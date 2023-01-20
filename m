Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125AD675C18
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjATRvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjATRvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:51:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3FF966C0;
        Fri, 20 Jan 2023 09:50:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA011B829C9;
        Fri, 20 Jan 2023 17:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0755C433EF;
        Fri, 20 Jan 2023 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674237055;
        bh=0tKKdkxEy9sQ0wVVlf5EUdjMLO2NPIax7lG2RdiZGEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFrN7A1N4KuuouKQO76s+yvuskA01LNNEr63yyy8jT2olX5ouendlKj9pYH1BjGAR
         OeKdyEv/7jVvkYJeIW1qkiiplGbGJx8R/8JweMpzx4m0sDKYpAuyRQVFRvoC5Cz4Ya
         eBaan6Zj8kD1a+AoVrmYRod1aj5qaGBbXBAv9o99insFzxPld/m6kI5THzpoUzsyFd
         cy0fB5U2Pc5iIeaxd4dlwdzweMePkjWYKG30nkmo8tfWxEQCCPcELfFvIm83zqEy97
         c8Sf2ni40PCnoHHQ3nJpoQVafgzegKD+w1ULuQn7K3UfEm3Dx0zV9uOwAIVaXnT0qA
         grZkYDZhiCwtw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 7/8] net: fou: use policy and operation tables generated from the spec
Date:   Fri, 20 Jan 2023 09:50:40 -0800
Message-Id: <20230120175041.342573-8-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230120175041.342573-1-kuba@kernel.org>
References: <20230120175041.342573-1-kuba@kernel.org>
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

Generate and plug in the spec-based tables.

A little bit of renaming is needed in the FOU code.

Acked-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v4:
 - use _ in the names of files instead of -
 - regen with /* */ comments
---
 net/ipv4/Makefile   |  2 +-
 net/ipv4/fou_core.c | 47 +++++++-------------------------------------
 net/ipv4/fou_nl.c   | 48 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/fou_nl.h   | 25 +++++++++++++++++++++++
 4 files changed, 81 insertions(+), 41 deletions(-)
 create mode 100644 net/ipv4/fou_nl.c
 create mode 100644 net/ipv4/fou_nl.h

diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index fabbe46897ce..880277c9fd07 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_IP_MROUTE) += ipmr.o
 obj-$(CONFIG_IP_MROUTE_COMMON) += ipmr_base.o
 obj-$(CONFIG_NET_IPIP) += ipip.o
 gre-y := gre_demux.o
-fou-y := fou_core.o
+fou-y := fou_core.o fou_nl.o
 obj-$(CONFIG_NET_FOU) += fou.o
 obj-$(CONFIG_NET_IPGRE_DEMUX) += gre.o
 obj-$(CONFIG_NET_IPGRE) += ip_gre.o
diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index 0c3c6d0cee29..cafec9b4eee0 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -19,6 +19,8 @@
 #include <uapi/linux/fou.h>
 #include <uapi/linux/genetlink.h>
 
