Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8123D650E
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240784AbhGZQT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241916AbhGZQQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8856F60F9C;
        Mon, 26 Jul 2021 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318559;
        bh=SdqcC4SBnpiyAbGIwEUencGCPWBBzYGKb6rvF/3ryhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDhVl40jHs6zDLPAy6GyGKfslc2TY/C18lGracxw0YMagihjB8i/uM90ADviUXU/V
         5y0BXC+SfpuNvl7VOoh3DchSepbV6YeaSZmN2kXoKZdk3F65N2jt+ugPnLzCuJbBsM
         LKXpujOJpDDXtiLV4Lon+xR+7FKl1hE0cSl8vfeJ4HRhRZRT68DQ8b1yK7/RSgIAft
         UAMl3ULo6Ar7ignHvbUvmQn5rBP5bTnuk/vtJ0BQFj2qS0/6+MtsSon5wrxbWJj+l8
         jQkbgIZAxrNbgzjLrThDziNRruLm6SO9N1NO+StyM46xrTRmYUcU5vpZZGDBr048rJ
         Q1KBBdakA7dSA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5e: Convert TIR to a dedicated object
Date:   Mon, 26 Jul 2021 09:55:42 -0700
Message-Id: <20210726165544.389143-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Code related to TIR is now encapsulated into a dedicated object and put
into new files en/tir.{c,h}. All usages are converted.

The Builder pattern is used to initialize a TIR. It allows to create a
multitude of different configurations, turning on and off some specific
features in different combinations, without having long parameter lists,
initializers per usage and repeating code in initializers.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  10 +-
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en/tir.c  | 188 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/tir.h  |  57 ++++
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |  27 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   |  28 --
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  10 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 322 ++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  90 +++--
 11 files changed, 447 insertions(+), 307 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index e65fc3aa79f8..148e2f92881b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -27,7 +27,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
-		en/qos.o en/trap.o en/fs_tt_redirect.o en/rqt.o
+		en/qos.o en/trap.o en/fs_tt_redirect.o en/rqt.o en/tir.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 59fc8432202f..6a72b6f0366a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -127,7 +127,6 @@ struct page_pool;
 
 #define MLX5E_PARAMS_MINIMUM_LOG_RQ_SIZE_MPW            0x2
 
-#define MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ                 (64 * 1024)
 #define MLX5E_DEFAULT_LRO_TIMEOUT                       32
 #define MLX5E_LRO_TIMEOUT_ARR_SIZE                      4
 
@@ -922,10 +921,7 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __always_unused __be16 proto,
 			   u16 vid);
 void mlx5e_timestamp_init(struct mlx5e_priv *priv);
 
-void mlx5e_build_indir_tir_ctx_hash(struct mlx5e_rss_params *rss_params,
-				    const struct mlx5e_tirc_config *ttconfig,
-				    void *tirc, bool inner);
-void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in);
+int mlx5e_modify_tirs_hash(struct mlx5e_priv *priv);
 struct mlx5e_tirc_config mlx5e_tirc_get_default_config(enum mlx5e_traffic_types tt);
 
 struct mlx5e_xsk_param;
@@ -1026,10 +1022,6 @@ static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 
 extern const struct ethtool_ops mlx5e_ethtool_ops;
 
-int mlx5e_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir,
-		     u32 *in);
-void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
-		       struct mlx5e_tir *tir);
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev);
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev);
 int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index bdcd0b583e43..130d81c32ffd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -6,26 +6,17 @@
 
 #include <linux/kernel.h>
 #include "rqt.h"
+#include "tir.h"
 #include "fs.h"
 
 #define MLX5E_MAX_NUM_CHANNELS (MLX5E_INDIR_RQT_SIZE / 2)
 
-struct mlx5e_rss_params_hash {
-	u8 hfunc;
-	u8 toeplitz_hash_key[40];
-};
-
 struct mlx5e_rss_params {
 	struct mlx5e_rss_params_hash hash;
 	struct mlx5e_rss_params_indir indir;
 	u32 rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
 };
 
