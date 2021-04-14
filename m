Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643BB35FC93
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349787AbhDNUY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231710AbhDNUXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 991BF6044F;
        Wed, 14 Apr 2021 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431808;
        bh=YfjV840ReKOs0Kez2sTnvZHSH+hgmPuEtfPigwI9iOE=;
        h=From:To:Cc:Subject:Date:From;
        b=McP9kSUk4v+BHSeLiO4PO/NLh/fuJgYUn0BxSQZC6wnj0AxeoGbZ1VEzVCpTUQel3
         iClbkWuYLXK88ljgArf21MzGAGPLc5hRGMq5M7E1W0N0cyzug5pvofGNuTj1OYvBm/
         HmEkSNU7Lwi8krN/1u4l/YyPjssG9vd03Iey/H3wlVM7kwi4hZLceyib3giwQLrsPA
         jjblFaN20nlKF1Bo+uQMPPZmA+klhbQ6qZkKnQ4jOtORFcHu8UTmf8xNq8pphJF8aE
         85mI8bChCWIvuKwzTPSGcuh+CpGwHh4Dd0NlHp7NMJzT9vo1iTszBYE80iT8WzgA1c
         RfHTJWGGXn5FQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 0/6] ethtool: add uAPI for reading standard stats
Date:   Wed, 14 Apr 2021 13:23:19 -0700
Message-Id: <20210414202325.2225774-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a new ethtool command to read well defined
device statistics. There is nothing clever here, just a netlink
API for dumping statistics defined by standards and RFCs which
today end up in ethtool -S under infinite variations of names.

This series adds basic IEEE stats (for PHY, MAC, Ctrl frames)
and RMON stats. AFAICT other RFCs only duplicate the IEEE
stats.

This series does _not_ add a netlink API to read driver-defined
stats. There seems to be little to gain from moving that part
to netlink.

The netlink message format is very simple, and aims to allow
adding stats and groups with no changes to user tooling (which
IIUC is expected for ethtool). Stats are dumped directly
into netlink with netlink attributes used as IDs. This is
perhaps where the biggest question mark is. We could instead
pack the stats into individual wrappers:

 [grp]
   [stat] // nest
     [id]    // u32
     [value] // u64
   [stat] // nest
     [id]    // u32
     [value] // u64

which would increase the message size 2x but allow
to ID the stats from 0, saving strset space as well as
allow seamless adding of legacy stats to this API
(which are IDed from 0).

On user space side we can re-use -S, and make it dump
standard stats if --groups are defined.

$ ethtool -S eth0 --groups eth-phy eth-mac rmon eth-ctrl
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

Jakub Kicinski (6):
  docs: networking: extend the statistics documentation
  docs: ethtool: document standard statistics
  ethtool: add a new command for reading standard stats
  ethtool: add interface to read standard MAC stats
  ethtool: add interface to read standard MAC Ctrl stats
  ethtool: add interface to read RMON stats

 Documentation/networking/ethtool-netlink.rst |  74 ++++
 Documentation/networking/statistics.rst      |  44 ++-
 include/linux/ethtool.h                      |  95 +++++
 include/uapi/linux/ethtool.h                 |  10 +
 include/uapi/linux/ethtool_netlink.h         | 134 +++++++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |  10 +
 net/ethtool/netlink.h                        |   8 +
 net/ethtool/stats.c                          | 374 +++++++++++++++++++
 net/ethtool/strset.c                         |  25 ++
 10 files changed, 773 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/stats.c

-- 
2.30.2

