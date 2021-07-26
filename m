Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6703D6506
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbhGZQTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241835AbhGZQQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17BD560F93;
        Mon, 26 Jul 2021 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318559;
        bh=HLdfKkZAnj1q3HPKa8nUddK2qGdEQw9QxO1ezSdaiiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozsWprsXqc2RZs0gG1wHb2txqppDiiO2LPS6BEeASMMF9cHE/k6qb1ttf49mXDt47
         DIT+10vyBg1gYouElwVS1GJkTAUss2vfTosrXTHD05XpDEuF/LlL++ogkP2auZEfuX
         K8pHVtL7Men19yTwLIu/DTc7vPmzeXcv29Jx7I3GHhIShjLxKsy8IQKkvdBgWJ6qBr
         MPpFpphKJNQqEK6G+9ZvxUZ1STvKJdao8xg3Vg/vc2047l8b/1z90fK9Grn9nyFtIb
         I877GTwnhe6y+XNufheceJ20RnPNiubuFHtcr0lLh+irhq1bFMsH5RSYuRgjrWRj1J
         m0kZhCaY6h9Dg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5e: Create struct mlx5e_rss_params_hash
Date:   Mon, 26 Jul 2021 09:55:41 -0700
Message-Id: <20210726165544.389143-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

This commit introduces a new struct to store RSS hash parameters: hash
function and hash key. The existing usages are changed to use the new
struct.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rx_res.h    |  8 ++++++--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c   | 18 ++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_main.c  | 14 +++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 4 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index b56c5de4828f..bdcd0b583e43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -10,11 +10,15 @@
 
 #define MLX5E_MAX_NUM_CHANNELS (MLX5E_INDIR_RQT_SIZE / 2)
 
+struct mlx5e_rss_params_hash {
+	u8 hfunc;
+	u8 toeplitz_hash_key[40];
+};
+
 struct mlx5e_rss_params {
+	struct mlx5e_rss_params_hash hash;
 	struct mlx5e_rss_params_indir indir;
 	u32 rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
-	u8 toeplitz_hash_key[40];
-	u8 hfunc;
 };
 
 struct mlx5e_tir {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 8a75b37edcc2..4167f4e4211e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1172,7 +1172,7 @@ static int mlx5e_set_link_ksettings(struct net_device *netdev,
 
 u32 mlx5e_ethtool_get_rxfh_key_size(struct mlx5e_priv *priv)
 {
-	return sizeof(priv->rx_res->rss_params.toeplitz_hash_key);
+	return sizeof(priv->rx_res->rss_params.hash.toeplitz_hash_key);
 }
 
 static u32 mlx5e_get_rxfh_key_size(struct net_device *netdev)
@@ -1206,11 +1206,10 @@ int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		memcpy(indir, rss->indir.table, sizeof(rss->indir.table));
 
 	if (key)
-		memcpy(key, rss->toeplitz_hash_key,
-		       sizeof(rss->toeplitz_hash_key));
+		memcpy(key, rss->hash.toeplitz_hash_key, sizeof(rss->hash.toeplitz_hash_key));
 
 	if (hfunc)
-		*hfunc = rss->hfunc;
+		*hfunc = rss->hash.hfunc;
 
 	return 0;
 }
@@ -1238,8 +1237,8 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 
 	rss = &priv->rx_res->rss_params;
 
-	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != rss->hfunc) {
-		rss->hfunc = hfunc;
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != rss->hash.hfunc) {
+		rss->hash.hfunc = hfunc;
 		refresh_rqt = true;
 		refresh_tirs = true;
 	}
@@ -1250,9 +1249,8 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 	}
 
 	if (key) {
-		memcpy(rss->toeplitz_hash_key, key,
-		       sizeof(rss->toeplitz_hash_key));
-		refresh_tirs = refresh_tirs || rss->hfunc == ETH_RSS_HASH_TOP;
+		memcpy(rss->hash.toeplitz_hash_key, key, sizeof(rss->hash.toeplitz_hash_key));
+		refresh_tirs = refresh_tirs || rss->hash.hfunc == ETH_RSS_HASH_TOP;
 	}
 
 	if (refresh_rqt && test_bit(MLX5E_STATE_OPENED, &priv->state)) {
@@ -1267,7 +1265,7 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 
 			mlx5e_rqt_redirect_indir(&priv->rx_res->indir_rqt, rqns,
 						 priv->channels.num,
-						 rss->hfunc, &rss->indir);
+						 rss->hash.hfunc, &rss->indir);
 			kvfree(rqns);
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 53a51ac86d64..10e6bebe8c74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2285,7 +2285,7 @@ static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 			rqns[ix] = chs->c[ix]->rq.rqn;
 
 		mlx5e_rqt_redirect_indir(&res->indir_rqt, rqns, chs->num,
-					 res->rss_params.hfunc,
+					 res->rss_params.hash.hfunc,
 					 &res->rss_params.indir);
 		kvfree(rqns);
 	}
@@ -2393,15 +2393,15 @@ void mlx5e_build_indir_tir_ctx_hash(struct mlx5e_rss_params *rss_params,
 	void *hfso = inner ? MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_inner) :
 			     MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_outer);
 
-	MLX5_SET(tirc, tirc, rx_hash_fn, mlx5e_rx_hash_fn(rss_params->hfunc));
-	if (rss_params->hfunc == ETH_RSS_HASH_TOP) {
+	MLX5_SET(tirc, tirc, rx_hash_fn, mlx5e_rx_hash_fn(rss_params->hash.hfunc));
+	if (rss_params->hash.hfunc == ETH_RSS_HASH_TOP) {
 		void *rss_key = MLX5_ADDR_OF(tirc, tirc,
 					     rx_hash_toeplitz_key);
 		size_t len = MLX5_FLD_SZ_BYTES(tirc,
 					       rx_hash_toeplitz_key);
 
 		MLX5_SET(tirc, tirc, rx_hash_symmetric, 1);
-		memcpy(rss_key, rss_params->toeplitz_hash_key, len);
+		memcpy(rss_key, rss_params->hash.toeplitz_hash_key, len);
 	}
 	MLX5_SET(rx_hash_field_select, hfso, l3_prot_type,
 		 ttconfig->l3_prot_type);
@@ -4591,9 +4591,9 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 {
 	enum mlx5e_traffic_types tt;
 
-	rss_params->hfunc = ETH_RSS_HASH_TOP;
-	netdev_rss_key_fill(rss_params->toeplitz_hash_key,
-			    sizeof(rss_params->toeplitz_hash_key));
+	rss_params->hash.hfunc = ETH_RSS_HASH_TOP;
+	netdev_rss_key_fill(rss_params->hash.toeplitz_hash_key,
+			    sizeof(rss_params->hash.toeplitz_hash_key));
 	mlx5e_build_default_indir_rqt(rss_params->indir.table,
 				      MLX5E_INDIR_RQT_SIZE, num_channels);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dd5546fb0f42..b4d58dd5c849 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -507,7 +507,7 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 
 	mlx5e_build_default_indir_rqt(indir->table, MLX5E_INDIR_RQT_SIZE, hp->num_channels);
 	err = mlx5e_rqt_init_indir(&hp->indir_rqt, mdev, hp->pair->rqn, hp->num_channels,
-				   priv->rx_res->rss_params.hfunc, indir);
+				    priv->rx_res->rss_params.hash.hfunc, indir);
 
 	kvfree(indir);
 	return err;
-- 
2.31.1

