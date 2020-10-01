Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535722806A1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732941AbgJASbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732792AbgJASbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 14:31:42 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F239A2158C;
        Thu,  1 Oct 2020 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601577101;
        bh=OjTEj14ipx73GdZND0RbqH8Bvh34palFQDkxYyAmXsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3uTHxFrMXQUzFD4uMLIuLCGMWWFmC/TDrFqsEZMFBFWjgJK3nwWa20Y8lN58rIUS
         C2y+PPeJl9LU/pjE0ZPvbhgn3zCFbsttGcLuUPca4tHNeeM0RTc4lcD4B/aKLkCjzg
         6IHKIkpCEwcJ+NUaxASMDJ4xL7N/g8NbFdAyET8Q=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 9/9] genetlink: allow dumping command-specific policy
Date:   Thu,  1 Oct 2020 11:30:16 -0700
Message-Id: <20201001183016.1259870-10-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001183016.1259870-1-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now CTRL_CMD_GETPOLICY can only dump the family-wide
policy. Support dumping policy of a specific op.

v1:
 - don't echo op in the output in a naive way, this should
   make it cleaner to extend the output format for dumping
   policies for all the commands at once in the future.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/genetlink.h |  1 +
 net/netlink/genetlink.c        | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

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
index 81f0b960e9f8..bc5a6fd60abc 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1119,6 +1119,7 @@ static const struct nla_policy ctrl_policy_policy[] = {
 	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
 	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = GENL_NAMSIZ - 1 },
+	[CTRL_ATTR_OP]		= { .type = NLA_U8 },
 };
 
 static int ctrl_dumppolicy_start(struct netlink_callback *cb)
@@ -1127,6 +1128,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
+	struct genl_ops op;
+	int err;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
@@ -1147,10 +1150,21 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	if (!rt)
 		return -ENOENT;
 
-	if (!rt->policy)
+	if (tb[CTRL_ATTR_OP]) {
+		err = genl_get_cmd(nla_get_u8(tb[CTRL_ATTR_OP]), rt, &op);
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
-- 
2.26.2

