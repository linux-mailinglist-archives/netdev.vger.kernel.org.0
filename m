Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88453314AE1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhBIIxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhBIIsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 03:48:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E5264E54;
        Tue,  9 Feb 2021 08:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612860439;
        bh=456eyc6udFP1z4U/1wq9wdI6Rc+mlsp8W2ZoiAWFm6s=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=qBJkxIH/ri/7qTgHMTy0K/KEaiKA52phYxZWekOM++5KkYiMyukpH5jjquL8KXyFw
         0JgqaOveuPyk2NvUGahFcnX7sDfm+bAN5CRL0YQ0W57FpCpw1MMwxYCpLu/KHaMM5F
         BB5zQyq+tDt9q0HFhVPu3qpqIG4YCbXpcFnOOfIR5xgkoQ0ZHHEvFuN1I83yRCK5cf
         fnnpRscqW2KGmCl6EmQdTbZdq1UrwX9v6K1+l1MEDFpb/isFJIURdjW/3PebqkPCIm
         Iz8iS2uFWdRFOG0/SQkS/m3ewkNh4QfdH1OVpxXjanBgPMH8WOu8S7DaT3LyCGDiTc
         Th4ZOGidWQxZQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0Ue1mYiuP1-qAovV4WwUrJ_k2Ug0tB+syzzHRtHeMiz7ww@mail.gmail.com>
References: <20210208171917.1088230-1-atenart@kernel.org> <20210208171917.1088230-8-atenart@kernel.org> <CAKgT0Ue1mYiuP1-qAovV4WwUrJ_k2Ug0tB+syzzHRtHeMiz7ww@mail.gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next v2 07/12] net: remove the xps possible_mask
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Message-ID: <161286043568.5645.13230167254226736235@kwain.local>
Date:   Tue, 09 Feb 2021 09:47:15 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Alexander Duyck (2021-02-08 22:43:39)
> On Mon, Feb 8, 2021 at 9:19 AM Antoine Tenart <atenart@kernel.org> wrote:
> >
> > -static void clean_xps_maps(struct net_device *dev, const unsigned long=
 *mask,
> > +static void clean_xps_maps(struct net_device *dev,
> >                            struct xps_dev_maps *dev_maps, u16 offset, u=
16 count,
> >                            bool is_rxqs_map)
> >  {
> > -       unsigned int nr_ids =3D dev_maps->nr_ids;
> >         bool active =3D false;
> >         int i, j;
> >
> > -       for (j =3D -1; j =3D netif_attrmask_next(j, mask, nr_ids), j < =
nr_ids;)
> > -               active |=3D remove_xps_queue_cpu(dev, dev_maps, j, offs=
et,
> > -                                              count);
> > +       for (j =3D 0; j < dev_maps->nr_ids; j++)
> > +               active |=3D remove_xps_queue_cpu(dev, dev_maps, j, offs=
et, count);
> >         if (!active)
> >                 reset_xps_maps(dev, dev_maps, is_rxqs_map);
> >
> > -       if (!is_rxqs_map) {
> > -               for (i =3D offset + (count - 1); count--; i--) {
> > +       if (!is_rxqs_map)
> > +               for (i =3D offset + (count - 1); count--; i--)
> >                         netdev_queue_numa_node_write(
> > -                               netdev_get_tx_queue(dev, i),
> > -                               NUMA_NO_NODE);
> > -               }
> > -       }
> > +                               netdev_get_tx_queue(dev, i), NUMA_NO_NO=
DE);
> >  }
>=20
> This violates the coding-style guide for the kernel. The if statement
> should still have braces as the for loop and
> netdev_queue_numa_node_write are more than a single statement. I'd be
> curious to see if checkpatch also complains about this because it
> probably should.

You're right, I'll remove that change to comply with the coding style.

I reran checkpatch, even with --strict, and it did not complain. Maybe
because it's a rework, not strictly new code.

Thanks,
Antoine
