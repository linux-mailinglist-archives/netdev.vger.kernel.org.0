Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC90453AE4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhKPU0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhKPU0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F36C617E4;
        Tue, 16 Nov 2021 20:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094217;
        bh=hcCAV6GNORiVHaVcsTD0f/8awC9SuMe2dTVVr/VJLxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFRVi2E0jXumOH3Xg1HrRygYqU9sfAwmQVcXfHel1DYHDQKdhTQgc5jkeW418g5kZ
         qGITY2Whq48eRbDVRQLIUtrBdJvyH/Ax/lpGkRS51haFLyI+xYuGRfZMo6W8DJ1txf
         PBvYvoxL59t2FSU1VGY70AZ13AAjmpwy/oA0AHs9edlJDhDErY78TysaCuUF9js36d
         gMH6oPxN3rko09kHSlsqYsgw3csc8om5y8ei31Ac7SQoXXoumnkiO01DVxeif4LYHD
         ky5Fm6vf6GDGynzPXpp+XU7TcXBYN+6qdGVXS13TtxM6pNXQXn09/ZkLP+cWbWYkLS
         pTeyM1pO7Vc/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/12] net/mlx5: DR, Handle eswitch manager and uplink vports separately
Date:   Tue, 16 Nov 2021 12:23:14 -0800
Message-Id: <20211116202321.283874-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When querying eswitch manager vport capabilities as "other = 1",
we encounter a FW compatibility issue with older FW versions.
To maintain backward compatibility, eswitch manager vport should
be queried as "other = 0" vport both for ECPF and non-ECPF cases.

This patch fixes these queries and improves the code readability
by handling eswitch manager and uplink vports separately, avoiding
the excessive 'if' conditions. Also, uplink caps are stored similar
to esw manager and not as part of xarray.

Fixes: dd4acb2a0954 ("net/mlx5: DR, Add missing query for vport 0")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c   | 56 ++++++++-----------
 .../mellanox/mlx5/core/steering/dr_types.h    |  1 +
 2 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 49089cbe897c..8cbd36c82b3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -135,25 +135,14 @@ static void dr_domain_fill_uplink_caps(struct mlx5dr_domain *dmn,
 
 static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 				 u16 vport_number,
+				 bool other_vport,
 				 struct mlx5dr_cmd_vport_cap *vport_caps)
 {
-	u16 cmd_vport = vport_number;
-	bool other_vport = true;
 	int ret;
 
-	if (vport_number == MLX5_VPORT_UPLINK) {
-		dr_domain_fill_uplink_caps(dmn, vport_caps);
-		return 0;
-	}
-
-	if (dmn->info.caps.is_ecpf && vport_number == MLX5_VPORT_ECPF) {
-		other_vport = false;
-		cmd_vport = 0;
-	}
-
 	ret = mlx5dr_cmd_query_esw_vport_context(dmn->mdev,
 						 other_vport,
-						 cmd_vport,
+						 vport_number,
 						 &vport_caps->icm_address_rx,
 						 &vport_caps->icm_address_tx);
 	if (ret)
@@ -161,7 +150,7 @@ static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 
 	ret = mlx5dr_cmd_query_gvmi(dmn->mdev,
 				    other_vport,
-				    cmd_vport,
+				    vport_number,
 				    &vport_caps->vport_gvmi);
 	if (ret)
 		return ret;
@@ -176,9 +165,15 @@ static int dr_domain_query_esw_mngr(struct mlx5dr_domain *dmn)
 {
 	return dr_domain_query_vport(dmn,
 				     dmn->info.caps.is_ecpf ? MLX5_VPORT_ECPF : 0,
+				     false,
 				     &dmn->info.caps.vports.esw_manager_caps);
 }
 
+static void dr_domain_query_uplink(struct mlx5dr_domain *dmn)
+{
+	dr_domain_fill_uplink_caps(dmn, &dmn->info.caps.vports.uplink_caps);
+}
+
 static struct mlx5dr_cmd_vport_cap *
 dr_domain_add_vport_cap(struct mlx5dr_domain *dmn, u16 vport)
 {
@@ -190,7 +185,7 @@ dr_domain_add_vport_cap(struct mlx5dr_domain *dmn, u16 vport)
 	if (!vport_caps)
 		return NULL;
 
-	ret = dr_domain_query_vport(dmn, vport, vport_caps);
+	ret = dr_domain_query_vport(dmn, vport, true, vport_caps);
 	if (ret) {
 		kvfree(vport_caps);
 		return NULL;
@@ -207,16 +202,26 @@ dr_domain_add_vport_cap(struct mlx5dr_domain *dmn, u16 vport)
 	return vport_caps;
 }
 
+static bool dr_domain_is_esw_mgr_vport(struct mlx5dr_domain *dmn, u16 vport)
+{
+	struct mlx5dr_cmd_caps *caps = &dmn->info.caps;
+
+	return (caps->is_ecpf && vport == MLX5_VPORT_ECPF) ||
+	       (!caps->is_ecpf && vport == 0);
+}
+
 struct mlx5dr_cmd_vport_cap *
 mlx5dr_domain_get_vport_cap(struct mlx5dr_domain *dmn, u16 vport)
 {
 	struct mlx5dr_cmd_caps *caps = &dmn->info.caps;
 	struct mlx5dr_cmd_vport_cap *vport_caps;
 
-	if ((caps->is_ecpf && vport == MLX5_VPORT_ECPF) ||
-	    (!caps->is_ecpf && vport == 0))
+	if (dr_domain_is_esw_mgr_vport(dmn, vport))
 		return &caps->vports.esw_manager_caps;
 
+	if (vport == MLX5_VPORT_UPLINK)
+		return &caps->vports.uplink_caps;
+
 vport_load:
 	vport_caps = xa_load(&caps->vports.vports_caps_xa, vport);
 	if (vport_caps)
@@ -241,17 +246,6 @@ static void dr_domain_clear_vports(struct mlx5dr_domain *dmn)
 	}
 }
 
-static int dr_domain_query_uplink(struct mlx5dr_domain *dmn)
-{
-	struct mlx5dr_cmd_vport_cap *vport_caps;
-
-	vport_caps = mlx5dr_domain_get_vport_cap(dmn, MLX5_VPORT_UPLINK);
-	if (!vport_caps)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
 				    struct mlx5dr_domain *dmn)
 {
@@ -281,11 +275,7 @@ static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
 		goto free_vports_caps_xa;
 	}
 
-	ret = dr_domain_query_uplink(dmn);
-	if (ret) {
-		mlx5dr_err(dmn, "Failed to query uplink vport caps (err: %d)", ret);
-		goto free_vports_caps_xa;
-	}
+	dr_domain_query_uplink(dmn);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 3028b776da00..2333c2439c28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -764,6 +764,7 @@ struct mlx5dr_roce_cap {
 
 struct mlx5dr_vports {
 	struct mlx5dr_cmd_vport_cap esw_manager_caps;
+	struct mlx5dr_cmd_vport_cap uplink_caps;
 	struct xarray vports_caps_xa;
 };
 
-- 
2.31.1

