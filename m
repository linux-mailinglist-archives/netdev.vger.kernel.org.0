Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3407673987
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjASNJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjASNIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:08:05 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD4261896;
        Thu, 19 Jan 2023 05:08:02 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id CE88C1A07;
        Thu, 19 Jan 2023 14:07:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674133680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KB9q2klnkcEtMLmw33Oo0QuC0liZTfwwOM7ryE/7LOs=;
        b=W3xTjohztJGbXmy3C4u8IpeO8WIju8y6jS2QjgV3yMJCcfEXSd3ETq7Z4OZhilXOOdMzmu
        2+FxZ9xPwbZnvOSBQl2UxSX83+1u50X728rQuuGR4OLvs0i/zqvShDClDGNiuFheptSiXD
        DfFlCJh3lPXpvvyPuraZEMn+PBB2FgovkCTsx01k82hbUB4erF0wAJsX1HHp5H4bUcZn89
        3U4w72R4WseRtujUm8DPMxwXj07OZey/1a5d43QQ/xEdnyBBgNCiOwVICGYlMWqeSq0KKQ
        aJ7sxUSDqqgiEALb31v+Mqu+8Wp1yhNM5TYHyaqfdJ0/b4jGLwFrmZ4anjOHOA==
From:   Michael Walle <michael@walle.cc>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wells Lu <wellslutw@gmail.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RESEND net-next 3/4] net: Remove C45 check in C22 only MDIO bus drivers
Date:   Thu, 19 Jan 2023 14:06:59 +0100
Message-Id: <20230119130700.440601-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119130700.440601-1-michael@walle.cc>
References: <20230119130700.440601-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The MDIO core should not pass a C45 request via the C22 API call any
more. So remove the tests from the drivers.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/dsa/microchip/ksz_common.c                    | 6 ------
 drivers/net/dsa/rzn1_a5psw.c                              | 6 ------
 drivers/net/dsa/sja1105/sja1105_mdio.c                    | 6 ------
 drivers/net/ethernet/actions/owl-emac.c                   | 6 ------
 drivers/net/ethernet/engleder/tsnep_main.c                | 6 ------
 drivers/net/ethernet/marvell/mvmdio.c                     | 6 ------
 drivers/net/ethernet/mediatek/mtk_star_emac.c             | 6 ------
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c    | 6 ------
 drivers/net/ethernet/sunplus/spl2sw_mdio.c                | 6 ------
 drivers/net/mdio/mdio-i2c.c                               | 6 ------
 drivers/net/mdio/mdio-ipq8064.c                           | 8 --------
 drivers/net/mdio/mdio-mscc-miim.c                         | 6 ------
 drivers/net/mdio/mdio-mvusb.c                             | 6 ------
 13 files changed, 80 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5e1e5bd555d2..28d26e80e256 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1777,9 +1777,6 @@ static int ksz_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	u16 val;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	ret = dev->dev_ops->r_phy(dev, addr, regnum, &val);
 	if (ret < 0)
 		return ret;
@@ -1792,9 +1789,6 @@ static int ksz_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
 {
 	struct ksz_device *dev = bus->priv;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	return dev->dev_ops->w_phy(dev, addr, regnum, val);
 }
 
diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index ed413d555bec..919027cf2012 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -781,9 +781,6 @@ static int a5psw_mdio_read(struct mii_bus *bus, int phy_id, int phy_reg)
 	u32 cmd, status;
 	int ret;
 