-struct mlx5e_tir {
-	u32 tirn;
-	struct list_head list;
-};
-
 struct mlx5e_rx_res {
 	struct mlx5e_rss_params rss_params;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
new file mode 100644
index 000000000000..3ec94da45d36
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -0,0 +1,188 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#include "tir.h"
+#include "params.h"
+#include <linux/mlx5/transobj.h>
+
+#define MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ (64 * 1024)
+
+/* max() doesn't work inside square brackets. */
+#define MLX5E_TIR_CMD_IN_SZ_DW ( \
+	MLX5_ST_SZ_DW(create_tir_in) > MLX5_ST_SZ_DW(modify_tir_in) ? \
+	MLX5_ST_SZ_DW(create_tir_in) : MLX5_ST_SZ_DW(modify_tir_in) \
+)
+
+struct mlx5e_tir_builder {
+	u32 in[MLX5E_TIR_CMD_IN_SZ_DW];
+	bool modify;
+};
+
+struct mlx5e_tir_builder *mlx5e_tir_builder_alloc(bool modify)
+{
+	struct mlx5e_tir_builder *builder;
+
+	builder = kvzalloc(sizeof(*builder), GFP_KERNEL);
+	builder->modify = modify;
+
+	return builder;
+}
+
+void mlx5e_tir_builder_free(struct mlx5e_tir_builder *builder)
+{
+	kvfree(builder);
+}
+
+void mlx5e_tir_builder_clear(struct mlx5e_tir_builder *builder)
+{
+	memset(builder->in, 0, sizeof(builder->in));
+}
+
+static void *mlx5e_tir_builder_get_tirc(struct mlx5e_tir_builder *builder)
+{
+	if (builder->modify)
+		return MLX5_ADDR_OF(modify_tir_in, builder->in, ctx);
+	return MLX5_ADDR_OF(create_tir_in, builder->in, ctx);
+}
+
+void mlx5e_tir_builder_build_inline(struct mlx5e_tir_builder *builder, u32 tdn, u32 rqn)
+{
+	void *tirc = mlx5e_tir_builder_get_tirc(builder);
+
+	WARN_ON(builder->modify);
+
+	MLX5_SET(tirc, tirc, transport_domain, tdn);
+	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
+	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_NONE);
+	MLX5_SET(tirc, tirc, inline_rqn, rqn);
+}
+
+void mlx5e_tir_builder_build_rqt(struct mlx5e_tir_builder *builder, u32 tdn,
+				 u32 rqtn, bool inner_ft_support)
+{
+	void *tirc = mlx5e_tir_builder_get_tirc(builder);
+
+	WARN_ON(builder->modify);
+
+	MLX5_SET(tirc, tirc, transport_domain, tdn);
+	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
+	MLX5_SET(tirc, tirc, indirect_table, rqtn);
+	MLX5_SET(tirc, tirc, tunneled_offload_en, inner_ft_support);
+}
+
+void mlx5e_tir_builder_build_lro(struct mlx5e_tir_builder *builder,
+				 const struct mlx5e_lro_param *lro_param)
+{
+	void *tirc = mlx5e_tir_builder_get_tirc(builder);
+	const unsigned int rough_max_l2_l3_hdr_sz = 256;
+
+	if (builder->modify)
+		MLX5_SET(modify_tir_in, builder->in, bitmask.lro, 1);
+
+	if (!lro_param->enabled)
+		return;
+
+	MLX5_SET(tirc, tirc, lro_enable_mask,
+		 MLX5_TIRC_LRO_ENABLE_MASK_IPV4_LRO |
+		 MLX5_TIRC_LRO_ENABLE_MASK_IPV6_LRO);
+	MLX5_SET(tirc, tirc, lro_max_ip_payload_size,
+		 (MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ - rough_max_l2_l3_hdr_sz) >> 8);
+	MLX5_SET(tirc, tirc, lro_timeout_period_usecs, lro_param->timeout);
+}
+
+static int mlx5e_hfunc_to_hw(u8 hfunc)
+{
+	switch (hfunc) {
+	case ETH_RSS_HASH_TOP:
+		return MLX5_RX_HASH_FN_TOEPLITZ;
+	case ETH_RSS_HASH_XOR:
+		return MLX5_RX_HASH_FN_INVERTED_XOR8;
+	default:
+		return MLX5_RX_HASH_FN_NONE;
+	}
+}
+
+void mlx5e_tir_builder_build_rss(struct mlx5e_tir_builder *builder,
+				 const struct mlx5e_rss_params_hash *rss_hash,
+				 const struct mlx5e_rss_params_traffic_type *rss_tt,
+				 bool inner)
+{
+	void *tirc = mlx5e_tir_builder_get_tirc(builder);
+	void *hfso;
+
+	if (builder->modify)
+		MLX5_SET(modify_tir_in, builder->in, bitmask.hash, 1);
+
+	MLX5_SET(tirc, tirc, rx_hash_fn, mlx5e_hfunc_to_hw(rss_hash->hfunc));
+	if (rss_hash->hfunc == ETH_RSS_HASH_TOP) {
+		const size_t len = MLX5_FLD_SZ_BYTES(tirc, rx_hash_toeplitz_key);
+		void *rss_key = MLX5_ADDR_OF(tirc, tirc, rx_hash_toeplitz_key);
+
+		MLX5_SET(tirc, tirc, rx_hash_symmetric, 1);
+		memcpy(rss_key, rss_hash->toeplitz_hash_key, len);
+	}
+
+	if (inner)
+		hfso = MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_inner);
+	else
+		hfso = MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_outer);
+	MLX5_SET(rx_hash_field_select, hfso, l3_prot_type, rss_tt->l3_prot_type);
+	MLX5_SET(rx_hash_field_select, hfso, l4_prot_type, rss_tt->l4_prot_type);
+	MLX5_SET(rx_hash_field_select, hfso, selected_fields, rss_tt->rx_hash_fields);
+}
+
+void mlx5e_tir_builder_build_direct(struct mlx5e_tir_builder *builder)
+{
+	void *tirc = mlx5e_tir_builder_get_tirc(builder);
+
+	WARN_ON(builder->modify);
+
+	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
+}
+
+int mlx5e_tir_init(struct mlx5e_tir *tir, struct mlx5e_tir_builder *builder,
+		   struct mlx5_core_dev *mdev, bool reg)
+{
+	int err;
+
+	tir->mdev = mdev;
+
+	err = mlx5_core_create_tir(tir->mdev, builder->in, &tir->tirn);
+	if (err)
+		return err;
+
+	if (reg) {
+		struct mlx5e_hw_objs *res = &tir->mdev->mlx5e_res.hw_objs;
+
+		mutex_lock(&res->td.list_lock);
+		list_add(&tir->list, &res->td.tirs_list);
+		mutex_unlock(&res->td.list_lock);
+	} else {
+		INIT_LIST_HEAD(&tir->list);
+	}
+
+	return 0;
+}
+
+void mlx5e_tir_destroy(struct mlx5e_tir *tir)
+{
+	struct mlx5e_hw_objs *res = &tir->mdev->mlx5e_res.hw_objs;
+
+	/* Skip mutex if list_del is no-op (the TIR wasn't registered in the
+	 * list). list_empty will never return true for an item of tirs_list,
+	 * and READ_ONCE/WRITE_ONCE in list_empty/list_del guarantee consistency
+	 * of the list->next value.
+	 */
+	if (!list_empty(&tir->list)) {
+		mutex_lock(&res->td.list_lock);
+		list_del(&tir->list);
+		mutex_unlock(&res->td.list_lock);
+	}
+
+	mlx5_core_destroy_tir(tir->mdev, tir->tirn);
+}
+
+int mlx5e_tir_modify(struct mlx5e_tir *tir, struct mlx5e_tir_builder *builder)
+{
+	return mlx5_core_modify_tir(tir->mdev, tir->tirn, builder->in);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
new file mode 100644
index 000000000000..25b8a2edf6cc
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_EN_TIR_H__
+#define __MLX5_EN_TIR_H__
+
+#include <linux/kernel.h>
+
+struct mlx5e_rss_params_hash {
+	u8 hfunc;
+	u8 toeplitz_hash_key[40];
+};
+
+struct mlx5e_rss_params_traffic_type {
+	u8 l3_prot_type;
+	u8 l4_prot_type;
+	u32 rx_hash_fields;
+};
+
+struct mlx5e_tir_builder;
+struct mlx5e_lro_param;
+
+struct mlx5e_tir_builder *mlx5e_tir_builder_alloc(bool modify);
+void mlx5e_tir_builder_free(struct mlx5e_tir_builder *builder);
+void mlx5e_tir_builder_clear(struct mlx5e_tir_builder *builder);
+
+void mlx5e_tir_builder_build_inline(struct mlx5e_tir_builder *builder, u32 tdn, u32 rqn);
+void mlx5e_tir_builder_build_rqt(struct mlx5e_tir_builder *builder, u32 tdn,
+				 u32 rqtn, bool inner_ft_support);
+void mlx5e_tir_builder_build_lro(struct mlx5e_tir_builder *builder,
+				 const struct mlx5e_lro_param *lro_param);
+void mlx5e_tir_builder_build_rss(struct mlx5e_tir_builder *builder,
+				 const struct mlx5e_rss_params_hash *rss_hash,
+				 const struct mlx5e_rss_params_traffic_type *rss_tt,
+				 bool inner);
+void mlx5e_tir_builder_build_direct(struct mlx5e_tir_builder *builder);
+
+struct mlx5_core_dev;
+
+struct mlx5e_tir {
+	struct mlx5_core_dev *mdev;
+	u32 tirn;
+	struct list_head list;
+};
+
+int mlx5e_tir_init(struct mlx5e_tir *tir, struct mlx5e_tir_builder *builder,
+		   struct mlx5_core_dev *mdev, bool reg);
+void mlx5e_tir_destroy(struct mlx5e_tir *tir);
+
+static inline u32 mlx5e_tir_get_tirn(struct mlx5e_tir *tir)
+{
+	return tir->tirn;
+}
+
+int mlx5e_tir_modify(struct mlx5e_tir *tir, struct mlx5e_tir_builder *builder);
+
+#endif /* __MLX5_EN_TIR_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 86ab4e864fe6..afaf5b413066 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -92,30 +92,19 @@ static void mlx5e_close_trap_rq(struct mlx5e_rq *rq)
 static int mlx5e_create_trap_direct_rq_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir,
 					   u32 rqn)
 {
-	void *tirc;
-	int inlen;
-	u32 *in;
+	struct mlx5e_tir_builder *builder;
 	int err;
 
-	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
 		return -ENOMEM;
 
-	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-	MLX5_SET(tirc, tirc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
-	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_NONE);
-	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
-	MLX5_SET(tirc, tirc, inline_rqn, rqn);
-	err = mlx5e_create_tir(mdev, tir, in);
-	kvfree(in);
+	mlx5e_tir_builder_build_inline(builder, mdev->mlx5e_res.hw_objs.td.tdn, rqn);
+	err = mlx5e_tir_init(tir, builder, mdev, true);
 
-	return err;
-}
+	mlx5e_tir_builder_free(builder);
 
