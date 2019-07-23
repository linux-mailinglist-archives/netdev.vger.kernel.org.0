Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2BC471B4B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfGWPQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:16:03 -0400
Received: from inva021.nxp.com ([92.121.34.21]:59516 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfGWPQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 11:16:00 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id ADD9C2000D9;
        Tue, 23 Jul 2019 17:15:57 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 95BF520001E;
        Tue, 23 Jul 2019 17:15:57 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 38EA7205DD;
        Tue, 23 Jul 2019 17:15:57 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] enetc: Add mdio bus driver for the PCIe MDIO endpoint
Date:   Tue, 23 Jul 2019 18:15:53 +0300
Message-Id: <1563894955-545-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563894955-545-1-git-send-email-claudiu.manoil@nxp.com>
References: <1563894955-545-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC ports can manage the MDIO bus via local register
interface.  However there's also a centralized way
to manage the MDIO bus, via the MDIO PCIe endpoint
device integrated by the same root complex that also
integrates the ENETC ports (eth controllers).

Depending on board design and use case, centralized
access to MDIO may be better than using local ENETC
port registers.  For instance, on the LS1028A QDS board
where MDIO muxing is requiered.  Also, the LS1028A on-chip
switch doesn't have a local MDIO register interface.

The current patch registers the above PCIe enpoint as a
separate MDIO bus and provides a driver for it by re-using
the code used for local MDIO access.  It also allows the
ENETC port PHYs to be managed by this driver if the local
"mdio" node is missing from the ENETC port node.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 90 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  5 +-
 2 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 77b9cd10ba2b..efa8a29f463d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -197,3 +197,93 @@ void enetc_mdio_remove(struct enetc_pf *pf)
 		mdiobus_free(pf->mdio);
 	}
 }
+
+#define ENETC_MDIO_DEV_ID	0xee01
+#define ENETC_MDIO_DEV_NAME	"FSL PCIe IE Central MDIO"
+#define ENETC_MDIO_BUS_NAME	ENETC_MDIO_DEV_NAME " Bus"
+#define ENETC_MDIO_DRV_NAME	ENETC_MDIO_DEV_NAME " driver"
+#define ENETC_MDIO_DRV_ID	"fsl_enetc_mdio"
+
+static int enetc_pci_mdio_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct mii_bus *bus;
+	int err;
+
+	bus = mdiobus_alloc_size(sizeof(u32 *));
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = ENETC_MDIO_BUS_NAME;
+	bus->read = enetc_mdio_read;
+	bus->write = enetc_mdio_write;
+	bus->parent = dev;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
+
+	pcie_flr(pdev);
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		dev_err(dev, "device enable failed\n");
+		return err;
+	}
+
+	err = pci_request_mem_regions(pdev, ENETC_MDIO_DRV_ID);
+	if (err) {
+		dev_err(dev, "pci_request_regions failed\n");
+		goto err_pci_mem_reg;
+	}
+
+	bus->priv = pci_iomap_range(pdev, 0, ENETC_MDIO_REG_OFFSET, 0);
+	if (!bus->priv) {
+		err = -ENXIO;
+		dev_err(dev, "ioremap failed\n");
+		goto err_ioremap;
+	}
+
+	err = of_mdiobus_register(bus, dev->of_node);
+	if (err)
+		goto err_mdiobus_reg;
+
+	pci_set_drvdata(pdev, bus);
+
+	return 0;
+
+err_mdiobus_reg:
+	iounmap(bus->priv);
+err_ioremap:
+	pci_release_mem_regions(pdev);
+err_pci_mem_reg:
+	pci_disable_device(pdev);
+
+	return err;
+}
+
+static void enetc_pci_mdio_remove(struct pci_dev *pdev)
+{
+	struct mii_bus *bus = pci_get_drvdata(pdev);
+
+	mdiobus_unregister(bus);
+	iounmap(bus->priv);
+	mdiobus_free(bus);
+
+	pci_release_mem_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+static const struct pci_device_id enetc_pci_mdio_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_FREESCALE, ENETC_MDIO_DEV_ID) },
+	{ 0, } /* End of table. */
+};
+MODULE_DEVICE_TABLE(pci, enetc_mdio_id_table);
+
+static struct pci_driver enetc_pci_mdio_driver = {
+	.name = ENETC_MDIO_DRV_ID,
+	.id_table = enetc_pci_mdio_id_table,
+	.probe = enetc_pci_mdio_probe,
+	.remove = enetc_pci_mdio_remove,
+};
+module_pci_driver(enetc_pci_mdio_driver);
+
+MODULE_DESCRIPTION(ENETC_MDIO_DRV_NAME);
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 258b3cb38a6f..7d6513ff8507 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -750,6 +750,7 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 {
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
 	struct device_node *np = priv->dev->of_node;
+	struct device_node *mdio_np;
 	int err;
 
 	if (!np) {
@@ -773,7 +774,9 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 		priv->phy_node = of_node_get(np);
 	}
 
-	if (!of_phy_is_fixed_link(np)) {
+	mdio_np = of_get_child_by_name(np, "mdio");
+	if (mdio_np) {
+		of_node_put(mdio_np);
 		err = enetc_mdio_probe(pf);
 		if (err) {
 			of_node_put(priv->phy_node);
-- 
2.17.1

