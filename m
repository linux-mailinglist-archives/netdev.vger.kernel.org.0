Return-Path: <netdev+bounces-7557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E19477209A1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DBBA1C20D1B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3021F161;
	Fri,  2 Jun 2023 19:13:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E5619E45
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C6C433A1;
	Fri,  2 Jun 2023 19:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685733190;
	bh=x0jGndzhc7tZfL71KgatBevdEvOZ/+YpdW6FLww/POQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt/4KemDS67zzMkSOOIWvB98PEhPTzhjhvDUuFEzHOoywbNJu58flEIwvN6eVp6Hz
	 9hM44EbE8ha4h3ToRI6T2NK9bl+RwHTqBSHzFymsuKZG+9QcGXvUKuI+z4a/HJ3Qlb
	 L1+O78bPD8CFMuGFQ4sYQ4fyWKPYndeU8JWKqGyisDvdVpAsz+cI3d6nuAE5/NEFQd
	 fg6wnbbSRMqRkhinxxGiY80/7xqfRhQ5PgdAgfxiEta5k0e7XGizOMh4pyQLiGZhZs
	 0syf9haAnyv2/Y9tu+RePqW5f4ntfxsO6rRd8tzsIAeedctRqG8ZJv8F6v3/7Vvasr
	 +y1HbSPcjL2CQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Roi Dayan <roid@nvidia.com>
Subject: [net-next V2 09/14] net/mlx5: E-switch, generalize shared FDB creation
Date: Fri,  2 Jun 2023 12:12:56 -0700
Message-Id: <20230602191301.47004-10-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602191301.47004-1-saeed@kernel.org>
References: <20230602191301.47004-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Shared FDB creation is hard coded for only two eswitches.
Generalize shared FDB creation so that any number of eswitches could
create shared FDB.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  | 12 +++++++
 .../mellanox/mlx5/core/esw/acl/ofld.h         |  1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 12 +++----
 .../mellanox/mlx5/core/eswitch_offloads.c     | 32 +++++++++--------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 35 +++++++++++++++----
 5 files changed, 66 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index ae815a8392c6..24b1ca4e4ff8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -15,6 +15,18 @@ static void esw_acl_egress_ofld_fwd2vport_destroy(struct mlx5_vport *vport)
 	vport->egress.offloads.fwd_rule = NULL;
 }
 
+void esw_acl_egress_ofld_bounce_rule_destroy(struct mlx5_vport *vport, int rule_index)
+{
+	struct mlx5_flow_handle *bounce_rule =
+		xa_load(&vport->egress.offloads.bounce_rules, rule_index);
+
+	if (!bounce_rule)
+		return;
+
+	mlx5_del_flow_rules(bounce_rule);
+	xa_erase(&vport->egress.offloads.bounce_rules, rule_index);
+}
+
 static void esw_acl_egress_ofld_bounce_rules_destroy(struct mlx5_vport *vport)
 {
 	struct mlx5_flow_handle *bounce_rule;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
index c9f8469e9a47..536b04e83618 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
@@ -10,6 +10,7 @@
 /* Eswitch acl egress external APIs */
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport);
+void esw_acl_egress_ofld_bounce_rule_destroy(struct mlx5_vport *vport, int rule_index);
 int mlx5_esw_acl_egress_vport_bond(struct mlx5_eswitch *esw, u16 active_vport_num,
 				   u16 passive_vport_num);
 int mlx5_esw_acl_egress_vport_unbond(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 05ae1c3a6e68..9833d1a587cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -754,9 +754,9 @@ void esw_vport_change_handle_locked(struct mlx5_vport *vport);
 
 bool mlx5_esw_offloads_controller_valid(const struct mlx5_eswitch *esw, u32 controller);
 
-int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
-					    struct mlx5_eswitch *slave_esw);
-void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
+int mlx5_eswitch_offloads_single_fdb_add_one(struct mlx5_eswitch *master_esw,
+					     struct mlx5_eswitch *slave_esw, int max_slaves);
+void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw);
 int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw);
 
@@ -808,14 +808,14 @@ mlx5_esw_vport_to_devlink_port_index(const struct mlx5_core_dev *dev,
 }
 
 static inline int
-mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
-					struct mlx5_eswitch *slave_esw)
+mlx5_eswitch_offloads_single_fdb_add_one(struct mlx5_eswitch *master_esw,
+					 struct mlx5_eswitch *slave_esw, int max_slaves)
 {
 	return 0;
 }
 
 static inline void
-mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
+mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 					 struct mlx5_eswitch *slave_esw) {}
 
 static inline int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ce70320b89b3..98d75a33a624 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2557,11 +2557,11 @@ static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
 }
 
 static int esw_master_egress_create_resources(struct mlx5_flow_namespace *egress_ns,
-					      struct mlx5_vport *vport)
+					      struct mlx5_vport *vport, size_t count)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr = {
-		.max_fte = MLX5_MAX_PORTS, .prio = 0, .level = 0,
+		.max_fte = count, .prio = 0, .level = 0,
 		.flags = MLX5_FLOW_TABLE_OTHER_VPORT,
 	};
 	struct mlx5_flow_table *acl;
@@ -2595,7 +2595,7 @@ static int esw_master_egress_create_resources(struct mlx5_flow_namespace *egress
 	MLX5_SET(create_flow_group_in, flow_group_in,
 		 source_eswitch_owner_vhca_id_valid, 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, MLX5_MAX_PORTS);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, count);
 
 	g = mlx5_create_flow_group(acl, flow_group_in);
 	if (IS_ERR(g)) {
@@ -2626,7 +2626,7 @@ static void esw_master_egress_destroy_resources(struct mlx5_vport *vport)
 }
 
 static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
