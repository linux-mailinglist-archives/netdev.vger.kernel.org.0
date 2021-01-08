Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8600F2EFB58
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbhAHWrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 17:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbhAHWrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 17:47:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C641B23A80;
        Fri,  8 Jan 2021 22:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610145996;
        bh=cs34ouDG3S7sI3dO30UtizidM6NZuXNslrjVsl9DLeI=;
        h=In-Reply-To:References:Subject:To:From:Cc:Date:From;
        b=uqwEWDjsq1L5Go5+mhAgLJNxmukQSVNZYo1Jjjz24EAS5fbEDnpB9H2p555Px6GZp
         wBPR1uw9K1yXqCoqRhhvTkVjTCS24VMCwVhNNooJejRpqt+I4496pwnOAdphIB0pI1
         r5QSKnVbAIPalCsfM+Cqyqu+spZnP5INNrAcclihj2dL5vRrMylW39ot+iZ+D8Iyte
         idVCZD6tbeWpyjwi2J2jWiiyM/6Pq2hHZgC6vM8hciHPm4yYtdmBcwTHMcVUFR1hwd
         3aQ3UK7JS2TGEaA+RzfDF53EeAPOYTCPw2gg7Bzs3bTHkZsjGhfUzZ7+lkyeODYmux
         OGB+IVQWXKMSw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0Ud-BFGYZAZU_3CFQ+mqzZEKj4w6CCZSFHbo5SBBOSsxgg@mail.gmail.com>
References: <20210106180428.722521-1-atenart@kernel.org> <20210106180428.722521-4-atenart@kernel.org> <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com> <161000966161.3275.12891261917424414122@kwain.local> <CAKgT0UcFu7pgy96uMhraT7B_JKEwXtVziouXLmZ4rdXPHn91Jg@mail.gmail.com> <161009687495.3394.14011897084392954560@kwain.local> <CAKgT0UdSiLpPXUEEOLRj4+7D0KcGBNBoW5cU=4DXW0kfOb=gEQ@mail.gmail.com> <161013228882.3394.7522492301815327352@kwain.local> <CAKgT0Ud-BFGYZAZU_3CFQ+mqzZEKj4w6CCZSFHbo5SBBOSsxgg@mail.gmail.com>
Subject: Re: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a common function
To:     Alexander Duyck <alexander.duyck@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Message-ID: <161014599329.3394.12275123853451658325@localhost.localdomain>
Date:   Fri, 08 Jan 2021 23:46:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Alexander Duyck (2021-01-08 23:04:57)
> On Fri, Jan 8, 2021 at 10:58 AM Antoine Tenart <atenart@kernel.org> wrote:
> >
> > Quoting Alexander Duyck (2021-01-08 17:33:01)
> > > On Fri, Jan 8, 2021 at 1:07 AM Antoine Tenart <atenart@kernel.org> wr=
ote:
> > > >
> > > > Quoting Alexander Duyck (2021-01-07 17:38:35)
> > > > > On Thu, Jan 7, 2021 at 12:54 AM Antoine Tenart <atenart@kernel.or=
g> wrote:
> > > > > >
> > > > > > Quoting Alexander Duyck (2021-01-06 20:54:11)
> > > > > > > On Wed, Jan 6, 2021 at 10:04 AM Antoine Tenart <atenart@kerne=
l.org> wrote:
> > > > > > > >         if (dev->num_tc) {
> > > > > > > >                 /* Do not allow XPS on subordinate device d=
irectly */
> > > > > > > >                 num_tc =3D dev->num_tc;
> > > > > > > > -               if (num_tc < 0) {
> > > > > > > > -                       ret =3D -EINVAL;
> > > > > > > > -                       goto err_rtnl_unlock;
> > > > > > > > -               }
> > > > > > > > +               if (num_tc < 0)
> > > > > > > > +                       return -EINVAL;
> > > > > > > >
> > > > > > > >                 /* If queue belongs to subordinate dev use =
its map */
> > > > > > > >                 dev =3D netdev_get_tx_queue(dev, index)->sb=
_dev ? : dev;
> > > > > > > >
> > > > > > > >                 tc =3D netdev_txq_to_tc(dev, index);
> > > > > > > > -               if (tc < 0) {
> > > > > > > > -                       ret =3D -EINVAL;
> > > > > > > > -                       goto err_rtnl_unlock;
> > > > > > > > -               }
> > > > > > > > +               if (tc < 0)
> > > > > > > > +                       return -EINVAL;
> > > > > > > >         }
> > > > > > > >
> > > > > > >
> > > > > > > So if we store the num_tc and nr_ids in the dev_maps structur=
e then we
> > > > > > > could simplify this a bit by pulling the num_tc info out of t=
he
> > > > > > > dev_map and only asking the Tx queue for the tc in that case =
and
> > > > > > > validating it against (tc <0 || num_tc <=3D tc) and returning=
 an error
