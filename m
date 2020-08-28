Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7989255672
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgH1I1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:27:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:23546 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbgH1I1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:27:30 -0400
IronPort-SDR: vcJasqLb5eRW1MqCT0E4DJhvlam6vVcKT+oYvH6SuP8VO1cE59joJ1UpvH93Ar13Mphz0GXdDe
 5wj7TWyTTfuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="156634013"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="156634013"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:27:11 -0700
IronPort-SDR: r+MoDDE1zIgsVXCGdeJKzMQrL7s+IcpntuSQ2rt4kRfBOqXQOuV8CgGjshNZuvil4e67jopfaV
 KPe3Rq0jYn2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762736"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:27:07 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 08/15] xsk: enable sharing of dma mappings
Date:   Fri, 28 Aug 2020 10:26:22 +0200
Message-Id: <1598603189-32145-9-git-send-email-magnus.karlsson@intel.com>
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

Enable the sharing of dma mappings by moving them out from the buffer
pool. Instead we put each dma mapped umem region in a list in the umem
structure. If dma has already been mapped for this umem and device, it
is not mapped again and the existing dma mappings are reused.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h      |   1 +
 include/net/xsk_buff_pool.h |  13 ++++
 net/xdp/xdp_umem.c          |   1 +
 net/xdp/xsk_buff_pool.c     | 183 ++++++++++++++++++++++++++++++++++----------
 4 files changed, 156 insertions(+), 42 deletions(-)

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
index 83f100c..356d0ac 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -28,10 +28,23 @@ struct xdp_buff_xsk {
 	struct list_head free_list_node;
 };
 
+struct xsk_dma_map {
+	dma_addr_t *dma_pages;
+	struct device *dev;
+	struct net_device *netdev;
+	refcount_t users;
+	struct list_head list; /* Protected by the RTNL_LOCK */
+	u32 dma_pages_cnt;
+	bool dma_need_sync;
+};
+
 struct xsk_buff_pool {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
 	struct list_head free_list;
+	/* For performance reasons, each buff pool has its own array of dma_pages
+	 * even when they are identical.
+	 */
 	dma_addr_t *dma_pages;
 	struct xdp_buff_xsk *heads;
 	u64 chunk_mask;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 77604c3..a7227b4 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -198,6 +198,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->user = NULL;
 	umem->flags = mr->flags;
 
+	INIT_LIST_HEAD(&umem->xsk_dma_list);
 	refcount_set(&umem->users, 1);
 
 	err = xdp_umem_account_pages(umem);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index c563874..547eb41 100644
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
@@ -233,70 +243,159 @@ void xp_put_pool(struct xsk_buff_pool *pool)
 	}
 }
 
-void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
+static struct xsk_dma_map *xp_find_dma_map(struct xsk_buff_pool *pool)
+{
+	struct xsk_dma_map *dma_map;
+
+	list_for_each_entry(dma_map, &pool->umem->xsk_dma_list, list) {
+		if (dma_map->netdev == pool->netdev)
+			return dma_map;
+	}
+
+	return NULL;
+}
+
+static struct xsk_dma_map *xp_create_dma_map(struct device *dev, struct net_device *netdev,
+					     u32 nr_pages, struct xdp_umem *umem)
+{
+	struct xsk_dma_map *dma_map;
+
+	dma_map = kzalloc(sizeof(*dma_map), GFP_KERNEL);
+	if (!dma_map)
+		return NULL;
+
+	dma_map->dma_pages = kvcalloc(nr_pages, sizeof(*dma_map->dma_pages), GFP_KERNEL);
+	if (!dma_map) {
+		kfree(dma_map);
+		return NULL;
+	}
+
+	dma_map->netdev = netdev;
+	dma_map->dev = dev;
+	dma_map->dma_need_sync = false;
+	dma_map->dma_pages_cnt = nr_pages;
+	refcount_set(&dma_map->users, 0);
+	list_add(&dma_map->list, &umem->xsk_dma_list);
+	return dma_map;
+}
+
+static void xp_destroy_dma_map(struct xsk_dma_map *dma_map)
+{
+	list_del(&dma_map->list);
+	kvfree(dma_map->dma_pages);
+	kfree(dma_map);
+}
+
+static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
 {
 	dma_addr_t *dma;
 	u32 i;
 
-	if (pool->dma_pages_cnt == 0)
-		return;
-
-	for (i = 0; i < pool->dma_pages_cnt; i++) {
-		dma = &pool->dma_pages[i];
+	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
+		dma = &dma_map->dma_pages[i];
 		if (*dma) {
-			dma_unmap_page_attrs(pool->dev, *dma, PAGE_SIZE,
+			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
 					     DMA_BIDIRECTIONAL, attrs);
 			*dma = 0;
 		}
 	}
 
+	xp_destroy_dma_map(dma_map);
+}
+
+void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
+{
+	struct xsk_dma_map *dma_map;
+
+	if (pool->dma_pages_cnt == 0)
+		return;
+
+	dma_map = xp_find_dma_map(pool);
+	if (!dma_map) {
+		WARN(1, "Could not find dma_map for device");
+		return;
+	}
+
+	if (!refcount_dec_and_test(&dma_map->users))
+		return;
+
+	__xp_dma_unmap(dma_map, attrs);
 	kvfree(pool->dma_pages);
 	pool->dma_pages_cnt = 0;
 	pool->dev = NULL;
 }
 EXPORT_SYMBOL(xp_dma_unmap);
 
