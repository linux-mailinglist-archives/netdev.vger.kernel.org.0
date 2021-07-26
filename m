Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BAA3D650A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbhGZQTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241830AbhGZQQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A102F60F5E;
        Mon, 26 Jul 2021 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318557;
        bh=KeibOd0Q6ISfpIn+i0Wyhen/56nbLoSR/OKDZ4RAeLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcqMGqxqv3LRNrxbX/nDLqtZ7EwYbtL9ZCWtULLDsea5X0okQOWRF9h+CS7BUO4gD
         wc/rlvv13njv+lWxOO7zNNAuUGKovpWjcDwVNqG5NWziwtrUciXqpJWKG3jofdaBTi
         G+pSg0b0tg8EEAV4MoEz8qdGJYY2iCFOWp75qs7x2Ouq7cKmu32PAZVu3EnyAsCmOw
         WKQU9hv7Z+DydKA6WEY7YjhUseH7gho8xni4CZ3p3vsKS9O+e9Hxz76aeFluiWq+C8
         1enRY5LuA+Kp6hGZyOeJvqh0ADICsSeMLJ2F2/oy30azwsAprp3IpfbyeKBMH1hWTj
         sn9a2KiyOyWSQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/16] net/mlx5e: Take RQT out of TIR and group RX resources
Date:   Mon, 26 Jul 2021 09:55:36 -0700
Message-Id: <20210726165544.389143-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

RQT is not part of TIR, as multiple TIRs may point to the same RQT, as
it happens with indir_tir and inner_indir_tir. These instances of a TIR
don't use the embedded RQT.

This commit takes RQT out of TIR, making them independent. The RQTs are
placed into struct mlx5e_rx_res, and items in that struct are regrouped
by functionality: RSS, channels and PTP.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |  25 ++-
 .../mellanox/mlx5/core/en/xsk/setup.c         |   4 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   6 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 209 ++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  19 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  17 +-
 11 files changed, 188 insertions(+), 119 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 2cd2fbf6764d..59fc8432202f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1050,10 +1050,10 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv);
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc);
 void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv);
 
-int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
-void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
-int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
-void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
+int mlx5e_create_direct_rqts(struct mlx5e_priv *priv);
+void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv);
+int mlx5e_create_direct_tirs(struct mlx5e_priv *priv);
+void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv);
 
 int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn);
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index c832a3dbdc74..849ee3e147c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -603,7 +603,7 @@ static void mlx5e_ptp_rx_unset_fs(struct mlx5e_priv *priv)
 static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ptp_fs *ptp_fs = priv->fs.ptp_fs;
