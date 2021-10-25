Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E65143A518
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbhJYU5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233868AbhJYU5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:57:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3E4960EDF;
        Mon, 25 Oct 2021 20:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195279;
        bh=BZSpelBA9ol1yji9OLMmqD9G2bQR49Twp2wnlPJlSFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjEuEjF2lAnbb6n3x5Ch/Bg8HVyarLez+F3LaK8iq4C6ySl4X8fkoBlFY+XDJiM1e
         wsQPK2W17ppu+IM/lfTgCcK2jVZCrzvqeXsMH7fkhhxJRnYX+nRfHPv0cw/mD1sjcq
         NNv9WLlyIxX0cTColzLzCaIo71V9tAc9i8ZzTLEpjNfEUZ5O9fRnf8TcBCHHx3bzpN
         qbhQg0IaAEGo2z9WAs3BN0dzc1DmOtW+BNYNIKcrEYcsmtMF1fsPa/LZwuBzcS0LkA
         74VQrTmPWyzqQ6NjO0V6TZhN/HVjKUNGO9np8HWzVRCrdOd9ZU0CjXX60p3HWEcmxJ
         In5nyR30U6iwQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/14] net/mlx5: Let user configure max_macs param
Date:   Mon, 25 Oct 2021 13:54:29 -0700
Message-Id: <20211025205431.365080-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
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
 Documentation/networking/devlink/mlx5.rst     |  4 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 69 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 18 +++++
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 4 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 5b77863f9c88..d467e770906e 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -14,8 +14,12 @@ Parameters
 
    * - Name
      - Mode
+     - Validation
    * - ``enable_roce``
      - driverinit
+   * - ``max_macs``
+     - driverinit
+     - The range is between 1 and 2^31. Only power of 2 values are supported.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1c98652b244a..fc78c745ead1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -752,6 +752,68 @@ static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
 	mlx5_devlink_eth_param_unregister(devlink);
 }
 
+static int mlx5_devlink_max_uc_list_validate(struct devlink *devlink, u32 id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	/* At least one unicast mac is needed */
+	if (val.vu32 == 0) {
+		NL_SET_ERR_MSG_MOD(extack, "max_macs value must be greater than 0");
+		return -EINVAL;
+	}
+	/* Check if its power of 2 or not */
+	if (!is_power_of_2(val.vu32)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only power of 2 values are supported for max_macs");
+		return -EOPNOTSUPP;
+	}
+
+	if (ilog2(val.vu32) >
+	    MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list)) {
+		NL_SET_ERR_MSG_MOD(extack, "max_macs value is out of the supported range");
+		return -EOPNOTSUPP;
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
+	if (!MLX5_CAP_GEN(dev, log_max_current_uc_list_wr_supported))
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
+	if (!MLX5_CAP_GEN(dev, log_max_current_uc_list_wr_supported))
+		return;
+
+	devlink_param_unregister(devlink, &max_uc_list_param);
+}
+
 #define MLX5_TRAP_DROP(_id, _group_id)					\
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
@@ -815,11 +877,17 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	err = mlx5_devlink_max_uc_list_param_register(devlink);
+	if (err)
+		goto uc_list_reg_err;
+
 	if (!mlx5_core_is_mp_slave(dev))
 		devlink_set_features(devlink, DEVLINK_F_RELOAD);
 
 	return 0;
 
+uc_list_reg_err:
+	mlx5_devlink_traps_unregister(devlink);
 traps_reg_err:
 	mlx5_devlink_auxdev_params_unregister(devlink);
 auxdev_reg_err:
@@ -830,6 +898,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	mlx5_devlink_max_uc_list_param_unregister(devlink);
 	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 96fdbc0c87bf..079ee9e8da10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -484,10 +484,23 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
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
+	return err ? 0 : val.vu32;
+}
+
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
+	u32 max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -561,6 +574,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	if (MLX5_CAP_GEN(dev, roce_rw_supported))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce, mlx5_is_roce_init_enabled(dev));
 
+	max_uc_list = max_uc_list_get_devlink_param(dev);
+	if (max_uc_list)
+		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_current_uc_list,
+			 ilog2(max_uc_list));
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 746381eccccf..97465d00de9d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1603,7 +1603,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         ext_stride_num_range[0x1];
 	u8         roce_rw_supported[0x1];
-	u8         reserved_at_3a2[0x1];
+	u8         log_max_current_uc_list_wr_supported[0x1];
 	u8         log_max_stride_sz_rq[0x5];
 	u8         reserved_at_3a8[0x3];
 	u8         log_min_stride_sz_rq[0x5];
-- 
2.31.1

