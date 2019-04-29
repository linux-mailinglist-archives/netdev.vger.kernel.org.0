Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAA4DFA8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfD2JmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 05:42:15 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43219 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727368AbfD2JmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:42:14 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Apr 2019 12:42:11 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x3T9gBIg031314;
        Mon, 29 Apr 2019 12:42:11 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id x3T9gB8k009965;
        Mon, 29 Apr 2019 12:42:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id x3T9g7ZT009960;
        Mon, 29 Apr 2019 12:42:07 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next] devlink: Change devlink health locking mechanism
Date:   Mon, 29 Apr 2019 12:41:45 +0300
Message-Id: <1556530905-9908-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink health reporters create/destroy and user commands currently
use the devlink->lock as a locking mechanism. Different reporters have
different rules in the driver and are being created/destroyed during
different stages of driver load/unload/running. So during execution of a
reporter recover the flow can go through another reporter's destroy and
create. Such flow leads to deadlock trying to lock a mutex already
held.

With the new locking mechanism the different reporters share mutex lock
only to protect access to shared reporters list.
Added refcount per reporter, to protect the reporters from destroy while
being used.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 include/net/devlink.h |  1 +
 net/core/devlink.c    | 97 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 75 insertions(+), 23 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4f5e416..1c4adfb 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -32,6 +32,7 @@ struct devlink {
 	struct list_head region_list;
 	u32 snapshot_id;
 	struct list_head reporter_list;
+	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
 	const struct devlink_ops *ops;
 	struct device *dev;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4e28d04..d43bc52 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
+#include <linux/refcount.h>
 #include <rdma/ib_verbs.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
@@ -4432,6 +4433,7 @@ struct devlink_health_reporter {
 	u64 error_count;
 	u64 recovery_count;
 	u64 last_recovery_ts;
+	refcount_t refcount;
 };
 
 void *
@@ -4447,6 +4449,7 @@ struct devlink_health_reporter {
 {
 	struct devlink_health_reporter *reporter;
 
+	lockdep_assert_held(&devlink->reporters_lock);
 	list_for_each_entry(reporter, &devlink->reporter_list, list)
 		if (!strcmp(reporter->ops->name, reporter_name))
 			return reporter;
@@ -4470,7 +4473,7 @@ struct devlink_health_reporter *
 {
 	struct devlink_health_reporter *reporter;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->reporters_lock);
 	if (devlink_health_reporter_find_by_name(devlink, ops->name)) {
 		reporter = ERR_PTR(-EEXIST);
 		goto unlock;
@@ -4494,9 +4497,10 @@ struct devlink_health_reporter *
 	reporter->graceful_period = graceful_period;
 	reporter->auto_recover = auto_recover;
 	mutex_init(&reporter->dump_lock);
+	refcount_set(&reporter->refcount, 1);
 	list_add_tail(&reporter->list, &devlink->reporter_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->reporters_lock);
 	return reporter;
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_create);
@@ -4509,10 +4513,12 @@ struct devlink_health_reporter *
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	mutex_lock(&reporter->devlink->lock);
+	mutex_lock(&reporter->devlink->reporters_lock);
 	list_del(&reporter->list);
+	mutex_unlock(&reporter->devlink->reporters_lock);
+	while (refcount_read(&reporter->refcount) > 1)
+		msleep(100);
 	mutex_destroy(&reporter->dump_lock);
-	mutex_unlock(&reporter->devlink->lock);
 	if (reporter->dump_fmsg)
 		devlink_fmsg_free(reporter->dump_fmsg);
 	kfree(reporter);
@@ -4648,6 +4654,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 devlink_health_reporter_get_from_info(struct devlink *devlink,
 				      struct genl_info *info)
 {
+	struct devlink_health_reporter *reporter;
 	char *reporter_name;
 
 	if (!info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME])
@@ -4655,7 +4662,18 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 
 	reporter_name =
 		nla_data(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
-	return devlink_health_reporter_find_by_name(devlink, reporter_name);
+	mutex_lock(&devlink->reporters_lock);
+	reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
+	if (reporter)
+		refcount_inc(&reporter->refcount);
+	mutex_unlock(&devlink->reporters_lock);
+	return reporter;
+}
+
+static void
+devlink_health_reporter_put(struct devlink_health_reporter *reporter)
+{
+	refcount_dec(&reporter->refcount);
 }
 
 static int
@@ -4730,8 +4748,10 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = devlink_nl_health_reporter_fill(msg, devlink, reporter,
 					      DEVLINK_CMD_HEALTH_REPORTER_GET,
@@ -4739,10 +4759,13 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 					      0);
 	if (err) {
 		nlmsg_free(msg);
-		return err;
+		goto out;
 	}
 
-	return genlmsg_reply(msg, info);
+	err = genlmsg_reply(msg, info);
+out:
+	devlink_health_reporter_put(reporter);
+	return err;
 }
 
 static int
@@ -4759,7 +4782,7 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 	list_for_each_entry(devlink, &devlink_list, list) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			continue;
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->reporters_lock);
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
 			if (idx < start) {
@@ -4773,12 +4796,12 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 							      cb->nlh->nlmsg_seq,
 							      NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->reporters_lock);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->reporters_lock);
 	}
 out:
 	mutex_unlock(&devlink_mutex);
