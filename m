Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554282D496F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbgLISsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:48:51 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:48315 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733278AbgLISsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 13:48:51 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0B9IlnlW016513;
        Wed, 9 Dec 2020 19:47:49 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Willy Tarreau <w@1wt.eu>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Palmer <daniel@0x0f.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH] Revert "macb: support the two tx descriptors on at91rm9200"
Date:   Wed,  9 Dec 2020 19:47:40 +0100
Message-Id: <20201209184740.16473-1-w@1wt.eu>
X-Mailer: git-send-email 2.9.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0a4e9ce17ba77847e5a9f87eed3c0ba46e3f82eb.

The code was developed and tested on an MSC313E SoC, which seems to be
half-way between the AT91RM9200 and the AT91SAM9260 in that it supports
both the 2-descriptors mode and a Tx ring.

It turns out that after the code was merged I could notice that the
controller would sometimes lock up, and only when dealing with sustained
bidirectional transfers, in which case it would report a Tx overrun
condition right after having reported being ready, and will stop sending
even after the status is cleared (a down/up cycle fixes it though).

After adding lots of traces I couldn't spot a sequence pattern allowing
to predict that this situation would happen. The chip comes with no
documentation and other bits are often reported with no conclusive
pattern either.

It is possible that my change is wrong just like it is possible that
the controller on the chip is bogus or at least unpredictable based on
existing docs from other chips. I do not have an RM9200 at hand to test
at the moment and a few tests run on a more recent 9G20 indicate that
this code path cannot be used there to test the code on a 3rd platform.

Since the MSC313E works fine in the single-descriptor mode, and that
people using the old RM9200 very likely favor stability over performance,
better revert this patch until we can test it on the original platform
this part of the driver was written for. Note that the reverted patch
was actually tested on MSC313E.

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Daniel Palmer <daniel@0x0f.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/netdev/20201206092041.GA10646@1wt.eu/
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ethernet/cadence/macb.h      |  2 --
 drivers/net/ethernet/cadence/macb_main.c | 46 ++++++--------------------------
 2 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 85be045..9fbdf53 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1216,8 +1216,6 @@ struct macb {
 
 	/* AT91RM9200 transmit queue (1 on wire + 1 queued) */
 	struct macb_tx_skb	rm9200_txq[2];
-	unsigned int		rm9200_tx_tail;
-	unsigned int		rm9200_tx_len;
 	unsigned int		max_tx_length;
 
 	u64			ethtool_stats[GEM_STATS_LEN + QUEUE_STATS_LEN * MACB_MAX_QUEUES];
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 817c7b0..352ae7f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3936,7 +3936,6 @@ static int at91ether_start(struct macb *lp)
 			     MACB_BIT(ISR_TUND)	|
 			     MACB_BIT(ISR_RLE)	|
 			     MACB_BIT(TCOMP)	|
-			     MACB_BIT(RM9200_TBRE)	|
 			     MACB_BIT(ISR_ROVR)	|
 			     MACB_BIT(HRESP));
 
@@ -3953,7 +3952,6 @@ static void at91ether_stop(struct macb *lp)
 			     MACB_BIT(ISR_TUND)	|
 			     MACB_BIT(ISR_RLE)	|
 			     MACB_BIT(TCOMP)	|
-			     MACB_BIT(RM9200_TBRE)	|
 			     MACB_BIT(ISR_ROVR) |
 			     MACB_BIT(HRESP));
 
@@ -4023,10 +4021,11 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
 					struct net_device *dev)
 {
 	struct macb *lp = netdev_priv(dev);
-	unsigned long flags;
 
-	if (lp->rm9200_tx_len < 2) {
-		int desc = lp->rm9200_tx_tail;
+	if (macb_readl(lp, TSR) & MACB_BIT(RM9200_BNQ)) {
+		int desc = 0;
+
+		netif_stop_queue(dev);
 
 		/* Store packet information (to free when Tx completed) */
 		lp->rm9200_txq[desc].skb = skb;
@@ -4040,15 +4039,6 @@ static netdev_tx_t at91ether_start_xmit(struct sk_buff *skb,
 			return NETDEV_TX_OK;
 		}
 
-		spin_lock_irqsave(&lp->lock, flags);
-
-		lp->rm9200_tx_tail = (desc + 1) & 1;
-		lp->rm9200_tx_len++;
-		if (lp->rm9200_tx_len > 1)
-			netif_stop_queue(dev);
-
-		spin_unlock_irqrestore(&lp->lock, flags);
-
 		/* Set address of the data in the Transmit Address register */
 		macb_writel(lp, TAR, lp->rm9200_txq[desc].mapping);
 		/* Set length of the packet in the Transmit Control register */
@@ -4114,8 +4104,6 @@ static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
 	struct macb *lp = netdev_priv(dev);
 	u32 intstatus, ctl;
 	unsigned int desc;
-	unsigned int qlen;
-	u32 tsr;
 
 	/* MAC Interrupt Status register indicates what interrupts are pending.
 	 * It is automatically cleared once read.
@@ -4127,39 +4115,21 @@ static irqreturn_t at91ether_interrupt(int irq, void *dev_id)
 		at91ether_rx(dev);
 
 	/* Transmit complete */
-	if (intstatus & (MACB_BIT(TCOMP) | MACB_BIT(RM9200_TBRE))) {
+	if (intstatus & MACB_BIT(TCOMP)) {
 		/* The TCOM bit is set even if the transmission failed */
 		if (intstatus & (MACB_BIT(ISR_TUND) | MACB_BIT(ISR_RLE)))
 			dev->stats.tx_errors++;
 
-		spin_lock(&lp->lock);
-
-		tsr = macb_readl(lp, TSR);
-
-		/* we have three possibilities here:
-		 *   - all pending packets transmitted (TGO, implies BNQ)
-		 *   - only first packet transmitted (!TGO && BNQ)
-		 *   - two frames pending (!TGO && !BNQ)
-		 * Note that TGO ("transmit go") is called "IDLE" on RM9200.
-		 */
-		qlen = (tsr & MACB_BIT(TGO)) ? 0 :
-			(tsr & MACB_BIT(RM9200_BNQ)) ? 1 : 2;
-
-		while (lp->rm9200_tx_len > qlen) {
-			desc = (lp->rm9200_tx_tail - lp->rm9200_tx_len) & 1;
+		desc = 0;
+		if (lp->rm9200_txq[desc].skb) {
 			dev_consume_skb_irq(lp->rm9200_txq[desc].skb);
 			lp->rm9200_txq[desc].skb = NULL;
 			dma_unmap_single(&lp->pdev->dev, lp->rm9200_txq[desc].mapping,
 					 lp->rm9200_txq[desc].size, DMA_TO_DEVICE);
 			dev->stats.tx_packets++;
 			dev->stats.tx_bytes += lp->rm9200_txq[desc].size;
-			lp->rm9200_tx_len--;
 		}
-
-		if (lp->rm9200_tx_len < 2 && netif_queue_stopped(dev))
-			netif_wake_queue(dev);
-
-		spin_unlock(&lp->lock);
+		netif_wake_queue(dev);
 	}
 
 	/* Work-around for EMAC Errata section 41.3.1 */
-- 
2.9.0

