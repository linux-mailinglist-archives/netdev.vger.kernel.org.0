Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B71B506706
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343562AbiDSIg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350045AbiDSIgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:36:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AA92AE1A;
        Tue, 19 Apr 2022 01:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650357249; x=1681893249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/gJV2Fw9EGqVFCyRqnQHv2MA1z3B7qFZ/NhR/jGQ3sA=;
  b=2lepcXqy8l1ylj1o9SiN5IA5ozGb1dKrKe5GNXDfmbsHM++3UCuDt1AW
   A9mUwjI6s0t8F4ZCS0doANgjbdkB1GlIEjXK7LapXSZ4WOWR7d3nIeTx8
   ZkGJTUCne5hwhuqfhTXZ3XL2EpTi2C3GdhsICJISwu2yZUg57zHOLENFd
   IAlxYqnBJN+TGCGotHv3g7HsXgtI+3dMzWXWKHFJyjU6uE40H+524SgsQ
   tuQL7nGZIHorNxSnOFo0dFahBtxtvdnpocM7PyLtZ1WgkvzeqVlrtwvYM
   7TIWtqJj0Hmw8dIK3lw6xzmjVWPxPabss2oVDJAk41EVBkGjALwhj9/qi
   g==;
X-IronPort-AV: E=Sophos;i="5.90,272,1643698800"; 
   d="scan'208";a="170068196"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2022 01:34:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Apr 2022 01:34:08 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 19 Apr 2022 01:34:06 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 2/2] net: phy: micrel: Implement set/get_adj_latency for lan8814
Date:   Tue, 19 Apr 2022 10:37:04 +0200
Message-ID: <20220419083704.48573-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419083704.48573-1-horatiu.vultur@microchip.com>
References: <20220419083704.48573-1-horatiu.vultur@microchip.com>
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

The lan8814 driver supports adjustments of the latency in the silicon
based on the speed and direction, therefore implement set/get_adj_latency
to adjust the HW.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 87 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 96840695debd..099d1ecd6dad 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -120,6 +120,15 @@
 #define PTP_TIMESTAMP_EN_PDREQ_			BIT(2)
 #define PTP_TIMESTAMP_EN_PDRES_			BIT(3)
 
+#define PTP_RX_LATENCY_1000			0x0224
+#define PTP_TX_LATENCY_1000			0x0225
+
+#define PTP_RX_LATENCY_100			0x0222
+#define PTP_TX_LATENCY_100			0x0223
+
+#define PTP_RX_LATENCY_10			0x0220
+#define PTP_TX_LATENCY_10			0x0221
+
 #define PTP_TX_PARSE_L2_ADDR_EN			0x0284
 #define PTP_RX_PARSE_L2_ADDR_EN			0x0244
 
@@ -208,6 +217,16 @@
 #define PTP_TSU_INT_STS_PTP_RX_TS_OVRFL_INT_	BIT(1)
 #define PTP_TSU_INT_STS_PTP_RX_TS_EN_		BIT(0)
 
+/* Represents the reset value of the latency registers,
+ * The values are express in ns
+ */
+#define LAN8814_RX_10_LATENCY			8874
+#define LAN8814_TX_10_LATENCY			11850
+#define LAN8814_RX_100_LATENCY			2346
+#define LAN8814_TX_100_LATENCY			705
+#define LAN8814_RX_1000_LATENCY			429
+#define LAN8814_TX_1000_LATENCY			201
+
 /* PHY Control 1 */
 #define MII_KSZPHY_CTRL_1			0x1e
 #define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
@@ -2657,6 +2676,72 @@ static int lan8804_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int lan8814_set_adj_latency(struct phy_device *phydev,
+				   enum ethtool_link_mode_bit_indices link_mode,
+				   s32 rx, s32 tx)
+{
+	switch (link_mode) {
+	case ETHTOOL_LINK_MODE_10baseT_Half_BIT:
+	case ETHTOOL_LINK_MODE_10baseT_Full_BIT:
+		rx += LAN8814_RX_10_LATENCY;
+		tx += LAN8814_TX_10_LATENCY;
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_10, rx);
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_10, tx);
+		return 0;
+	case ETHTOOL_LINK_MODE_100baseT_Half_BIT:
+	case ETHTOOL_LINK_MODE_100baseT_Full_BIT:
+		rx += LAN8814_RX_100_LATENCY;
+		tx += LAN8814_TX_100_LATENCY;
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_100, rx);
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_100, tx);
+		return 0;
+	case ETHTOOL_LINK_MODE_1000baseT_Half_BIT:
+	case ETHTOOL_LINK_MODE_1000baseT_Full_BIT:
+		rx += LAN8814_RX_1000_LATENCY;
+		tx += LAN8814_TX_1000_LATENCY;
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_1000, rx);
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_1000, tx);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int lan8814_get_adj_latency(struct phy_device *phydev,
+				   enum ethtool_link_mode_bit_indices link_mode,
+				   s32 *rx, s32 *tx)
+{
+	switch (link_mode) {
+	case ETHTOOL_LINK_MODE_10baseT_Half_BIT:
+	case ETHTOOL_LINK_MODE_10baseT_Full_BIT:
+		*rx = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_10);
+		*tx = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_10);
+		*rx -= LAN8814_RX_10_LATENCY;
+		*tx -= LAN8814_TX_10_LATENCY;
+		return 0;
+	case ETHTOOL_LINK_MODE_100baseT_Half_BIT:
+	case ETHTOOL_LINK_MODE_100baseT_Full_BIT:
+		*rx = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_100);
+		*tx = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_100);
+		*rx -= LAN8814_RX_100_LATENCY;
+		*tx -= LAN8814_TX_100_LATENCY;
+		return 0;
+	case ETHTOOL_LINK_MODE_1000baseT_Half_BIT:
+	case ETHTOOL_LINK_MODE_1000baseT_Full_BIT:
+		*rx = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_1000);
+		*tx = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_1000);
+		*rx -= LAN8814_RX_1000_LATENCY;
+		*tx -= LAN8814_TX_1000_LATENCY;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
 	u16 tsu_irq_status;
@@ -3052,6 +3137,8 @@ static struct phy_driver ksphy_driver[] = {
 	.resume		= kszphy_resume,
 	.config_intr	= lan8814_config_intr,
 	.handle_interrupt = lan8814_handle_interrupt,
+	.set_adj_latency = lan8814_set_adj_latency,
+	.get_adj_latency = lan8814_get_adj_latency,
 }, {
 	.phy_id		= PHY_ID_LAN8804,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.33.0

