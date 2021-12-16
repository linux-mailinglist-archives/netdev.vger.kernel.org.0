Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0514F47714F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhLPMF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbhLPMF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:05:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCB2C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:05:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mxpVk-0007oM-CD; Thu, 16 Dec 2021 13:05:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH v4 net-next 2/2] fib: expand fib_rule_policy
Date:   Thu, 16 Dec 2021 13:05:07 +0100
Message-Id: <20211216120507.3299-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211216120507.3299-1-fw@strlen.de>
References: <20211216120507.3299-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there is only one fib nla_policy there is no need to
keep the macro around.  Place it where its used.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 resend without changes.

 include/net/fib_rules.h | 20 --------------------
 net/core/fib_rules.c    | 18 +++++++++++++++++-
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 4183204915dc..82da359bca03 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -102,26 +102,6 @@ struct fib_rule_notifier_info {
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
index f2ae5dcef0bc..75282222e0b4 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -751,8 +751,24 @@ static int rule_exists(struct fib_rules_ops *ops, struct fib_rule_hdr *frh,
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

