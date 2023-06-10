Return-Path: <netdev+bounces-9766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC1F72A7AA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6BCC281A34
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230285393;
	Sat, 10 Jun 2023 01:43:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D044C98
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42983C4339C;
	Sat, 10 Jun 2023 01:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361390;
	bh=Vx2Q9FClR2dwFkGJmYb+tgLKggTImD5E6x5euLvUJ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYi1TgXiG70idawO/iXTddgAniygTnCa6qkuW6WJ2A5gzqCzjdh1EBi/a11Du4QK0
	 NB032kZhpv89cdtnjnLsg00WE7u0oeC4Gv3hZ6PRR5G+Wd2IRsp8I4PnQ6UJzBqw2q
	 XrLQ0gtDGWC5Ky2dTSCT2+gvFXeAkAZQuPiTeVUyQ1CMfOY8hf3/JlC+CE0VdFHTXo
	 pCQLoAyZGuRk2iYRdvctKUgcUqfibRw19o8A49V7szBv9YSmFfBKeGbDMdjc4Ne5Vy
	 V8AOMMnaH8OHuQqe6+tPxfj40uXdTkNT8WsJCgXiLvDIHgsKTYF+ubhMT6kBCdJfS/
	 LwL2iNlPBsZZw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Add management of EC VF vports
Date: Fri,  9 Jun 2023 18:42:44 -0700
Message-Id: <20230610014254.343576-6-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

Add init, load, unload, and cleanup of the EC VF vports. This includes
changes in how eswitch SRIOV is managed. Previous on an embedded CPU
platform the number of VFs provided when enabling the eswitch was always
0, host VFs vports are handled in the eswitch functions change event
handler. Now track the number of EC VFs as well, so they can be handled
properly in the enable/disable flows.

There are only 3 marks available for use in xarrays, all 3 were already
in use for this use case. EC VF vports are in a known range so we can
access them by index instead of marks.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 125 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  13 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  22 +++
 3 files changed, 143 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ecd8864d5d11..b33d852aae34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1051,6 +1051,18 @@ static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
 	}
 }
 
+static void mlx5_eswitch_clear_ec_vf_vports_info(struct mlx5_eswitch *esw)
+{
+	struct mlx5_vport *vport;
+	unsigned long i;
+
+	mlx5_esw_for_each_ec_vf_vport(esw, i, vport, esw->esw_funcs.num_ec_vfs) {
+		memset(&vport->qos, 0, sizeof(vport->qos));
+		memset(&vport->info, 0, sizeof(vport->info));
+		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_AUTO;
+	}
+}
+
 /* Public E-Switch API */
 int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 			    enum mlx5_eswitch_vport_event enabled_events)
@@ -1090,6 +1102,19 @@ void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs)
 	}
 }
 
+static void mlx5_eswitch_unload_ec_vf_vports(struct mlx5_eswitch *esw,
+					     u16 num_ec_vfs)
+{
+	struct mlx5_vport *vport;
+	unsigned long i;
+
+	mlx5_esw_for_each_ec_vf_vport(esw, i, vport, num_ec_vfs) {
+		if (!vport->enabled)
+			continue;
+		mlx5_eswitch_unload_vport(esw, vport->vport);
+	}
+}
+
 int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
 				enum mlx5_eswitch_vport_event enabled_events)
 {
@@ -1110,6 +1135,26 @@ int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs,
 	return err;
 }
 
+static int mlx5_eswitch_load_ec_vf_vports(struct mlx5_eswitch *esw, u16 num_ec_vfs,
+					  enum mlx5_eswitch_vport_event enabled_events)
+{
+	struct mlx5_vport *vport;
+	unsigned long i;
+	int err;
+
+	mlx5_esw_for_each_ec_vf_vport(esw, i, vport, num_ec_vfs) {
+		err = mlx5_eswitch_load_vport(esw, vport->vport, enabled_events);
+		if (err)
+			goto vf_err;
+	}
+
+	return 0;
+
+vf_err:
+	mlx5_eswitch_unload_ec_vf_vports(esw, num_ec_vfs);
+	return err;
+}
+
 static int host_pf_enable_hca(struct mlx5_core_dev *dev)
 {
 	if (!mlx5_core_is_ecpf(dev))
@@ -1154,6 +1199,12 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 		ret = mlx5_eswitch_load_vport(esw, MLX5_VPORT_ECPF, enabled_events);
 		if (ret)
 			goto ecpf_err;
+		if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+			ret = mlx5_eswitch_load_ec_vf_vports(esw, esw->esw_funcs.num_ec_vfs,
+							     enabled_events);
+			if (ret)
+				goto ec_vf_err;
+		}
 	}
 
 	/* Enable VF vports */
@@ -1164,6 +1215,9 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 	return 0;
 
 vf_err:
