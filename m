Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC31E704F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437552AbgE1XWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:49614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437524AbgE1XWP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D320DAFDF;
        Thu, 28 May 2020 23:22:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 025DCE32D2; Fri, 29 May 2020 01:22:12 +0200 (CEST)
Message-Id: <e008206e255831a5897bc82929dd0c386af2a7b9.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 13/21] netlink: add netlink handler for gchannels (-l)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:12 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -l <dev>" subcommand using ETHTOOL_MSG_CHANNELS_GET
netlink message. This retrieves and displays device channel counts,
traditionally provided by ETHTOOL_GCHANNELS ioctl request.

Also register the callback with monitor code so that the monitor can
display ETHTOOL_MSG_CHANNELS_NTF notifications.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am        |  1 +
 ethtool.c          |  1 +
 netlink/channels.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/extapi.h   |  2 ++
 netlink/monitor.c  |  8 ++++++
 netlink/netlink.h  |  1 +
 6 files changed, 84 insertions(+)
 create mode 100644 netlink/channels.c

diff --git a/Makefile.am b/Makefile.am
index f7d7b44a438d..b5e32bec68f1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -32,6 +32,7 @@ ethtool_SOURCES += \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
+		  netlink/channels.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index bddde6d9f7c0..eff97f4dfe70 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5365,6 +5365,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-l|--show-channels",
 		.func	= do_gchannels,
+		.nlfunc	= nl_gchannels,
 		.help	= "Query Channels"
 	},
 	{
diff --git a/netlink/channels.c b/netlink/channels.c
new file mode 100644
index 000000000000..ddea17b4d670
--- /dev/null
+++ b/netlink/channels.c
@@ -0,0 +1,71 @@
+/*
+ * channels.c - netlink implementation of channel commands
+ *
+ * Implementation of "ethtool -l <dev>"
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
+/* CHANNELS_GET */
+
+int channels_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_CHANNELS_MAX + 1] = {};
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
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_CHANNELS_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+	printf("Channel parameters for %s:\n", nlctx->devname);
+	printf("Pre-set maximums:\n");
+	show_u32(tb[ETHTOOL_A_CHANNELS_RX_MAX], "RX:\t\t");
+	show_u32(tb[ETHTOOL_A_CHANNELS_TX_MAX], "TX:\t\t");
+	show_u32(tb[ETHTOOL_A_CHANNELS_OTHER_MAX], "Other:\t\t");
+	show_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_MAX], "Combined:\t");
+	printf("Current hardware settings:\n");
+	show_u32(tb[ETHTOOL_A_CHANNELS_RX_COUNT], "RX:\t\t");
+	show_u32(tb[ETHTOOL_A_CHANNELS_TX_COUNT], "TX:\t\t");
+	show_u32(tb[ETHTOOL_A_CHANNELS_OTHER_COUNT], "Other:\t\t");
+	show_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], "Combined:\t");
+
+	return MNL_CB_OK;
+}
+
+int nl_gchannels(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_CHANNELS_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_CHANNELS_GET,
+				      ETHTOOL_A_CHANNELS_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, channels_reply_cb);
+}
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 8a3e72bc75e6..9438dcd3aa0f 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -26,6 +26,7 @@ int nl_gprivflags(struct cmd_context *ctx);
 int nl_sprivflags(struct cmd_context *ctx);
 int nl_gring(struct cmd_context *ctx);
 int nl_sring(struct cmd_context *ctx);
+int nl_gchannels(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -56,6 +57,7 @@ static inline void nl_monitor_usage(void)
 #define nl_sprivflags		NULL
 #define nl_gring		NULL
 #define nl_sring		NULL
+#define nl_gchannels		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index c89e6138dbec..5dada99168b0 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -43,6 +43,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_RINGS_NTF,
 		.cb	= rings_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_CHANNELS_NTF,
+		.cb	= channels_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -126,6 +130,10 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "-g|--show-ring|-G|--set-ring",
 		.cmd		= ETHTOOL_MSG_RINGS_NTF,
 	},
+	{
+		.pattern	= "-l|--show-channels|-L|--set-channels",
+		.cmd		= ETHTOOL_MSG_CHANNELS_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index fe68e23cccb3..511bcb2f2098 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -65,6 +65,7 @@ int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int features_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int privflags_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int channels_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
-- 
2.26.2

