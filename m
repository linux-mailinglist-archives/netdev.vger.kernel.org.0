Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2482F35E714
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347913AbhDMTbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345621AbhDMTav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99B25613CC;
        Tue, 13 Apr 2021 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342231;
        bh=e78Vk/dTbmzwQbjXmvm8wkgFwtX+30EgXtvrq2LpX30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BC8hGmbovgnYNY1JVmMJY3o2gomYlGEcZVAYEv+lSlajfInctiflj5+xWWDpAW0Cn
         VCzFm9P1dbKtoJn83NoJbpiouZChB+TRlf/2QxB2biUtfYMBCy/jfvsV13iawrdG6L
         +Kii/cN+kg6oMZ9dmt9zvpZhb2818ONEt7fwGcPsRvFY5Q/cylFe0fvXhTy2uEm0l6
         x8xoAv26Q+92TGGEXKb0NOHolgRP2xbuI2Vkk7w4eM8sgG/dkdaTjf8g4G2pB1Qbub
         ZjG2O80JDZoQJnyTjCxS5VCXFfViptNBUcsVJie/VSlZw68hgit7Ek13EcXDSN1kQ1
         QBiCH4wN1RUbg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5: E-Switch, Initialize eswitch acls ns when eswitch is enabled
Date:   Tue, 13 Apr 2021 12:29:57 -0700
Message-Id: <20210413193006.21650-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently eswitch flow steering (FS) namespace of vport's ingress and
egress ACL are enabled when FS layer is initialized. This is done even
when eswitch is diabled. This demands that total eswitch ports to be
known to FS layer without eswitch in use.

Given the FS core is not dependent on eswitch, make namespace init and
cleanup routines as helper routines to be invoked only when eswitch is
needed.

With this change, ingress and egress ACL namespaces are created only
when eswitch legacy/offloads mode is enabled.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 53 +++++++++--
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 88 ++++++++-----------
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  7 ++
 3 files changed, 93 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 3dfcd4ec1556..1bb229ecd43b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1367,6 +1367,47 @@ static void mlx5_esw_mode_change_notify(struct mlx5_eswitch *esw, u16 mode)
 	blocking_notifier_call_chain(&esw->n_head, 0, &info);
 }
 
