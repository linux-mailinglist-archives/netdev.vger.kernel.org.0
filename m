Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D441E7055
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437581AbgE1XWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:49892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437578AbgE1XWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F9C8AFDB;
        Thu, 28 May 2020 23:22:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2D425E32D2; Fri, 29 May 2020 01:22:43 +0200 (CEST)
Message-Id: <777a70bc941dbd4a0b6505c27a3658a7e8d945e2.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 19/21] netlink: add netlink handler for geee
 (--show-eee)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:43 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool --show-eee <dev>" subcommand using ETHTOOL_MSG_EEE_GET
netlink message. This retrieves and displays device coalescing parameters,
traditionally provided by ETHTOOL_GEEE ioctl request.

Also register the callback with monitor code so that the monitor can
display ETHTOOL_MSG_EEE_NTF notifications.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am        |   1 +
 ethtool.c          |   1 +
 netlink/eee.c      | 108 +++++++++++++++++++++++++++++++++++++++++++++
 netlink/extapi.h   |   2 +
 netlink/monitor.c  |   8 ++++
 netlink/netlink.h  |  15 +++++++
 netlink/settings.c |  17 ++-----
 7 files changed, 138 insertions(+), 14 deletions(-)
 create mode 100644 netlink/eee.c

diff --git a/Makefile.am b/Makefile.am
index 5d6c4e9571d0..95babcdc8eae 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -33,6 +33,7 @@ ethtool_SOURCES += \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
+		  netlink/eee.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index 2005e9523f93..f4aaab58aa5b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5407,6 +5407,7 @@ static const struct option args[] = {
 	{
 		.opts	= "--show-eee",
 		.func	= do_geee,
+		.nlfunc	= nl_geee,
 		.help	= "Show EEE settings",
 	},
 	{
diff --git a/netlink/eee.c b/netlink/eee.c
new file mode 100644
index 000000000000..c9a9fcfba1f5
--- /dev/null
+++ b/netlink/eee.c
@@ -0,0 +1,108 @@
+/*
+ * eee.c - netlink implementation of eee commands
+ *
+ * Implementation of "ethtool --show-eee <dev>"
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
+/* EEE_GET */
+
+int eee_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_EEE_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	bool enabled, active, tx_lpi_enabled;
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
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_EEE_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (!tb[ETHTOOL_A_EEE_MODES_OURS] ||
+	    !tb[ETHTOOL_A_EEE_ACTIVE] || !tb[ETHTOOL_A_EEE_ENABLED] ||
+	    !tb[ETHTOOL_A_EEE_TX_LPI_ENABLED] ||
+	    !tb[ETHTOOL_A_EEE_TX_LPI_TIMER]) {
+		fprintf(stderr, "Malformed response from kernel\n");
+		return err_ret;
+	}
+	active = mnl_attr_get_u8(tb[ETHTOOL_A_EEE_ACTIVE]);
+	enabled = mnl_attr_get_u8(tb[ETHTOOL_A_EEE_ENABLED]);
+	tx_lpi_enabled = mnl_attr_get_u8(tb[ETHTOOL_A_EEE_TX_LPI_ENABLED]);
+
+	if (silent)
+		putchar('\n');
+	printf("EEE settings for %s:\n", nlctx->devname);
+	printf("\tEEE status: ");
+	if (bitset_is_empty(tb[ETHTOOL_A_EEE_MODES_OURS], true, &ret)) {
+		printf("not supported\n");
+		return MNL_CB_OK;
+	}
+	if (!enabled)
+		printf("disabled\n");
+	else
+		printf("enabled - %s\n", active ? "active" : "inactive");
+	printf("\tTx LPI: ");
+	if (tx_lpi_enabled)
+		printf("%u (us)\n",
+		       mnl_attr_get_u32(tb[ETHTOOL_A_EEE_TX_LPI_TIMER]));
+	else
+		printf("disabled\n");
+
+	ret = dump_link_modes(nlctx, tb[ETHTOOL_A_EEE_MODES_OURS], true,
+			      LM_CLASS_REAL,
+			      "Supported EEE link modes:  ", NULL, "\n",
+			      "Not reported");
+	if (ret < 0)
+		return err_ret;
+	ret = dump_link_modes(nlctx, tb[ETHTOOL_A_EEE_MODES_OURS], false,
+			      LM_CLASS_REAL,
+			      "Advertised EEE link modes:  ", NULL, "\n",
+			      "Not reported");
+	if (ret < 0)
+		return err_ret;
+	ret = dump_link_modes(nlctx, tb[ETHTOOL_A_EEE_MODES_PEER], false,
+			      LM_CLASS_REAL,
+			      "Link partner advertised EEE link modes:  ", NULL,
+			      "\n", "Not reported");
+	if (ret < 0)
+		return err_ret;
+
+	return MNL_CB_OK;
+}
+
+int nl_geee(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_EEE_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_EEE_GET,
+				      ETHTOOL_A_EEE_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, eee_reply_cb);
+}
diff --git a/netlink/extapi.h b/netlink/extapi.h
index b86595763c9d..f16dd5ed25b4 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -32,6 +32,7 @@ int nl_gcoalesce(struct cmd_context *ctx);
 int nl_scoalesce(struct cmd_context *ctx);
 int nl_gpause(struct cmd_context *ctx);
 int nl_spause(struct cmd_context *ctx);
