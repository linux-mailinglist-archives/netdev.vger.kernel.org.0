Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1C93EDF34
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhHPVTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233357AbhHPVTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC2A61076;
        Mon, 16 Aug 2021 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148742;
        bh=IV2gDNgrYdBqhc1Gq99L9m+yvozhCI+sdkANw0y05MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYBVTuOYjQkysf8Pfq40KEKN3qpOxHbV+DjGA0dxWoAgQzSzcSQSEw+ibD/DFkswR
         nXIrG5mcCP1V11Inx1Re3C9RUwX+aizfbFLYyL+xON+JQxBt8cc7m1srjot2A5DNQX
         //cMjsUUwoe9UqmcLmhlo+ZkrRFZgYD0z78gc3lbRzc4Fu8YREMAASMQ2XaO3QYi7K
         HnF4c1HoGeakyJcaX5tbHLaOhj9mbV5AS3/eFayNep5soPz1XlAWuvyG5ZOfIIgegm
         K42Cf1j1cVh4Bvq5B8F50pJU7qUNj13JhTswpEllO4qmJ0I4Zrm02KkNzoo5WMGZiZ
         85Mb95O8RAbfA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/17] net/mlx5e: Introduce abstraction of RSS context
Date:   Mon, 16 Aug 2021 14:18:33 -0700
Message-Id: <20210816211847.526937-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816211847.526937-1-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Bring all fields that define and maintain RSS behavior together
into a new structure.
Align all usages with this new structure. Keep it hidden within
rx_res.c.
This helps supporting multiple RSS contexts in downstream patch.

Use dynamic allocations for the RSS context.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   | 170 +++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   6 +-
 3 files changed, 105 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index dfa492a14928..336930cfd632 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -64,24 +64,22 @@ mlx5e_rss_get_default_tt_config(enum mlx5_traffic_types tt)
 	return rss_default_config[tt];
 }
 
