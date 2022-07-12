Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AA857204E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiGLQFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbiGLQFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:05:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA7FC84F7;
        Tue, 12 Jul 2022 09:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641913; x=1689177913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1k5XTFDAgDM9X/EizoVRNhxWLqZmMpiZ7CMzzkUQDA8=;
  b=tjPYOOKH+S015DNrdUAAPmH7nMAFSwI17HiyQyUdfoUoleZEFMHc8uVK
   BQEH9eLkRjBrCZE84ZPzjFX6AsJcYAp+2H03SN7oYIly794fNxdPUO+on
   pH2DgiqtaLn8KYlXA1ZJRCIzbTb3Cy7YryRCdwlqMzxVYNrhZxmYmzBLa
   KfJYYCgeILRmuZ73wNlgKt0Lg3gKNSPhnwIF0Z9rrXRJHsUd082GY0hGV
   ZDLagM98KuD++vfesHPvYGfmJRBSfscrk1vuEZZ2wUlb+wcOn89R9d9rm
   Y/hdJ5T2QXRW+aoSVbkhaT0xdQatIUQObhyMcYYPToFsuts/9+QGBkhNk
   w==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="171787531"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:05:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:05:11 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:05:01 -0700
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
Subject: [RFC Patch net-next 07/10] net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
Date:   Tue, 12 Jul 2022 21:33:05 +0530
Message-ID: <20220712160308.13253-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220712160308.13253-1-arun.ramadoss@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
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

This patch apply the rgmii delay to the xmii tune adjust register based
on the interface selected in phylink mac config. There are two rgmii
port in LAN937x and value to be loaded in the register vary depends on
the port selected.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 61 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  | 18 +++++++
 2 files changed, 79 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index d86ffdf976b0..db88ea567ba6 100644
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
@@ -331,6 +370,9 @@ void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 				unsigned int mode,
 				const struct phylink_link_state *state)
 {
+	phy_interface_t interface = state->interface;
+	struct ksz_port *p = &dev->ports[port];
+
 	/* Internal PHYs */
 	if (dev->info->internal_phy[port])
 		return;
@@ -341,6 +383,25 @@ void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
 	}
 
 	ksz_set_xmii(dev, port, state->interface);
+
+	/* if the delay is 0, do not enable DLL */
+	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		if (p->rgmii_tx_val) {
+			lan937x_set_rgmii_tx_delay(dev, port);
+			dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
+				 port);
+		}
+	}
+
+	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		if (p->rgmii_rx_val) {
+			lan937x_set_rgmii_rx_delay(dev, port);
+			dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
+				 port);
+		}
+	}
 }
 
 int lan937x_setup(struct dsa_switch *ds)
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

