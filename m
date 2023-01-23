Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AD5678987
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 22:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjAWV1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 16:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjAWV1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 16:27:06 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22FB33469
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 13:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674509224; x=1706045224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B8y48vT0br15CK03lZjaPU0FIFbvJLrca3fzAH8FREY=;
  b=W5KN/QJvfkps3VKNEIyEsV+liW6DP15InlBgd/nDCLr2nQK0vosgBVxm
   GH/2SxzsVSnyuEFt2RH6Jd9LrwcufZmBVK+7nOAsW4NvsVeEox4ZX0tM2
   R/k3A7Z1BsqquFPnYFYHrcFu/dJYWpzdAf8qB8lM9lDw4Asf0poAeFjgs
   STBaC7FO2yXvuL4FjqRrAJVePwDQ3VAfcLSdaQosPurYTnHFFthE00L3c
   7nEBIqjvlX35PPi/zmTpMJfz+eROvvdIjb62x2AH2+aD4xvx1PlzbINQC
   M4421F88zwxxHA4t3IrJwaMTPpLpLPZ9c9EmXxUZGoTyiJVSsp5EpIvhv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="328241883"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="328241883"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2023 13:27:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10599"; a="655173682"
X-IronPort-AV: E=Sophos;i="5.97,240,1669104000"; 
   d="scan'208";a="655173682"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga007.jf.intel.com with ESMTP; 23 Jan 2023 13:27:03 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, mkubecek@suse.cz, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [RESEND PATCH ethtool-next v6 2/2] netlink: add netlink handler for get rss (-x)
Date:   Mon, 23 Jan 2023 13:25:01 -0800
Message-Id: <20230123212501.1471308-3-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230123212501.1471308-1-sudheer.mogilappagari@intel.com>
References: <20230123212501.1471308-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for netlink based "ethtool -x <dev>" command using
ETHTOOL_MSG_RSS_GET netlink message. It implements same functionality
provided by traditional ETHTOOL_GRSSH subcommand. This displays RSS
table, hash key and hash function along with JSON support.

Sample output with json option:
$ethtool --json -x eno2
[ {
    "ifname": "eno2",
    "rss-indirection-table": [ 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,
    ...skip similar lines...
    7,7,7,7,7,7,7,7 ],
    "rss-hash-key": [ 190,195,19,166,..],
    "rss-hash-function": "toeplitz"
    } ]

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 Makefile.am            |   2 +-
 ethtool.c              |   2 +
 netlink/desc-ethtool.c |  11 ++
 netlink/extapi.h       |   2 +
 netlink/rss.c          | 231 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 247 insertions(+), 1 deletion(-)
 create mode 100644 netlink/rss.c

diff --git a/Makefile.am b/Makefile.am
index 663f40a..c3e7401 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -39,7 +39,7 @@ ethtool_SOURCES += \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
 		  netlink/stats.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
-		  netlink/module-eeprom.c netlink/module.c \
+		  netlink/module-eeprom.c netlink/module.c netlink/rss.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
diff --git a/ethtool.c b/ethtool.c
index ea74684..1355995 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5858,7 +5858,9 @@ static const struct option args[] = {
 	},
 	{
 		.opts	= "-x|--show-rxfh-indir|--show-rxfh",
+		.json	= true,
 		.func	= do_grxfh,
+		.nlfunc	= nl_grss,
 		.help	= "Show Rx flow hash indirection table and/or RSS hash key",
 		.xhelp	= "		[ context %d ]\n"
 	},
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index b3ac64d..ed83dae 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -442,6 +442,15 @@ static const struct pretty_nla_desc __pse_desc[] = {
 	NLATTR_DESC_U32_ENUM(ETHTOOL_A_PODL_PSE_PW_D_STATUS, pse_pw_d_status),
 };
 
