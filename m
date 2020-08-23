Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E864124EF89
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgHWTkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:50830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgHWTkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D9AB8AEB1;
        Sun, 23 Aug 2020 19:41:08 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 43F566030D; Sun, 23 Aug 2020 21:40:39 +0200 (CEST)
Message-Id: <0457d46f26350a7ba65c596898069d585c7cd90d.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 8/9] ioctl: convert cmdline_info arrays to named
 initializers
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 23 Aug 2020 21:40:39 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To get rid of remaining "missing field initializer" compiler warnings,
convert arrays of struct cmdline_info used for command line parser to
named initializers. This also makes the initializers easier to read.

This commit should have no effect on resulting code (checked with gcc-11
and -O2).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 ethtool.c | 378 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 296 insertions(+), 82 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 3c30824016d5..e32a93b41088 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1825,10 +1825,24 @@ static int do_spause(struct cmd_context *ctx)
 	int pause_rx_wanted = -1;
 	int pause_tx_wanted = -1;
 	struct cmdline_info cmdline_pause[] = {
-		{ "autoneg", CMDL_BOOL, &pause_autoneg_wanted,
-		  &epause.autoneg },
-		{ "rx", CMDL_BOOL, &pause_rx_wanted, &epause.rx_pause },
-		{ "tx", CMDL_BOOL, &pause_tx_wanted, &epause.tx_pause },
+		{
+			.name		= "autoneg",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &pause_autoneg_wanted,
+			.ioctl_val	= &epause.autoneg,
+		},
+		{
+			.name		= "rx",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &pause_rx_wanted,
+			.ioctl_val	= &epause.rx_pause,
+		},
+		{
+			.name		= "tx",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &pause_tx_wanted,
+			.ioctl_val	= &epause.tx_pause,
+		},
 	};
 	int err, changed = 0;
 
@@ -1868,12 +1882,30 @@ static int do_sring(struct cmd_context *ctx)
 	s32 ring_rx_jumbo_wanted = -1;
 	s32 ring_tx_wanted = -1;
 	struct cmdline_info cmdline_ring[] = {
-		{ "rx", CMDL_S32, &ring_rx_wanted, &ering.rx_pending },
-		{ "rx-mini", CMDL_S32, &ring_rx_mini_wanted,
-		  &ering.rx_mini_pending },
-		{ "rx-jumbo", CMDL_S32, &ring_rx_jumbo_wanted,
-		  &ering.rx_jumbo_pending },
-		{ "tx", CMDL_S32, &ring_tx_wanted, &ering.tx_pending },
+		{
+			.name		= "rx",
+			.type		= CMDL_S32,
+			.wanted_val	= &ring_rx_wanted,
+			.ioctl_val	= &ering.rx_pending,
+		},
+		{
+			.name		= "rx-mini",
+			.type		= CMDL_S32,
+			.wanted_val	= &ring_rx_mini_wanted,
+			.ioctl_val	= &ering.rx_mini_pending,
+		},
+		{
+			.name		= "rx-jumbo",
+			.type		= CMDL_S32,
+			.wanted_val	= &ring_rx_jumbo_wanted,
+			.ioctl_val	= &ering.rx_jumbo_pending,
+		},
+		{
+			.name		= "tx",
+			.type		= CMDL_S32,
+			.wanted_val	= &ring_tx_wanted,
+			.ioctl_val	= &ering.tx_pending,
+		},
 	};
 	int err, changed = 0;
 
@@ -1937,12 +1969,30 @@ static int do_schannels(struct cmd_context *ctx)
 	s32 channels_other_wanted = -1;
 	s32 channels_combined_wanted = -1;
 	struct cmdline_info cmdline_channels[] = {
-		{ "rx", CMDL_S32, &channels_rx_wanted, &echannels.rx_count },
-		{ "tx", CMDL_S32, &channels_tx_wanted, &echannels.tx_count },
-		{ "other", CMDL_S32, &channels_other_wanted,
-		  &echannels.other_count },
-		{ "combined", CMDL_S32, &channels_combined_wanted,
-		  &echannels.combined_count },
+		{
+			.name		= "rx",
+			.type		= CMDL_S32,
+			.wanted_val	= &channels_rx_wanted,
+			.ioctl_val	= &echannels.rx_count,
+		},
+		{
+			.name		= "tx",
+			.type		= CMDL_S32,
+			.wanted_val	= &channels_tx_wanted,
+			.ioctl_val	= &echannels.tx_count,
+		},
+		{
+			.name		= "other",
+			.type		= CMDL_S32,
+			.wanted_val	= &channels_other_wanted,
+			.ioctl_val	= &echannels.other_count,
+		},
+		{
+			.name		= "combined",
+			.type		= CMDL_S32,
+			.wanted_val	= &channels_combined_wanted,
+			.ioctl_val	= &echannels.combined_count,
+		},
 	};
 	int err, changed = 0;
 
