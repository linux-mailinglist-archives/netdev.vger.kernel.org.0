Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F0F473094
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbhLMPcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbhLMPcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:32:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4FBC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 07:32:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mwnJJ-0006oR-5j; Mon, 13 Dec 2021 16:32:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 4/4] fib: expand fib_rule_policy
Date:   Mon, 13 Dec 2021 16:31:47 +0100
Message-Id: <20211213153147.17635-5-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211213153147.17635-1-fw@strlen.de>
References: <20211213153147.17635-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there is only one fib nla_policy there is no need to
keep the macro around.  Place it where its used.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/fib_rules.h | 20 --------------------
 net/core/fib_rules.c    | 18 +++++++++++++++++-
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 08b85a4eedcc..27dbff62b5c2 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -100,26 +100,6 @@ struct fib_rule_notifier_info {
 	struct fib_rule *rule;
 };
 
-#define FRA_GENERIC_POLICY \
-	[FRA_UNSPEC]	= { .strict_start_type = FRA_DPORT_RANGE + 1 }, \
-	[FRA_IIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
-	[FRA_OIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
-	[FRA_PRIORITY]	= { .type = NLA_U32 }, \
-	[FRA_FWMARK]	= { .type = NLA_U32 }, \
-	[FRA_TUN_ID]	= { .type = NLA_U64 }, \
-	[FRA_FWMASK]	= { .type = NLA_U32 }, \
-	[FRA_TABLE]     = { .type = NLA_U32 }, \
-	[FRA_SUPPRESS_PREFIXLEN] = { .type = NLA_U32 }, \
-	[FRA_SUPPRESS_IFGROUP] = { .type = NLA_U32 }, \
-	[FRA_GOTO]	= { .type = NLA_U32 }, \
-	[FRA_L3MDEV]	= { .type = NLA_U8 }, \
-	[FRA_UID_RANGE]	= { .len = sizeof(struct fib_rule_uid_range) }, \
-	[FRA_PROTOCOL]  = { .type = NLA_U8 }, \
-	[FRA_IP_PROTO]  = { .type = NLA_U8 }, \
-	[FRA_SPORT_RANGE] = { .len = sizeof(struct fib_rule_port_range) }, \
-	[FRA_DPORT_RANGE] = { .len = sizeof(struct fib_rule_port_range) }
-
-
 static inline void fib_rule_get(struct fib_rule *rule)
 {
 	refcount_inc(&rule->refcnt);
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 2ee8bd067afc..5ed0ff875898 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -825,8 +825,24 @@ static int rule_exists(struct fib_rules_ops *ops, struct fib_rule_hdr *frh,
 }
 
 static const struct nla_policy fib_rule_policy[FRA_MAX + 1] = {
-	FRA_GENERIC_POLICY,
+	[FRA_UNSPEC]	= { .strict_start_type = FRA_DPORT_RANGE + 1 },
+	[FRA_IIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 },
+	[FRA_OIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 },
+	[FRA_PRIORITY]	= { .type = NLA_U32 },
+	[FRA_FWMARK]	= { .type = NLA_U32 },
 	[FRA_FLOW]	= { .type = NLA_U32 },
+	[FRA_TUN_ID]	= { .type = NLA_U64 },
+	[FRA_FWMASK]	= { .type = NLA_U32 },
+	[FRA_TABLE]     = { .type = NLA_U32 },
+	[FRA_SUPPRESS_PREFIXLEN] = { .type = NLA_U32 },
+	[FRA_SUPPRESS_IFGROUP] = { .type = NLA_U32 },
+	[FRA_GOTO]	= { .type = NLA_U32 },
+	[FRA_L3MDEV]	= { .type = NLA_U8 },
+	[FRA_UID_RANGE]	= { .len = sizeof(struct fib_rule_uid_range) },
+	[FRA_PROTOCOL]  = { .type = NLA_U8 },
+	[FRA_IP_PROTO]  = { .type = NLA_U8 },
+	[FRA_SPORT_RANGE] = { .len = sizeof(struct fib_rule_port_range) },
+	[FRA_DPORT_RANGE] = { .len = sizeof(struct fib_rule_port_range) }
 };
 
 int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.32.0

