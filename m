Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC602A87C5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732129AbgKEUNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:13:04 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6024 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732033AbgKEUNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:13:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45ccc0001>; Thu, 05 Nov 2020 12:13:00 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:13:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 06/12] net/mlx5: DR, Sync chunks only during free
Date:   Thu, 5 Nov 2020 12:12:36 -0800
Message-ID: <20201105201242.21716-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105201242.21716-1-saeedm@nvidia.com>
References: <20201105201242.21716-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607180; bh=/CXbSfyI/MbYr2+Ar+3wtDX8QM7y3m+T9ksjUkE6JnM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=DwyvGcvtPb6V4aExE52que42rUC7J8otyMpZhqT61Ur/RGu3iRyrk9gSgqhfDjLc6
         lLVbSUGosAAhsquWhE+zBPwAB7PCsR5rddFXBOyomPYrELK9WdbZg62DznaCvKHNSW
         u/ajcNAM7G97Kzrv1npNT+KxZiEA5pEgy+m2shhBB/a9v5aCMFosx56OSRnSgMdhjZ
         jnPS6GWZ/mBl1/KFu43UyEHGQrZ9y0sKt7F3qkPEIhGYDzTkKlgfCaKgmY0zdpUI/b
         Cs8pLbchmKmoOaxLQYAkj8Mnk97Gg/Wr0ca2Su53InnXt72I54Qoxf0tqsUjA/N4xJ
         hd4S4vscxeUlQ==
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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 2c5886b469f7..4d8330aab169 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -332,10 +332,6 @@ static int dr_icm_handle_buddies_get_mem(struct mlx5dr=
_icm_pool *pool,
 	bool new_mem =3D false;
 	int err;
=20
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
 	struct mlx5dr_icm_buddy_mem *buddy =3D chunk->buddy_mem;
+	struct mlx5dr_icm_pool *pool =3D buddy->pool;
=20
 	/* move the memory to the waiting list AKA "hot" */
-	mutex_lock(&buddy->pool->mutex);
+	mutex_lock(&pool->mutex);
 	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
 	buddy->hot_memory_size +=3D chunk->byte_size;
-	mutex_unlock(&buddy->pool->mutex);
+
+	/* Check if we have chunks that are waiting for sync-ste */
+	if (dr_icm_pool_is_sync_required(pool))
+		dr_icm_pool_sync_all_buddy_pools(pool);
+
+	mutex_unlock(&pool->mutex);
 }
=20
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
--=20
2.26.2