@@ -2052,50 +2102,138 @@ static int do_gcoalesce(struct cmd_context *ctx)
 
 #define COALESCE_CMDLINE_INFO(__ecoal)					\
 {									\
-	{ "adaptive-rx", CMDL_BOOL, &coal_adaptive_rx_wanted,		\
-	  &__ecoal.use_adaptive_rx_coalesce },				\
-	{ "adaptive-tx", CMDL_BOOL, &coal_adaptive_tx_wanted,		\
-	  &__ecoal.use_adaptive_tx_coalesce },				\
-	{ "sample-interval", CMDL_S32, &coal_sample_rate_wanted,	\
-	  &__ecoal.rate_sample_interval },				\
-	{ "stats-block-usecs", CMDL_S32, &coal_stats_wanted,		\
-	  &__ecoal.stats_block_coalesce_usecs },			\
-	{ "pkt-rate-low", CMDL_S32, &coal_pkt_rate_low_wanted,		\
-	  &__ecoal.pkt_rate_low },					\
-	{ "pkt-rate-high", CMDL_S32, &coal_pkt_rate_high_wanted,	\
-	  &__ecoal.pkt_rate_high },					\
-	{ "rx-usecs", CMDL_S32, &coal_rx_usec_wanted,			\
-	  &__ecoal.rx_coalesce_usecs },					\
-	{ "rx-frames", CMDL_S32, &coal_rx_frames_wanted,		\
-	  &__ecoal.rx_max_coalesced_frames },				\
-	{ "rx-usecs-irq", CMDL_S32, &coal_rx_usec_irq_wanted,		\
-	  &__ecoal.rx_coalesce_usecs_irq },				\
-	{ "rx-frames-irq", CMDL_S32, &coal_rx_frames_irq_wanted,	\
-	  &__ecoal.rx_max_coalesced_frames_irq },			\
-	{ "tx-usecs", CMDL_S32, &coal_tx_usec_wanted,			\
-	  &__ecoal.tx_coalesce_usecs },					\
-	{ "tx-frames", CMDL_S32, &coal_tx_frames_wanted,		\
-	  &__ecoal.tx_max_coalesced_frames },				\
-	{ "tx-usecs-irq", CMDL_S32, &coal_tx_usec_irq_wanted,		\
-	  &__ecoal.tx_coalesce_usecs_irq },				\
-	{ "tx-frames-irq", CMDL_S32, &coal_tx_frames_irq_wanted,	\
-	  &__ecoal.tx_max_coalesced_frames_irq },			\
-	{ "rx-usecs-low", CMDL_S32, &coal_rx_usec_low_wanted,		\
-	  &__ecoal.rx_coalesce_usecs_low },				\
-	{ "rx-frames-low", CMDL_S32, &coal_rx_frames_low_wanted,	\
-	  &__ecoal.rx_max_coalesced_frames_low },			\
-	{ "tx-usecs-low", CMDL_S32, &coal_tx_usec_low_wanted,		\
-	  &__ecoal.tx_coalesce_usecs_low },				\
-	{ "tx-frames-low", CMDL_S32, &coal_tx_frames_low_wanted,	\
-	  &__ecoal.tx_max_coalesced_frames_low },			\
-	{ "rx-usecs-high", CMDL_S32, &coal_rx_usec_high_wanted,		\
-	  &__ecoal.rx_coalesce_usecs_high },				\
-	{ "rx-frames-high", CMDL_S32, &coal_rx_frames_high_wanted,	\
-	  &__ecoal.rx_max_coalesced_frames_high },			\
-	{ "tx-usecs-high", CMDL_S32, &coal_tx_usec_high_wanted,		\
-	  &__ecoal.tx_coalesce_usecs_high },				\
-	{ "tx-frames-high", CMDL_S32, &coal_tx_frames_high_wanted,	\
-	  &__ecoal.tx_max_coalesced_frames_high },			\
+	{								\
+		.name		= "adaptive-rx",			\
+		.type		= CMDL_BOOL,				\
+		.wanted_val	= &coal_adaptive_rx_wanted,		\
+		.ioctl_val	= &__ecoal.use_adaptive_rx_coalesce,	\
+	},								\
+	{								\
+		.name		= "adaptive-tx",			\
+		.type		= CMDL_BOOL,				\
+		.wanted_val	= &coal_adaptive_tx_wanted,		\
+		.ioctl_val	= &__ecoal.use_adaptive_tx_coalesce,	\
+	},								\
+	{								\
+		.name		= "sample-interval",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_sample_rate_wanted,		\
+		.ioctl_val	= &__ecoal.rate_sample_interval,	\
+	},								\
+	{								\
+		.name		= "stats-block-usecs",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_stats_wanted,			\
+		.ioctl_val	= &__ecoal.stats_block_coalesce_usecs,	\
+	},								\
+	{								\
+		.name		= "pkt-rate-low",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_pkt_rate_low_wanted,		\
+		.ioctl_val	= &__ecoal.pkt_rate_low,		\
+	},								\
+	{								\
+		.name		= "pkt-rate-high",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_pkt_rate_high_wanted,		\
+		.ioctl_val	= &__ecoal.pkt_rate_high,		\
+	},								\
+	{								\
+		.name		= "rx-usecs",				\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_usec_wanted,			\
+		.ioctl_val	= &__ecoal.rx_coalesce_usecs,		\
+	},								\
+	{								\
+		.name		= "rx-frames",				\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_frames_wanted,		\
+		.ioctl_val	= &__ecoal.rx_max_coalesced_frames,	\
+	},								\
+	{								\
+		.name		= "rx-usecs-irq",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_usec_irq_wanted,		\
+		.ioctl_val	= &__ecoal.rx_coalesce_usecs_irq,	\
+	},								\
+	{								\
+		.name		= "rx-frames-irq",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_frames_irq_wanted,		\
+		.ioctl_val	= &__ecoal.rx_max_coalesced_frames_irq,	\
+	},								\
+	{								\
+		.name		= "tx-usecs",				\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_usec_wanted,			\
+		.ioctl_val	= &__ecoal.tx_coalesce_usecs,		\
+	},								\
+	{								\
+		.name		= "tx-frames",				\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_frames_wanted,		\
+		.ioctl_val	= &__ecoal.tx_max_coalesced_frames,	\
+	},								\
+	{								\
+		.name		= "tx-usecs-irq",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_usec_irq_wanted,		\
+		.ioctl_val	= &__ecoal.tx_coalesce_usecs_irq,	\
+	},								\
+	{								\
+		.name		= "tx-frames-irq",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_frames_irq_wanted,		\
+		.ioctl_val	= &__ecoal.tx_max_coalesced_frames_irq,	\
+	},								\
+	{								\
+		.name		= "rx-usecs-low",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_usec_low_wanted,		\
+		.ioctl_val	= &__ecoal.rx_coalesce_usecs_low,	\
+	},								\
+	{								\
+		.name		= "rx-frames-low",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_frames_low_wanted,		\
+		.ioctl_val	= &__ecoal.rx_max_coalesced_frames_low,	\
+	},								\
+	{								\
+		.name		= "tx-usecs-low",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_usec_low_wanted,		\
+		.ioctl_val	= &__ecoal.tx_coalesce_usecs_low,	\
+	},								\
+	{								\
+		.name		= "tx-frames-low",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_frames_low_wanted,		\
+		.ioctl_val	= &__ecoal.tx_max_coalesced_frames_low,	\
+	},								\
+	{								\
+		.name		= "rx-usecs-high",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_usec_high_wanted,		\
+		.ioctl_val	= &__ecoal.rx_coalesce_usecs_high,	\
+	},								\
+	{								\
+		.name		= "rx-frames-high",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_rx_frames_high_wanted,		\
+		.ioctl_val	= &__ecoal.rx_max_coalesced_frames_high,\
+	},								\
+	{								\
+		.name		= "tx-usecs-high",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_usec_high_wanted,		\
+		.ioctl_val	= &__ecoal.tx_coalesce_usecs_high,	\
+	},								\
+	{								\
+		.name		= "tx-frames-high",			\
+		.type		= CMDL_S32,				\
+		.wanted_val	= &coal_tx_frames_high_wanted,		\
+		.ioctl_val	= &__ecoal.tx_max_coalesced_frames_high,\
+	},								\
 }
 
 static int do_scoalesce(struct cmd_context *ctx)
