Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B387563697
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiGAPHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiGAPG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:06:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5380E167C5;
        Fri,  1 Jul 2022 08:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656688018; x=1688224018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0ypvoj6TaFnqZOWdsIFH8+PMgqAVRN8fZIhAsaAGuO0=;
  b=E7wpj8aivK4/tqd8aS43wleqWApq0Oezd07AXl7+67zuLlF7B6eBNcMy
   xhEDFfznJGrjuZ7lh4oWkeOSMesBBKHXWCKXWxbNyESLKGXGPl7TjDNJR
   B3DV5yEp2qBja/drsZKghctXRwL1YovGgTuIzdWGspP5TvboHVrye0zyC
   9dMIgkTNE6AZBCpkv6OSQ/biipALWamVOxsQcnCBY7LX4t17WXRaYMXXh
   5tPqz6EYOGlKm+ApcPNDF1tvO35vjKthYnJDovObXFkYmHO+3wCLYbSm8
   mFDD7vIr1bBm3499S0VvkK4Ji7ECHKierXal5VAxO5LbyDjiD8KERwEFY
   w==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="102670051"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 08:06:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 08:06:54 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 08:06:35 -0700
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
Subject: [Patch net-next v15 07/13] net: dsa: microchip: lan937x: add phy read and write support
Date:   Fri, 1 Jul 2022 20:36:29 +0530
Message-ID: <20220701150629.27247-1-arun.ramadoss@microchip.com>
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

This patch add support for the writing and reading of the phy registers.
LAN937x uses the Vphy indirect addressing method for accessing the phys.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   |   2 +
 drivers/net/dsa/microchip/lan937x.h      |   2 +
 drivers/net/dsa/microchip/lan937x_main.c | 116 +++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h  |  36 +++++++
 4 files changed, 156 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 07b6f34a437e..67bb4bff4d9b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -207,6 +207,8 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.get_port_addr = ksz9477_get_port_addr,
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.port_setup = lan937x_port_setup,
+	.r_phy = lan937x_r_phy,
+	.w_phy = lan937x_w_phy,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
 	.r_mib_stat64 = ksz_r_mib_stats64,
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 534f5a7a1129..370203406a05 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -12,4 +12,6 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 void lan937x_config_cpu_port(struct dsa_switch *ds);
 int lan937x_switch_init(struct ksz_device *dev);
 void lan937x_switch_exit(struct ksz_device *dev);
+void lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
+void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index e167a0c1ff85..5a2e14fe3cf3 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -28,6 +28,114 @@ static int lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
 				  bits, set ? bits : 0);
 }
 
