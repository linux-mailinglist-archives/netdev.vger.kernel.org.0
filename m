Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050D52FB8DE
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406093AbhASN4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:56:46 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35117 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390640AbhASMJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 07:09:14 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maximmi@mellanox.com)
        with SMTP; 19 Jan 2021 14:08:15 +0200
Received: from dev-l-vrt-208.mtl.labs.mlnx (dev-l-vrt-208.mtl.labs.mlnx [10.234.208.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10JC8FR1021916;
        Tue, 19 Jan 2021 14:08:15 +0200
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 0/5] HTB offload
Date:   Tue, 19 Jan 2021 14:08:10 +0200
Message-Id: <20210119120815.463334-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for HTB offload to the HTB qdisc, and adds
usage to mlx5 driver.

The previous RFCs are available at [1], [2].

The feature is intended to solve the performance bottleneck caused by
the single lock of the HTB qdisc, which prevents it from scaling well.
The HTB algorithm itself is offloaded to the device, eliminating the
need to take the root lock of HTB on every packet. Classification part
is done in clsact (still in software) to avoid acquiring the lock, which
imposes a limitation that filters can target only leaf classes.

The speedup on Mellanox ConnectX-6 Dx was 14.2 times in the UDP
multi-stream test, compared to software HTB implementation (more details
in the mlx5 patch).

[1]: https://www.spinics.net/lists/netdev/msg628422.html
[2]: https://www.spinics.net/lists/netdev/msg663548.html

v2 changes:

Fixed sparse and smatch warnings. Formatted HTB patches to 80 chars per
line.

v3 changes:

Fixed the CI failure on parisc with 16-bit xchg by replacing it with
WRITE_ONCE. Fixed the capability bits in mlx5_ifc.h and the value of
MLX5E_QOS_MAX_LEAF_NODES.

v4 changes:

Check if HTB is root when offloading. Add extack for hardware errors.
Rephrase explanations of how it works in the commit message. Remove %hu
from format strings. Add resiliency when leaf_del_last fails to create a
new leaf node.

Maxim Mikityanskiy (5):
  net: sched: Add multi-queue support to sch_tree_lock
  net: sched: Add extack to Qdisc_class_ops.delete
  sch_htb: Hierarchical QoS hardware offload
  sch_htb: Stats for offloaded HTB
  net/mlx5e: Support HTB offload

 .../net/ethernet/mellanox/mlx5/core/Makefile  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 984 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  44 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  21 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 176 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 100 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  47 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  26 +
 drivers/net/ethernet/mellanox/mlx5/core/qos.c |  85 ++
 drivers/net/ethernet/mellanox/mlx5/core/qos.h |  30 +
 include/linux/mlx5/mlx5_ifc.h                 |  13 +-
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_cls.h                         |  36 +
 include/net/sch_generic.h                     |  17 +-
 include/uapi/linux/pkt_sched.h                |   1 +
 net/sched/sch_api.c                           |   7 +-
 net/sched/sch_atm.c                           |   3 +-
 net/sched/sch_cbq.c                           |   3 +-
 net/sched/sch_drr.c                           |   3 +-
 net/sched/sch_dsmark.c                        |   3 +-
 net/sched/sch_hfsc.c                          |   3 +-
 net/sched/sch_htb.c                           | 557 +++++++++-
 net/sched/sch_qfq.c                           |   3 +-
 net/sched/sch_sfb.c                           |   3 +-
 tools/include/uapi/linux/pkt_sched.h          |   1 +
 29 files changed, 2113 insertions(+), 93 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.h

-- 
2.25.1

