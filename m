Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4495D5B3538
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiIIK20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiIIK2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:28:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39CF12F234
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 03:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662719302; x=1694255302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fPWV4vVlk7UF/WCr+5IiCenkPnO2D3POu2AquS2y4ZI=;
  b=G8Fk+3qTu8NgQ9RoQtHsv/vljg+sXo0ASalacpj2yLER1Q5b7AZplLgu
   YU/pmYPp1BtF0IiTVdS2aKdYAWfDOOwcmSq69dLsYW2Up9b2sGV9UMwcC
   vIVdDqP5T3F1PqquPvQoSyiBc3oMPPa/h5USt1dL+8hvD8HHtmkB7AAL/
   2m/+jn5IU6lqrHO4p92NELBtH8u+PIAT8T500jGngZmsNz1shyRVpFcC8
   9Uq9YO7ru6EsvfK+R/bgGZRlJtT0Ji7LR8dS1X2pvgznHnhP+qxnuKpvW
   WzhdREusOCuSB5n/mHK3foooKdDMeVLAnxuEj2je5ZE5Zq8nUMUC7ZEVm
   A==;
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="173117257"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 03:28:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 03:28:20 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 03:28:18 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [RFC PATCH iproute2-next 2/2] dcb: add new subcommand for apptrust object
Date:   Fri, 9 Sep 2022 12:37:01 +0200
Message-ID: <20220909103701.468717-3-daniel.machon@microchip.com>
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

Add new apptrust subcommand for the apptrust extension object.

The apptrust command lets you specify a consecutive trust order of app
selectors, which can be used by drivers to determine if DSCP, PCP
or any other standard selector is trusted, and in which order.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/Makefile               |   3 +-
 dcb/dcb.c                  |   4 +-
 dcb/dcb.h                  |   4 +
 dcb/dcb_apptrust.c         | 216 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/dcbnl.h |  14 +++
 man/man8/dcb-apptrust.8    | 122 +++++++++++++++++++++
 6 files changed, 361 insertions(+), 2 deletions(-)
 create mode 100644 dcb/dcb_apptrust.c
 create mode 100644 man/man8/dcb-apptrust.8

diff --git a/dcb/Makefile b/dcb/Makefile
index ca65d467..dd41a559 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -7,7 +7,8 @@ DCBOBJ = dcb.o \
          dcb_dcbx.o \
          dcb_ets.o \
          dcb_maxrate.o \
-         dcb_pfc.o
+         dcb_pfc.o \
+         dcb_apptrust.o
 TARGETS += dcb
 LDLIBS += -lm
 
diff --git a/dcb/dcb.c b/dcb/dcb.c
index 8d75ab0a..35acb237 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -469,7 +469,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
-		"where  OBJECT := { app | buffer | dcbx | ets | maxrate | pfc }\n"
+		"where  OBJECT := { app | apptrust | buffer | dcbx | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -N | --Numeric | -p | --pretty\n"
 		"                  | -s | --statistics | -v | --verbose]\n");
