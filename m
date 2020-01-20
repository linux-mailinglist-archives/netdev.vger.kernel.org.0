Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06146142445
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgATHa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgATHa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 02:30:56 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F0320684;
        Mon, 20 Jan 2020 07:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579505454;
        bh=QkXqYataShtv5Re4qL9AbP44cpqVaJtkXXP3hf4o0Zc=;
        h=From:To:Cc:Subject:Date:From;
        b=zPidTaHSnvgnqAll1EEAUnFhOB5GW8k12cjrMW07cvev9hXP84vzbxR57rjTmucvn
         m0XIZQ6D2UK6MTtjqYp8tiHZivCZj5hvwl8UijfOTkfBzBw/vZulT+yFmaqoKKM1rj
         +mDHbH+Mzf01LF+iLvyVk9bJgji3i2y0nIeRVxoQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [net-next, rdma-next] [pull request] Use ODP MRs for kernel ULPs
Date:   Mon, 20 Jan 2020 09:30:46 +0200
Message-Id: <20200120073046.75590-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi David, Jakub, Doug and Jason

This is pull request to previously posted and reviewed series [1] which touches
RDMA and netdev subsystems. RDMA part was approved for inclusion by Jason [2]
and RDS patches were acked by Santosh [3].

For your convenience, the series is based on clean v5.5-rc6 tag and applies
cleanly to both subsystems.

Please pull and let me know if there's any problem. I'm very rare doing PRs
and sorry in advance if something is not as expected.

[1] https://lore.kernel.org/linux-rdma/20200115124340.79108-1-leon@kernel.org
[2] https://lore.kernel.org/linux-rdma/20200117141232.GX20978@mellanox.com
[3] https://lore.kernel.org/linux-rdma/3c479d8a-f98a-a4c9-bd85-6332e919bf35@oracle.com

----------------------------------------------------------------
The following series extends MR creation routines to allow creation of
user MRs through kernel ULPs as a proxy. The immediate use case is to
allow RDS to work over FS-DAX, which requires ODP (on-demand-paging)
MRs to be created and such MRs were not possible to create prior this
series.

The first part of this patchset extends RDMA to have special verb
ib_reg_user_mr(). The common use case that uses this function is a
userspace application that allocates memory for HCA access but the
responsibility to register the memory at the HCA is on an kernel ULP.
This ULP acts as an agent for the userspace application.

The second part provides advise MR functionality for ULPs. This is
integral part of ODP flows and used to trigger pagefaults in advance
to prepare memory before running working set.

The third part is actual user of those in-kernel APIs.

Thanks
----------------------------------------------------------------
The following changes since commit b3a987b0264d3ddbb24293ebff10eddfc472f653:

  Linux 5.5-rc6 (2020-01-12 16:55:08 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rds-odp-for-5.5

for you to fetch changes up to b2dfc6765e45a3154800333234e4952b5412d792:

  net/rds: Use prefetch for On-Demand-Paging MR (2020-01-18 11:48:19 +0200)

----------------------------------------------------------------
Hans Westgaard Ry (3):
      net/rds: Detect need of On-Demand-Paging memory registration
      net/rds: Handle ODP mr registration/unregistration
      net/rds: Use prefetch for On-Demand-Paging MR

Jason Gunthorpe (1):
      RDMA/mlx5: Fix handling of IOVA != user_va in ODP paths

Leon Romanovsky (1):
      RDMA/mlx5: Don't fake udata for kernel path

Moni Shoua (5):
      IB: Allow calls to ib_umem_get from kernel ULPs
      IB/core: Introduce ib_reg_user_mr
      IB/core: Add interface to advise_mr for kernel users
      IB/mlx5: Add ODP WQE handlers for kernel QPs
      IB/mlx5: Mask out unsupported ODP capabilities for kernel QPs

 drivers/infiniband/core/umem.c                |  27 ++---
 drivers/infiniband/core/umem_odp.c            |  29 ++---
 drivers/infiniband/core/verbs.c               |  41 +++++++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  12 +-
 drivers/infiniband/hw/cxgb4/mem.c             |   2 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c       |   2 +-
 drivers/infiniband/hw/hns/hns_roce_db.c       |   3 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       |   4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c       |   2 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c      |   5 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |   5 +-
 drivers/infiniband/hw/mlx4/cq.c               |   2 +-
 drivers/infiniband/hw/mlx4/doorbell.c         |   3 +-
 drivers/infiniband/hw/mlx4/mr.c               |   8 +-
 drivers/infiniband/hw/mlx4/qp.c               |   5 +-
 drivers/infiniband/hw/mlx4/srq.c              |   3 +-
 drivers/infiniband/hw/mlx5/cq.c               |   6 +-
 drivers/infiniband/hw/mlx5/devx.c             |   2 +-
 drivers/infiniband/hw/mlx5/doorbell.c         |   3 +-
 drivers/infiniband/hw/mlx5/main.c             |  51 +++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  12 +-
 drivers/infiniband/hw/mlx5/mr.c               |  20 +--
 drivers/infiniband/hw/mlx5/odp.c              |  33 +++--
 drivers/infiniband/hw/mlx5/qp.c               | 167 +++++++++++++++++---------
 drivers/infiniband/hw/mlx5/srq.c              |   2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |   2 +-
 drivers/infiniband/hw/qedr/verbs.c            |   9 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c  |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |   7 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |   2 +-
 drivers/infiniband/sw/rdmavt/mr.c             |   2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c            |   2 +-
 include/rdma/ib_umem.h                        |   4 +-
 include/rdma/ib_umem_odp.h                    |   6 +-
 include/rdma/ib_verbs.h                       |   9 ++
 net/rds/ib.c                                  |   7 ++
 net/rds/ib.h                                  |   3 +-
 net/rds/ib_mr.h                               |   7 +-
 net/rds/ib_rdma.c                             |  84 ++++++++++++-
 net/rds/ib_send.c                             |  44 +++++--
 net/rds/rdma.c                                | 157 ++++++++++++++++++------
 net/rds/rds.h                                 |  13 +-
 45 files changed, 561 insertions(+), 256 deletions(-)