> > > > > > > if either are true.
> > > > > > >
> > > > > > > This would also allow us to address the fact that the rxqs fe=
ature
> > > > > > > doesn't support the subordinate devices as you could pull out=
 the bit
> > > > > > > above related to the sb_dev and instead call that prior to ca=
lling
> > > > > > > xps_queue_show so that you are operating on the correct devic=
e map.
> > > > >
> > > > > It probably would be necessary to pass dev and index if we pull t=
he
> > > > > netdev_get_tx_queue()->sb_dev bit out and performed that before we
> > > > > called the xps_queue_show function. Specifically as the subordina=
te
> > > > > device wouldn't match up with the queue device so we would be bet=
ter
> > > > > off pulling it out first.
> > > >
> > > > While I agree moving the netdev_get_tx_queue()->sb_dev bit out of
> > > > xps_queue_show seems like a good idea for consistency, I'm not sure
> > > > it'll work: dev->num_tc is not only used to retrieve the number of =
tc
> > > > but also as a condition on not being 0. We have things like:
> > > >
> > > >   // Always done with the original dev.
> > > >   if (dev->num_tc) {
> > > >
> > > >       [...]
> > > >
> > > >       // Can be a subordinate dev.
> > > >       tc =3D netdev_txq_to_tc(dev, index);
> > > >   }
> > > >
> > > > And after moving num_tc in the map, we'll have checks like:
> > > >
> > > >   if (dev_maps->num_tc !=3D dev->num_tc)
> > > >       return -EINVAL;
> > >
> > > We shouldn't. That defeats the whole point and you will never be able
> > > to rely on the num_tc in the device to remain constant. If we are
> > > moving the value to an RCU accessible attribute we should just be
> > > using that value. We can only use that check if we are in an rtnl_lock
> > > anyway and we won't need that if we are just displaying the value.
> > >
> > > The checks should only be used to verify the tc of the queue is within
> > > the bounds of the num_tc of the xps_map.
> >
> > Right. So that would mean we have to choose between:
> >
> > - Removing the rtnl lock but with the understanding that the value we
> >   get when reading the maps might be invalid and not make sense with
> >   the current dev->num_tc configuration.
> >
> > - Keeping the rtnl lock (which, I mean, I'd like to remove).
> >
> > My first goal for embedding num_tc in the maps was to prevent accessing
> > the maps out-of-bound when dev->num_tc is updated after the maps are
> > allocated. That's a possibility (I could produce such behaviour with
> > KASAN enabled) even when taking the rtnl lock in the show/store helpers.
> >
> > We're now talking of also removing the rtnl lock, which is fine, I just
> > want to make those two different goals explicit as they're not
> > interdependent.
>=20
> The problem is in the grand scheme of things the XPS map data is
> already out of date by the time we look at it anyway regardless of the
> locking mechanics. The problem is if we are doing both at the same
> time we could already be looking at stale data as the num_tcs could
> change after we dump the map and then it would still be invalid even
> if we bothered with the RTNL lock or not.
>=20
> In my mind we are better of with the RCU style behavior as we are just
> using this to display the current setup anyway, and if we are updating
> then we need the RTNL lock so that we can guarantee a consistent state
> on the device while we are putting together the xps map.

You're right, there's no way to ensure we're looking at the current
setup. In that case let's use the embedded map values only.

> One additional thought I had is that we may want to treat an
> out-of-bounds reference the same as XPS not being enabled. So that we
> would return a 0 mask instead of an error.  So instead of just
> checking for "if (dev_maps)" we would check for "if (dev_maps && tc <
> dev_maps->num_tc)".

