Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9FE41E4B1
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhI3XWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347588AbhI3XWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F00A161262;
        Thu, 30 Sep 2021 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044056;
        bh=kBsB8CLU1r9GJZvRPsXaqnx6yor1iWaeWkGnoWno1n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMWMr7+mjPJlCmDYMNx4Eyc0aQWM3ccK5dHlZBcxX0dBVdN/pqY/VZT7gg+JRujhs
         vVTlIJKxzdX3jX7I0ssw6gsY6SSWSJL38NVz/2B1fL+QZ/rGSEZti7MS/OtfPThcnu
         NL++eV72bjmTXGwVzQNvDEWiFl5sc5Gdelt6hzjt36T0NNPxpX5gvJXtT0NWjdKe4k
         uAleI+Cknu+LHwdlJjXeYkvlP87DkV2e+4I4xuDSlCeSDdTLHc2/6jJUxgIYbpSGW/
         yB+STVtOzs6PlU2zivx77rqCPmEMgvkYw5vyFivd1svOUsGB79dFnEJNOw4zvT0Km3
         RlymHFvOwsRdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: DR, Support csum recalculation flow table on SFs
Date:   Thu, 30 Sep 2021 16:20:40 -0700
Message-Id: <20210930232050.41779-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Implement csum recalculation flow tables in XAarray instead of a fixed
array, thus adding support for csum recalc table on any valid vport
number, which enables this support for SFs.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   |  6 +--
 .../mellanox/mlx5/core/steering/dr_domain.c   | 53 ++++++++-----------
 .../mellanox/mlx5/core/steering/dr_types.h    | 12 ++---
 3 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index d09e99afc171..a41fac349981 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -513,9 +513,9 @@ static int dr_action_handle_cs_recalc(struct mlx5dr_domain *dmn,
 		/* If destination is vport we will get the FW flow table
 		 * that recalculates the CS and forwards to the vport.
 		 */
-		ret = mlx5dr_domain_cache_get_recalc_cs_ft_addr(dest_action->vport->dmn,
-								dest_action->vport->caps->num,
-								final_icm_addr);
+		ret = mlx5dr_domain_get_recalc_cs_ft_addr(dest_action->vport->dmn,
+							  dest_action->vport->caps->num,
+							  final_icm_addr);
 		if (ret) {
 			mlx5dr_err(dmn, "Failed to get FW cs recalc flow table\n");
 			return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index b61c5a8ba305..bb12e8faf096 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -9,48 +9,45 @@
 	 ((dmn)->info.caps.dmn_type##_sw_owner_v2 &&	\
 	  (dmn)->info.caps.sw_format_ver <= MLX5_STEERING_FORMAT_CONNECTX_6DX))
 
-static int dr_domain_init_cache(struct mlx5dr_domain *dmn)
+static void dr_domain_init_csum_recalc_fts(struct mlx5dr_domain *dmn)
 {
 	/* Per vport cached FW FT for checksum recalculation, this
-	 * recalculation is needed due to a HW bug.
+	 * recalculation is needed due to a HW bug in STEv0.
 	 */
-	dmn->cache.recalc_cs_ft = kcalloc(dmn->info.caps.num_vports,
-					  sizeof(dmn->cache.recalc_cs_ft[0]),
-					  GFP_KERNEL);
-	if (!dmn->cache.recalc_cs_ft)
-		return -ENOMEM;
-
-	return 0;
+	xa_init(&dmn->csum_fts_xa);
 }
 
-static void dr_domain_uninit_cache(struct mlx5dr_domain *dmn)
+static void dr_domain_uninit_csum_recalc_fts(struct mlx5dr_domain *dmn)
 {
-	int i;
-
-	for (i = 0; i < dmn->info.caps.num_vports; i++) {
-		if (!dmn->cache.recalc_cs_ft[i])
-			continue;
+	struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft;
+	unsigned long i;
 
-		mlx5dr_fw_destroy_recalc_cs_ft(dmn, dmn->cache.recalc_cs_ft[i]);
+	xa_for_each(&dmn->csum_fts_xa, i, recalc_cs_ft) {
+		if (recalc_cs_ft)
+			mlx5dr_fw_destroy_recalc_cs_ft(dmn, recalc_cs_ft);
 	}
 
-	kfree(dmn->cache.recalc_cs_ft);
+	xa_destroy(&dmn->csum_fts_xa);
 }
 
-int mlx5dr_domain_cache_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
-					      u16 vport_num,
-					      u64 *rx_icm_addr)
+int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
+					u16 vport_num,
+					u64 *rx_icm_addr)
 {
 	struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft;
+	int ret;
 
-	recalc_cs_ft = dmn->cache.recalc_cs_ft[vport_num];
+	recalc_cs_ft = xa_load(&dmn->csum_fts_xa, vport_num);
 	if (!recalc_cs_ft) {
-		/* Table not in cache, need to allocate a new one */
+		/* Table hasn't been created yet */
 		recalc_cs_ft = mlx5dr_fw_create_recalc_cs_ft(dmn, vport_num);
 		if (!recalc_cs_ft)
 			return -EINVAL;
 
-		dmn->cache.recalc_cs_ft[vport_num] = recalc_cs_ft;
+		ret = xa_err(xa_store(&dmn->csum_fts_xa, vport_num,
+				      recalc_cs_ft, GFP_KERNEL));
+		if (ret)
+			return ret;
 	}
 
 	*rx_icm_addr = recalc_cs_ft->rx_icm_addr;
@@ -346,16 +343,10 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type)
 		goto uninit_caps;
 	}
 
