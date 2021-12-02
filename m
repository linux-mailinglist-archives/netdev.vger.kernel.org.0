Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52184465CA3
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355130AbhLBDZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbhLBDZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:25:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D3EC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:21:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so1328178pjb.5
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IO0g7gLSaXX850+/ZAobSsgNhp5z622yJu9tcLhOCro=;
        b=kB9j+PuIZCWQKLbwvbrJWVyZAcc8WyTITqY3MJpDBxJ3Qz6YB7TynF0d66XZYvY0Jo
         nioVVyJsq85RtTQrrYDkNm3G2wPxEvLAbzNVyuYwEqVDsaunTvSbdA0+79MKbxG7UWp0
         HcDSx+K5pIvi/ppji2ogqmMtvMqZwup9nTJpYROdHJoYFXIlrYCD/hKdxtQgNeas3A/i
         dYbJ7XQBqr8+7ZRUZ35407Cr//esG1eh90ZYbd4O/n+DjNBTibmsXS2n5gORGNr2LjFf
         C8PiP+H2bmh4VyQL10dvQk2D2OCbIZZDzbwIzMIj8FoUY9GDcl1dWag4khQrr2Vneg0b
         7NHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IO0g7gLSaXX850+/ZAobSsgNhp5z622yJu9tcLhOCro=;
        b=Gn1vnYqSPASrAbgEOXkDgWlxqk6rRC1qByd9x/B9w+7JA/b/P7NBG//riTPpeHwP4A
         GdHRwKl75F/NcM4TJ6IaNyyeMpvoIwUNN7IT0qt9rhrBM1PoUXSUfgrCnkNeG0y1eOgD
         81IWvhxY6VGTndeH3Kp3sG8Do9QbXtZRBm3Q6dPYEpUWkUm2JotzCK+7ImDiLIC/pC7E
         SwA0QxkFDD+uuqGgsNN+KZ4Wclzn62E9b0ShHkb7p5p0prXMpUFULn0Fx0vbCuQkQgDS
         kcHoyd44DJW942ow/TT+7MOM1bMEUozdEVM+ULprIpKwmEh9Pq53TYV2dH7HZqR340YA
         2QpA==
X-Gm-Message-State: AOAM532OqF1CItn9rtqm1t/w3dNHSFNGibSiTgXZAsptMNYIzjCbD8Ev
        5XbQ0liEJyocXWp88lVahBk=
X-Google-Smtp-Source: ABdhPJwlngnZdGyXtr8Q2BtuG2ASShMkWm0tW9+LVVybZ0DUGQojdDt62edwhc/adeSD/NPUWgW9uQ==
X-Received: by 2002:a17:90b:4d8f:: with SMTP id oj15mr2828740pjb.127.1638415307291;
        Wed, 01 Dec 2021 19:21:47 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:21:46 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 00/19] net: add preliminary netdev refcount tracking
Date:   Wed,  1 Dec 2021 19:21:20 -0800
Message-Id: <20211202032139.3156411-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
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

Then a series of 17 patches converts some dev_hold()/dev_put()
pairs to new hepers : dev_hold_track() and dev_put_track().

Hopefully this will be used by developpers and syzbot to
root cause bugs that cause netdevice dismantles freezes.

With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
some class of bugs, but too late (when too many dev_put()
were happening).

Eric Dumazet (19):
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

 include/linux/inetdevice.h  |   2 +
 include/linux/netdevice.h   |  53 ++++++++++++++
 include/linux/ref_tracker.h |  73 +++++++++++++++++++
 include/net/devlink.h       |   3 +
 include/net/dst.h           |   1 +
 include/net/if_inet6.h      |   1 +
 include/net/ip6_tunnel.h    |   1 +
 include/net/ip_tunnels.h    |   3 +
 include/net/neighbour.h     |   3 +
 include/net/sch_generic.h   |   2 +-
 lib/Kconfig                 |   4 ++
 lib/Kconfig.debug           |  10 +++
 lib/Makefile                |   4 +-
 lib/ref_tracker.c           | 140 ++++++++++++++++++++++++++++++++++++
 lib/test_ref_tracker.c      | 116 ++++++++++++++++++++++++++++++
 net/Kconfig                 |   8 +++
 net/core/dev.c              |  10 ++-
 net/core/dev_ioctl.c        |   5 +-
 net/core/drop_monitor.c     |   4 +-
 net/core/dst.c              |   8 +--
 net/core/neighbour.c        |  18 ++---
 net/core/net-sysfs.c        |   8 +--
 net/ethtool/ioctl.c         |   5 +-
 net/ipv4/devinet.c          |   4 +-
 net/ipv4/route.c            |   7 +-
 net/ipv6/addrconf.c         |   4 +-
 net/ipv6/addrconf_core.c    |   2 +-
 net/ipv6/ip6_gre.c          |   8 +--
 net/ipv6/ip6_tunnel.c       |   4 +-
 net/ipv6/ip6_vti.c          |   4 +-
 net/ipv6/route.c            |  10 +--
 net/ipv6/sit.c              |   4 +-
 net/sched/sch_generic.c     |   4 +-
 33 files changed, 481 insertions(+), 52 deletions(-)
 create mode 100644 include/linux/ref_tracker.h
 create mode 100644 lib/ref_tracker.c
 create mode 100644 lib/test_ref_tracker.c

-- 
2.34.0.rc2.393.gf8c9666880-goog

