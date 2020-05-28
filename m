Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98B1E704B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437536AbgE1XWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:49362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437514AbgE1XV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7AA6AFF0;
        Thu, 28 May 2020 23:21:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DB0F1E32D2; Fri, 29 May 2020 01:21:52 +0200 (CEST)
Message-Id: <8666ce6140e5e155ef851c1d46c4df2d09862597.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 09/21] netlink: add netlink handler for gprivflags
 (--show-priv-flags)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:52 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool --show-priv-flags <dev>" subcommand using
ETHTOOL_MSG_PRIVFLAGS_GET netlink message. This retrieves and displays
values of device private flags, traditionally provided by ETHTOOL_GPFLAGS
ioctl request.

Also register the callback with monitor code so that the monitor can
display ETHTOOL_MSG_PRIVFLAGS_NTF notifications.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am         |   2 +-
 ethtool.c           |   1 +
 netlink/extapi.h    |   2 +
 netlink/monitor.c   |   8 ++++
 netlink/netlink.h   |   1 +
 netlink/privflags.c | 109 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100644 netlink/privflags.c

diff --git a/Makefile.am b/Makefile.am
index 36ee50a9dd0c..0a4c4e810c1c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,7 +31,7 @@ ethtool_SOURCES += \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
-		  netlink/features.c \
+		  netlink/features.c netlink/privflags.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.c b/ethtool.c
index 7fbf159baf69..843c710eb408 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5377,6 +5377,7 @@ static const struct option args[] = {
 	{
 		.opts	= "--show-priv-flags",
 		.func	= do_gprivflags,
+		.nlfunc	= nl_gprivflags,
 		.help	= "Query private flags"
 	},
 	{
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 0dbcc8eb2e7b..1bbe3fc21271 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -22,6 +22,7 @@ int nl_sset(struct cmd_context *ctx);
 int nl_permaddr(struct cmd_context *ctx);
 int nl_gfeatures(struct cmd_context *ctx);
 int nl_sfeatures(struct cmd_context *ctx);
+int nl_gprivflags(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -48,6 +49,7 @@ static inline void nl_monitor_usage(void)
 #define nl_permaddr		NULL
 #define nl_gfeatures		NULL
 #define nl_sfeatures		NULL
+#define nl_gprivflags		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/monitor.c b/netlink/monitor.c
index a572e3c38463..ca2654bad71f 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -35,6 +35,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_FEATURES_NTF,
 		.cb	= features_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PRIVFLAGS_NTF,
+		.cb	= privflags_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -110,6 +114,10 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "-k|--show-features|--show-offload|-K|--features|--offload",
 		.cmd		= ETHTOOL_MSG_FEATURES_NTF,
 	},
+	{
+		.pattern	= "--show-priv-flags|--set-priv-flags",
+		.cmd		= ETHTOOL_MSG_PRIVFLAGS_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 98e38ff2d7b0..2e90dbe095c9 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -63,6 +63,7 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int wol_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int features_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int privflags_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 static inline void copy_devname(char *dst, const char *src)
 {
diff --git a/netlink/privflags.c b/netlink/privflags.c
new file mode 100644
index 000000000000..b552c21ed191
--- /dev/null
+++ b/netlink/privflags.c
@@ -0,0 +1,109 @@
+/*
+ * privflags.c - netlink implementation of private flags commands
+ *
+ * Implementation of "ethtool --show-priv-flags <dev>"
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
+#include "bitset.h"
+
+/* PRIVFLAGS_GET */
+
+static void privflags_maxlen_walk_cb(unsigned int idx, const char *name,
+				     bool val, void *data)
+{
+	unsigned int *maxlen = data;
+	unsigned int len, n;
+
+	if (name)
+		len = strlen(name);
+	else {
+		len = 3; /* strlen("bit") */
+		for (n = idx ?: 1; n; n /= 10)
+			len++; /* plus number of ditigs */
+	}
+	if (len > *maxlen)
+		*maxlen = len;
+}
+
+static void privflags_dump_walk_cb(unsigned int idx, const char *name, bool val,
+				   void *data)
+{
+	unsigned int *maxlen = data;
+	char buff[16];
+
+	if (!name) {
+		snprintf(buff, sizeof(buff) - 1, "bit%u", idx);
+		name = buff;
+	}
+	printf("%-*s: %s\n", *maxlen, name, val ? "on" : "off");
+}
+
+int privflags_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	const struct stringset *flag_names = NULL;
+	struct nl_context *nlctx = data;
+	unsigned int maxlen = 0;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0 || !tb[ETHTOOL_A_PRIVFLAGS_FLAGS])
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PRIVFLAGS_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	if (bitset_is_compact(tb[ETHTOOL_A_PRIVFLAGS_FLAGS])) {
+		ret = netlink_init_ethnl2_socket(nlctx);
+		if (ret < 0)
+			return err_ret;
+		flag_names = perdev_stringset(nlctx->devname, ETH_SS_PRIV_FLAGS,
+					      nlctx->ethnl2_socket);
+	}
+
+	ret = walk_bitset(tb[ETHTOOL_A_PRIVFLAGS_FLAGS], flag_names,
+			  privflags_maxlen_walk_cb, &maxlen);
+	if (ret < 0)
+		return err_ret;
+	if (silent)
+		putchar('\n');
+	printf("Private flags for %s:\n", nlctx->devname);
+	ret = walk_bitset(tb[ETHTOOL_A_PRIVFLAGS_FLAGS], flag_names,
+			  privflags_dump_walk_cb, &maxlen);
+	return (ret < 0) ? err_ret : MNL_CB_OK;
+}
+
+int nl_gprivflags(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PRIVFLAGS_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PRIVFLAGS_GET,
+				      ETHTOOL_A_PRIVFLAGS_HEADER, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, privflags_reply_cb);
+}
-- 
2.26.2

