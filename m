Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC5F44AAA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfFMS2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:28:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbfFMS2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:28:37 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1BFCD8553D;
        Thu, 13 Jun 2019 18:28:37 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-44.brq.redhat.com [10.40.200.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AE5E600C1;
        Thu, 13 Jun 2019 18:28:33 +0000 (UTC)
Received: from [192.168.5.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 634B33009AEFD;
        Thu, 13 Jun 2019 20:28:32 +0200 (CEST)
Subject: [PATCH net-next v1 06/11] page_pool: introduce page_pool_free and
 use in mlx5
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     toshiaki.makita1@gmail.com, grygorii.strashko@ti.com,
        ivan.khoronzhuk@linaro.org, mcroce@redhat.com
Date:   Thu, 13 Jun 2019 20:28:32 +0200
Message-ID: <156045051233.29115.17600022182643845874.stgit@firesoul>
In-Reply-To: <156045046024.29115.11802895015973488428.stgit@firesoul>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 13 Jun 2019 18:28:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case driver fails to register the page_pool with XDP return API (via
xdp_rxq_info_reg_mem_model()), then the driver can free the page_pool
resources more directly than calling page_pool_destroy(), which does a
unnecessarily RCU free procedure.

This patch is preparing for removing page_pool_destroy(), from driver
invocation.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 +++---
 include/net/page_pool.h                           |   11 +++++++++++
 net/core/page_pool.c                              |   15 +++++++++++----
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 457cc39423f2..07de9ca4c53c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -545,8 +545,10 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	}
 	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 					 MEM_TYPE_PAGE_POOL, rq->page_pool);
-	if (err)
+	if (err) {
+		page_pool_free(rq->page_pool);
 		goto err_free;
+	}
 
 	for (i = 0; i < wq_sz; i++) {
 		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
@@ -611,8 +613,6 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	if (rq->xdp_prog)
 		bpf_prog_put(rq->xdp_prog);
 	xdp_rxq_info_unreg(&rq->xdp_rxq);
-	if (rq->page_pool)
-		page_pool_destroy(rq->page_pool);
 	mlx5_wq_destroy(&rq->wq_ctrl);
 
 	return err;
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index e240fac4c5b9..754d980700df 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -111,6 +111,17 @@ struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 void page_pool_destroy(struct page_pool *pool);
 
+void __page_pool_free(struct page_pool *pool);
+static inline void page_pool_free(struct page_pool *pool)
+{
+	/* When page_pool isn't compiled-in, net/core/xdp.c doesn't
+	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
+	 */
+#ifdef CONFIG_PAGE_POOL
+	__page_pool_free(pool);
+#endif
+}
+
 /* Never call this directly, use helpers below */
 void __page_pool_put_page(struct page_pool *pool,
 			  struct page *page, bool allow_direct);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 205af7bd6d09..41391b5dc14c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -292,17 +292,24 @@ static void __page_pool_empty_ring(struct page_pool *pool)
 	}
 }
 
+void __page_pool_free(struct page_pool *pool)
+{
+	WARN(pool->alloc.count, "API usage violation");
+	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
+
+	ptr_ring_cleanup(&pool->ring, NULL);
+	kfree(pool);
+}
+EXPORT_SYMBOL(__page_pool_free);
+
 static void __page_pool_destroy_rcu(struct rcu_head *rcu)
 {
 	struct page_pool *pool;
 
 	pool = container_of(rcu, struct page_pool, rcu);
 
-	WARN(pool->alloc.count, "API usage violation");
-
 	__page_pool_empty_ring(pool);
-	ptr_ring_cleanup(&pool->ring, NULL);
-	kfree(pool);
+	__page_pool_free(pool);
 }
 
 /* Cleanup and release resources */

