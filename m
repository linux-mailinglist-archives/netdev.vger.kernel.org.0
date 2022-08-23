Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AD659EF80
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiHWW6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiHWW6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:58:14 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7831176;
        Tue, 23 Aug 2022 15:58:12 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay12so7906705wmb.1;
        Tue, 23 Aug 2022 15:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=lk8/tj/nL+5/3atLQyJ228xPqcFNf3nUrZ03uJtpZEE=;
        b=pvfL7cJb4Q6aj5gWTQZr10k4cTHpOUxS7OR9MD9VoS52aLJQqXyhRq0jV08egaTM99
         +PZuXYnNSeIR+5K3C2HGqM0kq7LHIw+Bmdtna0MRXVK7AYCWQfuhPS4audm7Iuq6it+t
         zxDpN7LXKfs3pakXGXkNaf7nkqR2s9gEe1UCs9azV0aGGogLnmVRsknkLmP3C90Wiqod
         d8jmm9Qo1MIPLKZOwYA+BCnoxz6dM3fB+Vkgi7RPZrHrGPLzexH9gEYz8gDcOSBDz5Vc
         NQekFrrPeElUGnSETN4rTBDqiBV9Ca5A1nAh7wXsROpOmYDgoFI2tjnwb+qsY/5mJEM9
         gDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=lk8/tj/nL+5/3atLQyJ228xPqcFNf3nUrZ03uJtpZEE=;
        b=Bj8Q4W0SI1hBRnot+EUI5XlWa1COWrjhUFWIZpmGAsnCe6H2n7U3q6ND7iVVFq163u
         iQRvccUsFGeATGCrClUylJxBWqXRy/+gAlYxH5S3SZO52lIzlPHMHrEqT+FZK+tdLMoN
         st0/YLRCa5NnzstZ72/pdd89TUyjPR4yYpg+I8sej6d/TPmKHBqJ2M+mQwpfKWWyWCpt
         BSUC7Pf9i6OS1s30ARsF6VEbv4670vy6rwCFYN+JunssVKijbCtOPEOkN+maBAIMVD9t
         t5vo0aKXfdKV1bjvw+gUceSv2iaihqvjuedqJQ5UU50pJOVGWDCdkC9sQcGmxp5hW268
         vx2Q==
X-Gm-Message-State: ACgBeo0y4xBHYFkf8Zc5ZNq/S6EOtssZ5oC4eKmoYqLp4KfC6kA+MNKs
        CAROb00OsSlau6+w+fKWDfQ=
X-Google-Smtp-Source: AA6agR43PKc2OD8KiUkOBN1+RxOPi6GqXs/g9ouzuKC/13rWTetZzknP+V5rl+Lf0JXq4gPbsnRVWg==
X-Received: by 2002:a7b:cc90:0:b0:3a5:3899:7be1 with SMTP id p16-20020a7bcc90000000b003a538997be1mr3361217wma.19.1661295491434;
        Tue, 23 Aug 2022 15:58:11 -0700 (PDT)
Received: from localhost.localdomain ([84.255.184.228])
        by smtp.gmail.com with ESMTPSA id y6-20020a056000108600b002250c35826dsm15052123wrw.104.2022.08.23.15.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 15:58:10 -0700 (PDT)
From:   Mazin Al Haddad <mazinalhaddad05@gmail.com>
To:     pontus.fuchs@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, paskripkin@gmail.com,
        Mazin Al Haddad <mazinalhaddad05@gmail.com>,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Subject: [PATCH v2] ar5523: check endpoints type and direction in probe()
Date:   Wed, 24 Aug 2022 01:57:54 +0300
Message-Id: <20220823225754.519945-1-mazinalhaddad05@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes a bug reported by syzbot, where a warning occurs in usb_submit_urb()
due to the wrong endpoint type. There is no check for both the number
of endpoints and the type which causes an error as the code tries to
send a URB to the wrong endpoint.

Fix it by adding a check for the number of endpoints and the
direction/type of the endpoints. If the endpoints do not match the
expected configuration -ENODEV is returned.

Syzkaller report:

usb 1-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 1 PID: 71 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Modules linked in:
CPU: 1 PID: 71 Comm: kworker/1:2 Not tainted 5.19.0-rc7-syzkaller-00150-g32f02a211b0a #0
Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 ar5523_cmd+0x420/0x790 drivers/net/wireless/ath/ar5523/ar5523.c:275
 ar5523_cmd_read drivers/net/wireless/ath/ar5523/ar5523.c:302 [inline]
 ar5523_host_available drivers/net/wireless/ath/ar5523/ar5523.c:1376 [inline]
 ar5523_probe+0xc66/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:1655

Link: https://syzkaller.appspot.com/bug?extid=1bc2c2afd44f820a669f
Reported-and-tested-by: syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
---
v1->v2 changes:
	- Fix incorrect check in if statement within switch case (was missing
		a "!" operator).
	- Added comments explaining the code.

 drivers/net/wireless/ath/ar5523/ar5523.c | 33 ++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 6f937d2cc126..d7e86dc4c293 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1581,8 +1581,41 @@ static int ar5523_probe(struct usb_interface *intf,
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct ieee80211_hw *hw;
 	struct ar5523 *ar;
+	struct usb_host_interface *host = intf->cur_altsetting;
 	int error = -ENOMEM;
 
+	if (host->desc.bNumEndpoints != 4) {
+		dev_err(&dev->dev, "Wrong number of endpoints\n");
+		return -ENODEV;
+	}
+
+	// Check for type of endpoint and direction.
+	for (int i = 0; i < host->desc.bNumEndpoints; ++i) {
+		struct usb_endpoint_descriptor *ep = &host->endpoint[i].desc;
+
+		switch (i) {
+		case 0:
+		case 1:
+			// if endpoint direction and type does not match
+			if (!((ep->bEndpointAddress & USB_DIR_OUT) &&
+			      ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			      == USB_ENDPOINT_XFER_BULK))){
+				dev_err(&dev->dev, "Wrong type of endpoints\n");
+				return -ENODEV;
+			}
+			break;
+		case 2:
+		case 3:
+			if (!((ep->bEndpointAddress & USB_DIR_IN) &&
+			      ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			     == USB_ENDPOINT_XFER_BULK))){
+				dev_err(&dev->dev, "Wrong type of endpoints\n");
+				return -ENODEV;
+			}
+			break;
+		}
+	}
+
 	/*
 	 * Load firmware if the device requires it.  This will return
 	 * -ENXIO on success and we'll get called back afer the usb
-- 
2.37.2

