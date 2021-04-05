Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708AC353B84
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhDEFYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhDEFYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 325176138F;
        Mon,  5 Apr 2021 05:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600252;
        bh=M5HqKDCST9r1ErCNZdLcT+V9m148cOwOB3AdHel2elc=;
        h=From:To:Cc:Subject:Date:From;
        b=hYxGHSOUM1lmYuxafECVWKyVk/1yMgA27ZdLlPDWh3vMvPlO1tJgduVSItMFVYODB
         JnpFy9S2+owMH0EwMW3WCLjXexXYPCOYEO5/IqJ3FMCgeVaT4yr/j6+DRxhh/RHSAO
         I1A/TcGX7LefUSTMjTgUtndaKMYI+Ez73/54gQSKZVhXbyvmmaXHiDKrhp7PK/ezIU
         RcQ8Mvm4DVbdl8ybz0bVAmetN9hTocKU3ObpUPL8uDmMHUzfLLqmicbBNCI2o/pEQP
         k9Rt4IrksIjQLoaiBQCmWY+qnMpMNnphY/45jPoVm6dllEvwABl5jDaDxSDKdrjv1z
         kInT8rj7le7+A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Date:   Mon,  5 Apr 2021 08:23:54 +0300
Message-Id: <20210405052404.213889-1-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

From Avihai,

Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
imposed on PCI transactions, and thus, can improve performance.

Until now, relaxed ordering could be set only by user space applications
for user MRs. The following patch series enables relaxed ordering for the
kernel ULPs as well. Relaxed ordering is an optional capability, and as
such, it is ignored by vendors that don't support it.

The following test results show the performance improvement achieved
with relaxed ordering. The test was performed on a NVIDIA A100 in order
to check performance of storage infrastructure over xprtrdma:

Without Relaxed Ordering:
READ: bw=16.5GiB/s (17.7GB/s), 16.5GiB/s-16.5GiB/s (17.7GB/s-17.7GB/s),
io=1987GiB (2133GB), run=120422-120422msec

With relaxed ordering:
READ: bw=72.9GiB/s (78.2GB/s), 72.9GiB/s-72.9GiB/s (78.2GB/s-78.2GB/s),
io=2367GiB (2542GB), run=32492-32492msec

Thanks

Avihai Horon (10):
  RDMA: Add access flags to ib_alloc_mr() and ib_mr_pool_init()
  RDMA/core: Enable Relaxed Ordering in __ib_alloc_pd()
  RDMA/iser: Enable Relaxed Ordering
  RDMA/rtrs: Enable Relaxed Ordering
  RDMA/srp: Enable Relaxed Ordering
  nvme-rdma: Enable Relaxed Ordering
  cifs: smbd: Enable Relaxed Ordering
  net/rds: Enable Relaxed Ordering
  net/smc: Enable Relaxed Ordering
  xprtrdma: Enable Relaxed Ordering

 drivers/infiniband/core/mr_pool.c             |  7 +-
 drivers/infiniband/core/rw.c                  | 12 ++--
 drivers/infiniband/core/verbs.c               | 26 +++++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h      |  2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |  2 +-
 drivers/infiniband/hw/cxgb4/mem.c             |  2 +-
 drivers/infiniband/hw/hns/hns_roce_device.h   |  2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |  3 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |  2 +-
 drivers/infiniband/hw/mlx4/mr.c               |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          | 12 ++--
 drivers/infiniband/hw/mlx5/mr.c               | 61 ++++++++--------
 drivers/infiniband/hw/mlx5/wr.c               | 69 ++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h   |  2 +-
 drivers/infiniband/hw/qedr/verbs.c            |  2 +-
 drivers/infiniband/hw/qedr/verbs.h            |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |  4 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  2 +-
 drivers/infiniband/sw/rdmavt/mr.c             |  3 +-
 drivers/infiniband/sw/rdmavt/mr.h             |  2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |  2 +-
 drivers/infiniband/sw/siw/siw_verbs.c         |  2 +-
 drivers/infiniband/sw/siw/siw_verbs.h         |  2 +-
 drivers/infiniband/ulp/iser/iser_memory.c     | 10 ++-
 drivers/infiniband/ulp/iser/iser_verbs.c      |  6 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  6 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        | 15 ++--
 drivers/infiniband/ulp/srp/ib_srp.c           |  8 +--
 drivers/nvme/host/rdma.c                      | 19 +++--
 fs/cifs/smbdirect.c                           | 17 +++--
 include/rdma/ib_verbs.h                       | 11 ++-
 include/rdma/mr_pool.h                        |  3 +-
 net/rds/ib_frmr.c                             |  7 +-
 net/smc/smc_ib.c                              |  3 +-
 net/smc/smc_wr.c                              |  3 +-
 net/sunrpc/xprtrdma/frwr_ops.c                | 10 +--
 39 files changed, 209 insertions(+), 140 deletions(-)

-- 
2.30.2

