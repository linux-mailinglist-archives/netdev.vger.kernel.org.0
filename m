Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216372B9CD4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgKSVPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgKSVPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 16:15:34 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E941422240;
        Thu, 19 Nov 2020 21:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605820532;
        bh=Dk1OZMke65QwMHbA9aTRjYspFVy4jlBkVkJkDx0bCT0=;
        h=From:To:Cc:Subject:Date:From;
        b=YFlRsv5wdf31g519sBaYsb8JqXiR5V7mXNaCdslP+3NFU9YKTyVpryNiObC1nCXeL
         FNfN4tpb/mU/sKAAhQrB01mBIXbAV/NNGD6EBauA5fhXTp8VO6z91ybxJVsdqrdPXX
         u/6Vn/WrMM/ifpoimInHVlmUZ6c6f/Wg2bOWynb4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking
Date:   Thu, 19 Nov 2020 13:15:31 -0800
Message-Id: <20201119211531.3441860-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit db7c953555388571a96ed8783ff6c5745ba18ab9:

  Merge tag 'net-5.10-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-11-12 14:02:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc5

for you to fetch changes up to e6ea60bac1ee28bb46232f8c2ecd3a3fbb9011e0:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2020-11-19 12:26:10 -0800)

----------------------------------------------------------------
Networking fixes for 5.10-rc5, including fixes from the WiFi (mac80211),
can and bpf (including the strncpy_from_user fix).

Current release - regressions:

 - mac80211: fix memory leak of filtered powersave frames

 - mac80211: free sta in sta_info_insert_finish() on errors to avoid
             sleeping in atomic context

 - netlabel: fix an uninitialized variable warning added in -rc4

Previous release - regressions:

 - vsock: forward all packets to the host when no H2G is registered,
           un-breaking AWS Nitro Enclaves

 - net: Exempt multicast addresses from five-second neighbor lifetime
        requirement, decreasing the chances neighbor tables fill up

 - net/tls: fix corrupted data in recvmsg

 - qed: fix ILT configuration of SRC block

 - can: m_can: process interrupt only when not runtime suspended

Previous release - always broken:

 - page_frag: Recover from memory pressure by not recycling pages
              allocating from the reserves

 - strncpy_from_user: Mask out bytes after NUL terminator

 - ip_tunnels: Set tunnel option flag only when tunnel metadata is
               present, always setting it confuses Open vSwitch

 - bpf, sockmap:
   - Fix partial copy_page_to_iter so progress can still be made
   - Fix socket memory accounting and obeying SO_RCVBUF

 - net: Have netpoll bring-up DSA management interface

 - net: bridge: add missing counters to ndo_get_stats64 callback

 - tcp: brr: only postpone PROBE_RTT if RTT is < current min_rtt

 - enetc: Workaround MDIO register access HW bug

 - net/ncsi: move netlink family registration to a subsystem init,
             instead of tying it to driver probe

 - net: ftgmac100: unregister NC-SI when removing driver to avoid crash

 - lan743x: prevent interrupt storm on open

 - lan743x: fix freeing skbs in the wrong context

 - net/mlx5e: Fix socket refcount leak on kTLS RX resync

 - net: dsa: mv88e6xxx: Avoid VLAN database corruption on 6097

 - fix 21 unset return codes and other mistakes on error paths,
   mostly detected by the Hulk Robot

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alejandro Concepcion Rodriguez (1):
      can: dev: can_restart(): post buffer from the right context

Alex Elder (1):
      net: ipa: lock when freeing transaction

Alex Marginean (1):
      enetc: Workaround for MDIO register access issue

Alexei Starovoitov (2):
      MAINTAINERS/bpf: Update Andrii's entry.
      Merge branch 'Fix bpf_probe_read_user_str() overcopying'

Anant Thazhemadam (2):
      can: af_can: prevent potential access of uninitialized member in can_rcv()
      can: af_can: prevent potential access of uninitialized member in canfd_rcv()

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset

Andrii Nakryiko (2):
      libbpf: Don't attempt to load unused subprog as an entry-point BPF program
      selftests/bpf: Fix unused attribute usage in subprogs_unused test

Aya Levin (1):
      net/mlx4_core: Fix init_hca fields offset

Claire Chang (1):
      rfkill: Fix use-after-free in rfkill_resume()

Colin Ian King (1):
      can: peak_usb: fix potential integer overflow on shift of a int

Dan Murphy (2):
      can: m_can: m_can_class_free_dev(): introduce new function
      can: m_can: Fix freeing of can device from peripherials

Daniel Xu (2):
      lib/strncpy_from_user.c: Mask out bytes after NUL terminator.
      selftest/bpf: Test bpf_probe_read_user_str() strips trailing bytes after NUL

Dmitrii Banshchikov (1):
      bpf: Relax return code check for subprograms

