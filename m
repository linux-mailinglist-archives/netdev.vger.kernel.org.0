Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4E8449A7B
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241429AbhKHRJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241427AbhKHRJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD766120A;
        Mon,  8 Nov 2021 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391187;
        bh=L/Se/zv2J2DbfeHOL0Y+51ZLfzrv9gpbzkne+e66N9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T78uQG8Ez6DiEOedMvRsrwsaixUoOlrwST4CKidQLZiUcUn9P5cfyrTCy99t2Gv9Y
         mkNZqQo47WH5szv9lJ3me49qjBvk/v0BuLb+lyTfyr1WfHK/dN6SKoehJJM82hhmV/
         7tD+VR/zSeS/XDnUgSlFpiOmfKCqe5VQAi3Syel67TRexj5F47OgHqxVC10jRBGnsd
         a4ce6G7RIe1fsBKNGDwcbR6pQVWZFAgxShmLqgS55TZA3B4sOKUxZj+MyYQN4VmQUA
         KN/9gUxzvgERY1vy1i5fA4BdSGHy6ZIwdW5+nfKRkxjsqskzEuheRJrxSBnA6dLMv6
         9YfPEu5VCvIIA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 13/16] devlink: Convert dpipe to use dpipe_lock
Date:   Mon,  8 Nov 2021 19:05:35 +0200
Message-Id: <442025795c7508af22a2b656abf7c3ca6ac8f762.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Separate dpipe related list protection from main devlink instance lock
to rely on specialized lock.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 67 +++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 19f1802f1e5d..60af6a3fc130 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -47,6 +47,7 @@ struct devlink {
 	struct list_head sb_list;
 	struct mutex sb_list_lock; /* protects sb_list */
 	struct list_head dpipe_table_list;
+	struct mutex dpipe_lock; /* protects dpipe_table_list */
 	struct list_head resource_list;
 	struct mutex resource_list_lock; /* protects resource_list */
 	struct list_head param_list;
@@ -3105,13 +3106,16 @@ static int devlink_nl_cmd_dpipe_table_get(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	const char *table_name =  NULL;
+	int ret;
 
 	if (info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME])
 		table_name = nla_data(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME]);
 
-	return devlink_dpipe_tables_fill(info, DEVLINK_CMD_DPIPE_TABLE_GET, 0,
-					 &devlink->dpipe_table_list,
-					 table_name);
+	mutex_lock(&devlink->dpipe_lock);
+	ret = devlink_dpipe_tables_fill(info, DEVLINK_CMD_DPIPE_TABLE_GET, 0,
+					&devlink->dpipe_table_list, table_name);
+	mutex_unlock(&devlink->dpipe_lock);
+	return ret;
 }
 
 static int devlink_dpipe_value_put(struct sk_buff *skb,
@@ -3266,7 +3270,7 @@ devlink_dpipe_table_find(struct list_head *dpipe_tables,
 {
 	struct devlink_dpipe_table *table;
 	list_for_each_entry_rcu(table, dpipe_tables, list,
-				lockdep_is_held(&devlink->lock)) {
+				lockdep_is_held(&devlink->dpipe_lock)) {
 		if (!strcmp(table->name, table_name))
 			return table;
 	}
@@ -3379,21 +3383,31 @@ static int devlink_nl_cmd_dpipe_entries_get(struct sk_buff *skb,
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_dpipe_table *table;
 	const char *table_name;
+	int ret;
 
 	if (!info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME])
 		return -EINVAL;
 
 	table_name = nla_data(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME]);
+	mutex_lock(&devlink->dpipe_lock);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
-	if (!table)
-		return -EINVAL;
+	if (!table) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (!table->table_ops->entries_dump)
-		return -EINVAL;
+	if (!table->table_ops->entries_dump) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	return devlink_dpipe_entries_fill(info, DEVLINK_CMD_DPIPE_ENTRIES_GET,
-					  0, table);
+	ret = devlink_dpipe_entries_fill(info, DEVLINK_CMD_DPIPE_ENTRIES_GET, 0,
+					 table);
+
+out:
+	mutex_unlock(&devlink->dpipe_lock);
+	return ret;
 }
 
 static int devlink_dpipe_fields_put(struct sk_buff *skb,
@@ -3563,6 +3577,7 @@ static int devlink_nl_cmd_dpipe_table_counters_set(struct sk_buff *skb,
 	struct devlink *devlink = info->user_ptr[0];
 	const char *table_name;
 	bool counters_enable;
+	int ret;
 
 	if (!info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME] ||
 	    !info->attrs[DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED])
@@ -3571,8 +3586,11 @@ static int devlink_nl_cmd_dpipe_table_counters_set(struct sk_buff *skb,
 	table_name = nla_data(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME]);
 	counters_enable = !!nla_get_u8(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED]);
 
-	return devlink_dpipe_table_counters_set(devlink, table_name,
-						counters_enable);
+	mutex_lock(&devlink->dpipe_lock);
+	ret = devlink_dpipe_table_counters_set(devlink, table_name,
+					       counters_enable);
+	mutex_unlock(&devlink->dpipe_lock);
+	return ret;
 }
 
 static struct devlink_resource *
@@ -9026,6 +9044,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->sb_list_lock);
 
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
+	mutex_init(&devlink->dpipe_lock);
 
 	INIT_LIST_HEAD(&devlink->resource_list);
 	mutex_init(&devlink->resource_list_lock);
@@ -9205,6 +9224,7 @@ void devlink_free(struct devlink *devlink)
 	mutex_destroy(&devlink->region_list_lock);
 	mutex_destroy(&devlink->rate_list_lock);
 	mutex_destroy(&devlink->sb_list_lock);
+	mutex_destroy(&devlink->dpipe_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -9751,9 +9771,9 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 int devlink_dpipe_headers_register(struct devlink *devlink,
 				   struct devlink_dpipe_headers *dpipe_headers)
 {
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->dpipe_lock);
 	devlink->dpipe_headers = dpipe_headers;
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->dpipe_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
@@ -9767,9 +9787,9 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
  */
 void devlink_dpipe_headers_unregister(struct devlink *devlink)
 {
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->dpipe_lock);
 	devlink->dpipe_headers = NULL;
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->dpipe_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_unregister);
 
@@ -9824,8 +9844,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
-
+	mutex_lock(&devlink->dpipe_lock);
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name,
 				     devlink)) {
 		err = -EEXIST;
@@ -9845,7 +9864,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->dpipe_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
@@ -9861,17 +9880,17 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 {
 	struct devlink_dpipe_table *table;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->dpipe_lock);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table)
 		goto unlock;
 	list_del_rcu(&table->list);
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->dpipe_lock);
 	kfree_rcu(table, rcu);
 	return;
 unlock:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->dpipe_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
 
@@ -10018,7 +10037,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	struct devlink_dpipe_table *table;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->dpipe_lock);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table) {
@@ -10029,7 +10048,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	table->resource_units = resource_units;
 	table->resource_valid = true;
 out:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->dpipe_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
-- 
2.33.1

