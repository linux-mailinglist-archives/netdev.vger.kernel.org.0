Return-Path: <netdev+bounces-8309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F887238E4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A06471C20E85
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C30E28C26;
	Tue,  6 Jun 2023 07:20:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1D028C24
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:35 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C95109
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036020; x=1717572020;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=J6GCvOrPuS54o05RRMCY2J9/zvK3g8OKDrg8nGJfn8s=;
  b=JHNrRHKpUVFZRkcbVik1S4vfFsmV7eRoGBACvOkSGM5/ldxKA/g3m67A
   fYOT2EZqBnyuoiSCnSILVBpwuMU8ZEf5zpMGZt4kf/vR29IVswtRBW1Jf
   BDxQW6ADYIJD6NN53WHvJ9P+0uz5BQrRtTEKjGnkqvggggH6mOCNoSpqw
   /CeDJIUq18J8+XWYg6gOnJuCJGx8R5Oyc953rZ7P0Yqw+ssAcevEQDZIu
   jLaaV2aXXqd8IBQv5UYPHXTLpeXisrrnyMGeeNG+4A8Rr7D3NKYSaTlUq
   LSOCPFoSuYLsrEpMYXvMeA5nJEzlHNEy3/EyUH0LMTOpR7HpMV94UaT7y
   w==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="228600045"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:20 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:18 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:43 +0200
Subject: [PATCH iproute2-next v3 08/12] dcb: rewr: add new dcb-rewr
 subcommand
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-8-60a766f72e61@microchip.com>
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a new subcommand 'rewr' for configuring the in-kernel DCB rewrite
table. The rewrite table of the kernel is similar to the APP table,
therefore, much of the existing bookkeeping code from dcb-app, can be
reused in the dcb-rewr implementation.

Initially, only support for configuring PCP and DSCP-based rewrite has
been added.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/Makefile   |   3 +-
 dcb/dcb.c      |   4 +-
 dcb/dcb.h      |   4 +
 dcb/dcb_rewr.c | 363 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 372 insertions(+), 2 deletions(-)

diff --git a/dcb/Makefile b/dcb/Makefile
index dd41a559a0c8..10794c9dc19f 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -8,7 +8,8 @@ DCBOBJ = dcb.o \
          dcb_ets.o \
          dcb_maxrate.o \
          dcb_pfc.o \
-         dcb_apptrust.o
+         dcb_apptrust.o \
+         dcb_rewr.o
 TARGETS += dcb
 LDLIBS += -lm
 
diff --git a/dcb/dcb.c b/dcb/dcb.c
index 9b996abac529..fe0a0f04143d 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -470,7 +470,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
-		"where  OBJECT := { app | apptrust | buffer | dcbx | ets | maxrate | pfc }\n"
+		"where  OBJECT := { app | apptrust | buffer | dcbx | ets | maxrate | pfc | rewr }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -N | --Numeric | -p | --pretty\n"
 		"                  | -s | --statistics | -v | --verbose]\n");
