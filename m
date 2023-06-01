Return-Path: <netdev+bounces-7004-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3527192EF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83B73281620
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55A913AF0;
	Thu,  1 Jun 2023 06:01:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A115BA5E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E4CC433EF;
	Thu,  1 Jun 2023 06:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599300;
	bh=n21YIHPF43CNZvwtbNWoJGCLIXzaxmS78hTVdXZw8SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dix5IcuueYEOegW0hVvU22r3T4Y3ZqHM4Q6Ep6YMbKzWXXlPjHZdYCyrZOAg5wn+y
	 iNpR5LgFKUowV33gvWa/7c2fo+csSb917Lcx97o6gOxbLU8sx91nTpRewNqGdSKXOm
	 EeQ0rF0Nmnz2D1vGir/I4p6pMat5We6EmZGfXs57tG9opyGT+pOKIP/gE4j9RDG5/R
	 pm1j6+6kuVAE4dVwZgLeylU5i8d/HnhELFp08a4ewk16MZx73u+dKD1i+myF9c5jdN
	 dbHDSMs6TOk8QazdSCBbNKN8nk49pE4P+NUA/HgHPJdPPt55eTQz/JvtbMBU8g/4rr
	 FIyIUDZVBcT7Q==
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
Subject: [net-next 08/14] net/mlx5: E-switch, Handle multiple master egress rules
Date: Wed, 31 May 2023 23:01:12 -0700
Message-Id: <20230601060118.154015-9-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601060118.154015-1-saeed@kernel.org>
References: <20230601060118.154015-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Currently, whenever a shared FDB is created, the slave eswitch is
creating master egress rule to the master eswitch.
In order to support more than two ports, which means there will be
more than one slave eswitch, enlarge bounce_rule, which is used to
create master egress rule, to an xarray.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  | 15 +--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 92 +++++++++++++------
 3 files changed, 79 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index 2e504c7461c6..ae815a8392c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -15,13 +15,15 @@ static void esw_acl_egress_ofld_fwd2vport_destroy(struct mlx5_vport *vport)
 	vport->egress.offloads.fwd_rule = NULL;
 }
 
-static void esw_acl_egress_ofld_bounce_rule_destroy(struct mlx5_vport *vport)
+static void esw_acl_egress_ofld_bounce_rules_destroy(struct mlx5_vport *vport)
 {
-	if (!vport->egress.offloads.bounce_rule)
-		return;
+	struct mlx5_flow_handle *bounce_rule;
+	unsigned long i;
 
-	mlx5_del_flow_rules(vport->egress.offloads.bounce_rule);
-	vport->egress.offloads.bounce_rule = NULL;
+	xa_for_each(&vport->egress.offloads.bounce_rules, i, bounce_rule) {
+		mlx5_del_flow_rules(bounce_rule);
+		xa_erase(&vport->egress.offloads.bounce_rules, i);
+	}
 }
 
 static int esw_acl_egress_ofld_fwd2vport_create(struct mlx5_eswitch *esw,
@@ -96,7 +98,7 @@ static void esw_acl_egress_ofld_rules_destroy(struct mlx5_vport *vport)
 {
 	esw_acl_egress_vlan_destroy(vport);
 	esw_acl_egress_ofld_fwd2vport_destroy(vport);
-	esw_acl_egress_ofld_bounce_rule_destroy(vport);
+	esw_acl_egress_ofld_bounce_rules_destroy(vport);
 }
 
 static int esw_acl_egress_ofld_groups_create(struct mlx5_eswitch *esw,
@@ -194,6 +196,7 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 		vport->egress.acl = NULL;
 		return err;
 	}
+	vport->egress.type = VPORT_EGRESS_ACL_TYPE_DEFAULT;
 
 	err = esw_acl_egress_ofld_groups_create(esw, vport);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 2a941e1cc686..05ae1c3a6e68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -123,8 +123,14 @@ struct vport_ingress {
 	} offloads;
 };
 
+enum vport_egress_acl_type {
+	VPORT_EGRESS_ACL_TYPE_DEFAULT,
+	VPORT_EGRESS_ACL_TYPE_SHARED_FDB,
+};
+
 struct vport_egress {
 	struct mlx5_flow_table *acl;
+	enum vport_egress_acl_type type;
 	struct mlx5_flow_handle  *allowed_vlan;
 	struct mlx5_flow_group *vlan_grp;
 	union {
@@ -136,7 +142,7 @@ struct vport_egress {
 		struct {
 			struct mlx5_flow_group *fwd_grp;
 			struct mlx5_flow_handle *fwd_rule;
-			struct mlx5_flow_handle *bounce_rule;
+			struct xarray bounce_rules;
 			struct mlx5_flow_group *bounce_grp;
 		} offloads;
 	};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a7f352777d9e..ce70320b89b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2512,6 +2512,7 @@ static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
 					struct mlx5_vport *vport,
 					struct mlx5_flow_table *acl)
 {
+	u16 slave_index = MLX5_CAP_GEN(slave, vhca_id);
 	struct mlx5_flow_handle *flow_rule = NULL;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
@@ -2527,8 +2528,7 @@ static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 			    misc_parameters);
 	MLX5_SET(fte_match_set_misc, misc, source_port, MLX5_VPORT_UPLINK);
-	MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
-		 MLX5_CAP_GEN(slave, vhca_id));
+	MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id, slave_index);
 
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
@@ -2543,44 +2543,35 @@ static int __esw_set_master_egress_rule(struct mlx5_core_dev *master,
 
 	flow_rule = mlx5_add_flow_rules(acl, spec, &flow_act,
 					&dest, 1);
-	if (IS_ERR(flow_rule))
+	if (IS_ERR(flow_rule)) {
 		err = PTR_ERR(flow_rule);
-	else
-		vport->egress.offloads.bounce_rule = flow_rule;
+	} else {
+		err = xa_insert(&vport->egress.offloads.bounce_rules,
+				slave_index, flow_rule, GFP_KERNEL);
+		if (err)
+			mlx5_del_flow_rules(flow_rule);
+	}
 
 	kvfree(spec);
 	return err;
 }
 