@@ -4793,6 +4816,7 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
+	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
@@ -4800,8 +4824,10 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 
 	if (!reporter->ops->recover &&
 	    (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] ||
-	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]))
-		return -EOPNOTSUPP;
+	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
 		reporter->graceful_period =
@@ -4811,7 +4837,11 @@ static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 		reporter->auto_recover =
 			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
 
+	devlink_health_reporter_put(reporter);
 	return 0;
+out:
+	devlink_health_reporter_put(reporter);
+	return err;
 }
 
 static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
@@ -4819,12 +4849,16 @@ static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_health_reporter *reporter;
+	int err;
 
 	reporter = devlink_health_reporter_get_from_info(devlink, info);
 	if (!reporter)
 		return -EINVAL;
 
-	return devlink_health_reporter_recover(reporter, NULL);
+	err = devlink_health_reporter_recover(reporter, NULL);
+
+	devlink_health_reporter_put(reporter);
+	return err;
 }
 
 static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
@@ -4839,12 +4873,16 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->diagnose)
+	if (!reporter->ops->diagnose) {
+		devlink_health_reporter_put(reporter);
 		return -EOPNOTSUPP;
+	}
 
 	fmsg = devlink_fmsg_alloc();
-	if (!fmsg)
+	if (!fmsg) {
+		devlink_health_reporter_put(reporter);
 		return -ENOMEM;
+	}
 
 	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
@@ -4863,6 +4901,7 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 
 out:
 	devlink_fmsg_free(fmsg);
+	devlink_health_reporter_put(reporter);
 	return err;
 }
 
@@ -4877,8 +4916,10 @@ static int devlink_nl_cmd_health_reporter_dump_get_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->dump)
+	if (!reporter->ops->dump) {
+		devlink_health_reporter_put(reporter);
 		return -EOPNOTSUPP;
+	}
 
 	mutex_lock(&reporter->dump_lock);
 	err = devlink_health_do_dump(reporter, NULL);
@@ -4890,6 +4931,7 @@ static int devlink_nl_cmd_health_reporter_dump_get_doit(struct sk_buff *skb,
 
 out:
 	mutex_unlock(&reporter->dump_lock);
+	devlink_health_reporter_put(reporter);
 	return err;
 }
 
@@ -4904,12 +4946,15 @@ static int devlink_nl_cmd_health_reporter_dump_get_doit(struct sk_buff *skb,
 	if (!reporter)
 		return -EINVAL;
 
-	if (!reporter->ops->dump)
+	if (!reporter->ops->dump) {
+		devlink_health_reporter_put(reporter);
 		return -EOPNOTSUPP;
+	}
 
 	mutex_lock(&reporter->dump_lock);
 	devlink_health_dump_clear(reporter);
 	mutex_unlock(&reporter->dump_lock);
+	devlink_health_reporter_put(reporter);
 	return 0;
 }
 
@@ -5191,7 +5236,8 @@ static int devlink_nl_cmd_health_reporter_dump_get_doit(struct sk_buff *skb,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
 		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+				  DEVLINK_NL_FLAG_NO_LOCK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -5199,21 +5245,24 @@ static int devlink_nl_cmd_health_reporter_dump_get_doit(struct sk_buff *skb,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_RECOVER,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_recover_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_diagnose_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
+				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET,
@@ -5284,6 +5333,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	INIT_LIST_HEAD(&devlink->region_list);
 	INIT_LIST_HEAD(&devlink->reporter_list);
 	mutex_init(&devlink->lock);
+	mutex_init(&devlink->reporters_lock);
 	return devlink;
 }
 EXPORT_SYMBOL_GPL(devlink_alloc);
@@ -5326,6 +5376,7 @@ void devlink_unregister(struct devlink *devlink)
  */
 void devlink_free(struct devlink *devlink)
 {
+	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->reporter_list));
 	WARN_ON(!list_empty(&devlink->region_list));
-- 
1.8.3.1

