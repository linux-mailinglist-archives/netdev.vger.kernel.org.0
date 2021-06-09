Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19973A1F32
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhFIVra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60474 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhFIVr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:27 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DEA0B6422F;
        Wed,  9 Jun 2021 23:44:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/13] netfilter: nfnetlink: add struct nfgenmsg to struct nfnl_info and use it
Date:   Wed,  9 Jun 2021 23:45:11 +0200
Message-Id: <20210609214523.1678-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the nfnl_info structure to add a pointer to the nfnetlink header.
This simplifies the existing codebase since this header is usually
accessed. Update existing clients to use this new field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h  |  1 +
 net/netfilter/nf_conntrack_netlink.c | 23 +++++-------
 net/netfilter/nf_tables_api.c        | 55 ++++++++++------------------
 net/netfilter/nfnetlink.c            |  2 +
 net/netfilter/nfnetlink_log.c        |  5 +--
 net/netfilter/nfnetlink_queue.c      |  9 ++---
 net/netfilter/nft_compat.c           | 17 +++------
 7 files changed, 42 insertions(+), 70 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 515ce53aa20d..241e005f290a 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -11,6 +11,7 @@ struct nfnl_info {
 	struct net		*net;
 	struct sock		*sk;
 	const struct nlmsghdr	*nlh;
+	const struct nfgenmsg	*nfmsg;
 	struct netlink_ext_ack	*extack;
 };
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 220f51f055ab..4e1a9dba7077 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1528,7 +1528,7 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
 				   const struct nfnl_info *info,
 				   const struct nlattr * const cda[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u8 family = info->nfmsg->nfgen_family;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_zone zone;
@@ -1541,12 +1541,12 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
 
 	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
-					    nfmsg->nfgen_family, &zone);
+					    family, &zone);
 	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
