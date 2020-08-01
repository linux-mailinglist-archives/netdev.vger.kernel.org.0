Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C55234F1F
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 03:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgHABO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 21:14:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbgHABO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 21:14:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1g6w-007l8O-D1; Sat, 01 Aug 2020 03:14:54 +0200
Date:   Sat, 1 Aug 2020 03:14:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <Asmaa@mellanox.com>
Cc:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200801011454.GB1843538@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
 <20200731174222.GE1748118@lunn.ch>
 <VI1PR05MB4110070900CF42CB3E18983EDA4E0@VI1PR05MB4110.eurprd05.prod.outlook.com>
 <20200731195458.GA1843538@lunn.ch>
 <VI1PR05MB4110ACD3FE86FD3DF5F59D84DA4E0@VI1PR05MB4110.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR05MB4110ACD3FE86FD3DF5F59D84DA4E0@VI1PR05MB4110.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add,
> > > > +int
> > >
> > > > +phy_reg) {
> > >
> > > > +         struct mlxbf_gige *priv = bus->priv;
> > >
> > > > +         u32 cmd;
> > >
> > > > +         u32 ret;
> > >
> > > > +
> > >
> > > > +         /* If the lock is held by something else, drop the request.
> > >
> > > > +         * If the lock is cleared, that means the busy bit was cleared.
> > >
> > > > +         */
> > >
> > >
> > >
> > > How can this happen? The mdio core has a mutex which prevents parallel
> > access?
> > >
> > >
> > >
> > > This is a HW Lock. It is an actual register. So another HW entity can
> > > be holding that lock and reading/changing the values in the HW registers.
> > 
> > You have not explains how that can happen? Is there something in the driver
> > i missed which takes a backdoor to read/write MDIO transactions?
> 
> Ah ok! There is a HW entity (called YU) within the BlueField which is connected to the PHY device.
> I think the YU is what you are calling "backdoor" here. The YU contains several registers which control reads/writes
> To the PHY. So it is like an extra layer for reading MDIO registers. One of the YU registers is the gateway register (aka GW or
> MLXBF_GIGE_MDIO_GW_OFFSET in the code). If the GW register's LOCK bit is not cleared, we cannot write anything to the actual PHY MDIO registers.
> Did I answer your question?

Nope.

How can two transactions happen at the same time, causing this lock
bit to be locked? Given that the MDIO core has a mutex and serialises
all transactions. How can the lock bit every be set?

> > > > +         ret = mlxbf_gige_mdio_poll_bit(priv,
> > > > + MLXBF_GIGE_MDIO_GW_LOCK_MASK);
> > >
> > > > +         if (ret)
> > >
> > > > +                       return -EBUSY;
> > >
> > >
> > >
> > > PHY drivers are not going to like that. They are not going to retry.
> > > What is likely to happen is that phylib moves into the ERROR state,
> > > and the PHY driver grinds to a halt.
> > >
> > >
> > >
> > > This is a fairly quick HW transaction. So I don’t think it would cause
> > > and issue for the PHY drivers. In this case, we use the micrel
> > > KSZ9031. We haven’t seen issues.
> > 
> > So you have happy to debug hard to find and reproduce issues when it does
> > happen? Or would you like to spend a little bit of time now and just prevent
> > it happening at all?
> 
> I think I misunderstood your comment. Did you ask why we are polling here? Or that we shouldn't be returning -EBUSY?

I think you should not be returning EBUSY. If it every happens, bad
things will happen.

This lock bit seems to server no purpose. Software will ensure that
transactions are serialized. If it serves no purpose, just ensure it
is unlocked at probe time, and then ignore it. If you ignore it, you
will never return -EBUSY and so bad things will never happen.

Just because hardware exists does not mean you have to use it or that
it adds any value.

       Andrew
