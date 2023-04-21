Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541976EAB23
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbjDUNA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbjDUNA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:00:27 -0400
Received: from smtp1.lauterbach.com (smtp1.lauterbach.com [62.154.241.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A2B172D
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 06:00:25 -0700 (PDT)
Received: (qmail 5805 invoked by uid 484); 21 Apr 2023 13:00:24 -0000
X-Qmail-Scanner-Diagnostics: from ingpc2.intern.lauterbach.com by smtp1.lauterbach.com (envelope-from <ingo.rohloff@lauterbach.com>, uid 484) with qmail-scanner-2.11 
 (mhr: 1.0. clamdscan: 0.99/21437. spamassassin: 3.4.0.  
 Clear:RC:1(10.2.10.44):. 
 Processed in 0.156667 secs); 21 Apr 2023 13:00:24 -0000
Received: from ingpc2.intern.lauterbach.com (Authenticated_SSL:irohloff@[10.2.10.44])
          (envelope-sender <ingo.rohloff@lauterbach.com>)
          by smtp1.lauterbach.com (qmail-ldap-1.03) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <kuba@kernel.org>; 21 Apr 2023 13:00:22 -0000
From:   Ingo Rohloff <ingo.rohloff@lauterbach.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Lars-Peter Clausen <lars@metafoo.de>,
        robert.hancock@calian.com, Nicolas.Ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, tomas.melin@vaisala.com,
        Ingo Rohloff <ingo.rohloff@lauterbach.com>
Subject: [PATCH v2 1/1] net: macb: Avoid erroneously stopped TX ring.
Date:   Fri, 21 Apr 2023 15:00:35 +0200
Message-Id: <20230421130035.14346-2-ingo.rohloff@lauterbach.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230421130035.14346-1-ingo.rohloff@lauterbach.com>
References: <20230421130035.14346-1-ingo.rohloff@lauterbach.com>
In-Reply-To: <20230411190715.6eefb4fa@kernel.org>
References: <20230411190715.6eefb4fa@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SW puts a frame to be transmitted into the TX descriptor ring with
macb_start_xmit().
The last step of this operation is, that the SW clears the TX_USED bit
of the first descriptor it wrote.
The HW already reached and read this descriptor with a set TX_USED bit.
The SW sets the TSTART bit in the NCR register.
This is a race condition:
1) Either the HW already has processed the descriptor and has stopped the
   transmission, so the TGO bit in the TSR register is cleared.
2) The HW has read, but not yet processed the descriptor.
In case 2) the HW ignores the TSTART trigger and stops the
transmission a little bit later.

You now have got a TX descriptor in the TX ring which is ready (TX_USED
bit cleared), but the hardware does not process the fresh descriptor,
because it ignored the corresponding TSTART trigger.

This patch checks if the hardware is processing the same descriptor, where
the TX_USED bit was just cleared.
If this is the case this patch ensures that the TSTART trigger is repeated
if needed.

Signed-off-by: Ingo Rohloff <ingo.rohloff@lauterbach.com>
---
 drivers/net/ethernet/cadence/macb.h      |  1 -
 drivers/net/ethernet/cadence/macb_main.c | 94 +++++++++++++-----------
 2 files changed, 50 insertions(+), 45 deletions(-)

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
index e43d99ec50ba..0fc9a345c1f0 100644
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
@@ -1692,31 +1691,6 @@ static int macb_rx_poll(struct napi_struct *napi, int budget)
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
@@ -1741,13 +1715,6 @@ static int macb_tx_poll(struct napi_struct *napi, int budget)
 
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
 
@@ -1917,17 +1884,10 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
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
@@ -2288,14 +2248,54 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	return 0;
 }
 
+static void macb_fix_tstart_race(unsigned int tx_head,
+				 struct macb *bp, struct macb_queue *queue)
+{
+	u32 macb_tsr, macb_tbqp, macb_ncr;
+
+	/* Controller was (probably) active when we wrote TSTART.
+	 * This might be a race condition.
+	 * Ensure TSTART is not ignored.
+	 */
+	for (;;) {
+		macb_tbqp = queue_readl(queue, TBQP);
+		macb_tbqp = macb_tbqp - lower_32_bits(queue->tx_ring_dma);
+		macb_tbqp = macb_tbqp / macb_dma_desc_get_size(bp);
+		macb_tbqp = macb_tx_ring_wrap(bp, macb_tbqp);
+		if (tx_head != macb_tbqp) {
+			/* Controller is working on different descriptor.
+			 * There should be no problem.
+			 */
+			break;
+		}
+
+		/* Controller works on the descriptor we just wrote.
+		 * TSTART might not have worked. Check for TGO again.
+		 */
+		macb_tsr = macb_readl(bp, TSR);
+		if (!(macb_tsr & MACB_BIT(TGO))) {
+			/* Controller stopped... write TSTART again.
+			 */
+			macb_ncr = macb_readl(bp, NCR);
+			macb_ncr = macb_ncr | MACB_BIT(TSTART);
+			macb_writel(bp, NCR, macb_ncr);
+			break;
+		}
+		/* Controller might stop or process our descriptor.
+		 * Check again.
+		 */
+	}
+}
+
 static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	u16 queue_index = skb_get_queue_mapping(skb);
 	struct macb *bp = netdev_priv(dev);
 	struct macb_queue *queue = &bp->queues[queue_index];
-	unsigned int desc_cnt, nr_frags, frag_size, f;
+	unsigned int desc_cnt, nr_frags, frag_size, f, tx_head;
 	unsigned int hdrlen;
 	bool is_lso;
+	u32 macb_tsr;
 	netdev_tx_t ret = NETDEV_TX_OK;
 
 	if (macb_clear_csum(skb)) {
@@ -2367,6 +2367,9 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto unlock;
 	}
 
+	/* remember first descriptor we are going to modify */
+	tx_head = macb_tx_ring_wrap(bp, queue->tx_head);
+
 	/* Map socket buffer for DMA transfer */
 	if (!macb_tx_map(bp, queue, skb, hdrlen)) {
 		dev_kfree_skb_any(skb);
@@ -2378,7 +2381,10 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_tx_timestamp(skb);
 
 	spin_lock_irq(&bp->lock);
+	macb_tsr = macb_readl(bp, TSR);
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
+	if (macb_tsr & MACB_BIT(TGO))
+		macb_fix_tstart_race(tx_head, bp, queue);
 	spin_unlock_irq(&bp->lock);
 
 	if (CIRC_SPACE(queue->tx_head, queue->tx_tail, bp->tx_ring_size) < 1)
-- 
2.17.1

