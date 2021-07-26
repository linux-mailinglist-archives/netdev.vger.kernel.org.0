Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA593D64F9
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhGZQSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241314AbhGZQPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1509960560;
        Mon, 26 Jul 2021 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318555;
        bh=jjnZCzvg/zgnQLSAgoRMXe6IROlCbg4fbpfbkjCr0sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzVOqsAftS3IfQjOMcy3kWHbrXyJYkfJycAR8k1qKEUnke+EDssZ6AtosCntWVAM9
         HB8XeU5OB3rOhax6qPz8Cyryt9YcetBbjQ0cWOsVE5VGyKM0ImdvTeC6kL6BWm1auO
         vW5747ZPKJl+uUsfUeqiVsiRwLIT+ClTiZxS3ZMnYqhRxU9STs2QOe9Q2sSfHvXIjS
         taImrnHBibmpvcbcVSDXbpIEmrMRIes4QJrd6F8axiaa4jzh0iUNWHKO5/4cEn0iwY
         vzJQGGaJvILWZzceXEwxcAeZvqH2uNbWMVxskjEvY3gP3AGbTlPql36MqHxVDEFgP+
         FLlCu82u7Pb4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/16] net/mlx5e: Convert RQT to a dedicated object
Date:   Mon, 26 Jul 2021 09:55:33 -0700
Message-Id: <20210726165544.389143-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Code related to RQT is now encapsulated into a dedicated object and put
into new files en/rqt.{c,h}. All usages are converted.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  27 +--
 .../net/ethernet/mellanox/mlx5/core/en/rqt.c  | 161 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/rqt.h  |  39 +++
 .../mellanox/mlx5/core/en/xsk/setup.c         |  18 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  31 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 223 +++++-------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  58 +----
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   6 +-
 10 files changed, 295 insertions(+), 276 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b5072a3a2585..e65fc3aa79f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -27,7 +27,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/ptp.o \
-		en/qos.o en/trap.o en/fs_tt_redirect.o
+		en/qos.o en/trap.o en/fs_tt_redirect.o en/rqt.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b1b51bbba054..4ecf77d5f808 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -58,6 +58,7 @@
 #include "en/qos.h"
 #include "lib/hv_vhca.h"
 #include "lib/clock.h"
+#include "en/rqt.h"
 
 extern const struct net_device_ops mlx5e_netdev_ops;
 struct page_pool;
@@ -139,8 +140,6 @@ struct page_pool;
 #define MLX5E_PARAMS_DEFAULT_MIN_RX_WQES                0x80
 #define MLX5E_PARAMS_DEFAULT_MIN_RX_WQES_MPW            0x2
 
-#define MLX5E_LOG_INDIR_RQT_SIZE       0x8
-#define MLX5E_INDIR_RQT_SIZE           BIT(MLX5E_LOG_INDIR_RQT_SIZE)
 #define MLX5E_MIN_NUM_CHANNELS         0x1
 #define MLX5E_MAX_NUM_CHANNELS         (MLX5E_INDIR_RQT_SIZE / 2)
 #define MLX5E_MAX_NUM_SQS              (MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC)
@@ -745,14 +744,10 @@ enum {
 	MLX5E_STATE_XDP_ACTIVE,
 };
 
-struct mlx5e_rqt {
-	u32              rqtn;
-	bool		 enabled;
-};
-
 struct mlx5e_tir {
 	u32		  tirn;
 	struct mlx5e_rqt  rqt;
+	bool              rqt_enabled;
 	struct list_head  list;
 };
 
