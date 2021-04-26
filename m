Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C4536B7CE
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbhDZRNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:13:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51584 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbhDZRL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6E44B63E85;
        Mon, 26 Apr 2021 19:10:38 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 19/22] netfilter: nfnetlink: pass struct nfnl_info to rcu callbacks
Date:   Mon, 26 Apr 2021 19:10:53 +0200
Message-Id: <20210426171056.345271-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update rcu callbacks to use the nfnl_info structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h |   6 +-
 net/netfilter/nf_tables_api.c       | 152 ++++++++++++++--------------
 net/netfilter/nfnetlink.c           |   5 +-
 net/netfilter/nfnetlink_queue.c     |  40 ++++----
 net/netfilter/nft_compat.c          |  24 ++---
 5 files changed, 107 insertions(+), 120 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 1baa3205b199..c11f2f99eac4 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -17,10 +17,8 @@ struct nfnl_info {
 struct nfnl_callback {
 	int (*call)(struct sk_buff *skb, const struct nfnl_info *info,
 		    const struct nlattr * const cda[]);
-	int (*call_rcu)(struct net *net, struct sock *nl, struct sk_buff *skb,
-			const struct nlmsghdr *nlh,
-			const struct nlattr * const cda[],
-			struct netlink_ext_ack *extack);
+	int (*call_rcu)(struct sk_buff *skb, const struct nfnl_info *info,
+			const struct nlattr * const cda[]);
 	int (*call_batch)(struct net *net, struct sock *nl, struct sk_buff *skb,
 			  const struct nlmsghdr *nlh,
 			  const struct nlattr * const cda[],
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 155b85553fcc..f7c4e6f14130 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -858,25 +858,25 @@ static int nft_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_gettable(struct net *net, struct sock *nlsk,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nla[],
-			      struct netlink_ext_ack *extack)
+static int nf_tables_gettable(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_cur(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	int family = nfmsg->nfgen_family;
 	const struct nft_table *table;
+	struct net *net = info->net;
 	struct sk_buff *skb2;
-	int family = nfmsg->nfgen_family;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_tables,
 			.module = THIS_MODULE,
 		};
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
 	table = nft_table_lookup(net, nla[NFTA_TABLE_NAME], family, genmask, 0);
@@ -890,8 +890,8 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 		return -ENOMEM;
 
 	err = nf_tables_fill_table_info(skb2, net, NETLINK_CB(skb).portid,
-					nlh->nlmsg_seq, NFT_MSG_NEWTABLE, 0,
-					family, table);
+					info->nlh->nlmsg_seq, NFT_MSG_NEWTABLE,
+					0, family, table);
 	if (err < 0)
 		goto err_fill_table_info;
 
@@ -1623,26 +1623,26 @@ static int nf_tables_dump_chains(struct sk_buff *skb,
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getchain(struct net *net, struct sock *nlsk,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nla[],
-			      struct netlink_ext_ack *extack)
+static int nf_tables_getchain(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_cur(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	int family = nfmsg->nfgen_family;
 	const struct nft_chain *chain;
+	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
-	int family = nfmsg->nfgen_family;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_chains,
 			.module = THIS_MODULE,
 		};
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
 	table = nft_table_lookup(net, nla[NFTA_CHAIN_TABLE], family, genmask, 0);
@@ -1662,8 +1662,8 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 		return -ENOMEM;
 
 	err = nf_tables_fill_chain_info(skb2, net, NETLINK_CB(skb).portid,
-					nlh->nlmsg_seq, NFT_MSG_NEWCHAIN, 0,
-					family, table, chain);
+					info->nlh->nlmsg_seq, NFT_MSG_NEWCHAIN,
+					0, family, table, chain);
 	if (err < 0)
 		goto err_fill_chain_info;
 
@@ -3076,21 +3076,21 @@ static int nf_tables_dump_rules_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getrule(struct net *net, struct sock *nlsk,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const nla[],
-			     struct netlink_ext_ack *extack)
+static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_cur(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	int family = nfmsg->nfgen_family;
 	const struct nft_chain *chain;
 	const struct nft_rule *rule;
+	struct net *net = info->net;
 	struct nft_table *table;
 	struct sk_buff *skb2;
-	int family = nfmsg->nfgen_family;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start= nf_tables_dump_rules_start,
 			.dump = nf_tables_dump_rules,
@@ -3099,7 +3099,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 			.data = (void *)nla,
 		};
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
@@ -3125,7 +3125,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 		return -ENOMEM;
 
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
-				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
+				       info->nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, NULL);
 	if (err < 0)
 		goto err_fill_rule_info;
@@ -4045,25 +4045,25 @@ static int nf_tables_dump_sets_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getset(struct net *net, struct sock *nlsk,
-			    struct sk_buff *skb, const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[],
-			    struct netlink_ext_ack *extack)
+static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
 {
-	u8 genmask = nft_genmask_cur(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	struct net *net = info->net;
 	const struct nft_set *set;
-	struct nft_ctx ctx;
 	struct sk_buff *skb2;
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nft_ctx ctx;
 	int err;
 
 	/* Verify existence before starting dump */
-	err = nft_ctx_init_from_setattr(&ctx, net, skb, nlh, nla, extack,
+	err = nft_ctx_init_from_setattr(&ctx, net, skb, info->nlh, nla, extack,
 					genmask, 0);
 	if (err < 0)
 		return err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_sets_start,
 			.dump = nf_tables_dump_sets,
@@ -4072,7 +4072,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 			.module = THIS_MODULE,
 		};
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
 	/* Only accept unspec with dump */
@@ -5063,18 +5063,19 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
-				struct sk_buff *skb, const struct nlmsghdr *nlh,
-				const struct nlattr * const nla[],
-				struct netlink_ext_ack *extack)
+static int nf_tables_getsetelem(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const nla[])
 {
-	u8 genmask = nft_genmask_cur(net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	struct net *net = info->net;
 	struct nft_set *set;
 	struct nlattr *attr;
 	struct nft_ctx ctx;
 	int rem, err = 0;
 
-	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, extack,
+	err = nft_ctx_init_from_elemattr(&ctx, net, skb, info->nlh, nla, extack,
 					 genmask, NETLINK_CB(skb).portid);
 	if (err < 0)
 		return err;
@@ -5083,7 +5084,7 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_set_start,
 			.dump = nf_tables_dump_set,
@@ -5096,7 +5097,7 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 		};
 
 		c.data = &dump_ctx;
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
@@ -6416,22 +6417,22 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getobj(struct net *net, struct sock *nlsk,
-			    struct sk_buff *skb, const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[],
-			    struct netlink_ext_ack *extack)
+static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_cur(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
 	int family = nfmsg->nfgen_family;
 	const struct nft_table *table;
+	struct net *net = info->net;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
 	bool reset = false;
 	u32 objtype;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_obj_start,
 			.dump = nf_tables_dump_obj,
@@ -6440,7 +6441,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 			.data = (void *)nla,
 		};
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
 	if (!nla[NFTA_OBJ_NAME] ||
@@ -6464,7 +6465,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	if (!skb2)
 		return -ENOMEM;
 
-	if (NFNL_MSG_TYPE(nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
 	if (reset) {
@@ -6483,7 +6484,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	}
 
 	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
-				      nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
+				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
 				      family, table, obj, reset);
 	if (err < 0)
 		goto err_fill_obj_info;
@@ -7320,21 +7321,20 @@ static int nf_tables_dump_flowtable_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
-				  struct sk_buff *skb,
-				  const struct nlmsghdr *nlh,
-				  const struct nlattr * const nla[],
-				  struct netlink_ext_ack *extack)
+static int nf_tables_getflowtable(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const nla[])
 {
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u8 genmask = nft_genmask_cur(net);
+	const struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u8 genmask = nft_genmask_cur(info->net);
 	int family = nfmsg->nfgen_family;
 	struct nft_flowtable *flowtable;
 	const struct nft_table *table;
+	struct net *net = info->net;
 	struct sk_buff *skb2;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_flowtable_start,
 			.dump = nf_tables_dump_flowtable,
@@ -7343,7 +7343,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 			.data = (void *)nla,
 		};
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
 	if (!nla[NFTA_FLOWTABLE_NAME])
@@ -7364,7 +7364,7 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 		return -ENOMEM;
 
 	err = nf_tables_fill_flowtable_info(skb2, net, NETLINK_CB(skb).portid,
-					    nlh->nlmsg_seq,
+					    info->nlh->nlmsg_seq,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
 					    flowtable, &flowtable->hook_list);
 	if (err < 0)
@@ -7526,10 +7526,8 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
 			  -ENOBUFS);
 }
 
-static int nf_tables_getgen(struct net *net, struct sock *nlsk,
-			    struct sk_buff *skb, const struct nlmsghdr *nlh,
-			    const struct nlattr * const nla[],
-			    struct netlink_ext_ack *extack)
+static int nf_tables_getgen(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
 {
 	struct sk_buff *skb2;
 	int err;
@@ -7538,12 +7536,12 @@ static int nf_tables_getgen(struct net *net, struct sock *nlsk,
 	if (skb2 == NULL)
 		return -ENOMEM;
 
-	err = nf_tables_fill_gen_info(skb2, net, NETLINK_CB(skb).portid,
-				      nlh->nlmsg_seq);
+	err = nf_tables_fill_gen_info(skb2, info->net, NETLINK_CB(skb).portid,
+				      info->nlh->nlmsg_seq);
 	if (err < 0)
 		goto err_fill_gen_info;
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 
 err_fill_gen_info:
 	kfree_skb(skb2);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 5f04b67bf47e..7920f6c4ff69 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -274,9 +274,8 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 
 		if (nc->call_rcu) {
-			err = nc->call_rcu(net, nfnlnet->nfnl, skb, nlh,
-					   (const struct nlattr **)cda,
-					   extack);
+			err = nc->call_rcu(skb, &info,
+					   (const struct nlattr **)cda);
 			rcu_read_unlock();
 		} else {
 			rcu_read_unlock();
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 9d7e06d85199..ede9252c8de1 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1046,20 +1046,18 @@ static int nfq_id_after(unsigned int id, unsigned int max)
 	return (int)(id - max) > 0;
 }
 
-static int nfqnl_recv_verdict_batch(struct net *net, struct sock *ctnl,
-				    struct sk_buff *skb,
-				    const struct nlmsghdr *nlh,
-			            const struct nlattr * const nfqa[],
-				    struct netlink_ext_ack *extack)
+static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
+				    const struct nfnl_info *info,
+				    const struct nlattr * const nfqa[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u16 queue_num = ntohs(nfmsg->res_id);
 	struct nf_queue_entry *entry, *tmp;
-	unsigned int verdict, maxid;
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	struct nfqnl_instance *queue;
+	unsigned int verdict, maxid;
 	LIST_HEAD(batch_list);
-	u16 queue_num = ntohs(nfmsg->res_id);
-	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
 
 	queue = verdict_instance_lookup(q, queue_num,
 					NETLINK_CB(skb).portid);
@@ -1158,22 +1156,19 @@ static int nfqa_parse_bridge(struct nf_queue_entry *entry,
 	return 0;
 }
 
-static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
-			      struct sk_buff *skb,
-			      const struct nlmsghdr *nlh,
-			      const struct nlattr * const nfqa[],
-			      struct netlink_ext_ack *extack)
+static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nfqa[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
 	struct nfqnl_msg_verdict_hdr *vhdr;
+	enum ip_conntrack_info ctinfo;
 	struct nfqnl_instance *queue;
-	unsigned int verdict;
 	struct nf_queue_entry *entry;
-	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
 	struct nf_conn *ct = NULL;
-	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+	unsigned int verdict;
 	int err;
 
 	queue = verdict_instance_lookup(q, queue_num,
@@ -1196,7 +1191,8 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 
 	if (nfqa[NFQA_CT]) {
 		if (nfnl_ct != NULL)
-			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
+			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
+					    &ctinfo);
 	}
 
 	if (entry->state.pf == PF_BRIDGE) {
@@ -1224,10 +1220,8 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 	return 0;
 }
 
-static int nfqnl_recv_unsupp(struct net *net, struct sock *ctnl,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const nfqa[],
-			     struct netlink_ext_ack *extack)
+static int nfqnl_recv_unsupp(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const cda[])
 {
 	return -ENOTSUPP;
 }
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index b8dbd20a6a4c..4c0657245d5a 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -613,17 +613,15 @@ nfnl_compat_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	return -1;
 }
 
-static int nfnl_compat_get_rcu(struct net *net, struct sock *nfnl,
-			       struct sk_buff *skb, const struct nlmsghdr *nlh,
-			       const struct nlattr * const tb[],
-			       struct netlink_ext_ack *extack)
+static int nfnl_compat_get_rcu(struct sk_buff *skb,
+			       const struct nfnl_info *info,
+			       const struct nlattr * const tb[])
 {
-	int ret = 0, target;
 	struct nfgenmsg *nfmsg;
-	const char *fmt;
-	const char *name;
-	u32 rev;
+	const char *name, *fmt;
 	struct sk_buff *skb2;
+	int ret = 0, target;
+	u32 rev;
 
 	if (tb[NFTA_COMPAT_NAME] == NULL ||
 	    tb[NFTA_COMPAT_REV] == NULL ||
@@ -634,7 +632,7 @@ static int nfnl_compat_get_rcu(struct net *net, struct sock *nfnl,
 	rev = ntohl(nla_get_be32(tb[NFTA_COMPAT_REV]));
 	target = ntohl(nla_get_be32(tb[NFTA_COMPAT_TYPE]));
 
-	nfmsg = nlmsg_data(nlh);
+	nfmsg = nlmsg_data(info->nlh);
 
 	switch(nfmsg->nfgen_family) {
 	case AF_INET:
@@ -673,8 +671,8 @@ static int nfnl_compat_get_rcu(struct net *net, struct sock *nfnl,
 
 	/* include the best revision for this extension in the message */
 	if (nfnl_compat_fill_info(skb2, NETLINK_CB(skb).portid,
-				  nlh->nlmsg_seq,
-				  NFNL_MSG_TYPE(nlh->nlmsg_type),
+				  info->nlh->nlmsg_seq,
+				  NFNL_MSG_TYPE(info->nlh->nlmsg_type),
 				  NFNL_MSG_COMPAT_GET,
 				  nfmsg->nfgen_family,
 				  name, ret, target) <= 0) {
@@ -682,8 +680,8 @@ static int nfnl_compat_get_rcu(struct net *net, struct sock *nfnl,
 		goto out_put;
 	}
 
-	ret = netlink_unicast(nfnl, skb2, NETLINK_CB(skb).portid,
-				MSG_DONTWAIT);
+	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (ret > 0)
 		ret = 0;
 out_put:
-- 
2.30.2

