Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AEA36289B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbhDPT2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232796AbhDPT2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 15:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D78E60FF1;
        Fri, 16 Apr 2021 19:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618601270;
        bh=fFnA2V6uQPLRhgEr/56PvYBekrlk8/m61Wvr4T6Mt2A=;
        h=From:To:Cc:Subject:Date:From;
        b=LC6jfTbYZd9cqfB+rIiWm6ZBaSOwWMJDoZJBhB0+lTVZP1u4LUkpsWIsewmw0Kxlj
         4D7J5+fTGDUE54ALlzQGX1B8aIbuGPpoma0CRZko/l8JafxMtTgRbcihz6Rwy2hQga
         yPr7lpi67/HchFxJV0MpT68d7BFpjUYpq+rjjd0QjCjX4suY9AHVQOT9oCSuHGHS3L
         Ehqzq+LbDbZKJCOQ/UmxuvBBx2hpLUphAPTMJ6PGoYJy51Ml/ZDYztfMhKpJD0+4YU
         x4Y/wNALLjPwB+wUr99V068RLMd2EmwyGxez6yCGxbIEL90JRabpqdLwV3sy0YWqiY
         Gm4UZG6O9NknA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/9] ethtool: add uAPI for reading standard stats
Date:   Fri, 16 Apr 2021 12:27:36 -0700
Message-Id: <20210416192745.2851044-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continuing the effort of providing a unified access method
to standard stats, and explicitly tying the definitions to
the standards this series adds an API for general stats
which do no fit into more targeted control APIs.

There is nothing clever here, just a netlink API for dumping
statistics defined by standards and RFCs which today end up
in ethtool -S under infinite variations of names.

This series adds basic IEEE stats (for PHY, MAC, Ctrl frames)
and RMON stats. AFAICT other RFCs only duplicate the IEEE
stats.

This series does _not_ add a netlink API to read driver-defined
stats. There seems to be little to gain from moving that part
to netlink.

The netlink message format is very simple, and aims to allow
adding stats and groups with no changes to user tooling (which
IIUC is expected for ethtool).

On user space side we can re-use -S, and make it dump
standard stats if --groups are defined.

$ ethtool -S eth0 --groups eth-phy eth-mac eth-ctrl rmon
Stats for eth0:
eth-phy-SymbolErrorDuringCarrier: 0
eth-mac-FramesTransmittedOK: 0
eth-mac-FrameTooLongErrors: 0
eth-ctrl-MACControlFramesTransmitted: 0
eth-ctrl-MACControlFramesReceived: 1
eth-ctrl-UnsupportedOpcodesReceived: 0
rmon-etherStatsUndersizePkts: 0
rmon-etherStatsJabbers: 0
rmon-rx-etherStatsPkts64Octets: 1
rmon-rx-etherStatsPkts128to255Octets: 0
rmon-rx-etherStatsPkts1024toMaxOctets: 1
rmon-tx-etherStatsPkts64Octets: 1
rmon-tx-etherStatsPkts128to255Octets: 0
rmon-tx-etherStatsPkts1024toMaxOctets: 1

v1:

Driver support for mlxsw, mlx5 and bnxt included.

Compared to the RFC I went ahead with wrapping the stats into
a 1:1 nest. Now IDs of stats can start from 0, at a cost of
slightly "careful" u64 alignment handling.

v2:

Add missing kdoc in patch 5.

Jakub Kicinski (9):
  docs: networking: extend the statistics documentation
  docs: ethtool: document standard statistics
  ethtool: add a new command for reading standard stats
  ethtool: add interface to read standard MAC stats
  ethtool: add interface to read standard MAC Ctrl stats
  ethtool: add interface to read RMON stats
  mlxsw: implement ethtool standard stats
  bnxt: implement ethtool standard stats
  mlx5: implement ethtool standard stats

 Documentation/networking/ethtool-netlink.rst  |  82 ++++
 Documentation/networking/statistics.rst       |  44 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 125 ++++++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  37 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 142 +++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  10 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 129 ++++++
 include/linux/ethtool.h                       |  96 ++++
 include/uapi/linux/ethtool.h                  |  10 +
 include/uapi/linux/ethtool_netlink.h          | 137 ++++++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/netlink.c                         |  10 +
 net/ethtool/netlink.h                         |   8 +
 net/ethtool/stats.c                           | 410 ++++++++++++++++++
 net/ethtool/strset.c                          |  25 ++
 15 files changed, 1257 insertions(+), 10 deletions(-)
 create mode 100644 net/ethtool/stats.c

-- 
2.30.2

