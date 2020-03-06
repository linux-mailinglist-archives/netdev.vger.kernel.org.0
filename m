Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265FC17C37C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCFREY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:04:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:43022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgCFREX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:04:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B5D9B152;
        Fri,  6 Mar 2020 17:04:20 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C9675E00E7; Fri,  6 Mar 2020 18:04:19 +0100 (CET)
Message-Id: <5ac30be11d2b1fd4dacb23b1abbd286a4a3dc0d3.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 04/25] use named initializers in command line
 option list
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:04:19 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The command line option list initialization does not look very nice and
adding another struct member would not make it look any better.

Reformat it to use named initializers. Also replace want_device with (bool)
no_dev as only two options have want_device = 0 so that using an opposite
would allow omitting the initializer for almost all options.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 559 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 358 insertions(+), 201 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index dd0242b27a2f..3186a72644fd 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5288,200 +5288,357 @@ int send_ioctl(struct cmd_context *ctx, void *cmd)
 
 static int show_usage(struct cmd_context *ctx);
 
-static const struct option {
-	const char *opts;
-	int want_device;
-	int (*func)(struct cmd_context *);
-	char *help;
-	char *opthelp;
-} args[] = {
-	{ "-s|--change", 1, do_sset, "Change generic options",
-	  "		[ speed %d ]\n"
-	  "		[ duplex half|full ]\n"
-	  "		[ port tp|aui|bnc|mii|fibre ]\n"
-	  "		[ mdix auto|on|off ]\n"
-	  "		[ autoneg on|off ]\n"
-	  "		[ advertise %x ]\n"
-	  "		[ phyad %d ]\n"
-	  "		[ xcvr internal|external ]\n"
-	  "		[ wol p|u|m|b|a|g|s|f|d... ]\n"
-	  "		[ sopass %x:%x:%x:%x:%x:%x ]\n"
-	  "		[ msglvl %d | msglvl type on|off ... ]\n" },
-	{ "-a|--show-pause", 1, do_gpause, "Show pause options" },
-	{ "-A|--pause", 1, do_spause, "Set pause options",
-	  "		[ autoneg on|off ]\n"
-	  "		[ rx on|off ]\n"
-	  "		[ tx on|off ]\n" },
-	{ "-c|--show-coalesce", 1, do_gcoalesce, "Show coalesce options" },
-	{ "-C|--coalesce", 1, do_scoalesce, "Set coalesce options",
-	  "		[adaptive-rx on|off]\n"
-	  "		[adaptive-tx on|off]\n"
-	  "		[rx-usecs N]\n"
-	  "		[rx-frames N]\n"
-	  "		[rx-usecs-irq N]\n"
-	  "		[rx-frames-irq N]\n"
-	  "		[tx-usecs N]\n"
-	  "		[tx-frames N]\n"
-	  "		[tx-usecs-irq N]\n"
-	  "		[tx-frames-irq N]\n"
-	  "		[stats-block-usecs N]\n"
-	  "		[pkt-rate-low N]\n"
-	  "		[rx-usecs-low N]\n"
-	  "		[rx-frames-low N]\n"
-	  "		[tx-usecs-low N]\n"
-	  "		[tx-frames-low N]\n"
-	  "		[pkt-rate-high N]\n"
-	  "		[rx-usecs-high N]\n"
-	  "		[rx-frames-high N]\n"
-	  "		[tx-usecs-high N]\n"
-	  "		[tx-frames-high N]\n"
-	  "		[sample-interval N]\n" },
-	{ "-g|--show-ring", 1, do_gring, "Query RX/TX ring parameters" },
-	{ "-G|--set-ring", 1, do_sring, "Set RX/TX ring parameters",
-	  "		[ rx N ]\n"
-	  "		[ rx-mini N ]\n"
-	  "		[ rx-jumbo N ]\n"
-	  "		[ tx N ]\n" },
-	{ "-k|--show-features|--show-offload", 1, do_gfeatures,
-	  "Get state of protocol offload and other features" },
-	{ "-K|--features|--offload", 1, do_sfeatures,
-	  "Set protocol offload and other features",
-	  "		FEATURE on|off ...\n" },
-	{ "-i|--driver", 1, do_gdrv, "Show driver information" },
-	{ "-d|--register-dump", 1, do_gregs, "Do a register dump",
-	  "		[ raw on|off ]\n"
-	  "		[ file FILENAME ]\n" },
-	{ "-e|--eeprom-dump", 1, do_geeprom, "Do a EEPROM dump",
-	  "		[ raw on|off ]\n"
-	  "		[ offset N ]\n"
-	  "		[ length N ]\n" },
-	{ "-E|--change-eeprom", 1, do_seeprom,
-	  "Change bytes in device EEPROM",
-	  "		[ magic N ]\n"
-	  "		[ offset N ]\n"
-	  "		[ length N ]\n"
-	  "		[ value N ]\n" },
-	{ "-r|--negotiate", 1, do_nway_rst, "Restart N-WAY negotiation" },
-	{ "-p|--identify", 1, do_phys_id,
-	  "Show visible port identification (e.g. blinking)",
-	  "               [ TIME-IN-SECONDS ]\n" },
-	{ "-t|--test", 1, do_test, "Execute adapter self test",
-	  "               [ online | offline | external_lb ]\n" },
-	{ "-S|--statistics", 1, do_gnicstats, "Show adapter statistics" },
-	{ "--phy-statistics", 1, do_gphystats,
-	  "Show phy statistics" },
-	{ "-n|-u|--show-nfc|--show-ntuple", 1, do_grxclass,
-	  "Show Rx network flow classification options or rules",
-	  "		[ rx-flow-hash tcp4|udp4|ah4|esp4|sctp4|"
-	  "tcp6|udp6|ah6|esp6|sctp6 [context %d] |\n"
-	  "		  rule %d ]\n" },
-	{ "-N|-U|--config-nfc|--config-ntuple", 1, do_srxclass,
-	  "Configure Rx network flow classification options or rules",
-	  "		rx-flow-hash tcp4|udp4|ah4|esp4|sctp4|"
-	  "tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r... [context %d] |\n"
-	  "		flow-type ether|ip4|tcp4|udp4|sctp4|ah4|esp4|"
-	  "ip6|tcp6|udp6|ah6|esp6|sctp6\n"
-	  "			[ src %x:%x:%x:%x:%x:%x [m %x:%x:%x:%x:%x:%x] ]\n"
-	  "			[ dst %x:%x:%x:%x:%x:%x [m %x:%x:%x:%x:%x:%x] ]\n"
-	  "			[ proto %d [m %x] ]\n"
-	  "			[ src-ip IP-ADDRESS [m IP-ADDRESS] ]\n"
-	  "			[ dst-ip IP-ADDRESS [m IP-ADDRESS] ]\n"
-	  "			[ tos %d [m %x] ]\n"
-	  "			[ tclass %d [m %x] ]\n"
-	  "			[ l4proto %d [m %x] ]\n"
-	  "			[ src-port %d [m %x] ]\n"
-	  "			[ dst-port %d [m %x] ]\n"
-	  "			[ spi %d [m %x] ]\n"
-	  "			[ vlan-etype %x [m %x] ]\n"
-	  "			[ vlan %x [m %x] ]\n"
-	  "			[ user-def %x [m %x] ]\n"
-	  "			[ dst-mac %x:%x:%x:%x:%x:%x [m %x:%x:%x:%x:%x:%x] ]\n"
-	  "			[ action %d ] | [ vf %d queue %d ]\n"
-	  "			[ context %d ]\n"
-	  "			[ loc %d]] |\n"
-	  "		delete %d\n" },
-	{ "-T|--show-time-stamping", 1, do_tsinfo,
-	  "Show time stamping capabilities" },
-	{ "-x|--show-rxfh-indir|--show-rxfh", 1, do_grxfh,
-	  "Show Rx flow hash indirection table and/or RSS hash key",
-	  "		[ context %d ]\n" },
-	{ "-X|--set-rxfh-indir|--rxfh", 1, do_srxfh,
-	  "Set Rx flow hash indirection table and/or RSS hash key",
-	  "		[ context %d|new ]\n"
-	  "		[ equal N | weight W0 W1 ... | default ]\n"
-	  "		[ hkey %x:%x:%x:%x:%x:.... ]\n"
-	  "		[ hfunc FUNC ]\n"
-	  "		[ delete ]\n" },
-	{ "-f|--flash", 1, do_flash,
-	  "Flash firmware image from the specified file to a region on the device",
-	  "               FILENAME [ REGION-NUMBER-TO-FLASH ]\n" },
-	{ "-P|--show-permaddr", 1, do_permaddr,
-	  "Show permanent hardware address" },
-	{ "-w|--get-dump", 1, do_getfwdump,
-	  "Get dump flag, data",
-	  "		[ data FILENAME ]\n" },
-	{ "-W|--set-dump", 1, do_setfwdump,
-	  "Set dump flag of the device",
-	  "		N\n"},
-	{ "-l|--show-channels", 1, do_gchannels, "Query Channels" },
-	{ "-L|--set-channels", 1, do_schannels, "Set Channels",
-	  "               [ rx N ]\n"
-	  "               [ tx N ]\n"
-	  "               [ other N ]\n"
-	  "               [ combined N ]\n" },
-	{ "--show-priv-flags", 1, do_gprivflags, "Query private flags" },
-	{ "--set-priv-flags", 1, do_sprivflags, "Set private flags",
-	  "		FLAG on|off ...\n" },
-	{ "-m|--dump-module-eeprom|--module-info", 1, do_getmodule,
-	  "Query/Decode Module EEPROM information and optical diagnostics if available",
-	  "		[ raw on|off ]\n"
-	  "		[ hex on|off ]\n"
-	  "		[ offset N ]\n"
-	  "		[ length N ]\n" },
-	{ "--show-eee", 1, do_geee, "Show EEE settings"},
-	{ "--set-eee", 1, do_seee, "Set EEE settings",
-	  "		[ eee on|off ]\n"
-	  "		[ advertise %x ]\n"
-	  "		[ tx-lpi on|off ]\n"
-	  "		[ tx-timer %d ]\n"},
-	{ "--set-phy-tunable", 1, do_set_phy_tunable, "Set PHY tunable",
-	  "		[ downshift on|off [count N] ]\n"
-	  "		[ fast-link-down on|off [msecs N] ]\n"
-	  "		[ energy-detect-power-down on|off [msecs N] ]\n"},
-	{ "--get-phy-tunable", 1, do_get_phy_tunable, "Get PHY tunable",
-	  "		[ downshift ]\n"
-	  "		[ fast-link-down ]\n"
-	  "		[ energy-detect-power-down ]\n"},
-	{ "--reset", 1, do_reset, "Reset components",
-	  "		[ flags %x ]\n"
-	  "		[ mgmt ]\n"
-	  "		[ mgmt-shared ]\n"
-	  "		[ irq ]\n"
-	  "		[ irq-shared ]\n"
-	  "		[ dma ]\n"
-	  "		[ dma-shared ]\n"
-	  "		[ filter ]\n"
-	  "		[ filter-shared ]\n"
-	  "		[ offload ]\n"
-	  "		[ offload-shared ]\n"
-	  "		[ mac ]\n"
-	  "		[ mac-shared ]\n"
-	  "		[ phy ]\n"
-	  "		[ phy-shared ]\n"
-	  "		[ ram ]\n"
-	  "		[ ram-shared ]\n"
-	  "		[ ap ]\n"
-	  "		[ ap-shared ]\n"
-	  "		[ dedicated ]\n"
-	  "		[ all ]\n"},
-	{ "--show-fec", 1, do_gfec, "Show FEC settings"},
-	{ "--set-fec", 1, do_sfec, "Set FEC settings",
-	  "		[ encoding auto|off|rs|baser [...]]\n"},
-	{ "-Q|--per-queue", 1, do_perqueue, "Apply per-queue command."
-	  "The supported sub commands include --show-coalesce, --coalesce",
-	  "             [queue_mask %x] SUB_COMMAND\n"},
-	{ "-h|--help", 0, show_usage, "Show this help" },
-	{ "--version", 0, do_version, "Show version number" },
+struct option {
+	const char	*opts;
+	bool		no_dev;
+	int		(*func)(struct cmd_context *);
+	const char	*help;
+	const char	*xhelp;
+};
+
+static const struct option args[] = {
+	{
+		.opts	= "-s|--change",
+		.func	= do_sset,
+		.help	= "Change generic options",
+		.xhelp	= "		[ speed %d ]\n"
+			  "		[ duplex half|full ]\n"
+			  "		[ port tp|aui|bnc|mii|fibre ]\n"
+			  "		[ mdix auto|on|off ]\n"
+			  "		[ autoneg on|off ]\n"
+			  "		[ advertise %x ]\n"
+			  "		[ phyad %d ]\n"
+			  "		[ xcvr internal|external ]\n"
+			  "		[ wol p|u|m|b|a|g|s|f|d... ]\n"
+			  "		[ sopass %x:%x:%x:%x:%x:%x ]\n"
+			  "		[ msglvl %d | msglvl type on|off ... ]\n"
+	},
+	{
+		.opts	= "-a|--show-pause",
+		.func	= do_gpause,
+		.help	= "Show pause options"
+	},
+	{
+		.opts	= "-A|--pause",
+		.func	= do_spause,
+		.help	= "Set pause options",
+		.xhelp	= "		[ autoneg on|off ]\n"
+			  "		[ rx on|off ]\n"
+			  "		[ tx on|off ]\n"
+	},
+	{
+		.opts	= "-c|--show-coalesce",
+		.func	= do_gcoalesce,
+		.help	= "Show coalesce options"
+	},
+	{
+		.opts	= "-C|--coalesce",
+		.func	= do_scoalesce,
+		.help	= "Set coalesce options",
+		.xhelp	= "		[adaptive-rx on|off]\n"
+			  "		[adaptive-tx on|off]\n"
+			  "		[rx-usecs N]\n"
+			  "		[rx-frames N]\n"
+			  "		[rx-usecs-irq N]\n"
+			  "		[rx-frames-irq N]\n"
+			  "		[tx-usecs N]\n"
+			  "		[tx-frames N]\n"
+			  "		[tx-usecs-irq N]\n"
+			  "		[tx-frames-irq N]\n"
+			  "		[stats-block-usecs N]\n"
+			  "		[pkt-rate-low N]\n"
+			  "		[rx-usecs-low N]\n"
+			  "		[rx-frames-low N]\n"
+			  "		[tx-usecs-low N]\n"
+			  "		[tx-frames-low N]\n"
+			  "		[pkt-rate-high N]\n"
+			  "		[rx-usecs-high N]\n"
+			  "		[rx-frames-high N]\n"
+			  "		[tx-usecs-high N]\n"
+			  "		[tx-frames-high N]\n"
+			  "		[sample-interval N]\n"
+	},
+	{
+		.opts	= "-g|--show-ring",
+		.func	= do_gring,
+		.help	= "Query RX/TX ring parameters"
+	},
+	{
+		.opts	= "-G|--set-ring",
+		.func	= do_sring,
+		.help	= "Set RX/TX ring parameters",
+		.xhelp	= "		[ rx N ]\n"
+			  "		[ rx-mini N ]\n"
+			  "		[ rx-jumbo N ]\n"
+			  "		[ tx N ]\n"
+	},
+	{
+		.opts	= "-k|--show-features|--show-offload",
+		.func	= do_gfeatures,
+		.help	= "Get state of protocol offload and other features"
+	},
+	{
+		.opts	= "-K|--features|--offload",
+		.func	= do_sfeatures,
+		.help	= "Set protocol offload and other features",
+		.xhelp	= "		FEATURE on|off ...\n"
+	},
+	{
+		.opts	= "-i|--driver",
+		.func	= do_gdrv,
+		.help	= "Show driver information"
+	},
+	{
+		.opts	= "-d|--register-dump",
+		.func	= do_gregs,
+		.help	= "Do a register dump",
+		.xhelp	= "		[ raw on|off ]\n"
+			  "		[ file FILENAME ]\n"
+	},
+	{
+		.opts	= "-e|--eeprom-dump",
+		.func	= do_geeprom,
+		.help	= "Do a EEPROM dump",
+		.xhelp	= "		[ raw on|off ]\n"
+			  "		[ offset N ]\n"
+			  "		[ length N ]\n"
+	},
+	{
+		.opts	= "-E|--change-eeprom",
+		.func	= do_seeprom,
+		.help	= "Change bytes in device EEPROM",
+		.xhelp	= "		[ magic N ]\n"
+			  "		[ offset N ]\n"
+			  "		[ length N ]\n"
+			  "		[ value N ]\n"
+	},
+	{
+		.opts	= "-r|--negotiate",
+		.func	= do_nway_rst,
+		.help	= "Restart N-WAY negotiation"
+	},
+	{
+		.opts	= "-p|--identify",
+		.func	= do_phys_id,
+		.help	= "Show visible port identification (e.g. blinking)",
+		.xhelp	= "               [ TIME-IN-SECONDS ]\n"
+	},
+	{
+		.opts	= "-t|--test",
+		.func	= do_test,
+		.help	= "Execute adapter self test",
+		.xhelp	= "               [ online | offline | external_lb ]\n"
+	},
+	{
+		.opts	= "-S|--statistics",
+		.func	= do_gnicstats,
+		.help	= "Show adapter statistics"
+	},
+	{
+		.opts	= "--phy-statistics",
+		.func	= do_gphystats,
+		.help	= "Show phy statistics"
+	},
+	{
+		.opts	= "-n|-u|--show-nfc|--show-ntuple",
+		.func	= do_grxclass,
+		.help	= "Show Rx network flow classification options or rules",
+		.xhelp	= "		[ rx-flow-hash tcp4|udp4|ah4|esp4|sctp4|"
+			  "tcp6|udp6|ah6|esp6|sctp6 [context %d] |\n"
+			  "		  rule %d ]\n"
+	},
+	{
+		.opts	= "-N|-U|--config-nfc|--config-ntuple",
+		.func	= do_srxclass,
+		.help	= "Configure Rx network flow classification options or rules",
+		.xhelp	= "		rx-flow-hash tcp4|udp4|ah4|esp4|sctp4|"
+			  "tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r... [context %d] |\n"
+			  "		flow-type ether|ip4|tcp4|udp4|sctp4|ah4|esp4|"
+			  "ip6|tcp6|udp6|ah6|esp6|sctp6\n"
+			  "			[ src %x:%x:%x:%x:%x:%x [m %x:%x:%x:%x:%x:%x] ]\n"
+			  "			[ dst %x:%x:%x:%x:%x:%x [m %x:%x:%x:%x:%x:%x] ]\n"
+			  "			[ proto %d [m %x] ]\n"
+			  "			[ src-ip IP-ADDRESS [m IP-ADDRESS] ]\n"
+			  "			[ dst-ip IP-ADDRESS [m IP-ADDRESS] ]\n"
+			  "			[ tos %d [m %x] ]\n"
+			  "			[ tclass %d [m %x] ]\n"
+			  "			[ l4proto %d [m %x] ]\n"
+			  "			[ src-port %d [m %x] ]\n"
+			  "			[ dst-port %d [m %x] ]\n"
+			  "			[ spi %d [m %x] ]\n"
+			  "			[ vlan-etype %x [m %x] ]\n"
+			  "			[ vlan %x [m %x] ]\n"
+			  "			[ user-def %x [m %x] ]\n"
+			  "			[ dst-mac %x:%x:%x:%x:%x:%x [m %x:%x:%x:%x:%x:%x] ]\n"
+			  "			[ action %d ] | [ vf %d queue %d ]\n"
+			  "			[ context %d ]\n"
+			  "			[ loc %d]] |\n"
+			  "		delete %d\n"
+	},
+	{
+		.opts	= "-T|--show-time-stamping",
+		.func	= do_tsinfo,
+		.help	= "Show time stamping capabilities"
+	},
+	{
+		.opts	= "-x|--show-rxfh-indir|--show-rxfh",
+		.func	= do_grxfh,
+		.help	= "Show Rx flow hash indirection table and/or RSS hash key",
+		.xhelp	= "		[ context %d ]\n"
+	},
+	{
+		.opts	= "-X|--set-rxfh-indir|--rxfh",
+		.func	= do_srxfh,
+		.help	= "Set Rx flow hash indirection table and/or RSS hash key",
+		.xhelp	= "		[ context %d|new ]\n"
+			  "		[ equal N | weight W0 W1 ... | default ]\n"
+			  "		[ hkey %x:%x:%x:%x:%x:.... ]\n"
+			  "		[ hfunc FUNC ]\n"
+			  "		[ delete ]\n"
+	},
+	{
+		.opts	= "-f|--flash",
+		.func	= do_flash,
+		.help	= "Flash firmware image from the specified file to a region on the device",
+		.xhelp	= "               FILENAME [ REGION-NUMBER-TO-FLASH ]\n"
+	},
+	{
+		.opts	= "-P|--show-permaddr",
+		.func	= do_permaddr,
+		.help	= "Show permanent hardware address"
+	},
+	{
+		.opts	= "-w|--get-dump",
+		.func	= do_getfwdump,
+		.help	= "Get dump flag, data",
+		.xhelp	= "		[ data FILENAME ]\n"
+	},
+	{
+		.opts	= "-W|--set-dump",
+		.func	= do_setfwdump,
+		.help	= "Set dump flag of the device",
+		.xhelp	= "		N\n"
+	},
+	{
+		.opts	= "-l|--show-channels",
+		.func	= do_gchannels,
+		.help	= "Query Channels"
+	},
+	{
+		.opts	= "-L|--set-channels",
+		.func	= do_schannels,
+		.help	= "Set Channels",
+		.xhelp	= "               [ rx N ]\n"
+			  "               [ tx N ]\n"
+			  "               [ other N ]\n"
+			  "               [ combined N ]\n"
+	},
+	{
+		.opts	= "--show-priv-flags",
+		.func	= do_gprivflags,
+		.help	= "Query private flags"
+	},
+	{
+		.opts	= "--set-priv-flags",
+		.func	= do_sprivflags,
+		.help	= "Set private flags",
+		.xhelp	= "		FLAG on|off ...\n"
+	},
+	{
+		.opts	= "-m|--dump-module-eeprom|--module-info",
+		.func	= do_getmodule,
+		.help	= "Query/Decode Module EEPROM information and optical diagnostics if available",
+		.xhelp	= "		[ raw on|off ]\n"
+			  "		[ hex on|off ]\n"
+			  "		[ offset N ]\n"
+			  "		[ length N ]\n"
+	},
+	{
+		.opts	= "--show-eee",
+		.func	= do_geee,
+		.help	= "Show EEE settings",
+	},
+	{
+		.opts	= "--set-eee",
+		.func	= do_seee,
+		.help	= "Set EEE settings",
+		.xhelp	= "		[ eee on|off ]\n"
+			  "		[ advertise %x ]\n"
+			  "		[ tx-lpi on|off ]\n"
+			  "		[ tx-timer %d ]\n"
+	},
+	{
+		.opts	= "--set-phy-tunable",
+		.func	= do_set_phy_tunable,
+		.help	= "Set PHY tunable",
+		.xhelp	= "		[ downshift on|off [count N] ]\n"
+			  "		[ fast-link-down on|off [msecs N] ]\n"
+			  "		[ energy-detect-power-down on|off [msecs N] ]\n"
+	},
+	{
+		.opts	= "--get-phy-tunable",
+		.func	= do_get_phy_tunable,
+		.help	= "Get PHY tunable",
+		.xhelp	= "		[ downshift ]\n"
+			  "		[ fast-link-down ]\n"
+			  "		[ energy-detect-power-down ]\n"
+	},
+	{
+		.opts	= "--reset",
+		.func	= do_reset,
+		.help	= "Reset components",
+		.xhelp	= "		[ flags %x ]\n"
+			  "		[ mgmt ]\n"
+			  "		[ mgmt-shared ]\n"
+			  "		[ irq ]\n"
+			  "		[ irq-shared ]\n"
+			  "		[ dma ]\n"
+			  "		[ dma-shared ]\n"
+			  "		[ filter ]\n"
+			  "		[ filter-shared ]\n"
+			  "		[ offload ]\n"
+			  "		[ offload-shared ]\n"
+			  "		[ mac ]\n"
+			  "		[ mac-shared ]\n"
+			  "		[ phy ]\n"
+			  "		[ phy-shared ]\n"
+			  "		[ ram ]\n"
+			  "		[ ram-shared ]\n"
+			  "		[ ap ]\n"
+			  "		[ ap-shared ]\n"
+			  "		[ dedicated ]\n"
+			  "		[ all ]\n"
+	},
+	{
+		.opts	= "--show-fec",
+		.func	= do_gfec,
+		.help	= "Show FEC settings",
+	},
+	{
+		.opts	= "--set-fec",
+		.func	= do_sfec,
+		.help	= "Set FEC settings",
+		.xhelp	= "		[ encoding auto|off|rs|baser [...]]\n"
+	},
+	{
+		.opts	= "-Q|--per-queue",
+		.func	= do_perqueue,
+		.help	= "Apply per-queue command. ",
+		.xhelp	= "The supported sub commands include --show-coalesce, --coalesce"
+			  "             [queue_mask %x] SUB_COMMAND\n",
+	},
+	{
+		.opts	= "-h|--help",
+		.no_dev	= true,
+		.func	= show_usage,
+		.help	= "Show this help"
+	},
+	{
+		.opts	= "--version",
+		.no_dev	= true,
+		.func	= do_version,
+		.help	= "Show version number"
+	},
 	{}
 };
 
@@ -5499,10 +5656,10 @@ static int show_usage(struct cmd_context *ctx maybe_unused)
 		fputs("        ethtool [ --debug MASK ] ", stdout);
 		fprintf(stdout, "%s %s\t%s\n",
 			args[i].opts,
-			args[i].want_device ? "DEVNAME" : "\t",
+			args[i].no_dev ? "\t" : "DEVNAME",
 			args[i].help);
-		if (args[i].opthelp)
-			fputs(args[i].opthelp, stdout);
+		if (args[i].xhelp)
+			fputs(args[i].xhelp, stdout);
 	}
 
 	return 0;
@@ -5702,8 +5859,8 @@ static int do_perqueue(struct cmd_context *ctx)
 int main(int argc, char **argp)
 {
 	int (*func)(struct cmd_context *);
-	int want_device;
 	struct cmd_context ctx;
+	bool no_dev;
 	int k;
 
 	init_global_link_mode_masks();
@@ -5738,16 +5895,16 @@ int main(int argc, char **argp)
 		argp++;
 		argc--;
 		func = args[k].func;
-		want_device = args[k].want_device;
+		no_dev = args[k].no_dev;
 		goto opt_found;
 	}
 	if ((*argp)[0] == '-')
 		exit_bad_args();
 	func = do_gset;
-	want_device = 1;
+	no_dev = false;
 
 opt_found:
-	if (want_device) {
+	if (!no_dev) {
 		ctx.devname = *argp++;
 		argc--;
 
-- 
2.25.1