Dmitry Bogdanov (1):
      qed: fix ILT configuration of SRC block

Dongli Zhang (1):
      page_frag: Recover from memory pressure

Edwin Peer (1):
      bnxt_en: read EEPROM A2h address using page 0

Eli Cohen (1):
      net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled

Enric Balletbo i Serra (1):
      can: tcan4x5x: replace depends on REGMAP_SPI with depends on SPI

Faiz Abbas (1):
      can: m_can: m_can_stop(): set device to software init mode before closing

Felix Fietkau (3):
      mac80211: fix memory leak on filtered powersave frames
      mac80211: minstrel: remove deferred sampling code
      mac80211: minstrel: fix tx status processing corner case

Filip Moc (1):
      net: usb: qmi_wwan: Set DTR quirk for MR400

Florian Fainelli (1):
      net: Have netpoll bring-up DSA management interface

Florian Klink (1):
      ipv4: use IS_ENABLED instead of ifdef

Georg Kohmann (2):
      ipv6/netfilter: Discard first fragment not including all headers
      ipv6: Remove dependency of ipv6_frag_thdr_truncated on ipv6 module

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix cpts irq after suspend

Heiner Kallweit (1):
      net: bridge: add missing counters to ndo_get_stats64 callback

Huy Nguyen (2):
      net/mlx5e: Set IPsec WAs only in IP's non checksum partial case.
      net/mlx5e: Fix IPsec packet drop by mlx5e_tc_update_skb

Ido Schimmel (2):
      mlxsw: Fix firmware flashing
      mlxsw: core: Use variable timeout for EMAD retries

Jakub Kicinski (9):
      Merge tag 'mac80211-for-net-2020-11-13' of git://git.kernel.org/.../jberg/mac80211
      Merge tag 'linux-can-fixes-for-5.10-20201115' of git://git.kernel.org/.../mkl/linux-can
      Merge branch 'fix-usage-counter-leak-by-adding-a-general-sync-ops'
      Merge branch 'bnxt_en-bug-fixes'
      Merge branch 'mlxsw-couple-of-fixes'
      Merge tag 'mlx5-fixes-2020-11-17' of git://git.kernel.org/.../saeed/linux
      Merge tag 'linux-can-fixes-for-5.10-20201118' of git://git.kernel.org/.../mkl/linux-can
      Merge branch 'net-smc-fixes-2020-11-18'
      Merge https://git.kernel.org/.../bpf/bpf

Jarkko Nikula (1):
      can: m_can: process interrupt only when not runtime suspended

Jeff Dike (1):
      net: Exempt multicast addresses from five-second neighbor lifetime

Jimmy Assarsson (2):
      can: kvaser_pciefd: Fix KCAN bittiming limits
      can: kvaser_usb: kvaser_usb_hydra: Fix KCAN bittiming limits

Jiri Olsa (1):
      libbpf: Fix VERSIONED_SYM_COUNT number parsing

Jisheng Zhang (1):
      net: stmmac: dwmac_lib: enlarge dma reset timeout

Joel Stanley (2):
      net/ncsi: Fix netlink registration
      net: ftgmac100: Fix crash when removing driver

Johannes Berg (1):
      mac80211: free sta in sta_info_insert_finish() on errors

John Fastabend (6):
      bpf, sockmap: Fix partial copy_page_to_iter so progress can still be made
      bpf, sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
      bpf, sockmap: Use truesize with sk_rmem_schedule()
      bpf, sockmap: Avoid returning unneeded EAGAIN when redirecting to self
      bpf, sockmap: Handle memory acct if skb_verdict prog redirects to self
      bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list

Kaixu Xia (1):
      bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id

Karsten Graul (2):
      net/smc: fix matching of existing link groups
      net/smc: fix direct access to ib_gid_addr->ndev in smc_ib_determine_gid()

Lorenzo Bianconi (1):
      net: mvneta: fix possible memory leak in mvneta_swbm_add_rx_fragment

Luo Meng (1):
      fail_function: Remove a redundant mutex unlock

Maor Dickman (1):
      net/mlx5e: Fix check if netdev is bond slave

Marc Kleine-Budde (5):
      can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()
      can: flexcan: flexcan_setup_stop_mode(): add missing "req_bit" to stop mode property comment
      can: tcan4x5x: tcan4x5x_can_probe(): add missing error checking for devm_regmap_init()
      can: tcan4x5x: tcan4x5x_can_remove(): fix order of deregistration
      can: flexcan: flexcan_chip_start(): fix erroneous flexcan_transceiver_enable() during bus-off recovery

Martin Blumenstingl (1):
      net: lantiq: Wait for the GPHY firmware to be ready

Maxim Mikityanskiy (1):
      net/mlx5e: Fix refcount leak on kTLS RX resync

