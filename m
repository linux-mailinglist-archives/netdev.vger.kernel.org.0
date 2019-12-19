Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2FB12625E
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 13:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLSMkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 07:40:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:27930 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbfLSMj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 07:39:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 04:39:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,331,1571727600"; 
   d="scan'208";a="366062589"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.49.245])
  by orsmga004.jf.intel.com with ESMTP; 19 Dec 2019 04:39:56 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next v2 07/12] xsk: simplify the consumer ring access functions
Date:   Thu, 19 Dec 2019 13:39:26 +0100
Message-Id: <1576759171-28550-8-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
References: <1576759171-28550-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify and refactor consumer ring functions. The consumer first
"peeks" to find descriptors or addresses that are available to
read from the ring, then reads them and finally "releases" these
descriptors once it is done. The two local variables cons_tail
and cons_head are turned into one single variable called
cached_cons. cached_tail referred to the cached value of the
global consumer pointer and will be stored in cached_cons. For
cached_head, we just use cached_prod instead as it was not used
for a consumer queue before. It also better reflects what it
really is now: a cached copy of the producer pointer.

The names of the functions are also renamed in the same manner as
the producer functions. The new functions are called xskq_cons_
followed by what it does.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c       |  24 ++++++-------
 net/xdp/xsk_queue.h | 102 ++++++++++++++++++++++++----------------------------
 2 files changed, 58 insertions(+), 68 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f93cf76..fb13b64 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -39,19 +39,19 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 
 bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
 {
-	return xskq_has_addrs(umem->fq, cnt);
+	return xskq_cons_has_entries(umem->fq, cnt);
 }
 EXPORT_SYMBOL(xsk_umem_has_addrs);
 
 u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 {
-	return xskq_peek_addr(umem->fq, addr, umem);
+	return xskq_cons_peek_addr(umem->fq, addr, umem);
 }
 EXPORT_SYMBOL(xsk_umem_peek_addr);
 
 void xsk_umem_discard_addr(struct xdp_umem *umem)
 {
-	xskq_discard_addr(umem->fq);
+	xskq_cons_release(umem->fq);
 }
 EXPORT_SYMBOL(xsk_umem_discard_addr);
 
@@ -146,7 +146,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	u32 metalen;
 	int err;
 