-static void xp_check_dma_contiguity(struct xsk_buff_pool *pool)
+static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
 {
 	u32 i;
 
-	for (i = 0; i < pool->dma_pages_cnt - 1; i++) {
-		if (pool->dma_pages[i] + PAGE_SIZE == pool->dma_pages[i + 1])
-			pool->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
+	for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
+		if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
+			dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
 		else
-			pool->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
+			dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
 	}
 }
 
+static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
+{
+	pool->dma_pages = kvcalloc(dma_map->dma_pages_cnt, sizeof(*pool->dma_pages), GFP_KERNEL);
+	if (!pool->dma_pages)
+		return -ENOMEM;
+
+	pool->dev = dma_map->dev;
+	pool->dma_pages_cnt = dma_map->dma_pages_cnt;
+	pool->dma_need_sync = dma_map->dma_need_sync;
+	refcount_inc(&dma_map->users);
+	memcpy(pool->dma_pages, dma_map->dma_pages,
+	       pool->dma_pages_cnt * sizeof(*pool->dma_pages));
+
+	return 0;
+}
+
 int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 	       unsigned long attrs, struct page **pages, u32 nr_pages)
 {
+	struct xsk_dma_map *dma_map;
 	dma_addr_t dma;
+	int err;
 	u32 i;
 
-	pool->dma_pages = kvcalloc(nr_pages, sizeof(*pool->dma_pages),
-				   GFP_KERNEL);
-	if (!pool->dma_pages)
-		return -ENOMEM;
+	dma_map = xp_find_dma_map(pool);
+	if (dma_map) {
+		err = xp_init_dma_info(pool, dma_map);
+		if (err)
+			return err;
 
-	pool->dev = dev;
-	pool->dma_pages_cnt = nr_pages;
-	pool->dma_need_sync = false;
+		return 0;
+	}
 
-	for (i = 0; i < pool->dma_pages_cnt; i++) {
+	dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
+	if (!dma_map)
+		return -ENOMEM;
+
+	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
 		dma = dma_map_page_attrs(dev, pages[i], 0, PAGE_SIZE,
 					 DMA_BIDIRECTIONAL, attrs);
 		if (dma_mapping_error(dev, dma)) {
-			xp_dma_unmap(pool, attrs);
+			__xp_dma_unmap(dma_map, attrs);
 			return -ENOMEM;
 		}
 		if (dma_need_sync(dev, dma))
-			pool->dma_need_sync = true;
-		pool->dma_pages[i] = dma;
+			dma_map->dma_need_sync = true;
+		dma_map->dma_pages[i] = dma;
 	}
 
 	if (pool->unaligned)
-		xp_check_dma_contiguity(pool);
+		xp_check_dma_contiguity(dma_map);
+
+	err = xp_init_dma_info(pool, dma_map);
+	if (err) {
+		__xp_dma_unmap(dma_map, attrs);
+		return err;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(xp_dma_map);
-- 
2.7.4

