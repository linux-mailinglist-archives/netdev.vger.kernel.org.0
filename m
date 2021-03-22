Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C137C344D9E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhCVRlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232154AbhCVRle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD61D6188B;
        Mon, 22 Mar 2021 17:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616434894;
        bh=rG15/32xC4NYi9XjSvIg0kR1gu+mfrurU3eu176aaKQ=;
        h=In-Reply-To:References:To:Subject:Cc:From:Date:From;
        b=V7RAf3VvCg048v2qiqIpNzPa9B2jHSb1zS+tLABzgMjVURceOu6ejFNt3EZOW68H+
         lVtgybfivgqb2zntdk2D6PWIbzZfQ40dE+j7GcxIs/LsE7SOdgNfNaAMKdyuqp5+Dn
         Z7TYd6oLpz+nOzBNsN14f2yWvMA+3Q60Qj/XwFwD5gHd5EBMzy1EErGg7r6kRlKLmr
         SHPrj0upNoc+uFtHF8hyDWwZP6ylKrL6RNRZnxnpGJSupdmAcFC6ti2qTeSLlgxVk8
         I0HB3A9NLBTHEgt0wBM3+GwrQZVNh+QbuEn35AG+s0Qdk/1fOUKxzghOlINYaBZr/J
         uEN5Lh7BinEmw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210322165439.GR1719932@casper.infradead.org>
References: <20210322154329.340048-1-atenart@kernel.org> <20210322165439.GR1719932@casper.infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH net-next] net-sysfs: remove possible sleep from an RCU read-side critical section
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <161643489069.6320.12260867980480523074@kwain.local>
Date:   Mon, 22 Mar 2021 18:41:30 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Matthew Wilcox (2021-03-22 17:54:39)
> On Mon, Mar 22, 2021 at 04:43:29PM +0100, Antoine Tenart wrote:
> > xps_queue_show is mostly made of an RCU read-side critical section and
> > calls bitmap_zalloc with GFP_KERNEL in the middle of it. That is not
> > allowed as this call may sleep and such behaviours aren't allowed in RCU
> > read-side critical sections. Fix this by using GFP_NOWAIT instead.
>=20
> This would be another way of fixing the problem that is slightly less
> complex than my initial proposal, but does allow for using GFP_KERNEL
> for fewer failures:
>=20
> @@ -1366,11 +1366,10 @@ static ssize_t xps_queue_show(struct net_device *=
dev, unsigned int index,
>  {
>         struct xps_dev_maps *dev_maps;
>         unsigned long *mask;
> -       unsigned int nr_ids;
> +       unsigned int nr_ids, new_nr_ids;
>         int j, len;
> =20
> -       rcu_read_lock();
> -       dev_maps =3D rcu_dereference(dev->xps_maps[type]);
> +       dev_maps =3D READ_ONCE(dev->xps_maps[type]);

Couldn't dev_maps be freed between here and the read of dev_maps->nr_ids
as we're not in an RCU read-side critical section?

>         /* Default to nr_cpu_ids/dev->num_rx_queues and do not just retur=
n 0
>          * when dev_maps hasn't been allocated yet, to be backward compat=
ible.
> @@ -1379,10 +1378,18 @@ static ssize_t xps_queue_show(struct net_device *=
dev, unsigned int index,
>                  (type =3D=3D XPS_CPUS ? nr_cpu_ids : dev->num_rx_queues);
> =20
>         mask =3D bitmap_zalloc(nr_ids, GFP_KERNEL);
> -       if (!mask) {
> -               rcu_read_unlock();
> +       if (!mask)
>                 return -ENOMEM;
> -       }
> +
> +       rcu_read_lock();
> +       dev_maps =3D rcu_dereference(dev->xps_maps[type]);
> +       /* if nr_ids shrank in the meantime, do not overrun array.
> +        * if it increased, we just won't show the new ones
> +        */
> +       new_nr_ids =3D dev_maps ? dev_maps->nr_ids :
> +                       (type =3D=3D XPS_CPUS ? nr_cpu_ids : dev->num_rx_=
queues);
> +       if (new_nr_ids < nr_ids)
> +               nr_ids =3D new_nr_ids;
> =20
>         if (!dev_maps || tc >=3D dev_maps->num_tc)
>                 goto out_no_maps;

My feeling is there is not much value in having a tricky allocation
logic for reads from xps_cpus and xps_rxqs. While we could come up with
something, returning -ENOMEM on memory pressure should be fine.

Antoine
