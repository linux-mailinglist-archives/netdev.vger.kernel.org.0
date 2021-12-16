Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0F1477EDB
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 22:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241612AbhLPVcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 16:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbhLPVcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 16:32:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819B1C061574;
        Thu, 16 Dec 2021 13:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 261DFB82649;
        Thu, 16 Dec 2021 21:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89193C36AE2;
        Thu, 16 Dec 2021 21:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639690328;
        bh=33NLxHBFMer1crvPo4EJUWIvuQNWNmcxh9f5uboHm3Q=;
        h=From:To:Cc:Subject:Date:From;
        b=Mjm062Oun6PaBgLkESwRTHOhMQPSY4ko9nAF3IJIiDWmtnGKmIjcr3iOkRynO33Ma
         5Oo5+Vy3uJV4vqlJ65wux/lWMbVrkA2TQRh/Tb7IBSAelJoNdBgPZDMR8Z2wv7MI/I
         53iqP2rDLRfzwXPiyc1FnvW1/jGYVEx0exm95XkG11M7q7Beyy+iLzlMDD/Ktci4tH
         xEi+49itJHJzjn4/e3wQvmWGN7Iag3KYo/ddRbp5leWJzrQ3TBYdyU4D1AVK5OZo6y
         HF7Ch6XivQxxSDoQAomVG2YmDttpJaYQYbsBOcY4nL+UQKTSwHJ4ZsBpKOaJZCkqF7
         AJa/Wh3oJ7ZUw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net,
        johannes@sipsolutions.net, kvalo@codeaurora.org
Subject: [GIT PULL] Networking for 5.16-rc6
Date:   Thu, 16 Dec 2021 13:32:07 -0800
Message-Id: <20211216213207.839017-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Relatively large batches of fixes from BPF and the WiFi stack,
calm in general networking.

The following changes since commit c2fcbf81c332b42382a0c439bfe2414a241e4f5b:

  bpf, selftests: Fix racing issue in btf_skc_cls_ingress test (2021-12-16 21:41:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc6

for you to fetch changes up to 0c3e2474605581375d808bb3b9ce0927ed3eef70:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-12-16 13:06:49 -0800)

----------------------------------------------------------------
Networking fixes for 5.16-rc6, including fixes from mac80211, wifi, bpf.

Current release - regressions:

 - dpaa2-eth: fix buffer overrun when reporting ethtool statistics

Current release - new code bugs:

 - bpf: fix incorrect state pruning for <8B spill/fill

 - iavf:
     - add missing unlocks in iavf_watchdog_task()
     - do not override the adapter state in the watchdog task (again)

 - mlxsw: spectrum_router: consolidate MAC profiles when possible

Previous releases - regressions:

 - mac80211, fix:
     - rate control, avoid driver crash for retransmitted frames
     - regression in SSN handling of addba tx
     - a memory leak where sta_info is not freed
     - marking TX-during-stop for TX in in_reconfig, prevent stall

 - cfg80211: acquire wiphy mutex on regulatory work

 - wifi drivers: fix build regressions and LED config dependency

 - virtio_net: fix rx_drops stat for small pkts

 - dsa: mv88e6xxx: unforce speed & duplex in mac_link_down()

Previous releases - always broken:

 - bpf, fix:
    - kernel address leakage in atomic fetch
    - kernel address leakage in atomic cmpxchg's r0 aux reg
    - signed bounds propagation after mov32
    - extable fixup offset
    - extable address check

 - mac80211:
     - fix the size used for building probe request
     - send ADDBA requests using the tid/queue of the aggregation
       session
     - agg-tx: don't schedule_and_wake_txq() under sta->lock,
       avoid deadlocks
     - validate extended element ID is present

 - mptcp:
     - never allow the PM to close a listener subflow (null-defer)
     - clear 'kern' flag from fallback sockets, prevent crash
     - fix deadlock in __mptcp_push_pending()

 - inet_diag: fix kernel-infoleak for UDP sockets

 - xsk: do not sleep in poll() when need_wakeup set

 - smc: avoid very long waits in smc_release()

 - sch_ets: don't remove idle classes from the round-robin list

 - netdevsim:
     - zero-initialize memory for bpf map's value, prevent info leak
     - don't let user space overwrite read only (max) ethtool parms

 - ixgbe: set X550 MDIO speed before talking to PHY

 - stmmac:
     - fix null-deref in flower deletion w/ VLAN prio Rx steering
     - dwmac-rk: fix oob read in rk_gmac_setup

 - ice: time stamping fixes

 - systemport: add global locking for descriptor life cycle

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Ahmed Zaki (1):
      mac80211: fix a memory leak where sta_info is not freed

