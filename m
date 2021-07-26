Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB73D650C
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbhGZQTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241917AbhGZQQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C7060F9D;
        Mon, 26 Jul 2021 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318560;
        bh=cn99HZ7GWBXT4DwdioWKDBDu8Md4h56xcV0E6LazM5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTgH7sVYu5p7nRSI4h0SAp9rkdLX+OzRLwo4a/uhXpBKexu6fR4/6XaqXEM0YPVX4
         lmgvrREATvBZ+NGsIhKMd2NUOwCU3ar6AFHRrvlq1oGK8BZ8q7U4/Y6TDXoyt5KPW1
         9mdIURJlclvwIMz3QDjPBx/N04P1oqhRzkUNCc+tS21d9976Te5hPOtQBGl4fORGp2
         0JTyOlFwtZxhLP+s2upWV3Fr9j1meXAf3eR0W8nC4gSLZfWPKzkWzidCkaIJB7piVS
         YNLlcFbJ3U1JwHV/fhKBfpVUB/GX6CmF8baZF3ka5ckoC6KJCTwDpUJ5cffBMz9A5D
         O/uoUpBXTUP4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5e: Move management of indir traffic types to rx_res
Date:   Mon, 26 Jul 2021 09:55:43 -0700
Message-Id: <20210726165544.389143-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

This commit moves the responsibility of keeping the RSS configuration
for different traffic types to en/rx_res.{c,h}, hiding the
implementation details behind the new getters, and abandons all usage of
struct mlx5e_tirc_config, which is no longer useful and superseded by
struct mlx5e_rss_params_traffic_type.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  6 --
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   | 73 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |  5 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 71 ++----------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  9 +--
 7 files changed, 87 insertions(+), 81 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 148e2f92881b..6378dc815df7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -27,7 +27,8 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
-		en/qos.o en/trap.o en/fs_tt_redirect.o en/rqt.o en/tir.o
+		en/qos.o en/trap.o en/fs_tt_redirect.o en/rqt.o en/tir.o \
+		en/rx_res.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6a72b6f0366a..35668986878a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -922,7 +922,6 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __always_unused __be16 proto,
 void mlx5e_timestamp_init(struct mlx5e_priv *priv);
 
 int mlx5e_modify_tirs_hash(struct mlx5e_priv *priv);
-struct mlx5e_tirc_config mlx5e_tirc_get_default_config(enum mlx5e_traffic_types tt);
 
 struct mlx5e_xsk_param;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index d764ce8259a1..0e053aab12b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -83,12 +83,6 @@ enum mlx5e_traffic_types {
 	MLX5E_NUM_INDIR_TIRS = MLX5E_TT_ANY,
 };
 
-struct mlx5e_tirc_config {
-	u8 l3_prot_type;
-	u8 l4_prot_type;
-	u32 rx_hash_fields;
-};
-
 #define MLX5_HASH_IP		(MLX5_HASH_FIELD_SEL_SRC_IP   |\
 				 MLX5_HASH_FIELD_SEL_DST_IP)
 #define MLX5_HASH_IP_L4PORTS	(MLX5_HASH_FIELD_SEL_SRC_IP   |\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
