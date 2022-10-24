Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E30660B17D
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiJXQ0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiJXQ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B201A1633AE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9159261376
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC0DC433D6;
        Mon, 24 Oct 2022 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620052;
        bh=vkJAR8gPXYXxewNJIAj8D42aCJ/PToLkkRkDZZ8JzzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvvCp/6gm4Mj2ozRRH8S8sMl5BTxzHys8XDdiy408SsUYOFhsNwxkI5bOHRCus96C
         j/befugzuZ01HYFnCqtm54kduKsUcWatcgLnHDHFadJ19Vq6B3Lc3My0txnovRZtEc
         4lnwHNGQxaYFWWOytAZU9EX7zIDOSToaPpAPqfa47FgQxi/I94kLx3iwwIb7QO9Fy3
         gVnOFQ7eULu8bc+3kW99ImlBqEAZNCfmcvyIhJ/p94iA7zRxBewA9ozG1O5q5Ulype
         1ALNaDutS2eR1/t0put8SSsDCAQoyvKkXinvcwX80XUiiNaU1XQ60i+9K/CyQWBKUO
         2Ow3KgLMQQV1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 11/14] net/mlx5: DR, Allocate htbl from its own slab allocator
Date:   Mon, 24 Oct 2022 14:57:31 +0100
Message-Id: <20221024135734.69673-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

SW steering allocates/frees lots of htbl structs. Create a
separate kmem_cache and allocate htbls from this allocator.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c        | 14 +++++++++++++-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 10 ++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 12 +++++++++---
 .../mellanox/mlx5/core/steering/dr_types.h         |  4 ++++
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 3fbcb2883a26..9a9836218c8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -68,11 +68,20 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 		return -ENOMEM;
 	}
 
+	dmn->htbls_kmem_cache = kmem_cache_create("mlx5_dr_htbls",
+						  sizeof(struct mlx5dr_ste_htbl), 0,
+						  SLAB_HWCACHE_ALIGN, NULL);
+	if (!dmn->htbls_kmem_cache) {
+		mlx5dr_err(dmn, "Couldn't create hash tables kmem_cache\n");
+		ret = -ENOMEM;
+		goto free_chunks_kmem_cache;
+	}
+
 	dmn->ste_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_STE);
 	if (!dmn->ste_icm_pool) {
 		mlx5dr_err(dmn, "Couldn't get icm memory\n");
 		ret = -ENOMEM;
-		goto free_chunks_kmem_cache;
+		goto free_htbls_kmem_cache;
 	}
 
 	dmn->action_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_MODIFY_ACTION);
@@ -94,6 +103,8 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
 free_ste_icm_pool:
 	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+free_htbls_kmem_cache:
+	kmem_cache_destroy(dmn->htbls_kmem_cache);
 free_chunks_kmem_cache:
 	kmem_cache_destroy(dmn->chunks_kmem_cache);
 
@@ -105,6 +116,7 @@ static void dr_domain_uninit_mem_resources(struct mlx5dr_domain *dmn)
 	mlx5dr_send_info_pool_destroy(dmn);
 	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
 	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+	kmem_cache_destroy(dmn->htbls_kmem_cache);
 	kmem_cache_destroy(dmn->chunks_kmem_cache);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index be02546a7de0..ca91a0211a5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -470,6 +470,16 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	mutex_unlock(&pool->mutex);
 }
 
+struct mlx5dr_ste_htbl *mlx5dr_icm_pool_alloc_htbl(struct mlx5dr_icm_pool *pool)
+{
+	return kmem_cache_alloc(pool->dmn->htbls_kmem_cache, GFP_KERNEL);
+}
+
+void mlx5dr_icm_pool_free_htbl(struct mlx5dr_icm_pool *pool, struct mlx5dr_ste_htbl *htbl)
+{
+	kmem_cache_free(pool->dmn->htbls_kmem_cache, htbl);
+}
+
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 					       enum mlx5dr_icm_type icm_type)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 09ebd3088857..9e19a8dc9022 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -491,7 +491,7 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 	u32 num_entries;
 	int i;
 
-	htbl = kzalloc(sizeof(*htbl), GFP_KERNEL);
+	htbl = mlx5dr_icm_pool_alloc_htbl(pool);
 	if (!htbl)
 		return NULL;
 
@@ -503,6 +503,9 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 	htbl->lu_type = lu_type;
 	htbl->byte_mask = byte_mask;
 	htbl->refcount = 0;
+	htbl->pointing_ste = NULL;
+	htbl->ctrl.num_of_valid_entries = 0;
+	htbl->ctrl.num_of_collisions = 0;
 	num_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
 
 	for (i = 0; i < num_entries; i++) {
@@ -517,17 +520,20 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 	return htbl;
 
 out_free_htbl:
-	kfree(htbl);
+	mlx5dr_icm_pool_free_htbl(pool, htbl);
 	return NULL;
 }
 
 int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl)
 {
+	struct mlx5dr_icm_pool *pool = htbl->chunk->buddy_mem->pool;
+
 	if (htbl->refcount)
 		return -EBUSY;
 
 	mlx5dr_icm_free_chunk(htbl->chunk);
-	kfree(htbl);
+	mlx5dr_icm_pool_free_htbl(pool, htbl);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 4f38f0f5b352..b645c0ab9a72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -916,6 +916,7 @@ struct mlx5dr_domain {
 	struct mlx5dr_send_info_pool *send_info_pool_rx;
 	struct mlx5dr_send_info_pool *send_info_pool_tx;
 	struct kmem_cache *chunks_kmem_cache;
+	struct kmem_cache *htbls_kmem_cache;
 	struct mlx5dr_send_ring *send_ring;
 	struct mlx5dr_domain_info info;
 	struct xarray csum_fts_xa;
@@ -1162,6 +1163,9 @@ u32 mlx5dr_icm_pool_get_chunk_num_of_entries(struct mlx5dr_icm_chunk *chunk);
 u32 mlx5dr_icm_pool_get_chunk_byte_size(struct mlx5dr_icm_chunk *chunk);
 u8 *mlx5dr_ste_get_hw_ste(struct mlx5dr_ste *ste);
 
+struct mlx5dr_ste_htbl *mlx5dr_icm_pool_alloc_htbl(struct mlx5dr_icm_pool *pool);
+void mlx5dr_icm_pool_free_htbl(struct mlx5dr_icm_pool *pool, struct mlx5dr_ste_htbl *htbl);
+
 static inline int
 mlx5dr_icm_pool_dm_type_to_entry_size(enum mlx5dr_icm_type icm_type)
 {
-- 
2.37.3

