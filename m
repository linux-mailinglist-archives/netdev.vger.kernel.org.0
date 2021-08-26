Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF123F9115
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 01:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243879AbhHZXrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 19:47:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:34918 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243832AbhHZXrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 19:47:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205068833"
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="205068833"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 16:45:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="426956294"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2021 16:45:57 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 5BA635808BB;
        Thu, 26 Aug 2021 16:45:53 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Subject: [PATCH net-next v2 1/2] net: pcs: xpcs: enable skip xPCS soft reset
Date:   Fri, 27 Aug 2021 07:51:32 +0800
Message-Id: <20210826235134.4051310-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike any other platforms, Intel AlderLake-S uses Synopsys SerDes where
all the SerDes PLL configurations are controlled by the xPCS at the BIOS
level. If the driver perform a xPCS soft reset on initialization, these
settings will be switched back to the power on reset values.

This patch introduced a new xpcs_reset() function for drivers such as
sja1105 and stmmac to decide whether or not to perform a xPCS soft
reset.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c        |  6 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 15 +++++++-
 drivers/net/pcs/pcs-xpcs.c                    | 37 ++++++++++---------
 include/linux/pcs/pcs-xpcs.h                  |  4 +-
 include/linux/stmmac.h                        |  1 +
 5 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 705d3900e43a..6f8cc1358ac0 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -435,13 +435,17 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 			goto out_pcs_free;
 		}
 
-		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
+		xpcs = xpcs_create(mdiodev);
 		if (IS_ERR(xpcs)) {
 			rc = PTR_ERR(xpcs);
 			goto out_pcs_free;
 		}
 
 		priv->xpcs[port] = xpcs;
+
+		rc = xpcs_reset(xpcs, priv->phy_mode[port]);
+		if (rc)
+			goto out_pcs_free;
 	}
 
 	priv->mdio_pcs = bus;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5d150c5f3d8..50f0e6dccb85 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -401,12 +401,15 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 {
 	struct net_device *ndev = bus->priv;
 	struct mdio_device *mdiodev;
+	bool skip_xpcs_soft_reset;
 	struct stmmac_priv *priv;
 	struct dw_xpcs *xpcs;
 	int mode, addr;
+	int err;
 
 	priv = netdev_priv(ndev);
 	mode = priv->plat->phy_interface;
+	skip_xpcs_soft_reset = priv->plat->skip_xpcs_soft_reset;
 
 	/* Try to probe the XPCS by scanning all addresses. */
 	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
@@ -414,12 +417,20 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 		if (IS_ERR(mdiodev))
 			continue;
 
-		xpcs = xpcs_create(mdiodev, mode);
-		if (IS_ERR_OR_NULL(xpcs)) {
+		xpcs = xpcs_create(mdiodev);
+		if (IS_ERR(xpcs)) {
 			mdio_device_free(mdiodev);
 			continue;
 		}
 
+		if (!skip_xpcs_soft_reset) {
+			err = xpcs_reset(xpcs, mode);
+			if (err) {
+				mdio_device_free(mdiodev);
+				continue;
+			}
+		}
+
 		priv->hw->xpcs = xpcs;
 		break;
 	}
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index fb0a83dc09ac..e4961884dd96 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -252,6 +252,18 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 	return xpcs_poll_reset(xpcs, dev);
 }
 
+int xpcs_reset(struct dw_xpcs *xpcs, phy_interface_t interface)
+{
+	const struct xpcs_compat *compat;
+
+	compat = xpcs_find_compat(xpcs->id, interface);
+	if (!compat)
+		return -ENODEV;
+
+	return xpcs_soft_reset(xpcs, compat);
+}
+EXPORT_SYMBOL_GPL(xpcs_reset);
+
 #define xpcs_warn(__xpcs, __state, __args...) \
 ({ \
 	if ((__state)->link) \
@@ -1084,12 +1096,11 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_link_up = xpcs_link_up,
 };
 
-struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface)
+struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev)
 {
 	struct dw_xpcs *xpcs;
 	u32 xpcs_id;
-	int i, ret;
+	int i;
 
 	xpcs = kzalloc(sizeof(*xpcs), GFP_KERNEL);
 	if (!xpcs)
@@ -1099,37 +1110,27 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 
 	xpcs_id = xpcs_get_id(xpcs);
 
+	/* If Device ID are all ones, there is no device found */
+	if (xpcs_id == 0xffffffff)
+		goto out;
+
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
 		const struct xpcs_id *entry = &xpcs_id_list[i];
-		const struct xpcs_compat *compat;
 
 		if ((xpcs_id & entry->mask) != entry->id)
 			continue;
 
 		xpcs->id = entry;
-
-		compat = xpcs_find_compat(entry, interface);
-		if (!compat) {
-			ret = -ENODEV;
-			goto out;
-		}
-
 		xpcs->pcs.ops = &xpcs_phylink_ops;
 		xpcs->pcs.poll = true;
 
-		ret = xpcs_soft_reset(xpcs, compat);
-		if (ret)
-			goto out;
-
 		return xpcs;
 	}
 
-	ret = -ENODEV;
-
 out:
 	kfree(xpcs);
 
-	return ERR_PTR(ret);
+	return ERR_PTR(-ENODEV);
 }
 EXPORT_SYMBOL_GPL(xpcs_create);
 
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index add077a81b21..d841f55f12cc 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -35,8 +35,8 @@ void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface);
+int xpcs_reset(struct dw_xpcs *xpcs, phy_interface_t interface);
+struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev);
 void xpcs_destroy(struct dw_xpcs *xpcs);
 
 #endif /* __LINUX_PCS_XPCS_H */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a6f03b36fc4f..0f901773c5e4 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -268,5 +268,6 @@ struct plat_stmmacenet_data {
 	int msi_rx_base_vec;
 	int msi_tx_base_vec;
 	bool use_phy_wol;
+	bool skip_xpcs_soft_reset;
 };
 #endif
-- 
2.25.1

