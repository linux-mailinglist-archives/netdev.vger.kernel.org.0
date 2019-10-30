Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC87E9D23
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfJ3OJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:23 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55259 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726332AbfJ3OJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:23 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:15 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDg020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v2 6/8] net: sched: extend TCA_ACT space with TCA_ACT_FLAGS
Date:   Wed, 30 Oct 2019 16:09:05 +0200
Message-Id: <20191030140907.18561-7-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend TCA_ACT space with nla_bitfield32 flags. Add
TCA_ACT_FLAGS_NO_PERCPU_STATS as the only allowed flag. Parse the flags in
tcf_action_init_1() and pass resulting value as additional argument to
a_o->init().

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---

Notes:
    Changes V1 -> V2:
    
    - New patch.

 include/net/act_api.h        |  2 +-
 include/uapi/linux/pkt_cls.h |  5 +++++
 net/sched/act_api.c          | 10 ++++++++--
 net/sched/act_bpf.c          |  3 ++-
 net/sched/act_connmark.c     |  2 +-
 net/sched/act_csum.c         |  2 +-
 net/sched/act_ct.c           |  2 +-
 net/sched/act_ctinfo.c       |  2 +-
 net/sched/act_gact.c         |  3 ++-
 net/sched/act_ife.c          |  3 ++-
 net/sched/act_ipt.c          | 10 +++++-----
 net/sched/act_mirred.c       |  2 +-
 net/sched/act_mpls.c         |  3 ++-
 net/sched/act_nat.c          |  2 +-
 net/sched/act_pedit.c        |  3 ++-
 net/sched/act_police.c       |  2 +-
 net/sched/act_sample.c       |  2 +-
 net/sched/act_simple.c       |  3 ++-
 net/sched/act_skbedit.c      |  2 +-
 net/sched/act_skbmod.c       |  2 +-
 net/sched/act_tunnel_key.c   |  2 +-
 net/sched/act_vlan.c         |  3 ++-
 22 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index a56477051dae..85e95c44c7f9 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -94,7 +94,7 @@ struct tc_action_ops {
 	int     (*init)(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **act, int ovr,
 			int bind, bool rtnl_held, struct tcf_proto *tp,
-			struct netlink_ext_ack *extack);
+			u32 flags, struct netlink_ext_ack *extack);
 	int     (*walk)(struct net *, struct sk_buff *,
 			struct netlink_callback *, int,
 			const struct tc_action_ops *,
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index a6aa466fac9e..c6ad22f76ede 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -16,9 +16,14 @@ enum {
 	TCA_ACT_STATS,
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
+	TCA_ACT_FLAGS,
 	__TCA_ACT_MAX
 };
 
+#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
+					 * actions stats.
+					 */
+
 #define TCA_ACT_MAX __TCA_ACT_MAX
 #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
 #define TCA_ACT_MAX_PRIO 32
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f85b88da5216..92c00207d5a1 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -831,12 +831,15 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 	return c;
 }
 
+static const u32 tca_act_flags_allowed = TCA_ACT_FLAGS_NO_PERCPU_STATS;
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_KIND]		= { .type = NLA_STRING },
 	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
+	[TCA_ACT_FLAGS]		= { .type = NLA_BITFIELD32,
+				    .validation_data = &tca_act_flags_allowed },
 };
 
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
@@ -845,6 +848,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    bool rtnl_held,
 				    struct netlink_ext_ack *extack)
 {
+	struct nla_bitfield32 flags = { 0, 0 };
 	struct tc_action *a;
 	struct tc_action_ops *a_o;
 	struct tc_cookie *cookie = NULL;
@@ -876,6 +880,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				goto err_out;
 			}
 		}
+		if (tb[TCA_ACT_FLAGS])
+			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
 	} else {
 		if (strlcpy(act_name, name, IFNAMSIZ) >= IFNAMSIZ) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
@@ -914,10 +920,10 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	/* backward compatibility for policer */
 	if (name == NULL)
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, ovr, bind,
-				rtnl_held, tp, extack);
+				rtnl_held, tp, flags.value, extack);
 	else
 		err = a_o->init(net, nla, est, &a, ovr, bind, rtnl_held,
-				tp, extack);
+				tp, flags.value, extack);
 	if (err < 0)
 		goto err_mod;
 
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 04b7bd4ec751..9e8cb43bc3fe 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -275,7 +275,8 @@ static void tcf_bpf_prog_fill_cfg(const struct tcf_bpf *prog,
 static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **act,
 			int replace, int bind, bool rtnl_held,
-			struct tcf_proto *tp, struct netlink_ext_ack *extack)
+			struct tcf_proto *tp, u32 flags,
+			struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, bpf_net_id);
 	struct nlattr *tb[TCA_ACT_BPF_MAX + 1];
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 2b43cacf82af..2e0ec6f80458 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -94,7 +94,7 @@ static const struct nla_policy connmark_policy[TCA_CONNMARK_MAX + 1] = {
 static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 			     struct nlattr *est, struct tc_action **a,
 			     int ovr, int bind, bool rtnl_held,
-			     struct tcf_proto *tp,
+			     struct tcf_proto *tp, u32 flags,
 			     struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, connmark_net_id);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index bc909cf72257..66e54fada44c 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -43,7 +43,7 @@ static struct tc_action_ops act_csum_ops;
 static int tcf_csum_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a, int ovr,
 			 int bind, bool rtnl_held, struct tcf_proto *tp,
