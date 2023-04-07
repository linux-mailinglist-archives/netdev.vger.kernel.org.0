Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A6E6DB5D5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjDGVkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjDGVko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:40:44 -0400
Received: from smtp1.lauterbach.com (smtp1.lauterbach.com [62.154.241.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E594D305
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:40:40 -0700 (PDT)
Received: (qmail 12002 invoked by uid 484); 7 Apr 2023 21:33:59 -0000
X-Qmail-Scanner-Diagnostics: from ingpc2.intern.lauterbach.com by smtp1.lauterbach.com (envelope-from <ingo.rohloff@lauterbach.com>, uid 484) with qmail-scanner-2.11 
 (mhr: 1.0. clamdscan: 0.99/21437. spamassassin: 3.4.0.  
 Clear:RC:1(10.2.10.44):. 
 Processed in 0.071181 secs); 07 Apr 2023 21:33:59 -0000
Received: from ingpc2.intern.lauterbach.com (Authenticated_SSL:irohloff@[10.2.10.44])
          (envelope-sender <ingo.rohloff@lauterbach.com>)
          by smtp1.lauterbach.com (qmail-ldap-1.03) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <robert.hancock@calian.com>; 7 Apr 2023 21:33:57 -0000
From:   Ingo Rohloff <ingo.rohloff@lauterbach.com>
To:     robert.hancock@calian.com
Cc:     Nicolas.Ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tomas.melin@vaisala.com, Ingo Rohloff <ingo.rohloff@lauterbach.com>
Subject: [PATCH 1/1] net: macb: A different way to restart a stuck TX descriptor ring.
Date:   Fri,  7 Apr 2023 23:33:49 +0200
Message-Id: <20230407213349.8013-2-ingo.rohloff@lauterbach.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
 <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements a different approach than Commit 4298388574dae6 ("net:
macb: restart tx after tx used bit read"):

When reaping TX descriptors in macb_tx_complete(), if there are still
active descriptors pending (queue is not empty) and the controller
additionally signals that it is not any longer working on the TX ring,
then something has to be wrong. Reasoning:
Each time a descriptor is added to the TX ring (via macb_start_xmit()) the
controller is triggered to start transmitting (via setting the TSTART
bit).
At this point in time, there are two cases:
1) The controller already has read an inactive descriptor
   (with a set TX_USED bit).
2) The controller has not yet read an inactive descriptor
   and is still actively transmitting.

In case 1) setting the TSTART bit, should restart transmission.
In case 2) the controller should continue transmitting and at some point
reach the freshly added descriptors and then process them too.

This patch checks in macb_tx_complete() if the TX queue is non-empty and
additionally if the controller indicates that it is not transmitting any
longer. If this condition is detected, the TSTART bit is set again to
restart transmission.

Signed-off-by: Ingo Rohloff <ingo.rohloff@lauterbach.com>
---
 drivers/net/ethernet/cadence/macb.h      |  1 -
 drivers/net/ethernet/cadence/macb_main.c | 66 +++++++++---------------
 2 files changed, 23 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 14dfec4db8f9..b749fa2c0342 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1205,7 +1205,6 @@ struct macb_queue {
 	struct macb_tx_skb	*tx_skb;
 	dma_addr_t		tx_ring_dma;
 	struct work_struct	tx_error_task;
-	bool			txubr_pending;
 	struct napi_struct	napi_tx;
 
 	dma_addr_t		rx_ring_dma;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 66e30561569e..077024ad9ecc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -70,8 +70,7 @@ struct sifive_fu540_macb_mgmt {
 #define MACB_TX_ERR_FLAGS	(MACB_BIT(ISR_TUND)			\
 					| MACB_BIT(ISR_RLE)		\
 					| MACB_BIT(TXERR))
-#define MACB_TX_INT_FLAGS	(MACB_TX_ERR_FLAGS | MACB_BIT(TCOMP)	\
-					| MACB_BIT(TXUBR))
+#define MACB_TX_INT_FLAGS	(MACB_TX_ERR_FLAGS | MACB_BIT(TCOMP))
 
 /* Max length of transmit frame must be a multiple of 8 bytes */
 #define MACB_TX_LEN_ALIGN	8
@@ -1272,6 +1271,26 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
 	}
 
 	queue->tx_tail = tail;
+
+	if (tail != head) {
+		unsigned long flags;
+		u32 status;
+
+		spin_lock_irqsave(&bp->lock, flags);
+		status = macb_readl(bp, TSR);
+		if (!(status & MACB_BIT(TGO))) {
+			/* We have frames to be transmitted pending,
+			 * but controller is not transmitting any more.
+			 * Restart transmit engine
+			 */
+			u32 ncr;
+
+			ncr = macb_readl(bp, NCR) | MACB_BIT(TSTART);
+			macb_writel(bp, NCR, ncr);
+		}
+		spin_unlock_irqrestore(&bp->lock, flags);
+	}
+
 	if (__netif_subqueue_stopped(bp->dev, queue_index) &&
 	    CIRC_CNT(queue->tx_head, queue->tx_tail,
 		     bp->tx_ring_size) <= MACB_TX_WAKEUP_THRESH(bp))
@@ -1688,31 +1707,6 @@ static int macb_rx_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void macb_tx_restart(struct macb_queue *queue)
-{
-	struct macb *bp = queue->bp;
-	unsigned int head_idx, tbqp;
-
-	spin_lock(&queue->tx_ptr_lock);
-
-	if (queue->tx_head == queue->tx_tail)
-		goto out_tx_ptr_unlock;
-
-	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
-	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
-	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, queue->tx_head));
-
-	if (tbqp == head_idx)
-		goto out_tx_ptr_unlock;
-
-	spin_lock_irq(&bp->lock);
-	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
-	spin_unlock_irq(&bp->lock);
-
-out_tx_ptr_unlock:
-	spin_unlock(&queue->tx_ptr_lock);
-}
-
 static bool macb_tx_complete_pending(struct macb_queue *queue)
 {
 	bool retval = false;
@@ -1737,13 +1731,6 @@ static int macb_tx_poll(struct napi_struct *napi, int budget)
 
 	work_done = macb_tx_complete(queue, budget);
 
-	rmb(); // ensure txubr_pending is up to date
-	if (queue->txubr_pending) {
-		queue->txubr_pending = false;
-		netdev_vdbg(bp->dev, "poll: tx restart\n");
-		macb_tx_restart(queue);
-	}
-
 	netdev_vdbg(bp->dev, "TX poll: queue = %u, work_done = %d, budget = %d\n",
 		    (unsigned int)(queue - bp->queues), work_done, budget);
 
@@ -1913,17 +1900,10 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
 			}
 		}
 
-		if (status & (MACB_BIT(TCOMP) |
-			      MACB_BIT(TXUBR))) {
+		if (status & MACB_BIT(TCOMP)) {
 			queue_writel(queue, IDR, MACB_BIT(TCOMP));
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-				queue_writel(queue, ISR, MACB_BIT(TCOMP) |
-							 MACB_BIT(TXUBR));
-
-			if (status & MACB_BIT(TXUBR)) {
-				queue->txubr_pending = true;
-				wmb(); // ensure softirq can see update
-			}
+				queue_writel(queue, ISR, MACB_BIT(TCOMP));
 
 			if (napi_schedule_prep(&queue->napi_tx)) {
 				netdev_vdbg(bp->dev, "scheduling TX softirq\n");
-- 
2.17.1

