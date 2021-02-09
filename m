Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9199314B4B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhBIJQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhBIJMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 04:12:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5471264E3B;
        Tue,  9 Feb 2021 09:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612861935;
        bh=QIjIFDYjsJCXsiZ8vLy10Nr4dW+TAvXYrrX5gd44U6g=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=sTAoBAowLc2XKyKzQ/I5GaEX5WXwtsodRV8fI82KLfDGaJLaQjqWUdjbYFokHMG2f
         VvZvkI/D+1cnn68GO3xlqJkeSM4OFxZbjGcha1CsKHMZznnNG07kx9k0lajP/mVIkv
         ldPYa9QuqlagweuYkknuexYwr2Su+NgcngB8KCr/E8DsjCRarU1O6PnReziK4rSAMa
         oLCToc4EGIJ59FDfc6WS0EZDbJ5JsfCnyv8w3yuuncXAT6EGg7TcGOAhA7blkglvCU
         0Y8JQEuCy4lqWcKdDPvSAWY4jZNCIBzPJQRyMDKBDVnhpprNvjqiCG5S5vPPl7eblD
         BWYGN5hC1Pj0Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0Uc3TePxDd12MQiWtkUmtjnd4CAsrN2U49R1p7wXsvxgRA@mail.gmail.com>
References: <20210208171917.1088230-1-atenart@kernel.org> <20210208171917.1088230-10-atenart@kernel.org> <CAKgT0Uc3TePxDd12MQiWtkUmtjnd4CAsrN2U49R1p7wXsvxgRA@mail.gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next v2 09/12] net-sysfs: remove the rtnl lock when accessing the xps maps
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Message-ID: <161286193169.5645.3845763619163247582@kwain.local>
Date:   Tue, 09 Feb 2021 10:12:11 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Alexander Duyck (2021-02-08 23:20:58)
> On Mon, Feb 8, 2021 at 9:19 AM Antoine Tenart <atenart@kernel.org> wrote:
> > @@ -1328,17 +1328,12 @@ static ssize_t xps_cpus_show(struct netdev_queu=
e *queue,
> >
> >         index =3D get_netdev_queue_index(queue);
> >
> > -       if (!rtnl_trylock())
> > -               return restart_syscall();
> > -
> >         /* If queue belongs to subordinate dev use its map */
> >         dev =3D netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> >
> >         tc =3D netdev_txq_to_tc(dev, index);
> > -       if (tc < 0) {
> > -               ret =3D -EINVAL;
> > -               goto err_rtnl_unlock;
> > -       }
> > +       if (tc < 0)
> > +               return -EINVAL;
> >
> >         rcu_read_lock();
> >         dev_maps =3D rcu_dereference(dev->xps_maps[XPS_CPUS]);
>=20
> So I think we hit a snag here. The sb_dev pointer is protected by the
> rtnl_lock. So I don't think we can release the rtnl_lock until after
> we are done with the dev pointer.
>=20
> Also I am not sure it is safe to use netdev_txq_to_tc without holding
> the lock. I don't know if we ever went through and guaranteed that it
> will always work if the lock isn't held since in theory the device
> could reprogram all the map values out from under us.
>=20
> Odds are we should probably fix traffic_class_show as I suspect it
> probably also needs to be holding the rtnl_lock to prevent any
> possible races. I'll submit a patch for that.

Yet another possible race :-) Good catch, I thought about the one we
fixed already but not this one.

As the sb_dev pointer is protected by the rtnl lock, we'll have to keep
the lock. I'll move that patch at the end of the series (it'll be easier
to add the get_device/put_device logic with the xps_queue_show
function). I'll also move netdev_txq_to_tc out of xps_queue_show, to
call it under the rtnl lock taken.

Thanks,
Antoine
