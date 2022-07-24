Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B8457F464
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 11:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiGXJ3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 05:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiGXJ3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 05:29:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ABA18B25;
        Sun, 24 Jul 2022 02:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658654975; x=1690190975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dKnXPLCniMkFRfTjwD/RBYKyt33QqcAlND5UJxaTe0A=;
  b=CiSrJoMK/6Kk8FJnIDrDI9uQhpQVmo+eeqNGmr+n9yDwQ+ptfR5A7oL6
   QwIRi+KXnkXrquEucW3pZbPL/ZwXzabphdjWGgC/46fd4awJ7A6VeD3rp
   JOR4uZLxL064UDTtAhmg1LFkNUO7qSw3lMVwILVwXkH459wQO3l2AxF7E
   LDTfrt3FWiTA6N3JY57ILZK1n7VLiyla60LBQe3xJ284DRV7MGKG4EsXY
   dQMQgq8ZHy9jDVsBgt3XkSZ9n7eTrp0/6WiHQxiAL1AnpNZ0VxgfU0pVG
   lTrcZmNT7T/o9qLQICq5uOhrjQ21jf3HuM3oEEQQW45otmAscrCKhA2Fl
   w==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="173571598"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2022 02:29:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Jul 2022 02:29:33 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Sun, 24 Jul 2022 02:29:22 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next v2 3/9] net: dsa: microchip: add common duplex and flow control function
Date:   Sun, 24 Jul 2022 14:58:17 +0530
Message-ID: <20220724092823.24567-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724092823.24567-1-arun.ramadoss@microchip.com>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add common function for configuring the Full/Half duplex and
transmit/receive flow control. KSZ8795 uses the Global control register
4 for configuring the duplex and flow control, whereas all other KSZ9477
based switch uses the xMII Control 0 register.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477_reg.h  |  1 -
 drivers/net/dsa/microchip/ksz_common.c   | 36 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   | 15 ++++++++++
 drivers/net/dsa/microchip/lan937x_main.c | 25 ++++------------
 drivers/net/dsa/microchip/lan937x_reg.h  |  3 --
 5 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 2649fdf0bae1..6ca859345932 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1178,7 +1178,6 @@
 #define REG_PORT_XMII_CTRL_0		0x0300
 
 #define PORT_SGMII_SEL			BIT(7)
