Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267122CF4C9
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgLDT34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:29:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDT34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 14:29:56 -0500
From:   Arnd Bergmann <arnd@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.cionei@nxp.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Po Liu <Po.Liu@nxp.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] enetc: fix build warning
Date:   Fri,  4 Dec 2020 20:28:59 +0100
Message-Id: <20201204192910.2306023-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_OF is disabled, there is a harmless warning about
an unused variable:

enetc_pf.c: In function 'enetc_phylink_create':
enetc_pf.c:981:17: error: unused variable 'dev' [-Werror=unused-variable]

Slightly rearrange the code to pass around the of_node as a
function argument, which avoids the problem without hurting
readability.

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: move added variable declaration up
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ecdc2af8c292..ed8fcb8b486e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -851,13 +851,12 @@ static bool enetc_port_has_pcs(struct enetc_pf *pf)
 		pf->if_mode == PHY_INTERFACE_MODE_USXGMII);
 }
 
-static int enetc_mdiobus_create(struct enetc_pf *pf)
+static int enetc_mdiobus_create(struct enetc_pf *pf, struct device_node *node)
 {
-	struct device *dev = &pf->si->pdev->dev;
 	struct device_node *mdio_np;
 	int err;
 
-	mdio_np = of_get_child_by_name(dev->of_node, "mdio");
+	mdio_np = of_get_child_by_name(node, "mdio");
 	if (mdio_np) {
 		err = enetc_mdio_probe(pf, mdio_np);
 
@@ -969,18 +968,17 @@ static const struct phylink_mac_ops enetc_mac_phylink_ops = {
 	.mac_link_down = enetc_pl_mac_link_down,
 };
 
-static int enetc_phylink_create(struct enetc_ndev_priv *priv)
+static int enetc_phylink_create(struct enetc_ndev_priv *priv,
+				struct device_node *node)
 {
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	struct device *dev = &pf->si->pdev->dev;
 	struct phylink *phylink;
 	int err;
 
 	pf->phylink_config.dev = &priv->ndev->dev;
 	pf->phylink_config.type = PHYLINK_NETDEV;
 
-	phylink = phylink_create(&pf->phylink_config,
-				 of_fwnode_handle(dev->of_node),
+	phylink = phylink_create(&pf->phylink_config, of_fwnode_handle(node),
 				 pf->if_mode, &enetc_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -1001,13 +999,14 @@ static void enetc_phylink_destroy(struct enetc_ndev_priv *priv)
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
+	struct device_node *node = pdev->dev.of_node;
 	struct enetc_ndev_priv *priv;
 	struct net_device *ndev;
 	struct enetc_si *si;
 	struct enetc_pf *pf;
 	int err;
 
-	if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
+	if (node && !of_device_is_available(node)) {
 		dev_info(&pdev->dev, "device is disabled, skipping\n");
 		return -ENODEV;
 	}
@@ -1058,12 +1057,12 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	if (!of_get_phy_mode(pdev->dev.of_node, &pf->if_mode)) {
-		err = enetc_mdiobus_create(pf);
+	if (!of_get_phy_mode(node, &pf->if_mode)) {
+		err = enetc_mdiobus_create(pf, node);
 		if (err)
 			goto err_mdiobus_create;
 
-		err = enetc_phylink_create(priv);
+		err = enetc_phylink_create(priv, node);
 		if (err)
 			goto err_phylink_create;
 	}
-- 
2.27.0

