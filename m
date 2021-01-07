Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7EB2ED46E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbhAGQkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbhAGQkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:40:08 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893AFC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 08:38:47 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id m23so6767594ioy.2
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kKJbZQUZ1Fp4dhYLyCuk1zbCb7S7W1G1Z0bPxsRMlo4=;
        b=ZV0ET89MrT30I+SCr7lO5atTLcaOSBOaCaxIPEoB9v2hZEknfv+XjOoVV2HFdpl1e1
         X6DSzb30o0Lx4UTa8lBiZTclq3dZiPA6ilIaN0vL7M9FsF5ZHb7aKLEi0m5t8fsTXEFN
         +Ag2JtvFrfYlAMgmsMeXzvVrOmYp3rYMm7QyFtiCx6vtTBft3u8RC7SlX4pGymqBRRa2
         omyYc3M884obBfaeGDJ1pTazWRklKIOKxYo7c8WKpqZiO6M3b+dwGzzUKGU5wlgt6Cmu
         XTT7BKbsf35fEjqTy2V0uHbv/eKS7tcMldW6HX2GFkyOf/KZBSScXqb2eAwiEc/l1fAJ
         zLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kKJbZQUZ1Fp4dhYLyCuk1zbCb7S7W1G1Z0bPxsRMlo4=;
        b=g+nYL8uuAyJCbCI0/mg1Y0bjaPIK0urblkmttG4ysWxTJ0sPqhsrnsHEF1CKPlUJ0Y
         BxEb5SvlnT5iuc4J7jM+9IZbMfyXxXGOEZjOGN7xOvOEkA25amBAJ621yQwPvKKWMrKC
         Ulq/YeFAPJCJ0fWOTEinmliyrGmz6XnjJt9IWnUt1BIG5Sbn8nZiQb4R7qSoOSMJrhDX
         l046+RroMfeIk2Kz5MFqd4Cyt4Id0dR/L4J/XfED5ZGiYFzK1I6/dx3j8UuAtIZa43UH
         DjvirRW369GYiJLhB2uX0nQHDrhojDUeq3ypgfJJZeJ4CzPHMMp4dRX7GbNavjdqKpYy
         vAdA==
X-Gm-Message-State: AOAM531vmyxGvycQo+12tFOEHcOdhNGIhfCyhzuoXPLN3XI5wJv/0RpZ
        zDPOIjmD/foKs/oaqHESqKDB0+GTHE1MbKY2s00=
X-Google-Smtp-Source: ABdhPJwnpJsbCe3c9MqN8OCfS7Ylj/io5OI2xqhQmx9mKgsjXl4D2JXhiV4LNlxBlqQtrft8KJkVCrB74+cSx2IXJUQ=
X-Received: by 2002:a6b:d007:: with SMTP id x7mr1948481ioa.88.1610037526706;
 Thu, 07 Jan 2021 08:38:46 -0800 (PST)
MIME-Version: 1.0
References: <20210106180428.722521-1-atenart@kernel.org> <20210106180428.722521-4-atenart@kernel.org>
 <CAKgT0UdZs7ER84PmeM5EV6rAKWiqu-5Ma47bh8qf-68fjsfbAw@mail.gmail.com> <161000966161.3275.12891261917424414122@kwain.local>
In-Reply-To: <161000966161.3275.12891261917424414122@kwain.local>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 7 Jan 2021 08:38:35 -0800
Message-ID: <CAKgT0UcFu7pgy96uMhraT7B_JKEwXtVziouXLmZ4rdXPHn91Jg@mail.gmail.com>
Subject: Re: [PATCH net 3/3] net-sysfs: move the xps cpus/rxqs retrieval in a
 common function
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 12:54 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Quoting Alexander Duyck (2021-01-06 20:54:11)
> > On Wed, Jan 6, 2021 at 10:04 AM Antoine Tenart <atenart@kernel.org> wrote:
> > > +/* Should be called with the rtnl lock held. */
> > > +static int xps_queue_show(struct net_device *dev, unsigned long **mask,
> > > +                         unsigned int index, bool is_rxqs_map)
> >
> > Why pass dev and index instead of just the queue which already
> > contains both?
>
> Right, I can do that.

Actually I have to backtrack on that a bit. More on that below.

