Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD72064F6C0
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiLQBUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQBUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D37680A4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EECE7B81E54
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740E9C433F2;
        Sat, 17 Dec 2022 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240009;
        bh=6GZ0C+l6nzfCmVCiNxVn0QVLZTsSpvtmVC5AK7hqFkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jk35EKfx5psUBs7vW9fAzEYxOjB2n+3YjuVb25p/fN5FKbjeSVqfYmOXnOx8JeXvT
         CCKSuHjCBNL3P2qHLyIuR1DQTBlgf7cbqxBF9cn/REwwbEqH6VY2CxoKOV2b8dTUl2
         ozsNqcM8XoV7niQZGM1uOg43ZJkU5z7L9VZmbLU1FhexCdDDMcjSk+WG1YXm+M5x4I
         BrkQDNlIQUZAEsGd5qXYgSC1x8eh8Ymh0IEJ2FNY/xuFpMAUMs66qYd5/0+Mo8MjCI
         tnk/yecvp2PT3ks3ckBLiBfV4YLw/41XwXmQNRxE1arjEdp4l5Y5JLlG+K5JBfEyZD
         uw0ko1dtCrbWA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 01/10] devlink: bump the instance index directly when iterating
Date:   Fri, 16 Dec 2022 17:19:44 -0800
Message-Id: <20221217011953.152487-2-kuba@kernel.org>
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

We use a clever find_first() / find_after() scheme currently,
which works nicely as xarray will write the "current" index
into the variable we pass.

We can't do the same thing during the "dump walk" because
there we must not increment the index until we're sure
that the instance has been fully dumped.

Since we have a precedent and a requirement for manually futzing
with the increment of the index, let's switch
devlinks_xa_for_each_registered_get() to do the same thing.
It removes some indirections.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/core.c          | 31 +++++++++----------------------
 net/devlink/devl_internal.h | 17 ++++-------------
 2 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 371d6821315d..88c88b8053e2 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -91,16 +91,13 @@ void devlink_put(struct devlink *devlink)
 		call_rcu(&devlink->rcu, __devlink_put_rcu);
 }
 
-struct devlink *
-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
-					  unsigned long, xa_mark_t))
+struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
 {
-	struct devlink *devlink;
+	struct devlink *devlink = NULL;
 
 	rcu_read_lock();
 retry:
-	devlink = xa_find_fn(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
+	devlink = xa_find(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
 	if (!devlink)
 		goto unlock;
 
@@ -109,31 +106,21 @@ devlinks_xa_find_get(struct net *net, unsigned long *indexp,
 	 * This prevents live-lock of devlink_unregister() wait for completion.
 	 */
 	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
-		goto retry;
+		goto next;
 
-	/* For a possible retry, the xa_find_after() should be always used */
-	xa_find_fn = xa_find_after;
 	if (!devlink_try_get(devlink))
-		goto retry;
+		goto next;
 	if (!net_eq(devlink_net(devlink), net)) {
 		devlink_put(devlink);
-		goto retry;
+		goto next;
 	}
 unlock:
 	rcu_read_unlock();
 	return devlink;
-}
-
-struct devlink *
-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp)
-{
-	return devlinks_xa_find_get(net, indexp, xa_find);
-}
 
-struct devlink *
-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp)
-{
-	return devlinks_xa_find_get(net, indexp, xa_find_after);
+next:
+	(*indexp)++;
+	goto retry;
 }
 
 /**
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 1d7ab11f2f7e..ef0369449592 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -82,18 +82,9 @@ extern struct genl_family devlink_nl_family;
  * in loop body in order to release the reference.
  */
 #define devlinks_xa_for_each_registered_get(net, index, devlink)	\
-	for (index = 0,							\
-	     devlink = devlinks_xa_find_get_first(net, &index);	\
-	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
-
-struct devlink *
-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
-					  unsigned long, xa_mark_t));
-struct devlink *
-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp);
-struct devlink *
-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp);
+	for (index = 0; (devlink = devlinks_xa_find_get(net, &index)); index++)
+
+struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
 
 /* Netlink */
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
@@ -133,7 +124,7 @@ struct devlink_gen_cmd {
  */
 #define devlink_dump_for_each_instance_get(msg, dump, devlink)		\
 	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
-					       &dump->instance, xa_find)); \
+					       &dump->instance));	\
 	     dump->instance++, dump->idx = 0)
 
 extern const struct genl_small_ops devlink_nl_ops[56];
-- 
2.38.1

