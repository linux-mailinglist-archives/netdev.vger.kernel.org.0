Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D2160114
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 00:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgBOXSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 18:18:47 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39014 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOXSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 18:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7gv1YHXUzwWqx/cB7Iwp9BJNBUxQi/n0dWs09LeCp2Q=; b=pD4Gc0DciuZeWB/neTDxyVEC6
        gOu9zuEp8Qy/mOORqIzkweTpTDzIe0TXJPD2IQ2YckOPy2epEf5JjRE3Zr3Na50u7QWkEpv8nRIq3
        am3DGUQskCaTyhdJSaPRgz/9LMt+fRY3neci3t8sI4wJQmHpMU4bygLtK0kakn72Q/3PdjdjZ5MIp
        aZmddqucxb+M0fX+cT7xm6djJMIWM9TDrIZYIH++wUSygNVBLX0UHFsW9Cg9vrWzrvlgKAORaLWti
        9l74HphcgyrgpQOHcqXCeegQ4VEZk/qDBni+w0ghcUmPIBKH/86J/DUmpSXyHsEY7eFAxQeon8HFS
        ezicmFHpw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:48348)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j36hs-0007ju-CG; Sat, 15 Feb 2020 23:18:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j36hp-0004jH-0Z; Sat, 15 Feb 2020 23:18:37 +0000
Date:   Sat, 15 Feb 2020 23:18:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/10] net: add helpers to resolve negotiated
 flow control
Message-ID: <20200215231836.GS25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zh9-0003X2-9y@rmk-PC.armlinux.org.uk>
 <20200215184932.GS31084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200215184932.GS31084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 07:49:32PM +0100, Andrew Lunn wrote:
> On Sat, Feb 15, 2020 at 03:49:27PM +0000, Russell King wrote:
> > Add a couple of helpers to resolve negotiated flow control. Two helpers
> > are provided:
> > 
> > - linkmode_resolve_pause() which takes the link partner and local
> >   advertisements, and decodes whether we should enable TX or RX pause
> >   at the MAC. This is useful outside of phylib, e.g. in phylink.
> > - phy_get_pause(), which returns the TX/RX enablement status for the
> >   current negotiation results of the PHY.
> > 
> > This allows us to centralise the flow control resolution, rather than
> > spreading it around.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/Makefile     |  3 ++-
> >  drivers/net/phy/linkmode.c   | 44 ++++++++++++++++++++++++++++++++++++
> >  drivers/net/phy/phy_device.c | 26 +++++++++++++++++++++
> >  include/linux/linkmode.h     |  4 ++++
> >  include/linux/phy.h          |  3 +++
> >  5 files changed, 79 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/net/phy/linkmode.c
> > 
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index fe5badf13b65..d523fd5670e4 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -1,7 +1,8 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  # Makefile for Linux PHY drivers and MDIO bus drivers
> >  
> > -libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o
> > +libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
> > +				   linkmode.o
> >  mdio-bus-y			+= mdio_bus.o mdio_device.o
> >  
> >  ifdef CONFIG_MDIO_DEVICE
> > diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
> > new file mode 100644
> > index 000000000000..969918795228
> > --- /dev/null
> > +++ b/drivers/net/phy/linkmode.c
> > @@ -0,0 +1,44 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +#include <linux/linkmode.h>
> > +
> > +/**
> > + * linkmode_resolve_pause - resolve the allowable pause modes
> > + * @local_adv: local advertisement in ethtool format
> > + * @partner_adv: partner advertisement in ethtool format
> > + * @tx_pause: pointer to bool to indicate whether transmit pause should be
> > + * enabled.
> > + * @rx_pause: pointer to bool to indicate whether receive pause should be
> > + * enabled.
> > + *
> > + * Flow control is resolved according to our and the link partners
> > + * advertisements using the following drawn from the 802.3 specs:
> > + *  Local device  Link partner
> > + *  Pause AsymDir Pause AsymDir Result
> > + *    0     X       0     X     Disabled
> > + *    0     1       1     0     Disabled
> > + *    0     1       1     1     TX
> > + *    1     0       0     X     Disabled
> > + *    1     X       1     X     TX+RX
> > + *    1     1       0     1     RX
> > + */
> > +void linkmode_resolve_pause(const unsigned long *local_adv,
> > +			    const unsigned long *partner_adv,
> > +			    bool *tx_pause, bool *rx_pause)
> > +{
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(m);
> > +
> > +	linkmode_and(m, local_adv, partner_adv);
> > +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, m)) {
> > +		*tx_pause = true;
> > +		*rx_pause = true;
> > +	} else if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, m)) {
> > +		*tx_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> > +					      partner_adv);
> > +		*rx_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> > +					      local_adv);
> > +	} else {
> > +		*tx_pause = false;
> > +		*rx_pause = false;
> > +	}
> 
> Hi Russell
> 
> It took me a while to check this. Maybe it is the way my brain works,
> but to me, it is not obviously correct. I had to expand the table, and
> they try all 16 combinations.

The table is actually as given in 802.3, which is not expanded.

> Maybe a lookup table would be more obvious?

I feel that making a table of all 16 combinations is less obviously
correct.

I tend to work from the table as given, in this order:

 Local device  Link partner
 Pause AsymDir Pause AsymDir Result
   1     X       1     X     TX+RX

If both pause bits are set, we don't care what the asym direction bits
say.  Transmit and receive pause are enabled.

   0     1       1     1     TX

If both asym direction bits are set, and the link partner pause bit is
set, then we want transmit pause but not receive pause.

   1     1       0     1     RX

If both asym direction bits are set, and our pause bit is set, then
we want receive pause but not transmit pause.

These are the only three combinations that result in any pause settings
being enabled; all other combinations must result in both disabled.

So, working from that, the first test is fairly obvious - we want to
know if both pause bits are set: adv.pause & lpa.pause.  If that
evaluates true, we set both.

The second and third have a common precondition, which is:
adv.asymdir & lpa.asymdir.  If that is true, then to separate out
whether we enable transmit or receive pause becomes dependent on which
pause bit was set: lpa.pause tells us to enable transmit pause,
adv.pause tells us to enable receive pause.  We can't get here if both
pause bits were set due to the first.

If neither pause bits are set, then neither pause gets enabled even
if both asymdir bits are set.

Otherwise, we simply force both transmit and receive pause off.

This kind of thought process seems quite logical to me, but then I've
had several years of logic design and analysis when I was young - so
sorry if it's not obvious to others!

> However, now i spent the time:
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
