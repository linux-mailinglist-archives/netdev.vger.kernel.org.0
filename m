Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C748E57F460
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 11:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiGXJ3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 05:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiGXJ3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 05:29:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F0B15A27;
        Sun, 24 Jul 2022 02:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658654944; x=1690190944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EkYrgW8HSiQhQ97mLr+G51bWfgr/TU5XqmgEXoTsA7A=;
  b=0QR+GbBwyN6xk9kPZGjEQFzH243aWjnCOsM8N7z7Ubs1PGBLZxl5n+Z5
   qdlyp2k61c3TXbstqEDuLia5OMA6zspc6Mzllyll98ZrhwawtQkzzTWKd
   xT2vpUWT4ygl60KWmAh0LCSabPz4hZhCVYyCcxtn+wLAbcwW4vWCprK6p
   DIqPFEQ/d9snvn8BFw4EynrwZPc0+99/MQBCA2ufz2SVyFVevMXjKTJ71
   h7XxsAYoV8GZbp9dr7mVG47Z76QfFBylq2nOeb71hVb+CTLSGizMub489
   NupMt1ZK7d64Cjsa26UYPK5rdOiPxpddpq9PZzzoOcFs/NxiK5Q3NQVbL
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="166136614"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2022 02:29:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 24 Jul 2022 02:29:01 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Sun, 24 Jul 2022 02:28:49 -0700
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
Subject: [Patch net-next v2 1/9] net: dsa: microchip: add common gigabit set and get function
Date:   Sun, 24 Jul 2022 14:58:15 +0530
Message-ID: <20220724092823.24567-2-arun.ramadoss@microchip.com>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c      | 36 ++------------
 drivers/net/dsa/microchip/ksz9477_reg.h  |  4 --
 drivers/net/dsa/microchip/ksz_common.c   | 61 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h   | 12 +++++
 drivers/net/dsa/microchip/lan937x_main.c | 16 ++-----
 drivers/net/dsa/microchip/lan937x_reg.h  |  1 -
 6 files changed, 82 insertions(+), 48 deletions(-)

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
index fd12a68c1dcd..343381102cbf 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -257,6 +257,7 @@ static const u16 ksz8795_regs[] = {
 	[S_START_CTRL]			= 0x01,
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
+	[P_XMII_CTRL_1]			= 0x56,
 };
 
 static const u32 ksz8795_masks[] = {
@@ -281,6 +282,11 @@ static const u32 ksz8795_masks[] = {
 	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
 };
 
+static const u8 ksz8795_xmii_ctrl1[] = {
+	[P_GMII_1GBIT]			= 1,
+	[P_GMII_NOT_1GBIT]		= 0,
+};
+
 static const u8 ksz8795_shifts[] = {
 	[VLAN_TABLE_MEMBERSHIP_S]	= 7,
 	[VLAN_TABLE]			= 16,
@@ -351,6 +357,7 @@ static const u16 ksz9477_regs[] = {
 	[S_START_CTRL]			= 0x0300,
 	[S_BROADCAST_CTRL]		= 0x0332,
 	[S_MULTICAST_CTRL]		= 0x0331,
+	[P_XMII_CTRL_1]			= 0x0301,
 };
 
 static const u32 ksz9477_masks[] = {
@@ -362,6 +369,11 @@ static const u8 ksz9477_shifts[] = {
 	[ALU_STAT_INDEX]		= 16,
 };
 
+static const u8 ksz9477_xmii_ctrl1[] = {
+	[P_GMII_1GBIT]			= 0,
+	[P_GMII_NOT_1GBIT]		= 1,
+};
+
 static const u32 lan937x_masks[] = {
 	[ALU_STAT_WRITE]		= 1,
 	[ALU_STAT_READ]			= 2,
@@ -388,6 +400,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.xmii_ctrl1 = ksz8795_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -424,6 +437,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.xmii_ctrl1 = ksz8795_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -446,6 +460,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.xmii_ctrl1 = ksz8795_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -488,6 +503,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -514,6 +530,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -539,6 +556,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl1 = ksz8795_xmii_ctrl1, /* Same as ksz8795 */
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -561,6 +579,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = ksz9477_masks,
 		.shifts = ksz9477_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -586,6 +605,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -607,6 +627,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -628,6 +649,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -653,6 +675,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -678,6 +701,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz9477_regs,
 		.masks = lan937x_masks,
 		.shifts = lan937x_shifts,
+		.xmii_ctrl1 = ksz9477_xmii_ctrl1,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -1353,6 +1377,43 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 		dev->dev_ops->phylink_mac_config(dev, port, mode, state);
 }
 
+bool ksz_get_gbit(struct ksz_device *dev, int port)
+{
+	const u8 *bitval = dev->info->xmii_ctrl1;
+	const u16 *regs = dev->info->regs;
+	bool gbit = false;
+	u8 data8;
+	bool val;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+
+	val = FIELD_GET(P_GMII_1GBIT_M, data8);
+
+	if (val == bitval[P_GMII_1GBIT])
+		gbit = true;
+
+	return gbit;
+}
+
+void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
+{
+	const u8 *bitval = dev->info->xmii_ctrl1;
+	const u16 *regs = dev->info->regs;
+	u8 data8;
+
+	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+
+	data8 &= ~P_GMII_1GBIT_M;
+
+	if (gbit)
+		data8 |= FIELD_PREP(P_GMII_1GBIT_M, bitval[P_GMII_1GBIT]);
+	else
+		data8 |= FIELD_PREP(P_GMII_1GBIT_M, bitval[P_GMII_NOT_1GBIT]);
+
+	/* Write the updated value */
+	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
+}
+
 static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d5dddb7ec045..22f03148be0b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -51,6 +51,7 @@ struct ksz_chip_data {
 	const u16 *regs;
 	const u32 *masks;
 	const u8 *shifts;
+	const u8 *xmii_ctrl1;
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
 	int multicast_ctrl_reg;
@@ -169,6 +170,7 @@ enum ksz_regs {
 	S_START_CTRL,
 	S_BROADCAST_CTRL,
 	S_MULTICAST_CTRL,
+	P_XMII_CTRL_1,
 };
 
 enum ksz_masks {
@@ -208,6 +210,11 @@ enum ksz_shifts {
 	ALU_STAT_INDEX,
 };
 
+enum ksz_xmii_ctrl1 {
+	P_GMII_1GBIT,
+	P_GMII_NOT_1GBIT,
+};
+
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
@@ -293,6 +300,8 @@ void ksz_switch_remove(struct ksz_device *dev);
 void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
+bool ksz_get_gbit(struct ksz_device *dev, int port);
+void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
@@ -456,6 +465,9 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define SW_START			0x01
 
+/* xMII configuration */
+#define P_GMII_1GBIT_M			BIT(6)
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

