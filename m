Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2F2B1172
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKLW0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgKLW0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:26:18 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50BAC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:17 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CXGQw3pXQzQkm6;
        Thu, 12 Nov 2020 23:26:16 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605219974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5DQ16U+rKJUFA45rI51SI+jnCxmmOiOzo/NSCej8woE=;
        b=gbWQBsWH0K2kJmMT8E7kV2iAvLRYZhkU9HW6Aw2wYOkz8VegY03gcd5RKqOT4pwmb17Vch
        XfJAoFtK1Vim9I2e+Ma9h0HxDf50iwoXZGEaWL2qbhaZqdN4I1EpSSXnH8tej3WwBP/pG5
        FmZyEOMtBoe43n6ft+Ag+iiuhAQOLAJnCL4dmIY29NzPCNEp97/muVIPZ2gcWHdVkmPuxt
        EbDovUX6RgZWIDa0khwwTnuOLNs74e+RMQ18ex/GhRSgJN6jNUWqKED/vI+SJRumB3Owzq
        zyckakJDxpoo4XSELCES+1X/ITIKQlUCwDnGUnjlfTBfNZ5AZAM3Ksb7DEUqRw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id Gz8XJtJivpDD; Thu, 12 Nov 2020 23:26:12 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v5 11/11] dcb: Add a subtool for the DCB ETS object
Date:   Thu, 12 Nov 2020 23:24:48 +0100
Message-Id: <f4243d60be845888c1df13e08f8eeeadb66b081c.1605218735.git.me@pmachata.org>
In-Reply-To: <cover.1605218735.git.me@pmachata.org>
References: <cover.1605218735.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 7DB8117B4
X-Rspamd-UID: af0728
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
    v5:
    - Man page fix: TC-MAP is actually called PRIO-MAP.
    - Fix formatting of man page references in the dcb-ets man page.
    
    v4:
    - Drop all the FILE* arguments that were passed around unnecessarily
    - Emit ets-cap in FP as "ets-cap", not "ets_cap"
    
    v3:
    - Formatting tweaks in the man page

 dcb/Makefile       |   2 +-
 dcb/dcb.c          |   4 +-
 dcb/dcb.h          |   4 +
 dcb/dcb_ets.c      | 435 +++++++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-ets.8 | 188 ++++++++++++++++++++
 man/man8/dcb.8     |  11 ++
 6 files changed, 642 insertions(+), 2 deletions(-)
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
index 1ec8c24ec509..dc1e9fe04e22 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -295,7 +295,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -N | --Netns ] netnsname\n"
-		"where  OBJECT :=\n"
+		"where  OBJECT := ets\n"
 		"       OPTIONS := [ -V | --Version | -j | --json | -p | --pretty | -v | --verbose ]\n");
 }
 
@@ -304,6 +304,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 	if (!argc || matches(*argv, "help") == 0) {
 		dcb_help();
 		return 0;
+	} else if (matches(*argv, "ets") == 0) {
+		return dcb_cmd_ets(dcb, argc - 1, argv + 1);
 	}
 
 	fprintf(stderr, "Object \"%s\" is unknown\n", *argv);
diff --git a/dcb/dcb.h b/dcb/dcb.h
index a09d102a7fc6..6f135ed06b08 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -36,4 +36,8 @@ void dcb_print_array_u8(const __u8 *array, size_t size);
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
+/* dcb_ets.c */
+
+int dcb_cmd_ets(struct dcb *dcb, int argc, char **argv);
+
 #endif /* __DCB_H__ */
