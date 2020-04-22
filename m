Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E881B3A59
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgDVIkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:40:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52171 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726520AbgDVIkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:40:05 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Apr 2020 11:39:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03M8dxgc006118;
        Wed, 22 Apr 2020 11:39:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V4 mlx5-next 00/15] Add support to get xmit slave
Date:   Wed, 22 Apr 2020 11:39:36 +0300
Message-Id: <20200422083951.17424-1-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series is a combination of netdev and RDMA, so in order to avoid
conflicts, we would like to ask you to route this series through
mlx5-next shared branch. It is based on v5.7-rc1 tag.

---------------------------------------------------------------------

The following series adds support to get the LAG master xmit slave by
introducing new .ndo - ndo_get_xmit_slave. Every LAG module can
implement it and it first implemented in the bond driver. 
This is follow-up to the RFC discussion [1].

The main motivation for doing this is for drivers that offload part
of the LAG functionality. For example, Mellanox Connect-X hardware
implements RoCE LAG which selects the TX affinity when the resources
are created and port is remapped when it goes down.

The first part of this patchset introduces the new .ndo and add the
support to the bonding module.

The second part adds support to get the RoCE LAG xmit slave by building
skb of the RoCE packet based on the AH attributes and call to the new .ndo.

The third part change the mlx5 driver driver to set the QP's affinity
port according to the slave which found by the .ndo.

Thanks

[1] https://lore.kernel.org/netdev/20200126132126.9981-1-maorg@mellanox.com/

Change log:
v4: 1. Rename master_get_xmit_slave to netdev_get_xmit_slave and move the implementation to dev.c 
    2. Remove unnecessary check of NULL pointer.
    3. Fix typo.
v3: 1. Move master_get_xmit_slave to netdevice.h and change the flags arg.
to bool.
    2. Split helper functions commit to multiple commits for each bond
mode.
    3. Extract refcotring changes to seperate commits.
v2: The first patch wasn't sent in v1.
v1: https://lore.kernel.org/netdev/ac373456-b838-29cf-645f-b1ea1a93e3b0@gmail.com/T/#t 

Maor Gottlieb (15):
  net/core: Introduce netdev_get_xmit_slave
  bonding: Export skip slave logic to function
  bonding: Rename slave_arr to usable_slaves
  bonding/alb: Add helper functions to get the xmit slave
  bonding: Add helper function to get the xmit slave based on hash
  bonding: Add helper function to get the xmit slave in rr mode
  bonding: Add function to get the xmit slave in active-backup mode
  bonding: Add array of all slaves
  bonding: Implement ndo_get_xmit_slave
  RDMA/core: Add LAG functionality
  RDMA/core: Get xmit slave for LAG
  net/mlx5: Change lag mutex lock to spin lock
  net/mlx5: Add support to get lag physical port
  RDMA/mlx5: Refactor affinity related code
  RDMA/mlx5: Set lag tx affinity according to slave

 drivers/infiniband/core/Makefile              |   2 +-
 drivers/infiniband/core/lag.c                 | 138 +++++++++
 drivers/infiniband/core/verbs.c               |  44 ++-
 drivers/infiniband/hw/mlx5/ah.c               |   4 +
 drivers/infiniband/hw/mlx5/gsi.c              |  34 ++-
 drivers/infiniband/hw/mlx5/main.c             |   2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   1 +
 drivers/infiniband/hw/mlx5/qp.c               | 123 +++++---
 drivers/net/bonding/bond_alb.c                |  39 ++-
 drivers/net/bonding/bond_main.c               | 268 +++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |  66 +++--
 include/linux/mlx5/driver.h                   |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |   4 +-
 include/linux/mlx5/qp.h                       |   2 +
 include/linux/netdevice.h                     |   6 +
 include/net/bond_alb.h                        |   4 +
 include/net/bonding.h                         |   3 +-
 include/rdma/ib_verbs.h                       |   2 +
 include/rdma/lag.h                            |  22 ++
 net/core/dev.c                                |  30 ++
 20 files changed, 618 insertions(+), 178 deletions(-)
 create mode 100644 drivers/infiniband/core/lag.c
 create mode 100644 include/rdma/lag.h

-- 
2.17.2

