Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C43242FF74
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbhJPAlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239315AbhJPAlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C6F461212;
        Sat, 16 Oct 2021 00:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344746;
        bh=i6TwVZ7Mq9k72hxf72QH6hlF04dWKTgfmw+Na3iVeNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1gpLV0RKWYDc1nfAYH4H65xI60mrvk/86enzjIuWX3C8kbWthOQIe1Ms+fjyIEqR
         cmOYBsCbbtjx2gNWuWIAEoL/TiZlVhuNpW4CmxZ5+bh96J6/kbM1NZ+036uhYFaGqe
         txtj0n1UmCU2xHzDgGwAedvLRoXHcuJxH4FXrTgsUSkry/ViP5mJY6SRLnumc0wgH6
         9S3WMRu+zG78k1XQjvMFDvXB1yF9KtzilIf1xpfp1raM7X27e3kHlABRv1y/vR1vYP
         jxE0N+aozz+u3jK4re1piQidU8gc+FSeCRdnDTS4cCV0pxDDDyEXrNR+4Zu+K0C1Dn
         yW8iMEtMU7Tbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/13] net/mlx5: Disable roce at HCA level
Date:   Fri, 15 Oct 2021 17:38:55 -0700
Message-Id: <20211016003902.57116-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, when a user disables roce via the devlink param, this change
isn't passed down to the device.
If device allows disabling RoCE at device level, make use of it. This
instructs the device to skip memory allocations related to RoCE
functionality which otherwise is done by the device.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 25 ++++++++++++++++++-
 include/linux/mlx5/driver.h                   |  9 ++++---
 include/linux/mlx5/mlx5_ifc.h                 |  3 ++-
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index a85341a41cd0..1c98652b244a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -454,7 +454,8 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	bool new_state = val.vbool;
 
-	if (new_state && !MLX5_CAP_GEN(dev, roce)) {
+	if (new_state && !MLX5_CAP_GEN(dev, roce) &&
+	    !MLX5_CAP_GEN(dev, roce_rw_supported)) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 75d284272119..47d92fb459ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -558,15 +558,38 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, num_total_dynamic_vf_msix,
 			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
 
+	if (MLX5_CAP_GEN(dev, roce_rw_supported))
+		MLX5_SET(cmd_hca_cap, set_hca_cap, roce, mlx5_is_roce_init_enabled(dev));
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
+/* Cached MLX5_CAP_GEN(dev, roce) can be out of sync this early in the
+ * boot process.
+ * In case RoCE cap is writable in FW and user/devlink requested to change the
+ * cap, we are yet to query the final state of the above cap.
+ * Hence, the need for this function.
+ *
+ * Returns
+ * True:
+ * 1) RoCE cap is read only in FW and already disabled
+ * OR:
+ * 2) RoCE cap is writable in FW and user/devlink requested it off.
+ *
+ * In any other case, return False.
+ */
+static bool is_roce_fw_disabled(struct mlx5_core_dev *dev)
+{
+	return (MLX5_CAP_GEN(dev, roce_rw_supported) && !mlx5_is_roce_init_enabled(dev)) ||
+		(!MLX5_CAP_GEN(dev, roce_rw_supported) && !MLX5_CAP_GEN(dev, roce));
+}
+
 static int handle_hca_cap_roce(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	void *set_hca_cap;
 	int err;
 
-	if (!MLX5_CAP_GEN(dev, roce))
+	if (is_roce_fw_disabled(dev))
 		return 0;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_ROCE);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index fb06e8870aee..7c8b5f06c2cd 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1251,11 +1251,12 @@ static inline bool mlx5_is_roce_init_enabled(struct mlx5_core_dev *dev)
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	union devlink_param_value val;
+	int err;
 
-	devlink_param_driverinit_value_get(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
-					   &val);
-	return val.vbool;
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+						 &val);
+	return err ? MLX5_CAP_GEN(dev, roce) : val.vbool;
 }
 
 #endif /* MLX5_DRIVER_H */
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b8bff5109656..c614ad1da44d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1588,7 +1588,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_tis_per_sq[0x5];
 
 	u8         ext_stride_num_range[0x1];
-	u8         reserved_at_3a1[0x2];
+	u8         roce_rw_supported[0x1];
+	u8         reserved_at_3a2[0x1];
 	u8         log_max_stride_sz_rq[0x5];
 	u8         reserved_at_3a8[0x3];
 	u8         log_min_stride_sz_rq[0x5];
-- 
2.31.1

