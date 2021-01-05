Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB172EA17B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 01:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbhAEAdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 19:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbhAEAdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 19:33:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A7B2255F;
        Tue,  5 Jan 2021 00:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609806752;
        bh=ZMTzR7ZiHiWIVccJIMrPy71l3Es1Yyv5KsDSsfM3BX8=;
        h=From:To:Cc:Subject:Date:From;
        b=pF5b+zyk61OtOXrJ/hhm/wf+NufTk+U7g+GTZOf40drESp1Y5vcnodxRYoT/caxr4
         ATLAlLtmoveaEWnZF7xINNqRaLUk9WTJcCeaijIfFkjkLt6TEpKIY4jFAAKMDQI2vZ
         6TqRX4PUxkT/jnQGGmODj13MgTIPt1G6VMoYZawHOXlc9UixvJKi5+vAQGOAUF7Tsa
         /oAySOBsyTtz4AnL56Qbr8gBeEvO7HIRjnOXhnJptXvcUSrNxFV/qd3yZMbc7Ue9LX
         1kCZ7i+r7K54DAB7F8JU74U1FcabH2EwjJN9GJXH5ezTCfxQErFBwmsSf40eLMjrbV
         sv5xCmaD2Xzeg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.11-rc3
Date:   Mon,  4 Jan 2021 16:32:32 -0800
Message-Id: <20210105003232.3172133-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit d64c6f96ba86bd8b97ed8d6762a8c8cc1770d214:

  Merge tag 'net-5.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-12-17 13:45:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc3

for you to fetch changes up to a8f33c038f4e50b0f47448cb6c6ca184c4f717ef:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf (2021-01-04 14:02:02 -0800)

----------------------------------------------------------------
Networking fixes for 5.11-rc3, including fixes from netfilter, wireless
and bpf trees.

Current release - regressions:

 - mt76: - usb: fix NULL pointer dereference in mt76u_status_worker
         - sdio: fix NULL pointer dereference in mt76s_process_tx_queue

 - net: ipa: fix interconnect enable bug

Current release - always broken:

 - netfilter: ipset: fixes possible oops in mtype_resize

 - ath11k: fix number of coding issues found by static analysis tools
           and spurious error messages

Previous releases - regressions:

 - e1000e: re-enable s0ix power saving flows for systems with
           the Intel i219-LM Ethernet controllers to fix power
	   use regression

 - virtio_net: fix recursive call to cpus_read_lock() to avoid
               a deadlock

 - ipv4: ignore ECN bits for fib lookups in fib_compute_spec_dst()

 - net-sysfs: take the rtnl lock around XPS configuration

 - xsk: - fix memory leak for failed bind
        - rollback reservation at NETDEV_TX_BUSY

 - r8169: work around power-saving bug on some chip versions

Previous releases - always broken:

 - dcb: validate netlink message in DCB handler

 - tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
        to prevent unnecessary retries

 - vhost_net: fix ubuf refcount when sendmsg fails

 - bpf: save correct stopping point in file seq iteration

 - ncsi: use real net-device for response handler

 - neighbor: fix div by zero caused by a data race (TOCTOU)

 - bareudp: - fix use of incorrect min_headroom size
            - fix false positive lockdep splat from the TX lock

 - net: mvpp2: - clear force link UP during port init procedure
                 in case bootloader had set it
               - add TCAM entry to drop flow control pause frames
	       - fix PPPoE with ipv6 packet parsing
	       - fix GoP Networking Complex Control config of port 3
	       - fix pkt coalescing IRQ-threshold configuration

 - xsk: fix race in SKB mode transmit with shared cq

 - ionic: account for vlan tag len in rx buffer len

 - net: stmmac: ignore the second clock input, current clock framework
                does not handle exclusive clock use well, other drivers
		may reconfigure the second clock