+struct mlx5e_rss {
+	struct mlx5e_rss_params_hash hash;
+	struct mlx5e_rss_params_indir indir;
+	u32 rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_tir tir[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_tir inner_tir[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_rqt rqt;
+};
+
 struct mlx5e_rx_res {
 	struct mlx5_core_dev *mdev;
 	enum mlx5e_rx_res_features features;
 	unsigned int max_nch;
 	u32 drop_rqn;
 
-	struct {
-		struct mlx5e_rss_params_hash hash;
-		struct mlx5e_rss_params_indir indir;
-		u32 rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
-	} rss_params;
-
-	struct mlx5e_rqt indir_rqt;
-	struct {
-		struct mlx5e_tir indir_tir;
-		struct mlx5e_tir inner_indir_tir;
-	} rss[MLX5E_NUM_INDIR_TIRS];
-
+	struct mlx5e_rss *rss;
 	bool rss_active;
 	u32 rss_rqns[MLX5E_INDIR_RQT_SIZE];
 	unsigned int rss_nch;
@@ -106,14 +104,15 @@ struct mlx5e_rx_res *mlx5e_rx_res_alloc(void)
 
 static void mlx5e_rx_res_rss_params_init(struct mlx5e_rx_res *res, unsigned int init_nch)
 {
+	struct mlx5e_rss *rss = res->rss;
 	enum mlx5_traffic_types tt;
 
-	res->rss_params.hash.hfunc = ETH_RSS_HASH_TOP;
-	netdev_rss_key_fill(res->rss_params.hash.toeplitz_hash_key,
-			    sizeof(res->rss_params.hash.toeplitz_hash_key));
-	mlx5e_rss_params_indir_init_uniform(&res->rss_params.indir, init_nch);
+	rss->hash.hfunc = ETH_RSS_HASH_TOP;
+	netdev_rss_key_fill(rss->hash.toeplitz_hash_key,
+			    sizeof(rss->hash.toeplitz_hash_key));
+	mlx5e_rss_params_indir_init_uniform(&rss->indir, init_nch);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		res->rss_params.rx_hash_fields[tt] =
+		rss->rx_hash_fields[tt] =
 			mlx5e_rss_get_default_tt_config(tt).rx_hash_fields;
 }
 
@@ -121,9 +120,10 @@ static void mlx5e_rx_res_rss_destroy_tir(struct mlx5e_rx_res *res,
 					 enum mlx5_traffic_types tt,
 					 bool inner)
 {
+	struct mlx5e_rss *rss = res->rss;
 	struct mlx5e_tir *tir;
 
-	tir = inner ? &res->rss[tt].inner_indir_tir : &res->rss[tt].indir_tir;
+	tir = inner ? &rss->inner_tir[tt] : &rss->tir[tt];
 	mlx5e_tir_destroy(tir);
 }
 
@@ -135,18 +135,19 @@ static int mlx5e_rx_res_rss_create_tir(struct mlx5e_rx_res *res,
 {
 	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
 	struct mlx5e_rss_params_traffic_type rss_tt;
+	struct mlx5e_rss *rss = res->rss;
 	struct mlx5e_tir *tir;
 	u32 rqtn;
 	int err;
 
-	tir = inner ? &res->rss[tt].inner_indir_tir : &res->rss[tt].indir_tir;
+	tir = inner ? &rss->inner_tir[tt] : &rss->tir[tt];
 
-	rqtn = mlx5e_rqt_get_rqtn(&res->indir_rqt);
+	rqtn = mlx5e_rqt_get_rqtn(&rss->rqt);
 	mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
 				    rqtn, inner_ft_support);
 	mlx5e_tir_builder_build_lro(builder, init_lro_param);
 	rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
-	mlx5e_tir_builder_build_rss(builder, &res->rss_params.hash, &rss_tt, inner);
+	mlx5e_tir_builder_build_rss(builder, &rss->hash, &rss_tt, inner);
 
 	err = mlx5e_tir_init(tir, builder, res->mdev, true);
 	if (err) {
@@ -198,14 +199,24 @@ static void mlx5e_rx_res_rss_destroy_tirs(struct mlx5e_rx_res *res, bool inner)
 }
 
 static int mlx5e_rx_res_rss_init(struct mlx5e_rx_res *res,
-				 const struct mlx5e_lro_param *init_lro_param)
+				 const struct mlx5e_lro_param *init_lro_param,
+				 unsigned int init_nch)
 {
 	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
+	struct mlx5e_rss *rss;
 	int err;
 
-	err = mlx5e_rqt_init_direct(&res->indir_rqt, res->mdev, true, res->drop_rqn);
+	rss = kvzalloc(sizeof(*rss), GFP_KERNEL);
+	if (!rss)
+		return -ENOMEM;
+
+	res->rss = rss;
+
+	mlx5e_rx_res_rss_params_init(res, init_nch);
+
+	err = mlx5e_rqt_init_direct(&rss->rqt, res->mdev, true, res->drop_rqn);
 	if (err)
-		return err;
+		goto err_free_rss;
 
 	err = mlx5e_rx_res_rss_create_tirs(res, init_lro_param, false);
 	if (err)
@@ -223,8 +234,11 @@ static int mlx5e_rx_res_rss_init(struct mlx5e_rx_res *res,
 	mlx5e_rx_res_rss_destroy_tirs(res, false);
 
 err_destroy_rqt:
-	mlx5e_rqt_destroy(&res->indir_rqt);
+	mlx5e_rqt_destroy(&rss->rqt);
 
+err_free_rss:
+	kvfree(rss);
+	res->rss = NULL;
 	return err;
 }
 
@@ -367,12 +381,16 @@ static int mlx5e_rx_res_ptp_init(struct mlx5e_rx_res *res)
 
 static void mlx5e_rx_res_rss_destroy(struct mlx5e_rx_res *res)
 {
+	struct mlx5e_rss *rss = res->rss;
+
 	mlx5e_rx_res_rss_destroy_tirs(res, false);
 
 	if (res->features & MLX5E_RX_RES_FEATURE_INNER_FT)
 		mlx5e_rx_res_rss_destroy_tirs(res, true);
 
-	mlx5e_rqt_destroy(&res->indir_rqt);
+	mlx5e_rqt_destroy(&rss->rqt);
+	kvfree(rss);
+	res->rss = NULL;
 }
 
 static void mlx5e_rx_res_channels_destroy(struct mlx5e_rx_res *res)
@@ -411,9 +429,7 @@ int mlx5e_rx_res_init(struct mlx5e_rx_res *res, struct mlx5_core_dev *mdev,
 	res->max_nch = max_nch;
 	res->drop_rqn = drop_rqn;
 
-	mlx5e_rx_res_rss_params_init(res, init_nch);
-
-	err = mlx5e_rx_res_rss_init(res, init_lro_param);
+	err = mlx5e_rx_res_rss_init(res, init_lro_param, init_nch);
 	if (err)
 		return err;
 
@@ -460,13 +476,17 @@ u32 mlx5e_rx_res_get_tirn_xsk(struct mlx5e_rx_res *res, unsigned int ix)
 
 u32 mlx5e_rx_res_get_tirn_rss(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt)
 {
-	return mlx5e_tir_get_tirn(&res->rss[tt].indir_tir);
+	struct mlx5e_rss *rss = res->rss;
+
+	return mlx5e_tir_get_tirn(&rss->tir[tt]);
 }
 
 u32 mlx5e_rx_res_get_tirn_rss_inner(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt)
 {
+	struct mlx5e_rss *rss = res->rss;
+
 	WARN_ON(!(res->features & MLX5E_RX_RES_FEATURE_INNER_FT));
-	return mlx5e_tir_get_tirn(&res->rss[tt].inner_indir_tir);
+	return mlx5e_tir_get_tirn(&rss->inner_tir[tt]);
 }
 
 u32 mlx5e_rx_res_get_tirn_ptp(struct mlx5e_rx_res *res)
@@ -482,28 +502,30 @@ u32 mlx5e_rx_res_get_rqtn_direct(struct mlx5e_rx_res *res, unsigned int ix)
 
 static void mlx5e_rx_res_rss_enable(struct mlx5e_rx_res *res)
 {
+	struct mlx5e_rss *rss = res->rss;
 	int err;
 
 	res->rss_active = true;
 
-	err = mlx5e_rqt_redirect_indir(&res->indir_rqt, res->rss_rqns, res->rss_nch,
-				       res->rss_params.hash.hfunc,
-				       &res->rss_params.indir);
+	err = mlx5e_rqt_redirect_indir(&rss->rqt, res->rss_rqns, res->rss_nch,
+				       rss->hash.hfunc,
+				       &rss->indir);
 	if (err)
-		mlx5_core_warn(res->mdev, "Failed to redirect indirect RQT %#x to channels: err = %d\n",
-			       mlx5e_rqt_get_rqtn(&res->indir_rqt), err);
+		mlx5_core_warn(res->mdev, "Failed to redirect RQT %#x to channels: err = %d\n",
+			       mlx5e_rqt_get_rqtn(&rss->rqt), err);
 }
 
 static void mlx5e_rx_res_rss_disable(struct mlx5e_rx_res *res)
 {
+	struct mlx5e_rss *rss = res->rss;
 	int err;
 
 	res->rss_active = false;
 
-	err = mlx5e_rqt_redirect_direct(&res->indir_rqt, res->drop_rqn);
+	err = mlx5e_rqt_redirect_direct(&rss->rqt, res->drop_rqn);
 	if (err)
-		mlx5_core_warn(res->mdev, "Failed to redirect indirect RQT %#x to drop RQ %#x: err = %d\n",
-			       mlx5e_rqt_get_rqtn(&res->indir_rqt), res->drop_rqn, err);
+		mlx5_core_warn(res->mdev, "Failed to redirect RQT %#x to drop RQ %#x: err = %d\n",
+			       mlx5e_rqt_get_rqtn(&rss->rqt), res->drop_rqn, err);
 }
 
 void mlx5e_rx_res_channels_activate(struct mlx5e_rx_res *res, struct mlx5e_channels *chs)
@@ -637,9 +659,10 @@ struct mlx5e_rss_params_traffic_type
 mlx5e_rx_res_rss_get_current_tt_config(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt)
 {
 	struct mlx5e_rss_params_traffic_type rss_tt;
+	struct mlx5e_rss *rss = res->rss;
 
 	rss_tt = mlx5e_rss_get_default_tt_config(tt);
-	rss_tt.rx_hash_fields = res->rss_params.rx_hash_fields[tt];
+	rss_tt.rx_hash_fields = rss->rx_hash_fields[tt];
 	return rss_tt;
 }
 
@@ -647,23 +670,26 @@ mlx5e_rx_res_rss_get_current_tt_config(struct mlx5e_rx_res *res, enum mlx5_traff
 void mlx5e_rx_res_rss_set_indir_uniform(struct mlx5e_rx_res *res, unsigned int nch)
 {
 	WARN_ON_ONCE(res->rss_active);
-	mlx5e_rss_params_indir_init_uniform(&res->rss_params.indir, nch);
+	mlx5e_rss_params_indir_init_uniform(&res->rss->indir, nch);
 }
 
-void mlx5e_rx_res_rss_get_rxfh(struct mlx5e_rx_res *res, u32 *indir, u8 *key, u8 *hfunc)
+int mlx5e_rx_res_rss_get_rxfh(struct mlx5e_rx_res *res, u32 *indir, u8 *key, u8 *hfunc)
 {
+	struct mlx5e_rss *rss = res->rss;
 	unsigned int i;
 
 	if (indir)
 		for (i = 0; i < MLX5E_INDIR_RQT_SIZE; i++)
-			indir[i] = res->rss_params.indir.table[i];
+			indir[i] = rss->indir.table[i];
 
 	if (key)
-		memcpy(key, res->rss_params.hash.toeplitz_hash_key,
-		       sizeof(res->rss_params.hash.toeplitz_hash_key));
+		memcpy(key, rss->hash.toeplitz_hash_key,
+		       sizeof(rss->hash.toeplitz_hash_key));
 
 	if (hfunc)
-		*hfunc = res->rss_params.hash.hfunc;
+		*hfunc = rss->hash.hfunc;
+
+	return 0;
 }
 
 static int mlx5e_rx_res_rss_update_tir(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt,
@@ -671,6 +697,7 @@ static int mlx5e_rx_res_rss_update_tir(struct mlx5e_rx_res *res, enum mlx5_traff
 {
 	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_tir_builder *builder;
+	struct mlx5e_rss *rss = res->rss;
 	struct mlx5e_tir *tir;
 	int err;
 
@@ -680,8 +707,8 @@ static int mlx5e_rx_res_rss_update_tir(struct mlx5e_rx_res *res, enum mlx5_traff
 
 	rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
 
-	mlx5e_tir_builder_build_rss(builder, &res->rss_params.hash, &rss_tt, inner);
-	tir = inner ? &res->rss[tt].inner_indir_tir : &res->rss[tt].indir_tir;
+	mlx5e_tir_builder_build_rss(builder, &rss->hash, &rss_tt, inner);
+	tir = inner ? &rss->inner_tir[tt] : &rss->tir[tt];
 	err = mlx5e_tir_modify(tir, builder);
 
 	mlx5e_tir_builder_free(builder);
@@ -691,12 +718,13 @@ static int mlx5e_rx_res_rss_update_tir(struct mlx5e_rx_res *res, enum mlx5_traff
 int mlx5e_rx_res_rss_set_rxfh(struct mlx5e_rx_res *res, const u32 *indir,
 			      const u8 *key, const u8 *hfunc)
 {
+	struct mlx5e_rss *rss = res->rss;
 	enum mlx5_traffic_types tt;
 	bool changed_indir = false;
 	bool changed_hash = false;
 	int err;
 
-	if (hfunc && *hfunc != res->rss_params.hash.hfunc) {
+	if (hfunc && *hfunc != rss->hash.hfunc) {
 		switch (*hfunc) {
 		case ETH_RSS_HASH_XOR:
 		case ETH_RSS_HASH_TOP:
@@ -706,14 +734,14 @@ int mlx5e_rx_res_rss_set_rxfh(struct mlx5e_rx_res *res, const u32 *indir,
 		}
 		changed_hash = true;
 		changed_indir = true;
-		res->rss_params.hash.hfunc = *hfunc;
+		rss->hash.hfunc = *hfunc;
 	}
 
 	if (key) {
-		if (res->rss_params.hash.hfunc == ETH_RSS_HASH_TOP)
+		if (rss->hash.hfunc == ETH_RSS_HASH_TOP)
 			changed_hash = true;
-		memcpy(res->rss_params.hash.toeplitz_hash_key, key,
-		       sizeof(res->rss_params.hash.toeplitz_hash_key));
+		memcpy(rss->hash.toeplitz_hash_key, key,
+		       sizeof(rss->hash.toeplitz_hash_key));
 	}
 
 	if (indir) {
@@ -722,16 +750,15 @@ int mlx5e_rx_res_rss_set_rxfh(struct mlx5e_rx_res *res, const u32 *indir,
 		changed_indir = true;
 
 		for (i = 0; i < MLX5E_INDIR_RQT_SIZE; i++)
-			res->rss_params.indir.table[i] = indir[i];
+			rss->indir.table[i] = indir[i];
 	}
 
 	if (changed_indir && res->rss_active) {
-		err = mlx5e_rqt_redirect_indir(&res->indir_rqt, res->rss_rqns, res->rss_nch,
-					       res->rss_params.hash.hfunc,
-					       &res->rss_params.indir);
+		err = mlx5e_rqt_redirect_indir(&rss->rqt, res->rss_rqns, res->rss_nch,
+					       rss->hash.hfunc, &rss->indir);
 		if (err)
 			mlx5_core_warn(res->mdev, "Failed to redirect indirect RQT %#x to channels: err = %d\n",
-				       mlx5e_rqt_get_rqtn(&res->indir_rqt), err);
+				       mlx5e_rqt_get_rqtn(&rss->rqt), err);
 	}
 
 	if (changed_hash)
@@ -755,25 +782,28 @@ int mlx5e_rx_res_rss_set_rxfh(struct mlx5e_rx_res *res, const u32 *indir,
 
 u8 mlx5e_rx_res_rss_get_hash_fields(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt)
 {
-	return res->rss_params.rx_hash_fields[tt];
+	struct mlx5e_rss *rss = res->rss;
+
+	return rss->rx_hash_fields[tt];
 }
 
 int mlx5e_rx_res_rss_set_hash_fields(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt,
 				     u8 rx_hash_fields)
 {
+	struct mlx5e_rss *rss = res->rss;
 	u8 old_rx_hash_fields;
 	int err;
 
-	old_rx_hash_fields = res->rss_params.rx_hash_fields[tt];
+	old_rx_hash_fields = rss->rx_hash_fields[tt];
 
 	if (old_rx_hash_fields == rx_hash_fields)
 		return 0;
 
-	res->rss_params.rx_hash_fields[tt] = rx_hash_fields;
+	rss->rx_hash_fields[tt] = rx_hash_fields;
 
 	err = mlx5e_rx_res_rss_update_tir(res, tt, false);
 	if (err) {
-		res->rss_params.rx_hash_fields[tt] = old_rx_hash_fields;
+		rss->rx_hash_fields[tt] = old_rx_hash_fields;
 		mlx5_core_warn(res->mdev, "Failed to update RSS hash fields of indirect TIR for traffic type %d: err = %d\n",
 			       tt, err);
 		return err;
@@ -787,11 +817,12 @@ int mlx5e_rx_res_rss_set_hash_fields(struct mlx5e_rx_res *res, enum mlx5_traffic
 		/* Partial update happened. Try to revert - it may fail too, but
 		 * there is nothing more we can do.
 		 */
-		res->rss_params.rx_hash_fields[tt] = old_rx_hash_fields;
+		rss->rx_hash_fields[tt] = old_rx_hash_fields;
 		mlx5_core_warn(res->mdev, "Failed to update RSS hash fields of inner indirect TIR for traffic type %d: err = %d\n",
 			       tt, err);
 		if (mlx5e_rx_res_rss_update_tir(res, tt, false))
-			mlx5_core_warn(res->mdev, "Partial update of RSS hash fields happened: failed to revert indirect TIR for traffic type %d to the old values\n",
+			mlx5_core_warn(res->mdev,
+				       "Partial update of RSS hash fields happened: failed to revert indirect TIR for traffic type %d to the old values\n",
 				       tt);
 	}
 
@@ -800,6 +831,7 @@ int mlx5e_rx_res_rss_set_hash_fields(struct mlx5e_rx_res *res, enum mlx5_traffic
 
 int mlx5e_rx_res_lro_set_param(struct mlx5e_rx_res *res, struct mlx5e_lro_param *lro_param)
 {
+	struct mlx5e_rss *rss = res->rss;
 	struct mlx5e_tir_builder *builder;
 	enum mlx5_traffic_types tt;
 	int err, final_err;
@@ -814,10 +846,10 @@ int mlx5e_rx_res_lro_set_param(struct mlx5e_rx_res *res, struct mlx5e_lro_param
 	final_err = 0;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		err = mlx5e_tir_modify(&res->rss[tt].indir_tir, builder);
+		err = mlx5e_tir_modify(&rss->tir[tt], builder);
 		if (err) {
 			mlx5_core_warn(res->mdev, "Failed to update LRO state of indirect TIR %#x for traffic type %d: err = %d\n",
-				       mlx5e_tir_get_tirn(&res->rss[tt].indir_tir), tt, err);
+				       mlx5e_tir_get_tirn(&rss->tir[tt]), tt, err);
 			if (!final_err)
 				final_err = err;
 		}
@@ -825,10 +857,10 @@ int mlx5e_rx_res_lro_set_param(struct mlx5e_rx_res *res, struct mlx5e_lro_param
 		if (!(res->features & MLX5E_RX_RES_FEATURE_INNER_FT))
 			continue;
 
-		err = mlx5e_tir_modify(&res->rss[tt].inner_indir_tir, builder);
+		err = mlx5e_tir_modify(&rss->inner_tir[tt], builder);
 		if (err) {
 			mlx5_core_warn(res->mdev, "Failed to update LRO state of inner indirect TIR %#x for traffic type %d: err = %d\n",
-				       mlx5e_tir_get_tirn(&res->rss[tt].inner_indir_tir), tt, err);
+				       mlx5e_tir_get_tirn(&rss->inner_tir[tt]), tt, err);
 			if (!final_err)
 				final_err = err;
 		}
@@ -850,5 +882,5 @@ int mlx5e_rx_res_lro_set_param(struct mlx5e_rx_res *res, struct mlx5e_lro_param
 
 struct mlx5e_rss_params_hash mlx5e_rx_res_get_current_hash(struct mlx5e_rx_res *res)
 {
-	return res->rss_params.hash;
+	return res->rss->hash;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index 1baeec5158a3..1703fb981d6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -53,7 +53,7 @@ int mlx5e_rx_res_xsk_deactivate(struct mlx5e_rx_res *res, unsigned int ix);
 struct mlx5e_rss_params_traffic_type
 mlx5e_rx_res_rss_get_current_tt_config(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt);
 void mlx5e_rx_res_rss_set_indir_uniform(struct mlx5e_rx_res *res, unsigned int nch);
-void mlx5e_rx_res_rss_get_rxfh(struct mlx5e_rx_res *res, u32 *indir, u8 *key, u8 *hfunc);
+int mlx5e_rx_res_rss_get_rxfh(struct mlx5e_rx_res *res, u32 *indir, u8 *key, u8 *hfunc);
 int mlx5e_rx_res_rss_set_rxfh(struct mlx5e_rx_res *res, const u32 *indir,
 			      const u8 *key, const u8 *hfunc);
 u8 mlx5e_rx_res_rss_get_hash_fields(struct mlx5e_rx_res *res, enum mlx5_traffic_types tt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 2cf59bb5f898..62eef3e7f993 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1198,12 +1198,12 @@ int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		   u8 *hfunc)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	int err;
 
 	mutex_lock(&priv->state_lock);
-	mlx5e_rx_res_rss_get_rxfh(priv->rx_res, indir, key, hfunc);
+	err = mlx5e_rx_res_rss_get_rxfh(priv->rx_res, indir, key, hfunc);
 	mutex_unlock(&priv->state_lock);
-
-	return 0;
+	return err;
 }
 
 int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
-- 
2.31.1

