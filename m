Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2497F1D2E8A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgENLkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:40:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34145 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726067AbgENLkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:40:40 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 14:40:36 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EBeZKb031451;
        Thu, 14 May 2020 14:40:36 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 1/4] net: sched: introduce terse dump flag
Date:   Thu, 14 May 2020 14:40:23 +0300
Message-Id: <20200514114026.27047-2-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514114026.27047-1-vladbu@mellanox.com>
References: <20200514114026.27047-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new TCA_DUMP_FLAGS attribute and use it in cls API to request terse
filter output from classifiers with TCA_DUMP_FLAGS_TERSE flag. This option
is intended to be used to improve performance of TC filter dump when
userland only needs to obtain stats and not the whole classifier/action
data. Extend struct tcf_proto_ops with new terse_dump() callback that must
be defined by supporting classifier implementations.

Support of the options in specific classifiers and actions is
implemented in following patches in the series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/sch_generic.h      |  4 ++++
 include/uapi/linux/rtnetlink.h |  6 +++++
 net/sched/cls_api.c            | 41 +++++++++++++++++++++++++++-------
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index ab87a8b86a32..c510b03b9751 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -330,6 +330,10 @@ struct tcf_proto_ops {
 	int			(*dump)(struct net*, struct tcf_proto*, void *,
 					struct sk_buff *skb, struct tcmsg*,
 					bool);
+	int			(*terse_dump)(struct net *net,
+					      struct tcf_proto *tp, void *fh,
+					      struct sk_buff *skb,
+					      struct tcmsg *t, bool rtnl_held);
 	int			(*tmplt_dump)(struct sk_buff *skb,
 					      struct net *net,
 					      void *tmplt_priv);
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 4a8c5b745157..073e71ef6bdd 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -609,11 +609,17 @@ enum {
 	TCA_HW_OFFLOAD,
 	TCA_INGRESS_BLOCK,
 	TCA_EGRESS_BLOCK,
+	TCA_DUMP_FLAGS,
 	__TCA_MAX
 };
 
 #define TCA_MAX (__TCA_MAX - 1)
 
+#define TCA_DUMP_FLAGS_TERSE (1 << 0) /* Means that in dump user gets only basic
+				       * data necessary to identify the objects
+				       * (handle, cookie, etc.) and stats.
+				       */
+
 #define TCA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct tcmsg))))
 #define TCA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcmsg))
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 299b963c796e..d754f2718914 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1851,7 +1851,7 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 			 struct tcf_proto *tp, struct tcf_block *block,
 			 struct Qdisc *q, u32 parent, void *fh,
 			 u32 portid, u32 seq, u16 flags, int event,
-			 bool rtnl_held)
+			 bool terse_dump, bool rtnl_held)
 {
 	struct tcmsg *tcm;
 	struct nlmsghdr  *nlh;
@@ -1878,6 +1878,14 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 		goto nla_put_failure;
 	if (!fh) {
 		tcm->tcm_handle = 0;
+	} else if (terse_dump) {
+		if (tp->ops->terse_dump) {
+			if (tp->ops->terse_dump(net, tp, fh, skb, tcm,
+						rtnl_held) < 0)
+				goto nla_put_failure;
+		} else {
+			goto cls_op_not_supp;
+		}
 	} else {
 		if (tp->ops->dump &&
 		    tp->ops->dump(net, tp, fh, skb, tcm, rtnl_held) < 0)
@@ -1888,6 +1896,7 @@ static int tcf_fill_node(struct net *net, struct sk_buff *skb,
 
 out_nlmsg_trim:
 nla_put_failure:
+cls_op_not_supp:
 	nlmsg_trim(skb, b);
 	return -1;
 }
@@ -1908,7 +1917,7 @@ static int tfilter_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, event,
-			  rtnl_held) <= 0) {
+			  false, rtnl_held) <= 0) {
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1940,7 +1949,7 @@ static int tfilter_del_notify(struct net *net, struct sk_buff *oskb,
 
 	if (tcf_fill_node(net, skb, tp, block, q, parent, fh, portid,
 			  n->nlmsg_seq, n->nlmsg_flags, RTM_DELTFILTER,
-			  rtnl_held) <= 0) {
+			  false, rtnl_held) <= 0) {
 		NL_SET_ERR_MSG(extack, "Failed to build del event notification");
 		kfree_skb(skb);
 		return -EINVAL;
@@ -2501,6 +2510,7 @@ struct tcf_dump_args {
 	struct tcf_block *block;
 	struct Qdisc *q;
 	u32 parent;
+	bool terse_dump;
 };
 
 static int tcf_node_dump(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
@@ -2511,12 +2521,12 @@ static int tcf_node_dump(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
 	return tcf_fill_node(net, a->skb, tp, a->block, a->q, a->parent,
 			     n, NETLINK_CB(a->cb->skb).portid,
 			     a->cb->nlh->nlmsg_seq, NLM_F_MULTI,
-			     RTM_NEWTFILTER, true);
+			     RTM_NEWTFILTER, a->terse_dump, true);
 }
 
 static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 			   struct sk_buff *skb, struct netlink_callback *cb,
-			   long index_start, long *p_index)
+			   long index_start, long *p_index, bool terse)
 {
 	struct net *net = sock_net(skb->sk);
 	struct tcf_block *block = chain->block;
@@ -2545,7 +2555,7 @@ static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 			if (tcf_fill_node(net, skb, tp, block, q, parent, NULL,
 					  NETLINK_CB(cb->skb).portid,
 					  cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					  RTM_NEWTFILTER, true) <= 0)
+					  RTM_NEWTFILTER, false, true) <= 0)
 				goto errout;
 			cb->args[1] = 1;
 		}
