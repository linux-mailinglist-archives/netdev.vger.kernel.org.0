Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B31C36B7BA
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbhDZRM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51592 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbhDZRL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 805DB63E81;
        Mon, 26 Apr 2021 19:10:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 21/22] netfilter: nfnetlink: consolidate callback types
Date:   Mon, 26 Apr 2021 19:10:55 +0200
Message-Id: <20210426171056.345271-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enum nfnl_callback_type to identify the callback type to provide one
single callback.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h  | 16 +++--
 net/netfilter/ipset/ip_set_core.c    | 16 +++++
 net/netfilter/nf_conntrack_netlink.c | 88 ++++++++++++++++++++--------
 net/netfilter/nf_tables_api.c        | 69 ++++++++++++++--------
 net/netfilter/nfnetlink.c            | 37 +++++++-----
 net/netfilter/nfnetlink_acct.c       | 36 ++++++++----
 net/netfilter/nfnetlink_cthelper.c   | 27 ++++++---
 net/netfilter/nfnetlink_cttimeout.c  | 45 +++++++++-----
 net/netfilter/nfnetlink_log.c        | 16 +++--
 net/netfilter/nfnetlink_osf.c        |  2 +
 net/netfilter/nfnetlink_queue.c      | 34 +++++++----
 net/netfilter/nft_compat.c           |  9 ++-
 12 files changed, 271 insertions(+), 124 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index df0e3254c57b..515ce53aa20d 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -14,15 +14,19 @@ struct nfnl_info {
 	struct netlink_ext_ack	*extack;
 };
 
