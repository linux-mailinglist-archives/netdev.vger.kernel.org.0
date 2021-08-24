Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A2C3F5EA5
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbhHXNG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:06:28 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:46431 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237506AbhHXNG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:06:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0E822580B17;
        Tue, 24 Aug 2021 09:05:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Aug 2021 09:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=k5cJ6SXeUq2uTmbWzFA0RdcXQKCRPO30VQ7JfNCXJNw=; b=ElkV/Frw
        gmZ6zCfZapgNKZW2r3P/5KcJ039HFCRs2yOA2m1UD0+gStHW7LPw7oian+TMEoLO
        etxRZHGeTPWBH8n+r12LZpYyke5BtWyyAIes5T7oy44KuZnHfxcsTRFcPYpanf3N
        dL+Gavcq7xPfG7666nz30SmVvron38Maal4XSqKPxdf9PTqXwsj2m9R/cYi7fEv8
        6HWvw5UPJ/u92TaqjpJJX27JYBxcOZ9qKFWWzuN8N8ZVYkMf5iv2FduyWhltyiM7
        G9UN4Fc7B1N93kYqjoX1PdBI+5nMO6Aqy6G2yuNFAAftwMhmXnprD8q0/iSqVhaD
        sjSXfg+Z8Goyug==
X-ME-Sender: <xms:pe4kYTrxqOp79tq0pxtzJcYT_vuqysMFnqMTnmF9x5P3L6Zps8S10g>
    <xme:pe4kYdrtFqgQXRTmzOaaNyyRREazyin-grwmGqZx6QgxUFHrKiPdsM1uwEHu6pKhI
    p-v3bC85yTIRhw>
X-ME-Received: <xmr:pe4kYQN6zXMyo92C6_jUA3m7ySytfuoUoMEuVNz3Jk9A4kVXFgLDQkD07zl4RQiJT8yjilXsJzi1n849lDpuezkigrWNzMg_f3_coumzdBv1tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pe4kYW4Rw0NS_aaVdTjvOA9WXhyiHL5iXRezNpHHxccYhOy9T-dkWg>
    <xmx:pe4kYS4EY83y4zSJGIdOrFn7Xuqx9oiEwaXsh_JPO-en7QcOLcAvjA>
    <xmx:pe4kYei3OKiiiMCA2TPuLDoRpSdMJeqW3n12Fgobj_ttSsNd4SRZww>
    <xmx:p-4kYUvpKqMHAGUePrx1ec7fVnd3JZ2f-OgzbYTcWIoOLmPOvQL9Ig>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:05:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v3 2/6] ethtool: Add ability to control transceiver modules' power mode
Date:   Tue, 24 Aug 2021 16:05:11 +0300
Message-Id: <20210824130515.1828270-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130515.1828270-1-idosch@idosch.org>
References: <20210824130515.1828270-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add ability to control transceiver modules' power mode over netlink.

Example output and usage:

 # ip link set dev swp11 up

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy high
 power-mode high

 $ ethtool --json --show-module swp11
 [ {
        "ifname": "swp11",
        "power-mode-policy": "high",
        "power-mode": "high"
    } ]

 # ethtool --set-module swp11 power-mode-policy auto

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy auto
 power-mode high

 # ethtool --set-module swp11 power-mode-policy auto

 # ethtool --set-module swp11 power-mode-policy high

Despite three set commands, only two notifications were emitted, as the
kernel only emits notifications when an attribute changes:

 $ ethtool --monitor
 listening...

 Module parameters for swp11:
 power-mode-policy auto
 power-mode high

 Module parameters for swp11:
 power-mode-policy high
 power-mode high

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Makefile.am                   |   2 +-
 ethtool.8.in                  |  25 +++++
 ethtool.c                     |  11 +++
 netlink/desc-ethtool.c        |  11 +++
 netlink/extapi.h              |   4 +
 netlink/module.c              | 179 ++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |   4 +
 netlink/netlink.h             |   1 +
 shell-completion/bash/ethtool |  23 +++++
 9 files changed, 259 insertions(+), 1 deletion(-)
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
index f83d6d17ae41..0d0805bd0d3a 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -475,6 +475,14 @@ ethtool \- query or control network driver and hardware settings
 .HP
 .B ethtool \-\-show\-tunnels
 .I devname
