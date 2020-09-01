Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0694F258F70
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgIANtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbgIANsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:48:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FC4C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fqPJ0ZIDsPER4+f4hxSqegvHlld5uZHXWJO6MhOz/aQ=; b=myuMF1h7834can4hOhFov7alkO
        iq5iMN08T69TxXepQgfkhsKA2P/FcJe93j6NMVNYzWHfMItCg1WuROj0ez+CUcUdAt0H10ohT3W1K
        gvYpQdqPx6o+n+hTa7nm9e7vMXGtPZW8yYDOPvt8d2dh9Err7vIykw6sooI428iuwNKoiHCIinzTq
        xHNRHtesqU7Un5TeMHlWHr/HqhvyEme+P4SKUo/1mk3WIV0Bzk7+lo+wat4HtaQB8zIfHiCAXD7u0
        naF1rj5V1Wg7uI46wE8AUUtx8oj5M8hrPpB2vCT6CJJ16XHYtCLBsrKgm/+qGwQIduhvzwBemvNQ/
        2wP/faEw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36090 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6eM-0002ZB-5c; Tue, 01 Sep 2020 14:48:38 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kD6eL-0007Ll-Uh; Tue, 01 Sep 2020 14:48:37 +0100
In-Reply-To: <20200901134746.GM1551@shell.armlinux.org.uk>
References: <20200901134746.GM1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 6/6] net: mvpp2: split xlg and gmac pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kD6eL-0007Ll-Uh@rmk-PC.armlinux.org.uk>
Date:   Tue, 01 Sep 2020 14:48:37 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the XLG and GMAC PCS implementations and switch between them
during the mac_prepare() method.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 110 +++++++++---------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 6d3d84dc6d84..d0bbe3a64b8d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5381,9 +5381,10 @@ static struct mvpp2_port *mvpp2_pcs_to_port(struct phylink_pcs *pcs)
 	return container_of(pcs, struct mvpp2_port, phylink_pcs);
 }
 
