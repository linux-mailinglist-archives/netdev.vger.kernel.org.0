Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4163B5636BA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiGAPMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiGAPMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:12:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926563E5C1;
        Fri,  1 Jul 2022 08:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656688356; x=1688224356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q77Rpqg581RO9Mbbzxx40Z6hkVP0G/fVs0hL1O6DQQM=;
  b=MUT+U4eugTruQT3ch/tZF7XAY2mxw3zyfhoqM+HQqu61CpHL90dmZWZg
   02gWirWvCqoM6ppzaCombGkAF/CFbH6vufR9m/VqtShysCy6iPMwHQDpB
   MneFEXi5KRu4BiewUYyZ9Sc7InphMPWIdQ4dge0zPcSyfN18P1Ifx3d8W
   H9fEO9hmVOS+cmriz0rcj3dtGjjHG8Aj7ba9F2OYWib1DkTgb0biueMBa
   pNuEIx09110I/2zys80Ug2mB+yGlqiQxsNgrt6eKRvJOciHLfzBb98Qj1
   NdSvkDIlgjtn4Su1as7mjBDFCVWxw3UrI5QMI58a+PO8+EPfW+lBUOnPC
   w==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="102671893"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 08:12:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 08:12:35 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 08:12:09 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v15 12/13] net: dsa: microchip: lan937x: add phylink_mac_config support
Date:   Fri, 1 Jul 2022 20:42:03 +0530
Message-ID: <20220701151203.29512-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701144652.10526-1-arun.ramadoss@microchip.com>
References: <20220701144652.10526-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for phylink_mac_config dsa hook. It configures
the mac for MII/RMII modes. The RGMII mode will be added in the future
patches.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   | 12 +++++
 drivers/net/dsa/microchip/ksz_common.h   |  3 ++
 drivers/net/dsa/microchip/lan937x.h      |  3 ++
 drivers/net/dsa/microchip/lan937x_main.c | 58 +++++++++++++++++++++++-
 4 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9972b2fabf27..28d7cb2ce98f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -221,6 +221,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = lan937x_phylink_get_caps,
+	.phylink_mac_config = lan937x_phylink_mac_config,
 	.phylink_mac_link_up = lan937x_phylink_mac_link_up,
 	.fdb_dump = ksz9477_fdb_dump,
 	.fdb_add = ksz9477_fdb_add,
@@ -1341,6 +1342,16 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 	return dev->dev_ops->max_mtu(dev, port);
 }
 
+static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
+				   unsigned int mode,
+				   const struct phylink_link_state *state)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->phylink_mac_config)
+		dev->dev_ops->phylink_mac_config(dev, port, mode, state);
+}
+
 static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
@@ -1428,6 +1439,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
 	.phylink_get_caps	= ksz_phylink_get_caps,
+	.phylink_mac_config	= ksz_phylink_mac_config,
 	.phylink_mac_link_up	= ksz_phylink_mac_link_up,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f449feab5499..d5dddb7ec045 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -271,6 +271,9 @@ struct ksz_dev_ops {
 	int (*max_mtu)(struct ksz_device *dev, int port);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
+	void (*phylink_mac_config)(struct ksz_device *dev, int port,
+				   unsigned int mode,
+				   const struct phylink_link_state *state);
 	void (*phylink_mac_link_up)(struct ksz_device *dev, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 145770aec963..72ba9cb2fbc6 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -21,4 +21,7 @@ void lan937x_phylink_mac_link_up(struct ksz_device *dev, int port,
 				 unsigned int mode, phy_interface_t interface,
 				 struct phy_device *phydev, int speed,
 				 int duplex, bool tx_pause, bool rx_pause);
+void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
+				unsigned int mode,
+				const struct phylink_link_state *state);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 2f480bf4649d..c29d175ca6f7 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -312,6 +312,44 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 	return 0;
 }
 
+static void lan937x_config_gbit(struct ksz_device *dev, bool gbit, u8 *data)
+{
+	if (gbit)
+		*data &= ~PORT_MII_NOT_1GBIT;
+	else
+		*data |= PORT_MII_NOT_1GBIT;
+}
+
+static void lan937x_mac_config(struct ksz_device *dev, int port,
+			       phy_interface_t interface)
+{
+	u8 data8;
+
+	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
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
+	default:
+		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
+			phy_modes(interface), port);
+		return;
+	}
+
+	/* Write the updated value */
+	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
+}
+
 static void lan937x_config_interface(struct ksz_device *dev, int port,
 				     int speed, int duplex,
 				     bool tx_pause, bool rx_pause)
@@ -325,9 +363,9 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
 			PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL);
 
 	if (speed == SPEED_1000)
-		xmii_ctrl1 &= ~PORT_MII_NOT_1GBIT;
+		lan937x_config_gbit(dev, true, &xmii_ctrl1);
 	else
-		xmii_ctrl1 |= PORT_MII_NOT_1GBIT;
+		lan937x_config_gbit(dev, false, &xmii_ctrl1);
 
 	if (speed == SPEED_100)
 		xmii_ctrl0 |= PORT_MII_100MBIT;
@@ -370,6 +408,22 @@ void lan937x_phylink_mac_link_up(struct ksz_device *dev, int port,
 				 tx_pause, rx_pause);
 }
 
+void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
+				unsigned int mode,
+				const struct phylink_link_state *state)
+{
+	/* Internal PHYs */
+	if (dev->info->internal_phy[port])
+		return;
+
+	if (phylink_autoneg_inband(mode)) {
+		dev_err(dev->dev, "In-band AN not supported!\n");
+		return;
+	}
+
+	lan937x_mac_config(dev, port, state->interface);
+}
+
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-- 
2.36.1

