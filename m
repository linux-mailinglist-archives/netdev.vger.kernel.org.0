Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4319323C2D
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbfETPbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:31:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38417 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731262AbfETPbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:31:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id t5so12147902wmh.3;
        Mon, 20 May 2019 08:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=U14r5RuHwz6CW9kWdqe1Yxv8qr6791SEzbYW5ZFfNqk=;
        b=X42kXwwsyIepoPQ5+7f0C8mITSC9q9M4R3X6qzcOZJ+6VSrtBKWV3ZYEviRARRlQJ7
         UzHjPebLhixIVOSb6DT/Ks5hOQjyBSeqOnR/Pc0iiBtpLvXdIdODVy0/sp1pEe51rCOS
         WWHVhmU6BxArfJMfK1Fqh+5ntdjK84WS0UR++HrqeOd7SEBrkJqHt/uJEkd4eZNsXCPf
         3LrdntUh6Oh5JlGtwXGyhR/epNkW0eM7fnBi/IvEZogP8tsvVqoVjJRZzb/jdBBr5WLn
         glyCeIOZMlQUY7KZGZLi9Ce67PklCxkwKyJp37W5N1UEo/ZiLxqqA16zwla+l8dj3NfH
         UWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U14r5RuHwz6CW9kWdqe1Yxv8qr6791SEzbYW5ZFfNqk=;
        b=B0F1i/Mk4YyKX5j4CxOByeHD4dGEozyFE9C657Rc1Y74/jKOKro8ZO5wUaUJGPOEvg
         slrs0rxkY/8s5b0SP2L205Cx01faeIP+wgJ1zZupGIDXjQwnNtPzetXAGeN7f8ivTm2h
         +QPhjVmuzsnFIWlmdFGi/XshpUWY9BhavERX0vzQ8ulKDQxNRw3adMsZ9h/QLXLeu7z1
         rofQarvsRu71aZo/OYH1aHXBW8UcH45R9L0btGBjlMELrXQz4GPKE/K0M93Pnuz+hzZA
         MKGJ4YXgMKjBxXJPSfa/iOo74BhONlGDlSIFiD2e+KeLDbfRWa2bPBp0xML5VDgNQY4Q
         NFnQ==
X-Gm-Message-State: APjAAAXUdq0Sqt68kEm2eBGfIDAr5CncW1O+hsyU+gd6a2VnlBBD0ewE
        tv+VZK7Nt/8391Z3dM0G8hhyYI7A
X-Google-Smtp-Source: APXvYqzBLCxDCKBc93FboPBqTKnxofoRQHsgqJbVB8qp+LrOaxz2zsTmBoFWRhfw3rS0EiN1U5ZXVQ==
X-Received: by 2002:a1c:7511:: with SMTP id o17mr5112701wmc.39.1558366276038;
        Mon, 20 May 2019 08:31:16 -0700 (PDT)
Received: from ubuntu.faroeurope.com (mail.faroeurope.com. [213.61.174.138])
        by smtp.gmail.com with ESMTPSA id x1sm11666555wrp.35.2019.05.20.08.31.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 08:31:15 -0700 (PDT)
From:   Bernd Eckstein <3erndeckstein@gmail.com>
X-Google-Original-From: Bernd Eckstein <3ernd.Eckstein@gmail.com>
To:     davem@davemloft.net
Cc:     linux@roeck-us.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corsac@corsac.net, Oliver.Zweigle@faro.com,
        3ernd.Eckstein@gmail.com
Subject: [PATCH] usbnet: ipheth: fix racing condition
Date:   Mon, 20 May 2019 17:31:09 +0200
Message-Id: <1558366269-17787-1-git-send-email-3ernd.Eckstein@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a racing condition in ipheth.c that can lead to slow performance.

Bug: In ipheth_tx(), netif_wake_queue() may be called on the callback
ipheth_sndbulk_callback(), _before_ netif_stop_queue() is called.
When this happens, the queue is stopped longer than it needs to be,
thus reducing network performance.

Fix: Move netif_stop_queue() in front of usb_submit_urb(). Now the order
is always correct. In case, usb_submit_urb() fails, the queue is woken up
again as callback will not fire.

Testing: This racing condition is usually not noticeable, as it has to
occur very frequently to slowdown the network. The callback from the USB
is usually triggered slow enough, so the situation does not appear.
However, on a Ubuntu Linux on VMWare Workstation, running on Windows 10,
the we loose the race quite often and the following speedup can be noticed:

Without this patch: Download:  4.10 Mbit/s, Upload:  4.01 Mbit/s
With this patch:    Download: 36.23 Mbit/s, Upload: 17.61 Mbit/s

Signed-off-by: Oliver Zweigle <Oliver.Zweigle@faro.com>
Signed-off-by: Bernd Eckstein <3ernd.Eckstein@gmail.com>

---
 drivers/net/usb/ipheth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index c247aed..8c01fbf 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -383,17 +383,18 @@ static int ipheth_tx(struct sk_buff *skb, struct net_device *net)
 			  dev);
 	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
+	netif_stop_queue(net);
 	retval = usb_submit_urb(dev->tx_urb, GFP_ATOMIC);
 	if (retval) {
 		dev_err(&dev->intf->dev, "%s: usb_submit_urb: %d\n",
 			__func__, retval);
 		dev->net->stats.tx_errors++;
 		dev_kfree_skb_any(skb);
+		netif_wake_queue(net);
 	} else {
 		dev->net->stats.tx_packets++;
 		dev->net->stats.tx_bytes += skb->len;
 		dev_consume_skb_any(skb);
-		netif_stop_queue(net);
 	}
 
 	return NETDEV_TX_OK;
-- 
2.7.4

