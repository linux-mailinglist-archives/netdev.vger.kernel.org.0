Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD73164D52C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiLOCCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiLOCCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D3D4876E
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4205D61CE2
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B229C433F1;
        Thu, 15 Dec 2022 02:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069723;
        bh=OrDh6nzfm+jwS5SUh/uVEcv9O627FCOGdOPZqAi7Itc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUDpoMKmzEhWUOjzW/Yq1Ooig70IJR13v9J8e77bdPiQ2QYrxbJO6qJ3Jmdel1yHe
         8BgJ25iVf8GMSu2TMo0/vZJb2NAaGQkRUb6r9/lDGacnnM0jaoNNZM2cbgVylyem7Y
         tBGnTqQHQRAfE7KvzvyJr/fc/gCjrEzkZKc6kU/17lO1YmtOGiqQqGoP0luHZfB23a
         /T0Glr7fi3yowJ9GETNsSDGRzp2fb4w69o1qZfm+Kbf6Fwznn2XE0ypY6oMv/pqV3G
         ikUbDMAvmNjYXzmGpnM2ECM8IaEFQkksMuHhcnmiQCZokXAqc6+CxkePEEdjyNg4vC
         rx2SUyZxYN9TA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 02/15] devlink: split out core code
Date:   Wed, 14 Dec 2022 18:01:42 -0800
Message-Id: <20221215020155.1619839-3-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move core code into a separate file. It's spread around the main
file which makes refactoring and figuring out how devlink works
harder.

Move the xarray, all the most core devlink instance code out like
locking, ref counting, alloc, register, etc. Leave port stuff in
basic.c, if we want to move port code it'd probably be to its own file.

Rename devlink_netdevice_event() to make it clear that it only touches
ports (that's the only change which isn't a pure code move).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/Makefile        |   2 +-
 net/devlink/basic.c         | 444 +-----------------------------------
 net/devlink/core.c          | 347 ++++++++++++++++++++++++++++
 net/devlink/devl_internal.h | 117 ++++++++++
 4 files changed, 476 insertions(+), 434 deletions(-)
 create mode 100644 net/devlink/core.c
 create mode 100644 net/devlink/devl_internal.h

diff --git a/net/devlink/Makefile b/net/devlink/Makefile
index ba54922128ab..425532776929 100644
--- a/net/devlink/Makefile
+++ b/net/devlink/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := basic.o
+obj-y := basic.o core.o
diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index d2df30829083..3c53a742f472 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -31,52 +31,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/devlink.h>
 
