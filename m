Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F1480B41
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 16:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfHDOpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 10:45:00 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38466 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDOpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 10:45:00 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so41647803edo.5;
        Sun, 04 Aug 2019 07:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XeyplrnYbEY6zKt90AGW5ERzcZCdMSGch8+Ck0rohmM=;
        b=mxQb+0GUSfL3Ske/EYMGySbfRF05uwNvXKoXL/LcDrDz55FEbSaepCP9u8pOa9h3Zh
         lOPEgSziB5E+p+pY/DXDNhd1rkNBL/iOW2JBvGtJAPs2iTFY07V7SiGsfTzNEFaDuOHG
         ZpwKILbZ2kU0MIQMm1szb/dS50xMX2Gp4uwpnjkFN3VCEHDSCky9H/6dzU/4YUhOK7bR
         b9Hd5gYs5hLljxXHpVUehvbu+RCZtK5j9BxRHoqVHnFpUlnNgU4liZUUuuUZm7p9YmP6
         8l0j4p9nkKTsZIMyGnl0lLmbh+C0dLEV6I4mqRJKkdvD9h3hQBchUltf3oPCXd8y55Lr
         xwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XeyplrnYbEY6zKt90AGW5ERzcZCdMSGch8+Ck0rohmM=;
        b=i7Xl+txZ6XGgmXfYMqqU91zpTCx+3jRtHW4zDaTA7sXSvU2U7onq4q50jKpxHJCxgQ
         IxW+M3ayn0mN4ivNjD6h/4GdO5V9BllNiN1Oyo4jTtL5JfyQhe6cm4W4YcYKWJZ6330n
         YqqTFiV4ZBJJPTOLrY+SqLBUvyhhNXt5EZ7Ncp7CRMs2Yj1olRJoy60fNvJdghZYVScu
         eYVKWDF5DObKz7Pg667YWJyqNYCPYZEwCRG6DGZwxyXmJ2lUestNcwLfTpbKIkn1MFvl
         tLBPv1JXWXOq2dkIPGjN90eb/dptxMgrXp8LvOXbis2abPngXfEhSuD8Q/ib5vU3Y90A
         21dA==
X-Gm-Message-State: APjAAAWcdCtbAmccdb4+4GLR7yS80vuIdD+i36A9l1lnuvK+IDMoeuPf
        6J6Nkl1e8CX7LkaYrr/eNT+qi0YcWUr3IQ/jOIo=
X-Google-Smtp-Source: APXvYqwaCLvc1w1LRp2x19+CU+YzIDgAYpRhh61mmyka90uwqml/vBNDcgKtwXcEd8dz4k5m7ZCEh+0P/x6M8QjvUWo=
X-Received: by 2002:a17:906:4890:: with SMTP id v16mr21845600ejq.296.1564929898159;
 Sun, 04 Aug 2019 07:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190802164828.20243-1-hslester96@gmail.com> <20190804125858.GJ4832@mtr-leonro.mtl.com>
In-Reply-To: <20190804125858.GJ4832@mtr-leonro.mtl.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Sun, 4 Aug 2019 22:44:47 +0800
Message-ID: <CANhBUQ2H5MU0m2xM0AkJGPf7+MJBZ3Eq5rR0kgeOoKRi4q1j6Q@mail.gmail.com>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 4, 2019 at 8:59 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sat, Aug 03, 2019 at 12:48:28AM +0800, Chuhong Yuan wrote:
> > refcount_t is better for reference counters since its
> > implementation can prevent overflows.
> > So convert atomic_t ref counters to refcount_t.
>
> I'm not thrilled to see those automatic conversion patches, especially
> for flows which can't overflow. There is nothing wrong in using atomic_t
> type of variable, do you have in mind flow which will cause to overflow?
>
> Thanks

I have to say that these patches are not done automatically...
Only the detection of problems is done by a script.
All conversions are done manually.

I am not sure whether the flow can cause an overflow.
But I think it is hard to ensure that a data path is impossible
to have problems in any cases including being attacked.

So I think it is better to do this minor revision to prevent
potential risk, just like we have done in mlx5/core/cq.c.

Regards,
Chuhong

> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> > Changes in v2:
> >   - Add #include.
> >
> >  drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> > index b9d4f4e19ff9..148b55c3db7a 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
> > @@ -32,6 +32,7 @@
> >
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/refcount.h>
> >  #include <linux/mlx5/driver.h>
> >  #include <net/vxlan.h>
> >  #include "mlx5_core.h"
> > @@ -48,7 +49,7 @@ struct mlx5_vxlan {
> >
> >  struct mlx5_vxlan_port {
> >       struct hlist_node hlist;
> > -     atomic_t refcount;
> > +     refcount_t refcount;
> >       u16 udp_port;
> >  };
> >
> > @@ -113,7 +114,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
> >
> >       vxlanp = mlx5_vxlan_lookup_port(vxlan, port);
> >       if (vxlanp) {
> > -             atomic_inc(&vxlanp->refcount);
> > +             refcount_inc(&vxlanp->refcount);
> >               return 0;
> >       }
> >
> > @@ -137,7 +138,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
> >       }
> >
> >       vxlanp->udp_port = port;
> > -     atomic_set(&vxlanp->refcount, 1);
> > +     refcount_set(&vxlanp->refcount, 1);
> >
> >       spin_lock_bh(&vxlan->lock);
> >       hash_add(vxlan->htable, &vxlanp->hlist, port);
> > @@ -170,7 +171,7 @@ int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
> >               goto out_unlock;
> >       }
> >
> > -     if (atomic_dec_and_test(&vxlanp->refcount)) {
> > +     if (refcount_dec_and_test(&vxlanp->refcount)) {
> >               hash_del(&vxlanp->hlist);
> >               remove = true;
> >       }
> > --
> > 2.20.1
> >
