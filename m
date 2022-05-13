Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EC7525FC5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379446AbiEMKYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379464AbiEMKXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:23:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27CB185CB8;
        Fri, 13 May 2022 03:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652437413; x=1683973413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tnNpxFxEBClOHmM1PI0lO7/4uNG4yYPGVdsIwHRiH+U=;
  b=iKAz85I4ZJ0cVoHYERy2GCbAIW//r8/6tEcsGIXAArDtnv6zQdmx83qy
   K4zp7+CxfouYWvvqTr6l+okxP4JNOFzOpxkgRTmVOKHOnpSjxywBqyojs
   hXoXeAS4edsPojzyqqo7Hz7uen/+qqmQ7YP+7eyokV2qrqO49pGjGcmIP
   6I5fo3kHVdkzIQ1Nl3b7x5Au1jCjqtCPxuh8KFqNbBoTorFsE9j+BQPSx
   /CLyV8U5vReBkpLWbQi6BzSKZCffFCKTOvih8/7jxwtd8tR29JyQSpKHB
   pLysb7sGo8cg1V2sxqbu9mDaW6Vtsw0veNU9g1B15PHI8TkPmlv5RMPBD
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="173236907"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2022 03:23:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 13 May 2022 03:23:31 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 13 May 2022 03:23:26 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC Patch net-next v2 8/9] net: dsa: microchip: add the phylink get_caps
Date:   Fri, 13 May 2022 15:52:18 +0530
Message-ID: <20220513102219.30399-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220513102219.30399-1-arun.ramadoss@microchip.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
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

This patch add the support for phylink_get_caps for ksz8795 and ksz9477
series switch. It updates the struct ksz_switch_chip with the details of
the internal phys and xmii interface. Then during the get_caps based on
the bits set in the structure, corresponding phy mode is set.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 10 +--
 drivers/net/dsa/microchip/ksz9477.c    | 10 +++
 drivers/net/dsa/microchip/ksz_common.c | 98 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  8 +++
 4 files changed, 117 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index d6162b00e4fb..9d6d3c69fd47 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1376,15 +1376,7 @@ static void ksz8_get_caps(struct dsa_switch *ds, int port,
 {
 	struct ksz_device *dev = ds->priv;
 
-	if (port == dev->cpu_port) {
-		__set_bit(PHY_INTERFACE_MODE_RMII,
-			  config->supported_interfaces);
-		__set_bit(PHY_INTERFACE_MODE_MII,
-			  config->supported_interfaces);
-	} else {
-		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
-			  config->supported_interfaces);
-	}
+	ksz_phylink_get_caps(ds, port, config);
 
 	config->mac_capabilities = MAC_10 | MAC_100;
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 22ef56e2cb7b..ab40b700cf1a 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1097,6 +1097,15 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
 }
 
+static void ksz9477_get_caps(struct dsa_switch *ds, int port,
+			     struct phylink_config *config)
+{
+	ksz_phylink_get_caps(ds, port, config);
+
+	config->mac_capabilities = MAC_10 | MAC_100 | MAC_1000FD |
+				   MAC_ASYM_PAUSE | MAC_SYM_PAUSE;
+}
+
 static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
