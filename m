Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDF7545A96
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242989AbiFJDfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241438AbiFJDfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:35:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6661DFC41;
        Thu,  9 Jun 2022 20:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832098; x=1686368098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJL02eXOJ6PqC8kbf/jCzhaldzTN2TIxSgiMk42PRXA=;
  b=F9+Gy60Px3xLjuhOq3aOZOoP9jq7A3Cjsondq5jqqaRTVgAITYgNOZhS
   hh1qqZZjytgVqdO1BxLXu3hCowCoU7Q6uj/Whu83XPBLJjpFINnCw+Jn8
   Eb4QL+SvmnOCXQ4dqOX8+CvbE4uxjxlqFVBnQ39NzdBM6qV00VAevDn/d
   G80A6sa6Dnp6lNE98y7zqibNMqWlk93Kk1KVhchQOvjNWH6UlCNW7C77X
   oldfsnNzLUn5YcgErRAH10Ag8TyukWBlh/REzWw4mu0VvdxDnia1bnlWa
   4ciUVIcS6ll/06k4bheGZ8T28E9MM6EeiE9frxSNX/62SK28XtV/fh2ws
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="302872674"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="302872674"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:34:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="585971700"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2022 20:34:53 -0700
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
Subject: [PATCH net-next v2 6/6] net: stmmac: make mdio register skips PHY scanning for fixed-link
Date:   Fri, 10 Jun 2022 11:29:41 +0800
Message-Id: <20220610032941.113690-7-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610032941.113690-1-boon.leong.ong@intel.com>
References: <20220610032941.113690-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

