Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A726166D0
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiKBQCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiKBQCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:15 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139C227FF5
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:14 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t1so7261846wmi.4
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K5Csp1F7tT2maq3CoNLnFsNy6T/C9TeWxfNXgcQONjw=;
        b=ygjUbkToQRsZS7jiDKYT51mtv1lLpL3JUgU5lzVVkSCMnpEx8SGA+8JUia1hy2I2KU
         OeoNhldy/wjvKedh1VlRtXXBJ+HHMjP9+iamnwRE9TO0KcskuH8ivfKoN+gw4AAHmS50
         9subN07ZzN2owi+qDTQv/aLCb7NE4sQGvolDFuHMXd23CK4dCDQypjsWJ3uDIKMZ3BxX
         KFcVRWe3LObzpbaNNyHijcIs5/txkhRcZNIaCihoxNWGTYEwnmVNRjYCS+YfjUzZbQSL
         AQeACrF7hl7/UG+ZorhPlDF0b0GZ0FeGOQCCTXw9d6rTwyUNx3nOOPdtjWw6PWDufQHh
         QZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K5Csp1F7tT2maq3CoNLnFsNy6T/C9TeWxfNXgcQONjw=;
        b=I4uyMMZqI37LwsIjrKGJLBDr4BFPk2KsA5vnoDc15RuxFChqSh+PkitdlGpPS6DN7U
         koe258pnMiAQeJ5ONBS+Uz+YL+OO7IPRIfgAHkRQDeHEpOTvkzWkEcJgk0rYJeAwRmd8
         B0nKk4aTxHoE7A+sG6ixehRLNOfAJEVA0CBeXph1btYZvMYKDqOeYJ9H3KBQo71t8Y4T
         IkzGK83K4O1vWyOfG4LaTS+BP2mE3sq41kGYhv6rpjBVrGt2te/bM4V7UZ1WnfJUJmgS
         QTJW2joipid2auwSTX7TnnyVqhP7qjFyjMRmfhUTRmU50chEi0DxfLz4i1a8Ijpq4OES
         U3Yg==
X-Gm-Message-State: ACrzQf3r5xkhiVqrHXBXoRn9TY3LHGJM+MwzHMm1jNKH1uorb3yiD73R
        VM35QfT7WOym5kQA+HEkUGAhDNULxZsgKavv/So=
X-Google-Smtp-Source: AMsMyM7/k+QTk3CO1s4YhRvoW+mmdY0xMcX8i6X1UhDVIlMSFdjOSJ1LutYWdIm5jYZXpyKs6ltR3w==
X-Received: by 2002:a05:600c:3b11:b0:3c6:c02d:babb with SMTP id m17-20020a05600c3b1100b003c6c02dbabbmr26083029wms.69.1667404932487;
        Wed, 02 Nov 2022 09:02:12 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l20-20020a5d5274000000b0022cbf4cda62sm16378867wrc.27.2022.11.02.09.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 00/13] net: fix netdev to devlink_port linkage and expose to user
Date:   Wed,  2 Nov 2022 17:01:58 +0100
Message-Id: <20221102160211.662752-1-jiri@resnulli.us>
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
v3->v4:
- mostly cosmetics, see patches 5, 6 and 13 for changelogs
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
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  44 +---
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
 include/linux/netdevice.h                     |  24 ++-
 include/net/devlink.h                         |  32 ++-
 include/uapi/linux/if_link.h                  |   2 +
 net/core/dev.c                                |  14 +-
 net/core/devlink.c                            | 203 +++++++++++++-----
 net/core/net-sysfs.c                          |   4 +-
 net/core/rtnetlink.c                          |  39 ++++
 net/dsa/dsa2.c                                |   9 -
 net/dsa/slave.c                               |   9 +-
 net/ethtool/ioctl.c                           |  11 +-
 42 files changed, 293 insertions(+), 391 deletions(-)

-- 
2.37.3

