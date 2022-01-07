Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192A4486ECA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbiAGAaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiAGAaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C500C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D19C361DE7
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A975C36AE0;
        Fri,  7 Jan 2022 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515410;
        bh=pl2BwedS2muffgmhhvR7C4DLU9Fw9pKwxVkRoc3c6LM=;
        h=From:To:Cc:Subject:Date:From;
        b=s3BcY7rv3cepeJvnEwNsymnYpnXFfNp9T8A/kiZeYFjRA22nrtJcf+FSNK2txLzS6
         jTNCffP9gKJ12jWGlsa/HgIibJScdhkQtXsZFZ8Rxg2RD3h9RZwKAqgCGfXUIBO2PV
         59MappuHyeCMnBqDMgcQwge+4zSpi8a14KV2pLDn/Dr63/pZqeOW+MRmGE8ymT56bU
         V0XnuFJA+sfZfL56kc9QkfHb7uxUq4mPzdlBCbjE7K0zQrJjkP1xGGBFHTpAnKeM9Q
         ymPOCCYD1G40+lhzW0ZA/qF3FLm7zLBZ5vHJIj+717w1FMaUQQsHAeJv/m/A4Ar4vi
         Cgo4weALEvj0A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-01-06
Date:   Thu,  6 Jan 2022 16:29:41 -0800
Message-Id: <20220107002956.74849-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series adds misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 710ad98c363a66a0cd8526465426c5c5f8377ee0:

  veth: Do not record rx queue hint in veth_xmit (2022-01-06 13:49:54 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-01-06

for you to fetch changes up to 745a13061aa079b36d83ba7f36dc051dbfccd888:

  Documentation: devlink: mlx5.rst: Fix htmldoc build warning (2022-01-06 16:22:55 -0800)

----------------------------------------------------------------
mlx5-updates-2022-01-06

1) Expose FEC per lane block counters via ethtool

2) Trivial fixes/updates/cleanup to mlx5e netdev driver

3) Fix htmldoc build warning

4) Spread mlx5 SFs (sub-functions) to all available CPU cores: Commits 1..5

Shay Drory Says:
================
Before this patchset, mlx5 subfunction shared the same IRQs (MSI-X) with
their peers subfunctions, causing them to use same CPU cores.

In large scale, this is very undesirable, SFs use small number of cpu
cores and all of them will be packed on the same CPU cores, not
utilizing all CPU cores in the system.

In this patchset we want to achieve two things.
 a) Spread IRQs used by SFs to all cpu cores
 b) Pack less SFs in the same IRQ, will result in multiple IRQs per core.

In this patchset, we spread SFs over all online cpus available to mlx5
irqs in Round-Robin manner. e.g.: Whenever a SF is created, pick the next
CPU core with least number of SF IRQs bound to it, SFs will share IRQs on
the same core until a certain limit, when such limit is reached, we
request a new IRQ and add it to that CPU core IRQ pool, when out of IRQs,
pick any IRQ with least number of SF users.

This enhancement is done in order to achieve a better distribution of
the SFs over all the available CPUs, which reduces application latency,
as shown bellow.

Machine details:
Intel(R) Xeon(R) CPU E5-2697 v3 @ 2.60GHz with 56 cores.
PCI Express 3 with BW of 126 Gb/s.
ConnectX-5 Ex; EDR IB (100Gb/s) and 100GbE; dual-port QSFP28; PCIe4.0
x16.

Base line test description:
Single SF on the system. One instance of netperf is running on-top the
SF.
Numbers: latency = 15.136 usec, CPU Util = 35%

Test description:
There are 250 SFs on the system. There are 3 instances of netperf
running, on-top three different SFs, in parallel.

Perf numbers:
 # netperf     SFs         latency(usec)     latency    CPU utilization
   affinity    affinity    (lower is better) increase %
 1 cpu=0       cpu={0}     ~23 (app 1-3)     35%        75%
 2 cpu=0,2,4   cpu={0}     app 1: 21.625     30%        68% (CPU 0)
                           app 2-3: 16.5     9%         15% (CPU 2,4)
 3 cpu=0       cpu={0,2,4} app 1: ~16        7%         84% (CPU 0)
                           app 2-3: ~17.9    14%        22% (CPU 2,4)
 4 cpu=0,2,4   cpu={0,2,4} 15.2 (app 1-3)    0%         33% (CPU 0,2,4)

 - The first two entries (#1 and #2) show current state. e.g.: SFs are
   using the same CPU. The last two entries (#3 and #4) shows the latency
   reduction improvement of this patch. e.g.: SFs are on different CPUs.
 - Whenever we use several CPUs, in case there is a different CPU
   utilization, write the utilization of each CPU separately.
 - Whenever the latency result of the netperf instances were different,
   write the latency of each netperf instances separately.

Commands:
 - for netperf CPU=0:
$ for i in {1..3}; do taskset -c 0 netperf -H 1${i}.1.1.1 -t TCP_RR  -- \
  -o RT_LATENCY -r8 & done

 - for netperf CPU=0,2,4
$ for i in {1..3}; do taskset -c $(( ($i - 1) * 2  )) netperf -H \
  1${i}.1.1.1 -t TCP_RR  -- -o RT_LATENCY -r8 & done

================

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix feature check per profile

Gal Pressman (2):
      net/mlx5e: Move HW-GRO and CQE compression check to fix features flow
      net/mlx5e: Add recovery flow in case of error CQE

Lama Kayal (1):
      net/mlx5e: Expose FEC counters via ethtool

Maher Sanalla (1):
      net/mlx5: Update log_max_qp value to FW max capability

Maor Dickman (1):
      net/mlx5e: Unblock setting vid 0 for VF in case PF isn't eswitch manager

Roi Dayan (1):
      net/mlx5e: TC, Remove redundant error logging

Saeed Mahameed (3):
      net/mlx5: mlx5e_hv_vhca_stats_create return type to void
      net/mlx5e: Refactor set_pflag_cqe_based_moder
      Documentation: devlink: mlx5.rst: Fix htmldoc build warning

Shay Drory (5):
      net/mlx5: Introduce control IRQ request API
      net/mlx5: Move affinity assignment into irq_request
      net/mlx5: Split irq_pool_affinity logic to new file
      net/mlx5: Introduce API for bulk request and release of IRQs
      net/mlx5: SF, Use all available cpu for setting cpu affinity

 Documentation/networking/devlink/mlx5.rst          |   1 +
 drivers/infiniband/hw/mlx5/odp.c                   |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   8 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h |  13 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   8 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 101 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 104 +++++--
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c | 226 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 308 +++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h  |  39 +++
 include/linux/mlx5/eq.h                            |   4 +-
 19 files changed, 675 insertions(+), 236 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
