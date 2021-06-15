Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A53A757E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhFOEDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhFOEDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3705860FEE;
        Tue, 15 Jun 2021 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729688;
        bh=K1Cyatbx7ri5dFBIKUAZZEkhxOPQEkDWc7jyE8coXSc=;
        h=From:To:Cc:Subject:Date:From;
        b=T/ULyIeILh/8kA/ntX3VbkeJr0VskG1W/wV+Nmj8MFwLR4SVFq/95I+Bu74K6fghC
         ybaVr3FFG0LgjMcm2Ijc8Hu+RTafpjLGIlYKcFQFQ9zovfKnMYRvUUfa07M4QPu++u
         CU0yL4dZF486zoCls2DIMkluDWPP3B12eDY3HxZyB4z9WA9DkEolTbXhBIEYxy2VSB
         MArwvEuEU4qsj5vBJD0sP/f6rHDl1kTJFM0AUXfT8UGY2xPqdf6kj0N54hLdEIsIc/
         +lX7FAi+2qdFYahQYWd953JL0HF7IhTGE1giopnHGkg0sbt+qrVaNWKzvpX1nhIQOW
         Wh8dYnMsizR1g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-06-14
Date:   Mon, 14 Jun 2021 21:01:08 -0700
Message-Id: <20210615040123.287101-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides an IRQ allocation scheme update for Sub-Functions
(SFs) Scalability.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 89212e160b81e778f829b89743570665810e3b13:

  net: wwan: Fix WWAN config symbols (2021-06-14 13:17:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-06-14

for you to fetch changes up to c36326d38d933199014aba5a17d384cf52e4b558:

  net/mlx5: Round-Robin EQs over IRQs (2021-06-14 20:58:00 -0700)

----------------------------------------------------------------
mlx5-updates-2021-06-14

1) Trivial Lag refactroing in preparation for upcomming Single FDB lag feature
 - First 3 patches

2) Scalable IRQ distriburion for Sub-functions

A subfunction (SF) is a lightweight function that has a parent PCI
function (PF) on which it is deployed.

Currently, mlx5 subfunction is sharing the IRQs (MSI-X) with their
parent PCI function.

Before this series the PF allocates enough IRQs to cover
all the cores in a system, Newly created SFs will re-use all the IRQs
that the PF has allocated for itself.
Hence, the more SFs are created, there are more EQs per IRQs. Therefore,
whenever we handle an interrupt, we need to pull all SFs EQs and PF EQs
instead of PF EQs without SFs on the system. This leads to a hard impact
on the performance of SFs and PF.

For example, on machine with:
Intel(R) Xeon(R) CPU E5-2697 v3 @ 2.60GHz with 56 cores.
PCI Express 3 with BW of 126 Gb/s.
ConnectX-5 Ex; EDR IB (100Gb/s) and 100GbE; dual-port QSFP28; PCIe4.0 x16.

test case: iperf TX BW single CPU, affinity of app and IRQ are the same.
PF only: no SFs on the system, 56 IRQs.
SF (before), 250 SFs Sharing the same 56 IRQs .
SF (now),    250 SFs + 255 avaiable IRQs for the NIC. (please see IRQ spread scheme below).

	    application SF-IRQ  channel   BW(Gb/sec)         interrupts/sec
            iperf TX            affinity
PF only     cpu={0}     cpu={0} cpu={0}   79                 8200
SF (before) cpu={0}     cpu={0} cpu={0}   51.3 (-35%)        9500
SF (now)    cpu={0}     cpu={0} cpu={0}   78 (-2%)           8200

command:
$ taskset -c 0 iperf -c 11.1.1.1 -P 3 -i 6 -t 30 | grep SUM

The different between the SF examples is that before this series we
allocate num_cpus (56) IRQs, and all of them were shared among the PF
and the SFs. And after this series, we allocate 255 IRQs, and we spread
the SFs among the above IRQs. This have significantly decreased the load
on each IRQ and the number of EQs per IRQ is down by 95% (251->11).

In this patchset the solution proposed is to have a dedicated IRQ pool
for SFs to use. the pool will allocate a large number of IRQs
for SFs to grab from in order to minimize irq sharing between the
different SFs.
IRQs will not be requested from the OS until they are 1st requested by
an SF consumer, and will be eventually released when the last SF consumer
releases them.

For the detailed IRQ spread and allocation scheme  please see last patch:
("net/mlx5: Round-Robin EQs over IRQs")

----------------------------------------------------------------
Leon Romanovsky (3):
      net/mlx5: Delay IRQ destruction till all users are gone
      net/mlx5: Provide cpumask at EQ creation phase
      net/mlx5: Clean license text in eq.[c|h] files

Mark Bloch (3):
      net/mlx5: Lag, refactor disable flow
      net/mlx5: Lag, Don't rescan if the device is going down
      net/mlx5: Change ownership model for lag

Shay Drory (9):
      net/mlx5: Introduce API for request and release IRQs
      net/mlx5: Removing rmap per IRQ
      net/mlx5: Extend mlx5_irq_request to request IRQ from the kernel
      net/mlx5: Moving rmap logic to EQs
      net/mlx5: Change IRQ storage logic from static to dynamic
      net/mlx5: Allocating a pool of MSI-X vectors for SFs
      net/mlx5: Enlarge interrupt field in CREATE_EQ
      net/mlx5: Separate between public and private API of sf.h
      net/mlx5: Round-Robin EQs over IRQs

 drivers/infiniband/hw/mlx5/odp.c                   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 179 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      | 267 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h   |  45 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  25 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |  35 ++
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 608 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h    |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   1 +
 include/linux/mlx5/eq.h                            |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 17 files changed, 794 insertions(+), 435 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
