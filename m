Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF424670DA
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350923AbhLCDuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:50:03 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:59645 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350809AbhLCDuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:50:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UzEPI.U_1638503195;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UzEPI.U_1638503195)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Dec 2021 11:46:35 +0800
Date:   Fri, 3 Dec 2021 11:46:34 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH net-next 00/19] net: add preliminary netdev refcount
 tracking
Message-ID: <20211203034634.GB27989@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
 <20211202124915.GA27989@linux.alibaba.com>
 <CANn89iJrvR3Fh2yhn0qkxVcmWO4LucRG6jNt_utMpxWN1GRD9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJrvR3Fh2yhn0qkxVcmWO4LucRG6jNt_utMpxWN1GRD9w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 07:13:12AM -0800, Eric Dumazet wrote:
>On Thu, Dec 2, 2021 at 4:49 AM dust.li <dust.li@linux.alibaba.com> wrote:
>>
>> On Wed, Dec 01, 2021 at 07:21:20PM -0800, Eric Dumazet wrote:
>> >From: Eric Dumazet <edumazet@google.com>
>> >
>> >Two first patches add a generic infrastructure, that will be used
>> >to get tracking of refcount increments/decrements.
>> >
>> >The general idea is to be able to precisely pair each decrement with
>> >a corresponding prior increment. Both share a cookie, basically
>> >a pointer to private data storing stack traces.
>> >
>> >Then a series of 17 patches converts some dev_hold()/dev_put()
>> >pairs to new hepers : dev_hold_track() and dev_put_track().
>> >
>> >Hopefully this will be used by developpers and syzbot to
>> >root cause bugs that cause netdevice dismantles freezes.
>>
>> Hi Eric:
>>
>> I really like the idea of adding debug informantion for debugging
>> refcnt problems, we have met some bugs of leaking netdev refcnt in
>> the past and debugging them is really HARD !!
>>
>> Recently, when investigating a sk_refcnt double free bug in SMC,
>> I added some debug code a bit similar like this. I'm curious have
>> you considered expanding the ref tracker infrastructure into other
>> places like sock_hold/put() or even some hot path ?
>
>Sure, this should be absolutely doable with this generic infra.
>
>>
>> AFAIU, ref tracker add a tracker inside each object who want to
>> hold a refcnt, and stored the callstack into the tracker.
>> I have 2 questions here:
>> 1. If we want to use this in the hot path, looks like the overhead
>>    is a bit heavy ?
>
>Much less expensive than lockdep (we use one spinlock per struct
>ref_tracker_dir), so I think this is something doable.

Yeah, I'm thinking enable this feature by default in our kernel
so I care about this won't bring regression.
I did a simple test in case this might be helpful to other.

Testing was triggered by test_ref_tracker.ko run on a Intel Xeon server.
Added the following debug code:

@@ -12,8 +13,14 @@ struct ref_tracker {
        bool                    dead;
        depot_stack_handle_t    alloc_stack_handle;
        depot_stack_handle_t    free_stack_handle;
+       unsigned long long      lat;
 };

+static void dump_tracker_latency(struct ref_tracker *tracker)
+{
+       printk("tracker %pK alloc cost(ns): %llu\n", tracker, tracker->lat);
+}
+
 void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
 {
        struct ref_tracker *tracker, *n;
@@ -23,6 +30,7 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
        spin_lock_irqsave(&dir->lock, flags);
        list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
                list_del(&tracker->head);
+               dump_tracker_latency(tracker);
                kfree(tracker);
                dir->quarantine_avail++;
        }
 ...
 }

@@ -70,7 +78,9 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
        struct ref_tracker *tracker;
        unsigned int nr_entries;
        unsigned long flags;
+       unsigned long long t;

+       t = sched_clock();
        *trackerp = tracker = kzalloc(sizeof(*tracker), gfp | __GFP_NOFAIL);
        if (unlikely(!tracker)) {
                pr_err_once("memory allocation failure, unreliable refcount tracker.\n");
@@ -84,6 +94,7 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
        spin_lock_irqsave(&dir->lock, flags);
        list_add(&tracker->head, &dir->list);
        spin_unlock_irqrestore(&dir->lock, flags);
+       tracker->lat = sched_clock() - t;
        return 0;
 }

result:
[   13.187325] tracker ffff888113285980 alloc cost(ns): 3488
[   13.188050] tracker ffff888113285800 alloc cost(ns): 2612
[   13.188760] tracker ffff888113285940 alloc cost(ns): 2763
[   13.189482] tracker ffff888113285bc0 alloc cost(ns): 1063
[   13.190227] tracker ffff888113285340 alloc cost(ns): 982
[   13.190933] tracker ffff888113285f80 alloc cost(ns): 883
[   13.191638] tracker ffff888113285080 alloc cost(ns): 1006
[   13.192355] tracker ffff888113285cc0 alloc cost(ns): 1007
[   13.193105] tracker ffff888113285dc0 alloc cost(ns): 901
[   13.193811] tracker ffff8881132858c0 alloc cost(ns): 882
[   13.194522] tracker ffff888113285e40 alloc cost(ns): 1000
[   13.195253] tracker ffff888113285a00 alloc cost(ns): 896
[   13.195973] tracker ffff888113285ac0 alloc cost(ns): 903
[   13.196673] tracker ffff888113285c80 alloc cost(ns): 893
[   13.197384] tracker ffff888113285d00 alloc cost(ns): 1220
[   13.198130] tracker ffff888113285140 alloc cost(ns): 979
[   13.198858] tracker ffff888113285180 alloc cost(ns): 893
[   13.199571] tracker ffff8881132850c0 alloc cost(ns): 893

