Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18D633A30
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiKVKeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiKVKd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:33:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE48028F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669113037; x=1700649037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1JfnqAkR1YJ3QUjuxMrSq4rISnK7BKr9YdVxIUXKIc=;
  b=aK0CHqIKDvL1/S5+6xXp4Qx0lBVzh/ifjTRqcUFGKfuBxWPlHyGcDQeB
   8+eU0bUxMOEHd8b/UvPF9mNCX4PuIZsxuqxKZBrV6Y9HUxKeKNESz9Urm
   PXehiCGgQ0pxeZSJFVSNOswiqOcOeXEeURoPBYW2czFn8hbtB0eXuo2R8
   CoX1m6dqVyWl/rlM/v6eRSqNm+xDxmaJvfkKYigtWvNkJEF/ffJSe5Lbt
   Kioo0Tp/RyjKyp3fXwTjVpv+c54HmHWe1DshJPkye3Wltj+O03SQvkts/
   Bg+VuIjrMnlbGek+Nc8kKTDSPC46QY5bHDJx6951hTVIme87sY7ahSGba
   A==;
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="190066874"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 03:30:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 03:30:35 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 03:30:34 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to dcb app
Date:   Tue, 22 Nov 2022 11:41:11 +0100
Message-ID: <20221122104112.144293-2-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221122104112.144293-1-daniel.machon@microchip.com>
References: <20221122104112.144293-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new pcp-prio parameter to the app subcommand, which can be used to
classify traffic based on PCP and DEI from the VLAN header. PCP and DEI
is specified in a combination of numerical and symbolic form, where 'de'
(as specified in the PCP Encoding Table, 802.1Q) means DEI=1.

Map PCP 1 and DEI 0 to priority 1 $ dcb app add dev eth0 pcp-prio 1:1

Map PCP 1 and DEI 1 to priority 1 $ dcb app add dev eth0 pcp-prio 1de:1

Internally, PCP and DEI is encoded in the protocol field of the dcb_app
struct. Each combination of PCP and DEI maps to a priority, thus needing
a range of  0-15. A well formed dcb_app entry for PCP/DEI
prioritization, could look like:

    struct dcb_app pcp = {
        .selector = DCB_APP_SEL_PCP,
	.priority = 7,
        .protocol = 15
    }

For mapping PCP=7 and DEI=1 to Prio=7.

Also, two helper functions for translating between std and non-std APP
selectors, have been added to dcb_app.c and exposed through dcb.h.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb.h          |   3 +
 dcb/dcb_app.c      | 138 +++++++++++++++++++++++++++++++++++++++++++--
 man/man8/dcb-app.8 |  27 +++++++++
 3 files changed, 162 insertions(+), 6 deletions(-)

diff --git a/dcb/dcb.h b/dcb/dcb.h
index 244c3d3c30e3..05eddcbbcfdf 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -57,6 +57,9 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
 /* dcb_app.c */
 
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
+enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
+bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
+bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
 
 /* dcb_buffer.c */
 
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index dad34554017a..0d4a82e1e502 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -10,6 +10,16 @@
 #include "utils.h"
 #include "rt_names.h"
 
+static const char *const pcp_names[16] = {
+	"0",   "1",   "2",   "3",   "4",   "5",   "6",   "7",
+	"0de", "1de", "2de", "3de", "4de", "5de", "6de", "7de"
+};
+
+static const char *const ieee_attrs_app_names[__DCB_ATTR_IEEE_APP_MAX] = {
+	[DCB_ATTR_IEEE_APP] = "DCB_ATTR_IEEE_APP",
+	[DCB_ATTR_DCB_APP] = "DCB_ATTR_DCB_APP"
+};
+
 static void dcb_app_help_add(void)
 {
 	fprintf(stderr,
@@ -20,11 +30,13 @@ static void dcb_app_help_add(void)
 		"           [ dgram-port-prio PORT:PRIO ]\n"
 		"           [ port-prio PORT:PRIO ]\n"
 		"           [ dscp-prio INTEGER:PRIO ]\n"
+		"           [ pcp-prio INTEGER:PRIO ]\n"
 		"\n"
 		" where PRIO := { 0 .. 7 }\n"
 		"       ET := { 0x600 .. 0xffff }\n"
 		"       PORT := { 1 .. 65535 }\n"
 		"       DSCP := { 0 .. 63 }\n"
+		"       PCP := { 0(de) .. 7(de) }\n"
 		"\n"
 	);
 }
