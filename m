Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DFA35E70D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345589AbhDMTau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344831AbhDMTat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB322613CA;
        Tue, 13 Apr 2021 19:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342229;
        bh=MAsz5C68otqx+mbpAZGaz3LdewgDnfqk8GuLIKjf+h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4Rd6pAefDdQ3bocrT4HC3fg5ZM8fG4C/5bzu+DzoWpLfEoMmLzOzaenw7+ZEydOG
         bYjLcnwZRlAxOkz0OtIcqQpbFyQOQEQmOAB3e6dOtHjZa65TiM+Wg+AxUqYM0ViykP
         4gc1e3zFHR1TpVzwbYpSGsxFNkl/SSHBuUNCI0wwoQxZXT6BNKveaeeUE6AFPy85dq
         TuzvpOfVWn7BSD6lvEJAqC52diCAa1RCvyf9ej5CXwbTzMtTjTFenPJfkwqdgtORVZ
         OVlsoekhV+GZK3eVGs9NSGRBP1tyCOfwItGP0iV5A8cihOoQSZ6Ghb6gpVIz44JNJp
         50hFmeLQQOqXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/16] net/mlx5: E-Switch, let user to enable disable metadata
Date:   Tue, 13 Apr 2021 12:29:51 -0700
Message-Id: <20210413193006.21650-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently each packet inserted in eswitch is tagged with a internal
metadata to indicate source vport. Metadata tagging is not always
needed. Metadata insertion is needed for multi-port RoCE, failover
between representors and stacked devices. In many other cases,
metadata enablement is not needed.

Metadata insertion slows down the packet processing rate.

Hence, allow user to disable metadata using driver specific devlink
parameter.

Example to show and disable metadata before changing eswitch mode:
$ devlink dev param show pci/0000:06:00.0 name esw_port_metadata
pci/0000:06:00.0:
  name esw_port_metadata type driver-specific
    values:
      cmode runtime value true

$ devlink dev param set pci/0000:06:00.0 \
	  name esw_port_metadata value false cmode runtime

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst | 23 +++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 62 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 30 ++++++---
 5 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 1b7e32d8a61b..49bd05c8f3e5 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -183,6 +183,29 @@ User command examples:
       values:
          cmode driverinit value true
 
+esw_port_metadata: Eswitch port metadata state
+----------------------------------------------
+Eswitch port metadata state controls whether to internally tag packet with metadata or not.
+Metadata tagging must be enabled for multi-port RoCE, failover between representors and stacked devices.
+By default metadata is enabled on the supported devices. When metadata usage is not needed,
+user can disable metadata tagging before moving the eswitch to switchdev mode.
+
+- Show eswitch port metadata::
+
+    $ devlink dev param show pci/0000:06:00.0 name esw_port_metadata
+      pci/0000:06:00.0:
+        name esw_port_metadata type driver-specific
+          values:
+            cmode runtime value true
+
+- Disable eswitch port metadata::
+
+    $ devlink dev param set pci/0000:06:00.0 name esw_port_metadata value false cmode runtime
+
+- Change eswitch mode to switchdev mode where metadata is used::
+
+    $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
+
 mlx5 subfunction
 ================
 mlx5 supports subfunction management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 38c7c44fe883..ee0f5355f120 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -456,6 +456,50 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
 
 	return 0;
 }
+
+static int mlx5_devlink_esw_port_metadata_set(struct devlink *devlink, u32 id,
+					      struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return -EOPNOTSUPP;
+
+	return mlx5_esw_offloads_vport_metadata_set(dev->priv.eswitch, ctx->val.vbool);
+}
+
+static int mlx5_devlink_esw_port_metadata_get(struct devlink *devlink, u32 id,
+					      struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return -EOPNOTSUPP;
+
+	ctx->val.vbool = mlx5_eswitch_vport_match_metadata_enabled(dev->priv.eswitch);
+	return 0;
+}
+
+static int mlx5_devlink_esw_port_metadata_validate(struct devlink *devlink, u32 id,
+						   union devlink_param_value val,
+						   struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u8 esw_mode;
+
+	if (!MLX5_ESWITCH_MANAGER(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "E-Switch is unsupported");
+		return -EOPNOTSUPP;
+	}
+	esw_mode = mlx5_eswitch_mode(dev);
+	if (esw_mode == MLX5_ESWITCH_OFFLOADS) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "E-Switch must either disabled or non switchdev mode");
+		return -EBUSY;
+	}
+	return 0;
+}
+
 #endif
 
 static int mlx5_devlink_enable_remote_dev_reset_set(struct devlink *devlink, u32 id,
@@ -490,6 +534,12 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			     NULL, NULL,
 			     mlx5_devlink_large_group_num_validate),
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
+			     "esw_port_metadata", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     mlx5_devlink_esw_port_metadata_get,
+			     mlx5_devlink_esw_port_metadata_set,
+			     mlx5_devlink_esw_port_metadata_validate),
 #endif
 	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			      mlx5_devlink_enable_remote_dev_reset_get,
@@ -519,6 +569,18 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
 					   value);
+
+	if (MLX5_ESWITCH_MANAGER(dev)) {
+		if (mlx5_esw_vport_match_metadata_supported(dev->priv.eswitch)) {
+			dev->priv.eswitch->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
+			value.vbool = true;
+		} else {
+			value.vbool = false;
+		}
+		devlink_param_driverinit_value_set(devlink,
+						   MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
+						   value);
+	}
 #endif
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index eff107dad922..7318d44b774b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -10,6 +10,7 @@ enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 	MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
+	MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
 };
 
 struct mlx5_trap_ctx {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index deafb0e03787..c7a73dbd64b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -314,6 +314,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw);
 void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
 int esw_offloads_init_reps(struct mlx5_eswitch *esw);
 
+bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw);
+int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable);
 u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw);
 void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ab32f685cbb7..1f58e84bdfc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2351,8 +2351,7 @@ static void esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
 	mlx5_devcom_unregister_component(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 }
 
-static bool
-esw_check_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
+bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 {
 	if (!MLX5_CAP_ESW(esw->dev, esw_uplink_ingress_acl))
 		return false;
@@ -2452,6 +2451,28 @@ static int esw_offloads_metadata_init(struct mlx5_eswitch *esw)
 	return err;
 }
 
+int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable)
+{
+	int err = 0;
+
+	down_write(&esw->mode_lock);
+	if (esw->mode != MLX5_ESWITCH_NONE) {
+		err = -EBUSY;
+		goto done;
+	}
+	if (!mlx5_esw_vport_match_metadata_supported(esw)) {
+		err = -EOPNOTSUPP;
+		goto done;
+	}
+	if (enable)
+		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
+	else
+		esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
+done:
+	up_write(&esw->mode_lock);
+	return err;
+}
+
 int
 esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
@@ -2673,9 +2694,6 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_metadata;
 
-	if (esw_check_vport_match_metadata_supported(esw))
-		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
-
 	err = esw_offloads_metadata_init(esw);
 	if (err)
 		goto err_metadata;
@@ -2725,7 +2743,6 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 err_vport_metadata:
 	esw_offloads_metadata_uninit(esw);
 err_metadata:
-	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
 	return err;
@@ -2761,7 +2778,6 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 	esw_offloads_steering_cleanup(esw);
 	mapping_destroy(esw->offloads.reg_c0_obj_pool);
 	esw_offloads_metadata_uninit(esw);
-	esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
 	esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
-- 
2.30.2

