Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED66017AB62
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgCEROD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbgCEROB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C51E21556;
        Thu,  5 Mar 2020 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428440;
        bh=umYb5DtZUCOPAN5Tj456WAHGwP23QQZy/ivEOWLpI+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XClqYgG8s856OBcyv8mP7sfBmTjCUnUleVxRKJv/frOsee30KkX2a19atOGLnUHi/
         GmKK77W8LlGK4b7nTQH0Ds7q24Pz9XPznYxnnGaGyqbNjT7vzPVhNIe47Ae6X5o0z9
         D/ISS5WTW0kyzW90/sxf8u8KOVmldV5P+1FcRI2I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 37/67] net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC pressure
Date:   Thu,  5 Mar 2020 12:12:38 -0500
Message-Id: <20200305171309.29118-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 770d9c67974c4c71af4beb786dc43162ad2a15ba ]

Failures caused by GFP_ATOMIC memory pressure have been observed, and
due to the missing error handling, results in kernel crash such as

[1876998.350133] kernel BUG at mm/slub.c:3952!
[1876998.350141] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[1876998.350147] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.3.0-scnxt #1
[1876998.350150] Hardware name: N/A N/A/COMe-bIP2, BIOS CCR2R920 03/01/2017
[1876998.350160] RIP: 0010:kfree+0x1ca/0x220
[1876998.350164] Code: 85 db 74 49 48 8b 95 68 01 00 00 48 31 c2 48 89 10 e9 d7 fe ff ff 49 8b 04 24 a9 00 00 01 00 75 0b 49 8b 44 24 08 a8 01 75 02 <0f> 0b 49 8b 04 24 31 f6 a9 00 00 01 00 74 06 41 0f b6 74 24
 5b
[1876998.350172] RSP: 0018:ffffc900000f0df0 EFLAGS: 00010246
[1876998.350177] RAX: ffffea00027f0708 RBX: ffff888008d78000 RCX: 0000000000391372
[1876998.350181] RDX: 0000000000000000 RSI: ffffe8ffffd01400 RDI: ffff888008d78000
[1876998.350185] RBP: ffff8881185a5d00 R08: ffffc90000087dd8 R09: 000000000000280a
[1876998.350189] R10: 0000000000000002 R11: 0000000000000000 R12: ffffea0000235e00
[1876998.350193] R13: ffff8881185438a0 R14: 0000000000000000 R15: ffff888118543870
[1876998.350198] FS:  0000000000000000(0000) GS:ffff88811f300000(0000) knlGS:0000000000000000
[1876998.350203] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
s#1 Part1
[1876998.350206] CR2: 00007f8dac7b09f0 CR3: 000000011e20a006 CR4: 00000000001606e0
[1876998.350210] Call Trace:
[1876998.350215]  <IRQ>
[1876998.350224]  ? __netif_receive_skb_core+0x70a/0x920
[1876998.350229]  kfree_skb+0x32/0xb0
[1876998.350234]  __netif_receive_skb_core+0x70a/0x920
[1876998.350240]  __netif_receive_skb_one_core+0x36/0x80
[1876998.350245]  process_backlog+0x8b/0x150
[1876998.350250]  net_rx_action+0xf7/0x340
[1876998.350255]  __do_softirq+0x10f/0x353
[1876998.350262]  irq_exit+0xb2/0xc0
[1876998.350265]  do_IRQ+0x77/0xd0
[1876998.350271]  common_interrupt+0xf/0xf
[1876998.350274]  </IRQ>

In order to handle such failures more graceful, this change splits the
receive loop into one for consuming the received buffers, and one for
allocating new buffers.

When GFP_ATOMIC allocations fail, the receive will continue with the
buffers that is still there, and with the expectation that the allocations
will succeed in a later call to receive.

Fixes: 92744989533c ("net: add Xilinx ll_temac device driver")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac.h      |   1 +
 drivers/net/ethernet/xilinx/ll_temac_main.c | 112 ++++++++++++++------
 2 files changed, 82 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 276292bca334d..99fe059e5c7f3 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -375,6 +375,7 @@ struct temac_local {
 	int tx_bd_next;
 	int tx_bd_tail;
 	int rx_bd_ci;
+	int rx_bd_tail;
 
 	/* DMA channel control setup */
 	u32 tx_chnl_ctrl;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index fd4231493449b..2e3f59dae586e 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -389,12 +389,13 @@ static int temac_dma_bd_init(struct net_device *ndev)
 	lp->tx_bd_next = 0;
 	lp->tx_bd_tail = 0;
 	lp->rx_bd_ci = 0;
+	lp->rx_bd_tail = RX_BD_NUM - 1;
 
 	/* Enable RX DMA transfers */
 	wmb();
 	lp->dma_out(lp, RX_CURDESC_PTR,  lp->rx_bd_p);
 	lp->dma_out(lp, RX_TAILDESC_PTR,
-		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
+		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * lp->rx_bd_tail));
 
 	/* Prepare for TX DMA transfer */
 	lp->dma_out(lp, TX_CURDESC_PTR, lp->tx_bd_p);