Misc:

 - ppp: change PPPIOCUNBRIDGECHAN ioctl request number to follow
        existing scheme

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (6):
      net: ipa: fix interconnect enable bug
      net: ipa: clear pending interrupts before enabling
      net: ipa: use state to determine channel command success
      net: ipa: use state to determine event ring command success
      net: ipa: don't return a value from gsi_channel_command()
      net: ipa: don't return a value from evt_ring_command()

Andrii Nakryiko (1):
      selftests/bpf: Work-around EBUSY errors from hashmap update/delete

Antoine Tenart (4):
      net-sysfs: take the rtnl lock when storing xps_cpus
      net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
      net-sysfs: take the rtnl lock when storing xps_rxqs
      net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc

Arend van Spriel (1):
      MAINTAINERS: switch to different email address

Baruch Siach (4):
      net: af_packet: fix procfs header for 64-bit pointers
      docs: netdev-FAQ: fix question headers formatting
      docs: networking: packet_mmap: fix formatting for C macros
      docs: networking: packet_mmap: fix old config reference

Bjørn Mork (1):
      net: usb: qmi_wwan: add Quectel EM160R-GL

Carl Huang (4):
      ath11k: fix crash caused by NULL rx_channel
      ath11k: start vdev if a bss peer is already created
      ath11k: qmi: try to allocate a big block of DMA memory first
      ath11k: pci: disable ASPM L0sLs before downloading firmware

Charles Keepax (1):
      net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag

Colin Ian King (3):
      netfilter: nftables: fix incorrect increment of loop counter
      ath11k: add missing null check on allocated skb
      selftests/bpf: Fix spelling mistake "tranmission" -> "transmission"

Cong Wang (1):
      erspan: fix version 1 check in gre_parse_header()

Dan Carpenter (3):
      ath11k: Fix error code in ath11k_core_suspend()
      ath11k: Fix ath11k_pci_fix_l1ss()
      atm: idt77252: call pci_disable_device() on error path

David S. Miller (1):
      Merge git://git.kernel.org/.../bpf/bpf

Davide Caratti (2):
      net/sched: sch_taprio: ensure to reset/destroy all child qdiscs
      net: mptcp: cap forward allocation to 1M

Dinghao Liu (2):
      net: ethernet: mvneta: Fix error handling in mvneta_probe
      net: ethernet: Fix memleak in ethoc_probe

Eric Dumazet (1):
      bpf: Add schedule point in htab_init_buckets()

Florian Fainelli (1):
      net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE

Florian Westphal (1):
      netfilter: xt_RATEEST: reject non-null terminated string from userspace

Grygorii Strashko (1):
      net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered

Guillaume Nault (2):
      ppp: Fix PPPIOCUNBRIDGECHAN request number
      ipv4: Ignore ECN bits for fib lookups in fib_compute_spec_dst()

Heiner Kallweit (1):
      r8169: work around power-saving bug on some chip versions

Ido Schimmel (1):
      selftests: mlxsw: Set headroom size of correct port

Jakub Kicinski (13):
      iavf: fix double-release of rtnl_lock
      Merge branch '40GbE' of git://git.kernel.org/.../tnguy/net-queue
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'ucc_geth-fixes'
      MAINTAINERS: remove names from mailing list maintainers
      Merge tag 'wireless-drivers-2020-12-22' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'net-ipa-gsi-interrupt-handling-fixes'
      Merge branch 'net-sysfs-fix-race-conditions-in-the-xps-code'
      Merge branch '1GbE' of git://git.kernel.org/.../tnguy/net-queue
      Merge branch 'bnxt_en-bug-fixes'
      Merge branch 'net-ipa-fix-some-new-build-warnings'
      Merge branch 'net-dsa-lantiq_gswip-two-fixes-for-net-stable'
      Merge git://git.kernel.org/.../pablo/nf

Jeff Dike (1):
      virtio_net: Fix recursive call to cpus_read_lock()

John Wang (1):
      net/ncsi: Use real net-device for response handler

Jonathan Lemon (2):
      bpf: Save correct stopping point in file seq iteration
      bpf: Use thread_group_leader()

Kalle Valo (1):
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Kamal Mostafa (1):
      selftests/bpf: Clarify build error if no vmlinux