new file mode 100644
index 000000000000..8fc1dfc4e830
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#include "rx_res.h"
+
+static const struct mlx5e_rss_params_traffic_type rss_default_config[MLX5E_NUM_INDIR_TIRS] = {
+	[MLX5E_TT_IPV4_TCP] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
+		.l4_prot_type = MLX5_L4_PROT_TYPE_TCP,
+		.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
+	},
+	[MLX5E_TT_IPV6_TCP] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
+		.l4_prot_type = MLX5_L4_PROT_TYPE_TCP,
+		.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
+	},
+	[MLX5E_TT_IPV4_UDP] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
+		.l4_prot_type = MLX5_L4_PROT_TYPE_UDP,
+		.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
+	},
+	[MLX5E_TT_IPV6_UDP] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
+		.l4_prot_type = MLX5_L4_PROT_TYPE_UDP,
+		.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
+	},
+	[MLX5E_TT_IPV4_IPSEC_AH] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
+		.l4_prot_type = 0,
+		.rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
+	},
+	[MLX5E_TT_IPV6_IPSEC_AH] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
+		.l4_prot_type = 0,
+		.rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
+	},
+	[MLX5E_TT_IPV4_IPSEC_ESP] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
+		.l4_prot_type = 0,
+		.rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
+	},
+	[MLX5E_TT_IPV6_IPSEC_ESP] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
+		.l4_prot_type = 0,
+		.rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
+	},
+	[MLX5E_TT_IPV4] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
+		.l4_prot_type = 0,
+		.rx_hash_fields = MLX5_HASH_IP,
+	},
+	[MLX5E_TT_IPV6] = {
+		.l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
+		.l4_prot_type = 0,
+		.rx_hash_fields = MLX5_HASH_IP,
+	},
+};
+
+struct mlx5e_rss_params_traffic_type
+mlx5e_rss_get_default_tt_config(enum mlx5e_traffic_types tt)
+{
+	return rss_default_config[tt];
+}
+
+struct mlx5e_rss_params_traffic_type
+mlx5e_rx_res_rss_get_current_tt_config(struct mlx5e_rx_res *res, enum mlx5e_traffic_types tt)
+{
+	struct mlx5e_rss_params_traffic_type rss_tt;
+
+	rss_tt = mlx5e_rss_get_default_tt_config(tt);
+	rss_tt.rx_hash_fields = res->rss_params.rx_hash_fields[tt];
+	return rss_tt;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index 130d81c32ffd..068e48140a6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -39,4 +39,9 @@ struct mlx5e_rx_res {
 	} ptp;
 };
 
+struct mlx5e_rss_params_traffic_type
+mlx5e_rss_get_default_tt_config(enum mlx5e_traffic_types tt);
+struct mlx5e_rss_params_traffic_type
+mlx5e_rx_res_rss_get_current_tt_config(struct mlx5e_rx_res *res, enum mlx5e_traffic_types tt);
+
 #endif /* __MLX5_EN_RX_RES_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7bed96a9c320..b9a0459b58f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2316,69 +2316,9 @@ static void mlx5e_redirect_rqts_to_drop(struct mlx5e_priv *priv)
 		mlx5e_rqt_redirect_direct(&res->ptp.rqt, priv->drop_rq.rqn);
 }
 
-static const struct mlx5e_tirc_config tirc_default_config[MLX5E_NUM_INDIR_TIRS] = {
-	[MLX5E_TT_IPV4_TCP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
-				.l4_prot_type = MLX5_L4_PROT_TYPE_TCP,
-				.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
-	},
-	[MLX5E_TT_IPV6_TCP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
-				.l4_prot_type = MLX5_L4_PROT_TYPE_TCP,
-				.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
-	},
-	[MLX5E_TT_IPV4_UDP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
-				.l4_prot_type = MLX5_L4_PROT_TYPE_UDP,
-				.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
-	},
-	[MLX5E_TT_IPV6_UDP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
-				.l4_prot_type = MLX5_L4_PROT_TYPE_UDP,
-				.rx_hash_fields = MLX5_HASH_IP_L4PORTS,
-	},
-	[MLX5E_TT_IPV4_IPSEC_AH] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
-				     .l4_prot_type = 0,
-				     .rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
-	},
-	[MLX5E_TT_IPV6_IPSEC_AH] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
-				     .l4_prot_type = 0,
-				     .rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
-	},
-	[MLX5E_TT_IPV4_IPSEC_ESP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
-				      .l4_prot_type = 0,
-				      .rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
-	},
-	[MLX5E_TT_IPV6_IPSEC_ESP] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
-				      .l4_prot_type = 0,
-				      .rx_hash_fields = MLX5_HASH_IP_IPSEC_SPI,
-	},
-	[MLX5E_TT_IPV4] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV4,
-			    .l4_prot_type = 0,
-			    .rx_hash_fields = MLX5_HASH_IP,
-	},
-	[MLX5E_TT_IPV6] = { .l3_prot_type = MLX5_L3_PROT_TYPE_IPV6,
-			    .l4_prot_type = 0,
-			    .rx_hash_fields = MLX5_HASH_IP,
-	},
-};
-
-struct mlx5e_tirc_config mlx5e_tirc_get_default_config(enum mlx5e_traffic_types tt)
-{
-	return tirc_default_config[tt];
-}
-
-static void mlx5e_update_rx_hash_fields(struct mlx5e_rss_params_traffic_type *rss_tt,
-					enum mlx5e_traffic_types tt,
-					u32 rx_hash_fields)
-{
-	*rss_tt = (struct mlx5e_rss_params_traffic_type) {
-		.l3_prot_type = tirc_default_config[tt].l3_prot_type,
-		.l4_prot_type = tirc_default_config[tt].l4_prot_type,
-		.rx_hash_fields = rx_hash_fields,
-	};
-}
-
 int mlx5e_modify_tirs_hash(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rss_params_hash *rss_hash = &priv->rx_res->rss_params.hash;
-	struct mlx5e_rss_params *rss = &priv->rx_res->rss_params;
 	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_rx_res *res = priv->rx_res;
 	struct mlx5e_tir_builder *builder;
@@ -2389,7 +2329,7 @@ int mlx5e_modify_tirs_hash(struct mlx5e_priv *priv)
 		return -ENOMEM;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
 		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, false);
 		mlx5e_tir_modify(&res->rss[tt].indir_tir, builder);
 		mlx5e_tir_builder_clear(builder);
