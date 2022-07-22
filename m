Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2AA57DF39
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbiGVJih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbiGVJiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:38:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB51FB5049;
        Fri, 22 Jul 2022 02:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658482007; x=1690018007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ez7X+rmxujKKfqBUCFAYdIKf04v9FURqBTOH/CNIuSw=;
  b=Yz0fBhuzr1rsq/RZNhAI1Gr5xL8ntCsOaQMMmFLU0EhI+cfaJEihKa4R
   ZKNskpd5WgMHD9KHHidmPa6p5IwivnBOmeVacmiSNVYXSu8Wtg8fwhd3w
   zLIK2q2/nZCxt39tpqPNxgQVwLYIjqYc+Pw/gQjnPtMiaIXOx9fezTZpi
   6IJR15Ttser9z6b3G2hUMxZSVd+OW1AXQM2LM9tAjXeF+aQBOl3MvC2SV
   riaAbpT1OGa1uGNwfoOSQzqk8jEdUoSurKOh5j6cCXyCSuLIPf/xf76/j
   HXXDqlipLFK+GGSN+I6Lq6SoK9/kOS5uCTax8kqfBlmP/r6Eedmd6j/GE
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="169043350"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 02:26:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 02:26:41 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 22 Jul 2022 02:26:36 -0700
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
        "Arun Ramadoss" <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [Patch net-next v1 6/9] net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
Date:   Fri, 22 Jul 2022 14:54:56 +0530
Message-ID: <20220722092459.18653-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722092459.18653-1-arun.ramadoss@microchip.com>
References: <20220722092459.18653-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch read the rgmii tx and rx delay from device tree and stored it
in the ksz_port.  It applies the rgmii delay to the xmii tune adjust
register based on the interface selected in phylink mac config. There
are two rgmii port in LAN937x and value to be loaded in the register
vary depends on the port selected.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   | 53 +++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h   |  3 ++
 drivers/net/dsa/microchip/lan937x.h      |  1 +
 drivers/net/dsa/microchip/lan937x_main.c | 56 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  | 18 ++++++++
 5 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 2ba6ec09b6af..65a4ed77f3cc 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -223,6 +223,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = lan937x_phylink_get_caps,
 	.phylink_mac_config = lan937x_phylink_mac_config,
+	.setup_rgmii_delay = lan937x_setup_rgmii_delay,
 	.fdb_dump = ksz9477_fdb_dump,
 	.fdb_add = ksz9477_fdb_add,
 	.fdb_del = ksz9477_fdb_del,
@@ -1411,12 +1412,14 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
+	struct ksz_port *p = &dev->ports[port];
 	const u16 *regs = dev->info->regs;
 	u8 data8;
 
 	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
 
-	data8 &= ~P_MII_SEL_M;
+	data8 &= ~(P_MII_SEL_M | P_RGMII_ID_IG_ENABLE |
+		   P_RGMII_ID_EG_ENABLE);
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_MII:
@@ -1440,6 +1443,12 @@ void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
 		return;
 	}
 
+	if (p->rgmii_tx_val)
+		data8 |= P_RGMII_ID_EG_ENABLE;
+
+	if (p->rgmii_rx_val)
+		data8 |= P_RGMII_ID_IG_ENABLE;
+
 	/* Write the updated value */
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
 }
@@ -1452,6 +1461,9 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	if (dev->dev_ops->phylink_mac_config)
 		dev->dev_ops->phylink_mac_config(dev, port, mode, state);
+
+	if (dev->dev_ops->setup_rgmii_delay)
+		dev->dev_ops->setup_rgmii_delay(dev, port);
 }
 
 bool ksz_get_gbit(struct ksz_device *dev, int port)
@@ -1731,6 +1743,43 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 }
 EXPORT_SYMBOL(ksz_switch_alloc);
 
