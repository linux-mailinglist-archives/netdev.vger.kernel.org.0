Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13BA63D40
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfGIVZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:25:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44222 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIVZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:25:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so70199pgl.11
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 14:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NlzKSshtV1QiWo4NMDzkH4rpZYHmATzkQtj2hRHNpxI=;
        b=AiuAMeXYbqSvtw4kcsch20c+nMmWpP1bNKlLzvfkHDZiOptmhJkWzZKVnxTbalSZZf
         HvFpvWl6Uyidjd9icULpFrxg54IgXmfqAZxsxgqaz+VxTjX9raLum+cT2W3RjLqJr6wl
         HvuR4/oqUF0gQmk4mpmIVomP1P2BK8EaEGcU7Kg9CsBkx+T37iSyTlTfSwwwDJ1Bnc1F
         w8mVp/0SFOoK0MHqJOEiH2oThLQZcnjJemascXu4RNgow/JiXaK2Nh2pdnYlXYwPLyjF
         IHqQMAugt3R5jt7QWTf/jvRAUHqtDtddoKUMG5/kJHrm7pEMBPI2DLfQsfeZGFmvg5Bu
         iZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NlzKSshtV1QiWo4NMDzkH4rpZYHmATzkQtj2hRHNpxI=;
        b=rt8bNC7rx3jiL+gzRBCGiJlggfYf2RcOkAgwWiR0ie5koBG5YEpv7VgIDesZ4W7VgU
         CZY3AfiZ7VwWdrzofoIUUeL30LTggdl+IfkGDuHNmW3wRlpdy6dSIlGP6zSWoU0PshOC
         7lkzjU+RjmWnOuIAhTdSXS+hAgMXNfbgZg9usD1nJoxqm+cCrzXXOI9NkakcEYw47M+X
         H9pP7NKlFYCeycyvKWvtp5WUlImDBGx9Hnr2KWDEiUzXhzpWOXPS6Kqj8keozz08zLE0
         PK6QqEFl9AduQ+DZym/wwMMZOfZMZjdV4jpEEsDdO81yOCzOVNTcI6PBAHTeQD7x5cg9
         WByg==
X-Gm-Message-State: APjAAAWlULySETTL/YI2J2Oy6cSaLaHmdcJ4UXlb2qK4+k8Z1wMWEb4q
        NhKqr32rSoa1oWy/cTKsThfXn5z1QwA=
X-Google-Smtp-Source: APXvYqxCwR8+UcmdMW3kdqj9Dh6dZvo51aV214B4lnUBu7I3/3easXGLJQ6vbbZNzLgKOgoUZSMayg==
X-Received: by 2002:a17:90a:1785:: with SMTP id q5mr2406577pja.106.1562707522509;
        Tue, 09 Jul 2019 14:25:22 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f6sm25408pga.50.2019.07.09.14.25.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 14:25:21 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] tc: print all error messages to stderr
Date:   Tue,  9 Jul 2019 14:25:14 -0700
Message-Id: <20190709212514.26577-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many tc modules were printing error messages to stdout.
This is problematic if using JSON or other output formats.
Change all these places to use fprintf(stderr, ...) instead.

Also, remove unnecessary initialization and places
where else is used after error return.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/m_bpf.c        |  2 +-
 tc/m_connmark.c   |  2 +-
 tc/m_csum.c       |  2 +-
 tc/m_gact.c       |  2 +-
 tc/m_ife.c        |  4 +--
 tc/m_ipt.c        | 86 +++++++++++++++++++++++------------------------
 tc/m_mirred.c     |  2 +-
 tc/m_nat.c        |  2 +-
 tc/m_pedit.c      |  2 +-
 tc/m_sample.c     |  2 +-
 tc/m_simple.c     |  4 +--
 tc/m_skbedit.c    |  4 +--
 tc/m_skbmod.c     |  4 +--
 tc/m_tunnel_key.c |  3 +-
 tc/m_vlan.c       |  2 +-
 tc/m_xt.c         | 15 ++++-----
 tc/m_xt_old.c     | 86 +++++++++++++++++++++++------------------------
 tc/tc_filter.c    |  3 +-
 tc/tc_qdisc.c     |  3 +-
 19 files changed, 112 insertions(+), 118 deletions(-)

