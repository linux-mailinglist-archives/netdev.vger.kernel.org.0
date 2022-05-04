Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C063E51A3C0
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352304AbiEDPYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352296AbiEDPXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:23:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2067E44A09;
        Wed,  4 May 2022 08:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651677610; x=1683213610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LvWqqIHHriHmyFCRg3cnkbRVHkbqUk+UGne99ixefwE=;
  b=cM+FqQ/TryG0C77Txmc4RRmN76ADZw6GgHRCD/WWQVSn1gWAAYJ2slvk
   fdQrwDJ2hgCBnBP0nstXtYG6z4cXbcg5+7t3Po7xqRACffnkXCfhxHxAy
   CIYPvWfzjCztYdwiqnfP8bj4TT/wsgVfAutui/RAkUfNc4Nb6i8vYfgVC
   6gO13H0r5nMqv8rJ0b/7IfLOtd/RFUBHqahG1Uh6DoB7Qa0LSEng0/y88
   hY2Xi2oVcK2yh5HwUAxVa+o+7QplrxjWYFz0oJf6T8FRe9cZe8pkDWLKJ
   LUbXlXfvOj9hI2OpxE25YlhoVgSBXGmheC+Upc4OQ4WcQDxuEzXbiImIU
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="154805074"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 08:20:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 08:20:04 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 4 May 2022 08:19:50 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [Patch net-next v13 06/13] net: dsa: microchip: add support for phy read and write
Date:   Wed, 4 May 2022 20:47:48 +0530
Message-ID: <20220504151755.11737-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220504151755.11737-1-arun.ramadoss@microchip.com>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
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

This patch add support for the writing and reading of the phy registers.
LAN937x uses the Vphy indirect addressing method for accessing the phys.
And mdio bus is registered in this patch, mdio read and write inturn
uses the vphy.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 198 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/lan937x_dev.h  |   4 +
 drivers/net/dsa/microchip/lan937x_main.c |  23 +++
 3 files changed, 223 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index aee8100659f8..3f1797cc1d16 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -121,6 +121,36 @@ static void lan937x_switch_exit(struct ksz_device *dev)
 	lan937x_reset_switch(dev);
 }
 
+static int lan937x_enable_spi_indirect_access(struct ksz_device *dev)
+{
+	u16 data16;
+	u8 data8;
+	int ret;
+
+	ret = ksz_read8(dev, REG_GLOBAL_CTRL_0, &data8);
+	if (ret < 0)
+		return ret;
+
+	/* Check if PHY register is blocked */
+	if (data8 & SW_PHY_REG_BLOCK) {
+		/* Enable Phy access through SPI */
+		data8 &= ~SW_PHY_REG_BLOCK;
+
+		ret = ksz_write8(dev, REG_GLOBAL_CTRL_0, data8);
+		if (ret < 0)
+			return ret;
+	}
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
 static u32 lan937x_get_port_addr(int port, int offset)
 {
 	return PORT_CTRL_ADDR(port, offset);
@@ -171,6 +201,88 @@ bool lan937x_is_internal_base_t1_phy_port(struct ksz_device *dev, int port)
 	return false;
 }
 
+static int lan937x_vphy_ind_addr_wr(struct ksz_device *dev, int addr, int reg)
+{
+	u16 temp, addr_base;
+
+	if (lan937x_is_internal_base_tx_phy_port(dev, addr))
+		addr_base = REG_PORT_TX_PHY_CTRL_BASE;
+	else
+		addr_base = REG_PORT_T1_PHY_CTRL_BASE;
+
+	/* get register address based on the logical port */
+	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
+
+	return ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
+}
+
+int lan937x_internal_phy_write(struct ksz_device *dev, int addr, int reg,
+			       u16 val)
+{
+	unsigned int value;
+	int ret;
+
+	/* Check for internal phy port */
+	if (!lan937x_is_internal_phy_port(dev, addr))
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
+int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
+			      u16 *val)
+{
+	unsigned int value;
+	int ret;
+
+	/* Check for internal phy port, return 0xffff for non-existent phy */
+	if (!lan937x_is_internal_phy_port(dev, addr))
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
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct dsa_switch *ds = dev->ds;
@@ -205,6 +317,73 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	lan937x_cfg_port_member(dev, port, member);
 }
 
+static int lan937x_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct ksz_device *dev = bus->priv;
+	u16 val;
+	int ret;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	ret = lan937x_internal_phy_read(dev, addr, regnum, &val);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
+static int lan937x_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	struct ksz_device *dev = bus->priv;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	return lan937x_internal_phy_write(dev, addr, regnum, val);
+}
+
+static int lan937x_mdio_register(struct ksz_device *dev)
+{
+	struct dsa_switch *ds = dev->ds;
+	struct device_node *mdio_np;
+	struct mii_bus *bus;
+	int ret;
+
+	mdio_np = of_get_child_by_name(dev->dev->of_node, "mdio");
+	if (!mdio_np) {
+		dev_err(ds->dev, "no MDIO bus node\n");
+		return -ENODEV;
+	}
+
+	bus = devm_mdiobus_alloc(ds->dev);
+	if (!bus) {
+		of_node_put(mdio_np);
+		return -ENOMEM;
+	}
+
+	bus->priv = dev;
+	bus->read = lan937x_sw_mdio_read;
+	bus->write = lan937x_sw_mdio_write;
+	bus->name = "lan937x slave smi";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "SMI-%d", ds->index);
+	bus->parent = ds->dev;
+	bus->phy_mask = ~ds->phys_mii_mask;
+
+	ds->slave_mii_bus = bus;
+
+	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
+	if (ret) {
+		dev_err(ds->dev, "unable to register MDIO bus %s\n",
+			bus->id);
+	}
+
+	of_node_put(mdio_np);
+
+	return ret;
+}
+
 static int lan937x_switch_init(struct ksz_device *dev)
 {
 	dev->ds->ops = &lan937x_switch_ops;
@@ -227,10 +406,25 @@ static int lan937x_init(struct ksz_device *dev)
 	int ret;
 
 	ret = lan937x_switch_init(dev);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev->dev, "failed to initialize the switch");
