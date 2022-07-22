Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC13557DF32
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbiGVJlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbiGVJiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:38:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4566C9E75;
        Fri, 22 Jul 2022 02:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658482029; x=1690018029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HApNO1EEj6VyPzbBLVCWL+QVhXr5OKwlpBSBwJWb5lE=;
  b=cAqiTYUiJruyyjPOrPyJS7vFAhMnnO4jXOe7hdGE74Gnqp957RRrzqbT
   daavO3d8N35QLS6lnZ8ogLOblL7XkbpB6d3cJPy1E8uERMrbI3Ja9EMIA
   0Qock0OLsfVi0RiClEtwaqKAxDY5QIgd1ttIMpKfl3rgP2lzn0iKUMlWB
   bd9R3kyW/nZqO1BKwFbdNLFeHb+bmK96OcxPqBeEHY2y5pFn4Udw8Kbc6
   T1Ywvj4Nq9GBu9pJDxNdZkxZNoFFvBiXVQXUgzGoF4jx7zGn2/xm4jRfv
   ml6breeiZvghvYel8JpMR9GGYWj17v8pKg9m7vL5ygnXMtESskJpsN7vh
   w==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="105675684"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 02:27:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 22 Jul 2022 02:27:08 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 22 Jul 2022 02:27:03 -0700
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
Subject: [Patch net-next v1 9/9] net: dsa: microchip: add support for phylink mac config
Date:   Fri, 22 Jul 2022 14:54:59 +0530
Message-ID: <20220722092459.18653-10-arun.ramadoss@microchip.com>
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

This patch add support for phylink mac config for ksz series of
switches. All the files ksz8795, ksz9477 and lan937x uses the ksz common
xmii function. Instead of calling from the individual files, it is moved
to the ksz common phylink mac config function.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c      |  7 -------
 drivers/net/dsa/microchip/ksz9477.c      |  4 ----
 drivers/net/dsa/microchip/ksz_common.c   | 18 ++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h   |  6 +++++-
 drivers/net/dsa/microchip/lan937x.h      |  3 ---
 drivers/net/dsa/microchip/lan937x_main.c | 16 ----------------
 6 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8f807d8eace5..c79a5128235f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -26,11 +26,6 @@
 #include "ksz8795_reg.h"
 #include "ksz8.h"
 
-static bool ksz_is_ksz88x3(struct ksz_device *dev)
-{
-	return dev->chip_id == 0x8830;
-}
-
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -1124,8 +1119,6 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
 			 port);
 		p->interface = dev->compat_interface;
 	}
-
-	ksz_set_xmii(dev, port, p->interface);
 }
 
 void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 301283d1ba82..4b14d80d27ed 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -944,7 +944,6 @@ void ksz9477_get_caps(struct ksz_device *dev, int port,
 
 void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
-	struct ksz_port *p = &dev->ports[port];
 	struct dsa_switch *ds = dev->ds;
 	u16 data16;
 	u8 member;
@@ -987,9 +986,6 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
 			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
 			     true);
-
-		/* configure MAC to 1G & RGMII mode */
-		ksz_set_xmii(dev, port, p->interface);
 	}
 
 	if (cpu_port)
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 35723ca227b7..407bcd58cfa7 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -222,7 +222,6 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = lan937x_phylink_get_caps,
-	.phylink_mac_config = lan937x_phylink_mac_config,
 	.setup_rgmii_delay = lan937x_setup_rgmii_delay,
 	.fdb_dump = ksz9477_fdb_dump,
 	.fdb_add = ksz9477_fdb_add,
@@ -1409,7 +1408,8 @@ static int ksz_max_mtu(struct dsa_switch *ds, int port)
 	return dev->dev_ops->max_mtu(dev, port);
 }
 
-void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface)
+static void ksz_set_xmii(struct ksz_device *dev, int port,
+			 phy_interface_t interface)
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
 	struct ksz_port *p = &dev->ports[port];
@@ -1495,6 +1495,20 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 {
 	struct ksz_device *dev = ds->priv;
 
+	if (ksz_is_ksz88x3(dev))
+		return;
+
+	/* Internal PHYs */
+	if (dev->info->internal_phy[port])
+		return;
+
+	if (phylink_autoneg_inband(mode)) {
+		dev_err(dev->dev, "In-band AN not supported!\n");
+		return;
+	}
+
+	ksz_set_xmii(dev, port, state->interface);
+
 	if (dev->dev_ops->phylink_mac_config)
 		dev->dev_ops->phylink_mac_config(dev, port, mode, state);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 9fd52bf99d94..0412c2bc5f55 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -319,7 +319,6 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
-void ksz_set_xmii(struct ksz_device *dev, int port, phy_interface_t interface);
 phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
@@ -439,6 +438,11 @@ static inline void ksz_regmap_unlock(void *__mtx)
 	mutex_unlock(mtx);
 }
 
+static inline bool ksz_is_ksz88x3(struct ksz_device *dev)
+{
+	return dev->chip_id == KSZ8830_CHIP_ID;
+}
+
 static inline int is_lan937x(struct ksz_device *dev)
 {
 	return dev->chip_id == LAN9370_CHIP_ID ||
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 423521a13c9e..4e0b1dccec27 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -17,8 +17,5 @@ void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu);
 void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
 			      struct phylink_config *config);
-void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
-				unsigned int mode,
-				const struct phylink_link_state *state);
 void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 797fe7f62394..daedd2bf20c1 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -383,22 +383,6 @@ void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port)
 	}
 }
 
-void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
-				unsigned int mode,
-				const struct phylink_link_state *state)
-{
-	/* Internal PHYs */
-	if (dev->info->internal_phy[port])
-		return;
-
-	if (phylink_autoneg_inband(mode)) {
-		dev_err(dev->dev, "In-band AN not supported!\n");
-		return;
-	}
-
-	ksz_set_xmii(dev, port, state->interface);
-}
-
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-- 
2.36.1

