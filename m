Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4D1167C0
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfLIH46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:56:58 -0500
Received: from mga05.intel.com ([192.55.52.43]:35290 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbfLIH44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:56:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:56:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846884"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:56:51 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 03/12] xsk: standardize naming of producer ring access functions
Date:   Mon,  9 Dec 2019 08:56:20 +0100
Message-Id: <1575878189-31860-4-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adopt the naming of the producer ring access functions to have a
similar naming convention as the functions in libbpf, but adapted to
the kernel. You first reserve a number of entries that you later
submit to the global state of the ring. This is much clearer, IMO,
than the one that was in the kernel part. Once renamed, we also
discover that two functions are actually the same, so remove one of
them. Some of the primitive ring submission operations are also the
same so break these out into __xskq_prod_submit that the upper level
ring access functions can use.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c       | 18 ++++++++---------
 net/xdp/xsk_queue.h | 56 +++++++++++++++++++++++++----------------------------
 2 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9567938..76013f0 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -165,7 +165,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 
 	offset += metalen;
 	addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
-	err = xskq_produce_batch_desc(xs->rx, addr, len);
+	err = xskq_prod_reserve_desc(xs->rx, addr, len);
 	if (!err) {
 		xskq_discard_addr(xs->umem->fq);
 		xdp_return_buff(xdp);
@@ -178,7 +178,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 
 static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
-	int err = xskq_produce_batch_desc(xs->rx, (u64)xdp->handle, len);
+	int err = xskq_prod_reserve_desc(xs->rx, xdp->handle, len);
 
 	if (err)
 		xs->rx_dropped++;
@@ -214,7 +214,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 
 static void xsk_flush(struct xdp_sock *xs)
 {
-	xskq_produce_flush_desc(xs->rx);
+	xskq_prod_submit(xs->rx);
 	xs->sk.sk_data_ready(&xs->sk);
 }
 
@@ -245,12 +245,12 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	memcpy(buffer, xdp->data_meta, len + metalen);
 
 	addr = xsk_umem_adjust_offset(xs->umem, addr, metalen);
-	err = xskq_produce_batch_desc(xs->rx, addr, len);
+	err = xskq_prod_reserve_desc(xs->rx, addr, len);
 	if (err)
 		goto out_drop;
 
 	xskq_discard_addr(xs->umem->fq);
-	xskq_produce_flush_desc(xs->rx);
+	xskq_prod_submit(xs->rx);
 
 	spin_unlock_bh(&xs->rx_lock);
 
@@ -295,7 +295,7 @@ void __xsk_map_flush(struct bpf_map *map)
 
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries)
 {
-	xskq_produce_flush_addr_n(umem->cq, nb_entries);
+	xskq_prod_submit_n(umem->cq, nb_entries);
 }
 EXPORT_SYMBOL(xsk_umem_complete_tx);
 
@@ -320,7 +320,7 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 		if (!xskq_peek_desc(xs->tx, desc, umem))
 			continue;
 
-		if (xskq_produce_addr_lazy(umem->cq, desc->addr))
+		if (xskq_prod_reserve_addr(umem->cq, desc->addr))
 			goto out;
 
 		xskq_discard_desc(xs->tx);
@@ -349,7 +349,7 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	unsigned long flags;
 
 	spin_lock_irqsave(&xs->tx_completion_lock, flags);
-	WARN_ON_ONCE(xskq_produce_addr(xs->umem->cq, addr));
+	xskq_prod_submit_addr(xs->umem->cq, addr);
 	spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
 
 	sock_wfree(skb);
@@ -390,7 +390,7 @@ static int xsk_generic_xmit(struct sock *sk)
 		addr = desc.addr;
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-		if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
+		if (unlikely(err) || xskq_prod_reserve(xs->umem->cq)) {
 			kfree_skb(skb);
 			goto out;
 		}
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index d88e1a0..202d402 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -216,22 +216,17 @@ static inline void xskq_discard_addr(struct xsk_queue *q)
 	q->cons_tail++;
 }
 
-static inline int xskq_produce_addr(struct xsk_queue *q, u64 addr)
+static inline int xskq_prod_reserve(struct xsk_queue *q)
 {
-	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-	unsigned int idx = q->ring->producer;
+	if (xskq_nb_free(q, 1) == 0)
+		return -ENOSPC;
 
 	/* A, matches D */
-	ring->desc[idx++ & q->ring_mask] = addr;
-
-	/* Order producer and data */
-	smp_wmb(); /* B, matches C */
-
-	WRITE_ONCE(q->ring->producer, idx);
+	q->cached_prod++;
 	return 0;
 }
 
-static inline int xskq_produce_addr_lazy(struct xsk_queue *q, u64 addr)
+static inline int xskq_prod_reserve_addr(struct xsk_queue *q, u64 addr)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
 
@@ -243,23 +238,32 @@ static inline int xskq_produce_addr_lazy(struct xsk_queue *q, u64 addr)
 	return 0;
 }
 
-static inline void xskq_produce_flush_addr_n(struct xsk_queue *q,
-					     u32 nb_entries)
+static inline void __xskq_prod_submit(struct xsk_queue *q, u32 idx)
 {
 	/* Order producer and data */
 	smp_wmb(); /* B, matches C */
 
-	WRITE_ONCE(q->ring->producer, q->ring->producer + nb_entries);
+	WRITE_ONCE(q->ring->producer, idx);
 }
 
-static inline int xskq_reserve_addr(struct xsk_queue *q)
+static inline void xskq_prod_submit(struct xsk_queue *q)
 {
-	if (xskq_nb_free(q, 1) == 0)
-		return -ENOSPC;
+	__xskq_prod_submit(q, q->cached_prod);
+}
 
-	/* A, matches D */
-	q->cached_prod++;
-	return 0;
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
 
 /* Rx/Tx queue */
@@ -330,11 +334,11 @@ static inline void xskq_discard_desc(struct xsk_queue *q)
 	q->cons_tail++;
 }
 
-static inline int xskq_produce_batch_desc(struct xsk_queue *q,
-					  u64 addr, u32 len)
+static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
+					 u64 addr, u32 len)
 {
 	struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
-	unsigned int idx;
+	u32 idx;
 
 	if (xskq_nb_free(q, 1) == 0)
 		return -ENOSPC;
@@ -347,14 +351,6 @@ static inline int xskq_produce_batch_desc(struct xsk_queue *q,
 	return 0;
 }
 
-static inline void xskq_produce_flush_desc(struct xsk_queue *q)
-{
-	/* Order producer and data */
-	smp_wmb(); /* B, matches C */
-
-	WRITE_ONCE(q->ring->producer, q->cached_prod);
-}
-
 static inline bool xskq_full_desc(struct xsk_queue *q)
 {
 	return xskq_nb_avail(q, q->nentries) == q->nentries;
-- 
2.7.4

