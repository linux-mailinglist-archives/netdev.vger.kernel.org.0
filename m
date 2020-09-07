Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FD225FF35
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgIGO3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 10:29:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729883AbgIGO33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 10:29:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFI8t-00Dcm0-OV; Mon, 07 Sep 2020 16:29:11 +0200
Date:   Mon, 7 Sep 2020 16:29:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: dp83869: Add ability to advertise
 Fiber connection
Message-ID: <20200907142911.GT3112546@lunn.ch>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-2-dmurphy@ti.com>
 <20200905111755.4bd874b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905111755.4bd874b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 11:17:55AM -0700, Jakub Kicinski wrote:
> On Thu, 3 Sep 2020 06:42:57 -0500 Dan Murphy wrote:
> > Add the ability to advertise the Fiber connection if the strap or the
> > op-mode is configured for 100Base-FX.
> > 
> > Auto negotiation is not supported on this PHY when in fiber mode.
> > 
> > Signed-off-by: Dan Murphy <dmurphy@ti.com>
> 
> Some comments, I'm not very phy-knowledgeable so bear with me
> (hopefully PHY maintainers can correct me, too).
> 
> > diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> > index 58103152c601..48a68474f89c 100644
> > --- a/drivers/net/phy/dp83869.c
> > +++ b/drivers/net/phy/dp83869.c
> > @@ -52,6 +52,11 @@
> >  					 BMCR_FULLDPLX | \
> >  					 BMCR_SPEED1000)
> >  
> > +#define MII_DP83869_FIBER_ADVERTISE    (ADVERTISED_TP | ADVERTISED_MII | \
> > +					ADVERTISED_FIBRE | ADVERTISED_BNC |  \
> 
> I'm not actually sure myself what the semantics of port type advertise
> bits are, but if this is fiber why advertise TP and do you really have
> BNC connectors? :S

Hi Jakub

Normally, we start with a base of ETHTOOL_LINK_MODE_TP_BIT,
ETHTOOL_LINK_MODE_MII_BIT and then use genphy_read_abilities() to read
the standard registers in the PHY to determine what the PHY
supports. The PHY driver has the ability of provide its own function
to get the supported features, which is happening here. As far as i
remember, there is no standard way to indicate a PHY is doing Fibre,
not copper.

I agree that TP and BMC make no sense here, since my understanding is
that the device only supports Fibre when strapped for Fibre. It cannot
swap to TP, and it has been at least 20 years since i last had a BNC
cable in my hands.

In this context, i've no idea what MII means.

> > +					ADVERTISED_Pause | ADVERTISED_Asym_Pause | \
> > +					ADVERTISED_100baseT_Full)
> 
> You say 100Base-FX, yet you advertise 100Base-T?

100Base-FX does not actually exist in ADVERTISED_X form. I guess this
is historical. It was not widely supported, the broadcom PHYs appear
to support it, but not much else. We were also running out of bits to
represent these ADVERTISED_X values. Now that we have changed to linux
bitmaps and have unlimited number of bits, it makes sense to add it.

> > @@ -383,7 +389,37 @@ static int dp83869_configure_mode(struct phy_device *phydev,
> >  
> >  		break;
> >  	case DP83869_RGMII_1000_BASE:
> > +		break;
> >  	case DP83869_RGMII_100_BASE:
> > +		/* Only allow advertising what this PHY supports */
> > +		linkmode_and(phydev->advertising, phydev->advertising,
> > +			     phydev->supported);
> > +
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> > +				 phydev->supported);
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> > +				 phydev->advertising);
> > +
> > +		/* Auto neg is not supported in fiber mode */
> > +		bmcr = phy_read(phydev, MII_BMCR);
> > +		if (bmcr < 0)
> > +			return bmcr;
> > +
> > +		phydev->autoneg = AUTONEG_DISABLE;
> > +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> > +				   phydev->supported);
> > +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> > +				   phydev->advertising);
> > +
> > +		if (bmcr & BMCR_ANENABLE) {
> > +			ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
> > +			if (ret < 0)
> > +				return ret;
> > +		}
> > +
> > +		phy_modify_changed(phydev, MII_ADVERTISE,
> > +				   MII_DP83869_FIBER_ADVERTISE,
> > +				   MII_DP83869_FIBER_ADVERTISE);
> 
> This only accesses standard registers, should it perhaps be a helper in
> the kernel's phy code?

I suspect the PHY is not following the standard when strapped to
fibre.

	Andrew
