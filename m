Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E252255669
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgH1I1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:27:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:23538 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgH1I1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:27:25 -0400
IronPort-SDR: XrmYvH6TsumdpPzfL+tjcMFWHdSfsc7Mogci2cQfrC+sbCNlCf58Cc8QzDHrCKDu7SLGA29pEK
 XCXJl6f9qfJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156633981"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156633981"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:26:59 -0700
IronPort-SDR: XsKcdkwh6gs/qouyqZGbSCchiRMxXFB+7JMGIM/I1jM+kioFWz8bnUGNU9sn1K5Wqn1CG+HTz4
 dogxYMi4OoIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762629"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:26:55 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 05/15] xsk: move queue_id, dev and need_wakeup to buffer pool
Date:   Fri, 28 Aug 2020 10:26:19 +0200
Message-Id: <1598603189-32145-6-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move queue_id, dev, and need_wakeup from the umem to the
buffer pool. This so that we in a later commit can share the umem
between multiple HW queues. There is one buffer pool per dev and
queue id, so these variables should belong to the buffer pool, not
the umem. Need_wakeup is also something that is set on a per napi
level, so there is usually one per device and queue id. So move
this to the buffer pool too.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h      |  3 ---
 include/net/xsk_buff_pool.h |  4 ++++
 net/xdp/xdp_umem.c          | 22 ++--------------------
 net/xdp/xdp_umem.h          |  4 ----
 net/xdp/xsk.c               | 34 +++++++++++++---------------------
 net/xdp/xsk.h               |  7 -------
 net/xdp/xsk_buff_pool.c     | 39 ++++++++++++++++++++++-----------------
 net/xdp/xsk_diag.c          |  4 ++--
 8 files changed, 43 insertions(+), 74 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 2a284e1..b052f1c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -26,11 +26,8 @@ struct xdp_umem {
 	refcount_t users;
 	struct page **pgs;
 	u32 npgs;
-	u16 queue_id;
-	u8 need_wakeup;
 	u8 flags;
 	int id;
-	struct net_device *dev;
 	bool zc;
 	spinlock_t xsk_tx_list_lock;
 	struct list_head xsk_tx_list;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 380d9ae..2d94890 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -43,11 +43,15 @@ struct xsk_buff_pool {
 	u32 headroom;
 	u32 chunk_size;
 	u32 frame_len;
+	u16 queue_id;
+	u8 cached_need_wakeup;
+	bool uses_need_wakeup;
 	bool dma_need_sync;
 	bool unaligned;
 	struct xdp_umem *umem;
 	void *addrs;
 	struct device *dev;
+	struct net_device *netdev;
 	refcount_t users;
 	struct work_struct work;
 	struct xdp_buff_xsk *free_heads[];
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 7d86a63..3e612fc 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -63,26 +63,9 @@ static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
 	}
 }
 
-void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
-			 u16 queue_id)
-{
-	umem->dev = dev;
-	umem->queue_id = queue_id;
-
-	dev_hold(dev);
-}
-
-void xdp_umem_clear_dev(struct xdp_umem *umem)
-{
-	dev_put(umem->dev);
-	umem->dev = NULL;
-	umem->zc = false;
-}
-
 static void xdp_umem_release(struct xdp_umem *umem)
 {
-	xdp_umem_clear_dev(umem);
-
+	umem->zc = false;
 	ida_simple_remove(&umem_ida, umem->id);
 
 	xdp_umem_unpin_pages(umem);
@@ -181,8 +164,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 		return -EINVAL;
 	}
 
-	if (mr->flags & ~(XDP_UMEM_UNALIGNED_CHUNK_FLAG |
-			XDP_UMEM_USES_NEED_WAKEUP))
+	if (mr->flags & ~XDP_UMEM_UNALIGNED_CHUNK_FLAG)
 		return -EINVAL;
 
 	if (!unaligned_chunks && !is_power_of_2(chunk_size))
diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
index 93e96be..67bf3f3 100644
--- a/net/xdp/xdp_umem.h
+++ b/net/xdp/xdp_umem.h
@@ -8,10 +8,6 @@
 
 #include <net/xdp_sock_drv.h>
 