@@ -39,6 +51,7 @@ static void dcb_app_help_show_flush(void)
 		"           [ dgram-port-prio ]\n"
 		"           [ port-prio ]\n"
 		"           [ dscp-prio ]\n"
+		"           [ pcp-prio ]\n"
 		"\n"
 	);
 }
@@ -58,6 +71,38 @@ struct dcb_app_table {
 	size_t n_apps;
 };
 
+enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
+{
+	switch (selector) {
+	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
+	case IEEE_8021QAZ_APP_SEL_STREAM:
+	case IEEE_8021QAZ_APP_SEL_DGRAM:
+	case IEEE_8021QAZ_APP_SEL_ANY:
+	case IEEE_8021QAZ_APP_SEL_DSCP:
+		return DCB_ATTR_IEEE_APP;
+	case DCB_APP_SEL_PCP:
+		return DCB_ATTR_DCB_APP;
+	default:
+		return DCB_ATTR_IEEE_APP_UNSPEC;
+	}
+}
+
+bool dcb_app_attr_type_validate(enum ieee_attrs_app type)
+{
+	switch (type) {
+	case DCB_ATTR_IEEE_APP:
+	case DCB_ATTR_DCB_APP:
+		return true;
+	default:
+		return false;
+	}
+}
+
+bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector)
+{
+	return dcb_app_attr_type_get(selector) == type;
+}
+
 static void dcb_app_table_fini(struct dcb_app_table *tab)
 {
 	free(tab->apps);
@@ -213,6 +258,32 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data
 				 dcb_app_parse_mapping_cb, data);
 }
 
+static int dcb_app_parse_pcp(__u32 *key, const char *arg)
+{
+	int ret, res;
+
+	res = parse_one_of("pcp-names", arg, pcp_names,
+			   ARRAY_SIZE(pcp_names), &ret);
+	if (ret < 0)
+		return ret;
+
+	*key = res;
+
+	return 0;
+}
+
+static int dcb_app_parse_mapping_pcp_prio(__u32 key, char *value, void *data)
+{
+	__u8 prio;
+
+	if (get_u8(&prio, value, 0))
+		return -EINVAL;
+
+	return dcb_parse_mapping("PCP", key, 15,
+				 "PRIO", prio, IEEE_8021QAZ_MAX_TCS - 1,
+				 dcb_app_parse_mapping_cb, data);
+}
+
 static int dcb_app_parse_dscp(__u32 *key, const char *arg)
 {
 	if (parse_mapping_num_all(key, arg) == 0)
@@ -309,6 +380,11 @@ static bool dcb_app_is_dscp(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_DSCP;
 }
 
+static bool dcb_app_is_pcp(const struct dcb_app *app)
+{
+	return app->selector == DCB_APP_SEL_PCP;
+}
+
 static bool dcb_app_is_stream_port(const struct dcb_app *app)
 {
 	return app->selector == IEEE_8021QAZ_APP_SEL_STREAM;
@@ -344,6 +420,17 @@ static int dcb_app_print_key_dscp(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
 }
 
+static int dcb_app_print_key_pcp(__u16 protocol)
+{
+	/* Print in numerical form, if protocol value is out-of-range */
+	if (protocol > 15) {
+		fprintf(stderr, "Unknown PCP key: %d\n", protocol);
+		return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+	}
+
+	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
+}
+
 static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 				   bool (*filter)(const struct dcb_app *),
 				   int (*print_key)(__u16 protocol),
@@ -382,6 +469,15 @@ static void dcb_app_print_ethtype_prio(const struct dcb_app_table *tab)
 			       "ethtype_prio", "ethtype-prio");
 }
 
