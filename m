Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50EC13C14A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAOMnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbgAOMnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:43:45 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CDFC222C3;
        Wed, 15 Jan 2020 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092224;
        bh=X9sbDmmjEfGqMQAx2L+k/ZDn1gKCbHe3fFJYZS86pn4=;
        h=From:To:Cc:Subject:Date:From;
        b=QekXmLHeD8p8qPgEoDcsxV8vlvF/6t9iLMhIpp0Q+QNP1NTgqpLrmfhhWkDbZ3zvj
         hkIvj3pKH7TkK2KkEGiqbQr8NBiqOHXv82zDnS5xjZOFwaOw+O1ABstt3E2Uzn92PN
         5N7+v69oQ6bs6kZ79uRTDkWidBk1hbNsluxfolVY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Date:   Wed, 15 Jan 2020 14:43:30 +0200
Message-Id: <20200115124340.79108-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

The following series extends MR creation routines to allow creation of
user MRs through kernel ULPs as a proxy. The immediate use case is to
allow RDS to work over FS-DAX, which requires ODP (on-demand-paging)
MRs to be created and such MRs were not possible to create prior this
series.

The first part of this patchset extends RDMA to have special verb
ib_reg_user_mr(). The common use case that uses this function is a userspace
application that allocates memory for HCA access but the responsibility
to register the memory at the HCA is on an kernel ULP. This ULP that acts
as an agent for the userspace application.

The second part provides advise MR functionality for ULPs. This is
integral part of ODP flows and used to trigger pagefaults in advance
to prepare memory before running working set.

The third part is actual user of those in-kernel APIs.

Thanks

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

 drivers/infiniband/core/umem.c                |  27 +--
 drivers/infiniband/core/umem_odp.c            |  29 +--
 drivers/infiniband/core/verbs.c               |  41 +++++
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
 drivers/infiniband/hw/mlx5/main.c             |  51 ++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  12 +-
 drivers/infiniband/hw/mlx5/mr.c               |  20 +--
 drivers/infiniband/hw/mlx5/odp.c              |  33 ++--
 drivers/infiniband/hw/mlx5/qp.c               | 167 +++++++++++-------
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
 include/rdma/ib_verbs.h                       |   9 +
 net/rds/ib.c                                  |   7 +
 net/rds/ib.h                                  |   3 +-
 net/rds/ib_mr.h                               |   7 +-
 net/rds/ib_rdma.c                             |  83 ++++++++-
 net/rds/ib_send.c                             |  44 +++--
 net/rds/rdma.c                                | 156 +++++++++++-----
 net/rds/rds.h                                 |  13 +-
 45 files changed, 559 insertions(+), 256 deletions(-)

--
2.20.1

