Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CD92D8AB5
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 01:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439936AbgLMAJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 19:09:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgLMAJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 19:09:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1koEwZ-00Bguc-7U; Sun, 13 Dec 2020 01:08:55 +0100
Date:   Sun, 13 Dec 2020 01:08:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v3 net-next] net: dsa: reference count the host mdb
 addresses
Message-ID: <20201213000855.GA2786309@lunn.ch>
References: <20201212203901.351331-1-vladimir.oltean@nxp.com>
 <20201212220641.GA2781095@lunn.ch>
 <20201212221858.audzhrku3i3p2nqf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212221858.audzhrku3i3p2nqf@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 10:18:59PM +0000, Vladimir Oltean wrote:
> On Sat, Dec 12, 2020 at 11:06:41PM +0100, Andrew Lunn wrote:
> > > +	/* Complication created by the fact that addition has two phases, but
> > > +	 * deletion only has one phase, and we need reference counting.
> > > +	 * The strategy is to do the memory allocation in the prepare phase,
> > > +	 * but initialize the refcount in the commit phase.
> > > +	 *
> > > +	 * Have mdb	| mdb has refcount > 0	| Commit phase	| Resolution
> > > +	 * -------------+-----------------------+---------------+---------------
> > > +	 * no		| -			| no		| Alloc & proceed
> >
> > This does not look right.
> >
> > The point of the prepare phase is to allow all the different layers
> > involved to allocate whatever they need and to validate they can do
> > the requested action. Any layer can say, No, stop, i cannot do
> > this. The commit phase will then not happen. But that also means the
> > prepare phase should not do any state changes. So you should not be
> > proceeding here, just allocating.
> 
> Are you commenting based on the code, or just based on the comment?
> If just based on the comment, then yeah, sorry. I was limited to 80
> characters, and I couldn't specify "proceed to what". It's just "proceed
> to call the prepare phase of the driver"

Ah, O.K.

> > And you need some way to cleanup the allocated memory when the commit
> > never happens because some other layer has said No!
> 
> So this would be a fatal problem with the switchdev transactional model
> if I am not misunderstanding it. On one hand there's this nice, bubbly
> idea that you should preallocate memory in the prepare phase, so that
> there's one reason less to fail at commit time. But on the other hand,
> if "the commit phase might never happen" is even a remove possibility,
> all of that goes to trash - how are you even supposed to free the
> preallocated memory.

It can definitely happen, that commit is never called:

static int switchdev_port_obj_add_now(struct net_device *dev,
                                      const struct switchdev_obj *obj,
                                      struct netlink_ext_ack *extack)
{

       /* Phase I: prepare for obj add. Driver/device should fail
         * here if there are going to be issues in the commit phase,
         * such as lack of resources or support.  The driver/device
         * should reserve resources needed for the commit phase here,
         * but should not commit the obj.
         */

        trans.ph_prepare = true;
        err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
                                        dev, obj, &trans, extack);
        if (err)
                return err;

        /* Phase II: commit obj add.  This cannot fail as a fault
         * of driver/device.  If it does, it's a bug in the driver/device
         * because the driver said everythings was OK in phase I.
         */

        trans.ph_prepare = false;
        err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
                                        dev, obj, &trans, extack);
        WARN(err, "%s: Commit of object (id=%d) failed.\n", dev->name, obj->id);

        return err;

So if any notifier returns an error during prepare, the commit is
never called.

So the memory you allocated and added to the list may never get
used. Its refcount stays zero.  Which is why i suggested making the
MDB remove call do a general garbage collect. It is not perfect, the
cleanup could be deferred a long time, but is should get removed
eventually.

	Andrew
