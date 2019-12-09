Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7121167CA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfLIH5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:57:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:35353 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbfLIH5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:57:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:57:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846937"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:57:08 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 08/12] xsk: change names of validation functions
Date:   Mon,  9 Dec 2019 08:56:25 +0100
Message-Id: <1575878189-31860-9-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the names of the validation functions to better reflect what
they are doing. The uppermost ones are reading entries from the rings
and only the bottom ones validate entries. So xskq_cons_read_ is a
better prefix name.

Also change the xskq_cons_read_ functions to return a bool
as the the descriptor or address is already returned by reference
in the parameters. Everyone is using the return value as a bool
anyway.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h |  4 ++--
 net/xdp/xsk.c          |  4 ++--
 net/xdp/xsk_queue.h    | 59 ++++++++++++++++++++++++++------------------------
 3 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e3780e4..0742aa9 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -119,7 +119,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
 bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
 /* Used from netdev driver */
 bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
-u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
+bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
 void xsk_umem_discard_addr(struct xdp_umem *umem);
 void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
 bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
@@ -199,7 +199,7 @@ static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
 	return xsk_umem_has_addrs(umem, cnt - rq->length);
 }
 
-static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
+static inline bool xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
 {
 	struct xdp_umem_fq_reuse *rq = umem->fq_reuse;
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index fb13b64..62e27a4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -43,7 +43,7 @@ bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
 }
 EXPORT_SYMBOL(xsk_umem_has_addrs);
 
-u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
+bool xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
 {
 	return xskq_cons_peek_addr(umem->fq, addr, umem);
 }