-static void mlx5e_destroy_trap_direct_rq_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir)
-{
-	mlx5e_destroy_tir(mdev, tir);
+	return err;
 }
 
 static void mlx5e_build_trap_params(struct mlx5_core_dev *mdev,
@@ -173,7 +162,7 @@ static struct mlx5e_trap *mlx5e_open_trap(struct mlx5e_priv *priv)
 
 void mlx5e_close_trap(struct mlx5e_trap *trap)
 {
-	mlx5e_destroy_trap_direct_rq_tir(trap->mdev, &trap->tir);
+	mlx5e_tir_destroy(&trap->tir);
 	mlx5e_close_trap_rq(&trap->rq);
 	netif_napi_del(&trap->napi);
 	kvfree(trap);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index f3bdd063051a..c4db367d4baf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -36,34 +36,6 @@
  * Global resources are common to all the netdevices crated on the same nic.
  */
 
-int mlx5e_create_tir(struct mlx5_core_dev *mdev, struct mlx5e_tir *tir, u32 *in)
-{
-	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
-	int err;
-
-	err = mlx5_core_create_tir(mdev, in, &tir->tirn);
-	if (err)
-		return err;
-
-	mutex_lock(&res->td.list_lock);
-	list_add(&tir->list, &res->td.tirs_list);
-	mutex_unlock(&res->td.list_lock);
-
-	return 0;
-}
-
-void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
-		       struct mlx5e_tir *tir)
-{
-	struct mlx5e_hw_objs *res = &mdev->mlx5e_res.hw_objs;
-
-	mutex_lock(&res->td.list_lock);
-	list_del(&tir->list);
-	mutex_unlock(&res->td.list_lock);
-
-	mlx5_core_destroy_tir(mdev, tir->tirn);
-}
-
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 {
 	bool ro_pci_enable = pcie_relaxed_ordering_enabled(mdev->pdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 4167f4e4211e..9264d18b0964 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1218,21 +1218,15 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 		   const u8 *key, const u8 hfunc)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	int inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
 	struct mlx5e_rss_params *rss;
 	bool refresh_tirs = false;
 	bool refresh_rqt = false;
-	void *in;
 
 	if ((hfunc != ETH_RSS_HASH_NO_CHANGE) &&
 	    (hfunc != ETH_RSS_HASH_XOR) &&
 	    (hfunc != ETH_RSS_HASH_TOP))
 		return -EINVAL;
 
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
 	mutex_lock(&priv->state_lock);
 
 	rss = &priv->rx_res->rss_params;
@@ -1271,12 +1265,10 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 	}
 
 	if (refresh_tirs)
-		mlx5e_modify_tirs_hash(priv, in);
+		mlx5e_modify_tirs_hash(priv);
 
 	mutex_unlock(&priv->state_lock);
 
-	kvfree(in);
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 32edb9119d38..494f6f832407 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -817,10 +817,8 @@ static enum mlx5e_traffic_types flow_type_to_traffic_type(u32 flow_type)
 static int mlx5e_set_rss_hash_opt(struct mlx5e_priv *priv,
 				  struct ethtool_rxnfc *nfc)
 {
-	int inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
 	enum mlx5e_traffic_types tt;
 	u8 rx_hash_field = 0;
-	void *in;
 
 	tt = flow_type_to_traffic_type(nfc->flow_type);
 	if (tt == MLX5E_NUM_INDIR_TIRS)
@@ -849,21 +847,16 @@ static int mlx5e_set_rss_hash_opt(struct mlx5e_priv *priv,
 	if (nfc->data & RXH_L4_B_2_3)
 		rx_hash_field |= MLX5_HASH_FIELD_SEL_L4_DPORT;
 
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
 	mutex_lock(&priv->state_lock);
 
 	if (rx_hash_field == priv->rx_res->rss_params.rx_hash_fields[tt])
 		goto out;
 
 	priv->rx_res->rss_params.rx_hash_fields[tt] = rx_hash_field;
-	mlx5e_modify_tirs_hash(priv, in);
+	mlx5e_modify_tirs_hash(priv);
 
 out:
 	mutex_unlock(&priv->state_lock);
-	kvfree(in);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 10e6bebe8c74..7bed96a9c320 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2265,13 +2265,6 @@ static void mlx5e_destroy_xsk_rqts(struct mlx5e_priv *priv)
 		mlx5e_rqt_destroy(&priv->rx_res->channels[ix].xsk_rqt);
 }
 
-static int mlx5e_rx_hash_fn(int hfunc)
-{
-	return (hfunc == ETH_RSS_HASH_TOP) ?
-	       MLX5_RX_HASH_FN_TOEPLITZ :
-	       MLX5_RX_HASH_FN_INVERTED_XOR8;
-}
-
 static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
 					    struct mlx5e_channels *chs)
 {
@@ -2371,134 +2364,91 @@ struct mlx5e_tirc_config mlx5e_tirc_get_default_config(enum mlx5e_traffic_types
 	return tirc_default_config[tt];
 }
 
-static void mlx5e_build_tir_ctx_lro(struct mlx5e_lro_param *lro_param, void *tirc)
-{
-	if (!lro_param->enabled)
-		return;
-
-#define ROUGH_MAX_L2_L3_HDR_SZ 256
-
-	MLX5_SET(tirc, tirc, lro_enable_mask,
-		 MLX5_TIRC_LRO_ENABLE_MASK_IPV4_LRO |
-		 MLX5_TIRC_LRO_ENABLE_MASK_IPV6_LRO);
-	MLX5_SET(tirc, tirc, lro_max_ip_payload_size,
-		 (MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ - ROUGH_MAX_L2_L3_HDR_SZ) >> 8);
-	MLX5_SET(tirc, tirc, lro_timeout_period_usecs, lro_param->timeout);
-}
-
-void mlx5e_build_indir_tir_ctx_hash(struct mlx5e_rss_params *rss_params,
-				    const struct mlx5e_tirc_config *ttconfig,
-				    void *tirc, bool inner)
-{
-	void *hfso = inner ? MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_inner) :
-			     MLX5_ADDR_OF(tirc, tirc, rx_hash_field_selector_outer);
-
-	MLX5_SET(tirc, tirc, rx_hash_fn, mlx5e_rx_hash_fn(rss_params->hash.hfunc));
-	if (rss_params->hash.hfunc == ETH_RSS_HASH_TOP) {
-		void *rss_key = MLX5_ADDR_OF(tirc, tirc,
-					     rx_hash_toeplitz_key);
-		size_t len = MLX5_FLD_SZ_BYTES(tirc,
-					       rx_hash_toeplitz_key);
-
-		MLX5_SET(tirc, tirc, rx_hash_symmetric, 1);
-		memcpy(rss_key, rss_params->hash.toeplitz_hash_key, len);
-	}
-	MLX5_SET(rx_hash_field_select, hfso, l3_prot_type,
-		 ttconfig->l3_prot_type);
-	MLX5_SET(rx_hash_field_select, hfso, l4_prot_type,
-		 ttconfig->l4_prot_type);
-	MLX5_SET(rx_hash_field_select, hfso, selected_fields,
-		 ttconfig->rx_hash_fields);
-}
-
-static void mlx5e_update_rx_hash_fields(struct mlx5e_tirc_config *ttconfig,
+static void mlx5e_update_rx_hash_fields(struct mlx5e_rss_params_traffic_type *rss_tt,
 					enum mlx5e_traffic_types tt,
 					u32 rx_hash_fields)
 {
-	*ttconfig                = tirc_default_config[tt];
-	ttconfig->rx_hash_fields = rx_hash_fields;
+	*rss_tt = (struct mlx5e_rss_params_traffic_type) {
+		.l3_prot_type = tirc_default_config[tt].l3_prot_type,
+		.l4_prot_type = tirc_default_config[tt].l4_prot_type,
+		.rx_hash_fields = rx_hash_fields,
+	};
 }
 
-void mlx5e_modify_tirs_hash(struct mlx5e_priv *priv, void *in)
+int mlx5e_modify_tirs_hash(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rss_params_hash *rss_hash = &priv->rx_res->rss_params.hash;
 	struct mlx5e_rss_params *rss = &priv->rx_res->rss_params;
-	void *tirc = MLX5_ADDR_OF(modify_tir_in, in, ctx);
+	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_rx_res *res = priv->rx_res;
-	struct mlx5_core_dev *mdev = priv->mdev;
-	int ctxlen = MLX5_ST_SZ_BYTES(tirc);
-	struct mlx5e_tirc_config ttconfig;
-	int tt;
+	struct mlx5e_tir_builder *builder;
+	enum mlx5e_traffic_types tt;
 
-	MLX5_SET(modify_tir_in, in, bitmask.hash, 1);
+	builder = mlx5e_tir_builder_alloc(true);
+	if (!builder)
+		return -ENOMEM;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		memset(tirc, 0, ctxlen);
-		mlx5e_update_rx_hash_fields(&ttconfig, tt,
-					    rss->rx_hash_fields[tt]);
-		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, false);
-		mlx5_core_modify_tir(mdev, res->rss[tt].indir_tir.tirn, in);
+		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, false);
+		mlx5e_tir_modify(&res->rss[tt].indir_tir, builder);
+		mlx5e_tir_builder_clear(builder);
 	}
 
 	/* Verify inner tirs resources allocated */
 	if (!res->rss[0].inner_indir_tir.tirn)
