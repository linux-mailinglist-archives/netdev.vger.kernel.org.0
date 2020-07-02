Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC7621231F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgGBMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:19:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbgGBMTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:19:40 -0400
IronPort-SDR: 58mc8AnfTJiw2rlCJBRUnxYgeKIWNvOSsudeRxv3oUjLjSnqemLotL/6izJoQRKS0AuLgDTFsA
 mT2UoZ92Xh5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486083"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486083"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:19:40 -0700
IronPort-SDR: 9BuRF/NbD/YtGJMORtfLqOLbXkQFb8G3Pn/IfzvELgxqekmGxbzMKpIFT8lmrDtiJd76HmzR5d
 pQKAo3tU31og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933300"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:19:36 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 04/14] xsk: move fill and completion rings to buffer pool
Date:   Thu,  2 Jul 2020 14:19:03 +0200
Message-Id: <1593692353-15102-5-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the fill and completion rings from the umem to the buffer
pool. This so that we in a later commit can share the umem
between multiple HW queue ids. In this case, we need one fill and
completion ring per queue id. As the buffer pool is per queue id
and napi id this is a natural place for it and one umem
struture can be shared between these buffer pools.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h      |  2 --
 include/net/xsk_buff_pool.h |  3 ++-
 net/xdp/xdp_umem.c          | 15 ---------------
 net/xdp/xsk.c               | 40 ++++++++++++++++++++--------------------
 net/xdp/xsk_buff_pool.c     | 20 +++++++++++++++-----
 net/xdp/xsk_diag.c          | 10 ++++++----
 6 files changed, 43 insertions(+), 47 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index b9bb118..2dd3fd9 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -18,8 +18,6 @@ struct xsk_queue;
 struct xdp_buff;
 
 struct xdp_umem {
-	struct xsk_queue *fq;
-	struct xsk_queue *cq;
 	u64 size;
 	u32 headroom;
 	u32 chunk_size;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index cda8ced..f811e25 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -30,6 +30,7 @@ struct xdp_buff_xsk {
 
 struct xsk_buff_pool {
 	struct xsk_queue *fq;
+	struct xsk_queue *cq;
 	struct list_head free_list;
 	dma_addr_t *dma_pages;
 	struct xdp_buff_xsk *heads;
@@ -58,12 +59,12 @@ struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool,
 				     struct xdp_umem *umem);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 		  struct net_device *dev, u16 queue_id, u16 flags);
-void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
 void xp_get_pool(struct xsk_buff_pool *pool);
 void xp_put_pool(struct xsk_buff_pool *pool);
 void xp_clear_dev(struct xsk_buff_pool *pool);
+bool xp_validate_queues(struct xsk_buff_pool *pool);
 
 /* AF_XDP, and XDP core. */
 void xp_free(struct xdp_buff_xsk *xskb);
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index f290345..7d86a63 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -85,16 +85,6 @@ static void xdp_umem_release(struct xdp_umem *umem)
 
 	ida_simple_remove(&umem_ida, umem->id);
 
-	if (umem->fq) {
-		xskq_destroy(umem->fq);
-		umem->fq = NULL;
-	}
-
-	if (umem->cq) {
-		xskq_destroy(umem->cq);
-		umem->cq = NULL;
-	}
-
 	xdp_umem_unpin_pages(umem);
 
 	xdp_umem_unaccount_pages(umem);
@@ -278,8 +268,3 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
 
 	return umem;
 }
-
-bool xdp_umem_validate_queues(struct xdp_umem *umem)
-{
-	return umem->fq && umem->cq;
-}
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b12a832..92f05b0 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -36,7 +36,7 @@ static DEFINE_PER_CPU(struct list_head, xskmap_flush_list);
 bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 {
 	return READ_ONCE(xs->rx) &&  READ_ONCE(xs->umem) &&
-		READ_ONCE(xs->umem->fq);
+		READ_ONCE(xs->pool->fq);
 }
 
 void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
@@ -46,7 +46,7 @@ void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
 	if (umem->need_wakeup & XDP_WAKEUP_RX)
 		return;
 
-	umem->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
+	pool->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
 	umem->need_wakeup |= XDP_WAKEUP_RX;
 }
 EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
@@ -76,7 +76,7 @@ void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
 	if (!(umem->need_wakeup & XDP_WAKEUP_RX))
 		return;
 
-	umem->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
+	pool->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
 	umem->need_wakeup &= ~XDP_WAKEUP_RX;
 }
 EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
@@ -254,7 +254,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp,
 static void xsk_flush(struct xdp_sock *xs)
 {
 	xskq_prod_submit(xs->rx);
-	__xskq_cons_release(xs->umem->fq);
+	__xskq_cons_release(xs->pool->fq);
 	sock_def_readable(&xs->sk);
 }
 
@@ -297,7 +297,7 @@ void __xsk_map_flush(void)
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
 {
-	xskq_prod_submit_n(pool->umem->cq, nb_entries);
+	xskq_prod_submit_n(pool->cq, nb_entries);
 }
 EXPORT_SYMBOL(xsk_tx_completed);
 
@@ -329,7 +329,7 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
-		if (xskq_prod_reserve_addr(umem->cq, desc->addr))
+		if (xskq_prod_reserve_addr(pool->cq, desc->addr))
 			goto out;
 
 		xskq_cons_release(xs->tx);
