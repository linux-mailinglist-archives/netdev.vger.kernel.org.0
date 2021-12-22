Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8924547CB9D
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242122AbhLVDQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58302 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242088AbhLVDQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FDEBB81A61
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6A6C36AE9;
        Wed, 22 Dec 2021 03:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142973;
        bh=SKeiOqRlqnL4lLouGkwaJhXmd/WE3QD0gLjh0vmos1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JM/boP74PAJEHjKznO5BVdfT/s3anOg18upfPUys1fpg37Irxl+g7WGAQVyKKqOWV
         Ni2rGCR6QqYaULaGnBa0bHcFR0DivEIG8hlaJYMvDDjPoxGsB3HA3LrfYQJzQ7aOZ3
         K7SKCzwSbtsHZKw1rVL1opdzeg+vgp2m7c6IjYFEAbowp4sac74X4oaPqJY4S0IUkd
         VuQETEPlVHDh/lpVjT9P/GnbWKKgByaTSB1rYNqYiGcMecNm9eLT79P3vd36PRUgru
         sui28El6tM+FEIxZdLaZsKgcuYacUZRjauC3QOFZRLLGAN3BEmgtlL+pdOmBcHEHOY
         TqKurVKig5GDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 06/14] net/mlx5: Let user configure max_macs generic param
Date:   Tue, 21 Dec 2021 19:15:56 -0800
Message-Id: <20211222031604.14540-7-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, max_macs is taking 70Kbytes of memory per function. This
size is not needed in all use cases, and is critical with large scale.
Hence, allow user to configure the number of max_macs.

For example, to reduce the number of max_macs to 1, execute::
$ devlink dev param set pci/0000:00:0b.0 name max_macs value 1 \
              cmode driverinit
$ devlink dev reload pci/0000:00:0b.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst     |  3 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 67 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 21 ++++++
 3 files changed, 91 insertions(+)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 38089f0aefcf..38e94ed65936 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -23,6 +23,9 @@ Parameters
    * - ``event_eq_size``
      - driverinit
      - The range is between 64 and 4096.
+   * - ``max_macs``
+     - driverinit
+     - The range is between 1 and 2^31. Only power of 2 values are supported.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 37b7600c5545..d1093bb2d436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -773,6 +773,66 @@ static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
 	mlx5_devlink_eth_param_unregister(devlink);
 }
 
+static int mlx5_devlink_max_uc_list_validate(struct devlink *devlink, u32 id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (val.vu32 == 0) {
+		NL_SET_ERR_MSG_MOD(extack, "max_macs value must be greater than 0");
+		return -EINVAL;
+	}
+
+	if (!is_power_of_2(val.vu32)) {
+		NL_SET_ERR_MSG_MOD(extack, "Only power of 2 values are supported for max_macs");
+		return -EINVAL;
+	}
+
+	if (ilog2(val.vu32) >
+	    MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list)) {
+		NL_SET_ERR_MSG_MOD(extack, "max_macs value is out of the supported range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param max_uc_list_param =
+	DEVLINK_PARAM_GENERIC(MAX_MACS, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_max_uc_list_validate);
+
+static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	union devlink_param_value value;
+	int err;
+
+	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
+		return 0;
+
+	err = devlink_param_register(devlink, &max_uc_list_param);
+	if (err)
+		return err;
+
+	value.vu32 = 1 << MLX5_CAP_GEN(dev, log_max_current_uc_list);
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					   value);
+	return 0;
+}
+
+static void
+mlx5_devlink_max_uc_list_param_unregister(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
+		return;
+
+	devlink_param_unregister(devlink, &max_uc_list_param);
+}
+
 #define MLX5_TRAP_DROP(_id, _group_id)					\
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
@@ -832,6 +892,10 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto auxdev_reg_err;
 
+	err = mlx5_devlink_max_uc_list_param_register(devlink);
+	if (err)
+		goto max_uc_list_err;
+
 	err = mlx5_devlink_traps_register(devlink);
 	if (err)
 		goto traps_reg_err;
@@ -842,6 +906,8 @@ int mlx5_devlink_register(struct devlink *devlink)
 	return 0;
 
 traps_reg_err:
+	mlx5_devlink_max_uc_list_param_unregister(devlink);
+max_uc_list_err:
 	mlx5_devlink_auxdev_params_unregister(devlink);
 auxdev_reg_err:
 	devlink_params_unregister(devlink, mlx5_devlink_params,
@@ -852,6 +918,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	mlx5_devlink_max_uc_list_param_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d97c9e86d7b3..b1a82226623c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -484,10 +484,26 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_ODP);
 }
 
+static int max_uc_list_get_devlink_param(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+						 &val);
+	if (!err)
+		return val.vu32;
+	mlx5_core_dbg(dev, "Failed to get param. err = %d\n", err);
+	return err;
+}
+
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
+	int max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -561,6 +577,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	if (MLX5_CAP_GEN(dev, roce_rw_supported))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce, mlx5_is_roce_init_enabled(dev));
 
+	max_uc_list = max_uc_list_get_devlink_param(dev);
+	if (max_uc_list > 0)
+		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_current_uc_list,
+			 ilog2(max_uc_list));
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
-- 
2.33.1

