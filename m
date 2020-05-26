Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D171B8D3F
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 09:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgDZHRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 03:17:40 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41442 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726194AbgDZHRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 03:17:37 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Apr 2020 10:17:22 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03Q7HMT6023889;
        Sun, 26 Apr 2020 10:17:22 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH 00/16] Add support to get xmit slave
Date:   Sun, 26 Apr 2020 10:17:01 +0300
Message-Id: <20200426071717.17088-1-maorg@mellanox.com>
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
skb of the RoCE packet based on the AH attributes and call to the new
.ndo.

The third part change the mlx5 driver driver to set the QP's affinity
port according to the slave which found by the .ndo.

Thanks

[1]
https://lore.kernel.org/netdev/20200126132126.9981-1-maorg@xxxxxxxxxxxx/

Change log:
v6: patch 1 - Fix commit message and add function description. 
    patch 10 - Keep udata as function argument.
v5: patch 1 - Remove rcu lock.
    patch 10 - Refactor patch that group the AH attributes in struct.
    patch 11 - call the ndo while holding the rcu and initialize xmit_slave.
    patch 12 - Store the xmit slave in rdma_ah_init_attr and qp_attr.

v4: 1. Rename master_get_xmit_slave to netdev_get_xmit_slave and move
the implementation to dev.c 
    2. Remove unnecessary check of NULL pointer.
    3. Fix typo.
v3: 1. Move master_get_xmit_slave to netdevice.h and change the flags
arg.
to bool.
    2. Split helper functions commit to multiple commits for each bond
mode.
    3. Extract refcotring changes to seperate commits.
v2: The first patch wasn't sent in v1.
v1:
https://lore.kernel.org/netdev/ac373456-b838-29cf-645f-b1ea1a93e3b0@xxxxxxxxx/T/#t 

Maor Gottlieb (16):
  net/core: Introduce netdev_get_xmit_slave
  bonding: Export skip slave logic to function
  bonding: Rename slave_arr to usable_slaves
  bonding/alb: Add helper functions to get the xmit slave
  bonding: Add helper function to get the xmit slave based on hash
  bonding: Add helper function to get the xmit slave in rr mode
  bonding: Add function to get the xmit slave in active-backup mode
  bonding: Add array of all slaves
  bonding: Implement ndo_get_xmit_slave
  RDMA: Group create AH arguments in struct
  RDMA/core: Add LAG functionality
  RDMA/core: Get xmit slave for LAG
  net/mlx5: Change lag mutex lock to spin lock
  net/mlx5: Add support to get lag physical port
  RDMA/mlx5: Refactor affinity related code
  RDMA/mlx5: Set lag tx affinity according to slave

 drivers/infiniband/core/Makefile              |   2 +-
 drivers/infiniband/core/lag.c                 | 141 +++++++++
 drivers/infiniband/core/verbs.c               |  58 ++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |   8 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h      |   2 +-
 drivers/infiniband/hw/efa/efa.h               |   3 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   6 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c       |   5 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
 drivers/infiniband/hw/mlx4/ah.c               |  11 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |   2 +-
 drivers/infiniband/hw/mlx5/ah.c               |  14 +-
 drivers/infiniband/hw/mlx5/gsi.c              |  34 ++-
 drivers/infiniband/hw/mlx5/main.c             |   2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   3 +-
 drivers/infiniband/hw/mlx5/qp.c               | 122 +++++---
 drivers/infiniband/hw/mthca/mthca_provider.c  |   9 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |   2 +-
 drivers/infiniband/hw/qedr/verbs.c            |   4 +-
 drivers/infiniband/hw/qedr/verbs.h            |   2 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |   5 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |   2 +-
 drivers/infiniband/sw/rdmavt/ah.c             |  11 +-
 drivers/infiniband/sw/rdmavt/ah.h             |   4 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |   9 +-
 drivers/net/bonding/bond_alb.c                |  39 ++-
 drivers/net/bonding/bond_main.c               | 268 +++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |  66 +++--
 include/linux/mlx5/driver.h                   |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |   4 +-
 include/linux/mlx5/qp.h                       |   2 +
 include/linux/netdevice.h                     |  12 +
 include/net/bond_alb.h                        |   4 +
 include/net/bonding.h                         |   3 +-
 include/rdma/ib_verbs.h                       |  12 +-
 include/rdma/lag.h                            |  23 ++
 net/core/dev.c                                |  22 ++
 38 files changed, 696 insertions(+), 229 deletions(-)
 create mode 100644 drivers/infiniband/core/lag.c
 create mode 100644 include/rdma/lag.h

-- 
2.17.2

