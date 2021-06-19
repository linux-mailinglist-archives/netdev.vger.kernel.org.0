Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A375B3AD67B
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 03:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhFSB1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 21:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234601AbhFSB07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 21:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 450196102A;
        Sat, 19 Jun 2021 01:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624065889;
        bh=kciLYbr+ESZ+Re02aKQXicKHX5kGdAPe3ay3DEeyYjw=;
        h=From:To:Cc:Subject:Date:From;
        b=bizpNJfhw1NacHthAUZxdO19T+ZIV0w25VWIwxqeCxbrWAlPMIgXsGQbqOt4A5XVS
         wDjqgMw2So6satCyaktC4CeIexs/AVTWi9XzWSmrtbNGexqRqhROF9AYLCYrYurO7s
         WTFOpVkVR1SefOIITw3fGJg8C/k5CG0G+rYB5v3FhZx5apJAbmJX6njrYBzLt0yE92
         jfixx8MBgCN0Qdd6gKFukkxBqCti6LYIYjYBw/WK+0lGme+I11S3wqIxIJ49fWlfwj
         hiqeJiVUsZI0f97aEoC5VN4asZ1llUa2krwalIa1Xo40oj0jrm1uLgp3Jj43PBUFx/
         2BtKeWK80+DUQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.13-rc7
Date:   Fri, 18 Jun 2021 18:24:48 -0700
Message-Id: <20210619012448.3089951-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Things had indeed slowed down, nothing particularly scary,
the "current release" fixes are thinning out in number
and significance.

