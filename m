Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486B6225459
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 00:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgGSWDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 18:03:50 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:58649 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGSWDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 18:03:49 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5424123076;
        Mon, 20 Jul 2020 00:03:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1595196226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrdZODNf3Hj8hzql68Z+L1WApdxHLWKzvBOI9QwOXu0=;
        b=ZNgREgODrzsyeK21kTwzfIC2MnPMRYhAWHhqnqpBwvLFj5FgfplCDSdNGs+nFsW2tBgSQc
        rmNygCdFh4dh5/PecasiOo5Rjowc8Hh9gIdo5q2TxbXSVwpyD6+EeZlW1rwcETZeNibZ8M
        eTkH5t7K+4GazKCyp3D8EGv5Jj840vs=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v7 3/4] net: enetc: Initialize SerDes for SGMII and USXGMII protocols
Date:   Mon, 20 Jul 2020 00:03:35 +0200
Message-Id: <20200719220336.6919-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200719220336.6919-1-michael@walle.cc>
References: <20200719220336.6919-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC has ethernet MACs capable of SGMII, 2500BaseX and USXGMII. But in
order to use these protocols some SerDes configurations need to be
performed. The SerDes is configurable via an internal PCS PHY which is
connected to an internal MDIO bus at address 0.

This patch basically removes the dependency on bootloader regarding
SerDes initialization.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   3 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 135 ++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   2 +
 3 files changed, 140 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index fc357bc56835..135bf46354ea 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -224,6 +224,9 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_MAXFRM	0x8014
 #define ENETC_SET_TX_MTU(val)	((val) << 16)
 #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
+
+#define ENETC_PM_IMDIO_BASE	0x8030
+
 #define ENETC_PM0_IF_MODE	0x8300
 #define ENETC_PMO_IFM_RG	BIT(2)
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 4fac57dbb3c8..3bf345b84b76 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2017-2019 NXP */
 
+#include <linux/mdio.h>
 #include <linux/module.h>
 #include <linux/fsl/enetc_mdio.h>
 #include <linux/of_mdio.h>
@@ -833,6 +834,135 @@ static void enetc_of_put_phy(struct enetc_ndev_priv *priv)
 		of_node_put(priv->phy_node);
 }
 
+static int enetc_imdio_init(struct enetc_pf *pf, bool is_c45)
+{
+	struct device *dev = &pf->si->pdev->dev;
+	struct enetc_mdio_priv *mdio_priv;
+	struct phy_device *pcs;
+	struct mii_bus *bus;
+	int err;
+
+	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
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
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
+
+	err = mdiobus_register(bus);
+	if (err) {
+		dev_err(dev, "cannot register internal MDIO bus (%d)\n", err);
+		goto free_mdio_bus;
+	}
+
+	pcs = get_phy_device(bus, 0, is_c45);
+	if (IS_ERR(pcs)) {
+		err = PTR_ERR(pcs);
+		dev_err(dev, "cannot get internal PCS PHY (%d)\n", err);
+		goto unregister_mdiobus;
+	}
+
+	pf->imdio = bus;
+	pf->pcs = pcs;
+
+	return 0;
+
+unregister_mdiobus:
+	mdiobus_unregister(bus);
+free_mdio_bus:
+	mdiobus_free(bus);
+	return err;
+}
+
+static void enetc_imdio_remove(struct enetc_pf *pf)
+{
+	if (pf->pcs)
+		put_device(&pf->pcs->mdio.dev);
+	if (pf->imdio) {
+		mdiobus_unregister(pf->imdio);
+		mdiobus_free(pf->imdio);
+	}
+}
+
+static void enetc_configure_sgmii(struct phy_device *pcs)
+{
+	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
+	 * for the MAC PCS in order to acknowledge the AN.
+	 */
+	phy_write(pcs, MII_ADVERTISE, ADVERTISE_SGMII | ADVERTISE_LPACK);
+
+	phy_write(pcs, ENETC_PCS_IF_MODE,
+		  ENETC_PCS_IF_MODE_SGMII_EN |
+		  ENETC_PCS_IF_MODE_USE_SGMII_AN);
+
+	/* Adjust link timer for SGMII */
+	phy_write(pcs, ENETC_PCS_LINK_TIMER1, ENETC_PCS_LINK_TIMER1_VAL);
+	phy_write(pcs, ENETC_PCS_LINK_TIMER2, ENETC_PCS_LINK_TIMER2_VAL);
+
+	phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
+}
+
+static void enetc_configure_2500basex(struct phy_device *pcs)
+{
+	phy_write(pcs, ENETC_PCS_IF_MODE,
+		  ENETC_PCS_IF_MODE_SGMII_EN |
+		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
+
+	phy_write(pcs, MII_BMCR, BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_RESET);
+}
+
+static void enetc_configure_usxgmii(struct phy_device *pcs)
+{
+	/* Configure device ability for the USXGMII Replicator */
+	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
+		      ADVERTISE_SGMII | ADVERTISE_LPACK |
+		      MDIO_USXGMII_FULL_DUPLEX);
+
+	/* Restart PCS AN */
+	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_BMCR,
+		      BMCR_RESET | BMCR_ANENABLE | BMCR_ANRESTART);
+}
+
+static int enetc_configure_serdes(struct enetc_ndev_priv *priv)
+{
+	bool is_c45 = priv->if_mode == PHY_INTERFACE_MODE_USXGMII;
+	struct enetc_pf *pf = enetc_si_priv(priv->si);
+	int err;
+
+	if (priv->if_mode != PHY_INTERFACE_MODE_SGMII &&
+	    priv->if_mode != PHY_INTERFACE_MODE_2500BASEX &&
+	    priv->if_mode != PHY_INTERFACE_MODE_USXGMII)
+		return 0;
+
+	err = enetc_imdio_init(pf, is_c45);
+	if (err)
+		return err;
+
+	switch (priv->if_mode) {
+	case PHY_INTERFACE_MODE_SGMII:
+		enetc_configure_sgmii(pf->pcs);
+		break;
+	case PHY_INTERFACE_MODE_2500BASEX:
+		enetc_configure_2500basex(pf->pcs);
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		enetc_configure_usxgmii(pf->pcs);
+		break;
+	default:
+		dev_err(&pf->si->pdev->dev, "Unsupported link mode %s\n",
+			phy_modes(priv->if_mode));
+	}
+
+	return 0;
+}
+
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -897,6 +1027,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	if (err)
 		dev_warn(&pdev->dev, "Fallback to PHY-less operation\n");
 
+	err = enetc_configure_serdes(priv);
+	if (err)
+		dev_warn(&pdev->dev, "Attempted SerDes config but failed\n");
+
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
@@ -932,6 +1066,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	priv = netdev_priv(si->ndev);
 	unregister_netdev(si->ndev);
 
+	enetc_imdio_remove(pf);
 	enetc_mdio_remove(pf);
 	enetc_of_put_phy(priv);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 59e65a6f6c3e..2cb922b59f46 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -44,6 +44,8 @@ struct enetc_pf {
 	DECLARE_BITMAP(active_vlans, VLAN_N_VID);
 
 	struct mii_bus *mdio; /* saved for cleanup */
+	struct mii_bus *imdio;
+	struct phy_device *pcs;
 };
 
 int enetc_msg_psi_init(struct enetc_pf *pf);
-- 
2.20.1

