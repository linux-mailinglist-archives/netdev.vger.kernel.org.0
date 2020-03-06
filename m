Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C116817C394
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgCFRFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:05:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:43810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgCFRFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:05:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7C5E9B15D;
        Fri,  6 Mar 2020 17:05:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2D886E00E7; Fri,  6 Mar 2020 18:05:30 +0100 (CET)
Message-Id: <148c6fb218b83db9d0e973fb5684b4e3408a5f0a.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 18/25] netlink: add netlink handler for sset (-s)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:05:30 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement "ethtool -s <dev>" subcommand using netlink interface request
ETHTOOL_MSG_LINKINFO_SET, ETHTOOL_MSG_LINKMODES_SET, ETHTOOL_MSG_WOL_SET
and ETHTOOL_MSG_DEBUG_SET.

Parser grouping with PARSER_GROUP_MSG group style is used to create
multiple request messages from one set of attributes which can be in
arbitrary order.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.8.in       |  15 ++--
 ethtool.c          |   9 ++-
 netlink/extapi.h   |   2 +
 netlink/settings.c | 193 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 210 insertions(+), 9 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index 28e4f75eee8d..ba85cfe4f413 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -242,16 +242,21 @@ ethtool \- query or control network driver and hardware settings
 .I devname
 .BN speed
 .B2 duplex half full
-.B4 port tp aui bnc mii fibre
+.B4 port tp aui bnc mii fibre da
 .B3 mdix auto on off
 .B2 autoneg on off
-.BN advertise
+.RB [ advertise \ \fIN\fP[\fB/\fP\fIM\fP]
+|
+.BI advertise \ mode
+.A1 on off
+.RB ...]
 .BN phyad
 .B2 xcvr internal external
