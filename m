Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E424638B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgHQJjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:39:05 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55860 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728271AbgHQJiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:38:18 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 17 Aug 2020 12:38:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07H9cEpu011437;
        Mon, 17 Aug 2020 12:38:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07H9cEUf003250;
        Mon, 17 Aug 2020 12:38:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07H9cEqU003249;
        Mon, 17 Aug 2020 12:38:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v2 12/13] net/mlx5: Add support for devlink reload action live patch
Date:   Mon, 17 Aug 2020 12:37:51 +0300
Message-Id: <1597657072-3130-13-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink reload action fw_live_patch which does live
patching to firmware.
The driver checks if the firmware is capable of handling the pending
firmware changes as a live patch. If it is then it triggers
fw_live_patch flow.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v1 -> v2:
- Have fw_live_patch action instead of level
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d975f5bd7394..a62281cfc084 100644
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
 				    struct netlink_ext_ack *extack)
@@ -127,6 +150,8 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		return 0;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		return mlx5_devlink_reload_fw_activate(devlink, extack);
+	case DEVLINK_RELOAD_ACTION_FW_LIVE_PATCH:
+		return mlx5_devlink_trigger_fw_live_patch(devlink, extack);
 	default:
 		/* Unsupported action should not get to this function */
 		WARN_ON(1);
@@ -143,6 +168,8 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		return mlx5_load_one(dev, false);
+	case DEVLINK_RELOAD_ACTION_FW_LIVE_PATCH:
+		return 0;
 	default:
 		/* Unsupported action should not get to this function */
 		WARN_ON(1);
@@ -164,7 +191,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
 	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
-				    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
+				    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE) |
+				    BIT(DEVLINK_RELOAD_ACTION_FW_LIVE_PATCH),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
-- 
2.17.1

