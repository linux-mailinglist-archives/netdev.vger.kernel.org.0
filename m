Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F0621231D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgGBMTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:19:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbgGBMTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:19:37 -0400
IronPort-SDR: C8hf/MR3Ui9RejNGKqA2UlK1UbN11GdIH7Vo6TQM7XCeDYr938q2+fyCk63gkzQVk3beuINV0R
 Cm0Wc/DGoqbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486076"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486076"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:19:36 -0700
IronPort-SDR: +NUslLDGRlJzQqQCXy2zqP+pz++fbn7dTcj7RxFZna8qvk5e8CM7AqnjG4hid7g29zaEp2jrpQ
 5TkGAmrRVkXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933284"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:19:32 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 03/14] xsk: create and free context independently from umem
Date:   Thu,  2 Jul 2020 14:19:02 +0200
Message-Id: <1593692353-15102-4-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create and free the buffer pool independently from the umem. Move
these operations that are performed on the buffer pool from the
umem create and destroy functions to new create and destroy
functions just for the buffer pool. This so that in later commits
we can instantiate multiple buffer pools per umem when sharing a
umem between HW queues and/or devices. We also erradicate the
back pointer from the umem to the buffer pool as this will not
work when we introduce the possibility to have multiple buffer
pools per umem.

It might seem a bit odd that we create an empty buffer pool first
and then recreate it with its right size when we bind to a device
and umem. But the page pool will in later commits be used to
carry information before it has been assigned to a umem and its
size decided.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h      |   3 +-
 include/net/xsk_buff_pool.h |  14 +++-
 net/xdp/xdp_umem.c          | 164 ++++----------------------------------------
 net/xdp/xdp_umem.h          |   4 +-
 net/xdp/xsk.c               |  83 +++++++++++++++++++---
 net/xdp/xsk.h               |   3 +
 net/xdp/xsk_buff_pool.c     | 154 +++++++++++++++++++++++++++++++++++++----
 net/xdp/xsk_queue.h         |  12 ++--
 8 files changed, 250 insertions(+), 187 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 6eb9628..b9bb118 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -20,13 +20,12 @@ struct xdp_buff;
 struct xdp_umem {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
-	struct xsk_buff_pool *pool;
 	u64 size;
 	u32 headroom;
 	u32 chunk_size;
+	u32 chunks;
 	struct user_struct *user;
 	refcount_t users;
-	struct work_struct work;
 	struct page **pgs;
 	u32 npgs;
 	u16 queue_id;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index a6dec9c..cda8ced 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -14,6 +14,7 @@ struct xdp_rxq_info;
 struct xsk_queue;
 struct xdp_desc;
 struct xdp_umem;
+struct xdp_sock;
 struct device;
 struct page;
 
@@ -46,16 +47,23 @@ struct xsk_buff_pool {
 	struct xdp_umem *umem;
 	void *addrs;
 	struct device *dev;
+	refcount_t users;
+	struct work_struct work;
 	struct xdp_buff_xsk *free_heads[];
 };
 
 /* AF_XDP core. */
-struct xsk_buff_pool *xp_create(struct xdp_umem *umem, u32 chunks,
-				u32 chunk_size, u32 headroom, u64 size,
-				bool unaligned);
+struct xsk_buff_pool *xp_create(void);
+struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool,
+				     struct xdp_umem *umem);
+int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+		  struct net_device *dev, u16 queue_id, u16 flags);
 void xp_set_fq(struct xsk_buff_pool *pool, struct xsk_queue *fq);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
+void xp_get_pool(struct xsk_buff_pool *pool);
+void xp_put_pool(struct xsk_buff_pool *pool);
+void xp_clear_dev(struct xsk_buff_pool *pool);
 
 /* AF_XDP, and XDP core. */
 void xp_free(struct xdp_buff_xsk *xskb);
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index adde4d5..f290345 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -47,160 +47,41 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 	spin_unlock_irqrestore(&umem->xsk_tx_list_lock, flags);
 }
 
