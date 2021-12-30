Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8D3481F2F
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 19:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbhL3S3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 13:29:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50252 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbhL3S3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 13:29:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75FA1B81BBD;
        Thu, 30 Dec 2021 18:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF3FC36AE9;
        Thu, 30 Dec 2021 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640888948;
        bh=pQwav04b5UvrnEq93z3Zw0lsYaSH49b4fpW7r0eu6rQ=;
        h=From:To:Cc:Subject:Date:From;
        b=sZHSNEzmyS6mRpr2c0KQkTgfBmInqT5vUFaJiUvSjjsC7Dib5CfxhRcHqcCzD2jMR
         JtmE0ey4/vNhU9tmQHWaOOmdx5e7xcsDXHJfw2Ita/fuJXTd7zrROs6ifpMVk6HkUj
         u7nNexIR78rVPPBTcIA+dnZZBZN7JgbH6X/IBpFm/QBYd1EsLfcPcoN1Qi8QkenWIA
         0shbxzSgUt2z3k2LpFW15Tc9ZRMGSYPffLpw90UdN31Vc57aVlYCJuvPG54rlh/Dy8
         OCMnqWTahkK2B2n1Ag7rQSWoGmUdBziaecCYi5OiEoQSnPMq8UVcGM2rKy/U2Ao1Zh
         phWwW0zBTqFVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.16-rc8
Date:   Thu, 30 Dec 2021 10:29:07 -0800
Message-Id: <20211230182907.1190933-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

No regressions on our radar at this point. The igc problem fixed here
was the last one I was tracking but it was broken in previous releases,
anyway. Mostly driver fixes and a couple of largish SMC fixes.

The following changes since commit 95b40115a97bda99485267ca2b3b7566f965b5b4:

  Merge tag 'drm-fixes-2021-12-24' of git://anongit.freedesktop.org/drm/drm (2021-12-23 15:43:25 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc8

for you to fetch changes up to bf2b09fedc17248b315f80fb249087b7d28a69a6:

  fsl/fman: Fix missing put_device() call in fman_port_probe (2021-12-30 13:34:06 +0000)

----------------------------------------------------------------
Networking fixes for 5.16-rc8, including fixes from.. Santa?

Current release - regressions:

 - xsk: initialise xskb free_list_node, fixup for a -rc7 fix

Current release - new code bugs:

 - mlx5: handful of minor fixes:
   - use first online CPU instead of hard coded CPU
   - fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
   - fix skb memory leak when TC classifier action offloads are
     disabled
   - fix memory leak with rules with internal OvS port

Previous releases - regressions:

 - igc: do not enable crosstimestamping for i225-V models

Previous releases - always broken:

 - udp: use datalen to cap ipv6 udp max gso segments

 - fix use-after-free in tw_timer_handler due to early free of stats

 - smc: fix kernel panic caused by race of smc_sock

 - smc: don't send CDC/LLC message if link not ready, avoid timeouts

 - sctp: use call_rcu to free endpoint, avoid UAF in sock diag

 - bridge: mcast: add and enforce query interval minimum

 - usb: pegasus: do not drop long Ethernet frames

 - mlx5e: fix ICOSQ recovery flow for XSK

 - nfc: uapi: use kernel size_t to fix user-space builds

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksander Jan Bajkowski (1):
      net: lantiq_xrx200: fix statistics of received bytes

Amir Tzin (1):
      net/mlx5e: Wrap the tx reporter dump callback to extract the sq

Chris Mi (2):
      net/mlx5: Fix tc max supported prio for nic mode
      net/mlx5e: Delete forward rule for ct or sample action

Christophe JAILLET (3):
      net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
      net: ag71xx: Fix a potential double free in error handling paths
      ionic: Initialize the 'lif->dbid_inuse' bitmap

Ciara Loftus (1):
      xsk: Initialise xskb free_list_node

Coco Li (2):
      udp: using datalen to cap ipv6 udp max gso segments
      selftests: Calculate udpgso segment count without header adjustment

David S. Miller (1):
      Merge branch 'smc-fixes'

Dmitry V. Levin (1):
      uapi: fix linux/nfc.h userspace compilation errors

Dust Li (2):
      net/smc: don't send CDC/LLC message if link not ready
      net/smc: fix kernel panic caused by race of smc_sock

Gal Pressman (2):
      net/mlx5e: Fix skb memory leak when TC classifier action offloads are disabled
      net/mlx5e: Fix wrong features assignment in case of error

Jakub Kicinski (4):
      Merge tag 'mlx5-fixes-2021-12-22' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-bridge-mcast-add-and-enforce-query-interval-minimum'
      Merge tag 'mlx5-fixes-2021-12-28' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

James McLaughlin (1):
      igc: Fix TX timestamp support for non-MSI-X platforms

Jianguo Wu (2):
      selftests: net: Fix a typo in udpgro_fwd.sh
      selftests: net: using ping6 for IPv6 in udpgro_fwd.sh

Jiasheng Jiang (1):
      net/ncsi: check for error return from call to nla_put_u32

Karsten Graul (1):
      net/smc: fix using of uninitialized completions

Krzysztof Kozlowski (1):
      nfc: uapi: use kernel size_t to fix user-space builds

