Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15893D6500
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhGZQSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241827AbhGZQQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2000A60F91;
        Mon, 26 Jul 2021 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318556;
        bh=Ji8DQYUI+zuiI8TIvK6QkCN2DLckiPk72FeNGeSNLLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fW311axpbGzQxgCzD8CR/v5Mk5oWo0Vs6VK57Ykp7KEemgpXhalsWjzpYywTRHzx1
         VNdM42RiMRuZ08cWVroBOW6WQkKyQmxhyLbIJuaEoZH6mPqXvVtRNTQjEw3WbZnUnn
         cQGKkeOPAiAuLhYjWshvk5fABMo+bPB8Nan5P8wn1eMizJ2B99ufRyVG6lk7Nr0Oon
         WMPQYw1b65oasPQSeyF3khbD/OAuZBVhULwqE88RCxT2KScFLALWx1d7TjMO+YvW1v
         y4mmLcR09CuLxSfZsQYV4dsE6tMFzGtw7o6IJQIcDbFPplAeojlLHSvdbdqbFgYBk5
         QHc8YiFPar7iA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5e: Move RX resources to a separate struct
Date:   Mon, 26 Jul 2021 09:55:35 -0700
Message-Id: <20210726165544.389143-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

This commit moves RQTs and TIRs to a separate struct that is allocated
dynamically in profiles that support these RX resources (all profiles,
except IPoIB PKey). It also allows to remove rqt_enabled flags, as RQTs
are always enabled in profiles that support RX resources.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  26 +--
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |  36 ++++
 .../mellanox/mlx5/core/en/xsk/setup.c         |   4 +-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |   6 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   6 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 169 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  33 ++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   5 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  30 ++--
 14 files changed, 189 insertions(+), 154 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4ecf77d5f808..2cd2fbf6764d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -58,7 +58,7 @@
 #include "en/qos.h"
 #include "lib/hv_vhca.h"
 #include "lib/clock.h"
-#include "en/rqt.h"
+#include "en/rx_res.h"
 
 extern const struct net_device_ops mlx5e_netdev_ops;
 struct page_pool;
@@ -141,7 +141,6 @@ struct page_pool;
 #define MLX5E_PARAMS_DEFAULT_MIN_RX_WQES_MPW            0x2
 
 #define MLX5E_MIN_NUM_CHANNELS         0x1
-#define MLX5E_MAX_NUM_CHANNELS         (MLX5E_INDIR_RQT_SIZE / 2)
 #define MLX5E_MAX_NUM_SQS              (MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC)
 #define MLX5E_TX_CQ_POLL_BUDGET        128
 #define MLX5E_TX_XSK_POLL_BUDGET       64
@@ -744,25 +743,11 @@ enum {
 	MLX5E_STATE_XDP_ACTIVE,
 };
 
-struct mlx5e_tir {
-	u32		  tirn;
-	struct mlx5e_rqt  rqt;
-	bool              rqt_enabled;
-	struct list_head  list;
-};
-
 enum {
 	MLX5E_TC_PRIO = 0,
 	MLX5E_NIC_PRIO
 };
 