-static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
-				      struct mlx5_core_dev *slave)
+static int esw_master_egress_create_resources(struct mlx5_flow_namespace *egress_ns,
+					      struct mlx5_vport *vport)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_eswitch *esw = master->priv.eswitch;
 	struct mlx5_flow_table_attr ft_attr = {
-		.max_fte = 1, .prio = 0, .level = 0,
+		.max_fte = MLX5_MAX_PORTS, .prio = 0, .level = 0,
 		.flags = MLX5_FLOW_TABLE_OTHER_VPORT,
 	};
-	struct mlx5_flow_namespace *egress_ns;
 	struct mlx5_flow_table *acl;
 	struct mlx5_flow_group *g;
-	struct mlx5_vport *vport;
 	void *match_criteria;
 	u32 *flow_group_in;
 	int err;
 
-	vport = mlx5_eswitch_get_vport(esw, esw->manager_vport);
-	if (IS_ERR(vport))
-		return PTR_ERR(vport);
-
-	egress_ns = mlx5_get_flow_vport_acl_namespace(master,
-						      MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-						      vport->index);
-	if (!egress_ns)
-		return -EINVAL;
-
 	if (vport->egress.acl)
-		return -EINVAL;
+		return 0;
 
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
@@ -2604,7 +2595,7 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	MLX5_SET(create_flow_group_in, flow_group_in,
 		 source_eswitch_owner_vhca_id_valid, 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, MLX5_MAX_PORTS);
 
 	g = mlx5_create_flow_group(acl, flow_group_in);
 	if (IS_ERR(g)) {
@@ -2612,19 +2603,15 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 		goto err_group;
 	}
 
-	err = __esw_set_master_egress_rule(master, slave, vport, acl);
-	if (err)
-		goto err_rule;
-
 	vport->egress.acl = acl;
 	vport->egress.offloads.bounce_grp = g;
+	vport->egress.type = VPORT_EGRESS_ACL_TYPE_SHARED_FDB;
+	xa_init_flags(&vport->egress.offloads.bounce_rules, XA_FLAGS_ALLOC);
 
 	kvfree(flow_group_in);
 
 	return 0;
 
-err_rule:
-	mlx5_destroy_flow_group(g);
 err_group:
 	mlx5_destroy_flow_table(acl);
 out:
@@ -2632,6 +2619,52 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	return err;
 }
 
+static void esw_master_egress_destroy_resources(struct mlx5_vport *vport)
+{
+	mlx5_destroy_flow_group(vport->egress.offloads.bounce_grp);
+	mlx5_destroy_flow_table(vport->egress.acl);
+}
+
+static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
+				      struct mlx5_core_dev *slave)
+{
+	struct mlx5_eswitch *esw = master->priv.eswitch;
+	u16 slave_index = MLX5_CAP_GEN(slave, vhca_id);
+	struct mlx5_flow_namespace *egress_ns;
+	struct mlx5_vport *vport;
+	int err;
+
+	vport = mlx5_eswitch_get_vport(esw, esw->manager_vport);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	egress_ns = mlx5_get_flow_vport_acl_namespace(master,
+						      MLX5_FLOW_NAMESPACE_ESW_EGRESS,
+						      vport->index);
+	if (!egress_ns)
+		return -EINVAL;
+
+	if (vport->egress.acl && vport->egress.type != VPORT_EGRESS_ACL_TYPE_SHARED_FDB)
+		return 0;
+
+	err = esw_master_egress_create_resources(egress_ns, vport);
+	if (err)
+		return err;
+
+	if (xa_load(&vport->egress.offloads.bounce_rules, slave_index))
+		return -EINVAL;
+
+	err = __esw_set_master_egress_rule(master, slave, vport, vport->egress.acl);
+	if (err)
+		goto err_rule;
+
+	return 0;
+
+err_rule:
+	esw_master_egress_destroy_resources(vport);
+	return err;
+}
+
 static void esw_unset_master_egress_rule(struct mlx5_core_dev *dev)
 {
 	struct mlx5_vport *vport;
@@ -2640,6 +2673,7 @@ static void esw_unset_master_egress_rule(struct mlx5_core_dev *dev)
 				       dev->priv.eswitch->manager_vport);
 
 	esw_acl_egress_ofld_cleanup(vport);
+	xa_destroy(&vport->egress.offloads.bounce_rules);
 }
 
 int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
-- 
2.40.1


