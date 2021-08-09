Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53AC3E43B8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhHIKRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:17:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:15798 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234871AbhHIKRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:17:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214648747"
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="214648747"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 03:17:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="505146806"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2021 03:17:09 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 7A3A2580922;
        Mon,  9 Aug 2021 03:17:05 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: pcs: xpcs: enable skip xPCS soft reset
Date:   Mon,  9 Aug 2021 18:22:28 +0800
Message-Id: <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
References: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

Unlike any other platforms, Intel AlderLake-S uses Synopsys SerDes where
all the SerDes PLL configurations are controlled by the xPCS at the BIOS
level. If the driver perform a xPCS soft reset on initialization, these
settings will be switched back to the power on reset values.

This changes the xpcs_create function to take in an additional argument
to check if the platform request to skip xPCS soft reset during device
initialization.

Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c           |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c    |  4 +++-
 drivers/net/pcs/pcs-xpcs.c                       | 16 ++++++++++++----
 include/linux/pcs/pcs-xpcs.h                     |  3 ++-
 include/linux/stmmac.h                           |  1 +
 5 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 19aea8fb76f6..73b43a5da68a 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -437,7 +437,7 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 			goto out_pcs_free;
 		}
 
-		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
+		xpcs = xpcs_create(mdiodev, priv->phy_mode[port], false);
 		if (IS_ERR(xpcs)) {
 			rc = PTR_ERR(xpcs);
 			goto out_pcs_free;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5d150c5f3d8..803a4e61105b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -401,12 +401,14 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 {
 	struct net_device *ndev = bus->priv;
 	struct mdio_device *mdiodev;
+	bool skip_xpcs_soft_reset;
 	struct stmmac_priv *priv;
 	struct dw_xpcs *xpcs;
 	int mode, addr;
 
 	priv = netdev_priv(ndev);
 	mode = priv->plat->phy_interface;
+	skip_xpcs_soft_reset = priv->plat->skip_xpcs_soft_reset;
 
 	/* Try to probe the XPCS by scanning all addresses. */
 	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
@@ -414,7 +416,7 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 		if (IS_ERR(mdiodev))
 			continue;
 
-		xpcs = xpcs_create(mdiodev, mode);
+		xpcs = xpcs_create(mdiodev, mode, skip_xpcs_soft_reset);
 		if (IS_ERR_OR_NULL(xpcs)) {
 			mdio_device_free(mdiodev);
 			continue;
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 63fda3fc40aa..c7a3aa862079 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1081,7 +1081,8 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 };
 
 struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface)
+			    phy_interface_t interface,
+			    bool skip_reset)
 {
 	struct dw_xpcs *xpcs;
 	u32 xpcs_id;
@@ -1113,9 +1114,16 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 		xpcs->pcs.ops = &xpcs_phylink_ops;
 		xpcs->pcs.poll = true;
 
-		ret = xpcs_soft_reset(xpcs, compat);
-		if (ret)
-			goto out;
+		if (!skip_reset) {
+			dev_info(&xpcs->mdiodev->dev, "%s: xPCS soft reset\n",
+				 __func__);
+			ret = xpcs_soft_reset(xpcs, compat);
+			if (ret)
+				goto out;
+		} else {
+			dev_info(&xpcs->mdiodev->dev,
+				 "%s: skip xpcs soft reset\n", __func__);
+		}
 
 		return xpcs;
 	}
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index add077a81b21..0c05a63f3446 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -36,7 +36,8 @@ void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
 struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface);
+			    phy_interface_t interface,
+			    bool xpcs_reset);
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

