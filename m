Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8273C84EB
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 15:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhGNNDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 09:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhGNNDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 09:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39DF561154;
        Wed, 14 Jul 2021 13:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626267652;
        bh=tw7KcKv2BejPG5O0sNU3R2f3tuv2YN6watCbgRIaLdQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ZW11IQu42Oyat1c6v41G3j3flnvmH/DVqNdA+h53uTPNkLUaDXN3pdjKJ57zB0yZN
         M/OSrCmmZkG99qXfXkxUBr4GWyKv4O+yW4fVd91Dp/KUm2KtlTv8P3ZDv+ua02jTjr
         MR1EJN5yJQv3cGDMGX0k2mF0bWxvx9jh/agEJFNChuELc1E4/db/0FJjRPVsiNKfxW
         7w+gQOe3TYBKi0RsUJbICxci9ENyW02ptiCBvtoNjEWkgr3kun1oe5kd5R5lmrfEc4
         B9k+S/vilrt1V9bYgw3L8NhU7e9bfva2PZmndAdJvkZMvBXQMY0N9+wph7Sp79mCXK
         9A3QtpX3ms+JA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [GIT PULL] Networking for 5.14-rc2
Date:   Wed, 14 Jul 2021 06:00:01 -0700
Message-Id: <20210714130001.3799721-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit dbe69e43372212527abf48609aba7fc39a6daa27:

  Merge tag 'net-next-5.14' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2021-06-30 15:51:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc2

for you to fetch changes up to bcb9928a155444dbd212473e60241ca0a7f641e1:

  net: dsa: properly check for the bridge_leave methods in dsa_switch_bridge_leave() (2021-07-13 14:47:10 -0700)

----------------------------------------------------------------
Networking fixes for 5.14-rc2, including fixes from bpf and netfilter.

Current release - regressions:

 - sock: fix parameter order in sock_setsockopt()

Current release - new code bugs:

 - netfilter: nft_last:
     - fix incorrect arithmetic when restoring last used
     - honor NFTA_LAST_SET on restoration

Previous releases - regressions:

 - udp: properly flush normal packet at GRO time

 - sfc: ensure correct number of XDP queues; don't allow enabling the
        feature if there isn't sufficient resources to Tx from any CPU

 - dsa: sja1105: fix address learning getting disabled on the CPU port

 - mptcp: addresses a rmem accounting issue that could keep packets
        in subflow receive buffers longer than necessary, delaying
	MPTCP-level ACKs

 - ip_tunnel: fix mtu calculation for ETHER tunnel devices

 - do not reuse skbs allocated from skbuff_fclone_cache in the napi
   skb cache, we'd try to return them to the wrong slab cache

 - tcp: consistently disable header prediction for mptcp

Previous releases - always broken:

 - bpf: fix subprog poke descriptor tracking use-after-free

 - ipv6:
      - allocate enough headroom in ip6_finish_output2() in case
        iptables TEE is used
      - tcp: drop silly ICMPv6 packet too big messages to avoid
        expensive and pointless lookups (which may serve as a DDOS
	vector)
      - make sure fwmark is copied in SYNACK packets
      - fix 'disable_policy' for forwarded packets (align with IPv4)

 - netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state

 - netfilter: conntrack: do not mark RST in the reply direction coming
      after SYN packet for an out-of-sync entry

 - mptcp: cleanly handle error conditions with MP_JOIN and syncookies

 - mptcp: fix double free when rejecting a join due to port mismatch

 - validate lwtstate->data before returning from skb_tunnel_info()

 - tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path

 - mt76: mt7921: continue to probe driver when fw already downloaded

 - bonding: fix multiple issues with offloading IPsec to (thru?) bond

 - stmmac: ptp: fix issues around Qbv support and setting time back

 - bcmgenet: always clear wake-up based on energy detection

Misc:

 - sctp: move 198 addresses from unusable to private scope

 - ptp: support virtual clocks and timestamping

 - openvswitch: optimize operation for key comparison

----------------------------------------------------------------
Aaron Ma (1):
      mt76: mt7921: continue to probe driver when fw already downloaded

Aleksandr Loktionov (1):
      igb: Check if num of q_vectors is smaller than max before array access

Alexander Ovechkin (1):
      net: send SYNACK packet with accepted fwmark