-			 struct netlink_ext_ack *extack)
+			 u32 flags, struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, csum_net_id);
 	struct tcf_csum_params *params_new;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index eabae2227e13..92ec0bdb0547 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -656,7 +656,7 @@ static int tcf_ct_fill_params(struct net *net,
 static int tcf_ct_init(struct net *net, struct nlattr *nla,
 		       struct nlattr *est, struct tc_action **a,
 		       int replace, int bind, bool rtnl_held,
-		       struct tcf_proto *tp,
+		       struct tcf_proto *tp, u32 flags,
 		       struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, ct_net_id);
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 0dbcfd1dca7b..2205b2a934cc 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -153,7 +153,7 @@ static const struct nla_policy ctinfo_policy[TCA_CTINFO_MAX + 1] = {
 static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a,
 			   int ovr, int bind, bool rtnl_held,
-			   struct tcf_proto *tp,
+			   struct tcf_proto *tp, u32 flags,
 			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 221f0c2e26b1..c3dc89160f3a 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -53,7 +53,8 @@ static const struct nla_policy gact_policy[TCA_GACT_MAX + 1] = {
 static int tcf_gact_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
 			 int ovr, int bind, bool rtnl_held,
-			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
+			 struct tcf_proto *tp, u32 flags,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, gact_net_id);
 	struct nlattr *tb[TCA_GACT_MAX + 1];
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 3a31e241c647..f38d2a5fd608 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -465,7 +465,8 @@ static int populate_metalist(struct tcf_ife_info *ife, struct nlattr **tb,
 static int tcf_ife_init(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **a,
 			int ovr, int bind, bool rtnl_held,
-			struct tcf_proto *tp, struct netlink_ext_ack *extack)
+			struct tcf_proto *tp, u32 flags,
+			struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, ife_net_id);
 	struct nlattr *tb[TCA_IFE_MAX + 1];
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 214a03d405cf..fbab70787477 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -95,7 +95,7 @@ static const struct nla_policy ipt_policy[TCA_IPT_MAX + 1] = {
 static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 			  struct nlattr *est, struct tc_action **a,
 			  const struct tc_action_ops *ops, int ovr, int bind,
-			  struct tcf_proto *tp)
+			  struct tcf_proto *tp, u32 flags)
 {
 	struct tc_action_net *tn = net_generic(net, id);
 	struct nlattr *tb[TCA_IPT_MAX + 1];
@@ -205,19 +205,19 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 static int tcf_ipt_init(struct net *net, struct nlattr *nla,
 			struct nlattr *est, struct tc_action **a, int ovr,
 			int bind, bool rtnl_held, struct tcf_proto *tp,
-			struct netlink_ext_ack *extack)
+			u32 flags, struct netlink_ext_ack *extack)
 {
 	return __tcf_ipt_init(net, ipt_net_id, nla, est, a, &act_ipt_ops, ovr,
-			      bind, tp);
+			      bind, tp, flags);
 }
 
 static int tcf_xt_init(struct net *net, struct nlattr *nla,
 		       struct nlattr *est, struct tc_action **a, int ovr,
 		       int bind, bool unlocked, struct tcf_proto *tp,
-		       struct netlink_ext_ack *extack)
+		       u32 flags, struct netlink_ext_ack *extack)
 {
 	return __tcf_ipt_init(net, xt_net_id, nla, est, a, &act_xt_ops, ovr,
-			      bind, tp);
+			      bind, tp, flags);
 }
 
 static int tcf_ipt_act(struct sk_buff *skb, const struct tc_action *a,
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index ae1129aaf3c0..17ed19d6dff4 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -93,7 +93,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a,
 			   int ovr, int bind, bool rtnl_held,
 			   struct tcf_proto *tp,
-			   struct netlink_ext_ack *extack)
+			   u32 flags, struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, mirred_net_id);
 	struct nlattr *tb[TCA_MIRRED_MAX + 1];
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 4cf6c553bb0b..efd7fe07141b 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -131,7 +131,8 @@ static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
 static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
 			 int ovr, int bind, bool rtnl_held,