-	u32 tirn = priv->rx_res->ptp_tir.tirn;
+	u32 tirn = priv->rx_res->ptp.tir.tirn;
 	struct mlx5_flow_handle *rule;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index 0520ee39c162..b56c5de4828f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -19,18 +19,29 @@ struct mlx5e_rss_params {
 
 struct mlx5e_tir {
 	u32 tirn;
-	struct mlx5e_rqt rqt;
 	struct list_head list;
 };
 
 struct mlx5e_rx_res {
-	struct mlx5e_rqt indir_rqt;
-	struct mlx5e_tir indir_tirs[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_tir inner_indir_tirs[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_tir direct_tirs[MLX5E_MAX_NUM_CHANNELS];
-	struct mlx5e_tir xsk_tirs[MLX5E_MAX_NUM_CHANNELS];
-	struct mlx5e_tir ptp_tir;
 	struct mlx5e_rss_params rss_params;
+
+	struct mlx5e_rqt indir_rqt;
+	struct {
+		struct mlx5e_tir indir_tir;
+		struct mlx5e_tir inner_indir_tir;
+	} rss[MLX5E_NUM_INDIR_TIRS];
+
+	struct {
+		struct mlx5e_rqt direct_rqt;
+		struct mlx5e_tir direct_tir;
+		struct mlx5e_rqt xsk_rqt;
+		struct mlx5e_tir xsk_tir;
+	} channels[MLX5E_MAX_NUM_CHANNELS];
+
+	struct {
+		struct mlx5e_rqt rqt;
+		struct mlx5e_tir tir;
+	} ptp;
 };
 
 #endif /* __MLX5_EN_RX_RES_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 27dc6336d000..ab485d082729 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -186,12 +186,12 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 
 int mlx5e_xsk_redirect_rqt_to_channel(struct mlx5e_priv *priv, struct mlx5e_channel *c)
 {
-	return mlx5e_rqt_redirect_direct(&priv->rx_res->xsk_tirs[c->ix].rqt, c->xskrq.rqn);
+	return mlx5e_rqt_redirect_direct(&priv->rx_res->channels[c->ix].xsk_rqt, c->xskrq.rqn);
 }
 
 int mlx5e_xsk_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix)
 {
-	return mlx5e_rqt_redirect_direct(&priv->rx_res->xsk_tirs[ix].rqt, priv->drop_rq.rqn);
+	return mlx5e_rqt_redirect_direct(&priv->rx_res->channels[ix].xsk_rqt, priv->drop_rq.rqn);
 }
 
 int mlx5e_xsk_redirect_rqts_to_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index d6b9582e41f6..15153317a083 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -635,7 +635,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->sw_stats = &priv->tls->sw_stats;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
-	rqtn = priv->rx_res->direct_tirs[rxq].rqt.rqtn;
+	rqtn = priv->rx_res->channels[rxq].direct_rqt.rqtn;
 
 	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tirn, rqtn);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index b1efbcbb2573..db6c6a96a6c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -192,7 +192,6 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 				 enum arfs_type type)
 {
 	struct arfs_table *arfs_t = &priv->fs.arfs->arfs_tables[type];
-	struct mlx5e_tir *tir = priv->rx_res->indir_tirs;
 	struct mlx5_flow_destination dest = {};
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	enum mlx5e_traffic_types tt;
@@ -209,7 +208,7 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 	/* FIXME: Must use mlx5e_ttc_get_default_dest(),
 	 * but can't since TTC default is not setup yet !
 	 */
-	dest.tir_num = tir[tt].tirn;
+	dest.tir_num = priv->rx_res->rss[tt].indir_tir.tirn;
 	arfs_t->default_rule = mlx5_add_flow_rules(arfs_t->ft.t, NULL,
 						   &flow_act,
 						   &dest, 1);
@@ -553,7 +552,7 @@ static struct mlx5_flow_handle *arfs_add_rule(struct mlx5e_priv *priv,
 		       16);
 	}
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	dest.tir_num = priv->rx_res->direct_tirs[arfs_rule->rxq].tirn;
+	dest.tir_num = priv->rx_res->channels[arfs_rule->rxq].direct_tir.tirn;
 	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -576,7 +575,7 @@ static void arfs_modify_rule_rq(struct mlx5e_priv *priv,
 	int err = 0;
 
 	dst.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	dst.tir_num = priv->rx_res->direct_tirs[rxq].tirn;
+	dst.tir_num = priv->rx_res->channels[rxq].direct_tir.tirn;
 	err =  mlx5_modify_rule_destination(rule, &dst, NULL);
 	if (err)
 		netdev_warn(priv->netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 513a343abfe5..e79815763edf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1320,7 +1320,7 @@ static int mlx5e_create_inner_ttc_table_groups(struct mlx5e_ttc_table *ttc)
 void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv,
 				struct ttc_params *ttc_params)
 {
-	ttc_params->any_tt_tirn = priv->rx_res->direct_tirs[0].tirn;
+	ttc_params->any_tt_tirn = priv->rx_res->channels[0].direct_tir.tirn;
 	ttc_params->inner_ttc = &priv->fs.inner_ttc;
 }
 
@@ -1786,7 +1786,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	if (mlx5e_tunnel_inner_ft_supported(priv->mdev)) {
 		mlx5e_set_inner_ttc_ft_params(&ttc_params);
 		for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-			ttc_params.indir_tirn[tt] = priv->rx_res->inner_indir_tirs[tt].tirn;
+			ttc_params.indir_tirn[tt] = priv->rx_res->rss[tt].inner_indir_tir.tirn;
 
 		err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
 		if (err) {
@@ -1798,7 +1798,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 	mlx5e_set_ttc_ft_params(&ttc_params);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->rx_res->indir_tirs[tt].tirn;
+		ttc_params.indir_tirn[tt] = priv->rx_res->rss[tt].indir_tir.tirn;
 
 	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index b30967a316d1..32edb9119d38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -421,12 +421,9 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 	} else {
 		struct mlx5e_params *params = &priv->channels.params;
 		enum mlx5e_rq_group group;
-		struct mlx5e_tir *tir;
 		u16 ix;
 
 		mlx5e_qid_get_ch_and_group(params, fs->ring_cookie, &ix, &group);
-		tir = group == MLX5E_RQ_GROUP_XSK ? priv->rx_res->xsk_tirs :
-						    priv->rx_res->direct_tirs;
 
 		dst = kzalloc(sizeof(*dst), GFP_KERNEL);
 		if (!dst) {
@@ -435,7 +432,10 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 		}
 
 		dst->type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-		dst->tir_num = tir[ix].tirn;
+		if (group == MLX5E_RQ_GROUP_XSK)
+			dst->tir_num = priv->rx_res->channels[ix].xsk_tir.tirn;
+		else
+			dst->tir_num = priv->rx_res->channels[ix].direct_tir.tirn;
 		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c1ff4bc348bd..0e387799ee93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2205,14 +2205,14 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv)
 	return err;
 }
 
-int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
+int mlx5e_create_direct_rqts(struct mlx5e_priv *priv)
 {
 	int err;
 	int ix;
 
-	for (ix = 0; ix < n; ix++) {
-		err = mlx5e_rqt_init_direct(&tirs[ix].rqt, priv->mdev, false,
-					    priv->drop_rq.rqn);
+	for (ix = 0; ix < priv->max_nch; ix++) {
+		err = mlx5e_rqt_init_direct(&priv->rx_res->channels[ix].direct_rqt,
+					    priv->mdev, false, priv->drop_rq.rqn);
 		if (unlikely(err))
 			goto err_destroy_rqts;
 	}
@@ -2220,19 +2220,49 @@ int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, in
 	return 0;
 
 err_destroy_rqts:
-	mlx5_core_warn(priv->mdev, "create rqts failed, %d\n", err);
-	for (ix--; ix >= 0; ix--)
-		mlx5e_rqt_destroy(&tirs[ix].rqt);
+	mlx5_core_warn(priv->mdev, "create direct rqts failed, %d\n", err);
+	while (--ix >= 0)
+		mlx5e_rqt_destroy(&priv->rx_res->channels[ix].direct_rqt);
 
 	return err;
 }
 
-void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
+static int mlx5e_create_xsk_rqts(struct mlx5e_priv *priv)
 {
-	int i;
+	int err;
+	int ix;
+
+	for (ix = 0; ix < priv->max_nch; ix++) {
+		err = mlx5e_rqt_init_direct(&priv->rx_res->channels[ix].xsk_rqt,
+					    priv->mdev, false, priv->drop_rq.rqn);
+		if (unlikely(err))
+			goto err_destroy_rqts;
+	}
+
+	return 0;
+
+err_destroy_rqts:
+	mlx5_core_warn(priv->mdev, "create xsk rqts failed, %d\n", err);
+	while (--ix >= 0)
+		mlx5e_rqt_destroy(&priv->rx_res->channels[ix].xsk_rqt);
+
+	return err;
+}
+
+void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv)
+{
+	unsigned int ix;
 
-	for (i = 0; i < n; i++)
-		mlx5e_rqt_destroy(&tirs[i].rqt);
+	for (ix = 0; ix < priv->max_nch; ix++)
+		mlx5e_rqt_destroy(&priv->rx_res->channels[ix].direct_rqt);
+}
+
+static void mlx5e_destroy_xsk_rqts(struct mlx5e_priv *priv)
+{
+	unsigned int ix;
+
+	for (ix = 0; ix < priv->max_nch; ix++)
+		mlx5e_rqt_destroy(&priv->rx_res->channels[ix].xsk_rqt);
 }
 
 static int mlx5e_rx_hash_fn(int hfunc)
@@ -2266,7 +2296,7 @@ static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 		if (ix < chs->num)
 			rqn = chs->c[ix]->rq.rqn;
 
-		mlx5e_rqt_redirect_direct(&res->direct_tirs[ix].rqt, rqn);
+		mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, rqn);
 	}
 
 	if (priv->profile->rx_ptp_support) {
@@ -2275,7 +2305,7 @@ static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 		if (mlx5e_ptp_get_rqn(priv->channels.ptp, &rqn))
 			rqn = priv->drop_rq.rqn;
 
-		mlx5e_rqt_redirect_direct(&res->ptp_tir.rqt, rqn);
+		mlx5e_rqt_redirect_direct(&res->ptp.rqt, rqn);
 	}
 }
 