-struct mlx5e_rss_params {
-	struct mlx5e_rss_params_indir indir;
-	u32	rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
-	u8	toeplitz_hash_key[40];
-	u8	hfunc;
-};
-
 struct mlx5e_modify_sq_param {
 	int curr_state;
 	int next_state;
@@ -832,14 +817,7 @@ struct mlx5e_priv {
 
 	struct mlx5e_channels      channels;
 	u32                        tisn[MLX5_MAX_PORTS][MLX5E_MAX_NUM_TC];
-	struct mlx5e_rqt           indir_rqt;
-	bool                       indir_rqt_enabled;
-	struct mlx5e_tir           indir_tir[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_tir           inner_indir_tir[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_tir           direct_tir[MLX5E_MAX_NUM_CHANNELS];
-	struct mlx5e_tir           xsk_tir[MLX5E_MAX_NUM_CHANNELS];
-	struct mlx5e_tir           ptp_tir;
-	struct mlx5e_rss_params    rss_params;
+	struct mlx5e_rx_res       *rx_res;
 	u32                        tx_rates[MLX5E_MAX_NUM_SQS];
 
 	struct mlx5e_flow_steering fs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 43b092f5565a..d764ce8259a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -160,6 +160,8 @@ enum {
 					 MLX5E_INNER_TTC_GROUP2_SIZE +\
 					 MLX5E_INNER_TTC_GROUP3_SIZE)
 
+struct mlx5e_priv;
+
 #ifdef CONFIG_MLX5_EN_RXNFC
 
 struct mlx5e_ethtool_table {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 778e229310a9..c832a3dbdc74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -603,8 +603,8 @@ static void mlx5e_ptp_rx_unset_fs(struct mlx5e_priv *priv)
 static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ptp_fs *ptp_fs = priv->fs.ptp_fs;
+	u32 tirn = priv->rx_res->ptp_tir.tirn;
 	struct mlx5_flow_handle *rule;
-	u32 tirn = priv->ptp_tir.tirn;
 	int err;
 
 	if (ptp_fs->valid)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
new file mode 100644
index 000000000000..0520ee39c162
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_EN_RX_RES_H__
+#define __MLX5_EN_RX_RES_H__
+
+#include <linux/kernel.h>
+#include "rqt.h"
+#include "fs.h"
+
+#define MLX5E_MAX_NUM_CHANNELS (MLX5E_INDIR_RQT_SIZE / 2)
+
+struct mlx5e_rss_params {
+	struct mlx5e_rss_params_indir indir;
+	u32 rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
+	u8 toeplitz_hash_key[40];
+	u8 hfunc;
+};
+
+struct mlx5e_tir {
+	u32 tirn;
+	struct mlx5e_rqt rqt;
+	struct list_head list;
+};
+
+struct mlx5e_rx_res {
+	struct mlx5e_rqt indir_rqt;
+	struct mlx5e_tir indir_tirs[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_tir inner_indir_tirs[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_tir direct_tirs[MLX5E_MAX_NUM_CHANNELS];
+	struct mlx5e_tir xsk_tirs[MLX5E_MAX_NUM_CHANNELS];
+	struct mlx5e_tir ptp_tir;
+	struct mlx5e_rss_params rss_params;
+};
+
+#endif /* __MLX5_EN_RX_RES_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 0772dd324ae2..27dc6336d000 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -186,12 +186,12 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 
 int mlx5e_xsk_redirect_rqt_to_channel(struct mlx5e_priv *priv, struct mlx5e_channel *c)
 {
-	return mlx5e_rqt_redirect_direct(&priv->xsk_tir[c->ix].rqt, c->xskrq.rqn);
+	return mlx5e_rqt_redirect_direct(&priv->rx_res->xsk_tirs[c->ix].rqt, c->xskrq.rqn);
 }
 
 int mlx5e_xsk_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix)
 {
-	return mlx5e_rqt_redirect_direct(&priv->xsk_tir[ix].rqt, priv->drop_rq.rqn);
+	return mlx5e_rqt_redirect_direct(&priv->rx_res->xsk_tirs[ix].rqt, priv->drop_rq.rqn);
 }
 
 int mlx5e_xsk_redirect_rqts_to_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 4e58fade7a60..d6b9582e41f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -635,7 +635,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->sw_stats = &priv->tls->sw_stats;
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, priv_rx);
 
-	rqtn = priv->direct_tir[rxq].rqt.rqtn;
+	rqtn = priv->rx_res->direct_tirs[rxq].rqt.rqtn;
 
 	err = mlx5e_ktls_create_tir(mdev, &priv_rx->tirn, rqtn);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 25403af32859..b1efbcbb2573 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -192,7 +192,7 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 				 enum arfs_type type)
 {
 	struct arfs_table *arfs_t = &priv->fs.arfs->arfs_tables[type];
-	struct mlx5e_tir *tir = priv->indir_tir;
+	struct mlx5e_tir *tir = priv->rx_res->indir_tirs;
 	struct mlx5_flow_destination dest = {};
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	enum mlx5e_traffic_types tt;
@@ -553,7 +553,7 @@ static struct mlx5_flow_handle *arfs_add_rule(struct mlx5e_priv *priv,
 		       16);
 	}
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	dest.tir_num = priv->direct_tir[arfs_rule->rxq].tirn;
+	dest.tir_num = priv->rx_res->direct_tirs[arfs_rule->rxq].tirn;
 	rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -576,7 +576,7 @@ static void arfs_modify_rule_rq(struct mlx5e_priv *priv,
 	int err = 0;
 
 	dst.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	dst.tir_num = priv->direct_tir[rxq].tirn;
+	dst.tir_num = priv->rx_res->direct_tirs[rxq].tirn;
 	err =  mlx5_modify_rule_destination(rule, &dst, NULL);
 	if (err)
 		netdev_warn(priv->netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c1f42eade842..8a75b37edcc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1172,7 +1172,7 @@ static int mlx5e_set_link_ksettings(struct net_device *netdev,
 
 u32 mlx5e_ethtool_get_rxfh_key_size(struct mlx5e_priv *priv)
 {
-	return sizeof(priv->rss_params.toeplitz_hash_key);
+	return sizeof(priv->rx_res->rss_params.toeplitz_hash_key);
 }
 
 static u32 mlx5e_get_rxfh_key_size(struct net_device *netdev)
@@ -1198,7 +1198,9 @@ int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		   u8 *hfunc)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rss_params *rss = &priv->rss_params;
+	struct mlx5e_rss_params *rss;
+
+	rss = &priv->rx_res->rss_params;
 
 	if (indir)
 		memcpy(indir, rss->indir.table, sizeof(rss->indir.table));
@@ -1217,8 +1219,8 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 		   const u8 *key, const u8 hfunc)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_rss_params *rss = &priv->rss_params;
 	int inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
+	struct mlx5e_rss_params *rss;
 	bool refresh_tirs = false;
 	bool refresh_rqt = false;
 	void *in;
@@ -1234,6 +1236,8 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 
 	mutex_lock(&priv->state_lock);
 
+	rss = &priv->rx_res->rss_params;
+
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != rss->hfunc) {
 		rss->hfunc = hfunc;
 		refresh_rqt = true;
@@ -1261,7 +1265,8 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 			for (ix = 0; ix < priv->channels.num; ix++)
 				rqns[ix] = priv->channels.c[ix]->rq.rqn;
 
-			mlx5e_rqt_redirect_indir(&priv->indir_rqt, rqns, priv->channels.num,
+			mlx5e_rqt_redirect_indir(&priv->rx_res->indir_rqt, rqns,
+						 priv->channels.num,
 						 rss->hfunc, &rss->indir);
 			kvfree(rqns);
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 1a38c527423e..513a343abfe5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1320,7 +1320,7 @@ static int mlx5e_create_inner_ttc_table_groups(struct mlx5e_ttc_table *ttc)
 void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv,
 				struct ttc_params *ttc_params)
 {
-	ttc_params->any_tt_tirn = priv->direct_tir[0].tirn;
+	ttc_params->any_tt_tirn = priv->rx_res->direct_tirs[0].tirn;
 	ttc_params->inner_ttc = &priv->fs.inner_ttc;
 }
 
@@ -1786,7 +1786,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	if (mlx5e_tunnel_inner_ft_supported(priv->mdev)) {
 		mlx5e_set_inner_ttc_ft_params(&ttc_params);
 		for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-			ttc_params.indir_tirn[tt] = priv->inner_indir_tir[tt].tirn;
+			ttc_params.indir_tirn[tt] = priv->rx_res->inner_indir_tirs[tt].tirn;
 
 		err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
 		if (err) {
@@ -1798,7 +1798,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 	mlx5e_set_ttc_ft_params(&ttc_params);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->indir_tir[tt].tirn;
+		ttc_params.indir_tirn[tt] = priv->rx_res->indir_tirs[tt].tirn;
 
 	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index b416a8ee2eed..b30967a316d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -425,7 +425,8 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 		u16 ix;
 
 		mlx5e_qid_get_ch_and_group(params, fs->ring_cookie, &ix, &group);
-		tir = group == MLX5E_RQ_GROUP_XSK ? priv->xsk_tir : priv->direct_tir;
+		tir = group == MLX5E_RQ_GROUP_XSK ? priv->rx_res->xsk_tirs :
+						    priv->rx_res->direct_tirs;
 
 		dst = kzalloc(sizeof(*dst), GFP_KERNEL);
 		if (!dst) {
@@ -854,10 +855,10 @@ static int mlx5e_set_rss_hash_opt(struct mlx5e_priv *priv,
 
 	mutex_lock(&priv->state_lock);
 
-	if (rx_hash_field == priv->rss_params.rx_hash_fields[tt])
+	if (rx_hash_field == priv->rx_res->rss_params.rx_hash_fields[tt])
 		goto out;
 
-	priv->rss_params.rx_hash_fields[tt] = rx_hash_field;
+	priv->rx_res->rss_params.rx_hash_fields[tt] = rx_hash_field;
 	mlx5e_modify_tirs_hash(priv, in);
 
 out:
@@ -876,7 +877,7 @@ static int mlx5e_get_rss_hash_opt(struct mlx5e_priv *priv,
 	if (tt == MLX5E_NUM_INDIR_TIRS)
 		return -EINVAL;
 
-	hash_field = priv->rss_params.rx_hash_fields[tt];
+	hash_field = priv->rx_res->rss_params.rx_hash_fields[tt];
 	nfc->data = 0;
 
 	if (hash_field & MLX5_HASH_FIELD_SEL_SRC_IP)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6c495eee82d0..c1ff4bc348bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2198,11 +2198,10 @@ int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv)
 {
 	int err;
 
-	err = mlx5e_rqt_init_direct(&priv->indir_rqt, priv->mdev, true, priv->drop_rq.rqn);
+	err = mlx5e_rqt_init_direct(&priv->rx_res->indir_rqt, priv->mdev, true,
+				    priv->drop_rq.rqn);
 	if (err)
 		mlx5_core_warn(priv->mdev, "create indirect rqts failed, %d\n", err);
-	else
-		priv->indir_rqt_enabled = true;
 	return err;
 }
 
@@ -2216,17 +2215,14 @@ int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, in
 					    priv->drop_rq.rqn);
 		if (unlikely(err))
 			goto err_destroy_rqts;
-		tirs[ix].rqt_enabled = true;
 	}
 
 	return 0;
 
 err_destroy_rqts:
 	mlx5_core_warn(priv->mdev, "create rqts failed, %d\n", err);
-	for (ix--; ix >= 0; ix--) {
-		tirs[ix].rqt_enabled = false;
+	for (ix--; ix >= 0; ix--)
 		mlx5e_rqt_destroy(&tirs[ix].rqt);
-	}
 
 	return err;
 }
@@ -2235,10 +2231,8 @@ void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs,
 {
 	int i;
 
-	for (i = 0; i < n; i++) {
-		tirs[i].rqt_enabled = false;
+	for (i = 0; i < n; i++)
 		mlx5e_rqt_destroy(&tirs[i].rqt);
-	}
 }
 
 static int mlx5e_rx_hash_fn(int hfunc)
@@ -2251,33 +2245,28 @@ static int mlx5e_rx_hash_fn(int hfunc)
 static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 					    struct mlx5e_channels *chs)
 {
+	struct mlx5e_rx_res *res = priv->rx_res;
 	unsigned int ix;
+	u32 *rqns;
 
-	if (priv->indir_rqt_enabled) {
-		u32 *rqns;
+	rqns = kvmalloc_array(chs->num, sizeof(*rqns), GFP_KERNEL);
+	if (rqns) {
+		for (ix = 0; ix < chs->num; ix++)
+			rqns[ix] = chs->c[ix]->rq.rqn;
 
-		rqns = kvmalloc_array(chs->num, sizeof(*rqns), GFP_KERNEL);
-		if (rqns) {
-			for (ix = 0; ix < chs->num; ix++)
-				rqns[ix] = chs->c[ix]->rq.rqn;
-
-			mlx5e_rqt_redirect_indir(&priv->indir_rqt, rqns, chs->num,
-						 priv->rss_params.hfunc,
-						 &priv->rss_params.indir);
-			kvfree(rqns);
-		}
+		mlx5e_rqt_redirect_indir(&res->indir_rqt, rqns, chs->num,
+					 res->rss_params.hfunc,
+					 &res->rss_params.indir);
+		kvfree(rqns);
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
 		u32 rqn = priv->drop_rq.rqn;
 
-		if (!priv->direct_tir[ix].rqt_enabled)
-			continue;
-
 		if (ix < chs->num)
 			rqn = chs->c[ix]->rq.rqn;
 
-		mlx5e_rqt_redirect_direct(&priv->direct_tir[ix].rqt, rqn);
+		mlx5e_rqt_redirect_direct(&res->direct_tirs[ix].rqt, rqn);
 	}
 
 	if (priv->profile->rx_ptp_support) {
@@ -2286,26 +2275,22 @@ static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 		if (mlx5e_ptp_get_rqn(priv->channels.ptp, &rqn))
 			rqn = priv->drop_rq.rqn;
 
-		mlx5e_rqt_redirect_direct(&priv->ptp_tir.rqt, rqn);
+		mlx5e_rqt_redirect_direct(&res->ptp_tir.rqt, rqn);
 	}
 }
 
 static void mlx5e_redirect_rqts_to_drop(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rx_res *res = priv->rx_res;
 	unsigned int ix;
 
-	if (priv->indir_rqt_enabled)
-		mlx5e_rqt_redirect_direct(&priv->indir_rqt, priv->drop_rq.rqn);
+	mlx5e_rqt_redirect_direct(&res->indir_rqt, priv->drop_rq.rqn);
 
-	for (ix = 0; ix < priv->max_nch; ix++) {
-		if (!priv->direct_tir[ix].rqt_enabled)
-			continue;
-
-		mlx5e_rqt_redirect_direct(&priv->direct_tir[ix].rqt, priv->drop_rq.rqn);
-	}
+	for (ix = 0; ix < priv->max_nch; ix++)
+		mlx5e_rqt_redirect_direct(&res->direct_tirs[ix].rqt, priv->drop_rq.rqn);
 
 	if (priv->profile->rx_ptp_support)
-		mlx5e_rqt_redirect_direct(&priv->ptp_tir.rqt, priv->drop_rq.rqn);
+		mlx5e_rqt_redirect_direct(&res->ptp_tir.rqt, priv->drop_rq.rqn);
 }
 
 static const struct mlx5e_tirc_config tirc_default_config[MLX5E_NUM_INDIR_TIRS] = {
@@ -2406,8 +2391,9 @@ static void mlx5e_update_rx_hash_fields(struct mlx5e_tirc_config *ttconfig,
 
 void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in)
 {
+	struct mlx5e_rss_params *rss = &priv->rx_res->rss_params;
 	void *tirc = MLX5_ADDR_OF(modify_tir_in, in, ctx);
-	struct mlx5e_rss_params *rss = &priv->rss_params;
+	struct mlx5e_rx_res *res = priv->rx_res;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int ctxlen = MLX5_ST_SZ_BYTES(tirc);
 	struct mlx5e_tirc_config ttconfig;
@@ -2420,11 +2406,11 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in)
 		mlx5e_update_rx_hash_fields(&ttconfig, tt,
 					    rss->rx_hash_fields[tt]);
 		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, false);
-		mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in);
+		mlx5_core_modify_tir(mdev, res->indir_tirs[tt].tirn, in);
 	}
 
 	/* Verify inner tirs resources allocated */
-	if (!priv->inner_indir_tir[0].tirn)
+	if (!res->inner_indir_tirs[0].tirn)
 		return;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
@@ -2432,13 +2418,14 @@ void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in)
 		mlx5e_update_rx_hash_fields(&ttconfig, tt,
 					    rss->rx_hash_fields[tt]);
 		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, true);
-		mlx5_core_modify_tir(mdev, priv->inner_indir_tir[tt].tirn, in);
+		mlx5_core_modify_tir(mdev, res->inner_indir_tirs[tt].tirn, in);
 	}
 }
 
 static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_rx_res *res = priv->rx_res;
 
 	void *in;
 	void *tirc;
