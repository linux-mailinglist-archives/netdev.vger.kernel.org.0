Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3265E31DA5D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 14:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhBQN0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 08:26:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45756 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhBQN0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 08:26:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lCMpw-006tfi-Fw; Wed, 17 Feb 2021 14:25:48 +0100
Date:   Wed, 17 Feb 2021 14:25:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
Message-ID: <YC0ZXFx98JrtEGA3@lunn.ch>
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
 <YCvDVEvBU5wabIx7@lunn.ch>
 <55c94cf4-f660-f0f5-fb04-f51f4d175f53@gmail.com>
 <CA+aJhH3SE1s8P+srhO_-Za3E0KdHVn2_bK=Kf+-Jtbm1vJNm1w@mail.gmail.com>
 <YCyLWhk5zV4Z5Crv@lunn.ch>
 <CA+aJhH1VeCkk4JB02XVbvgJaM-Ua5i80qaNR7EVUoF-eBx_y5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+aJhH1VeCkk4JB02XVbvgJaM-Ua5i80qaNR7EVUoF-eBx_y5Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 02:48:30PM +1000, Nathan Rossi wrote:
> On Wed, 17 Feb 2021 at 13:19, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > > The patch does make sense though, Broadcom 53125 switches have a broken
> > > > turn around and are mdio_device instances, the broken behavior may not
> > > > show up with all MDIO controllers used to interface though. For the
> > >
> > > Yes the reason we needed this change was to enable broken turn around,
> > > specifically with a Marvell 88E6390.
> >
> > Ah, odd. I've never had problems with the 6390, either connected to a
> > Freecale FEC, or the Linux bit banging MDIO bus.
> >
> > What are you using for an MDIO bus controller? Did it already support
> > broken turn around, or did you need to add it?
> 
> Using bit bang MDIO to access the 88e6390. I suspect the issue is
> specific to the board design, another similar design we have uses bit
> bang MDIO but a 88e6193x switch and does not have any issue with turn
> around.

So to me, it sounds like changing the data pin, by the host, from
being driven to high impedance, is taking too long. So this is a bus
problem, not a per device on the bus problem. You need to indicate to
the bus controller that all addresses on the bus have broken turn
around, not just one. If you look at mdio-bitbang.c  it has:

        /* check the turnaround bit: the PHY should be driving it to zero, if this
         * PHY is listed in phy_ignore_ta_mask as having broken TA, skip that
         */
        if (mdiobb_get_bit(ctrl) != 0 &&
            !(bus->phy_ignore_ta_mask & (1 << phy))) {
                /* PHY didn't drive TA low -- flush any bits it
                 * may be trying to send.
                 */
                for (i = 0; i < 32; i++)
                        mdiobb_get_bit(ctrl);

                return 0xffff;
        }

So the property it specific to one address. And the mv88e6xxx normally
takes up multiple addresses on the bus.

So i would do this differently. Add a new property to "mdio-gpio" to
indicate the host has broken turn around, and it needs to set all 32
bits of bus->phy_ignore_ta_mask.

     Andrew
