Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE9925A6F8
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBHpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIBHpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 03:45:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 826FA20826;
        Wed,  2 Sep 2020 07:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599032708;
        bh=8DlnAGzB67y9uRNVOxyb/SwF/KAISQLuuSaE6gGbs+w=;
        h=From:To:Cc:Subject:Date:From;
        b=FieKjue+GdO9IjUCSEpAlS/YpadYxoXb/eGzBDikO/6TKqcvMjn9KQyPpzoDogF+4
         AEbLZQq2S9Q2KfwNQ3NWkEzhkSRCuU0vniw8CIC1icvnZ9KI0i9MXBBCeMWnT887Pt
         H/5f6+5AFZDV+GdRDVCXThTkBqZZ3MPBQCqt9U7s=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Achiad Shochat <achiad@mellanox.com>,
        Adit Ranadive <aditr@vmware.com>,
        Aharon Landau <aharonl@mellanox.com>,
        Ariel Elior <aelior@marvell.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: [PATCH rdma-next v1 0/3] Fix in-kernel active_speed type
Date:   Wed,  2 Sep 2020 10:45:00 +0300
Message-Id: <20200902074503.743310-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Changed patch #1 to fix memory corruption to help with bisect. No
   change in series, because the added code is changed anyway in patch
   #3.
v0:
 * https://lore.kernel.org/linux-rdma/20200824105826.1093613-1-leon@kernel.org

----------------------------------------------------------------------------------------

IBTA declares speed as 16 bits, but kernel stores it in u8. This series
fixes in-kernel declaration while keeping external interface intact.

Thanks

Aharon Landau (3):
  net/mlx5: Refactor query port speed functions
  RDMA/mlx5: Delete duplicated mlx5_ptys_width enum
  RDMA: Fix link active_speed size

 .../infiniband/core/uverbs_std_types_device.c |  3 +-
 drivers/infiniband/core/verbs.c               |  2 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |  2 +-
 drivers/infiniband/hw/hfi1/verbs.c            |  2 +-
 drivers/infiniband/hw/mlx5/main.c             | 41 +++++++------------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |  2 +-
 drivers/infiniband/hw/qedr/verbs.c            |  2 +-
 drivers/infiniband/hw/qib/qib.h               |  6 +--
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  2 +-
 .../mellanox/mlx5/core/ipoib/ethtool.c        | 31 ++------------
 .../net/ethernet/mellanox/mlx5/core/port.c    | 23 ++---------
 include/linux/mlx5/port.h                     | 15 +++++--
 include/rdma/ib_verbs.h                       |  4 +-
 13 files changed, 47 insertions(+), 88 deletions(-)

--
2.26.2

