Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFB96DA6ED
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbjDGBZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbjDGBZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:25:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC349753
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC09464C39
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFADC433D2;
        Fri,  7 Apr 2023 01:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680830744;
        bh=NCP8rrWBFQm0vNOjwQ89ntnpjVM2kzENU7nTgbW5Jd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuFVZyME7D6UNTZcf5s1/v7f3EvIKHD9U5B1j5/jtQpd30MQqjYM0L2UDibTwLqlV
         7pCXFYIZ0WpWVnpTP+STuNm2NH+9TSfOvsbsOCQp+QyZtC/bKkCQsVculXKJx1a8gu
         SAeDE1t0VmIJRFQlC8ta96M3lDApCoCn7zfVf+jdpMywnYqyR8hrDJZ2xq7YrCbYKY
         Lb3BXR5XKwIMBHGJY+M79dQqKa32rHwVfZSZcDj5PBLTTUisHl8pD1LNnOl3PIuC8U
         Jh+/YaVRhI52hl7QpVB+Vh5IPWFdQ4JXMc0KIPU1L8IfipcgSqJUBFkP9B8akhMWe/
         38OPbf1gC9IAw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v4 7/7] net: piggy back on the memory barrier in bql when waking queues
Date:   Thu,  6 Apr 2023 18:25:36 -0700
Message-Id: <20230407012536.273382-8-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230407012536.273382-1-kuba@kernel.org>
References: <20230407012536.273382-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers call netdev_tx_completed_queue() right before
netif_txq_maybe_wake(). If BQL is enabled netdev_tx_completed_queue()
should issue a memory barrier, so we can depend on that separating
the stop check from the consumer index update, instead of adding
another barrier in netif_txq_maybe_wake().

This matters more than the barriers on the xmit path, because
the wake condition is almost always true. So we issue the
consumer side barrier often.

Wrap netdev_tx_completed_queue() in a local helper to issue
the barrier even if BQL is disabled. Keep the same semantics
as netdev_tx_completed_queue() (barrier only if bytes != 0)
to make it clear that the barrier is conditional.

Plus since macro gets pkt/byte counts as arguments now -
we can skip waking if there were no packets completed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v4:
 - use IS_ENABLED()
 - improve commit message (add the 3rd paragraph)
v3: https://lore.kernel.org/all/20230405223134.94665-8-kuba@kernel.org/
 - new patch

CC: michael.chan@broadcom.com
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 12 +++---
 include/linux/netdevice.h                     |  2 +-
 include/net/netdev_queues.h                   | 39 ++++++++++++++-----
 4 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index de97bee25249..f7602d8d79e3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -688,11 +688,11 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		dev_kfree_skb_any(skb);
 	}
 
-	netdev_tx_completed_queue(txq, nr_pkts, tx_bytes);
 	txr->tx_cons = cons;
 
-	__netif_txq_maybe_wake(txq, bnxt_tx_avail(bp, txr), bp->tx_wake_thresh,
-			       READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING);
+	__netif_txq_completed_wake(txq, nr_pkts, tx_bytes,
+				   bnxt_tx_avail(bp, txr), bp->tx_wake_thresh,
+				   READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING);
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cbbddee55db1..f2604fc05991 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1251,15 +1251,13 @@ static bool ixgbe_clean_tx_irq(struct ixgbe_q_vector *q_vector,
 	if (ring_is_xdp(tx_ring))
 		return !!budget;
 
-	netdev_tx_completed_queue(txring_txq(tx_ring),
-				  total_packets, total_bytes);
-
 #define TX_WAKE_THRESHOLD (DESC_NEEDED * 2)
 	txq = netdev_get_tx_queue(tx_ring->netdev, tx_ring->queue_index);
-	if (total_packets && netif_carrier_ok(tx_ring->netdev) &&
-	    !__netif_txq_maybe_wake(txq, ixgbe_desc_unused(tx_ring),
-				    TX_WAKE_THRESHOLD,
-				    test_bit(__IXGBE_DOWN, &adapter->state)))
+	if (!__netif_txq_completed_wake(txq, total_packets, total_bytes,
+					ixgbe_desc_unused(tx_ring),
+					TX_WAKE_THRESHOLD,
+					netif_carrier_ok(tx_ring->netdev) &&
+					test_bit(__IXGBE_DOWN, &adapter->state)))
 		++tx_ring->tx_stats.restart_queue;
 
 	return !!budget;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 18770d325499..10736fc6d85e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3538,7 +3538,7 @@ static inline void netdev_tx_completed_queue(struct netdev_queue *dev_queue,
 	 * netdev_tx_sent_queue will miss the update and cause the queue to
 	 * be stopped forever
 	 */
-	smp_mb();
+	smp_mb(); /* NOTE: netdev_txq_completed_mb() assumes this exists */
 
 	if (unlikely(dql_avail(&dev_queue->dql) < 0))
 		return;
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index 5236d78bbdeb..b26fdb441e39 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -38,7 +38,7 @@
 		netif_tx_stop_queue(txq);				\
 		/* Producer index and stop bit must be visible		\
 		 * to consumer before we recheck.			\
-		 * Pairs with a barrier in __netif_txq_maybe_wake().	\
+		 * Pairs with a barrier in __netif_txq_completed_wake(). \
 		 */							\
 		smp_mb__after_atomic();					\
 									\
@@ -82,10 +82,24 @@
 		_res;							\
 	})								\
 
