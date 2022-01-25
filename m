Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D45149B836
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377664AbiAYQHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:07:47 -0500
Received: from mga18.intel.com ([134.134.136.126]:4817 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235555AbiAYQGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 11:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126812; x=1674662812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jtj706yswCz0v9Nzdw5GJS58GyWJWgMWbcrpgdGh1kU=;
  b=li74s/A58s4ai1UL5ru5i4je8nQMOMG/EqoMG0IF5zIYC5A6rzANuxhx
   t+pjHcGaFbYfuQJz3WigqN5zY29W2NNQ2HdkW5FC9+avL/IJJ7fbMwmFl
   q9mQhdTkAkVa0BloLwXcYLVCRoea8YMR/F6gZAcLrn3mAAv8IyGof/PpS
   M0lnkd2sPXDCt+0N5dMxONKHphbmW9dtzEKkZmdF/tMA5VtpkuJZ1Q8Rt
   qtVIWlEZJooo/Mk5NIRuFx0Zh5OVHwTxQA9i4n1ZjYvKlVWeXYLwlzlg/
   LSf59RptYp85hG8yr6ZZ4nuVwgFtFOOgJo6ICASzCmXyzRSTC+gRvVqFP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229911640"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229911640"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 08:05:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534789255"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2022 08:04:58 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com
Subject: [PATCH bpf-next v5 5/8] i40e: xsk: move tmp desc array from driver to pool
Date:   Tue, 25 Jan 2022 17:04:43 +0100
Message-Id: <20220125160446.78976-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Move desc_array from the driver to the pool. The reason behind this is
that we can then reuse this array as a temporary storage for descriptors
in all zero-copy drivers that use the batched interface. This will make
it easier to add batching to more drivers.

i40e is the only driver that has a batched Tx zero-copy
implementation, so no need to touch any other driver.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 11 -----------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  4 ++--
 include/net/xdp_sock_drv.h                  |  5 ++---
 include/net/xsk_buff_pool.h                 |  1 +
 net/xdp/xsk.c                               | 13 ++++++-------
 net/xdp/xsk_buff_pool.c                     |  7 +++++++
 net/xdp/xsk_queue.h                         | 12 ++++++------
 8 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 66cc79500c10..af9c88e71452 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -830,8 +830,6 @@ void i40e_free_tx_resources(struct i40e_ring *tx_ring)
 	i40e_clean_tx_ring(tx_ring);
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
-	kfree(tx_ring->xsk_descs);
-	tx_ring->xsk_descs = NULL;
 
 	if (tx_ring->desc) {
 		dma_free_coherent(tx_ring->dev, tx_ring->size,
@@ -1433,13 +1431,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	if (!tx_ring->tx_bi)
 		goto err;
 
-	if (ring_is_xdp(tx_ring)) {
-		tx_ring->xsk_descs = kcalloc(I40E_MAX_NUM_DESCRIPTORS, sizeof(*tx_ring->xsk_descs),
-					     GFP_KERNEL);
-		if (!tx_ring->xsk_descs)
-			goto err;
-	}
-
 	u64_stats_init(&tx_ring->syncp);
 
 	/* round up to nearest 4K */
@@ -1463,8 +1454,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	return 0;
 
 err:
-	kfree(tx_ring->xsk_descs);
-	tx_ring->xsk_descs = NULL;
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
 	return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index bfc2845c99d1..f6d91fa1562e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -390,7 +390,6 @@ struct i40e_ring {
 	u16 rx_offset;
 	struct xdp_rxq_info xdp_rxq;
 	struct xsk_buff_pool *xsk_pool;
-	struct xdp_desc *xsk_descs;      /* For storing descriptors in the AF_XDP ZC path */
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ring_uses_build_skb(struct i40e_ring *ring)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 945b1bb9c6f4..9f349aaca9ff 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -467,11 +467,11 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
  **/
 static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 {
-	struct xdp_desc *descs = xdp_ring->xsk_descs;
+	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
 	u32 nb_pkts, nb_processed = 0;
 	unsigned int total_bytes = 0;
 
-	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
+	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
 	if (!nb_pkts)
 		return true;
 
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 443d45951564..4aa031849668 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -13,7 +13,7 @@
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
 bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc, u32 max);
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max);
 void xsk_tx_release(struct xsk_buff_pool *pool);
 struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
 					    u16 queue_id);
@@ -142,8 +142,7 @@ static inline bool xsk_tx_peek_desc(struct xsk_buff_pool *pool,
 	return false;
 }
 
-static inline u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc,
-						 u32 max)
+static inline u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max)
 {
 	return 0;
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index ddeefc4a1040..5554ee75e7da 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -60,6 +60,7 @@ struct xsk_buff_pool {
 	 */
 	dma_addr_t *dma_pages;
 	struct xdp_buff_xsk *heads;
+	struct xdp_desc *tx_descs;
 	u64 chunk_mask;
 	u64 addrs_cnt;
 	u32 free_list_cnt;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 28ef3f4465ae..2abd64e4d589 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -343,9 +343,9 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_tx_peek_desc);
 
-static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, struct xdp_desc *descs,
-					u32 max_entries)
+static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, u32 max_entries)
 {
+	struct xdp_desc *descs = pool->tx_descs;
 	u32 nb_pkts = 0;
 
 	while (nb_pkts < max_entries && xsk_tx_peek_desc(pool, &descs[nb_pkts]))
@@ -355,8 +355,7 @@ static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, struct xdp_d
 	return nb_pkts;
 }
 
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *descs,
-				   u32 max_entries)
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 {
 	struct xdp_sock *xs;
 	u32 nb_pkts;
@@ -365,7 +364,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 	if (!list_is_singular(&pool->xsk_tx_list)) {
 		/* Fallback to the non-batched version */
 		rcu_read_unlock();
-		return xsk_tx_peek_release_fallback(pool, descs, max_entries);
+		return xsk_tx_peek_release_fallback(pool, max_entries);
 	}
 
 	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
@@ -374,7 +373,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 		goto out;
 	}
 
