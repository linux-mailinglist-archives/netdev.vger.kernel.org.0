Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33067424D78
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbhJGG5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240233AbhJGG5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 02:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C455361245;
        Thu,  7 Oct 2021 06:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633589724;
        bh=H7TOUe6A7T7LiBmoEChxjG23mV1sfS3VhuwtUlXJPxw=;
        h=From:To:Cc:Subject:Date:From;
        b=DgWzoc93M3NoV2N66cXqwyfRo52yjZlOL9ay2WlX1YVN5mi89PLEq1nWnWGUoDNrR
         Af43AQ8v/L+687s41V471CFzx4TMysoeL0J2IWsl/jhIWyzbYekxFYy1It3YDrpp0A
         JRLaPojUE1UGHBsjVuEVnwoyAABFo7lQbIWkJaB03Y25Nc/v3+xVnOBVlV74vSazRe
         Ik+RRVlGmwawopbeJ0TCp8u7PFgUbH1Qvi5AsmzoUIdms1Ol5bzE14F99ZUaGOVcfb
         yvxCCZSyg6W9U7WPEFpT6KtwPHiO+e4166L3kMHc4nza8VodhwXuIypq6sygxsPDV+
         RxFjkgwJxENiQ==
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
Subject: [PATCH net-next v3 0/5] devlink reload simplification
Date:   Thu,  7 Oct 2021 09:55:14 +0300
Message-Id: <cover.1633589385.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v3:
 * Rewrote third patch to keep static const nature of ops. This is done
   by extracting reload ops to separate ops structure.
 * Changed commit message in last patch as was suggested by Ido. 
v2: https://lore.kernel.org/all/cover.1633284302.git.leonro@nvidia.com
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
  devlink: Allow set reload ops callbacks separately
  net/mlx5: Separate reload devlink ops for multiport device
  devlink: Delete reload enable/disable interface

 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   7 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |  10 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  13 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 -
 .../mellanox/mlx5/core/sf/dev/driver.c        |   5 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  19 +-
 drivers/net/netdevsim/dev.c                   |  13 +-
 include/net/devlink.h                         |  79 ++------
 include/trace/events/devlink.h                |  72 ++++----
 net/core/devlink.c                            | 170 ++++++++++++------
 12 files changed, 216 insertions(+), 184 deletions(-)

-- 
2.31.1

