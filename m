Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6780CA457A
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 18:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfHaQyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 12:54:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34456 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbfHaQyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 12:54:53 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so11608652edb.1
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 09:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49o/9wKz1A3MUoxgATWz1MeNSvLEOCbfU8HYLSAJphs=;
        b=aKWR5t4gW8q3hnStOjwYuhUUqcE9zcmwKz4b+CG2x5TD9NWNCzh+Y0iJcBqEHDgQ33
         BSKDSNzJhAINT7HiHfOgsLs7Ifm6MTf68kzQHbqtySV8eC2fNLF9UlU0g8a8OermiFIM
         B32jWXe3zUfpTnok3i86Xb5nh9VOH7FoekpnlDWMKrB/DxazzKXzVy1Y+jenNuQxxbrx
         pGjfFXZYMNk4g+ASiZRoIHJV7trT+yIvtQ8/XMq1KDV5d2CmDPEBaPLyPu4eOXWjDXrE
         jevu0WNKtAOY3mBYxBsTOCOggD+nOHGs/63hh5+md4pP9XvYWEgmBNao998A+naBsrpH
         8ZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49o/9wKz1A3MUoxgATWz1MeNSvLEOCbfU8HYLSAJphs=;
        b=DqCcwU3L58qKN1cE5spp3iW+SxGItSvJ5250UfGEOAM0eZ9pgP1cJKBHORaZFVi76F
         xq36X5s61qBTN2kWG48fAXLYei3R51smv0qZAPf0TWACnxr2pLMoZcT3Jzcm4RPYjf8J
         uREI5vPcftj/EGh5DJJN16/NUR+XfwQ0hMjhLT2nBdp57fqbVwr6La+4fDb+h6Fl7870
         KNMt4Shc/F2mUvNO1MXDq3/2CIfmoFUehwJ/I56D7n/zd/pjtV14nRp6jaq85pgJkk2q
         FYM09FO5rD+xGFkpVBYZDXSLsPshrQJxDxZdt381yARAxGSBKtwBVjYSo9KxSfeWI9Wy
         41Rw==
X-Gm-Message-State: APjAAAUCCxATamXP6gPKwZsVY0BjTUs2w9CK2JC0bhtQnLcnIZYYYf8m
        6N5A3SkJXGEQvi2sn3F0HX+npxuRDi1neWyXHRY=
X-Google-Smtp-Source: APXvYqx5X0TH6p0R3E7yqytLNsz07LDeZZ6weo/kiXY0PuGWtSEP+8nITTcYDiSXNvft2vlzmH4fsnAbHRgNMfiMFow=
X-Received: by 2002:a17:906:d298:: with SMTP id ay24mr18138895ejb.230.1567270490866;
 Sat, 31 Aug 2019 09:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190831124619.460-1-olteanv@gmail.com> <20190831121958.GC12031@t480s.localdomain>
In-Reply-To: <20190831121958.GC12031@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 31 Aug 2019 19:54:40 +0300
Message-ID: <CA+h21hoKcg3UUNkYRyEw8FS0q_vxdmoQL90BaOuKoW074DYYow@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: Fix off-by-one number of calls to devlink_port_unregister
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien,