Andrey Eremeev (1):
      dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED

Arnd Bergmann (3):
      iwlwifi: fix LED dependencies
      brcmsmac: rework LED dependencies
      mt76: mt7921: fix build regression

Baowen Zheng (1):
      flow_offload: return EOPNOTSUPP for the unsupported mpls action type

Cyril Novikov (1):
      ixgbe: set X550 MDIO speed before talking to PHY

D. Wythe (1):
      net/smc: Prevent smc_release() from long blocking

Dan Carpenter (1):
      iavf: missing unlocks in iavf_watchdog_task()

Daniele Palmas (1):
      net: usb: qmi_wwan: add Telit 0x1070 composition

Danielle Ratson (2):
      mlxsw: spectrum_router: Consolidate MAC profiles when possible
      selftests: mlxsw: Add a test case for MAC profiles consolidation

David Ahern (3):
      selftests: Add duplicate config only for MD5 VRF tests
      selftests: Fix raw socket bind tests with VRF
      selftests: Fix IPv6 address bind tests

David S. Miller (7):
      Merge branch 'hns3-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mac80211-for-net-2021-12-14' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge branch 'mlxsw-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'wireless-drivers-2021-12-15' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

David Wu (1):
      net: stmmac: Add GFP_DMA32 for rx buffers if no 64 capability

Davide Caratti (1):
      net/sched: sch_ets: don't remove idle classes from the round-robin list

Eric Dumazet (2):
      inet_diag: fix kernel-infoleak for UDP sockets
      sit: do not call ipip6_dev_free() from sit_init_net()

Felix Fietkau (3):
      mac80211: fix rate control for retransmitted frames
      mac80211: fix regression in SSN handling of addba tx
      mac80211: send ADDBA requests using the tid/queue of the aggregation session

Filip Pokryvka (1):
      netdevsim: don't overwrite read only ethtool parms

Finn Behrens (2):
      nl80211: reset regdom when reloading regdb
      nl80211: remove reload flag from regulatory_request

Florian Fainelli (1):
      net: systemport: Add global locking for descriptor lifecycle

Florian Westphal (2):
      mptcp: remove tcp ulp setsockopt support
      mptcp: clear 'kern' flag from fallback sockets

Gal Pressman (1):
      net: Fix double 0x prefix print in SKB dump

Greg Jesionowski (1):
      net: usb: lan78xx: add Allied Telesis AT29M2-AF

Haimin Zhang (1):
      netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc

Hangbin Liu (1):
      selftest/net/forwarding: declare NETIFS p9 p10

Hangyu Hua (2):
      phonet: refcount leak in pep_sock_accep
      rds: memory leak in __rds_conn_create()

Ilan Peer (2):
      cfg80211: Acquire wiphy mutex on regulatory work
      mac80211: Fix the size used for building probe request

Ioana Ciornei (1):
      dpaa2-eth: fix ethtool statistics

Jakub Kicinski (2):
      Merge branch 'mptcp-fixes-for-ulp-a-deadlock-and-netlink-docs'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jiasheng Jiang (1):
      sfc_ef100: potential dereference of null pointer

Jie Wang (1):
      net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg

Johannes Berg (8):
      mac80211: track only QoS data frames for admission control
      mac80211: add docs for ssn in struct tid_ampdu_tx
      iwlwifi: mvm: don't crash on invalid rate w/o STA
      mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock
      mac80211: validate extended element ID is present
      mac80211: fix lookup when adding AddBA extension element
      mac80211: mark TX-during-stop for TX in in_reconfig
      mac80211: do drv_reconfig_complete() before restarting all

John Keeping (1):
      net: stmmac: dwmac-rk: fix oob read in rk_gmac_setup

Kalle Valo (1):
      MAINTAINERS: update Kalle Valo's email

Karen Sornek (1):
      igb: Fix removal of unicast MAC filters of VFs

Karol Kolacinski (2):
      ice: Use div64_u64 instead of div_u64 in adjfine
      ice: Don't put stale timestamps in the skb

Letu Ren (1):
      igbvf: fix double free in `igbvf_probe`

Marek Behún (1):
      net: dsa: mv88e6xxx: Unforce speed & duplex in mac_link_down()

Matthieu Baerts (1):
      mptcp: add missing documented NL params

Maxim Galaganov (1):
      mptcp: fix deadlock in __mptcp_push_pending()

Maxime Bizon (1):
      mac80211: fix TCP performance on mesh interface

