Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B4B449A79
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbhKHRJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241435AbhKHRJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C5F61406;
        Mon,  8 Nov 2021 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391180;
        bh=tq0Gg/TAMu/vt8uQk+2/qXKWAb9CPayZFTszfOa4jWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MG4S3zLaoZAl+isu29oty9JzHhQuriaG8UR4L6uUwXbXhNLj/MyV2fAoEGc0HbQbE
         KpeSnycw3isssptm9XUH7Tm7FuNKDt9YkFj0J1Erbsb1cl+kF0aBj/r/WodT0QXI5b
         /8WkkVtGtgQWUCOv+Li0BRWemxaGdozeKvtruJdGO3nZl7YBB/MsXBjrsvcv/DXabn
         StUk9ArWxiz4J6cJiBus2IKS3eyGkCJQZFMAtaY2vd95zWc2/fhbh222dKdpASgIZi
         7Rb7O8Mq6AC4SnyFgGb81GT+bGTBKjhQnziMMNw6OEVdLZEg6Y1OUbTLeHsbCgYkcy
         nlGP2K37TW/WQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 11/16] devlink: Protect all rate operations with specialized lock
Date:   Mon,  8 Nov 2021 19:05:33 +0200
Message-Id: <a0475d8c2592852ddfa0663469c96dcb14bdefff.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Separate rate related list protection from main devlink instance lock
to rely on specialized lock.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 60 +++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 52a1255a0917..008826bc108d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -43,6 +43,7 @@ struct devlink {
 	struct list_head port_list;
 	struct mutex port_list_lock; /* protects port_list */
 	struct list_head rate_list;
+	struct mutex rate_list_lock; /* protects rate_list */
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
 	struct list_head resource_list;
@@ -1143,7 +1144,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
-		mutex_lock(&devlink->lock);
+		mutex_lock(&devlink->rate_list_lock);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
 			u32 id = NETLINK_CB(cb->skb).portid;
@@ -1156,13 +1157,13 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 						   cb->nlh->nlmsg_seq,
 						   NLM_F_MULTI, NULL);
 			if (err) {
-				mutex_unlock(&devlink->lock);
+				mutex_unlock(&devlink->rate_list_lock);
 				devlink_put(devlink);
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->lock);
+		mutex_unlock(&devlink->rate_list_lock);
 retry:
 		devlink_put(devlink);
 	}
@@ -1829,15 +1830,21 @@ static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
 	if (!devlink_rate_set_ops_supported(ops, info, DEVLINK_RATE_TYPE_NODE))
 		return -EOPNOTSUPP;
 
+	mutex_lock(&devlink->rate_list_lock);
 	rate_node = devlink_rate_node_get_from_attrs(devlink, info->attrs);
-	if (!IS_ERR(rate_node))
-		return -EEXIST;
-	else if (rate_node == ERR_PTR(-EINVAL))
-		return -EINVAL;
+	if (!IS_ERR(rate_node)) {
+		err = -EEXIST;
+		goto out;
+	} else if (rate_node == ERR_PTR(-EINVAL)) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	rate_node = kzalloc(sizeof(*rate_node), GFP_KERNEL);
-	if (!rate_node)
-		return -ENOMEM;
+	if (!rate_node) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	rate_node->devlink = devlink;
 	rate_node->type = DEVLINK_RATE_TYPE_NODE;
@@ -1858,6 +1865,7 @@ static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
 	refcount_set(&rate_node->refcnt, 1);
 	list_add(&rate_node->list, &devlink->rate_list);
 	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
+	mutex_unlock(&devlink->rate_list_lock);
 	return 0;
 
 err_rate_set:
@@ -1866,6 +1874,8 @@ static int devlink_nl_cmd_rate_new_doit(struct sk_buff *skb,
 	kfree(rate_node->name);
 err_strdup:
 	kfree(rate_node);
+out:
+	mutex_unlock(&devlink->rate_list_lock);
 	return err;
 }
 
