Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CA3344DAC
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhCVRqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230262AbhCVRqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:46:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B25616196F;
        Mon, 22 Mar 2021 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616435160;
        bh=zInLZ1Xahm8K8GuVdWarkN9y+boGpr3kiPI2r242OKU=;
        h=In-Reply-To:References:To:Subject:Cc:From:Date:From;
        b=d9F1LsA4lzZbNRKp5w8vRRK1x8JHPEmikHhLepO3LM/yv7Sdw9yaAwQDkEHQ0WNIj
         RFAkxd5a2XEP2eiQz8f3m5A7B1odCAAibYHgQG9rWsfSETNyHYI+P9WIaNRXugrWGr
         JjnUQvVAl7U/bRYDZcjWWp9wbfcMg84UW2IfGB/RVo45Cci/sroIXqd1GQ5bA+c3hj
         eOr5uBfT0Xtwov950CaFWm+C+D1RZTJqlrK45cSQn7hjqR7fvmSXsAUSQTF9ReiL82
         Y6C+6kTZCwsnRwQI8vsfMdUdUHYzOOUUkktenq4x7bkXo9miKNvsl6x4uBROJ0ofiC
         PadRbIpQQMZXw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <161643489069.6320.12260867980480523074@kwain.local>
References: <20210322154329.340048-1-atenart@kernel.org> <20210322165439.GR1719932@casper.infradead.org> <161643489069.6320.12260867980480523074@kwain.local>
To:     Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH net-next] net-sysfs: remove possible sleep from an RCU read-side critical section
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <161643515720.6320.9889798258686173337@kwain.local>
Date:   Mon, 22 Mar 2021 18:45:57 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Antoine Tenart (2021-03-22 18:41:30)
> Quoting Matthew Wilcox (2021-03-22 17:54:39)
> > On Mon, Mar 22, 2021 at 04:43:29PM +0100, Antoine Tenart wrote:
> > > xps_queue_show is mostly made of an RCU read-side critical section and
> > > calls bitmap_zalloc with GFP_KERNEL in the middle of it. That is not
> > > allowed as this call may sleep and such behaviours aren't allowed in =
RCU
> > > read-side critical sections. Fix this by using GFP_NOWAIT instead.
> >=20
> > This would be another way of fixing the problem that is slightly less
> > complex than my initial proposal, but does allow for using GFP_KERNEL
> > for fewer failures:
> >=20
> > @@ -1366,11 +1366,10 @@ static ssize_t xps_queue_show(struct net_device=
 *dev, unsigned int index,
> >  {
> >         struct xps_dev_maps *dev_maps;
> >         unsigned long *mask;
> > -       unsigned int nr_ids;
> > +       unsigned int nr_ids, new_nr_ids;
> >         int j, len;
> > =20
> > -       rcu_read_lock();
> > -       dev_maps =3D rcu_dereference(dev->xps_maps[type]);
> > +       dev_maps =3D READ_ONCE(dev->xps_maps[type]);
>=20
> Couldn't dev_maps be freed between here and the read of dev_maps->nr_ids
> as we're not in an RCU read-side critical section?

* The first read of dev_maps->nr_ids, happening before rcu_read_lock,
  not the one shown below.

> >         /* Default to nr_cpu_ids/dev->num_rx_queues and do not just ret=
urn 0
> >          * when dev_maps hasn't been allocated yet, to be backward comp=
atible.
> > @@ -1379,10 +1378,18 @@ static ssize_t xps_queue_show(struct net_device=
 *dev, unsigned int index,
> >                  (type =3D=3D XPS_CPUS ? nr_cpu_ids : dev->num_rx_queue=
s);
> > =20
> >         mask =3D bitmap_zalloc(nr_ids, GFP_KERNEL);
> > -       if (!mask) {
> > -               rcu_read_unlock();
> > +       if (!mask)
> >                 return -ENOMEM;
> > -       }
> > +
> > +       rcu_read_lock();
> > +       dev_maps =3D rcu_dereference(dev->xps_maps[type]);
> > +       /* if nr_ids shrank in the meantime, do not overrun array.
> > +        * if it increased, we just won't show the new ones
> > +        */
> > +       new_nr_ids =3D dev_maps ? dev_maps->nr_ids :
> > +                       (type =3D=3D XPS_CPUS ? nr_cpu_ids : dev->num_r=
x_queues);
> > +       if (new_nr_ids < nr_ids)
> > +               nr_ids =3D new_nr_ids;