+static void dcb_app_print_pcp_prio(const struct dcb *dcb,
+				   const struct dcb_app_table *tab)
+{
+	dcb_app_print_filtered(tab, dcb_app_is_pcp,
+			       dcb->numeric ? dcb_app_print_key_dec
+					    : dcb_app_print_key_pcp,
+			       "pcp_prio", "pcp-prio");
+}
+
 static void dcb_app_print_dscp_prio(const struct dcb *dcb,
 				    const struct dcb_app_table *tab)
 {
@@ -439,26 +535,41 @@ static void dcb_app_print(const struct dcb *dcb, const struct dcb_app_table *tab
 	dcb_app_print_stream_port_prio(tab);
 	dcb_app_print_dgram_port_prio(tab);
 	dcb_app_print_port_prio(tab);
+	dcb_app_print_pcp_prio(dcb, tab);
 }
 
 static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
 {
 	struct dcb_app_table *tab = data;
 	struct dcb_app *app;
+	uint16_t type;
 	int ret;
 
-	if (mnl_attr_get_type(attr) != DCB_ATTR_IEEE_APP) {
-		fprintf(stderr, "Unknown attribute in DCB_ATTR_IEEE_APP_TABLE: %d\n",
-			mnl_attr_get_type(attr));
+	type = mnl_attr_get_type(attr);
+
+	if (!dcb_app_attr_type_validate(type)) {
+		fprintf(stderr,
+			"Unknown attribute in DCB_ATTR_IEEE_APP_TABLE: %d\n",
+			type);
 		return MNL_CB_OK;
 	}
 	if (mnl_attr_get_payload_len(attr) < sizeof(struct dcb_app)) {
-		fprintf(stderr, "DCB_ATTR_IEEE_APP payload expected to have size %zd, not %d\n",
-			sizeof(struct dcb_app), mnl_attr_get_payload_len(attr));
+		fprintf(stderr,
+			"%s payload expected to have size %zd, not %d\n",
+			ieee_attrs_app_names[type], sizeof(struct dcb_app),
+			mnl_attr_get_payload_len(attr));
 		return MNL_CB_OK;
 	}
 
 	app = mnl_attr_get_payload(attr);
+
+	/* Check that selector is encapsulated in the right attribute */
+	if (!dcb_app_selector_validate(type, app->selector)) {
+		fprintf(stderr, "Wrong selector for type: %s\n",
+			ieee_attrs_app_names[type]);
+		return MNL_CB_OK;
+	}
+
 	ret = dcb_app_table_push(tab, app);
 	if (ret != 0)
 		return MNL_CB_ERROR;
@@ -491,6 +602,7 @@ struct dcb_app_add_del {
 static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 {
 	struct dcb_app_add_del *add_del = data;
+	enum ieee_attrs_app type;
 	struct nlattr *nest;
 	size_t i;
 
@@ -498,9 +610,10 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 
 	for (i = 0; i < add_del->tab->n_apps; i++) {
 		const struct dcb_app *app = &add_del->tab->apps[i];
+		type = dcb_app_attr_type_get(app->selector);
 
 		if (add_del->filter == NULL || add_del->filter(app))
-			mnl_attr_put(nlh, DCB_ATTR_IEEE_APP, sizeof(*app), app);
+			mnl_attr_put(nlh, type, sizeof(*app), app);
 	}
 
 	mnl_attr_nest_end(nlh, nest);
@@ -577,6 +690,12 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
 			ret = parse_mapping(&argc, &argv, false,
 					    &dcb_app_parse_mapping_port_prio,
 					    &pm);
+		} else if (strcmp(*argv, "pcp-prio") == 0) {
+			NEXT_ARG();
+			pm.selector = DCB_APP_SEL_PCP;
+			ret = parse_mapping_gen(&argc, &argv, &dcb_app_parse_pcp,
+						&dcb_app_parse_mapping_pcp_prio,
+						&pm);
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			dcb_app_help_add();
@@ -656,6 +775,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
 			dcb_app_print_port_prio(&tab);
 		} else if (matches(*argv, "default-prio") == 0) {
 			dcb_app_print_default_prio(&tab);
+		} else if (strcmp(*argv, "pcp-prio") == 0) {
+			dcb_app_print_pcp_prio(dcb, &tab);
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			dcb_app_help_show_flush();
@@ -705,6 +826,11 @@ static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **
 					      &dcb_app_is_dscp);
 			if (ret != 0)
 				goto out;
+		} else if (strcmp(*argv, "pcp-prio") == 0) {
+			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+					      &dcb_app_is_pcp);
+			if (ret != 0)
+				goto out;
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			dcb_app_help_show_flush();
diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
index 9780fe4b60fa..054ba9801d81 100644
--- a/man/man8/dcb-app.8
+++ b/man/man8/dcb-app.8
@@ -23,6 +23,7 @@ the DCB (Data Center Bridging) subsystem
 .RB "[ " dgram-port-prio " ]"
 .RB "[ " port-prio " ]"
 .RB "[ " dscp-prio " ]"
+.RB "[ " pcp-prio " ]"
 
 .ti -8
 .B dcb ets " { " add " | " del " | " replace " } " dev
@@ -33,6 +34,7 @@ the DCB (Data Center Bridging) subsystem
 .RB "[ " dgram-port-prio " " \fIPORT-MAP\fB " ]"
 .RB "[ " port-prio " " \fIPORT-MAP\fB " ]"
 .RB "[ " dscp-prio " " \fIDSCP-MAP\fB " ]"
+.RB "[ " pcp-prio " " \fIPCP-MAP\fB " ]"
 
 .ti -8
 .IR PRIO-LIST " := [ " PRIO-LIST " ] " PRIO
@@ -64,6 +66,9 @@ the DCB (Data Center Bridging) subsystem
 .ti -8
 .IR DSCP " := { " \fB0\fR " .. " \fB63\fR " }"
 
+.ti -8
+.IR PCP " := { " \fB0\fR " .. " \fB7\fR " }"
+
 .ti -8
 .IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
 
@@ -182,6 +187,18 @@ command line option
 .B -N
 turns the show translation off.
 
+.TP
+.B pcp-prio \fIPCP-MAP
+\fIPCP-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are PCP/DEI values. Values are priorities assigned to traffic
+with matching PCP and DEI. PCP/DEI values are written as a combination of
+numeric- and symbolic values, to accommodate for both PCP and DEI. PCP always
+in numerical form e.g 1 .. 7 and DEI in symbolic form e.g 'de', indicating that
+the DEI bit is 1.  In combination 2de:1 translates to a mapping of PCP=2 and
+DEI=1 to priority 1. In a hardware offloaded context, the DEI bit can be mapped
+directly to drop-precedence (DP) by the driver.
+
 .SH EXAMPLE & USAGE
 
 Prioritize traffic with DSCP 0 to priority 0, 24 to 3 and 48 to 6:
@@ -221,6 +238,16 @@ Flush all DSCP rules:
 .br
 (nothing)
 
+Add a rule to map traffic with PCP 1 and DEI 0 to priority 1 and PCP 2 and DEI 1
+to priority 2:
+
+.P
+# dcb app add dev eth0 pcp-prio 1:1 2de:2
+.br
+# dcb app show dev eth0 pcp-prio
+.br
+pcp-prio 1:1 2de:2
+
 .SH EXIT STATUS
 Exit status is 0 if command was successful or a positive integer upon failure.
 
-- 
2.34.1

