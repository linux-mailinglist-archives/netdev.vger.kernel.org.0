Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935D91A5287
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgDKOs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 10:48:58 -0400
Received: from mail.pqgruber.com ([52.59.78.55]:46696 "EHLO mail.pqgruber.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgDKOs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 10:48:58 -0400
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 20170C72B3E;
        Sat, 11 Apr 2020 16:48:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1586616536;
        bh=F+HPVoPolAJ0ZWlW/cSWJ0vPz1dnndHcF9dbcmd4TBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TcNStRDa1gXVevkRBC5ZIkKfQhSn96p+wjeYfG33gC8uqs3PY6O8y2NEfJZjmX5nF
         d4OneaPIe6XEBAHGflklEmiYyAiIN1nj4QSWBiYnaHTAfGIdRowov+xm6cFwGn+aEg
         OPnkD4+yIDldQFxFiKQyL5/67qUuhkWcMxu5BMSI=
Date:   Sat, 11 Apr 2020 16:48:54 +0200
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200411144854.GA645563@workstation.tuxnet>
References: <20200408214326.934440-1-clemens.gruber@pqgruber.com>
 <20200410174304.22f812fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200411091705.GG25745@shell.armlinux.org.uk>
 <20200411132401.GA273086@workstation.tuxnet>
 <20200411134344.GI25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200411134344.GI25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 02:43:44PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Apr 11, 2020 at 03:24:01PM +0200, Clemens Gruber wrote:
> > On Sat, Apr 11, 2020 at 10:17:05AM +0100, Russell King - ARM Linux admin wrote:
> > > On Fri, Apr 10, 2020 at 05:43:04PM -0700, Jakub Kicinski wrote:
> > > > On Wed,  8 Apr 2020 23:43:26 +0200 Clemens Gruber wrote:
> > > > > The negotiation of flow control / pause frame modes was broken since
> > > > > commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
> > > > > genphy_read_lpa()") moved the setting of phydev->duplex below the
> > > > > phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
> > > > > function, phydev->pause was no longer set.
> > > > > 
> > > > > Fix it by moving the parsing of the status variable before the blocks
> > > > > dealing with the pause frames.
> > > > > 
> > > > > Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
> > > > > Cc: stable@vger.kernel.org # v5.6+
> > > > 
> > > > nit: please don't CC stable on networking patches
> > > > 
> > > > > Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> > > > > ---
> > > > >  drivers/net/phy/marvell.c | 44 +++++++++++++++++++--------------------
> > > > >  1 file changed, 22 insertions(+), 22 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > > > > index 4714ca0e0d4b..02cde4c0668c 100644
> > > > > --- a/drivers/net/phy/marvell.c
> > > > > +++ b/drivers/net/phy/marvell.c
> > > > > @@ -1263,6 +1263,28 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
> > > > >  	int lpa;
> > > > >  	int err;
> > > > >  
> > > > > +	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
> > > > > +		return 0;
> > > > 
> > > > If we return early here won't we miss updating the advertising bits?
> > > > We will no longer call e.g. fiber_lpa_mod_linkmode_lpa_t().
> > > > 
> > > > Perhaps extracting info from status should be moved to a helper so we
> > > > can return early without affecting the rest of the flow?
> > > > 
> > > > Is my understanding correct?  Russell?
> > > 
> > > You are correct - and yes, there is also a problem here.
> > > 
> > > It is not clear whether the resolved bit is set before or after the
> > > link status reports that link is up - however, the resolved bit
> > > indicates whether the speed and duplex are valid.
> > 
> > I assumed that in the fiber case, the link status register won't be 1
> > until autonegotiation is complete. There is a part in the 88E1510
> > datasheet on page 57 [2.6.2], which says so but it's in the Fiber/Copper
> > Auto-Selection chapter and I am not sure if that's true in general. (?)
> 
> The fiber code is IMHO very suspect; the decoding of the pause status
> seems to be completely broken. However, I'm not sure whether anyone
> actually uses that or not, so I've been trying not to touch it.
> 
> > (For copper, we call genphy_update_link, which sets phydev->link to 0 if
> > autoneg is enabled && !completed. And according to the datasheet,
> > the resolved bit is set when autonegotiation is completed || disabled)
> 
> The resolved bit indicates whether the resolution data is valid, which
> will be set when autoneg is complete or autoneg is disabled.  However,
> the timing of the bit compared to the link status is not defined in the
> datasheet - and that's the problem.  If the link status bits report that
> the link is up but the resolved bit is indicating that the resolution
> is not valid, what do we do?  Report potential garbage but link up to
> the higher layers, or pretend that the link is down?

I see, thanks for the clarification. Pretending that the link is down
seems to be the right choice.

> 
> > TL/DR:
> > It's probably a good idea to force link to 0 to be sure, as you
> > suggested below. I will send a v2 with that change.
> > 
> > Moving the extraction of info to a helper is probably better left to a
> > separate patch?
> 
> I'm not sure what you're suggesting.

I was referring to Jakub's suggestion to create a new helper function
for the parsing of the status register.

Clemens
