Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9BD57BDD5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiGTSct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGTScs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:32:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F2A70E5E;
        Wed, 20 Jul 2022 11:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1EimVean7S5A9vQLgzCpehPt6sY6+7H9wxmyyOq1Eyo=; b=Liihj85/neXg/k23jilkOCMfME
        BS1/uu1EqaSVDFCwKFJ4+rTIkyM5uttUdDHp5kcQ5c1jbOsZcsDithWa9nXFkZRHpFl1QuYF2xANc
        +FfjXaF2B4iEPTdFa5WPmRCBaTjKUW1xdDIA81To7PP00/UOz+zmdK4cVoCal486oyIbb5rDJ2uSv
        536CgPTWXaYIfOZgSdLpkawQXhdynx92p1EOdSYV76fiW9jUIL1nOVpOHsC1I8TvIi4GQdERN3+AM
        1h2SIMs56YpZ7r0cH84v6F6Y6YYGu9zRow109xZkR/KOd6EPFmJkduUE5yoKFh2CYmWwrUwVSRwAN
        H40tNMHQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33470)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEEV1-0004P9-Qr; Wed, 20 Jul 2022 19:32:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEEUz-00046R-9h; Wed, 20 Jul 2022 19:32:41 +0100
Date:   Wed, 20 Jul 2022 19:32:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 07/11] net: phylink: Adjust link settings based on
 rate adaptation
Message-ID: <YthKSYje5e+swg08@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-8-sean.anderson@seco.com>
 <YtelzB1uO0zACa42@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtelzB1uO0zACa42@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 07:50:52AM +0100, Russell King (Oracle) wrote:
> We can do that by storing the PHY rate adaption state, and processing
> that in phylink_link_up().

Something like this? I haven't included the IPG (open loop) stuff in
this - I think when we come to implement that, we need a new mac
method to call to set the IPG just before calling mac_link_up().
Something like:

 void mac_set_ipg(struct phylink_config *config, int packet_speed,
		  int interface_speed);

Note that we also have PCS that do rate adaption too, and I think
fitting those in with the code below may be easier than storing the
media and phy interface speed/duplex separately.

A few further question though - does rate adaption make sense with
interface modes that can already natively handle the different speeds,
such as SGMII, RGMII, USXGMII, etc?

 drivers/net/phy/phylink.c | 103 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |   1 +
 2 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..c89eb74458cd 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -994,23 +994,105 @@ static const char *phylink_pause_to_str(int pause)
 	}
 }
 
+static int phylink_interface_max_speed(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_MII:
+		return SPEED_100;
+
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_1000BASEKX:
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_GMII:
+		return SPEED_1000;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return SPEED_2500;
+
+	case PHY_INTERFACE_MODE_5GBASER:
+		return SPEED_5000;
+
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_USXGMII:
+		return SPEED_10000;
+
+	case PHY_INTERFACE_MODE_25GBASER:
+		return SPEED_25000;
+
+	case PHY_INTERFACE_MODE_XLGMII:
+		return SPEED_40000;
+
+	case PHY_INTERFACE_MODE_INTERNAL:
+		/* Rate adaption is probably not supported */
+		return 0;
+
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_MAX:
+		return SPEED_UNKNOWN;
+	}
+}
+
 static void phylink_link_up(struct phylink *pl,
 			    struct phylink_link_state link_state)
 {
 	struct net_device *ndev = pl->netdev;
+	int speed, duplex;
+	bool rx_pause;
+
+	speed = link_state.speed;
+	duplex = link_state.duplex;
+	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
+
+	switch (state->rate_adaption) {
+	case RATE_ADAPT_PAUSE:
+		/* The PHY is doing rate adaption from the media rate (in
+		 * the link_state) to the interface speed, and will send
+		 * pause frames to the MAC to limit its transmission speed.
+		 */
+		speed = phylink_interface_max_speed(link_state.interface);
+		duplex = DUPLEX_FULL;
+		rx_pause = true;
+		break;
+
+	case RATE_ADAPT_CRS:
+		/* The PHY is doing rate adaption from the media rate (in
+		 * the link_state) to the interface speed, and will cause
+		 * collisions to the MAC to limit its transmission speed.
+		 */
+		speed = phylink_interface_max_speed(link_state.interface);
+		duplex = DUPLEX_HALF;
+		break;
+	}
 
 	pl->cur_interface = link_state.interface;
 
 	if (pl->pcs && pl->pcs->ops->pcs_link_up)
 		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
-					 pl->cur_interface,
-					 link_state.speed, link_state.duplex);
+					 pl->cur_interface, speed, duplex);
 
 	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
 				 pl->cur_link_an_mode, pl->cur_interface,
-				 link_state.speed, link_state.duplex,
+				 speed, duplex,
 				 !!(link_state.pause & MLO_PAUSE_TX),
-				 !!(link_state.pause & MLO_PAUSE_RX));
+				 rx_pause);
 
 	if (ndev)
 		netif_carrier_on(ndev);
@@ -1102,6 +1184,17 @@ static void phylink_resolve(struct work_struct *w)
 				}
 				link_state.interface = pl->phy_state.interface;
 
+				/* If we are doing rate adaption, then the
+				 * media speed/duplex has to come from the PHY.
+				 */
+				if (pl->phy_state.rate_adaption) {
+					link_state.rate_adaption =
+						pl->phy_state.rate_adaption;
+					link_state.speed = pl->phy_state.speed;
+					link_state.duplex =
+						pl->phy_state.duplex;
+				}
+
 				/* If we have a PHY, we need to update with
 				 * the PHY flow control bits.
 				 */
@@ -1337,6 +1430,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
+	pl->phy_state.rate_adaption = phydev->rate_adaption;
 	if (tx_pause)
 		pl->phy_state.pause |= MLO_PAUSE_TX;
 	if (rx_pause)
@@ -1414,6 +1508,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.rate_adaption = RATE_ADAPT_NONE;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..65301e7961b0 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -70,6 +70,7 @@ struct phylink_link_state {
 	int speed;
 	int duplex;
 	int pause;
+	int rate_adaption;
 	unsigned int link:1;
 	unsigned int an_enabled:1;
 	unsigned int an_complete:1;

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
