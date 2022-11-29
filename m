Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEDF63C632
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiK2RMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiK2RMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:12:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF81190;
        Tue, 29 Nov 2022 09:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E90E761846;
        Tue, 29 Nov 2022 17:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEF4C433C1;
        Tue, 29 Nov 2022 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741955;
        bh=N57EwuI2bvGzIBT15rletU5aCRCITkxYGWyOef47+d4=;
        h=From:To:Cc:Subject:Date:From;
        b=bryjiMYtHPnHkcX6GPNaZ3eouXJHaQ5GIUvdqKER5idq3kShk/8o2Mct49X9M77HF
         oOOsSdgWTYPFmgZsfshiuLFyuzNMSw6UPhallfr8CeNBQcCHa1tn+K+FeMm9t4pDJZ
         OR+DV8vaDwQQO+7qGYEhQotk86o1GLdkrujPTky3BkcilfOKnpuTzwVYxzzBQn/apg
         KEIcVl5/VL2qwVYUURn973a57FEnb1ndhEpA/wV+mqeFzmcqBISgqqiGwXGNYe4UaS
         VnbnGINmVCOz1nS48cvZnfKSFV13WqUt7Ep99MdfBJ8KD8PHhhw2jMLUhtV/fanGZW
         Uzi/os4b4sL3g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL v2] Networking for v6.1-rc8 (part 1)
Date:   Tue, 29 Nov 2022 09:12:34 -0800
Message-Id: <20221129171234.2974397-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

.. with the clang warning fixed and a few other minor fixes.


