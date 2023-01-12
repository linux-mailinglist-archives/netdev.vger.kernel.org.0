Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489FF667909
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbjALPX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjALPWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:22:54 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916385E674;
        Thu, 12 Jan 2023 07:15:28 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 1D4191695;
        Thu, 12 Jan 2023 16:15:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673536526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UL8X5iPeOEkFpX+tWxIlqjpBa+Q45KGX7u55pnVrDdE=;
        b=ly1tq+6t5Kx2ZJeBlBEa+kI3AKPOQXKu7okt4KuckBRVJ7FE4rA7VV48JJxe1K/AZxKrLs
        mrux6tALW07R9EkqKAW6KBeN5HmP1MNXTQdrXpUVwaOwBI24pQkefVZfC67JrH4Oq4OyWo
        fE0dUN0aIgAvzFrcltvcYAb/t+J+FIKXy32u4DZ6b5tOkkWAO6eGJxD0KvuLYo3V0z3pZg
        xS2cnn4T48RjuheFVPasaWI3D3tmhZ8Ttl+g6HwHqhMjLMb3kplmKxYPSFpXsezbRXFiJR
        yu0VH8lbaMa/4oS/k59AGb8tUIKXH3rWAlS5YYHfvRp+6GoUfbMqyylROyQzlw==
From:   Michael Walle <michael@walle.cc>
Date:   Thu, 12 Jan 2023 16:15:12 +0100
Subject: [PATCH net-next 06/10] net: ethernet: mtk_eth_soc: Separate C22 and
 C45 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-net-next-c45-seperation-part-2-v1-6-5eeaae931526@walle.cc>
References: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
In-Reply-To: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Li Yang <leoyang.li@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The mediatek bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 178 +++++++++++++++++-----------
 1 file changed, 112 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e3de9a53b2d9..dc50e0b227a6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -215,8 +215,8 @@ static int mtk_mdio_busy_wait(struct mtk_eth *eth)
 	return -ETIMEDOUT;
 }
 
-static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
-			   u32 write_data)
+static int _mtk_mdio_write_c22(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
+			       u32 write_data)
 {
 	int ret;
 
@@ -224,35 +224,13 @@ static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
 	if (ret < 0)
 		return ret;
 
-	if (phy_reg & MII_ADDR_C45) {
-		mtk_w32(eth, PHY_IAC_ACCESS |
-			     PHY_IAC_START_C45 |
-			     PHY_IAC_CMD_C45_ADDR |
-			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
-			     PHY_IAC_ADDR(phy_addr) |
-			     PHY_IAC_DATA(mdiobus_c45_regad(phy_reg)),
-			MTK_PHY_IAC);
-
-		ret = mtk_mdio_busy_wait(eth);
-		if (ret < 0)
-			return ret;
-
-		mtk_w32(eth, PHY_IAC_ACCESS |
-			     PHY_IAC_START_C45 |
-			     PHY_IAC_CMD_WRITE |
-			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
-			     PHY_IAC_ADDR(phy_addr) |
-			     PHY_IAC_DATA(write_data),
-			MTK_PHY_IAC);
-	} else {
-		mtk_w32(eth, PHY_IAC_ACCESS |
-			     PHY_IAC_START_C22 |
-			     PHY_IAC_CMD_WRITE |
-			     PHY_IAC_REG(phy_reg) |
-			     PHY_IAC_ADDR(phy_addr) |
-			     PHY_IAC_DATA(write_data),
-			MTK_PHY_IAC);
-	}
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		PHY_IAC_START_C22 |
+		PHY_IAC_CMD_WRITE |
+		PHY_IAC_REG(phy_reg) |
+		PHY_IAC_ADDR(phy_addr) |
+		PHY_IAC_DATA(write_data),
+		MTK_PHY_IAC);
 
 	ret = mtk_mdio_busy_wait(eth);
 	if (ret < 0)
@@ -261,7 +239,8 @@ static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg,
 	return 0;
 }
 
