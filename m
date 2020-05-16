Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D9C1D5DAA
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEPBan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:30:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:39711 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgEPBal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 21:30:41 -0400
IronPort-SDR: NOxA6U8/mcDf+VkL2mkZxFc07Rg/plyUhGgNdZGNkjh1ttJdm08wfE7za0488+5zfgBRbpShwy
 AUl/6jq/fRpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 18:30:38 -0700
IronPort-SDR: pYRlnV7gYaqcCADMRRd1wvqPRV+JwcXW4tvkCe2o0mzC73SogrHkxbf9i1N0i7YlILAEkseNWk
 hJ9RUQEDEMLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,397,1583222400"; 
   d="scan'208";a="307569388"
Received: from wkbertra-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.131.129])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 18:30:38 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, linville@tuxdriver.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: [ethtool RFC 3/3] ethtool: Add support for configuring frame preemption via netlink
Date:   Fri, 15 May 2020 18:30:26 -0700
Message-Id: <20200516013026.3174098-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516013026.3174098-1-vinicius.gomes@intel.com>
References: <20200516013026.3174098-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the same functionality of the ETHTOOL_{G,S}FP commands, now via
the ETHTOOL_MSG_PREEMPT_{GET,SET} netlink messages.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 Makefile.am            |   2 +-
 ethtool.c              |   2 +
 netlink/desc-ethtool.c |  13 ++++
 netlink/extapi.h       |   4 ++
 netlink/preempt.c      | 148 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 168 insertions(+), 1 deletion(-)
 create mode 100644 netlink/preempt.c

diff --git a/Makefile.am b/Makefile.am
index 0f8465f..3b88533 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -32,7 +32,7 @@ ethtool_SOURCES += \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
-		  netlink/desc-rtnl.c \
+		  netlink/desc-rtnl.c netlink/preempt.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/ethtool.c b/ethtool.c
index 4c69d1c..3acdd54 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5587,11 +5587,13 @@ static const struct option args[] = {
 	{
 		.opts	= "--show-frame-preemption",
 		.func	= do_get_preempt,
+		.nlfunc	= nl_get_preempt,
 		.help	= "Show Frame Preemption settings",
 	},
 	{
 		.opts	= "--set-frame-preemption",
 		.func	= do_set_preempt,
+		.nlfunc	= nl_set_preempt,
 		.help	= "Set Frame Preemption settings",
 		.xhelp	= "		[ fp on|off ]\n"
 			  "		[ preemptible-queues-mask %x ]\n"
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 76c6f13..f82afd2 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -106,6 +106,17 @@ static const struct pretty_nla_desc __wol_desc[] = {
 	NLATTR_DESC_BINARY(ETHTOOL_A_WOL_SOPASS),
 };
 
+static const struct pretty_nla_desc __preempt_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_PREEMPT_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_PREEMPT_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_PREEMPT_SUPPORTED),
+	NLATTR_DESC_U8(ETHTOOL_A_PREEMPT_ACTIVE),
+	NLATTR_DESC_U32(ETHTOOL_A_PREEMPT_QUEUES_SUPPORTED),
+	NLATTR_DESC_U32(ETHTOOL_A_PREEMPT_QUEUES_PREEMPTIBLE),
+	NLATTR_DESC_U32(ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE),
+	NLATTR_DESC_BINARY(ETHTOOL_A_WOL_SOPASS),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -118,6 +129,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_DEBUG_SET, debug),
 	NLMSG_DESC(ETHTOOL_MSG_WOL_GET, wol),
 	NLMSG_DESC(ETHTOOL_MSG_WOL_SET, wol),
