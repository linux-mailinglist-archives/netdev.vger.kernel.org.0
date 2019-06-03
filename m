Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51233A5B
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfFCV4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:56:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44032 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCV4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:56:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id w13so13636531wru.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 14:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D7F7k2PJ0nfvQF+7pGzzUO/f1ZisDOnq8OMy1HnmWSM=;
        b=g6WILtHcUSVpyVN/aMFxhdUGH9eGmevsJ60vc0jZmSB7aAVBGdvEHfimmghkpD97qU
         U2YlLoy6WUhSj+2o7xWFdrmTqBoFZvzJZJ5jIGBwnCCpXac2SkZrk5kS697HfKOB6leP
         WuNhmwuXoBtfIuj//NhsG5pNuwxKvvPJwinXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=D7F7k2PJ0nfvQF+7pGzzUO/f1ZisDOnq8OMy1HnmWSM=;
        b=Wz5ZXv3jggurhDPkzTqvOdXhzYAU3DAyZ35+nEAIFq8kNx0BEF0oDsyUrthw53PHpU
         kST2LdQc4NfLPmYtSdgHP9Q344QasJmqkNJZkSmqqM7UyzG42sNyRxSi4S2kZ4q9oeVD
         NBqD6zUzhqxcFyZlohYyO7RyRHDAm9vrCcbt92+9l9gjtFcxW6NIgM++1/DZxb3E8cy5
         y9TmAKPRxjqH5UcMtOeZg4/ymA7yXtErTAJcWIs32gQ9QFAKg5uso4xGoM9tX9SfWnRk
         VQWipwRgKpaONrV8gxFJgAZnENxYg/spzI9scdw2uZZVdMnw2SJvu6P9c7ALaPe0uY0G
         rLvQ==
X-Gm-Message-State: APjAAAVdaI4/Znlp06nMJiBQ5RdCWeqlfVLzWsO5YLcblK9nhw41xYok
        qrOudj+af3l2t7GQWGyOn5uwS5jldsReSg==
X-Google-Smtp-Source: APXvYqw2+vfc/Iuy2CxpS6gDUn631DVC3FwkCLQPj26VcHveEP1Vl0/E6w/9xGdsuYq5bQEAgitZoQ==
X-Received: by 2002:adf:facb:: with SMTP id a11mr3826911wrs.280.1559594663745;
        Mon, 03 Jun 2019 13:44:23 -0700 (PDT)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1268:6500::dc83])
        by smtp.gmail.com with ESMTPSA id p3sm15841944wrd.47.2019.06.03.13.44.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 13:44:22 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH iproute2-next v1] tc: add support for action act_ctinfo
Date:   Mon,  3 Jun 2019 21:41:43 +0100
Message-Id: <20190603204142.51674-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ctinfo is an action restoring data stored in conntrack marks to various
fields.  At present it has two independent modes of operation,
restoration of DSCP into IPv4/v6 diffserv and restoration of conntrack
marks into packet skb marks.

It understands a number of parameters specific to this action in
additional to the usual action syntax.  Each operating mode is
independent of the other so all options are optional, however not
specifying at least one mode is a bit pointless.

Usage: ... ctinfo [dscp mask[/statemask]] [cpmark [mask]] [zone ZONE]
		  [CONTROL] [index <INDEX>]

DSCP mode

dscp enables copying of a DSCP store in the conntrack mark into the
ipv4/v6 diffserv field.  The mask is a 32bit field and specifies where
in the conntrack mark the DSCP value is stored.  It must be 6 contiguous
bits long, e.g. 0xfc000000 would restore the DSCP from the upper 6 bits
of the conntrack mark.

The DSCP copying may be optionally controlled by a statemask.  The
statemask is a 32bit field, usually with a single bit set and must not
overlap the dscp mask.  The DSCP restore operation will only take place
if the corresponding bit/s in conntrack mark yield a non zero result.

eg. dscp 0xfc000000/0x01000000 would retrieve the DSCP from the top 6
bits, whilst using bit 25 as a flag to do so.  Bit 26 is unused in this
example.

CPMARK mode

cpmark enables copying of the conntrack mark to the packet skb mark.  In
this mode it is completely equivalent to the existing act_connmark.
Additional functionality is provided by the optional mask parameter,
whereby the stored conntrack mark is logically anded with the cpmark
mask before being stored into skb mark.  This allows shared usage of the
conntrack mark between applications.

eg. cpmark 0x00ffffff would restore only the lower 24 bits of the
conntrack mark, thus may be useful in the event that the upper 8 bits
are used by the DSCP function.

Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
		  [CONTROL] [index <INDEX>]
where :
	dscp MASK is the bitmask to restore DSCP
	     STATEMASK is the bitmask to determine conditional restoring
	cpmark MASK mask applied to restored packet mark
	ZONE is the conntrack zone
	CONTROL := reclassify | pipe | drop | continue | ok |
		   goto chain <CHAIN_INDEX>

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/pkt_cls.h          |   1 +
 include/uapi/linux/tc_act/tc_ctinfo.h |  34 ++++
 tc/Makefile                           |   1 +
 tc/m_ctinfo.c                         | 268 ++++++++++++++++++++++++++
 4 files changed, 304 insertions(+)
 create mode 100644 include/uapi/linux/tc_act/tc_ctinfo.h
 create mode 100644 tc/m_ctinfo.c

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 51a0496f..a93680fc 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -105,6 +105,7 @@ enum tca_id {
 	TCA_ID_IFE = TCA_ACT_IFE,
 	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
 	/* other actions go here */
+	TCA_ID_CTINFO,
 	__TCA_ID_MAX = 255
 };
 
diff --git a/include/uapi/linux/tc_act/tc_ctinfo.h b/include/uapi/linux/tc_act/tc_ctinfo.h
new file mode 100644
index 00000000..da803e05
--- /dev/null
+++ b/include/uapi/linux/tc_act/tc_ctinfo.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __UAPI_TC_CTINFO_H
+#define __UAPI_TC_CTINFO_H
+
+#include <linux/types.h>
+#include <linux/pkt_cls.h>
+
+struct tc_ctinfo {
+	tc_gen;
+};
+
+enum {
+	TCA_CTINFO_UNSPEC,
+	TCA_CTINFO_PAD,
+	TCA_CTINFO_TM,
+	TCA_CTINFO_ACT,
+	TCA_CTINFO_ZONE,
+	TCA_CTINFO_PARMS_DSCP_MASK,
+	TCA_CTINFO_PARMS_DSCP_STATEMASK,
+	TCA_CTINFO_PARMS_CPMARK_MASK,
+	TCA_CTINFO_STATS_DSCP_SET,
+	TCA_CTINFO_STATS_DSCP_ERROR,
+	TCA_CTINFO_STATS_CPMARK_SET,
+	__TCA_CTINFO_MAX
+};
+
+#define TCA_CTINFO_MAX (__TCA_CTINFO_MAX - 1)
+
+enum {
+	CTINFO_MODE_DSCP	= BIT(0),
+	CTINFO_MODE_CPMARK	= BIT(1)
+};
+
+#endif
diff --git a/tc/Makefile b/tc/Makefile
index 1a305cf4..60abddee 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -48,6 +48,7 @@ TCMODULES += m_csum.o
 TCMODULES += m_simple.o
 TCMODULES += m_vlan.o
 TCMODULES += m_connmark.o
+TCMODULES += m_ctinfo.o
 TCMODULES += m_bpf.o
 TCMODULES += m_tunnel_key.o
 TCMODULES += m_sample.o
diff --git a/tc/m_ctinfo.c b/tc/m_ctinfo.c
new file mode 100644
index 00000000..5e451f87
--- /dev/null
+++ b/tc/m_ctinfo.c
@@ -0,0 +1,268 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * m_ctinfo.c		netfilter ctinfo mark action
+ *
+ * Copyright (c) 2019 Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include "utils.h"
+#include "tc_util.h"
+#include <linux/tc_act/tc_ctinfo.h>
+
+static void
+explain(void)
+{
+	fprintf(stderr,
+		"Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE] [CONTROL] [index <INDEX>]\n"
+		"where :\n"
+		"\tdscp   MASK bitmask location of stored DSCP\n"
+		"\t       STATEMASK bitmask to determine conditional restoring\n"
+		"\tcpmark MASK mask applied to mark on restoration\n"
+		"\tZONE is the conntrack zone\n"
+		"\tCONTROL := reclassify | pipe | drop | continue | ok |\n"
+		"\t           goto chain <CHAIN_INDEX>\n");
+}
+
+static void
+usage(void)
+{
+	explain();
+	exit(-1);
+}
+
+static int
+parse_ctinfo(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
+	     struct nlmsghdr *n)
+{
+	unsigned int cpmarkmask = 0, dscpmask = 0, dscpstatemask = 0;
+	struct tc_ctinfo sel = {};
+	unsigned short zone = 0;
+	char **argv = *argv_p;
+	struct rtattr *tail;
+	int argc = *argc_p;
+	int ok = 0;
+	__u8 i;
+
+	while (argc > 0) {
+		if (matches(*argv, "ctinfo") == 0) {
+			ok = 1;
+			NEXT_ARG_FWD();
+		} else if (matches(*argv, "help") == 0) {
+			usage();
+		} else {
+			break;
+		}
+
+	}
+
+	if (!ok) {
+		explain();
+		return -1;
+	}
+
+	if (argc) {
+		if (matches(*argv, "dscp") == 0) {
+			NEXT_ARG();
+			if (get_u32(&dscpmask, *argv, 0)) {
+				fprintf(stderr,
+					"ctinfo: Illegal dscp \"mask\"\n");
+				return -1;
+			}
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG_FWD();
+				if (!get_u32(&dscpstatemask, *argv, 0))
+					NEXT_ARG_FWD(); /* was a statemask */
+			} else {
+				NEXT_ARG_FWD();
+			}
+		}
+	}
+
+	/* cpmark has optional mask parameter, so the next arg might not  */
+	/* exist, or it might be the next option, or it may actually be a */
+	/* 32bit mask */
+	if (argc) {
+		if (matches(*argv, "cpmark") == 0) {
+			cpmarkmask = ~0;
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG_FWD();
+				if (!get_u32(&cpmarkmask, *argv, 0))
+					NEXT_ARG_FWD(); /* was a mask */
+			} else {
+				NEXT_ARG_FWD();
+			}
+		}
+	}
+
+	if (argc) {
+		if (matches(*argv, "zone") == 0) {
+			NEXT_ARG();
+			if (get_u16(&zone, *argv, 10)) {
+				fprintf(stderr, "ctinfo: Illegal \"zone\"\n");
+				return -1;
+			}
+			NEXT_ARG_FWD();
+		}
+	}
+
+	parse_action_control_dflt(&argc, &argv, &sel.action,
+				  false, TC_ACT_PIPE);
+
+	if (argc) {
+		if (matches(*argv, "index") == 0) {
+			NEXT_ARG();
+			if (get_u32(&sel.index, *argv, 10)) {
+				fprintf(stderr, "ctinfo: Illegal \"index\"\n");
+				return -1;
+			}
+			NEXT_ARG_FWD();
+		}
+	}
+
+	if (dscpmask & dscpstatemask) {
+		fprintf(stderr,
+			"ctinfo: dscp mask & statemask must NOT overlap\n");
+		return -1;
+	}
+
+	i = ffs(dscpmask);
+	if (i && ((~0 & (dscpmask >> (i - 1))) != 0x3f)) {
+		fprintf(stderr,
+			"ctinfo: dscp mask must be 6 contiguous bits long\n");
+		return -1;
+	}
+
+	tail = addattr_nest(n, MAX_MSG, tca_id);
+	addattr_l(n, MAX_MSG, TCA_CTINFO_ACT, &sel, sizeof(sel));
+	addattr16(n, MAX_MSG, TCA_CTINFO_ZONE, zone);
+
+	if (dscpmask)
+		addattr32(n, MAX_MSG,
+			  TCA_CTINFO_PARMS_DSCP_MASK, dscpmask);
+
+	if (dscpstatemask)
+		addattr32(n, MAX_MSG,
+			  TCA_CTINFO_PARMS_DSCP_STATEMASK, dscpstatemask);
+
+	if (cpmarkmask)
+		addattr32(n, MAX_MSG,
+			  TCA_CTINFO_PARMS_CPMARK_MASK, cpmarkmask);
+
+	addattr_nest_end(n, tail);
+
+	*argc_p = argc;
+	*argv_p = argv;
+	return 0;
+}
+
+static void print_ctinfo_stats(FILE *f, struct rtattr *tb[TCA_CTINFO_MAX + 1])
+{
+	struct tcf_t *tm;
+
+	if (tb[TCA_CTINFO_TM]) {
+		tm = RTA_DATA(tb[TCA_CTINFO_TM]);
+
+		print_tm(f, tm);
+	}
+
+	if (tb[TCA_CTINFO_STATS_DSCP_SET])
+		print_lluint(PRINT_ANY, "dscpset", " DSCP set %llu",
+			     rta_getattr_u64(tb[TCA_CTINFO_STATS_DSCP_SET]));
+	if (tb[TCA_CTINFO_STATS_DSCP_ERROR])
+		print_lluint(PRINT_ANY, "dscperror", " error %llu",
+			     rta_getattr_u64(tb[TCA_CTINFO_STATS_DSCP_ERROR]));
+
+	if (tb[TCA_CTINFO_STATS_CPMARK_SET])
+		print_lluint(PRINT_ANY, "cpmarkset", " CPMARK set %llu",
+			     rta_getattr_u64(tb[TCA_CTINFO_STATS_CPMARK_SET]));
+}
+
+static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
+{
+	unsigned int cpmarkmask = ~0, dscpmask = 0, dscpstatemask = 0;
+	struct rtattr *tb[TCA_CTINFO_MAX + 1];
+	unsigned short zone = 0;
+	struct tc_ctinfo *ci;
+
+	if (arg == NULL)
+		return -1;
+
+	parse_rtattr_nested(tb, TCA_CTINFO_MAX, arg);
+	if (!tb[TCA_CTINFO_ACT]) {
+		print_string(PRINT_FP, NULL, "%s",
+			     "[NULL ctinfo action parameters]");
+		return -1;
+	}
+
+	ci = RTA_DATA(tb[TCA_CTINFO_ACT]);
+
+	if (tb[TCA_CTINFO_PARMS_DSCP_MASK]) {
+		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_DSCP_MASK]) >=
+		    sizeof(__u32))
+			dscpmask = rta_getattr_u32(
+					tb[TCA_CTINFO_PARMS_DSCP_MASK]);
+		else
+			print_string(PRINT_FP, NULL, "%s",
+				     "[invalid dscp mask parameter]");
+	}
+
+	if (tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) {
+		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) >=
+		    sizeof(__u32))
+			dscpstatemask = rta_getattr_u32(
+					tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]);
+		else
+			print_string(PRINT_FP, NULL, "%s",
+				     "[invalid dscp statemask parameter]");
+	}
+
+	if (tb[TCA_CTINFO_PARMS_CPMARK_MASK]) {
+		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_CPMARK_MASK]) >=
+		    sizeof(__u32))
+			cpmarkmask = rta_getattr_u32(
+					tb[TCA_CTINFO_PARMS_CPMARK_MASK]);
+		else
+			print_string(PRINT_FP, NULL, "%s",
+				     "[invalid cpmark mask parameter]");
+	}
+
+	if (tb[TCA_CTINFO_ZONE] && RTA_PAYLOAD(tb[TCA_CTINFO_ZONE]) >=
+	    sizeof(__u16))
+		zone = rta_getattr_u16(tb[TCA_CTINFO_ZONE]);
+
+	print_string(PRINT_ANY, "kind", "%s ", "ctinfo");
+	print_hu(PRINT_ANY, "zone", "zone %u", zone);
+	print_action_control(f, " ", ci->action, "");
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+	print_uint(PRINT_ANY, "index", "\t index %u", ci->index);
+	print_int(PRINT_ANY, "ref", " ref %d", ci->refcnt);
+	print_int(PRINT_ANY, "bind", " bind %d", ci->bindcnt);
+
+	if (tb[TCA_CTINFO_PARMS_DSCP_MASK]) {
+		print_0xhex(PRINT_ANY, "dscpmask", " dscp %#010llx", dscpmask);
+		print_0xhex(PRINT_ANY, "dscpstatemask", " %#010llx",
+			    dscpstatemask);
+	}
+
+	if (tb[TCA_CTINFO_PARMS_CPMARK_MASK])
+		print_0xhex(PRINT_ANY, "cpmark", " cpmark %#010llx",
+			    cpmarkmask);
+
+	if (show_stats)
+		print_ctinfo_stats(f, tb);
+
+	print_string(PRINT_FP, NULL, "%s", _SL_);
+
+	return 0;
+}
+
+struct action_util ctinfo_action_util = {
+	.id = "ctinfo",
+	.parse_aopt = parse_ctinfo,
+	.print_aopt = print_ctinfo,
+};
-- 
2.20.1 (Apple Git-117)