+/* Variant of netdev_tx_completed_queue() which guarantees smp_mb() if
+ * @bytes != 0, regardless of kernel config.
+ */
+static inline void
+netdev_txq_completed_mb(struct netdev_queue *dev_queue,
+			unsigned int pkts, unsigned int bytes)
+{
+	if (IS_ENABLED(CONFIG_BQL))
+		netdev_tx_completed_queue(dev_queue, pkts, bytes);
+	else if (bytes)
+		smp_mb();
+}
 
 /**
- * __netif_txq_maybe_wake() - locklessly wake a Tx queue, if needed
+ * __netif_txq_completed_wake() - locklessly wake a Tx queue, if needed
  * @txq:	struct netdev_queue to stop/start
+ * @pkts:	number of packets completed
+ * @bytes:	number of bytes completed
  * @get_desc:	get current number of free descriptors (see requirements below!)
  * @start_thrs:	minimal number of descriptors to re-enable the queue
  * @down_cond:	down condition, predicate indicating that the queue should
@@ -94,22 +108,27 @@
  * All arguments may be evaluated multiple times.
  * @get_desc must be a formula or a function call, it must always
  * return up-to-date information when evaluated!
+ * Reports completed pkts/bytes to BQL.
  *
  * Returns:
  *	 0 if the queue was woken up
  *	 1 if the queue was already enabled (or disabled but @down_cond is true)
  *	-1 if the queue was left unchanged (@start_thrs not reached)
  */
-#define __netif_txq_maybe_wake(txq, get_desc, start_thrs, down_cond)	\
+#define __netif_txq_completed_wake(txq, pkts, bytes,			\
+				   get_desc, start_thrs, down_cond)	\
 	({								\
 		int _res;						\
 									\
+		/* Report to BQL and piggy back on its barrier.		\
+		 * Barrier makes sure that anybody stopping the queue	\
+		 * after this point sees the new consumer index.	\
+		 * Pairs with barrier in netif_txq_try_stop().		\
+		 */							\
+		netdev_txq_completed_mb(txq, pkts, bytes);		\
+									\
 		_res = -1;						\
-		if (likely(get_desc > start_thrs)) {			\
-			/* Make sure that anybody stopping the queue after \
-			 * this sees the new next_to_clean.		\
-			 */						\
-			smp_mb();					\
+		if (pkts && likely(get_desc > start_thrs)) {		\
 			_res = 1;					\
 			if (unlikely(netif_tx_queue_stopped(txq)) &&	\
 			    !(down_cond)) {				\
@@ -120,8 +139,8 @@
 		_res;							\
 	})
 
-#define netif_txq_maybe_wake(txq, get_desc, start_thrs)		\
-	__netif_txq_maybe_wake(txq, get_desc, start_thrs, false)
+#define netif_txq_completed_wake(txq, pkts, bytes, get_desc, start_thrs) \
+	__netif_txq_completed_wake(txq, pkts, bytes, get_desc, start_thrs, false)
 
 /* subqueue variants follow */
 
-- 
2.39.2

