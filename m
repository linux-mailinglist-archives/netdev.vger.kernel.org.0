Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB20B4E470B
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 20:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiCVT5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 15:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiCVT5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 15:57:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF0A4D9E8;
        Tue, 22 Mar 2022 12:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647978943; x=1679514943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HeXobi3Uy+VITO3vDI5dl1U/DYm0aref8Da7pvzBMkE=;
  b=CiusE8f7Ms8HFHqH56Bma10GJ5QQHUwJ9ORN1znX9IVCMlBzVwhwcqLk
   lxkhumTGtQKv1sNG5JtH6l0nzY2Jz7Ex9JyaqzpSdYUkcpq5s0aBPmKCU
   HDpQPZX+69sWQ5EEf6DPNhEy9qJmejvTG4bVR1+wleR4A8Xgobb4GORMr
   25aNh0hzR1Z74QAavCQY8rM8v2zHsbDqEfIO/brwa2KttFWOkzaMG8lqJ
   eysSxXtm1kPg/Bke9v8EOv6HOwiJWzNso5fqe3PUckQ11KK1seUQfF+Ja
   WiWPEMfI42geyus/6YqtaHoacGzg7Me9lDbPNSUxLNlC2mDiu4VYa6ks+
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,202,1643698800"; 
   d="scan'208";a="166737703"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2022 12:55:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Mar 2022 12:55:42 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 22 Mar 2022 12:55:36 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v10 net-next 06/10] net: dsa: microchip: add support for phylink management
Date:   Wed, 23 Mar 2022 01:24:51 +0530
Message-ID: <20220322195455.703921-7-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
References: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_get_caps() is implemented and reused KSZ commmon API for
phylink_mac_link_down() operation

lan937x_phylink_mac_config configures the interface using
lan937x_mac_config and lan937x_phylink_mac_link_up configures
the speed/duplex/flow control.

Currently SGMII & in-band neg are not supported & it will be
added later.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 158 +++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h  |   5 +
 drivers/net/dsa/microchip/lan937x_main.c |  66 ++++++++++
 3 files changed, 229 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index 784a24d0aa08..dfd93fa49939 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -449,6 +449,164 @@ int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
 	return ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
 }
 
