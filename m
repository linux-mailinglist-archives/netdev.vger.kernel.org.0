Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2065173A8
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386281AbiEBQGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386284AbiEBQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:06:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFD913F0B;
        Mon,  2 May 2022 09:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507357; x=1683043357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mdNa5vpYzeuV+PQwgwwzti4VZsAM9kgYrf9yZL/L80U=;
  b=dxff2n46Bt7zZC/sWY536PJ/lB8WYhWAPZ+lMiaiRkoNvakALt9DNWR0
   WygvXjqr0tr1SCLKJoKuK4c6cRUJ/VoMsrZUjbLqhHGm/KeZp4b1Nqfhs
   98/gx+hJ9NURxDx6UNbLUOAucwcYbTeXIPgld72F/0rq3jF9qJCtuA/8A
   1HyHPB2W+GFCE0yaURaKyT6/u0PcmAhvlbz36hMW6AbM4ugBhUwFxpqSm
   cSOBNyxlJnjysRPV5MDRYtgyOPHVTdGzZJQhuiAqauPMMKe4KtGgaSyK0
   7CQCMoBP+GWEMYpSqFQNIAS0pectlmwp0znYtH1ZCXJV7F/TC3CRJSiXH
   A==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="94280825"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 09:02:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 09:02:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 09:02:18 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 09/13] net: dsa: microchip: add support for phylink management
Date:   Mon, 2 May 2022 21:28:44 +0530
Message-ID: <20220502155848.30493-10-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220502155848.30493-1-arun.ramadoss@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
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

From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

phylink_get_caps() is implemented and reused KSZ common API for
phylink_mac_link_down() operation

lan937x_phylink_mac_config configures the interface using
lan937x_mac_config and lan937x_phylink_mac_link_up configures
the speed/duplex/flow control.

Currently SGMII & in-band neg are not supported & it will be
added later.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 157 +++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h  |   5 +
 drivers/net/dsa/microchip/lan937x_main.c |  66 ++++++++++
 3 files changed, 228 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index 353800edfa54..4612642e8f5e 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -313,6 +313,163 @@ int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
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
+static void lan937x_apply_rgmii_delay(struct ksz_device *dev, int port, u8 val)
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
+		lan937x_apply_rgmii_delay(dev, port, data8);
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
index 4e6d6f41e138..0141d417c446 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -33,6 +33,11 @@ int lan937x_reset_switch(struct ksz_device *dev);
 void lan937x_cfg_port_member(struct ksz_device *dev, int port,
 			     u8 member);
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
+void lan937x_config_interface(struct ksz_device *dev, int port,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause);
+void lan937x_mac_config(struct ksz_device *dev, int port,
+			phy_interface_t interface);
 
 extern const struct dsa_switch_ops lan937x_switch_ops;
 extern const struct ksz_dev_ops lan937x_dev_ops;
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index f48b54d9d2c0..38d5311bf21f 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -258,6 +258,68 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
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
+	if (lan937x_is_internal_phy_port(dev, port)) {
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
@@ -270,6 +332,10 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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
2.33.0

