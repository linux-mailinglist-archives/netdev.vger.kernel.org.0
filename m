Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A6F2D6B80
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389008AbgLJXEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388123AbgLJXDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:03:42 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2BC0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 15:03:01 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CsTwN12RhzQlXK;
        Fri, 11 Dec 2020 00:03:00 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1607641378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7YfeJwlNSM6ToaHRHVOi1WRajf1xi6nGNdikFGvT/l0=;
        b=mHwafhGIzo8TOyx+DCP9yT6aOS4ZrZ9lLvsjLYTf2Rvf7Mw3Pcut47CmD0NrrfBcQrhnaR
        Orxe9kw8nRnTfBdgMLxe0d5JEw2YO25DYrCaBNOkcE1KAWeLpuFghfnc0S4qB3c5omGRST
        nEo/JPWh/0VWWymWjR2OUyQbeHPr9hME7W37yk+Cs1PhPHpNWq0giTP+TK1Ll88htTvihK
        AeGQuysE5fkFLOi82yt8Yuz6stIcBzyrnXHpPyawQjn0A1YfyMERJ07VYQkLzwEL3PTEPw
        FSFJf9ih6nYG0tWIiTPxGRoHvxKhAmX7JGqo2mL+nntWt1xp6GSEbPhayOk/OA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id dhTggfQSRFdU; Fri, 11 Dec 2020 00:02:56 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 10/10] dcb: Add a subtool for the DCB maxrate object
Date:   Fri, 11 Dec 2020 00:02:24 +0100
Message-Id: <0842163a78e41b43e39e593a2d61ed73c29bc85d.1607640819.git.me@pmachata.org>
In-Reply-To: <cover.1607640819.git.me@pmachata.org>
References: <cover.1607640819.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.92 / 15.00 / 15.00
X-Rspamd-Queue-Id: 23B4B17A7
X-Rspamd-UID: a5fdfa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCBNL maxrate interfaces are an extension to the 802.1q DCB interfaces and
allow configuration of rate with which traffic in a given traffic class is
sent.

Add a dcb subtool to allow showing and tweaking of this per-TC maximum
rate. For example:

    # dcb maxrate show dev eni1np1
    tc-maxrate 0:25Gbit 1:25Gbit 2:25Gbit 3:25Gbit 4:25Gbit 5:25Gbit 6:100Gbit 7:25Gbit

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/Makefile           |   2 +-
 dcb/dcb.c              |   4 +-
 dcb/dcb.h              |   4 +
 dcb/dcb_maxrate.c      | 182 +++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-maxrate.8 |  94 +++++++++++++++++++++
 man/man8/dcb.8         |   7 +-
 6 files changed, 290 insertions(+), 3 deletions(-)
 create mode 100644 dcb/dcb_maxrate.c
 create mode 100644 man/man8/dcb-maxrate.8

diff --git a/dcb/Makefile b/dcb/Makefile
index dc84422f6096..4add954b4bba 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -5,7 +5,7 @@ TARGETS :=
 
 ifeq ($(HAVE_MNL),y)
 
-DCBOBJ = dcb.o dcb_buffer.o dcb_ets.o dcb_pfc.o
+DCBOBJ = dcb.o dcb_buffer.o dcb_ets.o dcb_maxrate.o dcb_pfc.o
 TARGETS += dcb
 
 endif
diff --git a/dcb/dcb.c b/dcb/dcb.c
index 570405a7e628..adec57476e1d 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -332,7 +332,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
-		"where  OBJECT := { buffer | ets | pfc }\n"
+		"where  OBJECT := { buffer | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -p | --pretty | -s | --statistics | -v | --verbose]\n");
 }
@@ -346,6 +346,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "ets") == 0) {
 		return dcb_cmd_ets(dcb, argc - 1, argv + 1);
+	} else if (matches(*argv, "maxrate") == 0) {
+		return dcb_cmd_maxrate(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "pfc") == 0) {
 		return dcb_cmd_pfc(dcb, argc - 1, argv + 1);
 	}
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 0638d63938fc..388a4204b95c 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -50,6 +50,10 @@ int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv);
 
 int dcb_cmd_ets(struct dcb *dcb, int argc, char **argv);
 
