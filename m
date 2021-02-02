Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B130C3F0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhBBPfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:35:51 -0500
Received: from mail.pr-group.ru ([178.18.215.3]:55603 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235403AbhBBPdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:33:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=nERRfERf5SRmkBbNLWTYs48EzkGgIACng7GdK5JFdeo=;
        b=xS9+bfiRK+bocvxyLzlExQS5o+swL5UtzSEj1N6f65aHGLuguv2oiWUF3PWl7BIj3e6n+MbO4EiLa
         jsrfYWPPeMIr0NqYX0lE7yaffi08og3RsWr+l6U8bp1W57aRTzQ4mVPaIa+gmOHZSN7GssxdLNy9wc
         02QX6i5DYHeKWcJNOV43Y3dLZJss74w6TzH+YTaVYLShYhFW9zpPMI2PBfa7AkxqG/32vWWEFAkqIC
         ESVAqo2lbNvx57vPPx50/QQGGFfeosSdTJoKP5bMCQXD9rGHkAygEydHvS5yN/Vczjk+yp1QL9nC8q
         l9uCXkj1cWXHKX0dpayfYEYcuCP03tA==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW, TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 2 Feb 2021 18:32:13 +0300
Date:   Tue, 2 Feb 2021 18:32:03 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210202153203.qcls4fdjfwy65nd4@dhcp-179.ddg>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
 <YBiHAXSYWGO2weK6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBiHAXSYWGO2weK6@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 11:56:01PM +0100, Andrew Lunn wrote:
> > +static int mv2222_config_init(struct phy_device *phydev)
> > +{
> > +	linkmode_zero(phydev->supported);
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, phydev->supported);
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, phydev->supported);
> > +
> > +	phydev->pause = 0;
> > +	phydev->asym_pause = 0;
> > +	phydev->duplex = DUPLEX_FULL;
> > +	phydev->autoneg = AUTONEG_DISABLE;
> > +
> > +	return 0;
> > +}
> > +
> > +static void mv2222_update_interface(struct phy_device *phydev)
> > +{
> > +	if ((phydev->speed == SPEED_1000 ||
> > +	     phydev->speed == SPEED_100 ||
> > +	     phydev->speed == SPEED_10) &&
> > +	    phydev->interface != PHY_INTERFACE_MODE_1000BASEX) {
> > +		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;
> 
> The speeds 10 and 100 seem odd here. 1000BaseX only supports 1G. It
> would have to be SGMII in order to also support 10Mbps and 100Mbps.
> Plus you are not listing 10 and 100 as a supported value.
> 
> > +/* Returns negative on error, 0 if link is down, 1 if link is up */
> > +static int mv2222_read_status_1g(struct phy_device *phydev)
> > +{
> > +	int val, link = 0;
> > +
> > +	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
> > +	if (val < 0)
> > +		return val;
> > +
> > +	if (!(val & MDIO_STAT1_LSTATUS) ||
> > +	    (phydev->autoneg == AUTONEG_ENABLE && !(val & MDIO_AN_STAT1_COMPLETE)))
> > +		return 0;
> > +
> > +	link = 1;
> > +
> > +	if (phydev->autoneg == AUTONEG_DISABLE) {
> > +		phydev->speed = SPEED_1000;
> > +		phydev->duplex = DUPLEX_FULL;
> > +
> > +		return link;
> > +	}
> > +
> > +	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_PHY_STAT);
> > +	if (val < 0)
> > +		return val;
> > +
> > +	if (val & MV_1GBX_PHY_STAT_AN_RESOLVED) {
> > +		if (val & MV_1GBX_PHY_STAT_DUPLEX)
> > +			phydev->duplex = DUPLEX_FULL;
> > +		else
> > +			phydev->duplex = DUPLEX_HALF;
> > +
> > +		if (val & MV_1GBX_PHY_STAT_SPEED1000)
> > +			phydev->speed = SPEED_1000;
> > +		else if (val & MV_1GBX_PHY_STAT_SPEED100)
> > +			phydev->speed = SPEED_100;
> > +		else
> > +			phydev->speed = SPEED_10;
> 
> Are you sure it is not doing SGMII? Maybe it can do both, 1000BaseX
> and SGMII? You would generally use 1000BaseX to connect to a fibre
> SFP, and SGMII to connect to a copper SFP. So ideally you want to be
> able to swap between these modes as needed.
> 
> > +static int mv2222_read_status(struct phy_device *phydev)
> > +{
> > +	int link;
> > +
> > +	linkmode_zero(phydev->lp_advertising);
> > +	phydev->pause = 0;
> > +	phydev->asym_pause = 0;
> > +
> > +	switch (phydev->interface) {
> > +	case PHY_INTERFACE_MODE_10GBASER:
> > +		link = mv2222_read_status_10g(phydev);
> > +		break;
> > +	case PHY_INTERFACE_MODE_1000BASEX:
> > +	default:
> > +		link = mv2222_read_status_1g(phydev);
> > +		break;
> > +	}
> > +
> > +	if (link < 0)
> > +		return link;
> > +
> > +	phydev->link = link;
> > +
> > +	if (phydev->link)
> > +		mv2222_link_led_on(phydev);
> > +	else
> > +		mv2222_link_led_off(phydev);
> 
> You have to manually control the LED? That is odd for a PHY. Normally
> you just select a mode and it will do it all in hardware.
> 
>     Andrew

Thanks for the review, Andrew, your remarks are all valid. I'll
implement 1000Base-X/SGMII swapping. As for the LED, I'll just drop it
for now, as it is not essential. I'll commit LEDs config when core
funtionality will be accepted.

