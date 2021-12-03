Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A7746702A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350226AbhLCCud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbhLCCuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:50:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3284C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:47:09 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so4042687pjb.2
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s6ThVRf929wtN1/dfDnByQFffdFdLWwEOcI8wIGwDiU=;
        b=nYXsFL5nNYdhsjf48Ve1dm6GvimQLvyOSjMZElw9WQFgOB9rbCUquRvV/wdmOoNX9H
         0AWhAhN+GshiHBnLgzZc/en7DUEjZFTfDyRJbjTa/w88NJ+BXwEYY6dASDOaft72q1pR
         c+tBheM7sXMOsq7Ix1R/BtiWPFBlR2F1sFcWw81UjoaxIWucXshjG3oNqshJhJOHa3Z/
         nf4I4SfgMjqsRll7+ePd/5Y7hIJMiHaxs4FvXv5ciEdg6QvZd8Paso5CqEmhTUfb5Y78
         u01ZMEyL8DDaDMTdvgoeb865SjXxTOcQemx8NTQNJg928gPtYRImDs/o2GtbCazlbuLI
         ro1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s6ThVRf929wtN1/dfDnByQFffdFdLWwEOcI8wIGwDiU=;
        b=S47By++RunPD+fXpYdUutWt/j/LpP+eD9ODIlWBjfL8Vryq0b5iZEsJFDi1guKdv+3
         DhdgJU5oxS8MxvLSPZFr5uI090P9iOBAyozWHiFVj58ht9d94TQktBwXvDEUJ02ZMG0t
         jpb5hOHcUX579XDvSWYioAgUodv5hDCne/glFSXQUlR+gLArAK71/49CEeBea851b2hN
         b1Qkw2XCWAHKJ+qzBEeRbJ8Zbi5K2ZawRJMr+cEt5m6Dh+C6n8o8uIP2eVrM0Jcp5q6C
         xoIs6uJAFsSQwnqCTlL6Us9myhNZin7wQmVhzFVyitU+NniK0gBRIhpEGtlfOQ0TJ6BS
         0azw==
X-Gm-Message-State: AOAM530YjeRQWTkiwkzDXSJ1ooeeV4uNgNwmvHlrMB65+IDBxQRo9iQh
        683D+3LZb/8TwsXa7gp1rqdOuIjnQHc=
X-Google-Smtp-Source: ABdhPJxQpoageCgzm6pVt2+7ezMhPSzehI2Az5MWqvZ907WftGkYmtEWZFIgtvgXp0XvqjApzmtZyw==
X-Received: by 2002:a17:902:ce85:b0:141:de7d:514e with SMTP id f5-20020a170902ce8500b00141de7d514emr19824276plg.0.1638499629289;
        Thu, 02 Dec 2021 18:47:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:47:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 00/23] net: add preliminary netdev refcount tracking
Date:   Thu,  2 Dec 2021 18:46:17 -0800
Message-Id: <20211203024640.1180745-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Two first patches add a generic infrastructure, that will be used
to get tracking of refcount increments/decrements.

The general idea is to be able to precisely pair each decrement with
a corresponding prior increment. Both share a cookie, basically
a pointer to private data storing stack traces.

The third place adds dev_hold_track() and dev_put_track() helpers
(CONFIG_NET_DEV_REFCNT_TRACKER)

Then a series of 20 patches converts some dev_hold()/dev_put()
pairs to new hepers : dev_hold_track() and dev_put_track().

Hopefully this will be used by developpers and syzbot to
root cause bugs that cause netdevice dismantles freezes.

With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
some class of bugs, but too late (when too many dev_put()
were happening).

v2: added four additional patches,
    added netdev_tracker_alloc() and netdev_tracker_free()
    addressed build error (kernel bots),
    use GFP_ATOMIC in test_ref_tracker_timer_func()

Eric Dumazet (23):
  lib: add reference counting tracking infrastructure
  lib: add tests for reference tracker
  net: add dev_hold_track() and dev_put_track() helpers
  net: add net device refcount tracker to struct netdev_rx_queue
  net: add net device refcount tracker to struct netdev_queue
  net: add net device refcount tracker to ethtool_phys_id()
  net: add net device refcount tracker to dev_ifsioc()
  drop_monitor: add net device refcount tracker
  net: dst: add net device refcount tracking to dst_entry
  ipv6: add net device refcount tracker to rt6_probe_deferred()
  sit: add net device refcount tracking to ip_tunnel
  ipv6: add net device refcount tracker to struct ip6_tnl
  net: add net device refcount tracker to struct neighbour
  net: add net device refcount tracker to struct pneigh_entry
  net: add net device refcount tracker to struct neigh_parms
  net: add net device refcount tracker to struct netdev_adjacent
  ipv6: add net device refcount tracker to struct inet6_dev
  ipv4: add net device refcount tracker to struct in_device
  net/sched: add net device refcount tracker to struct Qdisc
  net: linkwatch: add net device refcount tracker
  net: failover: add net device refcount tracker
  ipmr, ip6mr: add net device refcount tracker to struct vif_device
  netpoll: add net device refcount tracker to struct netpoll

 drivers/net/netconsole.c    |   2 +-
 include/linux/inetdevice.h  |   2 +
 include/linux/mroute_base.h |   1 +
 include/linux/netdevice.h   |  66 +++++++++++++++++
 include/linux/netpoll.h     |   1 +
 include/linux/ref_tracker.h |  73 +++++++++++++++++++
 include/net/devlink.h       |   3 +
 include/net/dst.h           |   1 +
 include/net/failover.h      |   1 +
 include/net/if_inet6.h      |   1 +
 include/net/ip6_tunnel.h    |   1 +
 include/net/ip_tunnels.h    |   3 +
 include/net/neighbour.h     |   3 +
 include/net/sch_generic.h   |   2 +-
 lib/Kconfig                 |   5 ++
 lib/Kconfig.debug           |  10 +++
 lib/Makefile                |   4 +-
 lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
 lib/test_ref_tracker.c      | 115 +++++++++++++++++++++++++++++
 net/Kconfig                 |   8 +++
 net/core/dev.c              |  10 ++-
 net/core/dev_ioctl.c        |   5 +-
 net/core/drop_monitor.c     |   6 +-
 net/core/dst.c              |   8 +--
 net/core/failover.c         |   4 +-
 net/core/link_watch.c       |   4 +-
 net/core/neighbour.c        |  18 ++---
 net/core/net-sysfs.c        |   8 +--
 net/core/netpoll.c          |   4 +-
 net/ethtool/ioctl.c         |   5 +-
 net/ipv4/devinet.c          |   4 +-
 net/ipv4/ipmr.c             |   3 +-
 net/ipv4/route.c            |   7 +-
 net/ipv6/addrconf.c         |   4 +-
 net/ipv6/addrconf_core.c    |   2 +-
 net/ipv6/ip6_gre.c          |   8 +--
 net/ipv6/ip6_tunnel.c       |   4 +-
 net/ipv6/ip6_vti.c          |   4 +-
 net/ipv6/ip6mr.c            |   3 +-
 net/ipv6/route.c            |  10 +--
 net/ipv6/sit.c              |   4 +-
 net/sched/sch_generic.c     |   4 +-
 42 files changed, 509 insertions(+), 62 deletions(-)
 create mode 100644 include/linux/ref_tracker.h
 create mode 100644 lib/ref_tracker.c
 create mode 100644 lib/test_ref_tracker.c

-- 
2.34.1.400.ga245620fadb-goog

