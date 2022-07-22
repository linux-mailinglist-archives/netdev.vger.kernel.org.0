Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D417F57DF56
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbiGVJiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbiGVJhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:37:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD46A896D;
        Fri, 22 Jul 2022 02:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658481992; x=1690017992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BdfF98CRWx6SyTbwveVKeEQJzpd1jQk+agHdxGMBL7A=;
  b=ZJ1+7tifSLLaUREzAE5btM8HQu9GSlmADVv2cjKQcaVDKpjMJEwhZNg6
   /kZBrPABl3Y5fsI/F/RhuGk9f4qcrNoRbwOioRSokhTZNEb7RxI6aFVb0
   PgvaYeo9tQf5h1xw2C2jVEjO1MRVhOeOfHGMMV89ICgi++D7rb8vvLrV/
   eZ2wQVLN19HSNkEBaDwMPeTffVeMLRyJ+FgeMqNMUpI9ph78KRziuX2Qs
   9aCWJFAYXA2eajYAd2xKfLsMVWMhNzYuLMC4Ta0MfHNHdwxgCqPDM6FY9
   30Mm7Up7D3WBo2nseZDq93I+FF1R1WSn48zz8km1pj2MajGqhBariTXeZ
   g==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="169043339"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 02:26:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 02:26:24 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 22 Jul 2022 02:26:19 -0700
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
Subject: [Patch net-next v1 4/9] net: dsa: microchip: add support for common phylink mac link up
Date:   Fri, 22 Jul 2022 14:54:54 +0530
Message-ID: <20220722092459.18653-5-arun.ramadoss@microchip.com>
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

This patch add the support for common phylink mac link up for the ksz
series switch. The register address, bit position and values are
configured based on the chip id to the dev->info structure.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   | 26 ++++++++++++++++++-----
 drivers/net/dsa/microchip/ksz_common.h   |  4 ----
 drivers/net/dsa/microchip/lan937x.h      |  4 ----
 drivers/net/dsa/microchip/lan937x_main.c | 27 ------------------------
 4 files changed, 21 insertions(+), 40 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 16825fcf43a8..91d620559f2e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -223,7 +223,6 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = lan937x_phylink_get_caps,
 	.phylink_mac_config = lan937x_phylink_mac_config,
-	.phylink_mac_link_up = lan937x_phylink_mac_link_up,
 	.fdb_dump = ksz9477_fdb_dump,
 	.fdb_add = ksz9477_fdb_add,
 	.fdb_del = ksz9477_fdb_del,
@@ -1467,7 +1466,7 @@ static void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed)
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
 }
 
-void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
+static void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
 {
 	if (speed == SPEED_1000)
 		ksz_set_gbit(dev, port, true);
@@ -1478,7 +1477,7 @@ void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
 		ksz_set_100_10mbit(dev, port, speed);
 }
 
-void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val)
+static void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val)
 {
 	const u8 *bitval = dev->info->xmii_ctrl0;
 	const u16 *regs = dev->info->regs;
@@ -1498,7 +1497,7 @@ void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val)
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
 }
 
-void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val)
+static void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val)
 {
 	const u32 *masks = dev->info->masks;
 	const u16 *regs = dev->info->regs;
@@ -1514,7 +1513,7 @@ void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val)
 	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
 }
 
-void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val)
+static void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val)
 {
 	const u32 *masks = dev->info->masks;
 	const u16 *regs = dev->info->regs;
@@ -1537,6 +1536,23 @@ static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    int duplex, bool tx_pause, bool rx_pause)
 {
 	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
+
+	p = &dev->ports[port];
+
+	/* Internal PHYs */
+	if (dev->info->internal_phy[port])
+		return;
+
+	p->phydev.speed = speed;
+
+	ksz_port_set_xmii_speed(dev, port, speed);
+
+	ksz_set_fullduplex(dev, port, duplex);
+
+	ksz_set_tx_pause(dev, port, tx_pause);
+
+	ksz_set_rx_pause(dev, port, rx_pause);
 
 	if (dev->dev_ops->phylink_mac_link_up)
 		dev->dev_ops->phylink_mac_link_up(dev, port, mode, interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index df8759dc02bd..d386f07cb711 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -313,10 +313,6 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
-void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed);
-void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val);
-void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val);
-void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 72ba9cb2fbc6..0ae553a9b9af 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -17,10 +17,6 @@ void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu);
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config);
-void lan937x_phylink_mac_link_up(struct ksz_device *dev, int port,
-				 unsigned int mode, phy_interface_t interface,
-				 struct phy_device *phydev, int speed,
-				 int duplex, bool tx_pause, bool rx_pause);
 void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 				unsigned int mode,
 				const struct phylink_link_state *state);
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 92275064fa6b..a2e648eacd19 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -345,20 +345,6 @@ static void lan937x_mac_config(struct ksz_device *dev, int port,
 	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
 }
 
-static void lan937x_config_interface(struct ksz_device *dev, int port,
-				     int speed, int duplex,
-				     bool tx_pause, bool rx_pause)
-{
-	ksz_port_set_xmii_speed(dev, port, speed);
-
-	ksz_set_fullduplex(dev, port, duplex);
-
-	ksz_set_tx_pause(dev, port, tx_pause);
-
-	ksz_set_rx_pause(dev, port, rx_pause);
-
-}
-
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config)
 {
@@ -371,19 +357,6 @@ void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 	}
 }
 
-void lan937x_phylink_mac_link_up(struct ksz_device *dev, int port,
-				 unsigned int mode, phy_interface_t interface,
-				 struct phy_device *phydev, int speed,
-				 int duplex, bool tx_pause, bool rx_pause)
-{
-	/* Internal PHYs */
-	if (dev->info->internal_phy[port])
-		return;
-
-	lan937x_config_interface(dev, port, speed, duplex,
-				 tx_pause, rx_pause);
-}
-
 void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 				unsigned int mode,
 				const struct phylink_link_state *state)
-- 
2.36.1

