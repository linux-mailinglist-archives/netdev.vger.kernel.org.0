Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296992791FF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgIYUVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgIYUTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:19:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 413122389E;
        Fri, 25 Sep 2020 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062699;
        bh=WIvyzRdZyEt4dgKqayjmEYa21CxO/LJj31/O+q3G8mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFSj4ttGDI0CzPt6XN0ro10t/yagpXCjxfxN5eNbJlulJtz7I8ajvM4HrZihtV6Ml
         Kqzz7qVc4xBBPx47FAuFNkfloFsi6Azw5gvAT2IKoEi7Ab7+CyFrShaxWUwi+SWq17
         WdjbSkt7nmnBiBYYzM9nQdDe6V/4IgPjZMFqlpsY=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Hamdan Igbaria <hamdani@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: DR, ICM memory pools sync optimization
Date:   Fri, 25 Sep 2020 12:37:58 -0700
Message-Id: <20200925193809.463047-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Track the pool's hot ICM memory when freeing/allocating
chunk, so that when checking if the sync is required, just
check if the pool hot memory has reached the sync threshold.

Signed-off-by: Hamdan Igbaria <hamdani@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 22 +++++--------------
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  2 --
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 4d8330aab169..c49f8e86f3bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -4,7 +4,7 @@
 #include "dr_types.h"
 
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
-#define DR_ICM_SYNC_THRESHOLD (64 * 1024 * 1024)
+#define DR_ICM_SYNC_THRESHOLD_POOL (64 * 1024 * 1024)
 
 struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
@@ -13,6 +13,7 @@ struct mlx5dr_icm_pool {
 	/* memory management */
 	struct mutex mutex; /* protect the ICM pool and ICM buddy */
 	struct list_head buddy_mem_list;
+	u64 hot_memory_size;
 };
 
 struct mlx5dr_icm_dm {
@@ -281,19 +282,8 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	u64 allow_hot_size, all_hot_mem = 0;
-	struct mlx5dr_icm_buddy_mem *buddy;
-
-	list_for_each_entry(buddy, &pool->buddy_mem_list, list_node) {
-		allow_hot_size =
-			mlx5dr_icm_pool_chunk_size_to_byte((buddy->max_order - 2),
-							   pool->icm_type);
-		all_hot_mem += buddy->hot_memory_size;
-
-		if (buddy->hot_memory_size > allow_hot_size ||
-		    all_hot_mem > DR_ICM_SYNC_THRESHOLD)
-			return true;
-	}
+	if (pool->hot_memory_size > DR_ICM_SYNC_THRESHOLD_POOL)
+		return true;
 
 	return false;
 }
@@ -315,7 +305,7 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 		list_for_each_entry_safe(chunk, tmp_chunk, &buddy->hot_list, chunk_list) {
 			mlx5dr_buddy_free_mem(buddy, chunk->seg,
 					      ilog2(chunk->num_of_entries));
-			buddy->hot_memory_size -= chunk->byte_size;
+			pool->hot_memory_size -= chunk->byte_size;
 			dr_icm_chunk_destroy(chunk);
 		}
 	}
@@ -410,7 +400,7 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	/* move the memory to the waiting list AKA "hot" */
 	mutex_lock(&pool->mutex);
 	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
-	buddy->hot_memory_size += chunk->byte_size;
+	pool->hot_memory_size += chunk->byte_size;
 
 	/* Check if we have chunks that are waiting for sync-ste */
 	if (dr_icm_pool_is_sync_required(pool))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 40bdbdc6e3f2..93ddb9c3e6b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -147,8 +147,6 @@ struct mlx5dr_icm_buddy_mem {
 	 * sync_ste command sets them free.
 	 */
 	struct list_head	hot_list;
-	/* indicates the byte size of hot mem */
-	unsigned int		hot_memory_size;
 };
 
 int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
-- 
2.26.2

