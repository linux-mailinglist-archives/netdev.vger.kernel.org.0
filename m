Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2359864F6BC
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiLQBUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiLQBUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3353680A9
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90AA662318
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB25AC4339B;
        Sat, 17 Dec 2022 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240010;
        bh=DTx4pFHQYkKjiXbiAQl7jm0nZ1D+gNMlOFHb/O87+3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0nauPtpF0REjUdoiipCJUNyb+32JY4Xlg6ll3hlS9kEmlJQ8VPjVs7fW4JZ6evhm
         c4IwsL8HOoUeP2k0Ljfdl+9DnibfKCoA9a8ahHG9GswYCR8jBj4UTknUR2R5K8qBVr
         dG/CheCt1yttlLrNPLqCGr6hz3v78LqOKz84/hglmPQ6f4xjw0HZ80HH13AGI6Lhqv
         JQPj3Ykg9RnQIWZuecHmRy2ewsfYxuW9SGSJyqPqZC6e/f1L4voc+MWufRJ3umI82S
         s6uB86BcbLhQzGG967II7mKMxiu+4p1/lpPsuzoTbnlnd08br9jyUkPO9Bq3vbmXyx
         //HzRCxCyaoGA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 05/10] devlink: remove the registration guarantee of references
Date:   Fri, 16 Dec 2022 17:19:48 -0800
Message-Id: <20221217011953.152487-6-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217011953.152487-1-kuba@kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h       |  2 ++
 net/devlink/core.c          | 64 ++++++++++++++++---------------------
 net/devlink/devl_internal.h |  2 --
 3 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 36e013d3aa52..cc910612b3f4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1648,6 +1648,8 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
 void devlink_set_features(struct devlink *devlink, u64 features);
+int devl_register(struct devlink *devlink);
+void devl_unregister(struct devlink *devlink);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
diff --git a/net/devlink/core.c b/net/devlink/core.c
index 2abad8247597..413b92534ad6 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -89,21 +89,10 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
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
@@ -116,13 +105,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
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
@@ -158,37 +140,48 @@ void devlink_set_features(struct devlink *devlink, u64 features)
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
 
@@ -252,7 +245,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	mutex_init(&devlink->reporters_lock);
 	mutex_init(&devlink->linecards_lock);
 	refcount_set(&devlink->refcount, 1);
-	init_completion(&devlink->comp);
 
 	return devlink;
 
@@ -298,7 +290,7 @@ void devlink_free(struct devlink *devlink)
 
 	xa_erase(&devlinks, devlink->index);
 
-	kfree(devlink);
+	devlink_put(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_free);
 
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index c3977c69552a..7e77eebde3b9 100644
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

