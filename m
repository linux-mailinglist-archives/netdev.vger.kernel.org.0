Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217C56CAB66
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjC0RDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjC0RDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:03:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA95559F
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FJcvW6FLMBuR5dReLaQ9QVdJBJjtutnnsIjGOsXsj88=; b=ZOUzB6VA6DNS7lbs92RKL255yJ
        B8BASDogmN+1cy0SLoUY3DSIsBmWQSSw9ES/EAZZGTX5ovegaBasHfiRAzBhHR/ZjjaZhNUmK1Zqh
        yuBKFuD9pthrV1HN0DfMz8V2Y9QMXG5hVSJ51VrEeQFFqcFsSgJCOP2j1WlQlhLrQOts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEV-008XtO-RV; Mon, 27 Mar 2023 19:02:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 21/23] net: phylink: Extend mac_capabilities in MAC drivers which support EEE
Date:   Mon, 27 Mar 2023 19:01:59 +0200
Message-Id: <20230327170201.2036708-22-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For MAC drivers making use of phylink, and which support EEE, set the
MAC_EEE bit in the mac_capabilities.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mvneta.c             | 2 +-
 drivers/net/ethernet/microchip/lan743x_main.c     | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 net/dsa/port.c                                    | 3 +++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c7d53fc774c3..9560a627fb78 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5444,7 +5444,7 @@ static int mvneta_probe(struct platform_device *pdev)
 
 	pp->phylink_config.dev = &dev->dev;
 	pp->phylink_config.type = PHYLINK_NETDEV;
-	pp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
+	pp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_EEE | MAC_10 |
 		MAC_100 | MAC_1000FD | MAC_2500FD;
 
 	phy_interface_set_rgmii(pp->phylink_config.supported_interfaces);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 7986f8fcf7d3..ad76be484536 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1543,6 +1543,8 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	phy->fc_request_control = (FLOW_CTRL_RX | FLOW_CTRL_TX);
 	phy->fc_autoneg = phydev->autoneg;
 
+	phy_support_eee(phydev);
+
 	phy_start(phydev);
 	phy_start_aneg(phydev);
 	phy_attached_info(phydev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 12cf6674909c..90aa602647ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1233,6 +1233,9 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 			~(MAC_10HD | MAC_100HD | MAC_1000HD);
 	priv->phylink_config.mac_managed_pm = true;
 
+	if (priv->dma_cap.eee)
+		priv->phylink_config.mac_capabilities |= MAC_EEE;
+
 	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
 	if (IS_ERR(phylink))
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 44c923b568ed..0d1bff988059 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1698,6 +1698,9 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
+	if (ds->ops->set_mac_eee && ds->ops->get_mac_eee)
+		dp->pl_config.mac_capabilities |= MAC_EEE;
+
 	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
 			    mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(pl)) {
-- 
2.39.2

