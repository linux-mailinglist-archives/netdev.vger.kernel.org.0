Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E7C202D90
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 00:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgFUW4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 18:56:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54382 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730792AbgFUW4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 18:56:04 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 08A8A2007BE;
        Mon, 22 Jun 2020 00:56:02 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F05402007B0;
        Mon, 22 Jun 2020 00:56:01 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 81EB720414;
        Mon, 22 Jun 2020 00:56:01 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 7/9] net: dsa: felix: set proper pause frame timers based on link speed
Date:   Mon, 22 Jun 2020 01:54:49 +0300
Message-Id: <20200621225451.12435-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621225451.12435-1-ioana.ciornei@nxp.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

state->speed holds a value of 10, 100, 1000 or 2500, but
SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.

So set the correct speed encoding into this register.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v3:
 * patch added

 drivers/net/dsa/ocelot/felix.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 723d4cb89fdf..98ae8421ef7f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -225,10 +225,25 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
 			   DEV_CLOCK_CFG);
 
-	/* Flow control. Link speed is only used here to evaluate the time
-	 * specification in incoming pause frames.
-	 */
-	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
+	switch (state->speed) {
+	case SPEED_10:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
+		break;
+	case SPEED_100:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
+		break;
+	case SPEED_1000:
+	case SPEED_2500:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
+		break;
+	case SPEED_UNKNOWN:
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(0);
+		break;
+	default:
+		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
+			port, state->speed);
+		return;
+	}
 
 	/* handle Rx pause in all cases, with 2500base-X this is used for rate
 	 * adaptation.
@@ -240,6 +255,10 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
 			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
 			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
+
+	/* Flow control. Link speed is only used here to evaluate the time
+	 * specification in incoming pause frames.
+	 */
 	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-- 
2.25.1

