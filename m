Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0446859BCBA
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbiHVJWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbiHVJV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:21:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7352231378;
        Mon, 22 Aug 2022 02:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661160084; x=1692696084;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1CUM1soV4sz91TsFZvbVRa41osspwvSUHcKRpySzz18=;
  b=PExJWvQcgMG97TJX5y9UvRN+ns2npHdnZsL6Kb5BQGHbKnWZQcb3uOHL
   Pm/s8J0bDIz5b6UVtqZzjIGlQfZfrCVHrhdFGqBOUDMBjFkRKkR1lzT+Q
   /hTTxXpkPmwy6iDWoM9Xe8uRQciPTjv8EJqvLcQNFIK0oLrh78LWDDPuk
   e/AC+YVVKhwPALS6Sgz+yDWZOu14JkMDNkkLWEmYqikgSGyB/KN0BO6Lg
   nG1798nOoXR+dgHcKt1k/i6q7Swc8n5Bqe5iQkAyqgBx1E+oMDMIl/Kaf
   sEmSl5w1wcuq5NqbNkGQfze/Rfm0oGOB7FIk93/Ch0TVCP94PJdBPITa2
   g==;
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="177196917"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2022 02:21:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 22 Aug 2022 02:21:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 22 Aug 2022 02:21:16 -0700
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
        "Russell King" <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: [RFC Patch net-next v2] net: dsa: microchip: lan937x: enable interrupt for internal phy link detection
Date:   Mon, 22 Aug 2022 14:50:17 +0530
Message-ID: <20220822092017.5671-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables the interrupts for internal phy link detection for
LAN937x. The interrupt enable bits are active low. It first enables port
interrupt and then port phy interrupt. Also patch register the irq
thread and in the ISR routine it clears the POR_READY_STS bit.
POR_READY_STS bit is write one clear bit and all other bit in the
register are read only. Since phy interrupts are handled by the lan937x
phy layer, switch interrupt routine does not read the phy layer
interrupts.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
Changes in RFC v2
- fixed the compilation issue

 drivers/net/dsa/microchip/ksz_common.h   |  1 +
 drivers/net/dsa/microchip/ksz_spi.c      |  2 +
 drivers/net/dsa/microchip/lan937x_main.c | 64 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  | 10 ++++
 4 files changed, 77 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 764ada3a0f42..a84488e6fab6 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -98,6 +98,7 @@ struct ksz_device {
 	struct regmap *regmap[3];
 
 	void *priv;
+	int irq;
 
 	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
 
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 05bd089795f8..7ba897b6f950 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -85,6 +85,8 @@ static int ksz_spi_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	dev->irq = spi->irq;
+
 	ret = ksz_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index daedd2bf20c1..ca786e5edf2c 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -10,6 +10,7 @@
 #include <linux/of_mdio.h>
 #include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
+#include <linux/irq.h>
 #include <linux/math.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
@@ -23,6 +24,11 @@ static int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
 }
 
+static int lan937x_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set)
+{
+	return regmap_update_bits(dev->regmap[2], addr, bits, set ? bits : 0);
+}
+
 static int lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
 			    u8 bits, bool set)
 {
@@ -285,6 +291,16 @@ void lan937x_config_cpu_port(struct dsa_switch *ds)
 
 	dsa_switch_for_each_user_port(dp, ds) {
 		ksz_port_stp_state_set(ds, dp->index, BR_STATE_DISABLED);
+
+		if (dev->info->internal_phy[dp->index]) {
+			/* Enable PORT Interrupt - active low */
+			lan937x_cfg32(dev, REG_SW_PORT_INT_MASK__4,
+				      BIT(dp->index), false);
+
+			/* Enable PORT_PHY_INT interrupt -  active low */
+			lan937x_port_cfg(dev, dp->index, REG_PORT_INT_MASK,
+					 PORT_PHY_INT, false);
+		}
 	}
 }
 
@@ -383,6 +399,50 @@ void lan937x_setup_rgmii_delay(struct ksz_device *dev, int port)
 	}
 }
 
+static irqreturn_t lan937x_switch_irq_thread(int irq, void *dev_id)
+{
+	struct ksz_device *dev = dev_id;
+	irqreturn_t result = IRQ_NONE;
+	u32 data;
+	int ret;
+
+	/* Read global interrupt status register */
+	ret = ksz_read32(dev, REG_SW_INT_STATUS__4, &data);
+	if (ret)
+		return result;
+
+	if (data & POR_READY_INT) {
+		ret = ksz_write32(dev, REG_SW_INT_STATUS__4, POR_READY_INT);
+		if (ret)
+			return result;
+	}
+
+	return result;
+}
+
+static int lan937x_register_interrupt(struct ksz_device *dev)
+{
+	int ret;
+
+	if (dev->irq > 0) {
+		unsigned long irqflags =
+			irqd_get_trigger_type(irq_get_irq_data(dev->irq));
+
+		irqflags |= (IRQF_ONESHOT | IRQF_SHARED);
+
+		ret = devm_request_threaded_irq(dev->dev, dev->irq, NULL,
+						lan937x_switch_irq_thread,
+						irqflags, dev_name(dev->dev),
+						dev);
+		if (ret) {
+			dev_err(dev->dev, "failed to request IRQ.\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
@@ -423,6 +483,10 @@ int lan937x_setup(struct dsa_switch *ds)
 	lan937x_cfg(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
 		    (SW_CLK125_ENB | SW_CLK25_ENB), true);
 
+	ret = lan937x_register_interrupt(dev);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index ba4adaddb3ec..a4b17fc722d2 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -118,6 +118,16 @@
 /* Port Registers */
 
 /* 0 - Operation */
+#define REG_PORT_INT_STATUS		0x001B
+#define REG_PORT_INT_MASK		0x001F
+
+#define PORT_TAS_INT			BIT(5)
+#define PORT_QCI_INT			BIT(4)
+#define PORT_SGMII_INT			BIT(3)
+#define PORT_PTP_INT			BIT(2)
+#define PORT_PHY_INT			BIT(1)
+#define PORT_ACL_INT			BIT(0)
+
 #define REG_PORT_CTRL_0			0x0020
 
 #define PORT_MAC_LOOPBACK		BIT(7)
-- 
2.36.1

