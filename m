Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8368E25CBB7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgICVAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:00:36 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6021 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgICVAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5159650000>; Thu, 03 Sep 2020 14:00:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 14:00:35 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 03 Sep 2020 14:00:35 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Sep
 2020 21:00:35 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/10] mlx5 Multi packet tx descriptors for SKBs
Date:   Thu, 3 Sep 2020 14:00:12 -0700
Message-ID: <20200903210022.22774-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599166821; bh=8JERQfDFxK0zySY2XRnjDaCVzTiDw9X5xiGHNeGeUKc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=c5RMX9ExTWurDtNlJVhLcTGHxcGkspwF+AR1nGoEvZYtSWVpm+9ds2a9vgsw4M7Dp
         EwR7mi38MtTrwoMgtqX4NT6DDX4IUJRR0EO+x/RQAcRCBdAedeXqedwOb/Xd8hyrB8
         K5BTte7gb9ogP06G2pQ4Pz6qqszE1Dyx9ngNwyYmsMEzzp4kX43+7mjwP3PBJDQP5n
         pA4FaYjQDLjcQjbChYmOhUBmGY6aYnzr4ndXL72l8W7pOxRgJbv9G19BS5ersm1cP2
         7g4yeDCF57/UA/pX3qhrP+SzLYDmjTTZUA0sg9I99pkEyzEjQOwW7IpwkXSArWghCb
         sx8H8byH1Xiig==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub

This series adds support for Multi packet tx descriptors for SKBs.
For more information please see tag log below.

One note that is worth mentioning here, is that Maxim had to do some
manual function inlining in the tx c file to avoid performance drop due
to refactoring and functions extraction for re-use, I hope this is not a
big deal, as the other way around this is to avoid code reuse which
makes the mlx5 tx path __uglier__.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 08aaa0819d5cce78a10c2fcea17057d07698691f=
:

  Merge branch 'l2tp-miscellaneous-cleanups' (2020-09-03 12:19:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-09-03

for you to fetch changes up to b960a70f9cf90524f2b4e67d202e7240c3ef6928:

  net/mlx5e: Enhanced TX MPWQE for SKBs (2020-09-03 13:56:10 -0700)

----------------------------------------------------------------
mlx5-updates-2020-09-03

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

Due to this refactoring and the increase of helper functions,
Maxim had to manually tune inlining of these functions in the tx.c file to
get the maximum performance and the expected results of MPWQE.

Performance effect:

All of the changes below are tested with packet rate udp and pktgen
tests, no performance impact seen on TCP single stream test and
XDP_TX single stream test.

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx

1)  Refactoring #1: Refactor xmit functions & manual inlining
This change has no performance impact in TCP single stream test and
XDP_TX single stream test.

UDP pktgen (burst 32), single stream:
  Packet rate: 17.55 Mpps -> 19.23 Mpps
  Instructions per packet: 420 -> 360
  Cycles per packet: 165 -> 142

2) Refactoring #2: Support multiple SKBs in a TX WQE
First building block needed to support multple SKBs in downstream MPWQE

UDP pktgen (burst 32), single stream:
  Packet rate: 19.23 Mpps -> 19.12 Mpps
  Instructions per packet: 360 -> 354
  Cycles per packet: 142 -> 140

3) MPWQE Feature for SKBs (final patch)

UDP pktgen, 64-byte packets, single stream, MPWQE off:
  Packet rate: 19.12 Mpps -> 20.02 Mpps
  Instructions per packet: 354 -> 347
  Cycles per packet: 140 -> 129

UDP pktgen, 64-byte packets, single stream, MPWQE on:
  Packet rate: 19.12 Mpps -> 20.67 Mpps
  Instructions per packet: 354 -> 335
  Cycles per packet: 140 -> 124

Enabling MPWQE can reduce PCI bandwidth:
  PCI Gen2, pktgen at fixed rate of 36864000 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 81.3%
    Inbound PCI utilization with MPWQE on: 59.3%
  PCI Gen3, pktgen at fixed rate of 56064005 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 65.8%
    Inbound PCI utilization with MPWQE on: 49.2%

Enabling MPWQE can also reduce CPU load, increasing the packet rate in
case of CPU bottleneck:
  PCI Gen2, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 37.4 Mpps
    Packet rate with MPWQE on: 49.1 Mpps
  PCI Gen3, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 56.2 Mpps
    Packet rate with MPWQE on: 67.0 Mpps

Burst size in all pktgen tests is 32.

To avoid performance degradation when MPWQE is off, manual optimizations
of function inlining were performed. It's especially important to have
mlx5e_sq_xmit_mpwqe noinline, otherwise gcc inlines it automatically and
bloats mlx5e_xmit, slowing it down, which reduces the maximum gain seen by
MPWQE, and in order to avoid this, we had two options
1. drop the refactoring and duplicate the TX data path to have 2 huge
functions.
2. refactoring and code reuse with manual inlining, as we did in this
series.

-Saeed.

----------------------------------------------------------------
Maxim Mikityanskiy (10):
      net/mlx5e: Refactor inline header size calculation in the TX path
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
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 102 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  33 +-
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
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 653 +++++++++++++++--=
----
 14 files changed, 659 insertions(+), 327 deletions(-)