-	if (!xskq_peek_addr(xs->umem->fq, &addr, xs->umem) ||
+	if (!xskq_cons_peek_addr(xs->umem->fq, &addr, xs->umem) ||
 	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
 		xs->rx_dropped++;
 		return -ENOSPC;
@@ -167,7 +167,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
 	err = xskq_prod_reserve_desc(xs->rx, addr, len);
 	if (!err) {
-		xskq_discard_addr(xs->umem->fq);
+		xskq_cons_release(xs->umem->fq);
 		xdp_return_buff(xdp);
 		return 0;
 	}
@@ -234,7 +234,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 		goto out_unlock;
 	}
 
-	if (!xskq_peek_addr(xs->umem->fq, &addr, xs->umem) ||
+	if (!xskq_cons_peek_addr(xs->umem->fq, &addr, xs->umem) ||
 	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
 		err = -ENOSPC;
 		goto out_drop;
@@ -249,7 +249,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	if (err)
 		goto out_drop;
 
-	xskq_discard_addr(xs->umem->fq);
+	xskq_cons_release(xs->umem->fq);
 	xskq_prod_submit(xs->rx);
 
 	spin_unlock_bh(&xs->rx_lock);
@@ -317,13 +317,13 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
-		if (!xskq_peek_desc(xs->tx, desc, umem))
+		if (!xskq_cons_peek_desc(xs->tx, desc, umem))
 			continue;
 
 		if (xskq_prod_reserve_addr(umem->cq, desc->addr))
 			goto out;
 
-		xskq_discard_desc(xs->tx);
+		xskq_cons_release(xs->tx);
 		rcu_read_unlock();
 		return true;
 	}
@@ -369,7 +369,7 @@ static int xsk_generic_xmit(struct sock *sk)
 	if (xs->queue_id >= xs->dev->real_num_tx_queues)
 		goto out;
 
-	while (xskq_peek_desc(xs->tx, &desc, xs->umem)) {
+	while (xskq_cons_peek_desc(xs->tx, &desc, xs->umem)) {
 		char *buffer;
 		u64 addr;
 		u32 len;
@@ -402,7 +402,7 @@ static int xsk_generic_xmit(struct sock *sk)
 		skb->destructor = xsk_destruct_skb;
 
 		err = dev_direct_xmit(skb, xs->queue_id);
-		xskq_discard_desc(xs->tx);
+		xskq_cons_release(xs->tx);
 		/* Ignore NET_XMIT_CN as packet might have been sent */
 		if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
 			/* SKB completed but not sent */
@@ -473,7 +473,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (xs->tx && !xskq_full_desc(xs->tx))
+	if (xs->tx && !xskq_cons_is_full(xs->tx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	return mask;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 8bfa2ee..1436116 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -34,8 +34,7 @@ struct xsk_queue {
 	u32 ring_mask;
 	u32 nentries;
 	u32 cached_prod;
-	u32 cons_head;
-	u32 cons_tail;
+	u32 cached_cons;
 	struct xdp_ring *ring;
 	u64 invalid_descs;
 };
@@ -89,43 +88,48 @@ static inline u64 xskq_nb_invalid_descs(struct xsk_queue *q)
 	return q ? q->invalid_descs : 0;
 }
 
-static inline u32 xskq_nb_avail(struct xsk_queue *q)
+static inline void __xskq_cons_release(struct xsk_queue *q)
 {
-	u32 entries = q->cached_prod - q->cons_tail;
+	smp_mb(); /* D, matches A */
+	WRITE_ONCE(q->ring->consumer, q->cached_cons);
+}
 
-	if (entries == 0) {
-		/* Refresh the local pointer */
-		q->cached_prod = READ_ONCE(q->ring->producer);
-		entries = q->cached_prod - q->cons_tail;
-	}
+static inline void __xskq_cons_peek(struct xsk_queue *q)
+{
+	/* Refresh the local pointer */
+	q->cached_prod = READ_ONCE(q->ring->producer);
+	smp_rmb(); /* C, matches B */
+}
 
-	return entries;
+static inline void xskq_cons_get_entries(struct xsk_queue *q)
+{
+	__xskq_cons_release(q);
+	__xskq_cons_peek(q);
 }
 
 static inline bool xskq_prod_is_full(struct xsk_queue *q)
 {
-	u32 free_entries = q->nentries - (q->cached_prod - q->cons_tail);
+	u32 free_entries = q->nentries - (q->cached_prod - q->cached_cons);
 
 	if (free_entries)
 		return false;
 
 	/* Refresh the local tail pointer */
-	q->cons_tail = READ_ONCE(q->ring->consumer);
-	free_entries = q->nentries - (q->cached_prod - q->cons_tail);
+	q->cached_cons = READ_ONCE(q->ring->consumer);
+	free_entries = q->nentries - (q->cached_prod - q->cached_cons);
 
 	return !free_entries;
 }
 
-static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
+static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
 {
-	u32 entries = q->cached_prod - q->cons_tail;
+	u32 entries = q->cached_prod - q->cached_cons;
 
 	if (entries >= cnt)
 		return true;
 
-	/* Refresh the local pointer. */
-	q->cached_prod = READ_ONCE(q->ring->producer);
-	entries = q->cached_prod - q->cons_tail;
+	__xskq_cons_peek(q);
+	entries = q->cached_prod - q->cached_cons;
 
 	return entries >= cnt;
 }
@@ -172,9 +176,10 @@ static inline bool xskq_is_valid_addr_unaligned(struct xsk_queue *q, u64 addr,
 static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr,
 				      struct xdp_umem *umem)
 {
-	while (q->cons_tail != q->cons_head) {
-		struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-		unsigned int idx = q->cons_tail & q->ring_mask;
+	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
+
+	while (q->cached_cons != q->cached_prod) {
+		u32 idx = q->cached_cons & q->ring_mask;
 
 		*addr = READ_ONCE(ring->desc[idx]) & q->chunk_mask;
 
@@ -190,30 +195,27 @@ static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr,
 			return addr;
 
 out:
-		q->cons_tail++;
+		q->cached_cons++;
 	}
 
 	return NULL;
 }
 
-static inline u64 *xskq_peek_addr(struct xsk_queue *q, u64 *addr,
-				  struct xdp_umem *umem)
+static inline u64 *xskq_cons_peek_addr(struct xsk_queue *q, u64 *addr,
+				       struct xdp_umem *umem)
 {
-	if (q->cons_tail == q->cons_head) {
-		smp_mb(); /* D, matches A */
-		WRITE_ONCE(q->ring->consumer, q->cons_tail);
-		q->cons_head = q->cons_tail + xskq_nb_avail(q);
-
-		/* Order consumer and data */
-		smp_rmb();
-	}
-
+	if (q->cached_prod == q->cached_cons)
+		xskq_cons_get_entries(q);
 	return xskq_validate_addr(q, addr, umem);
 }
 
-static inline void xskq_discard_addr(struct xsk_queue *q)
+static inline void xskq_cons_release(struct xsk_queue *q)
 {
-	q->cons_tail++;
+	/* To improve performance, only update local state here.
+	 * Do the actual release operation when we get new entries
+	 * from the ring in xskq_cons_get_entries() instead.
+	 */
+	q->cached_cons++;
 }
 
 static inline int xskq_prod_reserve(struct xsk_queue *q)
@@ -299,41 +301,29 @@ static inline struct xdp_desc *xskq_validate_desc(struct xsk_queue *q,
 						  struct xdp_desc *desc,
 						  struct xdp_umem *umem)
 {
-	while (q->cons_tail != q->cons_head) {
+	while (q->cached_cons != q->cached_prod) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
-		unsigned int idx = q->cons_tail & q->ring_mask;
+		u32 idx = q->cached_cons & q->ring_mask;
 
 		*desc = READ_ONCE(ring->desc[idx]);
 		if (xskq_is_valid_desc(q, desc, umem))
 			return desc;
 
-		q->cons_tail++;
+		q->cached_cons++;
 	}
 
 	return NULL;
 }
 
-static inline struct xdp_desc *xskq_peek_desc(struct xsk_queue *q,
-					      struct xdp_desc *desc,
-					      struct xdp_umem *umem)
+static inline struct xdp_desc *xskq_cons_peek_desc(struct xsk_queue *q,
+						   struct xdp_desc *desc,
+						   struct xdp_umem *umem)
 {
-	if (q->cons_tail == q->cons_head) {
-		smp_mb(); /* D, matches A */
-		WRITE_ONCE(q->ring->consumer, q->cons_tail);
-		q->cons_head = q->cons_tail + xskq_nb_avail(q);
-
-		/* Order consumer and data */
-		smp_rmb(); /* C, matches B */
-	}
-
+	if (q->cached_prod == q->cached_cons)
+		xskq_cons_get_entries(q);
 	return xskq_validate_desc(q, desc, umem);
 }
 
-static inline void xskq_discard_desc(struct xsk_queue *q)
-{
-	q->cons_tail++;
-}
-
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 					 u64 addr, u32 len)
 {
@@ -351,7 +341,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 	return 0;
 }
 
-static inline bool xskq_full_desc(struct xsk_queue *q)
+static inline bool xskq_cons_is_full(struct xsk_queue *q)
 {
 	/* No barriers needed since data is not accessed */
 	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer) ==
-- 
2.7.4

