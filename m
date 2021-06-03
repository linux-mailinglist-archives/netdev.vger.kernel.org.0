Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE78399E8B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFCKNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:13:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:33803 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhFCKNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 06:13:50 -0400
IronPort-SDR: nYP2va1TqbHkcXWC7ObIW13w95U27QBUwYDQaP42QypDoR+mBI0NTr/j4yYHcgSl2EvSZ6FGyb
 1b/mYNpBw+6w==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="191121094"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="191121094"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 03:12:06 -0700
IronPort-SDR: tLBal2aXQ2o0n23ePsAMn/lnrslSvPP5wiarjYd1qCZr6rduc4cRLSpfuYn/NUrdMM3TqL8uCQ
 dO8NvOEJReCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="549891436"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2021 03:12:01 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 1/3] net: stmmac: split xPCS setup from mdio register
Date:   Thu,  3 Jun 2021 18:06:45 +0800
Message-Id: <20210603100647.6123-2-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210603100647.6123-1-michael.wei.hong.sit@intel.com>
References: <20210603100647.6123-1-michael.wei.hong.sit@intel.com>
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
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 65 +++++++++++--------
 3 files changed, 46 insertions(+), 27 deletions(-)

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
index bf9fe25fed69..59505fa7afa1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6989,6 +6989,12 @@ int stmmac_dvr_probe(struct device *device,
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
@@ -7025,6 +7031,7 @@ int stmmac_dvr_probe(struct device *device,
 	unregister_netdev(ndev);
 error_netdev_register:
 	phylink_destroy(priv->phylink);
+error_xpcs_setup:
 error_phy_setup:
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index b750074f8f9c..fc0f73de700f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -397,6 +397,44 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
+int stmmac_xpcs_setup(struct mii_bus *bus)
+{
+	int mode, max_addr, addr, found, ret;
+	struct net_device *ndev = bus->priv;
+	struct mdio_xpcs_args *xpcs;
+	struct stmmac_priv *priv;
+
+	priv = netdev_priv(ndev);
+	xpcs = &priv->hw->xpcs_args;
+	mode = priv->plat->phy_interface;
+	max_addr = PHY_MAX_ADDR;
+
+	priv->hw->xpcs = mdio_xpcs_get_ops();
+	if (!priv->hw->xpcs)
+		return -ENODEV;
+
+	/* Try to probe the XPCS by scanning all addresses. */
+	xpcs->bus = bus;
+	found = 0;
+
+	for (addr = 0; addr < max_addr; addr++) {
+		xpcs->addr = addr;
+
+		ret = stmmac_xpcs_probe(priv, xpcs, mode);
+		if (!ret) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		dev_warn(priv->device, "No xPCS found\n");
+		return -ENODEV;
+	}
+
+	return ret;
+}
+
 /**
  * stmmac_mdio_register
  * @ndev: net device structure
@@ -444,14 +482,6 @@ int stmmac_mdio_register(struct net_device *ndev)
 		max_addr = PHY_MAX_ADDR;
 	}
 
-	if (mdio_bus_data->has_xpcs) {
-		priv->hw->xpcs = mdio_xpcs_get_ops();
-		if (!priv->hw->xpcs) {
-			err = -ENODEV;
-			goto bus_register_fail;
-		}
-	}
-
 	if (mdio_bus_data->needs_reset)
 		new_bus->reset = &stmmac_mdio_reset;
 
@@ -503,25 +533,6 @@ int stmmac_mdio_register(struct net_device *ndev)
 		found = 1;
 	}
 
-	/* Try to probe the XPCS by scanning all addresses. */
-	if (priv->hw->xpcs) {
-		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
-		int ret, mode = priv->plat->phy_interface;
-		max_addr = PHY_MAX_ADDR;
-
-		xpcs->bus = new_bus;
-
-		for (addr = 0; addr < max_addr; addr++) {
-			xpcs->addr = addr;
-
-			ret = stmmac_xpcs_probe(priv, xpcs, mode);
-			if (!ret) {
-				found = 1;
-				break;
-			}
-		}
-	}
-
 	if (!found && !mdio_node) {
 		dev_warn(dev, "No PHY found\n");
 		mdiobus_unregister(new_bus);
-- 
2.17.1

