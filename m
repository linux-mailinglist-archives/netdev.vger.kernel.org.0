Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8442727F66D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbgJAAFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbgJAAF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:29 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 372BF2184D;
        Thu,  1 Oct 2020 00:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510728;
        bh=UK4+gd5MZz9zCWkRgQ9UeM638zg3cKD+jcLbuulNtUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MXX2eJhkpNKkT7Odd34JNwxLzMZiCE/Et5StOcYvymF5BZYoSiTLFxhcwa4EcMIOK
         3uN0QB6AlPeLsvR8fc6XNDUiuF7HDhqjIcl/vUXKFHRwh70ZlE7JhBRBUthT/jr6QR
         joYg2TT1vbjZA/8KqpNINOtMRtgNDKFzpZvCGDpM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 3/9] genetlink: add small version of ops
Date:   Wed, 30 Sep 2020 17:05:12 -0700
Message-Id: <20201001000518.685243-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h |  25 +++++++++
 net/netlink/genetlink.c | 119 ++++++++++++++++++++++++++++++----------
 2 files changed, 116 insertions(+), 28 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 0033c76ff094..d781f2a240b5 100644
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
@@ -125,6 +129,27 @@ genl_dumpit_info(struct netlink_callback *cb)
 	return cb->data;
 }
 
+/**
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
+ */
+struct genl_small_ops {
+	int	(*doit)(struct sk_buff *skb, struct genl_info *info);
+	int	(*dumpit)(struct sk_buff *skb, struct netlink_callback *cb);
+	u8	cmd;
+	u8	internal_flags;
+	u8	flags;
+	u8	validate;
+};
+
 /**
  * struct genl_ops - generic netlink operations
  * @cmd: command identifier
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 3a718e327515..38d8f353dba1 100644
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
+	memcpy(op, &family->ops[i], sizeof(*op));
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
+static void genl_op_from_light(const struct genl_family *family,
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
+static int genl_get_cmd_light(u8 cmd, const struct genl_family *family,
+			      struct genl_ops *op)
+{
+	int i;
+
+	for (i = 0; i < family->n_small_ops; i++)
+		if (family->small_ops[i].cmd == cmd) {
+			genl_op_from_light(family, i, op);
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
+	return genl_get_cmd_light(cmd, family, op);
+}
+
+static void genl_get_cmd_by_index(unsigned int i,
+				  const struct genl_family *family,
+				  struct genl_ops *op)
+{
+	if (i < family->n_ops)
+		genl_op_from_full(family, i, op);
+	else if (i < family->n_ops + family->n_small_ops)
+		genl_op_from_light(family, i - family->n_ops, op);
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

