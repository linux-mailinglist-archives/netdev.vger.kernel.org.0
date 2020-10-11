Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDF728A67F
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgJKJKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:10:19 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43197 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJKJKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 05:10:19 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09B99q96010653;
        Sun, 11 Oct 2020 11:09:52 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Daniel Palmer <daniel@0x0f.com>
Subject: [PATCH net-next 2/3] macb: prepare at91 to use a 2-frame TX queue
Date:   Sun, 11 Oct 2020 11:09:43 +0200
Message-Id: <20201011090944.10607-3-w@1wt.eu>
X-Mailer: git-send-email 2.9.0
In-Reply-To: <20201011090944.10607-1-w@1wt.eu>
References: <20201011090944.10607-1-w@1wt.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RM9200 supports one frame being sent while another one is waiting in
queue. This avoids the dead time that follows the emission of a frame
and which prevents one from reaching line speed.

Right now the driver supports only a single skb, so we'll first replace
the rm9200-specific skb info with an array of two macb_tx_skb (already
used by other drivers). This patch only moves the skb_length to
txq[0].size and skb_physaddr to skb[0].mapping but doesn't perform any
other change. It already uses [desc] in order to minimize future changes.

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ethernet/cadence/macb.h      |  6 ++---
 drivers/net/ethernet/cadence/macb_main.c | 28 ++++++++++++++----------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 49d347429de8..e87db95fb0f6 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1206,10 +1206,8 @@ struct macb {
 
 	phy_interface_t		phy_interface;
 
-	/* AT91RM9200 transmit */
-	struct sk_buff *skb;			/* holds skb until xmit interrupt completes */
-	dma_addr_t skb_physaddr;		/* phys addr from pci_map_single */
-	int skb_length;				/* saved skb length for pci_unmap_single */
+	/* AT91RM9200 transmit queue (1 on wire + 1 queued) */
+	struct macb_tx_skb	rm9200_txq[2];
 	unsigned int		max_tx_length;
 
 	u64			ethtool_stats[GEM_STATS_LEN + QUEUE_STATS_LEN * MACB_MAX_QUEUES];
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9179f7b0b900..ca6e5456906a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3996,14 +3996,16 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
 	struct macb *lp = netdev_priv(dev);
 
 	if (macb_readl(lp, TSR) & MACB_BIT(RM9200_BNQ)) {
+		int desc = 0;
+
 		netif_stop_queue(dev);
 
 		/* Store packet information (to free when Tx completed) */
-		lp->skb = skb;
-		lp->skb_length = skb->len;
-		lp->skb_physaddr = dma_map_single(&lp->pdev->dev, skb->data,
-						  skb->len, DMA_TO_DEVICE);
-		if (dma_mapping_error(&lp->pdev->dev, lp->skb_physaddr)) {
+		lp->rm9200_txq[desc].skb = skb;
+		lp->rm9200_txq[desc].size = skb->len;
+		lp->rm9200_txq[desc].mapping = dma_map_single(&lp->pdev->dev, skb->data,
+							      skb->len, DMA_TO_DEVICE);
+		if (dma_mapping_error(&lp->pdev->dev, lp->rm9200_txq[desc].mapping)) {
 			dev_kfree_skb_any(skb);
 			dev->stats.tx_dropped++;
 			netdev_err(dev, "%s: DMA mapping error\n", __func__);
@@ -4011,7 +4013,7 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
 		}
 
 		/* Set address of the data in the Transmit Address register */
-		macb_writel(lp, TAR, lp->skb_physaddr);
+		macb_writel(lp, TAR, lp->rm9200_txq[desc].mapping);
 		/* Set length of the packet in the Transmit Control register */
 		macb_writel(lp, TCR, skb->len);
 
@@ -4074,6 +4076,7 @@ static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
 	struct net_device *dev = dev_id;
 	struct macb *lp = netdev_priv(dev);
 	u32 intstatus, ctl;
+	unsigned int desc;
 
 	/* MAC Interrupt Status register indicates what interrupts are pending.
 	 * It is automatically cleared once read.
@@ -4090,13 +4093,14 @@ static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
 		if (intstatus & (MACB_BIT(ISR_TUND) | MACB_BIT(ISR_RLE)))
 			dev->stats.tx_errors++;
 
-		if (lp->skb) {
-			dev_consume_skb_irq(lp->skb);
-			lp->skb = NULL;
-			dma_unmap_single(&lp->pdev->dev, lp->skb_physaddr,
-					 lp->skb_length, DMA_TO_DEVICE);
+		desc = 0;
+		if (lp->rm9200_txq[desc].skb) {
+			dev_consume_skb_irq(lp->rm9200_txq[desc].skb);
+			lp->rm9200_txq[desc].skb = NULL;
+			dma_unmap_single(&lp->pdev->dev, lp->rm9200_txq[desc].mapping,
+					 lp->rm9200_txq[desc].size, DMA_TO_DEVICE);
 			dev->stats.tx_packets++;
-			dev->stats.tx_bytes += lp->skb_length;
+			dev->stats.tx_bytes += lp->rm9200_txq[desc].size;
 		}
 		netif_wake_queue(dev);
 	}
-- 
2.28.0