@@ -2800,14 +2810,14 @@ static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 	struct devlink_rate *devlink_rate;
 
 	/* Take the lock to sync with devlink_rate_nodes_destroy() */
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->rate_list_lock);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
 		if (devlink_rate_is_node(devlink_rate)) {
-			mutex_unlock(&devlink->lock);
+			mutex_unlock(&devlink->rate_list_lock);
 			NL_SET_ERR_MSG_MOD(extack, "Rate node(s) exists.");
 			return -EBUSY;
 		}
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->rate_list_lock);
 	return 0;
 }
 
@@ -9009,6 +9019,8 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->port_list_lock);
 
 	INIT_LIST_HEAD(&devlink->rate_list);
+	mutex_init(&devlink->rate_list_lock);
+
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
 
@@ -9077,8 +9089,10 @@ static void devlink_notify_register(struct devlink *devlink)
 		devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_NEW);
 	mutex_unlock(&devlink->traps_lock);
 
+	mutex_lock(&devlink->rate_list_lock);
 	list_for_each_entry(rate_node, &devlink->rate_list, list)
 		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
+	mutex_unlock(&devlink->rate_list_lock);
 
 	mutex_lock(&devlink->region_list_lock);
 	list_for_each_entry(region, &devlink->region_list, list)
@@ -9109,8 +9123,10 @@ static void devlink_notify_unregister(struct devlink *devlink)
 		devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
 	mutex_unlock(&devlink->region_list_lock);
 
+	mutex_lock(&devlink->rate_list_lock);
 	list_for_each_entry_reverse(rate_node, &devlink->rate_list, list)
 		devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_DEL);
+	mutex_unlock(&devlink->rate_list_lock);
 
 	mutex_lock(&devlink->traps_lock);
 	list_for_each_entry_reverse(trap_item, &devlink->trap_list, list)
@@ -9184,6 +9200,7 @@ void devlink_free(struct devlink *devlink)
 	mutex_destroy(&devlink->resource_list_lock);
 	mutex_destroy(&devlink->traps_lock);
 	mutex_destroy(&devlink->region_list_lock);
+	mutex_destroy(&devlink->rate_list_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -9522,8 +9539,6 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
  * Create devlink rate object of type leaf on provided @devlink_port.
  * Throws call trace if @devlink_port already has a devlink rate object.
  *
- * Context: Takes and release devlink->lock <mutex>.
- *
  * Return: -ENOMEM if failed to allocate rate object, 0 otherwise.
  */
 int
@@ -9536,16 +9551,17 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	if (!devlink_rate)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
 	WARN_ON(devlink_port->devlink_rate);
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
 	devlink_rate->devlink_port = devlink_port;
 	devlink_rate->priv = priv;
+
+	mutex_lock(&devlink->rate_list_lock);
 	list_add_tail(&devlink_rate->list, &devlink->rate_list);
 	devlink_port->devlink_rate = devlink_rate;
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->rate_list_lock);
 
 	return 0;
 }
@@ -9555,8 +9571,6 @@ EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
  * devlink_rate_leaf_destroy - destroy devlink rate leaf
  *
  * @devlink_port: devlink port linked to the rate object
- *
- * Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 {
@@ -9566,13 +9580,13 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 	if (!devlink_rate)
 		return;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->rate_list_lock);
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
 	if (devlink_rate->parent)
 		refcount_dec(&devlink_rate->parent->refcnt);
 	list_del(&devlink_rate->list);
 	devlink_port->devlink_rate = NULL;
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->rate_list_lock);
 	kfree(devlink_rate);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
@@ -9584,15 +9598,13 @@ EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
  *
  * Unset parent for all rate objects and destroy all rate nodes
  * on specified device.
- *
- * Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_rate_nodes_destroy(struct devlink *devlink)
 {
 	static struct devlink_rate *devlink_rate, *tmp;
 	const struct devlink_ops *ops = devlink->ops;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->rate_list_lock);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 		if (!devlink_rate->parent)
 			continue;
@@ -9613,7 +9625,7 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 			kfree(devlink_rate);
 		}
 	}
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->rate_list_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
 
-- 
2.33.1

