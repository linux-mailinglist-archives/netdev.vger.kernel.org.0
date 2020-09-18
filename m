Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCFB2701CF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIRQOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:14:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55241 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726392AbgIRQN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:13:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 18 Sep 2020 19:07:12 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08IG7CUp025168;
        Fri, 18 Sep 2020 19:07:12 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08IG7Bi0031175;
        Fri, 18 Sep 2020 19:07:12 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08IG7Bvk031174;
        Fri, 18 Sep 2020 19:07:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v5 14/15] net/mlx5: Add support for devlink reload action limit level no reset
Date:   Fri, 18 Sep 2020 19:06:50 +0300
Message-Id: <1600445211-31078-15-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink reload action fw_activate with limit level
no_reset which does firmware live patching, updating the firmware image
without reset, no downtime and no configuration lose. The driver checks
if the firmware is capable of handling the pending firmware changes as a
live patch. If it is then it triggers firmware live patching flow.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v3 -> v4:
- Have action fw_activate with limit level no_reset instead of action
  fw_activate_no_reset
v2 -> v3:
- Replace fw_live_patch action by fw_activate_no_reset
v1 -> v2:
- Have fw_live_patch action instead of level
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 37 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d2e7b52619cc..02fe57fb507f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -115,6 +115,29 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	return err;
 }
 
+static int mlx5_devlink_trigger_fw_live_patch(struct devlink *devlink,
+					      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u8 reset_level;
+	int err;
+
+	err = mlx5_reg_mfrl_query(dev, &reset_level, NULL);
+	if (err)
+		return err;
+	if (!(reset_level & MLX5_MFRL_REG_RESET_LEVEL0)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FW upgrade to the stored FW can't be done by FW live patching");
+		return -EINVAL;
+	}
+
+	err = mlx5_fw_set_live_patch(dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
 				    enum devlink_reload_action_limit_level limit_level,
@@ -122,11 +145,19 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
+	if (limit_level == DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET &&
+	    action != DEVLINK_RELOAD_ACTION_FW_ACTIVATE) {
+		NL_SET_ERR_MSG_MOD(extack, "Requested limit level is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
 		mlx5_unload_one(dev, false);
 		return 0;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		if (limit_level == DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET)
+			return mlx5_devlink_trigger_fw_live_patch(devlink, extack);
 		return mlx5_devlink_reload_fw_activate(devlink, extack);
 	default:
 		/* Unsupported action should not get to this function */
@@ -145,7 +176,10 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		return mlx5_load_one(dev, false);
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		if (limit_level == DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET)
+			break;
 		/* On fw_activate action, also driver is reloaded and reinit performed */
 		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 		return mlx5_load_one(dev, false);
@@ -173,7 +207,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.info_get = mlx5_devlink_info_get,
 	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 				    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
-	.supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),
+	.supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE) |
+						BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
-- 
2.17.1

