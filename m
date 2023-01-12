Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE40966790F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjALPXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjALPWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:22:55 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DAE16484;
        Thu, 12 Jan 2023 07:15:27 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id C96DD15E8;
        Thu, 12 Jan 2023 16:15:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673536525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nh59coj550doZXKUioyBaJXnHjL7eqqxkdyADzKG0aw=;
        b=0PJqU0bpJyUWyXm+SQSGiXNKZ9/LdYWX4cRQNkbqH1J4qqJSPWjumCvh8aqI+OzDwYyXMc
        buhluiqJESGW4pmr0bKQzF+OPMsYKo+NOdVOg1nDPaY2JBuiq7jIv2M/qlO6uQ0KVXhRTW
        pVYedVbZBwkSgdL2mEyP6QgF30yZYJMLkspl+lksS3LZT7JxwVl/agdJWk5tgfQY+RiQzY
        4tCDnZkHvhEQmytDQj2YB/59IBbqjirwac+SFzVMcDFEbvy43drC2Ox3UB+o0HJ66ae1tV
        h6VkNjDTFS0n6JS6LUz5upzcF6riFGAShqaBM05hG1rp8dtA2rTlI3Z2dDJeog==
From:   Michael Walle <michael@walle.cc>
Date:   Thu, 12 Jan 2023 16:15:09 +0100
Subject: [PATCH net-next 03/10] net: mdio: mux-bcm-iproc: Separate C22 and C45
 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-net-next-c45-seperation-part-2-v1-3-5eeaae931526@walle.cc>
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

The MDIO mux broadcom iproc can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
Apparently, in the c45 case, the reg value including the MII_ADDR_C45
bit is written to the hardware. Looks weird, that a "random" software
bit is written to a register. Florian is that correct? Also, with this
patch this flag isn't set anymore.
---
 drivers/net/mdio/mdio-mux-bcm-iproc.c | 54 ++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-bcm-iproc.c b/drivers/net/mdio/mdio-mux-bcm-iproc.c
index 014c0baedbd2..956d54846b62 100644
--- a/drivers/net/mdio/mdio-mux-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-mux-bcm-iproc.c
@@ -98,7 +98,7 @@ static int iproc_mdio_wait_for_idle(void __iomem *base, bool result)
  * Return value: Successful Read operation returns read reg values and write
  *      operation returns 0. Failure operation returns negative error code.
  */
-static int start_miim_ops(void __iomem *base,
+static int start_miim_ops(void __iomem *base, bool c45,
 			  u16 phyid, u32 reg, u16 val, u32 op)
 {
 	u32 param;
@@ -112,7 +112,7 @@ static int start_miim_ops(void __iomem *base,
 	param = readl(base + MDIO_PARAM_OFFSET);
 	param |= phyid << MDIO_PARAM_PHY_ID;
 	param |= val << MDIO_PARAM_PHY_DATA;
-	if (reg & MII_ADDR_C45)
+	if (c45)
 		param |= BIT(MDIO_PARAM_C45_SEL);
 
 	writel(param, base + MDIO_PARAM_OFFSET);
@@ -131,28 +131,58 @@ static int start_miim_ops(void __iomem *base,
 	return ret;
 }
 
-static int iproc_mdiomux_read(struct mii_bus *bus, int phyid, int reg)
+static int iproc_mdiomux_read_c22(struct mii_bus *bus, int phyid, int reg)
 {
 	struct iproc_mdiomux_desc *md = bus->priv;
 	int ret;
 
-	ret = start_miim_ops(md->base, phyid, reg, 0, MDIO_CTRL_READ_OP);
+	ret = start_miim_ops(md->base, false, phyid, reg, 0, MDIO_CTRL_READ_OP);
 	if (ret < 0)
-		dev_err(&bus->dev, "mdiomux read operation failed!!!");
+		dev_err(&bus->dev, "mdiomux c22 read operation failed!!!");
 
 	return ret;
 }
 
-static int iproc_mdiomux_write(struct mii_bus *bus,
-			       int phyid, int reg, u16 val)
+static int iproc_mdiomux_read_c45(struct mii_bus *bus, int phyid, int devad,
+				  int reg)
+{
+	struct iproc_mdiomux_desc *md = bus->priv;
+	int ret;
+
+	ret = start_miim_ops(md->base, true, phyid, reg | devad << 16, 0,
+			     MDIO_CTRL_READ_OP);
+	if (ret < 0)
+		dev_err(&bus->dev, "mdiomux read c45 operation failed!!!");
+
+	return ret;
+}
+
+static int iproc_mdiomux_write_c22(struct mii_bus *bus,
+				   int phyid, int reg, u16 val)
+{
+	struct iproc_mdiomux_desc *md = bus->priv;
+	int ret;
+
+	/* Write val at reg offset */
+	ret = start_miim_ops(md->base, false, phyid, reg, val,
+			     MDIO_CTRL_WRITE_OP);
+	if (ret < 0)
+		dev_err(&bus->dev, "mdiomux write c22 operation failed!!!");
+
+	return ret;
+}
+
+static int iproc_mdiomux_write_c45(struct mii_bus *bus,
+				   int phyid, int devad, int reg, u16 val)
 {
 	struct iproc_mdiomux_desc *md = bus->priv;
 	int ret;
 
 	/* Write val at reg offset */
-	ret = start_miim_ops(md->base, phyid, reg, val, MDIO_CTRL_WRITE_OP);
+	ret = start_miim_ops(md->base, true, phyid, reg | devad << 16, val,
+			     MDIO_CTRL_WRITE_OP);
 	if (ret < 0)
-		dev_err(&bus->dev, "mdiomux write operation failed!!!");
+		dev_err(&bus->dev, "mdiomux write c45 operation failed!!!");
 
 	return ret;
 }
@@ -223,8 +253,10 @@ static int mdio_mux_iproc_probe(struct platform_device *pdev)
 	bus->name = "iProc MDIO mux bus";
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%d", pdev->name, pdev->id);
 	bus->parent = &pdev->dev;
-	bus->read = iproc_mdiomux_read;
-	bus->write = iproc_mdiomux_write;
+	bus->read = iproc_mdiomux_read_c22;
+	bus->write = iproc_mdiomux_write_c22;
+	bus->read_c45 = iproc_mdiomux_read_c45;
+	bus->write_c45 = iproc_mdiomux_write_c45;
 
 	bus->phy_mask = ~0;
 	bus->dev.of_node = pdev->dev.of_node;

-- 
2.30.2
