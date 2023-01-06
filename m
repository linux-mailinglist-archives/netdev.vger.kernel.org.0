Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE6065FB78
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjAFGeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjAFGeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE6B6CFFA
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A355261CE7
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB83C433D2;
        Fri,  6 Jan 2023 06:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986849;
        bh=KAeWUpM+NncsGxCiuCzHbBmWvKtjhOsByJizCeAaeAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyvySPCJ0UI880nAWP5loPdu/vTuW6d37mYf62d3AQqrrVsetJ4hzWIKE8tEPTZDG
         mAUAVZzxfC4Cbf80DsMDJdWUUoWrMLx/qWfHtVWCPLZv5tpHG3ynRr8xEJ02eGHKje
         AQJLTjYtpH/R8j8lTyrbS2guMvlbMoPXWfzY+j3ohsn4rK+yYlIH8FCmhVsZQyJr/t
         j0ZpHJbSCnqdRJpBBMWJOSn/IbqWnH/XnCp4HXBT1vttE4KQvXrLG7NSj9VtBs6WDX
         h8mShVYuseTEG+HiqLmGiJQ69cwHXJ/Hl+6XGsY40IBeVlxQA3Wq+PYM2xDl9eBFmL
         1EDxXaYrZaZUA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/9] devlink: remove the registration guarantee of references
Date:   Thu,  5 Jan 2023 22:33:58 -0800
Message-Id: <20230106063402.485336-6-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
References: <20230106063402.485336-1-kuba@kernel.org>
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

The objective of exposing the devlink instance locks to
drivers was to let them use these locks to prevent user space
from accessing the device before it's fully initialized.
This is difficult because devlink_unregister() waits for all
references to be released, meaning that devlink_unregister()
can't itself be called under the instance lock.

To avoid this issue devlink_register() was moved after subobject
registration a while ago. Unfortunately the netdev paths get
a hold of the devlink instances _before_ they are registered.
Ideally netdev should wait for devlink init to finish (synchronizing
on the instance lock). This can't work because we don't know if the
instance will _ever_ be registered (in case of failures it may not).
The other option of returning an error until devlink_register()
is called is unappealing (user space would get a notification
netdev exist but would have to wait arbitrary amount of time
before accessing some of its attributes).

Weaken the guarantees of the devlink references.

Holding a reference will now only guarantee that the memory
of the object is around. Another way of looking at it is that
the reference now protects the object not its "registered" status.
Use devlink instance lock to synchronize unregistration.

This implies that releasing of the "main" reference of the devlink
instance moves from devlink_unregister() to devlink_free().

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h       |  2 ++
 net/devlink/core.c          | 64 ++++++++++++++++---------------------
 net/devlink/devl_internal.h |  2 --
 3 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6a2e4f21779f..425ecef431b7 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1647,6 +1647,8 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
 void devlink_set_features(struct devlink *devlink, u64 features);
+int devl_register(struct devlink *devlink);
+void devl_unregister(struct devlink *devlink);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
diff --git a/net/devlink/core.c b/net/devlink/core.c
index c53c996edf1d..7cf0b3efbb2f 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -83,21 +83,10 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 	return NULL;
 }
 
-static void __devlink_put_rcu(struct rcu_head *head)
-{
-	struct devlink *devlink = container_of(head, struct devlink, rcu);
-
-	complete(&devlink->comp);
-}
-
 void devlink_put(struct devlink *devlink)
 {
 	if (refcount_dec_and_test(&devlink->refcount))
-		/* Make sure unregister operation that may await the completion
-		 * is unblocked only after all users are after the end of
-		 * RCU grace period.
-		 */
-		call_rcu(&devlink->rcu, __devlink_put_rcu);
+		kfree_rcu(devlink, rcu);
 }
 
 struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
@@ -110,13 +99,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
 	if (!devlink)
 		goto unlock;
 
-	/* In case devlink_unregister() was already called and "unregistering"
-	 * mark was set, do not allow to get a devlink reference here.
-	 * This prevents live-lock of devlink_unregister() wait for completion.
-	 */
-	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
-		goto next;
-
 	if (!devlink_try_get(devlink))
 		goto next;
 	if (!net_eq(devlink_net(devlink), net)) {
@@ -152,37 +134,48 @@ void devlink_set_features(struct devlink *devlink, u64 features)
 EXPORT_SYMBOL_GPL(devlink_set_features);
 
 /**
- *	devlink_register - Register devlink instance
- *
- *	@devlink: devlink
+ * devl_register - Register devlink instance
+ * @devlink: devlink
  */
-void devlink_register(struct devlink *devlink)
+int devl_register(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-	/* Make sure that we are in .probe() routine */
+	devl_assert_locked(devlink);
 
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_register);
+
+void devlink_register(struct devlink *devlink)
+{
+	devl_lock(devlink);
+	devl_register(devlink);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
 /**
- *	devlink_unregister - Unregister devlink instance
- *
- *	@devlink: devlink
+ * devl_unregister - Unregister devlink instance
+ * @devlink: devlink
  */
-void devlink_unregister(struct devlink *devlink)
+void devl_unregister(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_REGISTERED(devlink);
-	/* Make sure that we are in .remove() routine */
-
-	xa_set_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
-	devlink_put(devlink);
-	wait_for_completion(&devlink->comp);
+	devl_assert_locked(devlink);
 
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	xa_clear_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
+}
+EXPORT_SYMBOL_GPL(devl_unregister);
+
+void devlink_unregister(struct devlink *devlink)
+{
+	devl_lock(devlink);
+	devl_unregister(devlink);
+	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -246,7 +239,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->reporters_lock);
 	mutex_init(&devlink->linecards_lock);
 	refcount_set(&devlink->refcount, 1);
-	init_completion(&devlink->comp);
 
 	return devlink;
 
@@ -292,7 +284,7 @@ void devlink_free(struct devlink *devlink)
 
 	xa_erase(&devlinks, devlink->index);
 
-	kfree(devlink);
+	devlink_put(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_free);
 
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 01a00df81d0e..5d2bbe295659 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -12,7 +12,6 @@
 #include <net/net_namespace.h>
 
 #define DEVLINK_REGISTERED XA_MARK_1
-#define DEVLINK_UNREGISTERING XA_MARK_2
 
 #define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
 	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
@@ -52,7 +51,6 @@ struct devlink {
 	struct lock_class_key lock_key;
 	u8 reload_failed:1;
 	refcount_t refcount;
-	struct completion comp;
 	struct rcu_head rcu;
 	struct notifier_block netdevice_nb;
 	char priv[] __aligned(NETDEV_ALIGN);
-- 
2.38.1

