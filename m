Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAD53E43E1
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhHIKX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33939 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234692AbhHIKXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:45 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 60D3E5C0136;
        Mon,  9 Aug 2021 06:23:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 09 Aug 2021 06:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QBa80+Qv0E42aXBMgEcpuUi9zmt7lJ9BJZ38rQU1kmM=; b=imj6Ve1W
        Efybh0jWzyzwGIFsxxZJqt6c+ife2dzVy6ppLZf5uxhdvLIA9waQ/Lv0LunLNwXL
        bxgjnd3/qcQ4w/ayowsfq5gaXwFNkZD8L1VNM68gAVPl1iZrta9OqHufRMihnYHJ
        T92WLg938/7YZRfn6hcvQiBp+gaatxicmvgkbRxereodzTRZUsjlL3xtTUTvEPG7
        XGvuDKSx5DpA8Utx1Ppvze/7yymP7rQjO1rWgtt7Xm731elHMnW3cy/VpCHBeomL
        4vBP/oDHPKlUZyNilKFM13hM3RKYglJlQ4kzHSHnP+Pezw7+DKPxKAl+zKgQlcCp
        7DLrZQgV31yBxA==
X-ME-Sender: <xms:HQIRYR9iUZ1CL0iPBZxjFaixHnTiFJKqUXMcUJthyMbBSt8PcLDtJg>
    <xme:HQIRYVu9WLjqaisogDRuIlNbn0qWvDwtkoqfKnRnzEUEcjWxV6uq1gNSEZE5qmcYf
    HGH7Pcjm65-wQs>
X-ME-Received: <xmr:HQIRYfC5LKl_JCI_ZvjMuoeKUCOw8BJ_8FTx2q0jAJ0hUjrNdrGN2VkAMVoaWyCvuELHRN4zC3Yhmp2N2hbMeAmpg83Fmb_QiiwY-1kCep76hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpeefnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:HQIRYVc3PAXmequfOik6_Q0CmoMpMiWXDkLzaoVb8DpTnVdCEUpMtw>
    <xmx:HQIRYWN-0waLezuXYYG9oIGXSFdhihhmDrX5oLPkPkemAUjK4douIQ>
    <xmx:HQIRYXlexMmX1-Y6tXR9PV6B_BFfBArnJtKPgoSdNSIStbCYjOq3cg>
    <xmx:HQIRYSCN51WfmgKAJITeMKmrmA47nPeakuvztsgZnpmD7zXt7UCu6A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:23:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 2/6] ethtool: Add ability to control transceiver modules' low power mode
Date:   Mon,  9 Aug 2021 13:22:52 +0300
Message-Id: <20210809102256.720119-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102256.720119-1-idosch@idosch.org>
References: <20210809102256.720119-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add ability to control transceiver modules' low power mode over netlink.

Example output and usage:

 $ ethtool --show-module swp11
 Module parameters for swp11:
 low-power false

 $ ethtool --json --show-module swp11
 [ {
        "ifname": "swp11",
        "low-power": false
    } ]

 # ethtool --set-module swp11 low-power on

 $ ethtool --show-module swp11
 Module parameters for swp11:
 low-power true

 # ethtool --set-module swp11 low-power on

 # ethtool --set-module swp11 low-power off

Despite three set commands, only two notifications were emitted, as the
kernel only emits notifications when an attribute changes:

 $ ethtool --monitor
 listening...

 Module parameters for swp11:
 low-power true

 Module parameters for swp11:
 low-power false

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Makefile.am                   |   2 +-
 ethtool.8.in                  |  15 ++++
 ethtool.c                     |  11 +++
 netlink/desc-ethtool.c        |  10 +++
 netlink/extapi.h              |   4 +
 netlink/module.c              | 139 ++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |   4 +
 netlink/netlink.h             |   1 +
 shell-completion/bash/ethtool |  22 ++++++
 9 files changed, 207 insertions(+), 1 deletion(-)
 create mode 100644 netlink/module.c

diff --git a/Makefile.am b/Makefile.am
index dd357d0a158a..dc5fbec1e09d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -39,7 +39,7 @@ ethtool_SOURCES += \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
 		  netlink/stats.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
-		  netlink/module-eeprom.c \
+		  netlink/module-eeprom.c netlink/module.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
diff --git a/ethtool.8.in b/ethtool.8.in
index f83d6d17ae41..f9d901cdefca 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -475,6 +475,13 @@ ethtool \- query or control network driver and hardware settings
 .HP
 .B ethtool \-\-show\-tunnels
 .I devname
+.HP
+.B ethtool \-\-show\-module
+.I devname
+.HP
+.B ethtool \-\-set\-module
+.I devname
+.B2 low-power on off
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1458,6 +1465,14 @@ Show tunnel-related device capabilities and state.
 List UDP ports kernel has programmed the device to parse as VxLAN,
 or GENEVE tunnels.
 .RE
+.TP
+.B \-\-set\-module
+Set the transceiver module's parameters.
+.RS 4
+.TP
+.A2 low-power on off
+Enable / disable forcing of low power mode by the host.
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
diff --git a/ethtool.c b/ethtool.c
index 33a0a492cb15..89ff03b18fbf 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6020,6 +6020,17 @@ static const struct option args[] = {
 		.nlfunc	= nl_gtunnels,
 		.help	= "Show NIC tunnel offload information",
 	},
