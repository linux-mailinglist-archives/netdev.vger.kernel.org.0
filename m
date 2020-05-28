Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC911E7053
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437572AbgE1XWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:49836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437564AbgE1XWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2606AFE5;
        Thu, 28 May 2020 23:22:32 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1F218E32D2; Fri, 29 May 2020 01:22:33 +0200 (CEST)
Message-Id: <0d1220c934229cbf391f26400f09fa93d9eb9eb7.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 17/21] netlink: add netlink handler for gpause (-a)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:33 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -a <dev>" subcommand using ETHTOOL_MSG_PAUSE_GET netlink
message. This retrieves and diaplays device pause parameters, traditionally
provided by ETHTOOL_GPAUSEPARAM ioctl request.

Also register the callback with monitor code so that the monitor can
display ETHTOOL_MSG_PAUSE_NTF notifications. When in monitor mode,
negotiated status is not displayed.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am       |   2 +-
 ethtool.c         |   1 +
 netlink/extapi.h  |   2 +
 netlink/monitor.c |   8 +++
 netlink/netlink.h |   6 ++
 netlink/pause.c   | 158 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100644 netlink/pause.c

diff --git a/Makefile.am b/Makefile.am
index 19cef636286f..5d6c4e9571d0 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -32,7 +32,7 @@ ethtool_SOURCES += \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
-		  netlink/channels.c netlink/coalesce.c \
+		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index 6a28307004d5..b5b7ddab813d 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5154,6 +5154,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-a|--show-pause",
 		.func	= do_gpause,
+		.nlfunc	= nl_gpause,
 		.help	= "Show pause options"
 	},
 	{
diff --git a/netlink/extapi.h b/netlink/extapi.h
index d35029576d5c..00ad74010d2c 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -30,6 +30,7 @@ int nl_gchannels(struct cmd_context *ctx);
 int nl_schannels(struct cmd_context *ctx);
 int nl_gcoalesce(struct cmd_context *ctx);
 int nl_scoalesce(struct cmd_context *ctx);
+int nl_gpause(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -64,6 +65,7 @@ static inline void nl_monitor_usage(void)
 #define nl_schannels		NULL
 #define nl_gcoalesce		NULL
 #define nl_scoalesce		NULL
+#define nl_gpause		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index ef9cc7a6923a..f02b462ff102 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -51,6 +51,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_COALESCE_NTF,
 		.cb	= coalesce_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PAUSE_NTF,
+		.cb	= pause_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -142,6 +146,10 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "-c|--show-coalesce|-C|--coalesce",
 		.cmd		= ETHTOOL_MSG_COALESCE_NTF,
 	},
+	{
+		.pattern	= "-a|--show-pause|-A|--pause",
+		.cmd		= ETHTOOL_MSG_PAUSE_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index d35048583f5e..7cbb23733f88 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -67,6 +67,7 @@ int privflags_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int channels_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
@@ -86,6 +87,11 @@ static inline const char *u8_to_bool(const struct nlattr *attr)
 		return "n/a";
 }
 
+static inline void show_bool(const struct nlattr *attr, const char *label)
+{
+	printf("%s%s\n", label, u8_to_bool(attr));
+}
+
 /* misc */
 
 static inline void copy_devname(char *dst, const char *src)
diff --git a/netlink/pause.c b/netlink/pause.c
new file mode 100644
index 000000000000..c9fdaeeaa0bc
--- /dev/null
+++ b/netlink/pause.c
@@ -0,0 +1,158 @@
+/*
+ * pause.c - netlink implementation of pause commands
+ *
+ * Implementation of "ethtool -a <dev>"
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
+/* PAUSE_GET */
+
+struct pause_autoneg_status {
+	bool	pause;
+	bool	asym_pause;
+};
+
+static void pause_autoneg_walker(unsigned int idx, const char *name, bool val,
+				 void *data)
+{
+	struct pause_autoneg_status *status = data;
+
+	if (idx == ETHTOOL_LINK_MODE_Pause_BIT)
+		status->pause = val;
+	if (idx == ETHTOOL_LINK_MODE_Asym_Pause_BIT)
+		status->asym_pause = val;
+}
+
+static int pause_autoneg_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct pause_autoneg_status ours = {};
+	struct pause_autoneg_status peer = {};
+	struct nl_context *nlctx = data;
+	bool rx_status = false;
+	bool tx_status = false;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+
+	if (!tb[ETHTOOL_A_LINKMODES_OURS] || !tb[ETHTOOL_A_LINKMODES_PEER])
+		return MNL_CB_OK;
+	ret = walk_bitset(tb[ETHTOOL_A_LINKMODES_OURS], NULL,
+			  pause_autoneg_walker, &ours);
+	if (ret < 0)
+		return err_ret;
+	ret = walk_bitset(tb[ETHTOOL_A_LINKMODES_PEER], NULL,
+			  pause_autoneg_walker, &peer);
+	if (ret < 0)
+		return err_ret;
+
+	if (ours.pause && peer.pause) {
+		rx_status = true;
+		tx_status = true;
+	} else if (ours.asym_pause && peer.asym_pause) {
+		if (ours.pause)
+			rx_status = true;
+		else if (peer.pause)
+			tx_status = true;
+	}
+	printf("RX negotiated: %s\nTX negotiated: %s\n",
+	       rx_status ? "on" : "off", tx_status ? "on" : "off");
+
+	return MNL_CB_OK;
+}
+
+static int show_pause_autoneg_status(struct nl_context *nlctx)
+{
+	const char *saved_devname;
+	int ret;
+
+	saved_devname = nlctx->ctx->devname;
+	nlctx->ctx->devname = nlctx->devname;
+	ret = netlink_init_ethnl2_socket(nlctx);
+	if (ret < 0)
+		goto out;
+
+	ret = nlsock_prep_get_request(nlctx->ethnl2_socket,
+				      ETHTOOL_MSG_LINKMODES_GET,
+				      ETHTOOL_A_LINKMODES_HEADER,
+				      ETHTOOL_FLAG_COMPACT_BITSETS);
+	if (ret < 0)
+		goto out;
+	ret = nlsock_send_get_request(nlctx->ethnl2_socket, pause_autoneg_cb);
+
+out:
+	nlctx->ctx->devname = saved_devname;
+	return ret;
+}
+
+int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PAUSE_MAX + 1] = {};
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
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PAUSE_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+	printf("Pause parameters for %s:\n", nlctx->devname);
+	show_bool(tb[ETHTOOL_A_PAUSE_AUTONEG], "Autonegotiate:\t");
+	show_bool(tb[ETHTOOL_A_PAUSE_RX], "RX:\t\t");
+	show_bool(tb[ETHTOOL_A_PAUSE_TX], "TX:\t\t");
+	if (!nlctx->is_monitor && tb[ETHTOOL_A_PAUSE_AUTONEG] &&
+	    mnl_attr_get_u8(tb[ETHTOOL_A_PAUSE_AUTONEG])) {
+		ret = show_pause_autoneg_status(nlctx);
+		if (ret < 0)
+			return err_ret;
+	}
+	if (!silent)
+		putchar('\n');
+
+	return MNL_CB_OK;
+}
+
+int nl_gpause(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PAUSE_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PAUSE_GET,
+				      ETHTOOL_A_PAUSE_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, pause_reply_cb);
+}
-- 
2.26.2