@@ -2400,7 +2340,7 @@ int mlx5e_modify_tirs_hash(struct mlx5e_priv *priv)
 		goto out;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
 		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, true);
 		mlx5e_tir_modify(&res->rss[tt].indir_tir, builder);
 		mlx5e_tir_builder_clear(builder);
@@ -3083,7 +3023,6 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 {
 	struct mlx5e_rss_params_hash *rss_hash = &priv->rx_res->rss_params.hash;
 	bool inner_ft_support = priv->channels.params.tunneled_offload_en;
-	struct mlx5e_rss_params *rss = &priv->rx_res->rss_params;
 	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_rx_res *res = priv->rx_res;
 	enum mlx5e_traffic_types tt, max_tt;
@@ -3103,7 +3042,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		mlx5e_tir_builder_build_rqt(builder, priv->mdev->mlx5e_res.hw_objs.td.tdn,
 					    indir_rqtn, inner_ft_support);
 		mlx5e_tir_builder_build_lro(builder, &lro_param);
-		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
 		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, false);
 
 		err = mlx5e_tir_init(&res->rss[tt].indir_tir, builder, priv->mdev, true);
@@ -3122,7 +3061,7 @@ int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 		mlx5e_tir_builder_build_rqt(builder, priv->mdev->mlx5e_res.hw_objs.td.tdn,
 					    indir_rqtn, inner_ft_support);
 		mlx5e_tir_builder_build_lro(builder, &lro_param);
-		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		rss_tt = mlx5e_rx_res_rss_get_current_tt_config(res, tt);
 		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, true);
 
 		err = mlx5e_tir_init(&res->rss[tt].inner_indir_tir, builder, priv->mdev, true);
@@ -4540,7 +4479,7 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 				      MLX5E_INDIR_RQT_SIZE, num_channels);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		rss_params->rx_hash_fields[tt] =
-			tirc_default_config[tt].rx_hash_fields;
+			mlx5e_rss_get_default_tt_config(tt).rx_hash_fields;
 }
 
 void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16 mtu)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c5ab3e81d13e..0cee2fa76d65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -515,7 +515,6 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 
 static int mlx5e_hairpin_create_indirect_tirs(struct mlx5e_hairpin *hp)
 {
-	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_priv *priv = hp->func_priv;
 	struct mlx5e_rss_params_hash *rss_hash;
 	enum mlx5e_traffic_types tt, max_tt;
@@ -529,13 +528,9 @@ static int mlx5e_hairpin_create_indirect_tirs(struct mlx5e_hairpin *hp)
 	rss_hash = &priv->rx_res->rss_params.hash;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		struct mlx5e_tirc_config ttconfig = mlx5e_tirc_get_default_config(tt);
+		struct mlx5e_rss_params_traffic_type rss_tt;
 
-		rss_tt = (struct mlx5e_rss_params_traffic_type) {
-			.l3_prot_type = ttconfig.l3_prot_type,
-			.l4_prot_type = ttconfig.l4_prot_type,
-			.rx_hash_fields = ttconfig.rx_hash_fields,
-		};
+		rss_tt = mlx5e_rss_get_default_tt_config(tt);
 
 		mlx5e_tir_builder_build_rqt(builder, hp->tdn,
 					    mlx5e_rqt_get_rqtn(&hp->indir_rqt),
-- 
2.31.1

