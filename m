Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633191167CD
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfLIH5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:57:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:35363 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbfLIH5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:57:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:57:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846966"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:57:18 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 11/12] xsk: add function naming comments and reorder functions
Date:   Mon,  9 Dec 2019 08:56:28 +0100
Message-Id: <1575878189-31860-12-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add comments on how the ring access functions are named and how they
are supposed to be used for producers and consumers. The functions are
also reordered so that the consumer functions are in the beginning and
the producer functions in the end, for easier reference. Put this in a
separate patch as the diff might look a little odd, but no
functionality has changed in this patch.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c       |  10 ++
 net/xdp/xsk_queue.h | 291 ++++++++++++++++++++++++++++------------------------
 2 files changed, 166 insertions(+), 135 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f0dd740..e1ffcf1 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -320,6 +320,11 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 		if (!xskq_cons_peek_desc(xs->tx, desc, umem))
 			continue;
 
+		/* This is the backpreassure mechanism for the Tx path.
+		 * Reserve space in the completion queue and only proceed
+		 * if there is space in it. This avoids having to implement
+		 * any buffering in the Tx path.
+		 */
 		if (xskq_prod_reserve_addr(umem->cq, desc->addr))
 			goto out;
 
@@ -390,6 +395,11 @@ static int xsk_generic_xmit(struct sock *sk)
 		addr = desc.addr;
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
+		/* This is the backpreassure mechanism for the Tx path.
+		 * Reserve space in the completion queue and only proceed
+		 * if there is space in it. This avoids having to implement
+		 * any buffering in the Tx path.
+		 */
 		if (unlikely(err) || xskq_prod_reserve(xs->umem->cq)) {
 			kfree_skb(skb);
 			goto out;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 89e1fbd..81a88c1 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -81,60 +81,27 @@ struct xsk_queue {
  * now and again after circling through the ring.
  */
 
-/* Common functions operating for both RXTX and umem queues */
-
-static inline u64 xskq_nb_invalid_descs(struct xsk_queue *q)
-{
-	return q ? q->invalid_descs : 0;
-}
-
-static inline void __xskq_cons_release(struct xsk_queue *q)
-{
-	smp_mb(); /* D, matches A */
-	WRITE_ONCE(q->ring->consumer, q->cached_cons);
-}
-
-static inline void __xskq_cons_peek(struct xsk_queue *q)
-{
-	/* Refresh the local pointer */
-	q->cached_prod = READ_ONCE(q->ring->producer);
-	smp_rmb(); /* C, matches B */
-}
-
-static inline void xskq_cons_get_entries(struct xsk_queue *q)
-{
-	__xskq_cons_release(q);
-	__xskq_cons_peek(q);
-}
-
-static inline bool xskq_prod_is_full(struct xsk_queue *q)
-{
-	u32 free_entries = q->nentries - (q->cached_prod - q->cached_cons);
-
-	if (free_entries)
-		return false;
-
-	/* Refresh the local tail pointer */
-	q->cached_cons = READ_ONCE(q->ring->consumer);
-	free_entries = q->nentries - (q->cached_prod - q->cached_cons);
-
-	return !free_entries;
-}
-
-static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
-{
-	u32 entries = q->cached_prod - q->cached_cons;
-
-	if (entries >= cnt)
-		return true;
-
-	__xskq_cons_peek(q);
-	entries = q->cached_prod - q->cached_cons;
-
-	return entries >= cnt;
-}
+/* The operations on the rings are the following:
+ *
+ * producer                           consumer
+ *
+ * RESERVE entries                    PEEK in the ring for entries
+ * WRITE data into the ring           READ data from the ring
+ * SUBMIT entries                     RELEASE entries
+ *
+ * The producer reserves one or more entries in the ring. It can then
+ * fill in these entries and finally submit them so that they can be
+ * seen and read by the consumer.
+ *
+ * The consumer peeks into the ring to see if the producer has written
+ * any new entries. If so, the producer can then read these entries
+ * and when it is done reading them release them back to the producer
+ * so that the producer can use these slots to fill in new entries.
+ *
+ * The function names below reflect these operations.
+ */
 
-/* UMEM queue */
+/* Functions that read and validate content from consumer rings. */
 
 static inline bool xskq_cons_crosses_non_contig_pg(struct xdp_umem *umem,
 						   u64 addr,
@@ -148,16 +115,6 @@ static inline bool xskq_cons_crosses_non_contig_pg(struct xdp_umem *umem,
 	return cross_pg && !next_pg_contig;
 }
 
-static inline bool xskq_cons_is_valid_addr(struct xsk_queue *q, u64 addr)
-{
-	if (addr >= q->size) {
-		q->invalid_descs++;
-		return false;
-	}
-
-	return true;
-}
-
 static inline bool xskq_cons_is_valid_unaligned(struct xsk_queue *q,
 						u64 addr,
 						u64 length,
@@ -175,6 +132,16 @@ static inline bool xskq_cons_is_valid_unaligned(struct xsk_queue *q,
 	return true;
 }
 
+static inline bool xskq_cons_is_valid_addr(struct xsk_queue *q, u64 addr)
+{
+	if (addr >= q->size) {
+		q->invalid_descs++;
+		return false;
+	}
+
+	return true;
+}
+
 static inline bool xskq_cons_read_addr(struct xsk_queue *q, u64 *addr,
 				       struct xdp_umem *umem)
 {
@@ -203,75 +170,6 @@ static inline bool xskq_cons_read_addr(struct xsk_queue *q, u64 *addr,
 	return false;
 }
 
-static inline bool xskq_cons_peek_addr(struct xsk_queue *q, u64 *addr,
-				       struct xdp_umem *umem)
-{
-	if (q->cached_prod == q->cached_cons)
-		xskq_cons_get_entries(q);
-	return xskq_cons_read_addr(q, addr, umem);
-}
-
-static inline void xskq_cons_release(struct xsk_queue *q)
-{
-	/* To improve performance, only update local state here.
-	 * Do the actual release operation when we get new entries
-	 * from the ring in xskq_cons_get_entries() instead.
-	 */
-	q->cached_cons++;
-}
-
-static inline int xskq_prod_reserve(struct xsk_queue *q)
-{
-	if (xskq_prod_is_full(q))
-		return -ENOSPC;
-
-	/* A, matches D */
-	q->cached_prod++;
-	return 0;
-}
-
-static inline int xskq_prod_reserve_addr(struct xsk_queue *q, u64 addr)
-{
-	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-
-	if (xskq_prod_is_full(q))
-		return -ENOSPC;
-
-	/* A, matches D */
-	ring->desc[q->cached_prod++ & q->ring_mask] = addr;
-	return 0;
-}
-
-static inline void __xskq_prod_submit(struct xsk_queue *q, u32 idx)
-{
-	/* Order producer and data */
-	smp_wmb(); /* B, matches C */
-
-	WRITE_ONCE(q->ring->producer, idx);
-}
-
-static inline void xskq_prod_submit(struct xsk_queue *q)
-{
-	__xskq_prod_submit(q, q->cached_prod);
-}
-
-static inline void xskq_prod_submit_addr(struct xsk_queue *q, u64 addr)
-{
-	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-	u32 idx = q->ring->producer;
-
-	ring->desc[idx++ & q->ring_mask] = addr;
-
-	__xskq_prod_submit(q, idx);
-}
-
-static inline void xskq_prod_submit_n(struct xsk_queue *q, u32 nb_entries)
-{
-	__xskq_prod_submit(q, q->ring->producer + nb_entries);
-}
-
-/* Rx/Tx queue */
-
 static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
 					   struct xdp_desc *d,
 					   struct xdp_umem *umem)
@@ -318,6 +216,48 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 	return false;
 }
 
+/* Functions for consumers */
+
+static inline void __xskq_cons_release(struct xsk_queue *q)
+{
+	smp_mb(); /* D, matches A */
+	WRITE_ONCE(q->ring->consumer, q->cached_cons);
+}
+
+static inline void __xskq_cons_peek(struct xsk_queue *q)
+{
+	/* Refresh the local pointer */
+	q->cached_prod = READ_ONCE(q->ring->producer);
+	smp_rmb(); /* C, matches B */
+}
+
+static inline void xskq_cons_get_entries(struct xsk_queue *q)
+{
+	__xskq_cons_release(q);
+	__xskq_cons_peek(q);
+}
+
+static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
+{
+	u32 entries = q->cached_prod - q->cached_cons;
+
+	if (entries >= cnt)
+		return true;
+
+	__xskq_cons_peek(q);
+	entries = q->cached_prod - q->cached_cons;
+
+	return entries >= cnt;
+}
+
+static inline bool xskq_cons_peek_addr(struct xsk_queue *q, u64 *addr,
+				       struct xdp_umem *umem)
+{
+	if (q->cached_prod == q->cached_cons)
+		xskq_cons_get_entries(q);
+	return xskq_cons_read_addr(q, addr, umem);
+}
+
 static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 				       struct xdp_desc *desc,
 				       struct xdp_umem *umem)
@@ -327,6 +267,59 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 	return xskq_cons_read_desc(q, desc, umem);
 }
 
+static inline void xskq_cons_release(struct xsk_queue *q)
+{
+	/* To improve performance, only update local state here.
+	 * Reflect this to global state when we get new entries
+	 * from the ring in xskq_cons_get_entries().
+	 */
+	q->cached_cons++;
+}
+
+static inline bool xskq_cons_is_full(struct xsk_queue *q)
+{
+	/* No barriers needed since data is not accessed */
+	return READ_ONCE(q->ring->producer) - q->cached_cons == q->nentries;
+}
+
+/* Functions for producers */
+
+static inline bool xskq_prod_is_full(struct xsk_queue *q)
+{
+	u32 free_entries = q->nentries - (q->cached_prod - q->cached_cons);
+
+	if (free_entries)
+		return false;
+
+	/* Refresh the local tail pointer */
+	q->cached_cons = READ_ONCE(q->ring->consumer);
+	free_entries = q->nentries - (q->cached_prod - q->cached_cons);
+
+	return !free_entries;
+}
+
+static inline int xskq_prod_reserve(struct xsk_queue *q)
+{
+	if (xskq_prod_is_full(q))
+		return -ENOSPC;
+
+	/* A, matches D */
+	q->cached_prod++;
+	return 0;
+}
+
+static inline int xskq_prod_reserve_addr(struct xsk_queue *q, u64 addr)
+{
+	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
+
+	if (xskq_prod_is_full(q))
+		return -ENOSPC;
+
+	/* A, matches D */
+	ring->desc[q->cached_prod++ & q->ring_mask] = addr;
+	return 0;
+}
+
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 					 u64 addr, u32 len)
 {
@@ -344,10 +337,31 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 	return 0;
 }
 
