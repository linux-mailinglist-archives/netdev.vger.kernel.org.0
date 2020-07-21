Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1D32277F2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 07:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgGUFE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 01:04:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:5858 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728075AbgGUFE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 01:04:56 -0400
IronPort-SDR: WompTLC89qMVAaBEdrv0PKrlWzyUe4XzbR9z3bH4EtwctKSN1+c1kWYrIvVzqXE+ffXZ751f14
 2m8PtaTPNIyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="148005998"
X-IronPort-AV: E=Sophos;i="5.75,377,1589266800"; 
   d="scan'208";a="148005998"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 22:04:52 -0700
IronPort-SDR: TeAIau8c0TabECT2UX/VD/sq5dcDG0HNKnQ4d3KwGnLNM/pFEC3vinNidcSAShU7/34E94Vfjh
 kXu8v+zAFh2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,377,1589266800"; 
   d="scan'208";a="431855643"
Received: from taktemur-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.33.122])
  by orsmga004.jf.intel.com with ESMTP; 20 Jul 2020 22:04:48 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v4 08/14] xsk: enable sharing of dma mappings
Date:   Tue, 21 Jul 2020 07:04:02 +0200
Message-Id: <1595307848-20719-9-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the sharing of dma mappings by moving them out from the buffer
pool. Instead we put each dma mapped umem region in a list in the umem
structure. If dma has already been mapped for this umem and device, it
is not mapped again and the existing dma mappings are reused.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xdp_sock.h      |   1 +
 include/net/xsk_buff_pool.h |   7 +++
 net/xdp/xdp_umem.c          |   1 +
 net/xdp/xsk_buff_pool.c     | 112 ++++++++++++++++++++++++++++++++++++--------
 4 files changed, 102 insertions(+), 19 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 126d243..282aeba 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -30,6 +30,7 @@ struct xdp_umem {
 	u8 flags;
 	int id;
 	bool zc;
+	struct list_head xsk_dma_list;
 };
 
 struct xsk_map {
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 83f100c..8f1dc4c 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -28,6 +28,13 @@ struct xdp_buff_xsk {
 	struct list_head free_list_node;
 };
 
+struct xsk_dma_map {
+	dma_addr_t *dma_pages;
+	struct net_device *dev;
+	refcount_t users;
+	struct list_head list; /* Protected by the RTNL_LOCK */
+};
+
 struct xsk_buff_pool {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 372998d..cf27249 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -199,6 +199,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->user = NULL;
 	umem->flags = mr->flags;
 
+	INIT_LIST_HEAD(&umem->xsk_dma_list);
 	refcount_set(&umem->users, 1);
 
 	err = xdp_umem_account_pages(umem);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index c563874..ca74a3e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -104,6 +104,25 @@ void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
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
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
 		  u16 queue_id, u16 flags)
 {
@@ -122,6 +141,8 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
 	if (xsk_get_pool_from_qid(netdev, queue_id))
 		return -EBUSY;
 
+	pool->netdev = netdev;
+	pool->queue_id = queue_id;
 	err = xsk_reg_pool_at_qid(netdev, pool, queue_id);
 	if (err)
 		return err;
@@ -155,11 +176,15 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
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
@@ -170,25 +195,10 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *netdev,
 
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
@@ -233,14 +243,61 @@ void xp_put_pool(struct xsk_buff_pool *pool)
 	}
 }
 
+static struct xsk_dma_map *xp_find_dma_map(struct xsk_buff_pool *pool)
+{
+	struct xsk_dma_map *dma_map;
+
+	list_for_each_entry(dma_map, &pool->umem->xsk_dma_list, list) {
+		if (dma_map->dev == pool->netdev)
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
+	dma_map->dev = pool->netdev;
+	refcount_set(&dma_map->users, 1);
+	list_add(&dma_map->list, &pool->umem->xsk_dma_list);
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
@@ -250,6 +307,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
 		}
 	}
 
+	xp_put_dma_map(dma_map);
 	kvfree(pool->dma_pages);
 	pool->dma_pages_cnt = 0;
 	pool->dev = NULL;
@@ -271,14 +329,29 @@ static void xp_check_dma_contiguity(struct xsk_buff_pool *pool)
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
 	pool->dma_need_sync = false;
@@ -288,6 +361,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 					 DMA_BIDIRECTIONAL, attrs);
 		if (dma_mapping_error(dev, dma)) {
 			xp_dma_unmap(pool, attrs);
+			xp_destroy_dma_map(dma_map);
 			return -ENOMEM;
 		}
 		if (dma_need_sync(dev, dma))
-- 
2.7.4