+static int mlx5_esw_acls_ns_init(struct mlx5_eswitch *esw)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	int total_vports;
+	int err;
+
+	total_vports = mlx5_eswitch_get_total_vports(dev);
+
+	if (MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support)) {
+		err = mlx5_fs_egress_acls_init(dev, total_vports);
+		if (err)
+			return err;
+	} else {
+		esw_warn(dev, "engress ACL is not supported by FW\n");
+	}
+
+	if (MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support)) {
+		err = mlx5_fs_ingress_acls_init(dev, total_vports);
+		if (err)
+			goto err;
+	} else {
+		esw_warn(dev, "ingress ACL is not supported by FW\n");
+	}
+	return 0;
+
+err:
+	if (MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support))
+		mlx5_fs_egress_acls_cleanup(dev);
+	return err;
+}
+
+static void mlx5_esw_acls_ns_cleanup(struct mlx5_eswitch *esw)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+
+	if (MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support))
+		mlx5_fs_ingress_acls_cleanup(dev);
+	if (MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support))
+		mlx5_fs_egress_acls_cleanup(dev);
+}
+
 /**
  * mlx5_eswitch_enable_locked - Enable eswitch
  * @esw:	Pointer to eswitch
@@ -1395,14 +1436,12 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 		return -EOPNOTSUPP;
 	}
 
-	if (!MLX5_CAP_ESW_INGRESS_ACL(esw->dev, ft_support))
-		esw_warn(esw->dev, "ingress ACL is not supported by FW\n");
-
-	if (!MLX5_CAP_ESW_EGRESS_ACL(esw->dev, ft_support))
-		esw_warn(esw->dev, "engress ACL is not supported by FW\n");
-
 	mlx5_eswitch_get_devlink_param(esw);
 
+	err = mlx5_esw_acls_ns_init(esw);
+	if (err)
+		return err;
+
 	mlx5_eswitch_update_num_of_vfs(esw, num_vfs);
 
 	esw_create_tsar(esw);
@@ -1438,6 +1477,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 		mlx5_rescan_drivers(esw->dev);
 
 	esw_destroy_tsar(esw);
+	mlx5_esw_acls_ns_cleanup(esw);
 	return err;
 }
 
@@ -1506,6 +1546,7 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 		mlx5_rescan_drivers(esw->dev);
 
 	esw_destroy_tsar(esw);
+	mlx5_esw_acls_ns_cleanup(esw);
 
 	if (clear_vf)
 		mlx5_eswitch_clear_vf_vports_info(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0216bd63a42d..f74d2c834037 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2229,17 +2229,21 @@ struct mlx5_flow_namespace *mlx5_get_flow_vport_acl_namespace(struct mlx5_core_d
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
 
-	if (!steering || vport >= mlx5_eswitch_get_total_vports(dev))
+	if (!steering)
 		return NULL;
 
 	switch (type) {
 	case MLX5_FLOW_NAMESPACE_ESW_EGRESS:
+		if (vport >= steering->esw_egress_acl_vports)
+			return NULL;
 		if (steering->esw_egress_root_ns &&
 		    steering->esw_egress_root_ns[vport])
 			return &steering->esw_egress_root_ns[vport]->ns;
 		else
 			return NULL;
 	case MLX5_FLOW_NAMESPACE_ESW_INGRESS:
+		if (vport >= steering->esw_ingress_acl_vports)
+			return NULL;
 		if (steering->esw_ingress_root_ns &&
 		    steering->esw_ingress_root_ns[vport])
 			return &steering->esw_ingress_root_ns[vport]->ns;
@@ -2571,43 +2575,11 @@ static void cleanup_root_ns(struct mlx5_flow_root_namespace *root_ns)
 	clean_tree(&root_ns->ns.node);
 }
 
-static void cleanup_egress_acls_root_ns(struct mlx5_core_dev *dev)
-{
-	struct mlx5_flow_steering *steering = dev->priv.steering;
-	int i;
-
-	if (!steering->esw_egress_root_ns)
-		return;
-
-	for (i = 0; i < mlx5_eswitch_get_total_vports(dev); i++)
-		cleanup_root_ns(steering->esw_egress_root_ns[i]);
-
-	kfree(steering->esw_egress_root_ns);
-	steering->esw_egress_root_ns = NULL;
-}
-
-static void cleanup_ingress_acls_root_ns(struct mlx5_core_dev *dev)
-{
-	struct mlx5_flow_steering *steering = dev->priv.steering;
-	int i;
-
-	if (!steering->esw_ingress_root_ns)
-		return;
-
-	for (i = 0; i < mlx5_eswitch_get_total_vports(dev); i++)
-		cleanup_root_ns(steering->esw_ingress_root_ns[i]);
-
-	kfree(steering->esw_ingress_root_ns);
-	steering->esw_ingress_root_ns = NULL;
-}
-
 void mlx5_cleanup_fs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
 
 	cleanup_root_ns(steering->root_ns);
-	cleanup_egress_acls_root_ns(dev);
-	cleanup_ingress_acls_root_ns(dev);
 	cleanup_root_ns(steering->fdb_root_ns);
 	steering->fdb_root_ns = NULL;
 	kfree(steering->fdb_sub_ns);
@@ -2852,10 +2824,9 @@ static int init_ingress_acl_root_ns(struct mlx5_flow_steering *steering, int vpo
 	return PTR_ERR_OR_ZERO(prio);
 }
 
-static int init_egress_acls_root_ns(struct mlx5_core_dev *dev)
+int mlx5_fs_egress_acls_init(struct mlx5_core_dev *dev, int total_vports)
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
-	int total_vports = mlx5_eswitch_get_total_vports(dev);
 	int err;
 	int i;
 
@@ -2871,7 +2842,7 @@ static int init_egress_acls_root_ns(struct mlx5_core_dev *dev)
 		if (err)
 			goto cleanup_root_ns;
 	}
-
+	steering->esw_egress_acl_vports = total_vports;
 	return 0;
 
 cleanup_root_ns:
@@ -2882,10 +2853,24 @@ static int init_egress_acls_root_ns(struct mlx5_core_dev *dev)
 	return err;
 }
 
-static int init_ingress_acls_root_ns(struct mlx5_core_dev *dev)
+void mlx5_fs_egress_acls_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_flow_steering *steering = dev->priv.steering;
+	int i;
+
+	if (!steering->esw_egress_root_ns)
+		return;
+
+	for (i = 0; i < steering->esw_egress_acl_vports; i++)
+		cleanup_root_ns(steering->esw_egress_root_ns[i]);
+
+	kfree(steering->esw_egress_root_ns);
+	steering->esw_egress_root_ns = NULL;
+}
+
+int mlx5_fs_ingress_acls_init(struct mlx5_core_dev *dev, int total_vports)
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
-	int total_vports = mlx5_eswitch_get_total_vports(dev);
 	int err;
 	int i;
 
@@ -2901,7 +2886,7 @@ static int init_ingress_acls_root_ns(struct mlx5_core_dev *dev)
 		if (err)
 			goto cleanup_root_ns;
 	}
-
+	steering->esw_ingress_acl_vports = total_vports;
 	return 0;
 
 cleanup_root_ns:
@@ -2912,6 +2897,21 @@ static int init_ingress_acls_root_ns(struct mlx5_core_dev *dev)
 	return err;
 }
 
+void mlx5_fs_ingress_acls_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_flow_steering *steering = dev->priv.steering;
+	int i;
+
+	if (!steering->esw_ingress_root_ns)
+		return;
+
+	for (i = 0; i < steering->esw_ingress_acl_vports; i++)
+		cleanup_root_ns(steering->esw_ingress_root_ns[i]);
+
+	kfree(steering->esw_ingress_root_ns);
+	steering->esw_ingress_root_ns = NULL;
+}
+
 static int init_egress_root_ns(struct mlx5_flow_steering *steering)
 {
 	int err;
@@ -2974,16 +2974,6 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 			if (err)
 				goto err;
 		}
-		if (MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support)) {
-			err = init_egress_acls_root_ns(dev);
-			if (err)
-				goto err;
-		}
-		if (MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support)) {
-			err = init_ingress_acls_root_ns(dev);
-			if (err)
-				goto err;
-		}
 	}
 
 	if (MLX5_CAP_FLOWTABLE_SNIFFER_RX(dev, ft_support)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index b24a9849c45e..e577a2c424af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -129,6 +129,8 @@ struct mlx5_flow_steering {
 	struct mlx5_flow_root_namespace	*rdma_rx_root_ns;
 	struct mlx5_flow_root_namespace	*rdma_tx_root_ns;
 	struct mlx5_flow_root_namespace	*egress_root_ns;
+	int esw_egress_acl_vports;
+	int esw_ingress_acl_vports;
 };
 
 struct fs_node {
@@ -287,6 +289,11 @@ int mlx5_flow_namespace_set_mode(struct mlx5_flow_namespace *ns,
 int mlx5_init_fs(struct mlx5_core_dev *dev);
 void mlx5_cleanup_fs(struct mlx5_core_dev *dev);
 
+int mlx5_fs_egress_acls_init(struct mlx5_core_dev *dev, int total_vports);
+void mlx5_fs_egress_acls_cleanup(struct mlx5_core_dev *dev);
+int mlx5_fs_ingress_acls_init(struct mlx5_core_dev *dev, int total_vports);
+void mlx5_fs_ingress_acls_cleanup(struct mlx5_core_dev *dev);
+
 #define fs_get_obj(v, _node)  {v = container_of((_node), typeof(*v), node); }
 
 #define fs_list_for_each_entry(pos, root)		\
-- 
2.30.2

