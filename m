Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3994E2D6B7D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbgLJXDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730455AbgLJXDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:03:16 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641CEC061794
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:01 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CsTwN0KBJzQlRP;
        Fri, 11 Dec 2020 00:03:00 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OsYMdm6KVrs7xygwHiYBXZsFqUGkNpanmtlbARXZoOs=;
        b=1aFSJ3hyRG+qN2+6UtMSm9+g6ZTwOQ1b8A+oi1kj0Hu2D95eKq45re8ez5V5FMBHC+XM1k
        mnu2mTPU2D5D/uRdR9fjtmyf6VgdAlg9sL0E0V6xppKE1cwyS5QxOB4NtdaPjARsMmzfzh
        aecrAUMQBT7DZG9z9eoydQdTPG6yopCqmacR5s0SzoBzDG9+HArd3+e2i827zI8r45oB3I
        N2CpYRbJ+Z/9DMkfVlIXjqxaAn6Swh9ZEKTNAKLkXoPa+K/w6T2kSwcwqgGrEfjvIFgB4n
        SvqhAqkLi5P3OYg+wTH+LI0JEwOu6HwuN80n0UMY8cP9pAMtMvwzrl3bcQd3sg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id nay2Pc9wc23V; Fri, 11 Dec 2020 00:02:55 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 08/10] dcb: Add a subtool for the DCB PFC object
Date:   Fri, 11 Dec 2020 00:02:22 +0100
Message-Id: <5336f4f90fbebf46b6ee2525e22054b0ed67ea66.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.33 / 15.00 / 15.00
X-Rspamd-Queue-Id: E7EE2177D
X-Rspamd-UID: 0cd315
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PFC, for "Priority-based Flow Control", allows configuration of priority
lossiness, and related toggles.

Add a dcb subtool to allow showing and tweaking of individual PFC
configuration options, and querying statistics. For example:

    # dcb pfc show dev eni1np1
    pfc-cap 8 macsec-bypass on delay 0
    pg-pfc 0:off 1:on 2:off 3:off 4:off 5:off 6:off 7:on
    requests 0:0 1:217 2:0 3:0 4:0 5:0 6:0 7:28
    indications 0:0 1:179 2:0 3:0 4:0 5:0 6:0 7:18

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/Makefile       |   2 +-
 dcb/dcb.c          |  27 ++++-
 dcb/dcb.h          |   6 +
 dcb/dcb_pfc.c      | 286 +++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-pfc.8 | 127 ++++++++++++++++++++
 man/man8/dcb.8     |   9 +-
 6 files changed, 453 insertions(+), 4 deletions(-)
 create mode 100644 dcb/dcb_pfc.c
 create mode 100644 man/man8/dcb-pfc.8

diff --git a/dcb/Makefile b/dcb/Makefile
index 895817163562..ea557a309e81 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -5,7 +5,7 @@ TARGETS :=
 
 ifeq ($(HAVE_MNL),y)
 
-DCBOBJ = dcb.o dcb_ets.o
+DCBOBJ = dcb.o dcb_ets.o dcb_pfc.o
 TARGETS += dcb
 
 endif
diff --git a/dcb/dcb.c b/dcb/dcb.c
index 4b4a5b9354c6..cc07d3ddcee0 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 
+#include <inttypes.h>
 #include <stdio.h>
 #include <linux/dcbnl.h>
 #include <libmnl/libmnl.h>
@@ -201,6 +202,28 @@ void dcb_print_array_u8(const __u8 *array, size_t size)
 	}
 }
 
+void dcb_print_array_u64(const __u64 *array, size_t size)
+{
+	SPRINT_BUF(b);
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		snprintf(b, sizeof(b), "%zd:%%" PRIu64 " ", i);
+		print_u64(PRINT_ANY, NULL, b, array[i]);
+	}
+}
+
+void dcb_print_array_on_off(const __u8 *array, size_t size)
+{
+	SPRINT_BUF(b);
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		snprintf(b, sizeof(b), "%zd:%%s ", i);
+		print_on_off(PRINT_ANY, NULL, b, array[i]);
+	}
+}
+
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size)
 {
@@ -309,7 +332,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
-		"where  OBJECT := ets\n"
+		"where  OBJECT := { ets | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
 }