+/* dcb_maxrate.c */
+
+int dcb_cmd_maxrate(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_pfc.c */
 
 int dcb_cmd_pfc(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_maxrate.c b/dcb/dcb_maxrate.c
new file mode 100644
index 000000000000..1538c6d7c4cf
--- /dev/null
+++ b/dcb/dcb_maxrate.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <errno.h>
+#include <inttypes.h>
+#include <stdio.h>
+#include <linux/dcbnl.h>
+
+#include "dcb.h"
+#include "utils.h"
+
+static void dcb_maxrate_help_set(void)
+{
+	fprintf(stderr,
+		"Usage: dcb maxrate set dev STRING\n"
+		"           [ tc-maxrate RATE-MAP ]\n"
+		"\n"
+		" where RATE-MAP := [ RATE-MAP ] RATE-MAPPING\n"
+		"       RATE-MAPPING := { all | TC }:RATE\n"
+		"       TC := { 0 .. 7 }\n"
+		"\n"
+	);
+}
+
+static void dcb_maxrate_help_show(void)
+{
+	fprintf(stderr,
+		"Usage: dcb [ -i ] maxrate show dev STRING\n"
+		"           [ tc-maxrate ]\n"
+		"\n"
+	);
+}
+
+static void dcb_maxrate_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb maxrate help\n"
+		"\n"
+	);
+	dcb_maxrate_help_show();
+	dcb_maxrate_help_set();
+}
+
+static int dcb_maxrate_parse_mapping_tc_maxrate(__u32 key, char *value, void *data)
+{
+	__u64 rate;
+
+	if (get_rate64(&rate, value))
+		return -EINVAL;
+
+	return dcb_parse_mapping("TC", key, IEEE_8021QAZ_MAX_TCS - 1,
+				 "RATE", rate, -1,
+				 dcb_set_u64, data);
+}
+
+static void dcb_maxrate_print_tc_maxrate(struct dcb *dcb, const struct ieee_maxrate *maxrate)
+{
+	size_t size = ARRAY_SIZE(maxrate->tc_maxrate);
+	SPRINT_BUF(b);
+	size_t i;
+
+	open_json_array(PRINT_JSON, "tc_maxrate");
+	print_string(PRINT_FP, NULL, "tc-maxrate ", NULL);
+
+	for (i = 0; i < size; i++) {
+		snprintf(b, sizeof(b), "%zd:%%s ", i);
+		print_rate(dcb->use_iec, PRINT_ANY, NULL, b, maxrate->tc_maxrate[i]);
+	}
+
+	close_json_array(PRINT_JSON, "tc_maxrate");
+}
+
+static void dcb_maxrate_print(struct dcb *dcb, const struct ieee_maxrate *maxrate)
+{
+	dcb_maxrate_print_tc_maxrate(dcb, maxrate);
+	print_nl();
+}
+
+static int dcb_maxrate_get(struct dcb *dcb, const char *dev, struct ieee_maxrate *maxrate)
+{
+	return dcb_get_attribute(dcb, dev, DCB_ATTR_IEEE_MAXRATE, maxrate, sizeof(*maxrate));
+}
+
+static int dcb_maxrate_set(struct dcb *dcb, const char *dev, const struct ieee_maxrate *maxrate)
+{
+	return dcb_set_attribute(dcb, dev, DCB_ATTR_IEEE_MAXRATE, maxrate, sizeof(*maxrate));
+}
+
+static int dcb_cmd_maxrate_set(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct ieee_maxrate maxrate;
+	int ret;
+
+	if (!argc) {
+		dcb_maxrate_help_set();
+		return 0;
+	}
+
+	ret = dcb_maxrate_get(dcb, dev, &maxrate);
+	if (ret)
+		return ret;
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_maxrate_help_set();
+			return 0;
+		} else if (matches(*argv, "tc-maxrate") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true,
+					    &dcb_maxrate_parse_mapping_tc_maxrate, &maxrate);
+			if (ret) {
+				fprintf(stderr, "Invalid mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_maxrate_help_set();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+	return dcb_maxrate_set(dcb, dev, &maxrate);
+}
+
+static int dcb_cmd_maxrate_show(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct ieee_maxrate maxrate;
+	int ret;
+
+	ret = dcb_maxrate_get(dcb, dev, &maxrate);
+	if (ret)
+		return ret;
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_maxrate_print(dcb, &maxrate);
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_maxrate_help_show();
+			return 0;
+		} else if (matches(*argv, "tc-maxrate") == 0) {
+			dcb_maxrate_print_tc_maxrate(dcb, &maxrate);
+			print_nl();
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_maxrate_help_show();
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
+int dcb_cmd_maxrate(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_maxrate_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_maxrate_show, dcb_maxrate_help_show);
+	} else if (matches(*argv, "set") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv,
+					 dcb_cmd_maxrate_set, dcb_maxrate_help_set);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_maxrate_help();
+		return -EINVAL;
+	}
+}
diff --git a/man/man8/dcb-maxrate.8 b/man/man8/dcb-maxrate.8
new file mode 100644
index 000000000000..d03c215c08ed
--- /dev/null
+++ b/man/man8/dcb-maxrate.8
@@ -0,0 +1,94 @@
+.TH DCB-MAXRATE 8 "22 November 2020" "iproute2" "Linux"
+.SH NAME
+dcb-maxrate \- show / manipulate port maxrate settings of
+the DCB (Data Center Bridging) subsystem
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B maxrate
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb maxrate show dev
+.RI DEV
+.RB "[ " tc-maxrate " ]"
+
+.ti -8
+.B dcb maxrate set dev
+.RI DEV
+.RB "[ " tc-maxrate " " \fIRATE-MAP " ]"
+
+.ti -8
+.IR RATE-MAP " := [ " RATE-MAP " ] " RATE-MAPPING
+
+.ti -8
+.IR RATE-MAPPING " := { " TC " | " \fBall " }" \fB:\fIRATE\fR
+
+.ti -8
+.IR TC " := { " \fB0\fR " .. " \fB7\fR " }"
+
+.ti -8
+.IR RATE " := { " INTEGER "[" \fBbit\fR "] | " INTEGER\fBKbit\fR " | "
+.IR INTEGER\fBMib\fR " | " ... " }"
+
+.SH DESCRIPTION
+
+.B dcb maxrate
+is used to configure and inspect maximum rate at which traffic is allowed to
+egress from a given traffic class.
+
+.SH PARAMETERS
+
+The following describes only the write direction, i.e. as used with the
+\fBset\fR command. For the \fBshow\fR command, the parameter name is to be used
+as a simple keyword without further arguments. This instructs the tool to show
+the value of a given parameter. When no parameters are given, the tool shows the
+complete maxrate configuration.
+
+.TP
+.B tc-maxrate \fIRATE-MAP
+\fIRATE-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are TC indices, values are traffic rates in bits per second.
+The rates can use the notation documented in section PARAMETERS at
+.BR tc (8).
+Note that under that notation, "bit" stands for bits per second whereas "b"
+stands for bytes per second. When showing, the command line option
+.B -i
+toggles between using decadic and ISO/IEC prefixes.
+
+.SH EXAMPLE & USAGE
+
+Set rates of all traffic classes to 25Gbps, except for TC 6, which will
+have the rate of 100Gbps:
+
+.P
+# dcb maxrate set dev eth0 tc-maxrate all:25Gbit 6:100Gbit
+
+Show what was set:
+
+.P
+# dcb maxrate show dev eth0
+.br
+tc-maxrate 0:25Gbit 1:25Gbit 2:25Gbit 3:25Gbit 4:25Gbit 5:25Gbit 6:100Gbit 7:25Gbit
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
index e14762365cef..5964f25d386d 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -9,7 +9,7 @@ dcb \- show / manipulate DCB (Data Center Bridging) settings
 .ti -8
 .B dcb
 .RI "[ " OPTIONS " ] "
-.RB "{ " buffer " | " ets " | " pfc " }"
+.RB "{ " buffer " | " ets " | " maxrate " | " pfc " }"
 .RI "{ " COMMAND " | " help " }"
 .sp
 
@@ -71,6 +71,10 @@ part of the "show" output.
 .B ets
 - Configuration of ETS (Enhanced Transmission Selection)
 
+.TP
+.B maxrate
+- Configuration of per-TC maximum transmit rate
+
 .TP
 .B pfc
 - Configuration of PFC (Priority-based Flow Control)
@@ -121,6 +125,7 @@ Exit status is 0 if command was successful or a positive integer upon failure.
 .SH SEE ALSO
 .BR dcb-buffer (8),
 .BR dcb-ets (8),
+.BR dcb-maxrate (8),
 .BR dcb-pfc (8)
 .br
 
-- 
2.25.1