Michael Chan (2):
      bnxt_en: Free port stats during firmware reset.
      bnxt_en: Fix counter overflow logic.

Michael Guralnik (1):
      net/mlx5: Add handling of port type in rule deletion

Paul Moore (1):
      netlabel: fix an uninitialized warning in netlbl_unlabel_staticlist()

Raju Rangoju (1):
      MAINTAINERS: update cxgb4 and cxgb3 maintainer

Ryan Sharpelletti (1):
      tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate

Sebastian Andrzej Siewior (1):
      atm: nicstar: Unmap DMA on send error

Steen Hegelund (1):
      net: phy: mscc: remove non-MACSec compatible phy

Stefano Garzarella (1):
      vsock: forward all packets to the host when no H2G is registered

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup

Sven Van Asbroeck (2):
      lan743x: fix issue causing intermittent kernel log warnings
      lan743x: prevent entire kernel HANG on open, for some platforms

Taehee Yoo (1):
      netdevsim: set .owner to THIS_MODULE

Tariq Toukan (1):
      net/tls: Fix wrong record sn in async mode of device resync

Tobias Waldekranz (1):
      net: dsa: mv88e6xxx: Avoid VTU corruption on 6097

Vadim Fedorenko (1):
      net/tls: fix corrupted data in recvmsg

Vasundhara Volam (1):
      bnxt_en: Avoid unnecessary NVM_GET_DEV_INFO cmd error log on VFs.

Vincent Stehlé (1):
      net: ethernet: mtk-star-emac: return ok when xmit drops

Vladyslav Tarasiuk (2):
      net/mlx5: Clear bw_share upon VF disable
      net/mlx5: Disable QoS when min_rates on all VFs are zero

Wang Hai (6):
      tools, bpftool: Add missing close before bpftool net attach exit
      net: marvell: prestera: fix error return code in prestera_pci_probe()
      devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
      selftests/bpf: Fix error return code in run_getsockopt_test()
      net/mlx5: fix error return code in mlx5e_tc_nic_init()
      inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()

Wang Qing (2):
      bpf: Fix passing zero to PTR_ERR() in bpf_btf_printf_prepare
      net: ethernet: ti: am65-cpts: update ret when ptp_clock is ERROR

Wong Vee Khee (1):
      net: stmmac: Use rtnl_lock/unlock on netif_set_real_num_rx_queues() call

Wu Bo (1):
      can: m_can: m_can_handle_state_change(): fix state change

Xie He (2):
      net: x25: Increase refcnt of "struct x25_neigh" in x25_rx_call_request
      MAINTAINERS: Add Martin Schiller as a maintainer for the X.25 stack

Xin Long (1):
      sctp: change to hold/put transport for proto_unreach_timer

Yi-Hung Wei (1):
      ip_tunnels: Set tunnel option flag when tunnel metadata is present

Zhang Changzhong (11):
      net: ethernet: mtk-star-emac: fix error return code in mtk_star_enable()
      net: phy: smsc: add missed clk_disable_unprepare in smsc_phy_probe()
      cx82310_eth: fix error return code in cx82310_bind()
      qlcnic: fix error return code in qlcnic_83xx_restart_hw()
      net: stmmac: dwmac-intel-plat: fix error return code in intel_eth_plat_probe()
      net: ethernet: ti: cpsw: fix error return code in cpsw_probe()
      qed: fix error return code in qed_iwarp_ll2_start()
      net: b44: fix error return code in b44_init_one()
      ah6: fix error return code in ah6_input()
      atl1c: fix error return code in atl1c_probe()
      atl1e: fix error return code in atl1e_probe()

