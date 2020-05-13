Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375951D1C74
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389947AbgEMRkU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 13 May 2020 13:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733008AbgEMRkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:40:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDFFC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 10:40:20 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYvMc-0007rx-D4; Wed, 13 May 2020 19:40:14 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jYvMZ-0006Jw-Mq; Wed, 13 May 2020 19:40:11 +0200
Date:   Wed, 13 May 2020 19:40:11 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
Message-ID: <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200513133925.GD499265@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:26:43 up 180 days,  8:45, 182 users,  load average: 0.02, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 03:39:25PM +0200, Andrew Lunn wrote:
> On Wed, May 13, 2020 at 02:34:40PM +0200, Oleksij Rempel wrote:
> > Add initial cable testing support.
> > This PHY needs only 100usec for this test and it is recommended to run it
> > before the link is up. For now, provide at least ethtool support, so it
> > can be tested by more developers.
> > 
> > This patch was tested with TJA1102 PHY with following results:
> > - No cable, is detected as open
> > - 1m cable, with no connected other end and detected as open
> > - a 40m cable (out of spec, max lenght should be 15m) is detected as OK.
> > 
> > Current patch do not provide polarity test support. This test would
> > indicate not proper wire connection, where "+" wire of main phy is
> > connected to the "-" wire of the link partner.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/phy/nxp-tja11xx.c | 106 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 105 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> > index ca5f9d4dc57ed..8b743d25002b9 100644
> > --- a/drivers/net/phy/nxp-tja11xx.c
> > +++ b/drivers/net/phy/nxp-tja11xx.c
> > @@ -5,6 +5,7 @@
> >   */
> >  #include <linux/delay.h>
> >  #include <linux/ethtool.h>
> > +#include <linux/ethtool_netlink.h>
> >  #include <linux/kernel.h>
> >  #include <linux/mdio.h>
> >  #include <linux/mii.h>
> > @@ -26,6 +27,7 @@
> >  #define MII_ECTRL_POWER_MODE_NO_CHANGE	(0x0 << 11)
> >  #define MII_ECTRL_POWER_MODE_NORMAL	(0x3 << 11)
> >  #define MII_ECTRL_POWER_MODE_STANDBY	(0xc << 11)
> > +#define MII_ECTRL_CABLE_TEST		BIT(5)
> >  #define MII_ECTRL_CONFIG_EN		BIT(2)
> >  #define MII_ECTRL_WAKE_REQUEST		BIT(0)
> >  
> > @@ -55,6 +57,11 @@
> >  #define MII_GENSTAT			24
> >  #define MII_GENSTAT_PLL_LOCKED		BIT(14)
> >  
> > +#define MII_EXTSTAT			25
> > +#define MII_EXTSTAT_SHORT_DETECT	BIT(8)
> > +#define MII_EXTSTAT_OPEN_DETECT		BIT(7)
> > +#define MII_EXTSTAT_POLARITY_DETECT	BIT(6)
> > +
> 
> Do these registers all conform to the standard? Can we pull this code
> out into a library which all standards conformant PHY drivers can use?

According to opensig, this functionality should be present on all new T1 PHYs.
But the register/bit layout is no specified as standard. At least I was not able
to find it. I assume, current layout is TJA11xx specific.

> The code itself looks O.K.

What would be the best place to do a test before the link is getting up?
Can it be done in the phy core, or it should be done in the PHY driver?

So far, no action except of logging these errors is needed. 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
