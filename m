Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB80E60FAF3
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiJ0O6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiJ0O5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC25D9943
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D79B6236E
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E913C433C1;
        Thu, 27 Oct 2022 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882662;
        bh=98/P9v6OS3CoLWGGUxd42Qt5ATm7nnSFElef4v82yJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rsz6wiC/QS9chTzJrenZpXbQZN9Kar2bBZ7bX8vUFvPh0YEXgUNUdu2b77xGHef4P
         btBAOpE4lGcDwUbQgoJHIsc+UW+7vd6GVoZA90MbBGW2BRZipJ2jjn0AxVgGafqthS
         ew47ICuyiir5M3a3vty2Qu66Q1cvKwU/mLLeBiHrX9/smbJTkbTEUwZcFwdLlZIMi7
         MLm76bnqSM60GkCLsk+wF/M0NVnGErtX0iSFI3NyO6fBwHcwWEzLjL57NMoG2+JS1P
         DbWruMNteMfLl8VpI4wVl2Fkc8eRi+Rfii6aYbZ0vEgVH+1YPgbRiLf7oVRqOgJPl7
         jG2DnV+m3TNGA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 10/14] net/mlx5: DR, Allocate icm_chunks from their own slab allocator
Date:   Thu, 27 Oct 2022 15:56:39 +0100
Message-Id: <20221027145643.6618-11-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027145643.6618-1-saeed@kernel.org>
References: <20221027145643.6618-1-saeed@kernel.org>
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

SW steering allocates/frees lots of icm_chunk structs. To make this more
efficiently, create a separate kmem_cache and allocate these chunks from
this allocator.
By doing this we observe that the alloc/free "hiccups" frequency has
become much lower, which allows for a more steady rule insersion rate.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c       | 15 ++++++++++++++-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c     | 11 +++++++++--
 .../mellanox/mlx5/core/steering/dr_types.h        |  1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 3dc784b22741..3fbcb2883a26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -60,10 +60,19 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 {
 	int ret;
 
+	dmn->chunks_kmem_cache = kmem_cache_create("mlx5_dr_chunks",
+						   sizeof(struct mlx5dr_icm_chunk), 0,
+						   SLAB_HWCACHE_ALIGN, NULL);
+	if (!dmn->chunks_kmem_cache) {
+		mlx5dr_err(dmn, "Couldn't create chunks kmem_cache\n");
+		return -ENOMEM;
+	}
+
 	dmn->ste_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_STE);
 	if (!dmn->ste_icm_pool) {
 		mlx5dr_err(dmn, "Couldn't get icm memory\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_chunks_kmem_cache;
 	}
 
 	dmn->action_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_MODIFY_ACTION);
@@ -85,6 +94,9 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
 free_ste_icm_pool:
 	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+free_chunks_kmem_cache:
+	kmem_cache_destroy(dmn->chunks_kmem_cache);
+
 	return ret;
 }
 
@@ -93,6 +105,7 @@ static void dr_domain_uninit_mem_resources(struct mlx5dr_domain *dmn)
 	mlx5dr_send_info_pool_destroy(dmn);
 	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
 	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+	kmem_cache_destroy(dmn->chunks_kmem_cache);
 }
 
 static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 7ca1ef073f55..be02546a7de0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -9,6 +9,8 @@ struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
 	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
 	struct mlx5dr_domain *dmn;
+	struct kmem_cache *chunks_kmem_cache;
+
 	/* memory management */
 	struct mutex mutex; /* protect the ICM pool and ICM buddy */
 	struct list_head buddy_mem_list;
@@ -193,10 +195,13 @@ static void dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk, int offset)
 
 static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
 {
+	struct kmem_cache *chunks_cache =
+		chunk->buddy_mem->pool->chunks_kmem_cache;
+
 	chunk->buddy_mem->used_memory -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 	list_del(&chunk->chunk_list);
 
-	kvfree(chunk);
+	kmem_cache_free(chunks_cache, chunk);
 }
 
 static int dr_icm_buddy_init_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
@@ -302,10 +307,11 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 		    struct mlx5dr_icm_buddy_mem *buddy_mem_pool,
 		    unsigned int seg)
 {
+	struct kmem_cache *chunks_cache = buddy_mem_pool->pool->chunks_kmem_cache;
 	struct mlx5dr_icm_chunk *chunk;
 	int offset;
 
-	chunk = kvzalloc(sizeof(*chunk), GFP_KERNEL);
+	chunk = kmem_cache_alloc(chunks_cache, GFP_KERNEL);
 	if (!chunk)
 		return NULL;
 
@@ -482,6 +488,7 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 	pool->dmn = dmn;
 	pool->icm_type = icm_type;
 	pool->max_log_chunk_sz = max_log_chunk_sz;
+	pool->chunks_kmem_cache = dmn->chunks_kmem_cache;
 
 	INIT_LIST_HEAD(&pool->buddy_mem_list);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 244685453a27..4f38f0f5b352 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -915,6 +915,7 @@ struct mlx5dr_domain {
 	struct mlx5dr_icm_pool *action_icm_pool;
 	struct mlx5dr_send_info_pool *send_info_pool_rx;
 	struct mlx5dr_send_info_pool *send_info_pool_tx;
+	struct kmem_cache *chunks_kmem_cache;
 	struct mlx5dr_send_ring *send_ring;
 	struct mlx5dr_domain_info info;
 	struct xarray csum_fts_xa;
-- 
2.37.3

