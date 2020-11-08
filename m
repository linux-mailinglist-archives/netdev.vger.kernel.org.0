Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658A12AABBF
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 16:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgKHPIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 10:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgKHPIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 10:08:42 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E73C0613D2
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 07:08:41 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CTcvq60GczQlLp;
        Sun,  8 Nov 2020 16:08:39 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604848118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J5AUQJLSWkW6Cvod4xw0/VAPdxFFmOcxBVzggDZtvJ4=;
        b=vgZys5vAGuZ8jrn4KWTXsj+dKb1PmPnfpxnY0hh7/GGh4oLReIoZ7Zbi8W68Fie9Zqh/lF
        EzyJqrcYZt5nfHjSL7EfMAYoN0Ljk91zFvjcSYOqum8eqseJBZ+DDW0wGQeZFsYihoiF4h
        +asYcq+wq3edpVfDJOLHTbHNPNfz4UWxpTMFhM82UaY7z/nxBCVV93CuRq4LLTXi03sZtz
        COA/dTl13aPKWuctM4oTeiIBuBzRlg67XfVwXXBYFb8Annd7lsh3Dq2GqW5tbwXdCpI2kx
        guBjwkXwmZqGwYQ61mS8KSfp3FS7Cbiscf191X+agmKQYllFlJcx8ErX511QYg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id 7U8GmwPj1LqV; Sun,  8 Nov 2020 16:08:35 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v3 11/11] dcb: Add a subtool for the DCB ETS object
Date:   Sun,  8 Nov 2020 16:07:32 +0100
Message-Id: <9aa69e80900fe86b2200785055ea55b18ec3c7ec.1604847919.git.me@pmachata.org>
In-Reply-To: <cover.1604847919.git.me@pmachata.org>
References: <cover.1604847919.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.10 / 15.00 / 15.00
X-Rspamd-Queue-Id: C65761709
X-Rspamd-UID: 8f63b3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETS, for "Enhanced Transmission Selection", is a set of configurations that
permit configuration of mapping of priorities to traffic classes, traffic
selection algorithm to use per traffic class, bandwidth allocation, etc.

Add a dcb subtool to allow showing and tweaking of individual ETS
configuration options. For example:

    # dcb ets show dev eni1np1
    willing on ets_cap 8 cbs off
    tc-bw 0:0 1:0 2:0 3:0 4:100 5:0 6:0 7:0
    pg-bw 0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0
    tc-tsa 0:strict 1:strict 2:strict 3:strict 4:ets 5:strict 6:strict 7:strict
    prio-tc 0:1 1:3 2:5 3:0 4:0 5:0 6:0 7:0
    reco-tc-bw 0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0
    reco-tc-tsa 0:strict 1:strict 2:strict 3:strict 4:strict 5:strict 6:strict 7:strict
    reco-prio-tc 0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0

Signed-off-by: Petr Machata <me@pmachata.org>
---

Notes:
    v3:
    - Formatting tweaks in the man page

 dcb/Makefile       |   2 +-
 dcb/dcb.c          |   4 +-
 dcb/dcb.h          |   4 +
 dcb/dcb_ets.c      | 430 +++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-ets.8 | 185 +++++++++++++++++++
 man/man8/dcb.8     |  11 ++
 6 files changed, 634 insertions(+), 2 deletions(-)
 create mode 100644 dcb/dcb_ets.c
 create mode 100644 man/man8/dcb-ets.8

diff --git a/dcb/Makefile b/dcb/Makefile
index 9966c8f0bfa4..895817163562 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -5,7 +5,7 @@ TARGETS :=
 
 ifeq ($(HAVE_MNL),y)
 
-DCBOBJ = dcb.o
+DCBOBJ = dcb.o dcb_ets.o
 TARGETS += dcb
 
 endif
diff --git a/dcb/dcb.c b/dcb/dcb.c
index 5c4969e4f651..738975a0e359 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -286,7 +286,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
-		"where  OBJECT :=\n"
+		"where  OBJECT := ets\n"
 		"       OPTIONS := [ -V | --Version | -j | --json | -p | --pretty | -v | --verbose ]\n");
 }
 