-void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
-			 u16 queue_id);
-void xdp_umem_clear_dev(struct xdp_umem *umem);
-bool xdp_umem_validate_queues(struct xdp_umem *umem);
 void xdp_get_umem(struct xdp_umem *umem);
 void xdp_put_umem(struct xdp_umem *umem);
 void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index dacd340..9f1b906e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -41,13 +41,11 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 
 void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
 {
-	struct xdp_umem *umem = pool->umem;
-
-	if (umem->need_wakeup & XDP_WAKEUP_RX)
+	if (pool->cached_need_wakeup & XDP_WAKEUP_RX)
 		return;
 
 	pool->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
-	umem->need_wakeup |= XDP_WAKEUP_RX;
+	pool->cached_need_wakeup |= XDP_WAKEUP_RX;
 }
 EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
 
@@ -56,7 +54,7 @@ void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
 	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
-	if (umem->need_wakeup & XDP_WAKEUP_TX)
+	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
 		return;
 
 	rcu_read_lock();
@@ -65,19 +63,17 @@ void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
 	}
 	rcu_read_unlock();
 
-	umem->need_wakeup |= XDP_WAKEUP_TX;
+	pool->cached_need_wakeup |= XDP_WAKEUP_TX;
 }
 EXPORT_SYMBOL(xsk_set_tx_need_wakeup);
 
 void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool)
 {
-	struct xdp_umem *umem = pool->umem;
-
-	if (!(umem->need_wakeup & XDP_WAKEUP_RX))
+	if (!(pool->cached_need_wakeup & XDP_WAKEUP_RX))
 		return;
 
 	pool->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
-	umem->need_wakeup &= ~XDP_WAKEUP_RX;
+	pool->cached_need_wakeup &= ~XDP_WAKEUP_RX;
 }
 EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
 
@@ -86,7 +82,7 @@ void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
 	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
-	if (!(umem->need_wakeup & XDP_WAKEUP_TX))
+	if (!(pool->cached_need_wakeup & XDP_WAKEUP_TX))
 		return;
 
 	rcu_read_lock();
@@ -95,13 +91,13 @@ void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
 	}
 	rcu_read_unlock();
 
-	umem->need_wakeup &= ~XDP_WAKEUP_TX;
+	pool->cached_need_wakeup &= ~XDP_WAKEUP_TX;
 }
 EXPORT_SYMBOL(xsk_clear_tx_need_wakeup);
 
 bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
 {
-	return pool->umem->flags & XDP_UMEM_USES_NEED_WAKEUP;
+	return pool->uses_need_wakeup;
 }
 EXPORT_SYMBOL(xsk_uses_need_wakeup);
 
@@ -478,16 +474,16 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 	__poll_t mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
-	struct xdp_umem *umem;
+	struct xsk_buff_pool *pool;
 
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
-	umem = xs->umem;
+	pool = xs->pool;
 
-	if (umem->need_wakeup) {
+	if (pool->cached_need_wakeup) {
 		if (xs->zc)
-			xsk_wakeup(xs, umem->need_wakeup);
+			xsk_wakeup(xs, pool->cached_need_wakeup);
 		else
 			/* Poll needs to drive Tx also in copy mode */
 			__xsk_sendmsg(sk);
@@ -731,11 +727,9 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		goto out_unlock;
 	} else {
 		/* This xsk has its own umem. */
-		xdp_umem_assign_dev(xs->umem, dev, qid);
 		xs->pool = xp_create_and_assign_umem(xs, xs->umem);
 		if (!xs->pool) {
 			err = -ENOMEM;
-			xdp_umem_clear_dev(xs->umem);
 			goto out_unlock;
 		}
 
@@ -743,7 +737,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		if (err) {
 			xp_destroy(xs->pool);
 			xs->pool = NULL;
-			xdp_umem_clear_dev(xs->umem);
 			goto out_unlock;
 		}
 	}
@@ -1089,7 +1082,6 @@ static int xsk_notifier(struct notifier_block *this,
 
 				/* Clear device references. */
 				xp_clear_dev(xs->pool);
-				xdp_umem_clear_dev(xs->umem);
 			}
 			mutex_unlock(&xs->mutex);
 		}
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index a00e3e2..da1f73e 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -11,13 +11,6 @@
 #define XSK_NEXT_PG_CONTIG_SHIFT 0
 #define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
 