-static void mvpp22_xlg_pcs_get_state(struct mvpp2_port *port,
-				     struct phylink_link_state *state)
+static void mvpp2_xlg_pcs_get_state(struct phylink_pcs *pcs,
+				    struct phylink_link_state *state)
 {
+	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
 	u32 val;
 
 	state->speed = SPEED_10000;
@@ -5401,9 +5402,24 @@ static void mvpp22_xlg_pcs_get_state(struct mvpp2_port *port,
 		state->pause |= MLO_PAUSE_RX;
 }
 
-static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
+static int mvpp2_xlg_pcs_config(struct phylink_pcs *pcs,
+				unsigned int mode,
+				phy_interface_t interface,
+				const unsigned long *advertising,
+				bool permit_pause_to_mac)
+{
+	return 0;
+}
+
+static const struct phylink_pcs_ops mvpp2_phylink_xlg_pcs_ops = {
+	.pcs_get_state = mvpp2_xlg_pcs_get_state,
+	.pcs_config = mvpp2_xlg_pcs_config,
+};
+
+static void mvpp2_gmac_pcs_get_state(struct phylink_pcs *pcs,
 				     struct phylink_link_state *state)
 {
+	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
 	u32 val;
 
 	val = readl(port->base + MVPP2_GMAC_STATUS0);
@@ -5435,29 +5451,12 @@ static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
 		state->pause |= MLO_PAUSE_TX;
 }
 
-static void mvpp2_phylink_pcs_get_state(struct phylink_pcs *pcs,
-					struct phylink_link_state *state)
-{
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
-
-	if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
-		u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
-		mode &= MVPP22_XLG_CTRL3_MACMODESELECT_MASK;
-
-		if (mode == MVPP22_XLG_CTRL3_MACMODESELECT_10G) {
-			mvpp22_xlg_pcs_get_state(port, state);
-			return;
-		}
-	}
-
-	mvpp2_gmac_pcs_get_state(port, state);
-}
-
-static int mvpp2_gmac_pcs_config(struct mvpp2_port *port, unsigned int mode,
+static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 				 phy_interface_t interface,
 				 const unsigned long *advertising,
 				 bool permit_pause_to_mac)
 {
+	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
 	u32 mask, val, an, old_an, changed;
 
 	mask = MVPP2_GMAC_IN_BAND_AUTONEG_BYPASS |
@@ -5509,25 +5508,7 @@ static int mvpp2_gmac_pcs_config(struct mvpp2_port *port, unsigned int mode,
 	return changed & (MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN);
 }
 
-static int mvpp2_phylink_pcs_config(struct phylink_pcs *pcs,
-				    unsigned int mode,
-		                    phy_interface_t interface,
-				    const unsigned long *advertising,
-				    bool permit_pause_to_mac)
-{
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
-	int ret;
-
-	if (mvpp2_is_xlg(interface))
-		ret = 0;
-	else
-		ret = mvpp2_gmac_pcs_config(port, mode, interface, advertising,
-					    permit_pause_to_mac);
-
-	return ret;
-}
-
-static void mvpp2_phylink_pcs_an_restart(struct phylink_pcs *pcs)
+static void mvpp2_gmac_pcs_an_restart(struct phylink_pcs *pcs)
 {
 	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
 	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
@@ -5538,10 +5519,10 @@ static void mvpp2_phylink_pcs_an_restart(struct phylink_pcs *pcs)
 	       port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 }
 
-static const struct phylink_pcs_ops mvpp2_phylink_pcs_ops = {
-	.pcs_get_state = mvpp2_phylink_pcs_get_state,
-	.pcs_config = mvpp2_phylink_pcs_config,
-	.pcs_an_restart = mvpp2_phylink_pcs_an_restart,
+static const struct phylink_pcs_ops mvpp2_phylink_gmac_pcs_ops = {
+	.pcs_get_state = mvpp2_gmac_pcs_get_state,
+	.pcs_config = mvpp2_gmac_pcs_config,
+	.pcs_an_restart = mvpp2_gmac_pcs_an_restart,
 };
 
 static void mvpp2_phylink_validate(struct phylink_config *config,
@@ -5711,8 +5692,8 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		writel(ctrl4, port->base + MVPP22_GMAC_CTRL_4_REG);
 }
 
-static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
-			     phy_interface_t interface)
+static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
+			      phy_interface_t interface)
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 
@@ -5758,9 +5739,31 @@ static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
 		}
 	}
 
+	/* Select the appropriate PCS operations depending on the
+	 * configured interface mode. We will only switch to a mode
+	 * that the validate() checks have already passed.
+	 */
+	if (mvpp2_is_xlg(interface))
+		port->phylink_pcs.ops = &mvpp2_phylink_xlg_pcs_ops;
+	else
+		port->phylink_pcs.ops = &mvpp2_phylink_gmac_pcs_ops;
+
 	return 0;
 }
 
+static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
+			     phy_interface_t interface)
+{
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
+	int ret;
+
+	ret = mvpp2__mac_prepare(config, mode, interface);
+	if (ret == 0)
+		phylink_set_pcs(port->phylink, &port->phylink_pcs);
+
+	return ret;
+}
+
 static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
@@ -5934,12 +5937,12 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 	struct phylink_link_state state = {
 		.interface = port->phy_interface,
 	};
-	mvpp2_mac_prepare(&port->phylink_config, MLO_AN_INBAND,
-			  port->phy_interface);
+	mvpp2__mac_prepare(&port->phylink_config, MLO_AN_INBAND,
+			   port->phy_interface);
 	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
-	mvpp2_phylink_pcs_config(&port->phylink_pcs, MLO_AN_INBAND,
-				 port->phy_interface, state.advertising,
-				 false);
+	port->phylink_pcs.ops->pcs_config(&port->phylink_pcs, MLO_AN_INBAND,
+					  port->phy_interface,
+					  state.advertising, false);
 	mvpp2_mac_finish(&port->phylink_config, MLO_AN_INBAND,
 			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
@@ -6171,9 +6174,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 			goto err_free_port_pcpu;
 		}
 		port->phylink = phylink;
-
-		port->phylink_pcs.ops = &mvpp2_phylink_pcs_ops;
-		phylink_set_pcs(phylink, &port->phylink_pcs);
 	} else {
 		port->phylink = NULL;
 	}
-- 
2.20.1

