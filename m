Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B2F1E138F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389629AbgEYRoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389401AbgEYRoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 13:44:09 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2D802078B;
        Mon, 25 May 2020 17:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590428648;
        bh=GUafSs4qTtdbicJ/xkhfTiVGPUUeJrospfu4vMubQoQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cwbj7owwnZa/UOWnJ+hfJpgpF+YwRmWGnFDV3wCLZ1Xw0l9tbTKIJcCZqanhUFWuW
         IZfc+pjPYeNeYhupkZcPAp074B/V8OxdD8Q2hd41YJ/bYoydd4QkvHJufsrB+jU7yE
         ri+Bp8/y3Hpv5IRhghEeAlFRKIYNqo/zYAO0EOV4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next v2 0/9] Driver part of the ECE
Date:   Mon, 25 May 2020 20:43:52 +0300
Message-Id: <20200525174401.71152-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v2:
 * Rebased on latest wip/jgg-rdma-next branch, commit a94dae867c56
 * Fixed wrong setting of pm_state field in mlx5 conversion patch
 * Removed DC support for now
v1: https://lore.kernel.org/linux-rdma/20200523132243.817936-1-leon@kernel.org
 * Fixed compatibility issue of "old" kernel vs. "new" rdma-core. This
   is handled in extra patch.
 * Improved comments and commit messages after feedback from Yishai.
 * Added Mark Z. ROB tags
v0: https://lore.kernel.org/linux-rdma/20200520082919.440939-1-leon@kernel.org

----------------------------------------------------------------------

Hi,

This is driver part of the RDMA-CM ECE series [1].
According to the IBTA, ECE data is completely vendor specific, so this
series extends mlx5_ib create_qp and modify_qp structs with extra field
to pass ECE options to/from the application.

Thanks

[1]
https://lore.kernel.org/linux-rdma/20200413141538.935574-1-leon@kernel.org

Leon Romanovsky (9):
  net/mlx5: Add ability to read and write ECE options
  RDMA/mlx5: Get ECE options from FW during create QP
  RDMA/mlx5: Set ECE options during QP create
  RDMA/mlx5: Use direct modify QP implementation
  RDMA/mlx5: Remove manually crafted QP context the query call
  RDMA/mlx5: Convert modify QP to use MLX5_SET macros
  RDMA/mlx5: Advertise ECE support
  RDMA/mlx5: Set ECE options during modify QP
  RDMA/mlx5: Return ECE data after modify QP

 drivers/infiniband/hw/mlx5/main.c |   3 +
 drivers/infiniband/hw/mlx5/qp.c   | 478 +++++++++++++++++-------------
 drivers/infiniband/hw/mlx5/qp.h   |   6 +-
 drivers/infiniband/hw/mlx5/qpc.c  |  44 ++-
 include/linux/mlx5/mlx5_ifc.h     |  24 +-
 include/linux/mlx5/qp.h           |  66 -----
 include/uapi/rdma/mlx5-abi.h      |   9 +-
 7 files changed, 333 insertions(+), 297 deletions(-)

--
2.26.2

