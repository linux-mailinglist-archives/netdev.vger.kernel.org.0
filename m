Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8545D1E7056
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437587AbgE1XWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:49900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437583AbgE1XWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3F871AFFB;
        Thu, 28 May 2020 23:22:48 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 341C2E32D2; Fri, 29 May 2020 01:22:48 +0200 (CEST)
Message-Id: <f445a833de612321811326b87e1edf0b0075e71d.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 20/21] netlink: add netlink handler for seee
 (--set-eee)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:48 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool --set-eee <dev> ..." subcommand to set network device
EEE settings using ETHTOOL_MSG_EEE_SET netlink message. These are
traditionally set using ETHTOOL_SEEE ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c        |  1 +
 netlink/eee.c    | 83 +++++++++++++++++++++++++++++++++++++++++++++++-
 netlink/extapi.h |  2 ++
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index f4aaab58aa5b..3b81345d7120 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5413,6 +5413,7 @@ static const struct option args[] = {
 	{
 		.opts	= "--set-eee",
 		.func	= do_seee,
+		.nlfunc	= nl_seee,
 		.help	= "Set EEE settings",
 		.xhelp	= "		[ eee on|off ]\n"
 			  "		[ advertise %x ]\n"
diff --git a/netlink/eee.c b/netlink/eee.c
index c9a9fcfba1f5..d3135b2094a4 100644
--- a/netlink/eee.c
+++ b/netlink/eee.c
@@ -1,7 +1,8 @@
 /*
  * eee.c - netlink implementation of eee commands
  *
- * Implementation of "ethtool --show-eee <dev>"
+ * Implementation of "ethtool --show-eee <dev>" and
+ * "ethtool --set-eee <dev> ..."
  */
 
 #include <errno.h>
@@ -12,6 +13,7 @@
 #include "../common.h"
 #include "netlink.h"
 #include "bitset.h"
+#include "parser.h"
 
 /* EEE_GET */
 
@@ -106,3 +108,82 @@ int nl_geee(struct cmd_context *ctx)
 		return ret;
 	return nlsock_send_get_request(nlsk, eee_reply_cb);
 }
+
+/* EEE_SET */
+
+static const struct bitset_parser_data advertise_parser_data = {
+	.no_mask	= false,
+	.force_hex	= true,
+};
+
+static const struct param_parser seee_params[] = {
+	{
+		.arg		= "advertise",
+		.type		= ETHTOOL_A_EEE_MODES_OURS,
+		.handler	= nl_parse_bitset,
+		.handler_data	= &advertise_parser_data,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-lpi",
+		.type		= ETHTOOL_A_EEE_TX_LPI_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-timer",
+		.type		= ETHTOOL_A_EEE_TX_LPI_TIMER,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "eee",
+		.type		= ETHTOOL_A_EEE_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_seee(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_EEE_SET, false))
+		return -EOPNOTSUPP;
+	if (!ctx->argc) {
+		fprintf(stderr, "ethtool (--set-eee): parameters missing\n");
+		return 1;
+	}
+
+	nlctx->cmd = "--set-eee";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_EEE_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_EEE_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, seee_params, NULL, PARSER_GROUP_NONE);
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
diff --git a/netlink/extapi.h b/netlink/extapi.h
index f16dd5ed25b4..387787f61015 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -33,6 +33,7 @@ int nl_scoalesce(struct cmd_context *ctx);
 int nl_gpause(struct cmd_context *ctx);
 int nl_spause(struct cmd_context *ctx);
 int nl_geee(struct cmd_context *ctx);
+int nl_seee(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -70,6 +71,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gpause		NULL
 #define nl_spause		NULL
 #define nl_geee			NULL
+#define nl_seee			NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
-- 
2.26.2