-	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, descs, pool, max_entries);
+	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, pool, max_entries);
 	if (!nb_pkts) {
 		xs->tx->queue_empty_descs++;
 		goto out;
@@ -386,7 +385,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 	 * packets. This avoids having to implement any buffering in
 	 * the Tx path.
 	 */
-	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, descs, nb_pkts);
+	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, pool->tx_descs, nb_pkts);
 	if (!nb_pkts)
 		goto out;
 
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index fd39bb660ebc..b34fca6ada86 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -37,6 +37,7 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	if (!pool)
 		return;
 
+	kvfree(pool->tx_descs);
 	kvfree(pool->heads);
 	kvfree(pool);
 }
@@ -58,6 +59,12 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	if (!pool->heads)
 		goto out;
 
+	if (xs->tx) {
+		pool->tx_descs = kcalloc(xs->tx->nentries, sizeof(*pool->tx_descs), GFP_KERNEL);
+		if (!pool->tx_descs)
+			goto out;
+	}
+
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
 	pool->addrs_cnt = umem->size;
 	pool->heads_cnt = umem->chunks;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index e9aa2c236356..638138fbe475 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -205,11 +205,11 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 	return false;
 }
 
-static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q,
-					    struct xdp_desc *descs,
-					    struct xsk_buff_pool *pool, u32 max)
+static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
+					    u32 max)
 {
 	u32 cached_cons = q->cached_cons, nb_entries = 0;
+	struct xdp_desc *descs = pool->tx_descs;
 
 	while (cached_cons != q->cached_prod && nb_entries < max) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
@@ -282,12 +282,12 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 	return xskq_cons_read_desc(q, desc, pool);
 }
 
-static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xdp_desc *descs,
-					    struct xsk_buff_pool *pool, u32 max)
+static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
+					    u32 max)
 {
 	u32 entries = xskq_cons_nb_entries(q, max);
 
-	return xskq_cons_read_desc_batch(q, descs, pool, entries);
+	return xskq_cons_read_desc_batch(q, pool, entries);
 }
 
 /* To improve performance in the xskq_cons_release functions, only update local state here.
-- 
2.33.1

