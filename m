Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4690139B76B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFDLDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:03:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:48730 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhFDLDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 07:03:49 -0400
IronPort-SDR: L0McqOn9yyno1f001hu8IlvdoJkaB3bZ5lR6lLZM7vBW1/VB019yz0VIVb2Sug+TXmGoN68UFu
 99ZZS2jS7o8A==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="191607371"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="191607371"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 04:02:02 -0700
IronPort-SDR: S586vrfhOJmzoQc/cPER9JuGgPWfV/9S+q4Kt3Ful0yArjZ0+2JkP0VYnhKXtn3VLbLTdM3444
 F+kDNp69Hg5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="448220353"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jun 2021 04:01:57 -0700
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
Subject: [RESEND PATCH net-next v5 1/3] net: stmmac: split xPCS setup from mdio register
Date:   Fri,  4 Jun 2021 18:57:31 +0800
Message-Id: <20210604105733.31092-2-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210604105733.31092-1-michael.wei.hong.sit@intel.com>
References: <20210604105733.31092-1-michael.wei.hong.sit@intel.com>
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 ++
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 64 ++++++++++---------
 3 files changed, 43 insertions(+), 29 deletions(-)

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
index 6d41dd6f9f7a..c1331c07623d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6991,6 +6991,12 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
+	if (priv->plat->mdio_bus_data->has_xpcs) {
+		ret = stmmac_xpcs_setup(priv->mii);
+		if (ret)
+			goto error_xpcs_setup;
+	}
+
 	ret = stmmac_phy_setup(priv);
 	if (ret) {
 		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
@@ -7027,6 +7033,7 @@ int stmmac_dvr_probe(struct device *device,
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

