Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5344057F462
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiGXJ3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 05:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiGXJ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 05:29:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604BA14037;
        Sun, 24 Jul 2022 02:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658654960; x=1690190960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zz1aJ3Do4fgmEKpEF07fhJpvHv35KSHv+N3Bga4dLTc=;
  b=gLuvNoryTDKifxKdB74gp5SJe06nHs7e8+y2syWoiEk/KT8pEIV0f8xB
   zsKggOqHJrqCVALSt/J0nKrqRFy0iozLu+6WX+z1UMjfztQJXHhhWAax+
   mdfNYXS21WqrjurfthTLKM1mQXNG5Kb9Vtd90US7Y6Wq4TY42LrI0g+Lx
   rRXBPYtG2fqAkJDOrkk54167TuyPJh9g7/g5ZUNV7hnSz3rUZboWZ6xp/
   /T5Mk3CDjWPp62WiYNDaBnS9eqgQKO2i49Ia71nQ4kntwtjSLhGEkBlzo
   yIrlIDfI2eHKPNGfxs1rOmbLtv7NP5X0vOBP5mW8cfr+m9K/fhuYwofOs
   A==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="169239306"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2022 02:29:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Jul 2022 02:29:18 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Sun, 24 Jul 2022 02:29:05 -0700
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
Subject: [Patch net-next v2 2/9] net: dsa: microchip: add common ksz port xmii speed selection function
Date:   Sun, 24 Jul 2022 14:58:16 +0530
Message-ID: <20220724092823.24567-3-arun.ramadoss@microchip.com>
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

This patch adds the function for configuring the 100/10Mbps speed
selection for the ksz switches. KSZ8795 switch uses Global control 4
register 0x06 bit 4 for choosing 100/10Mpbs. Other switches uses xMII
control 1 0xN300 for it.
For KSZ8795, if the bit is set then 10Mbps is chosen and if bit is
clear then 100Mbps chosen. For all other switches it is other way
around, if the bit is set then 100Mbps is chosen.
So, this patch add the generic function for ksz switch to select the
100/10Mbps speed selection. While configuring, first it disables the
gigabit functionality and then configure the respective speed.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477_reg.h  |  1 -
 drivers/net/dsa/microchip/ksz_common.c   | 54 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   | 10 +++++
 drivers/net/dsa/microchip/lan937x_main.c | 18 +++-----
 drivers/net/dsa/microchip/lan937x_reg.h  |  1 -
 5 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index f23ed4809e47..2649fdf0bae1 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1179,7 +1179,6 @@
 
 #define PORT_SGMII_SEL			BIT(7)
 #define PORT_MII_FULL_DUPLEX		BIT(6)
-#define PORT_MII_100MBIT		BIT(4)
 #define PORT_GRXC_ENABLE		BIT(0)
 
 #define REG_PORT_XMII_CTRL_1		0x0301
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 343381102cbf..85392d3b1c2b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -257,6 +257,7 @@ static const u16 ksz8795_regs[] = {
 	[S_START_CTRL]			= 0x01,
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
+	[P_XMII_CTRL_0]			= 0x06,
 	[P_XMII_CTRL_1]			= 0x56,
 };
 
@@ -282,6 +283,11 @@ static const u32 ksz8795_masks[] = {
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
 };
 
