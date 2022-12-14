Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB1B64D453
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiLOAGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiLOAFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 19:05:31 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19F36B991
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671062297; x=1702598297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NqUcjvoPCz7Brbj36DpxXqGQWysHjoz5KI1pG/OJr3g=;
  b=dtoziMyh6nt0yPEAypcBqC2oExCcNu8aF9mRB8jE/XjPnUugQe/hP9fx
   /MHXEESJeQmTlHBa6dTewOIE9IZoki0mYkl8+h3qC3FME1bhuje8pYphh
   4AVItf6/f651GFl2bAuQ+kmxymUmd30lPi7QTbYOm7alZpVlOuNVjTNmF
   raUxjhXWx1y9ctsngYm1xRA/0cIQ6HVEpFqRJeTYDxlVXKprNbCGZHpeL
   rEIqzDdaqqQnRl2FXxhSZSPurOhntWdzB+G75JCIS12o6J2cS/flSE7Ou
   yMQpLcwH2OWR5mOXjr3SLbbSf/Txb/Y4vhqwHkwKiz12Frj7tlvczCWUL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="301951809"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="301951809"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 15:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="773503930"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="773503930"
Received: from msu-dell.jf.intel.com ([10.166.233.5])
  by orsmga004.jf.intel.com with ESMTP; 14 Dec 2022 15:57:25 -0800
From:   Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH ethtool-next v1 3/3] netlink: add netlink handler for get rss (-x)
Date:   Wed, 14 Dec 2022 15:54:18 -0800
Message-Id: <20221214235418.1033834-4-sudheer.mogilappagari@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
References: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for netlink based "ethtool -x <dev>" command using
ETHTOOL_MSG_RSS_GET netlink message. It implements same functionality
provided by traditional ETHTOOL_GRSSH subcommand. This displays RSS
table, hash key and hash function.

Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
---
 Makefile.am            |   2 +-
 ethtool.c              |   1 +
 netlink/desc-ethtool.c |  11 +++
 netlink/extapi.h       |   2 +
 netlink/rss.c          | 197 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 212 insertions(+), 1 deletion(-)
 create mode 100644 netlink/rss.c

diff --git a/Makefile.am b/Makefile.am
index fcc912e..4765c3f 100644
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
index 0971074..af57807 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5830,6 +5830,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-x|--show-rxfh-indir|--show-rxfh",
 		.func	= do_grxfh,
+		.nlfunc	= nl_grss,
 		.help	= "Show Rx flow hash indirection table and/or RSS hash key",
 		.xhelp	= "		[ context %d ]\n"
 	},
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 9a6651e..8783afc 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -409,6 +409,15 @@ static const struct pretty_nla_desc __module_desc[] = {
 	NLATTR_DESC_U8(ETHTOOL_A_MODULE_POWER_MODE),
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
@@ -446,6 +455,7 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_PHC_VCLOCKS_GET, phc_vclocks),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET, module),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
+	NLMSG_DESC(ETHTOOL_MSG_RSS_GET, rss),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -488,6 +498,7 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY, phc_vclocks),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET_REPLY, module),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_NTF, module),
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
index 0000000..256f688
--- /dev/null
+++ b/netlink/rss.c
@@ -0,0 +1,197 @@
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
+int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_RSS_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct cb_args *args = data;
+	struct nl_context *nlctx =  args->nlctx;
+	const struct stringset *hash_funcs;
+	u32 rss_config_size, rss_hfunc;
+	const char *rss_config, *hkey;
+	int indir_sz = 0, hkey_sz = 0;
+	struct ethtool_rxfh *rss;
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
+	if (silent)
+		putchar('\n');
+
+	rss_hfunc = mnl_attr_get_u32(tb[ETHTOOL_A_RSS_HFUNC]);
+
+	indir_sz = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_INDIR]);
+	rss_config = mnl_attr_get_str(tb[ETHTOOL_A_RSS_INDIR]);
+
+	hkey_sz = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_HKEY]);
+	hkey = mnl_attr_get_str(tb[ETHTOOL_A_RSS_HKEY]);
+
+	rss_config_size = indir_sz + hkey_sz;
+
+	rss = calloc(1, sizeof(*rss) + rss_config_size);
+	if (!rss) {
+		perror("Cannot allocate memory for RX flow hash config");
+		return 1;
+	}
+
+	rss->indir_size = indir_sz / sizeof(u32);
+	rss->key_size = hkey_sz;
+
+	memcpy(rss->rss_config, rss_config, indir_sz);
+	memcpy(rss->rss_config + rss->indir_size, hkey, hkey_sz);
+
+	print_rss_info(nlctx->ctx, args->num_rings, rss);
+
+	/* Fetch RSS hash functions and their status and print */
+	printf("RSS hash function:\n");
+	if (!rss_hfunc) {
+		printf("    Operation not supported\n");
+		return 0;
+	}
+
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
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_RSS_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	for (unsigned int i = 0; i < get_count(hash_funcs); i++)
+		printf("    %s: %s\n", get_string(hash_funcs, i),
+		       (rss_hfunc & (1 << i)) ? "on" : "off");
+
+	free(rss);
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
+int get_channels_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_CHANNELS_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct cb_args *args = data;
+	struct nl_context *nlctx =  args->nlctx;
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
+
+	args->num_rings = mnl_attr_get_u8(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT]);
+	return MNL_CB_OK;
+}
+
+int nl_grss(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	struct nl_msg_buff *msgbuff;
+	struct cb_args args;
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
+	/* save rings information into args.num_rings */
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_CHANNELS_GET, true))
+		return -EOPNOTSUPP;
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_CHANNELS_GET,
+				      ETHTOOL_A_CHANNELS_HEADER, 0);
+	if (ret < 0)
+		goto err;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		goto err;
+
+	args.nlctx = nlsk->nlctx;
+	ret = nlsock_process_reply(nlsk, get_channels_cb, &args);
+	if (ret < 0)
+		goto err;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_RSS_GET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 1;
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
+	ret = nlsock_process_reply(nlsk, rss_reply_cb, &args);
+	if (ret == 0)
+		return 0;
+
+err:
+	return nlctx->exit_code ?: 1;
+}
+
-- 
2.31.1

