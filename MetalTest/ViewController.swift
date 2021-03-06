//
//  ViewController.swift
//  MetalTest
//
//  Created by Chance_xmu on 2018/12/12.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit
import Metal
import MetalKit

class ViewController: UIViewController, HWDMP4PlayDelegate {

    var mp4View: UIView!
    var attachConfig: QGAdvancedGiftAttachmentsConfigModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgView = UIImageView.init(image: UIImage.init(named: "bg.PNG"))
        bgView.frame = view.bounds
        view.addSubview(bgView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMP4View))
        view.addGestureRecognizer(tapGesture)
        
        let configPath = Bundle.main.path(forResource: "data", ofType: "json")
        let attachConfigModel = QGAdvancedGiftAttachmentsConfigParser.parse(configPath)
        if let attachmentConfigModel = attachConfigModel {
            
            let extraInfo = [QGAGAttachmentVariable.AnchorName.rawValue : "我是主播",
                             QGAGAttachmentVariable.UserName.rawValue : "我是用户很长很长",
                             QGAGAttachmentVariable.AnchorAvatar.rawValue : "https://shp.qlogo.cn/pghead/PiajxSqBRaEIgqEVXKXHcrGsOpGYMlSichibxNemXbicavg/140",
                             QGAGAttachmentVariable.UserAvatar.rawValue : "https://shp.qlogo.cn/pghead/PiajxSqBRaELe05ZAy7Xa7bSPYf5rGfu3SWYKM2l1oY8/140"
                             ]
            
            QGAdvancedGiftAttachmentsConfigParser.requestSources(model:attachmentConfigModel, extraInfo:extraInfo) { (model, success) in
                //
                if success == true {
                    self.attachConfig = model
                }
                
            }
            
//            QGAdvancedGiftFramesEditor.mergeMaskInfo(config: attachmentConfigModel)
            
            for (index, frame) in attachmentConfigModel.frames {
                for attachment in frame.attachments {
                    
                    _ = attachment.maskModel.maskImageForFrame(index, directory: "./MetalTest/resource/752_1344")
                }
            }
        }
    
    }
    
    @objc func tapMP4View() {
        
        if mp4View != nil {
            mp4View.removeFromSuperview()
        }
        
        guard let attachment = attachConfig else { return }
        mp4View = UIView(frame: view.bounds)
        view.addSubview(mp4View)
        let resPath = Bundle.main.path(forResource: "cache", ofType: "mp4")
        mp4View.playHWDMP4(resPath!, fps: 0, blendMode: QGHWDTextureBlendMode(rawValue: 0)!, delegate: self, attachments: attachment)
//        mp4View.playHWDMP4(resPath!, fps: 0, blendMode: QGHWDTextureBlendMode(rawValue: 0)!, delegate: self)
    }
    
    func viewDidFinishPlayMP4(_ totalFrameCount: Int, view container: UIView!) {
        DispatchQueue.main.async {
            guard let mp4View = self.mp4View else {
                return ;
            }
            if mp4View == container {
                mp4View.removeFromSuperview()
                self.mp4View = nil
            }
        }
    }
    
    func viewDidPlayMP4(at frame: QGMP4AnimatedImageFrame!, view container: UIView!) {
        
    }
    
    func viewDidStopPlayMP4(_ lastFrameIndex: Int, view container: UIView!) {
        
    }
}

