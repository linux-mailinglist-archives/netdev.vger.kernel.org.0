Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A754686680
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjBANPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjBANPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:15:31 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D34E6AD3F;
        Wed,  1 Feb 2023 05:15:29 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,263,1669042800"; 
   d="scan'208";a="151302371"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 01 Feb 2023 22:15:28 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id DE8BE400C738;
        Wed,  1 Feb 2023 22:15:28 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v5 1/5] net: renesas: rswitch: Simplify struct phy * handling
Date:   Wed,  1 Feb 2023 22:14:50 +0900
Message-Id: <20230201131454.1928136-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify struct phy *serdes handling by keeping the valiable in
the struct rswitch_device.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 103 ++++++-------------------
 drivers/net/ethernet/renesas/rswitch.h |   2 +
 2 files changed, 27 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 14fc0af304ce..1c154018d795 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1071,32 +1071,14 @@ static struct device_node *rswitch_get_port_node(struct rswitch_device *rdev)
 	return port;
 }
 
-/* Call of_node_put(mdio) after done */
-static struct device_node *rswitch_get_mdio_node(struct rswitch_device *rdev)
-{
-	struct device_node *port, *mdio;
-
-	port = rswitch_get_port_node(rdev);
-	if (!port)
-		return NULL;
-
-	mdio = of_get_child_by_name(port, "mdio");
-	of_node_put(port);
-
-	return mdio;
-}
-
 static int rswitch_etha_get_params(struct rswitch_device *rdev)
 {
-	struct device_node *port;
 	int err;
 
-	port = rswitch_get_port_node(rdev);
-	if (!port)
+	if (!rdev->np_port)
 		return 0;	/* ignored */
 
-	err = of_get_phy_mode(port, &rdev->etha->phy_interface);
-	of_node_put(port);
+	err = of_get_phy_mode(rdev->np_port, &rdev->etha->phy_interface);
 
 	switch (rdev->etha->phy_interface) {
 	case PHY_INTERFACE_MODE_MII:
@@ -1133,7 +1115,7 @@ static int rswitch_mii_register(struct rswitch_device *rdev)
 	mii_bus->write_c45 = rswitch_etha_mii_write_c45;
 	mii_bus->parent = &rdev->priv->pdev->dev;
 
-	mdio_np = rswitch_get_mdio_node(rdev);
+	mdio_np = of_get_child_by_name(rdev->np_port, "mdio");
 	err = of_mdiobus_register(mii_bus, mdio_np);
 	if (err < 0) {
 		mdiobus_free(mii_bus);
@@ -1185,12 +1167,9 @@ static const struct phylink_mac_ops rswitch_phylink_ops = {
 
 static int rswitch_phylink_init(struct rswitch_device *rdev)
 {
-	struct device_node *port;
 	struct phylink *phylink;
-	int err;
 
-	port = rswitch_get_port_node(rdev);
-	if (!port)
+	if (!rdev->np_port)
 		return -ENODEV;
 
 	rdev->phylink_config.dev = &rdev->ndev->dev;
@@ -1199,19 +1178,14 @@ static int rswitch_phylink_init(struct rswitch_device *rdev)
 	__set_bit(PHY_INTERFACE_MODE_USXGMII, rdev->phylink_config.supported_interfaces);
 	rdev->phylink_config.mac_capabilities = MAC_100FD | MAC_1000FD | MAC_2500FD;
 
-	phylink = phylink_create(&rdev->phylink_config, &port->fwnode,
+	phylink = phylink_create(&rdev->phylink_config, &rdev->np_port->fwnode,
 				 rdev->etha->phy_interface, &rswitch_phylink_ops);
-	if (IS_ERR(phylink)) {
-		err = PTR_ERR(phylink);
-		goto out;
-	}
+	if (IS_ERR(phylink))
+		return PTR_ERR(phylink);
 
 	rdev->phylink = phylink;
-	err = phylink_of_phy_connect(rdev->phylink, port, rdev->etha->phy_interface);
-out:
-	of_node_put(port);
 
-	return err;
+	return phylink_of_phy_connect(rdev->phylink, rdev->np_port, rdev->etha->phy_interface);
 }
 
 static void rswitch_phylink_deinit(struct rswitch_device *rdev)
@@ -1224,47 +1198,14 @@ static void rswitch_phylink_deinit(struct rswitch_device *rdev)
 
 static int rswitch_serdes_set_params(struct rswitch_device *rdev)
 {
-	struct device_node *port = rswitch_get_port_node(rdev);
-	struct phy *serdes;
 	int err;
 
-	serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
-	of_node_put(port);
-	if (IS_ERR(serdes))
-		return PTR_ERR(serdes);
-
-	err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
+	err = phy_set_mode_ext(rdev->serdes, PHY_MODE_ETHERNET,
 			       rdev->etha->phy_interface);
 	if (err < 0)
 		return err;
 
-	return phy_set_speed(serdes, rdev->etha->speed);
-}
-
-static int rswitch_serdes_init(struct rswitch_device *rdev)
-{
-	struct device_node *port = rswitch_get_port_node(rdev);
-	struct phy *serdes;
-
-	serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
-	of_node_put(port);
-	if (IS_ERR(serdes))
-		return PTR_ERR(serdes);
-
-	return phy_init(serdes);
-}
-
-static int rswitch_serdes_deinit(struct rswitch_device *rdev)
-{
-	struct device_node *port = rswitch_get_port_node(rdev);
-	struct phy *serdes;
-
-	serdes = devm_of_phy_get(&rdev->priv->pdev->dev, port, NULL);
-	of_node_put(port);
-	if (IS_ERR(serdes))
-		return PTR_ERR(serdes);
-
-	return phy_exit(serdes);
+	return phy_set_speed(rdev->serdes, rdev->etha->speed);
 }
 
 static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
@@ -1286,6 +1227,12 @@ static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
 	if (err < 0)
 		goto err_phylink_init;
 
+	rdev->serdes = devm_of_phy_get(&rdev->priv->pdev->dev, rdev->np_port, NULL);
+	if (IS_ERR(rdev->serdes)) {
+		err = PTR_ERR(rdev->serdes);
+		goto err_serdes_phy_get;
+	}
+
 	err = rswitch_serdes_set_params(rdev);
 	if (err < 0)
 		goto err_serdes_set_params;
@@ -1293,6 +1240,7 @@ static int rswitch_ether_port_init_one(struct rswitch_device *rdev)
 	return 0;
 
 err_serdes_set_params:
+err_serdes_phy_get:
 	rswitch_phylink_deinit(rdev);
 
 err_phylink_init:
@@ -1318,7 +1266,7 @@ static int rswitch_ether_port_init_all(struct rswitch_private *priv)
 	}
 
 	rswitch_for_each_enabled_port(priv, i) {
-		err = rswitch_serdes_init(priv->rdev[i]);
+		err = phy_init(priv->rdev[i]->serdes);
 		if (err)
 			goto err_serdes;
 	}
@@ -1327,7 +1275,7 @@ static int rswitch_ether_port_init_all(struct rswitch_private *priv)
 
 err_serdes:
 	rswitch_for_each_enabled_port_continue_reverse(priv, i)
-		rswitch_serdes_deinit(priv->rdev[i]);
+		phy_exit(priv->rdev[i]->serdes);
 	i = RSWITCH_NUM_PORTS;
 
 err_init_one:
@@ -1342,7 +1290,7 @@ static void rswitch_ether_port_deinit_all(struct rswitch_private *priv)
 	int i;
 
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
-		rswitch_serdes_deinit(priv->rdev[i]);
+		phy_exit(priv->rdev[i]->serdes);
 		rswitch_ether_port_deinit_one(priv->rdev[i]);
 	}
 }
@@ -1565,7 +1513,6 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
 {
 	struct platform_device *pdev = priv->pdev;
 	struct rswitch_device *rdev;
-	struct device_node *port;
 	struct net_device *ndev;
 	int err;
 
@@ -1594,10 +1541,10 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
 
 	netif_napi_add(ndev, &rdev->napi, rswitch_poll);
 
-	port = rswitch_get_port_node(rdev);
-	rdev->disabled = !port;
-	err = of_get_ethdev_address(port, ndev);
-	of_node_put(port);
+	rdev->np_port = rswitch_get_port_node(rdev);
+	rdev->disabled = !rdev->np_port;
+	err = of_get_ethdev_address(rdev->np_port, ndev);
+	of_node_put(rdev->np_port);
 	if (err) {
 		if (is_valid_ether_addr(rdev->etha->mac_addr))
 			eth_hw_addr_set(ndev, rdev->etha->mac_addr);
@@ -1798,7 +1745,7 @@ static void rswitch_deinit(struct rswitch_private *priv)
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
 		struct rswitch_device *rdev = priv->rdev[i];
 
-		rswitch_serdes_deinit(rdev);
+		phy_exit(priv->rdev[i]->serdes);
 		rswitch_ether_port_deinit_one(rdev);
 		unregister_netdev(rdev->ndev);
 		rswitch_device_free(priv, i);
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 49efb0f31c77..6ae79395006e 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -953,6 +953,8 @@ struct rswitch_device {
 
 	int port;
 	struct rswitch_etha *etha;
+	struct device_node *np_port;
+	struct phy *serdes;
 };
 
 struct rswitch_mfwd_mac_table_entry {
-- 
2.25.1