The average cost for a ref_tracker_alloc() is about 0.9us
And most of the time is spent in stack_trace_save().

I'm not sure whether __builtin_return_address(0) is enough ?


>
>> 2. Since we only store 1 callstack in 1 tracker, what if some object
>>    want to hold and put refcnt in different places ?
>
>
>You can use a tracker on the stack (patch 6/19 net: add net device
>refcount tracker to ethtool_phys_id())
>
>For generic uses of dev_hold(), like in dev_get_by_index(), we will
>probably have new helpers
>so that callers can provide where the tracker is put.
>
>Or simply use this sequence to convert a generic/untracked reference
>to a tracked one.
>
>dev = dev_get_by_index(),;
>...
>
>p->dev = dev;
>dev_hold_track(dev, &p->dev_tracker, GFP...)
>dev_put(dev);

Yeah, I see. This looks good for netdev.
For sock_hold/put, I feel it's more complicate, I'm not sure if we
need add lots of tracker.

>
>
>>
>> Thanks.
>>
>> >
>> >With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
>> >some class of bugs, but too late (when too many dev_put()
>> >were happening).
>> >
>> >Eric Dumazet (19):
>> >  lib: add reference counting tracking infrastructure
>> >  lib: add tests for reference tracker
>> >  net: add dev_hold_track() and dev_put_track() helpers
>> >  net: add net device refcount tracker to struct netdev_rx_queue
>> >  net: add net device refcount tracker to struct netdev_queue
>> >  net: add net device refcount tracker to ethtool_phys_id()
>> >  net: add net device refcount tracker to dev_ifsioc()
>> >  drop_monitor: add net device refcount tracker
>> >  net: dst: add net device refcount tracking to dst_entry
>> >  ipv6: add net device refcount tracker to rt6_probe_deferred()
>> >  sit: add net device refcount tracking to ip_tunnel
>> >  ipv6: add net device refcount tracker to struct ip6_tnl
>> >  net: add net device refcount tracker to struct neighbour
>> >  net: add net device refcount tracker to struct pneigh_entry
>> >  net: add net device refcount tracker to struct neigh_parms
>> >  net: add net device refcount tracker to struct netdev_adjacent
>> >  ipv6: add net device refcount tracker to struct inet6_dev
>> >  ipv4: add net device refcount tracker to struct in_device
>> >  net/sched: add net device refcount tracker to struct Qdisc
>> >
>> > include/linux/inetdevice.h  |   2 +
>> > include/linux/netdevice.h   |  53 ++++++++++++++
>> > include/linux/ref_tracker.h |  73 +++++++++++++++++++
>> > include/net/devlink.h       |   3 +
>> > include/net/dst.h           |   1 +
>> > include/net/if_inet6.h      |   1 +
>> > include/net/ip6_tunnel.h    |   1 +
>> > include/net/ip_tunnels.h    |   3 +
>> > include/net/neighbour.h     |   3 +
>> > include/net/sch_generic.h   |   2 +-
>> > lib/Kconfig                 |   4 ++
>> > lib/Kconfig.debug           |  10 +++
>> > lib/Makefile                |   4 +-
>> > lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
>> > lib/test_ref_tracker.c      | 116 ++++++++++++++++++++++++++++++
>> > net/Kconfig                 |   8 +++
>> > net/core/dev.c              |  10 ++-
>> > net/core/dev_ioctl.c        |   5 +-
>> > net/core/drop_monitor.c     |   4 +-
>> > net/core/dst.c              |   8 +--
>> > net/core/neighbour.c        |  18 ++---
>> > net/core/net-sysfs.c        |   8 +--
>> > net/ethtool/ioctl.c         |   5 +-
>> > net/ipv4/devinet.c          |   4 +-
>> > net/ipv4/route.c            |   7 +-
>> > net/ipv6/addrconf.c         |   4 +-
>> > net/ipv6/addrconf_core.c    |   2 +-
>> > net/ipv6/ip6_gre.c          |   8 +--
>> > net/ipv6/ip6_tunnel.c       |   4 +-
>> > net/ipv6/ip6_vti.c          |   4 +-
>> > net/ipv6/route.c            |  10 +--
>> > net/ipv6/sit.c              |   4 +-
>> > net/sched/sch_generic.c     |   4 +-
>> > 33 files changed, 481 insertions(+), 52 deletions(-)
>> > create mode 100644 include/linux/ref_tracker.h
>> > create mode 100644 lib/ref_tracker.c
>> > create mode 100644 lib/test_ref_tracker.c
>> >
>> >--
>> >2.34.0.rc2.393.gf8c9666880-goog