+static void lan937x_config_gbit(struct ksz_device *dev, bool gbit, u8 *data)
+{
+	if (gbit)
+		*data &= ~PORT_MII_NOT_1GBIT;
+	else
+		*data |= PORT_MII_NOT_1GBIT;
+}
+
+static void lan937x_update_rgmii_tx_rx_delay(struct ksz_device *dev, int port,
+					     bool is_tx)
+{
+	u16 data16;
+	int reg;
+	u8 val;
+
+	/* Apply different codes based on the ports as per characterization
+	 * results
+	 */
+	if (is_tx) {
+		reg = REG_PORT_XMII_CTRL_5;
+		val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_TX_DELAY_2NS :
+						       RGMII_2_TX_DELAY_2NS;
+	} else {
+		reg = REG_PORT_XMII_CTRL_4;
+		val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_RX_DELAY_2NS :
+						       RGMII_2_RX_DELAY_2NS;
+	}
+
+	lan937x_pread16(dev, port, reg, &data16);
+
+	/* clear tune Adjust */
+	data16 &= ~PORT_TUNE_ADJ;
+	data16 |= (val << 7);
+	lan937x_pwrite16(dev, port, reg, data16);
+
+	data16 |= PORT_DLL_RESET;
+	/* write DLL reset to take effect */
+	lan937x_pwrite16(dev, port, reg, data16);
+}
+
+static void lan937x_apply_rgmii_delay(struct ksz_device *dev, int port,
+				      phy_interface_t interface, u8 val)
+{
+	struct ksz_port *p = &dev->ports[port];
+
+	/* Clear Ingress & Egress internal delay enabled bits */
+	val &= ~(PORT_RGMII_ID_EG_ENABLE | PORT_RGMII_ID_IG_ENABLE);
+
+	/* if the delay is 0, do not enable DLL */
+	if (p->rgmii_tx_val) {
+		lan937x_update_rgmii_tx_rx_delay(dev, port, true);
+		dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
+			 port);
+		val |= PORT_RGMII_ID_EG_ENABLE;
+	}
+
+	/* if the delay is 0, do not enable DLL */
+	if (p->rgmii_rx_val) {
+		lan937x_update_rgmii_tx_rx_delay(dev, port, false);
+		dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
+			 port);
+		val |= PORT_RGMII_ID_IG_ENABLE;
+	}
+
+	/* Enable RGMII internal delays */
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, val);
+}
+
+void lan937x_mac_config(struct ksz_device *dev, int port,
+			phy_interface_t interface)
+{
+	u8 data8;
+
+	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
+
+	/* clear MII selection & set it based on interface later */
+	data8 &= ~PORT_MII_SEL_M;
+
+	/* configure MAC based on interface */
+	switch (interface) {
+	case PHY_INTERFACE_MODE_MII:
+		lan937x_config_gbit(dev, false, &data8);
+		data8 |= PORT_MII_SEL;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		lan937x_config_gbit(dev, false, &data8);
+		data8 |= PORT_RMII_SEL;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		lan937x_config_gbit(dev, true, &data8);
+		data8 |= PORT_RGMII_SEL;
+
+		/* Apply rgmii internal delay for the mac */
+		lan937x_apply_rgmii_delay(dev, port, interface, data8);
+
+		/* rgmii delay configuration is already applied above,
+		 * hence return from here as no changes required
+		 */
+		return;
+	default:
+		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
+			phy_modes(interface), port);
+		return;
+	}
+
+	/* Write the updated value */
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
+}
+
+void lan937x_config_interface(struct ksz_device *dev, int port,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause)
+{
+	u8 xmii_ctrl0, xmii_ctrl1;
+
+	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
+	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &xmii_ctrl1);
+
+	switch (speed) {
+	case SPEED_1000:
+		lan937x_config_gbit(dev, true, &xmii_ctrl1);
+		break;
+	case SPEED_100:
+		lan937x_config_gbit(dev, false, &xmii_ctrl1);
+		xmii_ctrl0 |= PORT_MAC_SPEED_100;
+		break;
+	case SPEED_10:
+		lan937x_config_gbit(dev, false, &xmii_ctrl1);
+		xmii_ctrl0 &= ~PORT_MAC_SPEED_100;
+		break;
+	default:
+		dev_err(dev->dev, "Unsupported speed on port %d: %d\n",
+			port, speed);
+		return;
+	}
+
+	if (duplex)
+		xmii_ctrl0 |= PORT_FULL_DUPLEX;
+	else
+		xmii_ctrl0 &= ~PORT_FULL_DUPLEX;
+
+	if (tx_pause)
+		xmii_ctrl0 |= PORT_TX_FLOW_CTRL;
+	else
+		xmii_ctrl1 &= ~PORT_TX_FLOW_CTRL;
+
+	if (rx_pause)
+		xmii_ctrl0 |= PORT_RX_FLOW_CTRL;
+	else
+		xmii_ctrl0 &= ~PORT_RX_FLOW_CTRL;
+
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, xmii_ctrl1);
+}
+
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct dsa_switch *ds = dev->ds;
diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
index eba36912969a..a9b435594634 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -34,6 +34,11 @@ void lan937x_cfg_port_member(struct ksz_device *dev, int port,
 			     u8 member);
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 int lan937x_enable_spi_indirect_access(struct ksz_device *dev);
+void lan937x_config_interface(struct ksz_device *dev, int port,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause);
+void lan937x_mac_config(struct ksz_device *dev, int port,
+			phy_interface_t interface);
 void lan937x_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 		       u64 *dropped, u64 *cnt);
 
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index b5164be297c8..c7b7b9b373d7 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -295,6 +295,68 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
 	return (FR_MAX_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN);
 }
 
+static void lan937x_phylink_mac_config(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       const struct phylink_link_state *state)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* Internal PHYs */
+	if (lan937x_is_internal_phy_port(dev, port))
+		return;
+
+	if (phylink_autoneg_inband(mode)) {
+		dev_err(ds->dev, "In-band AN not supported!\n");
+		return;
+	}
+
+	lan937x_mac_config(dev, port, state->interface);
+}
+
+static void lan937x_phylink_mac_link_up(struct dsa_switch *ds, int port,
+					unsigned int mode,
+					phy_interface_t interface,
+					struct phy_device *phydev,
+					int speed, int duplex,
+					bool tx_pause, bool rx_pause)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* Internal PHYs */
+	if (lan937x_is_internal_phy_port(dev, port))
+		return;
+
+	lan937x_config_interface(dev, port, speed, duplex,
+				 tx_pause, rx_pause);
+}
+
+static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* non legacy driver */
+	config->legacy_pre_march2020 = false;
+
+	config->mac_capabilities = MAC_100FD;
+
+	/* internal T1 PHY */
+	if (lan937x_is_internal_base_t1_phy_port(dev, port)) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+	} else if (lan937x_is_rgmii_port(dev, port)) {
+		/* MII/RMII/RGMII ports */
+		config->mac_capabilities |= MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+					    MAC_100HD | MAC_10 | MAC_1000FD;
+		phy_interface_set_rgmii(config->supported_interfaces);
+
+		__set_bit(PHY_INTERFACE_MODE_MII,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
+	}
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
@@ -307,6 +369,10 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_fast_age = ksz_port_fast_age,
 	.port_max_mtu = lan937x_get_max_mtu,
 	.port_change_mtu = lan937x_change_mtu,
+	.phylink_get_caps = lan937x_phylink_get_caps,
+	.phylink_mac_link_down = ksz_mac_link_down,
+	.phylink_mac_config = lan937x_phylink_mac_config,
+	.phylink_mac_link_up = lan937x_phylink_mac_link_up,
 };
 
 int lan937x_switch_register(struct ksz_device *dev)
-- 
2.30.2

