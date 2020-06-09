Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8FF1F364E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 10:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgFIIro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 04:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgFIIrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 04:47:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF55C03E97C
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 01:47:41 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiZun-0008CC-4X; Tue, 09 Jun 2020 10:47:25 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jiZuh-0003gj-Dr; Tue, 09 Jun 2020 10:47:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH v3 2/3] netlink: add master/slave configuration support
Date:   Tue,  9 Jun 2020 10:47:17 +0200
Message-Id: <20200609084718.14110-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609084718.14110-1-o.rempel@pengutronix.de>
References: <20200609084718.14110-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
auto-negotiation support, we needed to be able to configure the
MASTER-SLAVE role of the port manually or from an application in user
space.

The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
force MASTER or SLAVE role. See IEEE 802.3-2018:
22.2.4.3.7 MASTER-SLAVE control register (Register 9)
22.2.4.3.8 MASTER-SLAVE status register (Register 10)
40.5.2 MASTER-SLAVE configuration resolution
45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)

The MASTER-SLAVE role affects the clock configuration:

-------------------------------------------------------------------------------
When the  PHY is configured as MASTER, the PMA Transmit function shall
source TX_TCLK from a local clock source. When configured as SLAVE, the
PMA Transmit function shall source TX_TCLK from the clock recovered from
data stream provided by MASTER.

iMX6Q                     KSZ9031                XXX
------\                /-----------\        /------------\
      |                |           |        |            |
 MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
      |<--- 125 MHz ---+-<------/  |        | \          |
------/                \-----------/        \------------/
                                               ^
                                                \-TX_TCLK

-------------------------------------------------------------------------------

Since some clock or link related issues are only reproducible in a
specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
to provide generic (not 100BASE-T1 specific) interface to the user space
for configuration flexibility and trouble shooting.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 ethtool.8.in           | 19 ++++++++++++++++
 ethtool.c              |  1 +
 netlink/desc-ethtool.c |  2 ++
 netlink/settings.c     | 50 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index f8b09e0..dca7c7a 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -52,6 +52,10 @@
 .\"
 .ds MA \fIxx\fP\fB:\fP\fIyy\fP\fB:\fP\fIzz\fP\fB:\fP\fIaa\fP\fB:\fP\fIbb\fP\fB:\fP\fIcc\fP
 .\"
+.\"	\(*MS - master-slave property
+.\"
+.ds MS \fBpreferred-master\fP|\fBpreferred-slave\fP|\fBforced-master\fP|\fBforced-slave\fP
+.\"
 .\"	\(*PA - IP address
 .\"
 .ds PA \fIip-address\fP
