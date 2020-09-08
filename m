Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2998260CF3
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 10:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgIHIEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 04:04:36 -0400
Received: from mail.intenta.de ([178.249.25.132]:31884 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgIHIB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 04:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=YP21TDGWllHWpfaJys6NePSmpLXasbh0yyTknnQh/Gs=;
        b=SxiM17HFB8RpHOaedDQHj0Ul0+gj/16ptNRSxWuTIkSpxZBD0CdBKJtzvUJJBN5ckgckm0MvrS7R5eV6OgkKL556lyJfz0ifaLJpb4gg/X/JmJHfuSr7RiHwdR2r4fz0B8HipTWTxUwvnsCTV8Njs350rQ1+0s48yw8Jui609OSF2s37AyJ2mhlXlYRA1cjXCn7d7un/wi+68BO3IxmoSM8/eGhU8LaRVGpae+DOwS1oReRfAu3ip+eui26wwGDqcOXGdjQW0VlJFwfGdQUOTAhIh4c92931SiXnZv3gg0M7kJV6AEveBeAPi2wa2JpWzNjJmlKsy5WVg9ykMsnlfA==;
Date:   Tue, 8 Sep 2020 10:01:38 +0200
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
Subject: [PATCH v3] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200908080136.GA14279@laureti-dev>
References: <20200907125555.GO3164319@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200907125555.GO3164319@lunn.ch>
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
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 arch/arm/boot/dts/at91-sama5d2_icp.dts |  2 +-
 drivers/net/dsa/microchip/ksz8795.c    | 18 +++++++++++-----
 drivers/net/dsa/microchip/ksz9477.c    | 29 +++++++++++++++++---------
 drivers/net/dsa/microchip/ksz_common.c | 13 +++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |  3 ++-
 5 files changed, 47 insertions(+), 18 deletions(-)

Changes since v2:
 * Include Acked-by Alexandre Belloni.
 * Improve deprecation message. Thanks to Andrew Lunn.

Changes since v1:
 * Preserve the reverse christmas tree ordering of local variables.
   Reported by David Miller.

Reason for resending v1:
 * While Andrew Lunn agreed to the semantic change, he found the
   implementation unnecessarily complex. He suggested going without a
   per-port interface attribute, but that happened to not work out. The
   information of which port will become the cpu port is only realized
   in a later initialization step.

Helmut

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
index 8f1d15ea15d9..f7d59d7b2cbe 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -932,11 +932,19 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
 
 	if (cpu_port) {
+		if (!p->interface && dev->compat_interface) {
+			dev_warn(dev->dev,
+				 "Using legacy switch \"phy-mode\" property, because it is missing on port %d node. "
+				 "Please update your device tree.\n",
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
@@ -952,11 +960,11 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
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
index 3cb22d149813..2f5506ac7d19 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1208,7 +1208,7 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 
 		/* configure MAC to 1G & RGMII mode */
 		ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
-		switch (dev->interface) {
+		switch (p->interface) {
 		case PHY_INTERFACE_MODE_MII:
 			ksz9477_set_xmii(dev, 0, &data8);
 			ksz9477_set_gbit(dev, false, &data8);
@@ -1229,11 +1229,11 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
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
@@ -1269,23 +1269,32 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
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
+						 "Using legacy switch \"phy-mode\" property, because it is missing on port %d node. "
+						 "Please update your device tree.\n",
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
index 8d53b12d40a8..8e755b50c9c1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -388,6 +388,8 @@ int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops)
 {
 	phy_interface_t interface;
+	struct device_node *port;
+	unsigned int port_num;
 	int ret;
 
 	if (dev->pdata)
@@ -421,10 +423,19 @@ int ksz_switch_register(struct ksz_device *dev,
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
index 206838160f49..cf866e48ff66 100644
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