-		return;
+		goto out;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		memset(tirc, 0, ctxlen);
-		mlx5e_update_rx_hash_fields(&ttconfig, tt,
-					    rss->rx_hash_fields[tt]);
-		mlx5e_build_indir_tir_ctx_hash(rss, &ttconfig, tirc, true);
-		mlx5_core_modify_tir(mdev, res->rss[tt].inner_indir_tir.tirn, in);
+		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, true);
+		mlx5e_tir_modify(&res->rss[tt].indir_tir, builder);
+		mlx5e_tir_builder_clear(builder);
 	}
+
+out:
+	mlx5e_tir_builder_free(builder);
+	return 0;
 }
 
 static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 {
-	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_rx_res *res = priv->rx_res;
+	struct mlx5e_tir_builder *builder;
 	struct mlx5e_lro_param lro_param;
-
-	void *in;
-	void *tirc;
-	int inlen;
+	enum mlx5e_traffic_types tt;
 	int err;
-	int tt;
 	int ix;
 
-	inlen = MLX5_ST_SZ_BYTES(modify_tir_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
+	builder = mlx5e_tir_builder_alloc(true);
+	if (!builder)
 		return -ENOMEM;
 
-	MLX5_SET(modify_tir_in, in, bitmask.lro, 1);
-	tirc = MLX5_ADDR_OF(modify_tir_in, in, ctx);
-
 	lro_param = mlx5e_get_lro_param(&priv->channels.params);
-	mlx5e_build_tir_ctx_lro(&lro_param, tirc);
+	mlx5e_tir_builder_build_lro(builder, &lro_param);
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		err = mlx5_core_modify_tir(mdev, res->rss[tt].indir_tir.tirn, in);
+		err = mlx5e_tir_modify(&res->rss[tt].indir_tir, builder);
 		if (err)
-			goto free_in;
+			goto err_free_builder;
 
 		/* Verify inner tirs resources allocated */
 		if (!res->rss[0].inner_indir_tir.tirn)
 			continue;
 
-		err = mlx5_core_modify_tir(mdev, res->rss[tt].inner_indir_tir.tirn, in);
+		err = mlx5e_tir_modify(&res->rss[tt].inner_indir_tir, builder);
 		if (err)
-			goto free_in;
+			goto err_free_builder;
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
-		err = mlx5_core_modify_tir(mdev, res->channels[ix].direct_tir.tirn, in);
+		err = mlx5e_tir_modify(&res->channels[ix].direct_tir, builder);
 		if (err)
-			goto free_in;
+			goto err_free_builder;
 	}
 
-free_in:
-	kvfree(in);
-
+err_free_builder:
+	mlx5e_tir_builder_free(builder);
 	return err;
 }
 
