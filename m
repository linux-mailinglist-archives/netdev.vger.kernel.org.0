Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F384A28A680
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgJKJK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:10:27 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43202 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJKJK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 05:10:26 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09B99qWs010654;
        Sun, 11 Oct 2020 11:09:52 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Daniel Palmer <daniel@0x0f.com>
Subject: [PATCH net-next 3/3] macb: support the two tx descriptors on at91rm9200
Date:   Sun, 11 Oct 2020 11:09:44 +0200
Message-Id: <20201011090944.10607-4-w@1wt.eu>
X-Mailer: git-send-email 2.9.0
In-Reply-To: <20201011090944.10607-1-w@1wt.eu>
References: <20201011090944.10607-1-w@1wt.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The at91rm9200 variant used by a few chips including the MSC313 supports
two Tx descriptors (one frame being serialized and another one queued).
However the driver only implemented a single one, which adds a dead time
after each transfer to receive and process the interrupt and wake the
queue up, preventing from reaching line rate.

This patch implements a very basic 2-deep queue to address this limitation.
The tests run on a Breadbee board equipped with an MSC313E show that at
1 GHz, HTTP traffic on medium-sized objects (45kB) was limited to exactly
50 Mbps before this patch, and jumped to 76 Mbps with this patch. And tests
on a single TCP stream with an MTU of 576 jump from 10kpps to 15kpps. With
1500 byte packets it's now possible to reach line rate versus 75 Mbps
before.

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ethernet/cadence/macb.h      |  2 ++
 drivers/net/ethernet/cadence/macb_main.c | 46 +++++++++++++++++++-----
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index e87db95fb0f6..f8133003981f 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1208,6 +1208,8 @@ struct macb {
 
 	/* AT91RM9200 transmit queue (1 on wire + 1 queued) */
 	struct macb_tx_skb	rm9200_txq[2];
+	unsigned int		rm9200_tx_tail;
+	unsigned int		rm9200_tx_len;
 	unsigned int		max_tx_length;
 
 	u64			ethtool_stats[GEM_STATS_LEN + QUEUE_STATS_LEN * MACB_MAX_QUEUES];
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ca6e5456906a..6ff8e4b0b95d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3909,6 +3909,7 @@ static int at91ether_start(struct macb *lp)
 			     MACB_BIT(ISR_TUND)	|
 			     MACB_BIT(ISR_RLE)	|
 			     MACB_BIT(TCOMP)	|
+			     MACB_BIT(RM9200_TBRE)	|
 			     MACB_BIT(ISR_ROVR)	|
 			     MACB_BIT(HRESP));
 
@@ -3925,6 +3926,7 @@ static void at91ether_stop(struct macb *lp)
 			     MACB_BIT(ISR_TUND)	|
 			     MACB_BIT(ISR_RLE)	|
 			     MACB_BIT(TCOMP)	|
+			     MACB_BIT(RM9200_TBRE)	|
 			     MACB_BIT(ISR_ROVR) |
 			     MACB_BIT(HRESP));
 
@@ -3994,11 +3996,10 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
 					struct net_device *dev)
 {
 	struct macb *lp = netdev_priv(dev);
+	unsigned long flags;
 
-	if (macb_readl(lp, TSR) & MACB_BIT(RM9200_BNQ)) {
-		int desc = 0;
-
-		netif_stop_queue(dev);
+	if (lp->rm9200_tx_len < 2) {
+		int desc = lp->rm9200_tx_tail;
 
 		/* Store packet information (to free when Tx completed) */
 		lp->rm9200_txq[desc].skb = skb;
@@ -4012,6 +4013,15 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
 			return NETDEV_TX_OK;
 		}
 
+		spin_lock_irqsave(&lp->lock, flags);
+
+		lp->rm9200_tx_tail = (desc + 1) & 1;
+		lp->rm9200_tx_len++;
+		if (lp->rm9200_tx_len > 1)
+			netif_stop_queue(dev);
+
+		spin_unlock_irqrestore(&lp->lock, flags);
+
 		/* Set address of the data in the Transmit Address register */
 		macb_writel(lp, TAR, lp->rm9200_txq[desc].mapping);
 		/* Set length of the packet in the Transmit Control register */
@@ -4077,6 +4087,8 @@ static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
 	struct macb *lp = netdev_priv(dev);
 	u32 intstatus, ctl;
 	unsigned int desc;
+	unsigned int qlen;
+	u32 tsr;
 
 	/* MAC Interrupt Status register indicates what interrupts are pending.
 	 * It is automatically cleared once read.
@@ -4088,21 +4100,39 @@ static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
 		at91ether_rx(dev);
 
 	/* Transmit complete */
-	if (intstatus & MACB_BIT(TCOMP)) {
+	if (intstatus & (MACB_BIT(TCOMP) | MACB_BIT(RM9200_TBRE))) {
 		/* The TCOM bit is set even if the transmission failed */
 		if (intstatus & (MACB_BIT(ISR_TUND) | MACB_BIT(ISR_RLE)))
 			dev->stats.tx_errors++;
 
-		desc = 0;
-		if (lp->rm9200_txq[desc].skb) {
+		spin_lock(&lp->lock);
+
+		tsr = macb_readl(lp, TSR);
+
+		/* we have three possibilities here:
+		 *   - all pending packets transmitted (TGO, implies BNQ)
+		 *   - only first packet transmitted (!TGO && BNQ)
+		 *   - two frames pending (!TGO && !BNQ)
+		 * Note that TGO ("transmit go") is called "IDLE" on RM9200.
+		 */
+		qlen = (tsr & MACB_BIT(TGO)) ? 0 :
+			(tsr & MACB_BIT(RM9200_BNQ)) ? 1 : 2;
+
+		while (lp->rm9200_tx_len > qlen) {
+			desc = (lp->rm9200_tx_tail - lp->rm9200_tx_len) & 1;
 			dev_consume_skb_irq(lp->rm9200_txq[desc].skb);
 			lp->rm9200_txq[desc].skb = NULL;
 			dma_unmap_single(&lp->pdev->dev, lp->rm9200_txq[desc].mapping,
 					 lp->rm9200_txq[desc].size, DMA_TO_DEVICE);
 			dev->stats.tx_packets++;
 			dev->stats.tx_bytes += lp->rm9200_txq[desc].size;
+			lp->rm9200_tx_len--;
 		}
-		netif_wake_queue(dev);
+
+		if (lp->rm9200_tx_len < 2 && netif_queue_stopped(dev))
+			netif_wake_queue(dev);
+
+		spin_unlock(&lp->lock);
 	}
 
 	/* Work-around for EMAC Errata section 41.3.1 */
-- 
2.28.0