+static void ksz_parse_rgmii_delay(struct ksz_device *dev, int port_num,
+				  struct device_node *port_dn)
+{
+	phy_interface_t phy_mode = dev->ports[port_num].interface;
+	int rx_delay = -1, tx_delay = -1;
+
+	if (!phy_interface_mode_is_rgmii(phy_mode))
+		return;
+
+	of_property_read_u32(port_dn, "rx-internal-delay-ps", &rx_delay);
+	of_property_read_u32(port_dn, "tx-internal-delay-ps", &tx_delay);
+
+	if (rx_delay == -1 && tx_delay == -1) {
+		dev_warn(dev->dev,
+			 "Port %d interpreting RGMII delay settings based on \"phy-mode\" property, "
+			 "please update device tree to specify \"rx-internal-delay-ps\" and "
+			 "\"tx-internal-delay-ps\"",
+			 port_num);
+
+		if (phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+			rx_delay = 2000;
+
+		if (phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+			tx_delay = 2000;
+	}
+
+	if (rx_delay < 0)
+		rx_delay = 0;
+	if (tx_delay < 0)
+		tx_delay = 0;
+
+	dev->ports[port_num].rgmii_rx_val = rx_delay;
+	dev->ports[port_num].rgmii_tx_val = tx_delay;
+}
+
 int ksz_switch_register(struct ksz_device *dev)
 {
 	const struct ksz_chip_data *info;
@@ -1828,6 +1877,8 @@ int ksz_switch_register(struct ksz_device *dev)
 				}
 				of_get_phy_mode(port,
 						&dev->ports[port_num].interface);
+
+				ksz_parse_rgmii_delay(dev, port_num, port);
 			}
 			of_node_put(ports);
 		}
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a69aff079cd9..61942e0636d6 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -79,6 +79,8 @@ struct ksz_port {
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
 	u16 max_frame;
+	u32 rgmii_tx_val;
+	u32 rgmii_rx_val;
 };
 
 struct ksz_device {
@@ -301,6 +303,7 @@ struct ksz_dev_ops {
 				    phy_interface_t interface,
 				    struct phy_device *phydev, int speed,
 				    int duplex, bool tx_pause, bool rx_pause);
+	void (*setup_rgmii_delay)(struct ksz_device *dev, int port);
 	void (*config_cpu_port)(struct dsa_switch *ds);
 	int (*enable_stp_addr)(struct ksz_device *dev);
 	int (*reset)(struct ksz_device *dev);
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 0ae553a9b9af..423521a13c9e 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -20,4 +20,5 @@ void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 				unsigned int mode,
 				const struct phylink_link_state *state);
+void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index d86ffdf976b0..797fe7f62394 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -315,6 +315,45 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 	return 0;
 }
 
+static void lan937x_set_tune_adj(struct ksz_device *dev, int port,
+				 u16 reg, u8 val)
+{
+	u16 data16;
+
+	ksz_pread16(dev, port, reg, &data16);
+
+	/* Update tune Adjust */
+	data16 |= FIELD_PREP(PORT_TUNE_ADJ, val);
+	ksz_pwrite16(dev, port, reg, data16);
+
+	/* write DLL reset to take effect */
+	data16 |= PORT_DLL_RESET;
+	ksz_pwrite16(dev, port, reg, data16);
+}
+
+static void lan937x_set_rgmii_tx_delay(struct ksz_device *dev, int port)
+{
+	u8 val;
+
+	/* Apply different codes based on the ports as per characterization
+	 * results
+	 */
+	val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_TX_DELAY_2NS :
+		RGMII_2_TX_DELAY_2NS;
+
+	lan937x_set_tune_adj(dev, port, REG_PORT_XMII_CTRL_5, val);
+}
+
+static void lan937x_set_rgmii_rx_delay(struct ksz_device *dev, int port)
+{
+	u8 val;
+
+	val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_RX_DELAY_2NS :
+		RGMII_2_RX_DELAY_2NS;
+
+	lan937x_set_tune_adj(dev, port, REG_PORT_XMII_CTRL_4, val);
+}
+
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config)
 {
@@ -327,6 +366,23 @@ void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 	}
 }
 
+void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port)
+{
+	struct ksz_port *p = &dev->ports[port];
+
+	if (p->rgmii_tx_val) {
+		lan937x_set_rgmii_tx_delay(dev, port);
+		dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
+			 port);
+	}
+
+	if (p->rgmii_rx_val) {
+		lan937x_set_rgmii_rx_delay(dev, port);
+		dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
+			 port);
+	}
+}
+
 void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 				unsigned int mode,
 				const struct phylink_link_state *state)
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index a6cb3ca22dc3..ba4adaddb3ec 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -136,6 +136,12 @@
 
 #define PORT_MII_SEL_EDGE		BIT(5)
 
+#define REG_PORT_XMII_CTRL_4		0x0304
+#define REG_PORT_XMII_CTRL_5		0x0306
+
+#define PORT_DLL_RESET			BIT(15)
+#define PORT_TUNE_ADJ			GENMASK(13, 7)
+
 /* 4 - MAC */
 #define REG_PORT_MAC_CTRL_0		0x0400
 #define PORT_CHECK_LENGTH		BIT(2)
@@ -161,6 +167,18 @@
 
 #define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
 
+/* The port number as per the datasheet */
+#define RGMII_2_PORT_NUM		5
+#define RGMII_1_PORT_NUM		6
+
+#define LAN937X_RGMII_2_PORT		(RGMII_2_PORT_NUM - 1)
+#define LAN937X_RGMII_1_PORT		(RGMII_1_PORT_NUM - 1)
+
+#define RGMII_1_TX_DELAY_2NS		2
+#define RGMII_2_TX_DELAY_2NS		0
+#define RGMII_1_RX_DELAY_2NS		0x1B
+#define RGMII_2_RX_DELAY_2NS		0x14
+
 #define LAN937X_TAG_LEN			2
 
 #endif
-- 
2.36.1