@@ -2458,21 +2445,21 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 	mlx5e_build_tir_ctx_lro(&priv->channels.params, tirc);
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		err = mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in);
+		err = mlx5_core_modify_tir(mdev, res->indir_tirs[tt].tirn, in);
 		if (err)
 			goto free_in;
 
 		/* Verify inner tirs resources allocated */
-		if (!priv->inner_indir_tir[0].tirn)
+		if (!res->inner_indir_tirs[0].tirn)
 			continue;
 
-		err = mlx5_core_modify_tir(mdev, priv->inner_indir_tir[tt].tirn, in);
+		err = mlx5_core_modify_tir(mdev, res->inner_indir_tirs[tt].tirn, in);
 		if (err)
 			goto free_in;
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
-		err = mlx5_core_modify_tir(mdev, priv->direct_tir[ix].tirn, in);
+		err = mlx5_core_modify_tir(mdev, res->direct_tirs[ix].tirn, in);
 		if (err)
 			goto free_in;
 	}
@@ -2661,8 +2648,9 @@ int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
 
 	mlx5e_set_default_xps_cpumasks(priv, &priv->channels.params);
 
-	if (!netif_is_rxfh_configured(priv->netdev))
-		mlx5e_build_default_indir_rqt(priv->rss_params.indir.table,
+	/* This function may be called on attach, before priv->rx_res is created. */
+	if (!netif_is_rxfh_configured(priv->netdev) && priv->rx_res)
+		mlx5e_build_default_indir_rqt(priv->rx_res->rss_params.indir.table,
 					      MLX5E_INDIR_RQT_SIZE, count);
 
 	return 0;
@@ -2722,16 +2710,19 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 		mlx5e_add_sqs_fwd_rules(priv);
 
 	mlx5e_wait_channels_min_rx_wqes(&priv->channels);
-	mlx5e_redirect_rqts_to_channels(priv, &priv->channels);
 
-	mlx5e_xsk_redirect_rqts_to_channels(priv, &priv->channels);
+	if (priv->rx_res) {
+		mlx5e_redirect_rqts_to_channels(priv, &priv->channels);
+		mlx5e_xsk_redirect_rqts_to_channels(priv, &priv->channels);
+	}
 }
 
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 {
-	mlx5e_xsk_redirect_rqts_to_drop(priv, &priv->channels);
-
-	mlx5e_redirect_rqts_to_drop(priv);
+	if (priv->rx_res) {
+		mlx5e_xsk_redirect_rqts_to_drop(priv, &priv->channels);
+		mlx5e_redirect_rqts_to_drop(priv);
+	}
 
 	if (mlx5e_is_vport_rep(priv))
 		mlx5e_remove_sqs_fwd_rules(priv);
@@ -3122,8 +3113,8 @@ static void mlx5e_build_indir_tir_ctx(struct mlx5e_priv *priv,
 				      enum mlx5e_traffic_types tt,
 				      u32 *tirc)
 {
-	mlx5e_build_indir_tir_ctx_common(priv, priv->indir_rqt.rqtn, tirc);
-	mlx5e_build_indir_tir_ctx_hash(&priv->rss_params,
+	mlx5e_build_indir_tir_ctx_common(priv, priv->rx_res->indir_rqt.rqtn, tirc);
+	mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
 				       &tirc_default_config[tt], tirc, false);
 }
 
@@ -3137,13 +3128,14 @@ static void mlx5e_build_inner_indir_tir_ctx(struct mlx5e_priv *priv,
 					    enum mlx5e_traffic_types tt,
 					    u32 *tirc)
 {
-	mlx5e_build_indir_tir_ctx_common(priv, priv->indir_rqt.rqtn, tirc);
-	mlx5e_build_indir_tir_ctx_hash(&priv->rss_params,
+	mlx5e_build_indir_tir_ctx_common(priv, priv->rx_res->indir_rqt.rqtn, tirc);
+	mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
 				       &tirc_default_config[tt], tirc, true);
 }
 
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 {
+	struct mlx5e_rx_res *res = priv->rx_res;
 	struct mlx5e_tir *tir;
 	void *tirc;
 	int inlen;
@@ -3159,7 +3151,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
 		memset(in, 0, inlen);
-		tir = &priv->indir_tir[tt];
+		tir = &res->indir_tirs[tt];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 		mlx5e_build_indir_tir_ctx(priv, tt, tirc);
 		err = mlx5e_create_tir(priv->mdev, tir, in);
@@ -3174,7 +3166,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++) {
 		memset(in, 0, inlen);
-		tir = &priv->inner_indir_tir[i];
+		tir = &res->inner_indir_tirs[i];
 		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 		mlx5e_build_inner_indir_tir_ctx(priv, i, tirc);
 		err = mlx5e_create_tir(priv->mdev, tir, in);
@@ -3191,10 +3183,10 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 
 err_destroy_inner_tirs:
 	for (i--; i >= 0; i--)
-		mlx5e_destroy_tir(priv->mdev, &priv->inner_indir_tir[i]);
+		mlx5e_destroy_tir(priv->mdev, &res->inner_indir_tirs[i]);
 
 	for (tt--; tt >= 0; tt--)
-		mlx5e_destroy_tir(priv->mdev, &priv->indir_tir[tt]);
+		mlx5e_destroy_tir(priv->mdev, &res->indir_tirs[tt]);
 
 	kvfree(in);
 
@@ -3240,17 +3232,18 @@ int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, in
 
 void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rx_res *res = priv->rx_res;
 	int i;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
-		mlx5e_destroy_tir(priv->mdev, &priv->indir_tir[i]);
+		mlx5e_destroy_tir(priv->mdev, &res->indir_tirs[i]);
 
 	/* Verify inner tirs resources allocated */
-	if (!priv->inner_indir_tir[0].tirn)
+	if (!res->inner_indir_tirs[0].tirn)
 		return;
 
 	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
-		mlx5e_destroy_tir(priv->mdev, &priv->inner_indir_tir[i]);
+		mlx5e_destroy_tir(priv->mdev, &res->inner_indir_tirs[i]);
 }
 
 void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n)