Agreed, that would be good and less confusing for the user.

> > > > > > > I think Jakub had mentioned earlier the idea of possibly movi=
ng some
> > > > > > > fields into the xps_cpus_map and xps_rxqs_map in order to red=
uce the
> > > > > > > complexity of this so that certain values would be protected =
by the
> > > > > > > RCU lock.
> > > > > > >
> > > > > > > This might be a good time to look at encoding things like the=
 number
> > > > > > > of IDs and the number of TCs there in order to avoid a bunch =
of this
> > > > > > > duplication. Then you could just pass a pointer to the map yo=
u want to
> > > > > > > display and the code should be able to just dump the values.:
> > > > > >
> > > > > > 100% agree to all the above. That would also prevent from makin=
g out of
> > > > > > bound accesses when dev->num_tc is increased after dev_maps is
> > > > > > allocated. I do have a series ready to be send storing num_tc i=
nto the
> > > > > > maps, and reworking code to use it instead of dev->num_tc. The =
series
> > > > > > also adds checks to ensure the map is valid when we access it (=
such as
> > > > > > making sure dev->num_tc =3D=3D map->num_tc). I however did not =
move nr_ids
> > > > > > into the map yet, but I'll look into it.
> > > > > >
> > > > > > The idea is to send it as a follow up series, as this one is on=
ly moving
> > > > > > code around to improve maintenance and readability. Even if all=
 the
> > > > > > patches were in the same series that would be a prerequisite.
> > > > >
> > > > > Okay, so if we are going to do it as a follow-up that is fine I
> > > > > suppose, but one of the reasons I brought it up is that it would =
help
> > > > > this patch set in terms of readability/maintainability. An additi=
onal
> > > > > change we could look at making would be to create an xps_map poin=
ter
> > > > > array instead of having individual pointers. Then you could simpl=
y be
> > > > > passing an index into the array to indicate if we are accessing t=
he
> > > > > CPUs or the RXQs map.
> > > >
> > > > Merging the two maps and embedding an offset in the struct? With the
> > > > upcoming changes embedding information in the map themselves we sho=
uld
> > > > have a single check to know what map to use. Using a single array w=
ith
> > > > offsets would not improve that. Also maps maintenance when num_tc
> > > > is updated would need to take care of both maps, having side effects
> > > > such as removing the old rxqs map when allocating the cpus one (or =
the
> > > > opposite).
> > >
> > > Sorry, I didn't mean to merge the two maps. Just go from two pointers
> > > to an array containing two pointers. Right now them sitting right next
> > > to each other it becomes pretty easy to just convert them so that
> > > instead of accessing them as:
> > >
> > > dev->xps_rxqs_map
> > > dev->xps_cpus_map
> > >
> > > You could instead access them as:
> > > dev->xps_map[XPS_RXQ];
> > > dev->xps_map[XPS_CPU];
> > >
> > > Then instead of all the if/else logic we have in the code you just are
> > > passing the index of the xps_map you want to access and we have the
> > > nr_ids and num_tc all encoded in the map so the code itself. Then for
> > > displaying we are just using the fields from the map to validate.
> > >
> > > We will still end up needing to take the rtnl_lock for the
> > > __netif_set_xps_queue case, however that should be the only case where
> > > we really need it as we have to re-read dev->num_tc and the
> > > netdev_txq_to_tc and guarantee they don't change while we are
> > > programming the map.
> >
> > Thanks for the detailed explanations. That indeed would be good.
>=20
> It does simplify things quite a bit, at least for the display logic
> since essentially all the secondary values that tell us the size and
> shape of the XPS map would essentially be stored in the map itself
> now.
>=20
> Odds are we could probably consolidate __netif_set_xps_queues quite a
> bit with this as well. From what I can tell it looks like we could
> probably default nr_ids to dev->num_rx_queues and then if we are doing
> a CPU based map then we overwrite nr_ids with nr_cpu_ids and populate
> the online mask.

Sure.

All right, I'll cook up a v2 for this series and take the other comments
and suggestions into account for the follow-up one.

Thanks!
Antoine
