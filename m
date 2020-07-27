Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E304022EADC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgG0LHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:07:52 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40700 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728531AbgG0LGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6DVL022240;
        Mon, 27 Jul 2020 14:06:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6DZ8002398;
        Mon, 27 Jul 2020 14:06:13 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6Dpb002397;
        Mon, 27 Jul 2020 14:06:13 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 08/13] net/mlx5: Add support for devlink reload level fw reset
Date:   Mon, 27 Jul 2020 14:02:28 +0300
Message-Id: <1595847753-2234-9-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink reload level fw_reset which does firmware reset
and driver entities re-instantiation. Once this reload command is
executed the driver initiates fw sync reset flow, where the firmware
synchronizes all PFs on coming reset and driver's entities
re-instantiation.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 53 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 14 +++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  1 +
 3 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 5424e31a0f45..905d55cab4c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -4,6 +4,7 @@
 #include <devlink.h>
 
 #include "mlx5_core.h"
+#include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
 
@@ -88,13 +89,48 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	return 0;
 }
 
+static int mlx5_devlink_trigger_fw_reset(struct devlink *devlink, struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u8 reset_level, reset_type, net_port_alive;
+	int err;
+
+	err = mlx5_reg_mfrl_query(dev, &reset_level, &reset_type);
+	if (err)
+		return err;
+	if (!(reset_level & MLX5_MFRL_REG_RESET_LEVEL3)) {
+		NL_SET_ERR_MSG_MOD(extack, "FW reset requires reboot");
+		return -EINVAL;
+	}
+
+	net_port_alive = !!(reset_type & MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE);
+	err = mlx5_fw_set_reset_sync(dev, net_port_alive);
+	if (err)
+		goto out;
+
+	err = mlx5_fw_wait_fw_reset_done(dev);
+out:
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "FW reset command failed");
+	return err;
+}
+
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_level level, struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
-	mlx5_unload_one(dev, false);
-	return 0;
+	switch (level) {
+	case DEVLINK_RELOAD_LEVEL_DRIVER:
+		mlx5_unload_one(dev, false);
+		return 0;
+	case DEVLINK_RELOAD_LEVEL_FW_RESET:
+		return mlx5_devlink_trigger_fw_reset(devlink, extack);
+	default:
+		/* Unsupported level should not get to this function */
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
 }
 
 static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_level level,
@@ -102,7 +138,15 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_l
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
-	return mlx5_load_one(dev, false);
+	switch (level) {
+	case DEVLINK_RELOAD_LEVEL_DRIVER:
+	case DEVLINK_RELOAD_LEVEL_FW_RESET:
+		return mlx5_load_one(dev, false);
+	default:
+		/* Unsupported level should not get to this function */
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
 }
 
 static const struct devlink_ops mlx5_devlink_ops = {
@@ -118,7 +162,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
-	.supported_reload_levels = BIT(DEVLINK_RELOAD_LEVEL_DRIVER),
+	.supported_reload_levels = BIT(DEVLINK_RELOAD_LEVEL_DRIVER) |
+				   BIT(DEVLINK_RELOAD_LEVEL_FW_RESET),
 	.default_reload_level = DEVLINK_RELOAD_LEVEL_DRIVER,
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index e665080e9a4e..f95df226b915 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -239,6 +239,20 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 	return NOTIFY_OK;
 }
 
+#define MLX5_FW_RESET_TIMEOUT_MSEC 5000
+int mlx5_fw_wait_fw_reset_done(struct mlx5_core_dev *dev)
+{
+	unsigned long timeout = msecs_to_jiffies(MLX5_FW_RESET_TIMEOUT_MSEC);
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	if (!wait_for_completion_timeout(&fw_reset->done, timeout)) {
+		mlx5_core_warn(dev, "FW sync reset timeout after %d seconds\n",
+			       MLX5_FW_RESET_TIMEOUT_MSEC / 1000);
+		return -ETIMEDOUT;
+	}
+	return fw_reset->ret;
+}
+
 int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = kzalloc(sizeof(*fw_reset), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index 278f538ea92a..d7ee951a2258 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -10,6 +10,7 @@ int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 int mlx5_fw_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel);
 int mlx5_fw_set_live_patch(struct mlx5_core_dev *dev);
 
+int mlx5_fw_wait_fw_reset_done(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_events_cleanup(struct mlx5_core_dev *dev);
 
-- 
2.17.1

