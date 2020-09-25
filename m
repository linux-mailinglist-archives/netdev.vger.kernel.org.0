Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A27B2791DF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgIYURf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbgIYUPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:15:31 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDED7235FA;
        Fri, 25 Sep 2020 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062700;
        bh=E6/TQjHLvzV+eX5nZGd4y3WgQeenVPzhKnKOn+PsjRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4HmHRnexHgBHwPIK9Wyha/4fcoVhkoJBpJjtaarCbWR9nEAPWjF+LsEHJTsC6Djz
         cR17385Fnj5bSX+Hvt3Bf131RjZV7QQfYXHDt8kbqZFdE2JycgICEZwmMJnczLn5RO
         DV85Y7+kz0ti3a+vjDitHTZScij56ZFr87r2v7AQ=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: DR, Free buddy ICM memory if it is unused
Date:   Fri, 25 Sep 2020 12:37:59 -0700
Message-Id: <20200925193809.463047-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Track buddy's used ICM memory, and free it if all
of the buddy's memory bacame unused.
Do this only for STEs.
MODIFY_ACTION buddies are much smaller, so in case there
is a large amount of modify_header actions, which result
in large amount of MODIFY_ACTION buddies, doing this
cleanup during sync will result in performance hit while
not freeing significant amount of memory.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 14 ++++++++++----
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index c49f8e86f3bc..66c24767e3b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -175,10 +175,12 @@ get_chunk_icm_type(struct mlx5dr_icm_chunk *chunk)
 	return chunk->buddy_mem->pool->icm_type;
 }
 
-static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
+static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk,
+				 struct mlx5dr_icm_buddy_mem *buddy)
 {
 	enum mlx5dr_icm_type icm_type = get_chunk_icm_type(chunk);
 
+	buddy->used_memory -= chunk->byte_size;
 	list_del(&chunk->chunk_list);
 
 	if (icm_type == DR_ICM_TYPE_STE)
@@ -223,10 +225,10 @@ static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 	struct mlx5dr_icm_chunk *chunk, *next;
 
 	list_for_each_entry_safe(chunk, next, &buddy->hot_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
+		dr_icm_chunk_destroy(chunk, buddy);
 
 	list_for_each_entry_safe(chunk, next, &buddy->used_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
+		dr_icm_chunk_destroy(chunk, buddy);
 
 	dr_icm_pool_mr_destroy(buddy->icm_mr);
 
@@ -267,6 +269,7 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 		goto out_free_chunk;
 	}
 
+	buddy_mem_pool->used_memory += chunk->byte_size;
 	chunk->buddy_mem = buddy_mem_pool;
 	INIT_LIST_HEAD(&chunk->chunk_list);
 
@@ -306,8 +309,11 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 			mlx5dr_buddy_free_mem(buddy, chunk->seg,
 					      ilog2(chunk->num_of_entries));
 			pool->hot_memory_size -= chunk->byte_size;
-			dr_icm_chunk_destroy(chunk);
+			dr_icm_chunk_destroy(chunk, buddy);
 		}
+
+		if (!buddy->used_memory && pool->icm_type == DR_ICM_TYPE_STE)
+			dr_icm_buddy_destroy(buddy);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 93ddb9c3e6b6..0aaba0ae9cf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -141,6 +141,7 @@ struct mlx5dr_icm_buddy_mem {
 
 	/* This is the list of used chunks. HW may be accessing this memory */
 	struct list_head	used_list;
+	u64			used_memory;
 
 	/* Hardware may be accessing this memory but at some future,
 	 * undetermined time, it might cease to do so.
-- 
2.26.2

