Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D150B1D9
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444949AbiDVHnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444943AbiDVHm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:42:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263A5517D1;
        Fri, 22 Apr 2022 00:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650613176; x=1682149176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6GcMHH6yUqex4pWxo8BLj/3zpi1O7XDEvvpDjCDkD0s=;
  b=TFn2bTIe/cUBE+BIyJnoE3JAQgbwQLM+nGCdcMSSZniqJ3Xo9io0wihu
   hR4eXm3nKeSziM9OCFV1z/XfzttWwPUY5iTVHK3ZPtbiZ0ocTKQwC/M6J
   stzN+quJmLxreoJZSpk38w3V5DR5MAjnZ1FkYNL2/fa+iI1bM4DMoKWMr
   5Xz6quCCO6t9ixKQK6HaXs7zdyH7NHE8XAF0WnwqGItmIbkJzne5clvUL
   HhpJklA9q6UQAPzETLFUmtemAvc2L9b/1m5CZfm7ts6YJOR4OlggkQ5Mf
   KylXGRuKE5E7uJGVzSA2rtdd50qmCRUoUwHoheo5JRDHOOiawbqzCVRBM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245180225"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="245180225"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:39:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="648516336"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Apr 2022 00:39:32 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 2/4] net: stmmac: introduce PHY-less setup support
Date:   Fri, 22 Apr 2022 15:35:03 +0800
Message-Id: <20220422073505.810084-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422073505.810084-1-boon.leong.ong@intel.com>
References: <20220422073505.810084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain platform uses PHY-less configuration whereby the MAC controller
is connected to network switch chip directly over SGMII or 1000BASE-X.

This patch prepares the stmmac driver to support PHY-less configuration
described above.

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c |  2 +-
 include/linux/stmmac.h                            |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 57cb11abec8..4d39387bc48 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1142,11 +1142,18 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	struct stmmac_mdio_bus_data *mdio_bus_data;
 	struct device_node *node;
-	int ret;
+	int ret = 0;
 
+	mdio_bus_data = priv->plat->mdio_bus_data;
 	node = priv->plat->phylink_node;
 
+	if (mdio_bus_data->phyless) {
+		netdev_info(priv->dev, "using PHY-less setup\n");
+		goto phyless_setup;
+	}
+
 	if (node)
 		ret = phylink_of_phy_connect(priv->phylink, node, 0);
 
@@ -1166,6 +1173,7 @@ static int stmmac_init_phy(struct net_device *dev)
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
+phyless_setup:
 	if (!priv->plat->pmt) {
 		struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 9bc625fccca..16ce188697e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -490,7 +490,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	if (priv->plat->has_xgmac)
 		stmmac_xgmac2_mdio_read(new_bus, 0, MII_ADDR_C45);
 
-	if (priv->plat->phy_node || mdio_node)
+	if (priv->plat->phy_node || mdio_node || mdio_bus_data->phyless)
 		goto bus_register_done;
 
 	found = 0;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index f8e8df25098..238d452ef43 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -82,6 +82,7 @@ struct stmmac_mdio_bus_data {
 	unsigned int phy_mask;
 	unsigned int has_xpcs;
 	unsigned int xpcs_an_inband;
+	unsigned int phyless;
 	int *irqs;
 	int probed_phy_irq;
 	bool needs_reset;
-- 
2.25.1

