Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4270228229A
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgJCIo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgJCIoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:44:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C86C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 01:44:55 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOd9x-00FmcE-BA; Sat, 03 Oct 2020 10:44:53 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 5/5] genetlink: allow dumping command-specific policy
Date:   Sat,  3 Oct 2020 10:44:46 +0200
Message-Id: <20201003084446.59042-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201003084446.59042-1-johannes@sipsolutions.net>
References: <20201003084446.59042-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

Right now CTRL_CMD_GETPOLICY can only dump the family-wide
policy. Support dumping policy of a specific op.

v3:
 - rebase after per-op policy export and handle that
v2:
 - make cmd U32, just in case.
v1:
 - don't echo op in the output in a naive way, this should
   make it cleaner to extend the output format for dumping
   policies for all the commands at once in the future.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20201001225933.1373426-11-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/genetlink.h |  1 +
 net/netlink/genetlink.c        | 41 +++++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index bc9c98e84828..d83f214b4134 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -65,6 +65,7 @@ enum {
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
 	CTRL_ATTR_OP_POLICY,
+	CTRL_ATTR_OP,
 	__CTRL_ATTR_MAX,
 };
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index eb916c44884f..c992424e4d63 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -123,7 +123,7 @@ static void genl_op_from_full(const struct genl_family *family,
 		op->policy = family->policy;
 }
 
-static int genl_get_cmd_full(u8 cmd, const struct genl_family *family,
+static int genl_get_cmd_full(u32 cmd, const struct genl_family *family,
 			     struct genl_ops *op)
 {
 	int i;
@@ -152,7 +152,7 @@ static void genl_op_from_small(const struct genl_family *family,
 	op->policy = family->policy;
 }
 
-static int genl_get_cmd_small(u8 cmd, const struct genl_family *family,
+static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
 			      struct genl_ops *op)
 {
 	int i;
@@ -166,7 +166,7 @@ static int genl_get_cmd_small(u8 cmd, const struct genl_family *family,
 	return -ENOENT;
 }
 
-static int genl_get_cmd(u8 cmd, const struct genl_family *family,
+static int genl_get_cmd(u32 cmd, const struct genl_family *family,
 			struct genl_ops *op)
 {
 	if (!genl_get_cmd_full(cmd, family, op))
@@ -1114,14 +1114,17 @@ struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
 	const struct genl_family *rt;
 	unsigned int opidx;
+	u32 op;
 	u16 fam_id;
-	u8 policies:1;
+	u8 policies:1,
+	   single_op:1;
 };
 
 static const struct nla_policy ctrl_policy_policy[] = {
 	[CTRL_ATTR_FAMILY_ID]	= { .type = NLA_U16 },
 	[CTRL_ATTR_FAMILY_NAME]	= { .type = NLA_NUL_STRING,
 				    .len = GENL_NAMSIZ - 1 },
+	[CTRL_ATTR_OP]		= { .type = NLA_U32 },
 };
 
 static int ctrl_dumppolicy_start(struct netlink_callback *cb)
@@ -1154,6 +1157,23 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 
 	ctx->rt = rt;
 
+	if (tb[CTRL_ATTR_OP]) {
+		ctx->single_op = true;
+		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
+
+		err = genl_get_cmd(ctx->op, rt, &op);
+		if (err) {
+			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
+			return err;
+		}
+
+		if (!op.policy)
+			return -ENODATA;
+
+		return netlink_policy_dump_add_policy(&ctx->state, op.policy,
+						      op.maxattr);
+	}
+
 	for (i = 0; i < genl_get_cmd_cnt(rt); i++) {
 		genl_get_cmd_by_index(i, rt, &op);
 
@@ -1248,7 +1268,18 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
 			struct genl_ops op;
 
-			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
+			if (ctx->single_op) {
+				int err;
+
+				err = genl_get_cmd(ctx->op, ctx->rt, &op);
+				if (WARN_ON(err))
+					return skb->len;
+
+				/* break out of the loop after this one */
+				ctx->opidx = genl_get_cmd_cnt(ctx->rt);
+			} else {
+				genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
+			}
 
 			if (ctrl_dumppolicy_put_op(skb, cb, &op))
 				return skb->len;
-- 
2.26.2