+	if (mlx5_core_ec_sriov_enabled(esw->dev))
+		mlx5_eswitch_unload_ec_vf_vports(esw, esw->esw_funcs.num_ec_vfs);
+ec_vf_err:
 	if (mlx5_ecpf_vport_exists(esw->dev))
 		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
 ecpf_err:
@@ -1180,8 +1234,11 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw)
 {
 	mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
 
-	if (mlx5_ecpf_vport_exists(esw->dev))
+	if (mlx5_ecpf_vport_exists(esw->dev)) {
+		if (mlx5_core_ec_sriov_enabled(esw->dev))
+			mlx5_eswitch_unload_ec_vf_vports(esw, esw->esw_funcs.num_vfs);
 		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
+	}
 
 	host_pf_disable_hca(esw->dev);
 	mlx5_eswitch_unload_vport(esw, MLX5_VPORT_PF);
@@ -1225,6 +1282,9 @@ mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, int num_vfs)
 
 	esw->esw_funcs.num_vfs = MLX5_GET(query_esw_functions_out, out,
 					  host_params_context.host_num_of_vfs);
+	if (mlx5_core_ec_sriov_enabled(esw->dev))
+		esw->esw_funcs.num_ec_vfs = num_vfs;
+
 	kvfree(out);
 }
 
@@ -1332,9 +1392,9 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs)
 
 	mlx5_eswitch_event_handlers_register(esw);
 
-	esw_info(esw->dev, "Enable: mode(%s), nvfs(%d), active vports(%d)\n",
+	esw_info(esw->dev, "Enable: mode(%s), nvfs(%d), necvfs(%d), active vports(%d)\n",
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
-		 esw->esw_funcs.num_vfs, esw->enabled_vports);
+		 esw->esw_funcs.num_vfs, esw->esw_funcs.num_ec_vfs, esw->enabled_vports);
 
 	mlx5_esw_mode_change_notify(esw, esw->mode);
 
@@ -1356,7 +1416,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs)
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 {
 	bool toggle_lag;
-	int ret;
+	int ret = 0;
 
 	if (!mlx5_esw_allowed(esw))
 		return 0;
@@ -1376,10 +1436,21 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 
 		vport_events = (esw->mode == MLX5_ESWITCH_LEGACY) ?
 					MLX5_LEGACY_SRIOV_VPORT_EVENTS : MLX5_VPORT_UC_ADDR_CHANGE;
-		ret = mlx5_eswitch_load_vf_vports(esw, num_vfs, vport_events);
-		if (!ret)
-			esw->esw_funcs.num_vfs = num_vfs;
+		/* If this is the ECPF the number of host VFs is managed via the
+		 * eswitch function change event handler, and any num_vfs provided
+		 * here are intended to be EC VFs.
+		 */
+		if (!mlx5_core_is_ecpf(esw->dev)) {
+			ret = mlx5_eswitch_load_vf_vports(esw, num_vfs, vport_events);
+			if (!ret)
+				esw->esw_funcs.num_vfs = num_vfs;
+		} else if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+			ret = mlx5_eswitch_load_ec_vf_vports(esw, num_vfs, vport_events);
+			if (!ret)
+				esw->esw_funcs.num_ec_vfs = num_vfs;
+		}
 	}
+
 	up_write(&esw->mode_lock);
 
 	if (toggle_lag)
@@ -1399,16 +1470,22 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 	/* If driver is unloaded, this function is called twice by remove_one()
 	 * and mlx5_unload(). Prevent the second call.
 	 */
-	if (!esw->esw_funcs.num_vfs && !clear_vf)
+	if (!esw->esw_funcs.num_vfs && !esw->esw_funcs.num_ec_vfs && !clear_vf)
 		goto unlock;
 
-	esw_info(esw->dev, "Unload vfs: mode(%s), nvfs(%d), active vports(%d)\n",
+	esw_info(esw->dev, "Unload vfs: mode(%s), nvfs(%d), necvfs(%d), active vports(%d)\n",
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
-		 esw->esw_funcs.num_vfs, esw->enabled_vports);
-
-	mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
-	if (clear_vf)
-		mlx5_eswitch_clear_vf_vports_info(esw);
+		 esw->esw_funcs.num_vfs, esw->esw_funcs.num_ec_vfs, esw->enabled_vports);
+
+	if (!mlx5_core_is_ecpf(esw->dev)) {
+		mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
+		if (clear_vf)
+			mlx5_eswitch_clear_vf_vports_info(esw);
+	} else if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+		mlx5_eswitch_unload_ec_vf_vports(esw, esw->esw_funcs.num_ec_vfs);
+		if (clear_vf)
+			mlx5_eswitch_clear_ec_vf_vports_info(esw);
+	}
 
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS) {
 		struct devlink *devlink = priv_to_devlink(esw->dev);
@@ -1419,7 +1496,10 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 	if (esw->mode == MLX5_ESWITCH_LEGACY)
 		mlx5_eswitch_disable_locked(esw);
 
-	esw->esw_funcs.num_vfs = 0;
+	if (!mlx5_core_is_ecpf(esw->dev))
+		esw->esw_funcs.num_vfs = 0;
+	else
+		esw->esw_funcs.num_ec_vfs = 0;
 
 unlock:
 	up_write(&esw->mode_lock);
@@ -1439,9 +1519,9 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw)
 
 	mlx5_eswitch_event_handlers_unregister(esw);
 
