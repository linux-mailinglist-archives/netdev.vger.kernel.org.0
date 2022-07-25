Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A053D57FB55
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbiGYI3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiGYI3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:32 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6049113F32
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z22so12914142edd.6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ROzDFWn2cm0CXQlzYrzGTkWeXJIvD4PH6UNmMPdTpJU=;
        b=v1+di92CGcJVTzW46LIpuys37CoQaSqoqLbIFGRJZ+FinFSIZo8TkhG+5Bsqp+lNMa
         EEmLBRlg4EOYWc0lcS4RJP+Jg03MiHBf9hHS77XIjE/thMSWYqPTYZ6LPtYy5dvylZjU
         iF+uLWJLochDvylxQ1UMTdwfJn14+5ojmcpy8f63Xi3D1Z/yn/Dw6YSpL+F3t8OhXonb
         lTvDkhpIPwmWD8snTUIUVtz743uQ7ZFOayiZbAgLyaO+6TbR+sd57eSKGdaU2qVUQfFE
         V0QL2t7JWA3/hnaJvY0yd0QSAHqPWsgOlyIITXyR8Fook90RUgCa7AR0F4PG7tldJ4c4
         f01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ROzDFWn2cm0CXQlzYrzGTkWeXJIvD4PH6UNmMPdTpJU=;
        b=p3XufIslkxa0qLOmcXAbICUhukwa7w7GlHMNH8Rljp/4g6/RzUfrmW6bup9s6/Lf8Q
         vL7yqBsq4CLUGYpJCPAVNtHLPEFQEm+HnFYKruBlE31FHhbRejoaWbYBnDDbET06xBQu
         tKM8hRNdwmUdDEoFETXraoTc/OZ+oeFrZrGZbPhpvB6mSg0gpUSP7snKB2eTP74ZEMLY
         tkwexi5V2e5XxxVwML7jDPyybISK5WcZNea8RrndROSUgOyGqmWALumK7+8wdhWE4rAQ
         ecn2/RJYUmNuIZiwIpaLR+zEmNDt4av9m/zdpoJrKlvD6o8cA1lzoDaOrxFyYINInATs
         h3JA==
X-Gm-Message-State: AJIora/iusLAkFWwiEQ6CY9g2K2bPl0Ge43zGQADaMcude65WbEL2RoD
        RN1ref7/DI/WUU03kpqeNY9Nbq6CJ61Tfz+Y2xM=
X-Google-Smtp-Source: AGRyM1v8GuVWGjRZzYVqQbGMKnn826Kl+M/Amm1eLUrOufRsgCbAqz/Jvc2FdMHe/NTAuQYka3vByQ==
X-Received: by 2002:aa7:dc17:0:b0:43b:6c14:8bf with SMTP id b23-20020aa7dc17000000b0043b6c1408bfmr12042440edu.190.1658737768753;
        Mon, 25 Jul 2022 01:29:28 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y10-20020a056402358a00b0043a8f5ad272sm6839459edc.49.2022.07.25.01.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 01/12] net: devlink: make sure that devlink_try_get() works with valid pointer during xarray iteration
Date:   Mon, 25 Jul 2022 10:29:14 +0200
Message-Id: <20220725082925.366455-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

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
---
v3->v4:
- introduced an iteration helpers and convert to use them instead of
  manually locking rcu_read_lock over xa_for_each_marked()
  and devlink_try_get() couple
- converted devlink_get_from_attrs() to take reference during iteration
  as well.
v2->v3:
- s/enf/end/ in devlink_put() comment
- added missing rcu_read_lock() call to info_get_dumpit()
- extended patch description by motivation
- removed an extra "by" from patch description
v1->v2:
- new patch (originally part of different patchset)
---
 net/core/devlink.c | 171 +++++++++++++++++++++------------------------
 1 file changed, 80 insertions(+), 91 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 98d79feeb3dc..c7abd928f389 100644
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
@@ -278,12 +288,55 @@ void devl_unlock(struct devlink *devlink)
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
 
@@ -293,21 +346,15 @@ static struct devlink *devlink_get_from_attrs(struct net *net,
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
@@ -1329,10 +1376,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -1432,10 +1476,7 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
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
@@ -1495,10 +1536,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -2177,10 +2215,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -2449,10 +2484,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -2601,10 +2633,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
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
@@ -2822,10 +2851,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
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
@@ -3071,10 +3097,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
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
@@ -5158,10 +5181,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -5393,10 +5413,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -5977,10 +5994,7 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -6511,10 +6525,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	int err = 0;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -7691,10 +7702,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_rep;
 
@@ -7721,10 +7729,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry_port;
 
@@ -8291,10 +8296,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -8518,10 +8520,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -8832,10 +8831,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	int err;
 
 	mutex_lock(&devlink_mutex);
-	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
-		if (!devlink_try_get(devlink))
-			continue;
-
+	devlinks_xa_for_each_registered_get(index, devlink) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			goto retry;
 
@@ -9589,10 +9585,8 @@ void devlink_register(struct devlink *devlink)
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
 
-	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
@@ -9609,10 +9603,8 @@ void devlink_unregister(struct devlink *devlink)
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
-	mutex_lock(&devlink_mutex);
 	devlink_notify_unregister(devlink);
 	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
-	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
@@ -12281,10 +12273,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
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
2.35.3

