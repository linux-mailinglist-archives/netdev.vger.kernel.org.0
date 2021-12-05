Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B22468A1C
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhLEI0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:26:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56252 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbhLEI0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:26:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3D0960AD4;
        Sun,  5 Dec 2021 08:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52571C341C4;
        Sun,  5 Dec 2021 08:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638692555;
        bh=/R7O1XOOY/pxR03X/1GvRhdKRCm4gIhzPUDfgRLrioo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDWUb/P+p6h5sL0QCxkHoxYlibJ0cw1yKuR5kgkY6F2qEVvd9LKqkqE2yorCPeMnJ
         VEdvdUfy0zW7aOYRDkL8YJ99pHYgLTHr9vuMCs1H3N7FLy/2/ZtqjzQWiN0epb00UW
         ze0nJKF3ZFvdWSd7Zon86ioXCnmYFCR0lb8oLTzOgT7XOgKm4iDbVVavkNZZ33axjJ
         dVqKDXAJn0WxnkBvfIfFk+BRVj0W/U4S7GmAXlp9aZC4FK0STCRl5uw+oHeCHfUCvm
         xsFHgq3xChQGd9KuVDPESBuKk9LfPse8my+2TCmFoxX5TQYUjIdTW2nToFbHaX++ZD
         W4rpR+yJ0S2Ew==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/6] devlink: Add devlink nested locking primitive
Date:   Sun,  5 Dec 2021 10:22:03 +0200
Message-Id: <2b64a2a81995b56fec0231751ff6075020058584.1638690564.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1638690564.git.leonro@nvidia.com>
References: <cover.1638690564.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Basic kernel locking primitives lack ability to avoid taking lock
if the lock is already taken by the caller before. In the devlink
case, we can easily implement such context behaviour, because all
user-space entries will take the devlink->lock in the following
patches, while kernel-space entries will need to take that lock
on the entry.

Such change will allow us to take devlink->lock for devlink reload too.

Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 146 +++++++++++++++++++++++++++------------------
 1 file changed, 88 insertions(+), 58 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index eddd554b50d4..7dd6091b97af 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -182,6 +182,7 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 
 static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 #define DEVLINK_REGISTERED XA_MARK_1
+#define DEVLINK_NESTED_LOCK XA_MARK_2
 
 /* devlink instances are open to the access from the user space after
  * devlink_register() call. Such logical barrier allows us to have certain
@@ -226,6 +227,28 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 	return NULL;
 }
 
+static void devlink_nested_lock(struct devlink *devlink)
+	__acquires(&devlink->lock)
+{
+	if (xa_get_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK))
+		__acquire(&devlink->lock);
+	else
+		mutex_lock(&devlink->lock);
+
+	lockdep_assert_held(&devlink->lock);
+}
+
+static void devlink_nested_unlock(struct devlink *devlink)
+	__releases(&devlink->lock)
+{
+	lockdep_assert_held(&devlink->lock);
+
+	if (xa_get_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK))
+		__release(&devlink->lock);
+	else
+		mutex_unlock(&devlink->lock);
+}
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -594,6 +617,7 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
+	__acquires(&devlink->lock)
 {
 	struct devlink_port *devlink_port;
 	struct devlink *devlink;
@@ -605,8 +629,10 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 		mutex_unlock(&devlink_mutex);
 		return PTR_ERR(devlink);
 	}
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
+	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK) {
 		mutex_lock(&devlink->lock);
+		xa_set_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
+	}
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
@@ -641,8 +667,10 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	return 0;
 
 unlock:
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
+	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK) {
+		xa_clear_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
 		mutex_unlock(&devlink->lock);
+	}
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 	return err;
@@ -650,12 +678,15 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 
 static void devlink_nl_post_doit(const struct genl_ops *ops,
 				 struct sk_buff *skb, struct genl_info *info)
+	__releases(&devlink->lock)
 {
 	struct devlink *devlink;
 
 	devlink = info->user_ptr[0];
-	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
+	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK) {
+		xa_clear_mark(&devlinks, devlink->index, DEVLINK_NESTED_LOCK);
 		mutex_unlock(&devlink->lock);
+	}
 	devlink_put(devlink);
 	mutex_unlock(&devlink_mutex);
 }
@@ -9545,7 +9576,7 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	if (!devlink_rate)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	WARN_ON(devlink_port->devlink_rate);
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
@@ -9554,7 +9585,7 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	list_add_tail(&devlink_rate->list, &devlink->rate_list);
 	devlink_port->devlink_rate = devlink_rate;
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 
 	return 0;
 }
@@ -9575,13 +9606,13 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 	if (!devlink_rate)
 		return;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
 	if (devlink_rate->parent)
 		refcount_dec(&devlink_rate->parent->refcnt);
 	list_del(&devlink_rate->list);
 	devlink_port->devlink_rate = NULL;
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	kfree(devlink_rate);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
@@ -9601,7 +9632,7 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 	static struct devlink_rate *devlink_rate, *tmp;
 	const struct devlink_ops *ops = devlink->ops;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 		if (!devlink_rate->parent)
 			continue;
@@ -9622,7 +9653,7 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 			kfree(devlink_rate);
 		}
 	}
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
 
@@ -9700,7 +9731,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	struct devlink_sb *devlink_sb;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	if (devlink_sb_index_exists(devlink, sb_index)) {
 		err = -EEXIST;
 		goto unlock;
@@ -9719,7 +9750,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	devlink_sb->egress_tc_count = egress_tc_count;
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
@@ -9728,11 +9759,11 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 {
 	struct devlink_sb *devlink_sb;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
 	list_del(&devlink_sb->list);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	kfree(devlink_sb);
 }
 EXPORT_SYMBOL_GPL(devlink_sb_unregister);
@@ -9748,9 +9779,9 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 int devlink_dpipe_headers_register(struct devlink *devlink,
 				   struct devlink_dpipe_headers *dpipe_headers)
 {
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	devlink->dpipe_headers = dpipe_headers;
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
@@ -9764,9 +9795,9 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
  */
 void devlink_dpipe_headers_unregister(struct devlink *devlink)
 {
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	devlink->dpipe_headers = NULL;
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_unregister);
 
