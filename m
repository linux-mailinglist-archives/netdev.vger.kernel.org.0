Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F44E2EF7C9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbhAHS6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbhAHS6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 13:58:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6078123A84;
        Fri,  8 Jan 2021 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610132292;
        bh=o8zuicixg9jCO43UexIPUpG6Q0nlXaVNb7e5AoCAur0=;
        h=In-Reply-To:References:Subject:To:From:Cc:Date:From;
        b=gY6EcGuH7ML+mrkbB2gBwusR20LopO2/dMVlelDGh7BH/9Rdcf568CCWGSi1NNpJM
         wmBcS0jXm9bkgHGWtTkjnL32QlJbi6W1DHPug1kSLXMqeaXl7G09WH62fNXa40wH+K
         4F/c8hDCbD4WLxnRRLFvU1uavxMYH4Jk2FMIg3g3JTD0K4q/ZuRaEQnareuuynqtor
         5D4JMv3d39EzoQGeYxm/cYfIZVTDU0BwqojYfye3a/M1egd8yxp1/Zo5MrHYkd8auN
         ceoA8LBIDzz54bjDw7z0Ly0l9dxf2SLaTgxR7I+PZ9eg7BliDVMJjGFAQz7yj0uq+v
         Wr7yC+mQud4/g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0UdSiLpPXUEEOLRj4+7D0KcGBNBoW5cU=4DXW0kfOb=gEQ@mail.gmail.com>
References: <20210106180428.722521-1-atenart@kernel.org> <20210106180428.722521-4-atenart@kernel.org> <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com> <161000966161.3275.12891261917424414122@kwain.local> <CAKgT0UcFu7pgy96uMhraT7B_JKEwXtVziouXLmZ4rdXPHn91Jg@mail.gmail.com> <161009687495.3394.14011897084392954560@kwain.local> <CAKgT0UdSiLpPXUEEOLRj4+7D0KcGBNBoW5cU=4DXW0kfOb=gEQ@mail.gmail.com>
Subject: Re: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a common function
To:     Alexander Duyck <alexander.duyck@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Message-ID: <161013228882.3394.7522492301815327352@kwain.local>
Date:   Fri, 08 Jan 2021 19:58:08 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Alexander Duyck (2021-01-08 17:33:01)
> On Fri, Jan 8, 2021 at 1:07 AM Antoine Tenart <atenart@kernel.org> wrote:
> >
> > Quoting Alexander Duyck (2021-01-07 17:38:35)
> > > On Thu, Jan 7, 2021 at 12:54 AM Antoine Tenart <atenart@kernel.org> w=
rote:
> > > >
> > > > Quoting Alexander Duyck (2021-01-06 20:54:11)
> > > > > On Wed, Jan 6, 2021 at 10:04 AM Antoine Tenart <atenart@kernel.or=
g> wrote:
> > > >
> > > > That would require to hold rcu_read_lock in the caller and I'd like=
 to
> > > > keep it in that function.
> > >
> > > Actually you could probably make it work if you were to pass a pointer
> > > to the RCU pointer.
> >
> > That should work but IMHO that could be easily breakable by future
> > changes as it's a bit tricky.
> >
> > > > > >         if (dev->num_tc) {
> > > > > >                 /* Do not allow XPS on subordinate device direc=
tly */
> > > > > >                 num_tc =3D dev->num_tc;
> > > > > > -               if (num_tc < 0) {
> > > > > > -                       ret =3D -EINVAL;
> > > > > > -                       goto err_rtnl_unlock;
> > > > > > -               }
> > > > > > +               if (num_tc < 0)
> > > > > > +                       return -EINVAL;
> > > > > >
> > > > > >                 /* If queue belongs to subordinate dev use its =
map */
> > > > > >                 dev =3D netdev_get_tx_queue(dev, index)->sb_dev=
 ? : dev;
> > > > > >
> > > > > >                 tc =3D netdev_txq_to_tc(dev, index);
> > > > > > -               if (tc < 0) {
> > > > > > -                       ret =3D -EINVAL;
> > > > > > -                       goto err_rtnl_unlock;
> > > > > > -               }
> > > > > > +               if (tc < 0)
> > > > > > +                       return -EINVAL;
> > > > > >         }
> > > > > >
> > > > >
> > > > > So if we store the num_tc and nr_ids in the dev_maps structure th=
en we
> > > > > could simplify this a bit by pulling the num_tc info out of the
> > > > > dev_map and only asking the Tx queue for the tc in that case and
> > > > > validating it against (tc <0 || num_tc <=3D tc) and returning an =
error
> > > > > if either are true.
> > > > >
> > > > > This would also allow us to address the fact that the rxqs feature
> > > > > doesn't support the subordinate devices as you could pull out the=
 bit
