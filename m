Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96294C47B8
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 15:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbiBYOgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 09:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241820AbiBYOgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 09:36:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D44F1AE659
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vIm+p/U/Eo0VBUL4gUrQjS73PEd/W6bB8Hf9HJZbIwU=; b=fNIj+OaVOez/2Yp14WXEqhW5Zs
        4st4789mrj26RQzmo6QJLkq8sDr749pZpKov8GwmVglkks/C8lkuMGf1ENx/1Bi3abSWsQdXdut/P
        pSIIFKEefVN7A41V6UKNTCwC1BP0pCoz/juToX30vL453lCOypyQCfQ+PZfx69UY4EsiftqKwjy0W
        Dh2k65Zp3ivQpAZy6M1bIzJyifjEIszHg8gc9wmQ6i41LBw7WOWyNWnZ3rd88O4/1eiSbx4+NFIGG
        hyEfxa7NGBhY45iQNiHTA7UVoBrYs/Cr3C4qxUsRn2pYZMVjJEZwzl7p/TQBj9n1o2/CRvIZLkcI8
        Po9jEtOg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46984 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNbgt-0005X9-C4; Fri, 25 Feb 2022 14:35:27 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNbgs-00Akiq-PW; Fri, 25 Feb 2022 14:35:26 +0000
In-Reply-To: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 3/4] net: dsa: ocelot: convert to
 mac_select_pcs()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNbgs-00Akiq-PW@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 14:35:26 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the PCS selection to use mac_select_pcs, which allows the PCS
to perform any validation it needs, and removes the need to set the PCS
in the mac_config() callback, delving into the higher DSA levels to do
so.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/felix.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9e05b18940c1..20ac74ee322d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -799,16 +799,18 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 		felix->info->phylink_validate(ocelot, port, supported, state);
 }
 
-static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
-				     unsigned int link_an_mode,
-				     const struct phylink_link_state *state)
+static struct phylink_pcs *felix_phylink_mac_select_pcs(struct dsa_switch *ds,
+							int port,
+							phy_interface_t iface)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct phylink_pcs *pcs = NULL;
 
 	if (felix->pcs && felix->pcs[port])
-		phylink_set_pcs(dp->pl, felix->pcs[port]);
+		pcs = felix->pcs[port];
+
+	return pcs;
 }
 
 static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
@@ -1599,7 +1601,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_ts_info			= felix_get_ts_info,
 	.phylink_get_caps		= felix_phylink_get_caps,
 	.phylink_validate		= felix_phylink_validate,
-	.phylink_mac_config		= felix_phylink_mac_config,
+	.phylink_mac_select_pcs		= felix_phylink_mac_select_pcs,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
 	.port_fast_age			= felix_port_fast_age,
-- 
2.30.2