Miaoqian Lin (1):
      net: bcmgenet: Fix NULL vs IS_ERR() checking

Mordechay Goodstein (1):
      mac80211: update channel context before station state

Ong Boon Leong (1):
      net: stmmac: fix tc flower deletion for VLAN priority Rx steering

Paolo Abeni (1):
      mptcp: never allow the PM to close a listener subflow

Po-Hsu Lin (1):
      selftests: icmp_redirect: pass xfail=0 to log_test()

Robert Schlabbach (1):
      ixgbe: Document how to enable NBASE-T support

Russell King (Oracle) (1):
      net: phy: add a note about refcounting

Sasha Neftin (1):
      igc: Fix typo in i225 LTR functions

Stefan Assmann (1):
      iavf: do not override the adapter state in the watchdog task (again)

Wang Qing (1):
      net: ethernet: ti: add missing of_node_put before return

Wenliang Wang (1):
      virtio_net: fix rx_drops stat for small pkts

Willem de Bruijn (2):
      selftests/net: toeplitz: fix udp option
      net/packet: rx_owner_map depends on pg_vec

Xing Song (1):
      mac80211: set up the fwd_skb->dev for mesh forwarding

Yufeng Mo (1):
      net: hns3: fix race condition in debugfs

 .../device_drivers/ethernet/intel/ixgbe.rst        | 16 ++++
 MAINTAINERS                                        | 12 +--
 drivers/net/dsa/mv88e6xxx/chip.c                   |  4 +
 drivers/net/dsa/mv88e6xxx/port.c                   |  4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  5 +-
 drivers/net/ethernet/broadcom/bcmsysport.h         |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 20 +++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  3 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  5 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 13 ++--
 drivers/net/ethernet/intel/ice/ice_ptp.h           |  6 ++
 drivers/net/ethernet/intel/igb/igb_main.c          | 28 +++----
 drivers/net/ethernet/intel/igbvf/netdev.c          |  1 +
 drivers/net/ethernet/intel/igc/igc_i225.c          |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |  3 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  3 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |  3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |  4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       | 17 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 16 +++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 86 ++++++++++++++++++----
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           | 29 +++++---
 drivers/net/netdevsim/bpf.c                        |  1 +
 drivers/net/netdevsim/ethtool.c                    |  5 +-
 drivers/net/phy/mdio_bus.c                         |  3 +
 drivers/net/usb/lan78xx.c                          |  6 ++
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/virtio_net.c                           |  9 +--
 drivers/net/wireless/broadcom/brcm80211/Kconfig    | 14 ++--
 .../wireless/broadcom/brcm80211/brcmsmac/Makefile  |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/led.h |  2 +-
 drivers/net/wireless/intel/iwlegacy/Kconfig        |  4 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  5 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |  2 +-
 include/uapi/linux/mptcp.h                         | 18 +++--
 net/core/skbuff.c                                  |  2 +-
 net/ipv4/inet_diag.c                               |  4 +-
 net/ipv6/sit.c                                     |  1 -
 net/mac80211/agg-rx.c                              |  5 +-
 net/mac80211/agg-tx.c                              | 16 ++--
 net/mac80211/driver-ops.h                          |  5 +-
 net/mac80211/mlme.c                                | 13 +++-
 net/mac80211/rx.c                                  |  1 +
 net/mac80211/sta_info.c                            | 21 +++---
 net/mac80211/sta_info.h                            |  2 +
 net/mac80211/tx.c                                  | 10 +--
 net/mac80211/util.c                                | 23 +++---
 net/mptcp/pm_netlink.c                             |  3 +
 net/mptcp/protocol.c                               |  6 +-
 net/mptcp/sockopt.c                                |  1 -
 net/packet/af_packet.c                             |  5 +-
 net/phonet/pep.c                                   |  1 +
 net/rds/connection.c                               |  1 +
 net/sched/cls_api.c                                |  1 +
 net/sched/sch_ets.c                                |  4 +-
 net/smc/af_smc.c                                   |  4 +-
 net/wireless/reg.c                                 | 30 +++++++-
 .../drivers/net/mlxsw/rif_mac_profiles_occ.sh      | 30 ++++++++
 tools/testing/selftests/net/fcnal-test.sh          | 43 ++++++++---
 .../net/forwarding/forwarding.config.sample        |  2 +
 tools/testing/selftests/net/icmp_redirect.sh       |  2 +-
 tools/testing/selftests/net/toeplitz.c             |  2 +-
 68 files changed, 445 insertions(+), 162 deletions(-)