+static const struct pretty_nla_desc __rss_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_MODULE_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MODULE_HEADER, header),
+	NLATTR_DESC_U32(ETHTOOL_A_RSS_CONTEXT),
+	NLATTR_DESC_U32(ETHTOOL_A_RSS_HFUNC),
+	NLATTR_DESC_BINARY(ETHTOOL_A_RSS_INDIR),
+	NLATTR_DESC_BINARY(ETHTOOL_A_RSS_HKEY),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -481,6 +490,7 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_GET, pse),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_SET, pse),
+	NLMSG_DESC(ETHTOOL_MSG_RSS_GET, rss),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -524,6 +534,7 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET_REPLY, module),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_NTF, module),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_GET_REPLY, pse),
+	NLMSG_DESC(ETHTOOL_MSG_RSS_GET_REPLY, rss),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 1bb580a..9b6dd1a 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -47,6 +47,7 @@ int nl_gmodule(struct cmd_context *ctx);
 int nl_smodule(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
+int nl_grss(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -114,6 +115,7 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_getmodule		NULL
 #define nl_gmodule		NULL
 #define nl_smodule		NULL
+#define nl_grss			NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/rss.c b/netlink/rss.c
new file mode 100644
index 0000000..afeeb7f
--- /dev/null
+++ b/netlink/rss.c
@@ -0,0 +1,231 @@
+/*
+ * rss.c - netlink implementation of RSS context commands
+ *
+ * Implementation of "ethtool -x <dev>"
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "strset.h"
+#include "parser.h"
+
+struct cb_args {
+	struct nl_context	*nlctx;
+	u32			num_rings;
+};
+
+void dump_json_rss_info(struct cmd_context *ctx, u32 *indir_table,
+			u32 indir_size, u8 *hkey, u32 hkey_size,
+			const struct stringset *hash_funcs, u8 hfunc)
+{
+	unsigned int i;
+
+	open_json_object(NULL);
+	print_string(PRINT_JSON, "ifname", NULL, ctx->devname);
+	if (indir_size) {
+		open_json_array("rss-indirection-table", NULL);
+		for (i = 0; i < indir_size; i++)
+			print_uint(PRINT_JSON, NULL, NULL, indir_table[i]);
+		close_json_array("\n");
+	}
+
+	if (hkey_size) {
+		open_json_array("rss-hash-key", NULL);
+		for (i = 0; i < hkey_size; i++)
+			print_uint(PRINT_JSON, NULL, NULL, (u8)hkey[i]);
+		close_json_array("\n");
+	}
+
+	if (hfunc) {
+		for (i = 0; i < get_count(hash_funcs); i++) {
+			if (hfunc & (1 << i)) {
+				print_string(PRINT_JSON, "rss-hash-function",
+					     NULL, get_string(hash_funcs, i));
+				break;
+			}
+		}
+	}
+
+	close_json_object();
+}
+
+int get_channels_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_CHANNELS_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct cb_args *args = data;
+	struct nl_context *nlctx = args->nlctx;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_CHANNELS_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+	if (tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT])
+		args->num_rings = mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT]);
+	if (tb[ETHTOOL_A_CHANNELS_RX_COUNT])
+		args->num_rings += mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_RX_COUNT]);
+	return MNL_CB_OK;
+}
+
+int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_RSS_MAX + 1] = {};
+	unsigned int indir_bytes = 0, hkey_bytes = 0;
+	DECLARE_ATTR_TB_INFO(tb);
+	struct cb_args *args = data;
+	struct nl_context *nlctx = args->nlctx;
+	const struct stringset *hash_funcs;
+	u32 rss_hfunc = 0, indir_size;
+	u32 *indir_table = NULL;
+	u8 *hkey = NULL;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_RSS_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	show_cr();
+
+	if (tb[ETHTOOL_A_RSS_HFUNC])
+		rss_hfunc = mnl_attr_get_u32(tb[ETHTOOL_A_RSS_HFUNC]);
+
+	if (tb[ETHTOOL_A_RSS_INDIR]) {
+		indir_bytes = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_INDIR]);
+		indir_table = mnl_attr_get_payload(tb[ETHTOOL_A_RSS_INDIR]);
+	}
+
+	if (tb[ETHTOOL_A_RSS_HKEY]) {
+		hkey_bytes = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_HKEY]);
+		hkey = mnl_attr_get_payload(tb[ETHTOOL_A_RSS_HKEY]);
+	}
+
+	/* Fetch RSS hash functions and their status and print */
+	if (!nlctx->is_monitor) {
+		ret = netlink_init_ethnl2_socket(nlctx);
+		if (ret < 0)
+			return MNL_CB_ERROR;
+	}
+	hash_funcs = global_stringset(ETH_SS_RSS_HASH_FUNCS,
+				      nlctx->ethnl2_socket);
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return silent ? MNL_CB_OK : MNL_CB_ERROR;
+
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_RSS_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	/* Fetch ring count info into args->num_rings */
+	ret = nlsock_prep_get_request(nlctx->ethnl2_socket,
+				      ETHTOOL_MSG_CHANNELS_GET,
+				      ETHTOOL_A_CHANNELS_HEADER, 0);
+	if (ret < 0)
+		return MNL_CB_ERROR;
+
+	ret = nlsock_sendmsg(nlctx->ethnl2_socket, NULL);
+	if (ret < 0)
+		return MNL_CB_ERROR;
+
+	ret = nlsock_process_reply(nlctx->ethnl2_socket, get_channels_cb, args);
+	if (ret < 0)
+		return MNL_CB_ERROR;
+
+	indir_size = indir_bytes / sizeof(u32);
+	if (is_json_context()) {
+		dump_json_rss_info(nlctx->ctx, (u32 *)indir_table, indir_size,
+				   hkey, hkey_bytes, hash_funcs, rss_hfunc);
+	} else {
+		print_indir_table(nlctx->ctx, args->num_rings,
+				  indir_size, (u32 *)indir_table);
+		print_rss_hkey(hkey, hkey_bytes);
+		printf("RSS hash function:\n");
+		if (!rss_hfunc) {
+			printf("    Operation not supported\n");
+			return 0;
+		}
+		for (unsigned int i = 0; i < get_count(hash_funcs); i++) {
+			printf("    %s: %s\n", get_string(hash_funcs, i),
+			       (rss_hfunc & (1 << i)) ? "on" : "off");
+		}
+	}
+
+	return MNL_CB_OK;
+}
+
+/* RSS_GET */
+static const struct param_parser grss_params[] = {
+	{
+		.arg		= "context",
+		.type		= ETHTOOL_A_RSS_CONTEXT,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_grss(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	struct nl_msg_buff *msgbuff;
+	struct cb_args args = {};
+	int ret;
+
+	nlctx->cmd = "-x";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_RSS_GET, true))
+		return -EOPNOTSUPP;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_RSS_GET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 1;
+
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_RSS_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, grss_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		goto err;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		goto err;
+
+	args.nlctx = nlctx;
+	new_json_obj(ctx->json);
+	ret = nlsock_process_reply(nlsk, rss_reply_cb, &args);
+	delete_json_obj();
+
+	if (ret == 0)
+		return 0;
+err:
+	return nlctx->exit_code ?: 1;
+}
+
-- 
2.31.1