@@ -367,7 +367,7 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	unsigned long flags;
 
 	spin_lock_irqsave(&xs->tx_completion_lock, flags);
-	xskq_prod_submit_addr(xs->umem->cq, addr);
+	xskq_prod_submit_addr(xs->pool->cq, addr);
 	spin_unlock_irqrestore(&xs->tx_completion_lock, flags);
 
 	sock_wfree(skb);
@@ -411,7 +411,7 @@ static int xsk_generic_xmit(struct sock *sk)
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
-		if (unlikely(err) || xskq_prod_reserve(xs->umem->cq)) {
+		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
 			kfree_skb(skb);
 			goto out;
 		}
@@ -686,6 +686,12 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			goto out_unlock;
 		}
 
+		if (xs->pool->fq || xs->pool->cq) {
+			/* Do not allow setting your own fq or cq. */
+			err = -EINVAL;
+			goto out_unlock;
+		}
+
 		sock = xsk_lookup_xsk_from_fd(sxdp->sxdp_shared_umem_fd);
 		if (IS_ERR(sock)) {
 			err = PTR_ERR(sock);
@@ -712,7 +718,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		xdp_get_umem(umem_xs->umem);
 		WRITE_ONCE(xs->umem, umem_xs->umem);
 		sockfd_put(sock);
-	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
+	} else if (!xs->umem || !xp_validate_queues(xs->pool)) {
 		err = -EINVAL;
 		goto out_unlock;
 	} else {
@@ -850,11 +856,9 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EINVAL;
 		}
 
-		q = (optname == XDP_UMEM_FILL_RING) ? &xs->umem->fq :
-			&xs->umem->cq;
+		q = (optname == XDP_UMEM_FILL_RING) ? &xs->pool->fq :
+			&xs->pool->cq;
 		err = xsk_init_queue(entries, q, true);
-		if (optname == XDP_UMEM_FILL_RING)
-			xp_set_fq(xs->pool, *q);
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
@@ -1000,8 +1004,8 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	loff_t offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long size = vma->vm_end - vma->vm_start;
 	struct xdp_sock *xs = xdp_sk(sock->sk);
+	struct xsk_buff_pool *pool = xs->pool;
 	struct xsk_queue *q = NULL;
-	struct xdp_umem *umem;
 	unsigned long pfn;
 	struct page *qpg;
 
@@ -1013,16 +1017,12 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	} else if (offset == XDP_PGOFF_TX_RING) {
 		q = READ_ONCE(xs->tx);
 	} else {
-		umem = READ_ONCE(xs->umem);
-		if (!umem)
-			return -EINVAL;
-
 		/* Matches the smp_wmb() in XDP_UMEM_REG */
 		smp_rmb();
 		if (offset == XDP_UMEM_PGOFF_FILL_RING)
-			q = READ_ONCE(umem->fq);
+			q = READ_ONCE(pool->fq);
 		else if (offset == XDP_UMEM_PGOFF_COMPLETION_RING)
-			q = READ_ONCE(umem->cq);
+			q = READ_ONCE(pool->cq);
 	}
 
 	if (!q)
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index da93b36..6a6e0d5 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -89,11 +89,6 @@ struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool_old,
 	return NULL;
 }
 
-void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq)
-{
-	pool->fq = fq;
-}
-
 void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
 {
 	u32 i;
@@ -197,6 +192,16 @@ static void xp_release_deferred(struct work_struct *work)
 	xp_clear_dev(pool);
 	rtnl_unlock();
 
+	if (pool->fq) {
+		xskq_destroy(pool->fq);
+		pool->fq = NULL;
+	}
+
+	if (pool->cq) {
+		xskq_destroy(pool->cq);
+		pool->cq = NULL;
+	}
+
 	xdp_put_umem(pool->umem);
 	xp_destroy(pool);
 }
@@ -217,6 +222,11 @@ void xp_put_pool(struct xsk_buff_pool *pool)
 	}
 }
 
+bool xp_validate_queues(struct xsk_buff_pool *pool)
+{
+	return pool->fq && pool->cq;
+}
+
 void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 {
 	dma_addr_t *dma;
diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index 0163b26..1936423 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -46,6 +46,7 @@ static int xsk_diag_put_rings_cfg(const struct xdp_sock *xs,
 
 static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
 {
+	struct xsk_buff_pool *pool = xs->pool;
 	struct xdp_umem *umem = xs->umem;
 	struct xdp_diag_umem du = {};
 	int err;
@@ -67,10 +68,11 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
 
 	err = nla_put(nlskb, XDP_DIAG_UMEM, sizeof(du), &du);
 
-	if (!err && umem->fq)
-		err = xsk_diag_put_ring(umem->fq, XDP_DIAG_UMEM_FILL_RING, nlskb);
-	if (!err && umem->cq) {
-		err = xsk_diag_put_ring(umem->cq, XDP_DIAG_UMEM_COMPLETION_RING,
+	if (!err && pool->fq)
+		err = xsk_diag_put_ring(pool->fq,
+					XDP_DIAG_UMEM_FILL_RING, nlskb);
+	if (!err && pool->cq) {
+		err = xsk_diag_put_ring(pool->cq, XDP_DIAG_UMEM_COMPLETION_RING,
 					nlskb);
 	}
 	return err;
-- 
2.7.4