@@ -3090,9 +3228,21 @@ static int do_gregs(struct cmd_context *ctx)
 	int gregs_dump_hex = 0;
 	char *gregs_dump_file = NULL;
 	struct cmdline_info cmdline_gregs[] = {
-		{ "raw", CMDL_BOOL, &gregs_dump_raw, NULL },
-		{ "hex", CMDL_BOOL, &gregs_dump_hex, NULL },
-		{ "file", CMDL_STR, &gregs_dump_file, NULL },
+		{
+			.name		= "raw",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &gregs_dump_raw,
+		},
+		{
+			.name		= "hex",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &gregs_dump_hex,
+		},
+		{
+			.name		= "file",
+			.type		= CMDL_STR,
+			.wanted_val	= &gregs_dump_file,
+		},
 	};
 	int err;
 	struct ethtool_drvinfo drvinfo;
@@ -3189,10 +3339,22 @@ static int do_geeprom(struct cmd_context *ctx)
 	u32 geeprom_length = 0;
 	int geeprom_length_seen = 0;
 	struct cmdline_info cmdline_geeprom[] = {
-		{ "offset", CMDL_U32, &geeprom_offset, NULL },
-		{ "length", CMDL_U32, &geeprom_length, NULL,
-		  0, &geeprom_length_seen },
-		{ "raw", CMDL_BOOL, &geeprom_dump_raw, NULL },
+		{
+			.name		= "offset",
+			.type		= CMDL_U32,
+			.wanted_val	= &geeprom_offset,
+		},
+		{
+			.name		= "length",
+			.type		= CMDL_U32,
+			.wanted_val	= &geeprom_length,
+			.seen_val	= &geeprom_length_seen,
+		},
+		{
+			.name		= "raw",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &geeprom_dump_raw,
+		},
 	};
 	int err;
 	struct ethtool_drvinfo drvinfo;