@@ -3129,167 +3079,159 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 	mlx5e_destroy_tises(priv);
 }
 
-static void mlx5e_build_indir_tir_ctx_common(u32 tdn, bool inner_ft_support,
-					     u32 rqtn, u32 *tirc)
-{
-	MLX5_SET(tirc, tirc, transport_domain, tdn);
-	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
-	MLX5_SET(tirc, tirc, indirect_table, rqtn);
-	MLX5_SET(tirc, tirc, tunneled_offload_en, inner_ft_support);
-}
-
-static void mlx5e_build_direct_tir_ctx(struct mlx5e_lro_param *lro_param,
-				       u32 tdn, bool inner_ft_support,
-				       u32 rqtn, u32 *tirc)
-{
-	mlx5e_build_indir_tir_ctx_common(tdn, inner_ft_support, rqtn, tirc);
-	mlx5e_build_tir_ctx_lro(lro_param, tirc);
-	MLX5_SET(tirc, tirc, rx_hash_fn, MLX5_RX_HASH_FN_INVERTED_XOR8);
-}
-
 int mlx5e_create_indirect_tirs(struct mlx5e_priv *priv, bool inner_ttc)
 {
+	struct mlx5e_rss_params_hash *rss_hash = &priv->rx_res->rss_params.hash;
+	bool inner_ft_support = priv->channels.params.tunneled_offload_en;
+	struct mlx5e_rss_params *rss = &priv->rx_res->rss_params;
+	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_rx_res *res = priv->rx_res;
+	enum mlx5e_traffic_types tt, max_tt;
+	struct mlx5e_tir_builder *builder;
 	struct mlx5e_lro_param lro_param;
-	struct mlx5e_tir *tir;
 	u32 indir_rqtn;
-	void *tirc;
-	int inlen;
-	int i = 0;
-	int err;
-	u32 *in;
-	int tt;
+	int err = 0;
 
-	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
 		return -ENOMEM;
 
 	lro_param = mlx5e_get_lro_param(&priv->channels.params);
-	indir_rqtn = mlx5e_rqt_get_rqtn(&priv->rx_res->indir_rqt);
+	indir_rqtn = mlx5e_rqt_get_rqtn(&res->indir_rqt);
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
-		memset(in, 0, inlen);
-		tir = &res->rss[tt].indir_tir;
-		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_indir_tir_ctx_common(priv->mdev->mlx5e_res.hw_objs.td.tdn,
-						 priv->channels.params.tunneled_offload_en,
-						 indir_rqtn, tirc);
-		mlx5e_build_tir_ctx_lro(&lro_param, tirc);
-		mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
-					       &tirc_default_config[tt], tirc, false);
-
-		err = mlx5e_create_tir(priv->mdev, tir, in);
+		mlx5e_tir_builder_build_rqt(builder, priv->mdev->mlx5e_res.hw_objs.td.tdn,
+					    indir_rqtn, inner_ft_support);
+		mlx5e_tir_builder_build_lro(builder, &lro_param);
+		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, false);
+
+		err = mlx5e_tir_init(&res->rss[tt].indir_tir, builder, priv->mdev, true);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "create indirect tirs failed, %d\n", err);
-			goto err_destroy_inner_tirs;
+			goto err_destroy_tirs;
 		}
