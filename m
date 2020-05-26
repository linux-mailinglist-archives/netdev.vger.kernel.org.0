Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBBA1E32FB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404537AbgEZWvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:51:18 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:47889 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390388AbgEZWvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:51:16 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CC45F23E2C;
        Wed, 27 May 2020 00:51:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590533472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yE4AZMMKDU81ZCTycgLQD+mVSNEWcG6IAHNuMw26IWY=;
        b=hcGYngjDVPE6qorpGgQ70+y+8PxbdZVMRJx4OUd/Cog8RLJCJGWrUBbXuW+t0Sl/RLKMEA
        6CxoGaOFtHDRfY5RjnmspBdS/+39rIQ/VDv/SJij7KUZSYzvjT96vnJa5nQA6ORT8ZVAr+
        hWdJx6VZNdjuQsMM11mk5iQM/1ozrSU=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next v2 1/2] net: enetc: Initialize SerDes for SGMII and SXGMII protocols
Date:   Wed, 27 May 2020 00:50:49 +0200
Message-Id: <20200526225050.5997-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200526225050.5997-1-michael@walle.cc>
References: <20200526225050.5997-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

ENETC has ethernet MACs capable of SGMII and SXGMII but in order to use
these protocols some serdes configurations need to be performed. The
SerDes is configurable via an internal MDIO bus connected to an internal
PCS device, all reads/writes are performed at address 0.

This patch basically removes the dependency on bootloader regarding
SerDes initialization.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 17 ++++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 98 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  1 +
 3 files changed, 116 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 6314051bc6c1..ee5851486388 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -224,6 +224,23 @@ enum enetc_bdr_type {TX, RX};
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
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 824d211ec00f..5836486314a7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -841,6 +841,99 @@ static void enetc_of_put_phy(struct enetc_ndev_priv *priv)
 		of_node_put(priv->phy_node);
 }
 
+static int enetc_imdio_init(struct enetc_pf *pf)
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
+	bus->name = "Freescale ENETC internal MDIO Bus";
+	bus->read = enetc_mdio_read;
+	bus->write = enetc_mdio_write;
+	bus->parent = dev;
+	bus->phy_mask = ~0;
+	mdio_priv = bus->priv;
+	mdio_priv->hw = &pf->si->hw;
+	mdio_priv->mdio_base = ENETC_PM_IMDIO_BASE;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "imdio-%s", dev_name(dev));
+
+	err = mdiobus_register(bus);
+	if (err) {
+		dev_err(dev, "cannot register internal MDIO bus (%d)\n", err);
+		devm_mdiobus_free(dev, bus);
+		return err;
+	}
+
+	pf->imdio = bus;
+
+	return 0;
+}
+
+static void enetc_imdio_remove(struct enetc_pf *pf)
+{
+	if (pf->imdio)
+		mdiobus_unregister(pf->imdio);
+}
+
+static void enetc_configure_sgmii(struct mii_bus *imdio)
+{
+	/* Set to SGMII mode, use AN */
+	mdiobus_write(imdio, 0, ENETC_PCS_IF_MODE,
+		      ENETC_PCS_IF_MODE_SGMII_AN);
+
+	/* Dev ability - SGMII */
+	mdiobus_write(imdio, 0, ENETC_PCS_DEV_ABILITY,
+		      ENETC_PCS_DEV_ABILITY_SGMII);
+
+	/* Adjust link timer for SGMII */
+	mdiobus_write(imdio, 0, ENETC_PCS_LINK_TIMER1,
+		      ENETC_PCS_LINK_TIMER1_VAL);
+	mdiobus_write(imdio, 0, ENETC_PCS_LINK_TIMER2,
+		      ENETC_PCS_LINK_TIMER2_VAL);
+
+	/* restart PCS AN */
+	mdiobus_write(imdio, 0, ENETC_PCS_CR,
+		      ENETC_PCS_CR_RESET_AN | ENETC_PCS_CR_DEF_VAL);
+}
+
+static void enetc_configure_sxgmii(struct mii_bus *imdio)
+{
+	/* Dev ability - SXGMII */
+	mdiobus_write(imdio, 0, ENETC_PCS_DEV_ABILITY | MII_ADDR_C45,
+		      ENETC_PCS_DEV_ABILITY_SXGMII);
+
+	/* Restart PCS AN */
+	mdiobus_write(imdio, 0, ENETC_PCS_CR | MII_ADDR_C45,
+		      ENETC_PCS_CR_LANE_RESET | ENETC_PCS_CR_RESET_AN);
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
@@ -905,6 +998,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	if (err)
 		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
 
+	err = enetc_configure_serdes(priv);
+	if (err)
+		dev_warn(&pdev->dev, "Attempted SerDes config but failed\n");
+
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
@@ -940,6 +1037,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	priv = netdev_priv(si->ndev);
 	unregister_netdev(si->ndev);
 
+	enetc_imdio_remove(pf);
 	enetc_mdio_remove(pf);
 	enetc_of_put_phy(priv);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 59e65a6f6c3e..ec56d9b8dcb8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -44,6 +44,7 @@ struct enetc_pf {
 	DECLARE_BITMAP(active_vlans, VLAN_N_VID);
 
 	struct mii_bus *mdio; /* saved for cleanup */
+	struct mii_bus *imdio;
 };
 
 int enetc_msg_psi_init(struct enetc_pf *pf);
-- 
2.20.1