+int nl_geee(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -68,6 +69,7 @@ static inline void nl_monitor_usage(void)
 #define nl_scoalesce		NULL
 #define nl_gpause		NULL
 #define nl_spause		NULL
+#define nl_geee			NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index f02b462ff102..18d4efd07bd2 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -55,6 +55,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_PAUSE_NTF,
 		.cb	= pause_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_EEE_NTF,
+		.cb	= eee_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -150,6 +154,10 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "-a|--show-pause|-A|--pause",
 		.cmd		= ETHTOOL_MSG_PAUSE_NTF,
 	},
+	{
+		.pattern	= "--show-eee|--set-eee",
+		.cmd		= ETHTOOL_MSG_EEE_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 7cbb23733f88..fe53fd066c95 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -16,6 +16,15 @@
 #define WILDCARD_DEVNAME "*"
 #define CMDMASK_WORDS DIV_ROUND_UP(__ETHTOOL_MSG_KERNEL_CNT, 32)
 
+enum link_mode_class {
+	LM_CLASS_UNKNOWN,
+	LM_CLASS_REAL,
+	LM_CLASS_AUTONEG,
+	LM_CLASS_PORT,
+	LM_CLASS_PAUSE,
+	LM_CLASS_FEC,
+};
+
 struct nl_context {
 	struct cmd_context	*ctx;
 	void			*cmd_private;
@@ -68,9 +77,15 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int channels_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int eee_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
+int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
+		    bool mask, unsigned int class, const char *before,
+		    const char *between, const char *after,
+		    const char *if_none);
+
 static inline void show_u32(const struct nlattr *attr, const char *label)
 {
 	if (attr)
diff --git a/netlink/settings.c b/netlink/settings.c
index 8be5a22ddd2e..aa627cd300ed 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -17,15 +17,6 @@
 
 /* GET_SETTINGS */
 
-enum link_mode_class {
-	LM_CLASS_UNKNOWN,
-	LM_CLASS_REAL,
-	LM_CLASS_AUTONEG,
-	LM_CLASS_PORT,
-	LM_CLASS_PAUSE,
-	LM_CLASS_FEC,
-};
-
 struct link_mode_info {
 	enum link_mode_class	class;
 	u32			speed;
@@ -263,11 +254,9 @@ static void print_banner(struct nl_context *nlctx)
 	nlctx->no_banner = true;
 }
 
-static int dump_link_modes(struct nl_context *nlctx,
-			   const struct nlattr *bitset, bool mask,
-			   unsigned int class, const char *before,
-			   const char *between, const char *after,
-			   const char *if_none)
+int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
+		    bool mask, unsigned int class, const char *before,
+		    const char *between, const char *after, const char *if_none)
 {
 	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
 	DECLARE_ATTR_TB_INFO(bitset_tb);
-- 
2.26.2

