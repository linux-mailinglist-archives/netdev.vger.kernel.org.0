Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3212A505E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgKCTsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:48:17 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18829 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729748AbgKCTsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:48:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b3fd0000>; Tue, 03 Nov 2020 11:48:13 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:48:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/12] net/mlx5: DR, Free unused buddy ICM memory
Date:   Tue, 3 Nov 2020 11:47:34 -0800
Message-ID: <20201103194738.64061-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432893; bh=ee/PPwuC9tk0h0HecSEiuRm1+zIIVnA8x8tkhbhIiFs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=FRVcOMtdWey9fc/AWsq/pu526Cy06CmRuLkP7tq/FHuKuCq8ZSOcObCpXv6AKIipx
         x171S8trb0fP1UgJUVCsitg5Bi0eLXgllpWhIxK0tA90H5CMkk54JORJgJexWSFMGF
         n89iksRqjyuztpnKRtxNURierhABLR8V2+6RngI9AGTo9bMfm+WJPyVks0ueKizW0O
         +S1fpxu8NWYNu+hvipUb4Ppe+xdlaKm4/oCPLaca/gfR6lFyYUlhr9r/7Bi9KkiT6Z
         OWUUCB6kKWPjuGCBCiO592w+R/EJrckXDEcSDw/ijlJUdEosH48RLms/PsBj7vD2Yw
         RRbJTpx1umwQw==
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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index c49f8e86f3bc..66c24767e3b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -175,10 +175,12 @@ get_chunk_icm_type(struct mlx5dr_icm_chunk *chunk)
 	return chunk->buddy_mem->pool->icm_type;
 }
=20
-static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
+static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk,
+				 struct mlx5dr_icm_buddy_mem *buddy)
 {
 	enum mlx5dr_icm_type icm_type =3D get_chunk_icm_type(chunk);
=20
+	buddy->used_memory -=3D chunk->byte_size;
 	list_del(&chunk->chunk_list);
=20
 	if (icm_type =3D=3D DR_ICM_TYPE_STE)
@@ -223,10 +225,10 @@ static void dr_icm_buddy_destroy(struct mlx5dr_icm_bu=
ddy_mem *buddy)
 	struct mlx5dr_icm_chunk *chunk, *next;
=20
 	list_for_each_entry_safe(chunk, next, &buddy->hot_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
+		dr_icm_chunk_destroy(chunk, buddy);
=20
 	list_for_each_entry_safe(chunk, next, &buddy->used_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
+		dr_icm_chunk_destroy(chunk, buddy);
=20
 	dr_icm_pool_mr_destroy(buddy->icm_mr);
=20
@@ -267,6 +269,7 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 		goto out_free_chunk;
 	}
=20
+	buddy_mem_pool->used_memory +=3D chunk->byte_size;
 	chunk->buddy_mem =3D buddy_mem_pool;
 	INIT_LIST_HEAD(&chunk->chunk_list);
=20
@@ -306,8 +309,11 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx=
5dr_icm_pool *pool)
 			mlx5dr_buddy_free_mem(buddy, chunk->seg,
 					      ilog2(chunk->num_of_entries));
 			pool->hot_memory_size -=3D chunk->byte_size;
-			dr_icm_chunk_destroy(chunk);
+			dr_icm_chunk_destroy(chunk, buddy);
 		}
+
+		if (!buddy->used_memory && pool->icm_type =3D=3D DR_ICM_TYPE_STE)
+			dr_icm_buddy_destroy(buddy);
 	}
=20
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index a483d7de9ea6..4177786b8eaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -141,6 +141,7 @@ struct mlx5dr_icm_buddy_mem {
=20
 	/* This is the list of used chunks. HW may be accessing this memory */
 	struct list_head	used_list;
+	u64			used_memory;
=20
 	/* Hardware may be accessing this memory but at some future,
 	 * undetermined time, it might cease to do so.
--=20
2.26.2

