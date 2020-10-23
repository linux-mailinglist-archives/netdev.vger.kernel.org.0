Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE632971C5
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465398AbgJWOzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 10:55:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40839 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S461140AbgJWOzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 10:55:52 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@nvidia.com)
        with SMTP; 23 Oct 2020 17:55:42 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09NEtgp4012350;
        Fri, 23 Oct 2020 17:55:42 +0300
From:   Vlad Buslov <vladbu@nvidia.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        vlad@buslov.dev, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH iproute2-next v4 1/2] tc: skip actions that don't have options attribute when printing
Date:   Fri, 23 Oct 2020 17:55:35 +0300
Message-Id: <20201023145536.27578-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201023145536.27578-1-vladbu@nvidia.com>
References: <20201023145536.27578-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Modify implementations that return error from action_until->print_aopt()
callback to silently skip actions that don't have their corresponding
TCA_ACT_OPTIONS attribute set (some actions already behave like this).
Print action kind before returning from action_until->print_aopt()
callbacks. This is necessary to support terse dump mode in following patch
in the series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
---

Notes:
    Changes V3 -> V4:
    
    - Print action kind in brief mode.

 tc/m_bpf.c        | 4 ++--
 tc/m_connmark.c   | 4 ++--
 tc/m_csum.c       | 4 ++--
 tc/m_ct.c         | 5 ++---
 tc/m_ctinfo.c     | 4 ++--
 tc/m_gact.c       | 4 ++--
 tc/m_ife.c        | 4 ++--
 tc/m_ipt.c        | 2 +-
 tc/m_mirred.c     | 4 ++--
 tc/m_mpls.c       | 4 ++--
 tc/m_nat.c        | 4 ++--
 tc/m_pedit.c      | 4 ++--
 tc/m_sample.c     | 4 ++--
 tc/m_simple.c     | 2 +-
 tc/m_skbedit.c    | 5 ++---
 tc/m_skbmod.c     | 2 +-
 tc/m_tunnel_key.c | 5 ++---
 tc/m_vlan.c       | 4 ++--
 tc/m_xt.c         | 2 +-
 tc/m_xt_old.c     | 2 +-
 20 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/tc/m_bpf.c b/tc/m_bpf.c
index e8d704b557f9..af5ba5ce45dc 100644
--- a/tc/m_bpf.c
+++ b/tc/m_bpf.c
@@ -161,8 +161,9 @@ static int bpf_print_opt(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_act_bpf *parm;
 	int d_ok = 0;
 
+	print_string(PRINT_ANY, "kind", "%s ", "bpf");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_ACT_BPF_MAX, arg);
 
