Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D95F27F66F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbgJAAFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731700AbgJAAFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:32 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FF0820780;
        Thu,  1 Oct 2020 00:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510731;
        bh=dS824bL9uI2/9mNXDZfm4HlBzu9jegnPC85mW3lF/5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMXfX6j7+xrF4vuOavQAYCing+o+gEMIQLMX3n40lPjYtKmMyyIdbaRNBGJRf0ag2
         0NrAN+4yscGYrbxPEjc9RgvvTxFhQVeXnmbGBNmBi+QRCdtWTFkhg7BPn6nCCdbz8E
         6eLo5hDaCRuWprONByp5+oyY1e0cIsuKcspXO8Is=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 9/9] genetlink: allow dumping command-specific policy
Date:   Wed, 30 Sep 2020 17:05:18 -0700
Message-Id: <20201001000518.685243-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now CTRL_CMD_GETPOLICY can only dump the family-wide
policy. Support dumping policy of a specific op.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/genetlink.h |  1 +
 net/netlink/genetlink.c        | 23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index 9c0636ec2286..7dbe2d5d7d46 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -64,6 +64,7 @@ enum {
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
+	CTRL_ATTR_OP,
 	__CTRL_ATTR_MAX,
 };
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index f2833e9165c7..12e9f323af35 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1113,12 +1113,14 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 struct ctrl_dump_policy_ctx {
 	unsigned long state;
 	unsigned int fam_id;
+	u8 cmd;
 };
 
 static const struct nla_policy ctrl_policy_policy[] = {
 	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
 	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = GENL_NAMSIZ - 1 },
+	[CTRL_ATTR_OP]		= { .type = NLA_U8 },
 };
 
 static int ctrl_dumppolicy_start(struct netlink_callback *cb)
@@ -1127,6 +1129,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->args;
 	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
+	struct genl_ops op;
+	int err;
 
 	if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
 		return -EINVAL;
@@ -1145,10 +1149,23 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	if (!rt)
 		return -ENOENT;
 
-	if (!rt->policy)
+	if (tb[CTRL_ATTR_OP]) {
+		ctx->cmd = nla_get_u8(tb[CTRL_ATTR_OP]);
+
+		err = genl_get_cmd(ctx->cmd, rt, &op);
+		if (err) {
+			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
+			return err;
+		}
+	} else {
+		op.policy = rt->policy;
+		op.maxattr = rt->maxattr;
+	}
+
+	if (!op.policy)
 		return -ENODATA;
 
-	return netlink_policy_dump_start(rt->policy, rt->maxattr, &ctx->state);
+	return netlink_policy_dump_start(op.policy, op.maxattr, &ctx->state);
 }
 
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
@@ -1167,6 +1184,8 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 
 		if (nla_put_u16(skb, CTRL_ATTR_FAMILY_ID, ctx->fam_id))
 			goto nla_put_failure;
+		if (ctx->cmd && nla_put_u8(skb, CTRL_ATTR_OP, ctx->cmd))
+			goto nla_put_failure;
 
 		nest = nla_nest_start(skb, CTRL_ATTR_POLICY);
 		if (!nest)
-- 
2.26.2

