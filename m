Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3A4D06F9
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbiCGSy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244863AbiCGSy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:54:27 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902B36FA19;
        Mon,  7 Mar 2022 10:53:31 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u3so5366666ljd.0;
        Mon, 07 Mar 2022 10:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tG48zlfsIlWWdNAN2VROyEUyP9nwE+RyuWnK+Wi+nbE=;
        b=hSW9HPyRvQxcoxlM6Ti3yu+7lcVrC32NoquHW9HJano7RmoAh3txW5r8Fwrx9c4bh5
         vN82VNNNUsiCn/FMhn4Cas5VQ/wMHbkzyL+uPGM6xoknI6Urjj/qXDOSNQ08eEA+s8yP
         qI3HT5EqYpwM2ybKgn2ErYkeu+/5oAtf0z18ODuPya4NQR1LDpV7W7Hho069moOrw/m2
         R9DgGMFn1Uu5aPWWHNDBxY+sIqSf9Wi5yjqVX+Ylcpr5iVyT7ejP9HKGGDMOXRgOBBDA
         sQjCNkb2NfJBLbdbBprhLKJ67QRdZDzU8kbvyF1b4vqt2zq8yXmdYjz9q1i3t6Cn2BW0
         M61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tG48zlfsIlWWdNAN2VROyEUyP9nwE+RyuWnK+Wi+nbE=;
        b=s0cx8JeZ/HRHgcDDNC9Ff0BVPy65agAeyJQIDvPoJCPAQSsU7kOTAvDvYBpvFGvFIA
         HSiikbI3o5dYIJE+zzGOLwRY50oX7jAMtpIvHrPPJqtutfGGNC4Dj7p9qEcIfUkKEAud
         sSgoioYG/3J3jhaEMSBRGYMHJiZA5TCm1gWqKlBbvZp/plZFbhIo/lqqsPYy6vYBoKUw
         Cs5fsTcZJyOksjLCv5nhJ1wjf2LFdTFluWpPx6MEWITZ/9S4ik+dfGrv6yxuIRK4njiM
         DLiiAKgZmEtNMYphzngElt/+4pNvFZ/2yAcGRVSTdq9fCwtb2AP3UvKEH0crkGZ8/6UW
         mxqw==
X-Gm-Message-State: AOAM533Rt0nBeUGCZXGhBOUTkdNeYlEn2rto2hoQqm8TNscXc6Ux5xui
        noiFJBIcIMKi6J8wDO0LNuU=
X-Google-Smtp-Source: ABdhPJy7vgdlX6mMw01hF7mdZkBKOrFSYrPSdFFrKw04H+LG1RKRKNnP+OzMN3TnJHikOATsjltdww==
X-Received: by 2002:a2e:bc0c:0:b0:247:ee54:3a84 with SMTP id b12-20020a2ebc0c000000b00247ee543a84mr159091ljf.286.1646679209014;
        Mon, 07 Mar 2022 10:53:29 -0800 (PST)
Received: from localhost.localdomain ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id o11-20020ac2434b000000b004478421baaesm2517827lfl.6.2022.03.07.10.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 10:53:28 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, mailhol.vincent@wanadoo.fr
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Subject: [PATCH RFT] can: mcba_usb: properly check endpoint type
Date:   Mon,  7 Mar 2022 21:53:14 +0300
Message-Id: <20220307185314.11228-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported warning in usb_submit_urb() which is caused by wrong
endpoint type. We should check that in endpoint is actually present to
prevent this warning

Fail log:

usb 5-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 1 PID: 49 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Modules linked in:
CPU: 1 PID: 49 Comm: kworker/1:2 Not tainted 5.17.0-rc6-syzkaller-00184-g38f80f42147f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
...
Call Trace:
 <TASK>
 mcba_usb_start drivers/net/can/usb/mcba_usb.c:662 [inline]
 mcba_usb_probe+0x8a3/0xc50 drivers/net/can/usb/mcba_usb.c:858
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:517 [inline]

Reported-and-tested-by: syzbot+3bc1dce0cc0052d60fde@syzkaller.appspotmail.com
Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Meta comments:

I am not an usb expert, but looks like this driver uses one
endpoint for in and out transactions:

/* MCBA endpoint numbers */
#define MCBA_USB_EP_IN 1
#define MCBA_USB_EP_OUT 1

That's why check only for in endpoint is added

---
 drivers/net/can/usb/mcba_usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 77bddff86252..646aac1a8684 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -807,6 +807,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
 	struct mcba_priv *priv;
 	int err;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *in;
+
+	err = usb_find_common_endpoints(intf->cur_altsetting, &in, NULL, NULL, NULL);
+	if (err) {
+		dev_err(&intf->dev, "Can't find endpoints\n");
+		return -ENODEV;
+	}
 
 	netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
 	if (!netdev) {
-- 
2.35.1

