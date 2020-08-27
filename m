Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE727253E40
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgH0G4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgH0G4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:56:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4FDC061264
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 23:56:07 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kBBpJ-0004xz-MR; Thu, 27 Aug 2020 08:56:01 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kBBpI-0004qx-Vw; Thu, 27 Aug 2020 08:56:00 +0200
Date:   Thu, 27 Aug 2020 08:56:00 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Subject: Re: [PATCH] net: mdiobus: fix device unregistering in
 mdiobus_register
Message-ID: <20200827065600.GB4498@pengutronix.de>
References: <20200826095141.5156-1-s.hauer@pengutronix.de>
 <7a1f68b7-c23b-11e2-befc-105b995da89f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a1f68b7-c23b-11e2-befc-105b995da89f@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:53:57 up 189 days, 14:24, 145 users,  load average: 0.02, 0.10,
 0.09
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 06:26:36PM +0200, Heiner Kallweit wrote:
> On 26.08.2020 11:51, Sascha Hauer wrote:
> > __mdiobus_register() can fail between calling device_register() and
> > setting bus->state to MDIOBUS_REGISTERED. When this happens the caller
> > will call mdiobus_free() which then frees the mdio bus structure. This
> > is not allowed as the embedded struct device is already registered, thus
> > must be freed dropping the reference count using put_device(). To
> > accomplish this set bus->state to MDIOBUS_UNREGISTERED after having
> > registered the device. With this mdiobus_free() correctly calls
> > put_device() instead of freeing the mdio bus structure directly.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/net/phy/mdio_bus.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 0af20faad69d..85cbaab4a591 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -540,6 +540,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
> >  		return -EINVAL;
> >  	}
> >  
> > +	bus->state = MDIOBUS_UNREGISTERED;
> > +
> >  	mutex_init(&bus->mdio_lock);
> >  	mutex_init(&bus->shared_lock);
> >  
> > 
> I see the point. If we bail out after having called device_register()
> then put_device() has to be called. This however isn't done by
> mdiobus_free() if state is MDIOBUS_ALLOCATED. So I think the idea is
> right. However we have to call put_device() even if device_register()
> fails, therefore setting state to MDIOBUS_UNREGISTERED should be
> moved to before calling device_register().

You're right, the comment above device_register clearly states:

/*
 * NOTE: _Never_ directly free @dev after calling this function, even
 * if it returned an error! Always use put_device() to give up the
 * reference initialized in this function instead.
 */

And I read this just yesterday while preparing this patch.

Will send a v2.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
