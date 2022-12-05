Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39416437BF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiLEWK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiLEWKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:10:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726F1FCFE
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 14:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670278222; x=1701814222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=esBB4UMIWEGWkBL5RcUjvbWqE8kLQUtyrrSfUnqw2Q4=;
  b=pQV+kJf8cz+eqBU4yfCaZ9OeGjXU0MsQDiZwLlDIxMW3nWC8uQPCzNmB
   oz2OeNoB0DWSVonMFKALQCyRE2fa7fH44cP39+pW5EFTtANRoSprZuuS3
   XP2sVmnF+wxjzk14y/+DDxkH6AAuBCd58clzKTly6+rrvZTxn+tFLkvLb
   TvxQEOx9NankfOyoI1Yscwbc8TI+CI2ISfau8H6Gl6si8B4c3pEESiAY9
   c7kCaGKd2sWRXOLoFlhaHzzReo9ScW9gqmakp16mCSAMEcZPhqt9G+sVl
   bPasIwrdA/YcRbcMfMQa06yn4xo7XkFl2XBfcjn3JNaTWRntx+CPkqRkw
   w==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="190146725"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 15:10:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 15:10:17 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 5 Dec 2022 15:10:15 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH iproute2-next v4 2/2] dcb: add new subcommand for apptrust
Date:   Mon, 5 Dec 2022 23:21:45 +0100
Message-ID: <20221205222145.753826-3-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205222145.753826-1-daniel.machon@microchip.com>
References: <20221205222145.753826-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new apptrust subcommand for the dcbnl apptrust extension object.

The apptrust command lets you specify a consecutive ordered list of
trusted selectors, which can be used by drivers to determine which
selectors are eligible (trusted) for packet prioritization, and in which
order.

Selectors are sent in a new nested attribute:
DCB_ATTR_IEEE_APP_TRUST_TABLE.  The nest contains trusted selectors
encapsulated in either DCB_ATTR_IEEE_APP or DCB_ATTR_DCB_APP attributes,
for standard and non-standard selectors, respectively.

Example:

Trust selectors dscp and pcp, in that order
$ dcb apptrust set dev eth0 order dscp pcp

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 dcb/Makefile            |   3 +-
 dcb/dcb.c               |   4 +-
 dcb/dcb.h               |   4 +
 dcb/dcb_apptrust.c      | 307 ++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-apptrust.8 | 109 ++++++++++++++
 5 files changed, 425 insertions(+), 2 deletions(-)
 create mode 100644 dcb/dcb_apptrust.c
 create mode 100644 man/man8/dcb-apptrust.8

diff --git a/dcb/Makefile b/dcb/Makefile
index ca65d4670c80..dd41a559a0c8 100644
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
index 391fd95455f4..3ffa91d64d0d 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -470,7 +470,7 @@ static void dcb_help(void)
 	fprintf(stderr,
 		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
-		"where  OBJECT := { app | buffer | dcbx | ets | maxrate | pfc }\n"
+		"where  OBJECT := { app | apptrust | buffer | dcbx | ets | maxrate | pfc }\n"
 		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
 		"                  | -N | --Numeric | -p | --pretty\n"
 		"                  | -s | --statistics | -v | --verbose]\n");
@@ -483,6 +483,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
 		return 0;
 	} else if (matches(*argv, "app") == 0) {
 		return dcb_cmd_app(dcb, argc - 1, argv + 1);
+	} else if (strcmp(*argv, "apptrust") == 0) {
+		return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "buffer") == 0) {
 		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
 	} else if (matches(*argv, "dcbx") == 0) {
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 05eddcbbcfdf..d40664f29dad 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -61,6 +61,10 @@ enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
 bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
 bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);

+/* dcb_apptrust.c */
+
+int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
+
 /* dcb_buffer.c */

 int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_apptrust.c b/dcb/dcb_apptrust.c
