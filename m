Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224BFC8DEF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfJBQMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32857 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfJBQMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so20364483wrs.0
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=64PyjK9hBPS2x0NOeYWPez4C5N5Oe+av4d02EGN33EA=;
        b=UrWdW4AbaEObeC+JZVXprtr3oEWznqdIdbDPijc89iC7XDNt/KwkOE9Uz3q2vcL/VZ
         H/dYi+FghCeGFk4AY5LYCpgR7jlttCwTsUWc7/PDxi9drML90k56BDODqmBOW4mqXvs/
         SiSZ7RKYprh0gDt0Jq24wtyRuadFbtjY/iZNbo+Xs08s/Lw6rL+JDhfsVjatdiG44KJP
         RzHPMYDDQ8VqvD2u4/MinllmiBqyW8tL0WKY9Q7tOC4bvDkQAtZm8tFhykzVOks6Gexl
         umUVZLdSjFGta4oOyhYxLdVruhkBFOm0B28RfLlRjVfgDAQPJ2K5J3719vPFW+LN56Hq
         E39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=64PyjK9hBPS2x0NOeYWPez4C5N5Oe+av4d02EGN33EA=;
        b=KXV1jWGnfdvGaf2QWBKzq5HCdGFmXOZbGB7nq+fV+u/Rb+ONIFWDZUHO/FHFfUonbY
         AICg1fhowzHZU4NRjUHqvUstqv0W/3VdKrxuCPuNs5d1I204UiCyAY9syumShHMyogCe
         QQMJqXPlMjaqyWjnosDiYCr4uclMKcQjbQQ0BYNTFK55mqJl6TxiqUQchiYCMjOUPLYl
         uXUpiaKQhEV53I840u5CavXih8CVVVFkCQML3mG/bUQwSHwzmoCqAnp4BepPJ8T1APXx
         zOZCOxrpU2e3uoFbCBjcgKf+V+LrNMnWQScAs11XpCbiJH5KkMksvXUKR9uYAxrZGae7
         8Deg==
X-Gm-Message-State: APjAAAWVUzQ5dMhSn/Ej63hmzwfI8Jz/ZMFhpk/T0RLR1VRPmBBS4WN2
        oMlscD/ZyIP/XmMyeAJ1oyJdDjqeCn0=
X-Google-Smtp-Source: APXvYqyatF5D5GwxP6BB6FPCoOYHgsTCwfx3v8v4DjDThGXcY0yfRBcAzXfmqG1lMYLVGpC0+0CCmg==
X-Received: by 2002:adf:ea12:: with SMTP id q18mr3611567wrm.323.1570032752228;
        Wed, 02 Oct 2019 09:12:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z1sm38727907wre.40.2019.10.02.09.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 00/15] devlink: allow devlink instances to change network namespace
Date:   Wed,  2 Oct 2019 18:12:16 +0200
Message-Id: <20191002161231.2987-1-jiri@resnulli.us>
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

 drivers/net/ethernet/mellanox/mlx4/main.c     |   6 +-
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |   9 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  14 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  12 +-
 drivers/net/ethernet/mellanox/mlxsw/i2c.c     |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  22 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   9 +-
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  59 ++-
 .../mellanox/mlxsw/spectrum_switchdev.c       |   2 +-
 .../net/ethernet/mellanox/mlxsw/switchib.c    |   3 +-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   4 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   9 +-
 drivers/net/netdevsim/dev.c                   | 350 +++++++++---------
 drivers/net/netdevsim/fib.c                   | 175 +++++----
 drivers/net/netdevsim/netdev.c                |  10 +-
 drivers/net/netdevsim/netdevsim.h             |  15 +-
 include/linux/mroute_base.h                   |  28 +-
 include/net/devlink.h                         |   3 +-
 include/net/fib_notifier.h                    |  13 +-
 include/net/fib_rules.h                       |   3 +-
 include/net/ip6_fib.h                         |  11 +-
 include/net/ip_fib.h                          |  11 +-
 include/uapi/linux/devlink.h                  |   4 +
 net/core/devlink.c                            | 157 +++++++-
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
 39 files changed, 862 insertions(+), 499 deletions(-)

-- 
2.21.0