> > > > > above related to the sb_dev and instead call that prior to calling
> > > > > xps_queue_show so that you are operating on the correct device ma=
p.
> > >
> > > It probably would be necessary to pass dev and index if we pull the
> > > netdev_get_tx_queue()->sb_dev bit out and performed that before we
> > > called the xps_queue_show function. Specifically as the subordinate
> > > device wouldn't match up with the queue device so we would be better
> > > off pulling it out first.
> >
> > While I agree moving the netdev_get_tx_queue()->sb_dev bit out of
> > xps_queue_show seems like a good idea for consistency, I'm not sure
> > it'll work: dev->num_tc is not only used to retrieve the number of tc
> > but also as a condition on not being 0. We have things like:
> >
> >   // Always done with the original dev.
> >   if (dev->num_tc) {
> >
> >       [...]
> >
> >       // Can be a subordinate dev.
> >       tc =3D netdev_txq_to_tc(dev, index);
> >   }
> >
> > And after moving num_tc in the map, we'll have checks like:
> >
> >   if (dev_maps->num_tc !=3D dev->num_tc)
> >       return -EINVAL;
>=20
> We shouldn't. That defeats the whole point and you will never be able
> to rely on the num_tc in the device to remain constant. If we are
> moving the value to an RCU accessible attribute we should just be
> using that value. We can only use that check if we are in an rtnl_lock
> anyway and we won't need that if we are just displaying the value.
>=20
> The checks should only be used to verify the tc of the queue is within
> the bounds of the num_tc of the xps_map.

Right. So that would mean we have to choose between:

- Removing the rtnl lock but with the understanding that the value we
  get when reading the maps might be invalid and not make sense with
  the current dev->num_tc configuration.

- Keeping the rtnl lock (which, I mean, I'd like to remove).

My first goal for embedding num_tc in the maps was to prevent accessing
the maps out-of-bound when dev->num_tc is updated after the maps are
allocated. That's a possibility (I could produce such behaviour with
KASAN enabled) even when taking the rtnl lock in the show/store helpers.

We're now talking of also removing the rtnl lock, which is fine, I just
want to make those two different goals explicit as they're not
interdependent.

> > > > > I think Jakub had mentioned earlier the idea of possibly moving s=
ome
> > > > > fields into the xps_cpus_map and xps_rxqs_map in order to reduce =
the
> > > > > complexity of this so that certain values would be protected by t=
he
> > > > > RCU lock.
> > > > >
> > > > > This might be a good time to look at encoding things like the num=
ber
> > > > > of IDs and the number of TCs there in order to avoid a bunch of t=
his
> > > > > duplication. Then you could just pass a pointer to the map you wa=
nt to
> > > > > display and the code should be able to just dump the values.:
> > > >
> > > > 100% agree to all the above. That would also prevent from making ou=
t of
> > > > bound accesses when dev->num_tc is increased after dev_maps is
> > > > allocated. I do have a series ready to be send storing num_tc into =
the
> > > > maps, and reworking code to use it instead of dev->num_tc. The seri=
es
> > > > also adds checks to ensure the map is valid when we access it (such=
 as
> > > > making sure dev->num_tc =3D=3D map->num_tc). I however did not move=
 nr_ids
> > > > into the map yet, but I'll look into it.
> > > >
> > > > The idea is to send it as a follow up series, as this one is only m=
oving
> > > > code around to improve maintenance and readability. Even if all the
> > > > patches were in the same series that would be a prerequisite.
> > >
> > > Okay, so if we are going to do it as a follow-up that is fine I
> > > suppose, but one of the reasons I brought it up is that it would help
> > > this patch set in terms of readability/maintainability. An additional
> > > change we could look at making would be to create an xps_map pointer
> > > array instead of having individual pointers. Then you could simply be
> > > passing an index into the array to indicate if we are accessing the
> > > CPUs or the RXQs map.
> >
> > Merging the two maps and embedding an offset in the struct? With the
> > upcoming changes embedding information in the map themselves we should
> > have a single check to know what map to use. Using a single array with
> > offsets would not improve that. Also maps maintenance when num_tc
> > is updated would need to take care of both maps, having side effects
> > such as removing the old rxqs map when allocating the cpus one (or the
> > opposite).
>=20
> Sorry, I didn't mean to merge the two maps. Just go from two pointers
> to an array containing two pointers. Right now them sitting right next
> to each other it becomes pretty easy to just convert them so that
> instead of accessing them as:
>=20
> dev->xps_rxqs_map
> dev->xps_cpus_map
>=20
> You could instead access them as:
> dev->xps_map[XPS_RXQ];
> dev->xps_map[XPS_CPU];
>=20
> Then instead of all the if/else logic we have in the code you just are
> passing the index of the xps_map you want to access and we have the
> nr_ids and num_tc all encoded in the map so the code itself. Then for
> displaying we are just using the fields from the map to validate.
>=20
> We will still end up needing to take the rtnl_lock for the
> __netif_set_xps_queue case, however that should be the only case where
> we really need it as we have to re-read dev->num_tc and the
> netdev_txq_to_tc and guarantee they don't change while we are
> programming the map.

Thanks for the detailed explanations. That indeed would be good.

> That reminds me we may want to add an ASSERT_RTNL to the start of
> __netif_set_xps_queue and a comment indicating that we need to hold
> the rtnl lock to guarantee that num_tc and the Tx queue to TC mapping
> cannot change while we are programming the value into the map.

Good idea!

Thanks,
Antoine
