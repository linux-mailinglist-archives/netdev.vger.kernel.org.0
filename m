Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB2A2D3372
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgLHUT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgLHUT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:19:26 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V3 00/15] mlx5 updates 2020-12-01
Date:   Tue,  8 Dec 2020 11:35:40 -0800
Message-Id: <20201208193555.674504-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Jakub,

v1->v2: Removed merge commit of mlx5-next.

v2->v3: 
  - Add accuracy improvement measurements.
  - Apply the accurate stamping only on PTP port and not all UDP.

This series adds port tx timestamping support and some misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---

The following changes since commit 8e98387b16b88440b06e57965f6b2d789acd9451:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2020-12-07 18:36:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-12-01

for you to fetch changes up to 2f6b379cca4cdf5e04f759c2a15933f82dc6ab0b:

  net/mlx5e: Fill mlx5e_create_cq_param in a function (2020-12-08 11:28:49 -0800)

----------------------------------------------------------------
mlx5-updates-2020-12-01

mlx5e port TX timestamping support and MISC updates

1) Add support for port TX timestamping, for better PTP accuracy.

Currently in mlx5 HW TX timestamping is done on CQE (TX completion)
generation, which much earlier than when the packet actually goes out to
the wire, in this series Eran implements the option to do timestamping on
the port using a special SQ (Send Queue), such Send Queue will generate 2
CQEs (TX completions), the original one and a new one when the packet
leaves the port, due to the nature of this special handling, such mechanism
is an opt-in only and it is off by default to avoid any performance
degradation on normal traffic flows.

This patchset improves TX Hardware timestamping offset to be less than
40ns at a 100Gbps line rate, compared to 600ns before.

With that, making our HW compliant with G.8273.2 class C, and allow Linux
systems to be deployed in the 5G telco edge, where this standard is a must.

2) Misc updates and trivial improvements.

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Allow CQ outside of channel context
      net/mlx5e: Allow RQ outside of channel context
      net/mlx5e: Split between RX/TX tunnel FW support indication

Eran Ben Elisha (6):
      net/mlx5e: Allow SQ outside of channel context
      net/mlx5e: Change skb fifo push/pop API to be used without SQ
      net/mlx5e: Split SW group counters update function
      net/mlx5e: Move MLX5E_RX_ERR_CQE macro
      net/mlx5e: Add TX PTP port object support
      net/mlx5e: Add TX port timestamp support

Maxim Mikityanskiy (1):
      net/mlx5e: Fill mlx5e_create_cq_param in a function

Shay Drory (1):
      net/mlx5: Arm only EQs with EQEs

Tariq Toukan (1):
      net/mlx5e: Free drop RQ in a dedicated function

YueHaibing (2):
      net/mlx5e: Remove duplicated include
      net/mlx5: Fix passing zero to 'PTR_ERR'

Zhu Yanjun (1):
      net/mlx5e: remove unnecessary memset

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  63 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  16 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 529 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  63 +++
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  52 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 215 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   9 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  33 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 253 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 403 +++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  11 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  84 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   6 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |   2 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   1 -
 27 files changed, 1493 insertions(+), 350 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
