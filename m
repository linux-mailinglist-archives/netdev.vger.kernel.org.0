Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA26E6652D9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 05:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjAKEa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 23:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjAKE3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 23:29:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D65364D9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:29:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C946195C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1725C433EF;
        Wed, 11 Jan 2023 04:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673411352;
        bh=basDxyzRuA4GteGLHasDDjMRYpPkd1j2GYrw44AvxUg=;
        h=From:To:Cc:Subject:Date:From;
        b=C5qIIUBKdKtK2/Vj8bF5ZdW/i/GpAv24amDiAZOGfkZ92XGVKDTMKzBnRYp8mSyW7
         TvjUEA/mwYjhAAbk9v5Q7VxJ9n70/NB2K1E8z32Dq/ewSBIUmpt3WXwhuiOmkPG+aT
         H7euEcvggQSpAeCMiPsI7HNfm8kgLZ454Ot9cFwHBikk4PFPj9UsTu+Ba8EEXcenK6
         nKugqR2dN5PUgmJmzQ07dIcfQisYOp+kZwtnQe9w/m7vWcN55BIbGph4Fr6Mm6894d
         sF2g0xq2apn1XNAFSRcvltBeDZ719MqedgJxzrr8GWjYkFpXYW9M9UZG2hH6ZbjxNx
         nZY8xY5zjiJNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
Subject: [PATCH net-next] devlink: keep the instance mutex alive until references are gone
Date:   Tue, 10 Jan 2023 20:29:08 -0800
Message-Id: <20230111042908.988199-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
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

The reference needs to keep the instance memory around, but also
the instance lock must remain valid. Users will take the lock,
check registration status and release the lock. mutex_destroy()
etc. belong in the same place as the freeing of the memory.

Unfortunately lockdep_unregister_key() sleeps so we need
to switch the an rcu_work.

Note that the problem is a bit hard to repro, because
devlink_pernet_pre_exit() iterates over registered instances.
AFAIU the instances must get devlink_free()d concurrently with
the namespace getting deleted for the problem to occur.

Reported-by: syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
Fixes: 9053637e0da7 ("devlink: remove the registration guarantee of references")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Jiri, this will likely conflict with your series, sorry :(
---
 net/devlink/core.c          | 16 +++++++++++++---
 net/devlink/devl_internal.h |  3 ++-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index a31a317626d7..60beca2df7cc 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -83,10 +83,21 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
 	return NULL;
 }
 
+static void devlink_release(struct work_struct *work)
+{
+	struct devlink *devlink;
+
+	devlink = container_of(to_rcu_work(work), struct devlink, rwork);
+
+	mutex_destroy(&devlink->lock);
+	lockdep_unregister_key(&devlink->lock_key);
+	kfree(devlink);
+}
+
 void devlink_put(struct devlink *devlink)
 {
 	if (refcount_dec_and_test(&devlink->refcount))
-		kfree_rcu(devlink, rcu);
+		queue_rcu_work(system_wq, &devlink->rwork);
 }
 
 struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
@@ -231,6 +242,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	INIT_LIST_HEAD(&devlink->trap_list);
 	INIT_LIST_HEAD(&devlink->trap_group_list);
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
+	INIT_RCU_WORK(&devlink->rwork, devlink_release);
 	lockdep_register_key(&devlink->lock_key);
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
@@ -259,8 +271,6 @@ void devlink_free(struct devlink *devlink)
 
 	mutex_destroy(&devlink->linecards_lock);
 	mutex_destroy(&devlink->reporters_lock);
-	mutex_destroy(&devlink->lock);
-	lockdep_unregister_key(&devlink->lock_key);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 5d2bbe295659..e724e4c2a4ff 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -7,6 +7,7 @@
 #include <linux/netdevice.h>
 #include <linux/notifier.h>
 #include <linux/types.h>
+#include <linux/workqueue.h>
 #include <linux/xarray.h>
 #include <net/devlink.h>
 #include <net/net_namespace.h>
@@ -51,7 +52,7 @@ struct devlink {
 	struct lock_class_key lock_key;
 	u8 reload_failed:1;
 	refcount_t refcount;
-	struct rcu_head rcu;
+	struct rcu_work rwork;
 	struct notifier_block netdevice_nb;
 	char priv[] __aligned(NETDEV_ALIGN);
 };
-- 
2.38.1

