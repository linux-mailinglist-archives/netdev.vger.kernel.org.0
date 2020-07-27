Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB16F22EACA
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgG0LHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:07:13 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40718 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728547AbgG0LGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6EmX022254;
        Mon, 27 Jul 2020 14:06:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6EuV002406;
        Mon, 27 Jul 2020 14:06:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6Ex2002405;
        Mon, 27 Jul 2020 14:06:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 12/13] net/mlx5: Add support for devlink reload level live patch
Date:   Mon, 27 Jul 2020 14:02:32 +0300
Message-Id: <1595847753-2234-13-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink reload level fw_live_patch which does live
patching to firmware.
The driver checks if the firmware is capable of handling the pending
firmware changes as a live patch. If it is then it triggers
fw_live_patch flow.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index a81204b3dd7c..804e1e7b25cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -115,6 +115,29 @@ static int mlx5_devlink_trigger_fw_reset(struct devlink *devlink, struct netlink
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
 				    enum devlink_reload_level level, struct netlink_ext_ack *extack)
 {
@@ -126,6 +149,8 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		return 0;
 	case DEVLINK_RELOAD_LEVEL_FW_RESET:
 		return mlx5_devlink_trigger_fw_reset(devlink, extack);
+	case DEVLINK_RELOAD_LEVEL_FW_LIVE_PATCH:
+		return mlx5_devlink_trigger_fw_live_patch(devlink, extack);
 	default:
 		/* Unsupported level should not get to this function */
 		WARN_ON(1);
@@ -142,6 +167,8 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_l
 	case DEVLINK_RELOAD_LEVEL_DRIVER:
 	case DEVLINK_RELOAD_LEVEL_FW_RESET:
 		return mlx5_load_one(dev, false);
+	case DEVLINK_RELOAD_LEVEL_FW_LIVE_PATCH:
+		return 0;
 	default:
 		/* Unsupported level should not get to this function */
 		WARN_ON(1);
@@ -163,7 +190,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
 	.supported_reload_levels = BIT(DEVLINK_RELOAD_LEVEL_DRIVER) |
-				   BIT(DEVLINK_RELOAD_LEVEL_FW_RESET),
+				   BIT(DEVLINK_RELOAD_LEVEL_FW_RESET) |
+				   BIT(DEVLINK_RELOAD_LEVEL_FW_LIVE_PATCH),
 	.default_reload_level = DEVLINK_RELOAD_LEVEL_DRIVER,
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
-- 
2.17.1

