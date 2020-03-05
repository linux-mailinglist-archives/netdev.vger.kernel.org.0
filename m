Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E1217A696
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgCENno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:43:44 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40750 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgCENno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 08:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eKMyrUy78s/GoGtnJK+7CfgOS5rUvrmVtoKsi0GoYFw=; b=ycvjzb2SZ/RU4aBKwhhUwBE+a
        ik5eVGNR+RqyrbLBH0uKFZRCSnXXgnL8nlHpo4GwNqoWlZ0OrVaLU2kBwfdzSmQUgHtUbGTXwBaa8
        ma4XfCCj54KoEcZ3GJxz+SYvlZeBa1XdEB8Wt1r4Ri4ty5F8OXWgTLTjMgy7apwYLkPAhh1mKxM+Y
        abuY4FDNygUw6WY9nxNbQNZVd/m5Ux5hZlIsn2oGZQfup+YLyE17L/HLNlBwIybblk23x/WpRScpa
        S4hzdQr9uOfshh4gJryf87vLsimpAupzR+GUgh9TjJP8kP2cdP99hE/+csPJMclk4WwgYPLGgQY5R
        d3bYPiy1g==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:56516)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j9qmm-0006jP-7n; Thu, 05 Mar 2020 13:43:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j9qmj-0007xp-Qj; Thu, 05 Mar 2020 13:43:33 +0000
Date:   Thu, 5 Mar 2020 13:43:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 06/10] net: dsa: mv88e6xxx: extend phylink to
 Serdes PHYs
Message-ID: <20200305134333.GC25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <E1j9ppf-00072N-L9@rmk-PC.armlinux.org.uk>
 <20200305143847.6507e32b@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200305143847.6507e32b@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 02:38:47PM +0100, Marek Behun wrote:
> On Thu, 05 Mar 2020 12:42:31 +0000
> Russell King <rmk+kernel@armlinux.org.uk> wrote:
> 
> > +int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
> > +				 u8 lane, int speed, int duplex)
> > +{
> > +	u16 val, bmcr;
> > +	int err;
> > +
> > +	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> > +				    MV88E6390_SGMII_BMCR, &val);
> > +	if (err)
> > +		return err;
> > +
> > +	bmcr = val & ~(BMCR_SPEED100 | BMCR_FULLDPLX | BMCR_SPEED1000);
> > +	switch (speed) {
> > +	case SPEED_2500:
> > +	case SPEED_1000:
> > +		bmcr |= BMCR_SPEED1000;
> >  		break;
> > -	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> > -		mode = PHY_INTERFACE_MODE_1000BASEX;
> > +	case SPEED_100:
> > +		bmcr |= BMCR_SPEED100;
> >  		break;
> > -	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> > -		mode = PHY_INTERFACE_MODE_2500BASEX;
> > +	case SPEED_10:
> >  		break;
> > -	default:
> > -		mode = PHY_INTERFACE_MODE_NA;
> >  	}
> >  
> > -	err = mv88e6xxx_port_setup_mac(chip, port, link, speed, duplex,
> > -				       PAUSE_OFF, mode);
> > -	if (err)
> > -		dev_err(chip->dev, "can't propagate PHY settings to MAC: %d\n",
> > -			err);
> > -	else
> > -		dsa_port_phylink_mac_change(ds, port, link == LINK_FORCED_UP);
> > +	if (duplex == DUPLEX_FULL)
> > +		bmcr |= BMCR_FULLDPLX;
> > +
> > +	if (bmcr == val)
> > +		return 0;
> > +
> > +	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> > +				      MV88E6390_SGMII_BMCR, bmcr);
> > +}
> 
> Hi,
> 
> some time ago I wondered if it would make sense to separate the
> SERDES PHY code into a separate phy driver to reside in
> drivers/net/phy/marvell-serdes.c or something like that. Are there
> compatible PHYs which aren't integrated into a switch?

We already have a problem with the copper PHYs in Marvell switches
being handled in this manner - on the 6141, we try to drive them as
our "6390" PHY, but they aren't compatible.  This results in hwmon
being registered, which permanently reports a temperature of -75°C.

I suspect we'll run into the same thing with the serdes.

Then there's the issue that the way we handle serdes PCS is not the
same as a copper PHY.

Lastly, there's the issue with SGMII PCS that there may also be a
copper PHY, and phylib / network devices have no support for stacking
one PHY on top of another.

All this could be solved, but I suspect it will require considerable
effort and restructuring of phylib, phylink and several other bits of
the kernel networking layer.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
