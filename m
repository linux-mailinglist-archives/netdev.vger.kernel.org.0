Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6762D1DF12C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgEVVbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:31:23 -0400
Received: from foss.arm.com ([217.140.110.172]:42400 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731176AbgEVVbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:31:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE1011477;
        Fri, 22 May 2020 14:31:14 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BD9943F68F;
        Fri, 22 May 2020 14:31:14 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 10/11] net: example acpize xgmac_mdio
Date:   Fri, 22 May 2020 16:30:58 -0500
Message-Id: <20200522213059.1535892-11-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522213059.1535892-1-jeremy.linton@arm.com>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 27 +++++++++++++--------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index c82c85ef5fb3..96ee3bd89983 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -245,14 +245,14 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct mii_bus *bus;
-	struct resource res;
+	struct resource *res;
 	struct mdio_fsl_priv *priv;
 	int ret;
 
-	ret = of_address_to_resource(np, 0, &res);
-	if (ret) {
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
 		dev_err(&pdev->dev, "could not obtain address\n");
-		return ret;
+		return -EINVAL;
 	}
 
 	bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
@@ -263,21 +263,21 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res->start);
 
 	/* Set the PHY base address */
 	priv = bus->priv;
-	priv->mdio_base = of_iomap(np, 0);
+	priv->mdio_base = devm_platform_ioremap_resource(pdev, 0);
 	if (!priv->mdio_base) {
 		ret = -ENOMEM;
 		goto err_ioremap;
 	}
 
-	priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
-						       "little-endian");
+	priv->is_little_endian = device_property_read_bool(&pdev->dev,
+							   "little-endian");
 
-	priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
-						  "fsl,erratum-a011043");
+	priv->has_a011043 = device_property_read_bool(&pdev->dev,
+						      "fsl,erratum-a011043");
 
 	ret = of_mdiobus_register(bus, np);
 	if (ret) {
@@ -320,10 +320,17 @@ static const struct of_device_id xgmac_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, xgmac_mdio_match);
 
+static const struct acpi_device_id xgmac_acpi_match[] = {
+	{ "NXP0006", (kernel_ulong_t)NULL },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, xgmac_acpi_match);
+
 static struct platform_driver xgmac_mdio_driver = {
 	.driver = {
 		.name = "fsl-fman_xmdio",
 		.of_match_table = xgmac_mdio_match,
+		.acpi_match_table = xgmac_acpi_match,
 	},
 	.probe = xgmac_mdio_probe,
 	.remove = xgmac_mdio_remove,
-- 
2.26.2