On Sat, 31 Aug 2019 at 19:20, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Sat, 31 Aug 2019 15:46:19 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > When a function such as dsa_slave_create fails, currently the following
> > stack trace can be seen:
> >
> > [    2.038342] sja1105 spi0.1: Probed switch chip: SJA1105T
> > [    2.054556] sja1105 spi0.1: Reset switch and programmed static config
> > [    2.063837] sja1105 spi0.1: Enabled switch tagging
> > [    2.068706] fsl-gianfar soc:ethernet@2d90000 eth2: error -19 setting up slave phy
> > [    2.076371] ------------[ cut here ]------------
> > [    2.080973] WARNING: CPU: 1 PID: 21 at net/core/devlink.c:6184 devlink_free+0x1b4/0x1c0
> > [    2.088954] Modules linked in:
> > [    2.092005] CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.3.0-rc6-01360-g41b52e38d2b6-dirty #1746
> > [    2.100912] Hardware name: Freescale LS1021A
> > [    2.105162] Workqueue: events deferred_probe_work_func
> > [    2.110287] [<c03133a4>] (unwind_backtrace) from [<c030d8cc>] (show_stack+0x10/0x14)
> > [    2.117992] [<c030d8cc>] (show_stack) from [<c10b08d8>] (dump_stack+0xb4/0xc8)
> > [    2.125180] [<c10b08d8>] (dump_stack) from [<c0349d04>] (__warn+0xe0/0xf8)
> > [    2.132018] [<c0349d04>] (__warn) from [<c0349e34>] (warn_slowpath_null+0x40/0x48)
> > [    2.139549] [<c0349e34>] (warn_slowpath_null) from [<c0f19d74>] (devlink_free+0x1b4/0x1c0)
> > [    2.147772] [<c0f19d74>] (devlink_free) from [<c1064fc0>] (dsa_switch_teardown+0x60/0x6c)
> > [    2.155907] [<c1064fc0>] (dsa_switch_teardown) from [<c1065950>] (dsa_register_switch+0x8e4/0xaa8)
> > [    2.164821] [<c1065950>] (dsa_register_switch) from [<c0ba7fe4>] (sja1105_probe+0x21c/0x2ec)
> > [    2.173216] [<c0ba7fe4>] (sja1105_probe) from [<c0b35948>] (spi_drv_probe+0x80/0xa4)
> > [    2.180920] [<c0b35948>] (spi_drv_probe) from [<c0a4c1cc>] (really_probe+0x108/0x400)
> > [    2.188711] [<c0a4c1cc>] (really_probe) from [<c0a4c694>] (driver_probe_device+0x78/0x1bc)
> > [    2.196933] [<c0a4c694>] (driver_probe_device) from [<c0a4a3dc>] (bus_for_each_drv+0x58/0xb8)
> > [    2.205414] [<c0a4a3dc>] (bus_for_each_drv) from [<c0a4c024>] (__device_attach+0xd0/0x168)
> > [    2.213637] [<c0a4c024>] (__device_attach) from [<c0a4b1d0>] (bus_probe_device+0x84/0x8c)
> > [    2.221772] [<c0a4b1d0>] (bus_probe_device) from [<c0a4b72c>] (deferred_probe_work_func+0x84/0xc4)
> > [    2.230686] [<c0a4b72c>] (deferred_probe_work_func) from [<c03650a4>] (process_one_work+0x218/0x510)
> > [    2.239772] [<c03650a4>] (process_one_work) from [<c03660d8>] (worker_thread+0x2a8/0x5c0)
> > [    2.247908] [<c03660d8>] (worker_thread) from [<c036b348>] (kthread+0x148/0x150)
> > [    2.255265] [<c036b348>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
> > [    2.262444] Exception stack(0xea965fb0 to 0xea965ff8)
> > [    2.267466] 5fa0:                                     00000000 00000000 00000000 00000000
> > [    2.275598] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > [    2.283729] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> > [    2.290333] ---[ end trace ca5d506728a0581a ]---
> >
> > devlink_free is complaining right here:
> >
> >       WARN_ON(!list_empty(&devlink->port_list));
> >
> > This happens because devlink_port_unregister is no longer done right
> > away in dsa_port_setup when a DSA_PORT_TYPE_USER has failed.
> > Vivien said about this change that:
> >
> >     Also no need to call devlink_port_unregister from within dsa_port_setup
> >     as this step is inconditionally handled by dsa_port_teardown on error.
> >
> > which is not really true. The devlink_port_unregister function _is_
> > being called unconditionally from within dsa_port_setup, but not for
>
> Not from within dsa_port_setup, but from its caller dsa_tree_setup_switches.
>
> > this port that just failed, just for the previous ones which were set
> > up.
> >
> > ports_teardown:
> >       for (i = 0; i < port; i++)
> >               dsa_port_teardown(&ds->ports[i]);
> >
> > Initially I was tempted to fix this by extending the "for" loop to also
> > cover the port that failed during setup. But this could have potentially
> > unforeseen consequences unrelated to devlink_port or even other types of
> > ports than user ports, which I can't really test for. For example, if
> > for some reason devlink_port_register itself would fail, then
> > unconditionally unregistering it in dsa_port_teardown would not be a
> > smart idea. The list might go on.
> >
> > So just make dsa_port_setup undo the setup it had done upon failure, and
> > let the for loop undo the work of setting up the previous ports, which
> > are guaranteed to be brought up to a consistent state.
> >
> > Fixes: 955222ca5281 ("net: dsa: use a single switch statement for port setup")
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  net/dsa/dsa2.c | 39 +++++++++++++++++++++++++++++----------
> >  1 file changed, 29 insertions(+), 10 deletions(-)
> >
> > diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> > index f8445fa73448..b501c90aabe4 100644
> > --- a/net/dsa/dsa2.c
> > +++ b/net/dsa/dsa2.c
> > @@ -259,8 +259,11 @@ static int dsa_port_setup(struct dsa_port *dp)
> >       const unsigned char *id = (const unsigned char *)&dst->index;
> >       const unsigned char len = sizeof(dst->index);
> >       struct devlink_port *dlp = &dp->devlink_port;
> > +     bool dsa_port_link_registered = false;
> > +     bool devlink_port_registered = false;
> >       struct devlink *dl = ds->devlink;
> > -     int err;
> > +     bool dsa_port_enabled = false;
> > +     int err = 0;
> >
> >       switch (dp->type) {
> >       case DSA_PORT_TYPE_UNUSED:
> > @@ -272,15 +275,19 @@ static int dsa_port_setup(struct dsa_port *dp)
> >                                      dp->index, false, 0, id, len);
> >               err = devlink_port_register(dl, dlp, dp->index);
> >               if (err)
> > -                     return err;
> > +                     break;
> > +             devlink_port_registered = true;
> >
> >               err = dsa_port_link_register_of(dp);
> >               if (err)
> > -                     return err;
> > +                     break;
> > +             dsa_port_link_registered = true;
> >
> >               err = dsa_port_enable(dp, NULL);
> >               if (err)
> > -                     return err;
> > +                     break;
> > +             dsa_port_enabled = true;
> > +
> >               break;
> >       case DSA_PORT_TYPE_DSA:
> >               memset(dlp, 0, sizeof(*dlp));
> > @@ -288,15 +295,19 @@ static int dsa_port_setup(struct dsa_port *dp)
> >                                      dp->index, false, 0, id, len);
> >               err = devlink_port_register(dl, dlp, dp->index);
> >               if (err)
> > -                     return err;
> > +                     break;
> > +             devlink_port_registered = true;
> >
> >               err = dsa_port_link_register_of(dp);
> >               if (err)
> > -                     return err;
> > +                     break;
> > +             dsa_port_link_registered = true;
> >
> >               err = dsa_port_enable(dp, NULL);
> >               if (err)
> > -                     return err;
> > +                     break;
> > +             dsa_port_enabled = true;
> > +
> >               break;
> >       case DSA_PORT_TYPE_USER:
> >               memset(dlp, 0, sizeof(*dlp));
> > @@ -304,18 +315,26 @@ static int dsa_port_setup(struct dsa_port *dp)
> >                                      dp->index, false, 0, id, len);
> >               err = devlink_port_register(dl, dlp, dp->index);
> >               if (err)
> > -                     return err;
> > +                     break;
> > +             devlink_port_registered = true;
> >
> >               dp->mac = of_get_mac_address(dp->dn);
> >               err = dsa_slave_create(dp);
> >               if (err)
> > -                     return err;
> > +                     break;
> >
> >               devlink_port_type_eth_set(dlp, dp->slave);
> >               break;
> >       }
> >
> > -     return 0;
> > +     if (err && dsa_port_enabled)
> > +             dsa_port_disable(dp);
> > +     if (err && dsa_port_link_registered)
> > +             dsa_port_link_unregister_of(dp);
> > +     if (err && devlink_port_registered)
> > +             devlink_port_unregister(dlp);
> > +
> > +     return err;
> >  }
>
> No no, I'm pretty sure you can tell this is going to be a nightmare to
> maintain these boolean states for all port types ;-)
>
> And this is not a proper fix for the problem you've spotted. The problem
> you've spotted is that devlink_port_unregister isn't called for the current
> port if its setup failed, because dsa_port_teardown -- which is supposed to
> be called unconditionally on error -- isn't called for the current port. Your
> first attempt was correct, simply fix the loop in dsa_tree_setup_switches
> to include the current port:
>

