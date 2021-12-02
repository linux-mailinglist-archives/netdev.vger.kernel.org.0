Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020AC46663F
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358867AbhLBPQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbhLBPQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:16:47 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07CBC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 07:13:24 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id x32so351079ybi.12
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 07:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvhZli07utXEe+dmByZavWcf1oBj+YvjEg+aYctVD+U=;
        b=GkPUEFMxfsBbFN3InuA2+O3bRtYkSQnm5zNtbEJIumKnq6v7SnelkyKaHFplDWxr4D
         Qj6dxUkV3bRmyVVdBdmGHDzWXNE2E6tf8pMQAwZw9Dj4mrv2LwADo+hC4yVqKbG1Iy8m
         IpgSbhJLIz/DKMpZ3twIXPuHRNg1xSLvD0Gx0+1jsIJRu9j9ojz+4CfGP8iqfMfEVegN
         rQ6o6m3+6OOkYArI9aDA91cLOj4FP9TMa2KpZHHTn4sVYjnGRZ9Wfy3ViS3/QMpUA1NF
         u2BbQ0MIecibYC0YP97nWnnWjiDRNZNcWQHvsbr0T/WRb3QYllYjkbWY+lF8OTh+I6Ao
         kLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvhZli07utXEe+dmByZavWcf1oBj+YvjEg+aYctVD+U=;
        b=x84azuxVtmJDMgIW9qozJ3UJyvoJQTHxLUKG6F6TtjDmwIco8+WJFXtS25C6sp6zKW
         8MZoRxLQf9F/qmT1yN/xKx0dpn3h7R+Ci8QIO7bnbR4ykWgp4FSKy2ojQYdxVAFuBGGY
         C72ZtYv2OZBpo3IMha5Dsi1nElES2mvThNBEJZyMEzoLTYKcaZaMUB0LED23Tz7EVl+g
         aQ9dRpLNtDepc8hoi178uRACF8q1CkhGuSd0KbmzH99UzV0o/AOAxSzvKaaFRzDIVImK
         mHAVNHo13qYBfDnv3SBQVziK0x1JYaeZfOBGAILtjuRIyYC8AP9GcB44SJumggICIVbz
         Sq8g==
X-Gm-Message-State: AOAM530GQ5bwESP2iPxrZSP7lh3ARqqR0ddnP0b2VG9ImXuiVPOHUwyg
        OpmwFv4Hnd23mHwMAwBsxJjcl0pWL/I8lnpvtv1hcA==
X-Google-Smtp-Source: ABdhPJy+gTAMf9aNHxSKH9DWm7Nl7K/wg4RgKOuS7VVGGWCqYffaESec+bpu/O1iLytvuCIQFBR2o5p+ZaPf2ENH6+c=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr17048531ybg.711.1638458003644;
 Thu, 02 Dec 2021 07:13:23 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-1-eric.dumazet@gmail.com> <20211202124915.GA27989@linux.alibaba.com>
In-Reply-To: <20211202124915.GA27989@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 07:13:12 -0800
Message-ID: <CANn89iJrvR3Fh2yhn0qkxVcmWO4LucRG6jNt_utMpxWN1GRD9w@mail.gmail.com>
Subject: Re: [PATCH net-next 00/19] net: add preliminary netdev refcount tracking
To:     dust.li@linux.alibaba.com
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 4:49 AM dust.li <dust.li@linux.alibaba.com> wrote:
>
> On Wed, Dec 01, 2021 at 07:21:20PM -0800, Eric Dumazet wrote:
> >From: Eric Dumazet <edumazet@google.com>
> >
> >Two first patches add a generic infrastructure, that will be used
> >to get tracking of refcount increments/decrements.
> >
> >The general idea is to be able to precisely pair each decrement with
> >a corresponding prior increment. Both share a cookie, basically
> >a pointer to private data storing stack traces.
> >
> >Then a series of 17 patches converts some dev_hold()/dev_put()
> >pairs to new hepers : dev_hold_track() and dev_put_track().
> >
> >Hopefully this will be used by developpers and syzbot to
> >root cause bugs that cause netdevice dismantles freezes.
>
> Hi Eric:
>
> I really like the idea of adding debug informantion for debugging
> refcnt problems, we have met some bugs of leaking netdev refcnt in
> the past and debugging them is really HARD !!
>
> Recently, when investigating a sk_refcnt double free bug in SMC,
> I added some debug code a bit similar like this. I'm curious have
> you considered expanding the ref tracker infrastructure into other
> places like sock_hold/put() or even some hot path ?

