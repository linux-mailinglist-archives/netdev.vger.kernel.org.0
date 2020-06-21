Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F93202D8E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 00:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbgFUW4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 18:56:06 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36572 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgFUW4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 18:56:03 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F0DE1A08BB;
        Mon, 22 Jun 2020 00:56:01 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 729CF1A08B9;
        Mon, 22 Jun 2020 00:56:01 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 038CE20414;
        Mon, 22 Jun 2020 00:56:00 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 6/9] net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
Date:   Mon, 22 Jun 2020 01:54:48 +0300
Message-Id: <20200621225451.12435-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621225451.12435-1-ioana.ciornei@nxp.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In VSC9959, the PCS is the one who performs rate adaptation (symbol
duplication) to the speed negotiated by the PHY. The MAC is unaware of
that and must remain configured for gigabit. If it is configured at
OCELOT_SPEED_10 or OCELOT_SPEED_100, it'll start transmitting PAUSE
frames out of control and never recover, _even if_ we then reconfigure
it at OCELOT_SPEED_1000 afterwards.

This patch fixes a bug that luckily did not have any functional impact.
We were writing 10, 100, 1000 etc into this 2-bit field in
DEV_CLOCK_CFG, but the hardware expects values in the range 0, 1, 2, 3.
So all speed values were getting truncated to 0, which is
OCELOT_SPEED_2500, and which also appears to be fine.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v3:
 * patch added

 drivers/net/dsa/ocelot/felix.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 66648986e6e3..723d4cb89fdf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -215,9 +215,14 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	u32 mac_fc_cfg;
 
 	/* Take port out of reset by clearing the MAC_TX_RST, MAC_RX_RST and
-	 * PORT_RST bits in CLOCK_CFG
+	 * PORT_RST bits in DEV_CLOCK_CFG. Note that the way this system is
+	 * integrated is that the MAC speed is fixed and it's the PCS who is
+	 * performing the rate adaptation, so we have to write "1000Mbps" into
+	 * the LINK_SPEED field of DEV_CLOCK_CFG (which is also its default
+	 * value).
 	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(state->speed),
+	ocelot_port_writel(ocelot_port,
+			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
 	/* Flow control. Link speed is only used here to evaluate the time
-- 
2.25.1

