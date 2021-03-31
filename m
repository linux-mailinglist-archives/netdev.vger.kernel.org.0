Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAA334DFD8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhC3ECN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231196AbhC3EB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FCD161988;
        Tue, 30 Mar 2021 04:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617076917;
        bh=iIPPKGY4sqkL6OlRUL9tOodRurxYcrbsY6xdumUhmmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwNQb8kcbGQ0xVEZ6F5RBmpgr19NZRMrIdovYzKFife5lXbH8NGPiTu+ZfuiVtZW9
         dyyv7Hpw1CRTfdC72wB6Ed/38uDvvJE/4YKtQgUBvem54PhLe5RK7j/pggRJAWWWmn
         JOFZytnwKo+H9F0sJ8BRU0TsHjC9iGx08E4jy38O4TnXG6km7ptA5bqa3shaafW/D9
         jxeIVKEhtJhKxnxjx4yemB6mqkfzNRniQIPdy9jUB2knob29Cz2vdjUkuR4+qI6Mnf
         dsyANdQV6MAXMX7PwNz6BU94A1h2aR6tU2OFuNdyMvRS0Ps4czQACgSJt+yo9BRWDz
         Cttaxhb5OFGQA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC ethtool-next 3/3] netlink: add FEC support
Date:   Mon, 29 Mar 2021 21:01:54 -0700
Message-Id: <20210330040154.1218028-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330040154.1218028-1-kuba@kernel.org>
References: <20210330040154.1218028-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for FEC get/set over netlink.

Output should be identical but for ordering of RS vs BaseR.
Since the new output is based on link modes RS comes before
BaseR in "Configured FEC encodings". Seems pretty unlikely
someone depends on the ordering there.

Since old API was case insensitive we need to carefully
manage the bit names. Luckily for now most of the modes
are all uppercase.

Beyond that we need to cover up the discrepancy between
the meanings of None and Off. Kernel API uses the link
mode definition, but ethtool needs to maintain the old
interpretation of None meaning "not supported".

Because of those deviations existing link mode parsers
can't be directly reused.

Allocate error code 83 for FEC errors.

JSON support included.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Makefile.am            |   2 +-
 ethtool.c              |   2 +
 netlink/desc-ethtool.c |  12 ++
 netlink/extapi.h       |   4 +
 netlink/fec.c          | 273 +++++++++++++++++++++++++++++++++++++++++
 netlink/monitor.c      |   4 +
 netlink/netlink.h      |   1 +
 7 files changed, 297 insertions(+), 1 deletion(-)
 create mode 100644 netlink/fec.c

diff --git a/Makefile.am b/Makefile.am
index e3e311d4b274..f643a24af97a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -35,7 +35,7 @@ ethtool_SOURCES += \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
-		  netlink/eee.c netlink/tsinfo.c \
+		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index fb90e9e456b9..0933bc02ce5e 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5963,11 +5963,13 @@ static const struct option args[] = {
 	{
 		.opts	= "--show-fec",
 		.func	= do_gfec,
+		.nlfunc	= nl_gfec,
 		.help	= "Show FEC settings",
 	},
 	{
 		.opts	= "--set-fec",
 		.func	= do_sfec,
+		.nlfunc	= nl_sfec,
 		.help	= "Set FEC settings",
 		.xhelp	= "		[ encoding auto|off|rs|baser|llrs [...]]\n"
 	},
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 96291b9bdd3b..9da052a5b8aa 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -317,6 +317,14 @@ const struct pretty_nla_desc __tunnel_info_desc[] = {
 	NLATTR_DESC_NESTED(ETHTOOL_A_TUNNEL_INFO_UDP_PORTS, tunnel_udp),
 };
 
+static const struct pretty_nla_desc __fec_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_FEC_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_FEC_HEADER, header),
+	NLATTR_DESC_NESTED(ETHTOOL_A_FEC_MODES, bitset),
+	NLATTR_DESC_BOOL(ETHTOOL_A_FEC_AUTO),
+	NLATTR_DESC_U32(ETHTOOL_A_FEC_ACTIVE),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -347,6 +355,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_ACT, cable_test),
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_TDR_ACT, cable_test_tdr),
 	NLMSG_DESC(ETHTOOL_MSG_TUNNEL_INFO_GET, tunnel_info),