-.RB [ wol \ \*(WO]
+.RB [ wol \ \fIN\fP[\fB/\fP\fIM\fP]
+.RB | \ wol \ \*(WO]
 .RB [ sopass \ \*(MA]
 .RB [ msglvl
-.IR N \ |
+.IR N\fP[/\fIM\fP] \ |
 .BI msglvl \ type
 .A1 on off
 .RB ...]
@@ -638,7 +643,7 @@ with just the device name as an argument will show you the supported device spee
 .A2 duplex half full
 Sets full or half duplex mode.
 .TP
-.A4 port tp aui bnc mii fibre
+.A4 port tp aui bnc mii fibre da
 Selects device port.
 .TP
 .A3 mdix auto on off
diff --git a/ethtool.c b/ethtool.c
index a69233bd73fc..baa6458bb486 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5166,18 +5166,19 @@ static const struct option args[] = {
 	{
 		.opts	= "-s|--change",
 		.func	= do_sset,
+		.nlfunc	= nl_sset,
 		.help	= "Change generic options",
 		.xhelp	= "		[ speed %d ]\n"
 			  "		[ duplex half|full ]\n"
-			  "		[ port tp|aui|bnc|mii|fibre ]\n"
+			  "		[ port tp|aui|bnc|mii|fibre|da ]\n"
 			  "		[ mdix auto|on|off ]\n"
 			  "		[ autoneg on|off ]\n"
-			  "		[ advertise %x ]\n"
+			  "		[ advertise %x[/%x] | mode on|off ... [--] ]\n"
 			  "		[ phyad %d ]\n"
 			  "		[ xcvr internal|external ]\n"
-			  "		[ wol p|u|m|b|a|g|s|f|d... ]\n"
+			  "		[ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
 			  "		[ sopass %x:%x:%x:%x:%x:%x ]\n"
-			  "		[ msglvl %d | msglvl type on|off ... ]\n"
+			  "		[ msglvl %d[/%d] | type on|off ... [--] ]\n"
 	},
 	{
 		.opts	= "-a|--show-pause",
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 8608ea7f51f5..612002e8228b 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -16,6 +16,7 @@ int netlink_init(struct cmd_context *ctx);
 void netlink_done(struct cmd_context *ctx);
 
 int nl_gset(struct cmd_context *ctx);
+int nl_sset(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -36,6 +37,7 @@ static inline void nl_monitor_usage(void)
 }
 
 #define nl_gset			NULL
+#define nl_sset			NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/settings.c b/netlink/settings.c
index 1e43d742245c..c8a911d718b9 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -13,6 +13,7 @@
 #include "netlink.h"
 #include "strset.h"
 #include "bitset.h"
+#include "parser.h"
 
 /* GET_SETTINGS */
 
@@ -760,3 +761,195 @@ int nl_gset(struct cmd_context *ctx)
 
 	return 0;
 }
+
+/* SET_SETTINGS */
+
+enum {
+	WAKE_PHY_BIT		= 0,
+	WAKE_UCAST_BIT		= 1,
+	WAKE_MCAST_BIT		= 2,
+	WAKE_BCAST_BIT		= 3,
+	WAKE_ARP_BIT		= 4,
+	WAKE_MAGIC_BIT		= 5,
+	WAKE_MAGICSECURE_BIT	= 6,
+	WAKE_FILTER_BIT		= 7,
+};
+
+#define WAKE_ALL (WAKE_PHY | WAKE_UCAST | WAKE_MCAST | WAKE_BCAST | WAKE_ARP | \
+		  WAKE_MAGIC | WAKE_MAGICSECURE)
+
+static const struct lookup_entry_u8 port_values[] = {
+	{ .arg = "tp",		.val = PORT_TP },
+	{ .arg = "aui",		.val = PORT_AUI },
+	{ .arg = "mii",		.val = PORT_MII },
+	{ .arg = "fibre",	.val = PORT_FIBRE },
+	{ .arg = "bnc",		.val = PORT_BNC },
+	{ .arg = "da",		.val = PORT_DA },
+	{}
+};
+
+static const struct lookup_entry_u8 mdix_values[] = {
+	{ .arg = "auto",	.val = ETH_TP_MDI_AUTO },
+	{ .arg = "on",		.val = ETH_TP_MDI_X },
+	{ .arg = "off",		.val = ETH_TP_MDI },
+	{}
+};
+
+static const struct error_parser_data xcvr_parser_data = {
+	.err_msg	= "deprecated parameter '%s' not supported by kernel\n",
+	.ret_val	= -EINVAL,
+	.extra_args	= 1,
+};
+
+static const struct lookup_entry_u8 autoneg_values[] = {
+	{ .arg = "off",		.val = AUTONEG_DISABLE },
+	{ .arg = "on",		.val = AUTONEG_ENABLE },
+	{}
+};
+
+static const struct bitset_parser_data advertise_parser_data = {
+	.no_mask	= false,
+	.force_hex	= true,
+};
+
+static const struct lookup_entry_u32 duplex_values[] = {
+	{ .arg = "half",	.val = DUPLEX_HALF },
+	{ .arg = "full",	.val = DUPLEX_FULL },
+	{}
+};
+
+char wol_bit_chars[WOL_MODE_COUNT] = {
+	[WAKE_PHY_BIT]		= 'p',
+	[WAKE_UCAST_BIT]	= 'u',
+	[WAKE_MCAST_BIT]	= 'm',
+	[WAKE_BCAST_BIT]	= 'b',
+	[WAKE_ARP_BIT]		= 'a',
+	[WAKE_MAGIC_BIT]	= 'g',
+	[WAKE_MAGICSECURE_BIT]	= 's',
+	[WAKE_FILTER_BIT]	= 'f',
+};
+
+const struct char_bitset_parser_data wol_parser_data = {
+	.bit_chars	= wol_bit_chars,
+	.nbits		= WOL_MODE_COUNT,
+	.reset_char	= 'd',
+};
+
+const struct byte_str_parser_data sopass_parser_data = {
+	.min_len	= 6,
+	.max_len	= 6,
+	.delim		= ':',
+};
+
+static const struct bitset_parser_data msglvl_parser_data = {
+	.no_mask	= false,
+	.force_hex	= false,
+};
+
+static const struct param_parser sset_params[] = {
+	{
+		.arg		= "port",
+		.group		= ETHTOOL_MSG_LINKINFO_SET,
+		.type		= ETHTOOL_A_LINKINFO_PORT,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= port_values,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "mdix",
+		.group		= ETHTOOL_MSG_LINKINFO_SET,
+		.type		= ETHTOOL_A_LINKINFO_TP_MDIX_CTRL,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= mdix_values,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "phyad",
+		.group		= ETHTOOL_MSG_LINKINFO_SET,
+		.type		= ETHTOOL_A_LINKINFO_PHYADDR,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "xcvr",
+		.group		= ETHTOOL_MSG_LINKINFO_SET,
+		.handler	= nl_parse_error,
+		.handler_data	= &xcvr_parser_data,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "autoneg",
+		.group		= ETHTOOL_MSG_LINKMODES_SET,
+		.type		= ETHTOOL_A_LINKMODES_AUTONEG,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= autoneg_values,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "advertise",
+		.group		= ETHTOOL_MSG_LINKMODES_SET,
+		.type		= ETHTOOL_A_LINKMODES_OURS,
+		.handler	= nl_parse_bitset,
+		.handler_data	= &advertise_parser_data,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "speed",
+		.group		= ETHTOOL_MSG_LINKMODES_SET,
+		.type		= ETHTOOL_A_LINKMODES_SPEED,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "duplex",
+		.group		= ETHTOOL_MSG_LINKMODES_SET,
+		.type		= ETHTOOL_A_LINKMODES_DUPLEX,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= duplex_values,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "wol",
+		.group		= ETHTOOL_MSG_WOL_SET,
+		.type		= ETHTOOL_A_WOL_MODES,
+		.handler	= nl_parse_char_bitset,
+		.handler_data	= &wol_parser_data,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "sopass",
+		.group		= ETHTOOL_MSG_WOL_SET,
+		.type		= ETHTOOL_A_WOL_SOPASS,
+		.handler	= nl_parse_byte_str,
+		.handler_data	= &sopass_parser_data,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "msglvl",
+		.group		= ETHTOOL_MSG_DEBUG_SET,
+		.type		= ETHTOOL_A_DEBUG_MSGMASK,
+		.handler	= nl_parse_bitset,
+		.handler_data	= &msglvl_parser_data,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_sset(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	int ret;
+
+	nlctx->cmd = "-s";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+
+	ret = nl_parser(nlctx, sset_params, NULL, PARSER_GROUP_MSG);
+	if (ret < 0)
+		return 1;
+
+	if (ret == 0)
+		return 0;
+	return nlctx->exit_code ?: 75;
+}
-- 
2.25.1

