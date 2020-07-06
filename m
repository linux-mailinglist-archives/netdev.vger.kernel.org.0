Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EC8216142
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 00:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgGFWDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 18:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGFWDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 18:03:10 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDF6C061755;
        Mon,  6 Jul 2020 15:03:10 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 40E1F23E41;
        Tue,  7 Jul 2020 00:03:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1594072988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IaLVtL8S3N5OlE7FZhRk/k/b1LD+oUavtXugpX9jRHQ=;
        b=AnVyQ1V22z+s+vD1Nwzqzede63aJnezePnOXrXWOogWgXCDf2+AN/1zR74D3xVKT5X37TQ
        pmHzf9L2pnFbjR3GR/JFFMlcFU/yXQnYJmkOkAwa7GYf2RzRfMq0ZQ0fO/5begKDhx56Cb
        071MYurTYhlGbhKy8pVPXsVFoyREgNI=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: [PATCH net-next v4 3/3] net: enetc: Use DT protocol information to set up the ports
Date:   Tue,  7 Jul 2020 00:02:55 +0200
Message-Id: <20200706220255.14738-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200706220255.14738-1-michael@walle.cc>
References: <20200706220255.14738-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
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
Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 57 ++++++++++---------
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  3 +
 2 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index cd7a061b05bf..dc370b3eebe7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -481,7 +481,8 @@ static void enetc_port_si_configure(struct enetc_si *si)
 	enetc_port_wr(hw, ENETC_PSIVLANFMR, ENETC_PSIVLANFMR_VS);
 }
 
-static void enetc_configure_port_mac(struct enetc_hw *hw)
+static void enetc_configure_port_mac(struct enetc_hw *hw,
+				     phy_interface_t phy_mode)
 {
 	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
 		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
@@ -497,9 +498,11 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
 		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
 	/* set auto-speed for RGMII */
-	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG)
+	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
+	    phy_interface_mode_is_rgmii(phy_mode))
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
-	if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) == ENETC_G_EPFBLPR1_XGMII)
+
+	if (phy_mode == PHY_INTERFACE_MODE_USXGMII)
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
 }
 
@@ -523,7 +526,7 @@ static void enetc_configure_port(struct enetc_pf *pf)
 
 	enetc_configure_port_pmac(hw);
 
-	enetc_configure_port_mac(hw);
+	enetc_configure_port_mac(hw, pf->if_mode);
 
 	enetc_port_si_configure(pf->si);
 
@@ -775,27 +778,27 @@ static void enetc_mdio_remove(struct enetc_pf *pf)
 		mdiobus_unregister(pf->mdio);
 }
 
-static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
+static int enetc_of_get_phy(struct enetc_pf *pf)
 {
-	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	struct device_node *np = priv->dev->of_node;
+	struct device *dev = &pf->si->pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct device_node *mdio_np;
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
@@ -803,15 +806,15 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 		of_node_put(mdio_np);
 		err = enetc_mdio_probe(pf);
 		if (err) {
-			of_node_put(priv->phy_node);
+			of_node_put(pf->phy_node);
 			return err;
 		}
 	}
 
-	err = of_get_phy_mode(np, &priv->if_mode);
+	err = of_get_phy_mode(np, &pf->if_mode);
 	if (err) {
-		dev_err(priv->dev, "missing phy type\n");
-		of_node_put(priv->phy_node);
+		dev_err(dev, "missing phy type\n");
+		of_node_put(pf->phy_node);
 		if (of_phy_is_fixed_link(np))
 			of_phy_deregister_fixed_link(np);
 		else
@@ -823,14 +826,14 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
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
 
 static int enetc_imdio_init(struct enetc_pf *pf, bool is_c45)
@@ -996,6 +999,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
 
+	err = enetc_of_get_phy(pf);
+	if (err)
+		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
+
 	enetc_configure_port(pf);
 
 	enetc_get_si_caps(si);
@@ -1010,6 +1017,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	enetc_pf_netdev_setup(si, ndev, &enetc_ndev_ops);
 
 	priv = netdev_priv(ndev);
+	priv->phy_node = pf->phy_node;
+	priv->if_mode = pf->if_mode;
 
 	enetc_init_si_rings_params(priv);
 
@@ -1025,10 +1034,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	err = enetc_of_get_phy(priv);
-	if (err)
-		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
-
 	err = enetc_configure_serdes(priv);
 	if (err)
 		dev_warn(&pdev->dev, "Attempted SerDes config but failed\n");
@@ -1042,7 +1047,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	return 0;
 
 err_reg_netdev:
-	enetc_of_put_phy(priv);
 	enetc_free_msix(priv);
 err_alloc_msix:
 	enetc_free_si_resources(priv);
@@ -1050,6 +1054,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
+	enetc_of_put_phy(pf);
 err_map_pf_space:
 	enetc_pci_remove(pdev);
 
@@ -1070,7 +1075,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 
 	enetc_imdio_remove(pf);
 	enetc_mdio_remove(pf);
-	enetc_of_put_phy(priv);
+	enetc_of_put_phy(pf);
 
 	enetc_free_msix(priv);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 2cb922b59f46..0d0ee91282a5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -46,6 +46,9 @@ struct enetc_pf {
 	struct mii_bus *mdio; /* saved for cleanup */
 	struct mii_bus *imdio;
 	struct phy_device *pcs;
+
+	struct device_node *phy_node;
+	phy_interface_t if_mode;
 };
 
 int enetc_msg_psi_init(struct enetc_pf *pf);
-- 
2.20.1

