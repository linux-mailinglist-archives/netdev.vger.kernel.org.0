Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191C439ED35
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhFHD6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:58:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:59065 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhFHD62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:58:28 -0400
IronPort-SDR: lnLcb46W2/eS8pG3Jj0fnl92TqSdKEpFlc83KsF/hscg/X0xeuObHC3qQjn2jk8AJ7VTPI8C5c
 jmI8SMyEoICg==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="202907295"
X-IronPort-AV: E=Sophos;i="5.83,256,1616482800"; 
   d="scan'208";a="202907295"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 20:56:35 -0700
IronPort-SDR: OuQPB/UMaRFZcBFKm4MjV68n54vDFjvHy4Mx0zJeWAg0nbxGat3ndhArlydfPEI30PgDwyZB78
 jJrP19Ei4KQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,256,1616482800"; 
   d="scan'208";a="440308750"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2021 20:56:31 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: [PATCH net-next v6 1/3] net: stmmac: split xPCS setup from mdio register
Date:   Tue,  8 Jun 2021 11:51:56 +0800
Message-Id: <20210608035158.4869-2-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608035158.4869-1-michael.wei.hong.sit@intel.com>
References: <20210608035158.4869-1-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

This patch is a preparation patch for the enabling of Intel mGbE 2.5Gbps
link speed. The Intel mGbR link speed configuration (1G/2.5G) is depends on
a mdio ADHOC register which can be configured in the bios menu.
As PHY interface might be different for 1G and 2.5G, the mdio bus need be
ready to check the link speed and select the PHY interface before probing
the xPCS.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  9 +++
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 64 ++++++++++---------
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index b6cd43eda7ac..fd7212afc543 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -311,6 +311,7 @@ enum stmmac_state {
 int stmmac_mdio_unregister(struct net_device *ndev);
 int stmmac_mdio_register(struct net_device *ndev);
 int stmmac_mdio_reset(struct mii_bus *mii);
+int stmmac_xpcs_setup(struct mii_bus *mii);
 void stmmac_set_ethtool_ops(struct net_device *netdev);
 
 void stmmac_ptp_register(struct stmmac_priv *priv);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0a266fa0af7e..af406ea3dd46 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6993,6 +6993,14 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
+	if (priv->plat->mdio_bus_data) {
+		if (priv->plat->mdio_bus_data->has_xpcs) {
+			ret = stmmac_xpcs_setup(priv->mii);
+			if (ret)
+				goto error_xpcs_setup;
+		}
+	}
+
 	ret = stmmac_phy_setup(priv);
 	if (ret) {
 		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
@@ -7029,6 +7037,7 @@ int stmmac_dvr_probe(struct device *device,
 	unregister_netdev(ndev);
 error_netdev_register:
 	phylink_destroy(priv->phylink);
+error_xpcs_setup:
 error_phy_setup:
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 6312a152c8ad..bc900e240da2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -397,6 +397,41 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
+int stmmac_xpcs_setup(struct mii_bus *bus)
+{
+	int mode, addr;
+	struct net_device *ndev = bus->priv;
+	struct mdio_xpcs_args *xpcs;
+	struct stmmac_priv *priv;
+	struct mdio_device *mdiodev;
+
+	priv = netdev_priv(ndev);
+	mode = priv->plat->phy_interface;
+
+	/* Try to probe the XPCS by scanning all addresses. */
+	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+		mdiodev = mdio_device_create(bus, addr);
+		if (IS_ERR(mdiodev))
+			continue;
+
+		xpcs = xpcs_create(mdiodev, mode);
+		if (IS_ERR_OR_NULL(xpcs)) {
+			mdio_device_free(mdiodev);
+			continue;
+		}
+
+		priv->hw->xpcs = xpcs;
+		break;
+	}
+
+	if (!priv->hw->xpcs) {
+		dev_warn(priv->device, "No xPCS found\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 /**
  * stmmac_mdio_register
  * @ndev: net device structure
@@ -501,40 +536,11 @@ int stmmac_mdio_register(struct net_device *ndev)
 		goto no_phy_found;
 	}
 
-	/* Try to probe the XPCS by scanning all addresses. */
-	if (mdio_bus_data->has_xpcs) {
-		int mode = priv->plat->phy_interface;
-		struct mdio_device *mdiodev;
-		struct mdio_xpcs_args *xpcs;
-
-		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
-			mdiodev = mdio_device_create(new_bus, addr);
-			if (IS_ERR(mdiodev))
-				continue;
-
-			xpcs = xpcs_create(mdiodev, mode);
-			if (IS_ERR_OR_NULL(xpcs)) {
-				mdio_device_free(mdiodev);
-				continue;
-			}
-
-			priv->hw->xpcs = xpcs;
-			break;
-		}
-
-		if (!priv->hw->xpcs) {
-			dev_warn(dev, "No XPCS found\n");
-			err = -ENODEV;
-			goto no_xpcs_found;
-		}
-	}
-
 bus_register_done:
 	priv->mii = new_bus;
 
 	return 0;
 
-no_xpcs_found:
 no_phy_found:
 	mdiobus_unregister(new_bus);
 bus_register_fail:
-- 
2.17.1

