Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DE6E063F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbfJVOTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:19:13 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33580 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726955AbfJVOS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:18:59 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqau023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 06/13] net: sched: add action fast initialization flag
Date:   Tue, 22 Oct 2019 17:17:57 +0300
Message-Id: <20191022141804.27639-7-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new tc action "tcfa_flags" field and define first flag value
TCA_ACT_FLAGS_FAST_INIT that will be used for following patches in the
series to skip percpu allocator usage in specific actions. Implement helper
function to check for fast initialization flags bit. Provide default
allowed flags value to be used for netlink validation.

Refactor tcf_idr_create() to accept additional 'flags' argument instead of
'cpustats'. Don't allocate percpu counters, if TCA_ACT_FLAGS_FAST_INIT flag
is set. Always pass TCA_ACT_FLAGS_FAST_INIT flag to tcf_idr_create() from
actions that don't use percpu-allocated counters.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h        | 10 +++++++++-
 include/net/pkt_cls.h        |  3 +++
 include/uapi/linux/pkt_cls.h |  8 ++++++++
 net/sched/act_api.c          |  5 +++--
 net/sched/act_bpf.c          |  2 +-
 net/sched/act_connmark.c     |  3 ++-
 net/sched/act_csum.c         |  2 +-
 net/sched/act_ct.c           |  2 +-
 net/sched/act_ctinfo.c       |  3 ++-
 net/sched/act_gact.c         |  2 +-
 net/sched/act_ife.c          |  2 +-
 net/sched/act_ipt.c          |  8 ++++----
 net/sched/act_mirred.c       |  2 +-
 net/sched/act_mpls.c         |  2 +-
 net/sched/act_nat.c          |  3 ++-
 net/sched/act_pedit.c        |  3 ++-
 net/sched/act_police.c       |  2 +-
 net/sched/act_sample.c       |  2 +-
 net/sched/act_simple.c       |  3 ++-
 net/sched/act_skbedit.c      |  2 +-
 net/sched/act_skbmod.c       |  2 +-
 net/sched/act_tunnel_key.c   |  2 +-
 net/sched/act_vlan.c         |  2 +-
 23 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index a56477051dae..d6c3e283f7e6 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -27,6 +27,7 @@ struct tc_action {
 	struct tcf_idrinfo		*idrinfo;
 
 	u32				tcfa_index;
+	u32				tcfa_flags;
 	refcount_t			tcfa_refcnt;
 	atomic_t			tcfa_bindcnt;
 	int				tcfa_action;
@@ -43,6 +44,7 @@ struct tc_action {
 	struct tcf_chain	__rcu *goto_chain;
 };
 #define tcf_index	common.tcfa_index
+#define tcf_flags	common.tcfa_flags
 #define tcf_refcnt	common.tcfa_refcnt
 #define tcf_bindcnt	common.tcfa_bindcnt
 #define tcf_action	common.tcfa_action
@@ -154,7 +156,7 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index);
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
-		   int bind, bool cpustats);
+		   int bind, u32 flags);
 void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a);
 
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
@@ -230,6 +232,12 @@ int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct netlink_ext_ack *newchain);
 struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *newchain);
+
+static inline bool tc_act_fast_init(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_FAST_INIT) ? true : false;
+}
+
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e553fc80eb23..53c118dcfeca 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -11,6 +11,9 @@
 /* TC action not accessible from user space */
 #define TC_ACT_CONSUMED		(TC_ACT_VALUE_MAX + 1)
 
+/* Default allowed action flags. */
+static const u32 tca_flags_allowed = TCA_ACT_FLAGS_FAST_INIT;
+
 /* Basic packet classifier frontend definitions. */
 
 struct tcf_walker {
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a6aa466fac9e..56664854a5ab 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -113,6 +113,14 @@ enum tca_id {
 
 #define TCA_ID_MAX __TCA_ID_MAX
 
+/* act flags definitions */
+#define TCA_ACT_FLAGS_FAST_INIT	(1 << 0) /* prefer action update rate
+					  * (slow-path), even at the cost of
+					  * reduced software data-path
+					  * performance (intended to be used for
+					  * hardware-offloaded actions)
+					  */
+
 struct tc_police {
 	__u32			index;
 	int			action;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f85b88da5216..948e458217cf 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -399,7 +399,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
-		   int bind, bool cpustats)
+		   int bind, u32 flags)
 {
 	struct tc_action *p = kzalloc(ops->size, GFP_KERNEL);
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
@@ -411,7 +411,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	if (bind)
 		atomic_set(&p->tcfa_bindcnt, 1);
 
-	if (cpustats) {
+	if (!tc_act_fast_init(flags)) {
 		p->cpu_bstats = netdev_alloc_pcpu_stats(struct gnet_stats_basic_cpu);
 		if (!p->cpu_bstats)
 			goto err1;
@@ -437,6 +437,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 
 	p->idrinfo = idrinfo;
 	p->ops = ops;
+	p->tcfa_flags = flags;
 	*a = p;
 	return 0;
 err4:
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 04b7bd4ec751..250f995a06d1 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -303,7 +303,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, act,
-				     &act_bpf_ops, bind, true);
+				     &act_bpf_ops, bind, 0);
 		if (ret < 0) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 2b43cacf82af..3222c7caeaba 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -121,7 +121,8 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false);
+				     &act_connmark_ops, bind,
+				     TCA_ACT_FLAGS_FAST_INIT);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index bc909cf72257..d2e6d8d77d9a 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -69,7 +69,7 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_csum_ops, bind, true);
+				     &act_csum_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index eabae2227e13..5dc8de42e1d4 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -689,7 +689,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 
 	if (!err) {
 		err = tcf_idr_create(tn, index, est, a,
-				     &act_ct_ops, bind, true);
+				     &act_ct_ops, bind, 0);
 		if (err) {
 			tcf_idr_cleanup(tn, index);
 			return err;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 0dbcfd1dca7b..1d80ae4eecc4 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -210,7 +210,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false);
