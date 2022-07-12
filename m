Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF0857203C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbiGLQEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiGLQEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:04:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92FE2E6A1;
        Tue, 12 Jul 2022 09:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641843; x=1689177843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C/G5WNpy1z0HE+Bn9PpQap6/xtg42ECP2OSRuH8gL/4=;
  b=UnxGVu52emzqdoTEaP1uxCmmXU6hcrb44Vsvx1Sde1vXfbjOxtfAy8XW
   Q8dFyQlChPIEXVKbo30pg5F4BllogNqjqyXhiOsluvaQZkxCihZybqq9P
   8VeWka6dI8DNARNZmfMmMzsamxNL4hH22rf8T98vglVpkMJ8Ea9I2gzBn
   til77zAV8oLGRy9D4QENom7y+g2D/30phJw+RXBtodBY6u4EyouFbQEaG
   pUcyHuvrtjwWy/w4+3Fk2OfAr00Dcgs6c9kZzl/mi86P1WM0fp62F7CMN
   itgyl41MACmg9q6y9GvUnamqaTT+CrarLQ2UySMH35YAD5ftKKm77wTpO
   w==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="167484131"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:04:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:04:00 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:03:50 -0700
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
Subject: [RFC Patch net-next 02/10] net: dsa: microchip: add common gigabit set and get function
Date:   Tue, 12 Jul 2022 21:33:00 +0530
Message-ID: <20220712160308.13253-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220712160308.13253-1-arun.ramadoss@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add helper function for setting and getting the gigabit
enable for the ksz series switch. KSZ8795 switch has different register
address compared to all other ksz switches. KSZ8795 series uses the Port
5 Interface control 6 Bit 6 for configuring the 1Gbps or 100/10Mbps
speed selection. All other switches uses the xMII control 1 0xN301
register Bit6 for gigabit.
Further, for KSZ8795 & KSZ9893 switches if bit 1 then 1Gbps is chosen
and if bit 0 then 100/10Mbps is chosen. It is other way around for
other switches bit 0 is for 1Gbps. So, this patch implements the common
function for configuring the gigabit set and get capability.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c      | 36 ++-----------
 drivers/net/dsa/microchip/ksz9477_reg.h  |  4 --
 drivers/net/dsa/microchip/ksz_common.c   | 66 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   | 12 +++++
 drivers/net/dsa/microchip/lan937x_main.c | 16 ++----
 drivers/net/dsa/microchip/lan937x_reg.h  |  1 -
 6 files changed, 87 insertions(+), 48 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 6453642fa14c..cfa7ddf60718 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -866,32 +866,6 @@ void ksz9477_port_mirror_del(struct ksz_device *dev, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
-static bool ksz9477_get_gbit(struct ksz_device *dev, u8 data)
-{
-	bool gbit;
-
-	if (dev->features & NEW_XMII)
-		gbit = !(data & PORT_MII_NOT_1GBIT);
-	else
-		gbit = !!(data & PORT_MII_1000MBIT_S1);
-	return gbit;
-}
-
-static void ksz9477_set_gbit(struct ksz_device *dev, bool gbit, u8 *data)
-{
-	if (dev->features & NEW_XMII) {
-		if (gbit)
-			*data &= ~PORT_MII_NOT_1GBIT;
-		else
-			*data |= PORT_MII_NOT_1GBIT;
-	} else {
-		if (gbit)
-			*data |= PORT_MII_1000MBIT_S1;
-		else
-			*data &= ~PORT_MII_1000MBIT_S1;
-	}
-}
-
 static int ksz9477_get_xmii(struct ksz_device *dev, u8 data)
 {
 	int mode;
@@ -977,7 +951,7 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 	if (port < dev->phy_port_cnt)
 		return PHY_INTERFACE_MODE_NA;
 	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
-	gbit = ksz9477_get_gbit(dev, data8);
+	gbit = ksz_get_gbit(dev, port);
 	mode = ksz9477_get_xmii(dev, data8);
 	switch (mode) {
 	case 2:
@@ -1122,22 +1096,22 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		switch (p->interface) {
 		case PHY_INTERFACE_MODE_MII:
 			ksz9477_set_xmii(dev, 0, &data8);
-			ksz9477_set_gbit(dev, false, &data8);
+			ksz_set_gbit(dev, port, false);
 			p->phydev.speed = SPEED_100;
 			break;
 		case PHY_INTERFACE_MODE_RMII:
 			ksz9477_set_xmii(dev, 1, &data8);
-			ksz9477_set_gbit(dev, false, &data8);
+			ksz_set_gbit(dev, port, false);
 			p->phydev.speed = SPEED_100;
 			break;
 		case PHY_INTERFACE_MODE_GMII:
 			ksz9477_set_xmii(dev, 2, &data8);
-			ksz9477_set_gbit(dev, true, &data8);
+			ksz_set_gbit(dev, port, true);
 			p->phydev.speed = SPEED_1000;
 			break;
 		default:
 			ksz9477_set_xmii(dev, 3, &data8);
-			ksz9477_set_gbit(dev, true, &data8);
+			ksz_set_gbit(dev, port, true);
 			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
 			data8 &= ~PORT_RGMII_ID_EG_ENABLE;
 			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index d0cce4ca3cf9..f23ed4809e47 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -1185,10 +1185,6 @@
 #define REG_PORT_XMII_CTRL_1		0x0301
 
 #define PORT_RMII_CLK_SEL		BIT(7)
-/* S1 */
-#define PORT_MII_1000MBIT_S1		BIT(6)
-/* S2 */
-#define PORT_MII_NOT_1GBIT		BIT(6)
 #define PORT_MII_SEL_EDGE		BIT(5)
 #define PORT_RGMII_ID_IG_ENABLE		BIT(4)
 #define PORT_RGMII_ID_EG_ENABLE		BIT(3)
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 4bc6277b4361..5ebcd87fc531 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -256,6 +256,7 @@ static const u16 ksz8795_regs[] = {
 	[S_START_CTRL]			= 0x01,
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
+	[P_XMII_CTRL_1]			= 0x56,
 };
 
 static const u32 ksz8795_masks[] = {
@@ -280,6 +281,11 @@ static const u32 ksz8795_masks[] = {
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
 };
 
+static const u8 ksz8795_values[] = {
+	[P_MII_1GBIT]			= 1,
+	[P_MII_NOT_1GBIT]		= 0,
+};
+
 static const u8 ksz8795_shifts[] = {
 	[VLAN_TABLE_MEMBERSHIP_S]	= 7,
 	[VLAN_TABLE]			= 16,
@@ -350,6 +356,7 @@ static const u16 ksz9477_regs[] = {
 	[S_START_CTRL]			= 0x0300,
 	[S_BROADCAST_CTRL]		= 0x0332,
 	[S_MULTICAST_CTRL]		= 0x0331,
+	[P_XMII_CTRL_1]			= 0x0301,
 };
 
 static const u32 ksz9477_masks[] = {
@@ -361,6 +368,16 @@ static const u8 ksz9477_shifts[] = {
 	[ALU_STAT_INDEX]		= 16,
 };
 
+static const u8 ksz9477_values[] = {
+	[P_MII_1GBIT]			= 0,
+	[P_MII_NOT_1GBIT]		= 1,
+};
+
+static const u8 ksz9893_values[] = {
+	[P_MII_1GBIT]			= 1,
+	[P_MII_NOT_1GBIT]		= 0,
+};
+
 static const u32 lan937x_masks[] = {
 	[ALU_STAT_WRITE]		= 1,
 	[ALU_STAT_READ]			= 2,
@@ -387,6 +404,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.bitval = ksz8795_values,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -423,6 +441,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.bitval = ksz8795_values,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -445,6 +464,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.bitval = ksz8795_values,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -487,6 +507,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -513,6 +534,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -538,6 +560,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.bitval = ksz9893_values,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -560,6 +583,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -585,6 +609,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -606,6 +631,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -627,6 +653,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -652,6 +679,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -677,6 +705,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.bitval = ksz9477_values,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -1352,6 +1381,43 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 		dev->dev_ops->phylink_mac_config(dev, port, mode, state);
 }
 
+bool ksz_get_gbit(struct ksz_device *dev, int port)
+{
+	const u8 *bitval = dev->info->bitval;
+	const u16 *regs = dev->info->regs;
+	bool gbit = false;
+	u8 data8;
+	bool val;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+
+	val = FIELD_GET(P_MII_1GBIT_M, data8);
+
+	if (val == bitval[P_MII_1GBIT])
+		gbit = true;
+
+	return gbit;
+}
+
+void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
+{
+	const u8 *bitval = dev->info->bitval;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+
+	data8 &= ~P_MII_1GBIT_M;
+
+	if (gbit)
+		data8 |= FIELD_PREP(P_MII_1GBIT_M, bitval[P_MII_1GBIT]);
+	else
+		data8 |= FIELD_PREP(P_MII_1GBIT_M, bitval[P_MII_NOT_1GBIT]);
+
+	/* Write the updated value */
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
+}
+
 static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 41fe6388af9e..a76dfef6309c 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -51,6 +51,7 @@ struct ksz_chip_data {
 	const u16 *regs;
 	const u32 *masks;
 	const u8 *shifts;
+	const u8 *bitval;
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
 	int multicast_ctrl_reg;
@@ -171,6 +172,7 @@ enum ksz_regs {
 	S_START_CTRL,
 	S_BROADCAST_CTRL,
 	S_MULTICAST_CTRL,
+	P_XMII_CTRL_1,
 };
 
 enum ksz_masks {
@@ -210,6 +212,11 @@ enum ksz_shifts {
 	ALU_STAT_INDEX,
 };
 
+enum ksz_values {
+	P_MII_1GBIT,
+	P_MII_NOT_1GBIT,
+};
+
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
@@ -295,6 +302,8 @@ void ksz_switch_remove(struct ksz_device *dev);
 void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
+bool ksz_get_gbit(struct ksz_device *dev, int port);
+void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -458,6 +467,9 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define SW_START			0x01
 
+/* xMII configuration */
+#define P_MII_1GBIT_M			BIT(6)
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index c29d175ca6f7..efca96b02e15 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -312,14 +312,6 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 	return 0;
 }
 
-static void lan937x_config_gbit(struct ksz_device *dev, bool gbit, u8 *data)
-{
-	if (gbit)
-		*data &= ~PORT_MII_NOT_1GBIT;
-	else
-		*data |= PORT_MII_NOT_1GBIT;
-}
-
 static void lan937x_mac_config(struct ksz_device *dev, int port,
 			       phy_interface_t interface)
 {
@@ -333,11 +325,11 @@ static void lan937x_mac_config(struct ksz_device *dev, int port,
 	/* configure MAC based on interface */
 	switch (interface) {
 	case PHY_INTERFACE_MODE_MII:
-		lan937x_config_gbit(dev, false, &data8);
+		ksz_set_gbit(dev, port, false);
 		data8 |= PORT_MII_SEL;
 		break;
 	case PHY_INTERFACE_MODE_RMII:
-		lan937x_config_gbit(dev, false, &data8);
+		ksz_set_gbit(dev, port, false);
 		data8 |= PORT_RMII_SEL;
 		break;
 	default:
@@ -363,9 +355,9 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 			PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL);
 
 	if (speed == SPEED_1000)
-		lan937x_config_gbit(dev, true, &xmii_ctrl1);
+		ksz_set_gbit(dev, port, true);
 	else
-		lan937x_config_gbit(dev, false, &xmii_ctrl1);
+		ksz_set_gbit(dev, port, false);
 
 	if (speed == SPEED_100)
 		xmii_ctrl0 |= PORT_MII_100MBIT;
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index c187d0a3e7fa..747295d34411 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -140,7 +140,6 @@
 #define PORT_GRXC_ENABLE		BIT(0)
 
 #define REG_PORT_XMII_CTRL_1		0x0301
-#define PORT_MII_NOT_1GBIT		BIT(6)
 #define PORT_MII_SEL_EDGE		BIT(5)
 #define PORT_RGMII_ID_IG_ENABLE		BIT(4)
 #define PORT_RGMII_ID_EG_ENABLE		BIT(3)
-- 
2.36.1