The following changes since commit 3822d0670c9d4342794d73e0d0e615322b40438e:

  cxgb4: avoid link re-train during TC-MQPRIO configuration (2021-06-04 14:45:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc7

for you to fetch changes up to 9cca0c2d70149160407bda9a9446ce0c29b6e6c6:

  net: ethernet: fix potential use-after-free in ec_bhf_remove (2021-06-18 13:01:17 -0700)

----------------------------------------------------------------
Networking fixes for 5.13-rc7, including fixes from wireless, bpf,
bluetooth, netfilter and can.

Current release - regressions:

 - mlxsw: spectrum_qdisc: Pass handle, not band number to find_class()
          to fix modifying offloaded qdiscs

 - lantiq: net: fix duplicated skb in rx descriptor ring

 - rtnetlink: fix regression in bridge VLAN configuration, empty info
              is not an error, bot-generated "fix" was not needed

 - libbpf: s/rx/tx/ typo on umem->rx_ring_setup_done to fix
           umem creation

Current release - new code bugs:

 - ethtool: fix NULL pointer dereference during module EEPROM dump via
            the new netlink API

 - mlx5e: don't update netdev RQs with PTP-RQ, the special purpose queue
          should not be visible to the stack

 - mlx5e: select special PTP queue only for SKBTX_HW_TSTAMP skbs

 - mlx5e: verify dev is present in get devlink port ndo, avoid a panic

Previous releases - regressions:

 - neighbour: allow NUD_NOARP entries to be force GCed

 - further fixes for fallout from reorg of WiFi locking
     (staging: rtl8723bs, mac80211, cfg80211)

 - skbuff: fix incorrect msg_zerocopy copy notifications

 - mac80211: fix NULL ptr deref for injected rate info

 - Revert "net/mlx5: Arm only EQs with EQEs" it may cause missed IRQs

Previous releases - always broken:

 - bpf: more speculative execution fixes

 - netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local

 - udp: fix race between close() and udp_abort() resulting in a panic

 - fix out of bounds when parsing TCP options before packets
   are validated (in netfilter: synproxy, tc: sch_cake and mptcp)

 - mptcp: improve operation under memory pressure, add missing wake-ups

 - mptcp: fix double-lock/soft lookup in subflow_error_report()

 - bridge: fix races (null pointer deref and UAF) in vlan tunnel egress

 - ena: fix DMA mapping function issues in XDP

 - rds: fix memory leak in rds_recvmsg

Misc:

 - vrf: allow larger MTUs

 - icmp: don't send out ICMP messages with a source address of 0.0.0.0

 - cdc_ncm: switch to eth%d interface naming

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksander Jan Bajkowski (2):
      net: lantiq: disable interrupt before sheduling NAPI
      lantiq: net: fix duplicated skb in rx descriptor ring

Alex Elder (1):
      net: qualcomm: rmnet: don't over-count statistics

Alex Vesker (1):
      net/mlx5: DR, Fix STEv1 incorrect L3 decapsulation padding

Andrea Righi (2):
      selftests: net: veth: make test compatible with dash
      selftests: net: use bash to run udpgro_fwd test case

Austin Kim (1):
      net: ethtool: clear heap allocations for ethtool function

Avraham Stern (1):
      cfg80211: avoid double free of PMSR request

Aya Levin (5):
      net/mlx5e: Don't update netdev RQs with PTP-RQ
      net/mlx5e: Fix select queue to consider SKBTX_HW_TSTAMP
      net/mlx5e: Block offload of outer header csum for UDP tunnels
      net/mlx5e: Block offload of outer header csum for GRE tunnel
      net/mlx5: Reset mkey index on creation

Brian Norris (1):
      mac80211: correct ieee80211_iterate_active_interfaces_mtx() locking comments

Changbin Du (2):
      net: make get_net_ns return error if NET_NS is disabled
      net: inline function get_net_ns_by_fd if NET_NS is disabled

Chengyang Fan (1):
      net: ipv4: fix memory leak in ip_mc_add1_src

Chris Mi (1):
      net/mlx5e: Verify dev is present in get devlink port ndo

Christophe JAILLET (4):
      alx: Fix an error handling path in 'alx_probe()'
      qlcnic: Fix an error handling path in 'qlcnic_probe()'
      netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
      be2net: Fix an error handling path in 'be_probe()'

Daniel Borkmann (4):
      bpf: Inherit expanded/patched seen count from old aux data
      bpf: Do not mark insn as seen under speculative path verification
      bpf: Fix leakage under speculation on mispredicted branches
      bpf, selftests: Adjust few selftest outcomes wrt unreachable code

David Ahern (2):
      neighbour: allow NUD_NOARP entries to be forced GCed
      ipv4: Fix device used for dst_alloc with local routes

David S. Miller (18):
      Merge branch 'mlxsw-fixes'
      Merge tag 'batadv-net-pullrequest-20210608' of git://git.open-mesh.org/linux-merge
      Merge tag 'mac80211-for-net-2021-06-09' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2021-06-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'bridge-egress-fixes'
      Merge branch 'tcp-options-oob-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'mptcp-fixes'
      Merge branch 'cxgb4-fixes'
      Merge tag 'for-net-2021-06-14' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth Luiz Augusto von Dentz says:
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'fec-ptp-fixes'
      Merge tag 'linux-can-fixes-for-5.13-20210616' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'net-packet-data-races'
      Merge tag 'mlx5-fixes-2021-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'bnxt_en-fixes'
      Merge tag 'mac80211-for-net-2021-06-18' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211

Dima Chumak (1):
      net/mlx5e: Fix page reclaim for dead peer hairpin

Dmytro Linkin (1):
      net/mlx5e: Don't create devices during unload flow

Dongliang Mu (1):
      net: usb: fix possible use-after-free in smsc75xx_bind

Du Cheng (2):
      cfg80211: call cfg80211_leave_ocb when switching away from OCB
      mac80211: fix skb length check in ieee80211_scan_rx()

Eric Dumazet (7):
      inet: annotate data race in inet_send_prepare() and inet_dgram_connect()
      net: annotate data race in sock_error()
      inet: annotate date races around sk->sk_txhash
      net/packet: annotate data race in packet_sendmsg()
      net/packet: annotate accesses to po->bind
      net/packet: annotate accesses to po->ifindex
      net/af_unix: fix a data-race in unix_dgram_sendmsg / unix_release_sock

Esben Haabendal (4):
      net: ll_temac: Make sure to free skb when it is completely used
      net: ll_temac: Add memory-barriers for TX BD access
      net: ll_temac: Fix TX BD buffer overwrite
      net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY

Felix Fietkau (1):
      mac80211: minstrel_ht: fix sample time check

Florian Westphal (2):
      selftests: netfilter: add fib test case
      netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local

Fugang Duan (1):
      net: fec_ptp: add clock rate zero check

Huy Nguyen (1):
      net/mlx5e: Remove dependency in IPsec initialization flows

Ido Schimmel (2):
      ethtool: Fix NULL pointer dereference during module EEPROM dump
      rtnetlink: Fix regression in bridge VLAN configuration

Jakub Kicinski (2):
      ethtool: strset: fix message length calculation
      ptp: improve max_adj check against unreasonable values

Jisheng Zhang (1):
      net: stmmac: dwmac1000: Fix extended MAC address registers definition

Joakim Zhang (2):
      net: stmmac: disable clocks in stmmac_remove_config_dt()
      net: fec_ptp: fix issue caused by refactor the fec_devtype

Johannes Berg (12):
      mac80211: remove warning in ieee80211_get_sband()
      mac80211_hwsim: drop pending frames on stop
      staging: rtl8723bs: fix monitor netdev register/unregister
      mac80211: fix deadlock in AP/VLAN handling
      mac80211: fix 'reset' debugfs locking
      cfg80211: fix phy80211 symlink creation
      cfg80211: shut down interfaces on failed resume
      mac80211: move interface shutdown out of wiphy lock
      mac80211: drop multicast fragments
      cfg80211: make certificate generation more robust
      mac80211: reset profile_periodicity/ema_ap
      mac80211: handle various extensible elements correctly

Karsten Graul (1):
      MAINTAINERS: add Guvenc as SMC maintainer

Kees Cook (4):
      r8152: Avoid memcpy() over-reading of ETH_SS_STATS
      sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
      r8169: Avoid memcpy() over-reading of ETH_SS_STATS
      net: qed: Fix memcpy() overflow of qed_dcbx_params()

Kev Jackson (1):
      libbpf: Fixes incorrect rx_ring_setup_done

Kristian Evensen (1):
      qmi_wwan: Do not call netif_rx from rx_fixup

Leon Romanovsky (2):
      net/mlx5: Fix error path for set HCA defaults
      net/mlx5: Check that driver was probed prior attaching the device

Linyu Yuan (1):
      net: cdc_eem: fix tx fixup skb leak

Luiz Augusto von Dentz (1):
      Bluetooth: SMP: Fix crash when receiving new connection when debug is enabled

Maciej Fijalkowski (2):
      ice: add ndo_bpf callback for safe mode netdev ops
      ice: parameterize functions responsible for Tx ring management

Maciej Żenczykowski (1):
      net: cdc_ncm: switch to eth%d interface naming

Maor Gottlieb (2):
      net/mlx5: Consider RoCE cap before init RDMA resources
      net/mlx5: DR, Don't use SW steering when RoCE is not supported

Marcelo Ricardo Leitner (1):
      net/sched: act_ct: handle DNAT tuple collision

Mathy Vanhoef (1):
      mac80211: Fix NULL ptr deref for injected rate info

Maxim Mikityanskiy (3):
      netfilter: synproxy: Fix out of bounds when parsing TCP options
      mptcp: Fix out of bounds when parsing TCP options
      sch_cake: Fix out of bounds when parsing TCP options and header

Michael Chan (1):
      bnxt_en: Rediscover PHY capabilities after firmware reset

Mykola Kostenok (1):
      mlxsw: core: Set thermal zone polling delay argument to real value at init

Nanyong Sun (1):
      net: ipv4: fix memory leak in netlbl_cipsov4_add_std

Nicolas Dichtel (1):
      vrf: fix maximum MTU

Nikolay Aleksandrov (2):
      net: bridge: fix vlan tunnel dst null pointer dereference
      net: bridge: fix vlan tunnel dst refcnt when egressing

Norbert Slusarek (1):
      can: bcm: fix infoleak in struct bcm_msg_head

Oleksij Rempel (1):
      can: j1939: fix Use-after-Free, hold skb ref while in use

Pablo Neira Ayuso (1):
      netfilter: nf_tables: initialize set before expression setup

Paolo Abeni (6):
      udp: fix race between close() and udp_abort()
      mptcp: try harder to borrow memory from subflow under pressure
      mptcp: wake-up readers only for in sequence data
      mptcp: do not warn on bad input from the network
      selftests: mptcp: enable syncookie only in absence of reorders
      mptcp: fix soft lookup in subflow_error_report()

Parav Pandit (3):
      net/mlx5: E-Switch, Read PF mac address
      net/mlx5: E-Switch, Allow setting GUID for host PF vport
      net/mlx5: SF_DEV, remove SF device on invalid state

Pavel Machek (1):
      cxgb4: fix wrong shift.

Pavel Skripkin (7):
      revert "net: kcm: fix memory leak in kcm_sendmsg"
      net: rds: fix memory leak in rds_recvmsg
      net: caif: fix memory leak in ldisc_open
      net: qrtr: fix OOB Read in qrtr_endpoint_post
      can: mcba_usb: fix memory leak in mcba_usb
      net: hamradio: fix memory leak in mkiss_close
      net: ethernet: fix potential use-after-free in ec_bhf_remove

Petr Machata (2):
      mlxsw: reg: Spectrum-3: Enforce lowest max-shaper burst size of 11
      mlxsw: spectrum_qdisc: Pass handle, not band number to find_class()

Praneeth Bajjuri (1):
      net: phy: dp83867: perform soft reset and retain established link

Rahul Lakkireddy (4):
      cxgb4: fix endianness when flashing boot image
      cxgb4: fix sleep in atomic when flashing PHY firmware
      cxgb4: halt chip before flashing PHY firmware image
      cxgb4: fix wrong ethtool n-tuple rule lookup

Rukhsana Ansari (1):
      bnxt_en: Fix TQM fastpath ring backing store computation

Shay Agroskin (1):
      net: ena: fix DMA mapping function issues in XDP

Shay Drory (1):
      Revert "net/mlx5: Arm only EQs with EQEs"

Somnath Kotur (1):
      bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path

Subash Abhinov Kasiviswanathan (1):
      net: mhi_net: Update the transmit handler prototype

Sven Eckelmann (1):
      batman-adv: Avoid WARN_ON timing related checks

Tetsuo Handa (1):
      can: bcm/raw/isotp: use per module netdevice notifier

Toke Høiland-Jørgensen (2):
      icmp: don't send out ICMP messages with a source address of 0.0.0.0
      selftests/net: Add icmp.sh for testing ICMP dummy address responses

Tyson Moore (1):
      sch_cake: revise docs for RFC 8622 LE PHB support

Vlad Buslov (1):
      net/mlx5e: Fix use-after-free of encap entry in neigh update handler

Vladimir Oltean (1):
      net: dsa: felix: re-enable TX flow control in ocelot_port_flush()

Willem de Bruijn (1):
      skbuff: fix incorrect msg_zerocopy copy notifications

Yang Li (1):
      net/mlx5e: Fix an error code in mlx5e_arfs_create_tables()

Zheng Yongjun (2):
      net: ipv4: Remove unneed BUG() function
      ping: Check return value of function 'ping_queue_rcv_skb'

gushengxian (1):
      net: appletalk: fix the usage of preposition

 MAINTAINERS                                        |   1 +
 drivers/net/caif/caif_serial.c                     |   1 +
 drivers/net/can/usb/mcba_usb.c                     |  17 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  54 ++---
 drivers/net/ethernet/atheros/alx/main.c            |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |  48 +++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 -
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  46 +++--
 drivers/net/ethernet/ec_bhf.c                      |   4 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   1 +
 drivers/net/ethernet/freescale/fec_ptp.c           |   8 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  18 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  15 ++
 drivers/net/ethernet/lantiq_xrx200.c               |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  19 ++
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  22 ++
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  33 ++-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  25 +--
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |   3 +
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |   1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  26 ++-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c |  30 ++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   2 -
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |   5 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   5 +
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |   2 +
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c         |   4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   1 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |  18 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   2 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  27 ++-
 drivers/net/hamradio/mkiss.c                       |   1 +
 drivers/net/mhi/net.c                              |   2 +-
 drivers/net/phy/dp83867.c                          |   6 +-
 drivers/net/usb/cdc_eem.c                          |   2 +-
 drivers/net/usb/cdc_ncm.c                          |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +-
 drivers/net/usb/r8152.c                            |   2 +-
 drivers/net/usb/smsc75xx.c                         |  10 +-
 drivers/net/vrf.c                                  |   6 +-
 drivers/net/wireless/mac80211_hwsim.c              |   5 +
 drivers/ptp/ptp_clock.c                            |   6 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   4 +-
 include/linux/mlx5/driver.h                        |   4 +
 include/linux/mlx5/transobj.h                      |   1 +
 include/linux/ptp_clock_kernel.h                   |   2 +-
 include/linux/socket.h                             |   2 -
 include/net/mac80211.h                             |   9 +-
 include/net/net_namespace.h                        |  14 +-
 include/net/sock.h                                 |  17 +-
 include/uapi/linux/in.h                            |   3 +
 kernel/bpf/verifier.c                              |  68 ++++++-
 net/appletalk/aarp.c                               |   2 +-
 net/batman-adv/bat_iv_ogm.c                        |   4 +-
 net/bluetooth/smp.c                                |   6 +-
 net/bridge/br_private.h                            |   4 +-
 net/bridge/br_vlan_tunnel.c                        |  38 ++--
 net/can/bcm.c                                      |  62 ++++--
 net/can/isotp.c                                    |  61 ++++--
 net/can/j1939/transport.c                          |  54 +++--
 net/can/raw.c                                      |  62 ++++--
 net/core/neighbour.c                               |   1 +
 net/core/net_namespace.c                           |  20 +-
 net/core/rtnetlink.c                               |   8 +-
 net/core/skbuff.c                                  |   4 +-
 net/ethtool/eeprom.c                               |   2 +-
 net/ethtool/ioctl.c                                |  10 +-
 net/ethtool/strset.c                               |   2 +
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/cipso_ipv4.c                              |   1 +
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/icmp.c                                    |   7 +
 net/ipv4/igmp.c                                    |   1 +
 net/ipv4/ping.c                                    |  12 +-
 net/ipv4/route.c                                   |  15 +-
 net/ipv4/udp.c                                     |  10 +
 net/ipv6/addrconf.c                                |   2 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  22 +-
 net/ipv6/udp.c                                     |   3 +
 net/kcm/kcmsock.c                                  |   5 -
 net/mac80211/debugfs.c                             |  11 +-
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/iface.c                               |  19 +-
 net/mac80211/main.c                                |   7 +-
 net/mac80211/mlme.c                                |   8 +
 net/mac80211/rc80211_minstrel_ht.c                 |   2 +-
 net/mac80211/rx.c                                  |   9 +-
 net/mac80211/scan.c                                |  21 +-
 net/mac80211/tx.c                                  |  52 +++--
 net/mac80211/util.c                                |  24 +--
 net/mptcp/options.c                                |   2 +
 net/mptcp/protocol.c                               |  52 ++---
 net/mptcp/protocol.h                               |   1 -
 net/mptcp/subflow.c                                | 108 +++++-----
 net/netfilter/nf_synproxy_core.c                   |   5 +
 net/netfilter/nf_tables_api.c                      |  85 ++++----
 net/packet/af_packet.c                             |  41 ++--
 net/qrtr/qrtr.c                                    |   2 +-
 net/rds/recv.c                                     |   2 +-
 net/sched/act_ct.c                                 |  21 +-
 net/sched/sch_cake.c                               |  18 +-
 net/socket.c                                       |  13 --
 net/unix/af_unix.c                                 |   7 +-
 net/wireless/Makefile                              |   2 +-
 net/wireless/core.c                                |  13 +-
 net/wireless/pmsr.c                                |  16 +-
 net/wireless/sysfs.c                               |   4 +
 net/wireless/util.c                                |   3 +
 tools/lib/bpf/xsk.c                                |   2 +-
 tools/testing/selftests/bpf/test_verifier.c        |   2 +-
 tools/testing/selftests/bpf/verifier/and.c         |   2 +
 tools/testing/selftests/bpf/verifier/bounds.c      |  14 ++
 tools/testing/selftests/bpf/verifier/dead_code.c   |   2 +
 tools/testing/selftests/bpf/verifier/jmp32.c       |  22 ++
 tools/testing/selftests/bpf/verifier/jset.c        |  10 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |   2 +
 .../selftests/bpf/verifier/value_ptr_arith.c       |   7 +-
 tools/testing/selftests/net/fib_tests.sh           |  25 +++
 tools/testing/selftests/net/icmp.sh                |  74 +++++++
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  11 +-
 tools/testing/selftests/net/udpgro_fwd.sh          |   2 +-
 tools/testing/selftests/net/veth.sh                |   5 +-
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 tools/testing/selftests/netfilter/nft_fib.sh       | 221 +++++++++++++++++++++
 145 files changed, 1513 insertions(+), 589 deletions(-)
 create mode 100755 tools/testing/selftests/net/icmp.sh
 create mode 100755 tools/testing/selftests/netfilter/nft_fib.sh
