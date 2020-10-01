Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395C728069A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732896AbgJASbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732672AbgJASbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 14:31:37 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E75621707;
        Thu,  1 Oct 2020 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601577096;
        bh=Tr+VEgFtiXn2kZMEGjRjHufg+br8k5RsTMBp8Spt7OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNFF61A2fy9u977W2MOMRZjVPX2OCJmwYRBD1h+t3Dk0o+fWpJdcgzEgwRUyVlRFW
         XMVPI4QivqTeX/+/KfuXmK5VRasojJ/L5dIcKxS0M4CAOawjZRCcWJVPIngRLwwDZ+
         WRg2Gp8Nih2n5w6Gb5P1fas1SAmfUJ73fg+FE9bw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/9] genetlink: add small version of ops
Date:   Thu,  1 Oct 2020 11:30:09 -0700
Message-Id: <20201001183016.1259870-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001183016.1259870-1-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to add maxattr and policy back to genl_ops, to enable
dumping per command policy to user space. This, however, would
cause bloat for all the families with global policies. Introduce
smaller version of ops (half the size of genl_ops). Translate
these smaller ops into a full blown struct before use in the
core.

v1:
 - use struct assignment
 - put a full copy of the op in struct genl_dumpit_info
 - s/light/small/

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/thermal/thermal_netlink.c |   2 +-
 include/net/genetlink.h           |  53 +++++++++----
 net/netlink/genetlink.c           | 127 ++++++++++++++++++++++--------
 3 files changed, 135 insertions(+), 47 deletions(-)

diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index af7b2383e8f6..e9999d5dfdd5 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -545,7 +545,7 @@ static int thermal_genl_cmd_dumpit(struct sk_buff *skb,
 {
 	struct param p = { .msg = skb };
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	int cmd = info->ops->cmd;
+	int cmd = info->op.cmd;
 	int ret;
 	void *hdr;
 
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 5cd9ab0c6bd9..8ea1fc1ed1c7 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -41,6 +41,8 @@ struct genl_info;
  *	(private)
  * @ops: the operations supported by this family
  * @n_ops: number of operations supported by this family
+ * @small_ops: the small-struct operations supported by this family
+ * @n_small_ops: number of small-struct operations supported by this family
  */
 struct genl_family {
 	int			id;		/* private */
@@ -52,6 +54,7 @@ struct genl_family {
 	u8			netnsok:1;
 	u8			parallel_ops:1;
 	u8			n_ops;
+	u8			n_small_ops;
 	u8			n_mcgrps;
 	const struct nla_policy *policy;
 	int			(*pre_doit)(const struct genl_ops *ops,
@@ -61,6 +64,7 @@ struct genl_family {
 					     struct sk_buff *skb,
 					     struct genl_info *info);
 	const struct genl_ops *	ops;
+	const struct genl_small_ops *small_ops;
 	const struct genl_multicast_group *mcgrps;
 	struct module		*module;
 };
@@ -108,23 +112,26 @@ enum genl_validate_flags {
 };
 
 /**
- * struct genl_info - info that is available during dumpit op call
- * @family: generic netlink family - for internal genl code usage
- * @ops: generic netlink ops - for internal genl code usage
- * @attrs: netlink attributes
+ * struct genl_small_ops - generic netlink operations (small version)
+ * @cmd: command identifier
+ * @internal_flags: flags used by the family
+ * @flags: flags
+ * @validate: validation flags from enum genl_validate_flags
+ * @doit: standard command callback
+ * @dumpit: callback for dumpers
+ *
+ * This is a cut-down version of struct genl_ops for users who don't need
+ * most of the ancillary infra and want to save space.
  */
-struct genl_dumpit_info {
-	const struct genl_family *family;
-	const struct genl_ops *ops;
-	struct nlattr **attrs;
+struct genl_small_ops {
+	int	(*doit)(struct sk_buff *skb, struct genl_info *info);
+	int	(*dumpit)(struct sk_buff *skb, struct netlink_callback *cb);
+	u8	cmd;
+	u8	internal_flags;
+	u8	flags;
+	u8	validate;
 };
 
-static inline const struct genl_dumpit_info *
-genl_dumpit_info(struct netlink_callback *cb)
-{
-	return cb->data;
-}
-
 /**
  * struct genl_ops - generic netlink operations
  * @cmd: command identifier
@@ -148,6 +155,24 @@ struct genl_ops {
 	u8			validate;
 };
 
+/**
+ * struct genl_info - info that is available during dumpit op call
+ * @family: generic netlink family - for internal genl code usage
+ * @ops: generic netlink ops - for internal genl code usage
+ * @attrs: netlink attributes
+ */
+struct genl_dumpit_info {
+	const struct genl_family *family;
+	struct genl_ops op;
+	struct nlattr **attrs;
+};
+
+static inline const struct genl_dumpit_info *
+genl_dumpit_info(struct netlink_callback *cb)
+{
+	return cb->data;
+}
+
 int genl_register_family(struct genl_family *family);
 int genl_unregister_family(const struct genl_family *family);
 void genl_notify(const struct genl_family *family, struct sk_buff *skb,
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 3a718e327515..094ebfff8889 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -107,16 +107,75 @@ static const struct genl_family *genl_family_find_byname(char *name)
 	return NULL;
 }
 
-static const struct genl_ops *genl_get_cmd(u8 cmd,
-					   const struct genl_family *family)
+static int genl_get_cmd_cnt(const struct genl_family *family)
+{
+	return family->n_ops + family->n_small_ops;
+}
+
+static void genl_op_from_full(const struct genl_family *family,
+			      unsigned int i, struct genl_ops *op)
+{
+	*op = family->ops[i];
+}
+
+static int genl_get_cmd_full(u8 cmd, const struct genl_family *family,
+			     struct genl_ops *op)
 {
 	int i;
 
 	for (i = 0; i < family->n_ops; i++)
-		if (family->ops[i].cmd == cmd)
-			return &family->ops[i];
+		if (family->ops[i].cmd == cmd) {
+			genl_op_from_full(family, i, op);
+			return 0;
+		}
 
-	return NULL;
+	return -ENOENT;
+}
+
+static void genl_op_from_small(const struct genl_family *family,
+			       unsigned int i, struct genl_ops *op)
+{
+	memset(op, 0, sizeof(*op));
+	op->doit	= family->small_ops[i].doit;
+	op->dumpit	= family->small_ops[i].dumpit;
+	op->cmd		= family->small_ops[i].cmd;
+	op->internal_flags = family->small_ops[i].internal_flags;
+	op->flags	= family->small_ops[i].flags;
+	op->validate	= family->small_ops[i].validate;
+}
+
+static int genl_get_cmd_small(u8 cmd, const struct genl_family *family,
+			      struct genl_ops *op)
+{
+	int i;
+
+	for (i = 0; i < family->n_small_ops; i++)
+		if (family->small_ops[i].cmd == cmd) {
+			genl_op_from_small(family, i, op);
+			return 0;
+		}
+
+	return -ENOENT;
+}
+
+static int genl_get_cmd(u8 cmd, const struct genl_family *family,
+			struct genl_ops *op)
+{
+	if (!genl_get_cmd_full(cmd, family, op))
+		return 0;
+	return genl_get_cmd_small(cmd, family, op);
+}
+
+static void genl_get_cmd_by_index(unsigned int i,
+				  const struct genl_family *family,
+				  struct genl_ops *op)
+{
+	if (i < family->n_ops)
+		genl_op_from_full(family, i, op);
+	else if (i < family->n_ops + family->n_small_ops)
+		genl_op_from_small(family, i - family->n_ops, op);
+	else
+		WARN_ON_ONCE(1);
 }
 
 static int genl_allocate_reserve_groups(int n_groups, int *first_id)
@@ -286,22 +345,25 @@ static void genl_unregister_mc_groups(const struct genl_family *family)
 
 static int genl_validate_ops(const struct genl_family *family)
 {
-	const struct genl_ops *ops = family->ops;
-	unsigned int n_ops = family->n_ops;
 	int i, j;
 
-	if (WARN_ON(n_ops && !ops))
+	if (WARN_ON(family->n_ops && !family->ops) ||
+	    WARN_ON(family->n_small_ops && !family->small_ops))
 		return -EINVAL;
 
-	if (!n_ops)
-		return 0;
+	for (i = 0; i < genl_get_cmd_cnt(family); i++) {
+		struct genl_ops op;
 
-	for (i = 0; i < n_ops; i++) {
-		if (ops[i].dumpit == NULL && ops[i].doit == NULL)
+		genl_get_cmd_by_index(i, family, &op);
+		if (op.dumpit == NULL && op.doit == NULL)
 			return -EINVAL;
-		for (j = i + 1; j < n_ops; j++)
-			if (ops[i].cmd == ops[j].cmd)
+		for (j = i + 1; j < genl_get_cmd_cnt(family); j++) {
+			struct genl_ops op2;
+
+			genl_get_cmd_by_index(j, family, &op2);
+			if (op.cmd == op2.cmd)
 				return -EINVAL;
+		}
 	}
 
 	return 0;
@@ -524,7 +586,7 @@ static int genl_start(struct netlink_callback *cb)
 		return -ENOMEM;
 	}
 	info->family = ctx->family;
-	info->ops = ops;
+	info->op = *ops;
 	info->attrs = attrs;
 
 	cb->data = info;
@@ -546,7 +608,7 @@ static int genl_start(struct netlink_callback *cb)
 
 static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	const struct genl_ops *ops = genl_dumpit_info(cb)->ops;
+	const struct genl_ops *ops = &genl_dumpit_info(cb)->op;
 	int rc;
 
 	genl_lock();
@@ -558,7 +620,7 @@ static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 static int genl_lock_done(struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	const struct genl_ops *ops = info->ops;
+	const struct genl_ops *ops = &info->op;
 	int rc = 0;
 
 	if (ops->done) {
@@ -574,7 +636,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 static int genl_parallel_done(struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	const struct genl_ops *ops = info->ops;
+	const struct genl_ops *ops = &info->op;
 	int rc = 0;
 
 	if (ops->done)
@@ -682,9 +744,9 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 			       struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
-	const struct genl_ops *ops;
 	struct net *net = sock_net(skb->sk);
 	struct genlmsghdr *hdr = nlmsg_data(nlh);
+	struct genl_ops op;
 	int hdrlen;
 
 	/* this family doesn't exist in this netns */
@@ -695,24 +757,23 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
 		return -EINVAL;
 
-	ops = genl_get_cmd(hdr->cmd, family);
-	if (ops == NULL)
+	if (genl_get_cmd(hdr->cmd, family, &op))
 		return -EOPNOTSUPP;
 
-	if ((ops->flags & GENL_ADMIN_PERM) &&
+	if ((op.flags & GENL_ADMIN_PERM) &&
 	    !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	if ((ops->flags & GENL_UNS_ADMIN_PERM) &&
+	if ((op.flags & GENL_UNS_ADMIN_PERM) &&
 	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if ((nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP)
 		return genl_family_rcv_msg_dumpit(family, skb, nlh, extack,
-						  ops, hdrlen, net);
+						  &op, hdrlen, net);
 	else
 		return genl_family_rcv_msg_doit(family, skb, nlh, extack,
-						ops, hdrlen, net);
+						&op, hdrlen, net);
 }
 
 static int genl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -765,7 +826,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 	    nla_put_u32(skb, CTRL_ATTR_MAXATTR, family->maxattr))
 		goto nla_put_failure;
 
-	if (family->n_ops) {
+	if (genl_get_cmd_cnt(family)) {
 		struct nlattr *nla_ops;
 		int i;
 
@@ -773,14 +834,16 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 		if (nla_ops == NULL)
 			goto nla_put_failure;
 
-		for (i = 0; i < family->n_ops; i++) {
+		for (i = 0; i < genl_get_cmd_cnt(family); i++) {
 			struct nlattr *nest;
-			const struct genl_ops *ops = &family->ops[i];
-			u32 op_flags = ops->flags;
+			struct genl_ops op;
+			u32 op_flags;
 
-			if (ops->dumpit)
+			genl_get_cmd_by_index(i, family, &op);
+			op_flags = op.flags;
+			if (op.dumpit)
 				op_flags |= GENL_CMD_CAP_DUMP;
-			if (ops->doit)
+			if (op.doit)
 				op_flags |= GENL_CMD_CAP_DO;
 			if (family->policy)
 				op_flags |= GENL_CMD_CAP_HASPOL;
@@ -789,7 +852,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 			if (nest == NULL)
 				goto nla_put_failure;
 
-			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, ops->cmd) ||
+			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, op.cmd) ||
 			    nla_put_u32(skb, CTRL_ATTR_OP_FLAGS, op_flags))
 				goto nla_put_failure;
 
-- 
2.26.2