-/* Flags for the umem flags field.
- *
- * The NEED_WAKEUP flag is 1 due to the reuse of the flags field for public
- * flags. See inlude/uapi/include/linux/if_xdp.h.
- */
-#define XDP_UMEM_USES_NEED_WAKEUP BIT(1)
-
 struct xdp_ring_offset_v1 {
 	__u64 producer;
 	__u64 consumer;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 36287d2..436648a 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -95,10 +95,9 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
 }
 EXPORT_SYMBOL(xp_set_rxq_info);
 
-int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
+int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
 		  u16 queue_id, u16 flags)
 {
-	struct xdp_umem *umem = pool->umem;
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
 	int err = 0;
@@ -111,27 +110,30 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 	if (force_zc && force_copy)
 		return -EINVAL;
 
-	if (xsk_get_pool_from_qid(dev, queue_id))
+	if (xsk_get_pool_from_qid(netdev, queue_id))
 		return -EBUSY;
 
-	err = xsk_reg_pool_at_qid(dev, pool, queue_id);
+	err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
 	if (err)
 		return err;
 
 	if (flags & XDP_USE_NEED_WAKEUP) {
-		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
+		pool->uses_need_wakeup = true;
 		/* Tx needs to be explicitly woken up the first time.
 		 * Also for supporting drivers that do not implement this
 		 * feature. They will always have to call sendto().
 		 */
-		umem->need_wakeup = XDP_WAKEUP_TX;
+		pool->cached_need_wakeup = XDP_WAKEUP_TX;
 	}
 
+	dev_hold(netdev);
+
 	if (force_copy)
 		/* For copy-mode, we are done. */
 		return 0;
 
-	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
+	if (!netdev->netdev_ops->ndo_bpf ||
+	    !netdev->netdev_ops->ndo_xsk_wakeup) {
 		err = -EOPNOTSUPP;
 		goto err_unreg_pool;
 	}
@@ -140,44 +142,47 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 	bpf.xsk.pool = pool;
 	bpf.xsk.queue_id = queue_id;
 
-	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
+	err = netdev->netdev_ops->ndo_bpf(netdev, &bpf);
 	if (err)
 		goto err_unreg_pool;
 
-	umem->zc = true;
+	pool->netdev = netdev;
+	pool->queue_id = queue_id;
+	pool->umem->zc = true;
 	return 0;
 
 err_unreg_pool:
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
 	if (err)
-		xsk_clear_pool_at_qid(dev, queue_id);
+		xsk_clear_pool_at_qid(netdev, queue_id);
 	return err;
 }
 
 void xp_clear_dev(struct xsk_buff_pool *pool)
 {
-	struct xdp_umem *umem = pool->umem;
 	struct netdev_bpf bpf;
 	int err;
 
 	ASSERT_RTNL();
 
-	if (!umem->dev)
+	if (!pool->netdev)
 		return;
 
-	if (umem->zc) {
+	if (pool->umem->zc) {
 		bpf.command = XDP_SETUP_XSK_POOL;
 		bpf.xsk.pool = NULL;
-		bpf.xsk.queue_id = umem->queue_id;
+		bpf.xsk.queue_id = pool->queue_id;
 
-		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
+		err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
 
 		if (err)
-			WARN(1, "failed to disable umem!\n");
+			WARN(1, "Failed to disable zero-copy!\n");
 	}
 
-	xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
+	xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
+	dev_put(pool->netdev);
+	pool->netdev = NULL;
 }
 
 static void xp_release_deferred(struct work_struct *work)
diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index 52675ea..5bd8ea9 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -59,8 +59,8 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
 	du.num_pages = umem->npgs;
 	du.chunk_size = umem->chunk_size;
 	du.headroom = umem->headroom;
-	du.ifindex = umem->dev ? umem->dev->ifindex : 0;
-	du.queue_id = umem->queue_id;
+	du.ifindex = pool->netdev ? pool->netdev->ifindex : 0;
+	du.queue_id = pool->queue_id;
 	du.flags = 0;
 	if (umem->zc)
 		du.flags |= XDP_DU_F_ZEROCOPY;
-- 
2.7.4