Lijun Pan (2):
      ibmvnic: fix login buffer memory leak
      ibmvnic: continue fatal error reset after passive init

Lorenzo Bianconi (4):
      mt76: mt76u: fix NULL pointer dereference in mt76u_status_worker
      mt76: usb: remove wake logic in mt76u_status_worker
      mt76: sdio: remove wake logic in mt76s_process_tx_queue
      mt76: mt76s: fix NULL pointer dereference in mt76s_process_tx_queue

Léo Le Bouter (1):
      atlantic: remove architecture depends

Magnus Karlsson (3):
      xsk: Fix memory leak for failed bind
      xsk: Fix race in SKB mode transmit with shared cq
      xsk: Rollback reservation at NETDEV_TX_BUSY

Manish Chopra (1):
      qede: fix offload for IPIP tunnel packets

Mario Limonciello (4):
      e1000e: Only run S0ix flows if shutdown succeeded
      e1000e: bump up timeout to wait when ME un-configures ULP mode
      Revert "e1000e: disable s0ix entry and exit flows for ME systems"
      e1000e: Export S0ix flags to ethtool

Martin Blumenstingl (3):
      net: stmmac: dwmac-meson8b: ignore the second clock input
      net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs
      net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register access

Michael Chan (1):
      bnxt_en: Check TQM rings for maximum supported value.

Noor Azura Ahmad Tarmizi (1):
      stmmac: intel: Add PCI IDs for TGL-H platform

Pablo Neira Ayuso (2):
      netfilter: nft_dynset: report EOPNOTSUPP on missing set feature
      netfilter: nftables: add set expression flags

Petr Machata (1):
      net: dcb: Validate netlink message in DCB handler

Ping-Ke Shih (1):
      rtlwifi: rise completion at the last step of firmware callback

Randy Dunlap (2):
      mt76: mt7915: fix MESH ifdef block
      net: sched: prevent invalid Scell_log shift count

Rasmus Villemoes (3):
      ethernet: ucc_geth: set dev->max_mtu to 1518
      ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
      ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()

Roland Dreier (1):
      CDC-NCM: remove "connected" log message

Shannon Nelson (1):
      ionic: account for vlan tag len in rx buffer len

Stefan Chulski (5):
      net: mvpp2: disable force link UP during port init procedure
      net: mvpp2: Add TCAM entry to drop flow control pause frames
      net: mvpp2: prs: fix PPPoE with ipv6 packet parse
      net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
      net: mvpp2: fix pkt coalescing int-threshold configuration

Subash Abhinov Kasiviswanathan (1):
      netfilter: x_tables: Update remaining dereference to RCU

Sylwester Dziedziuch (1):
      i40e: Fix Error I40E_AQ_RC_EINVAL when removing VFs

Taehee Yoo (2):
      bareudp: set NETIF_F_LLTX flag
      bareudp: Fix use of incorrect min_headroom size

Tian Tao (1):
      bpf: Remove unused including <linux/version.h>

Vasily Averin (2):
      netfilter: ipset: fixes possible oops in mtype_resize
      netfilter: ipset: fix shift-out-of-bounds in htable_bits()

Vasundhara Volam (1):
      bnxt_en: Fix AER recovery.

Xie He (2):
      net: hdlc_ppp: Fix issues when mod_timer is called while timer is running
      net: lapb: Decrease the refcount of "struct lapb_cb" in lapb_device_event

YANG LI (1):
      ibmvnic: fix: NULL pointer dereference.

Yunjian Wang (3):
      tun: fix return value when the number of iovs exceeds MAX_SKB_FRAGS
      net: hns: fix return value check in __lb_other_process()
      vhost_net: fix ubuf refcount incorrectly when sendmsg fails