@@ -762,7 +757,7 @@ enum {
 };
 
 struct mlx5e_rss_params {
-	u32	indirection_rqt[MLX5E_INDIR_RQT_SIZE];
+	struct mlx5e_rss_params_indir indir;
 	u32	rx_hash_fields[MLX5E_NUM_INDIR_TIRS];
 	u8	toeplitz_hash_key[40];
 	u8	hfunc;
@@ -838,6 +833,7 @@ struct mlx5e_priv {
 	struct mlx5e_channels      channels;
 	u32                        tisn[MLX5_MAX_PORTS][MLX5E_MAX_NUM_TC];
 	struct mlx5e_rqt           indir_rqt;
+	bool                       indir_rqt_enabled;
 	struct mlx5e_tir           indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_tir           inner_indir_tir[MLX5E_NUM_INDIR_TIRS];
 	struct mlx5e_tir           direct_tir[MLX5E_MAX_NUM_CHANNELS];
@@ -948,19 +944,6 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __always_unused __be16 proto,
 			   u16 vid);
 void mlx5e_timestamp_init(struct mlx5e_priv *priv);
 
-struct mlx5e_redirect_rqt_param {
-	bool is_rss;
-	union {
-		u32 rqn; /* Direct RQN (Non-RSS) */
-		struct {
-			u8 hfunc;
-			struct mlx5e_channels *channels;
-		} rss; /* RSS data */
-	};
-};
-
-int mlx5e_redirect_rqt(struct mlx5e_priv *priv, u32 rqtn, int sz,
-		       struct mlx5e_redirect_rqt_param rrp);
 void mlx5e_build_indir_tir_ctx_hash(struct mlx5e_rss_params *rss_params,
 				    const struct mlx5e_tirc_config *ttconfig,
 				    void *tirc, bool inner);
@@ -1093,7 +1076,6 @@ int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, in
 void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
 int mlx5e_create_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
 void mlx5e_destroy_direct_tirs(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, int n);
-void mlx5e_destroy_rqt(struct mlx5e_priv *priv, struct mlx5e_rqt *rqt);
 
 int mlx5e_create_tis(struct mlx5_core_dev *mdev, void *in, u32 *tisn);
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn);
@@ -1106,7 +1088,6 @@ int mlx5e_close(struct net_device *netdev);
 int mlx5e_open(struct net_device *netdev);
 
 void mlx5e_queue_update_stats(struct mlx5e_priv *priv);
-int mlx5e_bits_invert(unsigned long a, int size);
 
 int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv);
 int mlx5e_set_dev_port_mtu_ctx(struct mlx5e_priv *priv, void *context);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
