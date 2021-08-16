Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98CB3EE057
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhHPXXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234212AbhHPXXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DABB60FA0;
        Mon, 16 Aug 2021 23:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156152;
        bh=4oFIptL8DNw3Fz4VPsN7kp+ilUa3IZ+p8+nWkJH5aY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tv7pfo6prFMAmg3ZUpEHUEuWC9Px0qZ6WICjhzWx4jwoCDHcucJOIZX7JPGjyai7C
         /y2LGg9diw+hS7FiAQHsYa7hr2oZbGSk0BOubEYIBoSYt4PhUnI5Uv0CDrx80G68SX
         ba9wZMTTZhO9M9V3F04dyn7rQxZtpk0UN7fMbefr5xaL0pSRReS2xcCyFW2gtKuzWn
         Tw7yr7tFHezjXaBpYns/qoEBSQipfK5KEn6DLA97SowAzSikKXNXpE1iheT0j7/JUI
         JcWnXF+74ESKO5mAYmn/a+LtGrY8PKUSYrG8VJ4EbVUXyz36r/17Ec4Rim4UadKyyO
         8bpPz2HHCy06A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 05/17] net/mlx5e: Dynamically allocate TIRs in RSS contexts
Date:   Mon, 16 Aug 2021 16:22:07 -0700
Message-Id: <20210816232219.557083-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816232219.557083-1-saeed@kernel.org>
References: <20210816232219.557083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Move from static to dynamic memory allocations for TIR.
This is in preparation to supporting on-demand TIR operations in
downstream patches, where every RSS context will be init with an
empty set of TIRs.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rss.c  | 69 +++++++++++++++----
 1 file changed, 56 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