-	if (phy_reg & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	cmd = A5PSW_MDIO_COMMAND_READ;
 	cmd |= FIELD_PREP(A5PSW_MDIO_COMMAND_REG_ADDR, phy_reg);
 	cmd |= FIELD_PREP(A5PSW_MDIO_COMMAND_PHY_ADDR, phy_id);
@@ -809,9 +806,6 @@ static int a5psw_mdio_write(struct mii_bus *bus, int phy_id, int phy_reg,
 	struct a5psw *a5psw = bus->priv;
 	u32 cmd;
 
-	if (phy_reg & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	cmd = FIELD_PREP(A5PSW_MDIO_COMMAND_REG_ADDR, phy_reg);
 	cmd |= FIELD_PREP(A5PSW_MDIO_COMMAND_PHY_ADDR, phy_id);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 2fcb601cb4eb..01f1cb719042 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -235,9 +235,6 @@ static int sja1105_base_tx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	u32 tmp;
 	int rc;
 
-	if (reg & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	rc = sja1105_xfer_u32(priv, SPI_READ, regs->mdio_100base_tx + reg,
 			      &tmp, NULL);
 	if (rc < 0)
@@ -254,9 +251,6 @@ static int sja1105_base_tx_mdio_write(struct mii_bus *bus, int phy, int reg,
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 tmp = val;
 
-	if (reg & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->mdio_100base_tx + reg,
 				&tmp, NULL);
 }
diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
index cd4d71b83c33..c6f8f852bff1 100644
--- a/drivers/net/ethernet/actions/owl-emac.c
+++ b/drivers/net/ethernet/actions/owl-emac.c
@@ -1275,9 +1275,6 @@ static int owl_emac_mdio_read(struct mii_bus *bus, int addr, int regnum)
 	u32 data, tmp;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	data = OWL_EMAC_BIT_MAC_CSR10_SB;
 	data |= OWL_EMAC_VAL_MAC_CSR10_OPCODE_RD << OWL_EMAC_OFF_MAC_CSR10_OPCODE;
 
@@ -1305,9 +1302,6 @@ owl_emac_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
 	struct owl_emac_priv *priv = bus->priv;
 	u32 data, tmp;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	data = OWL_EMAC_BIT_MAC_CSR10_SB;
 	data |= OWL_EMAC_VAL_MAC_CSR10_OPCODE_WR << OWL_EMAC_OFF_MAC_CSR10_OPCODE;
 
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 5a909c1c11bc..e9dfefba5973 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -130,9 +130,6 @@ static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
 	u32 md;
 	int retval;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	md = ECM_MD_READ;
 	if (!adapter->suppress_preamble)
 		md |= ECM_MD_PREAMBLE;
@@ -154,9 +151,6 @@ static int tsnep_mdiobus_write(struct mii_bus *bus, int addr, int regnum,
 	u32 md;
 	int retval;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	md = ECM_MD_WRITE;
 	if (!adapter->suppress_preamble)
 		md |= ECM_MD_PREAMBLE;
diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 2d654a40af13..8662543ca5c8 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -146,9 +146,6 @@ static int orion_mdio_smi_read(struct mii_bus *bus, int mii_id,
 	u32 val;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	ret = orion_mdio_wait_ready(&orion_mdio_smi_ops, bus);
 	if (ret < 0)
 		return ret;
@@ -177,9 +174,6 @@ static int orion_mdio_smi_write(struct mii_bus *bus, int mii_id,
 	struct orion_mdio_dev *dev = bus->priv;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	ret = orion_mdio_wait_ready(&orion_mdio_smi_ops, bus);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 7050351250b7..02c03325911f 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1378,9 +1378,6 @@ static int mtk_star_mdio_read(struct mii_bus *mii, int phy_id, int regnum)
 	unsigned int val, data;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	mtk_star_mdio_rwok_clear(priv);
 
 	val = (regnum << MTK_STAR_OFF_PHY_CTRL0_PREG);
@@ -1407,9 +1404,6 @@ static int mtk_star_mdio_write(struct mii_bus *mii, int phy_id,
 	struct mtk_star_priv *priv = mii->priv;
 	unsigned int val;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	mtk_star_mdio_rwok_clear(priv);
 
 	val = data;
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index 7ac06fd31011..654190263535 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -213,9 +213,6 @@ static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
 	int ret;
 	u32 val;
 
-	if (phy_reg & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	/* Send mdio read request */
 	cmd = mlxbf_gige_mdio_create_cmd(priv->mdio_gw, 0, phy_add, phy_reg,
 					 MLXBF_GIGE_MDIO_CL22_READ);
@@ -249,9 +246,6 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 	u32 cmd;
 	int ret;
 
-	if (phy_reg & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	/* Send mdio write request */
 	cmd = mlxbf_gige_mdio_create_cmd(priv->mdio_gw, val, phy_add, phy_reg,
 					 MLXBF_GIGE_MDIO_CL22_WRITE);
diff --git a/drivers/net/ethernet/sunplus/spl2sw_mdio.c b/drivers/net/ethernet/sunplus/spl2sw_mdio.c
index 733ae1704269..c8ef17e34f3c 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_mdio.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_mdio.c
@@ -61,9 +61,6 @@ static int spl2sw_mii_read(struct mii_bus *bus, int addr, int regnum)
 {
 	struct spl2sw_common *comm = bus->priv;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	return spl2sw_mdio_access(comm, SPL2SW_MDIO_READ_CMD, addr, regnum, 0);
 }
 
@@ -72,9 +69,6 @@ static int spl2sw_mii_write(struct mii_bus *bus, int addr, int regnum, u16 val)
 	struct spl2sw_common *comm = bus->priv;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	ret = spl2sw_mdio_access(comm, SPL2SW_MDIO_WRITE_CMD, addr, regnum, val);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
index 9577a1842997..1e0c206d0f2e 100644
--- a/drivers/net/mdio/mdio-i2c.c
+++ b/drivers/net/mdio/mdio-i2c.c
@@ -297,9 +297,6 @@ static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
 	int bus_addr, ret;
 	u16 val;
 
-	if (!(reg & MII_ADDR_C45))
-		return -EOPNOTSUPP;
-
 	bus_addr = i2c_mii_phy_addr(phy_id);
 	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
 		return 0xffff;
@@ -331,9 +328,6 @@ static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int reg,
 	int bus_addr, ret;
 	u8 buf[6];
 
-	if (!(reg & MII_ADDR_C45))
-		return -EOPNOTSUPP;
-
 	bus_addr = i2c_mii_phy_addr(phy_id);
 	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
 		return 0;
diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 37e0d8b6da07..fd9716960106 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -57,10 +57,6 @@ ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
 	u32 ret_val;
 	int err;
 
-	/* Reject clause 45 */
-	if (reg_offset & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
 		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
 
@@ -81,10 +77,6 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 	u32 miiaddr = MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;
 	struct ipq8064_mdio *priv = bus->priv;
 
-	/* Reject clause 45 */
-	if (reg_offset & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	regmap_write(priv->base, MII_DATA_REG_ADDR, data);
 
 	miiaddr |= ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 51f68daac152..c87e991d1a17 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -108,9 +108,6 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	u32 val;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	ret = mscc_miim_wait_pending(bus);
 	if (ret)
 		goto out;
@@ -154,9 +151,6 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	struct mscc_miim_dev *miim = bus->priv;
 	int ret;
 
-	if (regnum & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	ret = mscc_miim_wait_pending(bus);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/mdio/mdio-mvusb.c b/drivers/net/mdio/mdio-mvusb.c
index d5eabddfdf51..68fc55906e78 100644
--- a/drivers/net/mdio/mdio-mvusb.c
+++ b/drivers/net/mdio/mdio-mvusb.c
@@ -34,9 +34,6 @@ static int mvusb_mdio_read(struct mii_bus *mdio, int dev, int reg)
 	struct mvusb_mdio *mvusb = mdio->priv;
 	int err, alen;
 
-	if (dev & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	mvusb->buf[MVUSB_CMD_ADDR] = cpu_to_le16(0xa400 | (dev << 5) | reg);
 
 	err = usb_bulk_msg(mvusb->udev, usb_sndbulkpipe(mvusb->udev, 2),
@@ -57,9 +54,6 @@ static int mvusb_mdio_write(struct mii_bus *mdio, int dev, int reg, u16 val)
 	struct mvusb_mdio *mvusb = mdio->priv;
 	int alen;
 
-	if (dev & MII_ADDR_C45)
-		return -EOPNOTSUPP;
-
 	mvusb->buf[MVUSB_CMD_ADDR] = cpu_to_le16(0x8000 | (dev << 5) | reg);
 	mvusb->buf[MVUSB_CMD_VAL]  = cpu_to_le16(val);
 
-- 
2.30.2