-			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
+			 struct tcf_proto *tp, u32 flags,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, mpls_net_id);
 	struct nlattr *tb[TCA_MPLS_MAX + 1];
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index ea4c5359e7df..51d631cef92c 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -36,7 +36,7 @@ static const struct nla_policy nat_policy[TCA_NAT_MAX + 1] = {
 static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 			struct tc_action **a, int ovr, int bind,
 			bool rtnl_held,	struct tcf_proto *tp,
-			struct netlink_ext_ack *extack)
+			u32 flags, struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, nat_net_id);
 	struct nlattr *tb[TCA_NAT_MAX + 1];
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cdfaa79382a2..adf1cbd6ae46 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -137,7 +137,8 @@ static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
 static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			  struct nlattr *est, struct tc_action **a,
 			  int ovr, int bind, bool rtnl_held,
-			  struct tcf_proto *tp, struct netlink_ext_ack *extack)
+			  struct tcf_proto *tp, u32 flags,
+			  struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, pedit_net_id);
 	struct nlattr *tb[TCA_PEDIT_MAX + 1];
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 51d34b1a61d5..7437b001f493 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -47,7 +47,7 @@ static const struct nla_policy police_policy[TCA_POLICE_MAX + 1] = {
 static int tcf_police_init(struct net *net, struct nlattr *nla,
 			       struct nlattr *est, struct tc_action **a,
 			       int ovr, int bind, bool rtnl_held,
-			       struct tcf_proto *tp,
+			       struct tcf_proto *tp, u32 flags,
 			       struct netlink_ext_ack *extack)
 {
 	int ret = 0, tcfp_result = TC_ACT_OK, err, size;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 514456a0b9a8..6f9a745c3095 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -36,7 +36,7 @@ static const struct nla_policy sample_policy[TCA_SAMPLE_MAX + 1] = {
 static int tcf_sample_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a, int ovr,
 			   int bind, bool rtnl_held, struct tcf_proto *tp,
-			   struct netlink_ext_ack *extack)
+			   u32 flags, struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, sample_net_id);
 	struct nlattr *tb[TCA_SAMPLE_MAX + 1];
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 6120e56117ca..b18890f3eb67 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -86,7 +86,8 @@ static const struct nla_policy simple_policy[TCA_DEF_MAX + 1] = {
 static int tcf_simp_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
 			 int ovr, int bind, bool rtnl_held,
-			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
+			 struct tcf_proto *tp, u32 flags,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, simp_net_id);
 	struct nlattr *tb[TCA_DEF_MAX + 1];
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 6a8d3337c577..25f3b7b56bea 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -86,7 +86,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 			    struct nlattr *est, struct tc_action **a,
 			    int ovr, int bind, bool rtnl_held,
-			    struct tcf_proto *tp,
+			    struct tcf_proto *tp, u32 act_flags,
 			    struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 888437f97ba6..8e1dc0d6b4b0 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -79,7 +79,7 @@ static const struct nla_policy skbmod_policy[TCA_SKBMOD_MAX + 1] = {
 static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a,
 			   int ovr, int bind, bool rtnl_held,
-			   struct tcf_proto *tp,
+			   struct tcf_proto *tp, u32 flags,
 			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 9ab2d3b4a9fc..b25e5124f571 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -208,7 +208,7 @@ static void tunnel_key_release_params(struct tcf_tunnel_key_params *p)
 static int tunnel_key_init(struct net *net, struct nlattr *nla,
 			   struct nlattr *est, struct tc_action **a,
 			   int ovr, int bind, bool rtnl_held,
-			   struct tcf_proto *tp,
+			   struct tcf_proto *tp, u32 act_flags,
 			   struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index ffa0f431aa84..4b4000338a09 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -102,7 +102,8 @@ static const struct nla_policy vlan_policy[TCA_VLAN_MAX + 1] = {
 static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
 			 int ovr, int bind, bool rtnl_held,
-			 struct tcf_proto *tp, struct netlink_ext_ack *extack)
+			 struct tcf_proto *tp, u32 flags,
+			 struct netlink_ext_ack *extack)
 {
 	struct tc_action_net *tn = net_generic(net, vlan_net_id);
 	struct nlattr *tb[TCA_VLAN_MAX + 1];
-- 
2.21.0

