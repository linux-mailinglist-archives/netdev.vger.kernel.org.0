Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706012800CB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732773AbgJAOCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:02:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36680 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732470AbgJAOA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:26 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0QsG002335;
        Thu, 1 Oct 2020 17:00:26 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0QIS011189;
        Thu, 1 Oct 2020 17:00:26 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0Q4n011188;
        Thu, 1 Oct 2020 17:00:26 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 15/16] net/mlx5: Add support for devlink reload limit no reset
Date:   Thu,  1 Oct 2020 16:59:18 +0300
Message-Id: <1601560759-11030-16-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink reload action fw_activate with reload limit
no_reset which does firmware live patching, updating the firmware image
without reset, no downtime and no configuration lose. The driver checks
if the firmware is capable of handling the pending firmware changes as a
live patch. If it is then it triggers firmware live patching flow.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
RFCv5 -> v1:
- Renamed reload_action_limit_level to reload_limit
RFCv3 -> RFCv4:
- Have action fw_activate with limit level no_reset instead of action
  fw_activate_no_reset
RFCv2 -> RFCv3:
- Replace fw_live_patch action by fw_activate_no_reset
RFCv1 -> RFCv2:
- Have fw_live_patch action instead of level
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 7b304227ad57..db59933a7fe1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -111,6 +111,29 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	return err;
 }
 
+static int mlx5_devlink_trigger_fw_live_patch(struct devlink *devlink,
+					      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u8 reset_level;
+	int err;
+
+	err = mlx5_fw_reset_query(dev, &reset_level, NULL);
+	if (err)
+		return err;
+	if (!(reset_level & MLX5_MFRL_REG_RESET_LEVEL0)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FW upgrade to the stored FW can't be done by FW live patching");
+		return -EINVAL;
+	}
+
+	err = mlx5_fw_reset_set_live_patch(dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
 				    enum devlink_reload_limit limit,
@@ -123,6 +146,8 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		mlx5_unload_one(dev, false);
 		return 0;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
+			return mlx5_devlink_trigger_fw_live_patch(devlink, extack);
 		return mlx5_devlink_reload_fw_activate(devlink, extack);
 	default:
 		/* Unsupported action should not get to this function */
@@ -140,7 +165,10 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		return mlx5_load_one(dev, false);
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
+			break;
 		/* On fw_activate action, also driver is reloaded and reinit performed */
 		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 		return mlx5_load_one(dev, false);
@@ -168,6 +196,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.info_get = mlx5_devlink_info_get,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
+	.reload_limits = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
-- 
2.18.2