+				     &act_ctinfo_ops, bind,
+				     TCA_ACT_FLAGS_FAST_INIT);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 221f0c2e26b1..67654aaa37a3 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -99,7 +99,7 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gact_ops, bind, true);
+				     &act_gact_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 3a31e241c647..b4de0addea04 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -522,7 +522,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
-				     bind, true);
+				     bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			kfree(p);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 214a03d405cf..dc6a8c0d0905 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -95,7 +95,7 @@ static const struct nla_policy ipt_policy[TCA_IPT_MAX + 1] = {
 static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 			  struct nlattr *est, struct tc_action **a,
 			  const struct tc_action_ops *ops, int ovr, int bind,
-			  struct tcf_proto *tp)
+			  struct tcf_proto *tp, struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, id);
 	struct nlattr *tb[TCA_IPT_MAX + 1];
@@ -144,7 +144,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, ops, bind,
-				     false);
+				     TCA_ACT_FLAGS_FAST_INIT);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
@@ -208,7 +208,7 @@ static int tcf_ipt_init(struct net *net, struct nlattr *nla,
 			struct netlink_ext_ack *extack)
 {
 	return __tcf_ipt_init(net, ipt_net_id, nla, est, a, &act_ipt_ops, ovr,
-			      bind, tp);
+			      bind, tp, extack);
 }
 
 static int tcf_xt_init(struct net *net, struct nlattr *nla,
@@ -217,7 +217,7 @@ static int tcf_xt_init(struct net *net, struct nlattr *nla,
 		       struct netlink_ext_ack *extack)
 {
 	return __tcf_ipt_init(net, xt_net_id, nla, est, a, &act_xt_ops, ovr,
-			      bind, tp);
+			      bind, tp, extack);
 }
 
 static int tcf_ipt_act(struct sk_buff *skb, const struct tc_action *a,
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index ae1129aaf3c0..f5582236bcee 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -149,7 +149,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			return -EINVAL;
 		}
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mirred_ops, bind, true);
+				     &act_mirred_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 4cf6c553bb0b..91083075e148 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -224,7 +224,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true);
+				     &act_mpls_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index ea4c5359e7df..d66fed95a7d4 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -61,7 +61,8 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_nat_ops, bind, false);
+				     &act_nat_ops, bind,
+				     TCA_ACT_FLAGS_FAST_INIT);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cdfaa79382a2..65b0c7428341 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -190,7 +190,8 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			goto out_free;
 		}
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false);
+				     &act_pedit_ops, bind,
+				     TCA_ACT_FLAGS_FAST_INIT);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			goto out_free;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 51d34b1a61d5..46528dcd907c 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -87,7 +87,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, NULL, a,
-				     &act_police_ops, bind, true);
+				     &act_police_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 514456a0b9a8..ee7bb68cb919 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -69,7 +69,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_sample_ops, bind, true);
+				     &act_sample_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 6120e56117ca..ff6ab2708978 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -127,7 +127,8 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_simp_ops, bind, false);
+				     &act_simp_ops, bind,
+				     TCA_ACT_FLAGS_FAST_INIT);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 6a8d3337c577..a1ac65116391 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -165,7 +165,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbedit_ops, bind, true);
+				     &act_skbedit_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 888437f97ba6..1dfe42503835 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -143,7 +143,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbmod_ops, bind, true);
+				     &act_skbmod_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 9ab2d3b4a9fc..b517bcf9152c 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -348,7 +348,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_tunnel_key_ops, bind, true);
+				     &act_tunnel_key_ops, bind, 0);
 		if (ret) {
 			NL_SET_ERR_MSG(extack, "Cannot create TC IDR");
 			goto release_tun_meta;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index ffa0f431aa84..f7aff66e5026 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -189,7 +189,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_vlan_ops, bind, true);
+				     &act_vlan_ops, bind, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.21.0

