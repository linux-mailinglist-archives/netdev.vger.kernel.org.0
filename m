Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03114475BE6
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243964AbhLOPea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243961AbhLOPea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:34:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22BCC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YCLBRn8adzfeUoiziiGh0UP4lphY9GH8rsakcybggaw=; b=fhgzpS1CdBH+ajINQVVkVom5XL
        sAJMfKosMI6/nE3iEBWQ1+7Knp5p9j8t2MH2RwxFdTv2vrHeYtxfzhxvy0asDc6uenqLadM3urCkC
        jnAluiHlgYsGFFlOZixtM2dhc3y3TVI8HPRhT5y20gMU+uLF8917bNqBJELT3syEewJJGHxcSkQSf
        7eKL5jKFuHV75kfYqWCIUjnaTM8pDOfmWHddeGZJsvpT7o2xdlFNzbxb7ay5lTrlrbPCEjas2izih
        3o7jqE7GqXI7hHyGhjRjzqOvt5QYBFK6UlHnGHfLn+WiAuJEYggZuV83yd+MjLTlllkL9I6IRyVCX
        R9vShe8g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:43820 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIT-0006ZN-Qt; Wed, 15 Dec 2021 15:34:25 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mxWIT-00GPiJ-CX; Wed, 15 Dec 2021 15:34:25 +0000
In-Reply-To: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
References: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 net-next 3/7] net: mvpp2: use .mac_select_pcs() interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mxWIT-00GPiJ-CX@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 15 Dec 2021 15:34:25 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the mac_select_pcs() method to choose between the GMAC and XLG
PCS implementations.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  3 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 75 ++++++++++---------
 2 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index cf8acabb90ac..ad73a488fc5f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1239,7 +1239,8 @@ struct mvpp2_port {
 	phy_interface_t phy_interface;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
-	struct phylink_pcs phylink_pcs;
+	struct phylink_pcs pcs_gmac;
+	struct phylink_pcs pcs_xlg;
 	struct phy *comphy;
 
 	struct mvpp2_bm_pool *pool_long;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8e5820d12362..f5e10fe7812b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6118,15 +6118,20 @@ static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
 	return container_of(config, struct mvpp2_port, phylink_config);
 }
 
-static struct mvpp2_port *mvpp2_pcs_to_port(struct phylink_pcs *pcs)
+static struct mvpp2_port *mvpp2_pcs_xlg_to_port(struct phylink_pcs *pcs)
 {
-	return container_of(pcs, struct mvpp2_port, phylink_pcs);
+	return container_of(pcs, struct mvpp2_port, pcs_xlg);
+}
+
+static struct mvpp2_port *mvpp2_pcs_gmac_to_port(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mvpp2_port, pcs_gmac);
 }
 
 static void mvpp2_xlg_pcs_get_state(struct phylink_pcs *pcs,
 				    struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_xlg_to_port(pcs);
 	u32 val;
 
 	if (port->phy_interface == PHY_INTERFACE_MODE_5GBASER)
@@ -6164,7 +6169,7 @@ static const struct phylink_pcs_ops mvpp2_phylink_xlg_pcs_ops = {
 static void mvpp2_gmac_pcs_get_state(struct phylink_pcs *pcs,
 				     struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_gmac_to_port(pcs);
 	u32 val;
 
 	val = readl(port->base + MVPP2_GMAC_STATUS0);
@@ -6201,7 +6206,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 				 const unsigned long *advertising,
 				 bool permit_pause_to_mac)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_gmac_to_port(pcs);
 	u32 mask, val, an, old_an, changed;
 
 	mask = MVPP2_GMAC_IN_BAND_AUTONEG_BYPASS |
@@ -6255,7 +6260,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 
 static void mvpp2_gmac_pcs_an_restart(struct phylink_pcs *pcs)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_gmac_to_port(pcs);
 	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 
 	writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
@@ -6368,8 +6373,23 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		writel(ctrl4, port->base + MVPP22_GMAC_CTRL_4_REG);
 }
 
-static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
-			      phy_interface_t interface)
+static struct phylink_pcs *mvpp2_select_pcs(struct phylink_config *config,
+					    phy_interface_t interface)
+{
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
+
+	/* Select the appropriate PCS operations depending on the
+	 * configured interface mode. We will only switch to a mode
+	 * that the validate() checks have already passed.
+	 */
+	if (mvpp2_is_xlg(interface))
+		return &port->pcs_xlg;
+	else
+		return &port->pcs_gmac;
+}
+
+static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
+			     phy_interface_t interface)
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 
@@ -6418,31 +6438,9 @@ static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
 		}
 	}
 
-	/* Select the appropriate PCS operations depending on the
-	 * configured interface mode. We will only switch to a mode
-	 * that the validate() checks have already passed.
-	 */
-	if (mvpp2_is_xlg(interface))
-		port->phylink_pcs.ops = &mvpp2_phylink_xlg_pcs_ops;
-	else
-		port->phylink_pcs.ops = &mvpp2_phylink_gmac_pcs_ops;
-
 	return 0;
 }
 
-static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
-			     phy_interface_t interface)
-{
-	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
-	int ret;
-
-	ret = mvpp2__mac_prepare(config, mode, interface);
-	if (ret == 0)
-		phylink_set_pcs(port->phylink, &port->phylink_pcs);
-
-	return ret;
-}
-
 static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
@@ -6614,6 +6612,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
 
 static const struct phylink_mac_ops mvpp2_phylink_ops = {
 	.validate = mvpp2_phylink_validate,
+	.mac_select_pcs = mvpp2_select_pcs,
 	.mac_prepare = mvpp2_mac_prepare,
 	.mac_config = mvpp2_mac_config,
 	.mac_finish = mvpp2_mac_finish,
@@ -6631,12 +6630,15 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 	struct phylink_link_state state = {
 		.interface = port->phy_interface,
 	};
-	mvpp2__mac_prepare(&port->phylink_config, MLO_AN_INBAND,
-			   port->phy_interface);
+	struct phylink_pcs *pcs;
+
+	pcs = mvpp2_select_pcs(&port->phylink_config, port->phy_interface);
+
+	mvpp2_mac_prepare(&port->phylink_config, MLO_AN_INBAND,
+			  port->phy_interface);
 	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
-	port->phylink_pcs.ops->pcs_config(&port->phylink_pcs, MLO_AN_INBAND,
-					  port->phy_interface,
-					  state.advertising, false);
+	pcs->ops->pcs_config(pcs, MLO_AN_INBAND, port->phy_interface,
+			     state.advertising, false);
 	mvpp2_mac_finish(&port->phylink_config, MLO_AN_INBAND,
 			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
@@ -6944,6 +6946,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 				  port->phylink_config.supported_interfaces);
 		}
 
+		port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
+		port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
+
 		phylink = phylink_create(&port->phylink_config, port_fwnode,
 					 phy_mode, &mvpp2_phylink_ops);
 		if (IS_ERR(phylink)) {
-- 
2.30.2

