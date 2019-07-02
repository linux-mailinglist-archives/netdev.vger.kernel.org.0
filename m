Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A6A5D1C6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfGBObu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:31:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53687 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfGBObu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 10:31:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B9D37B5BA;
        Tue,  2 Jul 2019 14:31:44 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-46.brq.redhat.com [10.40.200.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CF021001DD2;
        Tue,  2 Jul 2019 14:31:40 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 24DE43009AF0C;
        Tue,  2 Jul 2019 16:31:39 +0200 (CEST)
Subject: [PATCH] net: core: page_pool: add user refcnt and reintroduce
 page_pool_destroy
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        ivan.khoronzhuk@linaro.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Date:   Tue, 02 Jul 2019 16:31:39 +0200
Message-ID: <156207778364.29180.5111562317930943530.stgit@firesoul>
In-Reply-To: <20190702153902.0e42b0b2@carbon>
References: <20190702153902.0e42b0b2@carbon>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 02 Jul 2019 14:31:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Jesper recently removed page_pool_destroy() (from driver invocation) and
moved shutdown and free of page_pool into xdp_rxq_info_unreg(), in-order to
handle in-flight packets/pages. This created an asymmetry in drivers
create/destroy pairs.

This patch add page_pool user refcnt and reintroduce page_pool_destroy.
This serves two purposes, (1) simplify drivers error handling as driver now
drivers always calls page_pool_destroy() and don't need to track if
xdp_rxq_info_reg_mem_model() was unsuccessful. (2) allow special cases
where a single RX-queue (with a single page_pool) provides packets for two
net_device'es, and thus needs to register the same page_pool twice with two
xdp_rxq_info structures.

This patch is a modified version of Ivan Khoronzhuk's original patch.
Thus, Jesper gives author ownership to Ivan.

Link: https://lore.kernel.org/netdev/20190625175948.24771-2-ivan.khoronzhuk@linaro.org/
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---

To Ivan,
 If you agree with this patch, please add your Signed-off-by.

You can also say if you prefer to take this patch and make it
part of your driver patchset, what ever you prefer.
--Jesper

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 ++---
 drivers/net/ethernet/socionext/netsec.c           |    8 ++----
 include/net/page_pool.h                           |   27 +++++++++++++++++++++
 net/core/page_pool.c                              |    8 ++++++
 net/core/xdp.c                                    |    3 ++
 5 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1085040675ae..ce1c7a449eae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -545,10 +545,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	}
 	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 					 MEM_TYPE_PAGE_POOL, rq->page_pool);
-	if (err) {
-		page_pool_free(rq->page_pool);
+	if (err)
 		goto err_free;
-	}
 
 	for (i = 0; i < wq_sz; i++) {
 		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
@@ -613,6 +611,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	if (rq->xdp_prog)
 		bpf_prog_put(rq->xdp_prog);
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
+	page_pool_destroy(rq->page_pool);
 	mlx5_wq_destroy(&rq->wq_ctrl);
 
 	return err;
@@ -643,6 +642,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
 	}
 
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
+	page_pool_destroy(rq->page_pool);
 	mlx5_wq_destroy(&rq->wq_ctrl);
 }
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 5544a722543f..43ab0ce90704 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1210,15 +1210,11 @@ static void netsec_uninit_pkt_dring(struct netsec_priv *priv, int id)
 		}
 	}
 
-	/* Rx is currently using page_pool
-	 * since the pool is created during netsec_setup_rx_dring(), we need to
-	 * free the pool manually if the registration failed
-	 */
+	/* Rx is currently using page_pool */
 	if (id == NETSEC_RING_RX) {
 		if (xdp_rxq_info_is_reg(&dring->xdp_rxq))
 			xdp_rxq_info_unreg(&dring->xdp_rxq);
-		else
-			page_pool_free(dring->page_pool);
+		page_pool_destroy(dring->page_pool);
 	}
 
 	memset(dring->desc, 0, sizeof(struct netsec_desc) * DESC_NUM);
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ee9c871d2043..ea974856d0f7 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -101,6 +101,14 @@ struct page_pool {
 	struct ptr_ring ring;
 
 	atomic_t pages_state_release_cnt;
+
+	/* A page_pool is strictly tied to a single RX-queue being
+	 * protected by NAPI, due to above pp_alloc_cache.  This
+	 * refcnt serves two purposes. (1) simplify drivers error
+	 * handling, and (2) allow special cases where a single
+	 * RX-queue provides packet for two net_device'es.
+	 */
+	refcount_t user_cnt;
 };
 
 struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
@@ -134,6 +142,15 @@ static inline void page_pool_free(struct page_pool *pool)
 #endif
 }
 
+/* Drivers use this instead of page_pool_free */
+static inline void page_pool_destroy(struct page_pool *pool)
+{
+	if (!pool)
+		return;
+
+	page_pool_free(pool);
+}
+
 /* Never call this directly, use helpers below */
 void __page_pool_put_page(struct page_pool *pool,
 			  struct page *page, bool allow_direct);
@@ -201,4 +218,14 @@ static inline bool is_page_pool_compiled_in(void)
 #endif
 }
 
+static inline void page_pool_get(struct page_pool *pool)
+{
+	refcount_inc(&pool->user_cnt);
+}
+
+static inline bool page_pool_put(struct page_pool *pool)
+{
+	return refcount_dec_and_test(&pool->user_cnt);
+}
+
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b366f59885c1..3272dc7a8c81 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -49,6 +49,9 @@ static int page_pool_init(struct page_pool *pool,
 
 	atomic_set(&pool->pages_state_release_cnt, 0);
 
+	/* Driver calling page_pool_create() also call page_pool_destroy() */
+	refcount_set(&pool->user_cnt, 1);
+
 	if (pool->p.flags & PP_FLAG_DMA_MAP)
 		get_device(pool->p.dev);
 
@@ -70,6 +73,7 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
 		kfree(pool);
 		return ERR_PTR(err);
 	}
+
 	return pool;
 }
 EXPORT_SYMBOL(page_pool_create);
@@ -356,6 +360,10 @@ static void __warn_in_flight(struct page_pool *pool)
 
 void __page_pool_free(struct page_pool *pool)
 {
+	/* Only last user actually free/release resources */
+	if (!page_pool_put(pool))
+		return;
+
 	WARN(pool->alloc.count, "API usage violation");
 	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
 
diff --git a/net/core/xdp.c b/net/core/xdp.c
index b29d7b513a18..e57a0eb1feb7 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -372,6 +372,9 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 
 	mutex_unlock(&mem_id_lock);
 
+	if (type == MEM_TYPE_PAGE_POOL)
+		page_pool_get(xdp_alloc->page_pool);
+
 	trace_mem_connect(xdp_alloc, xdp_rxq);
 	return 0;
 err:

