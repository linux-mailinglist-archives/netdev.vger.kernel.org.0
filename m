Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE511E7052
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437567AbgE1XWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:49792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437558AbgE1XWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB34DAFF7;
        Thu, 28 May 2020 23:22:27 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 182EAE32D2; Fri, 29 May 2020 01:22:28 +0200 (CEST)
Message-Id: <d3ce71077a4b6dd090923d40c7a37aa8619a1133.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 16/21] netlink: add netlink handler for scoalesce (-C)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:28 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -C <dev> ..." subcommand to set network device
coalescing parameters using ETHTOOL_MSG_COALESCE_SET netlink message. These
are traditionally set using ETHTOOL_SCOALESCE ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c          |   1 +
 netlink/coalesce.c | 180 ++++++++++++++++++++++++++++++++++++++++++++-
 netlink/extapi.h   |   2 +
 3 files changed, 182 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 97280cb676db..6a28307004d5 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5173,6 +5173,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-C|--coalesce",
 		.func	= do_scoalesce,
+		.nlfunc	= nl_scoalesce,
 		.help	= "Set coalesce options",
 		.xhelp	= "		[adaptive-rx on|off]\n"
 			  "		[adaptive-tx on|off]\n"
diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index f1ad671c3bd4..65f75cf9a8dd 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -1,7 +1,7 @@
 /*
  * coalesce.c - netlink implementation of coalescing commands
  *
- * Implementation of "ethtool -c <dev>"
+ * Implementation of "ethtool -c <dev>" and "ethtool -C <dev> ..."
  */
 
 #include <errno.h>
@@ -11,6 +11,7 @@
 #include "../internal.h"
 #include "../common.h"
 #include "netlink.h"
+#include "parser.h"
 
 /* COALESCE_GET */
 
@@ -89,3 +90,180 @@ int nl_gcoalesce(struct cmd_context *ctx)
 		return ret;
 	return nlsock_send_get_request(nlsk, coalesce_reply_cb);
 }
+
+/* COALESCE_SET */
+
+static const struct param_parser scoalesce_params[] = {
+	{
+		.arg		= "adaptive-rx",
+		.type		= ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "adaptive-tx",
+		.type		= ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "sample-interval",
+		.type		= ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "stats-block-usecs",
+		.type		= ETHTOOL_A_COALESCE_STATS_BLOCK_USECS,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "pkt-rate-low",
+		.type		= ETHTOOL_A_COALESCE_PKT_RATE_LOW,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "pkt-rate-high",
+		.type		= ETHTOOL_A_COALESCE_PKT_RATE_HIGH,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-usecs",
+		.type		= ETHTOOL_A_COALESCE_RX_USECS,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-frames",
+		.type		= ETHTOOL_A_COALESCE_RX_MAX_FRAMES,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-usecs-irq",
+		.type		= ETHTOOL_A_COALESCE_RX_USECS_IRQ,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-frames-irq",
+		.type		= ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-usecs",
+		.type		= ETHTOOL_A_COALESCE_TX_USECS,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-frames",
+		.type		= ETHTOOL_A_COALESCE_TX_MAX_FRAMES,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-usecs-irq",
+		.type		= ETHTOOL_A_COALESCE_TX_USECS_IRQ,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-frames-irq",
+		.type		= ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-usecs-low",
+		.type		= ETHTOOL_A_COALESCE_RX_USECS_LOW,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-frames-low",
+		.type		= ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-usecs-low",
+		.type		= ETHTOOL_A_COALESCE_TX_USECS_LOW,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-frames-low",
+		.type		= ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-usecs-high",
+		.type		= ETHTOOL_A_COALESCE_RX_USECS_HIGH,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-frames-high",
+		.type		= ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-usecs-high",
+		.type		= ETHTOOL_A_COALESCE_TX_USECS_HIGH,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-frames-high",
+		.type		= ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_scoalesce(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_COALESCE_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "-C";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_COALESCE_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_COALESCE_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, scoalesce_params, NULL, PARSER_GROUP_NONE);
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
index f25fc6e4389f..d35029576d5c 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -29,6 +29,7 @@ int nl_sring(struct cmd_context *ctx);
 int nl_gchannels(struct cmd_context *ctx);
 int nl_schannels(struct cmd_context *ctx);
 int nl_gcoalesce(struct cmd_context *ctx);
+int nl_scoalesce(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -62,6 +63,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gchannels		NULL
 #define nl_schannels		NULL
 #define nl_gcoalesce		NULL
+#define nl_scoalesce		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
-- 
2.26.2

