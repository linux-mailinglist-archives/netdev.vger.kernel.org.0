Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66062701B9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIRQOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:14:08 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55259 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726406AbgIRQOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:14:00 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 18 Sep 2020 19:07:09 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08IG78fr025134;
        Fri, 18 Sep 2020 19:07:08 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08IG782x031152;
        Fri, 18 Sep 2020 19:07:08 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08IG78Zo031151;
        Fri, 18 Sep 2020 19:07:08 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v5 03/15] devlink: Add reload action stats
Date:   Fri, 18 Sep 2020 19:06:39 +0300
Message-Id: <1600445211-31078-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reload action stats to hold the history per reload action type and
limit level.

For example, the number of times fw_activate has been performed on this
device since the driver module was added or if the firmware activation
was performed with or without reset.

The function devlink_remote_reload_actions_performed() is exported to
enable also drivers update on reload actions performed, for example in
case firmware activation with reset finished successfully but was
initiated by remote host.

Add devlink notification on stats update.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v4 -> v5:
- Add separate reload action stats for updating on remote actions
- Protect  from updating remote actions stats during reload_down()/up()
v3 -> v4:
- Renamed reload_actions_cnts to reload_action_stats
- Add devlink notifications on stats update
- Renamed devlink_reload_actions_implicit_actions_performed() and add
  function comment in code
v2 -> v3:
- New patch
---
 include/net/devlink.h |  8 ++++++
 net/core/devlink.c    | 62 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d8c62d605381..f09f55a47d09 100644
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
@@ -38,6 +41,8 @@ struct devlink {
 	struct list_head trap_policer_list;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
+	u32 reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
+	u32 remote_reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
@@ -1400,6 +1405,9 @@ void
 devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
 
 bool devlink_is_reload_failed(const struct devlink *devlink);
+void devlink_remote_reload_actions_performed(struct devlink *devlink,
+					     enum devlink_reload_action_limit_level limit_level,
+					     unsigned long actions_performed);
 
 void devlink_flash_update_begin_notify(struct devlink *devlink);
 void devlink_flash_update_end_notify(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index fee6fcc7dead..1509c2ffb98b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3007,16 +3007,74 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
+static void
+__devlink_reload_action_stats_update(struct devlink *devlink,
+				     u32 *reload_action_stats,
+				     enum devlink_reload_action_limit_level limit_level,
+				     unsigned long actions_performed)
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
+		reload_action_stats[stat_idx]++;
+	}
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+}
+
+static void
+devlink_reload_action_stats_update(struct devlink *devlink,
+				   enum devlink_reload_action_limit_level limit_level,
+				   unsigned long actions_performed)
+{
+	__devlink_reload_action_stats_update(devlink, devlink->reload_action_stats,
+					     limit_level, actions_performed);
+}
+
+/**
+ *	devlink_remote_reload_actions_performed - Update devlink on reload actions
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
+void devlink_remote_reload_actions_performed(struct devlink *devlink,
+					     enum devlink_reload_action_limit_level limit_level,
+					     unsigned long actions_performed)
+{
+	__devlink_reload_action_stats_update(devlink, devlink->remote_reload_action_stats,
+					     limit_level, actions_performed);
+}
+EXPORT_SYMBOL_GPL(devlink_remote_reload_actions_performed);
+
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 			  enum devlink_reload_action action,
 			  enum devlink_reload_action_limit_level limit_level,
 			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
+	u32 remote_reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
 	int err;
 
 	if (!devlink->reload_enabled)
 		return -EOPNOTSUPP;
 
+	memcpy(remote_reload_action_stats, devlink->remote_reload_action_stats,
+	       sizeof(remote_reload_action_stats));
 	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit_level, extack);
 	if (err)
 		return err;
@@ -3030,6 +3088,10 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 		return err;
 
 	WARN_ON(!test_bit(action, actions_performed));
+	/* protect from driver updating the remote action within devlink reload */
+	WARN_ON(memcmp(remote_reload_action_stats, devlink->remote_reload_action_stats,
+		       sizeof(remote_reload_action_stats)));
+	devlink_reload_action_stats_update(devlink, limit_level, *actions_performed);
 	return 0;
 }
 
-- 
2.17.1