+#include "fou_nl.h"
+
 struct fou {
 	struct socket *sock;
 	u8 protocol;
@@ -640,20 +642,6 @@ static int fou_destroy(struct net *net, struct fou_cfg *cfg)
 
 static struct genl_family fou_nl_family;
 
-static const struct nla_policy fou_nl_policy[FOU_ATTR_MAX + 1] = {
-	[FOU_ATTR_PORT]			= { .type = NLA_U16, },
-	[FOU_ATTR_AF]			= { .type = NLA_U8, },
-	[FOU_ATTR_IPPROTO]		= { .type = NLA_U8, },
-	[FOU_ATTR_TYPE]			= { .type = NLA_U8, },
-	[FOU_ATTR_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG, },
-	[FOU_ATTR_LOCAL_V4]		= { .type = NLA_U32, },
-	[FOU_ATTR_PEER_V4]		= { .type = NLA_U32, },
-	[FOU_ATTR_LOCAL_V6]		= { .len = sizeof(struct in6_addr), },
-	[FOU_ATTR_PEER_V6]		= { .len = sizeof(struct in6_addr), },
-	[FOU_ATTR_PEER_PORT]		= { .type = NLA_U16, },
-	[FOU_ATTR_IFINDEX]		= { .type = NLA_S32, },
-};
-
 static int parse_nl_config(struct genl_info *info,
 			   struct fou_cfg *cfg)
 {
@@ -745,7 +733,7 @@ static int parse_nl_config(struct genl_info *info,
 	return 0;
 }
 
-static int fou_nl_cmd_add_port(struct sk_buff *skb, struct genl_info *info)
+int fou_nl_add_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
 	struct fou_cfg cfg;
@@ -758,7 +746,7 @@ static int fou_nl_cmd_add_port(struct sk_buff *skb, struct genl_info *info)
 	return fou_create(net, &cfg, NULL);
 }
 
-static int fou_nl_cmd_rm_port(struct sk_buff *skb, struct genl_info *info)
+int fou_nl_del_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
 	struct fou_cfg cfg;
@@ -827,7 +815,7 @@ static int fou_dump_info(struct fou *fou, u32 portid, u32 seq,
 	return -EMSGSIZE;
 }
 
-static int fou_nl_cmd_get_port(struct sk_buff *skb, struct genl_info *info)
+int fou_nl_get_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
 	struct fou_net *fn = net_generic(net, fou_net_id);
@@ -874,7 +862,7 @@ static int fou_nl_cmd_get_port(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static int fou_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
+int fou_nl_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
 	struct fou_net *fn = net_generic(net, fou_net_id);
@@ -897,33 +885,12 @@ static int fou_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static const struct genl_small_ops fou_nl_ops[] = {
-	{
-		.cmd = FOU_CMD_ADD,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.doit = fou_nl_cmd_add_port,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = FOU_CMD_DEL,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.doit = fou_nl_cmd_rm_port,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
-		.cmd = FOU_CMD_GET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.doit = fou_nl_cmd_get_port,
-		.dumpit = fou_nl_dump,
-	},
-};
-
 static struct genl_family fou_nl_family __ro_after_init = {
 	.hdrsize	= 0,
 	.name		= FOU_GENL_NAME,
 	.version	= FOU_GENL_VERSION,
 	.maxattr	= FOU_ATTR_MAX,
-	.policy = fou_nl_policy,
+	.policy		= fou_nl_policy,
 	.netnsok	= true,
 	.module		= THIS_MODULE,
 	.small_ops	= fou_nl_ops,
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
new file mode 100644
index 000000000000..6c3820f41dd5
--- /dev/null
+++ b/net/ipv4/fou_nl.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/fou.yaml */
+/* YNL-GEN kernel source */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "fou_nl.h"
+
+#include <linux/fou.h>
+
+/* Global operation policy for fou */
+const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1] = {
+	[FOU_ATTR_PORT] = { .type = NLA_U16, },
+	[FOU_ATTR_AF] = { .type = NLA_U8, },
+	[FOU_ATTR_IPPROTO] = { .type = NLA_U8, },
+	[FOU_ATTR_TYPE] = { .type = NLA_U8, },
+	[FOU_ATTR_REMCSUM_NOPARTIAL] = { .type = NLA_FLAG, },
+	[FOU_ATTR_LOCAL_V4] = { .type = NLA_U32, },
+	[FOU_ATTR_LOCAL_V6] = { .len = 16, },
+	[FOU_ATTR_PEER_V4] = { .type = NLA_U32, },
+	[FOU_ATTR_PEER_V6] = { .len = 16, },
+	[FOU_ATTR_PEER_PORT] = { .type = NLA_U16, },
+	[FOU_ATTR_IFINDEX] = { .type = NLA_S32, },
+};
+
+/* Ops table for fou */
+const struct genl_small_ops fou_nl_ops[3] = {
+	{
+		.cmd		= FOU_CMD_ADD,
+		.validate	= GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit		= fou_nl_add_doit,
+		.flags		= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd		= FOU_CMD_DEL,
+		.validate	= GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit		= fou_nl_del_doit,
+		.flags		= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd		= FOU_CMD_GET,
+		.validate	= GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit		= fou_nl_get_doit,
+		.dumpit		= fou_nl_get_dumpit,
+	},
+};
diff --git a/net/ipv4/fou_nl.h b/net/ipv4/fou_nl.h
new file mode 100644
index 000000000000..b7a68121ce6f
--- /dev/null
+++ b/net/ipv4/fou_nl.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/fou.yaml */
+/* YNL-GEN kernel header */
+
+#ifndef _LINUX_FOU_GEN_H
+#define _LINUX_FOU_GEN_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include <linux/fou.h>
+
+/* Global operation policy for fou */
+extern const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1];
+
+/* Ops table for fou */
+extern const struct genl_small_ops fou_nl_ops[3];
+
+int fou_nl_add_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_del_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_get_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+
+#endif /* _LINUX_FOU_GEN_H */
-- 
2.39.0