+	NLMSG_DESC(ETHTOOL_MSG_PREEMPT_GET, preempt),
+	NLMSG_DESC(ETHTOOL_MSG_PREEMPT_SET, preempt),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 9484b4c..2436f70 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -21,6 +21,8 @@ int nl_gset(struct cmd_context *ctx);
 int nl_sset(struct cmd_context *ctx);
 int nl_permaddr(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
+int nl_get_preempt(struct cmd_context *ctx);
+int nl_set_preempt(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -44,6 +46,8 @@ static inline void nl_monitor_usage(void)
 #define nl_gset			NULL
 #define nl_sset			NULL
 #define nl_permaddr		NULL
+#define nl_get_preempt		NULL
+#define nl_set_preempt		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/preempt.c b/netlink/preempt.c
new file mode 100644
index 0000000..976ae39
--- /dev/null
+++ b/netlink/preempt.c
@@ -0,0 +1,148 @@
+/*
+ * preempt.c - netlink implementation of frame preemption settings
+ *
+ * Implementation of "ethtool --{show,set}-frame-preemption <dev>"
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_link.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "parser.h"
+
+/* PREEMPT_GET */
+
+static int preempt_get_prep_request(struct nl_socket *nlsk)
+{
+	int ret;
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PREEMPT_GET,
+				      ETHTOOL_A_PREEMPT_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int preempt_get_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PREEMPT_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PREEMPT_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	printf("Frame preemption settings for %s:\n", nlctx->devname);
+
+	if (tb[ETHTOOL_A_PREEMPT_SUPPORTED]) {
+		int supported = mnl_attr_get_u8(
+			tb[ETHTOOL_A_PREEMPT_SUPPORTED]);
+
+		printf("\tsupport: %s\n",
+		       supported ? "supported" : "not supported");
+	}
+	if (tb[ETHTOOL_A_PREEMPT_ACTIVE]) {
+		int active = mnl_attr_get_u8(tb[ETHTOOL_A_PREEMPT_ACTIVE]);
+
+		printf("\tactive: %s\n", active ? "active" : "not active");
+	}
+	if (tb[ETHTOOL_A_PREEMPT_QUEUES_SUPPORTED]) {
+		uint32_t queues = mnl_attr_get_u32(
+			tb[ETHTOOL_A_PREEMPT_QUEUES_SUPPORTED]);
+
+		printf("\tsupported queues: %#x\n", queues);
+
+	}
+	if (tb[ETHTOOL_A_PREEMPT_QUEUES_PREEMPTIBLE]) {
+		uint32_t queues = mnl_attr_get_u32(
+			tb[ETHTOOL_A_PREEMPT_QUEUES_PREEMPTIBLE]);
+
+		printf("\tsupported queues: %#x\n", queues);
+
+	}
+	if (tb[ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE]) {
+		uint32_t min_frag_size = mnl_attr_get_u32(
+			tb[ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE]);
+
+		printf("\tminimum fragment size: %d\n", min_frag_size);
+	}
+	return MNL_CB_OK;
+}
+
+int nl_get_preempt(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	ret = preempt_get_prep_request(nlsk);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, preempt_get_reply_cb);
+}
+
+static const struct lookup_entry_u8 fp_values[] = {
+	{ .arg = "off",		.val = 0 },
+	{ .arg = "on",		.val = 1 },
+	{}
+};
+
+static const struct param_parser set_preempt_params[] = {
+	{
+		.arg		= "fp",
+		.group		= ETHTOOL_MSG_PREEMPT_SET,
+		.type		= ETHTOOL_A_PREEMPT_ACTIVE,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= fp_values,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "preemptible-queues-mask",
+		.group		= ETHTOOL_MSG_PREEMPT_SET,
+		.type		= ETHTOOL_A_PREEMPT_QUEUES_PREEMPTIBLE,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "min-frag-size",
+		.group		= ETHTOOL_MSG_PREEMPT_SET,
+		.type		= ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_set_preempt(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	int ret;
+
+	nlctx->cmd = "--set-frame-preemption";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+
+	ret = nl_parser(nlctx, set_preempt_params, NULL, PARSER_GROUP_MSG);
+	if (ret < 0)
+		return 1;
+
+	if (ret == 0)
+		return 0;
+	return nlctx->exit_code ?: 75;
+}
-- 
2.26.2

