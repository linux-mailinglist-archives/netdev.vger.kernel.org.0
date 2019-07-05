Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC93760957
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfGEPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:30:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52421 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727907AbfGEPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:51 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOZ029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Date:   Fri,  5 Jul 2019 18:30:10 +0300
Message-Id: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series from Eran and me, adds TLS TX HW offload support to
the mlx5 driver.

This offloads the kTLS encryption process from kernel to the 
Mellanox NIC, saving CPU cycles and improving utilization.

Upon a new TLS connection request, driver is responsible to create
a dedicated HW context and configure it according to the crypto info,
so HW can do the encryption itself.

When the HW context gets out-of-sync (i.e. due to packets retransmission),
driver is responsible for the re-sync process.
This is done by posting special resync descriptors to the HW.

Feature is supported on Mellanox Connect-X 6DX, and newer.
Series was tested on SimX simulator.

Series generated against net-next commit [1], with Saeed's request pulled [2]:

[1] c4cde5804d51 Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
[2] git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2019-07-04-v2

Changes from last pull request:
Fixed comments from Jakub:
Patch 4:
- Replace zero  memset with a call to memzero_explicit().
Patch 11:
- Fix stats counters names.
- Drop TLS SKB with non-matching netdev.

Regards,
Tariq

Eran Ben Elisha (1):
  net/mlx5e: Tx, Don't implicitly assume SKB-less wqe has one WQEBB

Tariq Toukan (11):
  net/mlx5: Accel, Expose accel wrapper for IPsec FPGA function
  net/mlx5: Kconfig, Better organize compilation flags
  net/mlx5: Add crypto library to support create/destroy encryption key
  net/mlx5: Accel, Add core TLS support for the Connect-X family
  net/mlx5e: Move helper functions to a new txrx datapath header
  net/mlx5e: Tx, Enforce L4 inline copy when needed
  net/mlx5e: Tx, Make SQ WQE fetch function type generic
  net/mlx5e: Tx, Unconstify SQ stop room
  net/mlx5e: Re-work TIS creation functions
  net/mlx5e: Introduce a fenced NOP WQE posting function
  net/mlx5e: Add kTLS TX HW offload support

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  52 ++-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  |   9 +
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.c    |  45 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |  51 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 114 +----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 208 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  93 +++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  97 +++++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 459 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  11 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   7 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  28 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  14 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  98 ++---
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |  75 ----
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  14 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   |  72 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 include/linux/mlx5/accel.h                         |   2 +-
 31 files changed, 1232 insertions(+), 287 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c

-- 
1.8.3.1

