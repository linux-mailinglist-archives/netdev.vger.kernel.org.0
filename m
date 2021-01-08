Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1673A2EEF23
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbhAHJIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbhAHJIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 04:08:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFA3222248;
        Fri,  8 Jan 2021 09:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610096878;
        bh=ZmEEzMibH+c6iVkmbTACvwiFhVw+RqGFpN/85Ql5SGU=;
        h=In-Reply-To:References:Subject:To:From:Cc:Date:From;
        b=JQ+ur01arKKhiTovPH+Vb1+pyHy4lmtuoDL+12yvA8vHLbXwJku1Ih3QkaBallVeH
         btjtzuyvxz3m+TXf6N9bno9RypAYVQsR5z68LQZT6RZnTxq8kEJLTWI23vql/3VoW+
         ktZs7CE7svbY55XV9cWS+eSPi2AjAqdL6kVsDGL0Jdlo4OY6UvGfZp2Evaof+/Nuz6
         rNy4GDcb+vwHBULlO6F0J4+IiRU4cMjfIcOKvzGP/nDaoMbP2118cNxD5jOWtyFbr/
         I8kplcmN+Vehd5gnQDdsV+s8rFF+KTTbPpPCE/uJ8QRgUyt7kOJ7uPKweRzvCHhIuh
         ao3C9bVRWXhNg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0UcFu7pgy96uMhraT7B_JKEwXtVziouXLmZ4rdXPHn91Jg@mail.gmail.com>
References: <20210106180428.722521-1-atenart@kernel.org> <20210106180428.722521-4-atenart@kernel.org> <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com> <161000966161.3275.12891261917424414122@kwain.local> <CAKgT0UcFu7pgy96uMhraT7B_JKEwXtVziouXLmZ4rdXPHn91Jg@mail.gmail.com>
Subject: Re: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a common function
To:     Alexander Duyck <alexander.duyck@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Message-ID: <161009687495.3394.14011897084392954560@kwain.local>
Date:   Fri, 08 Jan 2021 10:07:55 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Alexander Duyck (2021-01-07 17:38:35)
> On Thu, Jan 7, 2021 at 12:54 AM Antoine Tenart <atenart@kernel.org> wrote:
> >
> > Quoting Alexander Duyck (2021-01-06 20:54:11)
> > > On Wed, Jan 6, 2021 at 10:04 AM Antoine Tenart <atenart@kernel.org> w=
rote:
> >
> > That would require to hold rcu_read_lock in the caller and I'd like to
> > keep it in that function.
>=20
> Actually you could probably make it work if you were to pass a pointer
> to the RCU pointer.

That should work but IMHO that could be easily breakable by future
changes as it's a bit tricky.

> > > >         if (dev->num_tc) {
> > > >                 /* Do not allow XPS on subordinate device directly =
*/
> > > >                 num_tc =3D dev->num_tc;
> > > > -               if (num_tc < 0) {
> > > > -                       ret =3D -EINVAL;
> > > > -                       goto err_rtnl_unlock;
> > > > -               }
> > > > +               if (num_tc < 0)
> > > > +                       return -EINVAL;
> > > >
> > > >                 /* If queue belongs to subordinate dev use its map =
*/
> > > >                 dev =3D netdev_get_tx_queue(dev, index)->sb_dev ? :=
 dev;
> > > >
> > > >                 tc =3D netdev_txq_to_tc(dev, index);
> > > > -               if (tc < 0) {
> > > > -                       ret =3D -EINVAL;
> > > > -                       goto err_rtnl_unlock;
> > > > -               }
> > > > +               if (tc < 0)
> > > > +                       return -EINVAL;
> > > >         }
> > > >
> > >
> > > So if we store the num_tc and nr_ids in the dev_maps structure then we
> > > could simplify this a bit by pulling the num_tc info out of the
> > > dev_map and only asking the Tx queue for the tc in that case and
> > > validating it against (tc <0 || num_tc <=3D tc) and returning an error
> > > if either are true.
> > >
> > > This would also allow us to address the fact that the rxqs feature
> > > doesn't support the subordinate devices as you could pull out the bit
> > > above related to the sb_dev and instead call that prior to calling
> > > xps_queue_show so that you are operating on the correct device map.
>=20
> It probably would be necessary to pass dev and index if we pull the
> netdev_get_tx_queue()->sb_dev bit out and performed that before we
> called the xps_queue_show function. Specifically as the subordinate
> device wouldn't match up with the queue device so we would be better
> off pulling it out first.

