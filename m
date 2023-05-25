Return-Path: <netdev+bounces-5418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0081F71135E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA1B82815C1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4160523D46;
	Thu, 25 May 2023 18:11:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3135D19532
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:13 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D714B1A4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038269; x=1716574269;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=R9TXn39OaPVGwn+WAIogqyIiTPTC/caltsdL/6tESVU=;
  b=easFFDeKraHI8fZEJIUaLHdDITtoKWLZw6Fqjd0DYK4ajphIcV7JGlC3
   xJvL9ZMfWq9DKz7YmlAw+e/ZsbApSPzWUgTBxYniLaCWqCyictfRaN5vt
   1dZAo64nUFBzqA0Wwj80ZBlkyzDqsRHrdbG2BNxI+uqJqvB0ioerLbyy7
   q8AXsp7PUJvAMNxEhEGE1NYBCGciS5YUdOKGXVEfc8Fq9/rI+lMts/xAg
   3V4cmuJoDSY/+v+NW4NWXX9IonyqXDQghiSiBKAlEIttfqDb1sO5+E/Dv
   gnQhxjkxkMpn+4DkVjS+vp0KWq50xLIR6vdSdK+OQG/DLI9n20UBSbiXF
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="213094946"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:11:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:11:07 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:11:06 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Thu, 25 May 2023 20:10:25 +0200
Subject: [PATCH iproute2-next v2 5/8] dcb: rewr: add new dcb-rewr
 subcommand
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v2-5-9f38e688117e@microchip.com>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
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
table. The rewr-table of the kernel is similar to the APP-table, and so
is this new subcommand. Therefore, much of the existing bookkeeping code
from dcb-app, can be reused in the dcb-rewr implementation.

Initially, only support for configuring PCP and DSCP-based rewrite has
been added.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/Makefile   |   3 +-
 dcb/dcb.c      |   4 +-
 dcb/dcb.h      |  32 ++++++
 dcb/dcb_app.c  |  49 ++++----
 dcb/dcb_rewr.c | 355 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 416 insertions(+), 27 deletions(-)

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
index b3bc30cd02c5..092dc90e8358 100644
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
@@ -70,8 +74,29 @@ struct dcb_app_parse_mapping {
 	int err;
 };
 
+#define DCB_APP_PCP_MAX 15
+#define DCB_APP_DSCP_MAX 63
+
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
 
+int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab);
+int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
+		    const struct dcb_app_table *tab,
+		    bool (*filter)(const struct dcb_app *));
+
+bool dcb_app_is_dscp(const struct dcb_app *app);
+bool dcb_app_is_pcp(const struct dcb_app *app);
+
+int dcb_app_print_pid_dscp(__u16 protocol);
+int dcb_app_print_pid_pcp(__u16 protocol);
+int dcb_app_print_pid_dec(__u16 protocol);
+void dcb_app_print_filtered(const struct dcb_app_table *tab,
+			    bool (*filter)(const struct dcb_app *),
+			    void (*print_pid_prio)(int (*print_pid)(__u16),
+						   const struct dcb_app *),
+			    int (*print_pid)(__u16 protocol),
+			    const char *json_name, const char *fp_name);
+
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
 bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
 bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
@@ -80,11 +105,18 @@ bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
 bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
 
 int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
+int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b);
+void dcb_app_table_sort(struct dcb_app_table *tab);
+void dcb_app_table_fini(struct dcb_app_table *tab);
+void dcb_app_table_remove_existing(struct dcb_app_table *a,
+				   const struct dcb_app_table *b);
 void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 				   const struct dcb_app_table *b,
 				   bool (*key_eq)(const struct dcb_app *aa,
 						  const struct dcb_app *ab));
 
+int dcb_app_parse_pcp(__u32 *key, const char *arg);
+int dcb_app_parse_dscp(__u32 *key, const char *arg);
 void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
 
 /* dcb_apptrust.c */
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 97cba658aa6b..3cb1bb302ed6 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -100,7 +100,7 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector)
 	return dcb_app_attr_type_get(selector) == type;
 }
 
-static void dcb_app_table_fini(struct dcb_app_table *tab)
+void dcb_app_table_fini(struct dcb_app_table *tab)
 {
 	free(tab->apps);
 }
@@ -119,8 +119,8 @@ int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
 	return 0;
 }
 
-static void dcb_app_table_remove_existing(struct dcb_app_table *a,
-					  const struct dcb_app_table *b)
+void dcb_app_table_remove_existing(struct dcb_app_table *a,
+				   const struct dcb_app_table *b)
 {
 	size_t ia, ja;
 	size_t ib;
@@ -198,8 +198,7 @@ void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 	a->n_apps = ja;
 }
 
-static int dcb_app_table_copy(struct dcb_app_table *a,
-			      const struct dcb_app_table *b)
+int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b)
 {
 	size_t i;
 	int ret;
@@ -226,7 +225,7 @@ static int dcb_app_cmp_cb(const void *a, const void *b)
 	return dcb_app_cmp(a, b);
 }
 
-static void dcb_app_table_sort(struct dcb_app_table *tab)
+void dcb_app_table_sort(struct dcb_app_table *tab)
 {
 	qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
 }
@@ -269,7 +268,7 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data
 				 dcb_app_parse_mapping_cb, data);
 }
 
