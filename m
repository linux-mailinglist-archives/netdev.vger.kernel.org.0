Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494E3212323
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgGBMTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:19:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728832AbgGBMTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:19:48 -0400
IronPort-SDR: jiiKPVRQzidjZfd0uv/4rMPQECybH1KTfYJE4bGWIn39Xl1tZAJy3/i6Dl7fvOlc7cH/AwsDko
 BbhpRm1FdB3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486093"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486093"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:19:47 -0700
IronPort-SDR: ZLqsksi0iC6SyDBLF5hmJQkfetLBIJNstF2OSXYkFbfWqSlQrYF1XGKit9jYfQgpK07hEd7BHW
 oivj7E+r2HNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933322"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:19:44 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 06/14] xsk: move xsk_tx_list and its lock to buffer pool
Date:   Thu,  2 Jul 2020 14:19:05 +0200
Message-Id: <1593692353-15102-7-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the xsk_tx_list and the xsk_tx_list_lock from the umem to
the buffer pool. This so that we in a later commit can share the
umem between multiple HW queues. There is one xsk_tx_list per
device and queue id, so it should be located in the buffer pool.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h      |  4 +---
 include/net/xsk_buff_pool.h |  5 +++++
 net/xdp/xdp_umem.c          | 26 --------------------------
 net/xdp/xdp_umem.h          |  2 --
 net/xdp/xsk.c               | 13 ++++++-------
 net/xdp/xsk_buff_pool.c     | 26 ++++++++++++++++++++++++++
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e12d814..471719d 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -29,8 +29,6 @@ struct xdp_umem {
 	u8 flags;
 	int id;
 	bool zc;
-	spinlock_t xsk_tx_list_lock;
-	struct list_head xsk_tx_list;
 };
 
 struct xsk_map {
@@ -57,7 +55,7 @@ struct xdp_sock {
 	/* Protects multiple processes in the control path */
 	struct mutex mutex;
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
-	struct list_head list;
+	struct list_head tx_list;
 	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
 	 * in the SKB destructor callback.
 	 */
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index cd929a8..6158a47 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -52,6 +52,9 @@ struct xsk_buff_pool {
 	void *addrs;
 	struct device *dev;
 	struct net_device *netdev;
+	struct list_head xsk_tx_list;
+	/* Protects modifications to the xsk_tx_list */
+	spinlock_t xsk_tx_list_lock;
 	refcount_t users;
 	struct work_struct work;
 	struct xdp_buff_xsk *free_heads[];
@@ -69,6 +72,8 @@ void xp_get_pool(struct xsk_buff_pool *pool);
 void xp_put_pool(struct xsk_buff_pool *pool);
 void xp_clear_dev(struct xsk_buff_pool *pool);
 bool xp_validate_queues(struct xsk_buff_pool *pool);
+void xp_add_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
+void xp_del_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 
 /* AF_XDP, and XDP core. */
 void xp_free(struct xdp_buff_xsk *xskb);
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index b1699d0..a871c75 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -23,30 +23,6 @@
 
 static DEFINE_IDA(umem_ida);
 
-void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
-{
-	unsigned long flags;
-
-	if (!xs->tx)
-		return;
-
-	spin_lock_irqsave(&umem->xsk_tx_list_lock, flags);
-	list_add_rcu(&xs->list, &umem->xsk_tx_list);
-	spin_unlock_irqrestore(&umem->xsk_tx_list_lock, flags);
-}
-
-void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
-{
-	unsigned long flags;
-
-	if (!xs->tx)
-		return;
-
-	spin_lock_irqsave(&umem->xsk_tx_list_lock, flags);
-	list_del_rcu(&xs->list);
-	spin_unlock_irqrestore(&umem->xsk_tx_list_lock, flags);
-}
-
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
 	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
@@ -206,8 +182,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->pgs = NULL;
 	umem->user = NULL;
 	umem->flags = mr->flags;
-	INIT_LIST_HEAD(&umem->xsk_tx_list);
-	spin_lock_init(&umem->xsk_tx_list_lock);
 
 	refcount_set(&umem->users, 1);
 
diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
index 67bf3f3..181fdda 100644
--- a/net/xdp/xdp_umem.h
+++ b/net/xdp/xdp_umem.h
@@ -10,8 +10,6 @@
 
 void xdp_get_umem(struct xdp_umem *umem);
 void xdp_put_umem(struct xdp_umem *umem);
-void xdp_add_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs);
-void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs);
 struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr);
 
 #endif /* XDP_UMEM_H_ */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b02ed96..4d0028c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -57,7 +57,7 @@ void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool)
 		return;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {
+	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
 		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
 	}
 	rcu_read_unlock();