+enum nfnl_callback_type {
+	NFNL_CB_UNSPEC	= 0,
+	NFNL_CB_MUTEX,
+	NFNL_CB_RCU,
+	NFNL_CB_BATCH,
+};
+
 struct nfnl_callback {
 	int (*call)(struct sk_buff *skb, const struct nfnl_info *info,
 		    const struct nlattr * const cda[]);
-	int (*call_rcu)(struct sk_buff *skb, const struct nfnl_info *info,
-			const struct nlattr * const cda[]);
-	int (*call_batch)(struct sk_buff *skb, const struct nfnl_info *info,
-			  const struct nlattr * const cda[]);
-	const struct nla_policy *policy;	/* netlink attribute policy */
-	const u_int16_t attr_count;		/* number of nlattr's */
+	const struct nla_policy	*policy;
+	enum nfnl_callback_type	type;
+	__u16			attr_count;
 };
 
 enum nfnl_abort_action {
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index bf9902c1daa8..de2d20c37cda 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -2108,80 +2108,96 @@ static int ip_set_byindex(struct sk_buff *skb, const struct nfnl_info *info,
 static const struct nfnl_callback ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
 	[IPSET_CMD_NONE]	= {
 		.call		= ip_set_none,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 	},
 	[IPSET_CMD_CREATE]	= {
 		.call		= ip_set_create,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_create_policy,
 	},
 	[IPSET_CMD_DESTROY]	= {
 		.call		= ip_set_destroy,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_setname_policy,
 	},
 	[IPSET_CMD_FLUSH]	= {
 		.call		= ip_set_flush,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_setname_policy,
 	},
 	[IPSET_CMD_RENAME]	= {
 		.call		= ip_set_rename,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_setname2_policy,
 	},
 	[IPSET_CMD_SWAP]	= {
 		.call		= ip_set_swap,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_setname2_policy,
 	},
 	[IPSET_CMD_LIST]	= {
 		.call		= ip_set_dump,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_dump_policy,
 	},
 	[IPSET_CMD_SAVE]	= {
 		.call		= ip_set_dump,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_setname_policy,
 	},
 	[IPSET_CMD_ADD]	= {
 		.call		= ip_set_uadd,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_adt_policy,
 	},
 	[IPSET_CMD_DEL]	= {
 		.call		= ip_set_udel,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_adt_policy,
 	},
 	[IPSET_CMD_TEST]	= {
 		.call		= ip_set_utest,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_adt_policy,
 	},
 	[IPSET_CMD_HEADER]	= {
 		.call		= ip_set_header,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_setname_policy,
 	},
 	[IPSET_CMD_TYPE]	= {
 		.call		= ip_set_type,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_type_policy,
 	},
 	[IPSET_CMD_PROTOCOL]	= {
 		.call		= ip_set_protocol,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_protocol_policy,
 	},
 	[IPSET_CMD_GET_BYNAME]	= {
 		.call		= ip_set_byname,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_setname_policy,
 	},
 	[IPSET_CMD_GET_BYINDEX]	= {
 		.call		= ip_set_byindex,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
 		.policy		= ip_set_index_policy,
 	},
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5147a63b3d1b..8690fc07030f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3751,35 +3751,71 @@ static struct nf_exp_event_notifier ctnl_notifier_exp = {
 #endif
 
 static const struct nfnl_callback ctnl_cb[IPCTNL_MSG_MAX] = {
-	[IPCTNL_MSG_CT_NEW]		= { .call = ctnetlink_new_conntrack,
-					    .attr_count = CTA_MAX,
-					    .policy = ct_nla_policy },
-	[IPCTNL_MSG_CT_GET] 		= { .call = ctnetlink_get_conntrack,
-					    .attr_count = CTA_MAX,
-					    .policy = ct_nla_policy },
-	[IPCTNL_MSG_CT_DELETE]  	= { .call = ctnetlink_del_conntrack,
-					    .attr_count = CTA_MAX,
-					    .policy = ct_nla_policy },
-	[IPCTNL_MSG_CT_GET_CTRZERO] 	= { .call = ctnetlink_get_conntrack,
-					    .attr_count = CTA_MAX,
-					    .policy = ct_nla_policy },
-	[IPCTNL_MSG_CT_GET_STATS_CPU]	= { .call = ctnetlink_stat_ct_cpu },
-	[IPCTNL_MSG_CT_GET_STATS]	= { .call = ctnetlink_stat_ct },
-	[IPCTNL_MSG_CT_GET_DYING]	= { .call = ctnetlink_get_ct_dying },
-	[IPCTNL_MSG_CT_GET_UNCONFIRMED]	= { .call = ctnetlink_get_ct_unconfirmed },
+	[IPCTNL_MSG_CT_NEW]	= {
+		.call		= ctnetlink_new_conntrack,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_MAX,
+		.policy		= ct_nla_policy
+	},
+	[IPCTNL_MSG_CT_GET]	= {
+		.call		= ctnetlink_get_conntrack,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_MAX,
+		.policy		= ct_nla_policy
+	},
+	[IPCTNL_MSG_CT_DELETE]	= {
+		.call		= ctnetlink_del_conntrack,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_MAX,
+		.policy		= ct_nla_policy
+	},
+	[IPCTNL_MSG_CT_GET_CTRZERO] = {
+		.call		= ctnetlink_get_conntrack,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_MAX,
+		.policy		= ct_nla_policy
+	},
+	[IPCTNL_MSG_CT_GET_STATS_CPU] = {
+		.call		= ctnetlink_stat_ct_cpu,
+		.type		= NFNL_CB_MUTEX,
+	},
+	[IPCTNL_MSG_CT_GET_STATS] = {
+		.call		= ctnetlink_stat_ct,
+		.type		= NFNL_CB_MUTEX,
+	},
+	[IPCTNL_MSG_CT_GET_DYING] = {
+		.call		= ctnetlink_get_ct_dying,
+		.type		= NFNL_CB_MUTEX,
+	},
+	[IPCTNL_MSG_CT_GET_UNCONFIRMED]	= {
+		.call		= ctnetlink_get_ct_unconfirmed,
+		.type		= NFNL_CB_MUTEX,
+	},
 };
 
 static const struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_EXP_MAX] = {
-	[IPCTNL_MSG_EXP_GET]		= { .call = ctnetlink_get_expect,
-					    .attr_count = CTA_EXPECT_MAX,
-					    .policy = exp_nla_policy },
-	[IPCTNL_MSG_EXP_NEW]		= { .call = ctnetlink_new_expect,
-					    .attr_count = CTA_EXPECT_MAX,
-					    .policy = exp_nla_policy },
-	[IPCTNL_MSG_EXP_DELETE]		= { .call = ctnetlink_del_expect,
-					    .attr_count = CTA_EXPECT_MAX,
-					    .policy = exp_nla_policy },
-	[IPCTNL_MSG_EXP_GET_STATS_CPU]	= { .call = ctnetlink_stat_exp_cpu },
+	[IPCTNL_MSG_EXP_GET] = {
+		.call		= ctnetlink_get_expect,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_EXPECT_MAX,
+		.policy		= exp_nla_policy
+	},
+	[IPCTNL_MSG_EXP_NEW] = {
+		.call		= ctnetlink_new_expect,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_EXPECT_MAX,
+		.policy		= exp_nla_policy
+	},
+	[IPCTNL_MSG_EXP_DELETE] = {
+		.call		= ctnetlink_del_expect,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_EXPECT_MAX,
+		.policy		= exp_nla_policy
+	},
+	[IPCTNL_MSG_EXP_GET_STATS_CPU] = {
+		.call		= ctnetlink_stat_exp_cpu,
+		.type		= NFNL_CB_MUTEX,
+	},
 };
 
 static const struct nfnetlink_subsystem ctnl_subsys = {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 280ca136df56..1050f23c0d29 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7554,115 +7554,138 @@ static int nf_tables_getgen(struct sk_buff *skb, const struct nfnl_info *info,
 
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
-		.call_batch	= nf_tables_newtable,
+		.call		= nf_tables_newtable,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_GETTABLE] = {
-		.call_rcu	= nf_tables_gettable,
+		.call		= nf_tables_gettable,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_DELTABLE] = {
-		.call_batch	= nf_tables_deltable,
+		.call		= nf_tables_deltable,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
 	[NFT_MSG_NEWCHAIN] = {
-		.call_batch	= nf_tables_newchain,
+		.call		= nf_tables_newchain,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
 	[NFT_MSG_GETCHAIN] = {
-		.call_rcu	= nf_tables_getchain,
+		.call		= nf_tables_getchain,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
 	[NFT_MSG_DELCHAIN] = {
-		.call_batch	= nf_tables_delchain,
+		.call		= nf_tables_delchain,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
 	[NFT_MSG_NEWRULE] = {
-		.call_batch	= nf_tables_newrule,
+		.call		= nf_tables_newrule,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_GETRULE] = {
-		.call_rcu	= nf_tables_getrule,
+		.call		= nf_tables_getrule,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_DELRULE] = {
-		.call_batch	= nf_tables_delrule,
+		.call		= nf_tables_delrule,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
 	[NFT_MSG_NEWSET] = {
-		.call_batch	= nf_tables_newset,
+		.call		= nf_tables_newset,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
 	[NFT_MSG_GETSET] = {
-		.call_rcu	= nf_tables_getset,
+		.call		= nf_tables_getset,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
 	[NFT_MSG_DELSET] = {
-		.call_batch	= nf_tables_delset,
+		.call		= nf_tables_delset,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
 	[NFT_MSG_NEWSETELEM] = {
-		.call_batch	= nf_tables_newsetelem,
+		.call		= nf_tables_newsetelem,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETSETELEM] = {
-		.call_rcu	= nf_tables_getsetelem,
+		.call		= nf_tables_getsetelem,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_DELSETELEM] = {
-		.call_batch	= nf_tables_delsetelem,
+		.call		= nf_tables_delsetelem,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
 	[NFT_MSG_GETGEN] = {
-		.call_rcu	= nf_tables_getgen,
+		.call		= nf_tables_getgen,
+		.type		= NFNL_CB_RCU,
 	},
 	[NFT_MSG_NEWOBJ] = {
-		.call_batch	= nf_tables_newobj,
+		.call		= nf_tables_newobj,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ] = {
-		.call_rcu	= nf_tables_getobj,
+		.call		= nf_tables_getobj,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_DELOBJ] = {
-		.call_batch	= nf_tables_delobj,
+		.call		= nf_tables_delobj,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call_rcu	= nf_tables_getobj,
+		.call		= nf_tables_getobj,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_NEWFLOWTABLE] = {
-		.call_batch	= nf_tables_newflowtable,
+		.call		= nf_tables_newflowtable,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
 	[NFT_MSG_GETFLOWTABLE] = {
-		.call_rcu	= nf_tables_getflowtable,
+		.call		= nf_tables_getflowtable,
+		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
 	[NFT_MSG_DELFLOWTABLE] = {
-		.call_batch	= nf_tables_delflowtable,
+		.call		= nf_tables_delflowtable,
+		.type		= NFNL_CB_BATCH,
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e62c5af4b631..d7a9628b6cee 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -273,23 +273,30 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return err;
 		}
 
-		if (nc->call_rcu) {
-			err = nc->call_rcu(skb, &info,
-					   (const struct nlattr **)cda);
+		if (!nc->call) {
 			rcu_read_unlock();
-		} else {
+			return -EINVAL;
+		}
+
+		switch (nc->type) {
+		case NFNL_CB_RCU:
+			err = nc->call(skb, &info, (const struct nlattr **)cda);
+			rcu_read_unlock();
+			break;
+		case NFNL_CB_MUTEX:
 			rcu_read_unlock();
 			nfnl_lock(subsys_id);
 			if (nfnl_dereference_protected(subsys_id) != ss ||
 			    nfnetlink_find_client(type, ss) != nc) {
 				err = -EAGAIN;
-			} else if (nc->call) {
-				err = nc->call(skb, &info,
-					       (const struct nlattr **)cda);
-			} else {
-				err = -EINVAL;
+				break;
 			}
+			err = nc->call(skb, &info, (const struct nlattr **)cda);
 			nfnl_unlock(subsys_id);
+			break;
+		default:
+			err = -EINVAL;
+			break;
 		}
 		if (err == -EAGAIN)
 			goto replay;
@@ -467,12 +474,17 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto ack;
 		}
 
+		if (nc->type != NFNL_CB_BATCH) {
+			err = -EINVAL;
+			goto ack;
+		}
+
 		{
 			int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 			struct nfnl_net *nfnlnet = nfnl_pernet(net);
-			u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 			struct nlattr *cda[NFNL_MAX_ATTR_COUNT + 1];
 			struct nlattr *attr = (void *)nlh + min_len;
+			u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 			int attrlen = nlh->nlmsg_len - min_len;
 			struct nfnl_info info = {
 				.net	= net,
@@ -494,10 +506,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err < 0)
 				goto ack;
 
-			if (nc->call_batch) {
-				err = nc->call_batch(skb, &info,
-						     (const struct nlattr **)cda);
-			}
+			err = nc->call(skb, &info, (const struct nlattr **)cda);
 
 			/* The lock was released to autoload some module, we
 			 * have to abort and start from scratch using the
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 9cb4b21b8e95..3c8cf8748cfb 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -382,18 +382,30 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
-	[NFNL_MSG_ACCT_NEW]		= { .call = nfnl_acct_new,
-					    .attr_count = NFACCT_MAX,
-					    .policy = nfnl_acct_policy },
-	[NFNL_MSG_ACCT_GET] 		= { .call = nfnl_acct_get,
-					    .attr_count = NFACCT_MAX,
-					    .policy = nfnl_acct_policy },
-	[NFNL_MSG_ACCT_GET_CTRZERO] 	= { .call = nfnl_acct_get,
-					    .attr_count = NFACCT_MAX,
-					    .policy = nfnl_acct_policy },
-	[NFNL_MSG_ACCT_DEL]		= { .call = nfnl_acct_del,
-					    .attr_count = NFACCT_MAX,
-					    .policy = nfnl_acct_policy },
+	[NFNL_MSG_ACCT_NEW] = {
+		.call		= nfnl_acct_new,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFACCT_MAX,
+		.policy		= nfnl_acct_policy
+	},
+	[NFNL_MSG_ACCT_GET] = {
+		.call		= nfnl_acct_get,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFACCT_MAX,
+		.policy		= nfnl_acct_policy
+	},
+	[NFNL_MSG_ACCT_GET_CTRZERO] = {
+		.call		= nfnl_acct_get,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFACCT_MAX,
+		.policy		= nfnl_acct_policy
+	},
+	[NFNL_MSG_ACCT_DEL] = {
+		.call		= nfnl_acct_del,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFACCT_MAX,
+		.policy		= nfnl_acct_policy
+	},
 };
 
 static const struct nfnetlink_subsystem nfnl_acct_subsys = {
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 3d1a5215177b..322ac5dd5402 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -737,15 +737,24 @@ static const struct nla_policy nfnl_cthelper_policy[NFCTH_MAX+1] = {
 };
 
 static const struct nfnl_callback nfnl_cthelper_cb[NFNL_MSG_CTHELPER_MAX] = {
-	[NFNL_MSG_CTHELPER_NEW]		= { .call = nfnl_cthelper_new,
-					    .attr_count = NFCTH_MAX,
-					    .policy = nfnl_cthelper_policy },
-	[NFNL_MSG_CTHELPER_GET]		= { .call = nfnl_cthelper_get,
-					    .attr_count = NFCTH_MAX,
-					    .policy = nfnl_cthelper_policy },
-	[NFNL_MSG_CTHELPER_DEL]		= { .call = nfnl_cthelper_del,
-					    .attr_count = NFCTH_MAX,
-					    .policy = nfnl_cthelper_policy },
+	[NFNL_MSG_CTHELPER_NEW]	= {
+		.call		= nfnl_cthelper_new,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFCTH_MAX,
+		.policy		= nfnl_cthelper_policy
+	},
+	[NFNL_MSG_CTHELPER_GET] = {
+		.call		= nfnl_cthelper_get,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFCTH_MAX,
+		.policy		= nfnl_cthelper_policy
+	},
+	[NFNL_MSG_CTHELPER_DEL]	= {
+		.call		= nfnl_cthelper_del,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFCTH_MAX,
+		.policy		= nfnl_cthelper_policy
+	},
 };
 
 static const struct nfnetlink_subsystem nfnl_cthelper_subsys = {
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 994f3172bf42..38848ad68899 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -546,21 +546,36 @@ static void ctnl_timeout_put(struct nf_ct_timeout *t)
 }
 
 static const struct nfnl_callback cttimeout_cb[IPCTNL_MSG_TIMEOUT_MAX] = {
-	[IPCTNL_MSG_TIMEOUT_NEW]	= { .call = cttimeout_new_timeout,
-					    .attr_count = CTA_TIMEOUT_MAX,
-					    .policy = cttimeout_nla_policy },
-	[IPCTNL_MSG_TIMEOUT_GET]	= { .call = cttimeout_get_timeout,
-					    .attr_count = CTA_TIMEOUT_MAX,
-					    .policy = cttimeout_nla_policy },
-	[IPCTNL_MSG_TIMEOUT_DELETE]	= { .call = cttimeout_del_timeout,
-					    .attr_count = CTA_TIMEOUT_MAX,
-					    .policy = cttimeout_nla_policy },
-	[IPCTNL_MSG_TIMEOUT_DEFAULT_SET]= { .call = cttimeout_default_set,
-					    .attr_count = CTA_TIMEOUT_MAX,
-					    .policy = cttimeout_nla_policy },
-	[IPCTNL_MSG_TIMEOUT_DEFAULT_GET]= { .call = cttimeout_default_get,
-					    .attr_count = CTA_TIMEOUT_MAX,
-					    .policy = cttimeout_nla_policy },
+	[IPCTNL_MSG_TIMEOUT_NEW] = {
+		.call		= cttimeout_new_timeout,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_TIMEOUT_MAX,
+		.policy		= cttimeout_nla_policy
+	},
+	[IPCTNL_MSG_TIMEOUT_GET] = {
+		.call		= cttimeout_get_timeout,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_TIMEOUT_MAX,
+		.policy		= cttimeout_nla_policy
+	},
+	[IPCTNL_MSG_TIMEOUT_DELETE] = {
+		.call		= cttimeout_del_timeout,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_TIMEOUT_MAX,
+		.policy		= cttimeout_nla_policy
+	},
+	[IPCTNL_MSG_TIMEOUT_DEFAULT_SET] = {
+		.call		= cttimeout_default_set,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_TIMEOUT_MAX,
+		.policy		= cttimeout_nla_policy
+	},
+	[IPCTNL_MSG_TIMEOUT_DEFAULT_GET] = {
+		.call		= cttimeout_default_get,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= CTA_TIMEOUT_MAX,
+		.policy		= cttimeout_nla_policy
+	},
 };
 
 static const struct nfnetlink_subsystem cttimeout_subsys = {
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 81630600b4ef..587086b18c36 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -989,11 +989,17 @@ static int nfulnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 }
 
 static const struct nfnl_callback nfulnl_cb[NFULNL_MSG_MAX] = {
-	[NFULNL_MSG_PACKET]	= { .call = nfulnl_recv_unsupp,
-				    .attr_count = NFULA_MAX, },
-	[NFULNL_MSG_CONFIG]	= { .call = nfulnl_recv_config,
-				    .attr_count = NFULA_CFG_MAX,
-				    .policy = nfula_cfg_policy },
+	[NFULNL_MSG_PACKET]	= {
+		.call		= nfulnl_recv_unsupp,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFULA_MAX,
+	},
+	[NFULNL_MSG_CONFIG]	= {
+		.call		= nfulnl_recv_config,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFULA_CFG_MAX,
+		.policy		= nfula_cfg_policy
+	},
 };
 
 static const struct nfnetlink_subsystem nfulnl_subsys = {
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 1fd537ef4496..e8f8875c6884 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -374,11 +374,13 @@ static int nfnl_osf_remove_callback(struct sk_buff *skb,
 static const struct nfnl_callback nfnl_osf_callbacks[OSF_MSG_MAX] = {
 	[OSF_MSG_ADD]	= {
 		.call		= nfnl_osf_add_callback,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= OSF_ATTR_MAX,
 		.policy		= nfnl_osf_policy,
 	},
 	[OSF_MSG_REMOVE]	= {
 		.call		= nfnl_osf_remove_callback,
+		.type		= NFNL_CB_MUTEX,
 		.attr_count	= OSF_ATTR_MAX,
 		.policy		= nfnl_osf_policy,
 	},
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index ede9252c8de1..f37a575ebd7f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1365,17 +1365,29 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 }
 
 static const struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
-	[NFQNL_MSG_PACKET]	= { .call_rcu = nfqnl_recv_unsupp,
-				    .attr_count = NFQA_MAX, },
-	[NFQNL_MSG_VERDICT]	= { .call_rcu = nfqnl_recv_verdict,
-				    .attr_count = NFQA_MAX,
-				    .policy = nfqa_verdict_policy },
-	[NFQNL_MSG_CONFIG]	= { .call = nfqnl_recv_config,
-				    .attr_count = NFQA_CFG_MAX,
-				    .policy = nfqa_cfg_policy },
-	[NFQNL_MSG_VERDICT_BATCH]={ .call_rcu = nfqnl_recv_verdict_batch,
-				    .attr_count = NFQA_MAX,
-				    .policy = nfqa_verdict_batch_policy },
+	[NFQNL_MSG_PACKET]	= {
+		.call		= nfqnl_recv_unsupp,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFQA_MAX,
+	},
+	[NFQNL_MSG_VERDICT]	= {
+		.call		= nfqnl_recv_verdict,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFQA_MAX,
+		.policy		= nfqa_verdict_policy
+	},
+	[NFQNL_MSG_CONFIG]	= {
+		.call		= nfqnl_recv_config,
+		.type		= NFNL_CB_MUTEX,
+		.attr_count	= NFQA_CFG_MAX,
+		.policy		= nfqa_cfg_policy
+	},
+	[NFQNL_MSG_VERDICT_BATCH] = {
+		.call		= nfqnl_recv_verdict_batch,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFQA_MAX,
+		.policy		= nfqa_verdict_batch_policy
+	},
 };
 
 static const struct nfnetlink_subsystem nfqnl_subsys = {
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 4c0657245d5a..5415ab14400d 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -698,9 +698,12 @@ static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
 };
 
 static const struct nfnl_callback nfnl_nft_compat_cb[NFNL_MSG_COMPAT_MAX] = {
-	[NFNL_MSG_COMPAT_GET]		= { .call_rcu = nfnl_compat_get_rcu,
-					    .attr_count = NFTA_COMPAT_MAX,
-					    .policy = nfnl_compat_policy_get },
+	[NFNL_MSG_COMPAT_GET]	= {
+		.call		= nfnl_compat_get_rcu,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_COMPAT_MAX,
+		.policy		= nfnl_compat_policy_get
+	},
 };
 
 static const struct nfnetlink_subsystem nfnl_compat_subsys = {
-- 
2.30.2

