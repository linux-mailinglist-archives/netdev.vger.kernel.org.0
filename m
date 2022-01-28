Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2851849F142
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345536AbiA1Cso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345531AbiA1Cso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:48:44 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977D1C06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:48:43 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id z4so9024018lft.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pubvP/mMvouR5SGFMK73ef92kno2gn9MD1BLWmC68L0=;
        b=B8U/Zflg3bSsexKllQNJP0zkEB7Ahpf6gnxZ2e66RXQ4IO0+U95kszAS2RdLzfL6kJ
         Mcg69RazveOLxMtraa3RJPmk4ONQM6ocZ40iPuMHB177d1xgFWL4ckVpQ/sXHfVZ48FN
         yzx1J+N9JEAX4pWAPmxZZvKvJTD3OanRXH3LILdsmdKz4osNi0i7p1Pt/tqDuOCoKikg
         RYXcWm1WHT63Gxg8n29Z5KaeoLfNLLMzk05cMqEI7ORacRoE6n3BwcEGt4eU6mIznlXU
         HyWKHrvtzjNo5HLLK6K07Pg2XArVgYyXLKnPqQegwWnvEtipvrwhuuXMIqla7fD+bNSV
         O+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pubvP/mMvouR5SGFMK73ef92kno2gn9MD1BLWmC68L0=;
        b=Qh1JGIkpxzzvCbjltK1vlhEXK3IkkY8KAJ6K4s4yQTwsrslnd6FG+2re8WZ+lOS9tz
         dVRcl5OECr8N4KAoCmzz/kqEfc0qwBWJq17nunlDcx3G6qbBemWGWpSRcpJFJ66lb6wO
         iNh8ZbBO8Dic+JePkBjo3W15Kkc81LWNQUIykGFcg5zmwGxdIE0arsPDyUPFRFSrLKlZ
         8AZz1MgtfisnMPxWV1IqFLKoZmbZB3YbZAWFBRo4WxJiK/fnx1LNSqynx8XqVGdMkmDw
         qoS5tIxX7jAciftk/lHmtp7Ec04jxLr1Qo890tuRORSMBj6r/ghFq8mnGSCCuiCUQGc8
         NjcQ==
X-Gm-Message-State: AOAM531qhs8MeyyR/GamEtpIvOTg6lxwmvNJ2C5a1nfJNuGQvrltc6+M
        Av+BuXErFTjBS1H0dgz8lKQ5m+xKReOjLnWgyns67A==
X-Google-Smtp-Source: ABdhPJz1udND7rgCZOpgzYxiXiDz4pwaKreyHOEPrqllumKl6I7433zMjEnSsG/09cl+FDgja9euRPOA43pqIDzMt9w=
X-Received: by 2002:a19:ee13:: with SMTP id g19mr4721398lfb.288.1643338121783;
 Thu, 27 Jan 2022 18:48:41 -0800 (PST)
MIME-Version: 1.0
References: <20220128014303.2334568-1-jannh@google.com> <CANn89iKWaERfs1iW8jVyRZT8K1LwWM9efiRsx8E1U3CDT39dyw@mail.gmail.com>
 <CAG48ez0sXEjePefCthFdhDskCFhgcnrecEn2jFfteaqa2qwDnQ@mail.gmail.com> <CANn89iKmCYq+WBu_S4OvKOXqRSagTg=t8xKq0WC_Rrw+TpKsbw@mail.gmail.com>
In-Reply-To: <CANn89iKmCYq+WBu_S4OvKOXqRSagTg=t8xKq0WC_Rrw+TpKsbw@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 28 Jan 2022 03:48:15 +0100
Message-ID: <CAG48ez2wyQwc5XMKKw8835-4t6+x=X3kPY_CPUqZeh=xQ2krqQ@mail.gmail.com>
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