-/* The umem is stored both in the _rx struct and the _tx struct as we do
- * not know if the device has more tx queues than rx, or the opposite.
- * This might also change during run time.
- */
-static int xsk_reg_pool_at_qid(struct net_device *dev,
-			       struct xsk_buff_pool *pool,
-			       u16 queue_id)
-{
-	if (queue_id >= max_t(unsigned int,
-			      dev->real_num_rx_queues,
-			      dev->real_num_tx_queues))
-		return -EINVAL;
-
-	if (queue_id < dev->real_num_rx_queues)
-		dev->_rx[queue_id].pool = pool;
-	if (queue_id < dev->real_num_tx_queues)
-		dev->_tx[queue_id].pool = pool;
-
-	return 0;
-}
-
-struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
-					    u16 queue_id)
+static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
-	if (queue_id < dev->real_num_rx_queues)
-		return dev->_rx[queue_id].pool;
-	if (queue_id < dev->real_num_tx_queues)
-		return dev->_tx[queue_id].pool;
+	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
 
-	return NULL;
+	kfree(umem->pgs);
+	umem->pgs = NULL;
 }
-EXPORT_SYMBOL(xsk_get_pool_from_qid);
 
-static void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
+static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
 {
-	if (queue_id < dev->real_num_rx_queues)
-		dev->_rx[queue_id].pool = NULL;
-	if (queue_id < dev->real_num_tx_queues)
-		dev->_tx[queue_id].pool = NULL;
+	if (umem->user) {
+		atomic_long_sub(umem->npgs, &umem->user->locked_vm);
+		free_uid(umem->user);
+	}
 }
 
-int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
-			u16 queue_id, u16 flags)
+void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
+			 u16 queue_id)
 {
-	bool force_zc, force_copy;
-	struct netdev_bpf bpf;
-	int err = 0;
-
-	ASSERT_RTNL();
-
-	force_zc = flags & XDP_ZEROCOPY;
-	force_copy = flags & XDP_COPY;
-
-	if (force_zc && force_copy)
-		return -EINVAL;
-
-	if (xsk_get_pool_from_qid(dev, queue_id))
-		return -EBUSY;
-
-	err = xsk_reg_pool_at_qid(dev, umem->pool, queue_id);
-	if (err)
-		return err;
-
 	umem->dev = dev;
 	umem->queue_id = queue_id;
 
-	if (flags & XDP_USE_NEED_WAKEUP) {
-		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
-		/* Tx needs to be explicitly woken up the first time.
-		 * Also for supporting drivers that do not implement this
-		 * feature. They will always have to call sendto().
-		 */
-		xsk_set_tx_need_wakeup(umem->pool);
-	}
-
 	dev_hold(dev);
-
-	if (force_copy)
-		/* For copy-mode, we are done. */
-		return 0;
-
-	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
-		err = -EOPNOTSUPP;
-		goto err_unreg_umem;
-	}
-
-	bpf.command = XDP_SETUP_XSK_POOL;
-	bpf.xsk.pool = umem->pool;
-	bpf.xsk.queue_id = queue_id;
-
-	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
-	if (err)
-		goto err_unreg_umem;
-
-	umem->zc = true;
-	return 0;
-
-err_unreg_umem:
-	if (!force_zc)
-		err = 0; /* fallback to copy mode */
-	if (err)
-		xsk_clear_pool_at_qid(dev, queue_id);
-	return err;
 }
 
 void xdp_umem_clear_dev(struct xdp_umem *umem)
 {
-	struct netdev_bpf bpf;
-	int err;
-
-	ASSERT_RTNL();
-
-	if (!umem->dev)
-		return;
-
-	if (umem->zc) {
-		bpf.command = XDP_SETUP_XSK_POOL;
-		bpf.xsk.pool = NULL;
-		bpf.xsk.queue_id = umem->queue_id;
-
-		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
-
-		if (err)
-			WARN(1, "failed to disable umem!\n");
-	}
-
-	xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
-
 	dev_put(umem->dev);
 	umem->dev = NULL;
 	umem->zc = false;
 }
 
