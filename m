Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EC45B31BF
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 10:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiIIIbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 04:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIIIbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 04:31:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAAAF16D8;
        Fri,  9 Sep 2022 01:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662712296; x=1694248296;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=U6B35GSnL/iRb/NbR+mLgXp/4uj+c4qnEvgEQlg6KBE=;
  b=Y2A3gYmfYxioZY/ta8IpZTwYIXkQ/yrPPn9j3sT5I4f9OyCQmsubr09G
   bhUx0VOLB+nKefdNUW20STv7whCUvkYJCtQGxp6a4gnnE5rQAw4oObxbM
   yvIejHovDt40IPK94xftCfC/5akagBa/14fVtgXRiQr7lLi2CJmqxK5Sk
   gilpiOT16aH3hFF02F/WPtG57ywOK8FFLfhEoq8yqzfIQAnx85zwq5HQU
   rs1G0+QP54STFrMHvkeUA1EmMEVG+s0Q49vfx+BlMzBNdcjdg4MBV+5i7
   pDGk88FzLdHwvorBNnug/MQYHoZNnCHkjTBiAppMRbcSsDya5/z6qgHXM
   g==;
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="173107447"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 01:31:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 01:31:30 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 01:31:27 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Cable Diag feature for lan8814 phy
Date:   Fri, 9 Sep 2022 14:01:23 +0530
Message-ID: <20220909083123.30134-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for Cable Diagnostics in lan8814 phy

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 125 +++++++++++++++++++++++++++++++++------
 1 file changed, 107 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7b8c5c8d013e..491a04b89aa8 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -92,6 +92,15 @@
 #define KSZ9x31_LMD_VCT_DATA_HI_PULSE_MASK	GENMASK(1, 0)
 #define KSZ9x31_LMD_VCT_DATA_MASK		GENMASK(7, 0)
 
+#define KSZPHY_WIRE_PAIR_MASK			0x3
+
+#define LAN8814_CABLE_DIAG			0x12
+#define LAN8814_CABLE_DIAG_STAT_MASK		GENMASK(9, 8)
+#define LAN8814_CABLE_DIAG_VCT_DATA_MASK	GENMASK(7, 0)
+#define LAN8814_PAIR_BIT_SHIFT			12
+
+#define LAN8814_WIRE_PAIR_MASK			0xF
+
 /* Lan8814 general Interrupt control/status reg in GPHY specific block. */
 #define LAN8814_INTC				0x18
 #define LAN8814_INTS				0x1B
