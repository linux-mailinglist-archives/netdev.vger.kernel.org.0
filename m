Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27BFABA7C
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394099AbfIFOPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:15:49 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57816 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394079AbfIFOPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:48 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 325DF2005E3;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2589D20034B;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EA8752061D;
        Fri,  6 Sep 2019 16:15:45 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 3/5] enetc: Initialize SerDes for SGMII and SXGMII protocols
Date:   Fri,  6 Sep 2019 17:15:42 +0300
Message-Id: <1567779344-30965-4-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC has ethernet MACs capable of SGMII and SXGMII but
in order to use these protocols some serdes configurations
need to be performed.
The serdes is configurable via an internal MDIO bus
connected to an internal PCS device, all reads/writes are
performed at address 0.
This patch basically removes the dependency on bootloader
regarding serdes initialization.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 17 ++++++
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 31 ++++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 58 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  2 +
 4 files changed, 108 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 534de211b243..ced3693dabdb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -215,6 +215,23 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_MAXFRM	0x8014
 #define ENETC_SET_TX_MTU(val)	((val) << 16)
 #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
+
+#define ENETC_PM_IMDIO_BASE	0x8030
+/* PCS registers */
+#define ENETC_PCS_CR			0x0
+#define ENETC_PCS_CR_RESET_AN		0x1200
+#define ENETC_PCS_CR_DEF_VAL		0x0140
+#define ENETC_PCS_CR_LANE_RESET		0x8000
+#define ENETC_PCS_DEV_ABILITY		0x04
+#define ENETC_PCS_DEV_ABILITY_SGMII	0x4001
+#define ENETC_PCS_DEV_ABILITY_SXGMII	0x5001
+#define ENETC_PCS_LINK_TIMER1		0x12
+#define ENETC_PCS_LINK_TIMER1_VAL	0x06a0
+#define ENETC_PCS_LINK_TIMER2		0x13
+#define ENETC_PCS_LINK_TIMER2_VAL	0x0003
+#define ENETC_PCS_IF_MODE		0x14
+#define ENETC_PCS_IF_MODE_SGMII_AN	0x0003
+
 #define ENETC_PM0_IF_MODE	0x8300
 #define ENETC_PMO_IFM_RG	BIT(2)
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index c9a27e7fe5a7..0190fcb0c371 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -200,3 +200,34 @@ void enetc_mdio_remove(struct enetc_pf *pf)
 	if (pf->mdio)
 		mdiobus_unregister(pf->mdio);
 }
+
+int enetc_imdio_init(struct enetc_pf *pf)
+{
+	struct device *dev = &pf->si->pdev->dev;
+	struct enetc_mdio_priv *mdio_priv;
+	struct mii_bus *bus;
+	int err;
+
+	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "FSL ENETC internal MDIO Bus";
+	bus->read = enetc_mdio_read;
+	bus->write = enetc_mdio_write;
+	bus->parent = dev;
+	mdio_priv = bus->priv;
+	mdio_priv->hw = &pf->si->hw;
+	mdio_priv->mdio_base = ENETC_PM_IMDIO_BASE;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
+
+	err = mdiobus_register(bus);
+	if (err) {
+		dev_err(dev, "cannot register internal MDIO bus\n");
+		return err;
+	}
+
+	pf->imdio = bus;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 3a556646a2fb..9e9bb6b97c41 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -804,6 +804,60 @@ static void enetc_of_put_phy(struct enetc_ndev_priv *priv)
 		of_node_put(priv->phy_node);
 }
 
+static void enetc_configure_sgmii(struct mii_bus *imdio)
+{
+	/* Set to SGMII mode, use AN */
+	imdio->write(imdio, 0, ENETC_PCS_IF_MODE,
+		     ENETC_PCS_IF_MODE_SGMII_AN);
+
+	/* Dev ability - SGMII */
+	imdio->write(imdio, 0, ENETC_PCS_DEV_ABILITY,
+		     ENETC_PCS_DEV_ABILITY_SGMII);
+
+	/* Adjust link timer for SGMII */
+	imdio->write(imdio, 0, ENETC_PCS_LINK_TIMER1,
+		     ENETC_PCS_LINK_TIMER1_VAL);
+	imdio->write(imdio, 0, ENETC_PCS_LINK_TIMER2,
+		     ENETC_PCS_LINK_TIMER2_VAL);
+
+	/* restart PCS AN */
+	imdio->write(imdio, 0, ENETC_PCS_CR,
+		     ENETC_PCS_CR_RESET_AN | ENETC_PCS_CR_DEF_VAL);
+}
+
+static void enetc_configure_sxgmii(struct mii_bus *imdio)
+{
+	/* Dev ability - SXGMII */
+	imdio->write(imdio, 0, ENETC_PCS_DEV_ABILITY | MII_ADDR_C45,
+		     ENETC_PCS_DEV_ABILITY_SXGMII);
+
+	/* Restart PCS AN */
+	imdio->write(imdio, 0, ENETC_PCS_CR | MII_ADDR_C45,
+		     ENETC_PCS_CR_LANE_RESET | ENETC_PCS_CR_RESET_AN);
+}
+
+static int enetc_configure_serdes(struct enetc_ndev_priv *priv)
+{
+	struct enetc_pf *pf = enetc_si_priv(priv->si);
+	int err;
+
+	if (priv->if_mode != PHY_INTERFACE_MODE_SGMII &&
+	    priv->if_mode != PHY_INTERFACE_MODE_XGMII)
+		return 0;
+
+	err = enetc_imdio_init(pf);
+	if (err)
+		return err;
+
+	if (priv->if_mode == PHY_INTERFACE_MODE_SGMII)
+		enetc_configure_sgmii(pf->imdio);
+
+	if (priv->if_mode == PHY_INTERFACE_MODE_XGMII)
+		enetc_configure_sxgmii(pf->imdio);
+
+	return 0;
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -868,6 +922,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	if (err)
 		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
 
+	err = enetc_configure_serdes(priv);
+	if (err)
+		dev_warn(&pdev->dev, "Attempted serdes config but failed\n");
+
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 10dd1b53bb08..1357cdb71d64 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -44,6 +44,7 @@ struct enetc_pf {
 	DECLARE_BITMAP(active_vlans, VLAN_N_VID);
 
 	struct mii_bus *mdio; /* saved for cleanup */
+	struct mii_bus *imdio;
 };
 
 int enetc_msg_psi_init(struct enetc_pf *pf);
@@ -53,3 +54,4 @@ void enetc_msg_handle_rxmsg(struct enetc_pf *pf, int mbox_id, u16 *status);
 /* MDIO */
 int enetc_mdio_probe(struct enetc_pf *pf);
 void enetc_mdio_remove(struct enetc_pf *pf);
+int enetc_imdio_init(struct enetc_pf *pf);
-- 
2.17.1