-	esw_info(esw->dev, "Disable: mode(%s), nvfs(%d), active vports(%d)\n",
+	esw_info(esw->dev, "Disable: mode(%s), nvfs(%d), necvfs(%d), active vports(%d)\n",
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
-		 esw->esw_funcs.num_vfs, esw->enabled_vports);
+		 esw->esw_funcs.num_vfs, esw->esw_funcs.num_ec_vfs, esw->enabled_vports);
 
 	if (esw->fdb_table.flags & MLX5_ESW_FDB_CREATED) {
 		esw->fdb_table.flags &= ~MLX5_ESW_FDB_CREATED;
@@ -1601,6 +1681,17 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 		idx++;
 	}
 
+	if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+		int ec_vf_base_num = mlx5_core_ec_vf_vport_base(dev);
+
+		for (i = 0; i < mlx5_core_max_ec_vfs(esw->dev); i++) {
+			err = mlx5_esw_vport_alloc(esw, idx, ec_vf_base_num + i);
+			if (err)
+				goto err;
+			idx++;
+		}
+	}
+
 	if (mlx5_ecpf_vport_exists(dev) ||
 	    mlx5_core_is_ecpf_esw_manager(dev)) {
 		err = mlx5_esw_vport_alloc(esw, idx, MLX5_VPORT_ECPF);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d3608f198e0a..266b60fefe25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -289,6 +289,7 @@ struct mlx5_host_work {
 struct mlx5_esw_functions {
 	struct mlx5_nb		nb;
 	u16			num_vfs;
+	u16			num_ec_vfs;
 };
 
 enum {
@@ -654,6 +655,18 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 #define mlx5_esw_for_each_host_func_vport(esw, index, vport, last)	\
 	mlx5_esw_for_each_vport_marked(esw, index, vport, last, MLX5_ESW_VPT_HOST_FN)
 
+/* This macro should only be used if EC SRIOV is enabled.
+ *
+ * Because there were no more marks available on the xarray this uses a
+ * for_each_range approach. The range is only valid when EC SRIOV is enabled
+ */
+#define mlx5_esw_for_each_ec_vf_vport(esw, index, vport, last)		\
+	xa_for_each_range(&((esw)->vports),				\
+			  index,					\
+			  vport,					\
+			  MLX5_CAP_GEN_2((esw->dev), ec_vf_vport_base),	\
+			  (last) - 1)
+
 struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink);
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 625982454575..68798aed792f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3287,6 +3287,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	/* Representor will control the vport link state */
 	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
 		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_DOWN;
+	if (mlx5_core_ec_sriov_enabled(esw->dev))
+		mlx5_esw_for_each_ec_vf_vport(esw, i, vport, esw->esw_funcs.num_ec_vfs)
+			vport->info.link_state = MLX5_VPORT_ADMIN_STATE_DOWN;
 
 	/* Uplink vport rep must load first. */
 	err = esw_offloads_load_rep(esw, MLX5_VPORT_UPLINK);
@@ -3524,8 +3527,27 @@ static int mlx5_esw_vports_inline_set(struct mlx5_eswitch *esw, u8 mlx5_mode,
 			goto revert_inline_mode;
 		}
 	}
+	if (mlx5_core_ec_sriov_enabled(esw->dev)) {
+		mlx5_esw_for_each_ec_vf_vport(esw, i, vport, esw->esw_funcs.num_ec_vfs) {
+			err = mlx5_modify_nic_vport_min_inline(dev, vport->vport, mlx5_mode);
+			if (err) {
+				err_vport_num = vport->vport;
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Failed to set min inline on vport");
+				goto revert_ec_vf_inline_mode;
+			}
+		}
+	}
 	return 0;
 
+revert_ec_vf_inline_mode:
+	mlx5_esw_for_each_ec_vf_vport(esw, i, vport, esw->esw_funcs.num_ec_vfs) {
+		if (vport->vport == err_vport_num)
+			break;
+		mlx5_modify_nic_vport_min_inline(dev,
+						 vport->vport,
+						 esw->offloads.inline_mode);
+	}
 revert_inline_mode:
 	mlx5_esw_for_each_host_func_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
 		if (vport->vport == err_vport_num)
-- 
2.40.1


