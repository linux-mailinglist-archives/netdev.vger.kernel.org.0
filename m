Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8470249F0D8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345235AbiA1COn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345211AbiA1COn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:14:43 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED436C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:14:42 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id bu18so8892630lfb.5
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nTdhI81auRz1bNrEEEbeBe4FapnKWzQU4hPHMOHufgw=;
        b=EX7x+T0coZQ88/zpv3+q8LfKGXD/62qoG477FGyG8YHCjnagPHKpDF9KGBDhfA9gnV
         Cj1jR2epJYwzdkuVM2p5WiXe6Yr0nhIE4JK6WhSev2GBU3w9bQ5234qThb76NO/qkYRl
         kECpGekPgbddBmuXSKQUHGfkpG8GAZ3PNHy/WOvtK6ABwrNU9wjJsFnLWYVRb3GdPU5C
         635e8HZol37DX0qY39kEcgDDC4qvFONA0YCVHih1YPEr8hrIlo8IWZhJNwc2smaQiRS3
         CaN2GpU1v1pFpaHGajhZZHG8g4VIfXHZ7DB8FODFHV5jHENt9Lj2fjFgI3WzwowTFMgZ
         EfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nTdhI81auRz1bNrEEEbeBe4FapnKWzQU4hPHMOHufgw=;
        b=6Z4wq3iwdWKnzjtm6oDC9ZqH3aPWlwtGXnE5hdJmk2StoUwLIBy6oRY4+Sss5nP1o8
         96jWLK9POz0qKfaNzq5OgNy+MJVcHMqroPi7nZSr4IRjP/rSFwsdfoyBqmpiL5yYz3E3
         wQNiD8cFm+ORSn9h6fP3iqPQ7xH/Vlk46CgHEi2a5I+/lqkj2DNkBZncr1MX5JW7L5ta
         n5tgbjuedIZmCQ0AXjCcURPcviUIYINRl4T09DKXjjHXmkjWQ8o4LT3hb9Qdk7w4KCuJ
         BmJgouoH4EpEXX+I1z9YILACNWsHUksoLMEQ7Ni6cU7JUZEgzc6W8avqSx7t/WXzKz8u
         ZTHw==
X-Gm-Message-State: AOAM5316Qu7opHbBbIk4J1r5fbSGtmDuUKFond7ywOMsZaBEXNnSkka/
        0SGct9lmsomkwrTzjibdaavE25jurhfGnGaUmcWfBi6X08Y=
X-Google-Smtp-Source: ABdhPJyII+ra7xsTCfogWQRq7B/EkdbZc7WNvAuOZIiJBMT/iF54u8E2s52eHzIKSS5ZV06zOBms2mhJXSp9fBhtCBU=
X-Received: by 2002:a19:ee04:: with SMTP id g4mr4595541lfb.157.1643336080902;
 Thu, 27 Jan 2022 18:14:40 -0800 (PST)
MIME-Version: 1.0
References: <20220128014303.2334568-1-jannh@google.com> <CANn89iKWaERfs1iW8jVyRZT8K1LwWM9efiRsx8E1U3CDT39dyw@mail.gmail.com>
In-Reply-To: <CANn89iKWaERfs1iW8jVyRZT8K1LwWM9efiRsx8E1U3CDT39dyw@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 28 Jan 2022 03:14:14 +0100
Message-ID: <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dev: Detect dev_hold() after netdev_wait_allrefs()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 3:09 AM Eric Dumazet <edumazet@google.com> wrote:
> On Thu, Jan 27, 2022 at 5:43 PM Jann Horn <jannh@google.com> wrote:
> >
> > I've run into a bug where dev_hold() was being called after
> > netdev_wait_allrefs(). But at that point, the device is already going
> > away, and dev_hold() can't stop that anymore.
> >
> > To make such problems easier to diagnose in the future:
> >
> >  - For CONFIG_PCPU_DEV_REFCNT builds: Recheck in free_netdev() whether
> >    the net refcount has been elevated. If this is detected, WARN() and
> >    leak the object (to prevent worse consequences from a
> >    use-after-free).
> >  - For builds without CONFIG_PCPU_DEV_REFCNT: Set the refcount to zero.
> >    This signals to the generic refcount infrastructure that any attempt
> >    to increment the refcount later is a bug.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  net/core/dev.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 1baab07820f6..f7916c0d226d 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -9949,8 +9949,18 @@ void netdev_run_todo(void)
> >
> >                 netdev_wait_allrefs(dev);
> >
> > +               /* Drop the netdev refcount (which should be 1 at this point)
> > +                * to zero. If we're using the generic refcount code, this will
> > +                * tell it that any dev_hold() after this point is a bug.
> > +                */
> > +#ifdef CONFIG_PCPU_DEV_REFCNT
> > +               this_cpu_dec(*dev->pcpu_refcnt);
> > +               BUG_ON(netdev_refcnt_read(dev) != 0);
> > +#else
> > +               BUG_ON(!refcount_dec_and_test(&dev->dev_refcnt));
> > +#endif
> > +
> >                 /* paranoia */
> > -               BUG_ON(netdev_refcnt_read(dev) != 1);
> >                 BUG_ON(!list_empty(&dev->ptype_all));
> >                 BUG_ON(!list_empty(&dev->ptype_specific));
> >                 WARN_ON(rcu_access_pointer(dev->ip_ptr));
> > @@ -10293,6 +10303,12 @@ void free_netdev(struct net_device *dev)
> >         free_percpu(dev->xdp_bulkq);
> >         dev->xdp_bulkq = NULL;
> >
> > +       /* Recheck in case someone called dev_hold() between
> > +        * netdev_wait_allrefs() and here.
> > +        */
>
> At this point, dev->pcpu_refcnt per-cpu data has been freed already
> (CONFIG_PCPU_DEV_REFCNT=y)
>
> So this should probably crash, or at least UAF ?

Oh. Whoops. That's what I get for only testing without CONFIG_PCPU_DEV_REFCNT...

I guess a better place to put the new check would be directly after
checking for "dev->reg_state == NETREG_UNREGISTERING"? Like this?

        if (dev->reg_state == NETREG_UNREGISTERING) {
                ASSERT_RTNL();
                dev->needs_free_netdev = true;
                return;
        }

        /* Recheck in case someone called dev_hold() between
         * netdev_wait_allrefs() and here.
         */
        if (WARN_ON(netdev_refcnt_read(dev) != 0))
                return; /* leak memory, otherwise we might get UAF */

        netif_free_tx_queues(dev);
        netif_free_rx_queues(dev);
