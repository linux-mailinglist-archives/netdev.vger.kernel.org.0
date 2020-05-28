Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C630A1E7050
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437557AbgE1XW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:49688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437549AbgE1XWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB644AFFD;
        Thu, 28 May 2020 23:22:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 0971AE32D2; Fri, 29 May 2020 01:22:18 +0200 (CEST)
Message-Id: <73e17a306b77678442f108e49c941576211ff7e4.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 14/21] netlink: add netlink handler for schannels (-L)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:18 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -L <dev> ..." subcommand to set network device channel
counts using ETHTOOL_MSG_CHANNELS_SET netlink message. These are
traditionally set using ETHTOOL_SCHANNELS ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c          |  1 +
 netlink/channels.c | 72 +++++++++++++++++++++++++++++++++++++++++++++-
 netlink/extapi.h   |  2 ++
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index eff97f4dfe70..cf888e08b5a4 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5371,6 +5371,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-L|--set-channels",
 		.func	= do_schannels,
+		.nlfunc	= nl_schannels,
 		.help	= "Set Channels",
 		.xhelp	= "               [ rx N ]\n"
 			  "               [ tx N ]\n"
diff --git a/netlink/channels.c b/netlink/channels.c
index ddea17b4d670..c6002ceeb121 100644
--- a/netlink/channels.c
+++ b/netlink/channels.c
@@ -1,7 +1,7 @@
 /*
  * channels.c - netlink implementation of channel commands
  *
- * Implementation of "ethtool -l <dev>"
+ * Implementation of "ethtool -l <dev>" and "ethtool -L <dev> ..."
  */
 
 #include <errno.h>
@@ -11,6 +11,7 @@
 #include "../internal.h"
 #include "../common.h"
 #include "netlink.h"
+#include "parser.h"
 
 /* CHANNELS_GET */
 
@@ -69,3 +70,72 @@ int nl_gchannels(struct cmd_context *ctx)
 		return ret;
 	return nlsock_send_get_request(nlsk, channels_reply_cb);
 }
+
+/* CHANNELS_SET */
+
+static const struct param_parser schannels_params[] = {
+	{
+		.arg		= "rx",
+		.type		= ETHTOOL_A_CHANNELS_RX_COUNT,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx",
+		.type		= ETHTOOL_A_CHANNELS_TX_COUNT,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "other",
+		.type		= ETHTOOL_A_CHANNELS_OTHER_COUNT,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "combined",
+		.type		= ETHTOOL_A_CHANNELS_COMBINED_COUNT,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_schannels(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_CHANNELS_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "-L";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_CHANNELS_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_CHANNELS_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, schannels_params, NULL, PARSER_GROUP_NONE);
+	if (ret < 0)
+		return 1;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 1;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	else
+		return nlctx->exit_code ?: 1;
+}
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 9438dcd3aa0f..9cea57ac040a 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -27,6 +27,7 @@ int nl_sprivflags(struct cmd_context *ctx);
 int nl_gring(struct cmd_context *ctx);
 int nl_sring(struct cmd_context *ctx);
 int nl_gchannels(struct cmd_context *ctx);
+int nl_schannels(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -58,6 +59,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gring		NULL
 #define nl_sring		NULL
 #define nl_gchannels		NULL
+#define nl_schannels		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
-- 
2.26.2

