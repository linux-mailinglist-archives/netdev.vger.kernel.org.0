Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306E546890C
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhLEEZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhLEEZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:25:52 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F8FC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:22:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v23so5255143pjr.5
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qA9SMOI1pfNvKG+eAVqWFyy0k5XbWmdFHg2b1b/ICT8=;
        b=mhRY9teyrylzZjTTVmPmd+8Wv2reexrSng+Ylhe8vDfHPZu0ZFB/6ILGxnEoz2SI3r
         hpBtpio1WkT6sdsD/nzD42uThb+4Snriew5MayyWf4slbiMnkQSqtwm/PIy0lZliHgN7
         x1FuoKImofEU5VmIiTpGn1/ZI5cR5dNO4JxjlSbrxsPA/0QfJnJH8QxEOc+SNyd6orek
         pxarHU0eo1iMxLl0tunHH9XqEF5UoUQrxEd6kJ79fmIP637sHPpgAjMSoA/hYC/kBH4G
         KXIWoIbSH2cg7me8r8rw5zN48oPNSfWXn9MOpOWcKnJzCh8uTLG70uJKg7tkruaGoBIo
         r5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qA9SMOI1pfNvKG+eAVqWFyy0k5XbWmdFHg2b1b/ICT8=;
        b=7fOUMeLL2XK1Yhd4LZ5cd1Iyodw5tWYR4AuqdrmxouNhNfWHTp7uSF3RZglQLozKCd
         Q+89wy+Juw+z0+cNhF9d4HQhyMhrfmaJzx2TyzDd9xsAuD05WZpBm66gQuOKsGJJQs0D
         q20AckbpblO1giQ7yxZZFVAXcpw3bumpFB7aFbLN/ISaTch9voZKA+l7fRSesCnJWuJL
         XxjwNyinWQ4HjVKUSJRYfEWU4jlgWVF0Lv4ONmcaGVGbl9zVoLFCqU116i6bTx2oZRu0
         jUz2AZmJhpTGNgIWCg8PtW5cehfTPT3Ild0TLDGONGyWjPaDgIWst/B/9YQ89SK05yPT
         X4UA==
X-Gm-Message-State: AOAM533tEL5pgzAHxllF097THubjhNv2xee72urGX+qN0SBMABDRBIhT
        /mPVgsDcH6swunUOIcR2fH8RGuhikwE=
X-Google-Smtp-Source: ABdhPJzMD9ncJHlvOQaNyMqrwFT5D2J+/Nju/FFsDymuHnMkrSGYVkDjSZzA1mYtX8sI/Aaujy0MMw==
X-Received: by 2002:a17:90b:155:: with SMTP id em21mr27566062pjb.12.1638678145277;
        Sat, 04 Dec 2021 20:22:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:22:24 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
Date:   Sat,  4 Dec 2021 20:21:54 -0800
Message-Id: <20211205042217.982127-1-eric.dumazet@gmail.com>
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

The third patch adds dev_hold_track() and dev_put_track() helpers
(CONFIG_NET_DEV_REFCNT_TRACKER)

Then a series of 20 patches converts some dev_hold()/dev_put()
pairs to new hepers : dev_hold_track() and dev_put_track().

Hopefully this will be used by developpers and syzbot to
root cause bugs that cause netdevice dismantles freezes.

With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
some class of bugs, but too late (when too many dev_put()
were happening).

Another series will be sent after this one is merged.

v3: moved NET_DEV_REFCNT_TRACKER to net/Kconfig.debug
    added "depends on DEBUG_KERNEL && STACKTRACE_SUPPORT"
    to hopefully get rid of kbuild reports for ARCH=nios2
    Reworded patch 3 changelog.
    Added missing htmldocs (Jakub)

v2: added four additional patches,
    added netdev_tracker_alloc() and netdev_tracker_free()
    addressed build error (kernel bots),
    use GFP_ATOMIC in test_ref_tracker_timer_func()

Eric Dumazet (23):
  lib: add reference counting tracking infrastructure
  lib: add tests for reference tracker
  net: add net device refcount tracker infrastructure
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
 include/linux/mroute_base.h |   2 +
 include/linux/netdevice.h   |  68 ++++++++++++++++++
 include/linux/netpoll.h     |   1 +
 include/linux/ref_tracker.h |  73 +++++++++++++++++++
 include/net/devlink.h       |   4 ++
 include/net/dst.h           |   1 +
 include/net/failover.h      |   1 +
 include/net/if_inet6.h      |   1 +
 include/net/ip6_tunnel.h    |   1 +
 include/net/ip_tunnels.h    |   3 +
 include/net/neighbour.h     |   3 +
 include/net/sch_generic.h   |   2 +-
 lib/Kconfig                 |   5 ++
 lib/Kconfig.debug           |  15 ++++
 lib/Makefile                |   4 +-
 lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
 lib/test_ref_tracker.c      | 115 +++++++++++++++++++++++++++++
 net/Kconfig.debug           |  11 +++
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
 42 files changed, 521 insertions(+), 62 deletions(-)
 create mode 100644 include/linux/ref_tracker.h
 create mode 100644 lib/ref_tracker.c
 create mode 100644 lib/test_ref_tracker.c
 create mode 100644 net/Kconfig.debug

-- 
2.34.1.400.ga245620fadb-goog

