Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A8449A77
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbhKHRI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241429AbhKHRI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8595361406;
        Mon,  8 Nov 2021 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391173;
        bh=+SR6P1MuJzp5cF5dePEfqnSBAXoAo9DSe2e/gwRJZ1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3q5RcqHMYNJS8CrOMFnFwZccbg8b3VIvWUsT6zadAYFFWqSDJqyNjaXZJatSbWmS
         ktx4bg87izveBcXg2H4YD5JLF5azXB1wPsoSenama06hD7wOOtShDnoxXd1IDDBBQ5
         XfQCQoVvw6kBCcju5W//hidLYLTVRUPFyLnU+IjIW7DnfrjohEysfLAi7yf3HVXJ3f
         fZ1XY0bI9IHLO9RnCbBObgyL6b4PSRpzlQJZJbvNpofjdMEKCRU0LbzshN+kRhsDIN
         I4n9wVSdLiOdgJCut8N3An8hqlTh6+Ejwf0ShQXtwKLXYF2QTgf5rcg7SA9xUBBAnF
         yv18dcoCR+Seg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 09/16] devlink: Protect all traps lists with specialized lock
Date:   Mon,  8 Nov 2021 19:05:31 +0200
Message-Id: <49788cd5a06b23bc679edf21bf58832e37d170e3.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Separate traps related list protection from main devlink instance lock
to rely on specialized lock that will protect traps, traps groups and
policies.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 154 ++++++++++++++++++++++++++++++---------------
 1 file changed, 102 insertions(+), 52 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97154219fca2..e89eaaba653d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -55,6 +55,7 @@ struct devlink {
 	struct list_head trap_list;
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
+	struct mutex traps_lock; /* protects all traps activities */
 	const struct devlink_ops *ops;
 	u64 features;
 	struct xarray snapshot_ids;
@@ -7534,6 +7535,8 @@ devlink_trap_item_lookup(struct devlink *devlink, const char *name)
 {
 	struct devlink_trap_item *trap_item;
 
+	lockdep_assert_held(&devlink->traps_lock);
+
 	list_for_each_entry(trap_item, &devlink->trap_list, list) {
 		if (!strcmp(trap_item->trap->name, name))
 			return trap_item;
@@ -7753,21 +7756,25 @@ static int devlink_nl_cmd_trap_get_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_item *trap_item;
+	int err = -EOPNOTSUPP;
 	struct sk_buff *msg;
-	int err;
 
+	mutex_lock(&devlink->traps_lock);
 	if (list_empty(&devlink->trap_list))
-		return -EOPNOTSUPP;
+		goto out;
 
 	trap_item = devlink_trap_item_get_from_info(devlink, info);
 	if (!trap_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
-		return -ENOENT;
+		err = -ENOENT;
+		goto out;
 	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = devlink_nl_trap_fill(msg, devlink, trap_item,
 				   DEVLINK_CMD_TRAP_NEW, info->snd_portid,
@@ -7775,10 +7782,13 @@ static int devlink_nl_cmd_trap_get_doit(struct sk_buff *skb,
 	if (err)
 		goto err_trap_fill;
 
+	mutex_unlock(&devlink->traps_lock);
 	return genlmsg_reply(msg, info);
 
 err_trap_fill:
 	nlmsg_free(msg);
+out:
+	mutex_unlock(&devlink->traps_lock);
 	return err;
 }
 
@@ -7800,7 +7810,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->traps_lock);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < start) {
 				idx++;
@@ -7812,13 +7822,13 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->traps_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->traps_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -7878,17 +7888,23 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_item *trap_item;
+	int err = -EOPNOTSUPP;
 
+	mutex_lock(&devlink->traps_lock);
 	if (list_empty(&devlink->trap_list))
-		return -EOPNOTSUPP;
+		goto out;
 
 	trap_item = devlink_trap_item_get_from_info(devlink, info);
 	if (!trap_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
-		return -ENOENT;
+		err = -ENOENT;
+		goto out;
 	}
 
-	return devlink_trap_action_set(devlink, trap_item, info);
+	err = devlink_trap_action_set(devlink, trap_item, info);
+out:
+	mutex_unlock(&devlink->traps_lock);
+	return err;
 }
 
 static struct devlink_trap_group_item *
@@ -7978,21 +7994,25 @@ static int devlink_nl_cmd_trap_group_get_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_group_item *group_item;
+	int err = -EOPNOTSUPP;
 	struct sk_buff *msg;
-	int err;
 
+	mutex_lock(&devlink->traps_lock);
 	if (list_empty(&devlink->trap_group_list))
-		return -EOPNOTSUPP;
+		goto out;
 
 	group_item = devlink_trap_group_item_get_from_info(devlink, info);
 	if (!group_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap group");
-		return -ENOENT;
+		err = -ENOENT;
+		goto out;
 	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = devlink_nl_trap_group_fill(msg, devlink, group_item,
 					 DEVLINK_CMD_TRAP_GROUP_NEW,
@@ -8000,10 +8020,13 @@ static int devlink_nl_cmd_trap_group_get_doit(struct sk_buff *skb,
 	if (err)
 		goto err_trap_group_fill;
 
+	mutex_unlock(&devlink->traps_lock);
 	return genlmsg_reply(msg, info);
 
 err_trap_group_fill:
 	nlmsg_free(msg);
+out:
+	mutex_unlock(&devlink->traps_lock);
 	return err;
 }
 
@@ -8027,7 +8050,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->traps_lock);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
 			if (idx < start) {
@@ -8040,13 +8063,13 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 							 cb->nlh->nlmsg_seq,
 							 NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->traps_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->traps_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -8067,6 +8090,8 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 	struct devlink_trap_item *trap_item;
 	int err;
 
+	lockdep_assert_held(&devlink->traps_lock);
+
 	if (devlink->ops->trap_group_action_set) {
 		err = devlink->ops->trap_group_action_set(devlink, group_item->group,
 							  trap_action, extack);
@@ -8171,31 +8196,35 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_group_item *group_item;
 	bool modified = false;
-	int err;
+	int err = -EOPNOTSUPP;
 
+	mutex_lock(&devlink->traps_lock);
 	if (list_empty(&devlink->trap_group_list))
-		return -EOPNOTSUPP;
+		goto out;
 
 	group_item = devlink_trap_group_item_get_from_info(devlink, info);
 	if (!group_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap group");
-		return -ENOENT;
+		err = -ENOENT;
+		goto out;
 	}
 
 	err = devlink_trap_group_action_set(devlink, group_item, info,
 					    &modified);
 	if (err)
-		return err;
+		goto out;
 
 	err = devlink_trap_group_set(devlink, group_item, info);
 	if (err)
 		goto err_trap_group_set;
-
+	mutex_unlock(&devlink->traps_lock);
 	return 0;
 
 err_trap_group_set:
 	if (modified)
 		NL_SET_ERR_MSG_MOD(extack, "Trap group set failed, but some changes were committed already");
+out:
+	mutex_unlock(&devlink->traps_lock);
 	return err;
 }
 
@@ -8292,21 +8321,25 @@ static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
 	struct devlink_trap_policer_item *policer_item;
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
+	int err = -EOPNOTSUPP;
 	struct sk_buff *msg;
-	int err;
 
+	mutex_lock(&devlink->traps_lock);
 	if (list_empty(&devlink->trap_policer_list))
-		return -EOPNOTSUPP;
+		goto out;
 
 	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
 	if (!policer_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
-		return -ENOENT;
+		err = -ENOENT;
+		goto out;
 	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = devlink_nl_trap_policer_fill(msg, devlink, policer_item,
 					   DEVLINK_CMD_TRAP_POLICER_NEW,
@@ -8314,10 +8347,13 @@ static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
 	if (err)
 		goto err_trap_policer_fill;
 
+	mutex_unlock(&devlink->traps_lock);
 	return genlmsg_reply(msg, info);
 
 err_trap_policer_fill:
 	nlmsg_free(msg);
+out:
+	mutex_unlock(&devlink->traps_lock);
 	return err;
 }
 
@@ -8341,7 +8377,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->traps_lock);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
 			if (idx < start) {
@@ -8354,13 +8390,13 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 							   cb->nlh->nlmsg_seq,
 							   NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->traps_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->traps_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -8427,20 +8463,26 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	struct devlink_trap_policer_item *policer_item;
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
-
-	if (list_empty(&devlink->trap_policer_list))
-		return -EOPNOTSUPP;
+	int err = -EOPNOTSUPP;
 
 	if (!devlink->ops->trap_policer_set)
 		return -EOPNOTSUPP;
 
+	mutex_lock(&devlink->traps_lock);
+	if (list_empty(&devlink->trap_policer_list))
+		goto out;
+
 	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
 	if (!policer_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
-		return -ENOENT;
+		err = -ENOENT;
+		goto out;
 	}
 
-	return devlink_trap_policer_set(devlink, policer_item, info);
+	err = devlink_trap_policer_set(devlink, policer_item, info);
+out:
+	mutex_unlock(&devlink->traps_lock);
+	return err;
 }
 
 static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
@@ -8972,9 +9014,12 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	INIT_LIST_HEAD(&devlink->param_list);
 	INIT_LIST_HEAD(&devlink->region_list);
 	INIT_LIST_HEAD(&devlink->reporter_list);
+
 	INIT_LIST_HEAD(&devlink->trap_list);
 	INIT_LIST_HEAD(&devlink->trap_group_list);
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
+	mutex_init(&devlink->traps_lock);
+
 	mutex_init(&devlink->lock);
 	mutex_init(&devlink->reporters_lock);
 	refcount_set(&devlink->refcount, 1);
@@ -9012,6 +9057,7 @@ static void devlink_notify_register(struct devlink *devlink)
 		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	mutex_unlock(&devlink->port_list_lock);
 
+	mutex_lock(&devlink->traps_lock);
 	list_for_each_entry(policer_item, &devlink->trap_policer_list, list)
 		devlink_trap_policer_notify(devlink, policer_item,
 					    DEVLINK_CMD_TRAP_POLICER_NEW);
@@ -9022,6 +9068,7 @@ static void devlink_notify_register(struct devlink *devlink)
 
 	list_for_each_entry(trap_item, &devlink->trap_list, list)
 		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_NEW);
+	mutex_unlock(&devlink->traps_lock);
 
 	list_for_each_entry(rate_node, &devlink->rate_list, list)
 		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
@@ -9054,6 +9101,7 @@ static void devlink_notify_unregister(struct devlink *devlink)
 	list_for_each_entry_reverse(rate_node, &devlink->rate_list, list)
 		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_DEL);
 
+	mutex_lock(&devlink->traps_lock);
 	list_for_each_entry_reverse(trap_item, &devlink->trap_list, list)
 		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_DEL);
 
@@ -9064,6 +9112,7 @@ static void devlink_notify_unregister(struct devlink *devlink)
 				    list)
 		devlink_trap_policer_notify(devlink, policer_item,
 					    DEVLINK_CMD_TRAP_POLICER_DEL);
+	mutex_unlock(&devlink->traps_lock);
 
 	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry_reverse(devlink_port, &devlink->port_list, list)
@@ -9122,6 +9171,7 @@ void devlink_free(struct devlink *devlink)
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->port_list_lock);
 	mutex_destroy(&devlink->resource_list_lock);
+	mutex_destroy(&devlink->traps_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -10796,7 +10846,7 @@ int devlink_traps_register(struct devlink *devlink,
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->traps_lock);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -10808,7 +10858,7 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 
 	return 0;
 
@@ -10816,7 +10866,7 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_traps_register);
@@ -10833,7 +10883,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->traps_lock);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -10842,7 +10892,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
 
@@ -11014,7 +11064,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->traps_lock);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11026,7 +11076,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 
 	return 0;
 
@@ -11034,7 +11084,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
@@ -11051,10 +11101,10 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->traps_lock);
 	for (i = groups_count - 1; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
 
@@ -11154,7 +11204,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->traps_lock);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -11169,7 +11219,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 
 	return 0;
 
@@ -11177,7 +11227,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
@@ -11195,10 +11245,10 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->traps_lock);
 	for (i = policers_count - 1; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->traps_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
 
-- 
2.33.1