diff --git a/tc/m_bpf.c b/tc/m_bpf.c
index 3e8468c68324..ca02b56e40fd 100644
--- a/tc/m_bpf.c
+++ b/tc/m_bpf.c
@@ -165,7 +165,7 @@ static int bpf_print_opt(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_ACT_BPF_MAX, arg);
 
 	if (!tb[TCA_ACT_BPF_PARMS]) {
-		fprintf(f, "[NULL bpf parameters]");
+		fprintf(stderr, "Missing bpf parameters\n");
 		return -1;
 	}
 
diff --git a/tc/m_connmark.c b/tc/m_connmark.c
index 13543d337cc2..9505fe756851 100644
--- a/tc/m_connmark.c
+++ b/tc/m_connmark.c
@@ -114,7 +114,7 @@ static int print_connmark(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	parse_rtattr_nested(tb, TCA_CONNMARK_MAX, arg);
 	if (tb[TCA_CONNMARK_PARMS] == NULL) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL connmark parameters]");
+		fprintf(stderr, "Missing connmark parameters\n");
 		return -1;
 	}
 
diff --git a/tc/m_csum.c b/tc/m_csum.c
index 84396d6a482d..3e3dc251ea38 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -172,7 +172,7 @@ print_csum(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_CSUM_MAX, arg);
 
 	if (tb[TCA_CSUM_PARMS] == NULL) {
-		fprintf(f, "[NULL csum parameters]");
+		fprintf(stderr, "Missing csum parameters\n");
 		return -1;
 	}
 	sel = RTA_DATA(tb[TCA_CSUM_PARMS]);
diff --git a/tc/m_gact.c b/tc/m_gact.c
index 5b781e16446d..d82914a4ac0f 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -178,7 +178,7 @@ print_gact(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_GACT_MAX, arg);
 
 	if (tb[TCA_GACT_PARMS] == NULL) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL gact parameters]");
+		fprintf(stderr, "Missing gact parameters\n");
 		return -1;
 	}
 	p = RTA_DATA(tb[TCA_GACT_PARMS]);
diff --git a/tc/m_ife.c b/tc/m_ife.c
index 2bf9f2047b46..b34b8dbef70f 100644
--- a/tc/m_ife.c
+++ b/tc/m_ife.c
@@ -219,7 +219,7 @@ skip_encode:
 
 static int print_ife(struct action_util *au, FILE *f, struct rtattr *arg)
 {
-	struct tc_ife *p = NULL;
+	struct tc_ife *p;
 	struct rtattr *tb[TCA_IFE_MAX + 1];
 	__u16 ife_type = 0;
 	__u32 mmark = 0;
@@ -234,7 +234,7 @@ static int print_ife(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_IFE_MAX, arg);
 
 	if (tb[TCA_IFE_PARMS] == NULL) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL ife parameters]");
+		fprintf(stderr, "Missing ife parameters\n");
 		return -1;
 	}
 	p = RTA_DATA(tb[TCA_IFE_PARMS]);
