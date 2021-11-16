Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0E452BA9
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhKPHlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230356AbhKPHlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099075"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099075"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857354"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:37 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [RFC PATCH bpf-next 5/8] xsk: implement a batched version of xsk_rcv
Date:   Tue, 16 Nov 2021 07:37:39 +0000
Message-Id: <20211116073742.7941-6-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a batched version of xsk_rcv called xsk_rcv_batch which takes
an array of xdp_buffs and pushes them to the Rx ring. Also introduce a
batched version of xsk_buff_dma_sync_for_cpu.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 include/net/xdp_sock_drv.h  | 28 ++++++++++++++++++++++++++++
 include/net/xsk_buff_pool.h | 22 ++++++++++++++++++++++
 net/xdp/xsk.c               | 29 +++++++++++++++++++++++++++++
 net/xdp/xsk_queue.h         | 31 +++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index e923f5d1adb6..0b352d7a34af 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -23,6 +23,7 @@ void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool);
 void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool);
 bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool);
 int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
+int xsk_rcv_batch(struct xdp_sock *xs, struct xdp_buff **bufs, int batch_size);
 void xsk_flush(struct xdp_sock *xs);
 
 static inline u32 xsk_pool_get_headroom(struct xsk_buff_pool *pool)
@@ -125,6 +126,22 @@ static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp, struct xsk_bu
 	xp_dma_sync_for_cpu(xskb);
 }
 
+static inline void xsk_buff_dma_sync_for_cpu_batch(struct xdp_buff **bufs,
+						   struct xsk_buff_pool *pool,
+						   int batch_size)
+{
+	struct xdp_buff_xsk *xskb;
+	int i;
+
+	if (!pool->dma_need_sync)
+		return;
+
+	for (i = 0; i < batch_size; i++) {
+		xskb = container_of(*(bufs + i), struct xdp_buff_xsk, xdp);
+		xp_dma_sync_for_cpu(xskb);
+	}
+}
+
 static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 						    dma_addr_t dma,
 						    size_t size)
@@ -191,6 +208,11 @@ static inline int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return 0;
 }
 
+static inline int xsk_rcv_batch(struct xdp_sock *xs, struct xdp_buff **bufs, int batch_size)
+{
+	return 0;
+}
+
 static inline void xsk_flush(struct xdp_sock *xs)
 {
 }
@@ -274,6 +296,12 @@ static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp, struct xsk_bu
 {
 }
 
+static inline void xsk_buff_dma_sync_for_cpu_batch(struct xdp_buff **bufs,
+						   struct xsk_buff_pool *pool,
+						   int batch_size)
+{
+}
+
 static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 						    dma_addr_t dma,
 						    size_t size)
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index ddeefc4a1040..f6d76c7eaf6b 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -214,6 +214,28 @@ static inline void xp_release(struct xdp_buff_xsk *xskb)
 		xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
 }
 
+/* Release a batch of xdp_buffs back to an xdp_buff_pool.
+ * The batch of buffs must all come from the same xdp_buff_pool. This way
+ * it is safe to push the batch to the top of the free_heads stack, because
+ * at least the same amount will have been popped from the stack earlier in
+ * the datapath.
+ */
+static inline void xp_release_batch(struct xdp_buff **bufs, int batch_size)
+{
+	struct xdp_buff_xsk *xskb = container_of(*bufs, struct xdp_buff_xsk, xdp);
+	struct xsk_buff_pool *pool = xskb->pool;
+	u32 tail = pool->free_heads_cnt;
+	u32 i;
+
+	if (pool->unaligned) {
+		for (i = 0; i < batch_size; i++) {
+			xskb = container_of(*(bufs + i), struct xdp_buff_xsk, xdp);
+			pool->free_heads[tail + i] = xskb;
+		}
+		pool->free_heads_cnt += batch_size;
+	}
+}
+
 static inline u64 xp_get_handle(struct xdp_buff_xsk *xskb)
 {
 	u64 offset = xskb->xdp.data - xskb->xdp.data_hard_start;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index ce004f5fae64..22d00173a96f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -151,6 +151,20 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	return 0;
 }
 
+static int __xsk_rcv_zc_batch(struct xdp_sock *xs, struct xdp_buff **bufs, int batch_size)
+{
+	int err;
+
+	err = xskq_prod_reserve_desc_batch(xs->rx, bufs, batch_size);
+	if (err) {
+		xs->rx_queue_full++;
+		return -1;
+	}
+
+	xp_release_batch(bufs, batch_size);
+	return 0;
+}
+
 static void xsk_copy_xdp(struct xdp_buff *to, struct xdp_buff *from, u32 len)
 {
 	void *from_buf, *to_buf;
@@ -269,6 +283,21 @@ int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 }
 EXPORT_SYMBOL(xsk_rcv);
 
+int xsk_rcv_batch(struct xdp_sock *xs, struct xdp_buff **bufs, int batch_size)
+{
+	int err;
+
+	err = xsk_rcv_check(xs, *bufs);
+	if (err)
+		return err;
+
+	if ((*bufs)->rxq->mem.type != MEM_TYPE_XSK_BUFF_POOL)
+		return -1;
+
+	return __xsk_rcv_zc_batch(xs, bufs, batch_size);
+}
+EXPORT_SYMBOL(xsk_rcv_batch);
+
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	struct list_head *flush_list = this_cpu_ptr(&xskmap_flush_list);
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index e9aa2c236356..3be9f4a01d77 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -338,6 +338,11 @@ static inline bool xskq_prod_is_full(struct xsk_queue *q)
 	return xskq_prod_nb_free(q, 1) ? false : true;
 }
 
+static inline bool xskq_prod_is_full_n(struct xsk_queue *q, u32 n)
+{
+	return xskq_prod_nb_free(q, n) ? false : true;
+}
+
 static inline void xskq_prod_cancel(struct xsk_queue *q)
 {
 	q->cached_prod--;
@@ -399,6 +404,32 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 	return 0;
 }
 
+static inline int xskq_prod_reserve_desc_batch(struct xsk_queue *q, struct xdp_buff **bufs,
+					       int batch_size)
+{
+	struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
+	struct xdp_buff_xsk *xskb;
+	u64 addr;
+	u32 len;
+	u32 i;
+
+	if (xskq_prod_is_full_n(q, batch_size))
+		return -ENOSPC;
+
+	/* A, matches D */
+	for (i = 0; i < batch_size; i++) {
+		len = (*(bufs + i))->data_end - (*(bufs + i))->data;
+		xskb = container_of(*(bufs + i), struct xdp_buff_xsk, xdp);
+		addr = xp_get_handle(xskb);
+		ring->desc[(q->cached_prod + i) & q->ring_mask].addr = addr;
+		ring->desc[(q->cached_prod + i) & q->ring_mask].len = len;
+	}
+
+	q->cached_prod += batch_size;
+
+	return 0;
+}
+
 static inline void __xskq_prod_submit(struct xsk_queue *q, u32 idx)
 {
 	smp_store_release(&q->ring->producer, idx); /* B, matches C */
-- 
2.17.1

