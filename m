Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3433D2D8ABD
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 01:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439955AbgLMAex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 19:34:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392119AbgLMAex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 19:34:53 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1koFL0-00Bh3u-DN; Sun, 13 Dec 2020 01:34:10 +0100
Date:   Sun, 13 Dec 2020 01:34:10 +0100
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
Message-ID: <20201213003410.GB2786309@lunn.ch>
References: <20201212203901.351331-1-vladimir.oltean@nxp.com>
 <20201212220641.GA2781095@lunn.ch>
 <20201212221858.audzhrku3i3p2nqf@skbuf>
 <20201213000855.GA2786309@lunn.ch>
 <20201213001418.ygofxyfmm7d273fe@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213001418.ygofxyfmm7d273fe@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 12:14:19AM +0000, Vladimir Oltean wrote:
> On Sun, Dec 13, 2020 at 01:08:55AM +0100, Andrew Lunn wrote:
> > > > And you need some way to cleanup the allocated memory when the commit
> > > > never happens because some other layer has said No!
> > >
> > > So this would be a fatal problem with the switchdev transactional model
> > > if I am not misunderstanding it. On one hand there's this nice, bubbly
> > > idea that you should preallocate memory in the prepare phase, so that
> > > there's one reason less to fail at commit time. But on the other hand,
> > > if "the commit phase might never happen" is even a remove possibility,
> > > all of that goes to trash - how are you even supposed to free the
> > > preallocated memory.
> >
> > It can definitely happen, that commit is never called:
> >
> > static int switchdev_port_obj_add_now(struct net_device *dev,
> >                                       const struct switchdev_obj *obj,
> >                                       struct netlink_ext_ack *extack)
> > {
> >
> >        /* Phase I: prepare for obj add. Driver/device should fail
> >          * here if there are going to be issues in the commit phase,
> >          * such as lack of resources or support.  The driver/device
> >          * should reserve resources needed for the commit phase here,
> >          * but should not commit the obj.
> >          */
> >
> >         trans.ph_prepare = true;
> >         err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
> >                                         dev, obj, &trans, extack);
> >         if (err)
> >                 return err;
> >
> >         /* Phase II: commit obj add.  This cannot fail as a fault
> >          * of driver/device.  If it does, it's a bug in the driver/device
> >          * because the driver said everythings was OK in phase I.
> >          */
> >
> >         trans.ph_prepare = false;
> >         err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
> >                                         dev, obj, &trans, extack);
> >         WARN(err, "%s: Commit of object (id=%d) failed.\n", dev->name, obj->id);
> >
> >         return err;
> >
> > So if any notifier returns an error during prepare, the commit is
> > never called.
> >
> > So the memory you allocated and added to the list may never get
> > used. Its refcount stays zero.  Which is why i suggested making the
> > MDB remove call do a general garbage collect. It is not perfect, the
> > cleanup could be deferred a long time, but is should get removed
> > eventually.
> 
> What would the garbage collection look like?

        struct dsa_host_addr *a;

        list_for_each_entry_safe(a, addr_list, list)
		if (refcount_read(&a->refcount) == 0) {
			list_del(&a->list);
			free(a);
		}
	}

	Andrew
