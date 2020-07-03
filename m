Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECC5213229
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgGCD2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:28:25 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33602 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgGCD2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:28:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 3 Jul 2020 06:28:14 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0633SExG006780;
        Fri, 3 Jul 2020 06:28:14 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 0633SEbi006656;
        Fri, 3 Jul 2020 06:28:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 0633SE74006655;
        Fri, 3 Jul 2020 06:28:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH net-next v2 1/7] devlink: Refactor devlink health reporter constructor
Date:   Fri,  3 Jul 2020 06:27:32 +0300
Message-Id: <1593746858-6548-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1593746858-6548-1-git-send-email-moshe@mellanox.com>
References: <1593746858-6548-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Prepare a common routine in devlink_health_reporter_create() for usage
in similar functions for devlink port health reporters.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6ae3680..dfd7fe2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5295,6 +5295,31 @@ struct devlink_health_reporter {
 	return NULL;
 }
 
+static struct devlink_health_reporter *
+__devlink_health_reporter_create(struct devlink *devlink,
+				 const struct devlink_health_reporter_ops *ops,
+				 u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+
+	if (WARN_ON(graceful_period && !ops->recover))
+		return ERR_PTR(-EINVAL);
+
+	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
+	if (!reporter)
+		return ERR_PTR(-ENOMEM);
+
+	reporter->priv = priv;
+	reporter->ops = ops;
+	reporter->devlink = devlink;
+	reporter->graceful_period = graceful_period;
+	reporter->auto_recover = !!ops->recover;
+	reporter->auto_dump = !!ops->dump;
+	mutex_init(&reporter->dump_lock);
+	refcount_set(&reporter->refcount, 1);
+	return reporter;
+}
+
 /**
  *	devlink_health_reporter_create - create devlink health reporter
  *
@@ -5316,25 +5341,11 @@ struct devlink_health_reporter *
 		goto unlock;
 	}
 
-	if (WARN_ON(graceful_period && !ops->recover)) {
-		reporter = ERR_PTR(-EINVAL);
+	reporter = __devlink_health_reporter_create(devlink, ops,
+						    graceful_period, priv);
+	if (IS_ERR(reporter))
 		goto unlock;
-	}
-
-	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
-	if (!reporter) {
-		reporter = ERR_PTR(-ENOMEM);
-		goto unlock;
-	}
 
-	reporter->priv = priv;
-	reporter->ops = ops;
-	reporter->devlink = devlink;
-	reporter->graceful_period = graceful_period;
-	reporter->auto_recover = !!ops->recover;
-	reporter->auto_dump = !!ops->dump;
-	mutex_init(&reporter->dump_lock);
-	refcount_set(&reporter->refcount, 1);
 	list_add_tail(&reporter->list, &devlink->reporter_list);
 unlock:
 	mutex_unlock(&devlink->reporters_lock);
-- 
1.8.3.1