Ali Abdallah (2):
      netfilter: conntrack: improve RST handling when tuple is re-used
      netfilter: conntrack: add new sysctl to disable RST check

Antoine Tenart (1):
      net: do not reuse skbuff allocated from skbuff_fclone_cache in the skb cache

Bailey Forrest (1):
      gve: DQO: Remove incorrect prefetch

Baowen Zheng (1):
      openvswitch: Optimize operation for key comparison

Christoph Hellwig (1):
      net: remove the caif_hsi driver

Christophe JAILLET (9):
      ixgbe: Fix an error handling path in 'ixgbe_probe()'
      igc: Fix an error handling path in 'igc_probe()'
      igb: Fix an error handling path in 'igb_probe()'
      fm10k: Fix an error handling path in 'fm10k_probe()'
      e1000e: Fix an error handling path in 'e1000_probe()'
      iavf: Fix an error handling path in 'iavf_probe()'
      gve: Fix an error handling path in 'gve_probe()'
      gve: Propagate error codes to caller
      gve: Simplify code and axe the use of a deprecated API

Colin Ian King (3):
      netfilter: nf_tables: Fix dereference of null pointer flow
      octeontx2-pf: Fix assigned error return value that is never used
      octeontx2-pf: Fix uninitialized boolean variable pps

Dan Carpenter (2):
      sctp: prevent info leak in sctp_make_heartbeat()
      sock: unlock on error in sock_setsockopt()

David S. Miller (17):
      Merge branch 'octeopntx2-LMTST-regions'
      Merge branch 'dsa-mv88e6xxx-topaz-fixes'
      Merge branch 'master' of ../net-next/
      Merge branch 'octeontx2-dmasc-filtering'
      Merge branch 'wwan-iosm-fixes'
      Merge branch 'ptp-virtual-clocks-and-timestamping'
      Merge branch 'sms911x-dts'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/t nguy/net-queue
      Merge branch 'nfp-ct-fixes'
      Merge branch 'stmmac-ptp'
      Merge branch 'bonding-ipsec'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'ncsi-phy-link-up'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'mptcp-Connection-and-accounting-fixes'
      Merge branch 'bridge-mc-fixes'
      Merge branch 'sfc-tx-queues'

Doug Berger (1):
      net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Duncan Roe (1):
      netfilter: uapi: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h

Eric Dumazet (5):
      net: annotate data race around sk_ll_usec
      udp: annotate data races around unix_sk(sk)->gso_size
      tcp: annotate data races around tp->mtu_info
      sock: fix error in sock_setsockopt()
      ipv6: tcp: drop silly ICMPv6 packet too big messages

Florian Fainelli (2):
      skbuff: Fix build with SKB extensions disabled
      net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Florian Westphal (2):
      selftest: netfilter: add test case for unreplied tcp connections
      netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state

Gatis Peisenieks (1):
      atl1c: fix Mikrotik 10/25G NIC detection

Geert Uytterhoeven (2):
      ARM: dts: qcom-apq8060: Correct Ethernet node name and drop bogus irq property
      dt-bindings: net: sms911x: Convert to json-schema

Geetha sowjanya (2):
      octeontx2-af: cn10k: Support configurable LMTST regions
      octeontx2-pf: cn10k: Use runtime allocated LMTLINE region

Gu Shengxian (1):
      bpftool: Properly close va_list 'ap' by va_end() on error

Hangbin Liu (3):
      selftests: icmp_redirect: remove from checking for IPv6 route get
      selftests: icmp_redirect: IPv6 PMTU info should be cleared after redirect
      net: ip_tunnel: fix mtu calculation for ETHER tunnel devices

Hariprasad Kelam (2):
      octeontx2-af: Debugfs support for DMAC filters
      octeontx2-pf: offload DMAC filters to CGX/RPM block

Harman Kalra (1):
      octeontx2-af: cn10k: Setting up lmtst map table

Ivan Mikhaylov (3):
      net/ncsi: fix restricted cast warning of sparse
      net/ncsi: add NCSI Intel OEM command to keep PHY up
      net/ncsi: add dummy response handler for Intel boards

Jedrzej Jagielski (1):
      igb: Fix position of assignment to *ring

Jesper Dangaard Brouer (1):
      net/sched: sch_taprio: fix typo in comment

