Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF82921275E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgGBPJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:09:12 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39727 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729404AbgGBPJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:09:11 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 2 Jul 2020 18:09:09 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 062F99J8020263;
        Thu, 2 Jul 2020 18:09:09 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 062F99kB015409;
        Thu, 2 Jul 2020 18:09:09 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 062F98vs015408;
        Thu, 2 Jul 2020 18:09:08 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH net-next 3/7] devlink: Create generic devlink health reporter search function
Date:   Thu,  2 Jul 2020 18:08:09 +0300
Message-Id: <1593702493-15323-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
References: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Add a generic __devlink_health_reporter_find_by_name() that can be used
with arbitrary devlink health reporter list.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index dcf8006..98e6911 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5283,19 +5283,29 @@ struct devlink_health_reporter {
 EXPORT_SYMBOL_GPL(devlink_health_reporter_priv);
 
 static struct devlink_health_reporter *
-devlink_health_reporter_find_by_name(struct devlink *devlink,
-				     const char *reporter_name)
+__devlink_health_reporter_find_by_name(struct list_head *reporter_list,
+				       struct mutex *list_lock,
+				       const char *reporter_name)
 {
 	struct devlink_health_reporter *reporter;
 
-	lockdep_assert_held(&devlink->reporters_lock);
-	list_for_each_entry(reporter, &devlink->reporter_list, list)
+	lockdep_assert_held(list_lock);
+	list_for_each_entry(reporter, reporter_list, list)
 		if (!strcmp(reporter->ops->name, reporter_name))
 			return reporter;
 	return NULL;
 }
 
 static struct devlink_health_reporter *
+devlink_health_reporter_find_by_name(struct devlink *devlink,
+				     const char *reporter_name)
+{
+	return __devlink_health_reporter_find_by_name(&devlink->reporter_list,
+						      &devlink->reporters_lock,
+						      reporter_name);
+}
+
+static struct devlink_health_reporter *
 __devlink_health_reporter_create(struct devlink *devlink,
 				 const struct devlink_health_reporter_ops *ops,
 				 u64 graceful_period, void *priv)
-- 
1.8.3.1

