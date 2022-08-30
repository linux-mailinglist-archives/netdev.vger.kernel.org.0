Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52145A6314
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiH3MRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiH3MRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:17:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F975AB4CE;
        Tue, 30 Aug 2022 05:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661861833; x=1693397833;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P9C48dSSTkztXv+4cuY1FGRC92QtKSnE/J85TKf89Hc=;
  b=bfLnG5JsR+Ksz8ZwEJoLPCD9Mp12DDWhqYVBMikMpXCjIa4rIF7VWtST
   koz+q8ek91THo3k+cEtfrG4n5TDmmToFJa0I69NURwKbjzRNBu2+1fa5D
   FwBmQthEuwHR7++bxfOcio9iMQsihokChL0dZJZLpZLVHvx6cnvrNTh6p
   dCYPEx0a8FPXE18SLFK1xSz0zuQBAiwgr9thz7HfkWPcwoUmDILMJW67Y
   PIws8gC9UHrMehfAkLk/OZJk3MA1jjH5FUeZNqm2IfzgoM0FC0yPDT9RH
   xCjdw+SaPHmpJFIcGGuelKQBSB/jpOKEpoXpolnDgwIOrHgHF9hY4GbvW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="293902379"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="293902379"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:17:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="641349723"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 30 Aug 2022 05:17:10 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf] xsk: fix backpressure mechanism on Tx
Date:   Tue, 30 Aug 2022 14:17:05 +0200
Message-Id: <20220830121705.8618-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d678cbd2f867 ("xsk: Fix handling of invalid descriptors in XSK TX
batching API") fixed batch API usage against set of descriptors with
invalid ones but introduced a problem when AF_XDP SW rings are smaller
than HW ones. Mismatch of reported Tx'ed frames between HW generator and
user space app was observed. It turned out that backpressure mechanism
became a bottleneck when the amount of produced descriptors to CQ is
lower than what we grabbed from XSK Tx ring.

Say that 512 entries had been taken from XSK Tx ring but we had only 490
free entries in CQ. Then callsite (ZC driver) will produce only 490
entries onto HW Tx ring but 512 entries will be released from Tx ring
and this is what will be seen by the user space.

In order to fix this case, mix XSK Tx/CQ ring interractions by moving
around internal functions and changing call order:
*  pull out xskq_prod_nb_free() from xskq_prod_reserve_addr_batch() up to
   xsk_tx_peek_release_desc_batch();
** move xskq_cons_release_n() into xskq_cons_read_desc_batch()

After doing so, algorithm can be described as follows:
1. lookup Tx entries
2. use value from 1. to reserve space in CQ (*)
3. Read from Tx ring as much descriptors as value from 2
 3a. release descriptors from XSK Tx ring (**)
4. Finally produce addresses to CQ

Fixes: d678cbd2f867 ("xsk: Fix handling of invalid descriptors in XSK TX batching API")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk.c       | 22 +++++++++++-----------
 net/xdp/xsk_queue.h | 22 ++++++++++------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5b4ce6ba1bc7..639b2c3beb69 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -355,16 +355,15 @@ static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, u32 max_entr
 	return nb_pkts;
 }
 
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 nb_pkts)
 {
 	struct xdp_sock *xs;
-	u32 nb_pkts;
 
 	rcu_read_lock();
 	if (!list_is_singular(&pool->xsk_tx_list)) {
 		/* Fallback to the non-batched version */
 		rcu_read_unlock();
-		return xsk_tx_peek_release_fallback(pool, max_entries);
+		return xsk_tx_peek_release_fallback(pool, nb_pkts);
 	}
 
 	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
@@ -373,12 +372,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 		goto out;
 	}
 
-	max_entries = xskq_cons_nb_entries(xs->tx, max_entries);
-	nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, max_entries);
-	if (!nb_pkts) {
-		xs->tx->queue_empty_descs++;
-		goto out;
-	}
+	nb_pkts = xskq_cons_nb_entries(xs->tx, nb_pkts);
 
 	/* This is the backpressure mechanism for the Tx path. Try to
 	 * reserve space in the completion queue for all packets, but
@@ -386,12 +380,18 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 	 * packets. This avoids having to implement any buffering in
 	 * the Tx path.
 	 */
-	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, pool->tx_descs, nb_pkts);
+	nb_pkts = xskq_prod_nb_free(pool->cq, nb_pkts);
 	if (!nb_pkts)
 		goto out;
 
-	xskq_cons_release_n(xs->tx, max_entries);
+	nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, nb_pkts);
+	if (!nb_pkts) {
+		xs->tx->queue_empty_descs++;
+		goto out;
+	}
+
 	__xskq_cons_release(xs->tx);
+	xskq_prod_write_addr_batch(pool->cq, pool->tx_descs, nb_pkts);
 	xs->sk.sk_write_space(&xs->sk);
 
 out:
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index fb20bf7207cf..c6fb6b763658 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -205,6 +205,11 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 	return false;
 }
 
+static inline void xskq_cons_release_n(struct xsk_queue *q, u32 cnt)
+{
+	q->cached_cons += cnt;
+}
+
 static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
 					    u32 max)
 {
@@ -226,6 +231,8 @@ static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff
 		cached_cons++;
 	}
 
+	/* Release valid plus any invalid entries */
+	xskq_cons_release_n(q, cached_cons - q->cached_cons);
 	return nb_entries;
 }
 
@@ -291,11 +298,6 @@ static inline void xskq_cons_release(struct xsk_queue *q)
 	q->cached_cons++;
 }
 
-static inline void xskq_cons_release_n(struct xsk_queue *q, u32 cnt)
-{
-	q->cached_cons += cnt;
-}
-
 static inline u32 xskq_cons_present_entries(struct xsk_queue *q)
 {
 	/* No barriers needed since data is not accessed */
@@ -350,21 +352,17 @@ static inline int xskq_prod_reserve_addr(struct xsk_queue *q, u64 addr)
 	return 0;
 }
 
-static inline u32 xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_desc *descs,
-					       u32 max)
+static inline void xskq_prod_write_addr_batch(struct xsk_queue *q, struct xdp_desc *descs,
+					      u32 nb_entries)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-	u32 nb_entries, i, cached_prod;
-
-	nb_entries = xskq_prod_nb_free(q, max);
+	u32 i, cached_prod;
 
 	/* A, matches D */
 	cached_prod = q->cached_prod;
 	for (i = 0; i < nb_entries; i++)
 		ring->desc[cached_prod++ & q->ring_mask] = descs[i].addr;
 	q->cached_prod = cached_prod;
-
-	return nb_entries;
 }
 
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
-- 
2.34.1