@@ -2287,10 +2317,10 @@ static void mlx5e_redirect_rqts_to_drop(struct mlx5e_priv *priv)
 	mlx5e_rqt_redirect_direct(&res->indir_rqt, priv->drop_rq.rqn);
 
 	for (ix = 0; ix < priv->max_nch; ix++)
-		mlx5e_rqt_redirect_direct(&res->direct_tirs[ix].rqt, priv->drop_rq.rqn);
+		mlx5e_rqt_redirect_direct(&res->channels[ix].direct_rqt, priv->drop_rq.rqn);
 
 	if (priv->profile->rx_ptp_support)
-		mlx5e_rqt_redirect_direct(&res->ptp_tir.rqt, priv->drop_rq.rqn);
+		mlx5e_rqt_redirect_direct(&res->ptp.rqt, priv->drop_rq.rqn);
 }
 
 static const struct mlx5e_tirc_config tirc_default_config[MLX5E_NUM_INDIR_TIRS] = {
@@ -2406,11 +2436,11 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in)
 		mlx5e_update_rx_hash_fields(&ttconfig, tt,
 					    rss->rx_hash_fields[tt]);
 		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, false);
-		mlx5_core_modify_tir(mdev, res->indir_tirs[tt].tirn, in);
+		mlx5_core_modify_tir(mdev, res->rss[tt].indir_tir.tirn, in);
 	}
 
 	/* Verify inner tirs resources allocated */
