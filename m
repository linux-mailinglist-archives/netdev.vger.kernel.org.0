Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6BD1E6B7B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgE1TqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgE1TqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:01 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DD6C08C5CA
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:00 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id e20so1360185qvu.0
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vv27fdAaO6yeM0dPvx+TtJjfYzQQ3+W2/2SVCKpX4Ww=;
        b=hJa/Ot7PdWGL4Y5FGaaWUGwO4lutheiCFJyZrxehKE2STd5S3RTzEHD5fyGjb2n2rB
         jA7IvYZxJ9xkqzzlRoDp32ZrtUY7sHJQvbzsPyRm0oqHg0UprvkpgIXD/ny7WbHdAIFC
         rrt2TIa3MsIynAYTT3Va+GXncwLDUN61L1/ropTwwSRyPaQrfLYwn6XrBs5zDgYodqeT
         leulPD2wmvv4hKfOq2FtdVXzcB7UaYo9vKpwwbFzUa5tRhnTNvpUPHjs/40SarAruzTq
         HSjSaDFtT58rIhjAS7BWO7nJ7kGkyfr0IcZ9GUv4nL41Paa3fbIK7i6AATIPbhLygKM/
         dKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vv27fdAaO6yeM0dPvx+TtJjfYzQQ3+W2/2SVCKpX4Ww=;
        b=qM8BDksC0r+NBb1pJfooPv+SA/X6zMA453KeXtFTe3vZ22jsnVi8pULPf1P9lAXsKe
         hQkTsbWCMhVgnQFfHupw9I3d5VLog3N19BeGGjI1UiBdguymNoZ6d4rrEkQRGqvldChr
         YrtZRDoWX6sqjaB+fryz864RphCuODJvo5PYl8kefKKHwxyhkm9Jmf+gjmhVyjFPrRHJ
         aOOnzgB7+4/21o/XEJm1NfnYwB8nVEC24/3l0V0M5EyDCwKGPhOWnhvo2Bfk4PUsA84F
         Lm/gLBGs1lJluv7Zgf3gOUjYabWgwHF2rowGnW1YAIjOGytMIkXv4viCCdvoIO7FdDHt
         /7gA==
X-Gm-Message-State: AOAM533/xvCglc9a2WNeszQuSU4RTMZi8cFRXSog0JgJuwVY2HazaZqL
        N0gV1ihFEvRmEo02yuESmg1Tog==
X-Google-Smtp-Source: ABdhPJzhcbLKLPGqJ8edmBiq9jseWokk5HgD+3ATMRag7u4UARpesaPFJDnr/gJ9bFzCzsmiLP0buA==
X-Received: by 2002:ad4:5a53:: with SMTP id ej19mr4622151qvb.79.1590695159410;
        Thu, 28 May 2020 12:45:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id k20sm6264990qtu.16.2020.05.28.12.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTT-0006gc-UG; Thu, 28 May 2020 16:45:55 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ariel Elior <aelior@marvell.com>, aron.silverton@oracle.com,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Gal Pressman <galpress@amazon.com>,
        Israel Rukshin <israelr@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Michal Kalderon <mkalderon@marvell.com>, oren@mellanox.com,
        Sagi Grimberg <sagi@grimberg.me>, santosh.shilimkar@oracle.com,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>, shlomin@mellanox.com,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        vladimirk@mellanox.com, Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH v3 00/13] Remove FMR support from RDMA drivers
Date:   Thu, 28 May 2020 16:45:42 -0300
Message-Id: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

This series removes the support for FMR mode to register memory. This
ancient mode is unsafe (rkeys that are usually exposed for caching
purposes and the API is limited to page granularity mappings) and not
maintained/tested in the last few years. It also doesn't have any
reasonable advantage over other memory registration methods such as
FRWR (that is implemented in all the recent RDMA adapters). This series
should be reviewed and approved by the maintainer of the effected drivers
and I suggest to test it as well.

Changes from V2:
 - Removed more occurances of _fmr
 - Remove max_map_per_fmr device attribute
 - Remove max_fmr device attribute
 - Remove additional dead code from bnxt_re and i40iw
 - Revised RDS to not use ib_fmr_attr or other fmr things
 - Rebased on RDMA for-next
Changes from V1:
 https://lore.kernel.org/linux-rdma/20200527094634.24240-1-maxg@mellanox.com/
 - added "RDMA/mlx5: Remove FMR leftovers" (from GalP)
 - rebased on top of "Linux 5.7-rc7"
 - added "Reviewed-by" Bart signature for SRP

Cc: shlomin@mellanox.com
Cc: vladimirk@mellanox.com
Cc: oren@mellanox.com

Gal Pressman (1):
  RDMA/mlx5: Remove FMR leftovers

Israel Rukshin (1):
  RDMA/iser: Remove support for FMR memory registration