Fine, I had not noticed the "registered" field from devlink_port.
But I fail to see how dsa_port_teardown can be entered in the generic
case from whatever failure state dsa_port_setup left it in. What if
it's a DSA_PORT_TYPE_CPU whose devlink_port_register failed. What will
happen to the PHYLINK instance behind dsa_port_link_register_of (not
to mention about data that the driver might be allocating in
dsa_port_enable and expecting a matching disable so it won't leak)?
And that doesn't mean the fix isn't "proper". It may be "supposed" to
be called unconditionally on error, but right now it isn't, so I doubt
anybody has tested that, and that there aren't corner cases. Just
playing the safe side.

>
>      ports_teardown:
>     -       for (i = 0; i < port; i++)
>     +       for (i = 0; i <= port; i++)
>
>
> As for devlink_port_unregister, most kernel APIs unregistering objects are
> self protected, so I'm tempted to propose the following patch for devlink:
>
>
>     diff --git a/net/core/devlink.c b/net/core/devlink.c
>     index 650f36379203..ab95607800d6 100644
>     --- a/net/core/devlink.c
>     +++ b/net/core/devlink.c
>     @@ -6264,6 +6264,8 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
>      {
>             struct devlink *devlink = devlink_port->devlink;
>
>     +       if (!devlink_port->registered)
>     +               return;
>             devlink_port_type_warn_cancel(devlink_port);
>             devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
>             mutex_lock(&devlink->lock);
>
>
> Otherwise we can protect the devlink port unregistering ourselves with:
>
>
>     if (dlp->registered)
>         devlink_port_unregister(dlp);
>
>
> BTW that is the subtlety between "unregister" which considers that the object
> _may_ have been registered, and "deregister" which assumes the object _was_

That concept is not familiar to me. Actually I grepped the DSA API for
"unregister" and found:

static void dsa_tag_driver_unregister(struct dsa_tag_driver *dsa_tag_driver)
{
    mutex_lock(&dsa_tag_drivers_lock);
    list_del(&dsa_tag_driver->list);
    mutex_unlock(&dsa_tag_drivers_lock);
}

which looks pretty unconditional to me?

> registered. Would you like to go ahead and propose the devlink patch?
>

Nope, I don't really know what I'm getting myself into :) If you want
to send it, I will consider it during v2.

>
> Thanks for pointing this out,
>
>         Vivien

Regards,
-Vladimir