new file mode 100644
index 000000000000..38d0e9dbd6bd
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#include "rqt.h"
+#include <linux/mlx5/transobj.h>
+
+static int mlx5e_rqt_init(struct mlx5e_rqt *rqt, struct mlx5_core_dev *mdev,
+			  u16 max_size, u32 *init_rqns, u16 init_size)
+{
+	void *rqtc;
+	int inlen;
+	int err;
+	u32 *in;
+	int i;
+
+	rqt->mdev = mdev;
+	rqt->size = max_size;
+
+	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + sizeof(u32) * init_size;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
+
+	MLX5_SET(rqtc, rqtc, rqt_max_size, rqt->size);
+
+	MLX5_SET(rqtc, rqtc, rqt_actual_size, init_size);
+	for (i = 0; i < init_size; i++)
+		MLX5_SET(rqtc, rqtc, rq_num[i], init_rqns[i]);
+
+	err = mlx5_core_create_rqt(rqt->mdev, in, inlen, &rqt->rqtn);
+
+	kvfree(in);
+	return err;
+}
+
+int mlx5e_rqt_init_direct(struct mlx5e_rqt *rqt, struct mlx5_core_dev *mdev,
+			  bool indir_enabled, u32 init_rqn)
+{
+	u16 max_size = indir_enabled ? MLX5E_INDIR_RQT_SIZE : 1;
+
+	return mlx5e_rqt_init(rqt, mdev, max_size, &init_rqn, 1);
+}
+
+static int mlx5e_bits_invert(unsigned long a, int size)
+{
+	int inv = 0;
+	int i;
+
+	for (i = 0; i < size; i++)
+		inv |= (test_bit(size - i - 1, &a) ? 1 : 0) << i;
+
+	return inv;
+}
+
+static int mlx5e_calc_indir_rqns(u32 *rss_rqns, u32 *rqns, unsigned int num_rqns,
+				 u8 hfunc, struct mlx5e_rss_params_indir *indir)
+{
+	unsigned int i;
+
+	for (i = 0; i < MLX5E_INDIR_RQT_SIZE; i++) {
+		unsigned int ix = i;
+
+		if (hfunc == ETH_RSS_HASH_XOR)
+			ix = mlx5e_bits_invert(ix, ilog2(MLX5E_INDIR_RQT_SIZE));
+
+		ix = indir->table[ix];
+
+		if (WARN_ON(ix >= num_rqns))
+			/* Could be a bug in the driver or in the kernel part of
+			 * ethtool: indir table refers to non-existent RQs.
+			 */
+			return -EINVAL;
+		rss_rqns[i] = rqns[ix];
+	}
+
+	return 0;
+}
+
+int mlx5e_rqt_init_indir(struct mlx5e_rqt *rqt, struct mlx5_core_dev *mdev,
+			 u32 *rqns, unsigned int num_rqns,
+			 u8 hfunc, struct mlx5e_rss_params_indir *indir)
+{
+	u32 *rss_rqns;
+	int err;
+
+	rss_rqns = kvmalloc_array(MLX5E_INDIR_RQT_SIZE, sizeof(*rss_rqns), GFP_KERNEL);
+	if (!rss_rqns)
+		return -ENOMEM;
+
+	err = mlx5e_calc_indir_rqns(rss_rqns, rqns, num_rqns, hfunc, indir);
+	if (err)
+		goto out;
+
+	err = mlx5e_rqt_init(rqt, mdev, MLX5E_INDIR_RQT_SIZE, rss_rqns, MLX5E_INDIR_RQT_SIZE);
+
+out:
+	kvfree(rss_rqns);
+	return err;
+}
+
+void mlx5e_rqt_destroy(struct mlx5e_rqt *rqt)
+{
+	mlx5_core_destroy_rqt(rqt->mdev, rqt->rqtn);
+}
+
+static int mlx5e_rqt_redirect(struct mlx5e_rqt *rqt, u32 *rqns, unsigned int size)
+{
+	unsigned int i;
+	void *rqtc;
+	int inlen;
+	u32 *in;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_rqt_in) + sizeof(u32) * size;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	rqtc = MLX5_ADDR_OF(modify_rqt_in, in, ctx);
+
+	MLX5_SET(modify_rqt_in, in, bitmask.rqn_list, 1);
+	MLX5_SET(rqtc, rqtc, rqt_actual_size, size);
+	for (i = 0; i < size; i++)
+		MLX5_SET(rqtc, rqtc, rq_num[i], rqns[i]);
+
+	err = mlx5_core_modify_rqt(rqt->mdev, rqt->rqtn, in, inlen);
+
+	kvfree(in);
+	return err;
+}
+
+int mlx5e_rqt_redirect_direct(struct mlx5e_rqt *rqt, u32 rqn)
+{
+	return mlx5e_rqt_redirect(rqt, &rqn, 1);
+}
+
+int mlx5e_rqt_redirect_indir(struct mlx5e_rqt *rqt, u32 *rqns, unsigned int num_rqns,
+			     u8 hfunc, struct mlx5e_rss_params_indir *indir)
+{
+	u32 *rss_rqns;
+	int err;
+
+	if (WARN_ON(rqt->size != MLX5E_INDIR_RQT_SIZE))
+		return -EINVAL;
+
+	rss_rqns = kvmalloc_array(MLX5E_INDIR_RQT_SIZE, sizeof(*rss_rqns), GFP_KERNEL);
+	if (!rss_rqns)
+		return -ENOMEM;
+
+	err = mlx5e_calc_indir_rqns(rss_rqns, rqns, num_rqns, hfunc, indir);
+	if (err)
+		goto out;
+
+	err = mlx5e_rqt_redirect(rqt, rss_rqns, MLX5E_INDIR_RQT_SIZE);
+
+out:
+	kvfree(rss_rqns);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h
new file mode 100644
index 000000000000..d2c76649efb0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_EN_RQT_H__
+#define __MLX5_EN_RQT_H__
+
+#include <linux/kernel.h>
+
+#define MLX5E_INDIR_RQT_SIZE (1 << 8)
+
+struct mlx5_core_dev;
+
+struct mlx5e_rss_params_indir {
+	u32 table[MLX5E_INDIR_RQT_SIZE];
+};
+
+struct mlx5e_rqt {
+	struct mlx5_core_dev *mdev;
+	u32 rqtn;
+	u16 size;
+};
+
+int mlx5e_rqt_init_direct(struct mlx5e_rqt *rqt, struct mlx5_core_dev *mdev,
+			  bool indir_enabled, u32 init_rqn);
+int mlx5e_rqt_init_indir(struct mlx5e_rqt *rqt, struct mlx5_core_dev *mdev,
+			 u32 *rqns, unsigned int num_rqns,
+			 u8 hfunc, struct mlx5e_rss_params_indir *indir);
+void mlx5e_rqt_destroy(struct mlx5e_rqt *rqt);
+
+static inline u32 mlx5e_rqt_get_rqtn(struct mlx5e_rqt *rqt)
+{
+	return rqt->rqtn;
+}
+
+int mlx5e_rqt_redirect_direct(struct mlx5e_rqt *rqt, u32 rqn);
+int mlx5e_rqt_redirect_indir(struct mlx5e_rqt *rqt, u32 *rqns, unsigned int num_rqns,
+			     u8 hfunc, struct mlx5e_rss_params_indir *indir);
+
+#endif /* __MLX5_EN_RQT_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index a8315f166696..0772dd324ae2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -184,28 +184,14 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 	/* TX queue is disabled on close. */
 }
 
