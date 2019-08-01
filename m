Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CB37DC18
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 15:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbfHANDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 09:03:18 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37587 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726422AbfHANDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 09:03:17 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from dmitrolin@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Aug 2019 16:03:11 +0300
Received: from dev-r-vrt-111.mtr.labs.mlnx. (dev-r-vrt-111.mtr.labs.mlnx [10.212.111.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x71D3Bb5025889;
        Thu, 1 Aug 2019 16:03:11 +0300
From:   dmitrolin@mellanox.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@resnulli.us, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH] net: sched: use temporary variable for actions indexes
Date:   Thu,  1 Aug 2019 13:02:51 +0000
Message-Id: <1564664571-31508-1-git-send-email-dmitrolin@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Currently init call of all actions (except ipt) init their 'parm'
structure as a direct pointer to nla data in skb. This leads to race
condition when some of the filter actions were initialized successfully
(and were assigned with idr action index that was written directly
into nla data), but then were deleted and retried (due to following
action module missing or classifier-initiated retry), in which case
action init code tries to insert action to idr with index that was
assigned on previous iteration. During retry the index can be reused
by another action that was inserted concurrently, which causes
unintended action sharing between filters.
To fix described race condition, save action idr index to temporary
stack-allocated variable instead on nla data.

Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 net/sched/act_bpf.c        |  9 +++++----
 net/sched/act_connmark.c   |  9 +++++----
 net/sched/act_csum.c       |  9 +++++----
 net/sched/act_ct.c         |  9 +++++----
 net/sched/act_ctinfo.c     |  9 +++++----
 net/sched/act_gact.c       |  8 +++++---
 net/sched/act_ife.c        |  8 +++++---
 net/sched/act_mirred.c     | 13 +++++++------
 net/sched/act_mpls.c       |  8 +++++---
 net/sched/act_nat.c        |  9 +++++----
 net/sched/act_pedit.c      | 10 ++++++----
 net/sched/act_police.c     |  8 +++++---
 net/sched/act_sample.c     | 10 +++++-----
 net/sched/act_simple.c     | 10 ++++++----
 net/sched/act_skbedit.c    | 11 ++++++-----
 net/sched/act_skbmod.c     | 11 ++++++-----
 net/sched/act_tunnel_key.c |  8 +++++---
 net/sched/act_vlan.c       | 16 +++++++++-------
 18 files changed, 100 insertions(+), 75 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 8126b26..fd1f7e7 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -285,6 +285,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	struct tcf_bpf *prog;
 	bool is_bpf, is_ebpf;
 	int ret, res = 0;
+	u32 index;
 
 	if (!nla)
 		return -EINVAL;
@@ -298,13 +299,13 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_ACT_BPF_PARMS]);
-
-	ret = tcf_idr_check_alloc(tn, &parm->index, act, bind);
+	index = parm->index;
+	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
-		ret = tcf_idr_create(tn, parm->index, est, act,
+		ret = tcf_idr_create(tn, index, est, act,
 				     &act_bpf_ops, bind, true);
 		if (ret < 0) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index ce36b0f..32ac04d 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -103,6 +103,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	struct tcf_connmark_info *ci;
 	struct tc_connmark *parm;
 	int ret = 0, err;
+	u32 index;
 
 	if (!nla)
 		return -EINVAL;
@@ -116,13 +117,13 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_CONNMARK_PARMS]);
-
-	ret = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_connmark_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 621fb22..9b92882 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -52,6 +52,7 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	struct tc_csum *parm;
 	struct tcf_csum *p;
 	int ret = 0, err;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -64,13 +65,13 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	if (tb[TCA_CSUM_PARMS] == NULL)
 		return -EINVAL;
 	parm = nla_data(tb[TCA_CSUM_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_csum_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b501ce0..33a1a74 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -666,6 +666,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	struct tc_ct *parm;
 	struct tcf_ct *c;
 	int err, res = 0;
+	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Ct requires attributes to be passed");
@@ -681,16 +682,16 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 	parm = nla_data(tb[TCA_CT_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 
 	if (!err) {
-		err = tcf_idr_create(tn, parm->index, est, a,
+		err = tcf_idr_create(tn, index, est, a,
 				     &act_ct_ops, bind, true);
 		if (err) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return err;
 		}
 		res = ACT_P_CREATED;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 10eb2bb..06ef74b 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -157,10 +157,10 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
+	u32 dscpmask = 0, dscpstatemask, index;
 	struct nlattr *tb[TCA_CTINFO_MAX + 1];
 	struct tcf_ctinfo_params *cp_new;
 	struct tcf_chain *goto_ch = NULL;
-	u32 dscpmask = 0, dscpstatemask;
 	struct tc_ctinfo *actparm;
 	struct tcf_ctinfo *ci;
 	u8 dscpmaskshift;
@@ -206,12 +206,13 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	}
 
 	/* done the validation:now to the actual action allocation */
-	err = tcf_idr_check_alloc(tn, &actparm->index, a, bind);
+	index = actparm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, actparm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_ctinfo_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, actparm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index b2380c5..8f0140c 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -61,6 +61,7 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	struct tc_gact *parm;
 	struct tcf_gact *gact;
 	int ret = 0;
+	u32 index;
 	int err;
 #ifdef CONFIG_GACT_PROB
 	struct tc_gact_p *p_parm = NULL;
@@ -77,6 +78,7 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	if (tb[TCA_GACT_PARMS] == NULL)
 		return -EINVAL;
 	parm = nla_data(tb[TCA_GACT_PARMS]);
+	index = parm->index;
 
 #ifndef CONFIG_GACT_PROB
 	if (tb[TCA_GACT_PROB] != NULL)
@@ -94,12 +96,12 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	}
 #endif
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_gact_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 41d5398..bd1a541 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -479,6 +479,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	u8 *saddr = NULL;
 	bool exists = false;
 	int ret = 0;
+	u32 index;
 	int err;
 
 	err = nla_parse_nested_deprecated(tb, TCA_IFE_MAX, nla, ife_policy,
@@ -502,7 +503,8 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	if (!p)
 		return -ENOMEM;
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0) {
 		kfree(p);
 		return err;
@@ -514,10 +516,10 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a, &act_ife_ops,
+		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
 				     bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			kfree(p);
 			return ret;
 		}
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 055faa2..be3f88d 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -104,6 +104,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	struct net_device *dev;
 	bool exists = false;
 	int ret, err;
+	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Mirred requires attributes to be passed");
@@ -118,8 +119,8 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 	parm = nla_data(tb[TCA_MIRRED_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -136,21 +137,21 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		NL_SET_ERR_MSG_MOD(extack, "Unknown mirred option");
 		return -EINVAL;
 	}
 
 	if (!exists) {
 		if (!parm->ifindex) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			NL_SET_ERR_MSG_MOD(extack, "Specified device does not exist");
 			return -EINVAL;
 		}
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_mirred_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index ca2597c..0f299e3 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -138,6 +138,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	struct tcf_mpls *m;
 	int ret = 0, err;
 	u8 mpls_ttl = 0;
+	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Missing netlink attributes");
@@ -153,6 +154,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 	parm = nla_data(tb[TCA_MPLS_PARMS]);
+	index = parm->index;
 
 	/* Verify parameters against action type. */
 	switch (parm->m_action) {
@@ -209,7 +211,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -217,10 +219,10 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 		return 0;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_mpls_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 45923eb..7b858c1 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -44,6 +44,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	struct tc_nat *parm;
 	int ret = 0, err;
 	struct tcf_nat *p;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -56,13 +57,13 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	if (tb[TCA_NAT_PARMS] == NULL)
 		return -EINVAL;
 	parm = nla_data(tb[TCA_NAT_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_nat_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 45e9d6b..17360c6 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -149,6 +149,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	struct tcf_pedit *p;
 	int ret = 0, err;
 	int ksize;
+	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Pedit requires attributes to be passed");
@@ -179,18 +180,19 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	if (IS_ERR(keys_ex))
 		return PTR_ERR(keys_ex);
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		if (!parm->nkeys) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
 			ret = -EINVAL;
 			goto out_free;
 		}
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_pedit_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			goto out_free;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index a065f62..49cec3e 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -57,6 +57,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	struct tc_action_net *tn = net_generic(net, police_net_id);
 	struct tcf_police_params *new;
 	bool exists = false;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -73,7 +74,8 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_POLICE_TBF]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -81,10 +83,10 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 		return 0;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, NULL, a,
+		ret = tcf_idr_create(tn, index, NULL, a,
 				     &act_police_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 274d7a0..595308d 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -41,8 +41,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 	struct tc_action_net *tn = net_generic(net, sample_net_id);
 	struct nlattr *tb[TCA_SAMPLE_MAX + 1];
 	struct psample_group *psample_group;
+	u32 psample_group_num, rate, index;
 	struct tcf_chain *goto_ch = NULL;
-	u32 psample_group_num, rate;
 	struct tc_sample *parm;
 	struct tcf_sample *s;
 	bool exists = false;
@@ -59,8 +59,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -68,10 +68,10 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		return 0;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_sample_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 		ret = ACT_P_CREATED;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index f28ddba..33aefa2 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -95,6 +95,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 	struct tcf_defact *d;
 	bool exists = false;
 	int ret = 0, err;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -108,7 +109,8 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_DEF_PARMS]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -119,15 +121,15 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_simp_ops, bind, false);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 215a067..b100870 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -99,6 +99,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	u16 *queue_mapping = NULL, *ptype = NULL;
 	bool exists = false;
 	int ret = 0, err;
+	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -146,8 +147,8 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	parm = nla_data(tb[TCA_SKBEDIT_PARMS]);
-
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -158,15 +159,15 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_skbedit_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 4f07706..7da3518 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -87,12 +87,12 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	struct tcf_skbmod_params *p, *p_old;
 	struct tcf_chain *goto_ch = NULL;
 	struct tc_skbmod *parm;
+	u32 lflags = 0, index;
 	struct tcf_skbmod *d;
 	bool exists = false;
 	u8 *daddr = NULL;
 	u8 *saddr = NULL;
 	u16 eth_type = 0;
-	u32 lflags = 0;
 	int ret = 0, err;
 
 	if (!nla)
@@ -122,10 +122,11 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	}
 
 	parm = nla_data(tb[TCA_SKBMOD_PARMS]);
+	index = parm->index;
 	if (parm->flags & SKBMOD_F_SWAPMAC)
 		lflags = SKBMOD_F_SWAPMAC;
 
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -136,15 +137,15 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_skbmod_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 10dffda..6d0debd 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -225,6 +225,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	__be16 flags = 0;
 	u8 tos, ttl;
 	int ret = 0;
+	u32 index;
 	int err;
 
 	if (!nla) {
@@ -245,7 +246,8 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	}
 
 	parm = nla_data(tb[TCA_TUNNEL_KEY_PARMS]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -345,7 +347,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_tunnel_key_ops, bind, true);
 		if (ret) {
 			NL_SET_ERR_MSG(extack, "Cannot create TC IDR");
@@ -403,7 +405,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	if (exists)
 		tcf_idr_release(*a, bind);
 	else
-		tcf_idr_cleanup(tn, parm->index);
+		tcf_idr_cleanup(tn, index);
 	return ret;
 }
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 9269d35..984b05a 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -116,6 +116,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	u8 push_prio = 0;
 	bool exists = false;
 	int ret = 0, err;
+	u32 index;
 
 	if (!nla)
 		return -EINVAL;
@@ -128,7 +129,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	if (!tb[TCA_VLAN_PARMS])
 		return -EINVAL;
 	parm = nla_data(tb[TCA_VLAN_PARMS]);
-	err = tcf_idr_check_alloc(tn, &parm->index, a, bind);
+	index = parm->index;
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
 		return err;
 	exists = err;
@@ -144,7 +146,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			if (exists)
 				tcf_idr_release(*a, bind);
 			else
-				tcf_idr_cleanup(tn, parm->index);
+				tcf_idr_cleanup(tn, index);
 			return -EINVAL;
 		}
 		push_vid = nla_get_u16(tb[TCA_VLAN_PUSH_VLAN_ID]);
@@ -152,7 +154,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			if (exists)
 				tcf_idr_release(*a, bind);
 			else
-				tcf_idr_cleanup(tn, parm->index);
+				tcf_idr_cleanup(tn, index);
 			return -ERANGE;
 		}
 
@@ -166,7 +168,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 				if (exists)
 					tcf_idr_release(*a, bind);
 				else
-					tcf_idr_cleanup(tn, parm->index);
+					tcf_idr_cleanup(tn, index);
 				return -EPROTONOSUPPORT;
 			}
 		} else {
@@ -180,16 +182,16 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 		if (exists)
 			tcf_idr_release(*a, bind);
 		else
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 		return -EINVAL;
 	}
 	action = parm->v_action;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, parm->index, est, a,
+		ret = tcf_idr_create(tn, index, est, a,
 				     &act_vlan_ops, bind, true);
 		if (ret) {
-			tcf_idr_cleanup(tn, parm->index);
+			tcf_idr_cleanup(tn, index);
 			return ret;
 		}
 
-- 
1.8.3.1