@@ -124,7 +124,7 @@ static void __xsk_rcv_memcpy(struct xdp_umem *umem, u64 addr, void *from_buf,
 	void *to_buf = xdp_umem_get_data(umem, addr);
 
 	addr = xsk_umem_add_offset_to_addr(addr);
-	if (xskq_crosses_non_contig_pg(umem, addr, len + metalen)) {
+	if (xskq_cons_crosses_non_contig_pg(umem, addr, len + metalen)) {
 		void *next_pg_addr = umem->pages[(addr >> PAGE_SHIFT) + 1].addr;
 		u64 page_start = addr & ~(PAGE_SIZE - 1);
 		u64 first_len = PAGE_SIZE - (addr - page_start);
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 588bdc5..7566f64 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -136,8 +136,9 @@ static inline bool xskq_cons_has_entries(struct xsk_queue *q, u32 cnt)
 
 /* UMEM queue */
 
-static inline bool xskq_crosses_non_contig_pg(struct xdp_umem *umem, u64 addr,
-					      u64 length)
+static inline bool xskq_cons_crosses_non_contig_pg(struct xdp_umem *umem,
+						   u64 addr,
+						   u64 length)
 {
 	bool cross_pg = (addr & (PAGE_SIZE - 1)) + length > PAGE_SIZE;
 	bool next_pg_contig =
@@ -147,7 +148,7 @@ static inline bool xskq_crosses_non_contig_pg(struct xdp_umem *umem, u64 addr,
 	return cross_pg && !next_pg_contig;
 }
 
-static inline bool xskq_is_valid_addr(struct xsk_queue *q, u64 addr)
+static inline bool xskq_cons_is_valid_addr(struct xsk_queue *q, u64 addr)
 {
 	if (addr >= q->size) {
 		q->invalid_descs++;
@@ -157,7 +158,8 @@ static inline bool xskq_is_valid_addr(struct xsk_queue *q, u64 addr)
 	return true;
 }
 
-static inline bool xskq_is_valid_addr_unaligned(struct xsk_queue *q, u64 addr,
+static inline bool xskq_cons_is_valid_unaligned(struct xsk_queue *q,
+						u64 addr,
 						u64 length,
 						struct xdp_umem *umem)
 {
@@ -165,7 +167,7 @@ static inline bool xskq_is_valid_addr_unaligned(struct xsk_queue *q, u64 addr,
 
 	addr = xsk_umem_add_offset_to_addr(addr);
 	if (base_addr >= q->size || addr >= q->size ||
-	    xskq_crosses_non_contig_pg(umem, addr, length)) {
+	    xskq_cons_crosses_non_contig_pg(umem, addr, length)) {
 		q->invalid_descs++;
 		return false;
 	}
@@ -173,8 +175,8 @@ static inline bool xskq_is_valid_addr_unaligned(struct xsk_queue *q, u64 addr,
 	return true;
 }
 
-static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr,
-				      struct xdp_umem *umem)
+static inline bool xskq_cons_read_addr(struct xsk_queue *q, u64 *addr,
+				       struct xdp_umem *umem)
 {
 	struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
 
@@ -184,29 +186,29 @@ static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr,
 		*addr = READ_ONCE(ring->desc[idx]) & q->chunk_mask;
 
 		if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG) {
-			if (xskq_is_valid_addr_unaligned(q, *addr,
+			if (xskq_cons_is_valid_unaligned(q, *addr,
 							 umem->chunk_size_nohr,
 							 umem))
-				return addr;
+				return true;
 			goto out;
 		}
 
-		if (xskq_is_valid_addr(q, *addr))
-			return addr;
+		if (xskq_cons_is_valid_addr(q, *addr))
+			return true;
 
 out:
 		q->cached_cons++;
 	}
 
-	return NULL;
+	return false;
 }
 
-static inline u64 *xskq_cons_peek_addr(struct xsk_queue *q, u64 *addr,
+static inline bool xskq_cons_peek_addr(struct xsk_queue *q, u64 *addr,
 				       struct xdp_umem *umem)
 {
 	if (q->cached_prod == q->cached_cons)
 		xskq_cons_get_entries(q);
-	return xskq_validate_addr(q, addr, umem);
+	return xskq_cons_read_addr(q, addr, umem);
 }
 
 static inline void xskq_cons_release(struct xsk_queue *q)
@@ -270,11 +272,12 @@ static inline void xskq_prod_submit_n(struct xsk_queue *q, u32 nb_entries)
 
 /* Rx/Tx queue */
 
-static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct xdp_desc *d,
-				      struct xdp_umem *umem)
+static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
+					   struct xdp_desc *d,
+					   struct xdp_umem *umem)
 {
 	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG) {
-		if (!xskq_is_valid_addr_unaligned(q, d->addr, d->len, umem))
+		if (!xskq_cons_is_valid_unaligned(q, d->addr, d->len, umem))
 			return false;
 
 		if (d->len > umem->chunk_size_nohr || d->options) {
@@ -285,7 +288,7 @@ static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct xdp_desc *d,
 		return true;
 	}
 
-	if (!xskq_is_valid_addr(q, d->addr))
+	if (!xskq_cons_is_valid_addr(q, d->addr))
 		return false;
 
 	if (((d->addr + d->len) & q->chunk_mask) != (d->addr & q->chunk_mask) ||
@@ -297,31 +300,31 @@ static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct xdp_desc *d,
 	return true;
 }
 
-static inline struct xdp_desc *xskq_validate_desc(struct xsk_queue *q,
-						  struct xdp_desc *desc,
-						  struct xdp_umem *umem)
+static inline bool xskq_cons_read_desc(struct xsk_queue *q,
+				       struct xdp_desc *desc,
+				       struct xdp_umem *umem)
 {
 	while (q->cached_cons != q->cached_prod) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 		u32 idx = q->cached_cons & q->ring_mask;
 
 		*desc = READ_ONCE(ring->desc[idx]);
-		if (xskq_is_valid_desc(q, desc, umem))
-			return desc;
+		if (xskq_cons_is_valid_desc(q, desc, umem))
+			return true;
 
 		q->cached_cons++;
 	}
 
-	return NULL;
+	return false;
 }
 
-static inline struct xdp_desc *xskq_cons_peek_desc(struct xsk_queue *q,
-						   struct xdp_desc *desc,
-						   struct xdp_umem *umem)
+static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
+				       struct xdp_desc *desc,
+				       struct xdp_umem *umem)
 {
 	if (q->cached_prod == q->cached_cons)
 		xskq_cons_get_entries(q);
-	return xskq_validate_desc(q, desc, umem);
+	return xskq_cons_read_desc(q, desc, umem);
 }
 
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
-- 
2.7.4

