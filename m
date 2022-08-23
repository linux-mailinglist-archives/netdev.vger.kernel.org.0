Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC73659EF0F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiHWW0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiHWWZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:25:51 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3E17D78C;
        Tue, 23 Aug 2022 15:25:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b5so14327742wrr.5;
        Tue, 23 Aug 2022 15:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=0KiyNC174zzIjrp1GQzwkUvnQfE9zdtStKGjmTOoAis=;
        b=ISOAaZjBLHcybcp4uPVGbXkobnssTpHtkw01HnsIkvCOXnpw0/0LwaIbeXccRKCQ0M
         JKTK29tVl3uxvOrLEEfvBYrHm+cjw8F1x0eBXsQjDQKqE5di3ZMDFVqaQ7i6oS3xeTOy
         McKs03C2T5MNpFnSZw7g/0fM4sFGLp8WtHnfMXFFK1hN7wABEa1w6M8g0mgCbDt7weSS
         41xaeJvRF1ZAyjpxLi0/3Qh88jiIgM64CTkN5KVXoLNt5qtZDStaC9hJrrsNLuGvrWzK
         akMDScEddIA2fx0iToXHjyt//hg4dUKZ1sF2TBFvOtWQB+zblWRHviWhK5d7jeKuIryJ
         7O3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=0KiyNC174zzIjrp1GQzwkUvnQfE9zdtStKGjmTOoAis=;
        b=tvIDlvs314LcGwFxy0ulf1rhFdyznY7USDQL1R1tbX8rxA9an4mED+nBaTrSPBtmaB
         fYxNB3FkEXylHYWRJHcArzz2xLInsxOv1cg92oBTGaVj3Y3rTnf4GEF7jCv++mMqkWZR
         1l62zP4cjQJRW4Awixv/1qI5SS1+xS1HWRnHa9AkekJkxF2t0tLpTJSDOdj9vI3Vvcy0
         BIzxsoNRjTXwvVDB9CXg6kUDy11vAXGJ9HgSCf7VoSs0464cy9cmdwGZLslaWJD/wiTL
         6wxCgEB6WbRp7OEJqMWrJf10pTtL+3Utwc5zM8ThiIb/pnWacIfj+XlfZ1HQtmci+eSI
         LqvQ==
X-Gm-Message-State: ACgBeo3BBBSDnOne+uUZuh6myhpOVIt/a8uwSSLKySq1C4+aerhxPTbU
        CqOjaV7DID9xYp+OAgfem48=
X-Google-Smtp-Source: AA6agR4y17yGEPfUjNos3CS9FizMNvtc29TAVoyBBkCY/cph1Sh1OwBFkf27OS+J6CbR5P851Ny8bw==
X-Received: by 2002:a5d:594a:0:b0:225:3606:da33 with SMTP id e10-20020a5d594a000000b002253606da33mr12411231wri.60.1661293545431;
        Tue, 23 Aug 2022 15:25:45 -0700 (PDT)
Received: from localhost.localdomain ([84.255.184.228])
        by smtp.gmail.com with ESMTPSA id g11-20020a05600c4ecb00b003a4c6e67f01sm26522607wmq.6.2022.08.23.15.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 15:25:44 -0700 (PDT)
From:   Mazin Al Haddad <mazinalhaddad05@gmail.com>
To:     pontus.fuchs@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, paskripkin@gmail.com,
        Mazin Al Haddad <mazinalhaddad05@gmail.com>,
        syzbot+1bc2c2afd44f820a669f@syzkaller.appspotmail.com
Subject: [PATCH] ar5523: check endpoints type and direction in probe()
Date:   Wed, 24 Aug 2022 01:24:38 +0300
Message-Id: <20220823222436.514204-1-mazinalhaddad05@gmail.com>
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
 drivers/net/wireless/ath/ar5523/ar5523.c | 31 ++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 6f937d2cc126..5451bf9ab9fb 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1581,8 +1581,39 @@ static int ar5523_probe(struct usb_interface *intf,
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
+	for (int i = 0; i < host->desc.bNumEndpoints; ++i) {
+		struct usb_endpoint_descriptor *ep = &host->endpoint[i].desc;
+		// Check for type of endpoint and direction.
+		switch (i) {
+		case 0:
+		case 1:
+			if ((ep->bEndpointAddress & USB_DIR_OUT) &&
+			    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			     == USB_ENDPOINT_XFER_BULK)){
+				dev_err(&dev->dev, "Wrong type of endpoints\n");
+				return -ENODEV;
+			}
+			break;
+		case 2:
+		case 3:
+			if ((ep->bEndpointAddress & USB_DIR_IN) &&
+			    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			     == USB_ENDPOINT_XFER_BULK)){
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

