Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85C1E7054
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437576AbgE1XWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:49878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437569AbgE1XWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 03FC7AFFE;
        Thu, 28 May 2020 23:22:37 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 262E6E32D2; Fri, 29 May 2020 01:22:38 +0200 (CEST)
Message-Id: <88d2b52d85af7af8dba230917bfcf28d69e4f52c.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 18/21] netlink: add netlink handler for spause (-A)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:38 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -A <dev> ..." subcommand to set network device pause
parameters using ETHTOOL_MSG_PAUSE_SET netlink message. These are
traditionally set using ETHTOOL_SPAUSEPARAM ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c        |  1 +
 netlink/extapi.h |  2 ++
 netlink/pause.c  | 66 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index b5b7ddab813d..2005e9523f93 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5160,6 +5160,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-A|--pause",
 		.func	= do_spause,
+		.nlfunc	= nl_spause,
 		.help	= "Set pause options",
 		.xhelp	= "		[ autoneg on|off ]\n"
 			  "		[ rx on|off ]\n"
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 00ad74010d2c..b86595763c9d 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -31,6 +31,7 @@ int nl_schannels(struct cmd_context *ctx);
 int nl_gcoalesce(struct cmd_context *ctx);
 int nl_scoalesce(struct cmd_context *ctx);
 int nl_gpause(struct cmd_context *ctx);
+int nl_spause(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -66,6 +67,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gcoalesce		NULL
 #define nl_scoalesce		NULL
 #define nl_gpause		NULL
+#define nl_spause		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/pause.c b/netlink/pause.c
index c9fdaeeaa0bc..48215d29aa34 100644
--- a/netlink/pause.c
+++ b/netlink/pause.c
@@ -1,7 +1,7 @@
 /*
  * pause.c - netlink implementation of pause commands
  *
- * Implementation of "ethtool -a <dev>"
+ * Implementation of "ethtool -a <dev>" and "ethtool -A <dev> ..."
  */
 
 #include <errno.h>
@@ -12,6 +12,7 @@
 #include "../common.h"
 #include "netlink.h"
 #include "bitset.h"
+#include "parser.h"
 
 /* PAUSE_GET */
 
@@ -156,3 +157,66 @@ int nl_gpause(struct cmd_context *ctx)
 		return ret;
 	return nlsock_send_get_request(nlsk, pause_reply_cb);
 }
+
+/* PAUSE_SET */
+
+static const struct param_parser spause_params[] = {
+	{
+		.arg		= "autoneg",
+		.type		= ETHTOOL_A_PAUSE_AUTONEG,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx",
+		.type		= ETHTOOL_A_PAUSE_RX,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx",
+		.type		= ETHTOOL_A_PAUSE_TX,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_spause(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PAUSE_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "-A";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_PAUSE_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_PAUSE_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, spause_params, NULL, PARSER_GROUP_NONE);
+	if (ret < 0)
+		return 1;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 76;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	else
+		return nlctx->exit_code ?: 76;
+}
-- 
2.26.2

