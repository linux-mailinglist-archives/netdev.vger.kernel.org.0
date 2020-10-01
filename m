Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F285127F66E
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgJAAFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731506AbgJAAFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:30 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 411E021D41;
        Thu,  1 Oct 2020 00:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510729;
        bh=RlNjW5LFNPWJLJP/IMtSnmZ8hebU5OkshtqmFii1Z+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFE/nkArhS9IVdzoqM8SSPaqNjE2AfsM/Y4gAsfZpuGbVpCMq8jCoLe0QrcnWbezS
         V3vLjQWdZBGAMy+csX4dumL9K87YNi0Aju/SZ1N7In0V8kQA6J72zB3SnJfdchXw1k
         EOPsKF1Q5Ge1RGlnax8jcrKabtVsxcnc7Qm0HhLI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 5/9] genetlink: add a structure for dump state
Date:   Wed, 30 Sep 2020 17:05:14 -0700
Message-Id: <20201001000518.685243-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 38d8f353dba1..a8001044d8cd 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1102,13 +1102,18 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 	return 0;
 }
 
+struct ctrl_dump_policy_ctx {
+	unsigned long state;
+	unsigned int fam_id;
+};
+
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct ctrl_dump_policy_ctx *ctx = (void *)cb->args;
 	const struct genl_family *rt;
-	unsigned int fam_id = cb->args[0];
 	int err;
 
-	if (!fam_id) {
+	if (!ctx->fam_id) {
 		struct nlattr *tb[CTRL_ATTR_MAX + 1];
 
 		err = genlmsg_parse(cb->nlh, &genl_ctrl, tb,
@@ -1121,28 +1126,28 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
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
 
-	while (netlink_policy_dump_loop(&cb->args[1])) {
+	while (netlink_policy_dump_loop(&ctx->state)) {
 		void *hdr;
 		struct nlattr *nest;
 
@@ -1159,7 +1164,7 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!nest)
 			goto nla_put_failure;
 
-		if (netlink_policy_dump_write(skb, cb->args[1]))
+		if (netlink_policy_dump_write(skb, ctx->state))
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
@@ -1172,7 +1177,6 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		break;
 	}
 
-	cb->args[0] = fam_id;
 	return skb->len;
 }
 
-- 
2.26.2

