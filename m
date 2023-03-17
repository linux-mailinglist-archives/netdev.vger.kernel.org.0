Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C612A6BE5A4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjCQJao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCQJan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:30:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3B6CB074
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 02:30:31 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pd6Pt-0005QA-Lh; Fri, 17 Mar 2023 10:30:29 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pd6Ps-004k56-UH; Fri, 17 Mar 2023 10:30:28 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pd6Ps-004Pk6-9c; Fri, 17 Mar 2023 10:30:28 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org
Subject: [PATCH ethtool v1 1/1] add support for Ethernet PSE and PD devices
Date:   Fri, 17 Mar 2023 10:30:24 +0100
Message-Id: <20230317093024.1051999-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implementation aims to provide compatibility for Ethernet PSE
(Power Sourcing Equipment) and PDs (Powered Devices).

In its present state, this patch offers generic PSE support for PoDL
(Power over Data Lines 802.3bu) specifications while also reserving
namespace for PD devices.

The infrastructure can be expanded to include 802.3af and 802.3at "Power
via the Media Dependent Interface" (or PoE/Power over Ethernet).

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 Makefile.am      |   1 +
 ethtool.8.in     |  39 ++++++++++
 ethtool.c        |  12 +++
 netlink/extapi.h |   4 +
 netlink/pse-pd.c | 193 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 249 insertions(+)
 create mode 100644 netlink/pse-pd.c

diff --git a/Makefile.am b/Makefile.am
index c83cb18..3879138 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -43,6 +43,7 @@ ethtool_SOURCES += \
 		  netlink/module-eeprom.c netlink/module.c netlink/rss.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  netlink/plca.c \
+		  netlink/pse-pd.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h \
diff --git a/ethtool.8.in b/ethtool.8.in
index 3672e44..5ff6e40 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -522,6 +522,14 @@ ethtool \- query or control network driver and hardware settings
 .BR on | off ]
 .RB [ tx\-min\-frag\-size
 .BR N ]
+.HP
+.B ethtool \-\-show\-pse
+.I devname
+.HP
+.B ethtool \-\-set\-pse
+.I devname
+.RB [ podl\-pse\-admin\-control
+.BR enable | disable ]
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1703,6 +1711,37 @@ Enable or disable the verification state machine.
 Set the interval in ms between verification attempts.
 
 .RE
+.TP
+.B \-\-show\-pse
+Show the current Power Sourcing Equipment (PSE) status for the given interface.
+.RS 4
+.TP
+.B podl-pse-admin-state
+This attribute indicates the operational status of PoDL PSE functions, which
+can be modified using the
+.B podl-pse-admin-control
+parameter. It corresponds to IEEE 802.3-2018 30.15.1.1.2 (aPoDLPSEAdminState),
+with potential values being
+.B enabled, disabled
+.TP
+.B podl-pse-power-detection-status
+This attribute indicates the power detection status of the PoDL PSE. The
+status depend on internal PSE state machine and automatic PD classification
+support. It corresponds to IEEE 802.3-2018 30.15.1.1.3
+(aPoDLPSEPowerDetectionStatus) with potential values being
+.B disabled, searching, delivering power, sleep, idle, error
+.RE
+
+.RE
+.TP
+.B \-\-set\-pse
+Set Power Sourcing Equipment (PSE) parameters.
+.RS 4
+.TP
+.A2 podl-pse-admin-control \ enable disable
+This parameter manages PoDL PSE Admin operations in accordance with the IEEE
+802.3-2018 30.15.1.2.1 (acPoDLPSEAdminControl) specification.
+
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
diff --git a/ethtool.c b/ethtool.c
index 6022a6e..2a2d99f 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6120,6 +6120,18 @@ static const struct option args[] = {
 			  "		[ pmac-enabled on|off ]\n"
 			  "		[ tx-min-frag-size 60-252 ]\n"
 	},
