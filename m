Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B342ABA7E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394109AbfIFOPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:15:54 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48574 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394082AbfIFOPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:49 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B7A241A05DA;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AB8771A0210;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7C9E02061D;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 5/5] enetc: Use DT protocol information to set up the ports
Date:   Fri,  6 Sep 2019 17:15:44 +0300
Message-Id: <1567779344-30965-6-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

Use DT information rather than in-band information from bootloader to
set up MAC for XGMII. For RGMII use the DT indication in addition to
RGMII defaults in hardware.
However, this implies that PHY connection information needs to be
extracted before netdevice creation, when the ENETC Port MAC is
being configured.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 55 ++++++++++---------
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  3 +
 2 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ebf2996ebe69..dbe9515a89b1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -507,7 +507,8 @@ static void enetc_port_si_configure(struct enetc_si *si)
 	enetc_port_wr(hw, ENETC_PSIVLANFMR, ENETC_PSIVLANFMR_VS);
 }
 
-static void enetc_configure_port_mac(struct enetc_hw *hw)
+static void enetc_configure_port_mac(struct enetc_hw *hw,
+				     phy_interface_t phy_mode)
 {
 	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
 		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
@@ -523,9 +524,11 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
 		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
 	/* set auto-speed for RGMII */
-	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG)
+	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
+	    phy_mode == PHY_INTERFACE_MODE_RGMII)
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
-	if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) == ENETC_G_EPFBLPR1_XGMII)
+
+	if (phy_mode == PHY_INTERFACE_MODE_XGMII)
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
 }
 
@@ -549,7 +552,7 @@ static void enetc_configure_port(struct enetc_pf *pf)
 
 	enetc_configure_port_pmac(hw);
 
-	enetc_configure_port_mac(hw);
+	enetc_configure_port_mac(hw, pf->if_mode);
 
 	enetc_port_si_configure(pf->si);
 
@@ -746,28 +749,28 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
 
-static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
+static int enetc_of_get_phy(struct enetc_pf *pf)
 {
-	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	struct device_node *np = priv->dev->of_node;
+	struct device *dev = &pf->si->pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct device_node *mdio_np;
 	int phy_mode;
 	int err;
 
-	priv->phy_node = of_parse_phandle(np, "phy-handle", 0);
-	if (!priv->phy_node) {
+	pf->phy_node = of_parse_phandle(np, "phy-handle", 0);
+	if (!pf->phy_node) {
 		if (!of_phy_is_fixed_link(np)) {
-			dev_err(priv->dev, "PHY not specified\n");
+			dev_err(dev, "PHY not specified\n");
 			return -ENODEV;
 		}
 
 		err = of_phy_register_fixed_link(np);
 		if (err < 0) {
-			dev_err(priv->dev, "fixed link registration failed\n");
+			dev_err(dev, "fixed link registration failed\n");
 			return err;
 		}
 
-		priv->phy_node = of_node_get(np);
+		pf->phy_node = of_node_get(np);
 	}
 
 	mdio_np = of_get_child_by_name(np, "mdio");
@@ -775,28 +778,28 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 		of_node_put(mdio_np);
 		err = enetc_mdio_probe(pf);
 		if (err) {
-			of_node_put(priv->phy_node);
+			of_node_put(pf->phy_node);
 			return err;
 		}
 	}
 
 	phy_mode = of_get_phy_mode(np);
 	if (phy_mode < 0)
-		priv->if_mode = PHY_INTERFACE_MODE_NA; /* fixed link */
+		pf->if_mode = PHY_INTERFACE_MODE_NA; /* fixed link */
 	else
-		priv->if_mode = phy_mode;
+		pf->if_mode = phy_mode;
 
 	return 0;
 }
 
-static void enetc_of_put_phy(struct enetc_ndev_priv *priv)
+static void enetc_of_put_phy(struct enetc_pf *pf)
 {
-	struct device_node *np = priv->dev->of_node;
+	struct device_node *np = pf->si->pdev->dev.of_node;
 
 	if (np && of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
-	if (priv->phy_node)
-		of_node_put(priv->phy_node);
+	if (pf->phy_node)
+		of_node_put(pf->phy_node);
 }
 
 static void enetc_configure_sgmii(struct mii_bus *imdio)
@@ -884,6 +887,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
 
+	err = enetc_of_get_phy(pf);
+	if (err)
+		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
+
 	enetc_configure_port(pf);
 
 	enetc_get_si_caps(si);
@@ -898,6 +905,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	enetc_pf_netdev_setup(si, ndev, &enetc_ndev_ops);
 
 	priv = netdev_priv(ndev);
+	priv->phy_node = pf->phy_node;
+	priv->if_mode = pf->if_mode;
 
 	enetc_init_si_rings_params(priv);
 
@@ -913,10 +922,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	err = enetc_of_get_phy(priv);
-	if (err)
-		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
-
 	err = enetc_configure_serdes(priv);
 	if (err)
 		dev_warn(&pdev->dev, "Attempted serdes config but failed\n");
@@ -933,7 +938,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
-	enetc_of_put_phy(priv);
 	enetc_free_msix(priv);
 err_alloc_msix:
 	enetc_free_si_resources(priv);
@@ -941,6 +945,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
+	enetc_of_put_phy(pf);
 err_map_pf_space:
 	enetc_pci_remove(pdev);
 
@@ -963,7 +968,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	unregister_netdev(si->ndev);
 
 	enetc_mdio_remove(pf);
-	enetc_of_put_phy(priv);
+	enetc_of_put_phy(pf);
 
 	enetc_free_msix(priv);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 1357cdb71d64..e0346dcf9ed7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -45,6 +45,9 @@ struct enetc_pf {
 
 	struct mii_bus *mdio; /* saved for cleanup */
 	struct mii_bus *imdio;
+
+	struct device_node *phy_node;
+	phy_interface_t if_mode;
 };
 
 int enetc_msg_psi_init(struct enetc_pf *pf);
-- 
2.17.1