On Fri, Jan 28, 2022 at 3:25 AM Eric Dumazet <edumazet@google.com> wrote:
> On Thu, Jan 27, 2022 at 6:14 PM Jann Horn <jannh@google.com> wrote:
> > On Fri, Jan 28, 2022 at 3:09 AM Eric Dumazet <edumazet@google.com> wrote:
> > > On Thu, Jan 27, 2022 at 5:43 PM Jann Horn <jannh@google.com> wrote:
> > > >
> > > > I've run into a bug where dev_hold() was being called after
> > > > netdev_wait_allrefs(). But at that point, the device is already going
> > > > away, and dev_hold() can't stop that anymore.
> > > >
> > > > To make such problems easier to diagnose in the future:
> > > >
> > > >  - For CONFIG_PCPU_DEV_REFCNT builds: Recheck in free_netdev() whether
> > > >    the net refcount has been elevated. If this is detected, WARN() and
> > > >    leak the object (to prevent worse consequences from a
> > > >    use-after-free).
> > > >  - For builds without CONFIG_PCPU_DEV_REFCNT: Set the refcount to zero.
> > > >    This signals to the generic refcount infrastructure that any attempt
> > > >    to increment the refcount later is a bug.
> > > >
> > > > Signed-off-by: Jann Horn <jannh@google.com>
> > > > ---
> > > >  net/core/dev.c | 18 +++++++++++++++++-
> > > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index 1baab07820f6..f7916c0d226d 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -9949,8 +9949,18 @@ void netdev_run_todo(void)
> > > >
> > > >                 netdev_wait_allrefs(dev);
> > > >
> > > > +               /* Drop the netdev refcount (which should be 1 at this point)
> > > > +                * to zero. If we're using the generic refcount code, this will
> > > > +                * tell it that any dev_hold() after this point is a bug.
> > > > +                */
> > > > +#ifdef CONFIG_PCPU_DEV_REFCNT
> > > > +               this_cpu_dec(*dev->pcpu_refcnt);
> > > > +               BUG_ON(netdev_refcnt_read(dev) != 0);
> > > > +#else
> > > > +               BUG_ON(!refcount_dec_and_test(&dev->dev_refcnt));
> > > > +#endif
> > > > +
> > > >                 /* paranoia */
> > > > -               BUG_ON(netdev_refcnt_read(dev) != 1);
> > > >                 BUG_ON(!list_empty(&dev->ptype_all));
> > > >                 BUG_ON(!list_empty(&dev->ptype_specific));
> > > >                 WARN_ON(rcu_access_pointer(dev->ip_ptr));
> > > > @@ -10293,6 +10303,12 @@ void free_netdev(struct net_device *dev)
> > > >         free_percpu(dev->xdp_bulkq);
> > > >         dev->xdp_bulkq = NULL;
> > > >
> > > > +       /* Recheck in case someone called dev_hold() between
> > > > +        * netdev_wait_allrefs() and here.
> > > > +        */
> > >
> > > At this point, dev->pcpu_refcnt per-cpu data has been freed already
> > > (CONFIG_PCPU_DEV_REFCNT=y)
> > >
> > > So this should probably crash, or at least UAF ?
> >
> > Oh. Whoops. That's what I get for only testing without CONFIG_PCPU_DEV_REFCNT...
> >
> > I guess a better place to put the new check would be directly after
> > checking for "dev->reg_state == NETREG_UNREGISTERING"? Like this?
> >
> >         if (dev->reg_state == NETREG_UNREGISTERING) {
> >                 ASSERT_RTNL();
> >                 dev->needs_free_netdev = true;
> >                 return;
> >         }
> >
> >         /* Recheck in case someone called dev_hold() between
> >          * netdev_wait_allrefs() and here.
> >          */
> >         if (WARN_ON(netdev_refcnt_read(dev) != 0))
> >                 return; /* leak memory, otherwise we might get UAF */
> >
> >         netif_free_tx_queues(dev);
> >         netif_free_rx_queues(dev);
>
> Maybe another solution would be to leverage the recent dev_hold_track().
>
> We could add a  dead boolean to 'struct  ref_tracker_dir ' (dev->refcnt_tracker)
>
[...]
> @@ -72,6 +73,8 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
>         gfp_t gfp_mask = gfp;
>         unsigned long flags;
>
> +       WARN_ON_ONCE(dir->dead);

When someone is using NET_DEV_REFCNT_TRACKER for slow debugging, they
should also be able to take the performance hit of
CONFIG_PCPU_DEV_REFCNT and rely on the normal increment-from-zero
detection of the generic refcount code, right? (Maybe
NET_DEV_REFCNT_TRACKER should depend on !CONFIG_PCPU_DEV_REFCNT?)

My intent with the extra check in free_netdev() was to get some
limited detection for production systems that don't use
NET_DEV_REFCNT_TRACKER.