-static int mlx5e_redirect_xsk_rqt(struct mlx5e_priv *priv, u16 ix, u32 rqn)
-{
-	struct mlx5e_redirect_rqt_param direct_rrp = {
-		.is_rss = false,
-		{
-			.rqn = rqn,
-		},
-	};
-
-	u32 rqtn = priv->xsk_tir[ix].rqt.rqtn;
-
-	return mlx5e_redirect_rqt(priv, rqtn, 1, direct_rrp);
-}
-
 int mlx5e_xsk_redirect_rqt_to_channel(struct mlx5e_priv *priv, struct mlx5e_channel *c)
 {
-	return mlx5e_redirect_xsk_rqt(priv, c->ix, c->xskrq.rqn);
+	return mlx5e_rqt_redirect_direct(&priv->xsk_tir[c->ix].rqt, c->xskrq.rqn);
 }
 
 int mlx5e_xsk_redirect_rqt_to_drop(struct mlx5e_priv *priv, u16 ix)
 {
-	return mlx5e_redirect_xsk_rqt(priv, ix, priv->drop_rq.rqn);
+	return mlx5e_rqt_redirect_direct(&priv->xsk_tir[ix].rqt, priv->drop_rq.rqn);
 }
 
 int mlx5e_xsk_redirect_rqts_to_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index bd72572e03d1..c1f42eade842 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1201,8 +1201,7 @@ int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	struct mlx5e_rss_params *rss = &priv->rss_params;
 
 	if (indir)
-		memcpy(indir, rss->indirection_rqt,
-		       sizeof(rss->indirection_rqt));
+		memcpy(indir, rss->indir.table, sizeof(rss->indir.table));
 
 	if (key)
 		memcpy(key, rss->toeplitz_hash_key,
@@ -1242,8 +1241,7 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 	}
 
 	if (indir) {
-		memcpy(rss->indirection_rqt, indir,
-		       sizeof(rss->indirection_rqt));
+		memcpy(rss->indir.table, indir, sizeof(rss->indir.table));
 		refresh_rqt = true;
 	}
 
@@ -1254,18 +1252,19 @@ int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir,
 	}
 
 	if (refresh_rqt && test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		struct mlx5e_redirect_rqt_param rrp = {
-			.is_rss = true,
-			{
-				.rss = {
-					.hfunc = rss->hfunc,
-					.channels  = &priv->channels,
-				},
-			},
-		};
-		u32 rqtn = priv->indir_rqt.rqtn;
-
-		mlx5e_redirect_rqt(priv, rqtn, MLX5E_INDIR_RQT_SIZE, rrp);
+		u32 *rqns;
+
+		rqns = kvmalloc_array(priv->channels.num, sizeof(*rqns), GFP_KERNEL);
+		if (rqns) {
+			unsigned int ix;
+
+			for (ix = 0; ix < priv->channels.num; ix++)
+				rqns[ix] = priv->channels.c[ix]->rq.rqn;
+
+			mlx5e_rqt_redirect_indir(&priv->indir_rqt, rqns, priv->channels.num,
+						 rss->hfunc, &rss->indir);
+			kvfree(rqns);
+		}
 	}
 
 	if (refresh_tirs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b651134b0f6b..ccc78cafbbb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2194,51 +2194,15 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 	chs->num = 0;
 }
 
