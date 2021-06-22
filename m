Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB53B03C0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhFVMKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhFVMKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11712613B4;
        Tue, 22 Jun 2021 12:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624363709;
        bh=QgbOICWNWQVZBV9woPMxiJU074KR713S1bjNoE4oqlk=;
        h=From:To:Cc:Subject:Date:From;
        b=lMsWOuYVn8GonHp1D+NeGvhPvHMLCTC2GQbz3IAeYVi6sb0wR1DxJku4Du3RBD6lZ
         IggB5vkt7JSmp/Y5fWncEvCPaFwW5dkfDMR1NJAubitOpGeUmibljZydSGm3UBZjFx
         GUxh7aOi68ql+qWTdNEop2JvNWb/gXgMLP0+9NBoKnEkLVzswm4c9yuqp58gnS4cjS
         lZ4esAsm+4X4AcQseh2XnGBTOrWmBE3HHLZ2hklwVUgu8YuWvpkIBW37W1dRTpOkKm
         02wLF+3gRvD+BRaasUhmD7P2oyFiGGV6Tbeeg1sPRd5mCr58j4mXvOI3jXK4WfHENf
         hxXvRrLsx0PQA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH rdma-next 0/5] mlx5 MR cache enhancements
Date:   Tue, 22 Jun 2021 15:08:18 +0300
Message-Id: <cover.1624362290.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series from Aharon changes how memory region (MR) cache logic
works in mlx5 driver. First 3 patches are global conversions of
internal structures to hold mkeys, while the rest of the patches
changes cache logic in the RDMA subsystem.

Thanks

Aharon Landau (5):
  RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
  RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
  RDMA/mlx5: Change the cache to hold mkeys instead of MRs
  RDMA/mlx5: Change the cache structure to an rbtree
  RDMA/mlx5: Delay the deregistration of a non-cache mkey

 drivers/infiniband/hw/mlx5/devx.c             |   2 +-
 drivers/infiniband/hw/mlx5/main.c             |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  99 ++-
 drivers/infiniband/hw/mlx5/mr.c               | 795 ++++++++++++------
 drivers/infiniband/hw/mlx5/odp.c              |  56 +-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |   2 +-
 .../mellanox/mlx5/core/diag/fw_tracer.h       |   2 +-
 .../mellanox/mlx5/core/diag/rsc_dump.c        |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |   2 +-
 .../ethernet/mellanox/mlx5/core/en_common.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |   8 +-
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  |  26 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c |   9 +-
 .../mellanox/mlx5/core/steering/dr_send.c     |   9 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |   2 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h            |   8 +-
 drivers/vdpa/mlx5/core/mr.c                   |   6 +-
 drivers/vdpa/mlx5/core/resources.c            |  13 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |   2 +-
 include/linux/mlx5/driver.h                   |  30 +-
 24 files changed, 697 insertions(+), 404 deletions(-)

-- 
2.31.1