+
+		mlx5e_tir_builder_clear(builder);
 	}
 
 	if (!inner_ttc || !mlx5e_tunnel_inner_ft_supported(priv->mdev))
 		goto out;
 
-	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++) {
-		memset(in, 0, inlen);
-		tir = &res->rss[i].inner_indir_tir;
-		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-		mlx5e_build_indir_tir_ctx_common(priv->mdev->mlx5e_res.hw_objs.td.tdn,
-						 priv->channels.params.tunneled_offload_en,
-						 indir_rqtn, tirc);
-		mlx5e_build_tir_ctx_lro(&lro_param, tirc);
-		mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params,
-					       &tirc_default_config[i], tirc, true);
-		err = mlx5e_create_tir(priv->mdev, tir, in);
+	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
+		mlx5e_tir_builder_build_rqt(builder, priv->mdev->mlx5e_res.hw_objs.td.tdn,
+					    indir_rqtn, inner_ft_support);
+		mlx5e_tir_builder_build_lro(builder, &lro_param);
+		mlx5e_update_rx_hash_fields(&rss_tt, tt, rss->rx_hash_fields[tt]);
+		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, true);
+
+		err = mlx5e_tir_init(&res->rss[tt].inner_indir_tir, builder, priv->mdev, true);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "create inner indirect tirs failed, %d\n", err);
 			goto err_destroy_inner_tirs;
 		}
+
+		mlx5e_tir_builder_clear(builder);
 	}
 
-out:
-	kvfree(in);
-
-	return 0;
+	goto out;
 
 err_destroy_inner_tirs:
-	for (i--; i >= 0; i--)
-		mlx5e_destroy_tir(priv->mdev, &res->rss[i].inner_indir_tir);
+	max_tt = tt;
+	for (tt = 0; tt < max_tt; tt++)
+		mlx5e_tir_destroy(&res->rss[tt].inner_indir_tir);
 
-	for (tt--; tt >= 0; tt--)
-		mlx5e_destroy_tir(priv->mdev, &res->rss[tt].indir_tir);
+	tt = MLX5E_NUM_INDIR_TIRS;
+err_destroy_tirs:
+	max_tt = tt;
+	for (tt = 0; tt < max_tt; tt++)
+		mlx5e_tir_destroy(&res->rss[tt].indir_tir);
 
-	kvfree(in);
+out:
+	mlx5e_tir_builder_free(builder);
 
 	return err;
 }
 
 static int mlx5e_create_direct_tir(struct mlx5e_priv *priv, struct mlx5e_tir *tir,
-				   struct mlx5e_rqt *rqt)
+				   struct mlx5e_tir_builder *builder, struct mlx5e_rqt *rqt)
 {
+	bool inner_ft_support = priv->channels.params.tunneled_offload_en;
 	struct mlx5e_lro_param lro_param;
-	void *tirc;
-	int inlen;
 	int err = 0;
-	u32 *in;
-
-	inlen = MLX5_ST_SZ_BYTES(create_tir_in);
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
 
-	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 	lro_param = mlx5e_get_lro_param(&priv->channels.params);
-	mlx5e_build_direct_tir_ctx(&lro_param,
-				   priv->mdev->mlx5e_res.hw_objs.td.tdn,
-				   priv->channels.params.tunneled_offload_en,
-				   mlx5e_rqt_get_rqtn(rqt), tirc);
-	err = mlx5e_create_tir(priv->mdev, tir, in);
+
+	mlx5e_tir_builder_build_rqt(builder, priv->mdev->mlx5e_res.hw_objs.td.tdn,
+				    mlx5e_rqt_get_rqtn(rqt), inner_ft_support);
+	mlx5e_tir_builder_build_lro(builder, &lro_param);
+	mlx5e_tir_builder_build_direct(builder);
+
+	err = mlx5e_tir_init(tir, builder, priv->mdev, true);
 	if (unlikely(err))
 		mlx5_core_warn(priv->mdev, "create tirs failed, %d\n", err);
 
-	kvfree(in);
+	mlx5e_tir_builder_clear(builder);
 
 	return err;
 }
 
 int mlx5e_create_direct_tirs(struct mlx5e_priv *priv)
 {
-	int err;
+	struct mlx5e_rx_res *res = priv->rx_res;
+	struct mlx5e_tir_builder *builder;
+	int err = 0;
 	int ix;
 
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
+		return -ENOMEM;
+
 	for (ix = 0; ix < priv->max_nch; ix++) {
-		err = mlx5e_create_direct_tir(priv, &priv->rx_res->channels[ix].direct_tir,
-					      &priv->rx_res->channels[ix].direct_rqt);
+		err = mlx5e_create_direct_tir(priv, &res->channels[ix].direct_tir,
+					      builder, &res->channels[ix].direct_rqt);
 		if (err)
 			goto err_destroy_tirs;
 	}
 
-	return 0;
+	goto out;
 
 err_destroy_tirs:
 	while (--ix >= 0)
-		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].direct_tir);
+		mlx5e_tir_destroy(&res->channels[ix].direct_tir);
+
+out:
+	mlx5e_tir_builder_free(builder);
 
 	return err;
 }
 
 static int mlx5e_create_xsk_tirs(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rx_res *res = priv->rx_res;
+	struct mlx5e_tir_builder *builder;
 	int err;
 	int ix;
 
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
+		return -ENOMEM;
+
 	for (ix = 0; ix < priv->max_nch; ix++) {
-		err = mlx5e_create_direct_tir(priv, &priv->rx_res->channels[ix].xsk_tir,
-					      &priv->rx_res->channels[ix].xsk_rqt);
+		err = mlx5e_create_direct_tir(priv, &res->channels[ix].xsk_tir,
+					      builder, &res->channels[ix].xsk_rqt);
 		if (err)
 			goto err_destroy_tirs;
 	}
 
-	return 0;
+	goto out;
 
 err_destroy_tirs:
 	while (--ix >= 0)
-		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].xsk_tir);
+		mlx5e_tir_destroy(&res->channels[ix].xsk_tir);
+
+out:
+	mlx5e_tir_builder_free(builder);
 
 	return err;
 }