new file mode 100644
index 000000000000..ed1cba76929b
--- /dev/null
+++ b/dcb/dcb_apptrust.c
@@ -0,0 +1,307 @@
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
+		"       [ order [ ethtype | stream-port | dgram-port | port | dscp | pcp ] ]\n"
+		"\n");
+}
+
+static void dcb_apptrust_help_show(void)
+{
+	fprintf(stderr, "Usage: dcb apptrust show dev STRING\n"
+			"       [ order ]\n"
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
+	[IEEE_8021QAZ_APP_SEL_ETHERTYPE] = "ethtype",
+	[IEEE_8021QAZ_APP_SEL_STREAM]    = "stream-port",
+	[IEEE_8021QAZ_APP_SEL_DGRAM]     = "dgram-port",
+	[IEEE_8021QAZ_APP_SEL_ANY]       = "port",
+	[IEEE_8021QAZ_APP_SEL_DSCP]      = "dscp",
+	[DCB_APP_SEL_PCP]                = "pcp",
+};
+
+struct dcb_apptrust_table {
+	__u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1];
+	int nselectors;
+};
+
+static bool dcb_apptrust_contains(const struct dcb_apptrust_table *table,
+				  __u8 selector)
+{
+	int i;
+
+	for (i = 0; i < table->nselectors; i++)
+		if (table->selectors[i] == selector)
+			return true;
+
+	return false;
+}
+
+static void dcb_apptrust_print_order(const struct dcb_apptrust_table *table)
+{
+	const char *str;
+	__u8 selector;
+	int i;
+
+	open_json_array(PRINT_JSON, "order");
+	print_string(PRINT_FP, NULL, "order: ", NULL);
+
+	for (i = 0; i < table->nselectors; i++) {
+		selector = table->selectors[i];
+		str = selector_names[selector];
+		print_string(PRINT_ANY, NULL, "%s ", str);
+	}
+	print_nl();
+
+	close_json_array(PRINT_JSON, "order");
+}
+
+static void dcb_apptrust_print(const struct dcb_apptrust_table *table)
+{
+	dcb_apptrust_print_order(table);
+	print_nl();
+}
+
+static int dcb_apptrust_get_cb(const struct nlattr *attr, void *data)
+{
+	struct dcb_apptrust_table *table = data;
+	uint16_t type;
+	__u8 selector;
+
+	type = mnl_attr_get_type(attr);
+
+	if (!dcb_app_attr_type_validate(type)) {
+		fprintf(stderr,
+			"Unknown attribute in DCB_ATTR_IEEE_APP_TRUST_TABLE: %d\n",
+			type);
+		return MNL_CB_OK;
+	}
+
+	if (mnl_attr_get_payload_len(attr) < 1) {
+		fprintf(stderr,
+			"DCB_ATTR_IEEE_APP_TRUST payload expected to have size %zd, not %d\n",
+			sizeof(struct dcb_app), mnl_attr_get_payload_len(attr));
+		return MNL_CB_OK;
+	}
+
+	selector = mnl_attr_get_u8(attr);
+
+	/* Check that selector is encapsulated in the right attribute */
+	if (!dcb_app_selector_validate(type, selector)) {
+		fprintf(stderr, "Wrong type for selector: %s\n",
+			selector_names[selector]);
+		return MNL_CB_OK;
+	}
+
+	table->selectors[table->nselectors++] = selector;
+
+	return MNL_CB_OK;
+}
+
+static int dcb_apptrust_get(struct dcb *dcb, const char *dev,
+			    struct dcb_apptrust_table *table)
+{
+	uint16_t payload_len;
+	void *payload;
+	int ret;
+
+	ret = dcb_get_attribute_va(dcb, dev, DCB_ATTR_DCB_APP_TRUST_TABLE,
+				   &payload, &payload_len);
+	if (ret != 0)
+		return ret;
+
+	ret = mnl_attr_parse_payload(payload, payload_len, dcb_apptrust_get_cb,
+				     table);
+	if (ret != MNL_CB_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int dcb_apptrust_set_cb(struct dcb *dcb, struct nlmsghdr *nlh,
+			       void *data)
+{
+	const struct dcb_apptrust_table *table = data;
+	enum ieee_attrs_app type;
+	struct nlattr *nest;
+	int i;
+
+	nest = mnl_attr_nest_start(nlh, DCB_ATTR_DCB_APP_TRUST_TABLE);
+
+	for (i = 0; i < table->nselectors; i++) {
+		type = dcb_app_attr_type_get(table->selectors[i]);
+		mnl_attr_put_u8(nlh, type, table->selectors[i]);
+	}
+
+	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
+}
+
+static int dcb_apptrust_set(struct dcb *dcb, const char *dev,
+			    const struct dcb_apptrust_table *table)
+{
+	return dcb_set_attribute_va(dcb, DCB_CMD_IEEE_SET, dev,
+				    &dcb_apptrust_set_cb, (void *)table);
+}
+
+static __u8 dcb_apptrust_parse_selector(const char *selector, int *err)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(selector_names); i++) {
+		if (selector_names[i] &&
+		    strcmp(selector, selector_names[i]) == 0) {
+			    *err = 0;
+			    return i;
+		    }
+	}
+
+	*err = -EINVAL;
+	return 0;
+}
+
+static int dcb_apptrust_parse_selector_list(int *argcp, char ***argvp,
+					    struct dcb_apptrust_table *table)
+{
+	int argc = *argcp, err;
+	char **argv = *argvp;
+	__u8 selector;
+
+	/* No trusted selectors ? */
+	if (argc == 0)
+		goto out;
+
+	while (argc > 0) {
+		selector = dcb_apptrust_parse_selector(*argv, &err);
+		if (err < 0)
+			goto out;
+
+		if (table->nselectors > IEEE_8021QAZ_APP_SEL_MAX)
+			return -ERANGE;
+
+		if (dcb_apptrust_contains(table, selector)) {
+			fprintf(stderr, "Duplicate selector: %s\n",
+				selector_names[selector]);
+			return -EINVAL;
+		}
+
+		table->selectors[table->nselectors++] = selector;
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
+	struct dcb_apptrust_table table = { 0 };
+	int ret;
+
+	if (!argc) {
+		dcb_apptrust_help_set();
+		return 0;
+	}
+
+	do {
+		if (strcmp(*argv, "help") == 0) {
+			dcb_apptrust_help_set();
+			return 0;
+		} else if (strcmp(*argv, "order") == 0) {
+			NEXT_ARG_FWD();
+			ret = dcb_apptrust_parse_selector_list(&argc, &argv,
+							       &table);
+			if (ret < 0) {
+				fprintf(stderr, "Invalid list of selectors\n");
+				return -EINVAL;
+			}
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			dcb_apptrust_help_set();
+			return -EINVAL;
+		}
+	} while (argc > 0);
+
+	return dcb_apptrust_set(dcb, dev, &table);
+}
+
+static int dcb_cmd_apptrust_show(struct dcb *dcb, const char *dev, int argc,
+				 char **argv)
+{
+	struct dcb_apptrust_table table = { 0 };
+	int ret;
+
+	ret = dcb_apptrust_get(dcb, dev, &table);
+	if (ret)
+		return ret;
+
+	open_json_object(NULL);
+
+	if (!argc) {
+		dcb_apptrust_print(&table);
+		goto out;
+	}
+
+	do {
+		if (strcmp(*argv, "help") == 0) {
+			dcb_apptrust_help_show();
+			return 0;
+		} else if (strcmp(*argv, "order") == 0) {
+			dcb_apptrust_print_order(&table);
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
+	if (!argc || strcmp(*argv, "help") == 0) {
+		dcb_apptrust_help();
+		return 0;
+	} else if (strcmp(*argv, "show") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrust_show,
+					 dcb_apptrust_help_show);
+	} else if (strcmp(*argv, "set") == 0) {
+		NEXT_ARG_FWD();
+		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrust_set,
+					 dcb_apptrust_help_set);
+	} else {
+		fprintf(stderr, "What is \"%s\"?\n", *argv);
+		dcb_apptrust_help();
+		return -EINVAL;
+	}
+}
diff --git a/man/man8/dcb-apptrust.8 b/man/man8/dcb-apptrust.8
new file mode 100644
index 000000000000..03da5edb3cfc
--- /dev/null
+++ b/man/man8/dcb-apptrust.8
@@ -0,0 +1,109 @@
+.TH DCB-APPTRUST 8 "22 November 2022" "iproute2" "Linux"
+.SH NAME
+dcb-apptrust \- show / configure per-selector trust and trust order of the
+application priority table of the DCB (Data Center Bridging) subsystem.
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
+.RB "[ " order " ]"
+
+.ti -8
+.B dcb apptrust set dev
+.RI DEV
+.RB "[ " order " " \fiSEL-LIST\fB " ]"
+
+.ti -8
+.IR SEL-LIST " := [ " SEL-LIST " ] " SEL
+
+.ti -8
+.IR SEL " := { " ethtype " | " stream-port " | " dgram-port " | " port " | " dscp " | " pcp " } "
+
+.SH DESCRIPTION
+
+.B dcb apptrust
+is used to configure per-selector trust and trust order of the
+Application Priority Table, see
+.BR dcb-app (8)
+for details on how to configure app table entries.
+
+Selector trust can be used by the
+software stack, or drivers (most likely the latter), when querying the APP
+table, to determine if an APP entry should take effect, or not. Additionaly, the
+order of the trusted selectors will dictate which selector should take
+precedence, in the case of multiple different APP table selectors being present.
+
+.SH COMMANDS
+
+.TP
+.B show
+Display all trusted selectors.
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
+.B order \fISEL-LIST
+\fISEL-LIST\fR is a space-separated list of selector names. Possible selector
+values are:
+.B ethtype,
+.B stream-port,
+.B dgram-port,
+.B port,
+.B dscp,
+and
+.B pcp
+
+
+.SH EXAMPLE & USAGE
+
+Set trust order to: dscp, pcp for eth0:
+.P
+# dcb apptrust set dev eth0 order dscp pcp
+
+Set trust order to: port (stream or dgram), pcp, ethtype for eth1:
+.P
+# dcb apptrust set dev eth1 order port pcp ethtype
+
+Show what was set:
+
+.P
+# dcb apptrust show dev eth0
+.br
+order: port pcp ethtype
+
+.SH EXIT STATUS
+Exit status is 0 if command was successful or a positive integer upon failure.
+
+.SH SEE ALSO
+.BR dcb (8),
+.BR dcb-app (8)
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