-static void xdp_umem_unpin_pages(struct xdp_umem *umem)
-{
-	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
-
-	kfree(umem->pgs);
-	umem->pgs = NULL;
-}
-
-static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
-{
-	if (umem->user) {
-		atomic_long_sub(umem->npgs, &umem->user->locked_vm);
-		free_uid(umem->user);
-	}
-}
-
 static void xdp_umem_release(struct xdp_umem *umem)
 {
-	rtnl_lock();
 	xdp_umem_clear_dev(umem);
-	rtnl_unlock();
 
 	ida_simple_remove(&umem_ida, umem->id);
 
@@ -214,20 +95,12 @@ static void xdp_umem_release(struct xdp_umem *umem)
 		umem->cq = NULL;
 	}
 
-	xp_destroy(umem->pool);
 	xdp_umem_unpin_pages(umem);
 
 	xdp_umem_unaccount_pages(umem);
 	kfree(umem);
 }
 
-static void xdp_umem_release_deferred(struct work_struct *work)
-{
-	struct xdp_umem *umem = container_of(work, struct xdp_umem, work);
-
-	xdp_umem_release(umem);
-}
-
 void xdp_get_umem(struct xdp_umem *umem)
 {
 	refcount_inc(&umem->users);
@@ -238,10 +111,8 @@ void xdp_put_umem(struct xdp_umem *umem)
 	if (!umem)
 		return;
 
-	if (refcount_dec_and_test(&umem->users)) {
-		INIT_WORK(&umem->work, xdp_umem_release_deferred);
-		schedule_work(&umem->work);
-	}
+	if (refcount_dec_and_test(&umem->users))
+		xdp_umem_release(umem);
 }
 
 static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
@@ -357,6 +228,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->size = size;
 	umem->headroom = headroom;
 	umem->chunk_size = chunk_size;
+	umem->chunks = chunks;
 	umem->npgs = (u32)npgs;
 	umem->pgs = NULL;
 	umem->user = NULL;
@@ -374,16 +246,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (err)
 		goto out_account;
 
-	umem->pool = xp_create(umem, chunks, chunk_size, headroom, size,
-			       unaligned_chunks);
-	if (!umem->pool) {
-		err = -ENOMEM;
-		goto out_pin;
-	}
 	return 0;
 
-out_pin:
-	xdp_umem_unpin_pages(umem);
 out_account:
 	xdp_umem_unaccount_pages(umem);
 	return err;
diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
index 32067fe..93e96be 100644
--- a/net/xdp/xdp_umem.h
+++ b/net/xdp/xdp_umem.h
@@ -8,8 +8,8 @@
 
 #include <net/xdp_sock_drv.h>
 
-int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
-			u16 queue_id, u16 flags);
+void xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
+			 u16 queue_id);
 void xdp_umem_clear_dev(struct xdp_umem *umem);
 bool xdp_umem_validate_queues(struct xdp_umem *umem);
 void xdp_get_umem(struct xdp_umem *umem);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 7551f5b..b12a832 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -105,6 +105,46 @@ bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
 }
 EXPORT_SYMBOL(xsk_uses_need_wakeup);
 
+struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
+					    u16 queue_id)
+{
+	if (queue_id < dev->real_num_rx_queues)
+		return dev->_rx[queue_id].pool;
+	if (queue_id < dev->real_num_tx_queues)
+		return dev->_tx[queue_id].pool;
+
+	return NULL;
+}
+EXPORT_SYMBOL(xsk_get_pool_from_qid);
+
+void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
+{
+	if (queue_id < dev->real_num_rx_queues)
+		dev->_rx[queue_id].pool = NULL;
+	if (queue_id < dev->real_num_tx_queues)
+		dev->_tx[queue_id].pool = NULL;
+}
+
+/* The buffer pool is stored both in the _rx struct and the _tx struct as we do
+ * not know if the device has more tx queues than rx, or the opposite.
+ * This might also change during run time.
+ */
+int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
+			u16 queue_id)
+{
+	if (queue_id >= max_t(unsigned int,
+			      dev->real_num_rx_queues,
+			      dev->real_num_tx_queues))
+		return -EINVAL;
+
+	if (queue_id < dev->real_num_rx_queues)
+		dev->_rx[queue_id].pool = pool;
+	if (queue_id < dev->real_num_tx_queues)
+		dev->_tx[queue_id].pool = pool;
+
+	return 0;
+}
+
 void xp_release(struct xdp_buff_xsk *xskb)
 {
 	xskb->pool->free_heads[xskb->pool->free_heads_cnt++] = xskb;
@@ -281,7 +321,7 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
-		if (!xskq_cons_peek_desc(xs->tx, desc, umem))
+		if (!xskq_cons_peek_desc(xs->tx, desc, pool))
 			continue;
 
 		/* This is the backpressure mechanism for the Tx path.
@@ -347,7 +387,7 @@ static int xsk_generic_xmit(struct sock *sk)
 	if (xs->queue_id >= xs->dev->real_num_tx_queues)
 		goto out;
 
-	while (xskq_cons_peek_desc(xs->tx, &desc, xs->umem)) {
+	while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
 		char *buffer;
 		u64 addr;
 		u32 len;
@@ -629,6 +669,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	qid = sxdp->sxdp_queue_id;
 
 	if (flags & XDP_SHARED_UMEM) {
+		struct xsk_buff_pool *curr_pool;
 		struct xdp_sock *umem_xs;
 		struct socket *sock;
 
@@ -663,6 +704,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 			goto out_unlock;
 		}
 
+		/* Share the buffer pool with the other socket. */
+		xp_get_pool(umem_xs->pool);
+		curr_pool = xs->pool;
+		xs->pool = umem_xs->pool;
+		xp_destroy(curr_pool);
 		xdp_get_umem(umem_xs->umem);
 		WRITE_ONCE(xs->umem, umem_xs->umem);
 		sockfd_put(sock);
@@ -670,10 +716,24 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		err = -EINVAL;
 		goto out_unlock;
 	} else {
+		struct xsk_buff_pool *new_pool;
+
 		/* This xsk has its own umem. */
-		err = xdp_umem_assign_dev(xs->umem, dev, qid, flags);
-		if (err)
+		xdp_umem_assign_dev(xs->umem, dev, qid);
+		new_pool = xp_assign_umem(xs->pool, xs->umem);
+		if (!new_pool) {
+			err = -ENOMEM;
+			xdp_umem_clear_dev(xs->umem);
+			goto out_unlock;
+		}
+
+		err = xp_assign_dev(new_pool, xs, dev, qid, flags);
+		if (err) {
+			xp_destroy(new_pool);
+			xdp_umem_clear_dev(xs->umem);
 			goto out_unlock;
+		}
+		xs->pool = new_pool;
 	}
 
 	xs->dev = dev;
@@ -765,8 +825,6 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return PTR_ERR(umem);
 		}
 
-		xs->pool = umem->pool;
-
 		/* Make sure umem is ready before it can be seen by others */
 		smp_wmb();
 		WRITE_ONCE(xs->umem, umem);
@@ -796,7 +854,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			&xs->umem->cq;
 		err = xsk_init_queue(entries, q, true);
 		if (optname == XDP_UMEM_FILL_RING)
-			xp_set_fq(xs->umem->pool, *q);
+			xp_set_fq(xs->pool, *q);
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
@@ -1002,7 +1060,8 @@ static int xsk_notifier(struct notifier_block *this,
 
 				xsk_unbind_dev(xs);
 
-				/* Clear device references in umem. */
+				/* Clear device references. */
+				xp_clear_dev(xs->pool);
 				xdp_umem_clear_dev(xs->umem);
 			}
 			mutex_unlock(&xs->mutex);
@@ -1047,7 +1106,7 @@ static void xsk_destruct(struct sock *sk)
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;
 
-	xdp_put_umem(xs->umem);
+	xp_put_pool(xs->pool);
 
 	sk_refcnt_debug_dec(sk);
 }
@@ -1055,8 +1114,8 @@ static void xsk_destruct(struct sock *sk)
 static int xsk_create(struct net *net, struct socket *sock, int protocol,
 		      int kern)
 {
-	struct sock *sk;
 	struct xdp_sock *xs;
+	struct sock *sk;
 
 	if (!ns_capable(net->user_ns, CAP_NET_RAW))
 		return -EPERM;
@@ -1092,6 +1151,10 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	INIT_LIST_HEAD(&xs->map_list);
 	spin_lock_init(&xs->map_list_lock);
 
+	xs->pool = xp_create();
+	if (!xs->pool)
+		return -ENOMEM;
+
 	mutex_lock(&net->xdp.lock);
 	sk_add_node_rcu(sk, &net->xdp.list);
 	mutex_unlock(&net->xdp.lock);
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index 455ddd4..a00e3e2 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -51,5 +51,8 @@ void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry);
 int xsk_map_inc(struct xsk_map *map);
 void xsk_map_put(struct xsk_map *map);
