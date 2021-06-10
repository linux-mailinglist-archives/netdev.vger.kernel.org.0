Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57FF3A28F5
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFJKGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFJKGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:06:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55AEC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:04:15 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrHXh-0000Mt-7N; Thu, 10 Jun 2021 12:04:05 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lrHXf-0001Jt-N6; Thu, 10 Jun 2021 12:04:03 +0200
Date:   Thu, 10 Jun 2021 12:04:03 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v3 8/9] net: dsa: dsa_slave_phy_connect():
 extend phy's flags with port specific phy flags
Message-ID: <20210610100403.4lgte3x2kw5hvcci@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-9-o.rempel@pengutronix.de>
 <20210526150811.GF30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210526150811.GF30436@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:02:07 up 190 days, 8 min, 39 users,  load average: 0.00, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 04:08:11PM +0100, Russell King (Oracle) wrote:
> On Wed, May 26, 2021 at 06:30:36AM +0200, Oleksij Rempel wrote:
> > This patch extends the flags of the phy that's being connected with the
> > port specific flags of the switch port.
> > 
> > This is needed to handle a port specific erratum of the KSZ8873 switch,
> > which is added in a later patch.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/phy/phylink.c | 2 +-
> >  net/dsa/slave.c           | 4 ++++
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 96d8e88b4e46..167c2277814f 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -1029,7 +1029,7 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
> >  	if (pl->phydev)
> >  		return -EBUSY;
> >  
> > -	return phy_attach_direct(pl->netdev, phy, 0, interface);
> > +	return phy_attach_direct(pl->netdev, phy, phy->dev_flags, interface);
> 
> I don't think this has any benefit. phy_attach_direct() does this
> internally:
> 
>         phydev->dev_flags |= flags;
> 
> which means the above change is effectively doing:
> 
>         phydev->dev_flags |= phydev->dev_flags;
> 
> So, are you sure you need this?

Ah, good point. Back for two years, phy_attach_direct() was doing
	phydev->dev_flags = flags;

I didn't noticed this change.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
