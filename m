Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BD71AFE82
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgDSWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:04:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49082 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSWEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 18:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pymy6Tl7IZMTWy+LoFuFu0aqyPGomHdWLDj1I22zaUI=; b=0Mz+p927xj94attXHaFA2jwMd5
        6y1QdI/BXY8fS/8XTVw5TfQWt6eR5WUFmVrNjh3RR+AXvAKZT9tDYeRvAU/1tgCJOXfFeHmsGr2Md
        sP8lfNcBrj1g+ckglLiEqZFDAiwefWIwL55KpuQ7WdvQw6AX+d0JS13kIPvJvu+fSoHY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQI2w-003hqp-6J; Mon, 20 Apr 2020 00:04:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: [PATCH net-next v3 2/3] net: ethernet: fec: Allow configuration of MDIO bus speed
Date:   Mon, 20 Apr 2020 00:04:01 +0200
Message-Id: <20200419220402.883493-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200419220402.883493-1-andrew@lunn.ch>
References: <20200419220402.883493-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO busses typically operate at 2.5MHz. However many devices can
operate at faster speeds. This then allows more MDIO transactions per
second, useful for Ethernet switch statistics, or Ethernet PHY TDR
data. Allow the bus speed to be configured, using the standard
"clock-frequency" property, which i2c busses use to indicate the bus
speed. Before using this property, ensure all devices on the bus do
actually support the requested clock speed.

Suggested-by: Chris Healy <Chris.Healy@zii.aero>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt |  1 +
 Documentation/devicetree/bindings/net/mdio.yaml   |  6 ++++++
 drivers/net/ethernet/freescale/fec_main.c         | 11 ++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index ff8b0f211aa1..26c492a2e0e1 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -82,6 +82,7 @@ ethernet@83fec000 {
 	phy-supply = <&reg_fec_supply>;
 	phy-handle = <&ethphy>;
 	mdio {
+	        clock-frequency = <5000000>;
 		ethphy: ethernet-phy@6 {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <6>;
diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index 50c3397a82bc..ab4a9df8b8e2 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -39,6 +39,12 @@ properties:
       and must therefore be appropriately determined based on all PHY
       requirements (maximum value of all per-PHY RESET pulse widths).
 
+  clock-frequency:
+    description:
+      Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
+      defined 2.5MHz should only be used when all devices on the bus support
+      the given clock speed.
+
 patternProperties:
   "^ethernet-phy@[0-9a-f]+$":
     type: object
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2267bf75784e..832a24e2805c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2067,6 +2067,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	struct device_node *node;
 	int err = -ENXIO;
 	u32 mii_speed, holdtime;
+	u32 bus_freq;
 
 	/*
 	 * The i.MX28 dual fec interfaces are not equal.
@@ -2094,15 +2095,20 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
+	bus_freq = 2500000; /* 2.5MHz by default */
+	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+	if (node)
+		of_property_read_u32(node, "clock-frequency", &bus_freq);
+
 	/*
-	 * Set MII speed to 2.5 MHz (= clk_get_rate() / 2 * phy_speed)
+	 * Set MII speed (= clk_get_rate() / 2 * phy_speed)
 	 *
 	 * The formula for FEC MDC is 'ref_freq / (MII_SPEED x 2)' while
 	 * for ENET-MAC is 'ref_freq / ((MII_SPEED + 1) x 2)'.  The i.MX28
 	 * Reference Manual has an error on this, and gets fixed on i.MX6Q
 	 * document.
 	 */
-	mii_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 5000000);
+	mii_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), bus_freq * 2);
 	if (fep->quirks & FEC_QUIRK_ENET_MAC)
 		mii_speed--;
 	if (mii_speed > 63) {
@@ -2148,7 +2154,6 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	fep->mii_bus->priv = fep;
 	fep->mii_bus->parent = &pdev->dev;
 
-	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
 	err = of_mdiobus_register(fep->mii_bus, node);
 	of_node_put(node);
 	if (err)
-- 
2.26.1