+	{
+		.opts	= "--show-module",
+		.nlfunc	= nl_gmodule,
+		.help	= "Show transceiver module settings",
+	},
+	{
+		.opts	= "--set-module",
+		.nlfunc	= nl_smodule,
+		.help	= "Set transceiver module settings",
+		.xhelp	= "		[ low-power on|off ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index d6fc4e2d03df..3fb31b28f288 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -374,6 +374,12 @@ const struct pretty_nla_desc __module_eeprom_desc[] = {
 	NLATTR_DESC_BINARY(ETHTOOL_A_MODULE_EEPROM_DATA)
 };
 
+static const struct pretty_nla_desc __module_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_MODULE_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MODULE_HEADER, header),
+	NLATTR_DESC_BOOL(ETHTOOL_A_MODULE_LOW_POWER_ENABLED),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -408,6 +414,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_FEC_SET, fec),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET, stats),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET, module_eeprom),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET, module),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -447,6 +455,8 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_FEC_NTF, fec),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET_REPLY, stats),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY, module_eeprom),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET_REPLY, module),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_NTF, module),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 91bf02b5e3be..2ab4c6bc2f8d 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -43,6 +43,8 @@ int nl_gfec(struct cmd_context *ctx);
 int nl_sfec(struct cmd_context *ctx);
 bool nl_gstats_chk(struct cmd_context *ctx);
 int nl_gstats(struct cmd_context *ctx);
+int nl_gmodule(struct cmd_context *ctx);
+int nl_smodule(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
 
@@ -99,6 +101,8 @@ static inline void nl_monitor_usage(void)
 #define nl_gstats_chk		NULL
 #define nl_gstats		NULL
 #define nl_getmodule		NULL
+#define nl_gmodule		NULL
+#define nl_smodule		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/module.c b/netlink/module.c
new file mode 100644
index 000000000000..59a149075f0f
--- /dev/null
+++ b/netlink/module.c
@@ -0,0 +1,139 @@
+/*
+ * module.c - netlink implementation of module commands
+ *
+ * Implementation of "ethtool --show-module <dev>" and
+ * "ethtool --set-module <dev> ..."
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
+/* MODULE_GET */
+
+int module_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MODULE_MAX + 1] = {};
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
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_MODULE_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "Module parameters for %s:\n",
+		     nlctx->devname);
+
+	if (tb[ETHTOOL_A_MODULE_LOW_POWER_ENABLED]) {
+		bool low_power;
+
+		low_power =
+			mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_LOW_POWER_ENABLED]);
+		print_bool(PRINT_ANY, "low-power", "low-power %s\n", low_power);
+	}
+
+	close_json_object();
+
+	return MNL_CB_OK;
+}
+
+int nl_gmodule(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	nlsk = nlctx->ethnl_socket;
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_MODULE_GET,
+				      ETHTOOL_A_MODULE_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, module_reply_cb);
+	delete_json_obj();
+	return ret;
+}
+
+/* MODULE_SET */
+
+static const struct param_parser smodule_params[] = {
+	{
+		.arg		= "low-power",
+		.type		= ETHTOOL_A_MODULE_LOW_POWER_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_smodule(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_SET, false))
+		return -EOPNOTSUPP;
+	if (!ctx->argc) {
+		fprintf(stderr, "ethtool (--set-module): parameters missing\n");
+		return 1;
+	}
+
+	nlctx->cmd = "--set-module";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_MODULE_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_MODULE_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, smodule_params, NULL, PARSER_GROUP_NONE, NULL);
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
diff --git a/netlink/monitor.c b/netlink/monitor.c
index 0c4df9e78ee3..d631907817e2 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -71,6 +71,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_FEC_NTF,
 		.cb	= fec_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_NTF,
+		.cb	= module_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 70fa666b20e5..f43c1bff6a58 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -91,6 +91,7 @@ int cable_test_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int module_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
diff --git a/shell-completion/bash/ethtool b/shell-completion/bash/ethtool
index 45573413985d..5db3b4f50232 100644
--- a/shell-completion/bash/ethtool
+++ b/shell-completion/bash/ethtool
@@ -1137,6 +1137,26 @@ _ethtool_test()
 	fi
 }
 
+# Completion for ethtool --set-module
+_ethtool_set_module()
+{
+	local -A settings=(
+		[low-power]=1
+	)
+
+	if [ "${settings[$prev]+set}" ]; then
+		COMPREPLY=( $( compgen -W 'on off' -- "$cur" ) )
+		return
+	fi
+
+	# Remove settings which have been seen
+	local word
+	for word in "${words[@]:3:${#words[@]}-4}"; do
+		unset "settings[$word]"
+	done
+
+	COMPREPLY=( $( compgen -W "${!settings[*]}" -- "$cur" ) )
+}
 
 # Complete any ethtool command
 _ethtool()
@@ -1189,6 +1209,8 @@ _ethtool()
 		[--show-time-stamping]=devname
 		[--statistics]=devname
 		[--test]=test
+		[--set-module]=set_module
+		[--show-module]=devname
 	)
 	local -A other_funcs=(
 		[--config-ntuple]=config_nfc
-- 
2.31.1