Sure, this should be absolutely doable with this generic infra.

>
> AFAIU, ref tracker add a tracker inside each object who want to
> hold a refcnt, and stored the callstack into the tracker.
> I have 2 questions here:
> 1. If we want to use this in the hot path, looks like the overhead
>    is a bit heavy ?

Much less expensive than lockdep (we use one spinlock per struct
ref_tracker_dir), so I think this is something doable.

> 2. Since we only store 1 callstack in 1 tracker, what if some object
>    want to hold and put refcnt in different places ?


You can use a tracker on the stack (patch 6/19 net: add net device
refcount tracker to ethtool_phys_id())

For generic uses of dev_hold(), like in dev_get_by_index(), we will
probably have new helpers
so that callers can provide where the tracker is put.

Or simply use this sequence to convert a generic/untracked reference
to a tracked one.

dev = dev_get_by_index(),;
...

p->dev = dev;
dev_hold_track(dev, &p->dev_tracker, GFP...)
dev_put(dev);


>
> Thanks.
>
> >
> >With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
> >some class of bugs, but too late (when too many dev_put()
> >were happening).
> >
> >Eric Dumazet (19):
> >  lib: add reference counting tracking infrastructure
> >  lib: add tests for reference tracker
> >  net: add dev_hold_track() and dev_put_track() helpers
> >  net: add net device refcount tracker to struct netdev_rx_queue
> >  net: add net device refcount tracker to struct netdev_queue
> >  net: add net device refcount tracker to ethtool_phys_id()
> >  net: add net device refcount tracker to dev_ifsioc()
> >  drop_monitor: add net device refcount tracker
> >  net: dst: add net device refcount tracking to dst_entry
> >  ipv6: add net device refcount tracker to rt6_probe_deferred()
> >  sit: add net device refcount tracking to ip_tunnel
> >  ipv6: add net device refcount tracker to struct ip6_tnl
> >  net: add net device refcount tracker to struct neighbour
> >  net: add net device refcount tracker to struct pneigh_entry
> >  net: add net device refcount tracker to struct neigh_parms
> >  net: add net device refcount tracker to struct netdev_adjacent
> >  ipv6: add net device refcount tracker to struct inet6_dev
> >  ipv4: add net device refcount tracker to struct in_device
> >  net/sched: add net device refcount tracker to struct Qdisc
> >
> > include/linux/inetdevice.h  |   2 +
> > include/linux/netdevice.h   |  53 ++++++++++++++
> > include/linux/ref_tracker.h |  73 +++++++++++++++++++
> > include/net/devlink.h       |   3 +
> > include/net/dst.h           |   1 +
> > include/net/if_inet6.h      |   1 +
> > include/net/ip6_tunnel.h    |   1 +
> > include/net/ip_tunnels.h    |   3 +
> > include/net/neighbour.h     |   3 +
> > include/net/sch_generic.h   |   2 +-
> > lib/Kconfig                 |   4 ++
> > lib/Kconfig.debug           |  10 +++
> > lib/Makefile                |   4 +-
> > lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
> > lib/test_ref_tracker.c      | 116 ++++++++++++++++++++++++++++++
> > net/Kconfig                 |   8 +++
> > net/core/dev.c              |  10 ++-
> > net/core/dev_ioctl.c        |   5 +-
> > net/core/drop_monitor.c     |   4 +-
> > net/core/dst.c              |   8 +--
> > net/core/neighbour.c        |  18 ++---
> > net/core/net-sysfs.c        |   8 +--
> > net/ethtool/ioctl.c         |   5 +-
> > net/ipv4/devinet.c          |   4 +-
> > net/ipv4/route.c            |   7 +-
> > net/ipv6/addrconf.c         |   4 +-
> > net/ipv6/addrconf_core.c    |   2 +-
> > net/ipv6/ip6_gre.c          |   8 +--
> > net/ipv6/ip6_tunnel.c       |   4 +-
> > net/ipv6/ip6_vti.c          |   4 +-
> > net/ipv6/route.c            |  10 +--
> > net/ipv6/sit.c              |   4 +-
> > net/sched/sch_generic.c     |   4 +-
> > 33 files changed, 481 insertions(+), 52 deletions(-)
> > create mode 100644 include/linux/ref_tracker.h
> > create mode 100644 lib/ref_tracker.c
> > create mode 100644 lib/test_ref_tracker.c
> >
> >--
> >2.34.0.rc2.393.gf8c9666880-goog