@@ -321,6 +344,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 		return 0;
 	} else if (matches(*argv, "ets") == 0) {
 		return dcb_cmd_ets(dcb, argc - 1, argv + 1);
+	} else if (matches(*argv, "pfc") == 0) {
+		return dcb_cmd_pfc(dcb, argc - 1, argv + 1);
 	}
 
 	fprintf(stderr, "Object \"%s\" is unknown\n", *argv);
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 8637efc159b9..4ecc6afd59a9 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -37,6 +37,8 @@ void dcb_print_named_array(const char *json_name, const char *fp_name,
 			   const __u8 *array, size_t size,
 			   void (*print_array)(const __u8 *, size_t));
 void dcb_print_array_u8(const __u8 *array, size_t size);
+void dcb_print_array_u64(const __u64 *array, size_t size);
+void dcb_print_array_on_off(const __u8 *array, size_t size);
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
@@ -44,4 +46,8 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
 
 int dcb_cmd_ets(struct dcb *dcb, int argc, char **argv);
 
+/* dcb_pfc.c */
+
+int dcb_cmd_pfc(struct dcb *dcb, int argc, char **argv);
+
 #endif /* __DCB_H__ */
diff --git a/dcb/dcb_pfc.c b/dcb/dcb_pfc.c
new file mode 100644
index 000000000000..aaa09022e247
--- /dev/null
+++ b/dcb/dcb_pfc.c
@@ -0,0 +1,286 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <errno.h>
+#include <stdio.h>
+#include <linux/dcbnl.h>
+
+#include "dcb.h"
+#include "utils.h"
+
+static void dcb_pfc_help_set(void)
+{
+	fprintf(stderr,
+		"Usage: dcb pfc set dev STRING\n"
+		"           [ prio-pfc PFC-MAP ]\n"
+		"           [ macsec-bypass { on | off } ]\n"
+		"           [ delay INTEGER ]\n"
+		"\n"
+		" where PFC-MAP := [ PFC-MAP ] PFC-MAPPING\n"
+		"       PFC-MAPPING := { all | TC }:PFC\n"
+		"       TC := { 0 .. 7 }\n"
+		"       PFC := { on | off }\n"
+		"\n"
+	);
+}
+
+static void dcb_pfc_help_show(void)
+{
+	fprintf(stderr,
+		"Usage: dcb [ -s ] pfc show dev STRING\n"
+		"           [ pfc-cap ] [ prio-pfc ] [ macsec-bypass ]\n"
+		"           [ delay ] [ requests ] [ indications ]\n"
+		"\n"
+	);
+}
+
+static void dcb_pfc_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb pfc help\n"
+		"\n"
+	);
+	dcb_pfc_help_show();
+	dcb_pfc_help_set();
+}
+
+static void dcb_pfc_to_array(__u8 array[IEEE_8021QAZ_MAX_TCS], __u8 pfc_en)
+{
+	int i;
+
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
+		array[i] = !!(pfc_en & (1 << i));
+}
+
+static void dcb_pfc_from_array(__u8 array[IEEE_8021QAZ_MAX_TCS], __u8 *pfc_en_p)
+{
+	__u8 pfc_en = 0;
+	int i;
+
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		if (array[i])
+			pfc_en |= 1 << i;
+	}
+
+	*pfc_en_p = pfc_en;
+}
+
+static int dcb_pfc_parse_mapping_prio_pfc(__u32 key, char *value, void *data)
+{
+	struct ieee_pfc *pfc = data;
+	__u8 pfc_en[IEEE_8021QAZ_MAX_TCS];
+	bool enabled;
+	int ret;
+
+	dcb_pfc_to_array(pfc_en, pfc->pfc_en);
+
+	enabled = parse_on_off("PFC", value, &ret);
+	if (ret)
+		return ret;
+
+	ret = dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
+				"PFC", enabled, -1,
+				dcb_set_u8, pfc_en);
+	if (ret)
+		return ret;
+
+	dcb_pfc_from_array(pfc_en, &pfc->pfc_en);
+	return 0;
+}
+
+static void dcb_pfc_print_pfc_cap(const struct ieee_pfc *pfc)
+{
+	print_uint(PRINT_ANY, "pfc_cap", "pfc-cap %d ", pfc->pfc_cap);
+}
+
+static void dcb_pfc_print_macsec_bypass(const struct ieee_pfc *pfc)
+{
+	print_on_off(PRINT_ANY, "macsec_bypass", "macsec-bypass %s ", pfc->mbc);
+}
+
+static void dcb_pfc_print_delay(const struct ieee_pfc *pfc)
+{
+	print_uint(PRINT_ANY, "delay", "delay %d ", pfc->delay);
+}
+
+static void dcb_pfc_print_prio_pfc(const struct ieee_pfc *pfc)
+{
+	__u8 pfc_en[IEEE_8021QAZ_MAX_TCS];
+
+	dcb_pfc_to_array(pfc_en, pfc->pfc_en);
+	dcb_print_named_array("prio_pfc", "prio-pfc",
+			      pfc_en, ARRAY_SIZE(pfc_en), &dcb_print_array_on_off);
+}
+
+static void dcb_pfc_print_requests(const struct ieee_pfc *pfc)
+{
+	open_json_array(PRINT_JSON, "requests");
+	print_string(PRINT_FP, NULL, "requests ", NULL);
+	dcb_print_array_u64(pfc->requests, ARRAY_SIZE(pfc->requests));
+	close_json_array(PRINT_JSON, "requests");
+}
+
+static void dcb_pfc_print_indications(const struct ieee_pfc *pfc)
+{
+	open_json_array(PRINT_JSON, "indications");
+	print_string(PRINT_FP, NULL, "indications ", NULL);
+	dcb_print_array_u64(pfc->indications, ARRAY_SIZE(pfc->indications));
+	close_json_array(PRINT_JSON, "indications");
+}
+
+static void dcb_pfc_print(const struct dcb *dcb, const struct ieee_pfc *pfc)
+{
+	dcb_pfc_print_pfc_cap(pfc);
+	dcb_pfc_print_macsec_bypass(pfc);
+	dcb_pfc_print_delay(pfc);
+	print_nl();
+
+	dcb_pfc_print_prio_pfc(pfc);
+	print_nl();
+
+	if (dcb->stats) {
+		dcb_pfc_print_requests(pfc);
+		print_nl();
+
+		dcb_pfc_print_indications(pfc);
+		print_nl();
+	}
+}
+
+static int dcb_pfc_get(struct dcb *dcb, const char *dev, struct ieee_pfc *pfc)
+{
+	return dcb_get_attribute(dcb, dev, DCB_ATTR_IEEE_PFC, pfc, sizeof(*pfc));
+}
+
+static int dcb_pfc_set(struct dcb *dcb, const char *dev, const struct ieee_pfc *pfc)
+{
+	return dcb_set_attribute(dcb, dev, DCB_ATTR_IEEE_PFC, pfc, sizeof(*pfc));
+}
+
+static int dcb_cmd_pfc_set(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct ieee_pfc pfc;
+	int ret;
+
+	if (!argc) {
+		dcb_pfc_help_set();
+		return 0;
+	}
+
+	ret = dcb_pfc_get(dcb, dev, &pfc);
+	if (ret)
+		return ret;
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_pfc_help_set();
+			return 0;
+		} else if (matches(*argv, "prio-pfc") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true,
+					    &dcb_pfc_parse_mapping_prio_pfc, &pfc);
+			if (ret) {
+				fprintf(stderr, "Invalid pfc mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "macsec-bypass") == 0) {
+			NEXT_ARG();
+			pfc.mbc = parse_on_off("macsec-bypass", *argv, &ret);
+			if (ret)
+				return ret;
+		} else if (matches(*argv, "delay") == 0) {
+			NEXT_ARG();
+			/* Do not support the size notations for delay.
+			 * Delay is specified in "bit times", not bits, so
+			 * it is not applicable. At the same time it would
+			 * be confusing that 10Kbit does not mean 10240,
+			 * but 1280.
+			 */
+			if (get_u16(&pfc.delay, *argv, 0)) {
+				fprintf(stderr, "Invalid delay `%s', expected an integer 0..65535\n",
+					*argv);
+				return -EINVAL;
+			}
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_pfc_help_set();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+	return dcb_pfc_set(dcb, dev, &pfc);
+}
+
+static int dcb_cmd_pfc_show(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct ieee_pfc pfc;
+	int ret;
+
+	ret = dcb_pfc_get(dcb, dev, &pfc);
+	if (ret)
+		return ret;
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_pfc_print(dcb, &pfc);
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_pfc_help_show();
+			return 0;
+		} else if (matches(*argv, "prio-pfc") == 0) {
+			dcb_pfc_print_prio_pfc(&pfc);
+			print_nl();
+		} else if (matches(*argv, "pfc-cap") == 0) {
+			dcb_pfc_print_pfc_cap(&pfc);
+			print_nl();
+		} else if (matches(*argv, "macsec-bypass") == 0) {
+			dcb_pfc_print_macsec_bypass(&pfc);
+			print_nl();
+		} else if (matches(*argv, "delay") == 0) {
+			dcb_pfc_print_delay(&pfc);
+			print_nl();
+		} else if (matches(*argv, "requests") == 0) {
+			dcb_pfc_print_requests(&pfc);
+			print_nl();
+		} else if (matches(*argv, "indications") == 0) {
+			dcb_pfc_print_indications(&pfc);
+			print_nl();
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_pfc_help_show();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+out:
+	close_json_object();
+	return 0;
+}
+
+int dcb_cmd_pfc(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_pfc_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_pfc_show, dcb_pfc_help_show);
+	} else if (matches(*argv, "set") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_pfc_set, dcb_pfc_help_set);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_pfc_help();
+		return -EINVAL;
+	}
+}
diff --git a/man/man8/dcb-pfc.8 b/man/man8/dcb-pfc.8
new file mode 100644
index 000000000000..735c16e066cb
--- /dev/null
+++ b/man/man8/dcb-pfc.8
@@ -0,0 +1,127 @@
+.TH DCB-PFC 8 "31 October 2020" "iproute2" "Linux"
+.SH NAME
+dcb-pfc \- show / manipulate PFC (Priority-based Flow Control) settings of
+the DCB (Data Center Bridging) subsystem
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B pfc
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb pfc show dev
+.RI DEV
+.RB "[ " pfc-cap " ]"
+.RB "[ " prio-pfc " ]"
+.RB "[ " macsec-bypass " ]"
+.RB "[ " delay " ]"
+.RB "[ " requests " ]"
+.RB "[ " indications " ]"
+
+.ti -8
+.B dcb pfc set dev
+.RI DEV
+.RB "[ " prio-pfc " " \fIPFC-MAP " ]"
+.RB "[ " macsec-bypass " { " on " | " off " } ]"
+.RB "[ " delay " " \fIINTEGER\fR " ]"
+
+.ti -8
+.IR PFC-MAP " := [ " PFC-MAP " ] " PFC-MAPPING
+
+.ti -8
+.IR PFC-MAPPING " := { " PRIO " | " \fBall " }" \fB:\fR "{ "
+.IR \fBon\fR " | " \fBoff\fR " }"
+
+.ti -8
+.IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
+
+.SH DESCRIPTION
+
+.B dcb pfc
+is used to configure Priority-based Flow Control attributes through Linux
+DCB (Data Center Bridging) interface. PFC permits marking flows with a
+certain priority as lossless, and holds related configuration, as well as
+PFC counters.
+
+.SH PARAMETERS
+
+For read-write parameters, the following describes only the write direction,
+i.e. as used with the \fBset\fR command. For the \fBshow\fR command, the
+parameter name is to be used as a simple keyword without further arguments. This
+instructs the tool to show the value of a given parameter. When no parameters
+are given, the tool shows the complete PFC configuration.
+
+.TP
+.B pfc-cap
+A read-only property that shows the number of traffic classes that may
+simultaneously support PFC.
+
+.TP
+.B requests
+A read-only count of the sent PFC frames per traffic class. Only shown when
+-s is given, or when requested explicitly.
+
+.TP
+.B indications
+A read-only count of the received PFC frames per traffic class. Only shown
+when -s is given, or when requested explicitly.
+
+.TP
+.B macsec-bypass \fR{ \fBon\fR | \fBoff\fR }
+Whether the sending station is capable of bypassing MACsec processing when
+MACsec is disabled.
+
+.TP
+.B prio-pfc \fIPFC-MAP
+\fIPFC-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are priorities, values are on / off indicators of whether
+PFC is enabled for a given priority.
+
+.TP
+.B delay \fIINTEGER
+The allowance made for round-trip propagation delay of the link in bits.
+The value shall be 0..65535.
+
+.SH EXAMPLE & USAGE
+
+Enable PFC on priorities 6 and 7, leaving the rest intact:
+
+.P
+# dcb pfc set dev eth0 prio-pfc 6:on 7:on
+
+Disable PFC of all priorities except 6 and 7, and configure delay to 4096
+bits:
+
+.P
+# dcb pfc set dev eth0 prio-pfc all:off 6:on 7:on delay 0x1000
+
+Show what was set:
+
+.P
+# dcb pfc show dev eth0
+.br
+pfc-cap 8 macsec-bypass off delay 4096
+.br
+prio-pfc 0:off 1:off 2:off 3:off 4:off 5:off 6:on 7:on
+
+.SH EXIT STATUS
+Exit status is 0 if command was successful or a positive integer upon failure.
+
+.SH SEE ALSO
+.BR dcb (8)
+
+.SH REPORTING BUGS
+Report any bugs to the Network Developers mailing list
+.B <netdev@vger.kernel.org>
+where the development and maintenance is primarily done.
+You do not have to be subscribed to the list to send a message there.
+
+.SH AUTHOR
+Petr Machata <me@pmachata.org>
diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index 15b43942585a..01febe166bdf 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -9,7 +9,7 @@ dcb \- show / manipulate DCB (Data Center Bridging) settings
 .ti -8
 .B dcb
 .RI "[ " OPTIONS " ] "
-.B ets
+.RB "{ " ets " | " pfc " }"
 .RI "{ " COMMAND " | " help " }"
 .sp
 
@@ -67,6 +67,10 @@ part of the "show" output.
 .B ets
 - Configuration of ETS (Enhanced Transmission Selection)
 
+.TP
+.B pfc
+- Configuration of PFC (Priority-based Flow Control)
+
 .SH COMMANDS
 
 A \fICOMMAND\fR specifies the action to perform on the object. The set of
@@ -111,7 +115,8 @@ other values:
 Exit status is 0 if command was successful or a positive integer upon failure.
 
 .SH SEE ALSO
-.BR dcb-ets (8)
+.BR dcb-ets (8),
+.BR dcb-pfc (8)
 .br
 
 .SH REPORTING BUGS
-- 
2.25.1

