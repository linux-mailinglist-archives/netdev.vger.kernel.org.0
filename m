Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91FB3D64EE
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhGZQR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241125AbhGZQPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7AE60E08;
        Mon, 26 Jul 2021 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318553;
        bh=KiYT2j8nMtWjOtRIbK9r30/0y2L7UvokWDcvWYllADE=;
        h=From:To:Cc:Subject:Date:From;
        b=k6sUYTkI7VIIRNaKKox3px0z5PIW/b5l2p28aFOtdVnupD+EIZDpCbSCn6vZ+O65B
         GYB1Xh52qEi58WL6jdnBdeiSQHMMBlyUZ5hBiRuvKAPxv4E/uRP++X7Qp1JZ1TtEC6
         qd0iYGLDa9EyQB5wlGVdoYobcch74CGEV0W9TgF9kzzZYxmblwSyhOG0xocTWYODaZ
         bQW1VM8jqn/BQpIfLaJxCJS2US7q/zyGOS1rLDZI7yLQrnCBluMER8YqCc0MiaV745
         guIhsl0r6CyVWRFZ58UjH5tuUje29DYrGVR9hHN1aCvnUOwpMfLI9ryQRdjA4/zvoM
         LI9U8Kxw6rA2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2021-07-24
Date:   Mon, 26 Jul 2021 09:55:28 -0700
Message-Id: <20210726165544.389143-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series provides some refactoring to mlx5e RX resource management,
it is required for upcoming ADQ and TX lag hashing features.

The first two patches in this series :
  net/mlx5e: Prohibit inner indir TIRs in IPoIB
  net/mlx5e: Block LRO if firmware asks for tunneled LRO
Were supposed to go to net, but due to dependency and timing they were
included here.
I would appreciate it if you'd apply them to net and mark for -stable.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 4431531c482a2c05126caaa9fcc5053a4a5c495b:

  nfp: fix return statement in nfp_net_parse_meta() (2021-07-22 05:46:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-07-24

for you to fetch changes up to 09f83569189f0fabb28472378e99af289b402c0f:

  net/mlx5e: Use the new TIR API for kTLS (2021-07-26 09:50:41 -0700)

----------------------------------------------------------------
mlx5-updates-2021-07-24

This series aims to reduce coupling in mlx5e, particularly between RX
resources (TIRs, RQTs) and numerous code units that use them.

This refactoring is required for upcoming features, ADQ and TX lag
hashing.

The issue with the current code is that TIRs and RQTs are unmanaged,
different places all over the driver create, destroy, track and
configure them, often in an uncoordinated way. The responsibilities of
different units become vague, leading to a lot of hidden dependencies
between numerous units and tight coupling between them, which is prone
to bugs and hard to maintain.

The result of this refactoring is:

1. Creating a manager for RX resources, that controls their lifecycle
and provides a clear API, which restricts the set of actions that other
units can do.

2. Using object-oriented approach for TIRs, RQTs and RX resource
manager (struct mlx5e_rx_res).

3. Fixing a few bugs and misbehaviors found during the refactoring.

4. Reducing the amount of dependencies, removing hidden dependencies,
making them one-directional and organizing the code in clear abstraction
layers.

5. Explicitly exposing the remaining weird dependencies.

6. Simplifying and organizing code that creates and modifies TIRs and
RQTs.

----------------------------------------------------------------
Maxim Mikityanskiy (16):
      net/mlx5e: Prohibit inner indir TIRs in IPoIB
      net/mlx5e: Block LRO if firmware asks for tunneled LRO
      net/mlx5: Take TIR destruction out of the TIR list lock
      net/mlx5e: Check if inner FT is supported outside of create/destroy functions
      net/mlx5e: Convert RQT to a dedicated object
      net/mlx5e: Move mlx5e_build_rss_params() call to init_rx
      net/mlx5e: Move RX resources to a separate struct
      net/mlx5e: Take RQT out of TIR and group RX resources
      net/mlx5e: Use mlx5e_rqt_get_rqtn to access RQT hardware id
      net/mlx5e: Remove mlx5e_priv usage from mlx5e_build_*tir_ctx*()
      net/mlx5e: Remove lro_param from mlx5e_build_indir_tir_ctx_common()
      net/mlx5e: Remove mdev from mlx5e_build_indir_tir_ctx_common()
      net/mlx5e: Create struct mlx5e_rss_params_hash
      net/mlx5e: Convert TIR to a dedicated object
      net/mlx5e: Move management of indir traffic types to rx_res
      net/mlx5e: Use the new TIR API for kTLS

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  64 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  12 +
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c   | 161 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h   |  39 ++
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |  73 ++
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |  47 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   | 200 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h   |  58 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |  27 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  18 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  53 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  27 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  66 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  45 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 740 +++++++++------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 144 ++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  49 +-
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 25 files changed, 1106 insertions(+), 811 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h
