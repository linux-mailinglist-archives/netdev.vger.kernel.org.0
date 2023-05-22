Return-Path: <netdev+bounces-4400-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E2E770C571
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53FE71C20BDA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60123171C6;
	Mon, 22 May 2023 18:41:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E765171A9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:42 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F9102
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780896; x=1716316896;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=x/pZrZkjJQ2gokFUi3CsS56hDyjCxvBzdLe+My/SB74=;
  b=ZJ+wZEMpEi2eXcf7PJ/kG6GOZduooj+wnOibifB99EaWbAZbb826G05Q
   fovZdNbP/TAddxqILs1IXWUUQIPw37IvBssNrFxTfs0tJuTfD3186tVqk
   cJZYP+XjS3wOJD5G5/+CQ829WeCLQqZUPgd57cjwzCe55gUbiBrBtlWC4
   svO7DwtMkrze8Kn0XPhUPJnCSPJM/wd5Ph6DRwqXT5b9b+WzLhdDAYaQq
   N5ruJ6y/Zsu15SDpEzxXo2GuWQ2a+3+/S+ptRJm21Q01Ob+nHrIcCCqUO
   5wk6Wo4scJrpOYjgcBMkU3sclllDU9iInC13QAjuHYYZlwxmm7Z8BYROS
   A==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="153361949"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:35 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:33 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Mon, 22 May 2023 20:41:09 +0200
Subject: [PATCH iproute2-next 6/9] dcb: rewr: add new dcb-rewr subcommand
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v1-6-83adc1f93356@microchip.com>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a new subcommand 'rewr' for configuring the in-kernel DCB rewrite
table. The rewr-table of the kernel is similar to the APP-table, and so
is this new subcommand. Therefore, much of the existing bookkeeping code
from dcb-app, can be reused in the dcb-rewr implementation.

Initially, only support for configuring PCP and DSCP-based rewrite has
been added.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/Makefile   |   3 +-
 dcb/dcb.c      |   4 +-
 dcb/dcb.h      |   3 +
 dcb/dcb_app.h  |   1 +
 dcb/dcb_rewr.c | 332 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 341 insertions(+), 2 deletions(-)

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
index 4c8a4aa25e0c..39a04f1c59df 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -56,6 +56,9 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
+/* dcb_rewr.c */
+int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_apptrust.c */
 
 int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
index 8f048605c3a8..02c9eb03f6c2 100644
--- a/dcb/dcb_app.h
+++ b/dcb/dcb_app.h
@@ -22,6 +22,7 @@ struct dcb_app_parse_mapping {
 };
 
 #define DCB_APP_PCP_MAX 15
+#define DCB_APP_DSCP_MAX 63
 
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
 
diff --git a/dcb/dcb_rewr.c b/dcb/dcb_rewr.c
new file mode 100644
index 000000000000..731ba78977e2
--- /dev/null
+++ b/dcb/dcb_rewr.c
@@ -0,0 +1,332 @@
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
+		"           [ prio-pcp PRIO:PCP   ]\n"
+		"           [ prio-dscp PRIO:DSCP ]\n"
+		"\n"
+		" where PRIO := { 0 .. 7               }\n"
+		"       PCP  := { 0(nd/de) .. 7(nd/de) }\n"
+		"       DSCP := { 0 .. 63              }\n"
+		"\n"
+	);
+}
+
+static void dcb_rewr_help_show_flush(void)
+{
+	fprintf(stderr,
+		"Usage: dcb rewr { show | flush } dev STRING\n"
+		"           [ prio-pcp  ]\n"
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
+static int dcb_rewr_parse_mapping_prio_pcp(__u32 key, char *value, void *data)
+{
+	__u32 pcp;
+
+	if (dcb_app_parse_pcp(&pcp, value))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1, "PCP",
+				 pcp, DCB_APP_PCP_MAX, dcb_app_parse_mapping_cb,
+				 data);
+}
+
+static int dcb_rewr_parse_mapping_prio_dscp(__u32 key, char *value, void *data)
+{
+	__u32 dscp;
+
+	if (dcb_app_parse_dscp(&dscp, value))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1, "DSCP",
+				 dscp, DCB_APP_DSCP_MAX,
+				 dcb_app_parse_mapping_cb, data);
+}
+
+static void dcb_rewr_print_prio_pcp(const struct dcb *dcb,
+				    const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_pcp,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_pcp,
+			       "prio_pcp", "prio-pcp");
+}
+
+static void dcb_rewr_print_prio_dscp(const struct dcb *dcb,
+				     const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_dscp,
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
+static int dcb_cmd_rewr_parse_add_del(struct dcb *dcb, const char *dev,
+				      int argc, char **argv,
+				      struct dcb_app_table *tab)
+{
+	struct dcb_app_parse_mapping pm = { .tab = tab };
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
+	dcb_app_table_remove_replaced(&orig, &tab);
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


