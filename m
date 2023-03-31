Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECE76D1477
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCaA4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjCaAzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E022CA30
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RCuP5Gl3E6IZNAqlJ2JcW/mqur+qGEdqu2d0PBfr/04=; b=XmkvxQ7MEPBk2yXhtnxBl/E/U9
        RqhqUVcd5PL9jMS6G48jHvakuSLpLrpVaQOSKBJ28klirbRbnqM/X6RulD85Vetb4/+jV9AWjnzH+
        O+A94i5ClAH4Iwmu7oc7to3JwLzxkym/2zJ4n99hX5T3XcPHWP9odVK1dDeNqIEsh0uY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33M-008xLV-24; Fri, 31 Mar 2023 02:55:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 22/24] net: phylink: Extend mac_capabilities in MAC drivers which support EEE
Date:   Fri, 31 Mar 2023 02:55:16 +0200
Message-Id: <20230331005518.2134652-23-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
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
index fba9edad9e37..efe751da899b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5450,7 +5450,7 @@ static int mvneta_probe(struct platform_device *pdev)
 
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
index 190b74d7f4e7..522e6bb9e1fd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1232,6 +1232,9 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 			~(MAC_10HD | MAC_100HD | MAC_1000HD);
 	priv->phylink_config.mac_managed_pm = true;
 
+	if (priv->dma_cap.eee)
+		priv->phylink_config.mac_capabilities |= MAC_EEE;
+
 	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
 	if (IS_ERR(phylink))
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 67ad1adec2a2..68e52abadd7e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1696,6 +1696,9 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
+	if (ds->ops->set_mac_eee && ds->ops->get_mac_eee)
+		dp->pl_config.mac_capabilities |= MAC_EEE;
+
 	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
 			    mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(pl)) {
-- 
2.40.0

