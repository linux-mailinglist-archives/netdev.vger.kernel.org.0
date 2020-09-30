Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1315F27F2B4
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgI3TqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgI3TqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 15:46:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBBD1206F4;
        Wed, 30 Sep 2020 19:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601495174;
        bh=5a/DMw5mvzbN8DU1HszVTFJ3KIW5F80648jhpe5sfmk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i9TpMpJmMtlZTkQq9oky8JIcvEgeQtWW2/XCLIb35Sfbz/oq2BjDQgZUQVC93MGmW
         N2rqwr+Cozj//I37cd58toPo+IiOJKuTdMpU7IExBno1+OgFsGLCaiuaW4Em4UlBs3
         M3JYvyGB/ZhPFHvJm31i0O4H0kw99kNpXZ2RnQbM=
Date:   Wed, 30 Sep 2020 12:46:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930124612.32b53118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
        <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
        <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
        <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
        <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 21:15:33 +0200 Johannes Berg wrote:
> On Wed, 2020-09-30 at 12:14 -0700, Jakub Kicinski wrote:
> 
> > > Hm. I guess you could even have both?
> > > 
> > > 	struct genl_ops *ops;
> > > 	struct genl_ops_ext *extops;
> > > 
> > > and then search both arrays, no need for memcpy/pointer assignment?  
> > 
> > Yup, both should work quite nicely, too. No reason to force one or the
> > other.  
> 
> Indeed.
> 
> > Extra n_ops_ext should be fine, I think I can make n_ops a u8 in 
> > the first place, since commands themselves are u8s. And 0 is commonly
> > unused.  
> 
> True. I'm not really worried about the extra pointer in the *family*
> though, there aren't really all that many families :)

This builds (I think) - around 100 extra LoC:

 include/net/genetlink.h |  25 +++++++++
 net/netlink/genetlink.c | 138 +++++++++++++++++++++++++++++++++++++++---------
 net/wireless/nl80211.c  |   5 ++
 3 files changed, 142 insertions(+), 26 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index ee1d0ab3a89f..28e162d89426 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -41,6 +41,8 @@ struct genl_info;
  *	(private)
  * @ops: the operations supported by this family
  * @n_ops: number of operations supported by this family