Jianguo Wu (5):
      mptcp: fix warning in __skb_flow_dissect() when do syn cookie for subflow join
      mptcp: remove redundant req destruct in subflow_check_req()
      mptcp: fix syncookie process if mptcp can not_accept new subflow
      mptcp: avoid processing packet if a subflow reset
      selftests: mptcp: fix case multiple subflows limited by server

John Fastabend (2):
      bpf: Track subprog poke descriptors correctly and fix use-after-free
      bpf: Selftest to verify mixing bpf2bpf calls and tailcalls with insn patch

Jonathan Lemon (1):
      ptp: Relocate lookup cookie to correct block.

Kees Cook (1):
      s390: iucv: Avoid field over-reading memcpy()

Lorenzo Bianconi (1):
      net: marvell: always set skb_shared_info in mvneta_swbm_add_rx_fragment

Louis Peens (2):
      net/sched: act_ct: remove and free nf_table callbacks
      nfp: flower-ct: remove callback delete deadlock

M Chetan Kumar (5):
      net: wwan: iosm: fix uevent reporting
      net: wwan: iosm: remove reduandant check
      net: wwan: iosm: correct link-id handling
      net: wwan: iosm: fix netdev tx stats
      net: wwan: iosm: set default mtu

Manfred Spraul (1):
      netfilter: conntrack: Mark access for KCSAN

Marek Behún (7):
      net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
      net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
      net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz
      net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz
      net: dsa: mv88e6xxx: enable SerDes RX stats for Topaz
      net: dsa: mv88e6xxx: enable SerDes PCS register dump via ethtool -d on Topaz
      net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340

Mohammad Athari Bin Ismail (1):
      net: stmmac: Terminate FPE workqueue in suspend

Nguyen Dinh Phi (1):
      tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized

Nicolas Dichtel (1):
      ipv6: fix 'disable_policy' for fwd packets

Nikolay Aleksandrov (2):
      net: bridge: multicast: fix PIM hello router port marking race
      net: bridge: multicast: fix MRD advertisement router port marking race

Oleksij Rempel (1):
      net: usb: asix: ax88772: suspend PHY on driver probe

Pablo Neira Ayuso (2):
      netfilter: nft_last: honor NFTA_LAST_SET on restoration
      netfilter: nft_last: incorrect arithmetics when restoring last used

Paolo Abeni (3):
      tcp: consistently disable header prediction for mptcp
      udp: properly flush normal packet at GRO time
      mptcp: properly account bulk freed memory

Paul Blakey (1):
      skbuff: Release nfct refcount on napi stolen or re-used skbs

Pavel Skripkin (4):
      net: moxa: fix UAF in moxart_mac_probe
      net: qcom/emac: fix UAF in emac_remove
      net: ti: fix UAF in tlan_remove_one
      net: fddi: fix UAF in fza_probe

Randy Dunlap (2):
      net: microchip: sparx5: fix kconfig warning
      net: hdlc: rename 'mod_init' & 'mod_exit' functions to be module-specific

Ronak Doshi (1):
      vmxnet3: fix cksum offload issues for tunnels with non-default udp ports

Roy, UjjaL (1):
      ipmr: Fix indentation issue

SanjayKumar Jeyakumar (1):
      tools/runqslower: Use __state instead of state

Shahjada Abul Husain (1):
      cxgb4: fix IRQ free race during driver unload

Sukadev Bhattiprolu (1):
      ibmvnic: retry reset if there are no other resets

Sunil Kumar Kori (1):
      octeontx2-af: DMAC filter support in MAC block

Taehee Yoo (10):
      bonding: fix suspicious RCU usage in bond_ipsec_add_sa()
      bonding: fix null dereference in bond_ipsec_add_sa()
      net: netdevsim: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops
      ixgbevf: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops
      bonding: fix suspicious RCU usage in bond_ipsec_del_sa()
      bonding: disallow setting nested bonding + ipsec offload
      bonding: Add struct bond_ipesc to manage SA
      bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()
      bonding: fix incorrect return value of bond_ipsec_offload_ok()
      net: validate lwtstate->data before returning from skb_tunnel_info()

Talal Ahmad (1):
      tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path

Toke Høiland-Jørgensen (3):
      bpf, devmap: Convert remaining READ_ONCE() to rcu_dereference_check()
      bpf, samples: Add -fno-asynchronous-unwind-tables to BPF Clang invocation
      libbpf: Restore errno return for functions that were already returning it

