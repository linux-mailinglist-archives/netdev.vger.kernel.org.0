Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392AE672D80
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjASAhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjASAgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:36:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F40611EB;
        Wed, 18 Jan 2023 16:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA32B81FB8;
        Thu, 19 Jan 2023 00:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6BCC433EF;
        Thu, 19 Jan 2023 00:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674088583;
        bh=4HfnRMPxtp1KNL+lkrl/meYiHmQOakCOqtXc9wtpK6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEnsTJohzN8Qeupasb5mw1akOEat3SglXiK16Qz1RakHJ8Ac4WQcAa8Qul0ZWRjim
         MxVGuGrFbfKlYHX2IRuyrX2KjcvYkGKoiQV7VEQIhM2L5zZg6W5JjauGZHm6EozIPb
         uOmKr036LomNxUmv3JXjv7z7Y9hduA/YficTHz8oW4vK0Fm662NCerKYGbTTZliiX+
         jwb+XH0/B17qd+UMg78cZTC68MDjRAlTtpnUahgTXkI2t8RPAtJYQZKyA3gLWYYJIC
         6j+ojNSOu9aokHiPpbH2jCdV9wYx6zcNmgxCOa0XITWYtq7PiA7p3PI3hCZX8Iy7Nu
         LzTsr/B70vBvQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 7/8] net: fou: use policy and operation tables generated from the spec
Date:   Wed, 18 Jan 2023 16:36:12 -0800
Message-Id: <20230119003613.111778-8-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119003613.111778-1-kuba@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/Makefile   |  2 +-
 net/ipv4/fou-nl.c   | 48 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/fou-nl.h   | 25 +++++++++++++++++++++++
 net/ipv4/fou_core.c | 47 +++++++-------------------------------------
 4 files changed, 81 insertions(+), 41 deletions(-)
 create mode 100644 net/ipv4/fou-nl.c
 create mode 100644 net/ipv4/fou-nl.h

diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index fabbe46897ce..984da5159afb 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_IP_MROUTE) += ipmr.o
 obj-$(CONFIG_IP_MROUTE_COMMON) += ipmr_base.o
 obj-$(CONFIG_NET_IPIP) += ipip.o
 gre-y := gre_demux.o
-fou-y := fou_core.o
+fou-y := fou_core.o fou-nl.o
 obj-$(CONFIG_NET_FOU) += fou.o
 obj-$(CONFIG_NET_IPGRE_DEMUX) += gre.o
 obj-$(CONFIG_NET_IPGRE) += ip_gre.o
diff --git a/net/ipv4/fou-nl.c b/net/ipv4/fou-nl.c
new file mode 100644
index 000000000000..2ce8151301b4
--- /dev/null
+++ b/net/ipv4/fou-nl.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/fou.yaml */
+/* YNL-GEN kernel source */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "fou-nl.h"
+
+#include <linux/fou.h>
+
+// Global operation policy for fou
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
+// Ops table for fou
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
diff --git a/net/ipv4/fou-nl.h b/net/ipv4/fou-nl.h
new file mode 100644
index 000000000000..fc1d1c671c4d
--- /dev/null
+++ b/net/ipv4/fou-nl.h
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: BSD-3-Clause
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
+// Global operation policy for fou
+extern const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1];
+
+// Ops table for fou
+extern const struct genl_small_ops fou_nl_ops[3];
+
+int fou_nl_add_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_del_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_get_doit(struct sk_buff *skb, struct genl_info *info);
+int fou_nl_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+
+#endif /* _LINUX_FOU_GEN_H */
diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index 0c3c6d0cee29..606d2a4556aa 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -19,6 +19,8 @@
 #include <uapi/linux/fou.h>
 #include <uapi/linux/genetlink.h>
 
+#include "fou-nl.h"
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
-- 
2.39.0