+.HP
+.B ethtool \-\-show\-module
+.I devname
+.HP
+.B ethtool \-\-set\-module
+.I devname
+.RB [ power\-mode\-policy
+.BR high | auto ]
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1458,6 +1466,23 @@ Show tunnel-related device capabilities and state.
 List UDP ports kernel has programmed the device to parse as VxLAN,
 or GENEVE tunnels.
 .RE
+.TP
+.B \-\-show\-module
+Show the transceiver module's parameters.
+.RE
+.TP
+.B \-\-set\-module
+Set the transceiver module's parameters.
+.RS 4
+.TP
+.A3 power-mode-policy high auto
+Set the power mode policy for the module. When set to \fBhigh\fR, the module
+always operates at high power mode. When set to \fBauto\fR, the module is
+transitioned by the host to high power mode when the first port using it is put
+administratively up and to low power mode when the last port using it is put
+administratively down. The power mode policy can be set before a module is
+plugged-in.
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
diff --git a/ethtool.c b/ethtool.c
index 33a0a492cb15..f3b6cb9484e9 100644
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
+		.xhelp	= "		[ power-mode-policy high|auto ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index d6fc4e2d03df..721c8a393c85 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -374,6 +374,13 @@ const struct pretty_nla_desc __module_eeprom_desc[] = {
 	NLATTR_DESC_BINARY(ETHTOOL_A_MODULE_EEPROM_DATA)
 };
 
+static const struct pretty_nla_desc __module_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_MODULE_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MODULE_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_MODULE_POWER_MODE_POLICY),
+	NLATTR_DESC_U8(ETHTOOL_A_MODULE_POWER_MODE),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -408,6 +415,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_FEC_SET, fec),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET, stats),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET, module_eeprom),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET, module),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -447,6 +456,8 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
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
index 000000000000..a614b7fe0718
--- /dev/null
+++ b/netlink/module.c
@@ -0,0 +1,179 @@
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
+static const char *module_power_mode_policy_name(u8 val)
+{
+	switch (val) {
+	case ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH:
+		return "high";
+	case ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO:
+		return "auto";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *module_power_mode_name(u8 val)
+{
+	switch (val) {
+	case ETHTOOL_MODULE_POWER_MODE_LOW:
+		return "low";
+	case ETHTOOL_MODULE_POWER_MODE_HIGH:
+		return "high";
+	default:
+		return "unknown";
+	}
+}
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
+	if (tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]) {
+		u8 val;
+
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
+		print_string(PRINT_ANY, "power-mode-policy",
+			     "power-mode-policy %s\n",
+			     module_power_mode_policy_name(val));
+	}
+
+	if (tb[ETHTOOL_A_MODULE_POWER_MODE]) {
+		u8 val;
+
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE]);
+		print_string(PRINT_ANY, "power-mode",
+			     "power-mode %s\n", module_power_mode_name(val));
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
+static const struct lookup_entry_u8 power_mode_policy_values[] = {
+	{ .arg = "high",	.val = ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH },
+	{ .arg = "auto",	.val = ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO },
+	{}
+};
+
+static const struct param_parser smodule_params[] = {
+	{
+		.arg		= "power-mode-policy",
+		.type		= ETHTOOL_A_MODULE_POWER_MODE_POLICY,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= power_mode_policy_values,
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
index 45573413985d..46334b525e2b 100644
--- a/shell-completion/bash/ethtool
+++ b/shell-completion/bash/ethtool
@@ -1137,6 +1137,27 @@ _ethtool_test()
 	fi
 }
 
+# Completion for ethtool --set-module
+_ethtool_set_module()
+{
+	local -A settings=(
+		[power-mode-policy]=1
+	)
+
+	case "$prev" in
+		power-mode-policy)
+			COMPREPLY=( $( compgen -W 'high auto' -- "$cur" ) )
+			return ;;
+	esac
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
@@ -1189,6 +1210,8 @@ _ethtool()
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

