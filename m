Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8C42D0A3D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 06:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgLGFeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 00:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgLGFeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 00:34:36 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [pull request][for-next V2] mlx5-next auxbus support
Date:   Sun,  6 Dec 2020 21:33:49 -0800
Message-Id: <20201207053349.402772-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Jason

v1->v2: Fix compilation warning when compiling with W=1 in the mlx5
patches.

This pull request is targeting net-next and rdma-next branches.

This series provides mlx5 support for auxiliary bus devices.

It starts with a merge commit of tag 'auxbus-5.11-rc1' from
gregkh/driver-core into mlx5-next, then the mlx5 patches that will convert
mlx5 ulp devices (netdev, rdma, vdpa) to use the proper auxbus
infrastructure instead of the internal mlx5 device and interface management
implementation, which Leon is deleting at the end of this patchset.

Link: https://lore.kernel.org/alsa-devel/20201026111849.1035786-1-leon@kernel.org/

Thanks to everyone for the joint effort !

Please pull and let me know if there's any problem.

Thanks,
Saeed.

---

The following changes since commit b65054597872ce3aefbc6a666385eabdf9e288da:

  Linux 5.10-rc6 (2020-11-29 15:50:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 04b222f9577396a8d19bf2937d2a218dc2a3c7ac:

  RDMA/mlx5: Remove IB representors dead code (2020-12-06 07:43:54 +0200)

----------------------------------------------------------------
Dave Ertman (1):
      Add auxiliary bus support

Greg Kroah-Hartman (3):
      driver core: auxiliary bus: move slab.h from include file
      driver core: auxiliary bus: make remove function return void
      driver core: auxiliary bus: minor coding style tweaks

Leon Romanovsky (11):
      Merge tag 'auxbus-5.11-rc1' of https://git.kernel.org/.../gregkh/driver-core into mlx5-next
      net/mlx5: Properly convey driver version to firmware
      net/mlx5_core: Clean driver version and name
      vdpa/mlx5: Make hardware definitions visible to all mlx5 devices
      net/mlx5: Register mlx5 devices to auxiliary virtual bus
      vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus
      net/mlx5e: Connect ethernet part to auxiliary bus
      RDMA/mlx5: Convert mlx5_ib to use auxiliary bus
      net/mlx5: Delete custom device management logic
      net/mlx5: Simplify eswitch mode check
      RDMA/mlx5: Remove IB representors dead code

 Documentation/driver-api/auxiliary_bus.rst         | 234 +++++++++
 Documentation/driver-api/index.rst                 |   1 +
 drivers/base/Kconfig                               |   3 +
 drivers/base/Makefile                              |   1 +
 drivers/base/auxiliary.c                           | 274 ++++++++++
 drivers/infiniband/hw/mlx5/counters.c              |   7 -
 drivers/infiniband/hw/mlx5/ib_rep.c                | 112 ++--
 drivers/infiniband/hw/mlx5/ib_rep.h                |  45 +-
 drivers/infiniband/hw/mlx5/main.c                  | 153 ++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      | 567 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 134 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  41 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  21 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  58 +--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  49 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  33 +-
 drivers/vdpa/mlx5/Makefile                         |   2 +-
 drivers/vdpa/mlx5/net/main.c                       |  76 ---
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  53 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.h                  |  24 -
 include/linux/auxiliary_bus.h                      |  77 +++
 include/linux/mlx5/driver.h                        |  34 +-
 include/linux/mlx5/eswitch.h                       |   8 +-
 .../linux/mlx5/mlx5_ifc_vdpa.h                     |   8 +-
 include/linux/mod_devicetable.h                    |   8 +
 scripts/mod/devicetable-offsets.c                  |   3 +
 scripts/mod/file2alias.c                           |   8 +
 34 files changed, 1413 insertions(+), 650 deletions(-)
 create mode 100644 Documentation/driver-api/auxiliary_bus.rst
 create mode 100644 drivers/base/auxiliary.c
 delete mode 100644 drivers/vdpa/mlx5/net/main.c
 delete mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h
 create mode 100644 include/linux/auxiliary_bus.h
 rename drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h => include/linux/mlx5/mlx5_ifc_vdpa.h (96%)
