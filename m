Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551FB440FC5
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 18:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhJaRie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 13:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhJaRid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 13:38:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4529760E9C;
        Sun, 31 Oct 2021 17:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635701762;
        bh=7hOW7hCyrNsepgPyCQ8+mXyL7BlIpMFgqEpeTvD1Q1w=;
        h=From:To:Cc:Subject:Date:From;
        b=VvQrUUSfxXwAukSqirBjD7GklNxzQPFsavf0GRlErLKNpFtlWadgqMd0IxHS0F8vQ
         TP4RRvprwdG4jk3GxkPkKqiVh9dJard5W5lTKAzL6xDecOJ4N1dMrPvc/acxBk7XlQ
         5al/QAPGaiJpF5acAIivFNeBmWMhAiGKb4OkxA2AO9p4be6AxriVU3wnBEmDJsykwX
         kJvvko/g1WDJhnNvWz5SWLESZGcEHNHBAT8lTPNUGo61hfqsrHnNpGlmE2bwC/tcYB
         eKfR1aACFX2m4LHoWjuIsixXjCZ1XflYKqWr52o5kykkfKfdeRNQ1NYiOgOkivhRKx
         4uuXbx04tMyvA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        idosch@idosch.org, edwin.peer@broadcom.com
Subject: [PATCH net-next] devlink: Require devlink lock during device reload
Date:   Sun, 31 Oct 2021 19:35:56 +0200
Message-Id: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink reload was implemented as a special command which does _SET_
operation, but doesn't take devlink->lock, while recursive devlink
calls that were part of .reload_up()/.reload_down() sequence took it.

This fragile flow was possible due to holding a big devlink lock
(devlink_mutex), which effectively stopped all devlink activities,
even unrelated to reloaded devlink.

So let's make sure that devlink reload behaves as other commands and
use special nested locking primitives with a depth of 1. Such change
opens us to a venue of removing devlink_mutex completely, while keeping
devlink locking complexity in devlink.c.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 58 ++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2d8abe88c673..e46f8ad43c20 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8734,7 +8734,6 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_reload,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
@@ -9219,7 +9218,7 @@ int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index)
 {
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	if (devlink_port_index_exists(devlink, port_index)) {
 		mutex_unlock(&devlink->lock);
 		return -EEXIST;
@@ -9253,7 +9252,7 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	list_del(&devlink_port->list);
 	mutex_unlock(&devlink->lock);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
@@ -9501,7 +9500,7 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	if (!devlink_rate)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	WARN_ON(devlink_port->devlink_rate);
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
@@ -9531,7 +9530,7 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 	if (!devlink_rate)
 		return;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
 	if (devlink_rate->parent)
 		refcount_dec(&devlink_rate->parent->refcnt);
@@ -9557,7 +9556,7 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 	static struct devlink_rate *devlink_rate, *tmp;
 	const struct devlink_ops *ops = devlink->ops;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 		if (!devlink_rate->parent)
 			continue;
@@ -9656,7 +9655,7 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	struct devlink_sb *devlink_sb;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	if (devlink_sb_index_exists(devlink, sb_index)) {
 		err = -EEXIST;
 		goto unlock;
@@ -9684,7 +9683,7 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 {
 	struct devlink_sb *devlink_sb;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
 	list_del(&devlink_sb->list);
@@ -9704,7 +9703,7 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 int devlink_dpipe_headers_register(struct devlink *devlink,
 				   struct devlink_dpipe_headers *dpipe_headers)
 {
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	devlink->dpipe_headers = dpipe_headers;
 	mutex_unlock(&devlink->lock);
 	return 0;
@@ -9720,7 +9719,7 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
  */
 void devlink_dpipe_headers_unregister(struct devlink *devlink)
 {
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	devlink->dpipe_headers = NULL;
 	mutex_unlock(&devlink->lock);
 }
@@ -9814,7 +9813,7 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 {
 	struct devlink_dpipe_table *table;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table)
@@ -9856,7 +9855,7 @@ int devlink_resource_register(struct devlink *devlink,
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (resource) {
 		err = -EINVAL;
@@ -9919,7 +9918,7 @@ void devlink_resources_unregister(struct devlink *devlink,
 		resource_list = &devlink->resource_list;
 
 	if (!resource)
-		mutex_lock(&devlink->lock);
+		mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 
 	list_for_each_entry_safe(child_resource, tmp, resource_list, list) {
 		devlink_resources_unregister(devlink, child_resource);
@@ -9946,7 +9945,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	struct devlink_resource *resource;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (!resource) {
 		err = -EINVAL;
@@ -9975,7 +9974,7 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 	struct devlink_dpipe_table *table;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	table = devlink_dpipe_table_find(&devlink->dpipe_table_list,
 					 table_name, devlink);
 	if (!table) {
@@ -10006,7 +10005,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10030,7 +10029,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -10278,7 +10277,7 @@ devlink_region_create(struct devlink *devlink,
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 
 	if (devlink_region_get_by_name(devlink, ops->name)) {
 		err = -EEXIST;
@@ -10369,7 +10368,7 @@ void devlink_region_destroy(struct devlink_region *region)
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -10402,7 +10401,7 @@ int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	int err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	err = __devlink_region_snapshot_id_get(devlink, id);
 	mutex_unlock(&devlink->lock);
 
@@ -10422,7 +10421,7 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
  */
 void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id)
 {
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	__devlink_snapshot_id_decrement(devlink, id);
 	mutex_unlock(&devlink->lock);
 }
@@ -10446,7 +10445,7 @@ int devlink_region_snapshot_create(struct devlink_region *region,
 	struct devlink *devlink = region->devlink;
 	int err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	err = __devlink_region_snapshot_create(region, data, snapshot_id);
 	mutex_unlock(&devlink->lock);
 
@@ -10831,7 +10830,7 @@ int devlink_traps_register(struct devlink *devlink,
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -10868,7 +10867,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -11049,7 +11048,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11086,7 +11085,7 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	for (i = groups_count - 1; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
 	mutex_unlock(&devlink->lock);
@@ -11189,7 +11188,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -11230,7 +11229,7 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 {
 	int i;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
 	for (i = policers_count - 1; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
 	mutex_unlock(&devlink->lock);
@@ -11400,6 +11399,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
 
+		mutex_lock_nested(&devlink->lock, SINGLE_DEPTH_NESTING);
+
 		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
 		err = devlink_reload(devlink, &init_net,
 				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
@@ -11407,6 +11408,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 				     &actions_performed, NULL);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
+		mutex_unlock(&devlink->lock);
 retry:
 		devlink_put(devlink);
 	}
-- 
2.31.1

