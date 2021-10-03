Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC642033F
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhJCSOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhJCSN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 14:13:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 856166134F;
        Sun,  3 Oct 2021 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633284731;
        bh=D7jN9jM4hAeJc0S/qDp+zVB+ygDS5UpyUHMHuwrUDEQ=;
        h=From:To:Cc:Subject:Date:From;
        b=RpA1OUpduNud0tnpQ1qaxlkiGaPFsw3S/evVoQaZmH1Ps7cQt6lmmddvcizmsCRfX
         RVcmhqUnctSQmmG+yPe3uu4fqETun+pvkAoBeq7VjRZdBAgkj5Dt5rGfdrcD0aza2e
         Bkn1TvsvLAZcpJTllYPv/29NBMhBORBYNgjqIoR5OjUdITkglj4mMm9c3jSPbkX8d9
         PP6Mlupu1U2LKE2XZitQz4hyNo30zvgwvAkznwkFC+J9L2D1Ay6GZJTLLcHGIGS8lK
         3fu5wAExXvASBJD4ULww1DynSIV/g1prpUevze7AFf5M1Y2e11kgt5moRDXx97pMpj
         vmV5Q95zkQgGg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v2 0/5] devlink reload simplification
Date:   Sun,  3 Oct 2021 21:12:01 +0300
Message-Id: <cover.1633284302.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v2:
 * Dropped const removal patch
 * Added new patch to hide struct devlink
 * Added new patch to annotate devlink API
 * Implemented copy of all callback in devlink ops
v1: https://lore.kernel.org/all/cover.1632916329.git.leonro@nvidia.com
 * Missed removal of extra WARN_ON
 * Added "ops parameter to macro as Dan suggested.
v0: https://lore.kernel.org/all/cover.1632909221.git.leonro@nvidia.com

-------------------------------------------------------------------
Hi,

This series fixes the bug with mlx5 device, which in some configurations
doesn't support devlink reload and shouldn't have any reload statistics
like any other net device. Unfortunately, it is not the case in the
current implementation of devlink reload.

This fix is done by simplification of internal API.

Thanks

Leon Romanovsky (5):
  devlink: Reduce struct devlink exposure
  devlink: Annotate devlink API calls
  devlink: Allow set specific ops callbacks dynamically
  net/mlx5: Register separate reload devlink ops for multiport device
  devlink: Delete reload enable/disable interface

 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   3 -
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   3 -
 drivers/net/ethernet/mellanox/mlx4/main.c     |   2 -
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  13 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 -
 .../mellanox/mlx5/core/sf/dev/driver.c        |   5 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  10 +-
 drivers/net/netdevsim/dev.c                   |   3 -
 include/net/devlink.h                         |  57 +--
 include/trace/events/devlink.h                |  72 ++--
 net/core/devlink.c                            | 390 ++++++++++++------
 12 files changed, 317 insertions(+), 246 deletions(-)

-- 
2.31.1