@@ -3244,12 +3406,28 @@ static int do_seeprom(struct cmd_context *ctx)
 	int seeprom_length_seen = 0;
 	int seeprom_value_seen = 0;
 	struct cmdline_info cmdline_seeprom[] = {
-		{ "magic", CMDL_U32, &seeprom_magic, NULL },
-		{ "offset", CMDL_U32, &seeprom_offset, NULL },
-		{ "length", CMDL_U32, &seeprom_length, NULL,
-		  0, &seeprom_length_seen },
-		{ "value", CMDL_U8, &seeprom_value, NULL,
-		  0, &seeprom_value_seen },
+		{
+			.name		= "magic",
+			.type		= CMDL_U32,
+			.wanted_val	= &seeprom_magic,
+		},
+		{
+			.name		= "offset",
+			.type		= CMDL_U32,
+			.wanted_val	= &seeprom_offset,
+		},
+		{
+			.name		= "length",
+			.type		= CMDL_U32,
+			.wanted_val	= &seeprom_length,
+			.seen_val	= &seeprom_length_seen,
+		},
+		{
+			.name		= "value",
+			.type		= CMDL_U8,
+			.wanted_val	= &seeprom_value,
+			.seen_val	= &seeprom_value_seen,
+		},
 	};
 	int err;
 	struct ethtool_drvinfo drvinfo;
@@ -4553,11 +4731,27 @@ static int do_getmodule(struct cmd_context *ctx)
 	int err;
 
 	struct cmdline_info cmdline_geeprom[] = {
-		{ "offset", CMDL_U32, &geeprom_offset, NULL },
-		{ "length", CMDL_U32, &geeprom_length, NULL,
-		  0, &geeprom_length_seen },
-		{ "raw", CMDL_BOOL, &geeprom_dump_raw, NULL },
-		{ "hex", CMDL_BOOL, &geeprom_dump_hex, NULL },
+		{
+			.name		= "offset",
+			.type		= CMDL_U32,
+			.wanted_val	= &geeprom_offset,
+		},
+		{
+			.name		= "length",
+			.type		= CMDL_U32,
+			.wanted_val	= &geeprom_length,
+			.seen_val	= &geeprom_length_seen,
+		},
+		{
+			.name		= "raw",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &geeprom_dump_raw,
+		},
+		{
+			.name		= "hex",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &geeprom_dump_hex,
+		},
 	};
 
 	parse_generic_cmdline(ctx, &geeprom_changed,
@@ -4669,10 +4863,30 @@ static int do_seee(struct cmd_context *ctx)
 	int change = -1, change2 = 0;
 	struct ethtool_eee eeecmd;
 	struct cmdline_info cmdline_eee[] = {
-		{ "advertise",    CMDL_U32,  &adv_c,       &eeecmd.advertised },
-		{ "tx-lpi",       CMDL_BOOL, &lpi_c,   &eeecmd.tx_lpi_enabled },
-		{ "tx-timer",	  CMDL_U32,  &lpi_time_c, &eeecmd.tx_lpi_timer},
-		{ "eee",	  CMDL_BOOL, &eee_c,	   &eeecmd.eee_enabled},
+		{
+			.name		= "advertise",
+			.type		= CMDL_U32,
+			.wanted_val	= &adv_c,
+			.ioctl_val	= &eeecmd.advertised,
+		},
+		{
+			.name		= "tx-lpi",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &lpi_c,
+			.ioctl_val	= &eeecmd.tx_lpi_enabled,
+		},
+		{
+			.name		= "tx-timer",
+			.type		= CMDL_U32,
+			.wanted_val	= &lpi_time_c,
+			.ioctl_val	= &eeecmd.tx_lpi_timer,
+		},
+		{
+			.name		= "eee",
+			.type		= CMDL_BOOL,
+			.wanted_val	= &eee_c,
+			.ioctl_val	= &eeecmd.eee_enabled,
+		},
 	};
 
 	if (ctx->argc == 0)
-- 
2.28.0

