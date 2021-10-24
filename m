Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E72438B9B
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 21:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhJXTUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 15:20:16 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:57489 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhJXTUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 15:20:15 -0400
Received: from pop-os.home ([92.140.161.106])
        by smtp.orange.fr with ESMTPA
        id ej0CmbUB5dmYbej0CmLk0M; Sun, 24 Oct 2021 21:17:53 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 24 Oct 2021 21:17:53 +0200
X-ME-IP: 92.140.161.106
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mlxsw: spectrum: Use 'bitmap_zalloc()' when applicable
Date:   Sun, 24 Oct 2021 21:17:51 +0200
Message-Id: <daae11381ba197d91702cb23c6c1120571cb0b87.1635103002.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'bitmap_zalloc()' to simplify code, improve the semantic and avoid
some open-coded arithmetic in allocator arguments.

Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
consistency.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../ethernet/mellanox/mlxsw/spectrum_acl_atcam.c  |  8 +++-----
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c   | 15 ++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum_cnt.c    |  9 +++------
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c  | 11 ++++-------
 4 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c
index ded4cf658680..4b713832fdd5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c
@@ -119,7 +119,6 @@ mlxsw_sp_acl_atcam_region_12kb_init(struct mlxsw_sp_acl_atcam_region *aregion)
 {
 	struct mlxsw_sp *mlxsw_sp = aregion->region->mlxsw_sp;
 	struct mlxsw_sp_acl_atcam_region_12kb *region_12kb;
-	size_t alloc_size;
 	u64 max_lkey_id;
 	int err;
 
@@ -131,8 +130,7 @@ mlxsw_sp_acl_atcam_region_12kb_init(struct mlxsw_sp_acl_atcam_region *aregion)
 	if (!region_12kb)
 		return -ENOMEM;
 
-	alloc_size = BITS_TO_LONGS(max_lkey_id) * sizeof(unsigned long);
-	region_12kb->used_lkey_id = kzalloc(alloc_size, GFP_KERNEL);
+	region_12kb->used_lkey_id = bitmap_zalloc(max_lkey_id, GFP_KERNEL);
 	if (!region_12kb->used_lkey_id) {
 		err = -ENOMEM;
 		goto err_used_lkey_id_alloc;
@@ -149,7 +147,7 @@ mlxsw_sp_acl_atcam_region_12kb_init(struct mlxsw_sp_acl_atcam_region *aregion)
 	return 0;
 
 err_rhashtable_init:
-	kfree(region_12kb->used_lkey_id);
+	bitmap_free(region_12kb->used_lkey_id);
 err_used_lkey_id_alloc:
 	kfree(region_12kb);
 	return err;
@@ -161,7 +159,7 @@ mlxsw_sp_acl_atcam_region_12kb_fini(struct mlxsw_sp_acl_atcam_region *aregion)
 	struct mlxsw_sp_acl_atcam_region_12kb *region_12kb = aregion->priv;
 
 	rhashtable_destroy(&region_12kb->lkey_ht);
-	kfree(region_12kb->used_lkey_id);
+	bitmap_free(region_12kb->used_lkey_id);
 	kfree(region_12kb);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 7cccc41dd69c..31f7f4c3acc3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -36,7 +36,6 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	u64 max_tcam_regions;
 	u64 max_regions;
 	u64 max_groups;
-	size_t alloc_size;
 	int err;
 
 	mutex_init(&tcam->lock);
@@ -52,15 +51,13 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	if (max_tcam_regions < max_regions)
 		max_regions = max_tcam_regions;
 
-	alloc_size = sizeof(tcam->used_regions[0]) * BITS_TO_LONGS(max_regions);
-	tcam->used_regions = kzalloc(alloc_size, GFP_KERNEL);
+	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
 	if (!tcam->used_regions)
 		return -ENOMEM;
 	tcam->max_regions = max_regions;
 
 	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
-	alloc_size = sizeof(tcam->used_groups[0]) * BITS_TO_LONGS(max_groups);
-	tcam->used_groups = kzalloc(alloc_size, GFP_KERNEL);
+	tcam->used_groups = bitmap_zalloc(max_groups, GFP_KERNEL);
 	if (!tcam->used_groups) {
 		err = -ENOMEM;
 		goto err_alloc_used_groups;
@@ -76,9 +73,9 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_tcam_init:
-	kfree(tcam->used_groups);
+	bitmap_free(tcam->used_groups);
 err_alloc_used_groups:
-	kfree(tcam->used_regions);
+	bitmap_free(tcam->used_regions);
 	return err;
 }
 
@@ -89,8 +86,8 @@ void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
 
 	mutex_destroy(&tcam->lock);
 	ops->fini(mlxsw_sp, tcam->priv);
-	kfree(tcam->used_groups);
-	kfree(tcam->used_regions);
+	bitmap_free(tcam->used_groups);
+	bitmap_free(tcam->used_regions);
 }
 
 int mlxsw_sp_acl_tcam_priority_get(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index b65b93a2b9bc..fc2257753b9b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -122,7 +122,6 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	unsigned int sub_pools_count = ARRAY_SIZE(mlxsw_sp_counter_sub_pools);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_counter_pool *pool;
-	unsigned int map_size;
 	int err;
 
 	pool = kzalloc(struct_size(pool, sub_pools, sub_pools_count),
@@ -143,9 +142,7 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_COUNTERS,
 					  mlxsw_sp_counter_pool_occ_get, pool);
 
-	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
-
-	pool->usage = kzalloc(map_size, GFP_KERNEL);
+	pool->usage = bitmap_zalloc(pool->pool_size, GFP_KERNEL);
 	if (!pool->usage) {
 		err = -ENOMEM;
 		goto err_usage_alloc;
@@ -158,7 +155,7 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 
 err_sub_pools_init:
-	kfree(pool->usage);
+	bitmap_free(pool->usage);
 err_usage_alloc:
 	devlink_resource_occ_get_unregister(devlink,
 					    MLXSW_SP_RESOURCE_COUNTERS);
@@ -176,7 +173,7 @@ void mlxsw_sp_counter_pool_fini(struct mlxsw_sp *mlxsw_sp)
 	WARN_ON(find_first_bit(pool->usage, pool->pool_size) !=
 			       pool->pool_size);
 	WARN_ON(atomic_read(&pool->active_entries_count));
-	kfree(pool->usage);
+	bitmap_free(pool->usage);
 	devlink_resource_occ_get_unregister(devlink,
 					    MLXSW_SP_RESOURCE_COUNTERS);
 	kfree(pool);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 22fede5cb32c..81c7e8a7fcf5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1635,16 +1635,13 @@ mlxsw_sp_mid *__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 				  u16 fid)
 {
 	struct mlxsw_sp_mid *mid;
-	size_t alloc_size;
 
 	mid = kzalloc(sizeof(*mid), GFP_KERNEL);
 	if (!mid)
 		return NULL;
 
-	alloc_size = sizeof(unsigned long) *
-		     BITS_TO_LONGS(mlxsw_core_max_ports(mlxsw_sp->core));
-
-	mid->ports_in_mid = kzalloc(alloc_size, GFP_KERNEL);
+	mid->ports_in_mid = bitmap_zalloc(mlxsw_core_max_ports(mlxsw_sp->core),
+					  GFP_KERNEL);
 	if (!mid->ports_in_mid)
 		goto err_ports_in_mid_alloc;
 
@@ -1663,7 +1660,7 @@ mlxsw_sp_mid *__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 	return mid;
 
 err_write_mdb_entry:
-	kfree(mid->ports_in_mid);
+	bitmap_free(mid->ports_in_mid);
 err_ports_in_mid_alloc:
 	kfree(mid);
 	return NULL;
@@ -1680,7 +1677,7 @@ static int mlxsw_sp_port_remove_from_mid(struct mlxsw_sp_port *mlxsw_sp_port,
 			 mlxsw_core_max_ports(mlxsw_sp->core))) {
 		err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mid);
 		list_del(&mid->list);
-		kfree(mid->ports_in_mid);
+		bitmap_free(mid->ports_in_mid);
 		kfree(mid);
 	}
 	return err;
-- 
2.30.2