-static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
+static int _mtk_mdio_write_c45(struct mtk_eth *eth, u32 phy_addr,
+			       u32 devad, u32 phy_reg, u32 write_data)
 {
 	int ret;
 
@@ -269,33 +248,82 @@ static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
 	if (ret < 0)
 		return ret;
 
-	if (phy_reg & MII_ADDR_C45) {
-		mtk_w32(eth, PHY_IAC_ACCESS |
-			     PHY_IAC_START_C45 |
-			     PHY_IAC_CMD_C45_ADDR |
-			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
-			     PHY_IAC_ADDR(phy_addr) |
-			     PHY_IAC_DATA(mdiobus_c45_regad(phy_reg)),
-			MTK_PHY_IAC);
-
-		ret = mtk_mdio_busy_wait(eth);
-		if (ret < 0)
-			return ret;
-
-		mtk_w32(eth, PHY_IAC_ACCESS |
-			     PHY_IAC_START_C45 |
-			     PHY_IAC_CMD_C45_READ |
-			     PHY_IAC_REG(mdiobus_c45_devad(phy_reg)) |
-			     PHY_IAC_ADDR(phy_addr),
-			MTK_PHY_IAC);
-	} else {
-		mtk_w32(eth, PHY_IAC_ACCESS |
-			     PHY_IAC_START_C22 |
-			     PHY_IAC_CMD_C22_READ |
-			     PHY_IAC_REG(phy_reg) |
-			     PHY_IAC_ADDR(phy_addr),
-			MTK_PHY_IAC);
-	}
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		PHY_IAC_START_C45 |
+		PHY_IAC_CMD_C45_ADDR |
+		PHY_IAC_REG(devad) |
+		PHY_IAC_ADDR(phy_addr) |
+		PHY_IAC_DATA(phy_reg),
+		MTK_PHY_IAC);
+
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
+
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		PHY_IAC_START_C45 |
+		PHY_IAC_CMD_WRITE |
+		PHY_IAC_REG(devad) |
+		PHY_IAC_ADDR(phy_addr) |
+		PHY_IAC_DATA(write_data),
+		MTK_PHY_IAC);
+
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int _mtk_mdio_read_c22(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
+{
+	int ret;
+
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
+
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		PHY_IAC_START_C22 |
+		PHY_IAC_CMD_C22_READ |
+		PHY_IAC_REG(phy_reg) |
+		PHY_IAC_ADDR(phy_addr),
+		MTK_PHY_IAC);
+
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
+
+	return mtk_r32(eth, MTK_PHY_IAC) & PHY_IAC_DATA_MASK;
+}
+
+static int _mtk_mdio_read_c45(struct mtk_eth *eth, u32 phy_addr,
+			      u32 devad, u32 phy_reg)
+{
+	int ret;
+
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
+
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		PHY_IAC_START_C45 |
+		PHY_IAC_CMD_C45_ADDR |
+		PHY_IAC_REG(devad) |
+		PHY_IAC_ADDR(phy_addr) |
+		PHY_IAC_DATA(phy_reg),
+		MTK_PHY_IAC);
+
+	ret = mtk_mdio_busy_wait(eth);
+	if (ret < 0)
+		return ret;
+
+	mtk_w32(eth, PHY_IAC_ACCESS |
+		PHY_IAC_START_C45 |
+		PHY_IAC_CMD_C45_READ |
+		PHY_IAC_REG(devad) |
+		PHY_IAC_ADDR(phy_addr),
+		MTK_PHY_IAC);
 
 	ret = mtk_mdio_busy_wait(eth);
 	if (ret < 0)
@@ -304,19 +332,35 @@ static int _mtk_mdio_read(struct mtk_eth *eth, u32 phy_addr, u32 phy_reg)
 	return mtk_r32(eth, MTK_PHY_IAC) & PHY_IAC_DATA_MASK;
 }
 
-static int mtk_mdio_write(struct mii_bus *bus, int phy_addr,
-			  int phy_reg, u16 val)
+static int mtk_mdio_write_c22(struct mii_bus *bus, int phy_addr,
+			      int phy_reg, u16 val)
+{
+	struct mtk_eth *eth = bus->priv;
+
+	return _mtk_mdio_write_c22(eth, phy_addr, phy_reg, val);
+}
+
+static int mtk_mdio_write_c45(struct mii_bus *bus, int phy_addr,
+			      int devad, int phy_reg, u16 val)
+{
+	struct mtk_eth *eth = bus->priv;
+
+	return _mtk_mdio_write_c45(eth, phy_addr, devad, phy_reg, val);
+}
+
+static int mtk_mdio_read_c22(struct mii_bus *bus, int phy_addr, int phy_reg)
 {
 	struct mtk_eth *eth = bus->priv;
 
-	return _mtk_mdio_write(eth, phy_addr, phy_reg, val);
+	return _mtk_mdio_read_c22(eth, phy_addr, phy_reg);
 }
 
-static int mtk_mdio_read(struct mii_bus *bus, int phy_addr, int phy_reg)
+static int mtk_mdio_read_c45(struct mii_bus *bus, int phy_addr, int devad,
+			     int phy_reg)
 {
 	struct mtk_eth *eth = bus->priv;
 
-	return _mtk_mdio_read(eth, phy_addr, phy_reg);
+	return _mtk_mdio_read_c45(eth, phy_addr, devad, phy_reg);
 }
 
 static int mt7621_gmac0_rgmii_adjust(struct mtk_eth *eth,
@@ -760,8 +804,10 @@ static int mtk_mdio_init(struct mtk_eth *eth)
 	}
 
 	eth->mii_bus->name = "mdio";
-	eth->mii_bus->read = mtk_mdio_read;
-	eth->mii_bus->write = mtk_mdio_write;
+	eth->mii_bus->read = mtk_mdio_read_c22;
+	eth->mii_bus->write = mtk_mdio_write_c22;
+	eth->mii_bus->read_c45 = mtk_mdio_read_c45;
+	eth->mii_bus->write_c45 = mtk_mdio_write_c45;
 	eth->mii_bus->probe_capabilities = MDIOBUS_C22_C45;
 	eth->mii_bus->priv = eth;
 	eth->mii_bus->parent = eth->dev;

-- 
2.30.2
