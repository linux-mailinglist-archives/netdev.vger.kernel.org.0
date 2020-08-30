Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B8D256F15
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 17:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgH3Paz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 11:30:55 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42707 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726479AbgH3P2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 11:28:02 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 30 Aug 2020 18:27:54 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07UFRsE5029621;
        Sun, 30 Aug 2020 18:27:54 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07UFRsqE027830;
        Sun, 30 Aug 2020 18:27:54 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07UFRsTJ027829;
        Sun, 30 Aug 2020 18:27:54 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v3 02/14] devlink: Add reload actions counters
Date:   Sun, 30 Aug 2020 18:27:22 +0300
Message-Id: <1598801254-27764-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reload actions counters to hold the history per reload action type.
For example, the number of times fw_activate has been done on this
device since the driver module was added or if the firmware activation
was done with or without reset.
The function devlink_reload_actions_cnts_update() is exported to enable
also drivers update on reload actions done, for example in case firmware
activation with reset finished successfully but was initiated by remote
host.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v2 -> v3:
- New patch
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index b8f0152a1fff..0547f0707d92 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,6 +38,7 @@ struct devlink {
 	struct list_head trap_policer_list;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
+	u32 reload_actions_cnts[DEVLINK_RELOAD_ACTION_MAX];
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
@@ -1372,6 +1373,7 @@ void
 devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
 
 bool devlink_is_reload_failed(const struct devlink *devlink);
+void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done);
 
 void devlink_flash_update_begin_notify(struct devlink *devlink);
 void devlink_flash_update_end_notify(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8d4137ad40db..20a29c34ff71 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2969,10 +2969,23 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
+void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done)
+{
+	int action;
+
+	for (action = 0; action < DEVLINK_RELOAD_ACTION_MAX; action++) {
+		if (!test_bit(action, &actions_done))
+			continue;
+		devlink->reload_actions_cnts[action]++;
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_reload_actions_cnts_update);
+
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
-			  unsigned long *actions_done)
+			  unsigned long *actions_done_out)
 {
+	unsigned long actions_done;
 	int err;
 
 	if (!devlink->reload_enabled)
@@ -2985,9 +2998,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
 		devlink_reload_netns_change(devlink, dest_net);
 
-	err = devlink->ops->reload_up(devlink, action, extack, actions_done);
+	err = devlink->ops->reload_up(devlink, action, extack, &actions_done);
 	devlink_reload_failed_set(devlink, !!err);
-	return err;
+	if (err)
+		return err;
+	devlink_reload_actions_cnts_update(devlink, actions_done);
+	if (actions_done_out)
+		*actions_done_out = actions_done;
+	return 0;
 }
 
 static int
-- 
2.17.1