Ma Xinjian (1):
      selftests: mptcp: Remove the deprecated config NFT_COUNTER

Matthias-Christian Ott (1):
      net: usb: pegasus: Do not drop long Ethernet frames

Maxim Mikityanskiy (2):
      net/mlx5e: Fix interoperability between XSK and ICOSQ recovery flow
      net/mlx5e: Fix ICOSQ recovery flow for XSK

Miaoqian Lin (3):
      net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
      net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register
      fsl/fman: Fix missing put_device() call in fman_port_probe

Moshe Shemesh (1):
      net/mlx5: Fix SF health recovery flow

Muchun Song (1):
      net: fix use-after-free in tw_timer_handler

Nikolay Aleksandrov (3):
      net: bridge: mcast: add and enforce query interval minimum
      net: bridge: mcast: add and enforce startup query interval minimum
      net: bridge: mcast: fix br_multicast_ctx_vlan_global_disabled helper

Roi Dayan (1):
      net/mlx5e: TC, Fix memory leak with rules with internal port

Shay Drory (2):
      net/mlx5: Use first online CPU instead of hard coded CPU
      net/mlx5: Fix error print in case of IRQ request failed

Tamir Duberstein (1):
      ipv6: raw: check passed optlen before reading

Vinicius Costa Gomes (1):
      igc: Do not enable crosstimestamping for i225-V models

Wei Yongjun (1):
      NFC: st21nfca: Fix memory leak in device probe and remove

William Zhao (1):
      ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate

Xin Long (1):
      sctp: use call_rcu to free endpoint

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix querying eswitch manager vport for ECPF

Zekun Shen (1):
      atlantic: Fix buff_ring OOB in aq_ring_rx_clean

wolfgang huang (1):
      mISDN: change function names to avoid conflicts

wujianguo (1):
      selftests/net: udpgso_bench_tx: fix dst ip argument

xu xin (1):
      Documentation: fix outdated interpretation of ip_no_pmtu_disc

yangxingwu (1):
      net: udp: fix alignment problem in udp4_seq_show()

 Documentation/networking/ip-sysctl.rst             |  6 ++-
 drivers/isdn/mISDN/core.c                          |  6 +--
 drivers/isdn/mISDN/core.h                          |  4 +-
 drivers/isdn/mISDN/layer1.c                        |  4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  8 ++++
 drivers/net/ethernet/atheros/ag71xx.c              | 23 ++++------
 drivers/net/ethernet/freescale/fman/fman_port.c    | 12 ++---
 drivers/net/ethernet/intel/igc/igc_main.c          |  6 +++
 drivers/net/ethernet/intel/igc/igc_ptp.c           | 15 ++++++-
 drivers/net/ethernet/lantiq_xrx200.c               |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  5 +--
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.h    |  2 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 35 ++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 10 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 16 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 48 +++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 33 +++++++-------
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 11 ++---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  6 +--
 .../mellanox/mlx5/core/steering/dr_domain.c        |  9 ++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  2 +-
 drivers/net/phy/fixed_phy.c                        |  4 +-
 drivers/net/usb/pegasus.c                          |  4 +-
 drivers/nfc/st21nfca/i2c.c                         | 29 ++++++++----
 include/net/sctp/sctp.h                            |  6 +--
 include/net/sctp/structs.h                         |  3 +-
 include/uapi/linux/nfc.h                           |  6 +--
 net/bridge/br_multicast.c                          | 32 +++++++++++++
 net/bridge/br_netlink.c                            |  4 +-
 net/bridge/br_private.h                            | 12 +++--
 net/bridge/br_sysfs_br.c                           |  4 +-
 net/bridge/br_vlan_options.c                       |  4 +-
 net/ipv4/af_inet.c                                 | 10 ++---
 net/ipv4/udp.c                                     |  2 +-
 net/ipv6/ip6_vti.c                                 |  2 +
 net/ipv6/raw.c                                     |  3 ++
 net/ipv6/udp.c                                     |  2 +-
 net/ncsi/ncsi-netlink.c                            |  6 ++-
 net/sctp/diag.c                                    | 12 ++---
 net/sctp/endpointola.c                             | 23 ++++++----
 net/sctp/socket.c                                  | 23 ++++++----
 net/smc/smc.h                                      |  5 +++
 net/smc/smc_cdc.c                                  | 52 ++++++++++------------
 net/smc/smc_cdc.h                                  |  2 +-
 net/smc/smc_core.c                                 | 27 ++++++++---
 net/smc/smc_core.h                                 |  6 +++
 net/smc/smc_ib.c                                   |  4 +-
 net/smc/smc_ib.h                                   |  1 +
 net/smc/smc_llc.c                                  |  2 +-
 net/smc/smc_wr.c                                   | 51 ++++-----------------
 net/smc/smc_wr.h                                   |  5 +--
 net/xdp/xsk_buff_pool.c                            |  1 +
 tools/testing/selftests/net/mptcp/config           |  1 -
 tools/testing/selftests/net/udpgro_fwd.sh          |  6 ++-
 tools/testing/selftests/net/udpgso.c               | 12 ++---
 tools/testing/selftests/net/udpgso_bench_tx.c      |  8 +++-
 58 files changed, 405 insertions(+), 237 deletions(-)
