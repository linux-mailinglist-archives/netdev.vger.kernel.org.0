Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952B74059E6
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbhIIPBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 11:01:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237427AbhIIPBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 11:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9l53Nh7/iHpQSXsZmHOxAQYplkVcRh+5oMbjQhUdMB4=; b=QSr76lyUaZazSCd0Dm2+uM+eEI
        vTTQ5QZ+jkpd1oigNCVUKxAajmBUzVPW7v1e+VoiBRqNUUy8kI6coIYcWr+PoEStS12mkD2t/hnaS
        yL1OK0A7Zk1XqK3j7lnOjVUGmE5veVes4HZdtKTcic5QO9opmaCdZSnycAAvi0/RVSNA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mOLX6-005vyW-3B; Thu, 09 Sep 2021 17:00:08 +0200
Date:   Thu, 9 Sep 2021 17:00:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YToheBmLrce1CuZt@lunn.ch>
References: <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YTll0i6Rz3WAAYzs@lunn.ch>
 <CAGETcx_U--ayNCo2GH1-EuzuD9usywjQm+B57X_YwFOjA3e+3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_U--ayNCo2GH1-EuzuD9usywjQm+B57X_YwFOjA3e+3Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sigh... looks like some drivers register their mdio bus in their
> dsa_switch_ops->setup while others do it in their actual probe
> function (which actually makes more sense to me).
 
Drivers are free to do whatever they want. The driver model allows it.

> I'm okay with this big hammer for now while we figure out something
> better.


> 
> >
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 53f034fc2ef7..7ecd910f7fb8 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -525,6 +525,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
> >             NULL == bus->read || NULL == bus->write)
> >                 return -EINVAL;
> >
> > +       if (bus->parent && bus->parent->of_node)
> > +               bus->parent->of_node->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
> > +
> >         BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
> >                bus->state != MDIOBUS_UNREGISTERED);
> >
> > So basically saying all MDIO busses potentially have a problem.
> >
> > I also don't like the name FWNODE_FLAG_BROKEN_PARENT. The parents are
> > not broken, they work fine, if fw_devlink gets out of the way and
> > allows them to do their job.
> 
> The parent assuming the child will be probed as soon as it's added is
> a broken expectation/assumption. fw_devlink is just catching them
> immediately.

Why is it broken? As i said in the history, DSA has worked since
2008. This behaviour is not that old, but it has been used and worked
for a number of years.

I actual think your model of the driver model is too simple and needs
to accept that a driver probe is not atomic. Resources a driver
registers with other parts of the kernel can be used before the probe
completes. And we have some corners of the kernel that depend on that.

This is particularly true for network drivers. As soon as you register
a network interface to the stack, it will start using it, before the
probe function has completed. It does not wait around for the driver
core to say it has completed probing. And i doubt this is unique to
networking. Maybe when a frame buffer driver registers a frame buffer
with the core, the core starts to draw the splash screen, before the
probe finishes? Maybe when a block driver registers a block device,
the core starts reading the partition table, before the probe
finishes? These are all examples of using a resource before the probe
completes.

> Having said that, this is not the hill either of us should choose to
> die on. So, how about something like:
> FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
> 
> If that works, I can clean up the series with this and the MDIO fix
> you mentioned.

That is O.K. for me as a fix. I can test patches next week.

     Andrew
