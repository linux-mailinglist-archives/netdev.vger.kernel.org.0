Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8C1590135
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbiHKPtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbiHKPrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1810098A6E;
        Thu, 11 Aug 2022 08:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90AA9B82150;
        Thu, 11 Aug 2022 15:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63E0C433D6;
        Thu, 11 Aug 2022 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232487;
        bh=UPDy2wsnZunbhCqkifogzSYpO/JwhhwGsaGXXTQAaJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsAWOQrvz54W1kjstEJuGOOHc3Yv0WEwyGnmvZV5z93GhGIHCZkanrDFXpBTRxjpV
         XNqVOSyOGSDuQZYqnIGUgweFiulL7gQLWEo2xExC2jFmkh3PwiRcIhHruXa/Lrfdjr
         v+rGrkX1YvAQz7gUmc7ZDwuIW0QosBkLXrB+oTQ04gq1Ys/N+avkZSFKGYi1BOB2Uq
         MAkiiOE29+r2gpnjfBClNkLOJKgmleCnnmug6OnsxReTWYhIXaPBxyK+iBd5+6XVwE
         8aPDFsBMyug+/6bcDybFI+1H4GNyIeI34TplWUWxTCHSw7uSD40D6D914tcma1E7wR
         VaiFcYM+PK6iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 096/105] net: devlink: make sure that devlink_try_get() works with valid pointer during xarray iteration
Date:   Thu, 11 Aug 2022 11:28:20 -0400
Message-Id: <20220811152851.1520029-96-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 30bab7cdb56da4819ff081ad658646f2df16c098 ]

Remove dependency on devlink_mutex during devlinks xarray iteration.

The reason is that devlink_register/unregister() functions taking
devlink_mutex would deadlock during devlink reload operation of devlink
instance which registers/unregisters nested devlink instances.

The devlinks xarray consistency is ensured internally by xarray.
There is a reference taken when working with devlink using
devlink_try_get(). But there is no guarantee that devlink pointer
picked during xarray iteration is not freed before devlink_try_get()
is called.

Make sure that devlink_try_get() works with valid pointer.
Achieve it by:
1) Splitting devlink_put() so the completion is sent only
   after grace period. Completion unblocks the devlink_unregister()
   routine, which is followed-up by devlink_free()
2) During devlinks xa_array iteration, get devlink pointer from xa_array
   holding RCU read lock and taking reference using devlink_try_get()
   before unlock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 171 +++++++++++++++++++++------------------------
 1 file changed, 80 insertions(+), 91 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e4c19692c792..47ba3e255f14 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -70,6 +70,7 @@ struct devlink {
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct completion comp;
+	struct rcu_head rcu;
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
@@ -221,8 +222,6 @@ static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 /* devlink_mutex
  *
  * An overall lock guarding every operation coming from userspace.
- * It also guards devlink devices list and it is taken when
- * driver registers/unregisters it.
  */
 static DEFINE_MUTEX(devlink_mutex);
 
@@ -232,10 +231,21 @@ struct net *devlink_net(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_net);
 
+static void __devlink_put_rcu(struct rcu_head *head)
+{
+	struct devlink *devlink = container_of(head, struct devlink, rcu);
+
+	complete(&devlink->comp);
+}
+
 void devlink_put(struct devlink *devlink)
 {
 	if (refcount_dec_and_test(&devlink->refcount))
-		complete(&devlink->comp);
+		/* Make sure unregister operation that may await the completion
+		 * is unblocked only after all users are after the end of
+		 * RCU grace period.
+		 */
+		call_rcu(&devlink->rcu, __devlink_put_rcu);
 }
 
 struct devlink *__must_check devlink_try_get(struct devlink *devlink)
@@ -272,12 +282,55 @@ void devl_unlock(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devl_unlock);
 
+static struct devlink *
+devlinks_xa_find_get(unsigned long *indexp, xa_mark_t filter,
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
+	/* For a possible retry, the xa_find_after() should be always used */
+	xa_find_fn = xa_find_after;
+	if (!devlink_try_get(devlink))
+		goto retry;
+unlock:
+	rcu_read_unlock();
+	return devlink;
+}
+
+static struct devlink *devlinks_xa_find_get_first(unsigned long *indexp,
+						  xa_mark_t filter)
+{
+	return devlinks_xa_find_get(indexp, filter, xa_find);
+}
+
+static struct devlink *devlinks_xa_find_get_next(unsigned long *indexp,
+						 xa_mark_t filter)
+{
+	return devlinks_xa_find_get(indexp, filter, xa_find_after);
+}
+
+/* Iterate over devlink pointers which were possible to get reference to.
+ * devlink_put() needs to be called for each iterated devlink pointer
+ * in loop body in order to release the reference.
+ */
+#define devlinks_xa_for_each_get(index, devlink, filter)			\
+	for (index = 0, devlink = devlinks_xa_find_get_first(&index, filter);	\
+	     devlink; devlink = devlinks_xa_find_get_next(&index, filter))
+
+#define devlinks_xa_for_each_registered_get(index, devlink)			\
+	devlinks_xa_for_each_get(index, devlink, DEVLINK_REGISTERED)
+
 static struct devlink *devlink_get_from_attrs(struct net *net,
 					      struct nlattr **attrs)
 {
 	struct devlink *devlink;
 	unsigned long index;
-	bool found = false;
 	char *busname;
 	char *devname;
 
@@ -287,21 +340,15 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
 	busname = nla_data(attrs[DEVLINK_ATTR_BUS_NAME]);
 	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
 
-	lockdep_assert_held(&devlink_mutex);
-
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0 &&
-		    net_eq(devlink_net(devlink), net)) {
-			found = true;
-			break;
-		}
+		    net_eq(devlink_net(devlink), net))
+			return devlink;
+		devlink_put(devlink);
 	}
 
-	if (!found || !devlink_try_get(devlink))
-		devlink = ERR_PTR(-ENODEV);
-
-	return devlink;
+	return ERR_PTR(-ENODEV);
 }
 
 static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
@@ -1323,10 +1370,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -1426,10 +1470,7 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk))) {
 			devlink_put(devlink);
 			continue;
@@ -1489,10 +1530,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -2174,10 +2212,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -2446,10 +2481,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -2598,10 +2630,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_pool_get)
 			goto retry;
@@ -2819,10 +2848,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_port_pool_get)
 			goto retry;
@@ -3068,10 +3094,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)) ||
 		    !devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
@@ -5155,10 +5178,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -5390,10 +5410,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -5974,10 +5991,7 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -6508,10 +6522,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -7688,10 +7699,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_rep;
 
@@ -7718,10 +7726,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
@@ -8284,10 +8289,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -8511,10 +8513,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -8825,10 +8824,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -9584,10 +9580,8 @@ void devlink_register(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
 
-	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
@@ -9604,10 +9598,8 @@ void devlink_unregister(struct devlink *devlink)
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
-	mutex_lock(&devlink_mutex);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -12118,10 +12110,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 * all devlink instances from this namespace into init_net.
 	 */
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), net))
 			goto retry;
 
-- 
2.35.1