-				      struct mlx5_core_dev *slave)
+				      struct mlx5_core_dev *slave, size_t count)
 {
 	struct mlx5_eswitch *esw = master->priv.eswitch;
 	u16 slave_index = MLX5_CAP_GEN(slave, vhca_id);
@@ -2647,7 +2647,7 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	if (vport->egress.acl && vport->egress.type != VPORT_EGRESS_ACL_TYPE_SHARED_FDB)
 		return 0;
 
-	err = esw_master_egress_create_resources(egress_ns, vport);
+	err = esw_master_egress_create_resources(egress_ns, vport, count);
 	if (err)
 		return err;
 
@@ -2665,19 +2665,24 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	return err;
 }
 
-static void esw_unset_master_egress_rule(struct mlx5_core_dev *dev)
+static void esw_unset_master_egress_rule(struct mlx5_core_dev *dev,
+					 struct mlx5_core_dev *slave_dev)
 {
 	struct mlx5_vport *vport;
 
 	vport = mlx5_eswitch_get_vport(dev->priv.eswitch,
 				       dev->priv.eswitch->manager_vport);
 
-	esw_acl_egress_ofld_cleanup(vport);
-	xa_destroy(&vport->egress.offloads.bounce_rules);
+	esw_acl_egress_ofld_bounce_rule_destroy(vport, MLX5_CAP_GEN(slave_dev, vhca_id));
+
+	if (xa_empty(&vport->egress.offloads.bounce_rules)) {
+		esw_acl_egress_ofld_cleanup(vport);
+		xa_destroy(&vport->egress.offloads.bounce_rules);
+	}
 }
 
-int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
-					    struct mlx5_eswitch *slave_esw)
+int mlx5_eswitch_offloads_single_fdb_add_one(struct mlx5_eswitch *master_esw,
+					     struct mlx5_eswitch *slave_esw, int max_slaves)
 {
 	int err;
 
@@ -2687,7 +2692,7 @@ int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
 		return err;
 
 	err = esw_set_master_egress_rule(master_esw->dev,
-					 slave_esw->dev);
+					 slave_esw->dev, max_slaves);
 	if (err)
 		goto err_acl;
 
@@ -2695,15 +2700,14 @@ int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
 
 err_acl:
 	esw_set_slave_root_fdb(NULL, slave_esw->dev);
-
 	return err;
 }
 
-void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
+void mlx5_eswitch_offloads_single_fdb_del_one(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw)
 {
-	esw_unset_master_egress_rule(master_esw->dev);
 	esw_set_slave_root_fdb(NULL, slave_esw->dev);
+	esw_unset_master_egress_rule(master_esw->dev, slave_esw->dev);
 }
 
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 5d331b940f4d..9bc2822881ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -550,6 +550,29 @@ char *mlx5_get_str_port_sel_mode(enum mlx5_lag_mode mode, unsigned long flags)
 	}
 }
 
+static int mlx5_lag_create_single_fdb(struct mlx5_lag *ldev)
+{
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_eswitch *master_esw = dev0->priv.eswitch;
+	int err;
+	int i;
+
+	for (i = MLX5_LAG_P1 + 1; i < ldev->ports; i++) {
+		struct mlx5_eswitch *slave_esw = ldev->pf[i].dev->priv.eswitch;
+
+		err = mlx5_eswitch_offloads_single_fdb_add_one(master_esw,
+							       slave_esw, ldev->ports);
+		if (err)
+			goto err;
+	}
+	return 0;
+err:
+	for (; i > MLX5_LAG_P1; i--)
+		mlx5_eswitch_offloads_single_fdb_del_one(master_esw,
+							 ldev->pf[i].dev->priv.eswitch);
+	return err;
+}
+
 static int mlx5_create_lag(struct mlx5_lag *ldev,
 			   struct lag_tracker *tracker,
 			   enum mlx5_lag_mode mode,
@@ -557,7 +580,6 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 {
 	bool shared_fdb = test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags);
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	int err;
 
@@ -575,8 +597,7 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	}
 
 	if (shared_fdb) {
-		err = mlx5_eswitch_offloads_config_single_fdb(dev0->priv.eswitch,
-							      dev1->priv.eswitch);
+		err = mlx5_lag_create_single_fdb(ldev);
 		if (err)
 			mlx5_core_err(dev0, "Can't enable single FDB mode\n");
 		else
@@ -647,19 +668,21 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
+	struct mlx5_eswitch *master_esw = dev0->priv.eswitch;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	bool roce_lag = __mlx5_lag_is_roce(ldev);
 	unsigned long flags = ldev->mode_flags;
 	int err;
+	int i;
 
 	ldev->mode = MLX5_LAG_MODE_NONE;
 	ldev->mode_flags = 0;
 	mlx5_lag_mp_reset(ldev);
 
 	if (test_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags)) {
-		mlx5_eswitch_offloads_destroy_single_fdb(dev0->priv.eswitch,
-							 dev1->priv.eswitch);
+		for (i = MLX5_LAG_P1 + 1; i < ldev->ports; i++)
+			mlx5_eswitch_offloads_single_fdb_del_one(master_esw,
+								 ldev->pf[i].dev->priv.eswitch);
 		clear_bit(MLX5_LAG_MODE_FLAG_SHARED_FDB, &flags);
 	}
 
-- 
2.40.1