@@ -4869,7 +4862,11 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	u16 max_nch = priv->max_nch;
 	int err;
 
-	mlx5e_build_rss_params(&priv->rss_params, priv->channels.params.num_channels);
+	priv->rx_res = kvzalloc(sizeof(*priv->rx_res), GFP_KERNEL);
+	if (!priv->rx_res)
+		return -ENOMEM;
+
+	mlx5e_build_rss_params(&priv->rx_res->rss_params, priv->channels.params.num_channels);
 
 	mlx5e_create_q_counters(priv);
 
@@ -4883,7 +4880,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
+	err = mlx5e_create_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -4891,23 +4888,23 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->direct_tir, max_nch);
+	err = mlx5e_create_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
-	err = mlx5e_create_direct_rqts(priv, priv->xsk_tir, max_nch);
+	err = mlx5e_create_direct_rqts(priv, priv->rx_res->xsk_tirs, max_nch);
 	if (unlikely(err))
 		goto err_destroy_direct_tirs;
 
-	err = mlx5e_create_direct_tirs(priv, priv->xsk_tir, max_nch);
+	err = mlx5e_create_direct_tirs(priv, priv->rx_res->xsk_tirs, max_nch);
 	if (unlikely(err))
 		goto err_destroy_xsk_rqts;
 
