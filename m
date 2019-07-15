Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A172C69611
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389722AbfGOPCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 11:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388625AbfGOOMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:12:10 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89204206B8;
        Mon, 15 Jul 2019 14:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199929;
        bh=WqzzBMGKghwAVECJuWSGyIXaKX8I3eWraW46TCjFWDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJea2uRYvzMK0czS0UTGI1JHv44G3JfB9xIHH/ochgQ8dOwQzMn8K6uWXjiZeHKtm
         1HzBRZP/ndCqd4d6W7FWpShXEIWCQXBt8PbUaRHRO0ll7tV1ZzJsWWU4Oht9Ol2xbg
         vxXUJd6XTl4fIsM+071F9PZdLcFxJ2LvI4ZBc8oQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 140/219] mt7601u: do not schedule rx_tasklet when the device has been disconnected
Date:   Mon, 15 Jul 2019 10:02:21 -0400
Message-Id: <20190715140341.6443-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 4079e8ccabc3b6d1b503f2376123cb515d14921f ]

Do not schedule rx_tasklet when the usb dongle is disconnected.
Moreover do not grub rx_lock in mt7601u_kill_rx since usb_poison_urb
can run concurrently with urb completion and we can unlink urbs from rx
ring in any order.
This patch fixes the common kernel warning reported when
the device is removed.

[   24.921354] usb 3-14: USB disconnect, device number 7
[   24.921593] ------------[ cut here ]------------
[   24.921594] RX urb mismatch
[   24.921675] WARNING: CPU: 4 PID: 163 at drivers/net/wireless/mediatek/mt7601u/dma.c:200 mt7601u_complete_rx+0xcb/0xd0 [mt7601u]
[   24.921769] CPU: 4 PID: 163 Comm: kworker/4:2 Tainted: G           OE     4.19.31-041931-generic #201903231635
[   24.921770] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z97 Extreme4, BIOS P1.30 05/23/2014
[   24.921782] Workqueue: usb_hub_wq hub_event
[   24.921797] RIP: 0010:mt7601u_complete_rx+0xcb/0xd0 [mt7601u]
[   24.921800] RSP: 0018:ffff9bd9cfd03d08 EFLAGS: 00010086
[   24.921802] RAX: 0000000000000000 RBX: ffff9bd9bf043540 RCX: 0000000000000006
[   24.921803] RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff9bd9cfd16420
[   24.921804] RBP: ffff9bd9cfd03d28 R08: 0000000000000002 R09: 00000000000003a8
[   24.921805] R10: 0000002f485fca34 R11: 0000000000000000 R12: ffff9bd9bf043c1c
[   24.921806] R13: ffff9bd9c62fa3c0 R14: 0000000000000082 R15: 0000000000000000
[   24.921807] FS:  0000000000000000(0000) GS:ffff9bd9cfd00000(0000) knlGS:0000000000000000
[   24.921808] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   24.921808] CR2: 00007fb2648b0000 CR3: 0000000142c0a004 CR4: 00000000001606e0
[   24.921809] Call Trace:
[   24.921812]  <IRQ>
[   24.921819]  __usb_hcd_giveback_urb+0x8b/0x140
[   24.921821]  usb_hcd_giveback_urb+0xca/0xe0
[   24.921828]  xhci_giveback_urb_in_irq.isra.42+0x82/0xf0
[   24.921834]  handle_cmd_completion+0xe02/0x10d0
[   24.921837]  xhci_irq+0x274/0x4a0
[   24.921838]  xhci_msi_irq+0x11/0x20
[   24.921851]  __handle_irq_event_percpu+0x44/0x190
[   24.921856]  handle_irq_event_percpu+0x32/0x80
[   24.921861]  handle_irq_event+0x3b/0x5a
[   24.921867]  handle_edge_irq+0x80/0x190
[   24.921874]  handle_irq+0x20/0x30
[   24.921889]  do_IRQ+0x4e/0xe0
[   24.921891]  common_interrupt+0xf/0xf
[   24.921892]  </IRQ>
[   24.921900] RIP: 0010:usb_hcd_flush_endpoint+0x78/0x180
[   24.921354] usb 3-14: USB disconnect, device number 7

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 33 +++++++++++----------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index f7edeffb2b19..134f8a5bb5d4 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -193,10 +193,23 @@ static void mt7601u_complete_rx(struct urb *urb)
 	struct mt7601u_rx_queue *q = &dev->rx_q;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->rx_lock, flags);
+	/* do no schedule rx tasklet if urb has been unlinked
+	 * or the device has been removed
+	 */
+	switch (urb->status) {
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+	case -ENOENT:
+		return;
+	default:
+		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
+				    urb->status);
+		/* fall through */
+	case 0:
+		break;
+	}
 
-	if (mt7601u_urb_has_error(urb))
-		dev_err(dev->dev, "Error: RX urb failed:%d\n", urb->status);
+	spin_lock_irqsave(&dev->rx_lock, flags);
 	if (WARN_ONCE(q->e[q->end].urb != urb, "RX urb mismatch"))
 		goto out;
 
@@ -363,19 +376,9 @@ int mt7601u_dma_enqueue_tx(struct mt7601u_dev *dev, struct sk_buff *skb,
 static void mt7601u_kill_rx(struct mt7601u_dev *dev)
 {
 	int i;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dev->rx_lock, flags);
-
-	for (i = 0; i < dev->rx_q.entries; i++) {
-		int next = dev->rx_q.end;
-
-		spin_unlock_irqrestore(&dev->rx_lock, flags);
-		usb_poison_urb(dev->rx_q.e[next].urb);
-		spin_lock_irqsave(&dev->rx_lock, flags);
-	}
-
-	spin_unlock_irqrestore(&dev->rx_lock, flags);
+	for (i = 0; i < dev->rx_q.entries; i++)
+		usb_poison_urb(dev->rx_q.e[i].urb);
 }
 
 static int mt7601u_submit_rx_buf(struct mt7601u_dev *dev,
-- 
2.20.1

