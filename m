Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A93C212327
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgGBMT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:19:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:6897 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728906AbgGBMTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 08:19:55 -0400
IronPort-SDR: FnFqz9/RRuQj338clEBeNKtO+r0Yi4/fF2z8b4N1mIwI94J9G9Cat2DMqaEjN6kMNkZJWRy0Hc
 SCUojVmbfa4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126486108"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="126486108"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 05:19:54 -0700
IronPort-SDR: 81IknkhrmGAvjTJa+7ITokXw7xpvVezWAbZhNwzgmMIRtYaBa1eN4sml1r5KKLtVN2TBWDAV6z
 jt4UKJs32+Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="425933345"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.39.242])
  by orsmga004.jf.intel.com with ESMTP; 02 Jul 2020 05:19:51 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next 08/14] xsk: net: enable sharing of dma mappings
Date:   Thu,  2 Jul 2020 14:19:07 +0200
Message-Id: <1593692353-15102-9-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the sharing of dma mappings by moving them out of the umem
structure. Instead we put each dma mapped umem region in a list
in the netdev structure. If dma has already been mapped for this
umem and device, it is not mapped again and the existing dma
mappings are reused.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/linux/netdevice.h   |   3 ++
 include/net/xsk_buff_pool.h |   7 +++
 net/core/dev.c              |   3 ++
 net/xdp/xsk_buff_pool.c     | 112 ++++++++++++++++++++++++++++++++++++--------
 4 files changed, 106 insertions(+), 19 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e5acc3b..fd794aa 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2006,6 +2006,9 @@ struct net_device {
 	unsigned int		real_num_rx_queues;
 
 	struct bpf_prog __rcu	*xdp_prog;
+#ifdef CONFIG_XDP_SOCKETS
+	struct list_head        xsk_dma_list;
+#endif
 	unsigned long		gro_flush_timeout;
 	int			napi_defer_hard_irqs;
 	rx_handler_func_t __rcu	*rx_handler;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 6158a47..197cca8 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -28,6 +28,13 @@ struct xdp_buff_xsk {
 	struct list_head free_list_node;
 };
 
+struct xsk_dma_map {
+	dma_addr_t *dma_pages;
+	struct xdp_umem *umem;
+	refcount_t users;
+	struct list_head list; /* Protected by the RTNL_LOCK */
+};
+
 struct xsk_buff_pool {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388..fe8a72f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9959,6 +9959,9 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	INIT_LIST_HEAD(&dev->ptype_all);
 	INIT_LIST_HEAD(&dev->ptype_specific);
 	INIT_LIST_HEAD(&dev->net_notifier_list);
+#ifdef CONFIG_XDP_SOCKETS
+	INIT_LIST_HEAD(&dev->xsk_dma_list);
+#endif
 #ifdef CONFIG_NET_SCHED
 	hash_init(dev->qdisc_hash);
 #endif
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index ae27664..3c58d76 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -107,6 +107,25 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
 }
 EXPORT_SYMBOL(xp_set_rxq_info);
 
+static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
+{
+	struct netdev_bpf bpf;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (pool->umem->zc) {
+		bpf.command = XDP_SETUP_XSK_POOL;
+		bpf.xsk.pool = NULL;
+		bpf.xsk.queue_id = pool->queue_id;
+
+		err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
+
+		if (err)
+			WARN(1, "Failed to disable zero-copy!\n");
+	}
+}
+
 int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 		  struct net_device *netdev, u16 queue_id, u16 flags)
 {
@@ -125,6 +144,8 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 	if (xsk_get_pool_from_qid(netdev, queue_id))
 		return -EBUSY;
 
+	pool->netdev = netdev;
+	pool->queue_id = queue_id;
 	err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
 	if (err)
 		return err;
@@ -158,11 +179,15 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 	if (err)
 		goto err_unreg_pool;
 
-	pool->netdev = netdev;
-	pool->queue_id = queue_id;
+	if (!pool->dma_pages) {
+		WARN(1, "Driver did not DMA map zero-copy buffers");
+		goto err_unreg_xsk;
+	}
 	pool->umem->zc = true;
 	return 0;
 
+err_unreg_xsk:
+	xp_disable_drv_zc(pool);
 err_unreg_pool:
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
@@ -173,25 +198,10 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct xdp_sock *xs,
 
 void xp_clear_dev(struct xsk_buff_pool *pool)
 {
-	struct netdev_bpf bpf;
-	int err;
-
-	ASSERT_RTNL();
-
 	if (!pool->netdev)
 		return;
 
-	if (pool->umem->zc) {
-		bpf.command = XDP_SETUP_XSK_POOL;
-		bpf.xsk.pool = NULL;
-		bpf.xsk.queue_id = pool->queue_id;
-
-		err = pool->netdev->netdev_ops->ndo_bpf(pool->netdev, &bpf);
-
-		if (err)
-			WARN(1, "Failed to disable zero-copy!\n");
-	}
-
+	xp_disable_drv_zc(pool);
 	xsk_clear_pool_at_qid(pool->netdev, pool->queue_id);
 	dev_put(pool->netdev);
 	pool->netdev = NULL;
@@ -241,14 +251,61 @@ bool xp_validate_queues(struct xsk_buff_pool *pool)
 	return pool->fq && pool->cq;
 }
 
+static struct xsk_dma_map *xp_find_dma_map(struct xsk_buff_pool *pool)
+{
+	struct xsk_dma_map *dma_map;
+
+	list_for_each_entry(dma_map, &pool->netdev->xsk_dma_list, list) {
+		if (dma_map->umem == pool->umem)
+			return dma_map;
+	}
+
+	return NULL;
+}
+
+static void xp_destroy_dma_map(struct xsk_dma_map *dma_map)
+{
+	list_del(&dma_map->list);
+	kfree(dma_map);
+}
+
+static void xp_put_dma_map(struct xsk_dma_map *dma_map)
+{
+	if (!refcount_dec_and_test(&dma_map->users))
+		return;
+
+	xp_destroy_dma_map(dma_map);
+}
+
+static struct xsk_dma_map *xp_create_dma_map(struct xsk_buff_pool *pool)
+{
+	struct xsk_dma_map *dma_map;
+
+	dma_map = kzalloc(sizeof(*dma_map), GFP_KERNEL);
+	if (!dma_map)
+		return NULL;
+
+	dma_map->umem = pool->umem;
+	refcount_set(&dma_map->users, 1);
+	list_add(&dma_map->list, &pool->netdev->xsk_dma_list);
+	return dma_map;
+}
+
 void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 {
+	struct xsk_dma_map *dma_map;
 	dma_addr_t *dma;
 	u32 i;
 
 	if (pool->dma_pages_cnt == 0)
 		return;
 
+	dma_map = xp_find_dma_map(pool);
+	if (!dma_map) {
+		WARN(1, "Could not find dma_map for device");
+		return;
+	}
+
 	for (i = 0; i < pool->dma_pages_cnt; i++) {
 		dma = &pool->dma_pages[i];
 		if (*dma) {
@@ -258,6 +315,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 		}
 	}
 
+	xp_put_dma_map(dma_map);
 	kvfree(pool->dma_pages);
 	pool->dma_pages_cnt = 0;
 	pool->dev = NULL;
@@ -321,14 +379,29 @@ static bool xp_check_cheap_dma(struct xsk_buff_pool *pool)
 int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	       unsigned long attrs, struct page **pages, u32 nr_pages)
 {
+	struct xsk_dma_map *dma_map;
 	dma_addr_t dma;
 	u32 i;
 
+	dma_map = xp_find_dma_map(pool);
+	if (dma_map) {
+		pool->dma_pages = dma_map->dma_pages;
+		refcount_inc(&dma_map->users);
+		return 0;
+	}
+
+	dma_map = xp_create_dma_map(pool);
+	if (!dma_map)
+		return -ENOMEM;
+
 	pool->dma_pages = kvcalloc(nr_pages, sizeof(*pool->dma_pages),
 				   GFP_KERNEL);
-	if (!pool->dma_pages)
+	if (!pool->dma_pages) {
+		xp_destroy_dma_map(dma_map);
 		return -ENOMEM;
+	}
 
+	dma_map->dma_pages = pool->dma_pages;
 	pool->dev = dev;
 	pool->dma_pages_cnt = nr_pages;
 
@@ -337,6 +410,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 					 DMA_BIDIRECTIONAL, attrs);
 		if (dma_mapping_error(dev, dma)) {
 			xp_dma_unmap(pool, attrs);
+			xp_destroy_dma_map(dma_map);
 			return -ENOMEM;
 		}
 		pool->dma_pages[i] = dma;
-- 
2.7.4

