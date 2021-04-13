Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD79D35E7C6
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348353AbhDMUtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:49:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:41326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348286AbhDMUsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:48:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2C574B005;
        Tue, 13 Apr 2021 20:48:33 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: korina: Use DMA API
Date:   Tue, 13 Apr 2021 22:48:16 +0200
Message-Id: <20210413204818.23350-6-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210413204818.23350-1-tsbogend@alpha.franken.de>
References: <20210413204818.23350-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of messing with MIPS specific macros use DMA API for mapping
descriptors and skbs.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 143 ++++++++++++++++++++--------------
 1 file changed, 85 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 728c4baa3eee..0224cd179b03 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -109,6 +109,8 @@ struct korina_private {
 	struct dma_reg __iomem *tx_dma_regs;
 	struct dma_desc *td_ring; /* transmit descriptor ring */
 	struct dma_desc *rd_ring; /* receive descriptor ring  */
+	dma_addr_t td_dma;
+	dma_addr_t rd_dma;
 
 	struct sk_buff *tx_skb[KORINA_NUM_TDS];
 	struct sk_buff *rx_skb[KORINA_NUM_RDS];
@@ -137,10 +139,21 @@ struct korina_private {
 	struct mii_if_info mii_if;
 	struct work_struct restart_task;
 	struct net_device *dev;
+	struct device *dmadev;
 };
 
 extern unsigned int idt_cpu_freq;
 
+static dma_addr_t korina_tx_dma(struct korina_private *lp, int idx)
+{
+	return lp->td_dma + (idx * sizeof(struct dma_desc));
+}
+
+static dma_addr_t korina_rx_dma(struct korina_private *lp, int idx)
+{
+	return lp->rd_dma + (idx * sizeof(struct dma_desc));
+}
+
 static inline void korina_abort_dma(struct net_device *dev,
 					struct dma_reg *ch)
 {
@@ -179,10 +192,12 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 	u32 length;
 	u32 chain_prev, chain_next;
 	struct dma_desc *td;
+	int idx;
 
 	spin_lock_irqsave(&lp->lock, flags);
 
-	td = &lp->td_ring[lp->tx_chain_tail];
+	idx = lp->tx_chain_tail;
+	td = &lp->td_ring[idx];
 
 	/* stop queue when full, drop pkts if queue already full */
 	if (lp->tx_count >= (KORINA_NUM_TDS - 2)) {
@@ -190,26 +205,23 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 		if (lp->tx_count == (KORINA_NUM_TDS - 2))
 			netif_stop_queue(dev);
-		else {
-			dev->stats.tx_dropped++;
-			dev_kfree_skb_any(skb);
-			spin_unlock_irqrestore(&lp->lock, flags);
-
-			return NETDEV_TX_OK;
-		}
+		else
+			goto drop_packet;
 	}
 
 	lp->tx_count++;
 
-	lp->tx_skb[lp->tx_chain_tail] = skb;
+	lp->tx_skb[idx] = skb;
 
 	length = skb->len;
-	dma_cache_wback((u32)skb->data, skb->len);
 
 	/* Setup the transmit descriptor. */
-	td->ca = CPHYSADDR(skb->data);
-	chain_prev = (lp->tx_chain_tail - 1) & KORINA_TDS_MASK;
-	chain_next = (lp->tx_chain_tail + 1) & KORINA_TDS_MASK;
+	td->ca = dma_map_single(lp->dmadev, skb->data, length, DMA_TO_DEVICE);
+	if (dma_mapping_error(lp->dmadev, td->ca))
+		goto drop_packet;
+
+	chain_prev = (idx - 1) & KORINA_TDS_MASK;
+	chain_next = (idx + 1) & KORINA_TDS_MASK;
 
 	if (readl(&(lp->tx_dma_regs->dmandptr)) == 0) {
 		if (lp->tx_chain_status == desc_empty) {
@@ -219,8 +231,8 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 			/* Move tail */
 			lp->tx_chain_tail = chain_next;
 			/* Write to NDPTR */
-			writel(CPHYSADDR(&lp->td_ring[lp->tx_chain_head]),
-					&lp->tx_dma_regs->dmandptr);
+			writel(korina_tx_dma(lp, lp->tx_chain_head),
+			       &lp->tx_dma_regs->dmandptr);
 			/* Move head to tail */
 			lp->tx_chain_head = lp->tx_chain_tail;
 		} else {
@@ -231,12 +243,12 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 			lp->td_ring[chain_prev].control &=
 					~DMA_DESC_COF;
 			/* Link to prev */
-			lp->td_ring[chain_prev].link =  CPHYSADDR(td);
+			lp->td_ring[chain_prev].link = korina_tx_dma(lp, idx);
 			/* Move tail */
 			lp->tx_chain_tail = chain_next;
 			/* Write to NDPTR */
-			writel(CPHYSADDR(&lp->td_ring[lp->tx_chain_head]),
-					&(lp->tx_dma_regs->dmandptr));
+			writel(korina_tx_dma(lp, lp->tx_chain_head),
+			       &lp->tx_dma_regs->dmandptr);
 			/* Move head to tail */
 			lp->tx_chain_head = lp->tx_chain_tail;
 			lp->tx_chain_status = desc_empty;
@@ -255,7 +267,7 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 					DMA_DESC_COF | DMA_DESC_IOF;
 			lp->td_ring[chain_prev].control &=
 					~DMA_DESC_COF;
-			lp->td_ring[chain_prev].link =  CPHYSADDR(td);
+			lp->td_ring[chain_prev].link = korina_tx_dma(lp, idx);
 			lp->tx_chain_tail = chain_next;
 		}
 	}
@@ -263,6 +275,13 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 	netif_trans_update(dev);
 	spin_unlock_irqrestore(&lp->lock, flags);
 
+	return NETDEV_TX_OK;
+
+drop_packet:
+	dev->stats.tx_dropped++;
+	dev_kfree_skb_any(skb);
+	spin_unlock_irqrestore(&lp->lock, flags);
+
 	return NETDEV_TX_OK;
 }
 
@@ -345,8 +364,8 @@ static int korina_rx(struct net_device *dev, int limit)
 	struct korina_private *lp = netdev_priv(dev);
 	struct dma_desc *rd = &lp->rd_ring[lp->rx_next_done];
 	struct sk_buff *skb, *skb_new;
-	u8 *pkt_buf;
 	u32 devcs, pkt_len, dmas;
+	dma_addr_t ca;
 	int count;
 
 	for (count = 0; count < limit; count++) {
@@ -358,6 +377,8 @@ static int korina_rx(struct net_device *dev, int limit)
 		if ((KORINA_RBSIZE - (u32)DMA_COUNT(rd->control)) == 0)
 			break;
 
+		ca = rd->ca;
+
 		/* check that this is a whole packet
 		 * WARNING: DMA_FD bit incorrectly set
 		 * in Rc32434 (errata ref #077) */
@@ -382,20 +403,21 @@ static int korina_rx(struct net_device *dev, int limit)
 			goto next;
 		}
 
-		pkt_len = RCVPKT_LENGTH(devcs);
-
-		/* must be the (first and) last
-		 * descriptor then */
-		pkt_buf = (u8 *)lp->rx_skb[lp->rx_next_done]->data;
-
-		/* invalidate the cache */
-		dma_cache_inv((unsigned long)pkt_buf, pkt_len - 4);
-
 		/* Malloc up new buffer. */
 		skb_new = netdev_alloc_skb_ip_align(dev, KORINA_RBSIZE);
-
 		if (!skb_new)
 			break;
+
+		ca = dma_map_single(lp->dmadev, skb_new->data, KORINA_RBSIZE,
+				    DMA_FROM_DEVICE);
+		if (dma_mapping_error(lp->dmadev, ca)) {
+			dev_kfree_skb_any(skb_new);
+			break;
+		}
+
+		pkt_len = RCVPKT_LENGTH(devcs);
+		dma_unmap_single(lp->dmadev, rd->ca, pkt_len, DMA_FROM_DEVICE);
+
 		/* Do not count the CRC */
 		skb_put(skb, pkt_len - 4);
 		skb->protocol = eth_type_trans(skb, dev);
@@ -415,10 +437,7 @@ static int korina_rx(struct net_device *dev, int limit)
 		rd->devcs = 0;
 
 		/* Restore descriptor's curr_addr */
-		if (skb_new)
-			rd->ca = CPHYSADDR(skb_new->data);
-		else
-			rd->ca = CPHYSADDR(skb->data);
+		rd->ca = ca;
 
 		rd->control = DMA_COUNT(KORINA_RBSIZE) |
 			DMA_DESC_COD | DMA_DESC_IOD;
@@ -439,9 +458,8 @@ static int korina_rx(struct net_device *dev, int limit)
 
 		lp->dma_halt_cnt++;
 		rd->devcs = 0;
-		skb = lp->rx_skb[lp->rx_next_done];
-		rd->ca = CPHYSADDR(skb->data);
-		writel(CPHYSADDR(rd), &lp->rx_dma_regs->dmandptr);
+		writel(korina_rx_dma(lp, rd - lp->rd_ring),
+		       &lp->rx_dma_regs->dmandptr);
 	}
 
 	return count;
