Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E621E7057
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437591AbgE1XW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:49920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437584AbgE1XWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1AA41AFEC;
        Thu, 28 May 2020 23:22:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3AF5FE32D2; Fri, 29 May 2020 01:22:53 +0200 (CEST)
Message-Id: <5137404a0498eba7e64038a766cd8a250b2a5bc6.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 21/21] netlink: add netlink handler for tsinfo (-T)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:53 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -T <dev>" subcommand using ETHTOOL_MSG_TSINFO_GET
netlink message. This retrieves and displays device timestamping
information, traditionally provided by ETHTOOL_GET_TS_INFO ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am      |   2 +-
 ethtool.c        |   1 +
 netlink/extapi.h |   2 +
 netlink/tsinfo.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+), 1 deletion(-)
 create mode 100644 netlink/tsinfo.c

diff --git a/Makefile.am b/Makefile.am
index 95babcdc8eae..63c3fb3ebf90 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -33,7 +33,7 @@ ethtool_SOURCES += \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
-		  netlink/eee.c \
+		  netlink/eee.c netlink/tsinfo.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index 3b81345d7120..3646718d5c2a 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5324,6 +5324,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-T|--show-time-stamping",
 		.func	= do_tsinfo,
+		.nlfunc	= nl_tsinfo,
 		.help	= "Show time stamping capabilities"
 	},
 	{
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 387787f61015..1b39ed999f3d 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -34,6 +34,7 @@ int nl_gpause(struct cmd_context *ctx);
 int nl_spause(struct cmd_context *ctx);
 int nl_geee(struct cmd_context *ctx);
 int nl_seee(struct cmd_context *ctx);
+int nl_tsinfo(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -72,6 +73,7 @@ static inline void nl_monitor_usage(void)
 #define nl_spause		NULL
 #define nl_geee			NULL
 #define nl_seee			NULL
+#define nl_tsinfo		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/tsinfo.c b/netlink/tsinfo.c
new file mode 100644
index 000000000000..03ce91cd4314
--- /dev/null
+++ b/netlink/tsinfo.c
@@ -0,0 +1,124 @@
+/*
+ * tsinfo.c - netlink implementation of timestamping commands
+ *
+ * Implementation of "ethtool -T <dev>"
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "bitset.h"
+
+/* TSINFO_GET */
+
+static void tsinfo_dump_cb(unsigned int idx, const char *name, bool val,
+			   void *data)
+{
+	if (!val)
+		return;
+
+	if (name)
+		printf("\t%s\n", name);
+	else
+		printf("\tbit%u\n", idx);
+}
+
+static int tsinfo_dump_list(struct nl_context *nlctx, const struct nlattr *attr,
+			    const char *label, const char *if_empty,
+			    unsigned int stringset_id)
+{
+	const struct stringset *strings = NULL;
+	int ret;
+
+	printf("%s:", label);
+	ret = 0;
+	if (!attr || bitset_is_empty(attr, false, &ret)) {
+		printf("%s\n", if_empty);
+		return ret;
+	}
+	putchar('\n');
+	if (ret < 0)
+		return ret;
+
+	if (bitset_is_compact(attr)) {
+		ret = netlink_init_ethnl2_socket(nlctx);
+		if (ret < 0)
+			return ret;
+		strings = global_stringset(stringset_id, nlctx->ethnl2_socket);
+	}
+	return walk_bitset(attr, strings, tsinfo_dump_cb, NULL);
+}
+
+int tsinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_TSINFO_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_TSINFO_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+	printf("Time stamping parameters for %s:\n", nlctx->devname);
+
+	ret = tsinfo_dump_list(nlctx, tb[ETHTOOL_A_TSINFO_TIMESTAMPING],
+			       "Capabilities", "", ETH_SS_SOF_TIMESTAMPING);
+	if (ret < 0)
+		return err_ret;
+
+	printf("PTP Hardware Clock: ");
+	if (tb[ETHTOOL_A_TSINFO_PHC_INDEX])
+		printf("%d\n",
+		       mnl_attr_get_u32(tb[ETHTOOL_A_TSINFO_PHC_INDEX]));
+	else
+		printf("none\n");
+
+	ret = tsinfo_dump_list(nlctx, tb[ETHTOOL_A_TSINFO_TX_TYPES],
+			       "Hardware Transmit Timestamp Modes", " none",
+			       ETH_SS_TS_TX_TYPES);
+	if (ret < 0)
+		return err_ret;
+
+	ret = tsinfo_dump_list(nlctx, tb[ETHTOOL_A_TSINFO_RX_FILTERS],
+			       "Hardware Receive Filter Modes", " none",
+			       ETH_SS_TS_RX_FILTERS);
+	if (ret < 0)
+		return err_ret;
+
+	return MNL_CB_OK;
+}
+
+int nl_tsinfo(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_TSINFO_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_TSINFO_GET,
+				      ETHTOOL_A_TSINFO_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, tsinfo_reply_cb);
+}
-- 
2.26.2