@@ -84,7 +84,7 @@ void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool)
 		return;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &xs->umem->xsk_tx_list, list) {
+	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
 		xs->tx->ring->flags &= ~XDP_RING_NEED_WAKEUP;
 	}
 	rcu_read_unlock();
@@ -300,7 +300,7 @@ void xsk_tx_release(struct xsk_buff_pool *pool)
 	struct xdp_sock *xs;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &pool->umem->xsk_tx_list, list) {
+	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
 		__xskq_cons_release(xs->tx);
 		xs->sk.sk_write_space(&xs->sk);
 	}
@@ -310,11 +310,10 @@ EXPORT_SYMBOL(xsk_tx_release);
 
 bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 {
-	struct xdp_umem *umem = pool->umem;
 	struct xdp_sock *xs;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(xs, &umem->xsk_tx_list, list) {
+	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
 		if (!xskq_cons_peek_desc(xs->tx, desc, pool))
 			continue;
 
@@ -518,7 +517,7 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 	WRITE_ONCE(xs->state, XSK_UNBOUND);
 
 	/* Wait for driver to stop using the xdp socket. */
-	xdp_del_sk_umem(xs->umem, xs);
+	xp_del_xsk(xs->pool, xs);
 	xs->dev = NULL;
 	synchronize_net();
 	dev_put(dev);
@@ -736,7 +735,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xs->dev = dev;
 	xs->zc = xs->umem->zc;
 	xs->queue_id = qid;
-	xdp_add_sk_umem(xs->umem, xs);
+	xp_add_xsk(xs->pool, xs);
 
 out_unlock:
 	if (err) {
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index e0a49fc..31dd337 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -11,6 +11,30 @@
 #include "xdp_umem.h"
 #include "xsk.h"
 
+void xp_add_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs)
+{
+	unsigned long flags;
+
+	if (!xs->tx)
+		return;
+
+	spin_lock_irqsave(&pool->xsk_tx_list_lock, flags);
+	list_add_rcu(&xs->tx_list, &pool->xsk_tx_list);
+	spin_unlock_irqrestore(&pool->xsk_tx_list_lock, flags);
+}
+
+void xp_del_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs)
+{
+	unsigned long flags;
+
+	if (!xs->tx)
+		return;
+
+	spin_lock_irqsave(&pool->xsk_tx_list_lock, flags);
+	list_del_rcu(&xs->tx_list);
+	spin_unlock_irqrestore(&pool->xsk_tx_list_lock, flags);
+}
+
 static void xp_addr_unmap(struct xsk_buff_pool *pool)
 {
 	vunmap(pool->addrs);
@@ -71,6 +95,8 @@ struct xsk_buff_pool *xp_assign_umem(struct xsk_buff_pool *pool_old,
 		XDP_PACKET_HEADROOM;
 	pool->umem = umem;
 	INIT_LIST_HEAD(&pool->free_list);
+	INIT_LIST_HEAD(&pool->xsk_tx_list);
+	spin_lock_init(&pool->xsk_tx_list_lock);
 	refcount_set(&pool->users, 1);
 
 	for (i = 0; i < pool->free_heads_cnt; i++) {
-- 
2.7.4