index f4a72b6b8a02..34c5b8f0d100 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
@@ -71,8 +71,8 @@ struct mlx5e_rss {
 	struct mlx5e_rss_params_hash hash;
 	struct mlx5e_rss_params_indir indir;
 	u32 rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_tir tir[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_tir inner_tir[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_tir *tir[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_tir *inner_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_rqt rqt;
 	struct mlx5_core_dev *mdev;
 	u32 drop_rqn;
@@ -102,6 +102,18 @@ static void mlx5e_rss_params_init(struct mlx5e_rss *rss)
 			mlx5e_rss_get_default_tt_config(tt).rx_hash_fields;
 }
 
+static struct mlx5e_tir **rss_get_tirp(struct mlx5e_rss *rss, enum mlx5_traffic_types tt,
+				       bool inner)
+{
+	return inner ? &rss->inner_tir[tt] : &rss->tir[tt];
+}
+
+static struct mlx5e_tir *rss_get_tir(struct mlx5e_rss *rss, enum mlx5_traffic_types tt,
+				     bool inner)
+{
+	return *rss_get_tirp(rss, tt, inner);
+}
+
 static struct mlx5e_rss_params_traffic_type
 mlx5e_rss_get_tt_config(struct mlx5e_rss *rss, enum mlx5_traffic_types tt)
 {
@@ -119,6 +131,7 @@ static int mlx5e_rss_create_tir(struct mlx5e_rss *rss,
 {
 	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_tir_builder *builder;
+	struct mlx5e_tir **tir_p;
 	struct mlx5e_tir *tir;
 	u32 rqtn;
 	int err;
@@ -130,12 +143,20 @@ static int mlx5e_rss_create_tir(struct mlx5e_rss *rss,
 		return -EINVAL;
 	}
 
-	tir = inner ? &rss->inner_tir[tt] : &rss->tir[tt];
+	tir_p = rss_get_tirp(rss, tt, inner);
+	if (*tir_p)
+		return -EINVAL;
 
-	builder = mlx5e_tir_builder_alloc(false);
-	if (!builder)
+	tir = kvzalloc(sizeof(*tir), GFP_KERNEL);
+	if (!tir)
 		return -ENOMEM;
 
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder) {
+		err = -ENOMEM;
+		goto free_tir;
+	}
+
 	rqtn = mlx5e_rqt_get_rqtn(&rss->rqt);
 	mlx5e_tir_builder_build_rqt(builder, rss->mdev->mlx5e_res.hw_objs.td.tdn,
 				    rqtn, rss->inner_ft_support);
@@ -145,19 +166,34 @@ static int mlx5e_rss_create_tir(struct mlx5e_rss *rss,
 
 	err = mlx5e_tir_init(tir, builder, rss->mdev, true);
 	mlx5e_tir_builder_free(builder);
-	if (err)
+	if (err) {
 		mlx5e_rss_warn(rss->mdev, "Failed to create %sindirect TIR: err = %d, tt = %d\n",
 			       inner ? "inner " : "", err, tt);
+		goto free_tir;
+	}
+
+	*tir_p = tir;
+	return 0;
+
+free_tir:
+	kvfree(tir);
 	return err;
 }
 
 static void mlx5e_rss_destroy_tir(struct mlx5e_rss *rss, enum mlx5_traffic_types tt,
 				  bool inner)
 {
+	struct mlx5e_tir **tir_p;
 	struct mlx5e_tir *tir;
 
-	tir = inner ? &rss->inner_tir[tt] : &rss->tir[tt];
+	tir_p = rss_get_tirp(rss, tt, inner);
+	if (!*tir_p)
+		return;
+
+	tir = *tir_p;
 	mlx5e_tir_destroy(tir);
+	kvfree(tir);
+	*tir_p = NULL;
 }
 
 static int mlx5e_rss_create_tirs(struct mlx5e_rss *rss,
@@ -198,7 +234,9 @@ static int mlx5e_rss_update_tir(struct mlx5e_rss *rss, enum mlx5_traffic_types t
 	struct mlx5e_tir *tir;
 	int err;
 
-	tir = inner ? &rss->inner_tir[tt] : &rss->tir[tt];
+	tir = rss_get_tir(rss, tt, inner);
+	if (!tir)
+		return 0;
 
 	builder = mlx5e_tir_builder_alloc(true);
 	if (!builder)
@@ -295,7 +333,8 @@ u32 mlx5e_rss_get_tirn(struct mlx5e_rss *rss, enum mlx5_traffic_types tt,
 	struct mlx5e_tir *tir;
 
 	WARN_ON(inner && !rss->inner_ft_support);
-	tir = inner ? &rss->inner_tir[tt] : &rss->tir[tt];
+	tir = rss_get_tir(rss, tt, inner);
+	WARN_ON(!tir);
 
 	return mlx5e_tir_get_tirn(tir);
 }
@@ -342,10 +381,13 @@ int mlx5e_rss_lro_set_param(struct mlx5e_rss *rss, struct mlx5e_lro_param *lro_p
 	final_err = 0;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		err = mlx5e_tir_modify(&rss->tir[tt], builder);
+		struct mlx5e_tir *tir;
+
+		tir = rss_get_tir(rss, tt, false);
+		err = mlx5e_tir_modify(tir, builder);
 		if (err) {
 			mlx5e_rss_warn(rss->mdev, "Failed to update LRO state of indirect TIR %#x for traffic type %d: err = %d\n",
-				       mlx5e_tir_get_tirn(&rss->tir[tt]), tt, err);
+				       mlx5e_tir_get_tirn(rss->tir[tt]), tt, err);
 			if (!final_err)
 				final_err = err;
 		}
@@ -353,10 +395,11 @@ int mlx5e_rss_lro_set_param(struct mlx5e_rss *rss, struct mlx5e_lro_param *lro_p
 		if (!rss->inner_ft_support)
 			continue;
 
-		err = mlx5e_tir_modify(&rss->inner_tir[tt], builder);
+		tir = rss_get_tir(rss, tt, true);
+		err = mlx5e_tir_modify(tir, builder);
 		if (err) {
 			mlx5e_rss_warn(rss->mdev, "Failed to update LRO state of inner indirect TIR %#x for traffic type %d: err = %d\n",
-				       mlx5e_tir_get_tirn(&rss->inner_tir[tt]), tt, err);
+				       mlx5e_tir_get_tirn(rss->inner_tir[tt]), tt, err);
 			if (!final_err)
 				final_err = err;
 		}
-- 
2.31.1