@@ -255,6 +259,7 @@ ethtool \- query or control network driver and hardware settings
 .RB [ wol \ \fIN\fP[\fB/\fP\fIM\fP]
 .RB | \ wol \ \*(WO]
 .RB [ sopass \ \*(MA]
+.RB [ master-slave \ \*(MS]
 .RB [ msglvl
 .IR N\fP[/\fIM\fP] \ |
 .BI msglvl \ type
@@ -646,6 +651,20 @@ Sets full or half duplex mode.
 .A4 port tp aui bnc mii fibre da
 Selects device port.
 .TP
+.BR master-slave \ \*(MS
+Configure MASTER/SLAVE role of the PHY. When the PHY is configured as MASTER,
+the PMA Transmit function shall source TX_TCLK from a local clock source. When
+configured as SLAVE, the PMA Transmit function shall source TX_TCLK from the
+clock recovered from data stream provided by MASTER. Not all devices support this.
+.TS
+nokeep;
+lB	l.
+preferred-master Prefer MASTER role on autonegotiation
+preferred-slave	 Prefer SLAVE role on autonegotiation
+forced-master    Force the PHY in MASTER role. Can be used without autonegotiation
+forced-slave     Force the PHY in SLAVE role. Can be used without autonegotiation
+.TE
+.TP
 .A3 mdix auto on off
 Selects MDI-X mode for port. May be used to override the automatic
 detection feature of most adapters. An argument of \fBauto\fR means
diff --git a/ethtool.c b/ethtool.c
index 900880a..a6e9bfc 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5196,6 +5196,7 @@ static const struct option args[] = {
 			  "		[ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
 			  "		[ sopass %x:%x:%x:%x:%x:%x ]\n"
 			  "		[ msglvl %d[/%d] | type on|off ... [--] ]\n"
+			  "		[ master-slave master-preferred|slave-preferred|master-force|slave-force ]\n"
 	},
 	{
 		.opts	= "-a|--show-pause",
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 76c6f13..b0a793c 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -85,6 +85,8 @@ static const struct pretty_nla_desc __linkmodes_desc[] = {
 	NLATTR_DESC_NESTED(ETHTOOL_A_LINKMODES_PEER, bitset),
 	NLATTR_DESC_U32(ETHTOOL_A_LINKMODES_SPEED),
 	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_DUPLEX),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE),
 };
 
 static const struct pretty_nla_desc __linkstate_desc[] = {
diff --git a/netlink/settings.c b/netlink/settings.c
index 8be5a22..3a5a237 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -37,6 +37,21 @@ static const char *const names_duplex[] = {
 	[DUPLEX_FULL]		= "Full",
 };
 
+static const char *const names_master_slave_state[] = {
+	[MASTER_SLAVE_STATE_UNKNOWN]	= "unknown",
+	[MASTER_SLAVE_STATE_MASTER]	= "master",
+	[MASTER_SLAVE_STATE_SLAVE]	= "slave",
+	[MASTER_SLAVE_STATE_ERR]	= "resolution error",
+};
+
+static const char *const names_master_slave_cfg[] = {
+	[MASTER_SLAVE_CFG_UNKNOWN]		= "unknown",
+	[MASTER_SLAVE_CFG_MASTER_PREFERRED]	= "preferred master",
+	[MASTER_SLAVE_CFG_SLAVE_PREFERRED]	= "preferred slave",
+	[MASTER_SLAVE_CFG_MASTER_FORCE]		= "forced master",
+	[MASTER_SLAVE_CFG_SLAVE_FORCE]		= "forced slave",
+};
+
 static const char *const names_port[] = {
 	[PORT_TP]		= "Twisted Pair",
 	[PORT_AUI]		= "AUI",
@@ -520,6 +535,25 @@ int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		printf("\tAuto-negotiation: %s\n",
 		       (autoneg == AUTONEG_DISABLE) ? "off" : "on");
 	}
+	if (tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]) {
+		uint8_t val;
+
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]);
+
+		print_banner(nlctx);
+		print_enum(names_master_slave_cfg,
+			   ARRAY_SIZE(names_master_slave_cfg), val,
+			   "master-slave cfg");
+	}
+	if (tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE]) {
+		uint8_t val;
+
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE]);
+		print_banner(nlctx);
+		print_enum(names_master_slave_state,
+			   ARRAY_SIZE(names_master_slave_state), val,
+			   "master-slave status");
+	}
 
 	return MNL_CB_OK;
 err:
@@ -827,6 +861,14 @@ static const struct lookup_entry_u32 duplex_values[] = {
 	{}
 };
 
+static const struct lookup_entry_u8 master_slave_values[] = {
+	{ .arg = "preferred-master", .val = MASTER_SLAVE_CFG_MASTER_PREFERRED },
+	{ .arg = "preferred-slave",  .val = MASTER_SLAVE_CFG_SLAVE_PREFERRED },
+	{ .arg = "forced-master",    .val = MASTER_SLAVE_CFG_MASTER_FORCE },
+	{ .arg = "forced-slave",     .val = MASTER_SLAVE_CFG_SLAVE_FORCE },
+	{}
+};
+
 char wol_bit_chars[WOL_MODE_COUNT] = {
 	[WAKE_PHY_BIT]		= 'p',
 	[WAKE_UCAST_BIT]	= 'u',
@@ -917,6 +959,14 @@ static const struct param_parser sset_params[] = {
 		.handler_data	= duplex_values,
 		.min_argc	= 1,
 	},
+	{
+		.arg		= "master-slave",
+		.group		= ETHTOOL_MSG_LINKMODES_SET,
+		.type		= ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= master_slave_values,
+		.min_argc	= 1,
+	},
 	{
 		.arg		= "wol",
 		.group		= ETHTOOL_MSG_WOL_SET,
-- 
2.27.0

