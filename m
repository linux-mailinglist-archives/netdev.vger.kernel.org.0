Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87C21A525A
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 15:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgDKNYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 09:24:05 -0400
Received: from mail.pqgruber.com ([52.59.78.55]:46022 "EHLO mail.pqgruber.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgDKNYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 09:24:05 -0400
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 09AA9C72B3D;
        Sat, 11 Apr 2020 15:24:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1586611443;
        bh=MMPL4+F5BzwKMey5heeA56srlGR2uGjtldtJ89lxXiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EQEeEk/3dpvmSYslZSqX7AVfvWYfPGE1eTvWkMTUOKlf05msQnIt9U529fIxit+/w
         d5khcAO80Tj1WZLrmltjKZ7iUOsgQujF0Y/DBmBp0B0r4k6CFMp3Mr1vva+kNUIS1/
         Cf6tByUVY2szyn1gZE1Rt29IeVKt/BnhcOMu7e5c=
Date:   Sat, 11 Apr 2020 15:24:01 +0200
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200411132401.GA273086@workstation.tuxnet>
References: <20200408214326.934440-1-clemens.gruber@pqgruber.com>
 <20200410174304.22f812fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200411091705.GG25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200411091705.GG25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 10:17:05AM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Apr 10, 2020 at 05:43:04PM -0700, Jakub Kicinski wrote:
> > On Wed,  8 Apr 2020 23:43:26 +0200 Clemens Gruber wrote:
> > > The negotiation of flow control / pause frame modes was broken since
> > > commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
> > > genphy_read_lpa()") moved the setting of phydev->duplex below the
> > > phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
> > > function, phydev->pause was no longer set.
> > > 
> > > Fix it by moving the parsing of the status variable before the blocks
> > > dealing with the pause frames.
> > > 
> > > Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
> > > Cc: stable@vger.kernel.org # v5.6+
> > 
> > nit: please don't CC stable on networking patches
> > 
> > > Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> > > ---
> > >  drivers/net/phy/marvell.c | 44 +++++++++++++++++++--------------------
> > >  1 file changed, 22 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > > index 4714ca0e0d4b..02cde4c0668c 100644
> > > --- a/drivers/net/phy/marvell.c
> > > +++ b/drivers/net/phy/marvell.c
> > > @@ -1263,6 +1263,28 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
> > >  	int lpa;
> > >  	int err;
> > >  
> > > +	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
> > > +		return 0;
> > 
> > If we return early here won't we miss updating the advertising bits?
> > We will no longer call e.g. fiber_lpa_mod_linkmode_lpa_t().
> > 
> > Perhaps extracting info from status should be moved to a helper so we
> > can return early without affecting the rest of the flow?
> > 
> > Is my understanding correct?  Russell?
> 
> You are correct - and yes, there is also a problem here.
> 
> It is not clear whether the resolved bit is set before or after the
> link status reports that link is up - however, the resolved bit
> indicates whether the speed and duplex are valid.

I assumed that in the fiber case, the link status register won't be 1
until autonegotiation is complete. There is a part in the 88E1510
datasheet on page 57 [2.6.2], which says so but it's in the Fiber/Copper
Auto-Selection chapter and I am not sure if that's true in general. (?)
(For copper, we call genphy_update_link, which sets phydev->link to 0 if
autoneg is enabled && !completed. And according to the datasheet,
the resolved bit is set when autonegotiation is completed || disabled)

TL/DR:
It's probably a good idea to force link to 0 to be sure, as you
suggested below. I will send a v2 with that change.

Moving the extraction of info to a helper is probably better left to a
separate patch?

> What I've done elsewhere is if the resolved bit is not set, then we
> force phydev->link to be false, so we don't attempt to process a
> link-up status until we can read the link parameters.  I think that's
> what needs to happen here, i.o.w.:
> 
> 	if (!(status & MII_M1011_PHY_STATUS_RESOLVED)) {
> 		phydev->link = 0;
> 		return 0;
> 	}
> 
> especially as we're not reading the LPA.

Thanks,
Clemens