diff --git a/tc/m_ipt.c b/tc/m_ipt.c
index 1d73cb98895a..cc95eab7fefb 100644
--- a/tc/m_ipt.c
+++ b/tc/m_ipt.c
@@ -429,6 +429,8 @@ print_ipt(struct action_util *au, FILE * f, struct rtattr *arg)
 {
 	struct rtattr *tb[TCA_IPT_MAX + 1];
 	struct ipt_entry_target *t = NULL;
+	struct xtables_target *m;
+	__u32 hook;
 
 	if (arg == NULL)
 		return -1;
@@ -440,70 +442,68 @@ print_ipt(struct action_util *au, FILE * f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_IPT_MAX, arg);
 
 	if (tb[TCA_IPT_TABLE] == NULL) {
-		fprintf(f, "[NULL ipt table name ] assuming mangle ");
+		fprintf(stderr,  "Missing ipt table name, assuming mangle\n");
 	} else {
 		fprintf(f, "tablename: %s ",
 			rta_getattr_str(tb[TCA_IPT_TABLE]));
 	}
 
 	if (tb[TCA_IPT_HOOK] == NULL) {
-		fprintf(f, "[NULL ipt hook name ]\n ");
+		fprintf(stderr, "Missing ipt hook name\n ");
 		return -1;
-	} else {
-		__u32 hook;
-
-		hook = rta_getattr_u32(tb[TCA_IPT_HOOK]);
-		fprintf(f, " hook: %s\n", ipthooks[hook]);
 	}
 
+	hook = rta_getattr_u32(tb[TCA_IPT_HOOK]);
+	fprintf(f, " hook: %s\n", ipthooks[hook]);
+
 	if (tb[TCA_IPT_TARG] == NULL) {
-		fprintf(f, "\t[NULL ipt target parameters ]\n");
+		fprintf(stderr, "Missing ipt target parameters\n");
 		return -1;
-	} else {
-		struct xtables_target *m = NULL;
+	}
 
-		t = RTA_DATA(tb[TCA_IPT_TARG]);
-		m = get_target_name(t->u.user.name);
-		if (m != NULL) {
-			if (build_st(m, t) < 0) {
-				fprintf(stderr, " %s error\n", m->name);
-				return -1;
-			}
 
-			opts =
-			    merge_options(opts, m->extra_opts,
-					  &m->option_offset);
-		} else {
-			fprintf(stderr, " failed to find target %s\n\n",
-				t->u.user.name);
+	t = RTA_DATA(tb[TCA_IPT_TARG]);
+	m = get_target_name(t->u.user.name);
+	if (m != NULL) {
+		if (build_st(m, t) < 0) {
+			fprintf(stderr, " %s error\n", m->name);
 			return -1;
 		}
-		fprintf(f, "\ttarget ");
-		m->print(NULL, m->t, 0);
-		if (tb[TCA_IPT_INDEX] == NULL) {
-			fprintf(f, " [NULL ipt target index ]\n");
-		} else {
-			__u32 index;
 
-			index = rta_getattr_u32(tb[TCA_IPT_INDEX]);
-			fprintf(f, "\n\tindex %u", index);
-		}
+		opts =
+			merge_options(opts, m->extra_opts,
+				      &m->option_offset);
+	} else {
+		fprintf(stderr, " failed to find target %s\n\n",
+			t->u.user.name);
+		return -1;
+	}
 
-		if (tb[TCA_IPT_CNT]) {
-			struct tc_cnt *c  = RTA_DATA(tb[TCA_IPT_CNT]);
+	fprintf(f, "\ttarget ");
+	m->print(NULL, m->t, 0);
+	if (tb[TCA_IPT_INDEX] == NULL) {
+		fprintf(stderr, "Missing ipt target index\n");
+	} else {
+		__u32 index;
 
-			fprintf(f, " ref %d bind %d", c->refcnt, c->bindcnt);
-		}
-		if (show_stats) {
-			if (tb[TCA_IPT_TM]) {
-				struct tcf_t *tm = RTA_DATA(tb[TCA_IPT_TM]);
+		index = rta_getattr_u32(tb[TCA_IPT_INDEX]);
+		fprintf(f, "\n\tindex %u", index);
+	}
 
-				print_tm(f, tm);
-			}
-		}
-		fprintf(f, "\n");
+	if (tb[TCA_IPT_CNT]) {
+		struct tc_cnt *c  = RTA_DATA(tb[TCA_IPT_CNT]);
+
+		fprintf(f, " ref %d bind %d", c->refcnt, c->bindcnt);
+	}
+	if (show_stats) {
+		if (tb[TCA_IPT_TM]) {
+			struct tcf_t *tm = RTA_DATA(tb[TCA_IPT_TM]);
 
+			print_tm(f, tm);
+		}
 	}
+	fprintf(f, "\n");
+
 	free_opts(opts);
 
 	return 0;
diff --git a/tc/m_mirred.c b/tc/m_mirred.c
index 23ba638a234d..132095237929 100644
--- a/tc/m_mirred.c
+++ b/tc/m_mirred.c
@@ -287,7 +287,7 @@ print_mirred(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_MIRRED_MAX, arg);
 
 	if (tb[TCA_MIRRED_PARMS] == NULL) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL mirred parameters]");
+		fprintf(stderr, "Missing mirred parameters\n");
 		return -1;
 	}
 	p = RTA_DATA(tb[TCA_MIRRED_PARMS]);
diff --git a/tc/m_nat.c b/tc/m_nat.c
index ee0b7520a605..c4b02a83c3c7 100644
--- a/tc/m_nat.c
+++ b/tc/m_nat.c
@@ -152,7 +152,7 @@ print_nat(struct action_util *au, FILE * f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_NAT_MAX, arg);
 
 	if (tb[TCA_NAT_PARMS] == NULL) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL nat parameters]");
+		fprintf(stderr, "Missing nat parameters\n");
 		return -1;
 	}
 	sel = RTA_DATA(tb[TCA_NAT_PARMS]);
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 6f8d078b7d3c..d2ce1024efec 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -742,7 +742,7 @@ static int print_pedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_PEDIT_MAX, arg);
 
 	if (!tb[TCA_PEDIT_PARMS] && !tb[TCA_PEDIT_PARMS_EX]) {
-		fprintf(f, "[NULL pedit parameters]");
+		fprintf(stderr, "Missing pedit parameters\n");
 		return -1;
 	}
 
diff --git a/tc/m_sample.c b/tc/m_sample.c
index 39a99246a8ea..c9444e08c55c 100644
--- a/tc/m_sample.c
+++ b/tc/m_sample.c
@@ -149,7 +149,7 @@ static int print_sample(struct action_util *au, FILE *f, struct rtattr *arg)
 
 	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
 	    !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL sample parameters]");
+		fprintf(stderr, "Missing sample parameters\n");
 		return -1;
 	}
 	p = RTA_DATA(tb[TCA_SAMPLE_PARMS]);
diff --git a/tc/m_simple.c b/tc/m_simple.c
index e3c8a60ff64a..10f7c073db96 100644
--- a/tc/m_simple.c
+++ b/tc/m_simple.c
@@ -170,13 +170,13 @@ static int print_simple(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_DEF_MAX, arg);
 
 	if (tb[TCA_DEF_PARMS] == NULL) {
-		fprintf(f, "[NULL simple parameters]");
+		fprintf(stderr, "Missing simple parameters\n");
 		return -1;
 	}
 	sel = RTA_DATA(tb[TCA_DEF_PARMS]);
 
 	if (tb[TCA_DEF_DATA] == NULL) {
-		fprintf(f, "[missing simple string]");
+		fprintf(stderr, "Missing simple string\n");
 		return -1;
 	}
 
diff --git a/tc/m_skbedit.c b/tc/m_skbedit.c
index b6b839f8ef6c..0ccdad15811e 100644
--- a/tc/m_skbedit.c
+++ b/tc/m_skbedit.c
@@ -178,7 +178,7 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	SPRINT_BUF(b1);
 	__u32 priority;
 	__u16 ptype;
-	struct tc_skbedit *p = NULL;
+	struct tc_skbedit *p;
 
 	if (arg == NULL)
 		return -1;
@@ -186,7 +186,7 @@ static int print_skbedit(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_SKBEDIT_MAX, arg);
 
 	if (tb[TCA_SKBEDIT_PARMS] == NULL) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL skbedit parameters]");
+		fprintf(stderr, "Missing skbedit parameters\n");
 		return -1;
 	}
 	p = RTA_DATA(tb[TCA_SKBEDIT_PARMS]);
diff --git a/tc/m_skbmod.c b/tc/m_skbmod.c
index 2dd1bb7e3d6d..d38a5c1921e7 100644
--- a/tc/m_skbmod.c
+++ b/tc/m_skbmod.c
@@ -161,7 +161,7 @@ static int parse_skbmod(struct action_util *a, int *argc_p, char ***argv_p,
 
 static int print_skbmod(struct action_util *au, FILE *f, struct rtattr *arg)
 {
-	struct tc_skbmod *p = NULL;
+	struct tc_skbmod *p;
 	struct rtattr *tb[TCA_SKBMOD_MAX + 1];
 	__u16 skbmod_etype = 0;
 	int has_optional = 0;
@@ -174,7 +174,7 @@ static int print_skbmod(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_SKBMOD_MAX, arg);
 
 	if (tb[TCA_SKBMOD_PARMS] == NULL) {
-		fprintf(f, "[NULL skbmod parameters]");
+		fprintf(stderr, "Missing skbmod parameters\n");
 		return -1;
 	}
 
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 9449287ea0b4..7dc0bb287868 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -493,8 +493,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_TUNNEL_KEY_MAX, arg);
 
 	if (!tb[TCA_TUNNEL_KEY_PARMS]) {
-		print_string(PRINT_FP, NULL, "%s",
-			     "[NULL tunnel_key parameters]");
+		fprintf(stderr, "Missing tunnel_key parameters\n");
 		return -1;
 	}
 	parm = RTA_DATA(tb[TCA_TUNNEL_KEY_PARMS]);
diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 412f6aa1000e..9c8071e9dbbe 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -188,7 +188,7 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_VLAN_MAX, arg);
 
 	if (!tb[TCA_VLAN_PARMS]) {
-		print_string(PRINT_FP, NULL, "%s", "[NULL vlan parameters]");
+		fprintf(stderr, "Missing vlanparameters\n");
 		return -1;
 	}
 	parm = RTA_DATA(tb[TCA_VLAN_PARMS]);
diff --git a/tc/m_xt.c b/tc/m_xt.c
index 29574bd41f93..bf0db2be99a4 100644
--- a/tc/m_xt.c
+++ b/tc/m_xt.c
@@ -317,6 +317,7 @@ print_ipt(struct action_util *au, FILE *f, struct rtattr *arg)
 	struct xtables_target *m;
 	struct rtattr *tb[TCA_IPT_MAX + 1];
 	struct xt_entry_target *t = NULL;
+	__u32 hook;
 
 	if (arg == NULL)
 		return -1;
@@ -330,27 +331,25 @@ print_ipt(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_IPT_MAX, arg);
 
 	if (tb[TCA_IPT_TABLE] == NULL) {
-		fprintf(f, "[NULL ipt table name ] assuming mangle ");
+		fprintf(stderr, "Missing ipt table name, assuming mangle\n");
 	} else {
 		fprintf(f, "tablename: %s ",
 			rta_getattr_str(tb[TCA_IPT_TABLE]));
 	}
 
 	if (tb[TCA_IPT_HOOK] == NULL) {
-		fprintf(f, "[NULL ipt hook name ]\n ");
+		fprintf(stderr, "Missing ipt hook name\n ");
 		return -1;
-	} else {
-		__u32 hook;
-
-		hook = rta_getattr_u32(tb[TCA_IPT_HOOK]);
-		fprintf(f, " hook: %s\n", ipthooks[hook]);
 	}
 
 	if (tb[TCA_IPT_TARG] == NULL) {
-		fprintf(f, "\t[NULL ipt target parameters ]\n");
+		fprintf(stderr, "Missing ipt target parameters\n");
 		return -1;
 	}
 
+	hook = rta_getattr_u32(tb[TCA_IPT_HOOK]);
+	fprintf(f, " hook: %s\n", ipthooks[hook]);
+
 	t = RTA_DATA(tb[TCA_IPT_TARG]);
 	m = xtables_find_target(t->u.user.name, XTF_TRY_LOAD);
 	if (!m) {
diff --git a/tc/m_xt_old.c b/tc/m_xt_old.c
index 25d367785786..a025a55990df 100644
--- a/tc/m_xt_old.c
+++ b/tc/m_xt_old.c
@@ -354,7 +354,9 @@ print_ipt(struct action_util *au, FILE * f, struct rtattr *arg)
 {
 	struct rtattr *tb[TCA_IPT_MAX + 1];
 	struct xt_entry_target *t = NULL;
-
+	struct xtables_target *m;
+	__u32 hook;
+	
 	if (arg == NULL)
 		return -1;
 
@@ -363,70 +365,66 @@ print_ipt(struct action_util *au, FILE * f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_IPT_MAX, arg);
 
 	if (tb[TCA_IPT_TABLE] == NULL) {
-		fprintf(f, "[NULL ipt table name ] assuming mangle ");
+		fprintf(stderr, "Missing ipt table name, assuming mangle\n");
 	} else {
 		fprintf(f, "tablename: %s ",
 			rta_getattr_str(tb[TCA_IPT_TABLE]));
 	}
 
 	if (tb[TCA_IPT_HOOK] == NULL) {
-		fprintf(f, "[NULL ipt hook name ]\n ");
+		fprintf(stderr, "Missing ipt hook name\n");
 		return -1;
-	} else {
-		__u32 hook;
-
-		hook = rta_getattr_u32(tb[TCA_IPT_HOOK]);
-		fprintf(f, " hook: %s\n", ipthooks[hook]);
 	}
 
 	if (tb[TCA_IPT_TARG] == NULL) {
-		fprintf(f, "\t[NULL ipt target parameters ]\n");
+		fprintf(stderr, "Missing ipt target parameters\n");
 		return -1;
-	} else {
-		struct xtables_target *m = NULL;
+	}
 
-		t = RTA_DATA(tb[TCA_IPT_TARG]);
-		m = find_target(t->u.user.name, TRY_LOAD);
-		if (m != NULL) {
-			if (build_st(m, t) < 0) {
-				fprintf(stderr, " %s error\n", m->name);
-				return -1;
-			}
+	hook = rta_getattr_u32(tb[TCA_IPT_HOOK]);
+	fprintf(f, " hook: %s\n", ipthooks[hook]);
 
-			opts =
-			    merge_options(opts, m->extra_opts,
-					  &m->option_offset);
-		} else {
-			fprintf(stderr, " failed to find target %s\n\n",
-				t->u.user.name);
+	t = RTA_DATA(tb[TCA_IPT_TARG]);
+	m = find_target(t->u.user.name, TRY_LOAD);
+	if (m != NULL) {
+		if (build_st(m, t) < 0) {
+			fprintf(stderr, " %s error\n", m->name);
 			return -1;
 		}
-		fprintf(f, "\ttarget ");
-		m->print(NULL, m->t, 0);
-		if (tb[TCA_IPT_INDEX] == NULL) {
-			fprintf(f, " [NULL ipt target index ]\n");
-		} else {
-			__u32 index;
 
-			index = rta_getattr_u32(tb[TCA_IPT_INDEX]);
-			fprintf(f, "\n\tindex %u", index);
-		}
+		opts =
+			merge_options(opts, m->extra_opts,
+				      &m->option_offset);
+	} else {
+		fprintf(stderr, " failed to find target %s\n\n",
+			t->u.user.name);
+		return -1;
+	}
+	fprintf(f, "\ttarget ");
+	m->print(NULL, m->t, 0);
+	if (tb[TCA_IPT_INDEX] == NULL) {
+		fprintf(f, " [NULL ipt target index ]\n");
+	} else {
+		__u32 index;
 
-		if (tb[TCA_IPT_CNT]) {
-			struct tc_cnt *c  = RTA_DATA(tb[TCA_IPT_CNT]);
+		index = rta_getattr_u32(tb[TCA_IPT_INDEX]);
+		fprintf(f, "\n\tindex %u", index);
+	}
 
-			fprintf(f, " ref %d bind %d", c->refcnt, c->bindcnt);
-		}
-		if (show_stats) {
-			if (tb[TCA_IPT_TM]) {
-				struct tcf_t *tm = RTA_DATA(tb[TCA_IPT_TM]);
+	if (tb[TCA_IPT_CNT]) {
+		struct tc_cnt *c  = RTA_DATA(tb[TCA_IPT_CNT]);
 
-				print_tm(f, tm);
-			}
-		}
-		fprintf(f, "\n");
+		fprintf(f, " ref %d bind %d", c->refcnt, c->bindcnt);
+	}
+	if (show_stats) {
+		if (tb[TCA_IPT_TM]) {
+			struct tcf_t *tm = RTA_DATA(tb[TCA_IPT_TM]);
 
+			print_tm(f, tm);
+		}
 	}
+	fprintf(f, "\n");
+
 	free_opts(opts);
 
 	return 0;
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index e5c7bc4605a2..cd78c2441efa 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -375,8 +375,7 @@ int print_filter(struct nlmsghdr *n, void *arg)
 			if (q)
 				q->print_fopt(q, fp, tb[TCA_OPTIONS], t->tcm_handle);
 			else
-				print_string(PRINT_FP, NULL,
-					     "[cannot parse parameters]", NULL);
+				fprintf(stderr, "cannot parse option parameters\n");
 			close_json_object();
 		}
 	}
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index c5da5b5c1ed5..72e807359358 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -312,8 +312,7 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
 		if (q)
 			q->print_qopt(q, fp, tb[TCA_OPTIONS]);
 		else
-			print_string(PRINT_FP, NULL,
-				     "[cannot parse qdisc parameters]", NULL);
+			fprintf(stderr, "Cannot parse qdisc parameters\n");
 	}
 	close_json_object();
 
-- 
2.20.1

