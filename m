Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D3F65CC54
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbjADERS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbjADEQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDFF167FA
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEB3760B7F
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD4CC433F1;
        Wed,  4 Jan 2023 04:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805811;
        bh=ECwqvg6qvKAMPqAvNYjlGcpsP+ORCHMpgrVPk0MMnL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxMdpXXe3Dvyu/Oz2tiExm5rR0Cu0UaHLtyKlaKRnL13L/cni8CA2Dbj1BZkdaZYh
         jxbydIjHC/3fKK7BXopm4oJ4zjGoOYf9KJYccZ67K9UsOCIdd9Q5IC2zde5VX89EDI
         +TrtaaJo6tb/vfraXFDmBIjrTeAg7Ow1RgU0o/W3VVUOrJ96O5wOxB2i3BG00kPouP
         A8chS4m7etMvFNUuEscd3r+Pof+ZQZUkI0yIoiXok9jFXdnq5AIOYFamZMdhaOgsVw
         aB4ltXCtmTyU4B8buVBiB1KZtXfhIkct7LNNLPrpikC05tP3X60tSuttzYgNoemdGY
         cHseLsLnhlHig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 13/14] devlink: add by-instance dump infra
Date:   Tue,  3 Jan 2023 20:16:35 -0800
Message-Id: <20230104041636.226398-14-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230104041636.226398-1-kuba@kernel.org>
References: <20230104041636.226398-1-kuba@kernel.org>
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

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/devl_internal.h | 10 +++++++
 net/devlink/leftover.c      | 55 ++++++++++++++++---------------------
 net/devlink/netlink.c       | 33 ++++++++++++++++++++++
 3 files changed, 67 insertions(+), 31 deletions(-)

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
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index c6ad8133fc23..f18d8dcf9751 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
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

