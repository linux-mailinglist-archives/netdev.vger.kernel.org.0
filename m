Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67AD4E7B4B
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiCYVwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiCYVwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:52:42 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F7B3B54C
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=4x6NgibepUC0UFk60JpqHo0TJfizgSXLMHouyt4spKY=; t=1648245064; x=1649454664; 
        b=qu5o8B21vUEFvwCNm4112SIrHc85dHPyrXxSSX0lnnnsA6gfthTRE0QUDEb8HKl9z5+g/PRt84Z
        cKjeTmEhN4mv3NYv7DbFmdpbYUy6Y0LwcmPDihYnliH9m1GVRD2NRE3apbCWttmdf1wX010kdcxc1
        YnHM8kyeA2o4Cr6x/tKXLz5la/amu00LtgrKR6xGZdC3X2/X8THU9zLqoYhg63AcS/WhooegS96H1
        0f0X3ZC3LE2NEBpOL0I+2SyKPrUG4vqc0XxMUKu/t/bnJ5qPV0Q5zQisIUgM4Ec+LHx8eyKTveLMX
        JUjkUjYm5GeSS3SwbUydwSIt/+V+yBpqDJXQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXrpi-000WZV-W4;
        Fri, 25 Mar 2022 22:50:59 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] net: ensure net_todo_list is processed quickly
Date:   Fri, 25 Mar 2022 22:50:55 +0100
Message-Id: <20220325225055.37e89a72f814.Ic73d206e217db20fd22dcec14fe5442ca732804b@changeid>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In [1], Will raised a potential issue that the cfg80211 code,
which does (from a locking perspective)

  rtnl_lock()
  wiphy_lock()
  rtnl_unlock()

might be suspectible to ABBA deadlocks, because rtnl_unlock()
calls netdev_run_todo(), which might end up calling rtnl_lock()
again, which could then deadlock (see the comment in the code
added here for the scenario).

Some back and forth and thinking ensued, but clearly this can't
happen if the net_todo_list is empty at the rtnl_unlock() here.
Clearly, the code here cannot actually put an entry on it, and
all other users of rtnl_unlock() will empty it since that will
always go through netdev_run_todo(), emptying the list.

So the only other way to get there would be to add to the list
and then unlock the RTNL without going through rtnl_unlock(),
which is only possible through __rtnl_unlock(). However, this
isn't exported and not used in many places, and none of them
seem to be able to unregister before using it.

Therefore, add a WARN_ON() in the code to ensure this invariant
won't be broken, so that the cfg80211 (or any similar) code
stays safe.

[1] https://lore.kernel.org/r/Yjzpo3TfZxtKPMAG@google.com

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/netdevice.h |  3 ++-
 net/core/dev.c            |  2 +-
 net/core/rtnetlink.c      | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 59e27a2b7bf0..b6a1e7f643da 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3894,7 +3894,8 @@ void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev);
 extern int		netdev_budget;
 extern unsigned int	netdev_budget_usecs;
 
-/* Called by rtnetlink.c:rtnl_unlock() */
+/* Used by rtnetlink.c:__rtnl_unlock()/rtnl_unlock() */
+extern struct list_head net_todo_list;
 void netdev_run_todo(void);
 
 static inline void __dev_put(struct net_device *dev)
diff --git a/net/core/dev.c b/net/core/dev.c
index 8c6c08446556..2ec17358d7b4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9431,7 +9431,7 @@ static int dev_new_index(struct net *net)
 }
 
 /* Delayed registration/unregisteration */
-static LIST_HEAD(net_todo_list);
+LIST_HEAD(net_todo_list);
 DECLARE_WAIT_QUEUE_HEAD(netdev_unregistering_wq);
 
 static void net_set_todo(struct net_device *dev)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 159c9c61e6af..0e4502d641eb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -95,6 +95,39 @@ void __rtnl_unlock(void)
 
 	defer_kfree_skb_list = NULL;
 
+	/* Ensure that we didn't actually add any TODO item when __rtnl_unlock()
+	 * is used. In some places, e.g. in cfg80211, we have code that will do
+	 * something like
+	 *   rtnl_lock()
+	 *   wiphy_lock()
+	 *   ...
+	 *   rtnl_unlock()
+	 *
+	 * and because netdev_run_todo() acquires the RTNL for items on the list
+	 * we could cause a situation such as this:
+	 * Thread 1			Thread 2
+	 *				  rtnl_lock()
+	 *				  unregister_netdevice()
+	 *				  __rtnl_unlock()
+	 * rtnl_lock()
+	 * wiphy_lock()
+	 * rtnl_unlock()
+	 *   netdev_run_todo()
+	 *     __rtnl_unlock()
+	 *
+	 *     // list not empty now
+	 *     // because of thread 2
+	 *				  rtnl_lock()
+	 *     while (!list_empty(...))
+	 *       rtnl_lock()
+	 *				  wiphy_lock()
+	 * **** DEADLOCK ****
+	 *
+	 * However, usage of __rtnl_unlock() is rare, and so we can ensure that
+	 * it's not used in cases where something is added to do the list.
+	 */
+	WARN_ON(!list_empty(&net_todo_list));
+
 	mutex_unlock(&rtnl_mutex);
 
 	while (head) {
-- 
2.35.1

