Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40843E9D28
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfJ3OJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55261 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726297AbfJ3OJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:22 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:16 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDh020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v2 7/8] net: sched: update action implementations to support flags
Date:   Wed, 30 Oct 2019 16:09:06 +0200
Message-Id: <20191030140907.18561-8-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend struct tc_action with new "tcfa_flags" field. Set the field in
tcf_idr_create() function and provide new helper
tcf_idr_create_from_flags() that derives 'cpustats' boolean from flags
value. Update individual hardware-offloaded actions init() to pass their
"flags" argument to new helper in order to skip percpu stats allocation
when user requested it through flags.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes V1 -> V2:
    
    - New patch.

 include/net/act_api.h      |  7 ++++++-
 net/sched/act_api.c        | 22 +++++++++++++++++++++-
 net/sched/act_bpf.c        |  2 +-
 net/sched/act_connmark.c   |  2 +-
 net/sched/act_csum.c       |  4 ++--
 net/sched/act_ct.c         |  4 ++--
 net/sched/act_ctinfo.c     |  2 +-
 net/sched/act_gact.c       |  4 ++--
 net/sched/act_ife.c        |  2 +-
 net/sched/act_ipt.c        |  2 +-
 net/sched/act_mirred.c     |  4 ++--
 net/sched/act_mpls.c       |  2 +-
 net/sched/act_nat.c        |  2 +-
 net/sched/act_pedit.c      |  2 +-
 net/sched/act_police.c     |  2 +-
 net/sched/act_sample.c     |  2 +-
 net/sched/act_simple.c     |  2 +-
 net/sched/act_skbedit.c    |  2 +-
 net/sched/act_skbmod.c     |  2 +-
 net/sched/act_tunnel_key.c |  5 +++--
 net/sched/act_vlan.c       |  4 ++--
 21 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 85e95c44c7f9..0495bdc034d2 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -41,6 +41,7 @@ struct tc_action {
 	struct gnet_stats_queue __percpu *cpu_qstats;
 	struct tc_cookie	__rcu *act_cookie;
 	struct tcf_chain	__rcu *goto_chain;
+	u32			tcfa_flags;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
@@ -154,7 +155,11 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 int tcf_idr_search(struct tc_action_net *tn, struct tc_action **a, u32 index);
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
-		   int bind, bool cpustats);
+		   int bind, bool cpustats, u32 flags);
+int tcf_idr_create_from_flags(struct tc_action_net *tn, u32 index,
+			      struct nlattr *est, struct tc_action **a,
+			      const struct tc_action_ops *ops, int bind,
+			      u32 flags);
 void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a);
 
 void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 92c00207d5a1..6284c552e943 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -399,7 +399,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 
 int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 		   struct tc_action **a, const struct tc_action_ops *ops,
-		   int bind, bool cpustats)
+		   int bind, bool cpustats, u32 flags)
 {
 	struct tc_action *p = kzalloc(ops->size, GFP_KERNEL);
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
@@ -427,6 +427,7 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 	p->tcfa_tm.install = jiffies;
 	p->tcfa_tm.lastuse = jiffies;
 	p->tcfa_tm.firstuse = 0;
+	p->tcfa_flags = flags;
 	if (est) {
 		err = gen_new_estimator(&p->tcfa_bstats, p->cpu_bstats,
 					&p->tcfa_rate_est,
@@ -451,6 +452,17 @@ int tcf_idr_create(struct tc_action_net *tn, u32 index, struct nlattr *est,
 }
 EXPORT_SYMBOL(tcf_idr_create);
 
+int tcf_idr_create_from_flags(struct tc_action_net *tn, u32 index,
+			      struct nlattr *est, struct tc_action **a,
+			      const struct tc_action_ops *ops, int bind,
+			      u32 flags)
+{
+	/* Set cpustats according to actions flags. */
+	return tcf_idr_create(tn, index, est, a, ops, bind,
+			      !(flags & TCA_ACT_FLAGS_NO_PERCPU_STATS), flags);
+}
+EXPORT_SYMBOL(tcf_idr_create_from_flags);
+
 void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a)
 {
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
@@ -773,6 +785,14 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	}
 	rcu_read_unlock();
 
+	if (a->tcfa_flags) {
+		struct nla_bitfield32 flags = { a->tcfa_flags,
+						a->tcfa_flags, };
+
+		if (nla_put(skb, TCA_ACT_FLAGS, sizeof(flags), &flags))
+			goto nla_put_failure;
+	}
+
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 9e8cb43bc3fe..46f47e58b3be 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -304,7 +304,7 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, act, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, act,
-				     &act_bpf_ops, bind, true);
+				     &act_bpf_ops, bind, true, 0);
 		if (ret < 0) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 2e0ec6f80458..43a243081e7d 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -121,7 +121,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	ret = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!ret) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_connmark_ops, bind, false);