+		return ret;
+	}
 
-	return ret;
+	/* enable Indirect Access from SPI to the VPHY registers */
+	ret = lan937x_enable_spi_indirect_access(dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to enable spi indirect access");
+		return ret;
+	}
+
+	ret = lan937x_mdio_register(dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to register the mdio");
+		return ret;
+	}
+
+	return 0;
 }
 
 const struct ksz_dev_ops lan937x_dev_ops = {
diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
index 21f4aade0199..4e6d6f41e138 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -21,6 +21,10 @@ int lan937x_pwrite16(struct ksz_device *dev, int port,
 		     int offset, u16 data);
 int lan937x_pwrite32(struct ksz_device *dev, int port,
 		     int offset, u32 data);
+int lan937x_internal_phy_write(struct ksz_device *dev, int addr,
+			       int reg, u16 val);
+int lan937x_internal_phy_read(struct ksz_device *dev, int addr,
+			      int reg, u16 *val);
 bool lan937x_is_internal_phy_port(struct ksz_device *dev, int port);
 bool lan937x_is_internal_base_tx_phy_port(struct ksz_device *dev, int port);
 bool lan937x_is_internal_base_t1_phy_port(struct ksz_device *dev, int port);
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 154d7a0f08ac..88ca91f59a6f 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -23,6 +23,27 @@ static enum dsa_tag_protocol lan937x_get_tag_protocol(struct dsa_switch *ds,
 	return DSA_TAG_PROTO_LAN937X_VALUE;
 }
 
+static int lan937x_phy_read16(struct dsa_switch *ds, int addr, int reg)
+{
+	struct ksz_device *dev = ds->priv;
+	u16 val;
+	int ret;
+
+	ret = lan937x_internal_phy_read(dev, addr, reg, &val);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
+static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
+			       u16 val)
+{
+	struct ksz_device *dev = ds->priv;
+
+	return lan937x_internal_phy_write(dev, addr, reg, val);
+}
+
 static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -199,6 +220,8 @@ static int lan937x_setup(struct dsa_switch *ds)
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
+	.phy_read = lan937x_phy_read16,
+	.phy_write = lan937x_phy_write16,
 	.port_enable = ksz_enable_port,
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
-- 
2.33.0