Tom Rix (1):
      igc: change default return of igc_read_phy_reg()

Vadim Fedorenko (1):
      net: ipv6: fix return value of ip6_skb_dst_mtu

Vasily Averin (3):
      netfilter: conntrack: nf_ct_gre_keymap_flush() removal
      netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo
      ipv6: allocate enough headroom in ip6_finish_output2()

Vinicius Costa Gomes (2):
      igc: Fix use-after-free error during reset
      igb: Fix use-after-free error during reset

Vladimir Oltean (4):
      net: dsa: return -EOPNOTSUPP when driver does not implement .port_lag_join
      net: ocelot: fix switchdev objects synced for wrong netdev with LAG offload
      net: dsa: sja1105: fix address learning getting disabled on the CPU port
      net: dsa: properly check for the bridge_leave methods in dsa_switch_bridge_leave()

Wang Hai (1):
      bpf, samples: Fix xdpsock with '-M' parameter missing unload process

Wei Li (1):
      tools: bpf: Fix error in 'make -C tools/ bpf_install'

Wolfgang Bumiller (1):
      net: bridge: sync fdb to new unicast-filtering ports

Xiaoliang Yang (3):
      net: stmmac: separate the tas basetime calculation function
      net: stmmac: add mutex lock to protect est parameters
      net: stmmac: ptp: update tas basetime after ptp adjust

Xin Long (3):
      sctp: check pl.raise_count separately from its increment
      sctp: move 198 addresses from unusable to private scope
      Documentation: add more details in tipc.rst

Yajun Deng (1):
      net: Use nlmsg_unicast() instead of netlink_unicast()

Yang Yingliang (2):
      net/802/mrp: fix memleak in mrp_request_join()
      net/802/garp: fix memleak in garp_request_join()

Yangbo Lu (13):
      ptp: add ptp virtual clock driver framework
      ptp: support ptp physical/virtual clocks conversion
      ptp: track available ptp vclocks information
      ptp: add kernel API ptp_get_vclocks_index()
      ethtool: add a new command for getting PHC virtual clocks
      ptp: add kernel API ptp_convert_timestamp()
      mptcp: setsockopt: convert to mptcp_setsockopt_sol_socket_timestamping()
      net: sock: extend SO_TIMESTAMPING for PHC binding
      net: socket: support hardware timestamp conversion to PHC bound
      selftests/net: timestamping: support binding PHC
      MAINTAINERS: add entry for PTP virtual clock driver
      ptp: fix NULL pointer dereference in ptp_clock_register
      ptp: fix format string mismatch in ptp_sysfs.c

YueHaibing (2):
      stmmac: dwmac-loongson: Fix unsigned comparison to zero
      stmmac: platform: Fix signedness bug in stmmac_probe_config_dt()

Yunjian Wang (1):
      virtio_net: check virtqueue_add_sgs() return value

kernel test robot (1):
      dsa: fix for_each_child.cocci warnings

wenxu (1):
      net/sched: act_ct: fix err check for nf_conntrack_confirm