-static int dcb_app_parse_pcp(__u32 *key, const char *arg)
+int dcb_app_parse_pcp(__u32 *key, const char *arg)
 {
 	int i;
 
@@ -295,7 +294,7 @@ static int dcb_app_parse_mapping_pcp_prio(__u32 key, char *value, void *data)
 				 dcb_app_parse_mapping_cb, data);
 }
 
-static int dcb_app_parse_dscp(__u32 *key, const char *arg)
+int dcb_app_parse_dscp(__u32 *key, const char *arg)
 {
 	if (parse_mapping_num_all(key, arg) == 0)
 		return 0;
@@ -320,7 +319,7 @@ static int dcb_app_parse_mapping_dscp_prio(__u32 key, char *value, void *data)
 	if (get_u8(&prio, value, 0))
 		return -EINVAL;
 
-	return dcb_parse_mapping("DSCP", key, 63,
+	return dcb_parse_mapping("DSCP", key, DCB_APP_DSCP_MAX,
 				 "PRIO", prio, IEEE_8021QAZ_MAX_TCS - 1,
 				 dcb_app_parse_mapping_cb, data);
 }
@@ -386,12 +385,12 @@ static bool dcb_app_is_default(const struct dcb_app *app)
 	       app->protocol == 0;
 }
 
-static bool dcb_app_is_dscp(const struct dcb_app *app)
+bool dcb_app_is_dscp(const struct dcb_app *app)
 {
 	return app->selector == IEEE_8021QAZ_APP_SEL_DSCP;
 }
 
-static bool dcb_app_is_pcp(const struct dcb_app *app)
+bool dcb_app_is_pcp(const struct dcb_app *app)
 {
 	return app->selector == DCB_APP_SEL_PCP;
 }
@@ -411,7 +410,7 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
 }
 
-static int dcb_app_print_pid_dec(__u16 protocol)
+int dcb_app_print_pid_dec(__u16 protocol)
 {
 	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
@@ -421,7 +420,7 @@ static int dcb_app_print_pid_hex(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%x", protocol);
 }
 
-static int dcb_app_print_pid_dscp(__u16 protocol)
+int dcb_app_print_pid_dscp(__u16 protocol)
 {
 	const char *name = rtnl_dsfield_get_name(protocol << 2);
 
@@ -430,7 +429,7 @@ static int dcb_app_print_pid_dscp(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
-static int dcb_app_print_pid_pcp(__u16 protocol)
+int dcb_app_print_pid_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
@@ -439,13 +438,13 @@ static int dcb_app_print_pid_pcp(__u16 protocol)
 	return print_string(PRINT_ANY, NULL, "%s", pcp_names[protocol]);
 }
 
-static void dcb_app_print_filtered(const struct dcb_app_table *tab,
-				   bool (*filter)(const struct dcb_app *),
-				   void (*print_pid_prio)(int (*print_pid)(__u16),
-							  const struct dcb_app *),
-				   int (*print_pid)(__u16 protocol),
-				   const char *json_name,
-				   const char *fp_name)
+void dcb_app_print_filtered(const struct dcb_app_table *tab,
+			    bool (*filter)(const struct dcb_app *),
+			    void (*print_pid_prio)(int (*print_pid)(__u16),
+						   const struct dcb_app *),
+			    int (*print_pid)(__u16 protocol),
+			    const char *json_name,
+			    const char *fp_name)
 {
 	bool first = true;
 	size_t i;
@@ -600,7 +599,7 @@ static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
+int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
 {
 	uint16_t payload_len;
 	void *payload;
@@ -643,9 +642,9 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 	return 0;
 }
 
-static int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
-			   const struct dcb_app_table *tab,
-			   bool (*filter)(const struct dcb_app *))
+int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
+		    const struct dcb_app_table *tab,
+		    bool (*filter)(const struct dcb_app *))
 {
 	struct dcb_app_add_del add_del = {
 		.tab = tab,
diff --git a/dcb/dcb_rewr.c b/dcb/dcb_rewr.c
new file mode 100644
index 000000000000..37372465cae0
--- /dev/null
+++ b/dcb/dcb_rewr.c
@@ -0,0 +1,355 @@
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
+static int dcb_rewr_parse_mapping_prio_pcp(__u32 key, char *value, void *data)
+{
+	__u32 pcp;
+
+	if (dcb_app_parse_pcp(&pcp, value))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
+				 "PCP", pcp, DCB_APP_PCP_MAX,
+				 dcb_app_parse_mapping_cb, data);
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
+				 "DSCP", dscp, DCB_APP_DSCP_MAX,
+				 dcb_app_parse_mapping_cb, data);
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
+static int dcb_rewr_push(struct dcb_app_table *tab,
+			 __u8 selector, __u32 key, __u64 value)
+{
+	struct dcb_app app = {
+		.selector = selector,
+		.priority = key,
+		.protocol = value,
+	};
+	return dcb_app_table_push(tab, &app);
+}
+
+static int dcb_cmd_rewr_parse_add_del(struct dcb *dcb, const char *dev,
+				      int argc, char **argv,
+				      struct dcb_app_table *tab)
+{
+	struct dcb_app_parse_mapping pm = {
+		.tab = tab,
+		.push = dcb_rewr_push,
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
+	dcb_app_table_remove_replaced(&orig, &tab, dcb_app_prio_eq);
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


