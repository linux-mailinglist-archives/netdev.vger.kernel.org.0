Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA019E2B6
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 06:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDDETX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 00:19:23 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37229 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgDDETQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 00:19:16 -0400
Received: by mail-pj1-f67.google.com with SMTP id k3so3954235pjj.2;
        Fri, 03 Apr 2020 21:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NBIn0GFrxtO/4lI4+QkVpvttsLV5tnJTxG6y3LxiZMM=;
        b=luiJRooMUjQR/cMYrZzVPmNZHNDguDoXCLND5Sy3sKsUk55oz8ntkQRVJJ4cDFFpIg
         tP+CAKT1Gq34RP4xMlnhFcsDzL+6PK8tZ2I2msMHTkuAHAPXn7NGAgw22VVGd+k/yjS8
         heDF/cIrwUBvvrXac4Vx99NlCIpSVWd5XWSpSRKgGXICYZxDsB+eCr3sVp7GBfcG5bHR
         H6S82xDamqvqdSuSlplOQE/bH9gdo4RvTufJ+SDQuqw/0UJx+WTpD1gP6NpAQcfoFvWh
         zKi2ZIgfVeJDnPoIZCVWRq7NLvlZAn10Iid9NXfrzwScQddZsttkKfYZJtN/tuq53HwY
         90eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NBIn0GFrxtO/4lI4+QkVpvttsLV5tnJTxG6y3LxiZMM=;
        b=rJzHEQg0XLAxC6kU0+fs7LzXMSrm1gaCxJRt+tnMPtpIj1f/WiOimPQaK+c7rwCBeD
         mcerwg0heTaQNgVRv9gJgsjgRxSq0+mrPPKAakQuGaGN24BWlxgwKUDUfa1zPmb1TJLl
         Y3HxdZ0C+NcVHDE69iAxsJvCQtDgZC1d+C7cGgNh0PISzn75uvt/RSOaE1eWBpWSjpGc
         Tp7MTNENyH85QVlTxS7loS/e5KDb3TV5+HDA/j5r50AaxXrgXp3Am4j8JASVZ2qCyQ2Z
         N3fKjy8kmZ7JG1boXmLvwbsbVowGpE+hKgM8LBKllpGCmYFCTa0QHAGPg2FnPkd31oJb
         fc1Q==
X-Gm-Message-State: AGi0PuZ+ISv+uulCMy3Gk+ONr9mfn7nVakt5TK+0VUuceA0SaDCTC7z6
        PKa8+yv+t7r4fvYA5UcjASI=
X-Google-Smtp-Source: APiQypLEK3KUi7Hzkd4Wl1s+j5ijufu6l0qQ2nzxAi9MWxnceM+z0z1m76p7oH/5++eGm4ekV4dZbA==
X-Received: by 2002:a17:90a:d344:: with SMTP id i4mr14068135pjx.161.1585973955479;
        Fri, 03 Apr 2020 21:19:15 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id lj14sm6837259pjb.25.2020.04.03.21.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Apr 2020 21:19:15 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH 5/5] ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
Date:   Sat,  4 Apr 2020 12:18:38 +0800
Message-Id: <20200404041838.10426-6-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200404041838.10426-1-hqjagain@gmail.com>
References: <20200404041838.10426-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
usb_ifnum_to_if(urb->dev, 0)
But it isn't always true.

The case reported by syzbot:
https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
usb 2-1: new high-speed USB device number 2 using dummy_hcd
usb 2-1: config 1 has an invalid interface number: 2 but max is 0
usb 2-1: config 1 has no interface number 0
usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271, bcdDevice=
1.08
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
general protection fault, probably for non-canonical address
0xdffffc0000000015: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0

