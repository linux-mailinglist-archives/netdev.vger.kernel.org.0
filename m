Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42E7108B4F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKYKDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:03:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57825 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfKYKDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:03:08 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iZBCw-0004HW-Ku; Mon, 25 Nov 2019 11:03:02 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iZBCu-0001Qe-Og; Mon, 25 Nov 2019 11:03:00 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@protonic.nl
Subject: [PATCH v1 2/2] net: dsa: sja1105: fix sja1105_parse_rgmii_delays()
Date:   Mon, 25 Nov 2019 11:02:59 +0100
Message-Id: <20191125100259.5147-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191125100259.5147-1-o.rempel@pengutronix.de>
References: <20191125100259.5147-1-o.rempel@pengutronix.de>
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

This function was using configuration of port 0 in devicetree for all ports.
In case CPU port was not 0, the delay settings was ignored. This resulted not
working communication between CPU and the switch.

Fixes: f5b8631c293b ("net: dsa: sja1105: Error out if RGMII delays are requested in DT")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1238fd68b2cd..34544b1c30dc 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -594,15 +594,15 @@ static int sja1105_parse_rgmii_delays(struct sja1105_private *priv,
 	int i;
 
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		if (ports->role == XMII_MAC)
+		if (ports[i].role == XMII_MAC)
 			continue;
 
-		if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
-		    ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+		if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
 			priv->rgmii_rx_delay[i] = true;
 
-		if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
-		    ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+		if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
 			priv->rgmii_tx_delay[i] = true;
 
 		if ((priv->rgmii_rx_delay[i] || priv->rgmii_tx_delay[i]) &&
-- 
2.24.0

