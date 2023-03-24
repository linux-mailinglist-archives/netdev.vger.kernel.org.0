Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F606C7B97
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjCXJhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjCXJhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:37:34 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2196C27D5A;
        Fri, 24 Mar 2023 02:37:18 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 615B210000A;
        Fri, 24 Mar 2023 09:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcKUBQLSHXFtjE2P6mUGL1MaMfPe6D0uqDsP8lwztxk=;
        b=DRPhLqRlivFZFcn5sxGWGvCvXLueJeNRU6a6x1Ss+Al8tkSCb8NSP4kMCm0bGeaimo7Nn/
        DBS4IgPw4qKpwM+CKk5aRBe2r4qrh5V2NJBa/MMKRf6fLx/PGKt0Ca8rn3mcpX8YIbYxID
        kgRiYLhwaT0JEsWGCb2QJC4omPtV4n/8xeePK+h77lBwoSzIIFjwcpGB//OvKc1SWHdMFu
        e+xMKCL8C+k8kdQhv1L4vbhDZxA0z61ukf9AtZNDRxvBNZkFcfgqmw4Y22YhUL9fosbded
        D04rhcRphDJ+N/xjfpbUufoZedAA+xUhLxlbKFrt1LHA/etxfGI6zdwEgnMR5Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [RFC 6/7] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
Date:   Fri, 24 Mar 2023 10:36:43 +0100
Message-Id: <20230324093644.464704-7-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly introduced regmap-based MDIO driver allows for an easy mapping
of an mdiodevice onto the memory-mapped TSE PCS, which is actually a
Lynx PCS.

Convert Altera TSE to use this PCS instead of the pcs-altera-tse, which
is nothing more than a memory-mapped Lynx PCS.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/altera/altera_tse.h      |  1 +
 drivers/net/ethernet/altera/altera_tse_main.c | 54 ++++++++++++++++---
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index db5eed06e92d..d50cf440d01b 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -477,6 +477,7 @@ struct altera_tse_private {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 	struct phylink_pcs *pcs;
+	struct mdio_device *pcs_mdiodev;
 };
 
 /* Function prototypes
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 66e3af73ec41..c5f4b5e24376 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -27,14 +27,16 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mii.h>
+#include <linux/mdio/mdio-regmap.h>
 #include <linux/netdevice.h>
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
-#include <linux/pcs-altera-tse.h>
+#include <linux/pcs-lynx.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/skbuff.h>
 #include <asm/cacheflush.h>
 
@@ -1139,13 +1141,21 @@ static int altera_tse_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id = NULL;
 	struct altera_tse_private *priv;
 	struct resource *control_port;
+	struct regmap *pcs_regmap;
 	struct resource *dma_res;
 	struct resource *pcs_res;
+	struct mii_bus *pcs_bus;
 	struct net_device *ndev;
 	void __iomem *descmap;
-	int pcs_reg_width = 2;
 	int ret = -ENODEV;
 
+	struct regmap_config pcs_regmap_cfg;
+
+	struct mdio_regmap_config mrc = {
+		.parent = &pdev->dev,
+		.valid_addr = 0x1,
+	};
+
 	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
 	if (!ndev) {
 		dev_err(&pdev->dev, "Could not allocate network device\n");
@@ -1263,9 +1273,30 @@ static int altera_tse_probe(struct platform_device *pdev)
 	ret = request_and_map(pdev, "pcs", &pcs_res,
 			      &priv->pcs_base);
 	if (ret) {
+		/* If we can't find a dedicated resource for the PCS, fallback
+		 * to the internal PCS, that has a different address stride
+		 */
 		priv->pcs_base = priv->mac_dev + tse_csroffs(mdio_phy0);
-		pcs_reg_width = 4;
+		pcs_regmap_cfg.reg_bits = 32;
+		/* Values are MDIO-like values, on 16 bits */
+		pcs_regmap_cfg.val_bits = 16;
+		pcs_regmap_cfg.reg_stride = 4;
+		pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(2);
+	} else {
+		pcs_regmap_cfg.reg_bits = 16;
+		pcs_regmap_cfg.val_bits = 16;
+		pcs_regmap_cfg.reg_stride = 2;
+		pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
+	}
+
+	/* Create a regmap for the PCS so that it can be used by the PCS driver */
+	pcs_regmap = devm_regmap_init_mmio(&pdev->dev, priv->pcs_base,
+					   &pcs_regmap_cfg);
+	if (IS_ERR(pcs_regmap)) {
+		ret = PTR_ERR(pcs_regmap);
+		goto err_free_netdev;
 	}
+	mrc.regmap = pcs_regmap;
 
 	/* Rx IRQ */
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
@@ -1389,7 +1420,15 @@ static int altera_tse_probe(struct platform_device *pdev)
 			 (unsigned long) control_port->start, priv->rx_irq,
 			 priv->tx_irq);
 
-	priv->pcs = alt_tse_pcs_create(ndev, priv->pcs_base, pcs_reg_width);
+	snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
+	pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
+	priv->pcs_mdiodev = mdio_device_create(pcs_bus, 0);
+
+	priv->pcs = lynx_pcs_create(priv->pcs_mdiodev);
+	if (!priv->pcs) {
+		ret = -ENODEV;
+		goto err_init_phy;
+	}
 
 	priv->phylink_config.dev = &ndev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
@@ -1412,11 +1451,12 @@ static int altera_tse_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->phylink)) {
 		dev_err(&pdev->dev, "failed to create phylink\n");
 		ret = PTR_ERR(priv->phylink);
-		goto err_init_phy;
+		goto err_pcs;
 	}
 
 	return 0;
-
+err_pcs:
+	mdio_device_free(priv->pcs_mdiodev);
 err_init_phy:
 	unregister_netdev(ndev);
 err_register_netdev:
@@ -1438,6 +1478,8 @@ static int altera_tse_remove(struct platform_device *pdev)
 	altera_tse_mdio_destroy(ndev);
 	unregister_netdev(ndev);
 	phylink_destroy(priv->phylink);
+	mdio_device_free(priv->pcs_mdiodev);
+
 	free_netdev(ndev);
 
 	return 0;
-- 
2.39.2