+ * @light_ops: the small-struct operations supported by this family
+ * @n_light_ops: number of small-struct operations supported by this family
  */
 struct genl_family {
 	int			id;		/* private */
@@ -52,6 +54,7 @@ struct genl_family {
 	u8			netnsok:1;
 	u8			parallel_ops:1;
 	u8			n_ops;
+	u8			n_light_ops;
 	u8			n_mcgrps;
 	const struct nla_policy *policy;
 	int			(*pre_doit)(const struct genl_ops *ops,
@@ -61,6 +64,7 @@ struct genl_family {
 					     struct sk_buff *skb,
 					     struct genl_info *info);
 	const struct genl_ops *	ops;
+	const struct genl_light_ops *light_ops;
 	const struct genl_multicast_group *mcgrps;
 	struct module		*module;
 };
@@ -125,6 +129,27 @@ genl_dumpit_info(struct netlink_callback *cb)
 	return cb->data;
 }
 
+/**
+ * struct genl_light_ops - generic netlink operations (small version)
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
+struct genl_light_ops {
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
index b6a7c560772f..2a2330e149bc 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -107,16 +107,89 @@ static const struct genl_family *genl_family_find_byname(char *name)
 	return NULL;
 }
 
-static const struct genl_ops *genl_get_cmd(u8 cmd,
-					   const struct genl_family *family)
+static int genl_get_cmd_cnt(const struct genl_family *family)
+{
+	return family->n_ops + family->n_light_ops;
+}
+
+static void genl_op_from_full(const struct genl_family *family,
+			      unsigned int i, struct genl_ops *op)
+{
+	memcpy(op, &family->ops[i], sizeof(*op));
+
+	if (!op->maxattr)
+		op->maxattr = family->maxattr;
+	if (!op->policy)
+		op->policy = family->policy;
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
+	op->doit	= family->light_ops[i].doit;
+	op->dumpit	= family->light_ops[i].dumpit;
+	op->cmd		= family->light_ops[i].cmd;
+	op->internal_flags = family->light_ops[i].internal_flags;
+	op->flags	= family->light_ops[i].flags;
+	op->validate	= family->light_ops[i].validate;
+
+	op->maxattr = family->maxattr;
+	op->policy = family->policy;
+}
+
+static int genl_get_cmd_light(u8 cmd, const struct genl_family *family,
+			      struct genl_ops *op)
+{
+	int i;
+
+	for (i = 0; i < family->n_light_ops; i++)
+		if (family->light_ops[i].cmd == cmd) {
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
+static int genl_get_cmd_by_index(unsigned int i,
+				 const struct genl_family *family,
+				 struct genl_ops *op)
+{
+	if (i < family->n_ops) {
+		genl_op_from_full(family, i, op);
+		return 0;
+	}
+	i -= family->n_ops;
+
+	if (i < family->n_light_ops) {
+		genl_op_from_light(family, i, op);
+		return 0;
+	}
+
+	return -EINVAL;
 }
 
 static int genl_allocate_reserve_groups(int n_groups, int *first_id)
@@ -286,22 +359,32 @@ static void genl_unregister_mc_groups(const struct genl_family *family)
 
 static int genl_validate_ops(const struct genl_family *family)
 {
-	const struct genl_ops *ops = family->ops;
-	unsigned int n_ops = family->n_ops;
+	unsigned int n_ops;
 	int i, j;
 
-	if (WARN_ON(n_ops && !ops))
+	if (WARN_ON(family->n_ops && !family->ops) ||
+	    WARN_ON(family->n_light_ops && !family->light_ops))
 		return -EINVAL;
 
+	n_ops = genl_get_cmd_cnt(family);
 	if (!n_ops)
 		return 0;
 
 	for (i = 0; i < n_ops; i++) {
-		if (ops[i].dumpit == NULL && ops[i].doit == NULL)
+		struct genl_ops op;
+
+		if (genl_get_cmd_by_index(i, family, &op))
 			return -EINVAL;
-		for (j = i + 1; j < n_ops; j++)
-			if (ops[i].cmd == ops[j].cmd)
+		if (op.dumpit == NULL && op.doit == NULL)
+			return -EINVAL;
+		for (j = i + 1; j < n_ops; j++) {
+			struct genl_ops op2;
+
+			if (genl_get_cmd_by_index(j, family, &op2))
 				return -EINVAL;
+			if (op.cmd == op2.cmd)
+				return -EINVAL;
+		}
 	}
 
 	return 0;
@@ -687,9 +770,9 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 			       struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
-	const struct genl_ops *ops;
 	struct net *net = sock_net(skb->sk);
 	struct genlmsghdr *hdr = nlmsg_data(nlh);
+	struct genl_ops op;
 	int hdrlen;
 
 	/* this family doesn't exist in this netns */
@@ -700,24 +783,23 @@ static int genl_family_rcv_msg(const struct genl_family *family,
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
@@ -770,7 +852,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 	    nla_put_u32(skb, CTRL_ATTR_MAXATTR, family->maxattr))
 		goto nla_put_failure;
 
-	if (family->n_ops) {
+	if (genl_get_cmd_cnt(family)) {
 		struct nlattr *nla_ops;
 		int i;
 
@@ -778,23 +860,27 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 		if (nla_ops == NULL)
 			goto nla_put_failure;
 
-		for (i = 0; i < family->n_ops; i++) {
+		for (i = 0; i < genl_get_cmd_cnt(family); i++) {
 			struct nlattr *nest;
-			const struct genl_ops *ops = &family->ops[i];
-			u32 op_flags = ops->flags;
+			struct genl_ops op;
+			u32 op_flags;
+
+			if (genl_get_cmd_by_index(i, family, &op))
+				goto nla_put_failure;
 
-			if (ops->dumpit)
+			op_flags = op.flags;
+			if (op.dumpit)
 				op_flags |= GENL_CMD_CAP_DUMP;
-			if (ops->doit)
+			if (op.doit)
 				op_flags |= GENL_CMD_CAP_DO;
-			if (family->policy || ops->policy)
+			if (op.policy)
 				op_flags |= GENL_CMD_CAP_HASPOL;
 
 			nest = nla_nest_start_noflag(skb, i + 1);
 			if (nest == NULL)
 				goto nla_put_failure;
 
-			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, ops->cmd) ||
+			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, op.cmd) ||
 			    nla_put_u32(skb, CTRL_ATTR_OP_FLAGS, op_flags))
 				goto nla_put_failure;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1a212db7a300..2bff951dbb0a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14603,6 +14603,9 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+};
+
+static const struct genl_light_ops nl80211_light_ops[] = {
 	{
 		.cmd = NL80211_CMD_SET_WIPHY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -15464,6 +15467,8 @@ static struct genl_family nl80211_fam __ro_after_init = {
 	.module = THIS_MODULE,
 	.ops = nl80211_ops,
 	.n_ops = ARRAY_SIZE(nl80211_ops),
+	.light_ops = nl80211_light_ops,
+	.n_light_ops = ARRAY_SIZE(nl80211_light_ops),
 	.mcgrps = nl80211_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(nl80211_mcgrps),
 	.parallel_ops = true,