-					    nfmsg->nfgen_family, &zone);
+					    family, &zone);
 	else {
-		u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
+		u_int8_t u3 = info->nfmsg->version ? family : AF_UNSPEC;
 
 		return ctnetlink_flush_conntrack(info->net, cda,
 						 NETLINK_CB(skb).portid,
@@ -1586,8 +1586,7 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
 				   const struct nfnl_info *info,
 				   const struct nlattr * const cda[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = info->nfmsg->nfgen_family;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_zone zone;
@@ -2363,10 +2362,9 @@ static int ctnetlink_new_conntrack(struct sk_buff *skb,
 				   const struct nfnl_info *info,
 				   const struct nlattr * const cda[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = info->nfmsg->nfgen_family;
 	struct nf_conntrack_zone zone;
 	struct nf_conn *ct;
 	int err;
@@ -3259,8 +3257,7 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const cda[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = info->nfmsg->nfgen_family;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_zone zone;
@@ -3349,8 +3346,7 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const cda[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = info->nfmsg->nfgen_family;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_zone zone;
@@ -3601,8 +3597,7 @@ static int ctnetlink_new_expect(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const cda[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = info->nfmsg->nfgen_family;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_zone zone;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d63d2d8f769c..b2b4e03ce036 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -861,10 +861,9 @@ static int nft_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
 static int nf_tables_gettable(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_table *table;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
@@ -1059,10 +1058,9 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
@@ -1254,10 +1252,9 @@ static int nft_flush(struct nft_ctx *ctx, int family)
 static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
@@ -1627,10 +1624,9 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 static int nf_tables_getchain(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_chain *chain;
 	struct net *net = info->net;
 	struct nft_table *table;
@@ -2355,10 +2351,9 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct nft_chain *chain = NULL;
 	struct net *net = info->net;
 	const struct nlattr *attr;
@@ -2453,10 +2448,9 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
@@ -3080,10 +3074,9 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
 	struct net *net = info->net;
@@ -3221,13 +3214,12 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	unsigned int size, i, n, ulen = 0, usize = 0;
 	u8 genmask = nft_genmask_next(info->net);
 	struct nft_rule *rule, *old_rule = NULL;
 	struct nft_expr_info *expr_info = NULL;
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	struct nft_flow_rule *flow;
 	struct nft_userdata *udata;
@@ -3459,15 +3451,15 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
-	int family = nfmsg->nfgen_family, err = 0;
 	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
 	struct nft_chain *chain = NULL;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_rule *rule;
 	struct nft_ctx ctx;
+	int err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask,
 				 NETLINK_CB(skb).portid);
@@ -4050,7 +4042,6 @@ static int nf_tables_dump_sets_done(struct netlink_callback *cb)
 static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	struct net *net = info->net;
@@ -4078,7 +4069,7 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	/* Only accept unspec with dump */
-	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
+	if (info->nfmsg->nfgen_family == NFPROTO_UNSPEC)
 		return -EAFNOSUPPORT;
 	if (!nla[NFTA_SET_TABLE])
 		return -EINVAL;
@@ -4171,11 +4162,10 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	u32 ktype, dtype, flags, policy, gc_int, objtype;
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_set_ops *ops;
 	struct nft_expr *expr = NULL;
 	struct net *net = info->net;
@@ -4475,7 +4465,6 @@ static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
 	struct net *net = info->net;
@@ -4484,7 +4473,7 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_ctx ctx;
 	int err;
 
-	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
+	if (info->nfmsg->nfgen_family == NFPROTO_UNSPEC)
 		return -EAFNOSUPPORT;
 	if (nla[NFTA_SET_TABLE] == NULL)
 		return -EINVAL;
@@ -6527,11 +6516,10 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_object_type *type;
-	int family = nfmsg->nfgen_family;
 	struct net *net = info->net;
 	struct nft_table *table;
 	struct nft_object *obj;
@@ -6783,10 +6771,9 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_table *table;
 	struct net *net = info->net;
 	struct nft_object *obj;
@@ -6873,10 +6860,9 @@ static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
 static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
 	struct nft_table *table;
@@ -7304,12 +7290,11 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 				  const struct nfnl_info *info,
 				  const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	struct nft_flowtable_hook flowtable_hook;
 	u8 genmask = nft_genmask_next(info->net);
+	u8 family = info->nfmsg->nfgen_family;
 	const struct nf_flowtable_type *type;
-	int family = nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
 	struct nft_hook *hook, *next;
 	struct net *net = info->net;
@@ -7493,10 +7478,9 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 				  const struct nfnl_info *info,
 				  const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
 	struct net *net = info->net;
 	const struct nlattr *attr;
@@ -7688,9 +7672,8 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 				  const struct nfnl_info *info,
 				  const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	u8 genmask = nft_genmask_cur(info->net);
-	int family = nfmsg->nfgen_family;
+	u8 family = info->nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
 	const struct nft_table *table;
 	struct net *net = info->net;
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e8dbd8379027..028a1f39318b 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -256,6 +256,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			.net	= net,
 			.sk	= nfnlnet->nfnl,
 			.nlh	= nlh,
+			.nfmsg	= nlmsg_data(nlh),
 			.extack	= extack,
 		};
 
@@ -491,6 +492,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 				.net	= net,
 				.sk	= nfnlnet->nfnl,
 				.nlh	= nlh,
+				.nfmsg	= nlmsg_data(nlh),
 				.extack	= &extack,
 			};
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 587086b18c36..691ef4cffdd9 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -871,15 +871,14 @@ static int nfulnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nfula[])
 {
 	struct nfnl_log_net *log = nfnl_log_pernet(info->net);
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u_int16_t group_num = ntohs(nfmsg->res_id);
+	u_int16_t group_num = ntohs(info->nfmsg->res_id);
 	struct nfulnl_msg_config_cmd *cmd = NULL;
 	struct nfulnl_instance *inst;
 	u16 flags = 0;
 	int ret = 0;
 
 	if (nfula[NFULA_CFG_CMD]) {
-		u_int8_t pf = nfmsg->nfgen_family;
+		u_int8_t pf = info->nfmsg->nfgen_family;
 		cmd = nla_data(nfula[NFULA_CFG_CMD]);
 
 		/* Commands without queue context */
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f37a575ebd7f..f774de0fc24f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1051,8 +1051,7 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 				    const struct nlattr * const nfqa[])
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u16 queue_num = ntohs(nfmsg->res_id);
+	u16 queue_num = ntohs(info->nfmsg->res_id);
 	struct nf_queue_entry *entry, *tmp;
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	struct nfqnl_instance *queue;
@@ -1160,8 +1159,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nfqa[])
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u_int16_t queue_num = ntohs(nfmsg->res_id);
+	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	enum ip_conntrack_info ctinfo;
 	struct nfqnl_instance *queue;
@@ -1243,8 +1241,7 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nfqa[])
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
-	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
-	u_int16_t queue_num = ntohs(nfmsg->res_id);
+	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 3144a9ad2f6a..639c337c885b 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -625,7 +625,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 			       const struct nfnl_info *info,
 			       const struct nlattr * const tb[])
 {
-	struct nfgenmsg *nfmsg;
+	u8 family = info->nfmsg->nfgen_family;
 	const char *name, *fmt;
 	struct sk_buff *skb2;
 	int ret = 0, target;
@@ -640,9 +640,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 	rev = ntohl(nla_get_be32(tb[NFTA_COMPAT_REV]));
 	target = ntohl(nla_get_be32(tb[NFTA_COMPAT_TYPE]));
 
-	nfmsg = nlmsg_data(info->nlh);
-
-	switch(nfmsg->nfgen_family) {
+	switch(family) {
 	case AF_INET:
 		fmt = "ipt_%s";
 		break;
@@ -656,8 +654,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		fmt = "arpt_%s";
 		break;
 	default:
-		pr_err("nft_compat: unsupported protocol %d\n",
-			nfmsg->nfgen_family);
+		pr_err("nft_compat: unsupported protocol %d\n", family);
 		return -EINVAL;
 	}
 
@@ -665,9 +662,8 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		return -EINVAL;
 
 	rcu_read_unlock();
-	try_then_request_module(xt_find_revision(nfmsg->nfgen_family, name,
-						 rev, target, &ret),
-						 fmt, name);
+	try_then_request_module(xt_find_revision(family, name, rev, target, &ret),
+				fmt, name);
 	if (ret < 0)
 		goto out_put;
 
@@ -682,8 +678,7 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 				  info->nlh->nlmsg_seq,
 				  NFNL_MSG_TYPE(info->nlh->nlmsg_type),
 				  NFNL_MSG_COMPAT_GET,
-				  nfmsg->nfgen_family,
-				  name, ret, target) <= 0) {
+				  family, name, ret, target) <= 0) {
 		kfree_skb(skb2);
 		goto out_put;
 	}
-- 
2.30.2