@@ -482,6 +482,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 		return 0;
 	} else if (matches(*argv, "app") == 0) {
 		return dcb_cmd_app(dcb, argc - 1, argv + 1);
+	} else if (matches(*argv, "apptrust") == 0) {
+		return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "buffer") == 0) {
 		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "dcbx") == 0) {
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 244c3d3c..e800b0f4 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -58,6 +58,10 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
 
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
 
+/* dcb_apptrust.c */
+
+int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_buffer.c */
 
 int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_apptrust.c b/dcb/dcb_apptrust.c
new file mode 100644
index 00000000..0fe6cd76
--- /dev/null
+++ b/dcb/dcb_apptrust.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <errno.h>
+#include <linux/dcbnl.h>
+
+#include "dcb.h"
+#include "utils.h"
+
+static void dcb_apptrust_help_set(void)
+{
+	fprintf(stderr,
+		"Usage: dcb apptrust set dev STRING\n"
+		"	[ trust-order [ eth | stream | dgram | any | dscp | pcp ] ]\n"
+		"\n");
+}
+
+static void dcb_apptrust_help_show(void)
+{
+	fprintf(stderr, "Usage: dcb [ -i ] apptrust show dev STRING\n"
+			"           [ trust-order ]\n"
+			"\n");
+}
+
+static void dcb_apptrust_help(void)
+{
+	fprintf(stderr, "Usage: dcb apptrust help\n"
+			"\n");
+	dcb_apptrust_help_show();
+	dcb_apptrust_help_set();
+}
+
+static const char *const selector_names[] = {
+	[IEEE_8021QAZ_APP_SEL_ETHERTYPE] = "eth",
+	[IEEE_8021QAZ_APP_SEL_STREAM]    = "stream",
+	[IEEE_8021QAZ_APP_SEL_DGRAM]     = "dgram",
+	[IEEE_8021QAZ_APP_SEL_ANY]       = "any",
+	[IEEE_8021QAZ_APP_SEL_DSCP]      = "dscp",
+	[IEEE_8021QAZ_APP_SEL_PCP]       = "pcp",
+};
+
+static void dcb_apptrust_print(const struct ieee_apptrust *trust)
+{
+	const char *str;
+	__u8 sel;
+	int i;
+
+	open_json_array(PRINT_JSON, "trust_order");
+	print_string(PRINT_FP, NULL, "trust-order: ", NULL);
+
+	for (i = 0; i < trust->num; i++) {
+		sel = trust->order[i];
+		str = selector_names[sel];
+		print_string(PRINT_ANY, NULL, "%s ", str);
+	}
+	print_nl();
+
+	close_json_array(PRINT_JSON, "trust_order");
+}
+
+static int dcb_apptrust_get(struct dcb *dcb, const char *dev,
+			    struct ieee_apptrust *trust)
+{
+	return dcb_get_attribute(dcb, dev, DCB_ATTR_IEEE_APP_TRUST, trust,
+				 sizeof(*trust));
+}
+
+static int dcb_apptrust_set(struct dcb *dcb, const char *dev,
+			    const struct ieee_apptrust *trust)
+{
+	return dcb_set_attribute(dcb, dev, DCB_ATTR_IEEE_APP_TRUST, trust,
+				 sizeof(*trust));
+}
+
+static bool dcb_apptrust_contains(const struct ieee_apptrust *trust, __u8 sel)
+{
+	int i;
+
+	for (i = 0; i < trust->num; i++)
+		if (trust->order[i] == sel)
+			return true;
+
+	return false;
+}
+
+static int dcb_apptrust_parse_selector_list(int *argcp, char ***argvp,
+					    struct ieee_apptrust *trust)
+{
+	char **argv = *argvp;
+	int argc = *argcp;
+	__u8 sel;
+	int ret;
+
+	NEXT_ARG_FWD();
+
+	/* No trusted selectors ? */
+	if (argc == 0)
+		goto out;
+
+	while (argc > 0) {
+		sel = parse_one_of("trust-order", *argv, selector_names,
+				   ARRAY_SIZE(selector_names), &ret);
+		if (ret < 0)
+			return -EINVAL;
+
+		if (trust->num > IEEE_8021QAZ_APP_SEL_MAX)
+			return -ERANGE;
+
+		if (dcb_apptrust_contains(trust, sel)) {
+			fprintf(stderr, "Duplicate selector: %s\n",
+				selector_names[sel]);
+			return -EINVAL;
+		}
+
+		trust->order[trust->num++] = sel;
+
+		NEXT_ARG_FWD();
+	}
+
+out:
+	*argcp = argc;
+	*argvp = argv;
+
+	return 0;
+}
+
+static int dcb_cmd_apptrust_set(struct dcb *dcb, const char *dev, int argc,
+				char **argv)
+{
+	struct ieee_apptrust trust = {0};
+	int ret;
+
+	if (!argc) {
+		dcb_apptrust_help_set();
+		return 0;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_apptrust_help_set();
+			return 0;
+		} else if (matches(*argv, "trust-order") == 0) {
+			ret = dcb_apptrust_parse_selector_list(&argc, &argv,
+							       &trust);
+			if (ret < 0) {
+				fprintf(stderr, "Invalid list of selectors\n");
+				return -EINVAL;
+			}
+			continue;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_apptrust_help_set();
+			return -EINVAL;
+		}
+
+		NEXT_ARG_FWD();
+	} while (argc > 0);
+
+	return dcb_apptrust_set(dcb, dev, &trust);
+}
+
+static int dcb_cmd_apptrust_show(struct dcb *dcb, const char *dev, int argc,
+				 char **argv)
+{
+	struct ieee_apptrust trust = {0};
+	int ret;
+
+	ret = dcb_apptrust_get(dcb, dev, &trust);
+	if (ret)
+		return ret;
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_apptrust_help();
+		goto out;
+	}
+
+	do {
+		if (matches(*argv, "help") == 0) {
+			dcb_apptrust_help_show();
+			return 0;
+		} else if (matches(*argv, "trust-order") == 0) {
+			dcb_apptrust_print(&trust);
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_apptrust_help_show();
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
+int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv)
+{
+	if (!argc || matches(*argv, "help") == 0) {
+		dcb_apptrust_help();
+		return 0;
+	} else if (matches(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrust_show,
+					 dcb_apptrust_help_show);
+	} else if (matches(*argv, "set") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrust_set,
+					 dcb_apptrust_help_set);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_apptrust_help();
+		return -EINVAL;
+	}
+}
diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index 8eab16e5..833466de 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -248,6 +248,19 @@ struct dcb_app {
 	__u16	protocol;
 };
 