@@ -3297,17 +3239,17 @@ static int mlx5e_create_xsk_tirs(struct mlx5e_priv *priv)
 void mlx5e_destroy_indirect_tirs(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rx_res *res = priv->rx_res;
-	int i;
+	enum mlx5e_traffic_types tt;
 
-	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
-		mlx5e_destroy_tir(priv->mdev, &res->rss[i].indir_tir);
+	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
+		mlx5e_tir_destroy(&res->rss[tt].indir_tir);
 
 	/* Verify inner tirs resources allocated */
 	if (!res->rss[0].inner_indir_tir.tirn)
 		return;
 
-	for (i = 0; i < MLX5E_NUM_INDIR_TIRS; i++)
-		mlx5e_destroy_tir(priv->mdev, &res->rss[i].inner_indir_tir);
+	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
+		mlx5e_tir_destroy(&res->rss[tt].inner_indir_tir);
 }
 
 void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv)
@@ -3315,7 +3257,7 @@ void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv)
 	unsigned int ix;
 
 	for (ix = 0; ix < priv->max_nch; ix++)
-		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].direct_tir);
+		mlx5e_tir_destroy(&priv->rx_res->channels[ix].direct_tir);
 }
 
 static void mlx5e_destroy_xsk_tirs(struct mlx5e_priv *priv)
@@ -3323,7 +3265,7 @@ static void mlx5e_destroy_xsk_tirs(struct mlx5e_priv *priv)
 	unsigned int ix;
 
 	for (ix = 0; ix < priv->max_nch; ix++)
-		mlx5e_destroy_tir(priv->mdev, &priv->rx_res->channels[ix].xsk_tir);
+		mlx5e_tir_destroy(&priv->rx_res->channels[ix].xsk_tir);
 }
 
 static int mlx5e_modify_channels_scatter_fcs(struct mlx5e_channels *chs, bool enable)
@@ -4931,6 +4873,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_tir_builder *tir_builder;
 	int err;
 
 	priv->rx_res = kvzalloc(sizeof(*priv->rx_res), GFP_KERNEL);
@@ -4976,7 +4919,14 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_xsk_tirs;
 
-	err = mlx5e_create_direct_tir(priv, &priv->rx_res->ptp.tir, &priv->rx_res->ptp.rqt);
+	tir_builder = mlx5e_tir_builder_alloc(false);
+	if (!tir_builder) {
+		err = -ENOMEM;
+		goto err_destroy_ptp_rqt;
+	}
+	err = mlx5e_create_direct_tir(priv, &priv->rx_res->ptp.tir, tir_builder,
+				      &priv->rx_res->ptp.rqt);
+	mlx5e_tir_builder_free(tir_builder);
 	if (err)
 		goto err_destroy_ptp_rqt;
 
@@ -5005,7 +4955,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_destroy_flow_steering:
 	mlx5e_destroy_flow_steering(priv);
 err_destroy_ptp_direct_tir:
-	mlx5e_destroy_tir(priv->mdev, &priv->rx_res->ptp.tir);
+	mlx5e_tir_destroy(&priv->rx_res->ptp.tir);
 err_destroy_ptp_rqt:
 	mlx5e_rqt_destroy(&priv->rx_res->ptp.rqt);
 err_destroy_xsk_tirs:
@@ -5034,7 +4984,7 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 	mlx5e_accel_cleanup_rx(priv);
 	mlx5e_tc_nic_cleanup(priv);
 	mlx5e_destroy_flow_steering(priv);
