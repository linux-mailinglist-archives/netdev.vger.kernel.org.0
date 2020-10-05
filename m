Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC98282FFD
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 07:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgJEFID convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Oct 2020 01:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgJEFIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 01:08:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C2CC0613CE;
        Sun,  4 Oct 2020 22:07:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69E75127DD0C7;
        Sun,  4 Oct 2020 21:51:10 -0700 (PDT)
Date:   Sun, 04 Oct 2020 22:07:55 -0700 (PDT)
Message-Id: <20201004.220755.151782290115881232.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 21:51:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Make sure SKB control block is in the proper state during IPSEC
   ESP-in-TCP encapsulation.  From Sabrina Dubroca.

2) Various kinds of attributes were not being cloned properly when
   we build new xfrm_state objects from existing ones.  Fix from
   Antony Antony.

3) Make sure to keep BTF sections, from Tony Ambardar.

4) TX DMA channels need proper locking in lantiq driver, from Hauke
   Mehrtens.

5) Honour route MTU during forwarding, always.  From Maciej
   ¯enczykowski.

6) Fix races in kTLS which can result in crashes, from Rohit
   Maheshwari.

7) Skip TCP DSACKs with rediculous sequence ranges, from Priyaranjan
   Jha.

8) Use correct address family in xfrm state lookups, from Herbert Xu.

9) A bridge FDB flush should not clear out user managed fdb entries
   with the ext_learn flag set, from Nikolay Aleksandrov.

10) Fix nested locking of netdev address lists, from Taehee Yoo.

11) Fix handling of 32-bit DATA_FIN values in mptcp, from Mat Martineau.

12) Fix r8169 data corruptions on RTL8402 chips, from Heiner Kallweit.

13) Don't free command entries in mlx5 while comp handler could still
    be running, from Eran Ben Elisha.

14) Error flow of request_irq() in mlx5 is busted, due to an off by one
    we try to free and IRQ never allocated.  From Maor Gottlieb.

15) Fix leak when dumping netlink policies, from Johannes Berg.

16) Sendpage cannot be performed when a page is a slab page, or the
    page count is < 1.  Some subsystems such as nvme were doing so.
    Create a "sendpage_ok()" helper and use it as needed, from
    Coly Li.

17) Don't leak request socket when using syncookes with mptcp, from
    Paolo Abeni.

Please pull, thanks a lot!!

The following changes since commit 805c6d3c19210c90c109107d189744e960eae025:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2020-09-22 15:08:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 4296adc3e32f5d544a95061160fe7e127be1b9ff:

  net/core: check length before updating Ethertype in skb_mpls_{push,pop} (2020-10-04 15:09:26 -0700)

----------------------------------------------------------------
Anant Thazhemadam (1):
      net: team: fix memory leak in __team_options_register

Andrii Nakryiko (1):
      libbpf: Fix XDP program load regression for old kernels

Anirudh Venkataramanan (1):
      ice: Fix call trace on suspend

Antony Antony (4):
      xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
      xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
      xfrm: clone XFRMA_SEC_CTX in xfrm_do_migrate
      xfrm: clone whole liftime_cur structure in xfrm_do_migrate

Aya Levin (6):
      net/mlx5e: Fix error path for RQ alloc
      net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU
      net/mlx5e: Fix driver's declaration to support GRE offload
      net/mlx5e: Fix return status when setting unsupported FEC mode
      net/mlx5e: Fix VLAN cleanup flow
      net/mlx5e: Fix VLAN create flow

Christophe JAILLET (1):
      net: typhoon: Fix a typo Typoon --> Typhoon

Coly Li (7):
      net: introduce helper sendpage_ok() in include/linux/net.h
      net: add WARN_ONCE in kernel_sendpage() for improper zero-copy send
      nvme-tcp: check page by sendpage_ok() before calling kernel_sendpage()
      tcp: use sendpage_ok() to detect misused .sendpage
      drbd: code cleanup by using sendpage_ok() to check page for kernel_sendpage()
      scsi: libiscsi: use sendpage_ok() in iscsi_tcp_segment_map()
      libceph: use sendpage_ok() in ceph_tcp_sendpage()