+#define IEEE_8021QAZ_APP_SEL_MAX 255
+
+/* This structure contains trust order extension to the IEEE 802.1Qaz APP
+ * managed object.
+ *
+ * @order: contains trust ordering of selector values for the IEEE 802.1Qaz
+ *               APP managed object. Lower indexes has higher trust.
+ */
+struct ieee_apptrust {
+	__u8 num;
+	__u8 order[IEEE_8021QAZ_APP_SEL_MAX];
+};
+
 /**
  * struct dcb_peer_app_info - APP feature information sent by the peer
  *
@@ -419,6 +432,7 @@ enum ieee_attrs {
 	DCB_ATTR_IEEE_QCN,
 	DCB_ATTR_IEEE_QCN_STATS,
 	DCB_ATTR_DCB_BUFFER,
+	DCB_ATTR_IEEE_APP_TRUST,
 	__DCB_ATTR_IEEE_MAX
 };
 #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
diff --git a/man/man8/dcb-apptrust.8 b/man/man8/dcb-apptrust.8
new file mode 100644
index 00000000..b0d9a571
--- /dev/null
+++ b/man/man8/dcb-apptrust.8
@@ -0,0 +1,122 @@
+.TH DCB-APPTRUST 8 "5 September 2022" "iproute2" "Linux"
+.SH NAME
+dcb-apptrust \- show / manipulate the trust and trust order of the application
+priority table of the DCB (Data Center Bridging) subsystem
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+
+.ti -8
+.B dcb
+.RI "[ " OPTIONS " ] "
+.B apptrust
+.RI "{ " COMMAND " | " help " }"
+.sp
+
+.ti -8
+.B dcb apptrust show dev
+.RI DEV
+
+.ti -8
+.B dcb apptrust set dev
+.RI DEV
+.RB "[ " eth " ]"
+.RB "[ " stream " ]"
+.RB "[ " dgram " ]"
+.RB "[ " any " ]"
+.RB "[ " dscp " ]"
+.RB "[ " pcp " ]"
+
+.SH DESCRIPTION
+
+.B dcb apptrust
+is used to configure and inspect the trust and trust order of the Application
+Priority Table, see
+.BR dcb-app (8)
+for details on how to configure app table entries.
+
+.SH COMMANDS
+
+.TP
+.B show
+Display all trusted selectors
+
+.TP
+.B set
+Set new list of trusted selectors. Empty list is effectively the same as
+removing trust entirely.
+
+.SH PARAMETERS
+
+The following describes only the write direction, i.e. as used with the
+\fBset\fR command. For the \fBshow\fR command, the parameter name is to be used
+as a simple keyword without further arguments. This instructs the tool to show
+the values of a given parameter.
+
+.TP
+.B trust-order \fISELECTOR-NAMES
+\fISELECTOR-NAMES\fR is a space-seperated list selector names:\fR
+
+.TP
+.TQ
+.B eth
+Trust EtherType
+
+.TP
+.TQ
+.B stream
+Trust TCP, or Stream Control Transmission Protocol (SCTP).
+
+.TP
+.TQ
+.B dgram
+Trust UDP, or Datagram Congestion Control Protocol (DCCP).
+
+.TP
+.TQ
+.B any
+Trust TCP, SCTP, UDP, or DCCP.
+
+.TP
+.TQ
+.B dscp
+Trust Differentiated Services Code Point (DSCP) values.
+
+.TP
+.TQ
+.B pcp
+Trust Priority Code Point/Drop Eligible Indicator (PCP/DEI).
+
+
+.SH EXAMPLE & USAGE
+
+Set trust order to: dscp, pcp for eth0:
+.P
+# dcb apptrust set dev eth0 trust-order dscp pcp
+
+Set trust order to: any (stream or dgram), pcp, eth for eth1:
+.P
+# dcb apptrust set dev eth1 trust-order any pcp eth
+
+Show what was set:
+
+.P
+# dcb apptrust show dev eth0
+.br
+trust-order: any pcp eth
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
+Daniel Machon <daniel.machon@microchip.com>
-- 
2.34.1

