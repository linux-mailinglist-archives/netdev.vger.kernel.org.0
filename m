Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC30865E463
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjAEEGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjAEEFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E30237278
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F487B819B1
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E13C43392;
        Thu,  5 Jan 2023 04:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891542;
        bh=lxKmtNbxfAgsgwI8aC0TTlAohOR6NDnaW0faGKCQpIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRskPDxiU1uUjyFgFembeUJ80w2IicOhcmWwgKXqrvcAGRd28qNtiC8FX7u9j4e0g
         w/GIJ5Jv57D/611cDjd3GSUBcdG4MsQHUIOl9IoSGiAVuBL7gKF704NNIYpEHH4V4V
         0PocoPoYCM5TkkuSp3PMcgoaYOIsoG5fsVt0QrJBgUlFXsGGjBTRzM5T8OGZeyslTq
         HxAsDM45OY1xT8yJ7NqMa/7hp4K3hfnBt3HyJq3geeMHHAQ4hj4arXcu/ZRFMHzx16
         WeOUSvi6eIT8LQqr5shDPXjCSskOvdLdFlUI1Q9l9+FseGk6QWsdHV8s45TTOtxDhn
         JyG2nPEQo4EEQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 10/15] devlink: restart dump based on devlink instance ids (simple)
Date:   Wed,  4 Jan 2023 20:05:26 -0800
Message-Id: <20230105040531.353563-11-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105040531.353563-1-kuba@kernel.org>
References: <20230105040531.353563-1-kuba@kernel.org>
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

xarray gives each devlink instance an id and allows us to restart
walk based on that id quite neatly. This is nice both from the
perspective of code brevity and from the stability of the dump
(devlink instances disappearing from before the resumption point
will not cause inconsistent dumps).

This patch takes care of simple cases where state->idx counts
devlink instances only.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/core.c          |  2 +-
 net/devlink/devl_internal.h | 16 ++++++++++++++++
 net/devlink/leftover.c      | 36 ++++++++----------------------------
 3 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 3a99bf84632e..371d6821315d 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -91,7 +91,7 @@ void devlink_put(struct devlink *devlink)
 		call_rcu(&devlink->rcu, __devlink_put_rcu);
 }
 
-static struct devlink *
+struct devlink *
 devlinks_xa_find_get(struct net *net, unsigned long *indexp,
 		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
 					  unsigned long, xa_mark_t))
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index d680783e13be..c28032761476 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -87,6 +87,10 @@ extern struct genl_family devlink_nl_family;
 	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
 
 struct devlink *
+devlinks_xa_find_get(struct net *net, unsigned long *indexp,
+		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
+					  unsigned long, xa_mark_t));
+struct devlink *
 devlinks_xa_find_get_first(struct net *net, unsigned long *indexp);
 struct devlink *
 devlinks_xa_find_get_next(struct net *net, unsigned long *indexp);
@@ -104,6 +108,7 @@ enum devlink_multicast_groups {
 
 /* state held across netlink dumps */
 struct devlink_nl_dump_state {
+	unsigned long instance;
 	int idx;
 	union {
 		/* DEVLINK_CMD_REGION_READ */
@@ -117,6 +122,17 @@ struct devlink_nl_dump_state {
 	};
 };
 
+/* Iterate over registered devlink instances for devlink dump.
+ * devlink_put() needs to be called for each iterated devlink pointer
+ * in loop body in order to release the reference.
+ * Note: this is NOT a generic iterator, it makes assumptions about the use
+ *	 of @state and can only be used once per dumpit implementation.
+ */
+#define devlink_dump_for_each_instance_get(msg, state, devlink)		\
+	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
+					       &state->instance, xa_find)); \
+	     state->instance++)
+
 extern const struct genl_small_ops devlink_nl_ops[56];
 
 struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 83cd7bd55941..db7c095a0d75 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1319,17 +1319,9 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < state->idx) {
-			idx++;
-			devlink_put(devlink);
-			continue;
-		}
-
+	devlink_dump_for_each_instance_get(msg, state, devlink) {
 		devl_lock(devlink);
 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
 				      NETLINK_CB(cb->skb).portid,
@@ -1339,10 +1331,8 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 
 		if (err)
 			goto out;
-		idx++;
 	}
 out:
-	state->idx = idx;
 	return msg->len;
 }
 
@@ -4872,13 +4862,13 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < state->idx || !devlink->ops->selftest_check)
-			goto inc;
+	devlink_dump_for_each_instance_get(msg, state, devlink) {
+		if (!devlink->ops->selftest_check) {
+			devlink_put(devlink);
+			continue;
+		}
 
 		devl_lock(devlink);
 		err = devlink_nl_selftests_fill(msg, devlink,
@@ -4890,15 +4880,13 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
 			devlink_put(devlink);
 			break;
 		}
-inc:
-		idx++;
+
 		devlink_put(devlink);
 	}
 
 	if (err != -EMSGSIZE)
 		return err;
 
-	state->idx = idx;
 	return msg->len;
 }
 
@@ -6747,14 +6735,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < state->idx)
-			goto inc;
-
+	devlink_dump_for_each_instance_get(msg, state, devlink) {
 		devl_lock(devlink);
 		err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
 					   NETLINK_CB(cb->skb).portid,
@@ -6767,15 +6750,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 			devlink_put(devlink);
 			break;
 		}
-inc:
-		idx++;
 		devlink_put(devlink);
 	}
 
 	if (err != -EMSGSIZE)
 		return err;
 
-	state->idx = idx;
 	return msg->len;
 }
 
-- 
2.38.1

