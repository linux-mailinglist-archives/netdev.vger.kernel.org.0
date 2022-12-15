Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82A164D52A
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLOCCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLOCCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02C12ED6D
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98108B81AE0
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7203C43396;
        Thu, 15 Dec 2022 02:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069730;
        bh=yuq4fQ3ynALzFD+oa6mxkqvLNJ3RF01zzB/Fl5mcnLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxwiPjJOT0fwx7Sskk07wWCIpTHVkMknhLEitQcUcNKiJMf5oQinxoDY1bLlxYBsb
         KE5VMLdw428ad5pArDzkfD/Tr2ZO+IiG0JnqtMxb+i9wBGTmTQckze7XRsneZkbf+9
         geQqd2lnmXPOA+YceY49T2f6jUM3BzPhg8znjocjUeAlGRUFiv2T+Ra8bs/0bMSBog
         axcYFVWxcoYLwZxce2glqxiSe67gO7EJHsTCegKaGsRbo7f3ZnQlNDHL2SirBFJnw9
         WOqGftfLFQbgMtclmf0Uh+98sJAPjbI0cLhWdGa925zbtHd8RHYiuLKA6LpeQjAxDF
         Xg+olfFKrdWRg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 14/15] devlink: add by-instance dump infra
Date:   Wed, 14 Dec 2022 18:01:54 -0800
Message-Id: <20221215020155.1619839-15-kuba@kernel.org>
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

Most dumpit implementations walk the devlink instances.
This requires careful lock taking and reference dropping.
Factor the loop out and provide just a callback to handle
a single instance dump.

Convert one user as an example, other users converted
in the next change.

Slightly inspired by ethtool netlink code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c         | 55 ++++++++++++++++---------------------
 net/devlink/devl_internal.h | 10 +++++++
 net/devlink/netlink.c       | 33 ++++++++++++++++++++++
 3 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index c6ad8133fc23..f18d8dcf9751 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -1219,47 +1219,40 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
-static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
-					  struct netlink_callback *cb)
+static int
+devlink_nl_cmd_rate_get_dumpinst(struct sk_buff *msg, struct devlink *devlink,
+				 struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
-	struct devlink *devlink;
+	struct devlink_rate *devlink_rate;
+	int idx = 0;
 	int err = 0;
 
-	devlink_dump_for_each_instance_get(msg, dump, devlink) {
-		struct devlink_rate *devlink_rate;
-		int idx = 0;
-
-		devl_lock(devlink);
-		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
-			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
-			u32 id = NETLINK_CB(cb->skb).portid;
+	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
+		enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
+		u32 id = NETLINK_CB(cb->skb).portid;
 
-			if (idx < dump->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_rate_fill(msg, devlink_rate, cmd, id,
-						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI, NULL);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				dump->idx = idx;
-				goto out;
-			}
+		if (idx < dump->idx) {
 			idx++;
+			continue;
 		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		err = devlink_nl_rate_fill(msg, devlink_rate, cmd, id,
+					   cb->nlh->nlmsg_seq,
+					   NLM_F_MULTI, NULL);
+		if (err) {
+			dump->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	if (err != -EMSGSIZE)
-		return err;
 
-	return msg->len;
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_rate_get = {
+	.dump_one		= devlink_nl_cmd_rate_get_dumpinst,
+};
+
 static int devlink_nl_cmd_rate_get_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
@@ -9130,7 +9123,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_RATE_GET,
 		.doit = devlink_nl_cmd_rate_get_doit,
-		.dumpit = devlink_nl_cmd_rate_get_dumpit,
+		.dumpit = devlink_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
 		/* can be retrieved by unprivileged users */
 	},
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 5adac38454fd..e49b82dd77cd 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
 	};
 };
 
+struct devlink_gen_cmd {
+	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
+			struct netlink_callback *cb);
+};
+
 /* Iterate over devlink pointers which were possible to get reference to.
  * devlink_put() needs to be called for each iterated devlink pointer
  * in loop body in order to release the reference.
@@ -138,6 +143,9 @@ struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
 void devlink_notify_unregister(struct devlink *devlink);
 void devlink_notify_register(struct devlink *devlink);
 
+int devlink_instance_iter_dump(struct sk_buff *msg,
+			       struct netlink_callback *cb);
+
 static inline struct devlink_nl_dump_state *
 devl_dump_state(struct netlink_callback *cb)
 {
@@ -173,6 +181,8 @@ devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
 void devlink_linecard_put(struct devlink_linecard *linecard);
 
 /* Rates */
+extern const struct devlink_gen_cmd devl_gen_rate_get;
+
 struct devlink_rate *
 devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
 struct devlink_rate *
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index ce1a7d674d14..fcf10c288480 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/genetlink.h>
+#include <net/sock.h>
 
 #include "devl_internal.h"
 
@@ -177,6 +178,38 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 	devlink_put(devlink);
 }
 
+static const struct devlink_gen_cmd *devl_gen_cmds[] = {
+	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
+};
+
+int devlink_instance_iter_dump(struct sk_buff *msg, struct netlink_callback *cb)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
+	const struct devlink_gen_cmd *cmd;
+	struct devlink *devlink;
+	int err = 0;
+
+	cmd = devl_gen_cmds[info->op.cmd];
+
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		devl_lock(devlink);
+		err = cmd->dump_one(msg, devlink, cb);
+		devl_unlock(devlink);
+		devlink_put(devlink);
+
+		if (err)
+			break;
+
+		/* restart sub-object walk for the next instance */
+		dump->idx = 0;
+	}
+
+	if (err != -EMSGSIZE)
+		return err;
+	return msg->len;
+}
+
 struct genl_family devlink_nl_family __ro_after_init = {
 	.name		= DEVLINK_GENL_NAME,
 	.version	= DEVLINK_GENL_VERSION,
-- 
2.38.1

