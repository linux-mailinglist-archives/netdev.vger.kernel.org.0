Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F25281DD4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJBVuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgJBVuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:50:06 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ACDD2177B;
        Fri,  2 Oct 2020 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601675405;
        bh=Vaj81rPoMCPNOOOSB5yKF56452c2Qoe6OBAUWVA1gZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBVqm/z1cdMmN+DgdRcgAHzn36TRHipPV7XcvvMtu/dzC01tR9BO74bxhAlrPKH5d
         RTOFEbcEPZlFPUerpZkCzvYn69yuWkSdykepB77moE5C4EUHXBxgHPFAYjBM1aXoJc
         uXjnvijvbXDVdS8t7n9I70ZsOX9QPrU+8IDDLVKk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 4/9] genetlink: add a structure for dump state
Date:   Fri,  2 Oct 2020 14:49:55 -0700
Message-Id: <20201002215000.1526096-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002215000.1526096-1-kuba@kernel.org>
References: <20201002215000.1526096-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever netlink dump uses more than 2 cb->args[] entries
code gets hard to read. We're about to add more state to
ctrl_dumppolicy() so create a structure.

Since the structure is typed and clearly named we can remove
the local fam_id variable and use ctx->fam_id directly.

v3:
 - rebase onto explicit free fix
v1:
 - s/nl_policy_dump/netlink_policy_dump_state/
 - forward declare struct netlink_policy_dump_state,
   and move from passing unsigned long to actual pointer type
 - add build bug on
 - u16 fam_id
 - s/args/ctx/

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/netlink.h   | 11 +++++++----
 net/netlink/genetlink.c | 28 ++++++++++++++++++----------
 net/netlink/policy.c    | 31 ++++++++++++++-----------------
 3 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 9e7eca961a98..00258590f2cb 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1935,11 +1935,14 @@ void nla_get_range_unsigned(const struct nla_policy *pt,
 void nla_get_range_signed(const struct nla_policy *pt,
 			  struct netlink_range_validation_signed *range);
 
+struct netlink_policy_dump_state;
+
 int netlink_policy_dump_start(const struct nla_policy *policy,
 			      unsigned int maxtype,
-			      unsigned long *state);
-bool netlink_policy_dump_loop(unsigned long state);
-int netlink_policy_dump_write(struct sk_buff *skb, unsigned long state);
-void netlink_policy_dump_free(unsigned long state);
+			      struct netlink_policy_dump_state **state);
+bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state);
+int netlink_policy_dump_write(struct sk_buff *skb,
+			      struct netlink_policy_dump_state *state);
+void netlink_policy_dump_free(struct netlink_policy_dump_state *state);
 
 #endif
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 42a3c6c7a5ee..1febc7db1110 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1102,13 +1102,20 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 	return 0;
 }
 
+struct ctrl_dump_policy_ctx {
+	struct netlink_policy_dump_state *state;
+	u16 fam_id;
+};
+
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 	const struct genl_family *rt;
-	unsigned int fam_id = cb->args[0];
 	int err;
 
