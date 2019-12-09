Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E071167BE
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfLIH4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:56:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:35290 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfLIH4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:56:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:56:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846873"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:56:48 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 02/12] xsk: consolidate to one single cached producer pointer
Date:   Mon,  9 Dec 2019 08:56:19 +0100
Message-Id: <1575878189-31860-3-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the xsk ring code has two cached producer pointers:
prod_head and prod_tail. This patch consolidates these two into a
single one called cached_prod to make the code simpler and easier to
maintain. This will be in line with the user space part of the the
code found in libbpf, that only uses a single cached pointer.

The Rx path only uses the two top level functions
xskq_produce_batch_desc and xskq_produce_flush_desc and they both use
prod_head and never prod_tail. So just move them over to
cached_prod.

The Tx XDP_DRV path uses xskq_produce_addr_lazy and
xskq_produce_flush_addr_n and unnecessarily operates on both prod_tail
and prod_cons, so move them over to just use cached_prod by skipping
the intermediate step of updating prod_tail.

The Tx path in XDP_SKB mode uses xskq_reserve_addr and
xskq_produce_addr. They currently use both cached pointers, but we can
operate on the global producer pointer in xskq_produce_addr since it
has to be updated anyway, thus eliminating the use of both cached
pointers. We can also remove the xskq_nb_free in xskq_produce_addr
since it is already called in xskq_reserve_addr. No need to do it
twice.

When there is only one cached producer pointer, we can also simplify
xskq_nb_free by removing one argument.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_queue.h | 49 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index a2f0ba6..d88e1a0 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -35,8 +35,7 @@ struct xsk_queue {
 	u64 size;
 	u32 ring_mask;
 	u32 nentries;
-	u32 prod_head;
-	u32 prod_tail;
+	u32 cached_prod;
 	u32 cons_head;
 	u32 cons_tail;
 	struct xdp_ring *ring;
@@ -94,39 +93,39 @@ static inline u64 xskq_nb_invalid_descs(struct xsk_queue *q)
 
 static inline u32 xskq_nb_avail(struct xsk_queue *q, u32 dcnt)
 {
-	u32 entries = q->prod_tail - q->cons_tail;
+	u32 entries = q->cached_prod - q->cons_tail;
 
 	if (entries == 0) {
 		/* Refresh the local pointer */
-		q->prod_tail = READ_ONCE(q->ring->producer);
-		entries = q->prod_tail - q->cons_tail;
+		q->cached_prod = READ_ONCE(q->ring->producer);
+		entries = q->cached_prod - q->cons_tail;
 	}
 
 	return (entries > dcnt) ? dcnt : entries;
 }
 
-static inline u32 xskq_nb_free(struct xsk_queue *q, u32 producer, u32 dcnt)
+static inline u32 xskq_nb_free(struct xsk_queue *q, u32 dcnt)
 {
-	u32 free_entries = q->nentries - (producer - q->cons_tail);
+	u32 free_entries = q->nentries - (q->cached_prod - q->cons_tail);
 
 	if (free_entries >= dcnt)
 		return free_entries;
 
 	/* Refresh the local tail pointer */
 	q->cons_tail = READ_ONCE(q->ring->consumer);
-	return q->nentries - (producer - q->cons_tail);
+	return q->nentries - (q->cached_prod - q->cons_tail);
 }
 
 static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
 {
-	u32 entries = q->prod_tail - q->cons_tail;
+	u32 entries = q->cached_prod - q->cons_tail;
 
 	if (entries >= cnt)
 		return true;
 
 	/* Refresh the local pointer. */
-	q->prod_tail = READ_ONCE(q->ring->producer);
-	entries = q->prod_tail - q->cons_tail;
+	q->cached_prod = READ_ONCE(q->ring->producer);
+	entries = q->cached_prod - q->cons_tail;
 
 	return entries >= cnt;
 }
@@ -220,17 +219,15 @@ static inline void xskq_discard_addr(struct xsk_queue *q)
 static inline int xskq_produce_addr(struct xsk_queue *q, u64 addr)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
-
-	if (xskq_nb_free(q, q->prod_tail, 1) == 0)
-		return -ENOSPC;
+	unsigned int idx = q->ring->producer;
 
 	/* A, matches D */
-	ring->desc[q->prod_tail++ & q->ring_mask] = addr;
+	ring->desc[idx++ & q->ring_mask] = addr;
 
 	/* Order producer and data */
 	smp_wmb(); /* B, matches C */
 
-	WRITE_ONCE(q->ring->producer, q->prod_tail);
+	WRITE_ONCE(q->ring->producer, idx);
 	return 0;
 }
 
@@ -238,11 +235,11 @@ static inline int xskq_produce_addr_lazy(struct xsk_queue *q, u64 addr)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
 
-	if (xskq_nb_free(q, q->prod_head, 1) == 0)
+	if (xskq_nb_free(q, 1) == 0)
 		return -ENOSPC;
 
 	/* A, matches D */
-	ring->desc[q->prod_head++ & q->ring_mask] = addr;
+	ring->desc[q->cached_prod++ & q->ring_mask] = addr;
 	return 0;
 }
 
@@ -252,17 +249,16 @@ static inline void xskq_produce_flush_addr_n(struct xsk_queue *q,
 	/* Order producer and data */
 	smp_wmb(); /* B, matches C */
 
-	q->prod_tail += nb_entries;
-	WRITE_ONCE(q->ring->producer, q->prod_tail);
+	WRITE_ONCE(q->ring->producer, q->ring->producer + nb_entries);
 }
 
 static inline int xskq_reserve_addr(struct xsk_queue *q)
 {
-	if (xskq_nb_free(q, q->prod_head, 1) == 0)
+	if (xskq_nb_free(q, 1) == 0)
 		return -ENOSPC;
 
 	/* A, matches D */
-	q->prod_head++;
+	q->cached_prod++;
 	return 0;
 }
 
@@ -340,11 +336,11 @@ static inline int xskq_produce_batch_desc(struct xsk_queue *q,
 	struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 	unsigned int idx;
 
-	if (xskq_nb_free(q, q->prod_head, 1) == 0)
+	if (xskq_nb_free(q, 1) == 0)
 		return -ENOSPC;
 
 	/* A, matches D */
-	idx = (q->prod_head++) & q->ring_mask;
+	idx = q->cached_prod++ & q->ring_mask;
 	ring->desc[idx].addr = addr;
 	ring->desc[idx].len = len;
 
@@ -356,8 +352,7 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
 	/* Order producer and data */
 	smp_wmb(); /* B, matches C */
 
-	q->prod_tail = q->prod_head;
-	WRITE_ONCE(q->ring->producer, q->prod_tail);
+	WRITE_ONCE(q->ring->producer, q->cached_prod);
 }
 
 static inline bool xskq_full_desc(struct xsk_queue *q)
@@ -367,7 +362,7 @@ static inline bool xskq_full_desc(struct xsk_queue *q)
 
 static inline bool xskq_empty_desc(struct xsk_queue *q)
 {
-	return xskq_nb_free(q, q->prod_tail, q->nentries) == q->nentries;
+	return xskq_nb_free(q, q->nentries) == q->nentries;
 }
 
 void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
-- 
2.7.4