+	NLMSG_DESC(ETHTOOL_MSG_FEC_GET, fec),
+	NLMSG_DESC(ETHTOOL_MSG_FEC_SET, fec),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -382,6 +392,8 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_NTF, cable_test_ntf),
 	NLMSG_DESC(ETHTOOL_MSG_CABLE_TEST_TDR_NTF, cable_test_tdr_ntf),
 	NLMSG_DESC(ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY, tunnel_info),
+	NLMSG_DESC(ETHTOOL_MSG_FEC_GET_REPLY, fec),
+	NLMSG_DESC(ETHTOOL_MSG_FEC_NTF, fec),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 761cafb97855..5cadacce08e8 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -38,6 +38,8 @@ int nl_tsinfo(struct cmd_context *ctx);
 int nl_cable_test(struct cmd_context *ctx);
 int nl_cable_test_tdr(struct cmd_context *ctx);
 int nl_gtunnels(struct cmd_context *ctx);
+int nl_gfec(struct cmd_context *ctx);
+int nl_sfec(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -87,6 +89,8 @@ static inline void nl_monitor_usage(void)
 #define nl_cable_test		NULL
 #define nl_cable_test_tdr	NULL
 #define nl_gtunnels		NULL
+#define nl_gfec			NULL
+#define nl_sfec			NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/fec.c b/netlink/fec.c
new file mode 100644
index 000000000000..9d15832db98a
--- /dev/null
+++ b/netlink/fec.c
@@ -0,0 +1,273 @@
+/*
+ * fec.c - netlink implementation of FEC commands
+ *
+ * Implementation of "ethtool --show-fec <dev>" and
+ * "ethtool --set-fec <dev> ..."
+ */
+
+#include <errno.h>
+#include <ctype.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "bitset.h"
+#include "parser.h"
+
+/* FEC_GET */
+
+static void
+fec_mode_walk(unsigned int idx, const char *name, bool val, void *data)
+{
+	bool *empty = data;
+
+	if (!val)
+		return;
+	if (empty)
+		*empty = false;
+
+	/* Rename None to Off - in legacy ioctl None means "not supported"
+	 * rather than supported but disabled.
+	 */
+	if (idx == ETHTOOL_LINK_MODE_FEC_NONE_BIT)
+		name = "Off";
+	/* Rename to match the ioctl letter case */
+	else if (idx == ETHTOOL_LINK_MODE_FEC_BASER_BIT)
+		name = "BaseR";
+
+	print_string(PRINT_ANY, NULL, " %s", name);
+}
+
+int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_FEC_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	const struct stringset *lm_strings;
+	const char *name;
+	bool fa, empty;
+	bool silent;
+	int err_ret;
+	u32 active;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_FEC_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	ret = netlink_init_ethnl2_socket(nlctx);
+	if (ret < 0)
+		return err_ret;
+	lm_strings = global_stringset(ETH_SS_LINK_MODES, nlctx->ethnl2_socket);
+
+	active = 0;
+	if (tb[ETHTOOL_A_FEC_ACTIVE])
+		active = mnl_attr_get_u32(tb[ETHTOOL_A_FEC_ACTIVE]);
+
+	if (silent)
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "FEC parameters for %s:\n",
+		     nlctx->devname);
+
+	open_json_array("config", "Configured FEC encodings:");
+	fa = tb[ETHTOOL_A_FEC_AUTO] && mnl_attr_get_u8(tb[ETHTOOL_A_FEC_AUTO]);
+	if (fa)
+		print_string(PRINT_ANY, NULL, " %s", "Auto");
+	empty = !fa;
+
+	ret = walk_bitset(tb[ETHTOOL_A_FEC_MODES], lm_strings, fec_mode_walk,
+			  &empty);
+	if (ret < 0)
+		goto err_close_dev;
+	if (empty)
+		print_string(PRINT_ANY, NULL, " %s", "None");
+	close_json_array("\n");
+
+	open_json_array("active", "Active FEC encoding:");
+	if (active) {
+		name = get_string(lm_strings, active);
+		if (name)
+			/* Take care of renames */
+			fec_mode_walk(active, name, true, NULL);
+		else
+			print_uint(PRINT_ANY, NULL, " BIT%u", active);
+	} else {
+		print_string(PRINT_ANY, NULL, " %s", "None");
+	}
+	close_json_array("\n");
+
+	close_json_object();
+
+	return MNL_CB_OK;
+
+err_close_dev:
+	close_json_object();
+	return err_ret;
+}
+
+int nl_gfec(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_FEC_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_FEC_GET,
+				      ETHTOOL_A_FEC_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, fec_reply_cb);
+	delete_json_obj();
+	return ret;
+}
+
+/* FEC_SET */
+
+static void strupc(char *dst, const char *src)
+{
+	while (*src)
+		*dst++ = toupper(*src++);
+	*dst = '\0';
+}
+
+static int fec_parse_bitset(struct nl_context *nlctx, uint16_t type,
+			    const void *data __maybe_unused,
+			    struct nl_msg_buff *msgbuff, void *dest)
+{
+	struct nlattr *bitset_attr;
+	struct nlattr *bits_attr;
+	struct nlattr *bit_attr;
+	char upper[ETH_GSTRING_LEN];
+	bool fec_auto = false;
+	int ret;
+
+	if (!type || dest) {
+		fprintf(stderr, "ethtool (%s): internal error parsing '%s'\n",
+			nlctx->cmd, nlctx->param);
+		return -EFAULT;
+	}
+
+	bitset_attr = ethnla_nest_start(msgbuff, type);
+	if (!bitset_attr)
+		return -EMSGSIZE;
+	ret = -EMSGSIZE;
+	if (ethnla_put_flag(msgbuff, ETHTOOL_A_BITSET_NOMASK, true))
+		goto err;
+	bits_attr = ethnla_nest_start(msgbuff, ETHTOOL_A_BITSET_BITS);
+	if (!bits_attr)
+		goto err;
+
+	while (nlctx->argc > 0) {
+		const char *name = *nlctx->argp;
+
+		if (!strcmp(name, "--"))
+			goto next;
+
+		if (!strcasecmp(name, "auto")) {
+			fec_auto = true;
+			goto next;
+		}
+		if (!strcasecmp(name, "off")) {
+			name = "None";
+		} else {
+			strupc(upper, name);
+			name = upper;
+		}
+
+		ret = -EMSGSIZE;
+		bit_attr = ethnla_nest_start(msgbuff,
+					     ETHTOOL_A_BITSET_BITS_BIT);
+		if (!bit_attr)
+			goto err;
+		if (ethnla_put_strz(msgbuff, ETHTOOL_A_BITSET_BIT_NAME, name))
+			goto err;
+		ethnla_nest_end(msgbuff, bit_attr);
+
+next:
+		nlctx->argp++;
+		nlctx->argc--;
+	}
+
+	ethnla_nest_end(msgbuff, bits_attr);
+	ethnla_nest_end(msgbuff, bitset_attr);
+
+	if (ethnla_put_u8(msgbuff, ETHTOOL_A_FEC_AUTO, fec_auto))
+		goto err;
+
+	return 0;
+err:
+	ethnla_nest_cancel(msgbuff, bitset_attr);
+	return ret;
+}
+
+static const struct param_parser sfec_params[] = {
+	{
+		.arg		= "encoding",
+		.type		= ETHTOOL_A_FEC_MODES,
+		.handler	= fec_parse_bitset,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_sfec(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_FEC_SET, false))
+		return -EOPNOTSUPP;
+	if (!ctx->argc) {
+		fprintf(stderr, "ethtool (--set-fec): parameters missing\n");
+		return 1;
+	}
+
+	nlctx->cmd = "--set-fec";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_FEC_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_FEC_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, sfec_params, NULL, PARSER_GROUP_NONE, NULL);
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
index 19f991fce3e4..0c4df9e78ee3 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -67,6 +67,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 		.cb	= cable_test_tdr_ntf_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_FEC_NTF,
+		.cb	= fec_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index c02558540218..70fa666b20e5 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -90,6 +90,7 @@ int cable_test_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
+int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
-- 
2.30.2

