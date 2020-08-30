Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E100E256F13
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 17:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgH3PaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 11:30:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42752 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726618AbgH3P2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 11:28:04 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 30 Aug 2020 18:27:56 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07UFRuTc029653;
        Sun, 30 Aug 2020 18:27:56 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07UFRuXE027847;
        Sun, 30 Aug 2020 18:27:56 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07UFRuFA027846;
        Sun, 30 Aug 2020 18:27:56 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v3 09/14] net/mlx5: Add support for devlink reload action fw activate
Date:   Sun, 30 Aug 2020 18:27:29 +0300
Message-Id: <1598801254-27764-10-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink reload action fw_activate. To activate firmware
image the mlx5 driver resets the firmware and reloads it from flash. If
a new image was stored on flash it will be loaded. Once this reload
command is executed the driver initiates fw sync reset flow, where the
firmware synchronizes all PFs on coming reset and driver reload.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v2 -> v3:
- Return the reload actions done
- Update reload action counters if reset initiated by remote host
v1 -> v2:
- Have fw_activate action instead of fw_reset level
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 63 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 59 +++++++++++++++--
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  1 +
 3 files changed, 109 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e0f1a1a2c6a9..f2f1f4e4ef25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -4,6 +4,7 @@
 #include <devlink.h>
 
 #include "mlx5_core.h"
+#include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
 
@@ -88,14 +89,49 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	return 0;
 }
 
+static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u8 reset_level, reset_type, net_port_alive;
+	int err;
+
+	err = mlx5_reg_mfrl_query(dev, &reset_level, &reset_type);
+	if (err)
+		return err;
+	if (!(reset_level & MLX5_MFRL_REG_RESET_LEVEL3)) {
+		NL_SET_ERR_MSG_MOD(extack, "FW activate requires reboot");
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
+		NL_SET_ERR_MSG_MOD(extack, "FW activate command failed");
+	return err;
+}
+
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
-	mlx5_unload_one(dev, false);
-	return 0;
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		mlx5_unload_one(dev, false);
+		return 0;
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		return mlx5_devlink_reload_fw_activate(devlink, extack);
+	default:
+		/* Unsupported action should not get to this function */
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
 }
 
 static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
@@ -104,11 +140,21 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
-	err = mlx5_load_one(dev, false);
-	if (err)
-		return err;
-	if (actions_done)
-		*actions_done = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		err = mlx5_load_one(dev, false);
+		if (err)
+			return err;
+		/* On fw_activate action, also driver is reloaded and reinit done */
+		if (actions_done)
+			*actions_done = BIT(action) | BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
+		break;
+	default:
+		/* Unsupported action should not get to this function */
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
@@ -126,7 +172,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
-	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+				    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 61237f4836cc..1f9ad1f38d92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -5,6 +5,7 @@
 
 enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
+	MLX5_FW_RESET_FLAGS_PENDING_COMP
 };
 
 struct mlx5_fw_reset {
@@ -17,6 +18,8 @@ struct mlx5_fw_reset {
 	struct work_struct reset_abort_work;
 	unsigned long reset_flags;
 	struct timer_list timer;
+	struct completion done;
+	int ret;
 };
 
 static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
@@ -53,7 +56,14 @@ int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 
 int mlx5_fw_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel)
 {
-	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, reset_type_sel, 0, true);
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	int err;
+
+	set_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
+	err =  mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, reset_type_sel, 0, true);
+	if (err)
+		clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
+	return err;
 }
 
 int mlx5_fw_set_live_patch(struct mlx5_core_dev *dev)
@@ -66,19 +76,35 @@ static int mlx5_fw_set_reset_sync_ack(struct mlx5_core_dev *dev)
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 1, false);
 }
 
+static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	/* if this is the driver that initiated the fw reset, devlink completed the reload */
+	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
+		complete(&fw_reset->done);
+	} else {
+		mlx5_load_one(dev, false);
+		devlink_reload_actions_cnts_update(priv_to_devlink(dev),
+						   BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+						   BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
+	}
+}
+
 static void mlx5_sync_reset_reload_work(struct work_struct *work)
 {
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      reset_reload_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
+	int err;
 
 	mlx5_enter_error_state(dev, true);
 	mlx5_unload_one(dev, false);
-	if (mlx5_health_wait_pci_up(dev)) {
+	err = mlx5_health_wait_pci_up(dev);
+	if (err)
 		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
-		return;
-	}
-	mlx5_load_one(dev, false);
+	fw_reset->ret = err;
+	mlx5_fw_reset_complete_reload(dev);
 }
 
 static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
@@ -264,7 +290,8 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 done:
 	if (err)
 		mlx5_start_health_poll(dev);
-	mlx5_load_one(dev, false);
+	fw_reset->ret = err;
+	mlx5_fw_reset_complete_reload(dev);
 }
 
 static void mlx5_sync_reset_abort_event(struct work_struct *work)
@@ -313,6 +340,25 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 	return NOTIFY_OK;
 }
 
+#define MLX5_FW_RESET_TIMEOUT_MSEC 5000
+int mlx5_fw_wait_fw_reset_done(struct mlx5_core_dev *dev)
+{
+	unsigned long timeout = msecs_to_jiffies(MLX5_FW_RESET_TIMEOUT_MSEC);
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	int err;
+
+	if (!wait_for_completion_timeout(&fw_reset->done, timeout)) {
+		mlx5_core_warn(dev, "FW sync reset timeout after %d seconds\n",
+			       MLX5_FW_RESET_TIMEOUT_MSEC / 1000);
+		err = -ETIMEDOUT;
+		goto out;
+	}
+	err = fw_reset->ret;
+out:
+	clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
+	return err;
+}
+
 int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = kzalloc(sizeof(*fw_reset), GFP_KERNEL);
@@ -336,6 +382,7 @@ int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
 	MLX5_NB_INIT(&fw_reset->nb, fw_reset_event_notifier, GENERAL_EVENT);
 	mlx5_eq_notifier_register(dev, &fw_reset->nb);
 
+	init_completion(&fw_reset->done);
 	return 0;
 }
 
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

