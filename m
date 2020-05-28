Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB981E7051
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437562AbgE1XWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:49746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437554AbgE1XW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3A62AFE8;
        Thu, 28 May 2020 23:22:22 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1086AE32D2; Fri, 29 May 2020 01:22:23 +0200 (CEST)
Message-Id: <3bc7c003d31a82ffe1d1254fcf606ae3dba3fa64.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 15/21] netlink: add netlink handler for gcoalesce (-c)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:23 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -c <dev>" subcommand using ETHTOOL_MSG_COALESCE_GET
netlink message. This retrieves and displays device coalescing parameters,
traditionally provided by ETHTOOL_GCOALESCE ioctl request.

Unlike the ioctl code, netlink can distinguish between unsupported
parameter (shown as "n/a") and zero value ("0" or "off").

Also register the callback with monitor code so that the monitor can
display ETHTOOL_MSG_COALESCE_NTF notifications.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am        |  2 +-
 ethtool.c          |  1 +
 netlink/coalesce.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++
 netlink/extapi.h   |  2 +
 netlink/monitor.c  |  8 ++++
 netlink/netlink.h  |  9 +++++
 6 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 netlink/coalesce.c

diff --git a/Makefile.am b/Makefile.am
index b5e32bec68f1..19cef636286f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -32,7 +32,7 @@ ethtool_SOURCES += \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
-		  netlink/channels.c \
+		  netlink/channels.c netlink/coalesce.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index cf888e08b5a4..97280cb676db 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5167,6 +5167,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-c|--show-coalesce",
 		.func	= do_gcoalesce,
+		.nlfunc	= nl_gcoalesce,
 		.help	= "Show coalesce options"
 	},
 	{
diff --git a/netlink/coalesce.c b/netlink/coalesce.c
new file mode 100644
index 000000000000..f1ad671c3bd4
--- /dev/null
+++ b/netlink/coalesce.c
@@ -0,0 +1,91 @@
+/*
+ * coalesce.c - netlink implementation of coalescing commands
+ *
+ * Implementation of "ethtool -c <dev>"
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
+/* COALESCE_GET */
+
+int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_COALESCE_MAX + 1] = {};
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
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_COALESCE_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+	printf("Coalesce parameters for %s:\n", nlctx->devname);
+	printf("Adaptive RX: %s  TX: %s\n",
+	       u8_to_bool(tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]),
+	       u8_to_bool(tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]));
+	show_u32(tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS],
+		 "stats-block-usecs: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL],
+		 "sample-interval: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW], "pkt-rate-low: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_PKT_RATE_HIGH], "pkt-rate-high: ");
+	putchar('\n');
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS], "rx-usecs: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES], "rx-frames: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_IRQ], "rx-usecs-irq: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ], "rx-frames-irq: ");
+	putchar('\n');
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS], "tx-usecs: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES], "tx-frames: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_IRQ], "tx-usecs-irq: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ], "tx-frames-irq: ");
+	putchar('\n');
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_LOW], "rx-usecs-low: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW], "rx-frame-low: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_LOW], "tx-usecs-low: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW], "tx-frame-low: ");
+	putchar('\n');
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_HIGH], "rx-usecs-high: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH], "rx-frame-high: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], "tx-usecs-high: ");
+	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], "tx-frame-high: ");
+	putchar('\n');
+
+	return MNL_CB_OK;
+}
+
+int nl_gcoalesce(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_COALESCE_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_COALESCE_GET,
+				      ETHTOOL_A_COALESCE_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, coalesce_reply_cb);
+}
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 9cea57ac040a..f25fc6e4389f 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -28,6 +28,7 @@ int nl_gring(struct cmd_context *ctx);
 int nl_sring(struct cmd_context *ctx);
 int nl_gchannels(struct cmd_context *ctx);
 int nl_schannels(struct cmd_context *ctx);
+int nl_gcoalesce(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -60,6 +61,7 @@ static inline void nl_monitor_usage(void)
 #define nl_sring		NULL
 #define nl_gchannels		NULL
 #define nl_schannels		NULL
+#define nl_gcoalesce		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index 5dada99168b0..ef9cc7a6923a 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -47,6 +47,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_CHANNELS_NTF,
 		.cb	= channels_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_COALESCE_NTF,
+		.cb	= coalesce_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -134,6 +138,10 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "-l|--show-channels|-L|--set-channels",
 		.cmd		= ETHTOOL_MSG_CHANNELS_NTF,
 	},
+	{
+		.pattern	= "-c|--show-coalesce|-C|--coalesce",
+		.cmd		= ETHTOOL_MSG_COALESCE_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 511bcb2f2098..d35048583f5e 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -66,6 +66,7 @@ int features_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int privflags_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int channels_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
@@ -77,6 +78,14 @@ static inline void show_u32(const struct nlattr *attr, const char *label)
 		printf("%sn/a\n", label);
 }
 
+static inline const char *u8_to_bool(const struct nlattr *attr)
+{
+	if (attr)
+		return mnl_attr_get_u8(attr) ? "on" : "off";
+	else
+		return "n/a";
+}
+
 /* misc */
 
 static inline void copy_devname(char *dst, const char *src)
-- 
2.26.2

