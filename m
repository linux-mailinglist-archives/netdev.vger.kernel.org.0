Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C121275D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgGBPJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:09:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39748 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730070AbgGBPJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:09:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 2 Jul 2020 18:09:09 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 062F99u3020270;
        Thu, 2 Jul 2020 18:09:09 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 062F99XQ015413;
        Thu, 2 Jul 2020 18:09:09 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 062F99r4015412;
        Thu, 2 Jul 2020 18:09:09 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH net-next 5/7] devlink: Add devlink health port reporters API
Date:   Thu,  2 Jul 2020 18:08:11 +0300
Message-Id: <1593702493-15323-6-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
References: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

In order to use new devlink port health reporters infrastructure, add
corresponding constructor and destructor functions.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  9 +++++++++
 net/core/devlink.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d3ac152..2082062 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1336,9 +1336,18 @@ struct devlink_health_reporter *
 devlink_health_reporter_create(struct devlink *devlink,
 			       const struct devlink_health_reporter_ops *ops,
 			       u64 graceful_period, void *priv);
+
+struct devlink_health_reporter *
+devlink_port_health_reporter_create(struct devlink_port *port,
+				    const struct devlink_health_reporter_ops *ops,
+				    u64 graceful_period, void *priv);
+
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
+void
+devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
+
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter);
 int devlink_health_report(struct devlink_health_reporter *reporter,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8aedd20..e0bb045 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5346,6 +5346,42 @@ struct devlink_health_reporter {
 }
 
 /**
+ *	devlink_port_health_reporter_create - create devlink health reporter for
+ *	                                      specified port instance
+ *
+ *	@devlink_port: devlink_port
+ *	@ops: ops
+ *	@graceful_period: to avoid recovery loops, in msecs
+ *	@priv: priv
+ */
+struct devlink_health_reporter *
+devlink_port_health_reporter_create(struct devlink_port *port,
+				    const struct devlink_health_reporter_ops *ops,
+				    u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+
+	mutex_lock(&port->reporters_lock);
+	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
+						   &port->reporters_lock, ops->name)) {
+		reporter = ERR_PTR(-EEXIST);
+		goto unlock;
+	}
+
+	reporter = __devlink_health_reporter_create(port->devlink, ops,
+						    graceful_period, priv);
+	if (IS_ERR(reporter))
+		goto unlock;
+
+	reporter->devlink_port = port;
+	list_add_tail(&reporter->list, &port->reporter_list);
+unlock:
+	mutex_unlock(&port->reporters_lock);
+	return reporter;
+}
+EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
+
+/**
  *	devlink_health_reporter_create - create devlink health reporter
  *
  *	@devlink: devlink
@@ -5415,6 +5451,21 @@ struct devlink_health_reporter *
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
+/**
+ *	devlink_port_health_reporter_destroy - destroy devlink port health reporter
+ *
+ *	@port: devlink_port which should contain specified reporter
+ *	@reporter: devlink health reporter to destroy
+ */
+void
+devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
+{
+	mutex_lock(&reporter->devlink_port->reporters_lock);
+	__devlink_health_reporter_destroy(reporter);
+	mutex_unlock(&reporter->devlink_port->reporters_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
+
 static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
 				struct devlink *devlink,
-- 
1.8.3.1