diff --git a/dcb/dcb_ets.c b/dcb/dcb_ets.c
new file mode 100644
index 000000000000..1735885aa8ed
--- /dev/null
+++ b/dcb/dcb_ets.c
@@ -0,0 +1,435 @@
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
+	return dcb_parse_mapping("TC", key, IEEE_8021QAZ_MAX_TCS - 1,
+				 "TSA", tsa, -1U,
+				 dcb_set_u8, data);
+}
+
+static int dcb_ets_parse_mapping_tc_bw(__u32 key, char *value, void *data)
+{
+	__u8 bw;
+
+	if (get_u8(&bw, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping("TC", key, IEEE_8021QAZ_MAX_TCS - 1,
+				 "BW", bw, 100,
+				 dcb_set_u8, data);
+}
+
+static int dcb_ets_parse_mapping_prio_tc(unsigned int key, char *value, void *data)
+{
+	__u8 tc;
+
+	if (get_u8(&tc, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
+				 "TC", tc, IEEE_8021QAZ_MAX_TCS - 1,
+				 dcb_set_u8, data);
+}
+
+static void dcb_print_array_tsa(const __u8 *array, size_t size)
+{
+	dcb_print_array_kw(array, size, tsa_names, ARRAY_SIZE(tsa_names));
+}
+
+static void dcb_ets_print_willing(const struct ieee_ets *ets)
+{
+	print_on_off(PRINT_ANY, "willing", "willing %s ", ets->willing);
+}
+
+static void dcb_ets_print_ets_cap(const struct ieee_ets *ets)
+{
+	print_uint(PRINT_ANY, "ets_cap", "ets-cap %d ", ets->ets_cap);
+}
+
+static void dcb_ets_print_cbs(const struct ieee_ets *ets)
+{
+	print_on_off(PRINT_ANY, "cbs", "cbs %s ", ets->cbs);
+}
+
+static void dcb_ets_print_tc_bw(const struct ieee_ets *ets)
+{
+	dcb_print_named_array("tc_bw", "tc-bw",
+			      ets->tc_tx_bw, ARRAY_SIZE(ets->tc_tx_bw),
+			      dcb_print_array_u8);
+}
+
+static void dcb_ets_print_pg_bw(const struct ieee_ets *ets)
+{
+	dcb_print_named_array("pg_bw", "pg-bw",
+			      ets->tc_rx_bw, ARRAY_SIZE(ets->tc_rx_bw),
+			      dcb_print_array_u8);
+}
+
+static void dcb_ets_print_tc_tsa(const struct ieee_ets *ets)
+{
+	dcb_print_named_array("tc_tsa", "tc-tsa",
+			      ets->tc_tsa, ARRAY_SIZE(ets->tc_tsa),
+			      dcb_print_array_tsa);
+}
+
+static void dcb_ets_print_prio_tc(const struct ieee_ets *ets)
+{
+	dcb_print_named_array("prio_tc", "prio-tc",
+			      ets->prio_tc, ARRAY_SIZE(ets->prio_tc),
+			      dcb_print_array_u8);
+}
+
+static void dcb_ets_print_reco_tc_bw(const struct ieee_ets *ets)
+{
+	dcb_print_named_array("reco_tc_bw", "reco-tc-bw",
+			      ets->tc_reco_bw, ARRAY_SIZE(ets->tc_reco_bw),
+			      dcb_print_array_u8);
+}
+
+static void dcb_ets_print_reco_tc_tsa(const struct ieee_ets *ets)
+{
+	dcb_print_named_array("reco_tc_tsa", "reco-tc-tsa",
+			      ets->tc_reco_tsa, ARRAY_SIZE(ets->tc_reco_tsa),
+			      dcb_print_array_tsa);
+}
+
+static void dcb_ets_print_reco_prio_tc(const struct ieee_ets *ets)
+{
+	dcb_print_named_array("reco_prio_tc", "reco-prio-tc",
+			      ets->reco_prio_tc, ARRAY_SIZE(ets->reco_prio_tc),
+			      dcb_print_array_u8);
+}
+
+static void dcb_ets_print(const struct ieee_ets *ets)
+{
+	dcb_ets_print_willing(ets);
+	dcb_ets_print_ets_cap(ets);
+	dcb_ets_print_cbs(ets);
+	print_nl();
+
+	dcb_ets_print_tc_bw(ets);
+	print_nl();
+
+	dcb_ets_print_pg_bw(ets);
+	print_nl();
+
+	dcb_ets_print_tc_tsa(ets);
+	print_nl();
+
+	dcb_ets_print_prio_tc(ets);
+	print_nl();
+
+	dcb_ets_print_reco_tc_bw(ets);
+	print_nl();
+
+	dcb_ets_print_reco_tc_tsa(ets);
+	print_nl();
+
+	dcb_ets_print_reco_prio_tc(ets);
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
+		dcb_ets_print(&ets);
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_ets_help();
+			return 0;
+		} else if (matches(*argv, "willing") == 0) {
+			dcb_ets_print_willing(&ets);
+			print_nl();
+		} else if (matches(*argv, "ets-cap") == 0) {
+			dcb_ets_print_ets_cap(&ets);
+			print_nl();
+		} else if (matches(*argv, "cbs") == 0) {
+			dcb_ets_print_cbs(&ets);
+			print_nl();
+		} else if (matches(*argv, "tc-tsa") == 0) {
+			dcb_ets_print_tc_tsa(&ets);
+			print_nl();
+		} else if (matches(*argv, "reco-tc-tsa") == 0) {
+			dcb_ets_print_reco_tc_tsa(&ets);
+			print_nl();
+		} else if (matches(*argv, "tc-bw") == 0) {
+			dcb_ets_print_tc_bw(&ets);
+			print_nl();
+		} else if (matches(*argv, "pg-bw") == 0) {
+			dcb_ets_print_pg_bw(&ets);
+			print_nl();
+		} else if (matches(*argv, "reco-tc-bw") == 0) {
+			dcb_ets_print_reco_tc_bw(&ets);
+			print_nl();
+		} else if (matches(*argv, "prio-tc") == 0) {
+			dcb_ets_print_prio_tc(&ets);
+			print_nl();
+		} else if (matches(*argv, "reco-prio-tc") == 0) {
+			dcb_ets_print_reco_prio_tc(&ets);
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
index 000000000000..0ae3587cb66a
--- /dev/null
+++ b/man/man8/dcb-ets.8
@@ -0,0 +1,188 @@
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
+.B prio-tc \fIPRIO-MAP
+.TQ
+.B reco-prio-tc \fIPRIO-MAP
+\fIPRIO-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are priorities, values are traffic classes. For each priority
+sets a TC where traffic with that priority is directed to.
+
+.TP
+.B tc-tsa \fITSA-MAP
+.TQ
+.B reco-tc-tsa \fITSA-MAP
+\fITSA-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are TCs, values are Transmission Selection Algorithm (TSA)
+keywords described below. For each TC sets an algorithm used for deciding how
+traffic queued up at this TC is scheduled for transmission. Supported TSAs are:
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
+\fIBW-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are TCs, values are integers representing percent of available
+bandwidth given to the traffic class in question. The value should be 0 for TCs
+whose TSA is not \fBets\fR, and the sum of all values shall be 100. As an
+exception to the standard wording, a configuration with no \fBets\fR TCs is
+permitted to sum up to 0 instead.
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