Zhang Qilong (5):
      ipv6: Fix error path to cancel the meseage
      can: ti_hecc: Fix memleak in ti_hecc_probe
      can: flexcan: fix failure handling of pm_runtime_get_sync()
      PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter
      net: fec: Fix reference count leak in fec series ops

 MAINTAINERS                                        |  27 +++--
 drivers/atm/nicstar.c                              |   2 +
 drivers/net/can/dev.c                              |   2 +-
 drivers/net/can/flexcan.c                          |  28 ++---
 drivers/net/can/kvaser_pciefd.c                    |   4 +-
 drivers/net/can/m_can/Kconfig                      |   3 +-
 drivers/net/can/m_can/m_can.c                      |  18 +++-
 drivers/net/can/m_can/m_can.h                      |   1 +
 drivers/net/can/m_can/m_can_platform.c             |  23 +++--
 drivers/net/can/m_can/tcan4x5x.c                   |  32 ++++--
 drivers/net/can/ti_hecc.c                          |  13 ++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   2 +-
 drivers/net/can/usb/mcba_usb.c                     |   4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   4 +-
 drivers/net/dsa/lantiq_gswip.c                     |  11 ++
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +
 drivers/net/dsa/mv88e6xxx/global1.c                |  31 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h                |   1 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |  59 +++++++++--
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   4 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   4 +-
 drivers/net/ethernet/broadcom/b44.c                |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   5 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |   4 +
 drivers/net/ethernet/freescale/enetc/Kconfig       |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |  62 ++++++++---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    | 115 +++++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c  |   8 +-
 drivers/net/ethernet/freescale/fec_main.c          |  12 +--
 drivers/net/ethernet/marvell/mvneta.c              |   5 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   7 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   6 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  14 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   3 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   9 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  20 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   7 ++
 drivers/net/ethernet/mellanox/mlxsw/Kconfig        |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   3 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  13 +--
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h          |   3 -
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |  12 ++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   5 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +
 drivers/net/ethernet/ti/am65-cpts.c                |   3 +-
 drivers/net/ethernet/ti/cpsw.c                     |  11 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   9 +-
 drivers/net/geneve.c                               |   3 +-
 drivers/net/ipa/gsi_trans.c                        |  15 ++-
 drivers/net/netdevsim/dev.c                        |   2 +
 drivers/net/netdevsim/health.c                     |   1 +
 drivers/net/netdevsim/udp_tunnels.c                |   1 +
 drivers/net/phy/mscc/mscc_macsec.c                 |   1 -
 drivers/net/phy/smsc.c                             |   4 +-
 drivers/net/usb/cx82310_eth.c                      |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +-
 include/linux/pm_runtime.h                         |  21 ++++
 include/net/ip_tunnels.h                           |   7 +-
 include/net/ipv6_frag.h                            |  30 ++++++
 include/net/neighbour.h                            |   1 +
 include/net/tls.h                                  |  16 ++-
 kernel/bpf/verifier.c                              |  18 +++-
 kernel/fail_function.c                             |   5 +-
 kernel/trace/bpf_trace.c                           |  12 ++-
 lib/strncpy_from_user.c                            |  19 +++-
 mm/page_alloc.c                                    |   5 +
 net/bridge/br_device.c                             |   1 +
 net/can/af_can.c                                   |  38 +++++--
 net/core/devlink.c                                 |   6 +-
 net/core/neighbour.c                               |   2 +
 net/core/netpoll.c                                 |  22 +++-
 net/core/skmsg.c                                   |  87 +++++++++++++---
 net/ipv4/arp.c                                     |   6 ++
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/inet_diag.c                               |   4 +-
 net/ipv4/tcp_bbr.c                                 |   2 +-
 net/ipv4/tcp_bpf.c                                 |  18 ++--
 net/ipv6/addrconf.c                                |   8 +-
 net/ipv6/ah6.c                                     |   3 +-
 net/ipv6/ndisc.c                                   |   7 ++
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   9 ++
 net/ipv6/reassembly.c                              |  26 ++---
 net/mac80211/rc80211_minstrel.c                    |  27 +----
 net/mac80211/rc80211_minstrel.h                    |   1 -
 net/mac80211/sta_info.c                            |  14 +--
 net/mac80211/status.c                              |  18 ++--
 net/ncsi/ncsi-manage.c                             |   5 -
 net/ncsi/ncsi-netlink.c                            |  22 +---
 net/ncsi/ncsi-netlink.h                            |   3 -
 net/netlabel/netlabel_unlabeled.c                  |   2 +-
 net/rfkill/core.c                                  |   3 +
 net/sctp/input.c                                   |   4 +-
 net/sctp/sm_sideeffect.c                           |   4 +-
 net/sctp/transport.c                               |   2 +-
 net/smc/af_smc.c                                   |   3 +-
 net/smc/smc_core.c                                 |   3 +-
 net/smc/smc_ib.c                                   |   6 +-
 net/tls/tls_device.c                               |  37 +++++--
 net/tls/tls_sw.c                                   |   2 +-
 net/vmw_vsock/af_vsock.c                           |   2 +-
 net/x25/af_x25.c                                   |   1 +
 tools/bpf/bpftool/net.c                            |  18 ++--
 tools/lib/bpf/Makefile                             |   2 +
 tools/lib/bpf/libbpf.c                             |  23 +++--
 .../selftests/bpf/prog_tests/probe_read_user_str.c |  71 +++++++++++++
 .../selftests/bpf/prog_tests/sockopt_multi.c       |   3 +-
 tools/testing/selftests/bpf/prog_tests/subprogs.c  |   6 ++
 .../selftests/bpf/prog_tests/test_global_funcs.c   |   1 +
 .../selftests/bpf/progs/test_global_func8.c        |  19 ++++
 .../selftests/bpf/progs/test_probe_read_user_str.c |  25 +++++
 .../selftests/bpf/progs/test_subprogs_unused.c     |  21 ++++
 123 files changed, 1054 insertions(+), 379 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_read_user_str.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func8.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_probe_read_user_str.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs_unused.c
