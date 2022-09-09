Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7412A5B353C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiIIK2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiIIK2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:28:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F31112F715
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 03:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662719298; x=1694255298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B2yEgHwd+lOkIaMmSFnR6R0HV7MhRhHkQRiPCXGkJt4=;
  b=ug+WYmB4zZSqqeCihvGTjRvtEEgqoWF5UGYW02xj6RQkPKfXQKEmBkLu
   PjlP80Px7VxCL7d2xJUxrnItOO417qhJrLW/AGXS6qkwERazsgYHyNDJ/
   NeNq8Tb+O5pt3JnHHWmDWcp+EyPCCvKn/twYiPAK/dQjMxUgtnbiQq5c1
   wn6tzwNYdnic7Xx9ySB6VUwRBTF07tWw7humtCFu4Of9bXZhCO3ZVu+vo
   mHeKRs31yWz2pmBWg9Y0XJaVdVJ8Q5EHmTdr52UDaadclRHoCbtTviXRm
   xVkvYpFLwZw2zyc21RjvT8ENV8FEA6OUvl5qBzQyB3uS/rnwV06SeXC+x
   g==;
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="179714660"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 03:28:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 03:28:17 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 03:28:15 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [RFC PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to dcb app
Date:   Fri, 9 Sep 2022 12:37:00 +0200
Message-ID: <20220909103701.468717-2-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220909103701.468717-1-daniel.machon@microchip.com>
References: <20220909103701.468717-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new pcp-prio parameter to the app subcommand, to classify
traffic based on PCP and DEI.

The pcp-prio parameter makes use of the PCP selector to encode PCP and
DEI values in the protocol field of the app struct. Pcp-prio uses a
key:value mapping, where the key is a combination of numerical and
symbolic form. For example:

Map PCP 1 and DEI 0 to priority 1
$ dcb app add dev eth0 pcp-prio 1:1

Map PCP 1 and DEI 1 to priority 1
$ dcb app add dev eth0 pcp-prio 1de:1

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c              | 70 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/dcbnl.h |  1 +
 man/man8/dcb-app.8         | 25 ++++++++++++++
 3 files changed, 96 insertions(+)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index dad34554..74195285 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -10,6 +10,11 @@
 #include "utils.h"
 #include "rt_names.h"
 
+static const char *const pcp_names[16] = {
+	"0",   "1",   "2",   "3",   "4",   "5",   "6",   "7",
+	"0de", "1de", "2de", "3de", "4de", "5de", "6de", "7de"
+};
+
 static void dcb_app_help_add(void)
 {
 	fprintf(stderr,
@@ -20,11 +25,13 @@ static void dcb_app_help_add(void)
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
@@ -39,6 +46,7 @@ static void dcb_app_help_show_flush(void)
 		"           [ dgram-port-prio ]\n"
 		"           [ port-prio ]\n"
 		"           [ dscp-prio ]\n"
+		"           [ pcp-prio ]\n"
 		"\n"
 	);
 }
@@ -213,6 +221,32 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data
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
@@ -309,6 +343,11 @@ static bool dcb_app_is_dscp(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_DSCP;
 }
 
+static bool dcb_app_is_pcp(const struct dcb_app *app)
+{
+	return app->selector == IEEE_8021QAZ_APP_SEL_PCP;
+}
+
 static bool dcb_app_is_stream_port(const struct dcb_app *app)
 {
 	return app->selector == IEEE_8021QAZ_APP_SEL_STREAM;
@@ -344,6 +383,14 @@ static int dcb_app_print_key_dscp(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
 }
 
+static int dcb_app_print_key_pcp(__u16 protocol)
+{
+	if (protocol > 15)
+		return -1;
+
+	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
+}
+
 static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 				   bool (*filter)(const struct dcb_app *),
 				   int (*print_key)(__u16 protocol),
@@ -382,6 +429,15 @@ static void dcb_app_print_ethtype_prio(const struct dcb_app_table *tab)
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
@@ -439,6 +495,7 @@ static void dcb_app_print(const struct dcb *dcb, const struct dcb_app_table *tab
 	dcb_app_print_stream_port_prio(tab);
 	dcb_app_print_dgram_port_prio(tab);
 	dcb_app_print_port_prio(tab);
+	dcb_app_print_pcp_prio(dcb, tab);
 }
 
 static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
@@ -577,6 +634,12 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
 			ret = parse_mapping(&argc, &argv, false,
 					    &dcb_app_parse_mapping_port_prio,
 					    &pm);
+		} else if (matches(*argv, "pcp-prio") == 0) {
+			NEXT_ARG();
+			pm.selector = IEEE_8021QAZ_APP_SEL_PCP;
+			ret = parse_mapping_gen(&argc, &argv, &dcb_app_parse_pcp,
+						&dcb_app_parse_mapping_pcp_prio,
+						&pm);
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			dcb_app_help_add();
@@ -656,6 +719,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
 			dcb_app_print_port_prio(&tab);
 		} else if (matches(*argv, "default-prio") == 0) {
 			dcb_app_print_default_prio(&tab);
+		} else if (matches(*argv, "pcp-prio") == 0) {
+			dcb_app_print_pcp_prio(dcb, &tab);
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			dcb_app_help_show_flush();
@@ -705,6 +770,11 @@ static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **
 					      &dcb_app_is_dscp);
 			if (ret != 0)
 				goto out;
+		} else if (matches(*argv, "pcp-prio") == 0) {
+			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
+					      &dcb_app_is_pcp);
+			if (ret != 0)
+				goto out;
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			dcb_app_help_show_flush();
diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index a791a940..8eab16e5 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -217,6 +217,7 @@ struct cee_pfc {
 #define IEEE_8021QAZ_APP_SEL_DGRAM	3
 #define IEEE_8021QAZ_APP_SEL_ANY	4
 #define IEEE_8021QAZ_APP_SEL_DSCP       5
+#define IEEE_8021QAZ_APP_SEL_PCP	255
 
 /* This structure contains the IEEE 802.1Qaz APP managed object. This
  * object is also used for the CEE std as well.
diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
index 9780fe4b..1b3bc307 100644
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
 
@@ -182,6 +187,16 @@ command line option
 .B -N
 turns the show translation off.
 
+.TP
+.B pcp-prio \fIPCP-MAP
+\fIPCP-MAP\fR uses the array parameter syntax, see
+.BR dcb (8)
+for details. Keys are PCP/DEI values. Values are priorities assigned to traffic
+with matching PCP and DEI. PCP/DEI values are written as a combination of numeric- and
+symbolic values, to accommodate for both PCP and DEI. PCP always in numerical form e.g
+1 .. 7 and DEI in symbolic form e.g 'de' indicating that the DEI bit is 1.
+In combination 2de:1 translates to a mapping of PCP 2 and DEI 1 to priority 1.
+
 .SH EXAMPLE & USAGE
 
 Prioritize traffic with DSCP 0 to priority 0, 24 to 3 and 48 to 6:
@@ -221,6 +236,16 @@ Flush all DSCP rules:
 .br
 (nothing)
 
+Add a rule to prioritize traffic with PCP 1 and DEI 0 to priority 1 and PCP 2
+and DEI 1 to priority 2:
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

