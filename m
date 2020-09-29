Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1435227B96E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgI2Ban (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgI2Bak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 164AE20678;
        Tue, 29 Sep 2020 01:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343039;
        bh=IxXwNe8UuOodL7Pzab7Za96bo/MU+wjY0in1Z7bUpMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tt7aA2I1PcsACBofSJLGVmiXlZWPkAX0w5quRqhX89K+eR6b7ys2glwHh46njZbbg
         C1oJ7phFItciq8IjVKYhwHr5DKezhE5tBmbCBwqURIsILfNj99erB1UCb6bdw3zRxx
         rUwdN8qc8mvo7w/P/LCIXevvBFuKZbYzcDH+I99U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 08/29] net: dsa: microchip: look for phy-mode in port nodes
Date:   Mon, 28 Sep 2020 21:30:05 -0400
Message-Id: <20200929013027.2406344-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>

[ Upstream commit edecfa98f602a597666e3c5cab2677ada38d93c5 ]

Documentation/devicetree/bindings/net/dsa/dsa.txt says that the phy-mode
property should be specified on port nodes. However, the microchip
drivers read it from the switch node.

Let the driver use the per-port property and fall back to the old
location with a warning.

Fix in-tree users.

Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
Link: https://lore.kernel.org/netdev/20200617082235.GA1523@laureti-dev/
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d2_icp.dts |  2 +-
 drivers/net/dsa/microchip/ksz8795.c    | 18 +++++++++++-----
 drivers/net/dsa/microchip/ksz9477.c    | 29 +++++++++++++++++---------
 drivers/net/dsa/microchip/ksz_common.c | 13 +++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |  3 ++-
 5 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index 8d19925fc09e4..6783cf16ff818 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -116,7 +116,6 @@ spi2: spi@400 {
 		switch0: ksz8563@0 {
 			compatible = "microchip,ksz8563";
 			reg = <0>;
-			phy-mode = "mii";
 			reset-gpios = <&pioA PIN_PD4 GPIO_ACTIVE_LOW>;
 
 			spi-max-frequency = <500000>;
@@ -140,6 +139,7 @@ port@2 {
 					reg = <2>;
 					label = "cpu";
 					ethernet = <&macb0>;
+					phy-mode = "mii";
 					fixed-link {
 						speed = <100>;
 						full-duplex;
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 87db588bcdd6b..44a4b73806382 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -941,11 +941,19 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
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
@@ -961,11 +969,11 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
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
index 4a9239b2c2e4a..a5402f4dd5278 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1217,7 +1217,7 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 
 		/* configure MAC to 1G & RGMII mode */
 		ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
-		switch (dev->interface) {
+		switch (p->interface) {
 		case PHY_INTERFACE_MODE_MII:
 			ksz9477_set_xmii(dev, 0, &data8);
 			ksz9477_set_gbit(dev, false, &data8);
@@ -1238,11 +1238,11 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
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
@@ -1286,23 +1286,32 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
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
index 7b6c0dce75360..3dcf42f78b51b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -413,6 +413,8 @@ int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops)
 {
 	phy_interface_t interface;
+	struct device_node *port;
+	unsigned int port_num;
 	int ret;
 
 	if (dev->pdata)
@@ -446,10 +448,19 @@ int ksz_switch_register(struct ksz_device *dev,
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
index 7d11dd32ec0d1..7382b1d0c1d81 100644
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
2.25.1

