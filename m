Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C3B2791ED
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgIYUTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgIYURc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:17:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFBE2388E;
        Fri, 25 Sep 2020 19:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062699;
        bh=T0WShaI33HrY6a/taEdwGA+cpk4JkS9NZE8/qEfb+T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tFWNMMoTwGg0z29Fp5VJh1cEP/cgevZuceDV6tP6tOjV+dDMQMvFdRUjDaf/4nEJ
         r24GkTChshi9/MsEoRMJNnSeQLs0D3WXALK8MrtEZN1S0heyGaFpSnuKFDH1TywpyQ
         +xeN6kCgAyGqLv8dixYFruZ4wogh7ziWB6gmkWRI=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: DR, Sync chunks only during free
Date:   Fri, 25 Sep 2020 12:37:57 -0700
Message-Id: <20200925193809.463047-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When freeing chunks, we want to sync the steering
so that all the "hot" memory will be written to ICM
and all the chunks that are in the hot_list will be
actually destroyed.
When allocating from the pool, we don't have a need
to sync the steering, as we're not freeing anything,
and sync might just hurt the performance in terms of
flow-per-second offloaded.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 2c5886b469f7..4d8330aab169 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -332,10 +332,6 @@ static int dr_icm_handle_buddies_get_mem(struct mlx5dr_icm_pool *pool,
 	bool new_mem = false;
 	int err;
 
-	/* Check if we have chunks that are waiting for sync-ste */
-	if (dr_icm_pool_is_sync_required(pool))
-		dr_icm_pool_sync_all_buddy_pools(pool);
-
 alloc_buddy_mem:
 	/* find the next free place from the buddy list */
 	list_for_each_entry(buddy_mem_pool, &pool->buddy_mem_list, list_node) {
@@ -409,12 +405,18 @@ mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 {
 	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
+	struct mlx5dr_icm_pool *pool = buddy->pool;
 
 	/* move the memory to the waiting list AKA "hot" */
-	mutex_lock(&buddy->pool->mutex);
+	mutex_lock(&pool->mutex);
 	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
 	buddy->hot_memory_size += chunk->byte_size;
-	mutex_unlock(&buddy->pool->mutex);
+
+	/* Check if we have chunks that are waiting for sync-ste */
+	if (dr_icm_pool_is_sync_required(pool))
+		dr_icm_pool_sync_all_buddy_pools(pool);
+
+	mutex_unlock(&pool->mutex);
 }
 
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
-- 
2.26.2