While I agree moving the netdev_get_tx_queue()->sb_dev bit out of
xps_queue_show seems like a good idea for consistency, I'm not sure
it'll work: dev->num_tc is not only used to retrieve the number of tc
but also as a condition on not being 0. We have things like:

  // Always done with the original dev.
  if (dev->num_tc) {

      [...]

      // Can be a subordinate dev.
      tc =3D netdev_txq_to_tc(dev, index);
  }

And after moving num_tc in the map, we'll have checks like:

  if (dev_maps->num_tc !=3D dev->num_tc)
      return -EINVAL;

I don't think the subordinate dev holds the same num_tc value as dev.
What's your take on this?

> > > > -       mask =3D bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
> > > > -       if (!mask) {
> > > > -               ret =3D -ENOMEM;
> > > > -               goto err_rtnl_unlock;
> > > > +       rcu_read_lock();
> > > > +
> > > > +       if (is_rxqs_map) {
> > > > +               dev_maps =3D rcu_dereference(dev->xps_rxqs_map);
> > > > +               nr_ids =3D dev->num_rx_queues;
> > > > +       } else {
> > > > +               dev_maps =3D rcu_dereference(dev->xps_cpus_map);
> > > > +               nr_ids =3D nr_cpu_ids;
> > > > +               if (num_possible_cpus() > 1)
> > > > +                       possible_mask =3D cpumask_bits(cpu_possible=
_mask);
> > > >         }
> > >
>=20
> I don't think we need the possible_mask check. That is mostly just an
> optimization that was making use of an existing "for_each" loop macro.
> If we are going to go through 0 through nr_ids then there is no need
> for the possible_mask as we can just brute force our way through and
> will not find CPU that aren't there since we couldn't have added them
> to the map anyway.

I'll remove it then. __netif_set_xps_queue could also benefit from it.

> > > I think Jakub had mentioned earlier the idea of possibly moving some
> > > fields into the xps_cpus_map and xps_rxqs_map in order to reduce the
> > > complexity of this so that certain values would be protected by the
> > > RCU lock.
> > >
> > > This might be a good time to look at encoding things like the number
> > > of IDs and the number of TCs there in order to avoid a bunch of this
> > > duplication. Then you could just pass a pointer to the map you want to
> > > display and the code should be able to just dump the values.:
> >
> > 100% agree to all the above. That would also prevent from making out of
> > bound accesses when dev->num_tc is increased after dev_maps is
> > allocated. I do have a series ready to be send storing num_tc into the
> > maps, and reworking code to use it instead of dev->num_tc. The series
> > also adds checks to ensure the map is valid when we access it (such as
> > making sure dev->num_tc =3D=3D map->num_tc). I however did not move nr_=
ids
> > into the map yet, but I'll look into it.
> >
> > The idea is to send it as a follow up series, as this one is only moving
> > code around to improve maintenance and readability. Even if all the
> > patches were in the same series that would be a prerequisite.
>=20
> Okay, so if we are going to do it as a follow-up that is fine I
> suppose, but one of the reasons I brought it up is that it would help
> this patch set in terms of readability/maintainability. An additional
> change we could look at making would be to create an xps_map pointer
> array instead of having individual pointers. Then you could simply be
> passing an index into the array to indicate if we are accessing the
> CPUs or the RXQs map.

Merging the two maps and embedding an offset in the struct? With the
upcoming changes embedding information in the map themselves we should
have a single check to know what map to use. Using a single array with
offsets would not improve that. Also maps maintenance when num_tc
is updated would need to take care of both maps, having side effects
such as removing the old rxqs map when allocating the cpus one (or the
opposite).

Thanks,
Antoine
