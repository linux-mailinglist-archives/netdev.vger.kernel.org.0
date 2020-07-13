Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF221B4FD
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgGJM0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:26:15 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51787 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727864AbgGJMZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:25:56 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 10 Jul 2020 15:25:48 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06ACPmx0012397;
        Fri, 10 Jul 2020 15:25:48 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 06ACPmQp003376;
        Fri, 10 Jul 2020 15:25:48 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 06ACPmo7003375;
        Fri, 10 Jul 2020 15:25:48 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH net-next v3 4/7] devlink: Implement devlink health reporters on per-port basis
Date:   Fri, 10 Jul 2020 15:25:10 +0300
Message-Id: <1594383913-3295-5-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
References: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Add devlink-health reporter support on per-port basis.
The main difference existing devlink-health is that port reporters are
stored in per-devlink_port lists. Upon creation of such health reporter the
reference to a port it belongs to is stored in reporter struct.

Fill the port index attribute in devlink-health response to
allow devlink userspace utility to distinguish between device and port
reporters.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 94 +++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 79 insertions(+), 17 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 746bed5..bb11397 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -101,6 +101,8 @@ struct devlink_port {
 	u8 attrs_set:1,
 	   switch_port:1;
 	struct delayed_work type_warn_dw;
+	struct list_head reporter_list;
+	struct mutex reporters_lock; /* Protects reporter_list */
 };
 
 struct devlink_sb_pool_info {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4e995de..b4a231c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -386,19 +386,21 @@ struct devlink_snapshot {
 	return NULL;
 }
 
-#define DEVLINK_NL_FLAG_NEED_DEVLINK	BIT(0)
-#define DEVLINK_NL_FLAG_NEED_PORT	BIT(1)
-#define DEVLINK_NL_FLAG_NEED_SB		BIT(2)
+#define DEVLINK_NL_FLAG_NEED_DEVLINK		BIT(0)
+#define DEVLINK_NL_FLAG_NEED_PORT		BIT(1)
+#define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(2)
+#define DEVLINK_NL_FLAG_NEED_SB			BIT(3)
 
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
  * devlink lock is taken and protects from disruption by user-calls.
  */
-#define DEVLINK_NL_FLAG_NO_LOCK		BIT(3)
+#define DEVLINK_NL_FLAG_NO_LOCK			BIT(4)
 
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
 {
+	struct devlink_port *devlink_port;
 	struct devlink *devlink;
 	int err;
 
@@ -413,14 +415,17 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK) {
 		info->user_ptr[0] = devlink;
 	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
-		struct devlink_port *devlink_port;
-
 		devlink_port = devlink_port_get_from_info(devlink, info);
 		if (IS_ERR(devlink_port)) {
 			err = PTR_ERR(devlink_port);
 			goto unlock;
 		}
 		info->user_ptr[0] = devlink_port;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT) {
+		info->user_ptr[0] = devlink;
+		devlink_port = devlink_port_get_from_info(devlink, info);
+		if (!IS_ERR(devlink_port))
+			info->user_ptr[1] = devlink_port;
 	}
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_SB) {
 		struct devlink_sb *devlink_sb;
@@ -5287,6 +5292,7 @@ struct devlink_health_reporter {
 	void *priv;
 	const struct devlink_health_reporter_ops *ops;
 	struct devlink *devlink;
+	struct devlink_port *devlink_port;
 	struct devlink_fmsg *dump_fmsg;
 	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
 	u64 graceful_period;
@@ -5332,6 +5338,15 @@ struct devlink_health_reporter {
 }
 
 static struct devlink_health_reporter *
+devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
+					  const char *reporter_name)
+{
+	return __devlink_health_reporter_find_by_name(&devlink_port->reporter_list,
+						      &devlink_port->reporters_lock,
+						      reporter_name);
+}
+
+static struct devlink_health_reporter *
 __devlink_health_reporter_create(struct devlink *devlink,
 				 const struct devlink_health_reporter_ops *ops,
 				 u64 graceful_period, void *priv)
@@ -5443,6 +5458,10 @@ struct devlink_health_reporter *
 	if (devlink_nl_put_handle(msg, devlink))
 		goto genlmsg_cancel;
 
+	if (reporter->devlink_port) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, reporter->devlink_port->index))
+			goto genlmsg_cancel;
+	}
 	reporter_attr = nla_nest_start_noflag(msg,
 					      DEVLINK_ATTR_HEALTH_REPORTER);
 	if (!reporter_attr)
@@ -5650,17 +5669,28 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 				       struct nlattr **attrs)
 {
 	struct devlink_health_reporter *reporter;
+	struct devlink_port *devlink_port;
 	char *reporter_name;
 
 	if (!attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME])
 		return NULL;
 
 	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
-	mutex_lock(&devlink->reporters_lock);
-	reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
-	if (reporter)
-		refcount_inc(&reporter->refcount);
-	mutex_unlock(&devlink->reporters_lock);
+	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
+	if (IS_ERR(devlink_port)) {
+		mutex_lock(&devlink->reporters_lock);
+		reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
+		if (reporter)
+			refcount_inc(&reporter->refcount);
+		mutex_unlock(&devlink->reporters_lock);
+	} else {
+		mutex_lock(&devlink_port->reporters_lock);
+		reporter = devlink_port_health_reporter_find_by_name(devlink_port, reporter_name);
+		if (reporter)
+			refcount_inc(&reporter->refcount);
+		mutex_unlock(&devlink_port->reporters_lock);
+	}
+
 	return reporter;
 }
 
@@ -5748,6 +5778,7 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 					  struct netlink_callback *cb)
 {
 	struct devlink_health_reporter *reporter;
+	struct devlink_port *port;
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
@@ -5778,6 +5809,31 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 		}
 		mutex_unlock(&devlink->reporters_lock);
 	}
+
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		list_for_each_entry(port, &devlink->port_list, list) {
+			mutex_lock(&port->reporters_lock);
+			list_for_each_entry(reporter, &port->reporter_list, list) {
+				if (idx < start) {
+					idx++;
+					continue;
+				}
+				err = devlink_nl_health_reporter_fill(msg, devlink, reporter,
+								      DEVLINK_CMD_HEALTH_REPORTER_GET,
+								      NETLINK_CB(cb->skb).portid,
+								      cb->nlh->nlmsg_seq,
+								      NLM_F_MULTI);
+				if (err) {
+					mutex_unlock(&port->reporters_lock);
+					goto out;
+				}
+				idx++;
+			}
+			mutex_unlock(&port->reporters_lock);
+		}
+	}
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -7157,7 +7213,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
 		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
 				  DEVLINK_NL_FLAG_NO_LOCK,
 		/* can be retrieved by unprivileged users */
 	},
@@ -7166,7 +7222,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
 				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
@@ -7174,7 +7230,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_recover_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
 				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
@@ -7182,7 +7238,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_diagnose_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
 				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
@@ -7191,7 +7247,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = devlink_nl_cmd_health_reporter_dump_get_dumpit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
 				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
@@ -7199,7 +7255,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_dump_clear_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
 				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
@@ -7459,6 +7515,8 @@ int devlink_port_register(struct devlink *devlink,
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	mutex_unlock(&devlink->lock);
+	INIT_LIST_HEAD(&devlink_port->reporter_list);
+	mutex_init(&devlink_port->reporters_lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
@@ -7475,6 +7533,8 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
+	WARN_ON(!list_empty(&devlink_port->reporter_list));
+	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
-- 
1.8.3.1