@@ -257,6 +266,8 @@ static struct kszphy_hw_stat kszphy_hw_stats[] = {
 struct kszphy_type {
 	u32 led_mode_reg;
 	u16 interrupt_level_mask;
+	u16 cable_diag_reg;
+	unsigned long pair_mask;
 	bool has_broadcast_disable;
 	bool has_nand_tree_disable;
 	bool has_rmii_ref_clk_sel;
@@ -313,6 +324,13 @@ struct kszphy_priv {
 
 static const struct kszphy_type lan8814_type = {
 	.led_mode_reg		= ~LAN8814_LED_CTRL_1,
+	.cable_diag_reg		= LAN8814_CABLE_DIAG,
+	.pair_mask		= LAN8814_WIRE_PAIR_MASK,
+};
+
+static const struct kszphy_type ksz886x_type = {
+	.cable_diag_reg		= KSZ8081_LMD,
+	.pair_mask		= KSZPHY_WIRE_PAIR_MASK,
 };
 
 static const struct kszphy_type ksz8021_type = {
@@ -1796,6 +1814,17 @@ static int kszphy_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int lan8814_cable_test_start(struct phy_device *phydev)
+{
+	/* If autoneg is enabled, we won't be able to test cross pair
+	 * short. In this case, the PHY will "detect" a link and
+	 * confuse the internal state machine - disable auto neg here.
+	 * Set the speed to 1000mbit and full duplex.
+	 */
+	return phy_modify(phydev, MII_BMCR, BMCR_ANENABLE | BMCR_SPEED100,
+			  BMCR_SPEED1000 | BMCR_FULLDPLX);
+}
+
 static int ksz886x_cable_test_start(struct phy_device *phydev)
 {
 	if (phydev->dev_flags & MICREL_KSZ8_P1_ERRATA)
@@ -1809,9 +1838,9 @@ static int ksz886x_cable_test_start(struct phy_device *phydev)
 	return phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE | BMCR_SPEED100);
 }
 
-static int ksz886x_cable_test_result_trans(u16 status)
+static int ksz886x_cable_test_result_trans(u16 status, u16 mask)
 {
-	switch (FIELD_GET(KSZ8081_LMD_STAT_MASK, status)) {
+	switch (FIELD_GET(mask, status)) {
 	case KSZ8081_LMD_STAT_NORMAL:
 		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
 	case KSZ8081_LMD_STAT_SHORT:
@@ -1825,15 +1854,15 @@ static int ksz886x_cable_test_result_trans(u16 status)
 	}
 }
 
-static bool ksz886x_cable_test_failed(u16 status)
+static bool ksz886x_cable_test_failed(u16 status, u16 mask)
 {
-	return FIELD_GET(KSZ8081_LMD_STAT_MASK, status) ==
+	return FIELD_GET(mask, status) ==
 		KSZ8081_LMD_STAT_FAIL;
 }
 
-static bool ksz886x_cable_test_fault_length_valid(u16 status)
+static bool ksz886x_cable_test_fault_length_valid(u16 status, u16 mask)
 {
-	switch (FIELD_GET(KSZ8081_LMD_STAT_MASK, status)) {
+	switch (FIELD_GET(mask, status)) {
 	case KSZ8081_LMD_STAT_OPEN:
 		fallthrough;
 	case KSZ8081_LMD_STAT_SHORT:
@@ -1842,29 +1871,79 @@ static bool ksz886x_cable_test_fault_length_valid(u16 status)
 	return false;
 }
 
-static int ksz886x_cable_test_fault_length(u16 status)
+static int ksz886x_cable_test_fault_length(struct phy_device *phydev, u16 status, u16 data_mask)
 {
 	int dt;
 
 	/* According to the data sheet the distance to the fault is
-	 * DELTA_TIME * 0.4 meters.
+	 * DELTA_TIME * 0.4 meters for ksz phys.
+	 * (DELTA_TIME - 22) * 0.8 for lan8814 phy.
 	 */
-	dt = FIELD_GET(KSZ8081_LMD_DELTA_TIME_MASK, status);
+	dt = FIELD_GET(data_mask, status);
 
-	return (dt * 400) / 10;
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) == PHY_ID_LAN8814)
+		return ((dt - 22) * 800) / 10;
+	else
+		return (dt * 400) / 10;
 }
 
 static int ksz886x_cable_test_wait_for_completion(struct phy_device *phydev)
 {
+	const struct kszphy_type *type = phydev->drv->driver_data;
 	int val, ret;
 
-	ret = phy_read_poll_timeout(phydev, KSZ8081_LMD, val,
+	ret = phy_read_poll_timeout(phydev, type->cable_diag_reg, val,
 				    !(val & KSZ8081_LMD_ENABLE_TEST),
 				    30000, 100000, true);
 
 	return ret < 0 ? ret : 0;
 }
 
+static int lan8814_cable_test_one_pair(struct phy_device *phydev, int pair)
+{
+	static const int ethtool_pair[] = { ETHTOOL_A_CABLE_PAIR_A,
+					    ETHTOOL_A_CABLE_PAIR_B,
+					    ETHTOOL_A_CABLE_PAIR_C,
+					    ETHTOOL_A_CABLE_PAIR_D,
+					  };
+	u32 fault_length;
+	int ret;
+	int val;
+
+	val = KSZ8081_LMD_ENABLE_TEST;
+	val = val | (pair << LAN8814_PAIR_BIT_SHIFT);
+
+	ret = phy_write(phydev, LAN8814_CABLE_DIAG, val);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz886x_cable_test_wait_for_completion(phydev);
+	if (ret)
+		return ret;
+
+	val = phy_read(phydev, LAN8814_CABLE_DIAG);
+	if (val < 0)
+		return val;
+
+	if (ksz886x_cable_test_failed(val, LAN8814_CABLE_DIAG_STAT_MASK))
+		return -EAGAIN;
+
+	ret = ethnl_cable_test_result(phydev, ethtool_pair[pair],
+				      ksz886x_cable_test_result_trans(val,
+								      LAN8814_CABLE_DIAG_STAT_MASK
+								      ));
+	if (ret)
+		return ret;
+
+	if (!ksz886x_cable_test_fault_length_valid(val, LAN8814_CABLE_DIAG_STAT_MASK))
+		return 0;
+
+	fault_length = ksz886x_cable_test_fault_length(phydev, val,
+						       LAN8814_CABLE_DIAG_VCT_DATA_MASK);
+
+	return ethnl_cable_test_fault_length(phydev, ethtool_pair[pair], fault_length);
+}
+
 static int ksz886x_cable_test_one_pair(struct phy_device *phydev, int pair)
 {
 	static const int ethtool_pair[] = {
@@ -1872,6 +1951,7 @@ static int ksz886x_cable_test_one_pair(struct phy_device *phydev, int pair)
 		ETHTOOL_A_CABLE_PAIR_B,
 	};
 	int ret, val, mdix;
+	u32 fault_length;
 
 	/* There is no way to choice the pair, like we do one ksz9031.
 	 * We can workaround this limitation by using the MDI-X functionality.
@@ -1910,25 +1990,27 @@ static int ksz886x_cable_test_one_pair(struct phy_device *phydev, int pair)
 	if (val < 0)
 		return val;
 
-	if (ksz886x_cable_test_failed(val))
+	if (ksz886x_cable_test_failed(val, KSZ8081_LMD_STAT_MASK))
 		return -EAGAIN;
 
 	ret = ethnl_cable_test_result(phydev, ethtool_pair[pair],
-				      ksz886x_cable_test_result_trans(val));
+				      ksz886x_cable_test_result_trans(val, KSZ8081_LMD_STAT_MASK));
 	if (ret)
 		return ret;
 
-	if (!ksz886x_cable_test_fault_length_valid(val))
+	if (!ksz886x_cable_test_fault_length_valid(val, KSZ8081_LMD_STAT_MASK))
 		return 0;
 
-	return ethnl_cable_test_fault_length(phydev, ethtool_pair[pair],
-					     ksz886x_cable_test_fault_length(val));
+	fault_length = ksz886x_cable_test_fault_length(phydev, val, KSZ8081_LMD_DELTA_TIME_MASK);
+
+	return ethnl_cable_test_fault_length(phydev, ethtool_pair[pair], fault_length);
 }
 
 static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 					 bool *finished)
 {
-	unsigned long pair_mask = 0x3;
+	const struct kszphy_type *type = phydev->drv->driver_data;
+	unsigned long pair_mask = type->pair_mask;
 	int retries = 20;
 	int pair, ret;
 
@@ -1937,7 +2019,10 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 	/* Try harder if link partner is active */
 	while (pair_mask && retries--) {
 		for_each_set_bit(pair, &pair_mask, 4) {
-			ret = ksz886x_cable_test_one_pair(phydev, pair);
+			if (type->cable_diag_reg == LAN8814_CABLE_DIAG)
+				ret = lan8814_cable_test_one_pair(phydev, pair);
+			else
+				ret = ksz886x_cable_test_one_pair(phydev, pair);
 			if (ret == -EAGAIN)
 				continue;
 			if (ret < 0)
@@ -3111,6 +3196,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_LAN8814,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip INDY Gigabit Quad PHY",
+	.flags          = PHY_POLL_CABLE_TEST,
 	.config_init	= lan8814_config_init,
 	.driver_data	= &lan8814_type,
 	.probe		= lan8814_probe,
@@ -3123,6 +3209,8 @@ static struct phy_driver ksphy_driver[] = {
 	.resume		= kszphy_resume,
 	.config_intr	= lan8814_config_intr,
 	.handle_interrupt = lan8814_handle_interrupt,
+	.cable_test_start	= lan8814_cable_test_start,
+	.cable_test_get_status	= ksz886x_cable_test_get_status,
 }, {
 	.phy_id		= PHY_ID_LAN8804,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -3169,6 +3257,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_KSZ886X,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8851 Ethernet MAC or KSZ886X Switch",
+	.driver_data	= &ksz886x_type,
 	/* PHY_BASIC_FEATURES */
 	.flags		= PHY_POLL_CABLE_TEST,
 	.config_init	= kszphy_config_init,
-- 
2.17.1

