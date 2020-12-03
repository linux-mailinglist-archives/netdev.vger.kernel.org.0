Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B7F2CCCBA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgLCCjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:39:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgLCCjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:39:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkeWO-009y3R-Qz; Thu, 03 Dec 2020 03:39:04 +0100
Date:   Thu, 3 Dec 2020 03:39:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Edwards <grant.b.edwards@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201203023904.GA2333853@lunn.ch>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
 <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch>
 <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch>
 <rq90ks$mjq$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rq90ks$mjq$1@ciao.gmane.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 09:23:40PM -0000, Grant Edwards wrote:
> On 2020-12-02, Andrew Lunn <andrew@lunn.ch> wrote:
> >> > So it will access the MDIO bus of the PHY that is attached to the
> >> > MAC.
> >> 
> >> If that's the case, wouldn't the ioctl() calls "just work" even when
> >> only the fixed-phy mdio bus and fake PHY are declared in the device
> >> tree?
> >
> > The fixed-link PHY is connected to the MAC. So the IOCTL calls will be
> > made to the fixed-link fake MDIO bus.
> 
> So how do you control which of the two mdio buses is connected to
> the MAC?

The bus is not connected to the MAC. The PHY is.

https://elixir.bootlin.com/linux/HEAD/source/drivers/net/ethernet/cadence/macb_main.c#L699

	if (dn)
		ret = phylink_of_phy_connect(bp->phylink, dn, 0);

	if (!dn || (ret && !macb_phy_handle_exists(dn))) {
		phydev = phy_find_first(bp->mii_bus);
		if (!phydev) {
			netdev_err(dev, "no PHY found\n");
			return -ENXIO;
		}

		/* attach the mac to the phy */
		ret = phylink_connect_phy(bp->phylink, phydev);
	}

The call to phylink_of_phy_connect() will go looking in device tree to
find the phy-handle. If it exists, it follows it to the PHY, and the
PHY is connected to the MAC. This code also handles fixed link. But in
this case, because it is using phylink, not phylib, the emulation is
different. The phylib fixed-link has the limitation of only emulating
C22 PHYs upto 1Gbps. 2.5G, 10G etc is becoming more popular, so
Russell King implemented fixed-link in phylink differently. phylib has
emulated MDIO registers which the generic PHY driver uses. phylink
however incorporates fixed-link into the core code, there is no
emulation. And IOCTL is a stub.

Back to the code. If there is no PHY via device tree, it searches its
own MDIO bus for the first PHY, and connects that to the MAC. This is
obviously not ideal when you have multiple devices on the bus, so
using a phy-handle is best practice. This code is here for backwards
compatibility. macb has some funky backwards compatibility code with
respect to its MDIO bus. So you might be hitting a corner case which
is not handled correct.

> > There are plenty of examples to follow.
> 
> That's true, but knowing which ones do what you're trying to do is the
> hard part. If you already know how to do it, it's easy to find
> examples showing it.  :)

Feel free to ask.

     Andrew
