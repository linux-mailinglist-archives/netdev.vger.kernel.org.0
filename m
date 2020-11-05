Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1742A87C8
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgKEUNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:13:09 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5839 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732035AbgKEUNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:13:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45ccf0000>; Thu, 05 Nov 2020 12:13:03 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:13:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Hamdan Igbaria <hamdani@nvidia.com>,
        "Alex Vesker" <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 07/12] net/mlx5: DR, ICM memory pools sync optimization
Date:   Thu, 5 Nov 2020 12:12:37 -0800
Message-ID: <20201105201242.21716-8-saeedm@nvidia.com>
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
        t=1604607183; bh=ScUO9wawF/h4WRuYEbfD8YJbWMGxO/tN2OnhcBBRAyM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Qfnwb3/sRhQX5zoQeL46wKB8LIakpQkEikXZC3TLjnhEmq/HEx2F7X9xovftPtJ1O
         t54UdYBBfzz2rNRheFaEw2kVqyhGXdzRfbxpf+4gi99SenAdws4JL5R+6SWlCxnGwr
         qO5P3ichFcTQD/dW69WwUk36zxnC2qyEPCy25tDSJfCJW97mjXdZpO379ezucOlrQb
         BNTHiMMLYO2RMnxLmMFh1oU4XRFjyKPUKa3iz+Z8ecUPqGKfJR6fS12HRnjA0w+Yyi
         OgR9PDB4MAhVPDZGg0TT9P06gS4brMP7HX5aLqj8CFjbEJG9Tc6/30dkB53suAPmpW
         hLqJiCCs9O5sQ==
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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 4d8330aab169..c49f8e86f3bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -4,7 +4,7 @@
 #include "dr_types.h"
=20
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
-#define DR_ICM_SYNC_THRESHOLD (64 * 1024 * 1024)
+#define DR_ICM_SYNC_THRESHOLD_POOL (64 * 1024 * 1024)
=20
 struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
@@ -13,6 +13,7 @@ struct mlx5dr_icm_pool {
 	/* memory management */
 	struct mutex mutex; /* protect the ICM pool and ICM buddy */
 	struct list_head buddy_mem_list;
+	u64 hot_memory_size;
 };
=20
 struct mlx5dr_icm_dm {
@@ -281,19 +282,8 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
=20
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	u64 allow_hot_size, all_hot_mem =3D 0;
-	struct mlx5dr_icm_buddy_mem *buddy;
-
-	list_for_each_entry(buddy, &pool->buddy_mem_list, list_node) {
-		allow_hot_size =3D
-			mlx5dr_icm_pool_chunk_size_to_byte((buddy->max_order - 2),
-							   pool->icm_type);
-		all_hot_mem +=3D buddy->hot_memory_size;
-
-		if (buddy->hot_memory_size > allow_hot_size ||
-		    all_hot_mem > DR_ICM_SYNC_THRESHOLD)
-			return true;
-	}
+	if (pool->hot_memory_size > DR_ICM_SYNC_THRESHOLD_POOL)
+		return true;
=20
 	return false;
 }
@@ -315,7 +305,7 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5=
dr_icm_pool *pool)
 		list_for_each_entry_safe(chunk, tmp_chunk, &buddy->hot_list, chunk_list)=
 {
 			mlx5dr_buddy_free_mem(buddy, chunk->seg,
 					      ilog2(chunk->num_of_entries));
-			buddy->hot_memory_size -=3D chunk->byte_size;
+			pool->hot_memory_size -=3D chunk->byte_size;
 			dr_icm_chunk_destroy(chunk);
 		}
 	}
@@ -410,7 +400,7 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chu=
nk)
 	/* move the memory to the waiting list AKA "hot" */
 	mutex_lock(&pool->mutex);
 	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
-	buddy->hot_memory_size +=3D chunk->byte_size;
+	pool->hot_memory_size +=3D chunk->byte_size;
=20
 	/* Check if we have chunks that are waiting for sync-ste */
 	if (dr_icm_pool_is_sync_required(pool))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 25b7bda3ce4a..a483d7de9ea6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -147,8 +147,6 @@ struct mlx5dr_icm_buddy_mem {
 	 * sync_ste command sets them free.
 	 */
 	struct list_head	hot_list;
-	/* indicates the byte size of hot mem */
-	unsigned int		hot_memory_size;
 };
=20
 int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
--=20
2.26.2

