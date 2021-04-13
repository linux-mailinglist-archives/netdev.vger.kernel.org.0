Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2621935DFBF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243409AbhDMNHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:07:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237114AbhDMNHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:07:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWIl2-00GTdC-Mi; Tue, 13 Apr 2021 15:07:08 +0200
Date:   Tue, 13 Apr 2021 15:07:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        system@metrotek.ru, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <YHWXfFEnOZvpqxWM@lunn.ch>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
 <20210413013122.7fa0195f@thinkpad>
 <20210413071349.r374hxctgboj7l5a@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210413071349.r374hxctgboj7l5a@dhcp-179.ddg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 10:13:49AM +0300, Ivan Bornyakov wrote:
> On Tue, Apr 13, 2021 at 01:32:12AM +0200, Marek Behún wrote:
> > On Mon, 12 Apr 2021 15:16:59 +0300
> > Ivan Bornyakov <i.bornyakov@metrotek.ru> wrote:
> > 
> > > Some SFP modules uses RX_LOS for link indication. In such cases link
> > > will be always up, even without cable connected. RX_LOS changes will
> > > trigger link_up()/link_down() upstream operations. Thus, check that SFP
> > > link is operational before actual read link status.
> > > 
> > > Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> > > ---
> > >  drivers/net/phy/marvell-88x2222.c | 26 ++++++++++++++++++++++++++
> > >  1 file changed, 26 insertions(+)
> > > 
> > > diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
> > > index eca8c2f20684..fb285ac741b2 100644
> > > --- a/drivers/net/phy/marvell-88x2222.c
> > > +++ b/drivers/net/phy/marvell-88x2222.c
> > > @@ -51,6 +51,7 @@
> > >  struct mv2222_data {
> > >  	phy_interface_t line_interface;
> > >  	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
> > > +	bool sfp_link;
> > >  };
> > >  
> > >  /* SFI PMA transmit enable */
> > > @@ -148,6 +149,9 @@ static int mv2222_read_status(struct phy_device *phydev)
> > >  	phydev->speed = SPEED_UNKNOWN;
> > >  	phydev->duplex = DUPLEX_UNKNOWN;
> > >  
> > > +	if (!priv->sfp_link)
> > > +		return 0;
> > > +
> > 
> > So if SFP is not used at all, if this PHY is used in a different
> > usecase, this function will always return 0? Is this correct?
> > 
> 
> Yes, probably. The thing is that I only have hardware with SFP cages, so
> I realy don't know if this driver work in other usecases.

It is O.K, to say you don't know if this will work for other setups,
but it is different thing to do something which could potentially
break those other setup. Somebody trying to use this without an SFP is
going to have a bad experience because of this change. And then they
are going to have to try to fix this, potentially breaking your setup.

if you truly need this, make it conditional on that you know you have
an SFP cage connected.

> > > +static void mv2222_sfp_link_down(void *upstream)
> > > +{
> > > +	struct phy_device *phydev = upstream;
> > > +	struct mv2222_data *priv;
> > > +
> > > +	priv = (struct mv2222_data *)phydev->priv;
> > 
> > This cast is redundant since the phydev->priv is (void*). You can cast
> > (void*) to (struct ... *).
> > 
> > You can also just use
> > 	struct mv2222_data *priv = phydev->priv;
> >
> 
> Yeah, I know, but reverse XMAS tree wouldn't line up.

Please move the assignment into the body of the function.

       Andrew
