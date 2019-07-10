Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDACB6466D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfGJMlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:41:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34941 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJMlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:41:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so2326512wrm.2
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2CeTc72p/cbXq9knA0iWK6b+dKY9nbe1iBbuMYB3OgU=;
        b=tvmD+uSKMleUDsk74krEs7aQvlijyXP9iOKWAIrn53d2N6f2lFpZj9bSOGzP9MnCp1
         5fnXk/5FVdIXH/BKvrwqfBOCCMvKBWcqLyjA8jAoaayK+uwG+kpSFhpEb+FLEJSt270R
         YBuJHq1iPn9lvxv9V2y3nugxkNQFR/XOuwQGktD67t0zwltzCriODAi4IpbQ9x37rk4+
         9V2rLEFYc00DFYbMdHn++0E3o8mRXkkwbSYAIjmgmSTMq7UBS4rUfQpsLeEkvsQoxeX6
         ZzSWf1FlThEqg8gx+dXwxz2uRAFEtJn9ngJf/TT0Rq6YKnthhuPDx6J1WePCg5JwtLoD
         fd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2CeTc72p/cbXq9knA0iWK6b+dKY9nbe1iBbuMYB3OgU=;
        b=GyQKsSnYpis+298swMyuc8neQyOK6lM94zClwFapRf81fliZs2Yqux+XbcjEicHWJK
         xSzShhfp6xtYQLtxvEIiu1J3co8X1+Opx/CXmbhU4zSGdOmENHhz0Y6FzsbpdUnr16s7
         oN+iQMKGRcbs20cTTOgY1AsGnLUizQfvzV6yhbZ6iwMOg31LPCy39z+oPM9/U0vg5fX7
         /uQgVZ19ncFRBFRLU4yWBeT0KVGlvwgbbd7PubaHyw4mp33gJ43kGaf6h9FxyFOZvLZT
         rVcdi8YdKqwzKvnIO+idKSRknwsuzuxAK1qzkLhZT0Bkfxev3DfivT4pxbP1Rm9hpa+b
         ZaCQ==
X-Gm-Message-State: APjAAAUY7Z8hI6yXFMJOd19y3j/sR9hjpAz/K9xkuYaxmmXYwupwfmF0
        vg1oAacb29VLkdx/vYnaMuTqHO7eWb0=
X-Google-Smtp-Source: APXvYqyMqb8GwR48ZSN+NSlZ5NYeXNkR3acW26LeDs7+m8xXmCxqkE/LYva5EZRYP+whcFJusFJP/g==
X-Received: by 2002:adf:ce88:: with SMTP id r8mr33502769wrn.42.1562762467346;
        Wed, 10 Jul 2019 05:41:07 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id z5sm1406759wmf.48.2019.07.10.05.41.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 05:41:06 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        stephen@networkplumber.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH iproute2-next v2 2/3] tc: add mpls actions
Date:   Wed, 10 Jul 2019 13:40:39 +0100
Message-Id: <1562762440-25656-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
References: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new action type for TC that allows the pushing, popping, and
modifying of MPLS headers.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tc/Makefile |   1 +
 tc/m_mpls.c | 276 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 277 insertions(+)
 create mode 100644 tc/m_mpls.c

diff --git a/tc/Makefile b/tc/Makefile
index 60abdde..09ff369 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -39,6 +39,7 @@ TCMODULES += q_drr.o
 TCMODULES += q_qfq.o
 TCMODULES += m_gact.o
 TCMODULES += m_mirred.o
+TCMODULES += m_mpls.o
 TCMODULES += m_nat.o
 TCMODULES += m_pedit.o
 TCMODULES += m_ife.o
diff --git a/tc/m_mpls.c b/tc/m_mpls.c
new file mode 100644
index 0000000..0ae6d62
--- /dev/null
+++ b/tc/m_mpls.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Netronome Systems, Inc. */
+
+#include <linux/if_ether.h>
+#include <linux/tc_act/tc_mpls.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "utils.h"
+#include "rt_names.h"
+#include "tc_util.h"
+
+static const char * const action_names[] = {
+	[TCA_MPLS_ACT_POP] = "pop",
+	[TCA_MPLS_ACT_PUSH] = "push",
+	[TCA_MPLS_ACT_MODIFY] = "modify",
+	[TCA_MPLS_ACT_DEC_TTL] = "dec_ttl",
+};
+
+static void explain(void)
+{
+	fprintf(stderr,
+		"Usage: mpls pop [ protocol MPLS_PROTO ]\n"
+		"       mpls push [ protocol MPLS_PROTO ] [ label MPLS_LABEL ] [ tc MPLS_TC ]\n"
+		"                 [ ttl MPLS_TTL ] [ bos MPLS_BOS ] [CONTROL]\n"
+		"       mpls modify [ label MPLS_LABEL ] [ tc MPLS_TC ] [ ttl MPLS_TTL ] [CONTROL]\n"
+		"           for pop MPLS_PROTO is next header of packet - e.g. ip or mpls_uc\n"
+		"           for push MPLS_PROTO is one of mpls_uc or mpls_mc\n"
+		"               with default: mpls_uc\n"
+		"       CONTROL := reclassify | pipe | drop | continue | pass |\n"
+		"                  goto chain <CHAIN_INDEX>\n");
+}
+
+static void usage(void)
+{
+	explain();
+	exit(-1);
+}
+
+static bool can_modify_mpls_fields(unsigned int action)
+{
+	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_MODIFY;
+}
+
+static bool can_modify_ethtype(unsigned int action)
+{
+	return action == TCA_MPLS_ACT_PUSH || action == TCA_MPLS_ACT_POP;
+}
+
+static bool is_valid_label(__u32 label)
+{
+	return label <= 0xfffff;
+}
+
+static bool check_double_action(unsigned int action, const char *arg)
+{
+	if (!action)
+		return false;
+
+	fprintf(stderr,
+		"Error: got \"%s\" but action already set to \"%s\"\n",
+		arg, action_names[action]);
+	explain();
+	return true;
+}
+
+static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
+		      int tca_id, struct nlmsghdr *n)
+{
+	struct tc_mpls parm = {};
+	__u32 label = 0xffffffff;
+	unsigned int action = 0;
+	char **argv = *argv_p;
+	struct rtattr *tail;
+	int argc = *argc_p;
+	__u16 proto = 0;
+	__u8 bos = 0xff;
+	__u8 tc = 0xff;
+	__u8 ttl = 0;
+
+	if (matches(*argv, "mpls") != 0)
+		return -1;
+
+	NEXT_ARG();
+
+	while (argc > 0) {
+		if (matches(*argv, "pop") == 0) {
+			if (check_double_action(action, *argv))
+				return -1;
+			action = TCA_MPLS_ACT_POP;
+		} else if (matches(*argv, "push") == 0) {
+			if (check_double_action(action, *argv))
+				return -1;
+			action = TCA_MPLS_ACT_PUSH;
+		} else if (matches(*argv, "modify") == 0) {
+			if (check_double_action(action, *argv))
+				return -1;
+			action = TCA_MPLS_ACT_MODIFY;
+		} else if (matches(*argv, "dec_ttl") == 0) {
+			if (check_double_action(action, *argv))
+				return -1;
+			action = TCA_MPLS_ACT_DEC_TTL;
+		} else if (matches(*argv, "label") == 0) {
+			if (!can_modify_mpls_fields(action))
+				invarg("only valid for push/modify", *argv);
+			NEXT_ARG();
+			if (get_u32(&label, *argv, 0) || !is_valid_label(label))
+				invarg("label must be <=0xFFFFF", *argv);
+		} else if (matches(*argv, "tc") == 0) {
+			if (!can_modify_mpls_fields(action))
+				invarg("only valid for push/modify", *argv);
+			NEXT_ARG();
+			if (get_u8(&tc, *argv, 0) || (tc & ~0x7))
+				invarg("tc field is 3 bits max", *argv);
+		} else if (matches(*argv, "ttl") == 0) {
+			if (!can_modify_mpls_fields(action))
+				invarg("only valid for push/modify", *argv);
+			NEXT_ARG();
+			if (get_u8(&ttl, *argv, 0) || !ttl)
+				invarg("ttl must be >0 and <=255", *argv);
+		} else if (matches(*argv, "bos") == 0) {
+			if (!can_modify_mpls_fields(action))
+				invarg("only valid for push/modify", *argv);
+			NEXT_ARG();
+			if (get_u8(&bos, *argv, 0) || (bos & ~0x1))
+				invarg("bos must be 0 or 1", *argv);
+		} else if (matches(*argv, "protocol") == 0) {
+			if (!can_modify_ethtype(action))
+				invarg("only valid for push/pop", *argv);
+			NEXT_ARG();
+			if (ll_proto_a2n(&proto, *argv))
+				invarg("protocol is invalid", *argv);
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			break;
+		}
+
+		NEXT_ARG_FWD();
+	}
+
+	if (!action)
+		incomplete_command();
+
+	parse_action_control_dflt(&argc, &argv, &parm.action,
+				  false, TC_ACT_PIPE);
+
+	if (argc) {
+		if (matches(*argv, "index") == 0) {
+			NEXT_ARG();
+			if (get_u32(&parm.index, *argv, 10))
+				invarg("illegal index", *argv);
+			NEXT_ARG_FWD();
+		}
+	}
+
+	if (action == TCA_MPLS_ACT_PUSH && !label)
+		missarg("label");
+
+	if (action == TCA_MPLS_ACT_PUSH && proto &&
+	    proto != htons(ETH_P_MPLS_UC) && proto != htons(ETH_P_MPLS_MC)) {
+		fprintf(stderr,
+			"invalid push protocol \"0x%04x\" - use mpls_(uc|mc)\n",
+			ntohs(proto));
+		return -1;
+	}
+
+	if (action == TCA_MPLS_ACT_POP && !proto)
+		missarg("protocol");
+
+	parm.m_action = action;
+	tail = addattr_nest(n, MAX_MSG, tca_id | NLA_F_NESTED);
+	addattr_l(n, MAX_MSG, TCA_MPLS_PARMS, &parm, sizeof(parm));
+	if (label != 0xffffffff)
+		addattr_l(n, MAX_MSG, TCA_MPLS_LABEL, &label, sizeof(label));
+	if (proto)
+		addattr_l(n, MAX_MSG, TCA_MPLS_PROTO, &proto, sizeof(proto));
+	if (tc != 0xff)
+		addattr8(n, MAX_MSG, TCA_MPLS_TC, tc);
+	if (ttl)
+		addattr8(n, MAX_MSG, TCA_MPLS_TTL, ttl);
+	if (bos != 0xff)
+		addattr8(n, MAX_MSG, TCA_MPLS_BOS, bos);
+	addattr_nest_end(n, tail);
+
+	*argc_p = argc;
+	*argv_p = argv;
+	return 0;
+}
+
+static int print_mpls(struct action_util *au, FILE *f, struct rtattr *arg)
+{
+	struct rtattr *tb[TCA_MPLS_MAX + 1];
+	struct tc_mpls *parm;
+	SPRINT_BUF(b1);
+	__u32 val;
+
+	if (!arg)
+		return -1;
+
+	parse_rtattr_nested(tb, TCA_MPLS_MAX, arg);
+
+	if (!tb[TCA_MPLS_PARMS]) {
+		fprintf(stderr, "[NULL mpls parameters]\n");
+		return -1;
+	}
+	parm = RTA_DATA(tb[TCA_MPLS_PARMS]);
+
+	print_string(PRINT_ANY, "kind", "%s ", "mpls");
+	print_string(PRINT_ANY, "mpls_action", " %s",
+		     action_names[parm->m_action]);
+
+	switch (parm->m_action) {
+	case TCA_MPLS_ACT_POP:
+		if (tb[TCA_MPLS_PROTO]) {
+			__u16 proto;
+
+			proto = rta_getattr_u16(tb[TCA_MPLS_PROTO]);
+			print_string(PRINT_ANY, "protocol", " protocol %s",
+				     ll_proto_n2a(proto, b1, sizeof(b1)));
+		}
+		break;
+	case TCA_MPLS_ACT_PUSH:
+		if (tb[TCA_MPLS_PROTO]) {
+			__u16 proto;
+
+			proto = rta_getattr_u16(tb[TCA_MPLS_PROTO]);
+			print_string(PRINT_ANY, "protocol", " protocol %s",
+				     ll_proto_n2a(proto, b1, sizeof(b1)));
+		}
+		/* Fallthrough */
+	case TCA_MPLS_ACT_MODIFY:
+		if (tb[TCA_MPLS_LABEL]) {
+			val = rta_getattr_u32(tb[TCA_MPLS_LABEL]);
+			print_uint(PRINT_ANY, "label", " label %u", val);
+		}
+		if (tb[TCA_MPLS_TC]) {
+			val = rta_getattr_u8(tb[TCA_MPLS_TC]);
+			print_uint(PRINT_ANY, "tc", " tc %u", val);
+		}
+		if (tb[TCA_MPLS_BOS]) {
+			val = rta_getattr_u8(tb[TCA_MPLS_BOS]);
+			print_uint(PRINT_ANY, "bos", " bos %u", val);
+		}
+		if (tb[TCA_MPLS_TTL]) {
+			val = rta_getattr_u8(tb[TCA_MPLS_TTL]);
+			print_uint(PRINT_ANY, "ttl", " ttl %u", val);
+		}
+		break;
+	}
+	print_action_control(f, " ", parm->action, "");
+
+	print_uint(PRINT_ANY, "index", "\n\t index %u", parm->index);
+	print_int(PRINT_ANY, "ref", " ref %d", parm->refcnt);
+	print_int(PRINT_ANY, "bind", " bind %d", parm->bindcnt);
+
+	if (show_stats) {
+		if (tb[TCA_MPLS_TM]) {
+			struct tcf_t *tm = RTA_DATA(tb[TCA_MPLS_TM]);
+
+			print_tm(f, tm);
+		}
+	}
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+
+	return 0;
+}
+
+struct action_util mpls_action_util = {
+	.id = "mpls",
+	.parse_aopt = parse_mpls,
+	.print_aopt = print_mpls,
+};
-- 
2.7.4

