Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2926C2738D4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgIVCrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbgIVCrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:40 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FED621D91;
        Tue, 22 Sep 2020 02:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742859;
        bh=go76/gtrCUB4fYQ1TDhirXuakes8xpjdWKgI8ms4fd4=;
        h=From:To:Cc:Subject:Date:From;
        b=H97tGA/OKSNQYcRuA212hSrL66XfLesocCgc7g0d6cpSG+5aDc0Q1aN7ABBlRWxn5
         Btj6DO5UHKyTqrXVv7t7VponthAL0zvGjjN7FOJT6Z9YL9vfvMN7VdwXTasUp7mdo7
         5+3bTmg7sLys/jIkaCcQfZBSZoeOLM9gXXdA5pFI=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V3 00/12] mlx5 Multi packet tx descriptors for SKBs
Date:   Mon, 21 Sep 2020 19:46:52 -0700
Message-Id: <20200922024704.544482-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave & Jakub

This series adds support for Multi packet tx descriptors for SKBs.
For more information please see tag log below.

v1->v2:
 - Move small irrelevant changes from the refactoring patch to separate
patches.
 - Don't touch mlx5e_txwqe_build_eseg_csum without need.

v2->v3:
Manual inlining was dropped, test results were updated for GCC 10. The
previous numbers were measured on a kernel compiled with GCC 4.9, and it
turns out that the new GCC optimizes code in a different way, and manual
inlining is not needed to avoid performance degradation with GCC 10.


Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit c5a2a132a38619d24d6d115c66cc277594b4fe01:

  Merge tag 'linux-can-next-for-5.10-20200921' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next (2020-09-21 14:57:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-09-21

for you to fetch changes up to 5af75c747e2a868abbf8611494b50ed5e076fca7:

  net/mlx5e: Enhanced TX MPWQE for SKBs (2020-09-21 19:41:16 -0700)

----------------------------------------------------------------
mlx5-updates-2020-09-21

Multi packet TX descriptor support for SKBs.

This series introduces some refactoring of the regular TX data path in
mlx5 and adds the Enhanced TX MPWQE feature support. MPWQE stands for
multi-packet work queue element, and it can serve multiple packets,
reducing the PCI bandwidth spent on control traffic. It should improve
performance in scenarios where PCI is the bottleneck, and xmit_more is
signaled by the kernel. The refactoring done in this series also
improves the packet rate on its own.

MPWQE is already implemented in the XDP tx path, this series adds the
support of MPWQE for regular kernel SKB tx path.

MPWQE is supported from ConnectX-5 and onward, for legacy devices we need
to keep backward compatibility for regular (Single packet) WQE descriptor.

MPWQE is not compatible with certain offloads and features, such as TLS
offload, TSO, nonlinear SKBs. If such incompatible features are in use,
the driver gracefully falls back to non-MPWQE per SKB.

Prior to the final patch "net/mlx5e: Enhanced TX MPWQE for SKBs" that adds
the actual support, Maxim did some refactoring to the tx data path to
split it into stages and smaller helper functions that can be utilized and
reused for both legacy and new MPWQE feature.

Performance testing:

UDP performance is improved in a single stream pktgen test:
  Packet rate: 16.86 Mpps (±0.15 Mpps) -> 20.94 Mpps (±0.33 Mpps)
  Instructions per packet: 434 -> 329
  Cycles per packet: 158 -> 123
  Instructions per cycle: 2.75 -> 2.67

TCP and XDP_TX single stream tests show no performance difference.

MPWQE can reduce PCI bandwidth:
  PCI Gen2, pktgen at fixed rate of 36864000 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 80.3%
    Inbound PCI utilization with MPWQE on: 59.0%
  PCI Gen3, pktgen at fixed rate of 56064000 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 65.4%
    Inbound PCI utilization with MPWQE on: 49.3%

MPWQE can also reduce CPU load, increasing the packet rate in case of
CPU bottleneck:
  PCI Gen2, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 37.5 Mpps
    Packet rate with MPWQE on: 49.0 Mpps
  PCI Gen3, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 57.0 Mpps
    Packet rate with MPWQE on: 66.8 Mpps

Burst size in all pktgen tests is 32.

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx
GCC 10.2.0

----------------------------------------------------------------
Maxim Mikityanskiy (12):
      net/mlx5e: Refactor inline header size calculation in the TX path
      net/mlx5e: Use struct assignment to initialize mlx5e_tx_wqe_info
      net/mlx5e: Move mlx5e_tx_wqe_inline_mode to en_tx.c
      net/mlx5e: Refactor xmit functions
      net/mlx5e: Small improvements for XDP TX MPWQE logic
      net/mlx5e: Unify constants for WQE_EMPTY_DS_COUNT
      net/mlx5e: Move the TLS resync check out of the function
      net/mlx5e: Support multiple SKBs in a TX WQE
      net/mlx5e: Generalize TX MPWQE checks for full session
      net/mlx5e: Rename xmit-related structs to generalize them
      net/mlx5e: Move TX code into functions to be used by MPWQE
      net/mlx5e: Enhanced TX MPWQE for SKBs

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  83 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  35 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  60 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  32 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   3 -
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |  20 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 632 +++++++++++++++------
 14 files changed, 637 insertions(+), 311 deletions(-)