The following changes since commit 661e5ebbafd26d9d2e3c749f5cf591e55c7364f5:

  net: thunderx: Fix the ACPI memory leak (2022-11-24 10:15:47 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc8-2

for you to fetch changes up to d66233a312ec9013af3e37e4030b479a20811ec3:

  net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed (2022-11-29 08:41:01 -0800)

----------------------------------------------------------------
Including fixes from bpf, can and wifi.

Current release - new code bugs:

 - eth: mlx5e:
   - use kvfree() in mlx5e_accel_fs_tcp_create()
   - MACsec, fix RX data path 16 RX security channel limit
   - MACsec, fix memory leak when MACsec device is deleted
   - MACsec, fix update Rx secure channel active field
   - MACsec, fix add Rx security association (SA) rule memory leak

Previous releases - regressions:

 - wifi: cfg80211: don't allow multi-BSSID in S1G

 - stmmac: set MAC's flow control register to reflect current settings

 - eth: mlx5:
   - E-switch, fix duplicate lag creation
   - fix use-after-free when reverting termination table

Previous releases - always broken:

 - ipv4: fix route deletion when nexthop info is not specified

 - bpf: fix a local storage BPF map bug where the value's spin lock
   field can get initialized incorrectly

 - tipc: re-fetch skb cb after tipc_msg_validate

 - wifi: wilc1000: fix Information Element parsing

 - packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

 - sctp: fix memory leak in sctp_stream_outq_migrate()

 - can: can327: fix potential skb leak when netdev is down

 - can: add number of missing netdev freeing on error paths

 - aquantia: do not purge addresses when setting the number of rings

 - wwan: iosm:
   - fix incorrect skb length leading to truncated packet
   - fix crash in peek throughput test due to skb UAF

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'Bug fix and test case for special map value field '

Andrii Nakryiko (1):
      Merge branch 'libbpf: Fixes for ring buffer'

Ayush Sawal (1):
      MAINTAINERS: Update maintainer list for chelsio drivers

Chris Mi (3):
      net/mlx5: E-switch, Destroy legacy fdb table when needed
      net/mlx5: E-switch, Fix duplicate lag creation
      net/mlx5: Lag, Fix for loop when checking lag

Dan Carpenter (1):
      net/mlx5e: Fix a couple error codes

David S. Miller (4):
      Merge tag 'linux-can-fixes-for-6.1-20221124' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2022-11-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'wwan-iosm-fixes'

Duoming Zhou (1):
      qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Emeel Hakim (3):
      net/mlx5e: MACsec, fix add Rx security association (SA) rule memory leak
      net/mlx5e: MACsec, remove replay window size limitation in offload path
      net/mlx5e: MACsec, block offload requests with encrypt off

Goh, Wei Sheng (1):
      net: stmmac: Set MAC's flow control register to reflect current settings

Heiko Schocher (1):
      can: sja1000: fix size of OCR_MODE_MASK define

Hou Tao (5):
      bpf, perf: Use subprog name when reporting subprog ksymbol
      libbpf: Use page size as max_entries when probing ring buffer map
      libbpf: Handle size overflow for ringbuf mmap
      libbpf: Handle size overflow for user ringbuf mmap
      libbpf: Check the validity of size in user_ring_buffer__reserve()

Ido Schimmel (1):
      ipv4: Fix route deletion when nexthop info is not specified

Izabela Bakollari (1):
      aquantia: Do not purge addresses when setting the number of rings

Jakub Kicinski (3):
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'wireless-2022-11-28' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'mptcp-more-fixes-for-6-1'

Jerry Ray (1):
      dsa: lan9303: Correct stat name

Jiasheng Jiang (1):
      can: m_can: Add check for devm_clk_get

Jiri Olsa (3):
      libbpf: Use correct return pointer in attach_raw_tp
      selftests/bpf: Filter out default_idle from kprobe_multi bench
      selftests/bpf: Make test_bench_attach serial

Johannes Berg (2):
      wifi: cfg80211: fix buffer overflow in elem comparison
      wifi: cfg80211: don't allow multi-BSSID in S1G

Lorenzo Bianconi (1):
      wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration

Lukas Bulwahn (1):
      qed: avoid defines prefixed with CONFIG

M Chetan Kumar (4):
      net: wwan: iosm: fix kernel test robot reported error
      net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
      net: wwan: iosm: fix crash in peek throughput test
      net: wwan: iosm: fix incorrect skb length

Marek Vasut (1):
      MAINTAINERS: mark rsi wifi driver as orphan

Menglong Dong (1):
      mptcp: don't orphan ssk in mptcp_close()

Paolo Abeni (1):
      mptcp: fix sleep in atomic at close time

Phil Turnbull (4):
      wifi: wilc1000: validate pairwise and authentication suite offsets
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_OPER_CHANNEL attribute
      wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute
      wifi: wilc1000: validate number of channels

Raed Salem (5):
      net/mlx5e: MACsec, fix RX data path 16 RX security channel limit
      net/mlx5e: MACsec, fix memory leak when MACsec device is deleted
      net/mlx5e: MACsec, fix update Rx secure channel active field
      net/mlx5e: MACsec, fix mlx5e_macsec_update_rxsa bail condition and functionality
      net/mlx5e: MACsec, fix Tx SA active field update

Rasmus Villemoes (2):
      net: fec: don't reset irq coalesce settings to defaults on "ip link up"
      net: loopback: use NET_NAME_PREDICTABLE for name_assign_type

Roi Dayan (1):
      net/mlx5e: Fix use-after-free when reverting termination table

Russell King (Oracle) (1):
      net: phylink: fix PHY validation with rate adaption

Saeed Mahameed (1):
      Revert "net/mlx5e: MACsec, remove replay window size limitation in offload path"

Shang XiaoJing (3):
      ixgbevf: Fix resource leak in ixgbevf_init_module()
      i40e: Fix error handling in i40e_init_module()
      net: marvell: prestera: Fix a NULL vs IS_ERR() check in some functions

Shannon Nelson (1):
      ionic: update MAINTAINERS entry

Shigeru Yoshida (1):
      net: tun: Fix use-after-free in tun_detach()

Suman Ghosh (1):
      octeontx2-pf: Fix pfc_alloc_status array overflow

Wang Hai (2):
      e100: Fix possible use after free in e100_xmit_prepare
      net/9p: Fix a potential socket leak in p9_socket_open

Willem de Bruijn (1):
      packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Xin Long (1):
      tipc: re-fetch skb cb after tipc_msg_validate

Xu Kuohai (2):
      bpf: Do not copy spin lock field from user in bpf_selem_alloc
      bpf: Set and check spin lock value in sk_storage_map_test

Yang Yingliang (2):
      net: phy: fix null-ptr-deref while probe() failed
      net: mdiobus: fix unbalanced node reference count

Yasushi SHOJI (1):
      can: mcba_usb: Fix termination command argument

Yoshihiro Shimoda (1):
      net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Yuan Can (3):
      fm10k: Fix error handling in fm10k_init_module()
      iavf: Fix error handling in iavf_init_module()
      net: net_netdev: Fix error handling in ntb_netdev_init_module()

YueHaibing (4):
      net/mlx5: DR, Fix uninitialized var warning
      net/mlx5: Fix uninitialized variable bug in outlen_write()
      net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
      net: hsr: Fix potential use-after-free

Yuri Karpov (1):
      net: ethernet: nixge: fix NULL dereference

Zhang Changzhong (5):
      can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()
      can: cc770: cc770_isa_probe(): add missing free_cc770dev()
      can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()
      can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods
      net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()

Zhengchao Shao (1):
      sctp: fix memory leak in sctp_stream_outq_migrate()

Ziyang Xuan (1):
      can: can327: can327_feed_frame_to_netdev(): fix potential skb leak when netdev is down

 .mailmap                                           |   1 +
 MAINTAINERS                                        |  11 +-
 drivers/net/can/can327.c                           |   4 +-
 drivers/net/can/cc770/cc770_isa.c                  |  10 +-
 drivers/net/can/m_can/m_can.c                      |   2 +-
 drivers/net/can/m_can/m_can_pci.c                  |   9 +-
 drivers/net/can/sja1000/sja1000_isa.c              |  10 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   5 +-
 drivers/net/can/usb/mcba_usb.c                     |  10 +-
 drivers/net/dsa/lan9303-core.c                     |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |   5 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.h   |   2 +
 drivers/net/ethernet/freescale/fec_main.c          |  22 +---
 drivers/net/ethernet/intel/e100.c                  |   5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  11 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   9 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  10 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +-
 .../ethernet/marvell/prestera/prestera_router.c    |   2 +-
 .../ethernet/marvell/prestera/prestera_router_hw.c |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 122 ++++++++++-----------
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.h  |   6 +-
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |  17 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   8 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   7 ++
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   9 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |   5 +-
 drivers/net/ethernet/ni/nixge.c                    |  29 ++---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |  24 ++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  12 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/loopback.c                             |   2 +-
 drivers/net/mdio/fwnode_mdio.c                     |   2 +-
 drivers/net/ntb_netdev.c                           |   9 +-
 drivers/net/phy/phy_device.c                       |   2 +
 drivers/net/phy/phylink.c                          |  22 +++-
 drivers/net/tun.c                                  |   4 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  39 +++++--
 drivers/net/wireless/microchip/wilc1000/hif.c      |  21 +++-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |  26 +++--
 drivers/net/wwan/iosm/iosm_ipc_protocol.h          |   2 +-
 include/linux/can/platform/sja1000.h               |   2 +-
 include/net/sctp/stream_sched.h                    |   2 +
 kernel/bpf/bpf_local_storage.c                     |   2 +-
 kernel/events/core.c                               |   2 +-
 net/9p/trans_fd.c                                  |   4 +-
 net/hsr/hsr_forward.c                              |   5 +-
 net/ipv4/fib_semantics.c                           |   8 +-
 net/mac80211/airtime.c                             |   3 +
 net/mptcp/protocol.c                               |  13 +--
 net/mptcp/subflow.c                                |   6 +-
 net/packet/af_packet.c                             |   6 +-
 net/sctp/stream.c                                  |  25 +++--
 net/sctp/stream_sched.c                            |   5 +
 net/sctp/stream_sched_prio.c                       |  19 ++++
 net/sctp/stream_sched_rr.c                         |   5 +
 net/tipc/crypto.c                                  |   3 +
 net/wireless/scan.c                                |  10 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/lib/bpf/libbpf_probes.c                      |   2 +-
 tools/lib/bpf/ringbuf.c                            |  26 ++++-
 .../selftests/bpf/map_tests/sk_storage_map.c       |  36 +++---
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |   8 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  11 ++
 73 files changed, 480 insertions(+), 265 deletions(-)
