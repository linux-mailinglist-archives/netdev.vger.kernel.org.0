Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94A7282299
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgJCIoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgJCIoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:44:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D2DC0613E7
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 01:44:54 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOd9x-00FmcE-15; Sat, 03 Oct 2020 10:44:53 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 4/5] genetlink: properly support per-op policy dumping
Date:   Sat,  3 Oct 2020 10:44:45 +0200
Message-Id: <20201003104138.7f59292a5c88.I19674e30193a115c120d976d1e3ebc9ec7c8235e@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201003084446.59042-1-johannes@sipsolutions.net>
References: <20201003084446.59042-1-johannes@sipsolutions.net>
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
(indexed by op) containing attributes for do and dump policies.

When a single op is requested, the CTRL_ATTR_OP_POLICY will be
added in the same way, since do and dump policies may differ.

v2:
 - conditionally advertise per-command policies only if there
   actually is a policy being used for the do/dump and it's
   present at all

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/genetlink.h |  10 ++++
 net/netlink/genetlink.c        | 102 +++++++++++++++++++++++++++++----
 2 files changed, 102 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index 9c0636ec2286..bc9c98e84828 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -64,6 +64,7 @@ enum {
 	CTRL_ATTR_OPS,
 	CTRL_ATTR_MCAST_GROUPS,
 	CTRL_ATTR_POLICY,
+	CTRL_ATTR_OP_POLICY,
 	__CTRL_ATTR_MAX,
 };
 
@@ -85,6 +86,15 @@ enum {
 	__CTRL_ATTR_MCAST_GRP_MAX,
 };
 
+enum {
+	CTRL_ATTR_POLICY_UNSPEC,
+	CTRL_ATTR_POLICY_DO,
+	CTRL_ATTR_POLICY_DUMP,
+
+	__CTRL_ATTR_POLICY_DUMP_MAX,
+	CTRL_ATTR_POLICY_DUMP_MAX = __CTRL_ATTR_POLICY_DUMP_MAX - 1
+};
+
 #define CTRL_ATTR_MCAST_GRP_MAX (__CTRL_ATTR_MCAST_GRP_MAX - 1)
 
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 5e33c7938470..eb916c44884f 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1112,7 +1112,10 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 
 struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
+	const struct genl_family *rt;
+	unsigned int opidx;
 	u16 fam_id;
+	u8 policies:1;
 };
 
 static const struct nla_policy ctrl_policy_policy[] = {
@@ -1127,6 +1130,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
+	struct genl_ops op;
+	int err, i;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
@@ -1147,11 +1152,23 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	if (!rt)
 		return -ENOENT;
 
-	if (!rt->policy)
-		return -ENODATA;
+	ctx->rt = rt;
+
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
 
-	return netlink_policy_dump_add_policy(&ctx->state, rt->policy,
-					      rt->maxattr);
+	if (!ctx->state)
+		return -ENODATA;
+	return 0;
 }
 
 static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
@@ -1172,12 +1189,78 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
 	return hdr;
 }
 
+static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
+				  struct netlink_callback *cb,
+			          struct genl_ops *op)
+{
+	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
+	struct nlattr *nest_pol, *nest_op;
+	void *hdr;
+	int idx;
+
+	/* skip if we have nothing to show */
+	if (!op->policy)
+		return 0;
+	if (!op->doit &&
+	    (!op->dumpit || op->validate & GENL_DONT_VALIDATE_DUMP))
+		return 0;
+
+	hdr = ctrl_dumppolicy_prep(skb, cb);
+	if (!hdr)
+		return -ENOBUFS;
+
+	nest_pol = nla_nest_start(skb, CTRL_ATTR_OP_POLICY);
+	if (!nest_pol)
+		goto err;
+
+	nest_op = nla_nest_start(skb, op->cmd);
+	if (!nest_op)
+		goto err;
+
+	/* for now both do/dump are always the same */
+	idx = netlink_policy_dump_get_policy_idx(ctx->state,
+						 op->policy,
+						 op->maxattr);
+
+	if (op->doit && nla_put_u32(skb, CTRL_ATTR_POLICY_DO, idx))
+		goto err;
+
+	if (op->dumpit && !(op->validate & GENL_DONT_VALIDATE_DUMP) &&
+	    nla_put_u32(skb, CTRL_ATTR_POLICY_DUMP, idx))
+		goto err;
+
+	nla_nest_end(skb, nest_op);
+	nla_nest_end(skb, nest_pol);
+	genlmsg_end(skb, hdr);
+
+	return 0;
+err:
+	genlmsg_cancel(skb, hdr);
+	return -ENOBUFS;
+}
+
 static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
+	void *hdr;
+
+	if (!ctx->policies) {
+		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
+			struct genl_ops op;
+
+			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
+
+			if (ctrl_dumppolicy_put_op(skb, cb, &op))
+				return skb->len;
+
+			ctx->opidx++;
+		}
+
+		/* completed with the per-op policy index list */
+		ctx->policies = true;
+	}
 
 	while (netlink_policy_dump_loop(ctx->state)) {
-		void *hdr;
 		struct nlattr *nest;
 
 		hdr = ctrl_dumppolicy_prep(skb, cb);
@@ -1194,14 +1277,13 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
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

