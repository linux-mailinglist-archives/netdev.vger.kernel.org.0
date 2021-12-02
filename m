Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB494663F5
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358099AbhLBMwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:52:42 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:34532 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358082AbhLBMwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:52:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UzAdAEN_1638449356;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UzAdAEN_1638449356)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Dec 2021 20:49:17 +0800
Date:   Thu, 2 Dec 2021 20:49:15 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 00/19] net: add preliminary netdev refcount
 tracking
Message-ID: <20211202124915.GA27989@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 07:21:20PM -0800, Eric Dumazet wrote:
>From: Eric Dumazet <edumazet@google.com>
>
>Two first patches add a generic infrastructure, that will be used
>to get tracking of refcount increments/decrements.
>
>The general idea is to be able to precisely pair each decrement with
>a corresponding prior increment. Both share a cookie, basically
>a pointer to private data storing stack traces.
>
>Then a series of 17 patches converts some dev_hold()/dev_put()
>pairs to new hepers : dev_hold_track() and dev_put_track().
>
>Hopefully this will be used by developpers and syzbot to
>root cause bugs that cause netdevice dismantles freezes.

Hi Eric:

I really like the idea of adding debug informantion for debugging
refcnt problems, we have met some bugs of leaking netdev refcnt in
the past and debugging them is really HARD !!

Recently, when investigating a sk_refcnt double free bug in SMC,
I added some debug code a bit similar like this. I'm curious have
you considered expanding the ref tracker infrastructure into other
places like sock_hold/put() or even some hot path ?

AFAIU, ref tracker add a tracker inside each object who want to
hold a refcnt, and stored the callstack into the tracker.
I have 2 questions here:
1. If we want to use this in the hot path, looks like the overhead
   is a bit heavy ?
2. Since we only store 1 callstack in 1 tracker, what if some object
   want to hold and put refcnt in different places ?

Thanks.

>
>With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
>some class of bugs, but too late (when too many dev_put()
>were happening).
>
>Eric Dumazet (19):
>  lib: add reference counting tracking infrastructure
>  lib: add tests for reference tracker
>  net: add dev_hold_track() and dev_put_track() helpers
>  net: add net device refcount tracker to struct netdev_rx_queue
>  net: add net device refcount tracker to struct netdev_queue
>  net: add net device refcount tracker to ethtool_phys_id()
>  net: add net device refcount tracker to dev_ifsioc()
>  drop_monitor: add net device refcount tracker
>  net: dst: add net device refcount tracking to dst_entry
>  ipv6: add net device refcount tracker to rt6_probe_deferred()
>  sit: add net device refcount tracking to ip_tunnel
>  ipv6: add net device refcount tracker to struct ip6_tnl
>  net: add net device refcount tracker to struct neighbour
>  net: add net device refcount tracker to struct pneigh_entry
>  net: add net device refcount tracker to struct neigh_parms
>  net: add net device refcount tracker to struct netdev_adjacent
>  ipv6: add net device refcount tracker to struct inet6_dev
>  ipv4: add net device refcount tracker to struct in_device
>  net/sched: add net device refcount tracker to struct Qdisc
>
> include/linux/inetdevice.h  |   2 +
> include/linux/netdevice.h   |  53 ++++++++++++++
> include/linux/ref_tracker.h |  73 +++++++++++++++++++
> include/net/devlink.h       |   3 +
> include/net/dst.h           |   1 +
> include/net/if_inet6.h      |   1 +
> include/net/ip6_tunnel.h    |   1 +
> include/net/ip_tunnels.h    |   3 +
> include/net/neighbour.h     |   3 +
> include/net/sch_generic.h   |   2 +-
> lib/Kconfig                 |   4 ++
> lib/Kconfig.debug           |  10 +++
> lib/Makefile                |   4 +-
> lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
> lib/test_ref_tracker.c      | 116 ++++++++++++++++++++++++++++++
> net/Kconfig                 |   8 +++
> net/core/dev.c              |  10 ++-
> net/core/dev_ioctl.c        |   5 +-
> net/core/drop_monitor.c     |   4 +-
> net/core/dst.c              |   8 +--
> net/core/neighbour.c        |  18 ++---
> net/core/net-sysfs.c        |   8 +--
> net/ethtool/ioctl.c         |   5 +-
> net/ipv4/devinet.c          |   4 +-
> net/ipv4/route.c            |   7 +-
> net/ipv6/addrconf.c         |   4 +-
> net/ipv6/addrconf_core.c    |   2 +-
> net/ipv6/ip6_gre.c          |   8 +--
> net/ipv6/ip6_tunnel.c       |   4 +-
> net/ipv6/ip6_vti.c          |   4 +-
> net/ipv6/route.c            |  10 +--
> net/ipv6/sit.c              |   4 +-
> net/sched/sch_generic.c     |   4 +-
> 33 files changed, 481 insertions(+), 52 deletions(-)
> create mode 100644 include/linux/ref_tracker.h
> create mode 100644 lib/ref_tracker.c
> create mode 100644 lib/test_ref_tracker.c
>
>-- 
>2.34.0.rc2.393.gf8c9666880-goog