+	{
+		.opts	= "--show-pse",
+		.json	= true,
+		.nlfunc	= nl_gpse,
+		.help	= "Show settings for Power Sourcing Equipment",
+	},
+	{
+		.opts	= "--set-pse",
+		.nlfunc	= nl_spse,
+		.help	= "Set Power Sourcing Equipment settings",
+		.xhelp	= "		[ podl-pse-admin-control enable|disable ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/extapi.h b/netlink/extapi.h
index bbe0633..e2d6b71 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -53,6 +53,8 @@ int nl_plca_set_cfg(struct cmd_context *ctx);
 int nl_plca_get_status(struct cmd_context *ctx);
 int nl_get_mm(struct cmd_context *ctx);
 int nl_set_mm(struct cmd_context *ctx);
+int nl_gpse(struct cmd_context *ctx);
+int nl_spse(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -126,6 +128,8 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_plca_get_status	NULL
 #define nl_get_mm		NULL
 #define nl_set_mm		NULL
+#define nl_gpse			NULL
+#define nl_spse			NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/pse-pd.c b/netlink/pse-pd.c
new file mode 100644
index 0000000..d6faff8
--- /dev/null
+++ b/netlink/pse-pd.c
@@ -0,0 +1,193 @@
+/*
+ * pse.c - netlink implementation of pse commands
+ *
+ * Implementation of "ethtool --show-pse <dev>" and
+ * "ethtool --set-pse <dev> ..."
+ */
+
+#include <errno.h>
+#include <ctype.h>
+#include <inttypes.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "parser.h"
+
+/* PSE_GET */
+
+static const char *podl_pse_admin_state_name(u32 val)
+{
+	switch (val) {
+	case ETHTOOL_PODL_PSE_ADMIN_STATE_UNKNOWN:
+		return "unknown";
+	case ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED:
+		return "disabled";
+	case ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED:
+		return "enabled";
+	default:
+		return "unsupported";
+	}
+}
+
+static const char *podl_pse_pw_d_status_name(u32 val)
+{
+	switch (val) {
+	case ETHTOOL_PODL_PSE_PW_D_STATUS_UNKNOWN:
+		return "unknown";
+	case ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED:
+		return "disabled";
+	case ETHTOOL_PODL_PSE_PW_D_STATUS_SEARCHING:
+		return "searching";
+	case ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING:
+		return "delivering power";
+	case ETHTOOL_PODL_PSE_PW_D_STATUS_SLEEP:
+		return "sleep";
+	case ETHTOOL_PODL_PSE_PW_D_STATUS_IDLE:
+		return "idle";
+	case ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR:
+		return "error";
+	default:
+		return "unsupported";
+	}
+}
+
+int pse_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PSE_MAX + 1] = {};
+	struct nl_context *nlctx = data;
+	DECLARE_ATTR_TB_INFO(tb);
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PSE_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "PSE attributes for %s:\n",
+		     nlctx->devname);
+
+	if (tb[ETHTOOL_A_PODL_PSE_ADMIN_STATE]) {
+		u32 val;
+
+		val = mnl_attr_get_u32(tb[ETHTOOL_A_PODL_PSE_ADMIN_STATE]);
+		print_string(PRINT_ANY, "podl-pse-admin-state",
+			     "PoDL PSE Admin State: %s\n",
+			     podl_pse_admin_state_name(val));
+	}
+
+	if (tb[ETHTOOL_A_PODL_PSE_PW_D_STATUS]) {
+		u32 val;
+
+		val = mnl_attr_get_u32(tb[ETHTOOL_A_PODL_PSE_PW_D_STATUS]);
+		print_string(PRINT_ANY, "podl-pse-power-detection-status",
+			     "PoDL PSE Power Detection Status: %s\n",
+			     podl_pse_pw_d_status_name(val));
+	}
+
+	close_json_object();
+
+	return MNL_CB_OK;
+}
+
+int nl_gpse(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PSE_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	nlsk = nlctx->ethnl_socket;
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PSE_GET,
+				      ETHTOOL_A_PSE_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, pse_reply_cb);
+	delete_json_obj();
+
+	return ret;
+}
+
+/* PSE_SET */
+
+static const struct lookup_entry_u32 podl_pse_admin_control_values[] = {
+	{ .arg = "enable",	.val = ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED },
+	{ .arg = "disable",	.val = ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED },
+	{}
+};
+
+static const struct param_parser spse_params[] = {
+	{
+		.arg		= "podl-pse-admin-control",
+		.type		= ETHTOOL_A_PODL_PSE_ADMIN_CONTROL,
+		.handler	= nl_parse_lookup_u32,
+		.handler_data	= podl_pse_admin_control_values,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_spse(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PSE_SET, false))
+		return -EOPNOTSUPP;
+	if (!ctx->argc) {
+		fprintf(stderr, "ethtool (--set-pse): parameters missing\n");
+		return 1;
+	}
+
+	nlctx->cmd = "--set-pse";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_PSE_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_PSE_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, spse_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 83;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	else
+		return nlctx->exit_code ?: 83;
+}
-- 
2.30.2