> > I think it would make more sense to just stick to passing the queue
> > through along with a pointer to the xps_dev_maps value that we need to
> > read.
>
> That would require to hold rcu_read_lock in the caller and I'd like to
> keep it in that function.

Actually you could probably make it work if you were to pass a pointer
to the RCU pointer.

> > >         if (dev->num_tc) {
> > >                 /* Do not allow XPS on subordinate device directly */
> > >                 num_tc = dev->num_tc;
> > > -               if (num_tc < 0) {
> > > -                       ret = -EINVAL;
> > > -                       goto err_rtnl_unlock;
> > > -               }
> > > +               if (num_tc < 0)
> > > +                       return -EINVAL;
> > >
> > >                 /* If queue belongs to subordinate dev use its map */
> > >                 dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> > >
> > >                 tc = netdev_txq_to_tc(dev, index);
> > > -               if (tc < 0) {
> > > -                       ret = -EINVAL;
> > > -                       goto err_rtnl_unlock;
> > > -               }
> > > +               if (tc < 0)
> > > +                       return -EINVAL;
> > >         }
> > >
> >
> > So if we store the num_tc and nr_ids in the dev_maps structure then we
> > could simplify this a bit by pulling the num_tc info out of the
> > dev_map and only asking the Tx queue for the tc in that case and
> > validating it against (tc <0 || num_tc <= tc) and returning an error
> > if either are true.
> >
> > This would also allow us to address the fact that the rxqs feature
> > doesn't support the subordinate devices as you could pull out the bit
> > above related to the sb_dev and instead call that prior to calling
> > xps_queue_show so that you are operating on the correct device map.

It probably would be necessary to pass dev and index if we pull the
netdev_get_tx_queue()->sb_dev bit out and performed that before we
called the xps_queue_show function. Specifically as the subordinate
device wouldn't match up with the queue device so we would be better
off pulling it out first.

> >
> > > -       mask = bitmap_zalloc(nr_cpu_ids, GFP_KERNEL);
> > > -       if (!mask) {
> > > -               ret = -ENOMEM;
> > > -               goto err_rtnl_unlock;
> > > +       rcu_read_lock();
> > > +
> > > +       if (is_rxqs_map) {
> > > +               dev_maps = rcu_dereference(dev->xps_rxqs_map);
> > > +               nr_ids = dev->num_rx_queues;
> > > +       } else {
> > > +               dev_maps = rcu_dereference(dev->xps_cpus_map);
> > > +               nr_ids = nr_cpu_ids;
> > > +               if (num_possible_cpus() > 1)
> > > +                       possible_mask = cpumask_bits(cpu_possible_mask);
> > >         }
> >

I don't think we need the possible_mask check. That is mostly just an
optimization that was making use of an existing "for_each" loop macro.
If we are going to go through 0 through nr_ids then there is no need
for the possible_mask as we can just brute force our way through and
will not find CPU that aren't there since we couldn't have added them
to the map anyway.

> > I think Jakub had mentioned earlier the idea of possibly moving some
> > fields into the xps_cpus_map and xps_rxqs_map in order to reduce the
> > complexity of this so that certain values would be protected by the
> > RCU lock.
> >
> > This might be a good time to look at encoding things like the number
> > of IDs and the number of TCs there in order to avoid a bunch of this
> > duplication. Then you could just pass a pointer to the map you want to
> > display and the code should be able to just dump the values.:
>
> 100% agree to all the above. That would also prevent from making out of
> bound accesses when dev->num_tc is increased after dev_maps is
> allocated. I do have a series ready to be send storing num_tc into the
> maps, and reworking code to use it instead of dev->num_tc. The series
> also adds checks to ensure the map is valid when we access it (such as
> making sure dev->num_tc == map->num_tc). I however did not move nr_ids
> into the map yet, but I'll look into it.
>
> The idea is to send it as a follow up series, as this one is only moving
> code around to improve maintenance and readability. Even if all the
> patches were in the same series that would be a prerequisite.
>
> Thanks!
> Antoine

Okay, so if we are going to do it as a follow-up that is fine I
suppose, but one of the reasons I brought it up is that it would help
this patch set in terms of readability/maintainability. An additional
change we could look at making would be to create an xps_map pointer
array instead of having individual pointers. Then you could simply be
passing an index into the array to indicate if we are accessing the
CPUs or the RXQs map.