-static inline bool xskq_cons_is_full(struct xsk_queue *q)
+static inline void __xskq_prod_submit(struct xsk_queue *q, u32 idx)
 {
-	/* No barriers needed since data is not accessed */
-	return READ_ONCE(q->ring->producer) - q->cached_cons == q->nentries;
+	smp_wmb(); /* B, matches C */
+
+	WRITE_ONCE(q->ring->producer, idx);
+}
+
+static inline void xskq_prod_submit(struct xsk_queue *q)
+{
+	__xskq_prod_submit(q, q->cached_prod);
+}
+
+static inline void xskq_prod_submit_addr(struct xsk_queue *q, u64 addr)
+{
+	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
+	u32 idx = q->ring->producer;
+
+	ring->desc[idx++ & q->ring_mask] = addr;
+
+	__xskq_prod_submit(q, idx);
+}
+
+static inline void xskq_prod_submit_n(struct xsk_queue *q, u32 nb_entries)
+{
+	__xskq_prod_submit(q, q->ring->producer + nb_entries);
 }
 
 static inline bool xskq_prod_is_empty(struct xsk_queue *q)
@@ -356,6 +370,13 @@ static inline bool xskq_prod_is_empty(struct xsk_queue *q)
 	return READ_ONCE(q->ring->consumer) == q->cached_prod;
 }
 
+/* For both producers and consumers */
+
+static inline u64 xskq_nb_invalid_descs(struct xsk_queue *q)
+{
+	return q ? q->invalid_descs : 0;
+}
+
 void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
 struct xsk_queue *xskq_create(u32 nentries, bool umem_queue);
 void xskq_destroy(struct xsk_queue *q_ops);
-- 
2.7.4

