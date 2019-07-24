Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D58731F1
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbfGXOls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:41:48 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42072 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfGXOlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:41:46 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 458B81A037D;
        Wed, 24 Jul 2019 16:41:43 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3945F1A0373;
        Wed, 24 Jul 2019 16:41:43 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id BF14A205D8;
        Wed, 24 Jul 2019 16:41:42 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     andrew@lunn.ch, Rob Herring <robh+dt@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, alexandru.marginean@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/4] enetc: Clean up local mdio bus allocation
Date:   Wed, 24 Jul 2019 17:41:38 +0300
Message-Id: <1563979301-596-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563979301-596-1-git-send-email-claudiu.manoil@nxp.com>
References: <1563979301-596-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Though it works, this is not how it should have been.
What's needed is a pointer to the mdio registers.
Store it properly inside bus->priv allocated space.
Use devm_* variant to further clean up the init error /
remove paths.

Fixes following sparse warning:
 warning: incorrect type in assignment (different address spaces)
    expected void *priv
    got struct enetc_mdio_regs [noderef] <asn:2>*[assigned] regs

Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v1 - added this patch

 .../net/ethernet/freescale/enetc/enetc_mdio.c | 31 +++++++------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 77b9cd10ba2b..1e3cd21c13ee 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -15,7 +15,8 @@ struct enetc_mdio_regs {
 	u32	mdio_addr;	/* MDIO address */
 };
 
-#define bus_to_enetc_regs(bus)	(struct enetc_mdio_regs __iomem *)((bus)->priv)
+#define bus_to_enetc_regs(bus)	(*(struct enetc_mdio_regs __iomem **) \
+				((bus)->priv))
 
 #define ENETC_MDIO_REG_OFFSET	0x1c00
 #define ENETC_MDC_DIV		258
@@ -146,12 +147,12 @@ static int enetc_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 int enetc_mdio_probe(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
-	struct enetc_mdio_regs __iomem *regs;
+	struct enetc_mdio_regs __iomem **regsp;
 	struct device_node *np;
 	struct mii_bus *bus;
-	int ret;
+	int err;
 
-	bus = mdiobus_alloc_size(sizeof(regs));
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*regsp));
 	if (!bus)
 		return -ENOMEM;
 
@@ -159,41 +160,33 @@ int enetc_mdio_probe(struct enetc_pf *pf)
 	bus->read = enetc_mdio_read;
 	bus->write = enetc_mdio_write;
 	bus->parent = dev;
+	regsp = bus->priv;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
 	/* store the enetc mdio base address for this bus */
-	regs = pf->si->hw.port + ENETC_MDIO_REG_OFFSET;
-	bus->priv = regs;
+	*regsp = pf->si->hw.port + ENETC_MDIO_REG_OFFSET;
 
 	np = of_get_child_by_name(dev->of_node, "mdio");
 	if (!np) {
 		dev_err(dev, "MDIO node missing\n");
-		ret = -EINVAL;
-		goto err_registration;
+		return -EINVAL;
 	}
 
-	ret = of_mdiobus_register(bus, np);
-	if (ret) {
+	err = of_mdiobus_register(bus, np);
+	if (err) {
 		of_node_put(np);
 		dev_err(dev, "cannot register MDIO bus\n");
-		goto err_registration;
+		return err;
 	}
 
 	of_node_put(np);
 	pf->mdio = bus;
 
 	return 0;
-
-err_registration:
-	mdiobus_free(bus);
-
-	return ret;
 }
 
 void enetc_mdio_remove(struct enetc_pf *pf)
 {
-	if (pf->mdio) {
+	if (pf->mdio)
 		mdiobus_unregister(pf->mdio);
-		mdiobus_free(pf->mdio);
-	}
 }
-- 
2.17.1