Cong Wang (4):
      net_sched: defer tcf_idr_insert() in tcf_action_init_1()
      net_sched: commit action insertions together
      net_sched: remove a redundant goto chain check
      net_sched: check error pointer in tcf_dump_walker()

David S. Miller (14):
      Merge branch 'net_sched-fix-a-UAF-in-tcf_action_init'
      Merge tag 'wireless-drivers-2020-09-25' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch '100GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge branch 'bonding-team-basic-dev-needed_headroom-support'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      Merge branch 'net-core-fix-a-lockdep-splat-in-the-dev_addr_list'
      Merge branch 'More-incorrect-VCAP-offsets-for-mscc_ocelot-switch'
      Merge branch 'via-rhine-Resume-fix-and-other-maintenance-work'
      Merge branch 'mptcp-Fix-for-32-bit-DATA_FIN'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch '100GbE' of https://github.com/anguy11/net-queue
      Merge branch 'Fix-bugs-in-Octeontx2-netdev-driver'
      Merge branch 'Introduce-sendpage_ok-to-detect-misused-sendpage-in-network-related-drivers'
      Merge tag 'mlx5-fixes-2020-09-30' of git://git.kernel.org/.../saeed/linux

Eran Ben Elisha (4):
      net/mlx5: Fix a race when moving command interface to polling mode
      net/mlx5: Avoid possible free of command entry while timeout comp handler
      net/mlx5: poll cmd EQ in case of command timeout
      net/mlx5: Add retry mechanism to the command entry index allocation

Eric Dumazet (2):
      bonding: set dev->needed_headroom in bond_setup_by_slave()
      team: set dev->needed_headroom in team_setup_by_port()

Felix Fietkau (1):
      mt76: mt7615: reduce maximum VHT MPDU length to 7991

Florian Fainelli (1):
      MAINTAINERS: Add Vladimir as a maintainer for DSA

Geert Uytterhoeven (1):
      Revert "ravb: Fixed to be able to unload modules"

Geetha sowjanya (1):
      octeontx2-pf: Fix TCP/UDP checksum offload for IPv6 frames

Guillaume Nault (1):
      net/core: check length before updating Ethertype in skb_mpls_{push,pop}

Hariprasad Kelam (2):
      octeontx2-pf: Fix the device state on error
      octeontx2-pf: Fix synchnorization issue in mbox

Hauke Mehrtens (1):
      net: lantiq: Add locking for TX DMA channel

He Zhe (1):
      bpf, powerpc: Fix misuse of fallthrough in bpf_jit_comp()

Heiner Kallweit (3):
      r8169: fix RTL8168f/RTL8411 EPHY config
      r8169: fix handling ether_clk
      r8169: fix data corruption issue on RTL8402

Helmut Grohne (1):
      net: dsa: microchip: really look for phy-mode in port nodes

Herbert Xu (1):
      xfrm: Use correct address family in xfrm_state_find

Ido Schimmel (1):
      mlxsw: spectrum_acl: Fix mlxsw_sp_acl_tcam_group_add()'s error path

Igor Russkikh (1):
      net: atlantic: fix build when object tree is separate

Ioana Ciornei (1):
      dpaa2-eth: fix command version for Tx shaping

Ivan Khoronzhuk (1):
      net: ethernet: cavium: octeon_mgmt: use phy_start and phy_stop

Jacob Keller (4):
      ice: fix memory leak if register_netdev_fails
      ice: fix memory leak in ice_vsi_setup
      ice: increase maximum wait time for flash write commands
      ice: preserve NVM capabilities in safe mode

Jakub Kicinski (2):
      genetlink: add missing kdoc for validation flags
      ethtool: mark netlink family as __ro_after_init

Jamie Iles (1):
      net/fsl: quieten expected MDIO access failures

Johannes Berg (1):
      netlink: fix policy dump leak

