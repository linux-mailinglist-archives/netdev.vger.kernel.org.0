Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269F21A67F6
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgDMOXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbgDMOXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:13 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C98A20774;
        Mon, 13 Apr 2020 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787793;
        bh=4U231P8RCPYLap+BgbKPKpMvXfBay9oo74WF94IX5xQ=;
        h=From:To:Cc:Subject:Date:From;
        b=uUL3CXtAmrCP2sxfHKWHKWBlV9nUCmHeWfZuphezK+BBPqHyQABMqIA9vQYgl98Go
         ySr+cJw7DBFwi98eYYCRFb7i+b7EXWtkqdsSxEwL6T8ZIm+4tNjhk20oyxop/x3XMW
         eiv+c4LU7Rgxzp9P88dEHecI/IaS4+QwzdPP1Qqg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/13] Move QP code to be under mlx5_ib responsibility
Date:   Mon, 13 Apr 2020 17:22:55 +0300
Message-Id: <20200413142308.936946-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series introduces simplified version of mlx5 command interface,
refactors the code to disconnect mlx5_core from QP logic and moves
qp.c to be under mlx5_ib responsibilities.

Next series will convert mlx5_core to this new interface, so at this
point I tried to keep the amount of changes to the minimum.

Thanks

Leon Romanovsky (13):
  net/mlx5: Provide simplified command interfaces
  net/mlx5: Open-code create and destroy QP calls
  net/mlx5: Remove empty QP and CQ events handlers
  net/mlx5: Open-code modify QP in steering module
  net/mlx5: Open-code modify QP in the FPGA module
  net/mlx5: Open-code modify QP in the IPoIB module
  net/mlx5: Remove extra indirection while storing QPN
  net/mlx5: Replace hand written QP context struct with automatic
    getters
  net/mlx5: Remove Q counter low level helper APIs
  RDMA/mlx5: Delete Q counter allocations command
  net/mlx5: Delete not-used cmd header
  RDMA/mlx5: Alphabetically sort build artifacts
  net/mlx5: Move QP logic to mlx5_ib

 drivers/infiniband/hw/mlx5/Makefile           |  28 +-
 drivers/infiniband/hw/mlx5/cmd.c              |  17 -
 drivers/infiniband/hw/mlx5/cmd.h              |   2 -
 drivers/infiniband/hw/mlx5/cq.c               |   3 +-
 drivers/infiniband/hw/mlx5/devx.c             |  10 +-
 drivers/infiniband/hw/mlx5/mad.c              |   1 -
 drivers/infiniband/hw/mlx5/main.c             |  94 ++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   3 +-
 drivers/infiniband/hw/mlx5/odp.c              |   3 +-
 drivers/infiniband/hw/mlx5/qp.c               |  47 ++-
 drivers/infiniband/hw/mlx5/qp.h               |  46 +++
 .../core/qp.c => infiniband/hw/mlx5/qpc.c}    | 304 +++++-------------
 drivers/infiniband/hw/mlx5/srq_cmd.c          |   2 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |   1 -
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  57 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  39 ++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  35 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   1 -
 .../ethernet/mellanox/mlx5/core/fpga/cmd.c    |   1 -
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 136 +++-----
 .../ethernet/mellanox/mlx5/core/fpga/conn.h   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   1 -
 .../net/ethernet/mellanox/mlx5/core/health.c  |   1 -
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 150 +++++----
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |   6 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |  19 +-
 .../mellanox/mlx5/core/lib/port_tun.c         |   1 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  |   1 -
 .../ethernet/mellanox/mlx5/core/pagealloc.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/pd.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/rl.c  |   1 -
 .../mellanox/mlx5/core/steering/dr_send.c     |  58 ++--
 .../mellanox/mlx5/core/steering/dr_types.h    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c |   1 -
 include/linux/mlx5/cmd.h                      |  51 ---
 include/linux/mlx5/driver.h                   |  15 +-
 include/linux/mlx5/qp.h                       |  49 ---
 40 files changed, 496 insertions(+), 701 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/qp.h
 rename drivers/{net/ethernet/mellanox/mlx5/core/qp.c => infiniband/hw/mlx5/qpc.c} (55%)
 delete mode 100644 include/linux/mlx5/cmd.h

--
2.25.2

