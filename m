Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA551F2825
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgFHXtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731822AbgFHXZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B2862072F;
        Mon,  8 Jun 2020 23:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658735;
        bh=OfQ5j3NwQXj6NcrzfBevCA/v1mtF+loVmNXqcPJ9cD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyY3zRVRsQuecpUCcJWeST1mdXtmEnGGwb6Oqox658rNMFs/zgIDeaeWl5A0ne1yg
         bBfeXnosmhNlEHm64AGng8a5B5xHoQ/EpyQe5KXtCeZdOWkrYO7W63wBtfcyy8DvQu
         69J0f4TdHByJgWjwg+vOSHLrTFqx0cnGLfluQzMs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiujun Huang <hqjagain@gmail.com>,
        syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 24/72] ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
Date:   Mon,  8 Jun 2020 19:24:12 -0400
Message-Id: <20200608232500.3369581-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

[ Upstream commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200404041838.10426-6-hqjagain@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 48 ++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/hif_usb.h |  5 +++
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 805d88ecc7ac..4e769cf07f59 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -641,9 +641,9 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
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
@@ -683,14 +683,15 @@ static void ath9k_hif_usb_rx_cb(struct urb *urb)
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
@@ -748,6 +749,7 @@ static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 	return;
 free:
 	kfree_skb(skb);
+	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -793,7 +795,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -830,8 +832,9 @@ static void ath9k_hif_usb_dealloc_rx_urbs(struct hif_device_usb *hif_dev)
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct urb *urb = NULL;
+	struct rx_buf *rx_buf = NULL;
 	struct sk_buff *skb = NULL;
+	struct urb *urb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -839,6 +842,12 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 
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
@@ -853,11 +862,14 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
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
@@ -883,6 +895,8 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 err_skb:
 	usb_free_urb(urb);
 err_urb:
+	kfree(rx_buf);
+err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -894,14 +908,21 @@ static void ath9k_hif_usb_dealloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 
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
@@ -916,11 +937,14 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
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
@@ -946,6 +970,8 @@ static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
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
2.25.1