-#define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
-	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
-
-struct devlink_dev_stats {
-	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
-	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
-};
-
-struct devlink {
-	u32 index;
-	struct xarray ports;
-	struct list_head rate_list;
-	struct list_head sb_list;
-	struct list_head dpipe_table_list;
-	struct list_head resource_list;
-	struct list_head param_list;
-	struct list_head region_list;
-	struct list_head reporter_list;
-	struct mutex reporters_lock; /* protects reporter_list */
-	struct devlink_dpipe_headers *dpipe_headers;
-	struct list_head trap_list;
-	struct list_head trap_group_list;
-	struct list_head trap_policer_list;
-	struct list_head linecard_list;
-	struct mutex linecards_lock; /* protects linecard_list */
-	const struct devlink_ops *ops;
-	u64 features;
-	struct xarray snapshot_ids;
-	struct devlink_dev_stats stats;
-	struct device *dev;
-	possible_net_t _net;
-	/* Serializes access to devlink instance specific objects such as
-	 * port, sb, dpipe, resource, params, region, traps and more.
-	 */
-	struct mutex lock;
-	struct lock_class_key lock_key;
-	u8 reload_failed:1;
-	refcount_t refcount;
-	struct completion comp;
-	struct rcu_head rcu;
-	struct notifier_block netdevice_nb;
-	char priv[] __aligned(NETDEV_ALIGN);
-};
-
-struct devlink_linecard_ops;
-struct devlink_linecard_type;
+#include "devl_internal.h"
 
 struct devlink_linecard {
 	struct list_head list;
@@ -122,24 +77,6 @@ struct devlink_resource {
 	void *occ_get_priv;
 };
 
-void *devlink_priv(struct devlink *devlink)
-{
-	return &devlink->priv;
-}
-EXPORT_SYMBOL_GPL(devlink_priv);
-
-struct devlink *priv_to_devlink(void *priv)
-{
-	return container_of(priv, struct devlink, priv);
-}
-EXPORT_SYMBOL_GPL(priv_to_devlink);
-
-struct device *devlink_to_dev(const struct devlink *devlink)
-{
-	return devlink->dev;
-}
-EXPORT_SYMBOL_GPL(devlink_to_dev);
-
 static struct devlink_dpipe_field devlink_dpipe_fields_ethernet[] = {
 	{
 		.name = "destination mac",
@@ -211,148 +148,6 @@ static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_
 	[DEVLINK_ATTR_SELFTEST_ID_FLASH] = { .type = NLA_FLAG },
 };
 
-static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
-#define DEVLINK_REGISTERED XA_MARK_1
-#define DEVLINK_UNREGISTERING XA_MARK_2
-
-/* devlink instances are open to the access from the user space after
- * devlink_register() call. Such logical barrier allows us to have certain
- * expectations related to locking.
- *
- * Before *_register() - we are in initialization stage and no parallel
- * access possible to the devlink instance. All drivers perform that phase
- * by implicitly holding device_lock.
- *
- * After *_register() - users and driver can access devlink instance at
- * the same time.
- */
-#define ASSERT_DEVLINK_REGISTERED(d)                                           \
-	WARN_ON_ONCE(!xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
-#define ASSERT_DEVLINK_NOT_REGISTERED(d)                                       \
-	WARN_ON_ONCE(xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
-
-struct net *devlink_net(const struct devlink *devlink)
-{
-	return read_pnet(&devlink->_net);
-}
-EXPORT_SYMBOL_GPL(devlink_net);
-
-static void __devlink_put_rcu(struct rcu_head *head)
-{
-	struct devlink *devlink = container_of(head, struct devlink, rcu);
-
-	complete(&devlink->comp);
-}
-
-void devlink_put(struct devlink *devlink)
-{
-	if (refcount_dec_and_test(&devlink->refcount))
-		/* Make sure unregister operation that may await the completion
-		 * is unblocked only after all users are after the end of
-		 * RCU grace period.
-		 */
-		call_rcu(&devlink->rcu, __devlink_put_rcu);
-}
-
-struct devlink *__must_check devlink_try_get(struct devlink *devlink)
-{
-	if (refcount_inc_not_zero(&devlink->refcount))
-		return devlink;
-	return NULL;
-}
-
-void devl_assert_locked(struct devlink *devlink)
-{
-	lockdep_assert_held(&devlink->lock);
-}
-EXPORT_SYMBOL_GPL(devl_assert_locked);
-
-#ifdef CONFIG_LOCKDEP
-/* For use in conjunction with LOCKDEP only e.g. rcu_dereference_protected() */
-bool devl_lock_is_held(struct devlink *devlink)
-{
-	return lockdep_is_held(&devlink->lock);
-}
-EXPORT_SYMBOL_GPL(devl_lock_is_held);
-#endif
-
-void devl_lock(struct devlink *devlink)
-{
-	mutex_lock(&devlink->lock);
-}
-EXPORT_SYMBOL_GPL(devl_lock);
-
-int devl_trylock(struct devlink *devlink)
-{
-	return mutex_trylock(&devlink->lock);
-}
-EXPORT_SYMBOL_GPL(devl_trylock);
-
-void devl_unlock(struct devlink *devlink)
-{
-	mutex_unlock(&devlink->lock);
-}
-EXPORT_SYMBOL_GPL(devl_unlock);
-
-static struct devlink *
-devlinks_xa_find_get(struct net *net, unsigned long *indexp, xa_mark_t filter,
-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
-					  unsigned long, xa_mark_t))
-{
-	struct devlink *devlink;
-
-	rcu_read_lock();
-retry:
-	devlink = xa_find_fn(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
-	if (!devlink)
-		goto unlock;
-
-	/* In case devlink_unregister() was already called and "unregistering"
-	 * mark was set, do not allow to get a devlink reference here.
-	 * This prevents live-lock of devlink_unregister() wait for completion.
-	 */
-	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
-		goto retry;
-
-	/* For a possible retry, the xa_find_after() should be always used */
-	xa_find_fn = xa_find_after;
-	if (!devlink_try_get(devlink))
-		goto retry;
-	if (!net_eq(devlink_net(devlink), net)) {
-		devlink_put(devlink);
-		goto retry;
-	}
-unlock:
-	rcu_read_unlock();
-	return devlink;
-}
-
-static struct devlink *devlinks_xa_find_get_first(struct net *net,
-						  unsigned long *indexp,
-						  xa_mark_t filter)
-{
-	return devlinks_xa_find_get(net, indexp, filter, xa_find);
-}
-
-static struct devlink *devlinks_xa_find_get_next(struct net *net,
-						 unsigned long *indexp,
-						 xa_mark_t filter)
-{
-	return devlinks_xa_find_get(net, indexp, filter, xa_find_after);
-}
-
-/* Iterate over devlink pointers which were possible to get reference to.
- * devlink_put() needs to be called for each iterated devlink pointer
- * in loop body in order to release the reference.
- */
-#define devlinks_xa_for_each_get(net, index, devlink, filter)			\
-	for (index = 0,								\
-	     devlink = devlinks_xa_find_get_first(net, &index, filter);		\
-	     devlink; devlink = devlinks_xa_find_get_next(net, &index, filter))
-
-#define devlinks_xa_for_each_registered_get(net, index, devlink)		\
-	devlinks_xa_for_each_get(net, index, devlink, DEVLINK_REGISTERED)
-
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
@@ -917,8 +712,6 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 	devlink_put(devlink);
 }
 
-static struct genl_family devlink_nl_family;
-
 enum devlink_multicast_groups {
 	DEVLINK_MCGRP_CONFIG,
 };
@@ -4650,11 +4443,6 @@ static void devlink_ns_change_notify(struct devlink *devlink,
 		devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
-static bool devlink_reload_supported(const struct devlink_ops *ops)
-{
-	return ops->reload_down && ops->reload_up;
-}
-
 static void devlink_reload_failed_set(struct devlink *devlink,
 				      bool reload_failed)
 {
@@ -4722,9 +4510,10 @@ void devlink_remote_reload_actions_performed(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_remote_reload_actions_performed);
 
-static int devlink_reload(struct devlink *devlink, struct net *dest_net,
-			  enum devlink_reload_action action, enum devlink_reload_limit limit,
-			  u32 *actions_performed, struct netlink_ext_ack *extack)
+int devlink_reload(struct devlink *devlink, struct net *dest_net,
+		   enum devlink_reload_action action,
+		   enum devlink_reload_limit limit,
+		   u32 *actions_performed, struct netlink_ext_ack *extack)
 {
 	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
 	struct net *curr_net;
@@ -9874,7 +9663,7 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 	},
 };
 
-static struct genl_family devlink_nl_family __ro_after_init = {
+struct genl_family devlink_nl_family __ro_after_init = {
 	.name		= DEVLINK_GENL_NAME,
 	.version	= DEVLINK_GENL_VERSION,
 	.maxattr	= DEVLINK_ATTR_MAX,
@@ -9891,7 +9680,7 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
 };
 
-static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
+bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 {
 	const struct devlink_reload_combination *comb;
 	int i;
@@ -9920,100 +9709,6 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 	return true;
 }
 
-/**
- *	devlink_set_features - Set devlink supported features
- *
- *	@devlink: devlink
- *	@features: devlink support features
- *
- *	This interface allows us to set reload ops separatelly from
- *	the devlink_alloc.
- */
-void devlink_set_features(struct devlink *devlink, u64 features)
-{
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
-	WARN_ON(features & DEVLINK_F_RELOAD &&
-		!devlink_reload_supported(devlink->ops));
-	devlink->features = features;
-}
-EXPORT_SYMBOL_GPL(devlink_set_features);
-
-static int devlink_netdevice_event(struct notifier_block *nb,
-				   unsigned long event, void *ptr);
-
-/**
- *	devlink_alloc_ns - Allocate new devlink instance resources
- *	in specific namespace
- *
- *	@ops: ops
- *	@priv_size: size of user private data
- *	@net: net namespace
- *	@dev: parent device
- *
- *	Allocate new devlink instance resources, including devlink index
- *	and name.
- */
-struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
-				 size_t priv_size, struct net *net,
-				 struct device *dev)
-{
-	struct devlink *devlink;
-	static u32 last_id;
-	int ret;
-
-	WARN_ON(!ops || !dev);
-	if (!devlink_reload_actions_valid(ops))
-		return NULL;
-
-	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
-	if (!devlink)
-		return NULL;
-
-	ret = xa_alloc_cyclic(&devlinks, &devlink->index, devlink, xa_limit_31b,
-			      &last_id, GFP_KERNEL);
-	if (ret < 0)
-		goto err_xa_alloc;
-
-	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
-	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
-	if (ret)
-		goto err_register_netdevice_notifier;
-
-	devlink->dev = dev;
-	devlink->ops = ops;
-	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
-	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
-	write_pnet(&devlink->_net, net);
-	INIT_LIST_HEAD(&devlink->rate_list);
-	INIT_LIST_HEAD(&devlink->linecard_list);
-	INIT_LIST_HEAD(&devlink->sb_list);
-	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
-	INIT_LIST_HEAD(&devlink->resource_list);
-	INIT_LIST_HEAD(&devlink->param_list);
-	INIT_LIST_HEAD(&devlink->region_list);
-	INIT_LIST_HEAD(&devlink->reporter_list);
-	INIT_LIST_HEAD(&devlink->trap_list);
-	INIT_LIST_HEAD(&devlink->trap_group_list);
-	INIT_LIST_HEAD(&devlink->trap_policer_list);
-	lockdep_register_key(&devlink->lock_key);
-	mutex_init(&devlink->lock);
-	lockdep_set_class(&devlink->lock, &devlink->lock_key);
-	mutex_init(&devlink->reporters_lock);
-	mutex_init(&devlink->linecards_lock);
-	refcount_set(&devlink->refcount, 1);
-	init_completion(&devlink->comp);
-
-	return devlink;
-
-err_register_netdevice_notifier:
-	xa_erase(&devlinks, devlink->index);
-err_xa_alloc:
-	kfree(devlink);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(devlink_alloc_ns);
-
 static void
 devlink_trap_policer_notify(struct devlink *devlink,
 			    const struct devlink_trap_policer_item *policer_item,
@@ -10026,7 +9721,7 @@ static void devlink_trap_notify(struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd);
 
-static void devlink_notify_register(struct devlink *devlink)
+void devlink_notify_register(struct devlink *devlink)
 {
 	struct devlink_trap_policer_item *policer_item;
 	struct devlink_trap_group_item *group_item;
@@ -10067,7 +9762,7 @@ static void devlink_notify_register(struct devlink *devlink)
 				     DEVLINK_CMD_PARAM_NEW);
 }
 
-static void devlink_notify_unregister(struct devlink *devlink)
+void devlink_notify_unregister(struct devlink *devlink)
 {
 	struct devlink_trap_policer_item *policer_item;
 	struct devlink_trap_group_item *group_item;
@@ -10104,79 +9799,6 @@ static void devlink_notify_unregister(struct devlink *devlink)
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 }
 
-/**
- *	devlink_register - Register devlink instance
- *
- *	@devlink: devlink
- */
-void devlink_register(struct devlink *devlink)
-{
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-	/* Make sure that we are in .probe() routine */
-
-	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	devlink_notify_register(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_register);
-
-/**
- *	devlink_unregister - Unregister devlink instance
- *
- *	@devlink: devlink
- */
-void devlink_unregister(struct devlink *devlink)
-{
-	ASSERT_DEVLINK_REGISTERED(devlink);
-	/* Make sure that we are in .remove() routine */
-
-	xa_set_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
-	devlink_put(devlink);
-	wait_for_completion(&devlink->comp);
-
-	devlink_notify_unregister(devlink);
-	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	xa_clear_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
-}
-EXPORT_SYMBOL_GPL(devlink_unregister);
-
-/**
- *	devlink_free - Free devlink instance resources
- *
- *	@devlink: devlink
- */
-void devlink_free(struct devlink *devlink)
-{
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
-	mutex_destroy(&devlink->linecards_lock);
-	mutex_destroy(&devlink->reporters_lock);
-	mutex_destroy(&devlink->lock);
-	lockdep_unregister_key(&devlink->lock_key);
-	WARN_ON(!list_empty(&devlink->trap_policer_list));
-	WARN_ON(!list_empty(&devlink->trap_group_list));
-	WARN_ON(!list_empty(&devlink->trap_list));
-	WARN_ON(!list_empty(&devlink->reporter_list));
-	WARN_ON(!list_empty(&devlink->region_list));
-	WARN_ON(!list_empty(&devlink->param_list));
-	WARN_ON(!list_empty(&devlink->resource_list));
-	WARN_ON(!list_empty(&devlink->dpipe_table_list));
-	WARN_ON(!list_empty(&devlink->sb_list));
-	WARN_ON(!list_empty(&devlink->rate_list));
-	WARN_ON(!list_empty(&devlink->linecard_list));
-	WARN_ON(!xa_empty(&devlink->ports));
-
-	xa_destroy(&devlink->snapshot_ids);
-	xa_destroy(&devlink->ports);
-
-	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
-						       &devlink->netdevice_nb));
-
-	xa_erase(&devlinks, devlink->index);
-
-	kfree(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_free);
-
 static void devlink_port_type_warn(struct work_struct *work)
 {
 	WARN(true, "Type was not set for devlink port.");
@@ -10477,8 +10099,8 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-static int devlink_netdevice_event(struct notifier_block *nb,
-				   unsigned long event, void *ptr)
+int devlink_port_netdevice_event(struct notifier_block *nb,
+				 unsigned long event, void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 	struct devlink_port *devlink_port = netdev->devlink_port;
@@ -12980,47 +12602,3 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 
 	return 0;
 }
-
-static void __net_exit devlink_pernet_pre_exit(struct net *net)
-{
-	struct devlink *devlink;
-	u32 actions_performed;
-	unsigned long index;
-	int err;
-
-	/* In case network namespace is getting destroyed, reload
-	 * all devlink instances from this namespace into init_net.
-	 */
-	devlinks_xa_for_each_registered_get(net, index, devlink) {
-		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
-		mutex_lock(&devlink->lock);
-		err = devlink_reload(devlink, &init_net,
-				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
-				     DEVLINK_RELOAD_LIMIT_UNSPEC,
-				     &actions_performed, NULL);
-		mutex_unlock(&devlink->lock);
-		if (err && err != -EOPNOTSUPP)
-			pr_warn("Failed to reload devlink instance into init_net\n");
-		devlink_put(devlink);
-	}
-}
-
-static struct pernet_operations devlink_pernet_ops __net_initdata = {
-	.pre_exit = devlink_pernet_pre_exit,
-};
-
-static int __init devlink_init(void)
-{
-	int err;
-
-	err = genl_register_family(&devlink_nl_family);
-	if (err)
-		goto out;
-	err = register_pernet_subsys(&devlink_pernet_ops);
-
-out:
-	WARN_ON(err);
-	return err;
-}
-
-subsys_initcall(devlink_init);
diff --git a/net/devlink/core.c b/net/devlink/core.c
new file mode 100644
index 000000000000..c084eafa17fb
--- /dev/null
+++ b/net/devlink/core.c
@@ -0,0 +1,347 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2016 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
+ */
+
+#include <net/genetlink.h>
+
+#include "devl_internal.h"
+
+DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
+
+void *devlink_priv(struct devlink *devlink)
+{
+	return &devlink->priv;
+}
+EXPORT_SYMBOL_GPL(devlink_priv);
+
+struct devlink *priv_to_devlink(void *priv)
+{
+	return container_of(priv, struct devlink, priv);
+}
+EXPORT_SYMBOL_GPL(priv_to_devlink);
+
+struct device *devlink_to_dev(const struct devlink *devlink)
+{
+	return devlink->dev;
+}
+EXPORT_SYMBOL_GPL(devlink_to_dev);
+
+struct net *devlink_net(const struct devlink *devlink)
+{
+	return read_pnet(&devlink->_net);
+}
+EXPORT_SYMBOL_GPL(devlink_net);
+
+void devl_assert_locked(struct devlink *devlink)
+{
+	lockdep_assert_held(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_assert_locked);
+
+#ifdef CONFIG_LOCKDEP
+/* For use in conjunction with LOCKDEP only e.g. rcu_dereference_protected() */
+bool devl_lock_is_held(struct devlink *devlink)
+{
+	return lockdep_is_held(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_lock_is_held);
+#endif
+
+void devl_lock(struct devlink *devlink)
+{
+	mutex_lock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_lock);
+
+int devl_trylock(struct devlink *devlink)
+{
+	return mutex_trylock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_trylock);
+
+void devl_unlock(struct devlink *devlink)
+{
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devl_unlock);
+
+struct devlink *__must_check devlink_try_get(struct devlink *devlink)
+{
+	if (refcount_inc_not_zero(&devlink->refcount))
+		return devlink;
+	return NULL;
+}
+
+static void __devlink_put_rcu(struct rcu_head *head)
+{
+	struct devlink *devlink = container_of(head, struct devlink, rcu);
+
+	complete(&devlink->comp);
+}
+
+void devlink_put(struct devlink *devlink)
+{
+	if (refcount_dec_and_test(&devlink->refcount))
+		/* Make sure unregister operation that may await the completion
+		 * is unblocked only after all users are after the end of
+		 * RCU grace period.
+		 */
+		call_rcu(&devlink->rcu, __devlink_put_rcu);
+}
+
+static struct devlink *
+devlinks_xa_find_get(struct net *net, unsigned long *indexp, xa_mark_t filter,
+		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
+					  unsigned long, xa_mark_t))
+{
+	struct devlink *devlink;
+
+	rcu_read_lock();
+retry:
+	devlink = xa_find_fn(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
+	if (!devlink)
+		goto unlock;
+
+	/* In case devlink_unregister() was already called and "unregistering"
+	 * mark was set, do not allow to get a devlink reference here.
+	 * This prevents live-lock of devlink_unregister() wait for completion.
+	 */
+	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
+		goto retry;
+
+	/* For a possible retry, the xa_find_after() should be always used */
+	xa_find_fn = xa_find_after;
+	if (!devlink_try_get(devlink))
+		goto retry;
+	if (!net_eq(devlink_net(devlink), net)) {
+		devlink_put(devlink);
+		goto retry;
+	}
+unlock:
+	rcu_read_unlock();
+	return devlink;
+}
+
+struct devlink *
+devlinks_xa_find_get_first(struct net *net, unsigned long *indexp,
+			   xa_mark_t filter)
+{
+	return devlinks_xa_find_get(net, indexp, filter, xa_find);
+}
+
+struct devlink *
+devlinks_xa_find_get_next(struct net *net, unsigned long *indexp,
+			  xa_mark_t filter)
+{
+	return devlinks_xa_find_get(net, indexp, filter, xa_find_after);
+}
+
+/**
+ *	devlink_set_features - Set devlink supported features
+ *
+ *	@devlink: devlink
+ *	@features: devlink support features
+ *
+ *	This interface allows us to set reload ops separatelly from
+ *	the devlink_alloc.
+ */
+void devlink_set_features(struct devlink *devlink, u64 features)
+{
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
+	WARN_ON(features & DEVLINK_F_RELOAD &&
+		!devlink_reload_supported(devlink->ops));
+	devlink->features = features;
+}
+EXPORT_SYMBOL_GPL(devlink_set_features);
+
+/**
+ *	devlink_register - Register devlink instance
+ *
+ *	@devlink: devlink
+ */
+void devlink_register(struct devlink *devlink)
+{
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+	/* Make sure that we are in .probe() routine */
+
+	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+	devlink_notify_register(devlink);
+}
+EXPORT_SYMBOL_GPL(devlink_register);
+
+/**
+ *	devlink_unregister - Unregister devlink instance
+ *
+ *	@devlink: devlink
+ */
+void devlink_unregister(struct devlink *devlink)
+{
+	ASSERT_DEVLINK_REGISTERED(devlink);
+	/* Make sure that we are in .remove() routine */
+
+	xa_set_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
+	devlink_put(devlink);
+	wait_for_completion(&devlink->comp);
+
+	devlink_notify_unregister(devlink);
+	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
+	xa_clear_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
+}
+EXPORT_SYMBOL_GPL(devlink_unregister);
+
+/**
+ *	devlink_alloc_ns - Allocate new devlink instance resources
+ *	in specific namespace
+ *
+ *	@ops: ops
+ *	@priv_size: size of user private data
+ *	@net: net namespace
+ *	@dev: parent device
+ *
+ *	Allocate new devlink instance resources, including devlink index
+ *	and name.
+ */
+struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
+				 size_t priv_size, struct net *net,
+				 struct device *dev)
+{
+	struct devlink *devlink;
+	static u32 last_id;
+	int ret;
+
+	WARN_ON(!ops || !dev);
+	if (!devlink_reload_actions_valid(ops))
+		return NULL;
+
+	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
+	if (!devlink)
+		return NULL;
+
+	ret = xa_alloc_cyclic(&devlinks, &devlink->index, devlink, xa_limit_31b,
+			      &last_id, GFP_KERNEL);
+	if (ret < 0)
+		goto err_xa_alloc;
+
+	devlink->netdevice_nb.notifier_call = devlink_port_netdevice_event;
+	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
+	if (ret)
+		goto err_register_netdevice_notifier;
+
+	devlink->dev = dev;
+	devlink->ops = ops;
+	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
+	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
+	write_pnet(&devlink->_net, net);
+	INIT_LIST_HEAD(&devlink->rate_list);
+	INIT_LIST_HEAD(&devlink->linecard_list);
+	INIT_LIST_HEAD(&devlink->sb_list);
+	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
+	INIT_LIST_HEAD(&devlink->resource_list);
+	INIT_LIST_HEAD(&devlink->param_list);
+	INIT_LIST_HEAD(&devlink->region_list);
+	INIT_LIST_HEAD(&devlink->reporter_list);
+	INIT_LIST_HEAD(&devlink->trap_list);
+	INIT_LIST_HEAD(&devlink->trap_group_list);
+	INIT_LIST_HEAD(&devlink->trap_policer_list);
+	lockdep_register_key(&devlink->lock_key);
+	mutex_init(&devlink->lock);
+	lockdep_set_class(&devlink->lock, &devlink->lock_key);
+	mutex_init(&devlink->reporters_lock);
+	mutex_init(&devlink->linecards_lock);
+	refcount_set(&devlink->refcount, 1);
+	init_completion(&devlink->comp);
+
+	return devlink;
+
+err_register_netdevice_notifier:
+	xa_erase(&devlinks, devlink->index);
+err_xa_alloc:
+	kfree(devlink);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(devlink_alloc_ns);
+
+/**
+ *	devlink_free - Free devlink instance resources
+ *
+ *	@devlink: devlink
+ */
+void devlink_free(struct devlink *devlink)
+{
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
+	mutex_destroy(&devlink->linecards_lock);
+	mutex_destroy(&devlink->reporters_lock);
+	mutex_destroy(&devlink->lock);
+	lockdep_unregister_key(&devlink->lock_key);
+	WARN_ON(!list_empty(&devlink->trap_policer_list));
+	WARN_ON(!list_empty(&devlink->trap_group_list));
+	WARN_ON(!list_empty(&devlink->trap_list));
+	WARN_ON(!list_empty(&devlink->reporter_list));
+	WARN_ON(!list_empty(&devlink->region_list));
+	WARN_ON(!list_empty(&devlink->param_list));
+	WARN_ON(!list_empty(&devlink->resource_list));
+	WARN_ON(!list_empty(&devlink->dpipe_table_list));
+	WARN_ON(!list_empty(&devlink->sb_list));
+	WARN_ON(!list_empty(&devlink->rate_list));
+	WARN_ON(!list_empty(&devlink->linecard_list));
+	WARN_ON(!xa_empty(&devlink->ports));
+
+	xa_destroy(&devlink->snapshot_ids);
+	xa_destroy(&devlink->ports);
+
+	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
+						       &devlink->netdevice_nb));
+
+	xa_erase(&devlinks, devlink->index);
+
+	kfree(devlink);
+}
+EXPORT_SYMBOL_GPL(devlink_free);
+
+static void __net_exit devlink_pernet_pre_exit(struct net *net)
+{
+	struct devlink *devlink;
+	u32 actions_performed;
+	unsigned long index;
+	int err;
+
+	/* In case network namespace is getting destroyed, reload
+	 * all devlink instances from this namespace into init_net.
+	 */
+	devlinks_xa_for_each_registered_get(net, index, devlink) {
+		WARN_ON(!(devlink->features & DEVLINK_F_RELOAD));
+		mutex_lock(&devlink->lock);
+		err = devlink_reload(devlink, &init_net,
+				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+				     DEVLINK_RELOAD_LIMIT_UNSPEC,
+				     &actions_performed, NULL);
+		mutex_unlock(&devlink->lock);
+		if (err && err != -EOPNOTSUPP)
+			pr_warn("Failed to reload devlink instance into init_net\n");
+		devlink_put(devlink);
+	}
+}
+
+static struct pernet_operations devlink_pernet_ops __net_initdata = {
+	.pre_exit = devlink_pernet_pre_exit,
+};
+
+static int __init devlink_init(void)
+{
+	int err;
+
+	err = genl_register_family(&devlink_nl_family);
+	if (err)
+		goto out;
+	err = register_pernet_subsys(&devlink_pernet_ops);
+
+out:
+	WARN_ON(err);
+	return err;
+}
+
+subsys_initcall(devlink_init);
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
new file mode 100644
index 000000000000..0cca1f92d733
--- /dev/null
+++ b/net/devlink/devl_internal.h
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (c) 2016 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
+ */
+
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/notifier.h>
+#include <linux/types.h>
+#include <linux/xarray.h>
+#include <net/devlink.h>
+#include <net/net_namespace.h>
+
+#define DEVLINK_REGISTERED XA_MARK_1
+#define DEVLINK_UNREGISTERING XA_MARK_2
+
+#define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
+	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
+
+struct devlink_dev_stats {
+	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
+	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
+};
+
+struct devlink {
+	u32 index;
+	struct xarray ports;
+	struct list_head rate_list;
+	struct list_head sb_list;
+	struct list_head dpipe_table_list;
+	struct list_head resource_list;
+	struct list_head param_list;
+	struct list_head region_list;
+	struct list_head reporter_list;
+	struct mutex reporters_lock; /* protects reporter_list */
+	struct devlink_dpipe_headers *dpipe_headers;
+	struct list_head trap_list;
+	struct list_head trap_group_list;
+	struct list_head trap_policer_list;
+	struct list_head linecard_list;
+	struct mutex linecards_lock; /* protects linecard_list */
+	const struct devlink_ops *ops;
+	u64 features;
+	struct xarray snapshot_ids;
+	struct devlink_dev_stats stats;
+	struct device *dev;
+	possible_net_t _net;
+	/* Serializes access to devlink instance specific objects such as
+	 * port, sb, dpipe, resource, params, region, traps and more.
+	 */
+	struct mutex lock;
+	struct lock_class_key lock_key;
+	u8 reload_failed:1;
+	refcount_t refcount;
+	struct completion comp;
+	struct rcu_head rcu;
+	struct notifier_block netdevice_nb;
+	char priv[] __aligned(NETDEV_ALIGN);
+};
+
+extern struct xarray devlinks;
+extern struct genl_family devlink_nl_family;
+
+/* devlink instances are open to the access from the user space after
+ * devlink_register() call. Such logical barrier allows us to have certain
+ * expectations related to locking.
+ *
+ * Before *_register() - we are in initialization stage and no parallel
+ * access possible to the devlink instance. All drivers perform that phase
+ * by implicitly holding device_lock.
+ *
+ * After *_register() - users and driver can access devlink instance at
+ * the same time.
+ */
+#define ASSERT_DEVLINK_REGISTERED(d)                                           \
+	WARN_ON_ONCE(!xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
+#define ASSERT_DEVLINK_NOT_REGISTERED(d)                                       \
+	WARN_ON_ONCE(xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
+
+/* Iterate over devlink pointers which were possible to get reference to.
+ * devlink_put() needs to be called for each iterated devlink pointer
+ * in loop body in order to release the reference.
+ */
+#define devlinks_xa_for_each_get(net, index, devlink, filter)		\
+	for (index = 0,							\
+	     devlink = devlinks_xa_find_get_first(net, &index, filter);	\
+	     devlink; devlink = devlinks_xa_find_get_next(net, &index, filter))
+
+#define devlinks_xa_for_each_registered_get(net, index, devlink)	\
+	devlinks_xa_for_each_get(net, index, devlink, DEVLINK_REGISTERED)
+
+struct devlink *
+devlinks_xa_find_get_first(struct net *net, unsigned long *indexp,
+			   xa_mark_t filter);
+struct devlink *
+devlinks_xa_find_get_next(struct net *net, unsigned long *indexp,
+			  xa_mark_t filter);
+
+/* Netlink */
+void devlink_notify_unregister(struct devlink *devlink);
+void devlink_notify_register(struct devlink *devlink);
+
+/* Ports */
+int devlink_port_netdevice_event(struct notifier_block *nb,
+				 unsigned long event, void *ptr);
+
+/* Reload */
+bool devlink_reload_actions_valid(const struct devlink_ops *ops);
+int devlink_reload(struct devlink *devlink, struct net *dest_net,
+		   enum devlink_reload_action action,
+		   enum devlink_reload_limit limit,
+		   u32 *actions_performed, struct netlink_ext_ack *extack);
+
+static inline bool devlink_reload_supported(const struct devlink_ops *ops)
+{
+	return ops->reload_down && ops->reload_up;
+}
-- 
2.38.1