-static int
-mlx5e_create_rqt(struct mlx5e_priv *priv, int sz, struct mlx5e_rqt *rqt)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	void *rqtc;
-	int inlen;
-	int err;
-	u32 *in;
-	int i;
-
-	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + sizeof(u32) * sz;
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
-
-	MLX5_SET(rqtc, rqtc, rqt_actual_size, sz);
-	MLX5_SET(rqtc, rqtc, rqt_max_size, sz);
-
-	for (i = 0; i < sz; i++)
-		MLX5_SET(rqtc, rqtc, rq_num[i], priv->drop_rq.rqn);
-
-	err = mlx5_core_create_rqt(mdev, in, inlen, &rqt->rqtn);
-	if (!err)
-		rqt->enabled = true;
-
-	kvfree(in);
-	return err;
-}
-
-void mlx5e_destroy_rqt(struct mlx5e_priv *priv, struct mlx5e_rqt *rqt)
-{
-	rqt->enabled = false;
-	mlx5_core_destroy_rqt(priv->mdev, rqt->rqtn);
-}
-
 int mlx5e_create_indirect_rqt(struct mlx5e_priv *priv)
 {
-	struct mlx5e_rqt *rqt = &priv->indir_rqt;
 	int err;
 
-	err = mlx5e_create_rqt(priv, MLX5E_INDIR_RQT_SIZE, rqt);
+	err = mlx5e_rqt_init_direct(&priv->indir_rqt, priv->mdev, true, priv->drop_rq.rqn);
 	if (err)
 		mlx5_core_warn(priv->mdev, "create indirect rqts failed, %d\n", err);
+	else
+		priv->indir_rqt_enabled = true;
 	return err;
 }
 
@@ -2248,17 +2212,21 @@ int mlx5e_create_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs, in
 	int ix;
 
 	for (ix = 0; ix < n; ix++) {
-		err = mlx5e_create_rqt(priv, 1 /*size */, &tirs[ix].rqt);
+		err = mlx5e_rqt_init_direct(&tirs[ix].rqt, priv->mdev, false,
+					    priv->drop_rq.rqn);
 		if (unlikely(err))
 			goto err_destroy_rqts;
+		tirs[ix].rqt_enabled = true;
 	}
 
 	return 0;
 
 err_destroy_rqts:
 	mlx5_core_warn(priv->mdev, "create rqts failed, %d\n", err);
-	for (ix--; ix >= 0; ix--)
-		mlx5e_destroy_rqt(priv, &tirs[ix].rqt);
+	for (ix--; ix >= 0; ix--) {
+		tirs[ix].rqt_enabled = false;
+		mlx5e_rqt_destroy(&tirs[ix].rqt);
+	}
 
 	return err;
 }
@@ -2267,8 +2235,10 @@ void mlx5e_destroy_direct_rqts(struct mlx5e_priv *priv, struct mlx5e_tir *tirs,
 {
 	int i;
 
-	for (i = 0; i < n; i++)
-		mlx5e_destroy_rqt(priv, &tirs[i].rqt);
+	for (i = 0; i < n; i++) {
+		tirs[i].rqt_enabled = false;
+		mlx5e_rqt_destroy(&tirs[i].rqt);
+	}
 }
 
 static int mlx5e_rx_hash_fn(int hfunc)
@@ -2278,149 +2248,64 @@ static int mlx5e_rx_hash_fn(int hfunc)
 	       MLX5_RX_HASH_FN_INVERTED_XOR8;
 }
 