+				     &act_connmark_ops, bind, false, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 66e54fada44c..16e67e1c1db1 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -68,8 +68,8 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_csum_ops, bind, true);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_csum_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 92ec0bdb0547..68d6af56b243 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -688,8 +688,8 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 		return err;
 
 	if (!err) {
-		err = tcf_idr_create(tn, index, est, a,
-				     &act_ct_ops, bind, true);
+		err = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_ct_ops, bind, flags);
 		if (err) {
 			tcf_idr_cleanup(tn, index);
 			return err;
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 2205b2a934cc..b1e601007242 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -210,7 +210,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false);
+				     &act_ctinfo_ops, bind, false, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index c3dc89160f3a..416065772719 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -99,8 +99,8 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gact_ops, bind, true);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_gact_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index f38d2a5fd608..d562c88cccbe 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -523,7 +523,7 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, &act_ife_ops,
-				     bind, true);
+				     bind, true, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			kfree(p);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index fbab70787477..400a2cfe8452 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -144,7 +144,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a, ops, bind,
-				     false);
+				     false, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 17ed19d6dff4..b6e1b5bbb4da 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -148,8 +148,8 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			NL_SET_ERR_MSG_MOD(extack, "Specified device does not exist");
 			return -EINVAL;
 		}
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mirred_ops, bind, true);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_mirred_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index efd7fe07141b..4d8c822b6aca 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -225,7 +225,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true);
+				     &act_mpls_ops, bind, true, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 51d631cef92c..88a1b79a1848 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -61,7 +61,7 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_nat_ops, bind, false);
+				     &act_nat_ops, bind, false, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index adf1cbd6ae46..d5eff6ac17a9 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -191,7 +191,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			goto out_free;
 		}
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false);
+				     &act_pedit_ops, bind, false, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			goto out_free;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 7437b001f493..d96271590268 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -87,7 +87,7 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, NULL, a,
-				     &act_police_ops, bind, true);
+				     &act_police_ops, bind, true, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 6f9a745c3095..29b23bfaf10d 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -69,7 +69,7 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_sample_ops, bind, true);
+				     &act_sample_ops, bind, true, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index b18890f3eb67..97639b259cd7 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -128,7 +128,7 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_simp_ops, bind, false);
+				     &act_simp_ops, bind, false, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 25f3b7b56bea..5f7ca7f89ca2 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -165,7 +165,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbedit_ops, bind, true);
+				     &act_skbedit_ops, bind, true, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 8e1dc0d6b4b0..39e6d94cfafb 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -143,7 +143,7 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_skbmod_ops, bind, true);
+				     &act_skbmod_ops, bind, true, 0);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index b25e5124f571..cb34e5d57aaa 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -347,8 +347,9 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	}
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_tunnel_key_ops, bind, true);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_tunnel_key_ops, bind,
+						act_flags);
 		if (ret) {
 			NL_SET_ERR_MSG(extack, "Cannot create TC IDR");
 			goto release_tun_meta;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 4b4000338a09..b6939abc61eb 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -189,8 +189,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	action = parm->v_action;
 
 	if (!exists) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_vlan_ops, bind, true);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_vlan_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.21.0

