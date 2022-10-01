Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535335F1A15
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiJAGBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJAGBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:01:50 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83C9D4A97
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id rk17so12932363ejb.1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=3UF6B9Awp+vGtj4cPKd5v182qZWF99iVXDSy1FoymlE=;
        b=aeMhJcP3ByEINH3LBYydoD54RuXyfeZiiHO4RYy0mCkOLYuW5/NZ1fdGki6qMqAhGH
         yaZhOrmrFyIZBfk30a7CMoprGlkGaUrTCKzK+NH7xPB9vb/ohsKaKGFydk4ud1fWOHy6
         DytIaQzZZdeD1OgYCtAoPwYUA3L6Pb/3wjbACItlbIq+4/d+kAA1BIJN1fhv6iBXZekw
         gEc43HOXlgGag6nMofME6c/9ZtW5cri7rjo5NGGOs1daeED+3SJo/LOpU2d8TP8Lcy8h
         FYKEz765esYqw01TbFQKWPoqQL6DeOxBL30k7uR28VSAr9C68LPBA2jw+Lp3gnicOCmE
         0vWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=3UF6B9Awp+vGtj4cPKd5v182qZWF99iVXDSy1FoymlE=;
        b=1dj0Tk2PyF4vGzC+v1yIuGODb9vMIFfrzeYzslH3IoxuGMrZdzGBeM6/cl8L/hIRMN
         PhP7v1XadUX86HrroLYYmsNdxIb9j45O22BBYSuuoiLmup/hwhnjHcWX8ebROleHNanX
         N/lUHFQqsVIE7Xtceqxq3KFi47+iA60e/40mli9KyF2AzzKqTj9Sb1slTbzA3/C+B5TM
         2CayLS01T9ZD6n2tNn7dPaq/+0nCSsSR5/OdjkW///SFK5OX/H4wAY0WrwUnLhkJNQqX
         RNWI83IWW7Yh2ihnvMUKbqn+l/16ydH5yEWrXjrT9jn4SJpXplBpDi0mpnwT1LFpdq3p
         WWRg==
X-Gm-Message-State: ACrzQf0pMNEXoYs/toJFh2o/d0WyiiANcTzMf5EJLlhFhjgatXyYEXTC
        /MkLT2XstlsZAtnCK77mM5UszjKLPBiEJpQK
X-Google-Smtp-Source: AMsMyM71py6FQpNGo4HRXP6LEEQOvcs3GOo8bpJDcK3y2Kud1CPox5PFq1d7/m1NQXY4Jrzu2/c0HQ==
X-Received: by 2002:a17:906:5d07:b0:781:c281:f6e4 with SMTP id g7-20020a1709065d0700b00781c281f6e4mr8707026ejt.744.1664604107231;
        Fri, 30 Sep 2022 23:01:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r4-20020aa7cfc4000000b0044f21c69608sm2931796edy.10.2022.09.30.23.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 00/13] net: fix netdev to devlink_port linkage and expose to user
Date:   Sat,  1 Oct 2022 08:01:32 +0200
Message-Id: <20221001060145.3199964-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently, the info about linkage from netdev to the related
devlink_port instance is done using ndo_get_devlink_port().
This is not sufficient, as it is up to the driver to implement it and
some of them don't do that. Also it leads to a lot of unnecessary
boilerplate code in all the drivers.

Instead of that, introduce a possibility for driver to expose this
relationship by new SET_NETDEV_DEVLINK_PORT macro which stores it into
dev->devlink_port. It is ensured by the driver init/fini flows that
the devlink_port pointer does not change during the netdev lifetime.
Devlink port is always registered before netdev register and
unregistered after netdev unregister.

Benefit from this linkage setup and remove explicit calls from driver
to devlink_port_type_eth_set() and clear(). Many of the driver
didn't use it correctly anyway. Let the devlink.c to track associated
netdev events and adjust type and type pointer accordingly. Also
use this events to to keep track on ifname change and remove RTNL lock
taking from devlink_nl_port_fill().

Finally, remove the ndo_get_devlink_port() ndo which is no longer used
and expose devlink_port handle as a new netdev netlink attribute to the
user. That way, during the ifname->devlink_port lookup, userspace app
does not have to dump whole devlink port list and instead it can just
do a simple RTM_GETLINK query.

Jiri Pirko (13):
  net: devlink: convert devlink port type-specific pointers to union
  net: devlink: move port_type_warn_schedule() call to
    __devlink_port_type_set()
  net: devlink: move port_type_netdev_checks() call to
    __devlink_port_type_set()
  net: devlink: take RTNL in port_fill() function only if it is not held
  net: devlink: track netdev with devlink_port assigned
  net: make drivers to use SET_NETDEV_DEVLINK_PORT to set devlink_port
  net: devlink: remove netdev arg from devlink_port_type_eth_set()
  net: devlink: remove net namespace check from devlink_nl_port_fill()
  net: devlink: store copy netdevice ifindex and ifname to allow
    port_fill() without RTNL held
  net: devlink: add not cleared type warning to port unregister
  net: devlink: use devlink_port pointer instead of ndo_get_devlink_port
  net: remove unused ndo_get_devlink_port
  net: expose devlink port over rtnetlink

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  14 +-
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |  11 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
 .../ethernet/fungible/funeth/funeth_main.c    |  13 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  18 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  12 +-
 .../marvell/prestera/prestera_devlink.c       |  17 --
 .../marvell/prestera/prestera_devlink.h       |   5 -
 .../ethernet/marvell/prestera/prestera_main.c |   5 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |  17 --
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |   2 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  41 +---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  20 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  18 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  11 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   1 -
 drivers/net/ethernet/netronome/nfp/nfp_app.h  |   2 -
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  23 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   2 -
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  11 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |   1 -
 drivers/net/ethernet/netronome/nfp/nfp_port.h |   2 -
 .../ethernet/pensando/ionic/ionic_devlink.c   |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  14 +-
 drivers/net/netdevsim/dev.c                   |   2 -
 drivers/net/netdevsim/netdev.c                |  10 +-
 include/linux/netdevice.h                     |  19 +-
 include/net/devlink.h                         |  32 ++-
 include/uapi/linux/if_link.h                  |   2 +
 net/core/dev.c                                |  11 +-
 net/core/devlink.c                            | 205 +++++++++++++-----
 net/core/net-sysfs.c                          |   4 +-
 net/core/rtnetlink.c                          |  39 ++++
 net/dsa/dsa2.c                                |   9 -
 net/dsa/slave.c                               |   9 +-
 net/ethtool/ioctl.c                           |  11 +-
 42 files changed, 286 insertions(+), 381 deletions(-)

-- 
2.37.1

