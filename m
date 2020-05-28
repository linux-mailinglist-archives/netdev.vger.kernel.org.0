Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF12D1E704C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437539AbgE1XWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:22:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:49424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437524AbgE1XWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:22:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C03F4AFF4;
        Thu, 28 May 2020 23:21:57 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E1EB9E32D2; Fri, 29 May 2020 01:21:57 +0200 (CEST)
Message-Id: <1b897e33f5f792729deb0750fceab5394abc32fd.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 10/21] netlink: add netlink handler for sprivflags
 (--set-priv-flags)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:57 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool --set-priv-flags <dev> ..." subcommand to set device
private flags using ETHTOOL_MSG_PRIVFLAGS_SET netlink message. These are
traditionally set using ETHTOOL_SPFLAGS ioctl request.

Unlike ioctl implementation, netlink does not retrieve private flag names
first so that names provided on command line are validated by kernel rather
than by parser. Unrecognized names are therefore interpreted as a failed
request rather than a parser error.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c           |  1 +
 netlink/extapi.h    |  2 ++
 netlink/privflags.c | 51 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 843c710eb408..81472ad40a5b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5383,6 +5383,7 @@ static const struct option args[] = {
 	{
 		.opts	= "--set-priv-flags",
 		.func	= do_sprivflags,
+		.nlfunc	= nl_sprivflags,
 		.help	= "Set private flags",
 		.xhelp	= "		FLAG on|off ...\n"
 	},
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 1bbe3fc21271..ec5d086f05df 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -23,6 +23,7 @@ int nl_permaddr(struct cmd_context *ctx);
 int nl_gfeatures(struct cmd_context *ctx);
 int nl_sfeatures(struct cmd_context *ctx);
 int nl_gprivflags(struct cmd_context *ctx);
+int nl_sprivflags(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -50,6 +51,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gfeatures		NULL
 #define nl_sfeatures		NULL
 #define nl_gprivflags		NULL
+#define nl_sprivflags		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/privflags.c b/netlink/privflags.c
index b552c21ed191..a06cd6d88d9d 100644
--- a/netlink/privflags.c
+++ b/netlink/privflags.c
@@ -1,7 +1,8 @@
 /*
  * privflags.c - netlink implementation of private flags commands
  *
- * Implementation of "ethtool --show-priv-flags <dev>"
+ * Implementation of "ethtool --show-priv-flags <dev>" and
+ * "ethtool --set-priv-flags <dev> ..."
  */
 
 #include <errno.h>
@@ -13,6 +14,7 @@
 #include "netlink.h"
 #include "strset.h"
 #include "bitset.h"
+#include "parser.h"
 
 /* PRIVFLAGS_GET */
 
@@ -107,3 +109,50 @@ int nl_gprivflags(struct cmd_context *ctx)
 		return ret;
 	return nlsock_send_get_request(nlsk, privflags_reply_cb);
 }
+
+/* PRIVFLAGS_SET */
+
+static const struct bitset_parser_data privflags_parser_data = {
+	.force_hex	= false,
+	.no_mask	= false,
+};
+
+int nl_sprivflags(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PRIVFLAGS_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "--set-priv-flags";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_PRIVFLAGS_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_PRIVFLAGS_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parse_bitset(nlctx, ETHTOOL_A_PRIVFLAGS_FLAGS,
+			      &privflags_parser_data, msgbuff, NULL);
+	if (ret < 0)
+		return -EINVAL;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 2;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	else
+		return nlctx->exit_code ?: 1;
+}
-- 
2.26.2

