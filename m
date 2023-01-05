Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE85165E49D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjAEES7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjAEES0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B063D9D5;
        Wed,  4 Jan 2023 20:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C7C9B8198C;
        Thu,  5 Jan 2023 04:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A82AC433EF;
        Thu,  5 Jan 2023 04:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892293;
        bh=kkJDa+a0mL5jZf4N8yRY6oImqyNPWCQcQMcccP2bC98=;
        h=From:To:Cc:Subject:Date:From;
        b=GV3zsEOyUS3TqbJBxe31iEHb+q749l9ESez1W35/kp766inmGp4MkGmkm+ytL5Bh2
         BSYJA9D0C+x8uO5WVAjP83Gk1b+eUyjs8lgoKyxiYNi87DgfWqoFsqH2Vy2ndANns0
         95XsHycqYYNBs0/bIx8XPrjYJv7NkTxUKTVrAUYhdJX0OqTq/myVNr4vxgx2bItVnK
         IRLEYPhBqs3UrI57AvqTWc81HY9+d/zn9wb09PDSw0G2rVOFq/O/wAKzOok1sgA/Cz
         SCbSnhpUUDZWBM77yaXoqL3DkgF2rb/R2ZOkb4LJxKTsDfGEE7Vjaike/K0JYfUPqf
         6gMIvRtWkHgUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev events fixes in RDMA
Date:   Wed,  4 Jan 2023 20:17:48 -0800
Message-Id: <20230105041756.677120-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series includes mlx5 modifications for both net-next and
rdma-next trees.

In case of no objections, this series will be applied to net-mlx5 branch
first then sent in PR to both rdma and net trees.

1) From Jiri: fixe a deadlock in mlx5_ib's netdev notifier unregister.
2) From Mark and Patrisious: add IPsec RoCEv2 support.

Thanks,
Saeed.

Jiri Pirko (3):
  net/mlx5e: Fix trap event handling
  net/mlx5e: Propagate an internal event in case uplink netdev changes
  RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier
    unregister

Mark Zhang (4):
  net/mlx5: Implement new destination type TABLE_TYPE
  net/mlx5: Add IPSec priorities in RDMA namespaces
  net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
  net/mlx5: Configure IPsec steering for egress RoCEv2 traffic

Patrisious Haddad (1):
  net/mlx5: Introduce new destination type TABLE_TYPE

 drivers/infiniband/hw/mlx5/main.c             |  78 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   3 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   9 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   5 +
 .../mellanox/mlx5/core/diag/fs_tracepoint.c   |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  59 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/events.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   6 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  44 ++-
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.c    | 372 ++++++++++++++++++
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.h    |  20 +
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |   5 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  20 +
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   5 +
 include/linux/mlx5/fs.h                       |   3 +
 include/linux/mlx5/mlx5_ifc.h                 |  12 +-
 21 files changed, 614 insertions(+), 53 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h

-- 
2.38.1