-	err = mlx5e_create_direct_rqts(priv, &priv->ptp_tir, 1);
+	err = mlx5e_create_direct_rqts(priv, &priv->rx_res->ptp_tir, 1);
 	if (err)
 		goto err_destroy_xsk_tirs;
 
-	err = mlx5e_create_direct_tirs(priv, &priv->ptp_tir, 1);
+	err = mlx5e_create_direct_tirs(priv, &priv->rx_res->ptp_tir, 1);
 	if (err)
 		goto err_destroy_ptp_rqt;
 
@@ -4936,26 +4933,27 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_destroy_flow_steering:
 	mlx5e_destroy_flow_steering(priv);
 err_destroy_ptp_direct_tir:
-	mlx5e_destroy_direct_tirs(priv, &priv->ptp_tir, 1);
+	mlx5e_destroy_direct_tirs(priv, &priv->rx_res->ptp_tir, 1);
 err_destroy_ptp_rqt:
-	mlx5e_destroy_direct_rqts(priv, &priv->ptp_tir, 1);
+	mlx5e_destroy_direct_rqts(priv, &priv->rx_res->ptp_tir, 1);
 err_destroy_xsk_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->xsk_tirs, max_nch);
 err_destroy_xsk_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir, max_nch);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->xsk_tirs, max_nch);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
 err_destroy_indirect_rqts:
-	priv->indir_rqt_enabled = false;
-	mlx5e_rqt_destroy(&priv->indir_rqt);
+	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 err_close_drop_rq:
 	mlx5e_close_drop_rq(&priv->drop_rq);
 err_destroy_q_counters:
 	mlx5e_destroy_q_counters(priv);
+	kvfree(priv->rx_res);
+	priv->rx_res = NULL;
 	return err;
 }
 
@@ -4966,17 +4964,18 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv, &priv->ptp_tir, 1);
-	mlx5e_destroy_direct_rqts(priv, &priv->ptp_tir, 1);
-	mlx5e_destroy_direct_tirs(priv, priv->xsk_tir, max_nch);
-	mlx5e_destroy_direct_rqts(priv, priv->xsk_tir, max_nch);
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, &priv->rx_res->ptp_tir, 1);
+	mlx5e_destroy_direct_rqts(priv, &priv->rx_res->ptp_tir, 1);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->xsk_tirs, max_nch);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->xsk_tirs, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
-	priv->indir_rqt_enabled = false;
-	mlx5e_rqt_destroy(&priv->indir_rqt);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
+	kvfree(priv->rx_res);
+	priv->rx_res = NULL;
 }
 
 static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0df6c6f99820..590a7ae35155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -647,6 +647,7 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct mlx5e_rx_res *res = priv->rx_res;
 	struct ttc_params ttc_params = {};
 	int tt, err;
 