Kevin Brace (4):
      via-rhine: Fix for the hardware having a reset failure after resume
      via-rhine: VTunknown1 device is really VT8251 South Bridge
      via-rhine: Eliminate version information
      via-rhine: New device driver maintainer

Luo bin (1):
      hinic: fix wrong return value of mac-set cmd

Maciej ¯enczykowski (1):
      net/ipv4: always honour route mtu during forwarding

Magnus Karlsson (1):
      xsk: Do not discard packet when NETDEV_TX_BUSY

Manivannan Sadhasivam (1):
      net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks

Maor Dickman (1):
      net/mlx5e: CT, Fix coverity issue

Maor Gottlieb (1):
      net/mlx5: Fix request_irqs error flow

Marian-Cristian Rotariu (1):
      dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC

Mat Martineau (3):
      mptcp: Wake up MPTCP worker when DATA_FIN found on a TCP FIN packet
      mptcp: Consistently use READ_ONCE/WRITE_ONCE with msk->ack_seq
      mptcp: Handle incoming 32-bit DATA_FIN values

Mauro Carvalho Chehab (1):
      net: core: document two new elements of struct net_device

Nikolay Aleksandrov (1):
      net: bridge: fdb: don't flush ext_learn entries

Paolo Abeni (1):
      tcp: fix syn cookied MPTCP request socket leak

Petko Manolov (1):
      net: usb: pegasus: Proper error handing when setting pegasus' MAC address

Priyaranjan Jha (1):
      tcp: skip DSACKs with dubious sequence ranges

Randy Dunlap (2):
      mdio: fix mdio-thunder.c dependency & build error
      net: hinic: fix DEVLINK build errors

Rohit Maheshwari (1):
      net/tls: race causes kernel panic

Ronak Doshi (1):
      vmxnet3: fix cksum offload issues for non-udp tunnels

Sabrina Dubroca (2):
      espintcp: restore IP CB before handing the packet to xfrm
      xfrmi: drop ignore_df check before updating pmtu

Saeed Mahameed (1):
      net/mlx5: cmdif, Avoid skipping reclaim pages if FW is not accessible

Subbaraya Sundeep (1):
      octeontx2-af: Fix enable/disable of default NPC entries

Sylwester Dziedziuch (1):
      iavf: Fix incorrect adapter get in iavf_resume

Taehee Yoo (3):
      net: core: add __netdev_upper_dev_unlink()
      net: core: introduce struct netdev_nested_priv for nested interface infrastructure
      net: core: add nested_level variable in net_device

Tian Tao (1):
      net: switchdev: Fixed kerneldoc warning

Tom Rix (1):
      net: mvneta: fix double free of txq->buf

Tonghao Zhang (1):
      virtio-net: don't disable guest csum when disable LRO

Tony Ambardar (4):
      tools/bpftool: Support passing BPFTOOL_VERSION to make
      bpf: Fix sysfs export of empty BTF section
      bpf: Prevent .BTF section elimination
      libbpf: Fix native endian assumption when parsing BTF

Tony Nguyen (1):
      MAINTAINERS: Update MAINTAINERS for Intel ethernet drivers

Vineetha G. Jaya Kumaran (1):
      net: stmmac: Modify configuration method of EEE timers

Vlad Buslov (1):
      net/mlx5e: Fix race condition on nhe->n pointer in neigh update

Vladimir Oltean (2):
      net: dsa: felix: fix incorrect action offsets for VCAP IS2
      net: dsa: seville: fix VCAP IS2 action width

Voon Weifeng (1):
      net: stmmac: removed enabling eee in EEE set callback

Wang Qing (1):
      net/ethernet/broadcom: fix spelling typo

Wilken Gottwalt (3):
      net: usb: ax88179_178a: add Toshiba usb 3.0 adapter
      net: usb: ax88179_178a: fix missing stop entry in driver_info
      net: usb: ax88179_178a: add MCT usb 3.0 adapter

Willy Liu (1):
      net: phy: realtek: fix rtl8211e rx/tx delay config

Wong Vee Khee (1):
      net: stmmac: Fix clock handling on remove path

