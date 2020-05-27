Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF21E3DD9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgE0Jql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:46:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58141 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727794AbgE0Jql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:46:41 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:46:35 +0300
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9kYih009430;
        Wed, 27 May 2020 12:46:34 +0300
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, dledford@redhat.com, leon@kernel.org,
        galpress@amazon.com, dennis.dalessandro@intel.com,
        netdev@vger.kernel.org, sagi@grimberg.me,
        linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com
Cc:     aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 0/9 v2] Remove FMR support from RDMA drivers
Date:   Wed, 27 May 2020 12:46:25 +0300
Message-Id: <20200527094634.24240-1-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series removes the support for FMR mode to register memory. This ancient
mode is unsafe (rkeys that are usually exposed for caching purposes and the API
is limited to page granularity mappings) and not maintained/tested in the last
few years. It also doesn't have any reasonable advantage over other memory
registration methods such as FRWR (that is implemented in all the recent RDMA
adapters). This series should be reviewed and approved by the maintainer of the
effected drivers and I suggest to test it as well.

The tests that I made for this series (fio benchmarks and fio verify data):
1. iSER initiator on ConnectX-4
2. iSER initiator on ConnectX-3
3. SRP initiator on ConnectX-4 (loopback to SRP target)
4. SRP initiator on ConnectX-3

Not tested:
1. RDS
2. mthca
3. rdmavt

Changes from V1:
 - added "RDMA/mlx5: Remove FMR leftovers" (from GalP)
 - rebased on top of "Linux 5.7-rc7"
 - added "Reviewed-by" Bart signature for SRP

Gal Pressman (1):
  RDMA/mlx5: Remove FMR leftovers

Israel Rukshin (1):
  RDMA/iser: Remove support for FMR memory registration

Max Gurtovoy (7):
  RDMA/mlx4: remove FMR support for memory registration
  RDMA/rds: remove FMR support for memory registration
  RDMA/mthca: remove FMR support for memory registration
  RDMA/rdmavt: remove FMR memory registration
  RDMA/srp: remove support for FMR memory registration
  RDMA/core: remove FMR pool API
  RDMA/core: remove FMR device ops

 Documentation/driver-api/infiniband.rst      |   3 -
 Documentation/infiniband/core_locking.rst    |   2 -
 drivers/infiniband/core/Makefile             |   2 +-
 drivers/infiniband/core/device.c             |   4 -
 drivers/infiniband/core/fmr_pool.c           | 494 ---------------------------
 drivers/infiniband/core/verbs.c              |  48 ---
 drivers/infiniband/hw/mlx4/main.c            |  10 -
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  16 -
 drivers/infiniband/hw/mlx4/mr.c              |  93 -----
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   8 -
 drivers/infiniband/hw/mthca/mthca_dev.h      |  10 -
 drivers/infiniband/hw/mthca/mthca_mr.c       | 262 +-------------
 drivers/infiniband/hw/mthca/mthca_provider.c |  86 -----
 drivers/infiniband/sw/rdmavt/mr.c            | 154 ---------
 drivers/infiniband/sw/rdmavt/mr.h            |  15 -
 drivers/infiniband/sw/rdmavt/vt.c            |   4 -
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  79 +----
 drivers/infiniband/ulp/iser/iser_initiator.c |  19 +-
 drivers/infiniband/ulp/iser/iser_memory.c    | 188 +---------
 drivers/infiniband/ulp/iser/iser_verbs.c     | 126 +------
 drivers/infiniband/ulp/srp/ib_srp.c          | 222 +-----------
 drivers/infiniband/ulp/srp/ib_srp.h          |  27 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c      | 183 ----------
 include/linux/mlx4/device.h                  |  21 +-
 include/rdma/ib_fmr_pool.h                   |  93 -----
 include/rdma/ib_verbs.h                      |  45 ---
 net/rds/Makefile                             |   2 +-
 net/rds/ib.c                                 |  14 +-
 net/rds/ib.h                                 |   1 -
 net/rds/ib_cm.c                              |   4 +-
 net/rds/ib_fmr.c                             | 269 ---------------
 net/rds/ib_mr.h                              |  12 -
 net/rds/ib_rdma.c                            |  16 +-
 33 files changed, 77 insertions(+), 2455 deletions(-)
 delete mode 100644 drivers/infiniband/core/fmr_pool.c
 delete mode 100644 include/rdma/ib_fmr_pool.h
 delete mode 100644 net/rds/ib_fmr.c

-- 
1.8.3.1