@@ -9821,7 +9852,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 	if (WARN_ON(!table_ops->size_get))
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 
 	if (devlink_dpipe_table_find(&devlink->dpipe_table_list, table_name,
 				     devlink)) {
@@ -9842,7 +9873,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 
 	list_add_tail_rcu(&table->list, &devlink->dpipe_table_list);
 unlock:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
@@ -9858,17 +9889,17 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 {
 	struct devlink_dpipe_table *table;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table)
 		goto unlock;
 	list_del_rcu(&table->list);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	kfree_rcu(table, rcu);
 	return;
 unlock:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
 
@@ -9900,7 +9931,7 @@ int devlink_resource_register(struct devlink *devlink,
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (resource) {
 		err = -EINVAL;
@@ -9940,7 +9971,7 @@ int devlink_resource_register(struct devlink *devlink,
 	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
 out:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_register);
@@ -9967,7 +9998,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 {
 	struct devlink_resource *tmp, *child_resource;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 
 	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
 				 list) {
@@ -9975,8 +10006,7 @@ void devlink_resources_unregister(struct devlink *devlink)
 		list_del(&child_resource->list);
 		kfree(child_resource);
 	}
-
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
@@ -9994,7 +10024,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	struct devlink_resource *resource;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (!resource) {
 		err = -EINVAL;
@@ -10003,7 +10033,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	*p_resource_size = resource->size_new;
 	resource->size = resource->size_new;
 out:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_size_get);
@@ -10023,7 +10053,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	struct devlink_dpipe_table *table;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table) {
@@ -10034,7 +10064,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	table->resource_units = resource_units;
 	table->resource_valid = true;
 out:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
@@ -10054,7 +10084,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10063,7 +10093,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 	resource->occ_get = occ_get;
 	resource->occ_get_priv = occ_get_priv;
 out:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
 
@@ -10078,7 +10108,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10087,7 +10117,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 	resource->occ_get = NULL;
 	resource->occ_get_priv = NULL;
 out:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
 
@@ -10326,7 +10356,7 @@ devlink_region_create(struct devlink *devlink,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 
 	if (devlink_region_get_by_name(devlink, ops->name)) {
 		err = -EEXIST;
@@ -10347,11 +10377,11 @@ devlink_region_create(struct devlink *devlink,
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return region;
 
 unlock:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(devlink_region_create);
@@ -10376,7 +10406,7 @@ devlink_port_region_create(struct devlink_port *port,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 
 	if (devlink_port_region_get_by_name(port, ops->name)) {
 		err = -EEXIST;
@@ -10398,11 +10428,11 @@ devlink_port_region_create(struct devlink_port *port,
 	list_add_tail(&region->list, &port->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return region;
 
 unlock:
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(devlink_port_region_create);
@@ -10417,7 +10447,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -10426,7 +10456,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	kfree(region);
 }
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
@@ -10879,7 +10909,7 @@ int devlink_traps_register(struct devlink *devlink,
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -10891,7 +10921,7 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 
 	return 0;
 
@@ -10899,7 +10929,7 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_traps_register);
@@ -10916,7 +10946,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -10925,7 +10955,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
 
@@ -11097,7 +11127,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11109,7 +11139,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 
 	return 0;
 
@@ -11117,7 +11147,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
@@ -11134,10 +11164,10 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	for (i = groups_count - 1; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
 
@@ -11237,7 +11267,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -11252,7 +11282,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 
 	return 0;
 
@@ -11260,7 +11290,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
@@ -11278,10 +11308,10 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	devlink_nested_lock(devlink);
 	for (i = policers_count - 1; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-	mutex_unlock(&devlink->lock);
+	devlink_nested_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
 
-- 
2.33.1

