Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686F91E704D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437543AbgE1XWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:49554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437535AbgE1XWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CEF00AFF6;
        Thu, 28 May 2020 23:22:07 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id EF97AE32D2; Fri, 29 May 2020 01:22:07 +0200 (CEST)
Message-Id: <d3fa3e2b60c383792de498537bcde15958fe73dc.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 12/21] netlink: add netlink handler for sring (-G)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:22:07 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -G <dev> ..." subcommand to set network device ring
sizes using ETHTOOL_MSG_RINGS_SET netlink request. These are traditionally
set using ETHTOOL_SRINGPARAM ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c        |  1 +
 netlink/extapi.h |  2 ++
 netlink/rings.c  | 72 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index fc3fb11a6a19..bddde6d9f7c0 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5205,6 +5205,7 @@ static const struct option args[] = {
 	{
 		.opts	= "-G|--set-ring",
 		.func	= do_sring,
+		.nlfunc	= nl_sring,
 		.help	= "Set RX/TX ring parameters",
 		.xhelp	= "		[ rx N ]\n"
 			  "		[ rx-mini N ]\n"
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 3b3579d53b59..8a3e72bc75e6 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -25,6 +25,7 @@ int nl_sfeatures(struct cmd_context *ctx);
 int nl_gprivflags(struct cmd_context *ctx);
 int nl_sprivflags(struct cmd_context *ctx);
 int nl_gring(struct cmd_context *ctx);
+int nl_sring(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -54,6 +55,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gprivflags		NULL
 #define nl_sprivflags		NULL
 #define nl_gring		NULL
+#define nl_sring		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/rings.c b/netlink/rings.c
index 98ee5dbedb17..4061520212d5 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -1,7 +1,7 @@
 /*
  * rings.c - netlink implementation of ring commands
  *
- * Implementation of "ethtool -g <dev>"
+ * Implementation of "ethtool -g <dev>" and "ethtool -G <dev> ..."
  */
 
 #include <errno.h>
@@ -11,6 +11,7 @@
 #include "../internal.h"
 #include "../common.h"
 #include "netlink.h"
+#include "parser.h"
 
 /* RINGS_GET */
 
@@ -69,3 +70,72 @@ int nl_gring(struct cmd_context *ctx)
 		return ret;
 	return nlsock_send_get_request(nlsk, rings_reply_cb);
 }
+
+/* RINGS_SET */
+
+static const struct param_parser sring_params[] = {
+	{
+		.arg		= "rx",
+		.type		= ETHTOOL_A_RINGS_RX,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-mini",
+		.type		= ETHTOOL_A_RINGS_RX_MINI,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "rx-jumbo",
+		.type		= ETHTOOL_A_RINGS_RX_JUMBO,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx",
+		.type		= ETHTOOL_A_RINGS_TX,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_sring(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_RINGS_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "-G";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_RINGS_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_RINGS_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, sring_params, NULL, PARSER_GROUP_NONE);
+	if (ret < 0)
+		return 1;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 81;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	else
+		return nlctx->exit_code ?: 81;
+}
-- 
2.26.2

