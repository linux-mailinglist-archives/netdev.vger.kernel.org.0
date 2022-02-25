Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518DE4C47B3
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 15:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbiBYOf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 09:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241804AbiBYOfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 09:35:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BF61AE644
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GxU3SilRbUuqXXXPpdnUSDg3/nSbTqJe86dPKzdNyi4=; b=oQID33RcALcFA+Rx8HjKk+TESn
        9ljPui3jtOnPWZX2N6+UmvPR8Om6dcYZyL1qxD3xKSBNUaCUYK+oMRgOxGls0uWKg85itSIA0YqNT
        LoDU96q8qps3y0beYHJMNzerd9/EFDY9jLxAPRuFOmsV2S+gtncw3m02WTZHaTcYs45aVmYqITHnV
        absITpCeskWJVJWm27pIs7m1P02bkb6ClvRSFM3BUbmBQvnWeAs8g0FK0pNUFOQs4vw+jcv218HEi
        +NsJT3DrPD29YyPgBjQmhi6jbsSrpa+jcu/Do6kL/L/zUAG1LQlyMNg/Ofa9MDqUrh++BAbFy8fLa
        UfducEqw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46980 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNbgj-0005Wi-7r; Fri, 25 Feb 2022 14:35:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNbgi-00Akie-In; Fri, 25 Feb 2022 14:35:16 +0000
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
Subject: [PATCH RFC net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNbgi-00Akie-In@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 14:35:16 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces bitmap for the Ocelot DSA switches.

The felix_vsc9959 and seville_vsc9953 sub-drivers only supports a
single interface mode, defined by ocelot_port->phy_mode, so we indicate
only this interface mode to phylink.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/felix.c           | 11 +++++++++++
 drivers/net/dsa/ocelot/felix.h           |  2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 10 ++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 10 ++++++++++
 4 files changed, 33 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9959407fede8..9e05b18940c1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -778,6 +778,16 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 	return ocelot_vlan_del(ocelot, port, vlan->vid);
 }
 
+static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
+				   struct phylink_config *config)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->phylink_get_caps)
+		felix->info->phylink_get_caps(ocelot, port, config);
+}
+
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
 				   unsigned long *supported,
 				   struct phylink_link_state *state)
@@ -1587,6 +1597,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_ethtool_stats		= felix_get_ethtool_stats,
 	.get_sset_count			= felix_get_sset_count,
 	.get_ts_info			= felix_get_ts_info,
+	.phylink_get_caps		= felix_phylink_get_caps,
 	.phylink_validate		= felix_phylink_validate,
 	.phylink_mac_config		= felix_phylink_mac_config,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9395ac119d33..b195e3f4df7f 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -41,6 +41,8 @@ struct felix_info {
 
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
+	void	(*phylink_get_caps)(struct ocelot *ocelot, int port,
+				    struct phylink_config *config);
 	void	(*phylink_validate)(struct ocelot *ocelot, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 33f0ceae381d..a1be0e91dde6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -940,6 +940,15 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	return 0;
 }
 
+static void vsc9959_phylink_get_caps(struct ocelot *ocelot, int port,
+				     struct phylink_config *config)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	__set_bit(ocelot_port->phy_mode,
+		  config->supported_interfaces);
+}
+
 static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
@@ -2237,6 +2246,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
+	.phylink_get_caps	= vsc9959_phylink_get_caps,
 	.phylink_validate	= vsc9959_phylink_validate,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index f2f1608a476c..2db51494b1a9 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -913,6 +913,15 @@ static int vsc9953_reset(struct ocelot *ocelot)
 	return 0;
 }
 
+static void vsc9953_phylink_get_caps(struct ocelot *ocelot, int port,
+				     struct phylink_config *config)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	__set_bit(ocelot_port->phy_mode,
+		  config->supported_interfaces);
+}
+
 static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
 				     unsigned long *supported,
 				     struct phylink_link_state *state)
@@ -1105,6 +1114,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.num_tx_queues		= OCELOT_NUM_TC,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
+	.phylink_get_caps	= vsc9953_phylink_get_caps,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
 	.init_regmap		= ocelot_regmap_init,
-- 
2.30.2