-	if (!res->inner_indir_tirs[0].tirn)
+	if (!res->rss[0].inner_indir_tir.tirn)
 		return;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
@@ -2418,7 +2448,7 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in)
 		mlx5e_update_rx_hash_fields(&ttconfig, tt,
 					    rss->rx_hash_fields[tt]);
 		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, true);
-		mlx5_core_modify_tir(mdev, res->inner_indir_tirs[tt].tirn, in);
+		mlx5_core_modify_tir(mdev, res->rss[tt].inner_indir_tir.tirn, in);
 	}
 }
 
@@ -2445,21 +2475,21 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 	mlx5e_build_tir_ctx_lro(&priv->channels.params, tirc);
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		err = mlx5_core_modify_tir(mdev, res->indir_tirs[tt].tirn, in);
+		err = mlx5_core_modify_tir(mdev, res->rss[tt].indir_tir.tirn, in);
 		if (err)
 			goto free_in;
 
 		/* Verify inner tirs resources allocated */
-		if (!res->inner_indir_tirs[0].tirn)
+		if (!res->rss[0].inner_indir_tir.tirn)
 			continue;
 
-		err = mlx5_core_modify_tir(mdev, res->inner_indir_tirs[tt].tirn, in);
+		err = mlx5_core_modify_tir(mdev, res->rss[tt].inner_indir_tir.tirn, in);
 		if (err)
 			goto free_in;
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
-		err = mlx5_core_modify_tir(mdev, res->direct_tirs[ix].tirn, in);
+		err = mlx5_core_modify_tir(mdev, res->channels[ix].direct_tir.tirn, in);
 		if (err)
 			goto free_in;
 	}
