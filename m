Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CE12701D4
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgIRQPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:15:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55242 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726375AbgIRQN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:13:57 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 18 Sep 2020 19:07:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08IG7Be4025162;
        Fri, 18 Sep 2020 19:07:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08IG7BGB031171;
        Fri, 18 Sep 2020 19:07:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08IG7BHx031170;
        Fri, 18 Sep 2020 19:07:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v5 12/15] net/mlx5: Add devlink param enable_remote_dev_reset support
Date:   Fri, 18 Sep 2020 19:06:48 +0300
Message-Id: <1600445211-31078-13-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enable_remote_dev_reset devlink param flags that the host admin
allows resets by other hosts. In case it is cleared mlx5 host PF driver
will send NACK on pci sync for firmware update reset request and the
command will fail.
By default enable_remote_dev_reset parameter is true, so pci sync for
firmware update reset is enabled.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v1 -> v2:
- Have MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST instead of
  MLX5_HEALTH_RESET_FLAGS_NACK_RESET_REQUEST
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 21 +++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 30 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  2 ++
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 9b95434873ed..d2e7b52619cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -284,6 +284,24 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
 }
 #endif
 
+static int mlx5_devlink_enable_remote_dev_reset_set(struct devlink *devlink, u32 id,
+						    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	mlx5_fw_enable_remote_dev_reset_set(dev, ctx->val.vbool);
+	return 0;
+}
+
+static int mlx5_devlink_enable_remote_dev_reset_get(struct devlink *devlink, u32 id,
+						    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	ctx->val.vbool = mlx5_fw_enable_remote_dev_reset_get(dev);
+	return 0;
+}
+
 static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
@@ -299,6 +317,9 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     NULL, NULL,
 			     mlx5_devlink_large_group_num_validate),
 #endif
+	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      mlx5_devlink_enable_remote_dev_reset_get,
+			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 5519af94feb6..95a02e0e3a41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -5,6 +5,7 @@
 
 enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
+	MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
 	MLX5_FW_RESET_FLAGS_PENDING_COMP
 };
 
@@ -22,6 +23,23 @@ struct mlx5_fw_reset {
 	int ret;
 };
 
+void mlx5_fw_enable_remote_dev_reset_set(struct mlx5_core_dev *dev, bool enable)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	if (enable)
+		clear_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
+	else
+		set_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
+}
+
+bool mlx5_fw_enable_remote_dev_reset_get(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	return !test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
+}
+
 static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
 			     u8 reset_type_sel, u8 sync_resp, bool sync_start)
 {
@@ -76,6 +94,11 @@ static int mlx5_fw_set_reset_sync_ack(struct mlx5_core_dev *dev)
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 1, false);
 }
 
+static int mlx5_fw_set_reset_sync_nack(struct mlx5_core_dev *dev)
+{
+	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 2, false);
+}
+
 static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
@@ -170,7 +193,14 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      reset_request_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
+	int err;
 
+	if (test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags)) {
+		err = mlx5_fw_set_reset_sync_nack(dev);
+		mlx5_core_warn(dev, "PCI Sync FW Update Reset Nack %s",
+			       err ? "Failed" : "Sent");
+		return;
+	}
 	mlx5_sync_reset_set_reset_requested(dev);
 	if (mlx5_fw_set_reset_sync_ack(dev))
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack Failed.\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index d7ee951a2258..fd558dfe93fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -6,6 +6,8 @@
 
 #include "mlx5_core.h"
 
+void mlx5_fw_enable_remote_dev_reset_set(struct mlx5_core_dev *dev, bool enable);
+bool mlx5_fw_enable_remote_dev_reset_get(struct mlx5_core_dev *dev);
 int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_type);
 int mlx5_fw_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel);
 int mlx5_fw_set_live_patch(struct mlx5_core_dev *dev);
-- 
2.17.1

