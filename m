Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE7255C1B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgH1OPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgH1OPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 10:15:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D122DC061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 07:15:14 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kBf9s-0007Fs-Pv; Fri, 28 Aug 2020 16:15:12 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kBf9s-0003Zf-7V; Fri, 28 Aug 2020 16:15:12 +0200
Date:   Fri, 28 Aug 2020 16:15:12 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Subject: Re: [PATCHi v2] net: mdiobus: fix device unregistering in
 mdiobus_register
Message-ID: <20200828141512.GF4498@pengutronix.de>
References: <20200827070618.26754-1-s.hauer@pengutronix.de>
 <3f9daa3c-8a16-734b-da7b-e0721ddf992c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9daa3c-8a16-734b-da7b-e0721ddf992c@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:07:24 up 190 days, 21:37, 131 users,  load average: 0.11, 0.23,
 0.18
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 10:48:48AM +0200, Heiner Kallweit wrote:
> On 27.08.2020 09:06, Sascha Hauer wrote:
> > After device_register has been called the device structure may not be
> > freed anymore, put_device() has to be called instead. This gets violated
> > when device_register() or any of the following steps before the mdio
> > bus is fully registered fails. In this case the caller will call
> > mdiobus_free() which then directly frees the mdio bus structure.
> > 
> > Set bus->state to MDIOBUS_UNREGISTERED right before calling
> > device_register(). With this mdiobus_free() calls put_device() instead
> > as it ought to be.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> > 
> > Changes since v1:
> > - set bus->state before calling device_register(), not afterwards
> > 
> >  drivers/net/phy/mdio_bus.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 0af20faad69d..9434b04a11c8 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -534,6 +534,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
> >  	bus->dev.groups = NULL;
> >  	dev_set_name(&bus->dev, "%s", bus->id);
> >  
> > +	bus->state = MDIOBUS_UNREGISTERED;
> > +
> >  	err = device_register(&bus->dev);
> >  	if (err) {
> >  		pr_err("mii_bus %s failed to register\n", bus->id);
> > 
> LGTM. Just two points:
> 1. Subject has a typo (PATCHi). And it should be [PATCH net v2], because it's
>    something for the stable branch.
> 2. A "Fixes" tag is needed.

Uh, AFAICT this fixes a patch from 2008, this makes for quite some
stable updates :)

Sascha

| commit 161c8d2f50109b44b664eaf23831ea1587979a61
| Author: Krzysztof Halasa <khc@pm.waw.pl>
| Date:   Thu Dec 25 16:50:41 2008 -0800
| 
|     net: PHYLIB mdio fixes #2

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