@@ -3151,7 +3181,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
 		memset(in, 0, inlen);
-		tir = &res->indir_tirs[tt];
+		tir = &res->rss[tt].indir_tir;
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 		mlx5e_build_indir_tir_ctx(priv, tt, tirc);
 		err = mlx5e_create_tir(priv->mdev, tir, in);
@@ -3166,7 +3196,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++) {
 		memset(in, 0, inlen);
-		tir = &res->inner_indir_tirs[i];
+		tir = &res->rss[i].inner_indir_tir;
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 		mlx5e_build_inner_indir_tir_ctx(priv, i, tirc);
 		err = mlx5e_create_tir(priv->mdev, tir, in);
@@ -3183,49 +3213,78 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 
 err_destroy_inner_tirs:
 	for (i--; i >= 0; i--)
-		mlx5e_destroy_tir(priv->mdev, &res->inner_indir_tirs[i]);
+		mlx5e_destroy_tir(priv->mdev, &res->rss[i].inner_indir_tir);
 
 	for (tt--; tt >= 0; tt--)
-		mlx5e_destroy_tir(priv->mdev, &res->indir_tirs[tt]);
+		mlx5e_destroy_tir(priv->mdev, &res->rss[tt].indir_tir);
 
 	kvfree(in);
 
 	return err;
 }
 
-int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
+static int mlx5e_create_direct_tir(struct mlx5e_priv *priv, struct mlx5e_tir *tir,
+				   struct mlx5e_rqt *rqt)
 {
-	struct mlx5e_tir *tir;
 	void *tirc;
 	int inlen;
 	int err = 0;
 	u32 *in;
-	int ix;
 
 	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
-	for (ix = 0; ix < n; ix++) {
-		memset(in, 0, inlen);
-		tir = &tirs[ix];
-		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_direct_tir_ctx(priv, tir->rqt.rqtn, tirc);
-		err = mlx5e_create_tir(priv->mdev, tir, in);
-		if (unlikely(err))
-			goto err_destroy_ch_tirs;
+	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
+	mlx5e_build_direct_tir_ctx(priv, rqt->rqtn, tirc);
+	err = mlx5e_create_tir(priv->mdev, tir, in);
+	if (unlikely(err))
+		mlx5_core_warn(priv->mdev, "create tirs failed, %d\n", err);
+
+	kvfree(in);
+
+	return err;
+}
+
+int mlx5e_create_direct_tirs(struct mlx5e_priv *priv)
+{
+	int err;
+	int ix;
+
+	for (ix = 0; ix < priv->max_nch; ix++) {
+		err = mlx5e_create_direct_tir(priv, &priv->rx_res->channels[ix].direct_tir,
+					      &priv->rx_res->channels[ix].direct_rqt);
+		if (err)
+			goto err_destroy_tirs;
 	}
 
-	goto out;
+	return 0;
 
-err_destroy_ch_tirs:
-	mlx5_core_warn(priv->mdev, "create tirs failed, %d\n", err);
-	for (ix--; ix >= 0; ix--)
-		mlx5e_destroy_tir(priv->mdev, &tirs[ix]);
+err_destroy_tirs:
+	while (--ix >= 0)
+		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].direct_tir);
 
-out:
-	kvfree(in);
+	return err;
+}
+
+static int mlx5e_create_xsk_tirs(struct mlx5e_priv *priv)
+{
+	int err;
+	int ix;
+
+	for (ix = 0; ix < priv->max_nch; ix++) {
+		err = mlx5e_create_direct_tir(priv, &priv->rx_res->channels[ix].xsk_tir,
+					      &priv->rx_res->channels[ix].xsk_rqt);
+		if (err)
+			goto err_destroy_tirs;
+	}
+
+	return 0;
+
+err_destroy_tirs:
+	while (--ix >= 0)
+		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].xsk_tir);
 
 	return err;
 }