-	if (!fam_id) {
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+
+	if (!ctx->fam_id) {
 		struct nlattr *tb[CTRL_ATTR_MAX + 1];
 
 		err = genlmsg_parse(cb->nlh, &genl_ctrl, tb,
@@ -1121,28 +1128,28 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 			return -EINVAL;
 
 		if (tb[CTRL_ATTR_FAMILY_ID]) {
-			fam_id = nla_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
+			ctx->fam_id = nla_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
 		} else {
 			rt = genl_family_find_byname(
 				nla_data(tb[CTRL_ATTR_FAMILY_NAME]));
 			if (!rt)
 				return -ENOENT;
-			fam_id = rt->id;
+			ctx->fam_id = rt->id;
 		}
 	}
 
-	rt = genl_family_find_byid(fam_id);
+	rt = genl_family_find_byid(ctx->fam_id);
 	if (!rt)
 		return -ENOENT;
 
 	if (!rt->policy)
 		return -ENODATA;
 
-	err = netlink_policy_dump_start(rt->policy, rt->maxattr, &cb->args[1]);
+	err = netlink_policy_dump_start(rt->policy, rt->maxattr, &ctx->state);
 	if (err)
 		return err;
 
-	while (netlink_policy_dump_loop(cb->args[1])) {
+	while (netlink_policy_dump_loop(ctx->state)) {
 		void *hdr;
 		struct nlattr *nest;
 
@@ -1159,7 +1166,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!nest)
 			goto nla_put_failure;
 
-		if (netlink_policy_dump_write(skb, cb->args[1]))
+		if (netlink_policy_dump_write(skb, ctx->state))
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
@@ -1172,13 +1179,14 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		break;
 	}
 
-	cb->args[0] = fam_id;
 	return skb->len;
 }
 
 static int ctrl_dumppolicy_done(struct netlink_callback *cb)
 {
-	netlink_policy_dump_free(cb->args[1]);
+	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
+
+	netlink_policy_dump_free(ctx->state);
 	return 0;
 }
 
diff --git a/net/netlink/policy.c b/net/netlink/policy.c
index 7a9792442578..ebc64b20b6ee 100644
--- a/net/netlink/policy.c
+++ b/net/netlink/policy.c
@@ -14,7 +14,7 @@
 
 #define INITIAL_POLICIES_ALLOC	10
 
-struct nl_policy_dump {
+struct netlink_policy_dump_state {
 	unsigned int policy_idx;
 	unsigned int attr_idx;
 	unsigned int n_alloc;
@@ -24,11 +24,11 @@ struct nl_policy_dump {
 	} policies[];
 };
 
-static int add_policy(struct nl_policy_dump **statep,
+static int add_policy(struct netlink_policy_dump_state **statep,
 		      const struct nla_policy *policy,
 		      unsigned int maxtype)
 {
-	struct nl_policy_dump *state = *statep;
+	struct netlink_policy_dump_state *state = *statep;
 	unsigned int n_alloc, i;
 
 	if (!policy || !maxtype)
@@ -62,7 +62,7 @@ static int add_policy(struct nl_policy_dump **statep,
 	return 0;
 }
 
-static unsigned int get_policy_idx(struct nl_policy_dump *state,
+static unsigned int get_policy_idx(struct netlink_policy_dump_state *state,
 				   const struct nla_policy *policy)
 {
 	unsigned int i;
@@ -78,13 +78,13 @@ static unsigned int get_policy_idx(struct nl_policy_dump *state,
 
 int netlink_policy_dump_start(const struct nla_policy *policy,
 			      unsigned int maxtype,
-                              unsigned long *_state)
+			      struct netlink_policy_dump_state **statep)
 {
-	struct nl_policy_dump *state;
+	struct netlink_policy_dump_state *state;
 	unsigned int policy_idx;
 	int err;
 
-	if (*_state)
+	if (*statep)
 		return 0;
 
 	/*
@@ -128,27 +128,26 @@ int netlink_policy_dump_start(const struct nla_policy *policy,
 		}
 	}
 
-	*_state = (unsigned long)state;
+	*statep = state;
 
 	return 0;
 }
 
-static bool netlink_policy_dump_finished(struct nl_policy_dump *state)
+static bool
+netlink_policy_dump_finished(struct netlink_policy_dump_state *state)
 {
 	return state->policy_idx >= state->n_alloc ||
 	       !state->policies[state->policy_idx].policy;
 }
 
-bool netlink_policy_dump_loop(unsigned long _state)
+bool netlink_policy_dump_loop(struct netlink_policy_dump_state *state)
 {
-	struct nl_policy_dump *state = (void *)_state;
-
 	return !netlink_policy_dump_finished(state);
 }
 
-int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
+int netlink_policy_dump_write(struct sk_buff *skb,
+			      struct netlink_policy_dump_state *state)
 {
-	struct nl_policy_dump *state = (void *)_state;
 	const struct nla_policy *pt;
 	struct nlattr *policy, *attr;
 	enum netlink_attribute_type type;
@@ -306,9 +305,7 @@ int netlink_policy_dump_write(struct sk_buff *skb, unsigned long _state)
 	return -ENOBUFS;
 }
 
-void netlink_policy_dump_free(unsigned long _state)
+void netlink_policy_dump_free(struct netlink_policy_dump_state *state)
 {
-	struct nl_policy_dump *state = (void *)_state;
-
 	kfree(state);
 }
-- 
2.26.2