-int mlx5e_bits_invert(unsigned long a, int size)
-{
-	int inv = 0;
-	int i;
-
-	for (i = 0; i < size; i++)
-		inv |= (test_bit(size - i - 1, &a) ? 1 : 0) << i;
-
-	return inv;
-}
-
-static void mlx5e_fill_rqt_rqns(struct mlx5e_priv *priv, int sz,
-				struct mlx5e_redirect_rqt_param rrp, void *rqtc)
+static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
+					    struct mlx5e_channels *chs)
 {
-	int i;
-
-	for (i = 0; i < sz; i++) {
-		u32 rqn;
+	unsigned int ix;
 
-		if (rrp.is_rss) {
-			int ix = i;
+	if (priv->indir_rqt_enabled) {
+		u32 *rqns;
 
-			if (rrp.rss.hfunc == ETH_RSS_HASH_XOR)
-				ix = mlx5e_bits_invert(i, ilog2(sz));
+		rqns = kvmalloc_array(chs->num, sizeof(*rqns), GFP_KERNEL);
+		if (rqns) {
+			for (ix = 0; ix < chs->num; ix++)
+				rqns[ix] = chs->c[ix]->rq.rqn;
 
-			ix = priv->rss_params.indirection_rqt[ix];
-			rqn = rrp.rss.channels->c[ix]->rq.rqn;
-		} else {
-			rqn = rrp.rqn;
+			mlx5e_rqt_redirect_indir(&priv->indir_rqt, rqns, chs->num,
+						 priv->rss_params.hfunc,
+						 &priv->rss_params.indir);
+			kvfree(rqns);
 		}
-		MLX5_SET(rqtc, rqtc, rq_num[i], rqn);
 	}
-}
-
-int mlx5e_redirect_rqt(struct mlx5e_priv *priv, u32 rqtn, int sz,
-		       struct mlx5e_redirect_rqt_param rrp)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	void *rqtc;
-	int inlen;
-	u32 *in;
-	int err;
 
-	inlen = MLX5_ST_SZ_BYTES(modify_rqt_in) + sizeof(u32) * sz;
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
+	for (ix = 0; ix < priv->max_nch; ix++) {
+		u32 rqn = priv->drop_rq.rqn;
 
-	rqtc = MLX5_ADDR_OF(modify_rqt_in, in, ctx);
+		if (!priv->direct_tir[ix].rqt_enabled)
+			continue;
 
-	MLX5_SET(rqtc, rqtc, rqt_actual_size, sz);
-	MLX5_SET(modify_rqt_in, in, bitmask.rqn_list, 1);
-	mlx5e_fill_rqt_rqns(priv, sz, rrp, rqtc);
-	err = mlx5_core_modify_rqt(mdev, rqtn, in, inlen);
+		if (ix < chs->num)
+			rqn = chs->c[ix]->rq.rqn;
 
-	kvfree(in);
-	return err;
-}
+		mlx5e_rqt_redirect_direct(&priv->direct_tir[ix].rqt, rqn);
+	}
 
-static u32 mlx5e_get_direct_rqn(struct mlx5e_priv *priv, int ix,
-				struct mlx5e_redirect_rqt_param rrp)
-{
-	if (!rrp.is_rss)
-		return rrp.rqn;
+	if (priv->profile->rx_ptp_support) {
+		u32 rqn;
 
-	if (ix >= rrp.rss.channels->num)
-		return priv->drop_rq.rqn;
+		if (mlx5e_ptp_get_rqn(priv->channels.ptp, &rqn))
+			rqn = priv->drop_rq.rqn;
 
-	return rrp.rss.channels->c[ix]->rq.rqn;
+		mlx5e_rqt_redirect_direct(&priv->ptp_tir.rqt, rqn);
+	}
 }
 
-static void mlx5e_redirect_rqts(struct mlx5e_priv *priv,
-				struct mlx5e_redirect_rqt_param rrp,
-				struct mlx5e_redirect_rqt_param *ptp_rrp)
+static void mlx5e_redirect_rqts_to_drop(struct mlx5e_priv *priv)
 {
-	u32 rqtn;
-	int ix;
+	unsigned int ix;
 
-	if (priv->indir_rqt.enabled) {
-		/* RSS RQ table */
-		rqtn = priv->indir_rqt.rqtn;
-		mlx5e_redirect_rqt(priv, rqtn, MLX5E_INDIR_RQT_SIZE, rrp);
-	}
+	if (priv->indir_rqt_enabled)
+		mlx5e_rqt_redirect_direct(&priv->indir_rqt, priv->drop_rq.rqn);
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
-		struct mlx5e_redirect_rqt_param direct_rrp = {
-			.is_rss = false,
-			{
-				.rqn    = mlx5e_get_direct_rqn(priv, ix, rrp)
-			},
-		};
-
-		/* Direct RQ Tables */
-		if (!priv->direct_tir[ix].rqt.enabled)
+		if (!priv->direct_tir[ix].rqt_enabled)
 			continue;
 
-		rqtn = priv->direct_tir[ix].rqt.rqtn;
-		mlx5e_redirect_rqt(priv, rqtn, 1, direct_rrp);
+		mlx5e_rqt_redirect_direct(&priv->direct_tir[ix].rqt, priv->drop_rq.rqn);
 	}
-	if (ptp_rrp) {
-		rqtn = priv->ptp_tir.rqt.rqtn;
-		mlx5e_redirect_rqt(priv, rqtn, 1, *ptp_rrp);
-	}
-}
-
-static void mlx5e_redirect_rqts_to_channels(struct mlx5e_priv *priv,
-					    struct mlx5e_channels *chs)
-{
-	bool rx_ptp_support = priv->profile->rx_ptp_support;
-	struct mlx5e_redirect_rqt_param *ptp_rrp_p = NULL;
-	struct mlx5e_redirect_rqt_param rrp = {
-		.is_rss        = true,
-		{
-			.rss = {
-				.channels  = chs,
-				.hfunc     = priv->rss_params.hfunc,
-			}
-		},
-	};
-	struct mlx5e_redirect_rqt_param ptp_rrp;
-
-	if (rx_ptp_support) {
-		u32 ptp_rqn;
-
-		ptp_rrp.is_rss = false;
-		ptp_rrp.rqn = mlx5e_ptp_get_rqn(priv->channels.ptp, &ptp_rqn) ?
-			      priv->drop_rq.rqn : ptp_rqn;
-		ptp_rrp_p = &ptp_rrp;
-	}
-	mlx5e_redirect_rqts(priv, rrp, ptp_rrp_p);
-}
-
-static void mlx5e_redirect_rqts_to_drop(struct mlx5e_priv *priv)
-{
-	bool rx_ptp_support = priv->profile->rx_ptp_support;
-	struct mlx5e_redirect_rqt_param drop_rrp = {
-		.is_rss = false,
-		{
-			.rqn = priv->drop_rq.rqn,
-		},
-	};
 
-	mlx5e_redirect_rqts(priv, drop_rrp, rx_ptp_support ? &drop_rrp : NULL);
+	if (priv->profile->rx_ptp_support)
+		mlx5e_rqt_redirect_direct(&priv->ptp_tir.rqt, priv->drop_rq.rqn);
 }
 
 static const struct mlx5e_tirc_config tirc_default_config[MLX5E_NUM_INDIR_TIRS] = {
@@ -2777,7 +2662,7 @@ int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
 	mlx5e_set_default_xps_cpumasks(priv, &priv->channels.params);
 
 	if (!netif_is_rxfh_configured(priv->netdev))
-		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
+		mlx5e_build_default_indir_rqt(priv->rss_params.indir.table,
 					      MLX5E_INDIR_RQT_SIZE, count);
 
 	return 0;
@@ -4644,7 +4529,7 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 	rss_params->hfunc = ETH_RSS_HASH_TOP;
 	netdev_rss_key_fill(rss_params->toeplitz_hash_key,
 			    sizeof(rss_params->toeplitz_hash_key));
-	mlx5e_build_default_indir_rqt(rss_params->indirection_rqt,
+	mlx5e_build_default_indir_rqt(rss_params->indir.table,
 				      MLX5E_INDIR_RQT_SIZE, num_channels);
 	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 		rss_params->rx_hash_fields[tt] =
@@ -5067,7 +4952,8 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_rqts:
-	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
+	priv->indir_rqt_enabled = false;
+	mlx5e_rqt_destroy(&priv->indir_rqt);
 err_close_drop_rq:
 	mlx5e_close_drop_rq(&priv->drop_rq);
 err_destroy_q_counters:
@@ -5089,7 +4975,8 @@ static void mlx5e_cleanup_nic_rx(struct mlx5e_priv *priv)
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
-	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
+	priv->indir_rqt_enabled = false;
+	mlx5e_rqt_destroy(&priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index bf94bcb6fa5d..e998422405aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -814,7 +814,8 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_rqts:
-	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
+	priv->indir_rqt_enabled = false;
+	mlx5e_rqt_destroy(&priv->indir_rqt);
 err_close_drop_rq:
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	return err;
@@ -831,7 +832,8 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
-	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
+	priv->indir_rqt_enabled = false;
+	mlx5e_rqt_destroy(&priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 629a61e8022f..859f892603e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -494,60 +494,22 @@ static void mlx5e_hairpin_destroy_transport(struct mlx5e_hairpin *hp)
 	mlx5_core_dealloc_transport_domain(hp->func_mdev, hp->tdn);
 }
 
-static int mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp, void *rqtc)
-{
-	struct mlx5e_priv *priv = hp->func_priv;
-	int i, ix, sz = MLX5E_INDIR_RQT_SIZE;
-	u32 *indirection_rqt, rqn;
-
-	indirection_rqt = kcalloc(sz, sizeof(*indirection_rqt), GFP_KERNEL);
-	if (!indirection_rqt)
-		return -ENOMEM;
-
-	mlx5e_build_default_indir_rqt(indirection_rqt, sz,
-				      hp->num_channels);
-
-	for (i = 0; i < sz; i++) {
-		ix = i;
-		if (priv->rss_params.hfunc == ETH_RSS_HASH_XOR)
-			ix = mlx5e_bits_invert(i, ilog2(sz));
-		ix = indirection_rqt[ix];
-		rqn = hp->pair->rqn[ix];
-		MLX5_SET(rqtc, rqtc, rq_num[i], rqn);
-	}
-
-	kfree(indirection_rqt);
-	return 0;
-}
-
 static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
 {
-	int inlen, err, sz = MLX5E_INDIR_RQT_SIZE;
 	struct mlx5e_priv *priv = hp->func_priv;
 	struct mlx5_core_dev *mdev = priv->mdev;
-	void *rqtc;
-	u32 *in;
+	struct mlx5e_rss_params_indir *indir;
+	int err;
 
-	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + sizeof(u32) * sz;
-	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in)
+	indir = kvmalloc(sizeof(*indir), GFP_KERNEL);
+	if (!indir)
 		return -ENOMEM;
 
-	rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
+	mlx5e_build_default_indir_rqt(indir->table, MLX5E_INDIR_RQT_SIZE, hp->num_channels);
+	err = mlx5e_rqt_init_indir(&hp->indir_rqt, mdev, hp->pair->rqn, hp->num_channels,
+				   priv->rss_params.hfunc, indir);
 
-	MLX5_SET(rqtc, rqtc, rqt_actual_size, sz);
-	MLX5_SET(rqtc, rqtc, rqt_max_size, sz);
-
-	err = mlx5e_hairpin_fill_rqt_rqns(hp, rqtc);
-	if (err)
-		goto out;
-
-	err = mlx5_core_create_rqt(mdev, in, inlen, &hp->indir_rqt.rqtn);
-	if (!err)
-		hp->indir_rqt.enabled = true;
-
-out:
-	kvfree(in);
+	kvfree(indir);
 	return err;
 }
 
@@ -637,7 +599,7 @@ static int mlx5e_hairpin_rss_init(struct mlx5e_hairpin *hp)
 err_create_ttc_table:
 	mlx5e_hairpin_destroy_indirect_tirs(hp);
 err_create_indirect_tirs:
-	mlx5e_destroy_rqt(priv, &hp->indir_rqt);
+	mlx5e_rqt_destroy(&hp->indir_rqt);
 
 	return err;
 }
