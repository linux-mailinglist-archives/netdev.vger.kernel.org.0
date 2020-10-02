Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418EA280F90
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbgJBJJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387620AbgJBJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:09:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4130EC0613E3
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:09:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOH4c-00F9QD-Aw; Fri, 02 Oct 2020 11:09:54 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/5] genetlink: properly support per-op policy dumping
Date:   Fri,  2 Oct 2020 11:09:44 +0200
Message-Id: <20201002110205.17810866ae42.I19674e30193a115c120d976d1e3ebc9ec7c8235e@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002090944.195891-1-johannes@sipsolutions.net>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add support for per-op policy dumping. The data is pretty much
as before, except that now the assumption that the policy with
index 0 is "the" policy no longer holds - you now need to look
at the new CTRL_ATTR_OP_POLICY attribute which is a nested attr
containing the cmd -> policy index mapping.

When a single op is requested, the CTRL_ATTR_OP_POLICY will be
added but the policy for this op is still guaranteed to be at
index 0, so that's just for convenience.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/genetlink.h |   1 +
 net/netlink/genetlink.c        | 107 ++++++++++++++++++++++++++++-----
 2 files changed, 93 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index 7dbe2d5d7d46..583dcc737250 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -65,6 +65,7 @@ enum {
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
 	CTRL_ATTR_OP,
+	CTRL_ATTR_OP_POLICY,
 	__CTRL_ATTR_MAX,
 };
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 0ab9549e30ee..b2a87fbd3875 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1112,7 +1112,12 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 
 struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
+	const struct genl_family *rt;
+	unsigned int opidx;
+	u32 op;
 	u16 fam_id;
+	u8 policies:1,
+	   single_op:1;
 };
 
 static const struct nla_policy ctrl_policy_policy[] = {
@@ -1129,7 +1134,7 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
 	struct genl_ops op;
-	int err;
+	int err, i;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
@@ -1150,22 +1155,40 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	if (!rt)
 		return -ENOENT;
 
+	ctx->rt = rt;
+
 	if (tb[CTRL_ATTR_OP]) {
-		err = genl_get_cmd(nla_get_u32(tb[CTRL_ATTR_OP]), rt, &op);
+		ctx->single_op = true;
+		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
+
+		err = genl_get_cmd(ctx->op, rt, &op);
 		if (err) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
 			return err;
 		}
-	} else {
-		op.policy = rt->policy;
-		op.maxattr = rt->maxattr;
+
+		if (!op.policy)
+			return -ENODATA;
+
+		return netlink_policy_dump_add_policy(&ctx->state, op.policy,
+						      op.maxattr);
 	}
 
-	if (!op.policy)
-		return -ENODATA;
+	for (i = 0; i < genl_get_cmd_cnt(rt); i++) {
+		genl_get_cmd_by_index(i, rt, &op);
+
+		if (op.policy) {
+			err = netlink_policy_dump_add_policy(&ctx->state,
+							     op.policy,
+							     op.maxattr);
+			if (err)
+				return err;
+		}
+	}
 
-	return netlink_policy_dump_add_policy(&ctx->state, op.policy,
-					      op.maxattr);
+	if (!ctx->state)
+		return -ENODATA;
+	return 0;
 }
 
 static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
@@ -1189,11 +1212,65 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
+	void *hdr;
+
+	if (!ctx->policies) {
+		if (ctx->single_op) {
+			struct nlattr *nest;
+
+			hdr = ctrl_dumppolicy_prep(skb, cb);
+			if (!hdr)
+				goto nla_put_failure;
+
+			nest = nla_nest_start(skb, CTRL_ATTR_OP_POLICY);
+			if (!nest)
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb, ctx->op, 0))
+				goto nla_put_failure;
+
+			nla_nest_end(skb, nest);
+			genlmsg_end(skb, hdr);
+
+			/* skip loop below */
+			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
+		}
+
+		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
+			struct genl_ops op;
+			struct nlattr *nest;
+			int idx;
+
+			hdr = ctrl_dumppolicy_prep(skb, cb);
+			if (!hdr)
+				goto nla_put_failure;
+
+			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
+
+			nest = nla_nest_start(skb, CTRL_ATTR_OP_POLICY);
+			if (!nest)
+				goto nla_put_failure;
+
+			idx = netlink_policy_dump_get_policy_idx(ctx->state,
+								 op.policy,
+								 op.maxattr);
+			if (nla_put_u32(skb, op.cmd, idx))
+				goto nla_put_failure;
+
+			ctx->opidx++;
+
+			nla_nest_end(skb, nest);
+			genlmsg_end(skb, hdr);
+		}
+
+		/* completed with the per-op policy index list */
+		ctx->policies = true;
+	}
 
 	while (netlink_policy_dump_loop(ctx->state)) {
-		void *hdr = ctrl_dumppolicy_prep(skb, cb);
 		struct nlattr *nest;
 
+		hdr = ctrl_dumppolicy_prep(skb, cb);
 		if (!hdr)
 			goto nla_put_failure;
 
@@ -1201,20 +1278,20 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!nest)
 			goto nla_put_failure;
 
+
 		if (netlink_policy_dump_write(skb, ctx->state))
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
 
 		genlmsg_end(skb, hdr);
-		continue;
-
-nla_put_failure:
-		genlmsg_cancel(skb, hdr);
-		break;
 	}
 
 	return skb->len;
+
+nla_put_failure:
+	genlmsg_cancel(skb, hdr);
+	return skb->len;
 }
 
 static int ctrl_dumppolicy_done(struct netlink_callback *cb)
-- 
2.26.2

