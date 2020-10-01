Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE25E27F673
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbgJAAFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731590AbgJAAFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:30 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B621721D43;
        Thu,  1 Oct 2020 00:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510730;
        bh=F0Mi+sJnF46Hdr7e318OrthAEewcsZ1fMbPt/pDxT3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rb8yz6+nsyhN9O+WyqC+64M/uCg+l0gFdNjfGvlxNPPYtzYxiibYCDV39nDhJBXkZ
         bGwVMym+C9ID40COf+hNGrrvDfbw9aCVtEDUmBvayeuCa098kqbhWugBBeKFib6UxO
         Pa7ByThEef6Xxgr7OI1+8ghtJtjnI4KVzZsSSMvA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 6/9] genetlink: use .start callback for dumppolicy
Date:   Wed, 30 Sep 2020 17:05:15 -0700
Message-Id: <20201001000518.685243-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structure of ctrl_dumppolicy() is clearly split into
init and dumping. Move the init to a .start callback
for clarity, it's a more idiomatic netlink dump code structure.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 48 ++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index a8001044d8cd..dfa8a00640c0 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1107,33 +1107,29 @@ struct ctrl_dump_policy_ctx {
 	unsigned int fam_id;
 };
 
-static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
+static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->args;
+	struct nlattr *tb[CTRL_ATTR_MAX + 1];
 	const struct genl_family *rt;
 	int err;
 
-	if (!ctx->fam_id) {
-		struct nlattr *tb[CTRL_ATTR_MAX + 1];
-
-		err = genlmsg_parse(cb->nlh, &genl_ctrl, tb,
-				    genl_ctrl.maxattr,
-				    genl_ctrl.policy, cb->extack);
-		if (err)
-			return err;
+	err = genlmsg_parse(cb->nlh, &genl_ctrl, tb, genl_ctrl.maxattr,
+			    genl_ctrl.policy, cb->extack);
+	if (err)
+		return err;
 
-		if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
-			return -EINVAL;
+	if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
+		return -EINVAL;
 
-		if (tb[CTRL_ATTR_FAMILY_ID]) {
-			ctx->fam_id = nla_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
-		} else {
-			rt = genl_family_find_byname(
-				nla_data(tb[CTRL_ATTR_FAMILY_NAME]));
-			if (!rt)
-				return -ENOENT;
-			ctx->fam_id = rt->id;
-		}
+	if (tb[CTRL_ATTR_FAMILY_ID]) {
+		ctx->fam_id = nla_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
+	} else {
+		rt = genl_family_find_byname(
+			nla_data(tb[CTRL_ATTR_FAMILY_NAME]));
+		if (!rt)
+			return -ENOENT;
+		ctx->fam_id = rt->id;
 	}
 
 	rt = genl_family_find_byid(ctx->fam_id);
@@ -1143,9 +1139,12 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!rt->policy)
 		return -ENODATA;
 
-	err = netlink_policy_dump_start(rt->policy, rt->maxattr, &ctx->state);
-	if (err)
-		return err;
+	return netlink_policy_dump_start(rt->policy, rt->maxattr, &ctx->state);
+}
+
+static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct ctrl_dump_policy_ctx *ctx = (void *)cb->args;
 
 	while (netlink_policy_dump_loop(&ctx->state)) {
 		void *hdr;
@@ -1157,7 +1156,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!hdr)
 			goto nla_put_failure;
 
-		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, rt->id))
+		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, ctx->fam_id))
 			goto nla_put_failure;
 
 		nest = nla_nest_start(skb, CTRL_ATTR_POLICY);
@@ -1189,6 +1188,7 @@ static const struct genl_ops genl_ctrl_ops[] = {
 	},
 	{
 		.cmd		= CTRL_CMD_GETPOLICY,
+		.start		= ctrl_dumppolicy_start,
 		.dumpit		= ctrl_dumppolicy,
 	},
 };
-- 
2.26.2

