Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27C857203A
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiGLQDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbiGLQDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:03:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3647222533;
        Tue, 12 Jul 2022 09:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657641828; x=1689177828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=trDax7EE9Dyjpj8Kb8A0IA5xcuOYX0sfuN9+YiqBpKc=;
  b=Y2nlHZtWitw1hB6buu2WK7GyjTGVIvmxleDtrrfQybL7/9WQAC0553gb
   SvDVaKyk7Kl5nDqlEsW2D0nHX1DG4UtbW3wyTe/ZhYL8BnbjUqayCeIir
   ucRpErHP90w5SSw/CMkmUy9BfuQ0Y1j/X1VDL+67BM+nOYhaU5ShVQ2oE
   6/ZrfEp4ejWyl13u4Jc5T5ZjHvOFmhjLzns9zNiVN8wVekEZAP+tb6qgO
   SaxjkodqS8asT+G2wmlrbbJY13K2A6KOdiJRbg34aPQfiQDLaK+rhRCWM
   spD/jvLH2xCdOHbLqKU1wky7H3P/WbiKedGO9ghafSPQTQ74k8BMeX9/D
   A==;
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="171787190"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jul 2022 09:03:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Jul 2022 09:03:46 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 09:03:36 -0700
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
Subject: [RFC Patch net-next 01/10] net: dsa: microchip: lan937x: read rgmii delay from device tree
Date:   Tue, 12 Jul 2022 21:32:59 +0530
Message-ID: <20220712160308.13253-2-arun.ramadoss@microchip.com>
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

This patch read the rgmii tx and rx delay from device tree and stored it
in the ksz_port.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 16 ++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 28d7cb2ce98f..4bc6277b4361 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1499,6 +1499,7 @@ int ksz_switch_register(struct ksz_device *dev)
 	struct device_node *port, *ports;
 	phy_interface_t interface;
 	unsigned int port_num;
+	u32 *value;
 	int ret;
 	int i;
 
@@ -1589,6 +1590,21 @@ int ksz_switch_register(struct ksz_device *dev)
 				}
 				of_get_phy_mode(port,
 						&dev->ports[port_num].interface);
+
+				if (!dev->info->supports_rgmii[port_num])
+					continue;
+
+				value = &dev->ports[port_num].rgmii_rx_val;
+				if (of_property_read_u32(port,
+							 "rx-internal-delay-ps",
+							 value))
+					*value = 0;
+
+				value = &dev->ports[port_num].rgmii_tx_val;
+				if (of_property_read_u32(port,
+							 "tx-internal-delay-ps",
+							 value))
+					*value = 0;
 			}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d5dddb7ec045..41fe6388af9e 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -77,6 +77,8 @@ struct ksz_port {
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
 	u16 max_frame;
+	u32 rgmii_tx_val;
+	u32 rgmii_rx_val;
 };
 
 struct ksz_device {
-- 
2.36.1

