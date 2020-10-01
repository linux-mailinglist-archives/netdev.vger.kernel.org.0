Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B035E2800AF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgJAOAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:00:34 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36660 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732459AbgJAOA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:26 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0Ppu002170;
        Thu, 1 Oct 2020 17:00:25 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0PYT011181;
        Thu, 1 Oct 2020 17:00:25 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0PTE011180;
        Thu, 1 Oct 2020 17:00:25 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 11/16] net/mlx5: Add support for devlink reload action fw activate
Date:   Thu,  1 Oct 2020 16:59:14 +0300
Message-Id: <1601560759-11030-12-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink reload action fw_activate. To activate firmware
image the mlx5 driver resets the firmware and reloads it from flash. If
a new image was stored on flash it will be loaded. Once this reload
command is executed the driver initiates fw sync reset flow, where the
firmware synchronizes all PFs on coming reset and driver reload.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
RFCv4 -> RFCv5:
- Add remote actions stats
- If devlink reload is not supported, show only remote_stats
RFCv3 -> RFCv4:
- Renamed DEVLINK_ATTR_RELOAD_ACTION_CNT to
  DEVLINK_ATTR_RELOAD_ACTION_STAT
- Add stats per action per limit level
RFCv2 -> RFCv3:
- Add reload actions counters instead of supported reload actions
  (reload actions counters are only for supported action so no need for
   both)
RFCv1 -> RFCv2:
- Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
- Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
- Have actions instead of levels
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 59 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 59 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  1 +
 3 files changed, 108 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 47f3dbc80c7c..13153454cc05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -4,6 +4,7 @@
 #include <devlink.h>
 
 #include "mlx5_core.h"
+#include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
 
@@ -84,6 +85,32 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	return 0;
 }
 
+static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u8 reset_level, reset_type, net_port_alive;
+	int err;
+
+	err = mlx5_fw_reset_query(dev, &reset_level, &reset_type);
+	if (err)
+		return err;
+	if (!(reset_level & MLX5_MFRL_REG_RESET_LEVEL3)) {
+		NL_SET_ERR_MSG_MOD(extack, "FW activate requires reboot");
+		return -EINVAL;
+	}
+
+	net_port_alive = !!(reset_type & MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE);
+	err = mlx5_fw_reset_set_reset_sync(dev, net_port_alive);
+	if (err)
+		goto out;
+
+	err = mlx5_fw_reset_wait_reset_done(dev);
+out:
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "FW activate command failed");
+	return err;
+}
+
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
 				    enum devlink_reload_limit limit,
@@ -91,8 +118,17 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
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
@@ -101,8 +137,20 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
-	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-	return mlx5_load_one(dev, false);
+	*actions_performed = BIT(action);
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		/* On fw_activate action, also driver is reloaded and reinit performed */
+		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
+		return mlx5_load_one(dev, false);
+	default:
+		/* Unsupported action should not get to this function */
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
 }
 
 static const struct devlink_ops mlx5_devlink_ops = {
@@ -118,7 +166,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
-	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 56ae72e016f1..f5ffb6fc55c3 100644
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
@@ -58,7 +61,14 @@ int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 
 int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel)
 {
-	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, reset_type_sel, 0, true);
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	int err;
+
+	set_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
+	err = mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, reset_type_sel, 0, true);
+	if (err)
+		clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
+	return err;
 }
 
 int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev)
@@ -66,19 +76,35 @@ int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev)
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL0, 0, 0, false);
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
+		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
+							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
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
@@ -269,7 +295,8 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	mlx5_enter_error_state(dev, true);
 	mlx5_unload_one(dev, false);
 done:
-	mlx5_load_one(dev, false);
+	fw_reset->ret = err;
+	mlx5_fw_reset_complete_reload(dev);
 }
 
 static void mlx5_sync_reset_abort_event(struct work_struct *work)
@@ -318,6 +345,25 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 	return NOTIFY_OK;
 }
 
+#define MLX5_FW_RESET_TIMEOUT_MSEC 5000
+int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
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
 void mlx5_fw_reset_events_start(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
@@ -351,6 +397,7 @@ int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
 	INIT_WORK(&fw_reset->reset_abort_work, mlx5_sync_reset_abort_event);
 
+	init_completion(&fw_reset->done);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index a231f7848a8f..e7937447ce1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -10,6 +10,7 @@ int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel);
 int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev);
 
+int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_events_start(struct mlx5_core_dev *dev);
 void mlx5_fw_reset_events_stop(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_init(struct mlx5_core_dev *dev);
-- 
2.18.2

