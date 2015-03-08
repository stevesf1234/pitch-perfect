//
//  AudioPlayerViewController.swift
//  PitchPerfect
//
//  Created by Stephen Fong on 3/4/15.
//  Copyright (c) 2015 Stephen Fong. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var recievedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup path to audio playback file
        //println("recievedAudio.filePathUrl: \(recievedAudio.filePathUrl)")
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)

    }
    
    func playAudioAtRateOf(rate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0   // Start playback from the beginning
        audioPlayer.play()
    }
    
    
    @IBAction func stopPlayback(sender: UIButton) {
        audioPlayer.stop()
    }

    @IBAction func playAudioAtSlowSpeed(sender: UIButton) {
        println("playAudioAtSlowSpeed")
        playAudioAtRateOf(0.5)
    }
    
    @IBAction func playAudioAtFastSpeed(sender: UIButton) {
        println("playAudioAtFastSpeed")
        playAudioAtRateOf(2.0)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
}