@@ -295,6 +295,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 	if (!argc || matches(*argv, "help") == 0) {
 		dcb_help();
 		return 0;
+	} else if (matches(*argv, "ets") == 0) {
+		return dcb_cmd_ets(dcb, argc - 1, argv + 1);
 	}
 
 	fprintf(stderr, "Object \"%s\" is unknown\n", *argv);
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 1d31a0f94652..9b46e09178be 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -32,4 +32,8 @@ void dcb_print_array_num(FILE *fp, const __u8 *array, size_t size);
 void dcb_print_array_kw(FILE *fp, const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
+/* dcb_ets.c */
+
+int dcb_cmd_ets(struct dcb *dcb, int argc, char **argv);
+
 #endif /* __DCB_H__ */
diff --git a/dcb/dcb_ets.c b/dcb/dcb_ets.c
new file mode 100644
index 000000000000..cc3f30ef5c82
--- /dev/null
+++ b/dcb/dcb_ets.c
@@ -0,0 +1,430 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <errno.h>
+#include <stdio.h>
+#include <linux/dcbnl.h>
+
+#include "dcb.h"
+#include "utils.h"
+
+static void dcb_ets_help_set(void)
+{
+	fprintf(stderr,
+		"Usage: dcb ets set dev STRING\n"
+		"           [ willing { on | off } ]\n"
+		"           [ { tc-tsa | reco-tc-tsa } TSA-MAP ]\n"
+		"           [ { pg-bw | tc-bw | reco-tc-bw } BW-MAP ]\n"
+		"           [ { prio-tc | reco-prio-tc } PRIO-MAP ]\n"
+		"\n"
+		" where TSA-MAP := [ TSA-MAP ] TSA-MAPPING\n"
+		"       TSA-MAPPING := { all | TC }:{ strict | cbs | ets | vendor }\n"
+		"       BW-MAP := [ BW-MAP ] BW-MAPPING\n"
+		"       BW-MAPPING := { all | TC }:INTEGER\n"
+		"       PRIO-MAP := [ PRIO-MAP ] PRIO-MAPPING\n"
+		"       PRIO-MAPPING := { all | PRIO }:TC\n"
+		"       TC := { 0 .. 7 }\n"
+		"       PRIO := { 0 .. 7 }\n"
+		"\n"
+	);
+}
+
+static void dcb_ets_help_show(void)
+{
+	fprintf(stderr,
+		"Usage: dcb ets show dev STRING\n"
+		"           [ willing | ets-cap | cbs | tc-tsa | reco-tc-tsa |\n"
+		"             pg-bw | tc-bw | reco-tc-bw | prio-tc |\n"
+		"             reco-prio-tc ]\n"
+		"\n"
+	);
+}
+
+static void dcb_ets_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb ets help\n"
+		"\n"
+	);
+	dcb_ets_help_show();
+	dcb_ets_help_set();
+}
+
+static const char *const tsa_names[] = {
+	[IEEE_8021QAZ_TSA_STRICT] = "strict",
+	[IEEE_8021QAZ_TSA_CB_SHAPER] = "cbs",
+	[IEEE_8021QAZ_TSA_ETS] = "ets",
+	[IEEE_8021QAZ_TSA_VENDOR] = "vendor",
+};
+
+static int dcb_ets_parse_mapping_tc_tsa(__u32 key, char *value, void *data)
+{
+	__u8 tsa;
+	int ret;
+
+	tsa = parse_one_of("TSA", value, tsa_names, ARRAY_SIZE(tsa_names), &ret);
+	if (ret)
+		return ret;
+
+	return dcb_parse_mapping(key, tsa, -1, data, "TC", "TSA");
+}
+
+static int dcb_ets_parse_mapping_tc_int(__u32 key, char *value, __u8 max_value, __u8 *array,
+					const char *what_key, const char *what_value)
+{
+	__u8 int_value;
+
+	if (get_u8(&int_value, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping(key, int_value, max_value, array, what_key, what_value);
+}
+
+static int dcb_ets_parse_mapping_tc_bw(__u32 key, char *value, void *data)
+{
+	return dcb_ets_parse_mapping_tc_int(key, value, 100, data, "TC", "BW");
+}
+
+static int dcb_ets_parse_mapping_prio_tc(unsigned int key, char *value, void *data)
+{
+	return dcb_ets_parse_mapping_tc_int(key, value, IEEE_8021QAZ_MAX_TCS, data, "PRIO", "TC");
+}
+
+static void dcb_print_array_tsa(FILE *fp, const __u8 *array, size_t size)
+{
+	dcb_print_array_kw(fp, array, size, tsa_names, ARRAY_SIZE(tsa_names));
+}
+
+static void dcb_ets_print_willing(FILE *fp, const struct ieee_ets *ets)
+{
+	print_on_off(PRINT_ANY, "willing", "willing %s ", ets->willing);
+}
+
+static void dcb_ets_print_ets_cap(FILE *fp, const struct ieee_ets *ets)
+{
+	print_uint(PRINT_ANY, "ets_cap", "ets_cap %d ", ets->ets_cap);
+}
+
+static void dcb_ets_print_cbs(FILE *fp, const struct ieee_ets *ets)
+{
+	print_on_off(PRINT_ANY, "cbs", "cbs %s ", ets->cbs);
+}
+
+static void dcb_ets_print_tc_bw(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_print_named_array(fp, "tc-bw", "tc_bw",
+			      ets->tc_tx_bw, ARRAY_SIZE(ets->tc_tx_bw),
+			      dcb_print_array_num);
+}
+
+static void dcb_ets_print_pg_bw(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_print_named_array(fp, "pg-bw", "pg_bw",
+			      ets->tc_rx_bw, ARRAY_SIZE(ets->tc_rx_bw),
+			      dcb_print_array_num);
+}
+
+static void dcb_ets_print_tc_tsa(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_print_named_array(fp, "tc-tsa", "tc_tsa",
+			      ets->tc_tsa, ARRAY_SIZE(ets->tc_tsa),
+			      dcb_print_array_tsa);
+}
+
+static void dcb_ets_print_prio_tc(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_print_named_array(fp, "prio-tc", "prio_tc",
+			      ets->prio_tc, ARRAY_SIZE(ets->prio_tc),
+			      dcb_print_array_num);
+}
+
+static void dcb_ets_print_reco_tc_bw(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_print_named_array(fp, "reco-tc-bw", "reco_tc_bw",
+			      ets->tc_reco_bw, ARRAY_SIZE(ets->tc_reco_bw),
+			      dcb_print_array_num);
+}
+
+static void dcb_ets_print_reco_tc_tsa(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_print_named_array(fp, "reco-tc-tsa", "reco_tc_tsa",
+			      ets->tc_reco_tsa, ARRAY_SIZE(ets->tc_reco_tsa),
+			      dcb_print_array_tsa);
+}
+
+static void dcb_ets_print_reco_prio_tc(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_print_named_array(fp, "reco-prio-tc", "reco_prio_tc",
+			      ets->reco_prio_tc, ARRAY_SIZE(ets->reco_prio_tc),
+			      dcb_print_array_num);
+}
+
+static void dcb_ets_print(FILE *fp, const struct ieee_ets *ets)
+{
+	dcb_ets_print_willing(fp, ets);
+	dcb_ets_print_ets_cap(fp, ets);
+	dcb_ets_print_cbs(fp, ets);
+	print_nl();
+
+	dcb_ets_print_tc_bw(fp, ets);
+	print_nl();
+
+	dcb_ets_print_pg_bw(fp, ets);
+	print_nl();
+
+	dcb_ets_print_tc_tsa(fp, ets);
+	print_nl();
+
+	dcb_ets_print_prio_tc(fp, ets);
+	print_nl();
+
+	dcb_ets_print_reco_tc_bw(fp, ets);
+	print_nl();
+
+	dcb_ets_print_reco_tc_tsa(fp, ets);
+	print_nl();
+
+	dcb_ets_print_reco_prio_tc(fp, ets);
+	print_nl();
+}
+
+static int dcb_ets_get(struct dcb *dcb, const char *dev, struct ieee_ets *ets)
+{
+	return dcb_get_attribute(dcb, dev, DCB_ATTR_IEEE_ETS, ets, sizeof(*ets));
+}
+
+static int dcb_ets_validate_bw(const __u8 bw[], const __u8 tsa[], const char *what)
+{
+	bool has_ets = false;
+	unsigned int total = 0;
+	unsigned int tc;
+
+	for (tc = 0; tc < IEEE_8021QAZ_MAX_TCS; tc++) {
+		if (tsa[tc] == IEEE_8021QAZ_TSA_ETS) {
+			has_ets = true;
+			break;
+		}
+	}
+
+	/* TC bandwidth is only intended for ETS, but 802.1Q-2018 only requires
+	 * that the sum be 100, and individual entries 0..100. It explicitly
+	 * notes that non-ETS TCs can have non-0 TC bandwidth during
+	 * reconfiguration.
+	 */
+	for (tc = 0; tc < IEEE_8021QAZ_MAX_TCS; tc++) {
+		if (bw[tc] > 100) {
+			fprintf(stderr, "%d%% for TC %d of %s is not a valid bandwidth percentage, expected 0..100%%\n",
+				bw[tc], tc, what);
+			return -EINVAL;
+		}
+		total += bw[tc];
+	}
+
+	/* This is what 802.1Q-2018 requires. */
+	if (total == 100)
+		return 0;
+
+	/* But this requirement does not make sense for all-strict
+	 * configurations. Anything else than 0 does not make sense: either BW
+	 * has not been reconfigured for the all-strict allocation yet, at which
+	 * point we expect sum of 100. Or it has already been reconfigured, at
+	 * which point accept 0.
+	 */
+	if (!has_ets && total == 0)
+		return 0;
+
+	fprintf(stderr, "Bandwidth percentages in %s sum to %d%%, expected %d%%\n",
+		what, total, has_ets ? 100 : 0);
+	return -EINVAL;
+}
+
+static int dcb_ets_set(struct dcb *dcb, const char *dev, const struct ieee_ets *ets)
+{
+	/* Do not validate pg-bw, which is not standard and has unclear
+	 * meaning.
+	 */
+	if (dcb_ets_validate_bw(ets->tc_tx_bw, ets->tc_tsa, "tc-bw") ||
+	    dcb_ets_validate_bw(ets->tc_reco_bw, ets->tc_reco_tsa, "reco-tc-bw"))
+		return -EINVAL;
+
+	return dcb_set_attribute(dcb, dev, DCB_ATTR_IEEE_ETS, ets, sizeof(*ets));
+}
+
+static int dcb_cmd_ets_set(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct ieee_ets ets;
+	int ret;
+
+	if (!argc) {
+		dcb_ets_help_set();
+		return 1;
+	}
+
+	ret = dcb_ets_get(dcb, dev, &ets);
+	if (ret)
+		return ret;
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_ets_help_set();
+			return 0;
+		} else if (matches(*argv, "willing") == 0) {
+			NEXT_ARG();
+			ets.willing = parse_on_off("willing", *argv, &ret);
+			if (ret)
+				return ret;
+		} else if (matches(*argv, "tc-tsa") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true, &dcb_ets_parse_mapping_tc_tsa,
+					    ets.tc_tsa);
+			if (ret) {
+				fprintf(stderr, "Invalid tc-tsa mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "reco-tc-tsa") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true, &dcb_ets_parse_mapping_tc_tsa,
+					    ets.tc_reco_tsa);
+			if (ret) {
+				fprintf(stderr, "Invalid reco-tc-tsa mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "tc-bw") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true, &dcb_ets_parse_mapping_tc_bw,
+					    ets.tc_tx_bw);
+			if (ret) {
+				fprintf(stderr, "Invalid tc-bw mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "pg-bw") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true, &dcb_ets_parse_mapping_tc_bw,
+					    ets.tc_rx_bw);
+			if (ret) {
+				fprintf(stderr, "Invalid pg-bw mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "reco-tc-bw") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true, &dcb_ets_parse_mapping_tc_bw,
+					    ets.tc_reco_bw);
+			if (ret) {
+				fprintf(stderr, "Invalid reco-tc-bw mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "prio-tc") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true, &dcb_ets_parse_mapping_prio_tc,
+					    ets.prio_tc);
+			if (ret) {
+				fprintf(stderr, "Invalid prio-tc mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else if (matches(*argv, "reco-prio-tc") == 0) {
+			NEXT_ARG();
+			ret = parse_mapping(&argc, &argv, true, &dcb_ets_parse_mapping_prio_tc,
+					    ets.reco_prio_tc);
+			if (ret) {
+				fprintf(stderr, "Invalid reco-prio-tc mapping %s\n", *argv);
+				return ret;
+			}
+			continue;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_ets_help_set();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+	return dcb_ets_set(dcb, dev, &ets);
+}
+
+static int dcb_cmd_ets_show(struct dcb *dcb, const char *dev, int argc, char **argv)
+{
+	struct ieee_ets ets;
+	int ret;
+
+	ret = dcb_ets_get(dcb, dev, &ets);
+	if (ret)
+		return ret;
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_ets_print(stdout, &ets);
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_ets_help();
+			return 0;
+		} else if (matches(*argv, "willing") == 0) {
+			dcb_ets_print_willing(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "ets-cap") == 0) {
+			dcb_ets_print_ets_cap(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "cbs") == 0) {
+			dcb_ets_print_cbs(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "tc-tsa") == 0) {
+			dcb_ets_print_tc_tsa(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "reco-tc-tsa") == 0) {
+			dcb_ets_print_reco_tc_tsa(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "tc-bw") == 0) {
+			dcb_ets_print_tc_bw(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "pg-bw") == 0) {
+			dcb_ets_print_pg_bw(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "reco-tc-bw") == 0) {
+			dcb_ets_print_reco_tc_bw(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "prio-tc") == 0) {
+			dcb_ets_print_prio_tc(stdout, &ets);
+			print_nl();
+		} else if (matches(*argv, "reco-prio-tc") == 0) {
+			dcb_ets_print_reco_prio_tc(stdout, &ets);
+			print_nl();
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_ets_help();
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
+int dcb_cmd_ets(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_ets_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_ets_show, dcb_ets_help_show);
+	} else if (matches(*argv, "set") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_ets_set, dcb_ets_help_set);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_ets_help();
+		return -EINVAL;
+	}
+}
diff --git a/man/man8/dcb-ets.8 b/man/man8/dcb-ets.8
new file mode 100644
index 000000000000..81d8c5bce7e6
--- /dev/null
+++ b/man/man8/dcb-ets.8
@@ -0,0 +1,185 @@
+.TH DCB-ETS 8 "19 October 2020" "iproute2" "Linux"
+.SH NAME
+dcb-ets \- show / manipulate ETS (Enhanced Transmission Selection) settings of
+the DCB (Data Center Bridging) subsystem
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B ets
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb ets show dev
+.RI DEV
+.RB "[ { " willing " | " ets-cap " | " cbs " | " tc-tsa " | " reco-tc-tsa
+.RB " | " pg-bw " | " tc-bw " | " reco-tc-bw " | " prio-tc
+.RB " | " reco-prio-tc " } ]"
+
+.ti -8
+.B dcb ets set dev
+.RI DEV
+.RB "[ " willing " { " on " | " off " } ]"
+.RB "[ { " tc-tsa " | " reco-tc-tsa " } " \fITSA-MAP\fB " ]"
+.RB "[ { " pg-bw " | " tc-bw " | " reco-tc-bw " } " \fIBW-MAP\fB " ]"
+.RB "[ { " prio-tc " | " reco-prio-tc " } " \fIPRIO-MAP\fB " ]"
+
+.ti -8
+.IR TSA-MAP " := [ " TSA-MAP " ] " TSA-MAPPING
+
+.ti -8
+.IR TSA-MAPPING " := { " TC " | " \fBall " }" \fB: "{ " \fBstrict\fR " | "
+.IR \fBcbs\fR " | " \fBets\fR " | " \fBvendor\fR " }"
+
+.ti -8
+.IR BW-MAP " := [ " BW-MAP " ] " BW-MAPPING
+
+.ti -8
+.IR BW-MAPPING " := { " TC " | " \fBall " }" \fB:\fIINTEGER\fR
+
+.ti -8
+.IR PRIO-MAP " := [ " PRIO-MAP " ] " PRIO-MAPPING
+
+.ti -8
+.IR PRIO-MAPPING " := { " PRIO " | " \fBall " }" \fB:\fITC\fR
+
+.ti -8
+.IR TC " := { " \fB0\fR " .. " \fB7\fR " }"
+
+.ti -8
+.IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
+
+
+.SH DESCRIPTION
+
+.B dcb ets
+is used to configure Enhanced Transmission Selection attributes through Linux
+DCB (Data Center Bridging) interface. ETS permits configuration of mapping of
+priorities to traffic classes, traffic selection algorithm to use per traffic
+class, bandwidth allocation, etc.
+
+Two DCB TLVs are related to the ETS feature: a configuration and recommendation
+values. Recommendation values are named with a prefix
+.B reco-,
+while the configuration ones have plain names.
+
+.SH PARAMETERS
+
+For read-write parameters, the following describes only the write direction,
+i.e. as used with the \fBset\fR command. For the \fBshow\fR command, the
+parameter name is to be used as a simple keyword without further arguments. This
+instructs the tool to show the value of a given parameter. When no parameters
+are given, the tool shows the complete ETS configuration.
+
+.TP
+.B ets-cap
+A read-only property that shows the number of supported ETS traffic classes.
+
+.TP
+.B cbs
+A read-only property that is enabled if the driver and the hardware support the
+CBS Transmission Selection Algorithm.
+
+.TP
+.B willing \fR{ \fBon\fR | \fBoff\fR }
+Whether local host should accept configuration from peer TLVs.
+
+.TP
+.B prio-tc \fITC-MAP
+.TQ
+.B reco-prio-tc \fITC-MAP
+\fITC-MAP\fR uses the array parameter syntax, see dcb(8) for details. Keys are
+priorities, values are traffic classes. For each priority sets a TC where
+traffic with that priority is directed to.
+
+.TP
+.B tc-tsa \fITSA-MAP
+.TQ
+.B reco-tc-tsa \fITSA-MAP
+\fITC-MAP\fR uses the array parameter syntax, see dcb(8) for details. Keys are
+TCs, values are Transmission Selection Algorithm (TSA) keywords described below.
+For each TC sets an algorithm used for deciding how traffic queued up at this TC
+is scheduled for transmission. Supported TSAs are:
+
+.B strict
+- for strict priority, where traffic in higher-numbered TCs always takes
+precedence over traffic in lower-numbered TCs.
+.br
+.B ets
+- for Enhanced Traffic Selection, where available bandwidth is distributed among
+the ETS-enabled TCs according to the weights set by
+.B tc-bw
+and
+.B reco-tc-bw\fR,
+respectively.
+.br
+.B cbs
+- for Credit Based Shaper, where traffic is scheduled in a strict manner up to
+the limit set by a shaper.
+.br
+.B vendor
+- for vendor-specific traffic selection algorithm.
+
+.TP
+.B tc-bw \fIBW-MAP
+.TQ
+.B reco-tc-bw \fIBW-MAP
+\fIBW-MAP\fR uses the array parameter syntax, see dcb(8) for details. Keys are
+TCs, values are integers representing percent of available bandwidth given to
+the traffic class in question. The value should be 0 for TCs whose TSA is not
+\fBets\fR, and the sum of all values shall be 100. As an exception to the
+standard wording, a configuration with no ETS TCs is permitted to sum up to 0
+instead.
+.br
+
+.TP
+.B pg-bw \fIBW-MAP
+The precise meaning of \fBpg-bw\fR is not standardized, but the assumption seems
+to be that the same scheduling process as on the transmit side is applicable on
+receive side as well, and configures receive bandwidth allocation for \fBets\fR
+ingress traffic classes (priority groups).
+
+.SH EXAMPLE & USAGE
+
+Configure ETS priomap in a one-to-one fashion:
+
+.P
+# dcb ets set dev eth0 prio-tc 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+
+Set TSA and transmit bandwidth configuration:
+
+.P
+# dcb ets set dev eth0 tc-tsa all:strict 0:ets 1:ets 2:ets \\
+.br
+                       tc-bw all:0 0:33 1:33 2:34
+
+Show what was set:
+
+.P
+# dcb ets show dev eth0 prio-tc tc-tsa tc-bw
+.br
+prio-tc 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+.br
+tc-tsa 0:ets 1:ets 2:ets 3:strict 4:strict 5:strict 6:strict 7:strict
+.br
+tc-bw 0:33 1:33 2:34 3:0 4:0 5:0 6:0 7:0
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
index 19433bfb906d..f318435caa98 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -6,6 +6,13 @@ dcb \- show / manipulate DCB (Data Center Bridging) settings
 .ad l
 .in +8
 
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B ets
+.RI "{ " COMMAND " | " help " }"
+.sp
+
 .ti -8
 .B dcb
 .RB "[ " -force " ] "
@@ -46,6 +53,10 @@ When combined with -j generate a pretty JSON output.
 
 .SH OBJECTS
 
+.TP
+.B ets
+- Configuration of ETS (Enhanced Transmission Selection)
+
 .SH COMMANDS
 
 A \fICOMMAND\fR specifies the action to perform on the object. The set of
-- 
2.25.1

