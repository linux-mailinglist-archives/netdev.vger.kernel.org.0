Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D19449A76
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbhKHRI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240498AbhKHRIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0194261506;
        Mon,  8 Nov 2021 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391169;
        bh=GioKaK/2hbDGHXaH5P+QF8ecDSsZeb2OfZRbFNGEHps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4ClLS8drPa81UXv0nnoNHkeORUz5FgNkU5ucPTgSG4avNa00AHBRcTpAiVswVC3P
         /SJHXGlCd3vrhdXj7URigL43OR0smQEHmonfJKgXXKFKmkDXwqpFnW5h85cuiLVIYN
         m4owuT8sbDhf0Vranpx0klaWGOBdQFE2neLhKqZfNdvC97uD1okhYm7xKsxeT2MF+o
         UamvAs5kgsmeQ0jZ6iZg8ISO1I5terkq/bOlCYeHqBeVYN6clQMf0jxmF/pa6Le0vz
         3bBRNfBPRMk9CtMqsM+ZC2XTEOmxUIahIN0+iaIy6KojZm4B2OURuOgzjkZIs1Xxzr
         OjbQjirNlBCoQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 05/16] devlink: Be explicit with devlink port protection
Date:   Mon,  8 Nov 2021 19:05:27 +0200
Message-Id: <e7989c996889c1ceb70a0a288f7b0a0e8ffda24b.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink port flows use devlink instance lock to protect from parallel
addition and deletion from port_list. So instead of using global lock,
let's introduce specific protection lock with much more clear scope
that will protect port_list.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 61 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index b41ab8751635..d88e882616bc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -41,6 +41,7 @@ struct devlink_dev_stats {
 struct devlink {
 	u32 index;
 	struct list_head port_list;
+	struct mutex port_list_lock; /* protects port_list */
 	struct list_head rate_list;
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
@@ -228,13 +229,17 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 						      unsigned int port_index)
 {
-	struct devlink_port *devlink_port;
+	struct devlink_port *devlink_port, *res = NULL;
 
+	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry(devlink_port, &devlink->port_list, list) {
-		if (devlink_port->index == port_index)
-			return devlink_port;
+		if (devlink_port->index == port_index) {
+			res = devlink_port;
+			break;
+		}
 	}
-	return NULL;
+	mutex_unlock(&devlink->port_list_lock);
+	return res;
 }
 
 static struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
@@ -1341,7 +1346,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			if (idx < start) {
 				idx++;
@@ -1353,13 +1358,13 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI, cb->extack);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->port_list_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->port_list_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -2567,8 +2572,9 @@ static int __sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_port *devlink_port;
 	u16 tc_index;
-	int err;
+	int err = 0;
 
+	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry(devlink_port, &devlink->port_list, list) {
 		for (tc_index = 0;
 		     tc_index < devlink_sb->ingress_tc_count; tc_index++) {
@@ -2585,7 +2591,7 @@ static int __sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 							      portid, seq,
 							      NLM_F_MULTI);
 			if (err)
-				return err;
+				goto out;
 			(*p_idx)++;
 		}
 		for (tc_index = 0;
@@ -2603,11 +2609,13 @@ static int __sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 							      portid, seq,
 							      NLM_F_MULTI);
 			if (err)
-				return err;
+				goto out;
 			(*p_idx)++;
 		}
 	}
-	return 0;
+out:
+	mutex_unlock(&devlink->port_list_lock);
+	return err;
 }
 
 static int
@@ -4938,7 +4946,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(devlink_port, &devlink->port_list, list) {
 			list_for_each_entry(param_item,
 					    &devlink_port->param_list, list) {
@@ -4956,14 +4964,14 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 				if (err == -EOPNOTSUPP) {
 					err = 0;
 				} else if (err) {
-					mutex_unlock(&devlink->lock);
+					mutex_unlock(&devlink->port_list_lock);
 					devlink_put(devlink);
 					goto out;
 				}
 				idx++;
 			}
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->port_list_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -5481,6 +5489,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 		(*idx)++;
 	}
 
+	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry(port, &devlink->port_list, list) {
 		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
 							    start);
@@ -5489,6 +5498,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	}
 
 out:
+	mutex_unlock(&devlink->port_list_lock);
 	mutex_unlock(&devlink->lock);
 	return err;
 }
@@ -7254,7 +7264,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->port_list_lock);
 		list_for_each_entry(port, &devlink->port_list, list) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
@@ -7269,7 +7279,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
 					mutex_unlock(&port->reporters_lock);
-					mutex_unlock(&devlink->lock);
+					mutex_unlock(&devlink->port_list_lock);
 					devlink_put(devlink);
 					goto out;
 				}
@@ -7277,7 +7287,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			}
 			mutex_unlock(&port->reporters_lock);
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->port_list_lock);
 retry_port:
 		devlink_put(devlink);
 	}
@@ -8978,7 +8988,10 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	devlink->ops = ops;
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
+
 	INIT_LIST_HEAD(&devlink->port_list);
+	mutex_init(&devlink->port_list_lock);
+
 	INIT_LIST_HEAD(&devlink->rate_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
@@ -9021,8 +9034,10 @@ static void devlink_notify_register(struct devlink *devlink)
 	struct devlink_region *region;
 
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
+	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry(devlink_port, &devlink->port_list, list)
 		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	mutex_unlock(&devlink->port_list_lock);
 
 	list_for_each_entry(policer_item, &devlink->trap_policer_list, list)
 		devlink_trap_policer_notify(devlink, policer_item,
@@ -9077,8 +9092,11 @@ static void devlink_notify_unregister(struct devlink *devlink)
 		devlink_trap_policer_notify(devlink, policer_item,
 					    DEVLINK_CMD_TRAP_POLICER_DEL);
 
+	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry_reverse(devlink_port, &devlink->port_list, list)
 		devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
+	mutex_unlock(&devlink->port_list_lock);
+
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
@@ -9129,6 +9147,7 @@ void devlink_free(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
 	mutex_destroy(&devlink->reporters_lock);
+	mutex_destroy(&devlink->port_list_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -9211,9 +9230,9 @@ void devlink_port_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&devlink_port->region_list);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->port_list_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->port_list_lock);
 
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9232,9 +9251,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->port_list_lock);
 	list_del(&devlink_port->list);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->port_list_lock);
 
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
 	WARN_ON(!list_empty(&devlink_port->region_list));
-- 
2.33.1

