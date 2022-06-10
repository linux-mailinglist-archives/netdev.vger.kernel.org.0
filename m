Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB51545AB6
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346141AbiFJDl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346077AbiFJDlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:41:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC0E22076B;
        Thu,  9 Jun 2022 20:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832473; x=1686368473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJL02eXOJ6PqC8kbf/jCzhaldzTN2TIxSgiMk42PRXA=;
  b=Lfq4p+ZcUMH4qT55KepU3CgVO/53lYnoe3Pv5FBxy9rdvPcJoBfW4YGN
   hfC0jQQrCYqNBKP95cAXvb3xoXNbfxw2/6SncADpusmo6NUAD2Xb138RQ
   sZO/F68c3MRmGAH3sKUKCeyq3kz/KHI1R0MfvYsR41vb5+0GiQislF3yX
   WEvwBZgxd8Tzqs2+/Sa+soRcSHhe1uCE0panR439YiH+zEN+YI7vf7yX3
   WPzsevgmmxvbxoNRkiW4Fqh2K0qjLTcGjwaDGBdm/OOi/SyzNR7E7/UcG
   n0MyTk4XoCAopWGhrKwPOENWGfEASVQXk+uZ06cN8j2ccM7R9nBEdUOqu
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278305274"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="278305274"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:41:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="827994021"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2022 20:41:08 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v3 7/7] net: stmmac: make mdio register skips PHY scanning for fixed-link
Date:   Fri, 10 Jun 2022 11:36:10 +0800
Message-Id: <20220610033610.114084-8-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610033610.114084-1-boon.leong.ong@intel.com>
References: <20220610033610.114084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_mdio_register() lacks fixed-link consideration and only skip PHY
scanning if it has done DT style PHY discovery. So, for DT or ACPI _DSD
setting of fixed-link, the PHY scanning should not happen.

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 ++++++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 14 ++++++++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 73cae2938f6..bc8edd88175 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1141,19 +1141,20 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
  */
 static int stmmac_init_phy(struct net_device *dev)
 {
+	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	struct stmmac_priv *priv = netdev_priv(dev);
-	struct device_node *node;
 	int ret;
 
-	node = priv->plat->phylink_node;
+	if (!fwnode)
+		fwnode = dev_fwnode(priv->device);
 
-	if (node)
-		ret = phylink_of_phy_connect(priv->phylink, node, 0);
+	if (fwnode)
+		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
 
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!node || ret) {
+	if (!fwnode || ret) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 03d3d1f7aa4..5f177ea8072 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -434,9 +434,11 @@ int stmmac_mdio_register(struct net_device *ndev)
 	int err = 0;
 	struct mii_bus *new_bus;
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
 	struct device_node *mdio_node = priv->plat->mdio_node;
 	struct device *dev = ndev->dev.parent;
+	struct fwnode_handle *fixed_node;
 	int addr, found, max_addr;
 
 	if (!mdio_bus_data)
@@ -490,6 +492,18 @@ int stmmac_mdio_register(struct net_device *ndev)
 	if (priv->plat->has_xgmac)
 		stmmac_xgmac2_mdio_read(new_bus, 0, MII_ADDR_C45);
 
+	/* If fixed-link is set, skip PHY scanning */
+	if (!fwnode)
+		fwnode = dev_fwnode(priv->device);
+
+	if (fwnode) {
+		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
+		if (fixed_node) {
+			fwnode_handle_put(fixed_node);
+			goto bus_register_done;
+		}
+	}
+
 	if (priv->plat->phy_node || mdio_node)
 		goto bus_register_done;
 
-- 
2.25.1

