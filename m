Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADCA4BDE5B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381473AbiBURLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:11:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiBURLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:11:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3406E25EB0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GKdNa4gDiOW4V2rNFQbOZydgez1KRHpC7Z+95dnWiGo=; b=g0taVoTigbv1ClEftLVr0OIPPw
        gDYt61QR6yzO79929JOn1TP2RCI71k2Qbs28DCRVmiD6WPhQep0QES0BDEtIyNHhRKli7ROL42Uh3
        S+zIrFP+Kerli+eLOmw212TRFQZj/v/+ETQCJVBHfTlEeZ+RaPgyVsKcgehm20jxhjVhnsU2uXdb+
        B0n6ZzWizBa0FT+0Td3o6je5FzbojUXaPTHuO9rthxtT/jdgH/O93muChgCKnfTywhnKd7wqq1xqg
        5JY+ra0A+q53gf6WC0awC3xarSR1D1uQonTLLanes6EX8NGUMTlTQCWpo4Y3EoNGp7tYxDPnT1Ofa
        vkYx+3fQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42084 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMCD7-0000gU-3b; Mon, 21 Feb 2022 17:10:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMCD6-00A0wC-FG; Mon, 21 Feb 2022 17:10:52 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: phylink: fix DSA mac_select_pcs()
 introduction
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMCD6-00A0wC-FG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 21 Feb 2022 17:10:52 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean reports that probing on DSA drivers that aren't yet
populating supported_interfaces now fails. Fix this by allowing
phylink to detect whether DSA actually provides an underlying
mac_select_pcs() implementation.

Reported-by: Vladimir Oltean <olteanv@gmail.com>
Fixes: bde018222c6b ("net: dsa: add support for phylink mac_select_pcs()")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 14 +++++++++++---
 net/dsa/port.c            |  2 +-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 26f1219a005f..28aa23533107 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -74,6 +74,7 @@ struct phylink {
 	struct work_struct resolve;
 
 	bool mac_link_dropped;
+	bool using_mac_select_pcs;
 
 	struct sfp_bus *sfp_bus;
 	bool sfp_may_have_phy;
@@ -416,7 +417,7 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
 	int ret;
 
 	/* Get the PCS for this interface mode */
-	if (pl->mac_ops->mac_select_pcs) {
+	if (pl->using_mac_select_pcs) {
 		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
 		if (IS_ERR(pcs))
 			return PTR_ERR(pcs);
@@ -791,7 +792,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 
 	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
 
-	if (pl->mac_ops->mac_select_pcs) {
+	if (pl->using_mac_select_pcs) {
 		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
 		if (IS_ERR(pcs)) {
 			phylink_err(pl,
@@ -1205,11 +1206,17 @@ struct phylink *phylink_create(struct phylink_config *config,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops)
 {
+	bool using_mac_select_pcs = false;
 	struct phylink *pl;
 	int ret;
 
-	/* Validate the supplied configuration */
 	if (mac_ops->mac_select_pcs &&
+	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) !=
+	      ERR_PTR(-EOPNOTSUPP))
+		using_mac_select_pcs = true;
+
+	/* Validate the supplied configuration */
+	if (using_mac_select_pcs &&
 	    phy_interface_empty(config->supported_interfaces)) {
 		dev_err(config->dev,
 			"phylink: error: empty supported_interfaces but mac_select_pcs() method present\n");
@@ -1233,6 +1240,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 		return ERR_PTR(-EINVAL);
 	}
 
+	pl->using_mac_select_pcs = using_mac_select_pcs;
 	pl->phy_state.interface = iface;
 	pl->link_interface = iface;
 	if (iface == PHY_INTERFACE_MODE_MOCA)
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 258782bf4271..367d141c6971 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1058,8 +1058,8 @@ dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
 				phy_interface_t interface)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct phylink_pcs *pcs = ERR_PTR(-EOPNOTSUPP);
 	struct dsa_switch *ds = dp->ds;
-	struct phylink_pcs *pcs = NULL;
 
 	if (ds->ops->phylink_mac_select_pcs)
 		pcs = ds->ops->phylink_mac_select_pcs(ds, dp->index, interface);
-- 
2.30.2

