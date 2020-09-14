Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F6226845F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgINGI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:08:28 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59463 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbgINGIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 02:08:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 14 Sep 2020 09:08:15 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08E68Fwj020941;
        Mon, 14 Sep 2020 09:08:15 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08E68F4x017385;
        Mon, 14 Sep 2020 09:08:15 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08E68F40017384;
        Mon, 14 Sep 2020 09:08:15 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v4 03/15] devlink: Add reload action stats
Date:   Mon, 14 Sep 2020 09:07:50 +0300
Message-Id: <1600063682-17313-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reload action stats to hold the history per reload action type and
limit level.
For example, the number of times fw_activate has been performed on this
device since the driver module was added or if the firmware activation
was performed with or without reset.
Add devlink notification on stats update.

The function devlink_reload_actions_implicit_actions_performed() is
exported to enable also drivers update on reload actions performed,
for example in case firmware activation with reset finished
successfully but was initiated by remote host.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v3 -> v4:
- Renamed reload_actions_cnts to reload_action_stats
- Add devlink notifications on stats update
- Renamed devlink_reload_actions_implicit_actions_performed() and add
  function comment in code
v2 -> v3:
- New patch
---
 include/net/devlink.h |  7 ++++++
 net/core/devlink.c    | 58 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index dddd9ee5b8a9..b4feb92e0269 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -20,6 +20,9 @@
 #include <uapi/linux/devlink.h>
 #include <linux/xarray.h>
 
+#define DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE \
+	(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX * __DEVLINK_RELOAD_ACTION_MAX)
+
 struct devlink_ops;
 
 struct devlink {
@@ -38,6 +41,7 @@ struct devlink {
 	struct list_head trap_policer_list;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
+	u32 reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
@@ -1397,6 +1401,9 @@ void
 devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
 
 bool devlink_is_reload_failed(const struct devlink *devlink);
+void devlink_reload_implicit_actions_performed(struct devlink *devlink,
+					       enum devlink_reload_action_limit_level limit_level,
+					       unsigned long actions_performed);
 
 void devlink_flash_update_begin_notify(struct devlink *devlink);
 void devlink_flash_update_end_notify(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 60aa0c4a3726..cbf746966913 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2981,11 +2981,58 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
+static void
+devlink_reload_action_stats_update(struct devlink *devlink,
+				   enum devlink_reload_action_limit_level limit_level,
+				   unsigned long actions_performed)
+{
+	int stat_idx;
+	int action;
+
+	if (!actions_performed)
+		return;
+
+	if (WARN_ON(limit_level > DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX))
+		return;
+	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
+		if (!test_bit(action, &actions_performed))
+			continue;
+		stat_idx = limit_level * __DEVLINK_RELOAD_ACTION_MAX + action;
+		devlink->reload_action_stats[stat_idx]++;
+	}
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+}
+
+/**
+ *	devlink_reload_implicit_actions_performed - Update devlink on reload actions
+ *	  performed which are not a direct result of devlink reload call.
+ *
+ *	This should be called by a driver after performing reload actions in case it was not
+ *	a result of devlink reload call. For example fw_activate was performed as a result
+ *	of devlink reload triggered fw_activate on another host.
+ *	The motivation for this function is to keep data on reload actions performed on this
+ *	function whether it was done due to direct devlink reload call or not.
+ *
+ *	@devlink: devlink
+ *	@limit_level: reload action limit level
+ *	@actions_performed: bitmask of actions performed
+ */
+void devlink_reload_implicit_actions_performed(struct devlink *devlink,
+					       enum devlink_reload_action_limit_level limit_level,
+					       unsigned long actions_performed)
+{
+	if (!devlink_reload_supported(devlink))
+		return;
+	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
+}
+EXPORT_SYMBOL_GPL(devlink_reload_implicit_actions_performed);
+
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 			  enum devlink_reload_action action,
 			  enum devlink_reload_action_limit_level limit_level,
-			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
+			  struct netlink_ext_ack *extack, unsigned long *actions_performed_out)
 {
+	unsigned long actions_performed;
 	int err;
 
 	if (!devlink->reload_enabled)
@@ -2998,9 +3045,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
 		devlink_reload_netns_change(devlink, dest_net);
 
-	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
+	err = devlink->ops->reload_up(devlink, action, limit_level, extack, &actions_performed);
 	devlink_reload_failed_set(devlink, !!err);
-	return err;
+	if (err)
+		return err;
+	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
+	if (actions_performed_out)
+		*actions_performed_out = actions_performed;
+	return 0;
 }
 
 static int
-- 
2.17.1

