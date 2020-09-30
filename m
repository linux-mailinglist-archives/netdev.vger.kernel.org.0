Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8034727E2B8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 09:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgI3HhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 03:37:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39862 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725440AbgI3HhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 03:37:18 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@nvidia.com)
        with SMTP; 30 Sep 2020 10:37:11 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08U7bBBU020971;
        Wed, 30 Sep 2020 10:37:11 +0300
From:   Vlad Buslov <vladbu@nvidia.com>
To:     dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [RESEND PATCH iproute2-next 1/2] tc: skip actions that don't have options attribute when printing
Date:   Wed, 30 Sep 2020 10:36:50 +0300
Message-Id: <20200930073651.31247-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200930073651.31247-1-vladbu@nvidia.com>
References: <20200930073651.31247-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Modify implementations that return error from action_until->print_aopt()
callback to silently skip actions that don't have their corresponding
TCA_ACT_OPTIONS attribute set (some actions already behave like this). This
is necessary to support terse dump mode in following patch in the series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/m_bpf.c        | 2 +-
 tc/m_connmark.c   | 2 +-
 tc/m_csum.c       | 2 +-
 tc/m_ct.c         | 2 +-
 tc/m_ctinfo.c     | 2 +-
 tc/m_gact.c       | 2 +-
 tc/m_ife.c        | 2 +-
 tc/m_ipt.c        | 2 +-
 tc/m_mirred.c     | 2 +-
 tc/m_mpls.c       | 2 +-
 tc/m_nat.c        | 2 +-
 tc/m_pedit.c      | 2 +-
 tc/m_sample.c     | 2 +-
 tc/m_simple.c     | 2 +-
 tc/m_skbedit.c    | 2 +-
 tc/m_skbmod.c     | 2 +-
 tc/m_tunnel_key.c | 2 +-
 tc/m_vlan.c       | 2 +-
 tc/m_xt.c         | 2 +-
 tc/m_xt_old.c     | 2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tc/m_bpf.c b/tc/m_bpf.c
index e8d704b557f9..6b231cb3d7b0 100644
--- a/tc/m_bpf.c
+++ b/tc/m_bpf.c
@@ -162,7 +162,7 @@ static int bpf_print_opt(struct action_util *au, FILE *f, struct rtattr *arg)
 	int d_ok = 0;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_ACT_BPF_MAX, arg);
 
diff --git a/tc/m_connmark.c b/tc/m_connmark.c
index 4b2dc4e25ef8..38546c75b30c 100644
--- a/tc/m_connmark.c
+++ b/tc/m_connmark.c
@@ -111,7 +111,7 @@ static int print_connmark(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_connmark *ci;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CONNMARK_MAX, arg);
 	if (tb[TCA_CONNMARK_PARMS] == NULL) {
diff --git a/tc/m_csum.c b/tc/m_csum.c
index afbee9c8de0f..347e5e90e967 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -167,7 +167,7 @@ print_csum(struct action_util *au, FILE *f, struct rtattr *arg)
 	int uflag_count = 0;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CSUM_MAX, arg);
 
diff --git a/tc/m_ct.c b/tc/m_ct.c
index 70d186e859f4..20cc9c8a3102 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -444,7 +444,7 @@ static int print_ct(struct action_util *au, FILE *f, struct rtattr *arg)
 	int ct_action = 0;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CT_MAX, arg);
 	if (tb[TCA_CT_PARMS] == NULL) {
diff --git a/tc/m_ctinfo.c b/tc/m_ctinfo.c
index e5c1b43642a7..5475fe4d43da 100644
--- a/tc/m_ctinfo.c
+++ b/tc/m_ctinfo.c
@@ -189,7 +189,7 @@ static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_ctinfo *ci;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_CTINFO_MAX, arg);
 	if (!tb[TCA_CTINFO_ACT]) {
diff --git a/tc/m_gact.c b/tc/m_gact.c
index 33f326f823d1..2722e9b805f7 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -172,7 +172,7 @@ print_gact(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct rtattr *tb[TCA_GACT_MAX + 1];
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_GACT_MAX, arg);
 
diff --git a/tc/m_ife.c b/tc/m_ife.c
index 6a85e087ede1..2491ddb861c2 100644
--- a/tc/m_ife.c
+++ b/tc/m_ife.c
@@ -228,7 +228,7 @@ static int print_ife(struct action_util *au, FILE *f, struct rtattr *arg)
 	SPRINT_BUF(b2);
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_IFE_MAX, arg);
 
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
index d2bdf4074a73..7c6351865788 100644
--- a/tc/m_mirred.c
+++ b/tc/m_mirred.c
@@ -282,7 +282,7 @@ print_mirred(struct action_util *au, FILE *f, struct rtattr *arg)
 	const char *dev;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_MIRRED_MAX, arg);
 
diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 3d5d9b25fbf6..1a3bfdda104b 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -198,7 +198,7 @@ static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
 	__u32 val;
 
 	if (!arg)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_MPLS_MAX, arg);
 
diff --git a/tc/m_nat.c b/tc/m_nat.c
index 56e8f47cdefd..63de71014efd 100644
--- a/tc/m_nat.c
+++ b/tc/m_nat.c
@@ -147,7 +147,7 @@ print_nat(struct action_util *au, FILE * f, struct rtattr *arg)
 	int len;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_NAT_MAX, arg);
 
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 51dcf10930e8..ec71fcf9922e 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -746,7 +746,7 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	int err;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_PEDIT_MAX, arg);
 
diff --git a/tc/m_sample.c b/tc/m_sample.c
index 4a30513a6247..e2467a93444a 100644
--- a/tc/m_sample.c
+++ b/tc/m_sample.c
@@ -144,7 +144,7 @@ static int print_sample(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_sample *p;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_SAMPLE_MAX, arg);
 
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
index 9afe2f0c049d..37625c5ab067 100644
--- a/tc/m_skbedit.c
+++ b/tc/m_skbedit.c
@@ -199,7 +199,7 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_skbedit *p;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_SKBEDIT_MAX, arg);
 
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
index bfec90724d72..f700f6d86c82 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -671,7 +671,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_tunnel_key *parm;
 
 	if (!arg)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_TUNNEL_KEY_MAX, arg);
 
diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 1096ba0fbf12..afc9b475ae0a 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -183,7 +183,7 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct tc_vlan *parm;
 
 	if (arg == NULL)
-		return -1;
+		return 0;
 
 	parse_rtattr_nested(tb, TCA_VLAN_MAX, arg);
 
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

