Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9053A48534E
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbiAENPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiAENPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:15:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A89AC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 05:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZRrjH6jdJrqkxNFeeQvp8tj83hjb5AGIe2VfjpV7jG8=; b=WShwrltq8q0ykYSoQY5WrxHHkD
        27iHB6JoaGSPyT9+MR6KY50+XN8npS3zONNq6nXqJweYY8t0RI/+sugIKibdwZno8OX4eoi9A2lXl
        SAdQy8ip26w0YYfqiiYHOWxj0lAcygHQebvm2HlJUf/XnoPcvkPnJo3O7c4Bbdlh5EYpz8LUUu/dD
        h1x9FYZQDg7mwNRurtDKNbTyQBA4B4PkSMqUye0r4a3p0E5NxZbqCiCoCPnxN90LkWEP/gaznzJZA
        2MVv5DWK7lNNDTAYIQabBMyPrREnzFvG7kFOO2btq44SJbgl61UhYdGAoyYnNwtR9TkXFpQVrouHf
        2MSh4t5A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58298 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1n568K-00082z-2r; Wed, 05 Jan 2022 13:15:16 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1n568J-002SZX-Gr; Wed, 05 Jan 2022 13:15:15 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: macb: use .mac_select_pcs() interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1n568J-002SZX-Gr@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 05 Jan 2022 13:15:15 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the PCS selection to use mac_select_pcs, which allows the PCS
to perform any validation it needs.

We must use separate phylink_pcs instances for the USX and SGMII PCS,
rather than just changing the "ops" pointer before re-setting it to
phylink as this interface queries the PCS, rather than requesting it
to be changed.

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/cadence/macb.h      |  3 ++-
 drivers/net/ethernet/cadence/macb_main.c | 26 +++++++++++-------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 5620b97b3482..9ddbee7de72b 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1271,7 +1271,8 @@ struct macb {
 	struct mii_bus		*mii_bus;
 	struct phylink		*phylink;
 	struct phylink_config	phylink_config;
-	struct phylink_pcs	phylink_pcs;
+	struct phylink_pcs	phylink_usx_pcs;
+	struct phylink_pcs	phylink_sgmii_pcs;
 
 	u32			caps;
 	unsigned int		dma_burst_length;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d4da9adf6777..a363da928e8b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -510,7 +510,7 @@ static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 				 phy_interface_t interface, int speed,
 				 int duplex)
 {
-	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	struct macb *bp = container_of(pcs, struct macb, phylink_usx_pcs);
 	u32 config;
 
 	config = gem_readl(bp, USX_CONTROL);
@@ -524,7 +524,7 @@ static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
 				   struct phylink_link_state *state)
 {
-	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	struct macb *bp = container_of(pcs, struct macb, phylink_usx_pcs);
 	u32 val;
 
 	state->speed = SPEED_10000;
@@ -544,7 +544,7 @@ static int macb_usx_pcs_config(struct phylink_pcs *pcs,
 			       const unsigned long *advertising,
 			       bool permit_pause_to_mac)
 {
-	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	struct macb *bp = container_of(pcs, struct macb, phylink_usx_pcs);
 
 	gem_writel(bp, USX_CONTROL, gem_readl(bp, USX_CONTROL) |
 		   GEM_BIT(SIGNAL_OK));
@@ -727,28 +727,23 @@ static void macb_mac_link_up(struct phylink_config *config,
 	netif_tx_wake_all_queues(ndev);
 }
 
-static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
-			    phy_interface_t interface)
+static struct phylink_pcs *macb_mac_select_pcs(struct phylink_config *config,
+					       phy_interface_t interface)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct macb *bp = netdev_priv(ndev);
 
 	if (interface == PHY_INTERFACE_MODE_10GBASER)
-		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
+		return &bp->phylink_usx_pcs;
 	else if (interface == PHY_INTERFACE_MODE_SGMII)
-		bp->phylink_pcs.ops = &macb_phylink_pcs_ops;
+		return &bp->phylink_sgmii_pcs;
 	else
-		bp->phylink_pcs.ops = NULL;
-
-	if (bp->phylink_pcs.ops)
-		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
-
-	return 0;
+		return NULL;
 }
 
 static const struct phylink_mac_ops macb_phylink_ops = {
 	.validate = phylink_generic_validate,
-	.mac_prepare = macb_mac_prepare,
+	.mac_select_pcs = macb_mac_select_pcs,
 	.mac_config = macb_mac_config,
 	.mac_link_down = macb_mac_link_down,
 	.mac_link_up = macb_mac_link_up,
@@ -806,6 +801,9 @@ static int macb_mii_probe(struct net_device *dev)
 {
 	struct macb *bp = netdev_priv(dev);
 
+	bp->phylink_sgmii_pcs.ops = &macb_phylink_pcs_ops;
+	bp->phylink_usx_pcs.ops = &macb_phylink_usx_pcs_ops;
+
 	bp->phylink_config.dev = &dev->dev;
 	bp->phylink_config.type = PHYLINK_NETDEV;
 
-- 
2.30.2

