Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A7722EAD8
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgG0LHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:07:44 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40708 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728542AbgG0LGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6DXB022246;
        Mon, 27 Jul 2020 14:06:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6D2L002402;
        Mon, 27 Jul 2020 14:06:13 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6Dh9002401;
        Mon, 27 Jul 2020 14:06:13 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 10/13] net/mlx5: Add devlink param enable_remote_dev_reset support
Date:   Mon, 27 Jul 2020 14:02:30 +0300
Message-Id: <1595847753-2234-11-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
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
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 29 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 12 ++++++++
 include/linux/mlx5/driver.h                   |  1 +
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 905d55cab4c3..a81204b3dd7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -275,6 +275,32 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
 }
 #endif
 
+static int mlx5_devlink_enable_remote_dev_reset_set(struct devlink *devlink, u32 id,
+						    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_core_health *health;
+
+	health = &dev->priv.health;
+	if (ctx->val.vbool)
+		clear_bit(MLX5_HEALTH_RESET_FLAGS_NACK_RESET_REQUEST, &health->reset_flags);
+	else
+		set_bit(MLX5_HEALTH_RESET_FLAGS_NACK_RESET_REQUEST, &health->reset_flags);
+	return 0;
+}
+
+static int mlx5_devlink_enable_remote_dev_reset_get(struct devlink *devlink, u32 id,
+						    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_core_health *health;
+
+	health = &dev->priv.health;
+	ctx->val.vbool = !test_bit(MLX5_HEALTH_RESET_FLAGS_NACK_RESET_REQUEST,
+				   &health->reset_flags);
+	return 0;
+}
+
 static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
@@ -290,6 +316,9 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     NULL, NULL,
 			     mlx5_devlink_large_group_num_validate),
 #endif
+	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      mlx5_devlink_enable_remote_dev_reset_get,
+			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index f95df226b915..45fdecbadf52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -61,12 +61,24 @@ static int mlx5_fw_set_reset_sync_ack(struct mlx5_core_dev *dev)
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 1, false);
 }
 
+static int mlx5_fw_set_reset_sync_nack(struct mlx5_core_dev *dev)
+{
+	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 2, false);
+}
+
 static void mlx5_sync_reset_request_event(struct work_struct *work)
 {
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      reset_request_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
+	int err;
 
+	if (test_bit(MLX5_HEALTH_RESET_FLAGS_NACK_RESET_REQUEST, &dev->priv.health.reset_flags)) {
+		err = mlx5_fw_set_reset_sync_nack(dev);
+		mlx5_core_warn(dev, "PCI Sync FW Update Reset Nack %s",
+			       err ? "Failed" : "Sent");
+		return;
+	}
 	mlx5_health_set_reset_requested_mode(dev);
 	mlx5_reload_health_poll_timer(dev);
 	if (mlx5_fw_set_reset_sync_ack(dev))
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 27b6086f3095..4999dff9dc8c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -426,6 +426,7 @@ struct mlx5_sq_bfreg {
 enum {
 	MLX5_HEALTH_RESET_FLAGS_RESET_REQUESTED,
 	MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY,
+	MLX5_HEALTH_RESET_FLAGS_NACK_RESET_REQUEST,
 };
 
 struct mlx5_core_health {
-- 
2.17.1