-	ret = dr_domain_init_cache(dmn);
-	if (ret) {
-		mlx5dr_err(dmn, "Failed initialize domain cache\n");
-		goto uninit_resourses;
-	}
+	dr_domain_init_csum_recalc_fts(dmn);
 
 	return dmn;
 
-uninit_resourses:
-	dr_domain_uninit_resources(dmn);
 uninit_caps:
 	dr_domain_caps_uninit(dmn);
 free_domain:
@@ -394,7 +385,7 @@ int mlx5dr_domain_destroy(struct mlx5dr_domain *dmn)
 
 	/* make sure resources are not used by the hardware */
 	mlx5dr_cmd_sync_steering(dmn->mdev);
-	dr_domain_uninit_cache(dmn);
+	dr_domain_uninit_csum_recalc_fts(dmn);
 	dr_domain_uninit_resources(dmn);
 	dr_domain_caps_uninit(dmn);
 	mutex_destroy(&dmn->info.tx.mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 4bf8156f0a87..a9cf4f55cacf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -827,10 +827,6 @@ struct mlx5dr_domain_info {
 	struct mlx5dr_cmd_caps caps;
 };
 
-struct mlx5dr_domain_cache {
-	struct mlx5dr_fw_recalc_cs_ft **recalc_cs_ft;
-};
-
 struct mlx5dr_domain {
 	struct mlx5dr_domain *peer_dmn;
 	struct mlx5_core_dev *mdev;
@@ -842,7 +838,7 @@ struct mlx5dr_domain {
 	struct mlx5dr_icm_pool *action_icm_pool;
 	struct mlx5dr_send_ring *send_ring;
 	struct mlx5dr_domain_info info;
-	struct mlx5dr_domain_cache cache;
+	struct xarray csum_fts_xa;
 	struct mlx5dr_ste_ctx *ste_ctx;
 };
 
@@ -1379,9 +1375,9 @@ struct mlx5dr_fw_recalc_cs_ft *
 mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn, u16 vport_num);
 void mlx5dr_fw_destroy_recalc_cs_ft(struct mlx5dr_domain *dmn,
 				    struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft);
-int mlx5dr_domain_cache_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
-					      u16 vport_num,
-					      u64 *rx_icm_addr);
+int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
+					u16 vport_num,
+					u64 *rx_icm_addr);
 int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    struct mlx5dr_cmd_flow_destination_hw_info *dest,
 			    int num_dest,
-- 
2.31.1