@@ -923,27 +924,41 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 static void ll_temac_recv(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
-	struct sk_buff *skb, *new_skb;
-	unsigned int bdstat;
-	struct cdmac_bd *cur_p;
-	dma_addr_t tail_p, skb_dma_addr;
-	int length;
 	unsigned long flags;
+	int rx_bd;
+	bool update_tail = false;
 
 	spin_lock_irqsave(&lp->rx_lock, flags);
 
-	tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
-	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-
-	bdstat = be32_to_cpu(cur_p->app0);
-	while ((bdstat & STS_CTRL_APP0_CMPLT)) {
+	/* Process all received buffers, passing them on network
+	 * stack.  After this, the buffer descriptors will be in an
+	 * un-allocated stage, where no skb is allocated for it, and
+	 * they are therefore not available for TEMAC/DMA.
+	 */
+	do {
+		struct cdmac_bd *bd = &lp->rx_bd_v[lp->rx_bd_ci];
+		struct sk_buff *skb = lp->rx_skb[lp->rx_bd_ci];
+		unsigned int bdstat = be32_to_cpu(bd->app0);
+		int length;
+
+		/* While this should not normally happen, we can end
+		 * here when GFP_ATOMIC allocations fail, and we
+		 * therefore have un-allocated buffers.
+		 */
+		if (!skb)
+			break;
 
-		skb = lp->rx_skb[lp->rx_bd_ci];
-		length = be32_to_cpu(cur_p->app4) & 0x3FFF;
+		/* Loop over all completed buffer descriptors */
+		if (!(bdstat & STS_CTRL_APP0_CMPLT))
+			break;
 
-		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
+		dma_unmap_single(ndev->dev.parent, be32_to_cpu(bd->phys),
 				 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
+		/* The buffer is not valid for DMA anymore */
+		bd->phys = 0;
+		bd->len = 0;
 
+		length = be32_to_cpu(bd->app4) & 0x3FFF;
 		skb_put(skb, length);
 		skb->protocol = eth_type_trans(skb, ndev);
 		skb_checksum_none_assert(skb);
@@ -958,39 +973,74 @@ static void ll_temac_recv(struct net_device *ndev)
 			 * (back) for proper IP checksum byte order
 			 * (be16).
 			 */
-			skb->csum = htons(be32_to_cpu(cur_p->app3) & 0xFFFF);
+			skb->csum = htons(be32_to_cpu(bd->app3) & 0xFFFF);
 			skb->ip_summed = CHECKSUM_COMPLETE;
 		}
 
 		if (!skb_defer_rx_timestamp(skb))
 			netif_rx(skb);
+		/* The skb buffer is now owned by network stack above */
+		lp->rx_skb[lp->rx_bd_ci] = NULL;
 
 		ndev->stats.rx_packets++;
 		ndev->stats.rx_bytes += length;
 
-		new_skb = netdev_alloc_skb_ip_align(ndev,
-						XTE_MAX_JUMBO_FRAME_SIZE);
-		if (!new_skb) {
-			spin_unlock_irqrestore(&lp->rx_lock, flags);
-			return;
+		rx_bd = lp->rx_bd_ci;
+		if (++lp->rx_bd_ci >= RX_BD_NUM)
+			lp->rx_bd_ci = 0;
+	} while (rx_bd != lp->rx_bd_tail);
+
+	/* Allocate new buffers for those buffer descriptors that were
+	 * passed to network stack.  Note that GFP_ATOMIC allocations
+	 * can fail (e.g. when a larger burst of GFP_ATOMIC
+	 * allocations occurs), so while we try to allocate all
+	 * buffers in the same interrupt where they were processed, we
+	 * continue with what we could get in case of allocation
+	 * failure.  Allocation of remaining buffers will be retried
+	 * in following calls.
+	 */
+	while (1) {
+		struct sk_buff *skb;
+		struct cdmac_bd *bd;
+		dma_addr_t skb_dma_addr;
+
+		rx_bd = lp->rx_bd_tail + 1;
+		if (rx_bd >= RX_BD_NUM)
+			rx_bd = 0;
+		bd = &lp->rx_bd_v[rx_bd];
+
+		if (bd->phys)
+			break;	/* All skb's allocated */
+
+		skb = netdev_alloc_skb_ip_align(ndev, XTE_MAX_JUMBO_FRAME_SIZE);
+		if (!skb) {
+			dev_warn(&ndev->dev, "skb alloc failed\n");
+			break;
 		}
 
-		cur_p->app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
-		skb_dma_addr = dma_map_single(ndev->dev.parent, new_skb->data,
+		skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
 					      XTE_MAX_JUMBO_FRAME_SIZE,
 					      DMA_FROM_DEVICE);
-		cur_p->phys = cpu_to_be32(skb_dma_addr);
-		cur_p->len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
-		lp->rx_skb[lp->rx_bd_ci] = new_skb;
+		if (WARN_ON_ONCE(dma_mapping_error(ndev->dev.parent,
+						   skb_dma_addr))) {
+			dev_kfree_skb_any(skb);
+			break;
+		}
 
-		lp->rx_bd_ci++;
-		if (lp->rx_bd_ci >= RX_BD_NUM)
-			lp->rx_bd_ci = 0;
+		bd->phys = cpu_to_be32(skb_dma_addr);
+		bd->len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
+		bd->app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
+		lp->rx_skb[rx_bd] = skb;
+
+		lp->rx_bd_tail = rx_bd;
+		update_tail = true;
+	}
 
-		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-		bdstat = be32_to_cpu(cur_p->app0);
+	/* Move tail pointer when buffers have been allocated */
+	if (update_tail) {
+		lp->dma_out(lp, RX_TAILDESC_PTR,
+			lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_tail);
 	}
-	lp->dma_out(lp, RX_TAILDESC_PTR, tail_p);
 
 	spin_unlock_irqrestore(&lp->rx_lock, flags);
 }
-- 
2.20.1