@@ -1322,6 +1331,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
+	.phylink_get_caps	= ksz9477_get_caps,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 240a0aab96ff..e21184836bf1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -151,6 +151,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false, true},
+		.supports_rmii = {false, false, false, false, true},
+		.supports_rgmii = {false, false, false, false, true},
+		.internal_phy = {true, true, true, true, false},
 	},
 
 	[KSZ8794] = {
@@ -179,6 +183,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false, true},
+		.supports_rmii = {false, false, false, false, true},
+		.supports_rgmii = {false, false, false, false, true},
+		.internal_phy = {true, true, true, false, false},
 	},
 
 	[KSZ8765] = {
@@ -193,6 +201,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false, true},
+		.supports_rmii = {false, false, false, false, true},
+		.supports_rgmii = {false, false, false, false, true},
+		.internal_phy = {true, true, true, true, false},
 	},
 
 	[KSZ8830] = {
@@ -206,6 +218,9 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz88xx_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, true},
+		.supports_rmii = {false, false, true},
+		.internal_phy = {true, true, false},
 	},
 
 	[KSZ9477] = {
@@ -220,6 +235,14 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false,
+				 false, true, false},
+		.supports_rmii = {false, false, false, false,
+			false, true, false},
+		.supports_rgmii = {false, false, false, false,
+			false, true, false},
+		.internal_phy = {true, true, true, true,
+				true, false, false},
 	},
 
 	[KSZ9897] = {
@@ -234,6 +257,14 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false,
+				 false, true, true},
+		.supports_rmii = {false, false, false, false,
+			false, true, true},
+		.supports_rgmii = {false, false, false, false,
+			false, true, true},
+		.internal_phy = {true, true, true, true,
+				true, false, false},
 	},
 
 	[KSZ9893] = {
@@ -247,6 +278,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, true},
+		.supports_rmii = {false, false, true},
+		.supports_rgmii = {false, false, true},
+		.internal_phy = {true, true, false},
 	},
 
 	[KSZ9567] = {
@@ -261,6 +296,14 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false,
+				 false, true, true},
+		.supports_rmii = {false, false, false, false,
+			false, true, true},
+		.supports_rgmii = {false, false, false, false,
+			false, true, true},
+		.internal_phy = {true, true, true, true,
+				true, false, false},
 	},
 
 	[LAN9370] = {
@@ -274,6 +317,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false, true},
+		.supports_rmii = {false, false, false, false, true},
+		.supports_rgmii = {false, false, false, false, true},
+		.internal_phy = {true, true, true, true, false},
 	},
 
 	[LAN9371] = {
@@ -287,6 +334,10 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false, true, true},
+		.supports_rmii = {false, false, false, false, true, true},
+		.supports_rgmii = {false, false, false, false, true, true},
+		.internal_phy = {true, true, true, true, false, false},
 	},
 
 	[LAN9372] = {
@@ -300,6 +351,14 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false,
+				 true, true, false, false},
+		.supports_rmii = {false, false, false, false,
+				 true, true, false, false},
+		.supports_rgmii = {false, false, false, false,
+				 true, true, false, false},
+		.internal_phy = {true, true, true, true,
+				false, false, true, true},
 	},
 
 	[LAN9373] = {
@@ -313,6 +372,14 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false,
+				 true, true, false, false},
+		.supports_rmii = {false, false, false, false,
+				 true, true, false, false},
+		.supports_rgmii = {false, false, false, false,
+				 true, true, false, false},
+		.internal_phy = {true, true, true, false,
+				false, false, true, true},
 	},
 
 	[LAN9374] = {
@@ -326,6 +393,14 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.supports_mii = {false, false, false, false,
+				 true, true, false, false},
+		.supports_rmii = {false, false, false, false,
+				 true, true, false, false},
+		.supports_rgmii = {false, false, false, false,
+				 true, true, false, false},
+		.internal_phy = {true, true, true, true,
+				false, false, true, true},
 	},
 };
 EXPORT_SYMBOL_GPL(ksz_switch_chips);
@@ -361,6 +436,29 @@ static int ksz_check_device_id(struct ksz_device *dev)
 	return 0;
 }
 
+void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
+			  struct phylink_config *config)
+{
+	struct ksz_device *dev = ds->priv;
+
+	config->legacy_pre_march2020 = false;
+
+	if (dev->info->supports_mii[port])
+		__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
+
+	if (dev->info->supports_rmii[port])
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  config->supported_interfaces);
+
+	if (dev->info->supports_rgmii[port])
+		phy_interface_set_rgmii(config->supported_interfaces);
+
+	if (dev->info->internal_phy[port])
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+}
+EXPORT_SYMBOL_GPL(ksz_phylink_get_caps);
+
 void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 {
 	struct rtnl_link_stats64 *stats;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0c1dc87c8176..846d3aa606ec 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -14,6 +14,8 @@
 #include <linux/regmap.h>
 #include <net/dsa.h>
 
+#define KSZ_MAX_NUM_PORTS 8
+
 struct vlan_table {
 	u32 table[3];
 };
@@ -44,6 +46,10 @@ struct ksz_chip_data {
 	const struct ksz_mib_names *mib_names;
 	int mib_cnt;
 	u8 reg_mib_cnt;
+	bool supports_mii[KSZ_MAX_NUM_PORTS];
+	bool supports_rmii[KSZ_MAX_NUM_PORTS];
+	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
+	bool internal_phy[KSZ_MAX_NUM_PORTS];
 };
 
 struct ksz_port {
@@ -182,6 +188,8 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_get_stats64(struct dsa_switch *ds, int port,
 		     struct rtnl_link_stats64 *s);
+void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
+			  struct phylink_config *config);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common DSA access functions */
-- 
2.33.0

