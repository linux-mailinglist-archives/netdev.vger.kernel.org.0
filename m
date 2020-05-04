Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DEF1C3B56
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgEDNeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:34:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:32040 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgEDNeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:34:03 -0400
IronPort-SDR: U0Stp25lUyl3b++tsS2pc+p3EAzjKgW9j2MdgfRiOPUv5FxBoIr9wjOANoJW7jm4GUDxJTk1Ui
 n9+U8u2pnZtg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 06:34:03 -0700
IronPort-SDR: on9NE+S3PUAOcn/Iokg0CQl3RkwUJ6OenhmrgPamQ+PvEH+7eWbr1bLPO/uJHW4mx7wOYGKYG0
 OHRUW9w+exVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="406478271"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.47.50])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2020 06:34:01 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 1/2] xsk: change two variable names for increased clarity
Date:   Mon,  4 May 2020 15:33:51 +0200
Message-Id: <1588599232-24897-2-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
References: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change two variables names so that it is clearer what they
represent. The first one is xsk_list that in fact only contains the
list of AF_XDP sockets with a Tx component. Change this to xsk_tx_list
for improved clarity. The second variable is size in the ring
structure. One might think that this is the size of the ring, but it
is in fact the size of the umem, copied into the ring structure to
improve performance. Rename this variable umem_size to avoid any
confusion.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h |  4 ++--
 net/xdp/xdp_umem.c     | 14 +++++++-------
 net/xdp/xsk.c          |  8 ++++----
 net/xdp/xsk_queue.c    |  4 ++--
 net/xdp/xsk_queue.h    |  8 ++++----
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e86ec48..b72f1f4 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -62,8 +62,8 @@ struct xdp_umem {
 	struct net_device *dev;
 	struct xdp_umem_fq_reuse *fq_reuse;
 	bool zc;
-	spinlock_t xsk_list_lock;
-	struct list_head xsk_list;
+	spinlock_t xsk_tx_list_lock;
+	struct list_head xsk_tx_list;
 };
 
 /* Nodes are linked in the struct xdp_sock map_list field, and used to
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index ed7a606..7211f45 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -30,9 +30,9 @@ void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 	if (!xs->tx)
 		return;
 
-	spin_lock_irqsave(&umem->xsk_list_lock, flags);
-	list_add_rcu(&xs->list, &umem->xsk_list);
-	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
+	spin_lock_irqsave(&umem->xsk_tx_list_lock, flags);
+	list_add_rcu(&xs->list, &umem->xsk_tx_list);
+	spin_unlock_irqrestore(&umem->xsk_tx_list_lock, flags);
 }
 
 void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
@@ -42,9 +42,9 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 	if (!xs->tx)
 		return;
 
-	spin_lock_irqsave(&umem->xsk_list_lock, flags);
+	spin_lock_irqsave(&umem->xsk_tx_list_lock, flags);
 	list_del_rcu(&xs->list);
-	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
+	spin_unlock_irqrestore(&umem->xsk_tx_list_lock, flags);
 }
 
 /* The umem is stored both in the _rx struct and the _tx struct as we do
@@ -395,8 +395,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->pgs = NULL;
 	umem->user = NULL;
 	umem->flags = mr->flags;
-	INIT_LIST_HEAD(&umem->xsk_list);
-	spin_lock_init(&umem->xsk_list_lock);
+	INIT_LIST_HEAD(&umem->xsk_tx_list);
+	spin_lock_init(&umem->xsk_tx_list_lock);
 
 	refcount_set(&umem->users, 1);
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f6e6609..45ffd67 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -75,7 +75,7 @@ void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
 		return;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
+	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
 		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
 	}
 	rcu_read_unlock();
@@ -102,7 +102,7 @@ void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
 		return;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
+	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
 		xs->tx->ring->flags &= ~XDP_RING_NEED_WAKEUP;
 	}
 	rcu_read_unlock();
@@ -305,7 +305,7 @@ void xsk_umem_consume_tx_done(struct xdp_umem *umem)
 	struct xdp_sock *xs;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
+	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
 		__xskq_cons_release(xs->tx);
 		xs->sk.sk_write_space(&xs->sk);
 	}
@@ -318,7 +318,7 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 	struct xdp_sock *xs;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
+	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
 		if (!xskq_cons_peek_desc(xs->tx, desc, umem))
 			continue;
 
diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
index c90e9c1..57fb81b 100644
--- a/net/xdp/xsk_queue.c
+++ b/net/xdp/xsk_queue.c
@@ -9,12 +9,12 @@
 
 #include "xsk_queue.h"
 
-void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask)
+void xskq_set_umem(struct xsk_queue *q, u64 umem_size, u64 chunk_mask)
 {
 	if (!q)
 		return;
 
-	q->size = size;
+	q->umem_size = umem_size;
 	q->chunk_mask = chunk_mask;
 }
 
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index b50bb5c..648733ec 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -30,7 +30,7 @@ struct xdp_umem_ring {
 
 struct xsk_queue {
 	u64 chunk_mask;
-	u64 size;
+	u64 umem_size;
 	u32 ring_mask;
 	u32 nentries;
 	u32 cached_prod;
@@ -123,7 +123,7 @@ static inline bool xskq_cons_is_valid_unaligned(struct xsk_queue *q,
 	u64 base_addr = xsk_umem_extract_addr(addr);
 
 	addr = xsk_umem_add_offset_to_addr(addr);
-	if (base_addr >= q->size || addr >= q->size ||
+	if (base_addr >= q->umem_size || addr >= q->umem_size ||
 	    xskq_cons_crosses_non_contig_pg(umem, addr, length)) {
 		q->invalid_descs++;
 		return false;
@@ -134,7 +134,7 @@ static inline bool xskq_cons_is_valid_unaligned(struct xsk_queue *q,
 
 static inline bool xskq_cons_is_valid_addr(struct xsk_queue *q, u64 addr)
 {
-	if (addr >= q->size) {
+	if (addr >= q->umem_size) {
 		q->invalid_descs++;
 		return false;
 	}
@@ -379,7 +379,7 @@ static inline u64 xskq_nb_invalid_descs(struct xsk_queue *q)
 	return q ? q->invalid_descs : 0;
 }
 
-void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
+void xskq_set_umem(struct xsk_queue *q, u64 umem_size, u64 chunk_mask);
 struct xsk_queue *xskq_create(u32 nentries, bool umem_queue);
 void xskq_destroy(struct xsk_queue *q_ops);
 
-- 
2.7.4