Xiaoliang Yang (2):
      net: dsa: felix: convert TAS link speed based on phylink speed
      net: mscc: ocelot: fix fields offset in SG_CONFIG_REG_3

Xie He (1):
      drivers/net/wan/x25_asy: Correct the ndo_open and ndo_stop functions

YueHaibing (1):
      ip_vti: Fix unused variable warning

 Documentation/devicetree/bindings/net/renesas,ravb.txt   |   1 +
 MAINTAINERS                                              |   7 ++-
 arch/powerpc/net/bpf_jit_comp.c                          |   1 -
 drivers/block/drbd/drbd_main.c                           |   2 +-
 drivers/infiniband/core/cache.c                          |  10 +++--
 drivers/infiniband/core/cma.c                            |   9 ++--
 drivers/infiniband/core/roce_gid_mgmt.c                  |   9 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c                |   9 ++--
 drivers/net/bonding/bond_alb.c                           |   9 ++--
 drivers/net/bonding/bond_main.c                          |  11 +++--
 drivers/net/dsa/microchip/ksz_common.c                   |  20 +++++----
 drivers/net/dsa/ocelot/felix_vsc9959.c                   |  34 ++++++++++++---
 drivers/net/dsa/ocelot/seville_vsc9953.c                 |   2 +-
 drivers/net/ethernet/3com/typhoon.h                      |   2 +-
 drivers/net/ethernet/aquantia/atlantic/Makefile          |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h          |  16 +++----
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c         |   6 ++-
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h          |   4 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c              |   2 +-
 drivers/net/ethernet/huawei/hinic/Kconfig                |   1 +
 drivers/net/ethernet/huawei/hinic/hinic_port.c           |   6 +--
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c          |  12 +----
 drivers/net/ethernet/intel/iavf/iavf_main.c              |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c              |  49 +++++++++++----------
 drivers/net/ethernet/intel/ice/ice_fw_update.c           |  10 ++++-
 drivers/net/ethernet/intel/ice/ice_lib.c                 |  20 +++++++--
 drivers/net/ethernet/intel/ice/ice_lib.h                 |   6 ---
 drivers/net/ethernet/intel/ice/ice_main.c                |  14 ++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c            |  37 +++++++++++-----
 drivers/net/ethernet/lantiq_xrx200.c                     |   2 +
 drivers/net/ethernet/marvell/mvneta.c                    |  13 +-----
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c         |  12 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h         |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h          |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c      |   5 +--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c      |  26 ++++++++---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c     |  16 ++++---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c   |   1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c     |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c            | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |   8 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c        |   3 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c   |  81 +++++++++++++++++++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c       |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c          |  14 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        | 104 ++++++++++++++++++++++++++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h         |   6 ---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c             |  42 +++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h         |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c        |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           |  24 +++++-----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c  |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c    |  11 +++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |  10 +++--
 drivers/net/ethernet/realtek/r8169_main.c                |  38 ++++++++++------
 drivers/net/ethernet/renesas/ravb_main.c                 | 110 +++++++++++++++++++++++-----------------------
 drivers/net/ethernet/rocker/rocker_main.c                |   9 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c        |   1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac.h             |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c     |  27 +++++++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c        |  23 ++++++----
 drivers/net/ethernet/via/via-rhine.c                     |  21 ++-------
 drivers/net/phy/Kconfig                                  |   1 +
 drivers/net/phy/realtek.c                                |  31 ++++++-------
 drivers/net/team/team.c                                  |   3 +-
 drivers/net/usb/ax88179_178a.c                           |  35 +++++++++++++++
 drivers/net/usb/pegasus.c                                |  35 +++++++++++----
 drivers/net/virtio_net.c                                 |   8 +++-
 drivers/net/vmxnet3/vmxnet3_drv.c                        |   5 +--
 drivers/net/vmxnet3/vmxnet3_ethtool.c                    |  28 ++++++++++++
 drivers/net/vmxnet3/vmxnet3_int.h                        |   4 ++
 drivers/net/wan/x25_asy.c                                |  43 ++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt7615/init.c         |   2 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c            |  10 +++--
 drivers/nvme/host/tcp.c                                  |   7 ++-
 drivers/scsi/libiscsi_tcp.c                              |   2 +-
 include/asm-generic/vmlinux.lds.h                        |   2 +-
 include/linux/mlx5/driver.h                              |   3 ++
 include/linux/net.h                                      |  16 +++++++
 include/linux/netdevice.h                                |  73 +++++++++++++++++++++++++------
 include/net/act_api.h                                    |   2 -
 include/net/genetlink.h                                  |   1 +
 include/net/ip.h                                         |   6 +++
 include/net/netlink.h                                    |   3 +-
 include/net/xfrm.h                                       |  16 +++----
 include/soc/mscc/ocelot_ana.h                            |   8 ++--
 include/uapi/linux/snmp.h                                |   1 +
 kernel/bpf/sysfs_btf.c                                   |   6 +--
 net/bridge/br_arp_nd_proxy.c                             |  26 +++++++----
 net/bridge/br_fdb.c                                      |   2 +
 net/bridge/br_vlan.c                                     |  20 ++++++---
 net/ceph/messenger.c                                     |   2 +-
 net/core/dev.c                                           | 164 ++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 net/core/dev_addr_lists.c                                |  12 ++---
 net/core/skbuff.c                                        |   4 +-
 net/ethtool/netlink.c                                    |   2 +-
 net/ipv4/ip_vti.c                                        |   2 +
 net/ipv4/proc.c                                          |   1 +
 net/ipv4/syncookies.c                                    |   2 +-
 net/ipv4/tcp.c                                           |   3 +-
 net/ipv4/tcp_input.c                                     |  32 +++++++++++---
 net/mptcp/options.c                                      |  11 ++---
 net/mptcp/protocol.c                                     |   8 ++--
 net/mptcp/protocol.h                                     |   2 +-
 net/mptcp/subflow.c                                      |  19 ++++++--
 net/netlink/genetlink.c                                  |   9 +++-
 net/netlink/policy.c                                     |  24 +++++-----
 net/qrtr/ns.c                                            |  34 +++++++++++----
 net/sched/act_api.c                                      |  54 ++++++++++++-----------
 net/sched/act_bpf.c                                      |   4 +-
 net/sched/act_connmark.c                                 |   1 -
 net/sched/act_csum.c                                     |   3 --
 net/sched/act_ct.c                                       |   2 -
 net/sched/act_ctinfo.c                                   |   3 --
 net/sched/act_gact.c                                     |   2 -
 net/sched/act_gate.c                                     |   3 --
 net/sched/act_ife.c                                      |   3 --
 net/sched/act_ipt.c                                      |   2 -
 net/sched/act_mirred.c                                   |   2 -
 net/sched/act_mpls.c                                     |   2 -
 net/sched/act_nat.c                                      |   3 --
 net/sched/act_pedit.c                                    |   2 -
 net/sched/act_police.c                                   |   2 -
 net/sched/act_sample.c                                   |   2 -
 net/sched/act_simple.c                                   |   2 -
 net/sched/act_skbedit.c                                  |   2 -
 net/sched/act_skbmod.c                                   |   2 -
 net/sched/act_tunnel_key.c                               |   3 --
 net/sched/act_vlan.c                                     |   2 -
 net/socket.c                                             |   6 ++-
 net/switchdev/switchdev.c                                |   2 +-
 net/tls/tls_sw.c                                         |   9 +++-
 net/xdp/xsk.c                                            |  17 +++++++-
 net/xfrm/espintcp.c                                      |   6 ++-
 net/xfrm/xfrm_interface.c                                |   2 +-
 net/xfrm/xfrm_state.c                                    |  42 +++++++++++++++---
 tools/bpf/bpftool/Makefile                               |   2 +-
 tools/lib/bpf/btf.c                                      |   6 +++
 tools/lib/bpf/libbpf.c                                   |   2 +-
 140 files changed, 1380 insertions(+), 690 deletions(-)