-	mlx5e_destroy_tir(priv->mdev, &priv->rx_res->ptp.tir);
+	mlx5e_tir_destroy(&priv->rx_res->ptp.tir);
 	mlx5e_rqt_destroy(&priv->rx_res->ptp.rqt);
 	mlx5e_destroy_xsk_tirs(priv);
 	mlx5e_destroy_xsk_rqts(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b4d58dd5c849..c5ab3e81d13e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -340,11 +340,11 @@ struct mlx5e_hairpin {
 	struct mlx5_core_dev *func_mdev;
 	struct mlx5e_priv *func_priv;
 	u32 tdn;
-	u32 tirn;
+	struct mlx5e_tir direct_tir;
 
 	int num_channels;
 	struct mlx5e_rqt indir_rqt;
-	u32 indir_tirn[MLX5E_NUM_INDIR_TIRS];
+	struct mlx5e_tir indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_ttc_table ttc;
 };
 
@@ -462,35 +462,35 @@ struct mlx5_core_dev *mlx5e_hairpin_get_mdev(struct net *net, int ifindex)
 
 static int mlx5e_hairpin_create_transport(struct mlx5e_hairpin *hp)
 {
-	u32 in[MLX5_ST_SZ_DW(create_tir_in)] = {};
-	void *tirc;
+	struct mlx5e_tir_builder *builder;
 	int err;
 
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
+		return -ENOMEM;
+
 	err = mlx5_core_alloc_transport_domain(hp->func_mdev, &hp->tdn);
 	if (err)
-		goto alloc_tdn_err;
-
-	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
-
-	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
-	MLX5_SET(tirc, tirc, inline_rqn, hp->pair->rqn[0]);
-	MLX5_SET(tirc, tirc, transport_domain, hp->tdn);
+		goto out;
 
-	err = mlx5_core_create_tir(hp->func_mdev, in, &hp->tirn);
+	mlx5e_tir_builder_build_inline(builder, hp->tdn, hp->pair->rqn[0]);
+	err = mlx5e_tir_init(&hp->direct_tir, builder, hp->func_mdev, false);
 	if (err)
 		goto create_tir_err;
 
-	return 0;
+out:
+	mlx5e_tir_builder_free(builder);
+	return err;
 
 create_tir_err:
 	mlx5_core_dealloc_transport_domain(hp->func_mdev, hp->tdn);
-alloc_tdn_err:
-	return err;
+
+	goto out;
 }
 
 static void mlx5e_hairpin_destroy_transport(struct mlx5e_hairpin *hp)
 {
-	mlx5_core_destroy_tir(hp->func_mdev, hp->tirn);
+	mlx5e_tir_destroy(&hp->direct_tir);
 	mlx5_core_dealloc_transport_domain(hp->func_mdev, hp->tdn);
 }
 
@@ -515,36 +515,52 @@ static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 
 static int mlx5e_hairpin_create_indirect_tirs(struct mlx5e_hairpin *hp)
 {
+	struct mlx5e_rss_params_traffic_type rss_tt;
 	struct mlx5e_priv *priv = hp->func_priv;
-	u32 in[MLX5_ST_SZ_DW(create_tir_in)];
-	int tt, i, err;
-	void *tirc;
+	struct mlx5e_rss_params_hash *rss_hash;
+	enum mlx5e_traffic_types tt, max_tt;
+	struct mlx5e_tir_builder *builder;
+	int err = 0;
+
+	builder = mlx5e_tir_builder_alloc(false);
+	if (!builder)
+		return -ENOMEM;
+
+	rss_hash = &priv->rx_res->rss_params.hash;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++) {
 		struct mlx5e_tirc_config ttconfig = mlx5e_tirc_get_default_config(tt);
 
-		memset(in, 0, MLX5_ST_SZ_BYTES(create_tir_in));
-		tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
+		rss_tt = (struct mlx5e_rss_params_traffic_type) {
+			.l3_prot_type = ttconfig.l3_prot_type,
+			.l4_prot_type = ttconfig.l4_prot_type,
+			.rx_hash_fields = ttconfig.rx_hash_fields,
+		};
 
-		MLX5_SET(tirc, tirc, transport_domain, hp->tdn);
-		MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_INDIRECT);
-		MLX5_SET(tirc, tirc, indirect_table, mlx5e_rqt_get_rqtn(&hp->indir_rqt));
-		mlx5e_build_indir_tir_ctx_hash(&priv->rx_res->rss_params, &ttconfig,
-					       tirc, false);
+		mlx5e_tir_builder_build_rqt(builder, hp->tdn,
+					    mlx5e_rqt_get_rqtn(&hp->indir_rqt),
+					    false);
+		mlx5e_tir_builder_build_rss(builder, rss_hash, &rss_tt, false);
 
-		err = mlx5_core_create_tir(hp->func_mdev, in,
-					   &hp->indir_tirn[tt]);
+		err = mlx5e_tir_init(&hp->indir_tir[tt], builder, hp->func_mdev, false);
 		if (err) {
 			mlx5_core_warn(hp->func_mdev, "create indirect tirs failed, %d\n", err);
 			goto err_destroy_tirs;
 		}
+
+		mlx5e_tir_builder_clear(builder);
 	}
-	return 0;
 
-err_destroy_tirs:
-	for (i = 0; i < tt; i++)
-		mlx5_core_destroy_tir(hp->func_mdev, hp->indir_tirn[i]);
+out:
+	mlx5e_tir_builder_free(builder);
 	return err;
+
+err_destroy_tirs:
+	max_tt = tt;
+	for (tt = 0; tt < max_tt; tt++)
+		mlx5e_tir_destroy(&hp->indir_tir[tt]);
+
+	goto out;
 }
 
 static void mlx5e_hairpin_destroy_indirect_tirs(struct mlx5e_hairpin *hp)
@@ -552,7 +568,7 @@ static void mlx5e_hairpin_destroy_indirect_tirs(struct mlx5e_hairpin *hp)
 	int tt;
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		mlx5_core_destroy_tir(hp->func_mdev, hp->indir_tirn[tt]);
+		mlx5e_tir_destroy(&hp->indir_tir[tt]);
 }
 
 static void mlx5e_hairpin_set_ttc_params(struct mlx5e_hairpin *hp,
@@ -563,10 +579,10 @@ static void mlx5e_hairpin_set_ttc_params(struct mlx5e_hairpin *hp,
 
 	memset(ttc_params, 0, sizeof(*ttc_params));
 
-	ttc_params->any_tt_tirn = hp->tirn;
+	ttc_params->any_tt_tirn = mlx5e_tir_get_tirn(&hp->direct_tir);
 
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params->indir_tirn[tt] = hp->indir_tirn[tt];
+		ttc_params->indir_tirn[tt] = mlx5e_tir_get_tirn(&hp->indir_tir[tt]);
 
 	ft_attr->max_fte = MLX5E_TTC_TABLE_SIZE;
 	ft_attr->level = MLX5E_TC_TTC_FT_LEVEL;
@@ -837,7 +853,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	}
 
 	netdev_dbg(priv->netdev, "add hairpin: tirn %x rqn %x peer %s sqn %x prio %d (log) data %d packets %d\n",
-		   hp->tirn, hp->pair->rqn[0],
+		   mlx5e_tir_get_tirn(&hp->direct_tir), hp->pair->rqn[0],
 		   dev_name(hp->pair->peer_mdev->device),
 		   hp->pair->sqn[0], match_prio, params.log_data_size, params.log_num_packets);
 
@@ -846,7 +862,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 		flow_flag_set(flow, HAIRPIN_RSS);
 		flow->attr->nic_attr->hairpin_ft = hpe->hp->ttc.ft.t;
 	} else {
-		flow->attr->nic_attr->hairpin_tirn = hpe->hp->tirn;
+		flow->attr->nic_attr->hairpin_tirn = mlx5e_tir_get_tirn(&hpe->hp->direct_tir);
 	}
 
 	flow->hpe = hpe;
-- 
2.31.1

