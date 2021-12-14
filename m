Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB44547495F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhLNR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhLNR14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:27:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89830C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 09:27:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mxBal-0005Rl-1u; Tue, 14 Dec 2021 18:27:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 3/4] fib: rules: remove duplicated nla policies
Date:   Tue, 14 Dec 2021 18:27:30 +0100
Message-Id: <20211214172731.3591-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214172731.3591-1-fw@strlen.de>
References: <20211214172731.3591-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The attributes are identical in all implementations so move the ipv4 one
into the core and remove the per-family nla policies.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since last version.

 include/net/fib_rules.h | 1 -
 net/core/fib_rules.c    | 9 +++++++--
 net/decnet/dn_rules.c   | 5 -----
 net/ipv4/fib_rules.c    | 6 ------
 net/ipv4/ipmr.c         | 5 -----
 net/ipv6/fib6_rules.c   | 5 -----
 net/ipv6/ip6mr.c        | 5 -----
 7 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index d15e5638b937..08b85a4eedcc 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -89,7 +89,6 @@ struct fib_rules_ops {
 	void			(*flush_cache)(struct fib_rules_ops *ops);
 
 	int			nlgroup;
-	const struct nla_policy	*policy;
 	struct list_head	rules_list;
 	struct module		*owner;
 	struct net		*fro_net;
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index c763b69eea8c..5dce3f5adb17 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -828,6 +828,11 @@ static int rule_exists(struct fib_rules_ops *ops, struct fib_rule_hdr *frh,
 	return 0;
 }
 
+static const struct nla_policy fib_rule_policy[FRA_MAX + 1] = {
+	FRA_GENERIC_POLICY,
+	[FRA_FLOW]	= { .type = NLA_U32 },
+};
+
 int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 		   struct netlink_ext_ack *extack)
 {
@@ -852,7 +857,7 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(*frh), tb, FRA_MAX,
-				     ops->policy, extack);
+				     fib_rule_policy, extack);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Error parsing msg");
 		goto errout;
@@ -960,7 +965,7 @@ int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(*frh), tb, FRA_MAX,
-				     ops->policy, extack);
+				     fib_rule_policy, extack);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Error parsing msg");
 		goto errout;
diff --git a/net/decnet/dn_rules.c b/net/decnet/dn_rules.c
index 4a4e3c17740c..ee73057529cf 100644
--- a/net/decnet/dn_rules.c
+++ b/net/decnet/dn_rules.c
@@ -101,10 +101,6 @@ static int dn_fib_rule_action(struct fib_rule *rule, struct flowi *flp,
 	return err;
 }
 
-static const struct nla_policy dn_fib_rule_policy[FRA_MAX+1] = {
-	FRA_GENERIC_POLICY,
-};
-
 static int dn_fib_rule_match(struct fib_rule *rule, struct flowi *fl, int flags)
 {
 	struct dn_fib_rule *r = (struct dn_fib_rule *)rule;
@@ -235,7 +231,6 @@ static const struct fib_rules_ops __net_initconst dn_fib_rules_ops_template = {
 	.fill		= dn_fib_rule_fill,
 	.flush_cache	= dn_fib_rule_flush_cache,
 	.nlgroup	= RTNLGRP_DECnet_RULE,
-	.policy		= dn_fib_rule_policy,
 	.owner		= THIS_MODULE,
 	.fro_net	= &init_net,
 };
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index 560702a9bed4..cf873b0788a3 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -183,11 +183,6 @@ static struct fib_table *fib_empty_table(struct net *net)
 	return NULL;
 }
 
-static const struct nla_policy fib4_rule_policy[FRA_MAX+1] = {
-	FRA_GENERIC_POLICY,
-	[FRA_FLOW]	= { .type = NLA_U32 },
-};
-
 static int fib4_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       struct fib_rule_hdr *frh,
 			       struct nlattr **tb,
@@ -352,7 +347,6 @@ static const struct fib_rules_ops __net_initconst fib4_rules_ops_template = {
 	.nlmsg_payload	= fib4_rule_nlmsg_payload,
 	.flush_cache	= fib4_rule_flush_cache,
 	.nlgroup	= RTNLGRP_IPV4_RULE,
-	.policy		= fib4_rule_policy,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 4c7aca884fa9..07274619b9ea 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -195,10 +195,6 @@ static int ipmr_rule_match(struct fib_rule *rule, struct flowi *fl, int flags)
 	return 1;
 }
 
-static const struct nla_policy ipmr_rule_policy[FRA_MAX + 1] = {
-	FRA_GENERIC_POLICY,
-};
-
 static int ipmr_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       struct fib_rule_hdr *frh, struct nlattr **tb,
 			       struct netlink_ext_ack *extack)
@@ -231,7 +227,6 @@ static const struct fib_rules_ops __net_initconst ipmr_rules_ops_template = {
 	.compare	= ipmr_rule_compare,
 	.fill		= ipmr_rule_fill,
 	.nlgroup	= RTNLGRP_IPV4_RULE,
-	.policy		= ipmr_rule_policy,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 6b6718844fee..26da672f4d00 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -307,10 +307,6 @@ INDIRECT_CALLABLE_SCOPE int fib6_rule_match(struct fib_rule *rule,
 	return 1;
 }
 
-static const struct nla_policy fib6_rule_policy[FRA_MAX+1] = {
-	FRA_GENERIC_POLICY,
-};
-
 static int fib6_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 			       struct fib_rule_hdr *frh,
 			       struct nlattr **tb,
@@ -425,7 +421,6 @@ static const struct fib_rules_ops __net_initconst fib6_rules_ops_template = {
 	.fill			= fib6_rule_fill,
 	.nlmsg_payload		= fib6_rule_nlmsg_payload,
 	.nlgroup		= RTNLGRP_IPV6_RULE,
-	.policy			= fib6_rule_policy,
 	.owner			= THIS_MODULE,
 	.fro_net		= &init_net,
 };
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a77a15a7f3dc..7cf73e60e619 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -182,10 +182,6 @@ static int ip6mr_rule_match(struct fib_rule *rule, struct flowi *flp, int flags)
 	return 1;
 }
 
-static const struct nla_policy ip6mr_rule_policy[FRA_MAX + 1] = {
-	FRA_GENERIC_POLICY,
-};
-
 static int ip6mr_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 				struct fib_rule_hdr *frh, struct nlattr **tb,
 				struct netlink_ext_ack *extack)
@@ -218,7 +214,6 @@ static const struct fib_rules_ops __net_initconst ip6mr_rules_ops_template = {
 	.compare	= ip6mr_rule_compare,
 	.fill		= ip6mr_rule_fill,
 	.nlgroup	= RTNLGRP_IPV6_RULE,
-	.policy		= ip6mr_rule_policy,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.32.0

