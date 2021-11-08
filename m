Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DC2449A78
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240498AbhKHRJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241431AbhKHRJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31A386120A;
        Mon,  8 Nov 2021 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391176;
        bh=xXuKLQObFUgfLmuLEDUT6jwWURydljj59SldGzW0B50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAUHXHGToNJ0Tixt32huUOBXeZLvcctrnBvR4et71IHOoHXAhpraZ46rZtGaCv0rc
         1YE+Idpg3jAaOYQYqQVM5ndEtuq3iJHFcVqMGbLR6nfPhMtoTxS17TMKb8Rrc1oozh
         vKvGF3C6AGQobRjOHQgs72KvU/5mfdpdfXKGrgz8W2FRNLVbwEdiY7h41m1DBF5BWd
         fLYyr5zdDb2/zWG8Kb27EYa5o92JPrBE7RE/C8mk5Ey1ITjXP7xoFmO89SLPVK4yXd
         HJRtGwn0juaVvo6BGd4CQxYwT4TmOLh5uowf1hp7U50gLfvr2JO/+WyIIojCt93QWy
         GR5qYBfUeo5pQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 10/16] devlink: Separate region list protection to be done with specialized lock
Date:   Mon,  8 Nov 2021 19:05:32 +0200
Message-Id: <a84ddeda0fb9f6a4b895bb0a8a92b22773d602f3.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Reduce scope of devlink->lock and use dedicated lock to protect region_list.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 66 +++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e89eaaba653d..52a1255a0917 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -49,6 +49,7 @@ struct devlink {
 	struct mutex resource_list_lock; /* protects resource_list */
 	struct list_head param_list;
 	struct list_head region_list;
+	struct mutex region_list_lock; /* protects region_list, including port */
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
@@ -5412,25 +5413,28 @@ static int devlink_nl_cmd_region_get_port_dumpit(struct sk_buff *msg,
 						 int *idx,
 						 int start)
 {
+	struct devlink *devlink = port->devlink;
 	struct devlink_region *region;
 	int err = 0;
 
+	mutex_lock(&devlink->region_list_lock);
 	list_for_each_entry(region, &port->region_list, list) {
 		if (*idx < start) {
 			(*idx)++;
 			continue;
 		}
-		err = devlink_nl_region_fill(msg, port->devlink,
+		err = devlink_nl_region_fill(msg, devlink,
 					     DEVLINK_CMD_REGION_GET,
 					     NETLINK_CB(cb->skb).portid,
-					     cb->nlh->nlmsg_seq,
-					     NLM_F_MULTI, region);
+					     cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					     region);
 		if (err)
 			goto out;
 		(*idx)++;
 	}
 
 out:
+	mutex_unlock(&devlink->region_list_lock);
 	return err;
 }
 
@@ -5444,7 +5448,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	struct devlink_port *port;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 	list_for_each_entry(region, &devlink->region_list, list) {
 		if (*idx < start) {
 			(*idx)++;
@@ -5455,22 +5459,22 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 					     NETLINK_CB(cb->skb).portid,
 					     cb->nlh->nlmsg_seq,
 					     NLM_F_MULTI, region);
-		if (err)
-			goto out;
+		if (err) {
+			mutex_unlock(&devlink->region_list_lock);
+			return err;
+		}
 		(*idx)++;
 	}
+	mutex_unlock(&devlink->region_list_lock);
 
 	mutex_lock(&devlink->port_list_lock);
 	list_for_each_entry(port, &devlink->port_list, list) {
 		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
 							    start);
 		if (err)
-			goto out;
+			break;
 	}
-
-out:
 	mutex_unlock(&devlink->port_list_lock);
-	mutex_unlock(&devlink->lock);
 	return err;
 }
 
@@ -5760,7 +5764,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_dev;
 	}
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 
 	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
 	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
@@ -5856,7 +5860,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	nla_nest_end(skb, chunks_attr);
 	genlmsg_end(skb, hdr);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 
@@ -5865,7 +5869,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 nla_put_failure:
 	genlmsg_cancel(skb, hdr);
 out_unlock:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 	devlink_put(devlink);
 out_dev:
 	mutex_unlock(&devlink_mutex);
@@ -9012,7 +9016,10 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->resource_list_lock);
 
 	INIT_LIST_HEAD(&devlink->param_list);
+
 	INIT_LIST_HEAD(&devlink->region_list);
+	mutex_init(&devlink->region_list_lock);
+
 	INIT_LIST_HEAD(&devlink->reporter_list);
 
 	INIT_LIST_HEAD(&devlink->trap_list);
@@ -9073,8 +9080,10 @@ static void devlink_notify_register(struct devlink *devlink)
 	list_for_each_entry(rate_node, &devlink->rate_list, list)
 		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
 
+	mutex_lock(&devlink->region_list_lock);
 	list_for_each_entry(region, &devlink->region_list, list)
 		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
+	mutex_unlock(&devlink->region_list_lock);
 
 	list_for_each_entry(param_item, &devlink->param_list, list)
 		devlink_param_notify(devlink, 0, param_item,
@@ -9095,8 +9104,10 @@ static void devlink_notify_unregister(struct devlink *devlink)
 		devlink_param_notify(devlink, 0, param_item,
 				     DEVLINK_CMD_PARAM_DEL);
 
+	mutex_lock(&devlink->region_list_lock);
 	list_for_each_entry_reverse(region, &devlink->region_list, list)
 		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
+	mutex_unlock(&devlink->region_list_lock);
 
 	list_for_each_entry_reverse(rate_node, &devlink->rate_list, list)
 		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_DEL);
@@ -9172,6 +9183,7 @@ void devlink_free(struct devlink *devlink)
 	mutex_destroy(&devlink->port_list_lock);
 	mutex_destroy(&devlink->resource_list_lock);
 	mutex_destroy(&devlink->traps_lock);
+	mutex_destroy(&devlink->region_list_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -10293,7 +10305,7 @@ devlink_region_create(struct devlink *devlink,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 
 	if (devlink_region_get_by_name(devlink, ops->name)) {
 		err = -EEXIST;
@@ -10314,11 +10326,11 @@ devlink_region_create(struct devlink *devlink,
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 	return region;
 
 unlock:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(devlink_region_create);
@@ -10343,7 +10355,7 @@ devlink_port_region_create(struct devlink_port *port,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 
 	if (devlink_port_region_get_by_name(port, ops->name)) {
 		err = -EEXIST;
@@ -10365,11 +10377,11 @@ devlink_port_region_create(struct devlink_port *port,
 	list_add_tail(&region->list, &port->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 	return region;
 
 unlock:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(devlink_port_region_create);
@@ -10384,7 +10396,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -10393,7 +10405,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 	kfree(region);
 }
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
@@ -10417,9 +10429,9 @@ int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	int err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 	err = __devlink_region_snapshot_id_get(devlink, id);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 
 	return err;
 }
@@ -10437,9 +10449,9 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
  */
 void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id)
 {
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 	__devlink_snapshot_id_decrement(devlink, id);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_put);
 
@@ -10461,9 +10473,9 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink *devlink = region->devlink;
 	int err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->region_list_lock);
 	err = __devlink_region_snapshot_create(region, data, snapshot_id);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->region_list_lock);
 
 	return err;
 }
-- 
2.33.1

