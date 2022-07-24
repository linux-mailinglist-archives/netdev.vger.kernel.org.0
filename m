Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2AA57F467
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 11:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiGXJ34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 05:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiGXJ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 05:29:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1DA193F1;
        Sun, 24 Jul 2022 02:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658654993; x=1690190993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NubMY4TSFycuTBDZyFpnvVVYa8tuWt4wyOTbql+oAMo=;
  b=0EI4M1u3vcrwEerGQRh2JTD+X1ZKlL5Nn8eoB+HbhL8ExdCWtjhsFqSm
   2fngPxeh0Kg2lL5rTmmsE9qeNE8OREz7D9CjS4jjiB1EBwReAGdSiUBN3
   VLLF0NRv6JuWmaNn0YrovXRjrbrqJ5eUbss5YVjmNy3AytJAVR/TlK63R
   /dFNEN9kWkI+ncxQ0TSfzrTjqWQdMm3XVrGXxrs2vhpaMbR/V6fwOodQY
   hhnyxQ/wN+hjNZiMTfJaSarKL9wXYVFOvvDFZVrwPNk4fxFsW+oMqhs6a
   yYHNSMEACutYjWXhMuBZoSc3B2uf1Qys9xw7vFk4A1hQ+EB72ynvOzpr+
   A==;
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="166136655"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2022 02:29:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Jul 2022 02:29:50 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Sun, 24 Jul 2022 02:29:39 -0700
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
Subject: [Patch net-next v2 4/9] net: dsa: microchip: add support for common phylink mac link up
Date:   Sun, 24 Jul 2022 14:58:18 +0530
Message-ID: <20220724092823.24567-5-arun.ramadoss@microchip.com>
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

This patch add the support for common phylink mac link up for the ksz
series switch. The register address, bit position and values are
configured based on the chip id to the dev->info structure.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   | 20 ++++++++++++++++----
 drivers/net/dsa/microchip/ksz_common.h   |  3 ---
 drivers/net/dsa/microchip/lan937x.h      |  4 ----
 drivers/net/dsa/microchip/lan937x_main.c | 22 ----------------------
 4 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 28c21f5a285f..bcf61f815e11 100644
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
@@ -1478,8 +1477,8 @@ void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
 		ksz_set_100_10mbit(dev, port, speed);
 }
 
-void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
-			 bool tx_pause, bool rx_pause)
+static void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
+				bool tx_pause, bool rx_pause)
 {
 	const u8 *bitval = dev->info->xmii_ctrl0;
 	const u32 *masks = dev->info->masks;
@@ -1511,6 +1510,19 @@ static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
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
+	ksz_duplex_flowctrl(dev, port, duplex, tx_pause, rx_pause);
 
 	if (dev->dev_ops->phylink_mac_link_up)
 		dev->dev_ops->phylink_mac_link_up(dev, port, mode, interface,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 3577fa2c5eab..71a344afbf1f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -313,9 +313,6 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
-void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed);
-void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
-			 bool tx_pause, bool rx_pause);
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
index 450ad059d93c..a2e648eacd19 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -345,15 +345,6 @@ static void lan937x_mac_config(struct ksz_device *dev, int port,
 	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
 }
 
-static void lan937x_config_interface(struct ksz_device *dev, int port,
-				     int speed, int duplex,
-				     bool tx_pause, bool rx_pause)
-{
-	ksz_port_set_xmii_speed(dev, port, speed);
-
-	ksz_duplex_flowctrl(dev, port, duplex, tx_pause, rx_pause);
-}
-
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config)
 {
@@ -366,19 +357,6 @@ void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
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