+static const u8 ksz8795_xmii_ctrl0[] = {
+	[P_MII_100MBIT]			= 0,
+	[P_MII_10MBIT]			= 1,
+};
+
 static const u8 ksz8795_xmii_ctrl1[] = {
 	[P_GMII_1GBIT]			= 1,
 	[P_GMII_NOT_1GBIT]		= 0,
@@ -357,6 +363,7 @@ static const u16 ksz9477_regs[] = {
 	[S_START_CTRL]			= 0x0300,
 	[S_BROADCAST_CTRL]		= 0x0332,
 	[S_MULTICAST_CTRL]		= 0x0331,
+	[P_XMII_CTRL_0]			= 0x0300,
 	[P_XMII_CTRL_1]			= 0x0301,
 };
 
@@ -369,6 +376,11 @@ static const u8 ksz9477_shifts[] = {
 	[ALU_STAT_INDEX]		= 16,
 };
 
+static const u8 ksz9477_xmii_ctrl0[] = {
+	[P_MII_100MBIT]			= 1,
+	[P_MII_10MBIT]			= 0,
+};
+
 static const u8 ksz9477_xmii_ctrl1[] = {
 	[P_GMII_1GBIT]			= 0,
 	[P_GMII_NOT_1GBIT]		= 1,
@@ -400,6 +412,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.xmii_ctrl0 = ksz8795_xmii_ctrl0,
 		.xmii_ctrl1 = ksz8795_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
@@ -437,6 +450,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.xmii_ctrl0 = ksz8795_xmii_ctrl0,
 		.xmii_ctrl1 = ksz8795_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
@@ -460,6 +474,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.xmii_ctrl0 = ksz8795_xmii_ctrl0,
 		.xmii_ctrl1 = ksz8795_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
@@ -503,6 +518,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
@@ -530,6 +546,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
@@ -556,6 +573,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz8795_xmii_ctrl1, /* Same as ksz8795 */
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
@@ -579,6 +597,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
@@ -605,6 +624,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
@@ -627,6 +647,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
@@ -649,6 +670,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
@@ -675,6 +697,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
@@ -701,6 +724,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
 		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
@@ -1414,6 +1438,36 @@ void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
 }
 
+static void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed)
+{
+	const u8 *bitval = dev->info->xmii_ctrl0;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
+
+	data8 &= ~P_MII_100MBIT_M;
+
+	if (speed == SPEED_100)
+		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_100MBIT]);
+	else
+		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_10MBIT]);
+
+	/* Write the updated value */
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
+}
+
+void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
+{
+	if (speed == SPEED_1000)
+		ksz_set_gbit(dev, port, true);
+	else
+		ksz_set_gbit(dev, port, false);
+
+	if (speed == SPEED_100 || speed == SPEED_10)
+		ksz_set_100_10mbit(dev, port, speed);
+}
+
 static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 22f03148be0b..d87dc88d9f20 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -51,6 +51,7 @@ struct ksz_chip_data {
 	const u16 *regs;
 	const u32 *masks;
 	const u8 *shifts;
+	const u8 *xmii_ctrl0;
 	const u8 *xmii_ctrl1;
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
@@ -170,6 +171,7 @@ enum ksz_regs {
 	S_START_CTRL,
 	S_BROADCAST_CTRL,
 	S_MULTICAST_CTRL,
+	P_XMII_CTRL_0,
 	P_XMII_CTRL_1,
 };
 
@@ -210,6 +212,11 @@ enum ksz_shifts {
 	ALU_STAT_INDEX,
 };
 
+enum ksz_xmii_ctrl0 {
+	P_MII_100MBIT,
+	P_MII_10MBIT,
+};
+
 enum ksz_xmii_ctrl1 {
 	P_GMII_1GBIT,
 	P_GMII_NOT_1GBIT,
@@ -302,6 +309,7 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
+void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -466,6 +474,8 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define SW_START			0x01
 
 /* xMII configuration */
+#define P_MII_100MBIT_M			BIT(4)
+
 #define P_GMII_1GBIT_M			BIT(6)
 
 /* Regmap tables generation */
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index efca96b02e15..c48bae285758 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -346,21 +346,14 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 				     int speed, int duplex,
 				     bool tx_pause, bool rx_pause)
 {
-	u8 xmii_ctrl0, xmii_ctrl1;
+	u8 xmii_ctrl0;
 
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
-	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &xmii_ctrl1);
-
-	xmii_ctrl0 &= ~(PORT_MII_100MBIT | PORT_MII_FULL_DUPLEX |
-			PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL);
+	ksz_port_set_xmii_speed(dev, port, speed);
 
-	if (speed == SPEED_1000)
-		ksz_set_gbit(dev, port, true);
-	else
-		ksz_set_gbit(dev, port, false);
+	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
 
-	if (speed == SPEED_100)
-		xmii_ctrl0 |= PORT_MII_100MBIT;
+	xmii_ctrl0 &= ~(PORT_MII_FULL_DUPLEX | PORT_MII_TX_FLOW_CTRL |
+			PORT_MII_RX_FLOW_CTRL);
 
 	if (duplex)
 		xmii_ctrl0 |= PORT_MII_FULL_DUPLEX;
@@ -372,7 +365,6 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 		xmii_ctrl0 |= PORT_MII_RX_FLOW_CTRL;
 
 	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
-	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, xmii_ctrl1);
 }
 
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index 747295d34411..b9364f6a4f8f 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -135,7 +135,6 @@
 #define PORT_SGMII_SEL			BIT(7)
 #define PORT_MII_FULL_DUPLEX		BIT(6)
 #define PORT_MII_TX_FLOW_CTRL		BIT(5)
-#define PORT_MII_100MBIT		BIT(4)
 #define PORT_MII_RX_FLOW_CTRL		BIT(3)
 #define PORT_GRXC_ENABLE		BIT(0)
 
-- 
2.36.1