Íñigo Huguet (3):
      sfc: fix lack of XDP TX queues - error XDP TX failed (-22)
      sfc: ensure correct number of XDP queues
      sfc: add logs explaining XDP_TX/REDIRECT is not available

 Documentation/ABI/testing/sysfs-ptp                |   20 +
 Documentation/devicetree/bindings/net/gpmc-eth.txt |    2 +-
 .../devicetree/bindings/net/smsc,lan9115.yaml      |  110 ++
 Documentation/devicetree/bindings/net/smsc911x.txt |   43 -
 Documentation/networking/ethtool-netlink.rst       |   22 +
 Documentation/networking/nf_conntrack-sysctl.rst   |    6 +
 Documentation/networking/tipc.rst                  |  121 +-
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/qcom-apq8060-dragonboard.dts     |    4 +-
 arch/x86/net/bpf_jit_comp.c                        |    3 +
 drivers/net/bonding/bond_main.c                    |  181 ++-
 drivers/net/caif/Kconfig                           |    9 -
 drivers/net/caif/Makefile                          |    3 -
 drivers/net/caif/caif_hsi.c                        | 1454 --------------------
 drivers/net/dsa/microchip/ksz_common.c             |    4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   22 +-
 drivers/net/dsa/mv88e6xxx/serdes.c                 |    6 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   14 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c      |    5 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   23 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |    3 +
 drivers/net/ethernet/google/gve/gve_main.c         |   19 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |    7 -
 drivers/net/ethernet/ibm/ibmvnic.c                 |   22 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |    1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |    1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |   15 +-
 drivers/net/ethernet/intel/igc/igc.h               |    2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |    3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    1 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |   20 +-
 drivers/net/ethernet/marvell/mvneta.c              |   20 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  292 +++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   10 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |   12 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   58 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    7 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  111 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  200 +++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   88 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |    3 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   10 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |    3 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   87 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    3 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   18 +-
 .../ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c |  173 +++
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  229 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   26 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |    2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |    1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   12 +-
 drivers/net/ethernet/microchip/sparx5/Kconfig      |    1 +
 drivers/net/ethernet/moxa/moxart_ether.c           |    4 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |    9 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |   13 -
 drivers/net/ethernet/qualcomm/emac/emac.c          |    3 +-
 drivers/net/ethernet/sfc/efx_channels.c            |   22 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |    9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    1 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   41 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   56 +-
 drivers/net/ethernet/ti/tlan.c                     |    3 +-
 drivers/net/fddi/defza.c                           |    3 +-
 drivers/net/netdevsim/ipsec.c                      |    8 +-
 drivers/net/phy/marvell10g.c                       |   40 +-
 drivers/net/usb/asix_devices.c                     |    1 +
 drivers/net/virtio_net.c                           |    8 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   22 +-
 drivers/net/wan/hdlc_cisco.c                       |    8 +-
 drivers/net/wan/hdlc_fr.c                          |    8 +-
 drivers/net/wan/hdlc_ppp.c                         |    8 +-
 drivers/net/wan/hdlc_raw.c                         |    8 +-
 drivers/net/wan/hdlc_raw_eth.c                     |    8 +-
 drivers/net/wan/hdlc_x25.c                         |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    3 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |   21 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h          |    6 +-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |    2 +-
 drivers/net/wwan/iosm/iosm_ipc_uevent.c            |    2 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |   11 +-
 drivers/ptp/Makefile                               |    2 +-
 drivers/ptp/ptp_clock.c                            |   44 +-
 drivers/ptp/ptp_private.h                          |   39 +
 drivers/ptp/ptp_sysfs.c                            |  160 +++
 drivers/ptp/ptp_vclock.c                           |  219 +++
 include/linux/bpf.h                                |    1 +
 include/linux/ethtool.h                            |   10 +
 include/linux/marvell_phy.h                        |    6 +-
 include/linux/ptp_clock_kernel.h                   |   31 +-
 include/linux/stmmac.h                             |    2 +
 include/net/bonding.h                              |    9 +-
 include/net/busy_poll.h                            |    2 +-
 include/net/caif/caif_hsi.h                        |  200 ---
 include/net/dst_metadata.h                         |    4 +-
 include/net/ip6_route.h                            |    2 +-
 include/net/mptcp.h                                |    5 +-
 include/net/netfilter/nf_conntrack_core.h          |    1 -
 include/net/netns/conntrack.h                      |    1 +
 include/net/sctp/constants.h                       |    4 +-
 include/net/sock.h                                 |    8 +-
 include/net/tcp.h                                  |    4 +
 include/uapi/linux/ethtool_netlink.h               |   15 +
 include/uapi/linux/net_tstamp.h                    |   17 +-
 include/uapi/linux/netfilter/nfnetlink_log.h       |    2 +-
 include/uapi/linux/netfilter/nfnetlink_queue.h     |    4 +-
 kernel/bpf/core.c                                  |    8 +-
 kernel/bpf/devmap.c                                |    6 +-
 kernel/bpf/verifier.c                              |   60 +-
 net/802/garp.c                                     |   14 +
 net/802/mrp.c                                      |   14 +
 net/bridge/br_if.c                                 |   17 +-
 net/bridge/br_multicast.c                          |    6 +
 net/core/dev.c                                     |   16 +
 net/core/skbuff.c                                  |    1 +
 net/core/sock.c                                    |   71 +-
 net/dsa/switch.c                                   |    8 +-
 net/ethtool/Makefile                               |    2 +-
 net/ethtool/common.c                               |   14 +
 net/ethtool/netlink.c                              |   10 +
 net/ethtool/netlink.h                              |    2 +
 net/ethtool/phc_vclocks.c                          |   94 ++
 net/ipv4/fib_frontend.c                            |    2 +-
 net/ipv4/inet_diag.c                               |    5 +-
 net/ipv4/ip_tunnel.c                               |   18 +-
 net/ipv4/ipmr.c                                    |    2 +-
 net/ipv4/raw_diag.c                                |    7 +-
 net/ipv4/tcp.c                                     |    3 +
 net/ipv4/tcp_input.c                               |   21 +-
 net/ipv4/tcp_ipv4.c                                |    4 +-
 net/ipv4/tcp_output.c                              |    1 +
 net/ipv4/udp.c                                     |    6 +-
 net/ipv4/udp_diag.c                                |    6 +-
 net/ipv4/udp_offload.c                             |    6 +-
 net/ipv6/ip6_output.c                              |   32 +-
 net/ipv6/tcp_ipv6.c                                |   21 +-
 net/ipv6/udp.c                                     |    2 +-
 net/ipv6/xfrm6_output.c                            |    2 +-
 net/iucv/iucv.c                                    |   22 +-
 net/mptcp/mib.c                                    |    1 +
 net/mptcp/mib.h                                    |    1 +
 net/mptcp/mptcp_diag.c                             |    6 +-
 net/mptcp/options.c                                |   19 +-
 net/mptcp/protocol.c                               |   12 +-
 net/mptcp/protocol.h                               |   10 +-
 net/mptcp/sockopt.c                                |   68 +-
 net/mptcp/subflow.c                                |   11 +-
 net/mptcp/syncookies.c                             |   16 +-
 net/ncsi/Kconfig                                   |    6 +
 net/ncsi/internal.h                                |    5 +
 net/ncsi/ncsi-manage.c                             |   51 +-
 net/ncsi/ncsi-rsp.c                                |   11 +-
 net/netfilter/nf_conntrack_core.c                  |   11 +-
 net/netfilter/nf_conntrack_netlink.c               |    3 +
 net/netfilter/nf_conntrack_proto.c                 |    7 -
 net/netfilter/nf_conntrack_proto_gre.c             |   13 -
 net/netfilter/nf_conntrack_proto_tcp.c             |   69 +-
 net/netfilter/nf_conntrack_standalone.c            |   10 +
 net/netfilter/nf_tables_api.c                      |    3 +-
 net/netfilter/nft_last.c                           |   12 +-
 net/netlink/af_netlink.c                           |    2 +-
 net/openvswitch/flow_table.c                       |    6 +-
 net/sched/act_ct.c                                 |   14 +-
 net/sched/sch_taprio.c                             |    2 +-
 net/sctp/diag.c                                    |    6 +-
 net/sctp/protocol.c                                |    3 +-
 net/sctp/sm_make_chunk.c                           |    2 +-
 net/sctp/transport.c                               |   11 +-
 net/socket.c                                       |   19 +-
 net/unix/diag.c                                    |    6 +-
 samples/bpf/Makefile                               |    1 +
 samples/bpf/xdpsock_user.c                         |   28 +
 tools/bpf/Makefile                                 |    7 +-
 tools/bpf/bpftool/jit_disasm.c                     |    6 +-
 tools/bpf/runqslower/runqslower.bpf.c              |    2 +-
 tools/lib/bpf/libbpf.c                             |    4 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |   36 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   18 +
 tools/testing/selftests/net/icmp_redirect.sh       |    5 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |    2 +-
 tools/testing/selftests/net/timestamping.c         |   55 +-
 tools/testing/selftests/netfilter/Makefile         |    2 +-
 .../selftests/netfilter/conntrack_tcp_unreplied.sh |  167 +++
 191 files changed, 3595 insertions(+), 2346 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/smsc,lan9115.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/smsc911x.txt
 delete mode 100644 drivers/net/caif/caif_hsi.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
 create mode 100644 drivers/ptp/ptp_vclock.c
 delete mode 100644 include/net/caif/caif_hsi.h
 create mode 100644 net/ethtool/phc_vclocks.c
 create mode 100755 tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh
