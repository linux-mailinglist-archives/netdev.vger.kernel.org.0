Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26918215DFE
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgGFSI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:08:27 -0400
Received: from out0-140.mail.aliyun.com ([140.205.0.140]:50195 "EHLO
        out0-140.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbgGFSI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594058903; h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type;
        bh=TYFCdz/pgVS5oEbj32eO/a40jSRAlgfpv089pVjzqPU=;
        b=hcPyEHDzm672klh1v7grFcP5wzZY2zd7XLXOQOFKnPuE9mX+Cc7UUEWb55fS+4+NQz5xZ9dtcS7koBMCQ/S33E/KlAlDqR2x/GWnGZVUdP6oGK2dJJxUCtWu5EEJjt0P86kWSWLVAaDRjTK4otqF4caMx9xP4s8BSd5aooq4OWA=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01l07381;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.Hz20VxX_1594058901;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.Hz20VxX_1594058901)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 02:08:22 +0800
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Subject: [PATCH iproute2-next] iproute2 Support lockless token bucket (LTB)
To:     netdev@vger.kernel.org
Message-ID: <0010e146-ccda-ee6b-819b-96e518204f8a@alibaba-inc.com>
Date:   Tue, 07 Jul 2020 02:08:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new tc command parameter "ltb" to allow configuring lockless
token bucket qdisc.

For example:

        # tc qdisc add dev eth0 root handle 1: ltb default 10
        # tc class add dev eth0 parent 1: classid 1:10 ltb \
                rate 3000Mbit ceil 9000Mbit prio 3

Signed-off-by: Xiangning Yu <xiangning.yu@alibaba-inc.com>
---
 include/uapi/linux/pkt_sched.h |  35 +++++++
 tc/Makefile                    |   1 +
 tc/q_ltb.c                     | 223 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+)
 create mode 100644 tc/q_ltb.c

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index a95f3ae..523d0ea 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -445,6 +445,41 @@ struct tc_htb_xstats {
 	__s32 ctokens;
 };
 
+/* LTB section */
+
+#define TC_LTB_PROTOVER         3 /* the same as LTB and TC's major */
+#define TC_LTB_NUMPRIO          16
+enum {
+        TCA_LTB_UNSPEC,
+        TCA_LTB_PARMS,
+        TCA_LTB_INIT,
+        TCA_LTB_RATE64,
+        TCA_LTB_CEIL64,
+        TCA_LTB_PAD,
+        __TCA_LTB_MAX,
+};
+#define TCA_LTB_MAX (__TCA_LTB_MAX - 1)
+
+struct tc_ltb_opt {
+        struct tc_ratespec      rate;
+        struct tc_ratespec      ceil;
+        __u64   measured;
+        __u64	allocated;
+        __u64	high_water;
+        __u32	prio;
+};
+
+struct tc_ltb_glob {
+        __u32 version;          /* to match LTB/TC */
+        __u32 defcls;           /* default class number */
+};
+
+struct tc_ltb_xstats {
+        __u64 measured;
+        __u64 allocated;
+        __u64 high_water;
+};
+
 /* HFSC section */
 
 struct tc_hfsc_qopt {
diff --git a/tc/Makefile b/tc/Makefile
index 79c9c1d..9ccf30b 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -35,6 +35,7 @@ TCMODULES += f_tcindex.o
 TCMODULES += q_ingress.o
 TCMODULES += q_hfsc.o
 TCMODULES += q_htb.o
+TCMODULES += q_ltb.o
 TCMODULES += q_drr.o
 TCMODULES += q_qfq.o
 TCMODULES += m_gact.o
diff --git a/tc/q_ltb.c b/tc/q_ltb.c
new file mode 100644
index 0000000..dc96910
--- /dev/null
+++ b/tc/q_ltb.c
@@ -0,0 +1,223 @@
+/*
+ * q_ltb.c		LTB.
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Xiangning Yu <xiangning.yu@alibaba-inc.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <syslog.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+
+#include "utils.h"
+#include "tc_util.h"
+#define LTB_TC_VER	0x30001
+
+static void explain(void)
+{
+	fprintf(stderr, "Usage: ... qdisc add ... ltb [default N]\n"
+		" default  minor id of class to which unclassified packets are sent {0}\n"
+		" rate     rate allocated to this class (class can still borrow)\n"
+		" ceil     definite upper class rate (no borrows) {rate}\n"
+		" prio     priority of leaf; lower are served first {0}\n"
+		"\nTC LTB version %d.%d\n", LTB_TC_VER >> 16,
+		LTB_TC_VER & 0xffff
+		);
+}
+
+static void explain1(char *arg)
+{
+	fprintf(stderr, "Illegal \"%s\"\n", arg);
+	explain();
+}
+
+static int ltb_parse_opt(struct qdisc_util *qu, int argc, char **argv,
+			 struct nlmsghdr *n, const char *dev)
+{
+	struct tc_ltb_glob opt;
+	struct rtattr *tail;
+
+	memset(&opt, 0, sizeof(opt));
+	opt.version = 3;
+	while (argc > 0) {
+		if (matches(*argv, "default") == 0) {
+			NEXT_ARG();
+			if (get_u32(&opt.defcls, *argv, 16)) {
+				explain1("default");
+				return -1;
+			}
+		} else {
+			explain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+
+	tail = addattr_nest(n, 1024, TCA_OPTIONS);
+	addattr_l(n, 2024, TCA_LTB_INIT, &opt, NLMSG_ALIGN(sizeof(opt)));
+	addattr_nest_end(n, tail);
+	return 0;
+}
+
+static int ltb_parse_class_opt(struct qdisc_util *qu, int argc, char **argv,
+			       struct nlmsghdr *n, const char *dev)
+{
+	struct tc_ltb_opt opt;
+	struct rtattr *tail;
+	__u64 ceil64 = 0, rate64 = 0;
+
+	memset(&opt, 0, sizeof(opt));
+	while (argc > 0) {
+		if (matches(*argv, "prio") == 0) {
+			NEXT_ARG();
+			if (get_u32(&opt.prio, *argv, 10)) {
+				explain1("prio");
+				return -1;
+			}
+		} else if (strcmp(*argv, "ceil") == 0) {
+			NEXT_ARG();
+			if (ceil64) {
+				fprintf(stderr, "Double \"ceil\" spec\n");
+				return -1;
+			}
+			if (strchr(*argv, '%')) {
+				if (get_percent_rate64(&ceil64, *argv, dev)) {
+					explain1("ceil");
+					return -1;
+				}
+			} else if (get_rate64(&ceil64, *argv)) {
+				explain1("ceil");
+				return -1;
+			}
+		} else if (strcmp(*argv, "rate") == 0) {
+			NEXT_ARG();
+			if (rate64) {
+				fprintf(stderr, "Double \"rate\" spec\n");
+				return -1;
+			}
+			if (strchr(*argv, '%')) {
+				if (get_percent_rate64(&rate64, *argv, dev)) {
+					explain1("rate");
+					return -1;
+				}
+			} else if (get_rate64(&rate64, *argv)) {
+				explain1("rate");
+				return -1;
+			}
+		} else if (strcmp(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+		argc--; argv++;
+	}
+
+	if (!rate64) {
+		fprintf(stderr, "\"rate\" is required.\n");
+		return -1;
+	}
+	/* if ceil params are missing, use the same as rate */
+	if (!ceil64)
+		ceil64 = rate64;
+
+	opt.rate.rate = (rate64 >= (1ULL << 32)) ? ~0U : rate64;
+	opt.ceil.rate = (ceil64 >= (1ULL << 32)) ? ~0U : ceil64;
+
+	opt.ceil.overhead = 0;
+	opt.rate.overhead = 0;
+	opt.ceil.mpu = 0;
+	opt.rate.mpu = 0;
+
+	tail = addattr_nest(n, 1024, TCA_OPTIONS);
+
+	if (rate64 >= (1ULL << 32))
+		addattr_l(n, 1124, TCA_LTB_RATE64, &rate64, sizeof(rate64));
+
+	if (ceil64 >= (1ULL << 32))
+		addattr_l(n, 1224, TCA_LTB_CEIL64, &ceil64, sizeof(ceil64));
+
+	addattr_l(n, 2024, TCA_LTB_PARMS, &opt, sizeof(opt));
+	addattr_nest_end(n, tail);
+
+	return 0;
+}
+
+static int ltb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
+{
+	struct rtattr *tb[TCA_LTB_MAX + 1];
+	struct tc_ltb_opt *lopt;
+	struct tc_ltb_glob *gopt;
+	__u64 rate64, ceil64;
+
+	SPRINT_BUF(b1);
+	if (opt == NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_LTB_MAX, opt);
+
+	if (tb[TCA_LTB_PARMS]) {
+		lopt = RTA_DATA(tb[TCA_LTB_PARMS]);
+		if (RTA_PAYLOAD(tb[TCA_LTB_PARMS])  < sizeof(*lopt))
+			return -1;
+
+		fprintf(f, "prio %d ", (int)lopt->prio);
+
+		rate64 = lopt->rate.rate;
+		if (tb[TCA_LTB_RATE64] &&
+		    RTA_PAYLOAD(tb[TCA_LTB_RATE64]) >= sizeof(rate64)) {
+			rate64 = *(__u64 *)RTA_DATA(tb[TCA_LTB_RATE64]);
+		}
+
+		ceil64 = lopt->ceil.rate;
+		if (tb[TCA_LTB_CEIL64] &&
+		    RTA_PAYLOAD(tb[TCA_LTB_CEIL64]) >= sizeof(ceil64))
+			ceil64 = *(__u64 *)RTA_DATA(tb[TCA_LTB_CEIL64]);
+
+		fprintf(f, "rate %s ", sprint_rate(rate64, b1));
+		fprintf(f, "ceil %s ", sprint_rate(ceil64, b1));
+		if (show_details) {
+			fprintf(f, "measured %llu allocated %llu "
+				"highwater %llu", lopt->measured,
+				lopt->allocated, lopt->high_water);
+		}
+	}
+	if (tb[TCA_LTB_INIT]) {
+		gopt = RTA_DATA(tb[TCA_LTB_INIT]);
+		if (RTA_PAYLOAD(tb[TCA_LTB_INIT])  < sizeof(*gopt))
+			return -1;
+
+		fprintf(f, "default %x", gopt->defcls);
+		if (show_details)
+			fprintf(f, " ver %d.%d", gopt->version >> 16,
+				gopt->version & 0xffff);
+	}
+	return 0;
+}
+
+static int ltb_print_xstats(struct qdisc_util *qu, FILE *f,
+			    struct rtattr *xstats)
+{
+	return 0;
+}
+
+struct qdisc_util ltb_qdisc_util = {
+	.id		= "ltb",
+	.parse_qopt	= ltb_parse_opt,
+	.print_qopt	= ltb_print_opt,
+	.print_xstats	= ltb_print_xstats,
+	.parse_copt	= ltb_parse_class_opt,
+	.print_copt	= ltb_print_opt,
+};
-- 
1.8.3.1

