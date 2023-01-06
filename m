Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3DC65FB7B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjAFGeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjAFGeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6F96E0DB
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D89AFB81C99
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8FDC433F1;
        Fri,  6 Jan 2023 06:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986847;
        bh=gajrdD/p4GCUDcw1uutGDiFfEeSdgxvHA7O6py0IaxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWMOlLNrmWG9YxFR/DmyIC8AUxb1oC0zGWfGOvmszSJzEVqC9uUv5zlHOjQAFaaYq
         Egbtey1V7B+qUm4wgLycxTcB7F0dS1EeUjqeTnXgVZiwtvFi+A8esRqq9deo3+nfiB
         oCcGfgVsALh5LrwB/vCy4xYTWKj2vhZyonDXq37KkGjbHhDTgM/8nP66jhMiZHrxUs
         El0L7WcrkKgxzn7NmA6LeVgEq1gPyBd4OZiReAVsBMbynLfeViUn2mpG6l29xXQThl
         lmK6YZWekw+q2bxiQoHIXC/z+zSgrPe9V/z5q7LdKTW4bWmnacEJFfwC9Fk0ArGNxJ
         IeQN3eG7lMxBA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/9] devlink: bump the instance index directly when iterating
Date:   Thu,  5 Jan 2023 22:33:54 -0800
Message-Id: <20230106063402.485336-2-kuba@kernel.org>
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

xa_find_after() is designed to handle multi-index entries correctly.
If a xarray has two entries one which spans indexes 0-3 and one at
index 4 xa_find_after(0) will return the entry at index 4.

Having to juggle the two callbacks, however, is unnecessary in case
of the devlink xarray, as there is 1:1 relationship with indexes.

Always use xa_find() and increment the index manually.

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
index adf9f6c177db..14767e809178 100644
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
@@ -135,7 +126,7 @@ struct devlink_gen_cmd {
  */
 #define devlink_dump_for_each_instance_get(msg, state, devlink)		\
 	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
-					       &state->instance, xa_find)); \
+					       &state->instance));	\
 	     state->instance++, state->idx = 0)
 
 extern const struct genl_small_ops devlink_nl_ops[56];
-- 
2.38.1