@@ -654,7 +655,7 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 					      MLX5_FLOW_NAMESPACE_KERNEL);
 
 	/* The inner_ttc in the ttc params is intentionally not set */
-	ttc_params.any_tt_tirn = priv->direct_tir[0].tirn;
+	ttc_params.any_tt_tirn = res->direct_tirs[0].tirn;
 	mlx5e_set_ttc_ft_params(&ttc_params);
 
 	if (rep->vport != MLX5_VPORT_UPLINK)
@@ -662,7 +663,7 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 		ttc_params.ft_attr.level = MLX5E_TTC_FT_LEVEL + 1;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->indir_tir[tt].tirn;
+		ttc_params.indir_tirn[tt] = res->indir_tirs[tt].tirn;
 
 	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
 	if (err) {
@@ -760,7 +761,11 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	u16 max_nch = priv->max_nch;
 	int err;
 
-	mlx5e_build_rss_params(&priv->rss_params, priv->channels.params.num_channels);
+	priv->rx_res = kvzalloc(sizeof(*priv->rx_res), GFP_KERNEL);
+	if (!priv->rx_res)
+		return -ENOMEM;
+
+	mlx5e_build_rss_params(&priv->rx_res->rss_params, priv->channels.params.num_channels);
 
 	mlx5e_init_l2_addr(priv);
 
@@ -774,7 +779,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
+	err = mlx5e_create_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -782,7 +787,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->direct_tir, max_nch);
+	err = mlx5e_create_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -807,16 +812,17 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_ttc_table:
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
 err_destroy_indirect_rqts:
-	priv->indir_rqt_enabled = false;
-	mlx5e_rqt_destroy(&priv->indir_rqt);
+	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 err_close_drop_rq:
 	mlx5e_close_drop_rq(&priv->drop_rq);
+	kvfree(priv->rx_res);
+	priv->rx_res = NULL;
 	return err;
 }
 
@@ -828,12 +834,13 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
-	priv->indir_rqt_enabled = false;
-	mlx5e_rqt_destroy(&priv->indir_rqt);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
+	kvfree(priv->rx_res);
+	priv->rx_res = NULL;
 }
 
 static int mlx5e_init_ul_rep_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 859f892603e3..4c00abc472be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -507,7 +507,7 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 
 	mlx5e_build_default_indir_rqt(indir->table, MLX5E_INDIR_RQT_SIZE, hp->num_channels);
 	err = mlx5e_rqt_init_indir(&hp->indir_rqt, mdev, hp->pair->rqn, hp->num_channels,
-				   priv->rss_params.hfunc, indir);
+				   priv->rx_res->rss_params.hfunc, indir);
 
 	kvfree(indir);
 	return err;
@@ -529,7 +529,8 @@ static int mlx5e_hairpin_create_indirect_tirs(struct mlx5e_hairpin *hp)
 		MLX5_SET(tirc, tirc, transport_domain, hp->tdn);
 		MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
 		MLX5_SET(tirc, tirc, indirect_table, hp->indir_rqt.rqtn);
-		mlx5e_build_indir_tir_ctx_hash(&priv->rss_params, &ttconfig, tirc, false);
+		mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params, &ttconfig,
+					       tirc, false);
 
 		err = mlx5_core_create_tir(hp->func_mdev, in,
 					   &hp->indir_tirn[tt]);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 87c713179c28..685d23e90450 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -333,7 +333,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_set_ttc_basic_params(priv, &ttc_params);
 	mlx5e_set_ttc_ft_params(&ttc_params);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = priv->indir_tir[tt].tirn;
+		ttc_params.indir_tirn[tt] = priv->rx_res->indir_tirs[tt].tirn;
 
 	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
 	if (err) {
@@ -362,7 +362,11 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	u16 max_nch = priv->max_nch;
 	int err;
 
-	mlx5e_build_rss_params(&priv->rss_params, priv->channels.params.num_channels);
+	priv->rx_res = kvzalloc(sizeof(*priv->rx_res), GFP_KERNEL);
+	if (!priv->rx_res)
+		return -ENOMEM;
+
+	mlx5e_build_rss_params(&priv->rx_res->rss_params, priv->channels.params.num_channels);
 
 	mlx5e_create_q_counters(priv);
 
@@ -376,7 +380,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_close_drop_rq;
 
-	err = mlx5e_create_direct_rqts(priv, priv->direct_tir, max_nch);
+	err = mlx5e_create_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
 	if (err)
 		goto err_destroy_indirect_rqts;
 
@@ -384,7 +388,7 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_direct_rqts;
 
-	err = mlx5e_create_direct_tirs(priv, priv->direct_tir, max_nch);
+	err = mlx5e_create_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 	if (err)
 		goto err_destroy_indirect_tirs;
 
@@ -395,18 +399,19 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 	return 0;
 
 err_destroy_direct_tirs:
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 err_destroy_indirect_tirs:
 	mlx5e_destroy_indirect_tirs(priv);
 err_destroy_direct_rqts:
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
 err_destroy_indirect_rqts:
-	priv->indir_rqt_enabled = false;
-	mlx5e_rqt_destroy(&priv->indir_rqt);
+	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 err_close_drop_rq:
 	mlx5e_close_drop_rq(&priv->drop_rq);
 err_destroy_q_counters:
 	mlx5e_destroy_q_counters(priv);
+	kvfree(priv->rx_res);
+	priv->rx_res = NULL;
 	return err;
 }
 
@@ -415,13 +420,14 @@ static void mlx5i_cleanup_rx(struct mlx5e_priv *priv)
 	u16 max_nch = priv->max_nch;
 
 	mlx5i_destroy_flow_steering(priv);
-	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
+	mlx5e_destroy_direct_tirs(priv, priv->rx_res->direct_tirs, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
-	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
-	priv->indir_rqt_enabled = false;
-	mlx5e_rqt_destroy(&priv->indir_rqt);
+	mlx5e_destroy_direct_rqts(priv, priv->rx_res->direct_tirs, max_nch);
+	mlx5e_rqt_destroy(&priv->rx_res->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
+	kvfree(priv->rx_res);
+	priv->rx_res = NULL;
 }
 
 /* The stats groups order is opposite to the update_stats() order calls */
-- 
2.31.1