+void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
+int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
+			u16 queue_id);
 
 #endif /* XSK_H_ */
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index c57f0bb..da93b36 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -2,11 +2,14 @@
 
 #include <net/xsk_buff_pool.h>
 #include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-noncoherent.h>
 #include <linux/swiotlb.h>
 
 #include "xsk_queue.h"
+#include "xdp_umem.h"
+#include "xsk.h"
 
 static void xp_addr_unmap(struct xsk_buff_pool *pool)
 {
@@ -32,39 +35,48 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	kvfree(pool);
 }
 
-struct xsk_buff_pool *xp_create(struct xdp_umem *umem, u32 chunks,
-				u32 chunk_size, u32 headroom, u64 size,
-				bool unaligned)
+struct xsk_buff_pool *xp_create(void)
+{
+	return kvzalloc(sizeof(struct xsk_buff_pool), GFP_KERNEL);
+}
+
+struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool_old,
+				     struct xdp_umem *umem)
 {
 	struct xsk_buff_pool *pool;
 	struct xdp_buff_xsk *xskb;
 	int err;
 	u32 i;
 
-	pool = kvzalloc(struct_size(pool, free_heads, chunks), GFP_KERNEL);
+	pool = kvzalloc(struct_size(pool, free_heads, umem->chunks),
+			GFP_KERNEL);
 	if (!pool)
 		goto out;
 
-	pool->heads = kvcalloc(chunks, sizeof(*pool->heads), GFP_KERNEL);
+	memcpy(pool, pool_old, sizeof(*pool_old));
+
+	pool->heads = kvcalloc(umem->chunks, sizeof(*pool->heads), GFP_KERNEL);
 	if (!pool->heads)
 		goto out;
 
-	pool->chunk_mask = ~((u64)chunk_size - 1);
-	pool->addrs_cnt = size;
-	pool->heads_cnt = chunks;
-	pool->free_heads_cnt = chunks;
-	pool->headroom = headroom;
-	pool->chunk_size = chunk_size;
+	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
+	pool->addrs_cnt = umem->size;
+	pool->heads_cnt = umem->chunks;
+	pool->free_heads_cnt = umem->chunks;
+	pool->headroom = umem->headroom;
+	pool->chunk_size = umem->chunk_size;
 	pool->cheap_dma = true;
-	pool->unaligned = unaligned;
-	pool->frame_len = chunk_size - headroom - XDP_PACKET_HEADROOM;
+	pool->unaligned = umem->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
+	pool->frame_len = umem->chunk_size - umem->headroom -
+		XDP_PACKET_HEADROOM;
 	pool->umem = umem;
 	INIT_LIST_HEAD(&pool->free_list);
+	refcount_set(&pool->users, 1);
 
 	for (i = 0; i < pool->free_heads_cnt; i++) {
 		xskb = &pool->heads[i];
 		xskb->pool = pool;
-		xskb->xdp.frame_sz = chunk_size - headroom;
+		xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
 		pool->free_heads[i] = xskb;
 	}
 
@@ -91,6 +103,120 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
 }
 EXPORT_SYMBOL(xp_set_rxq_info);
 