weichenchen (1):
      net: neighbor: fix a crash caused by mod zero

 Documentation/networking/netdev-FAQ.rst            | 126 ++++++++++----------
 Documentation/networking/packet_mmap.rst           |  11 +-
 MAINTAINERS                                        |  26 ++---
 drivers/atm/idt77252.c                             |   2 +-
 drivers/net/bareudp.c                              |   3 +-
 drivers/net/dsa/lantiq_gswip.c                     |  27 ++---
 drivers/net/ethernet/aquantia/Kconfig              |   1 -
 drivers/net/ethernet/broadcom/bcmsysport.c         |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  38 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   7 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/ethoc.c                       |   3 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |   3 +-
 drivers/net/ethernet/freescale/ucc_geth.h          |   9 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   4 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  10 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  46 ++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  17 ++-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  59 ++--------
 drivers/net/ethernet/intel/i40e/i40e.h             |   3 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  10 ++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   4 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  27 +++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  38 +++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h     |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   5 +
 drivers/net/ethernet/realtek/r8169_main.c          |   6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 +
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   2 +-
 drivers/net/ethernet/ti/cpts.c                     |   2 +
 drivers/net/ipa/gsi.c                              | 127 +++++++++++----------
 drivers/net/ipa/ipa_clock.c                        |   4 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/cdc_ncm.c                          |   3 -
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |  12 +-
 drivers/net/wan/hdlc_ppp.c                         |   7 ++
 drivers/net/wireless/ath/ath11k/core.c             |   2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  10 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   8 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  44 ++++++-
 drivers/net/wireless/ath/ath11k/pci.h              |   2 +
 drivers/net/wireless/ath/ath11k/peer.c             |  17 +++
 drivers/net/wireless/ath/ath11k/peer.h             |   2 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  24 +++-
 drivers/net/wireless/ath/ath11k/qmi.h              |   1 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   3 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |  19 ++-
 drivers/net/wireless/mediatek/mt76/usb.c           |   9 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   8 +-
 drivers/vhost/net.c                                |   6 +-
 include/net/red.h                                  |   4 +-
 include/net/xdp_sock.h                             |   4 -
 include/net/xsk_buff_pool.h                        |   5 +
 include/uapi/linux/netfilter/nf_tables.h           |   3 +
 include/uapi/linux/ppp-ioctl.h                     |   2 +-
 kernel/bpf/hashtab.c                               |   1 +
 kernel/bpf/syscall.c                               |   1 -
 kernel/bpf/task_iter.c                             |  18 +--
 net/core/neighbour.c                               |   6 +-
 net/core/net-sysfs.c                               |  65 +++++++++--
 net/dcb/dcbnl.c                                    |   2 +
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/gre_demux.c                               |   2 +-
 net/ipv4/netfilter/arp_tables.c                    |   2 +-
 net/ipv4/netfilter/ip_tables.c                     |   2 +-
 net/ipv6/netfilter/ip6_tables.c                    |   2 +-
 net/lapb/lapb_iface.c                              |   1 +
 net/mptcp/protocol.c                               |   5 +-
 net/ncsi/ncsi-rsp.c                                |   2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  42 +++----
 net/netfilter/nf_tables_api.c                      |  10 +-
 net/netfilter/nft_dynset.c                         |  15 ++-
 net/netfilter/xt_RATEEST.c                         |   3 +
 net/packet/af_packet.c                             |   4 +-
 net/sched/sch_choke.c                              |   2 +-
 net/sched/sch_gred.c                               |   2 +-
 net/sched/sch_red.c                                |   2 +-
 net/sched/sch_sfq.c                                |   2 +-
 net/sched/sch_taprio.c                             |   7 +-
 net/xdp/xsk.c                                      |  16 ++-
 net/xdp/xsk_buff_pool.c                            |   3 +-
 net/xdp/xsk_queue.h                                |   5 +
 tools/testing/selftests/bpf/Makefile               |   3 +
 tools/testing/selftests/bpf/test_maps.c            |  48 +++++++-
 tools/testing/selftests/bpf/xdpxceiver.c           |   4 +-
 .../testing/selftests/drivers/net/mlxsw/qos_pfc.sh |   2 +-
 92 files changed, 710 insertions(+), 411 deletions(-)
