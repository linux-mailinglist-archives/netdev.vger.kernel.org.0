Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A251A2ECC14
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 09:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbhAGIzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 03:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbhAGIzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 03:55:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47A532313B;
        Thu,  7 Jan 2021 08:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610009665;
        bh=FtqVSUgdaxf6+JYUvu+inUHS11JLGFu2ssQmVg0Z45U=;
        h=In-Reply-To:References:To:Cc:From:Subject:Date:From;
        b=iV7Db2+RGMqV2TqsgWxNWDvchbAapULFxpR+rmi8M+/jHiZcDjQFN+dr/f8yf/yPt
         KIBuuEbvhk2Vz+ygDAIp9qB5HocxM97pRjNg53N8rPwVJ4LY2+Ezirp03Sw/aq2i+k
         x8uk5qcophL1C5c4951lEyMes9q4rsMvg4gjLVT0S90xdSb7oh+p2/7liqfNXXh0qQ
         swX2u7Bht3WA4e3WalQdrFyHvMtQnvoDCQ020Gsb52Yz8MKD35ijdvDKZPwZXyWxar
         96R7bRVURknRl3nixjYwghzFAqWDk6eQ964FTgEaUmYdqIAl/Y+ylJx0QnMlXZERdG
         vl1RTxCCD9rcg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com>
References: <20210106180428.722521-1-atenart@kernel.org> <20210106180428.722521-4-atenart@kernel.org> <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a common function
Message-ID: <161000966161.3275.12891261917424414122@kwain.local>
Date:   Thu, 07 Jan 2021 09:54:21 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Alexander Duyck (2021-01-06 20:54:11)
> On Wed, Jan 6, 2021 at 10:04 AM Antoine Tenart <atenart@kernel.org> wrote:
> > +/* Should be called with the rtnl lock held. */
> > +static int xps_queue_show(struct net_device *dev, unsigned long **mask,
> > +                         unsigned int index, bool is_rxqs_map)
>=20
> Why pass dev and index instead of just the queue which already
> contains both?

Right, I can do that.

> I think it would make more sense to just stick to passing the queue
> through along with a pointer to the xps_dev_maps value that we need to
> read.

That would require to hold rcu_read_lock in the caller and I'd like to
keep it in that function.

> >         if (dev->num_tc) {
> >                 /* Do not allow XPS on subordinate device directly */
> >                 num_tc =3D dev->num_tc;
> > -               if (num_tc < 0) {
> > -                       ret =3D -EINVAL;
> > -                       goto err_rtnl_unlock;
> > -               }
> > +               if (num_tc < 0)
> > +                       return -EINVAL;
> >
> >                 /* If queue belongs to subordinate dev use its map */
> >                 dev =3D netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> >
> >                 tc =3D netdev_txq_to_tc(dev, index);
> > -               if (tc < 0) {
> > -                       ret =3D -EINVAL;
> > -                       goto err_rtnl_unlock;
> > -               }
> > +               if (tc < 0)
> > +                       return -EINVAL;
> >         }
> >
>=20
> So if we store the num_tc and nr_ids in the dev_maps structure then we
> could simplify this a bit by pulling the num_tc info out of the
> dev_map and only asking the Tx queue for the tc in that case and
> validating it against (tc <0 || num_tc <=3D tc) and returning an error
> if either are true.
>=20
> This would also allow us to address the fact that the rxqs feature
> doesn't support the subordinate devices as you could pull out the bit
> above related to the sb_dev and instead call that prior to calling
> xps_queue_show so that you are operating on the correct device map.
>=20
> > -       mask =3D bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
> > -       if (!mask) {
> > -               ret =3D -ENOMEM;
> > -               goto err_rtnl_unlock;
> > +       rcu_read_lock();
> > +
> > +       if (is_rxqs_map) {
> > +               dev_maps =3D rcu_dereference(dev->xps_rxqs_map);
> > +               nr_ids =3D dev->num_rx_queues;
> > +       } else {
> > +               dev_maps =3D rcu_dereference(dev->xps_cpus_map);
> > +               nr_ids =3D nr_cpu_ids;
> > +               if (num_possible_cpus() > 1)
> > +                       possible_mask =3D cpumask_bits(cpu_possible_mas=
k);
> >         }
>=20
> I think Jakub had mentioned earlier the idea of possibly moving some
> fields into the xps_cpus_map and xps_rxqs_map in order to reduce the
> complexity of this so that certain values would be protected by the
> RCU lock.
>=20
> This might be a good time to look at encoding things like the number
> of IDs and the number of TCs there in order to avoid a bunch of this
> duplication. Then you could just pass a pointer to the map you want to
> display and the code should be able to just dump the values.:

100% agree to all the above. That would also prevent from making out of
bound accesses when dev->num_tc is increased after dev_maps is
allocated. I do have a series ready to be send storing num_tc into the
maps, and reworking code to use it instead of dev->num_tc. The series
also adds checks to ensure the map is valid when we access it (such as
making sure dev->num_tc =3D=3D map->num_tc). I however did not move nr_ids
into the map yet, but I'll look into it.

The idea is to send it as a follow up series, as this one is only moving
code around to improve maintenance and readability. Even if all the
patches were in the same series that would be a prerequisite.

Thanks!
Antoine
