Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF6A2800B6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbgJAOAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:00:31 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36626 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732169AbgJAOA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:23 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0NAv001720;
        Thu, 1 Oct 2020 17:00:23 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0NFb011161;
        Thu, 1 Oct 2020 17:00:23 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0NWc011160;
        Thu, 1 Oct 2020 17:00:23 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 01/16] devlink: Change devlink_reload_supported() param type
Date:   Thu,  1 Oct 2020 16:59:04 +0300
Message-Id: <1601560759-11030-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change devlink_reload_supported() function to get devlink_ops pointer
param instead of devlink pointer param.
This change will be used in the next patch to check if devlink reload is
supported before devlink instance is allocated.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
RFCv5 -> v1:
- New patch
---
 net/core/devlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6f2863e717a9..722a9431ff60 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2946,9 +2946,9 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 				     DEVLINK_CMD_PARAM_NEW);
 }
 
-static bool devlink_reload_supported(const struct devlink *devlink)
+static bool devlink_reload_supported(const struct devlink_ops *ops)
 {
-	return devlink->ops->reload_down && devlink->ops->reload_up;
+	return ops->reload_down && ops->reload_up;
 }
 
 static void devlink_reload_failed_set(struct devlink *devlink,
@@ -2992,7 +2992,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	struct net *dest_net = NULL;
 	int err;
 
-	if (!devlink_reload_supported(devlink))
+	if (!devlink_reload_supported(devlink->ops))
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -7516,7 +7516,7 @@ EXPORT_SYMBOL_GPL(devlink_register);
 void devlink_unregister(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink) &&
+	WARN_ON(devlink_reload_supported(devlink->ops) &&
 		devlink->reload_enabled);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 	list_del(&devlink->list);
@@ -8553,7 +8553,7 @@ __devlink_param_driverinit_value_set(struct devlink *devlink,
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val)
 {
-	if (!devlink_reload_supported(devlink))
+	if (!devlink_reload_supported(devlink->ops))
 		return -EOPNOTSUPP;
 
 	return __devlink_param_driverinit_value_get(&devlink->param_list,
@@ -8600,7 +8600,7 @@ int devlink_port_param_driverinit_value_get(struct devlink_port *devlink_port,
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	if (!devlink_reload_supported(devlink))
+	if (!devlink_reload_supported(devlink->ops))
 		return -EOPNOTSUPP;
 
 	return __devlink_param_driverinit_value_get(&devlink_port->param_list,
@@ -9733,7 +9733,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
 		if (net_eq(devlink_net(devlink), net)) {
-			if (WARN_ON(!devlink_reload_supported(devlink)))
+			if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 				continue;
 			err = devlink_reload(devlink, &init_net, NULL);
 			if (err && err != -EOPNOTSUPP)
-- 
2.18.2

