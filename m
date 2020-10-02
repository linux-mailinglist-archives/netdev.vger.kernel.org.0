Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83555281DD5
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgJBVuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgJBVuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:50:06 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42E102168B;
        Fri,  2 Oct 2020 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601675405;
        bh=UTloXJMu7DEQzfNfQtHi++KmlsPBj8O8yNNTY0Bbyv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNOay8cRSZpZARZ1+AUwQ2RgezkbjVRiTh6Tp8aBXCKAiRSGEUgaYZzvZ69riNkVM
         3AIQxFgSy91hi/2aKk9PCAp4scYTq6aFABYUtM7ZUW6pkLhgSdEjwxaNLGEB38Nofr
         kbUyfbekLwImqj4HBSO3Jd3lKPm4DAmwv5pyxKq4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 5/9] genetlink: use .start callback for dumppolicy
Date:   Fri,  2 Oct 2020 14:49:56 -0700
Message-Id: <20201002215000.1526096-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002215000.1526096-1-kuba@kernel.org>
References: <20201002215000.1526096-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structure of ctrl_dumppolicy() is clearly split into
init and dumping. Move the init to a .start callback
for clarity, it's a more idiomatic netlink dump code structure.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/netlink/genetlink.c | 48 ++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1febc7db1110..286a3b3f928e 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1107,35 +1107,31 @@ struct ctrl_dump_policy_ctx {
 	u16 fam_id;
 };
 
-static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
+static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
+	struct nlattr *tb[CTRL_ATTR_MAX + 1];
 	const struct genl_family *rt;
 	int err;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
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
@@ -1145,9 +1141,12 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
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
+	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 
 	while (netlink_policy_dump_loop(ctx->state)) {
 		void *hdr;
@@ -1159,7 +1158,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!hdr)
 			goto nla_put_failure;
 
-		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, rt->id))
+		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, ctx->fam_id))
 			goto nla_put_failure;
 
 		nest = nla_nest_start(skb, CTRL_ATTR_POLICY);
@@ -1199,6 +1198,7 @@ static const struct genl_ops genl_ctrl_ops[] = {
 	},
 	{
 		.cmd		= CTRL_CMD_GETPOLICY,
+		.start		= ctrl_dumppolicy_start,
 		.dumpit		= ctrl_dumppolicy,
 		.done		= ctrl_dumppolicy_done,
 	},
-- 
2.26.2

