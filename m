Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01E531BC1B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhBOPST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:18:19 -0500
Received: from lists.nic.cz ([217.31.204.67]:57546 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhBOPRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 10:17:11 -0500
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id A7F5D140A60;
        Mon, 15 Feb 2021 16:16:28 +0100 (CET)
Date:   Mon, 15 Feb 2021 16:16:27 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Nathan Rossi <nathan@nathanrossi.com>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: prevent 2500BASEX mode override
Message-ID: <20210215161627.63c3091c@nic.cz>
In-Reply-To: <20210215145757.GX1463@shell.armlinux.org.uk>
References: <20210215061559.1187396-1-nathan@nathanrossi.com>
        <20210215144756.76846c9b@nic.cz>
        <20210215145757.GX1463@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Feb 2021 14:57:57 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Mon, Feb 15, 2021 at 02:47:56PM +0100, Marek Behun wrote:
> > On Mon, 15 Feb 2021 06:15:59 +0000
> > Nathan Rossi <nathan@nathanrossi.com> wrote:
> >   
> > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > > index 54aa942eed..5c52906b29 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > > @@ -650,6 +650,13 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
> > >  	if (chip->info->ops->phylink_validate)
> > >  		chip->info->ops->phylink_validate(chip, port, mask, state);
> > >  
> > > +	/* Advertise 2500BASEX only if 1000BASEX is not configured, this
> > > +	 * prevents phylink_helper_basex_speed from always overriding the
> > > +	 * 1000BASEX mode since auto negotiation is always enabled.
> > > +	 */
> > > +	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
> > > +		phylink_clear(mask, 2500baseX_Full);
> > > +  
> > 
> > I don't quite like this. This problem should be either solved in
> > phylink_helper_basex_speed() or somewhere in the mv88e6xxx code, but near
> > the call to phylink_helper_basex_speed().
> > 
> > Putting a solution to the behaviour of phylink_helper_basex_speed() it
> > into the validate() method when phylink_helper_basex_speed() is called
> > from a different place will complicate debugging in the future. If
> > we start solving problems in this kind of way, the driver will become
> > totally unreadable, IMO.  
> 
> If we can't switch between 1000base-X and 2500base-X, then we should
> not be calling phylink_helper_basex_speed() - and only one of those
> two capabilities should be set in the validation callback. I thought
> there were DSA switches where we could program the CMODE to switch
> between these two...

There are. At least Peridot, Topaz and Amethyst support switching
between these modes. But only on some ports.

This problem happnes on Peridot X, I think.

On Peridot X there are
- port 0: RGMII
- ports 9-10: capable of 1, 2.5 and 10G SerDes (10G via
  XAUI/RXAUI, so multiple lanes)
- ports 1-8: with copper PHYs
  - some of these can instead be set to use the unused SerDes lanes
    of ports 9-10, but only in 1000base-x mode

So the problem can happen if you set port 9 or 10 to only use one
SerDes lane, and use the spare lanes for the 1G ports.
On these ports 2500base-x is not supported, only 1000base-x (maybe
sgmii, I don't remember)

Marek
