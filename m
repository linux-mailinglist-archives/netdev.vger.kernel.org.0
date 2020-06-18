Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933781FF708
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgFRPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgFRPiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:38:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8C6C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 08:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q9GgV9RiYxE/lW1IEZqGAacLd7C7DiNvgsa6PYmlJrk=; b=NcEe/CvcjH1NhO85b+LCzVZKos
        yzcoo98SJCvCXFVouF2VZJjhPx9cMvF5kXOsMXW6cZmiql6Ed8sOx+uj8ZR7lBWfAuDqxKaVR9/In
        W29pBIyYJxxbrm9D9UZ+ti1KtuZn1n2iL2x5099llFIfLisTPgEW2ohJ/Sm54FjY7EkkJOL2wRKQl
        qF48R412CrVRYiG/eb11pg9yhDbxaS8nVDINmz1+FlVY5sftaziEdbi2j4BL/ofwxUkitbriD9ubW
        uMBU4nLQlx7GnsNXW2rhk9/TBD9ToPGqxwUyZwuIaC3KehjjvAtAVsmX8/LPmHZKboFKCsxIZDyLq
        IBnzjLlQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38266 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlwct-0005I9-LQ; Thu, 18 Jun 2020 16:38:51 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jlwct-0005Hj-6W; Thu, 18 Jun 2020 16:38:51 +0100
In-Reply-To: <20200618153818.GD1551@shell.armlinux.org.uk>
References: <20200618153818.GD1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jlwct-0005Hj-6W@rmk-PC.armlinux.org.uk>
Date:   Thu, 18 Jun 2020 16:38:51 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to convert the struct phylink_config pointer passed in
from phylink to the drivers internal struct mvpp2_port.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 7653277d03b7..8c8314715efd 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4767,12 +4767,17 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 	eth_hw_addr_random(dev);
 }
 
+static inline struct mvpp2_port *
+mvpp2_phylink_to_port(struct phylink_config *config)
+{
+	return container_of(config, struct mvpp2_port, phylink_config);
+}
+
 static void mvpp2_phylink_validate(struct phylink_config *config,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
-					       phylink_config);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	/* Invalid combinations */
@@ -4913,8 +4918,7 @@ static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
 static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
 					    struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
-					       phylink_config);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 
 	if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
 		u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
@@ -4931,8 +4935,7 @@ static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
 
 static void mvpp2_mac_an_restart(struct phylink_config *config)
 {
-	struct mvpp2_port *port = container_of(config, struct mvpp2_port,
-					       phylink_config);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 
 	writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
@@ -5105,13 +5108,12 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
-	struct net_device *dev = to_net_dev(config->dev);
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	bool change_interface = port->phy_interface != state->interface;
 
 	/* Check for invalid configuration */
 	if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
-		netdev_err(dev, "Invalid mode on %s\n", dev->name);
+		netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
 		return;
 	}
 
@@ -5151,8 +5153,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			      int speed, int duplex,
 			      bool tx_pause, bool rx_pause)
 {
-	struct net_device *dev = to_net_dev(config->dev);
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val;
 
 	if (mvpp2_is_xlg(interface)) {
@@ -5199,14 +5200,13 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 
 	mvpp2_egress_enable(port);
 	mvpp2_ingress_enable(port);
-	netif_tx_wake_all_queues(dev);
+	netif_tx_wake_all_queues(port->dev);
 }
 
 static void mvpp2_mac_link_down(struct phylink_config *config,
 				unsigned int mode, phy_interface_t interface)
 {
-	struct net_device *dev = to_net_dev(config->dev);
-	struct mvpp2_port *port = netdev_priv(dev);
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val;
 
 	if (!phylink_autoneg_inband(mode)) {
@@ -5223,7 +5223,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
 		}
 	}
 
-	netif_tx_stop_all_queues(dev);
+	netif_tx_stop_all_queues(port->dev);
 	mvpp2_egress_disable(port);
 	mvpp2_ingress_disable(port);
 
-- 
2.20.1