Call Trace
__usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
__do_softirq+0x21e/0x950 kernel/softirq.c:292
invoke_softirq kernel/softirq.c:373 [inline]
irq_exit+0x178/0x1a0 kernel/softirq.c:413
exiting_irq arch/x86/include/asm/apic.h:546 [inline]
smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829

Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 48 ++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/hif_usb.h |  5 +++
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 6049d3766c64..4ed21dad6a8e 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -643,9 +643,9 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
 {
-	struct sk_buff *skb = (struct sk_buff *) urb->context;
-	struct hif_device_usb *hif_dev =
-		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
+	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
+	struct sk_buff *skb = rx_buf->skb;
 	int ret;
 
 	if (!skb)
@@ -685,14 +685,15 @@ static void ath9k_hif_usb_rx_cb(struct urb *urb)
 	return;
 free:
 	kfree_skb(skb);
+	kfree(rx_buf);
 }
 
 static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 {
-	struct sk_buff *skb = (struct sk_buff *) urb->context;
+	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
+	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
+	struct sk_buff *skb = rx_buf->skb;
 	struct sk_buff *nskb;
-	struct hif_device_usb *hif_dev =
-		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
 	if (!skb)
@@ -750,6 +751,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	return;
 free:
 	kfree_skb(skb);
+	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -795,7 +797,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -832,8 +834,9 @@ static void ath9k_hif_usb_dealloc_rx_urbs(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct urb *urb = NULL;
+	struct rx_buf *rx_buf = NULL;
 	struct sk_buff *skb = NULL;
+	struct urb *urb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -841,6 +844,12 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 
 	for (i = 0; i < MAX_RX_URB_NUM; i++) {
 
+		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
+		if (!rx_buf) {
+			ret = -ENOMEM;
+			goto err_rxb;
+		}
+
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -855,11 +864,14 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 			goto err_skb;
 		}
 
+		rx_buf->hif_dev = hif_dev;
+		rx_buf->skb = skb;
+
 		usb_fill_bulk_urb(urb, hif_dev->udev,
 				  usb_rcvbulkpipe(hif_dev->udev,
 						  USB_WLAN_RX_PIPE),
 				  skb->data, MAX_RX_BUF_SIZE,
-				  ath9k_hif_usb_rx_cb, skb);
+				  ath9k_hif_usb_rx_cb, rx_buf);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->rx_submitted);
@@ -885,6 +897,8 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 err_skb:
 	usb_free_urb(urb);
 err_urb:
+	kfree(rx_buf);
+err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -896,14 +910,21 @@ static void ath9k_hif_usb_dealloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 {
-	struct urb *urb = NULL;
+	struct rx_buf *rx_buf = NULL;
 	struct sk_buff *skb = NULL;
+	struct urb *urb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->reg_in_submitted);
 
 	for (i = 0; i < MAX_REG_IN_URB_NUM; i++) {
 
+		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
+		if (!rx_buf) {
+			ret = -ENOMEM;
+			goto err_rxb;
+		}
+
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -918,11 +939,14 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 			goto err_skb;
 		}
 
+		rx_buf->hif_dev = hif_dev;
+		rx_buf->skb = skb;
+
 		usb_fill_int_urb(urb, hif_dev->udev,
 				  usb_rcvintpipe(hif_dev->udev,
 						  USB_REG_IN_PIPE),
 				  skb->data, MAX_REG_IN_BUF_SIZE,
-				  ath9k_hif_usb_reg_in_cb, skb, 1);
+				  ath9k_hif_usb_reg_in_cb, rx_buf, 1);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
@@ -948,6 +972,8 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 err_skb:
 	usb_free_urb(urb);
 err_urb:
+	kfree(rx_buf);
+err_rxb:
 	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index a94e7e1c86e9..5985aa15ca93 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -86,6 +86,11 @@ struct tx_buf {
 	struct list_head list;
 };
 
+struct rx_buf {
+	struct sk_buff *skb;
+	struct hif_device_usb *hif_dev;
+};
+
 #define HIF_USB_TX_STOP  BIT(0)
 #define HIF_USB_TX_FLUSH BIT(1)
 
-- 
2.17.1