+static int lan937x_enable_spi_indirect_access(struct ksz_device *dev)
+{
+	u16 data16;
+	int ret;
+
+	/* Enable Phy access through SPI */
+	ret = lan937x_cfg(dev, REG_GLOBAL_CTRL_0, SW_PHY_REG_BLOCK, false);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_read16(dev, REG_VPHY_SPECIAL_CTRL__2, &data16);
+	if (ret < 0)
+		return ret;
+
+	/* Allow SPI access */
+	data16 |= VPHY_SPI_INDIRECT_ENABLE;
+
+	return ksz_write16(dev, REG_VPHY_SPECIAL_CTRL__2, data16);
+}
+
+static int lan937x_vphy_ind_addr_wr(struct ksz_device *dev, int addr, int reg)
+{
+	u16 addr_base = REG_PORT_T1_PHY_CTRL_BASE;
+	u16 temp;
+
+	/* get register address based on the logical port */
+	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
+
+	return ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
+}
+
+static int lan937x_internal_phy_write(struct ksz_device *dev, int addr, int reg,
+				      u16 val)
+{
+	unsigned int value;
+	int ret;
+
+	/* Check for internal phy port */
+	if (!dev->info->internal_phy[addr])
+		return -EOPNOTSUPP;
+
+	ret = lan937x_vphy_ind_addr_wr(dev, addr, reg);
+	if (ret < 0)
+		return ret;
+
+	/* Write the data to be written to the VPHY reg */
+	ret = ksz_write16(dev, REG_VPHY_IND_DATA__2, val);
+	if (ret < 0)
+		return ret;
+
+	/* Write the Write En and Busy bit */
+	ret = ksz_write16(dev, REG_VPHY_IND_CTRL__2,
+			  (VPHY_IND_WRITE | VPHY_IND_BUSY));
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_read_poll_timeout(dev->regmap[1], REG_VPHY_IND_CTRL__2,
+				       value, !(value & VPHY_IND_BUSY), 10,
+				       1000);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to write phy register\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
+				     u16 *val)
+{
+	unsigned int value;
+	int ret;
+
+	/* Check for internal phy port, return 0xffff for non-existent phy */
+	if (!dev->info->internal_phy[addr])
+		return 0xffff;
+
+	ret = lan937x_vphy_ind_addr_wr(dev, addr, reg);
+	if (ret < 0)
+		return ret;
+
+	/* Write Read and Busy bit to start the transaction */
+	ret = ksz_write16(dev, REG_VPHY_IND_CTRL__2, VPHY_IND_BUSY);
+	if (ret < 0)
+		return ret;
+
+	ret = regmap_read_poll_timeout(dev->regmap[1], REG_VPHY_IND_CTRL__2,
+				       value, !(value & VPHY_IND_BUSY), 10,
+				       1000);
+	if (ret < 0) {
+		dev_err(dev->dev, "Failed to read phy register\n");
+		return ret;
+	}
+
+	/* Read the VPHY register which has the PHY data */
+	return ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
+}
+
+void lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
+{
+	lan937x_internal_phy_read(dev, addr, reg, data);
+}
+
+void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
+{
+	lan937x_internal_phy_write(dev, addr, reg, val);
+}
+
 int lan937x_reset_switch(struct ksz_device *dev)
 {
 	u32 data32;
@@ -111,6 +219,14 @@ void lan937x_config_cpu_port(struct dsa_switch *ds)
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	int ret;
+
+	/* enable Indirect Access from SPI to the VPHY registers */
+	ret = lan937x_enable_spi_indirect_access(dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to enable spi indirect access");
+		return ret;
+	}
 
 	/* The VLAN aware is a global setting. Mixed vlan
 	 * filterings are not supported.
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index 5e27b2bd2d86..7a0fa2595950 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -8,6 +8,12 @@
 #define PORT_CTRL_ADDR(port, addr)	((addr) | (((port) + 1)  << 12))
 
 /* 0 - Operation */
+#define REG_GLOBAL_CTRL_0		0x0007
+
+#define SW_PHY_REG_BLOCK		BIT(7)
+#define SW_FAST_MODE			BIT(3)
+#define SW_FAST_MODE_OVERRIDE		BIT(2)
+
 #define REG_SW_INT_STATUS__4		0x0010
 #define REG_SW_INT_MASK__4		0x0014
 
@@ -82,6 +88,33 @@
 #define ALU_V_USE_FID			BIT(30)
 #define ALU_V_PORT_MAP			0xFF
 
+/* 7 - VPhy */
+#define REG_VPHY_IND_ADDR__2		0x075C
+#define REG_VPHY_IND_DATA__2		0x0760
+
+#define REG_VPHY_IND_CTRL__2		0x0768
+
+#define VPHY_IND_WRITE			BIT(1)
+#define VPHY_IND_BUSY			BIT(0)
+
+#define REG_VPHY_SPECIAL_CTRL__2	0x077C
+#define VPHY_SMI_INDIRECT_ENABLE	BIT(15)
+#define VPHY_SW_LOOPBACK		BIT(14)
+#define VPHY_MDIO_INTERNAL_ENABLE	BIT(13)
+#define VPHY_SPI_INDIRECT_ENABLE	BIT(12)
+#define VPHY_PORT_MODE_M		0x3
+#define VPHY_PORT_MODE_S		8
+#define VPHY_MODE_RGMII			0
+#define VPHY_MODE_MII_PHY		1
+#define VPHY_MODE_SGMII			2
+#define VPHY_MODE_RMII_PHY		3
+#define VPHY_SW_COLLISION_TEST		BIT(7)
+#define VPHY_SPEED_DUPLEX_STAT_M	0x7
+#define VPHY_SPEED_DUPLEX_STAT_S	2
+#define VPHY_SPEED_1000			BIT(4)
+#define VPHY_SPEED_100			BIT(3)
+#define VPHY_FULL_DUPLEX		BIT(2)
+
 /* Port Registers */
 
 /* 0 - Operation */
@@ -94,6 +127,9 @@
 #define PORT_TAIL_TAG_ENABLE		BIT(2)
 #define PORT_QUEUE_SPLIT_ENABLE		0x3
 
+/* 1 - Phy */
+#define REG_PORT_T1_PHY_CTRL_BASE	0x0100
+
 /* 3 - xMII */
 #define REG_PORT_XMII_CTRL_0		0x0300
 #define PORT_SGMII_SEL			BIT(7)
-- 
2.36.1

