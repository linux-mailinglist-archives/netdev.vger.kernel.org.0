Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A06E36178E
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbhDPC2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237220AbhDPC2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA40C61184;
        Fri, 16 Apr 2021 02:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540075;
        bh=5WAee4cNPjAJZSbsJc/b+XafzM4AeDE0ZqlQRyfi+m4=;
        h=From:To:Cc:Subject:Date:From;
        b=TI2xuGzGyDnCGdBwx9ljUFfYDKQEybrOglfBpX8g15Q8wR8XTrSofC0LB4MT3FOwU
         +ELbmn2dk5+uiQ/JYshnxom8Dmi1SSQgPUVG5G2m2GUyMgJTT5h/+nyu5sFq1/DUEF
         rk2aCUSviiFK0YPs99L/EBfBk5hXas9KLgsiyZrvDWHf1wysPpHCECFoylR4rP7FY1
         v+qCX3IF93W36U6KOluNXfbxiFOeY58zrUBJ/dr6bzbjN9nOz5rFJu7Ukm2IY7Ltkr
         ahWKgSmyhJGhLj/PVQiJQCCRkC5fJ261+yYFjbXXRqYP2zz7Mu6Vy2biBlGHKlOU0t
         Nk0BgNTisGYfg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/9] ethtool: add uAPI for reading standard stats
Date:   Thu, 15 Apr 2021 19:27:43 -0700
Message-Id: <20210416022752.2814621-1-kuba@kernel.org>
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

 Documentation/networking/ethtool-netlink.rst  |  74 ++++
 Documentation/networking/statistics.rst       |  44 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 125 ++++++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  37 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 142 +++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  10 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 129 ++++++
 include/linux/ethtool.h                       |  95 ++++
 include/uapi/linux/ethtool.h                  |  10 +
 include/uapi/linux/ethtool_netlink.h          | 137 ++++++
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/netlink.c                         |  10 +
 net/ethtool/netlink.h                         |   8 +
 net/ethtool/stats.c                           | 410 ++++++++++++++++++
 net/ethtool/strset.c                          |  25 ++
 15 files changed, 1248 insertions(+), 10 deletions(-)
 create mode 100644 net/ethtool/stats.c

-- 
2.30.2

