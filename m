Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33127421B8F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhJEBQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhJEBQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 375AD613AC;
        Tue,  5 Oct 2021 01:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396482;
        bh=p5JkSnhi5Ucg88ouHjYa/GnID3KuGBkRL/7Q0U6KlHI=;
        h=From:To:Cc:Subject:Date:From;
        b=lKhQGVKh0ZiXSjqS8C17fzSWSAK6EI9XuWhnUi/V0SbSYLSP60yYc0Pw9eZieTezp
         5yBITu8NpnWvwRYXPawJ9/imWrpRHNxh53GIEMDrsm6Exp7WzKvs3NbcinfKwXBIVs
         DdaJGkPN/JV37F9wu8YXUCqA1MXj+TaRp/ZpgsULhY7p4Dcwq2watHdoedWWpChSBP
         Jxhha7VfgNTWA8mO3shD4JTu+bJpq33/oePQbk1wlrGxA5FMrtlDyZ5WUBBmbY1AkP
         afwUwyVD2OkWopbulr4z9lSJmsCOYkZ/t4E8TG9tOe0S+962aZiz6Vzcecl47/0D/r
         NqYKIYTH1XItQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-10-04
Date:   Mon,  4 Oct 2021 18:12:47 -0700
Message-Id: <20211005011302.41793-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series introduces some misc updates to mlx5.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 1660034361904dfcb82714aa48615a9b66462ee6:

  Merge branch 'phy-10g-mode-helper' (2021-10-04 13:50:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-10-04

for you to fetch changes up to f891b7cdbdcda116fd26bbd706f91bd58567aa17:

  net/mlx5: Enable single IRQ for PCI Function (2021-10-04 18:10:57 -0700)

----------------------------------------------------------------
mlx5-updates-2021-10-04

Misc updates for mlx5 driver

1) Add TX max rate support for MQPRIO channel mode
2) Trivial TC action and modify header refactoring
3) TC support for accept action in fdb offloads
4) Allow single IRQ for PCI functions

5) Bridge offload: Pop PVID VLAN header on egress miss

Vlad Buslov says:
=================

With current architecture of mlx5 bridge offload it is possible for a
packet to match in ingress table by source MAC (resulting VLAN header push
in case of port with configured PVID) and then miss in egress table when
destination MAC is not in FDB. Due to the lack of hardware learning in
NICs, this, in turn, results packet going to software data path with PVID
VLAN already added by hardware. This doesn't break software bridge since it
accepts either untagged packets or packets with any provisioned VLAN on
ports with PVID, but can break ingress TC, if affected part of Ethernet
header is matched by classifier.

Improve compatibility with software TC by restoring the packet header on
egress miss. Effectively, this change implements atomicity of mlx5 bridge
offload implementation - packet is either modified and redirected to
destination port or appears unmodified in software.

=================

----------------------------------------------------------------
Chris Mi (1):
      net/mlx5e: Specify out ifindex when looking up encap route

Roi Dayan (4):
      net/mlx5e: TC, Refactor sample offload error flow
      net/mlx5e: Move mod hdr allocation to a single place
      net/mlx5e: Split actions_match_supported() into a sub function
      net/mlx5e: Move parse fdb check into actions_match_supported_fdb()

Shay Drory (2):
      net/mlx5: Shift control IRQ to the last index
      net/mlx5: Enable single IRQ for PCI Function

Tariq Toukan (2):
      net/mlx5e: Specify SQ stats struct for mlx5e_open_txqsq()
      net/mlx5e: Add TX max rate support for MQPRIO channel mode

Vlad Buslov (6):
      net/mlx5e: Reserve a value from TC tunnel options mapping
      net/mlx5e: Support accept action
      net/mlx5: Bridge, refactor eswitch instance usage
      net/mlx5: Bridge, extract VLAN pop code to dedicated functions
      net/mlx5: Bridge, mark reg_c1 when pushing VLAN
      net/mlx5: Bridge, pop VLAN on egress table miss

 drivers/infiniband/hw/mlx5/odp.c                   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   | 102 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |   9 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  21 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   8 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 106 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 179 +++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   9 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   | 227 ++++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   8 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   6 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  36 ++--
 include/linux/mlx5/driver.h                        |   2 +
 include/linux/mlx5/eq.h                            |   1 -
 include/linux/mlx5/eswitch.h                       |   9 +
 21 files changed, 597 insertions(+), 149 deletions(-)
