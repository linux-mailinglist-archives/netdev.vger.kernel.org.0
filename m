Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B562BB2A22
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfINGqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38968 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfINGqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so4321330wml.4
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9oX6DFqAtM8bIdXfz5uv+V9DaiG+OCO6l7gDfPf3xfg=;
        b=GvEvRYJRf0MVYMM0myjZnnPG7UWu5Lfa21z7IksPxpcI9aObLEdMRRSjJnXtroko44
         BYOTGY25rQ7gf2E6rD4biqyMIlUOk4dfdpvpE0c1tinExY12Y8jGtkqjL1FHrfAHQjtD
         YB4KzEh7PZge3QhrL2NkSPCB6FngSw4gsRAe2749APSy7ibTNV5BmbhQUrnk5xUhTRN6
         kQR+sEgNZ4PtTelwXtL77WDV8iyGhAIzUBYGTuPuwPBE2uiqVKSNZFdSPmY9deYWmT3/
         ipjibzFrkB1Dz/Dd5nnudN4j+L52CCJMxQFows6N/M43O4YOq4brAqns8e8xBw4poVVa
         l/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9oX6DFqAtM8bIdXfz5uv+V9DaiG+OCO6l7gDfPf3xfg=;
        b=OwEvDO+Zsf55rwmhkTSeQ/T0wGbm2XmF5vU9wIM+Ptmi0RIOhTz3dm/sUM2XlIgGzT
         9un3BkXWHUmLa3PLlSYYZWn4qGumSOp9v2XtnDVJTX5Z71HFRU91OaePYYcNF49qkDqx
         LH7TcRRTUi8nO54CBFNaIhaceOAnH5t1l2YkaE9wPTj5B6TUxhXNtSTIThSz7SESXMJG
         j/Q7HMSS5+gXHGSdzOnSq82KVhsJo/mKmLeBwp4tMSv3+1Oi88ZLHUfX8vD2rnWBPtpu
         LkzEooJvR/aZg2lyfGGzLU2o2SZXKKDTXtbdKAnpemLdxoJbk/b3rqgI+PcVTPnFEb3d
         AV5Q==
X-Gm-Message-State: APjAAAUdKrMNNzyX66IlWN4s/cOL/j7ZbZHMVWZCfOrKLA5hZzcV56ED
        iL3D7dRxmM8bnQPKMrcFA7KOML+XvNk=
X-Google-Smtp-Source: APXvYqy941i6tGR20qISmpKoSvvf9nly9//gVufvxuNrumfbM3I2D0qsRCivBbPpPKyBLHnhcN161g==
X-Received: by 2002:a1c:a7c6:: with SMTP id q189mr5682493wme.22.1568443569587;
        Fri, 13 Sep 2019 23:46:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a205sm9317454wmd.44.2019.09.13.23.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:09 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 00/15] devlink: allow devlink instances to change network namespace
Date:   Sat, 14 Sep 2019 08:45:53 +0200
Message-Id: <20190914064608.26799-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Devlink from the beginning counts with network namespaces, but the
instances has been fixed to init_net.

Implement change of network namespace as part of "devlink reload"
procedure like this:

$ ip netns add testns1
$ devlink/devlink dev reload netdevsim/netdevsim10 netns testns1

This command reloads device "netdevsim10" into network
namespace "testns1".

Note that "devlink reload" reinstantiates driver objects, effectively it
reloads the driver instance, including possible hw reset etc. Newly
created netdevices respect the network namespace of the parent devlink
instance and according to that, they are created in target network
namespace.

Driver is able to refuse to be reloaded into different namespace. That
is the case of mlx4 right now.

FIB entries and rules are replayed during FIB notifier registration
which is triggered during reload (driver instance init). FIB notifier
is also registered to the target network namespace, that allows user
to use netdevsim devlink resources to setup per-namespace limits of FIB
entries and FIB rules. In fact, with multiple netdevsim instances
in each network namespace, user might setup different limits.
This maintains and extends current netdevsim resources behaviour.

Patch 1 prepares netdevsim code for the follow-up changes in the
patchset. It does not change the behaviour, only moves pet-init_netns
accounting to netdevsim instance, which is also in init_netns.

Patches 2-5 prepare the FIB notifier making it per-netns and to behave
correctly upon error conditions.

Patch 6 just exports a devlink_net helper so it can be used in drivers.

Patches 7-9 do preparations in mlxsw driver.

Patches 10-13 do preparations in netdevsim driver, namely patch 12
implements proper devlink reload where the driver instance objects are
actually re-created as they should be.

Patch 14 actually implements the possibility to reload into a different
network namespace.

Patch 15 adds needed selftests for devlink reload into namespace for
netdevsim driver.

Jiri Pirko (15):
  netdevsim: change fib accounting and limitations to be per-device
  net: fib_notifier: make FIB notifier per-netns
  net: fib_notifier: propagate possible error during fib notifier
    registration
  mlxsw: spectrum_router: Don't rely on missing extack to symbolize dump
  net: fib_notifier: propagate extack down to the notifier block
    callback
  net: devlink: export devlink net getter
  mlxsw: spectrum: Take devlink net instead of init_net
  mlxsw: Register port netdevices into net of core
  mlxsw: Propagate extack down to register_fib_notifier()
  netdevsim: add all ports in nsim_dev_create() and del them in
    destroy()
  netdevsim: implement proper devlink reload
  netdevsim: register port netdevices into net of device
  netdevsim: take devlink net instead of init_net
  net: devlink: allow to change namespaces during reload
  selftests: netdevsim: add tests for devlink reload with resources

 drivers/net/ethernet/mellanox/mlx4/main.c     |   4 +
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |   9 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  13 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  12 +-
 drivers/net/ethernet/mellanox/mlxsw/i2c.c     |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   9 +-
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  57 ++-
 .../mellanox/mlxsw/spectrum_switchdev.c       |   2 +-
 .../net/ethernet/mellanox/mlxsw/switchib.c    |   3 +-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   4 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   9 +-
 drivers/net/netdevsim/dev.c                   | 341 +++++++++---------
 drivers/net/netdevsim/fib.c                   | 175 +++++----
 drivers/net/netdevsim/netdev.c                |  10 +-
 drivers/net/netdevsim/netdevsim.h             |  15 +-
 include/linux/mroute_base.h                   |  26 +-
 include/net/devlink.h                         |   1 +
 include/net/fib_notifier.h                    |  12 +-
 include/net/fib_rules.h                       |   3 +-
 include/net/ip6_fib.h                         |  11 +-
 include/net/ip_fib.h                          |  11 +-
 include/uapi/linux/devlink.h                  |   4 +
 net/core/devlink.c                            | 158 +++++++-
 net/core/fib_notifier.c                       |  95 +++--
 net/core/fib_rules.c                          |  23 +-
 net/ipv4/fib_notifier.c                       |  13 +-
 net/ipv4/fib_rules.c                          |   5 +-
 net/ipv4/fib_trie.c                           |  44 ++-
 net/ipv4/ipmr.c                               |  13 +-
 net/ipv4/ipmr_base.c                          |  30 +-
 net/ipv6/fib6_notifier.c                      |  11 +-
 net/ipv6/fib6_rules.c                         |   5 +-
 net/ipv6/ip6_fib.c                            |  50 ++-
 net/ipv6/ip6mr.c                              |  13 +-
 .../drivers/net/netdevsim/devlink.sh          | 120 +++++-
 39 files changed, 848 insertions(+), 489 deletions(-)

-- 
2.21.0

