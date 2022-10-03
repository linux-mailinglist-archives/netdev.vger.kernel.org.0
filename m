Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6C5F2F06
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiJCKwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJCKwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:52:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DA95302B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:52:07 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qx23so3161975ejb.11
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 03:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=GNCnYjkABRW8uKtxLeXkdIxb03UC8OqDbAQJ4XfhNiU=;
        b=XB4a5pVpNxqD4VsUUj5iFCW/ZcrGv8sZrwnKBWtMC7k2COIz6L0rkQNuIowi0lL1I5
         Wpepd1a/Ms4sC3Fb2UOn1VTPy1ELTD5eE5K2DBDLQcMzcqYp1EixUIgVHwzioIkT5rBj
         wlpYP0cRP+dAWfy8JXVUs8G+QkGgfsI/JTIgJCD5pGfIfynNnekjTbORI8LaNxm/KUE2
         ZlDroRDp2Wyu9k/4HS3g9tfVPwMhXZWqhRjUGrKnM5TfVaYJSZy1CXMKwQuwPtnC2yIj
         dxNl6bMsI+X/88I48KKuv1Jqj3cj3fkkZulrD0YYp3Kh52uuBSZOavSD6lsQ4c344iO5
         GHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=GNCnYjkABRW8uKtxLeXkdIxb03UC8OqDbAQJ4XfhNiU=;
        b=a65+pF/34wn01/kaAcGigm0jUYYUYNS8F/ppHi+rPCXoX5s220RkRauIC5c5jweKhI
         1ERuqcgteslwT5KMcMpVerizQvFZnFGIQhnhUmpmBNaAB24JLtvv3D6VVc1cBpdgKI6i
         yFG8+52cs29pjBVced8EWlWtD67ELAAHOUkRKmgRTcpZvwcFXRNI1Z6VstXLkYNft4VF
         9KdEsrZyvckg/0AYlKVwKmd4iFn3Z7hTJsm5+QSlQc4I99V0Iwi3W5N4D9ldi+j18eC4
         sIeMja/jOqchiUF0p3a4d0n5eEH8+Z4/yOth3IU03d5cMYg8AcZL+MVKPdaiYNkLxL4g
         lX9w==
X-Gm-Message-State: ACrzQf3qkYLjv0UVYJLeHYwzNJSOVEzVG+Rz06LPJazw/RmTjeeRmhXQ
        1rI4BrKNdOzgfauOvp2wGodoe+qWLO2Z+u2t6AQ=
X-Google-Smtp-Source: AMsMyM60TmGie4JjbBqGnjxbrNuo90DG9zJnZJgtySo7EuyOIYaY9wILwus8yPajPkljQ19h/MBdIA==
X-Received: by 2002:a17:907:3f8b:b0:783:2008:e562 with SMTP id hr11-20020a1709073f8b00b007832008e562mr14841367ejc.261.1664794325574;
        Mon, 03 Oct 2022 03:52:05 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o4-20020a170906768400b0077826b92d99sm5333473ejm.12.2022.10.03.03.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 03:52:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v2 00/13] net: fix netdev to devlink_port linkage and expose to user
Date:   Mon,  3 Oct 2022 12:51:51 +0200
Message-Id: <20221003105204.3315337-1-jiri@resnulli.us>
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

---
v1->v2:
- see patches 5 and 6 for changelogs

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
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  43 +---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  20 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  17 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  16 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  11 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   6 -
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
 include/linux/netdevice.h                     |  24 +-
 include/net/devlink.h                         |  32 ++-
 include/uapi/linux/if_link.h                  |   2 +
 net/core/dev.c                                |  11 +-
 net/core/devlink.c                            | 205 +++++++++++++-----
 net/core/net-sysfs.c                          |   4 +-
 net/core/rtnetlink.c                          |  39 ++++
 net/dsa/dsa2.c                                |   9 -
 net/dsa/slave.c                               |   9 +-
 net/ethtool/ioctl.c                           |  11 +-
 42 files changed, 292 insertions(+), 387 deletions(-)

-- 
2.37.1

