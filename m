Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA2A4257EA
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbhJGQ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbhJGQ1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:27:37 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B3BC061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 09:25:42 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso124020pgi.21
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 09:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t9BTZnuwugGBCsNM9hKVnh7lfB4qB5mKDLELhG9sTh0=;
        b=NXN3fj6RjpGO/lr+rTT720Z0R91fKqssGivN/EXv/8+4zm46kYmyv2uOnqeV6sroZa
         RPQs8eoZZupPXkC07giBC9K/5aqhhmk4uzd69UCX39I7gXzyAC1JLj2KOsxrPdOCYJRt
         CijZysJc7mFkgrCdbiPQsZdnQeAqBNZIK4OCr4n8L8EJbLoCafbOFHuMLTUnrfIBy6Sx
         A6WfIngOdocao1/LtATIfiX7uXootXDqEDL7iw8KaZGrXGw5eePoLbk17kp6yyoVVeQd
         PA+aOZEQSwAk0DircoA+2xkDqk5Cjuhzr5WppRwtjeDr43rfK3A4RYQSpyRuj80NvYGj
         5d5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t9BTZnuwugGBCsNM9hKVnh7lfB4qB5mKDLELhG9sTh0=;
        b=aj1REgxKu6qMuRiKXpDmyb2uQ7KvjQ3KZ3EZC7tczXSD71NHOholf+wtx2tj9Q5imN
         1x5rLkAFc/JgW/JZFCn0hsGcewgUUvADqVA1dmBE8laEAL2zutzRCf57HsNDipywwnoC
         usFyn3fHBLgBwz9IlRN/YZ6JulEqD03a+N42d1u/YPAxWxL6c9BE7ZlrDx8MvP9Ix7DY
         hYh3qErc4biS2pNnTzesIiXi5Qi1BvaLEDkZvSJBHFzsVNGcMCwyVkY7klX1uV5y6zno
         Ux797i3TBIcg6i8dbnnWbs3tDn/M4qIs08zRedpqro0hwXd84buoz2aVElcvPpzQHoKS
         rJwg==
X-Gm-Message-State: AOAM5300qkV8Y+Cf9KW63enzWP91Kv+MXr3TJ6mdNkX/nCL2kID6GOUp
        6pxtCaRTYmm2OW8u/22wAzUQe1awi+4++jk6dn7AWh8MOT6yN/TeF8PPG4tn0WM0QPeF22oHHUy
        CgXoSM2kk/pw9P2vOX+LebMM0lHW2JCEqgawp3npEriEQ2v6zr5JSRrCvOv7sXly0Gu8=
X-Google-Smtp-Source: ABdhPJwi1ewG3eAgjg5cnY9L3yqcf+nvtEyZ/6jR+ZZ6h2ut5VJVnyI3rYSvYLnbltFSUd32PJZOLVPPPy3RaA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:fe55:7411:11ac:c2a7])
 (user=jeroendb job=sendgmr) by 2002:a17:902:7613:b0:13d:b35f:b4d7 with SMTP
 id k19-20020a170902761300b0013db35fb4d7mr4824867pll.8.1633623942070; Thu, 07
 Oct 2021 09:25:42 -0700 (PDT)
Date:   Thu,  7 Oct 2021 09:25:30 -0700
In-Reply-To: <20211007162534.1502578-1-jeroendb@google.com>
Message-Id: <20211007162534.1502578-3-jeroendb@google.com>
Mime-Version: 1.0
References: <20211007162534.1502578-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net-next 3/7] gve: Do lazy cleanup in TX path
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Tao Liu <xliutaox@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Liu <xliutaox@google.com>

