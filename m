Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8554D554637
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357275AbiFVJKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357274AbiFVJJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:09:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F13930F7D;
        Wed, 22 Jun 2022 02:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888891; x=1687424891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ex7EEdNA0l4W9ocblvz6P5Q2Ph8QUhH9oxSUyhLzrgE=;
  b=YwDlQwOk3KpD3i6QUGflXXoovZfAFxvW4EcvtsocVxmNw+wgS/Y5FKq8
   c+h5G1Dw+fNM6jx1nZQsXKOWm5wDz+sUsbPeAs7ldQhIIHEUKGTxLizEi
   iAFi5LKPNR1Mhw9sSGeYD/oAeDXXSqy8GnkXtOXyOPx73VVbgQ++NW++U
   7z4PHSTsWxAmYj6+RR2TuJEZxhuT+Z77SMVewS9/W1EyX94SXj6BNXoSw
   1/r57XsS43KCpgdgHT52mgGzeJA0wyTzYiIznkIBmQ6sCdR3574CZirBk
   xFHEQXxs0U7dcnfuWSNk7/0edtJCO4cUf37NkhireiHzPlrSRWHt8TONZ
   g==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="179017287"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:08:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:08:10 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:08:06 -0700
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
Subject: [Patch net-next 07/13] net: dsa: microchip: move start of switch to ksz_setup
Date:   Wed, 22 Jun 2022 14:34:19 +0530
Message-ID: <20220622090425.17709-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
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

This patch move the setting the start bit from the individual switch
configuration to ksz_setup

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795_reg.h |  1 -
 drivers/net/dsa/microchip/ksz9477.c     |  3 ---
 drivers/net/dsa/microchip/ksz9477_reg.h |  1 -
 drivers/net/dsa/microchip/ksz_common.c  | 17 +++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  3 +++
 5 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index f2b0399d69d1..32d985296520 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -16,7 +16,6 @@
 
 #define SW_REVISION_M			0x0E
 #define SW_REVISION_S			1
-#define SW_START			0x01
 
 #define KSZ8863_REG_SW_RESET		0x43
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 827e62b032d2..5fa5b3d09146 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1287,9 +1287,6 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	/* enable global MIB counter freeze function */
 	ksz_cfg(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FREEZE, true);
 
-	/* start switch */
-	ksz_cfg(dev, REG_SW_OPERATION, SW_START, true);
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 57e03dfcf869..c0ad83753b13 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -165,7 +165,6 @@
 
 #define SW_DOUBLE_TAG			BIT(7)
 #define SW_RESET			BIT(1)
-#define SW_START			BIT(0)
 
 #define REG_SW_MAC_ADDR_0		0x0302
 #define REG_SW_MAC_ADDR_1		0x0303
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 719fa1b0884e..6da4df520397 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -155,6 +155,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
+		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -190,6 +191,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
+		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -211,6 +213,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
+		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -231,6 +234,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x02,
 		.broadcast_ctrl_reg =  0x06,
 		.multicast_ctrl_reg = 0x04,
+		.start_ctrl_reg = 0x01,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.internal_phy = {true, true, false},
@@ -251,6 +255,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   false, true, false},
 		.supports_rmii	= {false, false, false, false,
@@ -276,6 +281,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -300,6 +306,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.supports_rgmii = {false, false, true},
@@ -321,6 +328,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   false, true, true},
 		.supports_rmii	= {false, false, false, false,
@@ -345,6 +353,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii = {false, false, false, false, true},
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
@@ -365,6 +374,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii = {false, false, false, false, true, true},
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
@@ -385,6 +395,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -409,6 +420,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -433,6 +445,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.stp_ctrl_reg = 0x0B04,
 		.broadcast_ctrl_reg =  0x0332,
 		.multicast_ctrl_reg = 0x0331,
+		.start_ctrl_reg = 0x0300,
 		.supports_mii	= {false, false, false, false,
 				   true, true, false, false},
 		.supports_rmii	= {false, false, false, false,
@@ -672,6 +685,10 @@ int ksz_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
+	/* start switch */
+	regmap_update_bits(dev->regmap[0], dev->info->start_ctrl_reg,
+			   SW_START, SW_START);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ksz_setup);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 35d734ee932e..2cf8474ba626 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -49,6 +49,7 @@ struct ksz_chip_data {
 	int stp_ctrl_reg;
 	int broadcast_ctrl_reg;
 	int multicast_ctrl_reg;
+	int start_ctrl_reg;
 	bool supports_mii[KSZ_MAX_NUM_PORTS];
 	bool supports_rmii[KSZ_MAX_NUM_PORTS];
 	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
@@ -429,6 +430,8 @@ static inline void ksz_regmap_unlock(void *__mtx)
 
 #define MULTICAST_STORM_DISABLE		BIT(6)
 
+#define SW_START			0x01
+
 /* Regmap tables generation */
 #define KSZ_SPI_OP_RD		3
 #define KSZ_SPI_OP_WR		2
-- 
2.36.1