@@ -3236,22 +3295,30 @@ void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv)
 	int i;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
-		mlx5e_destroy_tir(priv->mdev, &res->indir_tirs[i]);
+		mlx5e_destroy_tir(priv->mdev, &res->rss[i].indir_tir);
 
 	/* Verify inner tirs resources allocated */
-	if (!res->inner_indir_tirs[0].tirn)
+	if (!res->rss[0].inner_indir_tir.tirn)
 		return;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
-		mlx5e_destroy_tir(priv->mdev, &res->inner_indir_tirs[i]);
+		mlx5e_destroy_tir(priv->mdev, &res->rss[i].inner_indir_tir);
 }
 
-void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
+void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv)
 {
-	int i;
+	unsigned int ix;
 
-	for (i = 0; i < n; i++)
-		mlx5e_destroy_tir(priv->mdev, &tirs[i]);
+	for (ix = 0; ix < priv->max_nch; ix++)
+		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].direct_tir);
+}
+
+static void mlx5e_destroy_xsk_tirs(struct mlx5e_priv *priv)
+{
+	unsigned int ix;
+
+	for (ix = 0; ix < priv->max_nch; ix++)
+		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].xsk_tir);
 }
 
 static int mlx5e_modify_channels_scatter_fcs(struct mlx5e_channels *chs, bool enable)
@@ -4859,7 +4926,6 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u16 max_nch = priv->max_nch;
 	int err;
 
 	priv->rx_res = kvzalloc(sizeof(*priv->rx_res), GFP_KERNEL);
@@ -4880,7 +4946,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	err = mlx5e_create_direct_rqts(priv);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -4888,23 +4954,24 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	err = mlx5e_create_direct_tirs(priv);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
-	err = mlx5e_create_direct_rqts(priv, priv->rx_res->xsk_tirs, max_nch);
+	err = mlx5e_create_xsk_rqts(priv);
 	if (unlikely(err))
 		goto err_destroy_direct_tirs;
 
-	err = mlx5e_create_direct_tirs(priv, priv->rx_res->xsk_tirs, max_nch);
+	err = mlx5e_create_xsk_tirs(priv);
 	if (unlikely(err))
 		goto err_destroy_xsk_rqts;
 
-	err = mlx5e_create_direct_rqts(priv, &priv->rx_res->ptp_tir, 1);
+	err = mlx5e_rqt_init_direct(&priv->rx_res->ptp.rqt, priv->mdev, false,
+				    priv->drop_rq.rqn);
 	if (err)
 		goto err_destroy_xsk_tirs;
 
-	err = mlx5e_create_direct_tirs(priv, &priv->rx_res->ptp_tir, 1);
+	err = mlx5e_create_direct_tir(priv, &priv->rx_res->ptp.tir, &priv->rx_res->ptp.rqt);
 	if (err)
 		goto err_destroy_ptp_rqt;
 
@@ -4933,19 +5000,19 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_destroy_flow_steering:
 	mlx5e_destroy_flow_steering(priv);
 err_destroy_ptp_direct_tir:
-	mlx5e_destroy_direct_tirs(priv, &priv->rx_res->ptp_tir, 1);
+	mlx5e_destroy_tir(priv->mdev, &priv->rx_res->ptp.tir);
 err_destroy_ptp_rqt:
-	mlx5e_destroy_direct_rqts(priv, &priv->rx_res->ptp_tir, 1);
+	mlx5e_rqt_destroy(&priv->rx_res->ptp.rqt);
 err_destroy_xsk_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->xsk_tirs, max_nch);
+	mlx5e_destroy_xsk_tirs(priv);
 err_destroy_xsk_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->xsk_tirs, max_nch);