When TX queue is full, attemt to process enough TX completions
to avoid stalling the queue.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Tao Liu <xliutaox@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  9 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |  3 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  6 +-
 drivers/net/ethernet/google/gve/gve_tx.c      | 94 +++++++++++--------
 4 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 59c525800e5d..003b30b91c6d 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -341,8 +341,8 @@ struct gve_tx_ring {
 	union {
 		/* GQI fields */
 		struct {
-			/* NIC tail pointer */
-			__be32 last_nic_done;
+			/* Spinlock for when cleanup in progress */
+			spinlock_t clean_lock;
 		};
 
 		/* DQO fields. */
@@ -821,8 +821,9 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev);
 bool gve_tx_poll(struct gve_notify_block *block, int budget);
 int gve_tx_alloc_rings(struct gve_priv *priv);
 void gve_tx_free_rings_gqi(struct gve_priv *priv);
-__be32 gve_tx_load_event_counter(struct gve_priv *priv,
-				 struct gve_tx_ring *tx);
+u32 gve_tx_load_event_counter(struct gve_priv *priv,
+			      struct gve_tx_ring *tx);
+bool gve_tx_clean_pending(struct gve_priv *priv, struct gve_tx_ring *tx);
 /* rx handling */
 void gve_rx_write_doorbell(struct gve_priv *priv, struct gve_rx_ring *rx);
 int gve_rx_poll(struct gve_notify_block *block, int budget);
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 716e6240305d..618a3e1d858e 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -330,8 +330,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = tmp_tx_bytes;
 			data[i++] = tx->wake_queue;
 			data[i++] = tx->stop_queue;
-			data[i++] = be32_to_cpu(gve_tx_load_event_counter(priv,
-									  tx));
+			data[i++] = gve_tx_load_event_counter(priv, tx);
 			data[i++] = tx->dma_mapping_error;
 			/* stats from NIC */
 			if (skip_nic_stats) {
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 388262c61b8d..74e35a87ec38 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -201,13 +201,13 @@ static int gve_napi_poll(struct napi_struct *napi, int budget)
 		irq_doorbell = gve_irq_doorbell(priv, block);
 		iowrite32be(GVE_IRQ_ACK | GVE_IRQ_EVENT, irq_doorbell);
 
-		/* Double check we have no extra work.
-		 * Ensure unmask synchronizes with checking for work.
+		/* Ensure IRQ ACK is visible before we check pending work.
+		 * If queue had issued updates, it would be truly visible.
 		 */
 		mb();
 
 		if (block->tx)
-			reschedule |= gve_tx_poll(block, -1);
+			reschedule |= gve_tx_clean_pending(priv, block->tx);
 		if (block->rx)
 			reschedule |= gve_rx_work_pending(block->rx);
 
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 9922ce46a635..a9cb241fedf4 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -144,7 +144,7 @@ static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 
 	gve_tx_remove_from_block(priv, idx);
 	slots = tx->mask + 1;
-	gve_clean_tx_done(priv, tx, tx->req, false);
+	gve_clean_tx_done(priv, tx, priv->tx_desc_cnt, false);
 	netdev_tx_reset_queue(tx->netdev_txq);
 
 	dma_free_coherent(hdev, sizeof(*tx->q_resources),
@@ -176,6 +176,7 @@ static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
 
 	/* Make sure everything is zeroed to start */
 	memset(tx, 0, sizeof(*tx));
+	spin_lock_init(&tx->clean_lock);
 	tx->q_num = idx;
 
 	tx->mask = slots - 1;
@@ -328,10 +329,16 @@ static inline bool gve_can_tx(struct gve_tx_ring *tx, int bytes_required)
 	return (gve_tx_avail(tx) >= MAX_TX_DESC_NEEDED && can_alloc);
 }
 
+static_assert(NAPI_POLL_WEIGHT >= MAX_TX_DESC_NEEDED);
+
 /* Stops the queue if the skb cannot be transmitted. */
-static int gve_maybe_stop_tx(struct gve_tx_ring *tx, struct sk_buff *skb)
+static int gve_maybe_stop_tx(struct gve_priv *priv, struct gve_tx_ring *tx,
+			     struct sk_buff *skb)
 {
 	int bytes_required = 0;
+	u32 nic_done;
+	u32 to_do;
+	int ret;
 
 	if (!tx->raw_addressing)
 		bytes_required = gve_skb_fifo_bytes_required(tx, skb);
@@ -339,29 +346,28 @@ static int gve_maybe_stop_tx(struct gve_tx_ring *tx, struct sk_buff *skb)
 	if (likely(gve_can_tx(tx, bytes_required)))
 		return 0;
 
-	/* No space, so stop the queue */
-	tx->stop_queue++;
-	netif_tx_stop_queue(tx->netdev_txq);
-	smp_mb();	/* sync with restarting queue in gve_clean_tx_done() */
-
-	/* Now check for resources again, in case gve_clean_tx_done() freed
-	 * resources after we checked and we stopped the queue after
-	 * gve_clean_tx_done() checked.
-	 *
-	 * gve_maybe_stop_tx()			gve_clean_tx_done()
-	 *   nsegs/can_alloc test failed
-	 *					  gve_tx_free_fifo()
-	 *					  if (tx queue stopped)
-	 *					    netif_tx_queue_wake()
-	 *   netif_tx_stop_queue()
-	 *   Need to check again for space here!
-	 */
-	if (likely(!gve_can_tx(tx, bytes_required)))
-		return -EBUSY;
+	ret = -EBUSY;
+	spin_lock(&tx->clean_lock);
+	nic_done = gve_tx_load_event_counter(priv, tx);
+	to_do = nic_done - tx->done;
 
-	netif_tx_start_queue(tx->netdev_txq);
-	tx->wake_queue++;
-	return 0;
+	/* Only try to clean if there is hope for TX */
+	if (to_do + gve_tx_avail(tx) >= MAX_TX_DESC_NEEDED) {
+		if (to_do > 0) {
+			to_do = min_t(u32, to_do, NAPI_POLL_WEIGHT);
+			gve_clean_tx_done(priv, tx, to_do, false);
+		}
+		if (likely(gve_can_tx(tx, bytes_required)))
+			ret = 0;
+	}
+	if (ret) {
+		/* No space, so stop the queue */
+		tx->stop_queue++;
+		netif_tx_stop_queue(tx->netdev_txq);
+	}
+	spin_unlock(&tx->clean_lock);
+
+	return ret;
 }
 
 static void gve_tx_fill_pkt_desc(union gve_tx_desc *pkt_desc,
@@ -576,7 +582,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	WARN(skb_get_queue_mapping(skb) >= priv->tx_cfg.num_queues,
 	     "skb queue index out of range");
 	tx = &priv->tx[skb_get_queue_mapping(skb)];
-	if (unlikely(gve_maybe_stop_tx(tx, skb))) {
+	if (unlikely(gve_maybe_stop_tx(priv, tx, skb))) {
 		/* We need to ring the txq doorbell -- we have stopped the Tx
 		 * queue for want of resources, but prior calls to gve_tx()
 		 * may have added descriptors without ringing the doorbell.
@@ -672,19 +678,19 @@ static int gve_clean_tx_done(struct gve_priv *priv, struct gve_tx_ring *tx,
 	return pkts;
 }
 
-__be32 gve_tx_load_event_counter(struct gve_priv *priv,
-				 struct gve_tx_ring *tx)
+u32 gve_tx_load_event_counter(struct gve_priv *priv,
+			      struct gve_tx_ring *tx)
 {
-	u32 counter_index = be32_to_cpu((tx->q_resources->counter_index));
+	u32 counter_index = be32_to_cpu(tx->q_resources->counter_index);
+	__be32 counter = READ_ONCE(priv->counter_array[counter_index]);
 
-	return READ_ONCE(priv->counter_array[counter_index]);
+	return be32_to_cpu(counter);
 }
 
 bool gve_tx_poll(struct gve_notify_block *block, int budget)
 {
 	struct gve_priv *priv = block->priv;
 	struct gve_tx_ring *tx = block->tx;
-	bool repoll = false;
 	u32 nic_done;
 	u32 to_do;
 
@@ -692,17 +698,23 @@ bool gve_tx_poll(struct gve_notify_block *block, int budget)
 	if (budget == 0)
 		budget = INT_MAX;
 
+	/* In TX path, it may try to clean completed pkts in order to xmit,
+	 * to avoid cleaning conflict, use spin_lock(), it yields better
+	 * concurrency between xmit/clean than netif's lock.
+	 */
+	spin_lock(&tx->clean_lock);
 	/* Find out how much work there is to be done */
-	tx->last_nic_done = gve_tx_load_event_counter(priv, tx);
-	nic_done = be32_to_cpu(tx->last_nic_done);
-	if (budget > 0) {
-		/* Do as much work as we have that the budget will
-		 * allow
-		 */
-		to_do = min_t(u32, (nic_done - tx->done), budget);
-		gve_clean_tx_done(priv, tx, to_do, true);
-	}
+	nic_done = gve_tx_load_event_counter(priv, tx);
+	to_do = min_t(u32, (nic_done - tx->done), budget);
+	gve_clean_tx_done(priv, tx, to_do, true);
+	spin_unlock(&tx->clean_lock);
 	/* If we still have work we want to repoll */
-	repoll |= (nic_done != tx->done);
-	return repoll;
+	return nic_done != tx->done;
+}
+
+bool gve_tx_clean_pending(struct gve_priv *priv, struct gve_tx_ring *tx)
+{
+	u32 nic_done = gve_tx_load_event_counter(priv, tx);
+
+	return nic_done != tx->done;
 }
-- 
2.33.0.800.g4c38ced690-goog