@@ -648,7 +610,7 @@ static void mlx5e_hairpin_rss_cleanup(struct mlx5e_hairpin *hp)
 
 	mlx5e_destroy_ttc_table(priv, &hp->ttc);
 	mlx5e_hairpin_destroy_indirect_tirs(hp);
-	mlx5e_destroy_rqt(priv, &hp->indir_rqt);
+	mlx5e_rqt_destroy(&hp->indir_rqt);
 }
 
 static struct mlx5e_hairpin *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 620d638e1e8f..1c865458e5c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -399,7 +399,8 @@ static int mlx5i_init_rx(struct mlx5e_priv *priv)
 err_destroy_direct_rqts:
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
 err_destroy_indirect_rqts:
-	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
+	priv->indir_rqt_enabled = false;
+	mlx5e_rqt_destroy(&priv->indir_rqt);
 err_close_drop_rq:
 	mlx5e_close_drop_rq(&priv->drop_rq);
 err_destroy_q_counters:
@@ -415,7 +416,8 @@ static void mlx5i_cleanup_rx(struct mlx5e_priv *priv)
 	mlx5e_destroy_direct_tirs(priv, priv->direct_tir, max_nch);
 	mlx5e_destroy_indirect_tirs(priv);
 	mlx5e_destroy_direct_rqts(priv, priv->direct_tir, max_nch);
-	mlx5e_destroy_rqt(priv, &priv->indir_rqt);
+	priv->indir_rqt_enabled = false;
+	mlx5e_rqt_destroy(&priv->indir_rqt);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_destroy_q_counters(priv);
 }
-- 
2.31.1

