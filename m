Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1366026D74C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 11:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIQJCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 05:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgIQJCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 05:02:30 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7BC62076D;
        Thu, 17 Sep 2020 09:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600333349;
        bh=uObNOBKy1NqJePr2mqJ9xVb7ssBbEU3eil62g617ILk=;
        h=From:To:Cc:Subject:Date:From;
        b=1A5BTxhh4eexfkFU7ZSEci59kLWUuCTqIZ8H77lt4GimVk7etNJv0/2hL4mZAzZyt
         XFkupcH1aBSvxpCVN7WYIJ5PfRSfuvz2fpHFeH9XDkNcZeBmqmGGAoiE/NRdwWE1UT
         fdwKG2j2eau422nydni9wNUDDeq7bejHffENNyuA=
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
Subject: [PATCH rdma-next v2 0/3] Fix in-kernel active_speed type
Date:   Thu, 17 Sep 2020 12:02:20 +0300
Message-Id: <20200917090223.1018224-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v2:
 * Changed WARN_ON casting to be saturated value instead while returning active_speed
   to the user.
v1: https://lore.kernel.org/linux-rdma/20200902074503.743310-1-leon@kernel.org
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

