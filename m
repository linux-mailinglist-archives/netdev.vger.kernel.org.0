Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5781E21F010
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGNMIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:08:44 -0400
Received: from mail.intenta.de ([178.249.25.132]:38259 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgGNMIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 08:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=zln4hxZBPKBJeOUEje0k20V2f5G6rG4rAoe1m3aL+eI=;
        b=fW+syt96bwKz945+di9iKOrbGSelnfe/4x0AZQedolC13C3jW1Ox9Y7mUAWgYufBbP9HU2LgEX+2TxuVwDa1rKeNACezI+nI+JTUYCaTECJovN2P1YqPtYnfsMtFQwdDu8FiCB1Yb+jHJrxWHNzc8qevCJ+17OoORPyiBfOfZcSggUKIRppqoObnFO6EDdUt3o3hLZG1o0ZMe6Liop12tb2sH7WBuvDT+TX10ajS4hNXakvDbvgwe/77jBCKCVnk3fCoOMq2gFG3GtJmvxs+AUTxCXDyq7q9pEbUzOtEc2R8HjxOcTp2nJZrBTzhc6Ef3cVqm061U3g896pQhV085g==;
Date:   Tue, 14 Jul 2020 14:08:28 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200714120827.GA7939@laureti-dev>
References: <20200617082235.GA1523@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200617082235.GA1523@laureti-dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/devicetree/bindings/net/dsa/dsa.txt says that the phy-mode
property should be specified on port nodes. However, the microchip
drivers read it from the switch node.

Let the driver use the per-port property and fall back to the old
location with a warning.

Fix in-tree users.

Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
Link: https://lore.kernel.org/netdev/20200617082235.GA1523@laureti-dev/
---
 arch/arm/boot/dts/at91-sama5d2_icp.dts |  2 +-
 drivers/net/dsa/microchip/ksz8795.c    | 17 +++++++++++-----
 drivers/net/dsa/microchip/ksz9477.c    | 28 +++++++++++++++++---------
 drivers/net/dsa/microchip/ksz_common.c | 13 +++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |  3 ++-
 5 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index 8d19925fc09e..6783cf16ff81 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -116,7 +116,6 @@
 		switch0: ksz8563@0 {
 			compatible = "microchip,ksz8563";
 			reg = <0>;
-			phy-mode = "mii";
 			reset-gpios = <&pioA PIN_PD4 GPIO_ACTIVE_LOW>;
 
 			spi-max-frequency = <500000>;
@@ -140,6 +139,7 @@
 					reg = <2>;
 					label = "cpu";
 					ethernet = <&macb0>;
+					phy-mode = "mii";
 					fixed-link {
 						speed = <100>;
 						full-duplex;
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7c17b0f705ec..01c03205db53 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -941,11 +941,18 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
 
 	if (cpu_port) {
+		if (!p->interface && dev->compat_interface) {
+			dev_warn(dev->dev,
+				 "Using legacy switch \"phy-mode\" missing on port %d node. Please update your device tree.\n",
+				 port);
+			p->interface = dev->compat_interface;
+		}
+
 		/* Configure MII interface for proper network communication. */
 		ksz_read8(dev, REG_PORT_5_CTRL_6, &data8);
 		data8 &= ~PORT_INTERFACE_TYPE;
 		data8 &= ~PORT_GMII_1GPS_MODE;
-		switch (dev->interface) {
+		switch (p->interface) {
 		case PHY_INTERFACE_MODE_MII:
 			p->phydev.speed = SPEED_100;
 			break;
@@ -961,11 +968,11 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		default:
 			data8 &= ~PORT_RGMII_ID_IN_ENABLE;
 			data8 &= ~PORT_RGMII_ID_OUT_ENABLE;
-			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    dev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
 				data8 |= PORT_RGMII_ID_IN_ENABLE;
-			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    dev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 				data8 |= PORT_RGMII_ID_OUT_ENABLE;
 			data8 |= PORT_GMII_1GPS_MODE;
 			data8 |= PORT_INTERFACE_RGMII;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8d15c3016024..06c76948814b 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1234,7 +1234,7 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 
 		/* configure MAC to 1G & RGMII mode */
 		ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
-		switch (dev->interface) {
+		switch (p->interface) {
 		case PHY_INTERFACE_MODE_MII:
 			ksz9477_set_xmii(dev, 0, &data8);
 			ksz9477_set_gbit(dev, false, &data8);
@@ -1255,11 +1255,11 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			ksz9477_set_gbit(dev, true, &data8);
 			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
 			data8 &= ~PORT_RGMII_ID_EG_ENABLE;
-			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    dev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
+			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
 				data8 |= PORT_RGMII_ID_IG_ENABLE;
-			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-			    dev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
+			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 				data8 |= PORT_RGMII_ID_EG_ENABLE;
 			p->phydev.speed = SPEED_1000;
 			break;
@@ -1303,23 +1303,31 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 			dev->cpu_port = i;
 			dev->host_mask = (1 << dev->cpu_port);
 			dev->port_mask |= dev->host_mask;
+			p = &dev->ports[i];
 
 			/* Read from XMII register to determine host port
 			 * interface.  If set specifically in device tree
 			 * note the difference to help debugging.
 			 */
 			interface = ksz9477_get_interface(dev, i);
-			if (!dev->interface)
-				dev->interface = interface;
-			if (interface && interface != dev->interface)
+			if (!p->interface) {
+				if (dev->compat_interface) {
+					dev_warn(dev->dev,
+						 "Using legacy switch \"phy-mode\" missing on port %d node. Please update your device tree.\n",
+						 i);
+					p->interface = dev->compat_interface;
+				} else {
+					p->interface = interface;
+				}
+			}
+			if (interface && interface != p->interface)
 				dev_info(dev->dev,
 					 "use %s instead of %s\n",
-					  phy_modes(dev->interface),
+					  phy_modes(p->interface),
 					  phy_modes(interface));
 
 			/* enable cpu port */
 			ksz9477_port_setup(dev, i, true);
-			p = &dev->ports[dev->cpu_port];
 			p->vid_member = dev->port_mask;
 			p->on = 1;
 		}
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fd1d6676ae4f..9cb8e04109f4 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -416,6 +416,8 @@ int ksz_switch_register(struct ksz_device *dev,
 {
 	phy_interface_t interface;
 	int ret;
+	struct device_node *port;
+	unsigned int port_num;
 
 	if (dev->pdata)
 		dev->chip_id = dev->pdata->chip_id;
@@ -448,10 +450,19 @@ int ksz_switch_register(struct ksz_device *dev,
 	/* Host port interface will be self detected, or specifically set in
 	 * device tree.
 	 */
+	for (port_num = 0; port_num < dev->port_cnt; ++port_num)
+		dev->ports[port_num].interface = PHY_INTERFACE_MODE_NA;
 	if (dev->dev->of_node) {
 		ret = of_get_phy_mode(dev->dev->of_node, &interface);
 		if (ret == 0)
-			dev->interface = interface;
+			dev->compat_interface = interface;
+		for_each_available_child_of_node(dev->dev->of_node, port) {
+			if (of_property_read_u32(port, "reg", &port_num))
+				continue;
+			if (port_num >= dev->port_cnt)
+				return -EINVAL;
+			of_get_phy_mode(port, &dev->ports[port_num].interface);
+		}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
 	}
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f2c9bb68fd33..c0c736aaef61 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -39,6 +39,7 @@ struct ksz_port {
 	u32 freeze:1;			/* MIB counter freeze is enabled */
 
 	struct ksz_port_mib mib;
+	phy_interface_t interface;
 };
 
 struct ksz_device {
@@ -72,7 +73,7 @@ struct ksz_device {
 	int mib_cnt;
 	int mib_port_cnt;
 	int last_port;			/* ports after that not used */
-	phy_interface_t interface;
+	phy_interface_t compat_interface;
 	u32 regs_size;
 	bool phy_errata_9477;
 	bool synclko_125;
-- 
2.20.1

