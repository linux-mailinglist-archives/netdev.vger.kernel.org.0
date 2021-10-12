Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579B042A1F7
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbhJLK2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235153AbhJLK2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:28:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B41456101D;
        Tue, 12 Oct 2021 10:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634034400;
        bh=x150KESnW9y0NudUm0jVtADK6sh5MfPdAVLfbM/aWiY=;
        h=From:To:Cc:Subject:Date:From;
        b=LiGUI+8YNYfkLbwdBY8u/p79Jm/iQPdqUK5IhZv7LExcrQ6ATXfHT5iAAtYSGWynz
         kr5ND/0mGrvuK7ubilEw7i7aWoIVqsi7o4xaIrdCU77mwUCR+oVk55gGD5bpoX8l9Y
         PZqg3hvu0olFH0tKpScGwY9n7t1Fqn79fnOrK4He4wVzv+4ufyKy41khjlRq0SfhkA
         kv+PDlLFYDBOHqHT3XXL41SpY8S43G6B64yNy9uHy011iqU3YGD847SqJfaLHTbazb
         GKWW3k/5YOiTrGg3qK9ceGiJ77L0BTkrr2T4xXJnaPz3IsbjHrJANZZbIyzgoOcIqv
         5wIz1HDYSIOQA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH mlx5-next 0/7] Clean MR key use across mlx5_* modules
Date:   Tue, 12 Oct 2021 13:26:28 +0300
Message-Id: <cover.1634033956.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is cleanup series of mlx5_* MR mkey management.

Thanks

Aharon Landau (7):
  RDMA/mlx5: Don't set esc_size in user mr
  RDMA/mlx5: Remove iova from struct mlx5_core_mkey
  RDMA/mlx5: Remove size from struct mlx5_core_mkey
  RDMA/mlx5: Remove pd from struct mlx5_core_mkey
  RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
  RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
  RDMA/mlx5: Attach ndescs to mlx5_ib_mkey

 drivers/infiniband/hw/mlx5/devx.c             | 13 +--
 drivers/infiniband/hw/mlx5/devx.h             |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          | 31 ++++---
 drivers/infiniband/hw/mlx5/mr.c               | 82 +++++++++----------
 drivers/infiniband/hw/mlx5/odp.c              | 38 +++------
 drivers/infiniband/hw/mlx5/wr.c               | 10 +--
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  6 +-
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  2 +-
 .../mellanox/mlx5/core/diag/rsc_dump.c        | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |  2 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 10 +--
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 27 +++---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 10 +--
 .../mellanox/mlx5/core/steering/dr_send.c     | 11 ++-
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h            |  8 +-
 drivers/vdpa/mlx5/core/mr.c                   |  8 +-
 drivers/vdpa/mlx5/core/resources.c            | 13 +--
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |  2 +-
 include/linux/mlx5/driver.h                   | 30 ++-----
 25 files changed, 147 insertions(+), 195 deletions(-)

-- 
2.31.1