@@ -564,6 +582,9 @@ static void korina_tx(struct net_device *dev)
 
 		/* We must always free the original skb */
 		if (lp->tx_skb[lp->tx_next_done]) {
+			dma_unmap_single(lp->dmadev, td->ca,
+					 lp->tx_skb[lp->tx_next_done]->len,
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(lp->tx_skb[lp->tx_next_done]);
 			lp->tx_skb[lp->tx_next_done] = NULL;
 		}
@@ -610,8 +631,8 @@ korina_tx_dma_interrupt(int irq, void *dev_id)
 
 		if (lp->tx_chain_status == desc_filled &&
 			(readl(&(lp->tx_dma_regs->dmandptr)) == 0)) {
-			writel(CPHYSADDR(&lp->td_ring[lp->tx_chain_head]),
-				&(lp->tx_dma_regs->dmandptr));
+			writel(korina_tx_dma(lp, lp->tx_chain_head),
+			       &lp->tx_dma_regs->dmandptr);
 			lp->tx_chain_status = desc_empty;
 			lp->tx_chain_head = lp->tx_chain_tail;
 			netif_trans_update(dev);
@@ -753,13 +774,17 @@ static int korina_alloc_ring(struct net_device *dev)
 		lp->rd_ring[i].control = DMA_DESC_IOD |
 				DMA_COUNT(KORINA_RBSIZE);
 		lp->rd_ring[i].devcs = 0;
-		lp->rd_ring[i].ca = CPHYSADDR(skb->data);
-		lp->rd_ring[i].link = CPHYSADDR(&lp->rd_ring[i+1]);
+		lp->rd_ring[i].ca = dma_map_single(lp->dmadev, skb->data,
+						   KORINA_RBSIZE,
+						   DMA_FROM_DEVICE);
+		if (dma_mapping_error(lp->dmadev, lp->rd_ring[i].ca))
+			return -ENOMEM;
+		lp->rd_ring[i].link = korina_rx_dma(lp, i + 1);
 	}
 
 	/* loop back receive descriptors, so the last
 	 * descriptor points to the first one */
-	lp->rd_ring[i - 1].link = CPHYSADDR(&lp->rd_ring[0]);
+	lp->rd_ring[i - 1].link = lp->rd_dma;
 	lp->rd_ring[i - 1].control |= DMA_DESC_COD;
 
 	lp->rx_next_done  = 0;
@@ -777,16 +802,22 @@ static void korina_free_ring(struct net_device *dev)
 
 	for (i = 0; i < KORINA_NUM_RDS; i++) {
 		lp->rd_ring[i].control = 0;
-		if (lp->rx_skb[i])
+		if (lp->rx_skb[i]) {
+			dma_unmap_single(lp->dmadev, lp->rd_ring[i].ca,
+					 KORINA_RBSIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb_any(lp->rx_skb[i]);
-		lp->rx_skb[i] = NULL;
+			lp->rx_skb[i] = NULL;
+		}
 	}
 
 	for (i = 0; i < KORINA_NUM_TDS; i++) {
 		lp->td_ring[i].control = 0;
-		if (lp->tx_skb[i])
+		if (lp->tx_skb[i]) {
+			dma_unmap_single(lp->dmadev, lp->td_ring[i].ca,
+					 lp->tx_skb[i]->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(lp->tx_skb[i]);
-		lp->tx_skb[i] = NULL;
+			lp->tx_skb[i] = NULL;
+		}
 	}
 }
 
@@ -819,7 +850,7 @@ static int korina_init(struct net_device *dev)
 	writel(0, &lp->rx_dma_regs->dmas);
 	/* Start Rx DMA */
 	writel(0, &lp->rx_dma_regs->dmandptr);
-	writel(CPHYSADDR(&lp->rd_ring[0]), &lp->rx_dma_regs->dmadptr);
+	writel(korina_rx_dma(lp, 0), &lp->rx_dma_regs->dmadptr);
 
 	writel(readl(&lp->tx_dma_regs->dmasm) &
 			~(DMA_STAT_FINI | DMA_STAT_ERR),
@@ -1054,21 +1085,21 @@ static int korina_probe(struct platform_device *pdev)
 	}
 	lp->tx_dma_regs = p;
 
-	lp->td_ring = kmalloc(TD_RING_SIZE + RD_RING_SIZE, GFP_KERNEL);
+	lp->td_ring = dmam_alloc_coherent(&pdev->dev, TD_RING_SIZE,
+					  &lp->td_dma, GFP_KERNEL);
 	if (!lp->td_ring)
 		return -ENOMEM;
 
-	dma_cache_inv((unsigned long)(lp->td_ring),
-			TD_RING_SIZE + RD_RING_SIZE);
-
-	/* now convert TD_RING pointer to KSEG1 */
-	lp->td_ring = (struct dma_desc *)KSEG1ADDR(lp->td_ring);
-	lp->rd_ring = &lp->td_ring[KORINA_NUM_TDS];
+	lp->rd_ring = dmam_alloc_coherent(&pdev->dev, RD_RING_SIZE,
+					  &lp->rd_dma, GFP_KERNEL);
+	if (!lp->rd_ring)
+		return -ENOMEM;
 
 	spin_lock_init(&lp->lock);
 	/* just use the rx dma irq */
 	dev->irq = lp->rx_irq;
 	lp->dev = dev;
+	lp->dmadev = &pdev->dev;
 
 	dev->netdev_ops = &korina_netdev_ops;
 	dev->ethtool_ops = &netdev_ethtool_ops;
@@ -1086,7 +1117,6 @@ static int korina_probe(struct platform_device *pdev)
 	if (rc < 0) {
 		printk(KERN_ERR DRV_NAME
 			": cannot register net device: %d\n", rc);
-		kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 		return rc;
 	}
 	timer_setup(&lp->media_check_timer, korina_poll_media, 0);
@@ -1101,9 +1131,6 @@ static int korina_probe(struct platform_device *pdev)
 static int korina_remove(struct platform_device *pdev)
 {
 	struct korina_device *bif = platform_get_drvdata(pdev);
-	struct korina_private *lp = netdev_priv(bif->dev);
-
-	kfree((struct dma_desc *)KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
 
-- 
2.29.2