@@ -2561,6 +2571,7 @@ static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 		arg.w.skip = cb->args[1] - 1;
 		arg.w.count = 0;
 		arg.w.cookie = cb->args[2];
+		arg.terse_dump = terse;
 		tp->ops->walk(tp, &arg.w, true);
 		cb->args[2] = arg.w.cookie;
 		cb->args[1] = arg.w.count + 1;
@@ -2574,6 +2585,12 @@ static bool tcf_chain_dump(struct tcf_chain *chain, struct Qdisc *q, u32 parent,
 	return false;
 }
 
+static const u32 tca_dump_flags_allowed = TCA_DUMP_FLAGS_TERSE;
+
+static const struct nla_policy tcf_tfilter_dump_policy[TCA_MAX + 1] = {
+	[TCA_DUMP_FLAGS] = NLA_POLICY_BITFIELD32(tca_dump_flags_allowed),
+};
+
 /* called with RTNL */
 static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -2583,6 +2600,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 	struct Qdisc *q = NULL;
 	struct tcf_block *block;
 	struct tcmsg *tcm = nlmsg_data(cb->nlh);
+	bool terse_dump = false;
 	long index_start;
 	long index;
 	u32 parent;
@@ -2592,10 +2610,17 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 		return skb->len;
 
 	err = nlmsg_parse_deprecated(cb->nlh, sizeof(*tcm), tca, TCA_MAX,
-				     NULL, cb->extack);
+				     tcf_tfilter_dump_policy, cb->extack);
 	if (err)
 		return err;
 
+	if (tca[TCA_DUMP_FLAGS]) {
+		struct nla_bitfield32 flags =
+			nla_get_bitfield32(tca[TCA_DUMP_FLAGS]);
+
+		terse_dump = flags.value & TCA_DUMP_FLAGS_TERSE;
+	}
+
 	if (tcm->tcm_ifindex == TCM_IFINDEX_MAGIC_BLOCK) {
 		block = tcf_block_refcnt_get(net, tcm->tcm_block_index);
 		if (!block)
@@ -2653,7 +2678,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 		    nla_get_u32(tca[TCA_CHAIN]) != chain->index)
 			continue;
 		if (!tcf_chain_dump(chain, q, parent, skb, cb,
-				    index_start, &index)) {
+				    index_start, &index, terse_dump)) {
 			tcf_chain_put(chain);
 			err = -EMSGSIZE;
 			break;
-- 
2.21.0

