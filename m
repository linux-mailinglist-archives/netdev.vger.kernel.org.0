Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A882212321
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgGBMTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:19:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728832AbgGBMTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:19:44 -0400
IronPort-SDR: RZI79Q56G2ITzxoY3vnWk7jrtPXuiudBqakE2wFGLqwlJwRjcqM0AdHzDod26gYyHPRBoZAg3u
 fCQ8Uidn9Fhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486087"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486087"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:19:44 -0700
IronPort-SDR: jYmiWH16iDCEo2oyKNLKQl3HilmRQzQRJ82uahogbNtZMiXcRs1NatXkFlsyVVTda2k41jQQHr
 fCEWCE2JXyYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933311"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:19:40 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 05/14] xsk: move queue_id, dev and need_wakeup to context
Date:   Thu,  2 Jul 2020 14:19:04 +0200
Message-Id: <1593692353-15102-6-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
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
---
 include/net/xdp_sock.h      |  3 ---
 include/net/xsk_buff_pool.h |  4 ++++
 net/xdp/xdp_umem.c          | 19 +------------------
 net/xdp/xdp_umem.h          |  4 ----
 net/xdp/xsk.c               | 40 +++++++++++++++-------------------------
 net/xdp/xsk_buff_pool.c     | 37 +++++++++++++++++++++----------------
 net/xdp/xsk_diag.c          |  4 ++--
 7 files changed, 43 insertions(+), 68 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 2dd3fd9..e12d814 100644
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
index f811e25..cd929a8 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -43,11 +43,15 @@ struct xsk_buff_pool {
 	u32 headroom;
 	u32 chunk_size;
 	u32 frame_len;
+	u16 queue_id;
+	u8 cached_need_wakeup;
+	bool uses_need_wakeup;
 	bool cheap_dma;
 	bool unaligned;
 	struct xdp_umem *umem;
 	void *addrs;
 	struct device *dev;
+	struct net_device *netdev;
 	refcount_t users;
 	struct work_struct work;
 	struct xdp_buff_xsk *free_heads[];
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 7d86a63..b1699d0 100644
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
index 92f05b0..b02ed96 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -41,67 +41,61 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
 
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
 
 void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
 {
-	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
-	if (umem->need_wakeup & XDP_WAKEUP_TX)
+	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
 		return;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
+	list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {
 		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
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
 
 void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
 {
-	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
-	if (!(umem->need_wakeup & XDP_WAKEUP_TX))
+	if (!(pool->cached_need_wakeup & XDP_WAKEUP_TX))
 		return;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
+	list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {
 		xs->tx->ring->flags &= ~XDP_RING_NEED_WAKEUP;
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
 
@@ -474,16 +468,16 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
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
@@ -725,18 +719,15 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		struct xsk_buff_pool *new_pool;
 
 		/* This xsk has its own umem. */
-		xdp_umem_assign_dev(xs->umem, dev, qid);
 		new_pool = xp_assign_umem(xs->pool, xs->umem);
 		if (!new_pool) {
 			err = -ENOMEM;
-			xdp_umem_clear_dev(xs->umem);
 			goto out_unlock;
 		}
 
 		err = xp_assign_dev(new_pool, xs, dev, qid, flags);
 		if (err) {
 			xp_destroy(new_pool);
-			xdp_umem_clear_dev(xs->umem);
 			goto out_unlock;
 		}
 		xs->pool = new_pool;
@@ -1062,7 +1053,6 @@ static int xsk_notifier(struct notifier_block *this,
 
 				/* Clear device references. */
 				xp_clear_dev(xs->pool);
-				xdp_umem_clear_dev(xs->umem);
 			}
 			mutex_unlock(&xs->mutex);
 		}
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 6a6e0d5..e0a49fc 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -99,9 +99,8 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
 EXPORT_SYMBOL(xp_set_rxq_info);
 
 int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
-		  struct net_device *dev, u16 queue_id, u16 flags)
+		  struct net_device *netdev, u16 queue_id, u16 flags)
 {
-	struct xdp_umem *umem = pool->umem;
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
 	int err = 0;
@@ -114,15 +113,15 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 	if (force_zc && force_copy)
 		return -EINVAL;
 
-	if (xsk_get_pool_from_qid(dev, queue_id))
+	if (xsk_get_pool_from_qid(netdev, queue_id))
 		return -EBUSY;
 
-	err = xsk_reg_pool_at_qid(dev, pool, queue_id);
+	err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
 	if (err)
 		return err;
 
 	if ((flags & XDP_USE_NEED_WAKEUP) && xs->tx) {
-		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
+		pool->uses_need_wakeup = true;
 		/* Tx needs to be explicitly woken up the first time.
 		 * Also for supporting drivers that do not implement this
 		 * feature. They will always have to call sendto().
@@ -130,11 +129,14 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
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
@@ -143,44 +145,47 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
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
index 1936423..c974295 100644
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