+int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
+		  struct net_device *dev, u16 queue_id, u16 flags)
+{
+	struct xdp_umem *umem = pool->umem;
+	bool force_zc, force_copy;
+	struct netdev_bpf bpf;
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	force_zc = flags & XDP_ZEROCOPY;
+	force_copy = flags & XDP_COPY;
+
+	if (force_zc && force_copy)
+		return -EINVAL;
+
+	if (xsk_get_pool_from_qid(dev, queue_id))
+		return -EBUSY;
+
+	err = xsk_reg_pool_at_qid(dev, pool, queue_id);
+	if (err)
+		return err;
+
+	if ((flags & XDP_USE_NEED_WAKEUP) && xs->tx) {
+		umem->flags |= XDP_UMEM_USES_NEED_WAKEUP;
+		/* Tx needs to be explicitly woken up the first time.
+		 * Also for supporting drivers that do not implement this
+		 * feature. They will always have to call sendto().
+		 */
+		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
+	}
+
+	if (force_copy)
+		/* For copy-mode, we are done. */
+		return 0;
+
+	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
+		err = -EOPNOTSUPP;
+		goto err_unreg_pool;
+	}
+
+	bpf.command = XDP_SETUP_XSK_POOL;
+	bpf.xsk.pool = pool;
+	bpf.xsk.queue_id = queue_id;
+
+	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
+	if (err)
+		goto err_unreg_pool;
+
+	umem->zc = true;
+	return 0;
+
+err_unreg_pool:
+	if (!force_zc)
+		err = 0; /* fallback to copy mode */
+	if (err)
+		xsk_clear_pool_at_qid(dev, queue_id);
+	return err;
+}
+
+void xp_clear_dev(struct xsk_buff_pool *pool)
+{
+	struct xdp_umem *umem = pool->umem;
+	struct netdev_bpf bpf;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (!umem->dev)
+		return;
+
+	if (umem->zc) {
+		bpf.command = XDP_SETUP_XSK_POOL;
+		bpf.xsk.pool = NULL;
+		bpf.xsk.queue_id = umem->queue_id;
+
+		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
+
+		if (err)
+			WARN(1, "failed to disable umem!\n");
+	}
+
+	xsk_clear_pool_at_qid(umem->dev, umem->queue_id);
+}
+
+static void xp_release_deferred(struct work_struct *work)
+{
+	struct xsk_buff_pool *pool = container_of(work, struct xsk_buff_pool,
+						  work);
+
+	rtnl_lock();
+	xp_clear_dev(pool);
+	rtnl_unlock();
+
+	xdp_put_umem(pool->umem);
+	xp_destroy(pool);
+}
+
+void xp_get_pool(struct xsk_buff_pool *pool)
+{
+	refcount_inc(&pool->users);
+}
+
+void xp_put_pool(struct xsk_buff_pool *pool)
+{
+	if (!pool)
+		return;
+
+	if (refcount_dec_and_test(&pool->users)) {
+		INIT_WORK(&pool->work, xp_release_deferred);
+		schedule_work(&pool->work);
+	}
+}
+
 void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 {
 	dma_addr_t *dma;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 5b5d24d..75f1853 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -165,9 +165,9 @@ static inline bool xp_validate_desc(struct xsk_buff_pool *pool,
 
 static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
 					   struct xdp_desc *d,
-					   struct xdp_umem *umem)
+					   struct xsk_buff_pool *pool)
 {
-	if (!xp_validate_desc(umem->pool, d)) {
+	if (!xp_validate_desc(pool, d)) {
 		q->invalid_descs++;
 		return false;
 	}
@@ -176,14 +176,14 @@ static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
 
 static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 				       struct xdp_desc *desc,
-				       struct xdp_umem *umem)
+				       struct xsk_buff_pool *pool)
 {
 	while (q->cached_cons != q->cached_prod) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 		u32 idx = q->cached_cons & q->ring_mask;
 
 		*desc = ring->desc[idx];
-		if (xskq_cons_is_valid_desc(q, desc, umem))
+		if (xskq_cons_is_valid_desc(q, desc, pool))
 			return true;
 
 		q->cached_cons++;
@@ -235,11 +235,11 @@ static inline bool xskq_cons_peek_addr_unchecked(struct xsk_queue *q, u64 *addr)
 
 static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 				       struct xdp_desc *desc,
-				       struct xdp_umem *umem)
+				       struct xsk_buff_pool *pool)
 {
 	if (q->cached_prod == q->cached_cons)
 		xskq_cons_get_entries(q);
-	return xskq_cons_read_desc(q, desc, umem);
+	return xskq_cons_read_desc(q, desc, pool);
 }
 
 static inline void xskq_cons_release(struct xsk_queue *q)
-- 
2.7.4