@@ -485,6 +485,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 		return dcb_cmd_app(dcb, argc - 1, argv + 1);
 	} else if (strcmp(*argv, "apptrust") == 0) {
 		return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
+	} else if (strcmp(*argv, "rewr") == 0) {
+		return dcb_cmd_rewr(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "buffer") == 0) {
 		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "dcbx") == 0) {
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 82ad72bc9ff3..ff11a122ba37 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -54,6 +54,10 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
+/* dcp_rewr.c */
+
+int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_app.c */
 
 struct dcb_app_table {
diff --git a/dcb/dcb_rewr.c b/dcb/dcb_rewr.c
new file mode 100644
index 000000000000..facbdbe664a4
--- /dev/null
+++ b/dcb/dcb_rewr.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <errno.h>
+#include <linux/dcbnl.h>
+#include <stdio.h>
+
+#include "dcb.h"
+#include "utils.h"
+
+static void dcb_rewr_help_add(void)
+{
+	fprintf(stderr,
+		"Usage: dcb rewr { add | del | replace } dev STRING\n"
+		"           [ prio-pcp PRIO:PCP ]\n"
+		"           [ prio-dscp PRIO:DSCP ]\n"
+		"\n"
+		" where PRIO := { 0 .. 7 }\n"
+		"       PCP  := { 0(nd/de) .. 7(nd/de) }\n"
+		"       DSCP := { 0 .. 63 }\n"
+		"\n"
+	);
+}
+
+static void dcb_rewr_help_show_flush(void)
+{
+	fprintf(stderr,
+		"Usage: dcb rewr { show | flush } dev STRING\n"
+		"           [ prio-pcp ]\n"
+		"           [ prio-dscp ]\n"
+		"\n"
+	);
+}
+
+static void dcb_rewr_help(void)
+{
+	fprintf(stderr,
+		"Usage: dcb rewr help\n"
+		"\n"
+	);
+	dcb_rewr_help_show_flush();
+	dcb_rewr_help_add();
+}
+
+static void dcb_rewr_parse_mapping_cb(__u32 key, __u64 value, void *data)
+{
+	struct dcb_app_parse_mapping *pm = data;
+	struct dcb_app app = {
+		.selector = pm->selector,
+		.priority = key,
+		.protocol = value,
+	};
+
+	if (pm->err)
+		return;
+
+	pm->err = dcb_app_table_push(pm->tab, &app);
+}
+
+static int dcb_rewr_parse_mapping_prio_pcp(__u32 key, char *value, void *data)
+{
+	__u32 pcp;
+
+	if (dcb_app_parse_pcp(&pcp, value))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
+				 "PCP", pcp, DCB_APP_PCP_MAX,
+				 dcb_rewr_parse_mapping_cb, data);
+}
+
+static int dcb_rewr_parse_mapping_prio_dscp(__u32 key, char *value, void *data)
+{
+	__u32 dscp;
+
+	if (dcb_app_parse_dscp(&dscp, value))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
+				 "DSCP", dscp, 63,
+				 dcb_rewr_parse_mapping_cb, data);
+}
+
+static void dcb_rewr_print_prio_pid(int (*print_pid)(__u16 protocol),
+				    const struct dcb_app *app)
+{
+	print_uint(PRINT_ANY, NULL, "%u:", app->priority);
+	print_pid(app->protocol);
+}
+
+static void dcb_rewr_print_prio_pcp(const struct dcb *dcb,
+				    const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_pcp,
+			       dcb_rewr_print_prio_pid,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_pcp,
+			       "prio_pcp", "prio-pcp");
+}
+
+static void dcb_rewr_print_prio_dscp(const struct dcb *dcb,
+				     const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_dscp,
+			       dcb_rewr_print_prio_pid,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_dscp,
+			       "prio_dscp", "prio-dscp");
+}
+
+static void dcb_rewr_print(const struct dcb *dcb,
+			   const struct dcb_app_table *tab)
+{
+	dcb_rewr_print_prio_pcp(dcb, tab);
+	dcb_rewr_print_prio_dscp(dcb, tab);
+}
+
+static bool dcb_rewr_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab)
+{
+	return aa->selector == ab->selector &&
+	       aa->priority == ab->priority;
+}
+
+static int dcb_cmd_rewr_parse_add_del(struct dcb *dcb, const char *dev,
+				      int argc, char **argv,
+				      struct dcb_app_table *tab)
+{
+	struct dcb_app_parse_mapping pm = {
+		.tab = tab,
+	};
+	int ret;
+
+	if (!argc) {
+		dcb_rewr_help_add();
+		return 0;
+	}
+
+	do {
+		if (strcmp(*argv, "help") == 0) {
+			dcb_rewr_help_add();
+			return 0;
+		} else if (strcmp(*argv, "prio-pcp") == 0) {
+			NEXT_ARG();
+			pm.selector = DCB_APP_SEL_PCP;
+			ret = parse_mapping(&argc, &argv, false,
+					    &dcb_rewr_parse_mapping_prio_pcp,
+					    &pm);
+		} else if (strcmp(*argv, "prio-dscp") == 0) {
+			NEXT_ARG();
+			pm.selector = IEEE_8021QAZ_APP_SEL_DSCP;
+			ret = parse_mapping(&argc, &argv, false,
+					    &dcb_rewr_parse_mapping_prio_dscp,
+					    &pm);
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_rewr_help_add();
+			return -EINVAL;
+		}
+
+		if (ret != 0) {
+			fprintf(stderr, "Invalid mapping %s\n", *argv);
+			return ret;
+		}
+		if (pm.err)
+			return pm.err;
+	} while (argc > 0);
+
+	return 0;
+}
+
+static int dcb_cmd_rewr_add(struct dcb *dcb, const char *dev, int argc,
+			    char **argv)
+{
+	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
+	int ret;
+
+	ret = dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
+	if (ret != 0)
+		return ret;
+
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &tab, NULL);
+	dcb_app_table_fini(&tab);
+	return ret;
+}
+
+static int dcb_cmd_rewr_del(struct dcb *dcb, const char *dev, int argc,
+			    char **argv)
+{
+	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
+	int ret;
+
+	ret = dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
+	if (ret != 0)
+		return ret;
+
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab, NULL);
+	dcb_app_table_fini(&tab);
+	return ret;
+}
+
+static int dcb_cmd_rewr_replace(struct dcb *dcb, const char *dev, int argc,
+				char **argv)
+{
+	struct dcb_app_table orig = { .attr = DCB_ATTR_DCB_REWR_TABLE };
+	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
+	struct dcb_app_table new = { .attr = DCB_ATTR_DCB_REWR_TABLE };
+	int ret;
+
+	ret = dcb_app_get(dcb, dev, &orig);
+	if (ret != 0)
+		return ret;
+
+	ret = dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
+	if (ret != 0)
+		goto out;
+
+	/* Attempts to add an existing entry would be rejected, so drop
+	 * these entries from tab.
+	 */
+	ret = dcb_app_table_copy(&new, &tab);
+	if (ret != 0)
+		goto out;
+	dcb_app_table_remove_existing(&new, &orig);
+
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &new, NULL);
+	if (ret != 0) {
+		fprintf(stderr, "Could not add new rewrite entries\n");
+		goto out;
+	}
+
+	/* Remove the obsolete entries. */
+	dcb_app_table_remove_replaced(&orig, &tab, dcb_rewr_prio_eq);
+	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &orig, NULL);
+	if (ret != 0) {
+		fprintf(stderr, "Could not remove replaced rewrite entries\n");
+		goto out;
+	}
+
+out:
+	dcb_app_table_fini(&new);
+	dcb_app_table_fini(&tab);
+	dcb_app_table_fini(&orig);
+	return 0;
+}
+
+static int dcb_cmd_rewr_show(struct dcb *dcb, const char *dev, int argc,
+			     char **argv)
+{
+	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
+	int ret;
+
+	ret = dcb_app_get(dcb, dev, &tab);
+	if (ret != 0)
+		return ret;
+
+	dcb_app_table_sort(&tab);
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_rewr_print(dcb, &tab);
+		goto out;
+	}
+
+	do {
+		if (strcmp(*argv, "help") == 0) {
+			dcb_rewr_help_show_flush();
+			goto out;
+		} else if (strcmp(*argv, "prio-pcp") == 0) {
+			dcb_rewr_print_prio_pcp(dcb, &tab);
+		} else if (strcmp(*argv, "prio-dscp") == 0) {
+			dcb_rewr_print_prio_dscp(dcb, &tab);
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_rewr_help_show_flush();
+			ret = -EINVAL;
+			goto out;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+out:
+	close_json_object();
+	dcb_app_table_fini(&tab);
+	return ret;
+}
+
+static int dcb_cmd_rewr_flush(struct dcb *dcb, const char *dev, int argc,
+			      char **argv)
+{
+	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
+	int ret;
+
+	ret = dcb_app_get(dcb, dev, &tab);
+	if (ret != 0)
+		return ret;
+
+	if (!argc) {
+		ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+				      NULL);
+		goto out;
+	}
+
+	do {
+		if (strcmp(*argv, "help") == 0) {
+			dcb_rewr_help_show_flush();
+			goto out;
+		} else if (strcmp(*argv, "prio-pcp") == 0) {
+			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+					      &dcb_app_is_pcp);
+			if (ret != 0)
+				goto out;
+		} else if (strcmp(*argv, "prio-dscp") == 0) {
+			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+					      &dcb_app_is_dscp);
+			if (ret != 0)
+				goto out;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_rewr_help_show_flush();
+			ret = -EINVAL;
+			goto out;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+out:
+	dcb_app_table_fini(&tab);
+	return ret;
+}
+
+int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || strcmp(*argv, "help") == 0) {
+		dcb_rewr_help();
+		return 0;
+	} else if (strcmp(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_show,
+					 dcb_rewr_help_show_flush);
+	} else if (strcmp(*argv, "flush") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_flush,
+					 dcb_rewr_help_show_flush);
+	} else if (strcmp(*argv, "add") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_add,
+					 dcb_rewr_help_add);
+	} else if (strcmp(*argv, "del") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_del,
+					 dcb_rewr_help_add);
+	} else if (strcmp(*argv, "replace") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_replace,
+					 dcb_rewr_help_add);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_rewr_help();
+		return -EINVAL;
+	}
+}

-- 
2.34.1


