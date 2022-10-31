Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2DA6136A6
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiJaMmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiJaMmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:42:52 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED691D2EB
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:50 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so7930133wmb.3
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=27jiGBRkKA9KVsu+9TEtFs5XoMhm35d52CGzAYnTh6g=;
        b=2CcpRxK5VuCTEhqsRyMrSF8VeFTgPBCMBvUXv+cEeNqZu05OHywqk5XzZ/rqCOLVIx
         fXl0QpsAavV296IbZUewLvQOuORrfPeT5nRhOzL5j6BpKMq3yUNqMhu9W4SM29ZOh2t1
         CIU6GwOVlCbnoVqAjcLWTyzyk4nUhw8hx2FORyhhJ8JQI4gIJ+dXZLC3jiAjbzTpamY1
         uKDeWS9qEp7fXKHmRFXSIWCDSEpP7Cffz99g2lJ10O+4oBgmj5OHCJxyve35S4u4B0Be
         PwtAqHOQg5aUr+6lEAnv2vCaaiu8io8N8vC9O8XPqoHdAU6l2NW1H1lIKZT6e/MsBsZ7
         VGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=27jiGBRkKA9KVsu+9TEtFs5XoMhm35d52CGzAYnTh6g=;
        b=5hDrUHpU6VD8Zn9rO5w44cUPlWCrxCZ8b9mCMt2+ert1mUUIgjQIEdXa35SRXjRsmA
         EkuEvmv63TCk4mZ7hK9ZxBSwiv4elP+tAQXQtOZzugU8glVjR2O3TOcw9GjWOlCXttUx
         ZtFRwZ5J9DeSfaAimX//yxXaVsK5NRF9xsEyYaQBh8t7NKSdgBjOCaOC1PtuiYYvm6N5
         9400qBNgVvlTulXmG5J+mRMVhdFY4DZGWJbsUksWFwRGCNCLjXTfAgjX7RAQ72Q7v1kY
         2gGoshWRIsNJGSPsRLKvZGBAlpS//ITcXJeUTJj35suI9udD/wZtcoENLBRXEfK+zzS8
         M+4Q==
X-Gm-Message-State: ACrzQf1dMq+oZouICYRaqsKCaxV7Wc7ZmWs0LbTSERV0Rky47Dy427a9
        XS+pOavO+QiRA4Bj93F6F1XeA2JWBGhUBNGA
X-Google-Smtp-Source: AMsMyM6AvUfHo2kQiXs45niXwce4oPtw18jQpOxzOPA+wEiBUIoDMm54Fux4J+weugaLkwkcyMKV7A==
X-Received: by 2002:a05:600c:a4c:b0:3b4:fc1b:81 with SMTP id c12-20020a05600c0a4c00b003b4fc1b0081mr7790068wmq.125.1667220169438;
        Mon, 31 Oct 2022 05:42:49 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bd26-20020a05600c1f1a00b003c6b70a4d69sm7153511wmb.42.2022.10.31.05.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:42:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 00/13] net: fix netdev to devlink_port linkage and expose to user
Date:   Mon, 31 Oct 2022 13:42:35 +0100
Message-Id: <20221031124248.484405-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
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
v2->v3:
- see patch 6 for a changelog
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
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |   9 -
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
 42 files changed, 292 insertions(+), 390 deletions(-)

-- 
2.37.3

