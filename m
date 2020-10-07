Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE9C285862
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgJGGBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:01:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34536 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727369AbgJGGB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:01:28 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 7 Oct 2020 09:01:14 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09761EJs018750;
        Wed, 7 Oct 2020 09:01:14 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 09761EqZ021765;
        Wed, 7 Oct 2020 09:01:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 09761EwS021764;
        Wed, 7 Oct 2020 09:01:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next v2 01/16] devlink: Change devlink_reload_supported() param type
Date:   Wed,  7 Oct 2020 09:00:42 +0300
Message-Id: <1602050457-21700-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change devlink_reload_supported() function to get devlink_ops pointer
param instead of devlink pointer param.
This change will be used in the next patch to check if devlink reload is
supported before devlink instance is allocated.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
RFCv5 -> v1:
- New patch
---
 net/core/devlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 65b8ac8b5fba..5c45b3964ec3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2963,9 +2963,9 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 				     DEVLINK_CMD_PARAM_NEW);
 }
 
-static bool devlink_reload_supported(const struct devlink *devlink)
+static bool devlink_reload_supported(const struct devlink_ops *ops)
 {
-	return devlink->ops->reload_down && devlink->ops->reload_up;
+	return ops->reload_down && ops->reload_up;
 }
 
 static void devlink_reload_failed_set(struct devlink *devlink,
@@ -3009,7 +3009,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	struct net *dest_net = NULL;
 	int err;
 
-	if (!devlink_reload_supported(devlink))
+	if (!devlink_reload_supported(devlink->ops))
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -7679,7 +7679,7 @@ EXPORT_SYMBOL_GPL(devlink_register);
 void devlink_unregister(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
-	WARN_ON(devlink_reload_supported(devlink) &&
+	WARN_ON(devlink_reload_supported(devlink->ops) &&
 		devlink->reload_enabled);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 	list_del(&devlink->list);
@@ -8720,7 +8720,7 @@ __devlink_param_driverinit_value_set(struct devlink *devlink,
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val)
 {
-	if (!devlink_reload_supported(devlink))
+	if (!devlink_reload_supported(devlink->ops))
 		return -EOPNOTSUPP;
 
 	return __devlink_param_driverinit_value_get(&devlink->param_list,
@@ -8767,7 +8767,7 @@ int devlink_port_param_driverinit_value_get(struct devlink_port *devlink_port,
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	if (!devlink_reload_supported(devlink))
+	if (!devlink_reload_supported(devlink->ops))
 		return -EOPNOTSUPP;
 
 	return __devlink_param_driverinit_value_get(&devlink_port->param_list,
@@ -9968,7 +9968,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
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