@@ -172,7 +173,6 @@ static int bpf_print_opt(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 
 	parm = RTA_DATA(tb[TCA_ACT_BPF_PARMS]);
-	print_string(PRINT_ANY, "kind", "%s ", "bpf");
 
 	if (tb[TCA_ACT_BPF_NAME])
 		print_string(PRINT_ANY, "bpf_name", "%s ",
diff --git a/tc/m_connmark.c b/tc/m_connmark.c
index 4b2dc4e25ef8..640bba9da18e 100644
--- a/tc/m_connmark.c
+++ b/tc/m_connmark.c
@@ -110,8 +110,9 @@ static int print_connmark(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct rtattr *tb[TCA_CONNMARK_MAX + 1];
 	struct tc_connmark *ci;
 
+	print_string(PRINT_ANY, "kind", "%s ", "connmark");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CONNMARK_MAX, arg);
 	if (tb[TCA_CONNMARK_PARMS] == NULL) {
@@ -121,7 +122,6 @@ static int print_connmark(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	ci = RTA_DATA(tb[TCA_CONNMARK_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "connmark");
 	print_uint(PRINT_ANY, "zone", "zone %u", ci->zone);
 	print_action_control(f, " ", ci->action, "");
 
diff --git a/tc/m_csum.c b/tc/m_csum.c
index afbee9c8de0f..23c5972535c6 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -166,8 +166,9 @@ print_csum(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	int uflag_count = 0;
 
+	print_string(PRINT_ANY, "kind", "%s ", "csum");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CSUM_MAX, arg);
 
@@ -199,7 +200,6 @@ print_csum(struct action_util *au, FILE *f, struct rtattr *arg)
 		uflag_1 = "?empty";
 	}
 
-	print_string(PRINT_ANY, "kind", "%s ", "csum");
 	snprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s",
 		 uflag_1, uflag_2, uflag_3,
 		 uflag_4, uflag_5, uflag_6, uflag_7);
diff --git a/tc/m_ct.c b/tc/m_ct.c
index 70d186e859f4..a02bf0cc1655 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -443,8 +443,9 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_ct *p;
 	int ct_action = 0;
 
+	print_string(PRINT_ANY, "kind", "%s", "ct");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CT_MAX, arg);
 	if (tb[TCA_CT_PARMS] == NULL) {
@@ -454,8 +455,6 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	p = RTA_DATA(tb[TCA_CT_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s", "ct");
-
 	if (tb[TCA_CT_ACTION])
 		ct_action = rta_getattr_u16(tb[TCA_CT_ACTION]);
 	if (ct_action & TCA_CT_ACT_COMMIT) {
diff --git a/tc/m_ctinfo.c b/tc/m_ctinfo.c
index e5c1b43642a7..996a36217dfe 100644
--- a/tc/m_ctinfo.c
+++ b/tc/m_ctinfo.c
@@ -188,8 +188,9 @@ static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
 	unsigned short zone = 0;
 	struct tc_ctinfo *ci;
 
+	print_string(PRINT_ANY, "kind", "%s ", "ctinfo");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CTINFO_MAX, arg);
 	if (!tb[TCA_CTINFO_ACT]) {
@@ -234,7 +235,6 @@ static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
 	    sizeof(__u16))
 		zone = rta_getattr_u16(tb[TCA_CTINFO_ZONE]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "ctinfo");
 	print_hu(PRINT_ANY, "zone", "zone %u", zone);
 	print_action_control(f, " ", ci->action, "");
 
diff --git a/tc/m_gact.c b/tc/m_gact.c
index 33f326f823d1..2ef52cd10559 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -171,8 +171,9 @@ print_gact(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_gact *p = NULL;
 	struct rtattr *tb[TCA_GACT_MAX + 1];
 
+	print_string(PRINT_ANY, "kind", "%s ", "gact");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_GACT_MAX, arg);
 
@@ -182,7 +183,6 @@ print_gact(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	p = RTA_DATA(tb[TCA_GACT_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "gact");
 	print_action_control(f, "action ", p->action, "");
 #ifdef CONFIG_GACT_PROB
 	if (tb[TCA_GACT_PROB] != NULL) {
diff --git a/tc/m_ife.c b/tc/m_ife.c
index 6a85e087ede1..70ab1d754fc5 100644
--- a/tc/m_ife.c
+++ b/tc/m_ife.c
@@ -227,8 +227,9 @@ static int print_ife(struct action_util *au, FILE *f, struct rtattr *arg)
 	int has_optional = 0;
 	SPRINT_BUF(b2);
 
+	print_string(PRINT_ANY, "kind", "%s ", "ife");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_IFE_MAX, arg);
 
@@ -238,7 +239,6 @@ static int print_ife(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	p = RTA_DATA(tb[TCA_IFE_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "ife");
 	print_string(PRINT_ANY, "mode", "%s ",
 		     p->flags & IFE_ENCODE ? "encode" : "decode");
 	print_action_control(f, "action ", p->action, " ");
diff --git a/tc/m_ipt.c b/tc/m_ipt.c
index cc95eab7fefb..046b310e64ab 100644
--- a/tc/m_ipt.c
+++ b/tc/m_ipt.c
@@ -433,7 +433,7 @@ print_ipt(struct action_util *au, FILE * f, struct rtattr *arg)
 	__u32 hook;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	lib_dir = getenv("IPTABLES_LIB_DIR");
 	if (!lib_dir)
diff --git a/tc/m_mirred.c b/tc/m_mirred.c
index d2bdf4074a73..38d8043baa46 100644
--- a/tc/m_mirred.c
+++ b/tc/m_mirred.c
@@ -281,8 +281,9 @@ print_mirred(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct rtattr *tb[TCA_MIRRED_MAX + 1];
 	const char *dev;
 
+	print_string(PRINT_ANY, "kind", "%s ", "mirred");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_MIRRED_MAX, arg);
 
@@ -298,7 +299,6 @@ print_mirred(struct action_util *au, FILE *f, struct rtattr *arg)
 		return -1;
 	}
 
-	print_string(PRINT_ANY, "kind", "%s ", "mirred");
 	print_string(PRINT_FP, NULL, "(%s", mirred_n2a(p->eaction));
 	print_string(PRINT_JSON, "mirred_action", NULL,
 		     mirred_action(p->eaction));
diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index cb8019b1d278..54190aa8b422 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -213,8 +213,9 @@ static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
 	SPRINT_BUF(b1);
 	__u32 val;
 
+	print_string(PRINT_ANY, "kind", "%s ", "mpls");
 	if (!arg)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_MPLS_MAX, arg);
 
@@ -224,7 +225,6 @@ static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	parm = RTA_DATA(tb[TCA_MPLS_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "mpls");
 	print_string(PRINT_ANY, "mpls_action", " %s",
 		     action_names[parm->m_action]);
 
diff --git a/tc/m_nat.c b/tc/m_nat.c
index 56e8f47cdefd..654f9a3bd95e 100644
--- a/tc/m_nat.c
+++ b/tc/m_nat.c
@@ -146,8 +146,9 @@ print_nat(struct action_util *au, FILE * f, struct rtattr *arg)
 	SPRINT_BUF(buf2);
 	int len;
 
+	print_string(PRINT_ANY, "type", " %s ", "nat");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_NAT_MAX, arg);
 
@@ -160,7 +161,6 @@ print_nat(struct action_util *au, FILE * f, struct rtattr *arg)
 	len = ffs(sel->mask);
 	len = len ? 33 - len : 0;
 
-	print_string(PRINT_ANY, "type", " %s ", "nat");
 	print_string(PRINT_ANY, "direction", "%s",
 		     sel->flags & TCA_NAT_FLAG_EGRESS ? "egress" : "ingress");
 
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 51dcf10930e8..24fede4a7cab 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -745,8 +745,9 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct m_pedit_key_ex *keys_ex = NULL;
 	int err;
 
+	print_string(PRINT_ANY, "kind", " %s ", "pedit");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_PEDIT_MAX, arg);
 
@@ -783,7 +784,6 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 		}
 	}
 
-	print_string(PRINT_ANY, "kind", " %s ", "pedit");
 	print_action_control(f, "action ", sel->action, " ");
 	print_uint(PRINT_ANY, "nkeys", "keys %d\n", sel->nkeys);
 	print_uint(PRINT_ANY, "index", " \t index %u", sel->index);
diff --git a/tc/m_sample.c b/tc/m_sample.c
index 4a30513a6247..696d76095ae6 100644
--- a/tc/m_sample.c
+++ b/tc/m_sample.c
@@ -143,8 +143,9 @@ static int print_sample(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct rtattr *tb[TCA_SAMPLE_MAX + 1];
 	struct tc_sample *p;
 
+	print_string(PRINT_ANY, "kind", "%s ", "sample");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_SAMPLE_MAX, arg);
 
@@ -155,7 +156,6 @@ static int print_sample(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	p = RTA_DATA(tb[TCA_SAMPLE_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "sample");
 	print_uint(PRINT_ANY, "rate", "rate 1/%u ",
 		   rta_getattr_u32(tb[TCA_SAMPLE_RATE]));
 	print_uint(PRINT_ANY, "group", "group %u",
diff --git a/tc/m_simple.c b/tc/m_simple.c
index 70897d6b7c13..bc86be27cbcc 100644
--- a/tc/m_simple.c
+++ b/tc/m_simple.c
@@ -166,7 +166,7 @@ static int print_simple(struct action_util *au, FILE *f, struct rtattr *arg)
 	char *simpdata;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_DEF_MAX, arg);
 
diff --git a/tc/m_skbedit.c b/tc/m_skbedit.c
index 9afe2f0c049d..46d92b25582f 100644
--- a/tc/m_skbedit.c
+++ b/tc/m_skbedit.c
@@ -198,8 +198,9 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	__u16 ptype;
 	struct tc_skbedit *p;
 
+	print_string(PRINT_ANY, "kind", "%s ", "skbedit");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_SKBEDIT_MAX, arg);
 
@@ -209,8 +210,6 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	p = RTA_DATA(tb[TCA_SKBEDIT_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "skbedit");
-
 	if (tb[TCA_SKBEDIT_QUEUE_MAPPING] != NULL) {
 		print_uint(PRINT_ANY, "queue_mapping", "queue_mapping %u",
 			   rta_getattr_u16(tb[TCA_SKBEDIT_QUEUE_MAPPING]));
diff --git a/tc/m_skbmod.c b/tc/m_skbmod.c
index d38a5c1921e7..e13d3f16bfcb 100644
--- a/tc/m_skbmod.c
+++ b/tc/m_skbmod.c
@@ -169,7 +169,7 @@ static int print_skbmod(struct action_util *au, FILE *f, struct rtattr *arg)
 	SPRINT_BUF(b2);
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_SKBMOD_MAX, arg);
 
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index bfec90724d72..ca0dff119a49 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -670,8 +670,9 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct rtattr *tb[TCA_TUNNEL_KEY_MAX + 1];
 	struct tc_tunnel_key *parm;
 
+	print_string(PRINT_ANY, "kind", "%s ", "tunnel_key");
 	if (!arg)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_TUNNEL_KEY_MAX, arg);
 
@@ -681,8 +682,6 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	parm = RTA_DATA(tb[TCA_TUNNEL_KEY_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "tunnel_key");
-
 	switch (parm->t_action) {
 	case TCA_TUNNEL_KEY_ACT_RELEASE:
 		print_string(PRINT_ANY, "mode", " %s", "unset");
diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index e6b21330a05a..dbb0912eff22 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -238,8 +238,9 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 	__u16 val;
 	struct tc_vlan *parm;
 
+	print_string(PRINT_ANY, "kind", "%s ", "vlan");
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_VLAN_MAX, arg);
 
@@ -249,7 +250,6 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 	}
 	parm = RTA_DATA(tb[TCA_VLAN_PARMS]);
 
-	print_string(PRINT_ANY, "kind", "%s ", "vlan");
 	print_string(PRINT_ANY, "vlan_action", " %s",
 		     action_names[parm->v_action]);
 
diff --git a/tc/m_xt.c b/tc/m_xt.c
index 487ba25ad391..deaf96a26f75 100644
--- a/tc/m_xt.c
+++ b/tc/m_xt.c
@@ -320,7 +320,7 @@ print_ipt(struct action_util *au, FILE *f, struct rtattr *arg)
 	__u32 hook;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	/* copy tcipt_globals because .opts will be modified by iptables */
 	struct xtables_globals tmp_tcipt_globals = tcipt_globals;
diff --git a/tc/m_xt_old.c b/tc/m_xt_old.c
index 6a4509a9982f..db014898590d 100644
--- a/tc/m_xt_old.c
+++ b/tc/m_xt_old.c
@@ -358,7 +358,7 @@ print_ipt(struct action_util *au, FILE * f, struct rtattr *arg)
 	__u32 hook;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	set_lib_dir();
 
-- 
2.21.0

