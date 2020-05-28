Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58AA1E704E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437547AbgE1XWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:49488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437531AbgE1XWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C7890AFF8;
        Thu, 28 May 2020 23:22:02 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E8C76E32D2; Fri, 29 May 2020 01:22:02 +0200 (CEST)
Message-Id: <6b8630102193ca84c9fcbde17b604aa22f9b14a3.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 11/21] netlink: add netlink handler for gring (-g)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:02 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -g <dev>" subcommand using ETHTOOL_MSG_RINGS_GET netlink
message. This retrieves and displays device ring sizes, traditionally
provided by ETHTOOL_GRINGPARAM ioctl request.

Also register the callback with monitor code so that the monitor can
display ETHTOOL_MSG_RINGS_NTF notifications.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |  2 +-
 ethtool.c         |  1 +
 netlink/extapi.h  |  2 ++
 netlink/monitor.c |  8 ++++++
 netlink/netlink.h | 13 +++++++++
 netlink/rings.c   | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 netlink/rings.c

diff --git a/Makefile.am b/Makefile.am
index 0a4c4e810c1c..f7d7b44a438d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,7 +31,7 @@ ethtool_SOURCES += \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
-		  netlink/features.c netlink/privflags.c \
+		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index 81472ad40a5b..fc3fb11a6a19 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5199,6 +5199,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-g|--show-ring",
 		.func	= do_gring,
+		.nlfunc	= nl_gring,
 		.help	= "Query RX/TX ring parameters"
 	},
 	{
diff --git a/netlink/extapi.h b/netlink/extapi.h
index ec5d086f05df..3b3579d53b59 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -24,6 +24,7 @@ int nl_gfeatures(struct cmd_context *ctx);
 int nl_sfeatures(struct cmd_context *ctx);
 int nl_gprivflags(struct cmd_context *ctx);
 int nl_sprivflags(struct cmd_context *ctx);
+int nl_gring(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -52,6 +53,7 @@ static inline void nl_monitor_usage(void)
 #define nl_sfeatures		NULL
 #define nl_gprivflags		NULL
 #define nl_sprivflags		NULL
+#define nl_gring		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index ca2654bad71f..c89e6138dbec 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -39,6 +39,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_PRIVFLAGS_NTF,
 		.cb	= privflags_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RINGS_NTF,
+		.cb	= rings_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -118,6 +122,10 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "--show-priv-flags|--set-priv-flags",
 		.cmd		= ETHTOOL_MSG_PRIVFLAGS_NTF,
 	},
+	{
+		.pattern	= "-g|--show-ring|-G|--set-ring",
+		.cmd		= ETHTOOL_MSG_RINGS_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 2e90dbe095c9..fe68e23cccb3 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -64,6 +64,19 @@ int wol_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int features_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int privflags_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+
+/* dump helpers */
+
+static inline void show_u32(const struct nlattr *attr, const char *label)
+{
+	if (attr)
+		printf("%s%u\n", label, mnl_attr_get_u32(attr));
+	else
+		printf("%sn/a\n", label);
+}
+
+/* misc */
 
 static inline void copy_devname(char *dst, const char *src)
 {
diff --git a/netlink/rings.c b/netlink/rings.c
new file mode 100644
index 000000000000..98ee5dbedb17
--- /dev/null
+++ b/netlink/rings.c
@@ -0,0 +1,71 @@
+/*
+ * rings.c - netlink implementation of ring commands
+ *
+ * Implementation of "ethtool -g <dev>"
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+
+/* RINGS_GET */
+
+int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_RINGS_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_RINGS_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+	printf("Ring parameters for %s:\n", nlctx->devname);
+	printf("Pre-set maximums:\n");
+	show_u32(tb[ETHTOOL_A_RINGS_RX_MAX], "RX:\t\t");
+	show_u32(tb[ETHTOOL_A_RINGS_RX_MINI_MAX], "RX Mini:\t");
+	show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO_MAX], "RX Jumbo:\t");
+	show_u32(tb[ETHTOOL_A_RINGS_TX_MAX], "TX:\t\t");
+	printf("Current hardware settings:\n");
+	show_u32(tb[ETHTOOL_A_RINGS_RX], "RX:\t\t");
+	show_u32(tb[ETHTOOL_A_RINGS_RX_MINI], "RX Mini:\t");
+	show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO], "RX Jumbo:\t");
+	show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
+
+	return MNL_CB_OK;
+}
+
+int nl_gring(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_RINGS_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_RINGS_GET,
+				      ETHTOOL_A_RINGS_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, rings_reply_cb);
+}
-- 
2.26.2

