Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5524E83665
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387729AbfHFQLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387634AbfHFQLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:11:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25B120679;
        Tue,  6 Aug 2019 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107896;
        bh=p2nVIG3E/3bXN/7Joe3Zs+lBEuvu5FF2jMiydSrSjsY=;
        h=From:To:Cc:Subject:Date:From;
        b=1H5YZnYBa3bp4bHOlhfyVyFq7JZqFqgQhOtjHl/AeG8OQ/wuR3Ir47RygQ0SSrI+V
         fmvYGZ4+43hrPTiySjeofca63CBk4Md4vHlIJWbkHBB8ldctq4/Sh6j5VXrWgH1dYl
         0RlQ8aokCgn4U5m5LPchUAFfuoKaZmcjOmSi8dHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 00/17] Networking driver debugfs cleanups
Date:   Tue,  6 Aug 2019 18:11:11 +0200
Message-Id: <20190806161128.31232-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to test the result of any debugfs call anymore.  The
debugfs core warns the user if something fails, and the return value of
a debugfs call can always be fed back into another debugfs call with no
problems.

Also, debugfs is for debugging, so if there are problems with debugfs
(i.e. the system is out of memory) the rest of the kernel should not
change behavior, so testing for debugfs calls is pointless and not the
goal of debugfs at all.

This series cleans up a lot of networking drivers and some wimax code
that was calling debugfs and trying to do something with the return
value that it didn't need to.  Removing this logic makes the code
smaller, easier to understand, and use less run-time memory in some
cases, all good things.

The series is against net-next, and have no dependancies between any of
them if they want to go through any random tree/order.  Or, if wanted,
I can take them through my driver-core tree where other debugfs cleanups
are being slowly fed during major merge windows.

thanks,

greg k-h

Greg Kroah-Hartman (17):
  wimax: no need to check return value of debugfs_create functions
  bonding: no need to print a message if debugfs_create_dir() fails
  mlx5: no need to check return value of debugfs_create functions
  xgbe: no need to check return value of debugfs_create functions
  bnxt: no need to check return value of debugfs_create functions
  cxgb4: no need to check return value of debugfs_create functions
  hns3: no need to check return value of debugfs_create functions
  nfp: no need to check return value of debugfs_create functions
  stmmac: no need to check return value of debugfs_create functions
  dpaa2: no need to check return value of debugfs_create functions
  qca: no need to check return value of debugfs_create functions
  skge: no need to check return value of debugfs_create functions
  mvpp2: no need to check return value of debugfs_create functions
  fm10k: no need to check return value of debugfs_create functions
  i40e: no need to check return value of debugfs_create functions
  ixgbe: no need to check return value of debugfs_create functions
  ieee802154: no need to check return value of debugfs_create functions

 drivers/net/bonding/bond_debugfs.c            |   5 -
 drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c  | 107 ++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   1 -
 .../net/ethernet/broadcom/bnxt/bnxt_debugfs.c |  39 ++---
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   5 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   3 -
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  21 +--
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |  54 +------
 .../freescale/dpaa2/dpaa2-eth-debugfs.h       |   3 -
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  17 +-
 .../net/ethernet/intel/fm10k/fm10k_debugfs.c  |   2 -
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  21 +--
 .../net/ethernet/intel/ixgbe/ixgbe_debugfs.c  |  22 +--
 .../ethernet/marvell/mvpp2/mvpp2_debugfs.c    |  19 +--
 drivers/net/ethernet/marvell/skge.c           |  39 ++---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  51 +-----
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 102 ++----------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  11 +-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   7 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |  17 +-
 drivers/net/ethernet/qualcomm/qca_debug.c     |  13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   2 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  52 +-----
 drivers/net/ieee802154/adf7242.c              |  12 +-
 drivers/net/ieee802154/at86rf230.c            |  20 +--
 drivers/net/ieee802154/ca8210.c               |   9 +-
 drivers/net/wimax/i2400m/debugfs.c            | 149 +++---------------
 drivers/net/wimax/i2400m/driver.c             |   7 +-
 drivers/net/wimax/i2400m/i2400m.h             |   7 +-
 drivers/net/wimax/i2400m/usb.c                |  61 ++-----
 include/linux/mlx5/driver.h                   |  12 +-
 include/linux/wimax/debug.h                   |  20 +--
 net/wimax/debugfs.c                           |  42 +----
 net/wimax/stack.c                             |  11 +-
 net/wimax/wimax-internal.h                    |   7 +-
 37 files changed, 175 insertions(+), 799 deletions(-)

-- 
2.22.0