-#define PORT_MII_FULL_DUPLEX		BIT(6)
 #define PORT_GRXC_ENABLE		BIT(0)
 
 #define REG_PORT_XMII_CTRL_1		0x0301
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 85392d3b1c2b..28c21f5a285f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -281,11 +281,15 @@ static const u32 ksz8795_masks[] = {
 	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
 	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(5),
 };
 
 static const u8 ksz8795_xmii_ctrl0[] = {
 	[P_MII_100MBIT]			= 0,
 	[P_MII_10MBIT]			= 1,
+	[P_MII_FULL_DUPLEX]		= 0,
+	[P_MII_HALF_DUPLEX]		= 1,
 };
 
 static const u8 ksz8795_xmii_ctrl1[] = {
@@ -370,6 +374,8 @@ static const u16 ksz9477_regs[] = {
 static const u32 ksz9477_masks[] = {
 	[ALU_STAT_WRITE]		= 0,
 	[ALU_STAT_READ]			= 1,
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
 
 static const u8 ksz9477_shifts[] = {
@@ -379,6 +385,8 @@ static const u8 ksz9477_shifts[] = {
 static const u8 ksz9477_xmii_ctrl0[] = {
 	[P_MII_100MBIT]			= 1,
 	[P_MII_10MBIT]			= 0,
+	[P_MII_FULL_DUPLEX]		= 1,
+	[P_MII_HALF_DUPLEX]		= 0,
 };
 
 static const u8 ksz9477_xmii_ctrl1[] = {
@@ -389,6 +397,8 @@ static const u8 ksz9477_xmii_ctrl1[] = {
 static const u32 lan937x_masks[] = {
 	[ALU_STAT_WRITE]		= 1,
 	[ALU_STAT_READ]			= 2,
+	[P_MII_TX_FLOW_CTRL]		= BIT(5),
+	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
 
 static const u8 lan937x_shifts[] = {
@@ -1468,6 +1478,32 @@ void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
 		ksz_set_100_10mbit(dev, port, speed);
 }
 
+void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
+			 bool tx_pause, bool rx_pause)
+{
+	const u8 *bitval = dev->info->xmii_ctrl0;
+	const u32 *masks = dev->info->masks;
+	const u16 *regs = dev->info->regs;
+	u8 mask;
+	u8 val;
+
+	mask = P_MII_DUPLEX_M | masks[P_MII_TX_FLOW_CTRL] |
+	       masks[P_MII_RX_FLOW_CTRL];
+
+	if (duplex == DUPLEX_FULL)
+		val = FIELD_PREP(P_MII_DUPLEX_M, bitval[P_MII_FULL_DUPLEX]);
+	else
+		val = FIELD_PREP(P_MII_DUPLEX_M, bitval[P_MII_HALF_DUPLEX]);
+
+	if (tx_pause)
+		val |= masks[P_MII_TX_FLOW_CTRL];
+
+	if (rx_pause)
+		val |= masks[P_MII_RX_FLOW_CTRL];
+
+	ksz_prmw8(dev, port, regs[P_XMII_CTRL_0], mask, val);
+}
+
 static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d87dc88d9f20..3577fa2c5eab 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -197,6 +197,8 @@ enum ksz_masks {
 	DYNAMIC_MAC_TABLE_TIMESTAMP,
 	ALU_STAT_WRITE,
 	ALU_STAT_READ,
+	P_MII_TX_FLOW_CTRL,
+	P_MII_RX_FLOW_CTRL,
 };
 
 enum ksz_shifts {
@@ -215,6 +217,8 @@ enum ksz_shifts {
 enum ksz_xmii_ctrl0 {
 	P_MII_100MBIT,
 	P_MII_10MBIT,
+	P_MII_FULL_DUPLEX,
+	P_MII_HALF_DUPLEX,
 };
 
 enum ksz_xmii_ctrl1 {
@@ -310,6 +314,8 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
 void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed);
+void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
+			 bool tx_pause, bool rx_pause);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -416,6 +422,14 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 	ksz_write32(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
+static inline void ksz_prmw8(struct ksz_device *dev, int port, int offset,
+			     u8 mask, u8 val)
+{
+	regmap_update_bits(dev->regmap[0],
+			   dev->dev_ops->get_port_addr(port, offset),
+			   mask, val);
+}
+
 static inline void ksz_regmap_lock(void *__mtx)
 {
 	struct mutex *mtx = __mtx;
@@ -474,6 +488,7 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define SW_START			0x01
 
 /* xMII configuration */
+#define P_MII_DUPLEX_M			BIT(6)
 #define P_MII_100MBIT_M			BIT(4)
 
 #define P_GMII_1GBIT_M			BIT(6)
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index c48bae285758..450ad059d93c 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -234,6 +234,8 @@ int lan937x_reset_switch(struct ksz_device *dev)
 
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
+	const u32 *masks = dev->info->masks;
+	const u16 *regs = dev->info->regs;
 	struct dsa_switch *ds = dev->ds;
 	u8 member;
 
@@ -254,8 +256,9 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
 
 	if (!dev->info->internal_phy[port])
-		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
-				 PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL,
+		lan937x_port_cfg(dev, port, regs[P_XMII_CTRL_0],
+				 masks[P_MII_TX_FLOW_CTRL] |
+				 masks[P_MII_RX_FLOW_CTRL],
 				 true);
 
 	if (cpu_port)
@@ -346,25 +349,9 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 				     int speed, int duplex,
 				     bool tx_pause, bool rx_pause)
 {
-	u8 xmii_ctrl0;
-
 	ksz_port_set_xmii_speed(dev, port, speed);
 
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
-
-	xmii_ctrl0 &= ~(PORT_MII_FULL_DUPLEX | PORT_MII_TX_FLOW_CTRL |
-			PORT_MII_RX_FLOW_CTRL);
-
-	if (duplex)
-		xmii_ctrl0 |= PORT_MII_FULL_DUPLEX;
-
-	if (tx_pause)
-		xmii_ctrl0 |= PORT_MII_TX_FLOW_CTRL;
-
-	if (rx_pause)
-		xmii_ctrl0 |= PORT_MII_RX_FLOW_CTRL;
-
-	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
+	ksz_duplex_flowctrl(dev, port, duplex, tx_pause, rx_pause);
 }
 
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index b9364f6a4f8f..d5eb6dc3a739 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -133,9 +133,6 @@
 /* 3 - xMII */
 #define REG_PORT_XMII_CTRL_0		0x0300
 #define PORT_SGMII_SEL			BIT(7)
-#define PORT_MII_FULL_DUPLEX		BIT(6)
-#define PORT_MII_TX_FLOW_CTRL		BIT(5)
-#define PORT_MII_RX_FLOW_CTRL		BIT(3)
 #define PORT_GRXC_ENABLE		BIT(0)
 
 #define REG_PORT_XMII_CTRL_1		0x0301
-- 
2.36.1