+	mlx5e_destroy_xsk_rqts(priv);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_tirs(priv);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_rqts(priv);
 err_destroy_indirect_rqts:
 	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 err_close_drop_rq:
@@ -4959,18 +5026,16 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 {
-	u16 max_nch = priv->max_nch;
-
 	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv, &priv->rx_res->ptp_tir, 1);
-	mlx5e_destroy_direct_rqts(priv, &priv->rx_res->ptp_tir, 1);
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->xsk_tirs, max_nch);
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->xsk_tirs, max_nch);
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_tir(priv->mdev, &priv->rx_res->ptp.tir);
+	mlx5e_rqt_destroy(&priv->rx_res->ptp.rqt);
+	mlx5e_destroy_xsk_tirs(priv);
+	mlx5e_destroy_xsk_rqts(priv);
+	mlx5e_destroy_direct_tirs(priv);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_rqts(priv);
 	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 590a7ae35155..2c54951c240d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -655,7 +655,7 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 					      MLX5_FLOW_NAMESPACE_KERNEL);
 
 	/* The inner_ttc in the ttc params is intentionally not set */
-	ttc_params.any_tt_tirn = res->direct_tirs[0].tirn;
+	ttc_params.any_tt_tirn = res->channels[0].direct_tir.tirn;
 	mlx5e_set_ttc_ft_params(&ttc_params);
 
 	if (rep->vport != MLX5_VPORT_UPLINK)
@@ -663,7 +663,7 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 		ttc_params.ft_attr.level = MLX5E_TTC_FT_LEVEL + 1;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = res->indir_tirs[tt].tirn;
+		ttc_params.indir_tirn[tt] = res->rss[tt].indir_tir.tirn;
 
 	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
 	if (err) {
@@ -758,7 +758,6 @@ int mlx5e_rep_bond_update(struct mlx5e_priv *priv, bool cleanup)
 static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u16 max_nch = priv->max_nch;
 	int err;
 
 	priv->rx_res = kvzalloc(sizeof(*priv->rx_res), GFP_KERNEL);
@@ -779,7 +778,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	err = mlx5e_create_direct_rqts(priv);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -787,7 +786,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	err = mlx5e_create_direct_tirs(priv);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -812,11 +811,11 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_ttc_table:
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_tirs(priv);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_rqts(priv);
 err_destroy_indirect_rqts:
 	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 err_close_drop_rq:
@@ -828,15 +827,13 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 {
-	u16 max_nch = priv->max_nch;
-
 	mlx5e_ethtool_cleanup_steering(priv);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_tirs(priv);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_rqts(priv);
 	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	kvfree(priv->rx_res);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 685d23e90450..6535c636ae22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -333,7 +333,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_set_ttc_basic_params(priv, &ttc_params);
 	mlx5e_set_ttc_ft_params(&ttc_params);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->rx_res->indir_tirs[tt].tirn;
+		ttc_params.indir_tirn[tt] = priv->rx_res->rss[tt].indir_tir.tirn;
 
 	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
 	if (err) {
@@ -359,7 +359,6 @@ static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 static int mlx5i_init_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u16 max_nch = priv->max_nch;
 	int err;
 
 	priv->rx_res = kvzalloc(sizeof(*priv->rx_res), GFP_KERNEL);
@@ -380,7 +379,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	err = mlx5e_create_direct_rqts(priv);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -388,7 +387,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	err = mlx5e_create_direct_tirs(priv);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -399,11 +398,11 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	return 0;
 
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_tirs(priv);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_rqts(priv);
 err_destroy_indirect_rqts:
 	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 err_close_drop_rq:
@@ -417,12 +416,10 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 
 static void mlx5i_cleanup_rx(struct mlx5e_priv *priv)
 {
-	u16 max_nch = priv->max_nch;
-
 	mlx5i_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_tirs(priv);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_destroy_direct_rqts(priv);
 	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
-- 
2.31.1