Jason Gunthorpe (4):
  RDMA/bnxt_re: Remove FMR leftovers
  RDMA/i40iw: Remove FMR leftovers
  RDMA: Remove 'max_fmr'
  RDMA: Remove 'max_map_per_fmr'

Max Gurtovoy (7):
  RDMA/srp: Remove support for FMR memory registration
  RDMA/rds: Remove FMR support for memory registration
  RDMA/core: Remove FMR pool API
  RDMA/mlx4: Remove FMR support for memory registration
  RDMA/mthca: Remove FMR support for memory registration
  RDMA/rdmavt: Remove FMR memory registration
  RDMA/core: Remove FMR device ops

 Documentation/driver-api/infiniband.rst      |   3 -
 Documentation/infiniband/core_locking.rst    |   2 -
 drivers/infiniband/core/Makefile             |   2 +-
 drivers/infiniband/core/device.c             |   4 -
 drivers/infiniband/core/fmr_pool.c           | 494 -------------------
 drivers/infiniband/core/uverbs_cmd.c         |   2 -
 drivers/infiniband/core/verbs.c              |  48 --
 drivers/infiniband/hw/bnxt_re/ib_verbs.c     |   3 -
 drivers/infiniband/hw/bnxt_re/ib_verbs.h     |   6 -
 drivers/infiniband/hw/bnxt_re/qplib_sp.c     |   3 -
 drivers/infiniband/hw/bnxt_re/qplib_sp.h     |   2 -
 drivers/infiniband/hw/hfi1/verbs.c           |   1 -
 drivers/infiniband/hw/i40iw/i40iw.h          |   9 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |   1 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.h    |   1 -
 drivers/infiniband/hw/mlx4/main.c            |  11 -
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  16 -
 drivers/infiniband/hw/mlx4/mr.c              |  93 ----
 drivers/infiniband/hw/mlx5/main.c            |   1 -
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |   8 -
 drivers/infiniband/hw/mthca/mthca_dev.h      |  10 -
 drivers/infiniband/hw/mthca/mthca_mr.c       | 262 +---------
 drivers/infiniband/hw/mthca/mthca_provider.c |  96 ----
 drivers/infiniband/hw/mthca/mthca_provider.h |  23 -
 drivers/infiniband/hw/ocrdma/ocrdma.h        |   1 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c     |   1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   2 -
 drivers/infiniband/hw/qedr/main.c            |   1 -
 drivers/infiniband/hw/qedr/qedr.h            |   1 -
 drivers/infiniband/hw/qedr/verbs.c           |   2 -
 drivers/infiniband/hw/qib/qib_verbs.c        |   1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   1 -
 drivers/infiniband/sw/rdmavt/mr.c            | 155 ------
 drivers/infiniband/sw/rdmavt/mr.h            |  15 -
 drivers/infiniband/sw/rdmavt/vt.c            |   4 -
 drivers/infiniband/sw/siw/siw.h              |   2 -
 drivers/infiniband/sw/siw/siw_main.c         |   1 -
 drivers/infiniband/sw/siw/siw_verbs.c        |   1 -
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  79 +--
 drivers/infiniband/ulp/iser/iser_initiator.c |  19 +-
 drivers/infiniband/ulp/iser/iser_memory.c    | 188 +------
 drivers/infiniband/ulp/iser/iser_verbs.c     | 126 +----
 drivers/infiniband/ulp/srp/ib_srp.c          | 222 +--------
 drivers/infiniband/ulp/srp/ib_srp.h          |  27 +-
 drivers/net/ethernet/mellanox/mlx4/main.c    |   2 -
 drivers/net/ethernet/mellanox/mlx4/mr.c      | 183 -------
 drivers/net/ethernet/qlogic/qed/qed_rdma.c   |   1 -
 drivers/net/ethernet/qlogic/qed/qed_rdma.h   |   1 -
 include/linux/mlx4/device.h                  |  22 +-
 include/linux/qed/qed_rdma_if.h              |   1 -
 include/rdma/ib_fmr_pool.h                   |  93 ----
 include/rdma/ib_verbs.h                      |  61 ---
 net/rds/Makefile                             |   2 +-
 net/rds/ib.c                                 |  22 +-
 net/rds/ib.h                                 |   2 -
 net/rds/ib_cm.c                              |   4 +-
 net/rds/ib_fmr.c                             | 269 ----------
 net/rds/ib_frmr.c                            |   4 +-
 net/rds/ib_mr.h                              |  14 +-
 net/rds/ib_rdma.c                            |  28 +-
 60 files changed, 88 insertions(+), 2571 deletions(-)
 delete mode 100644 drivers/infiniband/core/fmr_pool.c
 delete mode 100644 include/rdma/ib_fmr_pool.h
 delete mode 100644 net/rds/ib_fmr.c

-- 
2.26.2

