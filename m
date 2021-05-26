Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD233922D5
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 00:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhEZWh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 18:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232411AbhEZWh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 18:37:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE72613CA;
        Wed, 26 May 2021 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622068554;
        bh=Vb5U4RwJ+Msa/itCE46n78elvgIAhdweMTDZDvI6R9M=;
        h=From:To:Cc:Subject:Date:From;
        b=BOnay4J9rr0mqQ7jp6TiaJcJ9UycvJUk22twLUCRNLm04SQqGNnj/N94EVxVss6Sz
         MHSmdvTADFNqB4YLY3uTtXzgdI7lj4LJIIADV9waBM7a30YxTMK9DL8Lyz0b+YDTz4
         tVQzhU3bYSMYbhjvsa+hsa6eIt3+JYbrieKVlp68jKagJeBdx1qfTdnmtwdCkF/4+P
         66mJxeAZFE8lQxWWfJz+7y1Mx36XXPoiNi61RE6VHrtI6X5etl9Z4Jkf5CdIadAQqG
         dBY8yLF7jIsstFNm49iligimeSfhc7lvtTkh5Xy7V62vxfGvSdiF4bOrC+Am+WovgV
         NDR/rfK3N1MOQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.13-rc4
Date:   Wed, 26 May 2021 15:35:53 -0700
Message-Id: <20210526223553.306028-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit b741596468b010af2846b75f5e75a842ce344a6e:

  Merge tag 'riscv-for-linus-5.13-mw1' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux (2021-05-08 11:52:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc4

for you to fetch changes up to 62f3415db237b8d2aa9a804ff84ce2efa87df179:

  net: phy: Document phydev::dev_flags bits allocation (2021-05-26 13:15:55 -0700)

----------------------------------------------------------------
Networking fixes for 5.13-rc4, including fixes from bpf, netfilter,
can and wireless trees. Notably including fixes for the recently
announced "FragAttacks" WiFi vulnerabilities. Rather large batch,
touching some core parts of the stack, too, but nothing hair-raising.

Current release - regressions:

 - tipc: make node link identity publish thread safe

 - dsa: felix: re-enable TAS guard band mode

 - stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()

 - stmmac: fix system hang if change mac address after interface ifdown

Current release - new code bugs:

 - mptcp: avoid OOB access in setsockopt()

 - bpf: Fix nested bpf_bprintf_prepare with more per-cpu buffers

 - ethtool: stats: fix a copy-paste error - init correct array size

Previous releases - regressions:

 - sched: fix packet stuck problem for lockless qdisc

 - net: really orphan skbs tied to closing sk

 - mlx4: fix EEPROM dump support

 - bpf: fix alu32 const subreg bound tracking on bitwise operations

 - bpf: fix mask direction swap upon off reg sign change

 - bpf, offload: reorder offload callback 'prepare' in verifier

 - stmmac: Fix MAC WoL not working if PHY does not support WoL

 - packetmmap: fix only tx timestamp on request

 - tipc: skb_linearize the head skb when reassembling msgs

Previous releases - always broken:

 - mac80211: address recent "FragAttacks" vulnerabilities

 - mac80211: do not accept/forward invalid EAPOL frames

 - mptcp: avoid potential error message floods

 - bpf, ringbuf: deny reserve of buffers larger than ringbuf to prevent
                 out of buffer writes

 - bpf: forbid trampoline attach for functions with variable arguments

 - bpf: add deny list of functions to prevent inf recursion of tracing
        programs

 - tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT

 - can: isotp: prevent race between isotp_bind() and isotp_setsockopt()

 - netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check,
              fallback to non-AVX2 version

Misc:

 - bpf: add kconfig knob for disabling unpriv bpf by default

----------------------------------------------------------------
Aditya Srivastava (2):
      net: encx24j600: fix kernel-doc syntax in file headers
      NFC: nfcmrvl: fix kernel-doc syntax in file headers

Aleksander Jan Bajkowski (1):
      net: lantiq: fix memory corruption in RX ring

Alex Elder (1):
      net: ipa: memory region array is variable size

Andrii Nakryiko (2):
      bpf: Prevent writable memory-mapping of read-only ringbuf pages
      selftests/bpf: Test ringbuf mmap read-only and read-write restrictions

Andy Gospodarek (1):
      bnxt_en: Include new P5 HV definition in VF check.

Ariel Levkovich (1):
      net/mlx5: Set term table as an unmanaged flow table

Arnaldo Carvalho de Melo (1):
      libbpf: Provide GELF_ST_VISIBILITY() define for older libelf

Aya Levin (1):
      net/mlx5e: Fix error path of updating netdev queues

Ayush Sawal (1):
      cxgb4/ch_ktls: Clear resources when pf4 device is removed

Catherine Sullivan (2):
      gve: Check TX QPL was actually assigned
      gve: Upgrade memory barrier in poll routine

Christophe JAILLET (4):
      net: netcp: Fix an error message
      ptp: ocp: Fix a resource leak in an error handling path
      net: mdio: thunder: Fix a double free issue in the .remove function
      net: mdio: octeon: Fix some double free issues

DENG Qingfang (1):
      net: dsa: mt7530: fix VLAN traffic leaks

Dan Carpenter (5):
      net: dsa: fix a crash if ->get_sset_count() fails
      octeontx2-pf: fix a buffer overflow in otx2_set_rxfh_context()
      chelsio/chtls: unlock on error in chtls_pt_recvmsg()
      net: hso: check for allocation failure in hso_create_bulk_serial_device()
      net: mdiobus: get rid of a BUG_ON()

Daniel Borkmann (9):
      bpf: Fix alu32 const subreg bound tracking on bitwise operations
      bpf, kconfig: Add consolidated menu entry for bpf with core options
      bpf: Add kconfig knob for disabling unpriv bpf by default
      bpf: Fix BPF_JIT kconfig symbol dependency
      bpf: Fix BPF_LSM kconfig symbol dependency
      bpf: Wrap aux data inside bpf_sanitize_info container
      bpf: Fix mask direction swap upon off reg sign change
      bpf: No need to simulate speculative domain for immediates
      bpf, selftests: Adjust few selftest result_unpriv outcomes

David Awogbemila (3):
      gve: Update mgmt_msix_idx if num_ntfy changes
      gve: Add NULL pointer checks when freeing irqs.
      gve: Correct SKB queue index validation.

David Matlack (1):
      selftests: Add .gitignore for nci test suite

David S. Miller (15):
      Merge tag 'mac80211-for-net-2021-05-11' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'fec-fixes'
      Merge tag 'linux-can-fixes-for-5.13-20210512' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'lockless-qdisc-packet-stuck'
      Merge branch 'bnxt_en-fixes'
      Merge branch 'gve-fixes'
      Merge branch 'hns3-fixes'
      Merge tag 'mlx5-fixes-2021-05-18' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'stmmac-fixes'
      Merge branch 'fq_pie-fixes'
      Merge branch 'sja1105-fixes'
      Merge branch 'mptcp-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Davide Caratti (3):
      net/sched: fq_pie: re-factor fix for fq_pie endless loop
      net/sched: fq_pie: fix OOB access in the traffic path
      mptcp: validate 'id' when stopping the ADD_ADDR retransmit timer

Dima Chumak (3):
      net/mlx5e: Fix nullptr in add_vlan_push_action()
      net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()
      net/mlx5e: Fix multipath lag activation

Dongliang Mu (1):
      NFC: nci: fix memory leak in nci_allocate_device

Eli Cohen (1):
      {net,vdpa}/mlx5: Configure interface MAC into mpfs L2 table

Florent Revest (3):
      bpf: Fix nested bpf_bprintf_prepare with more per-cpu buffers
      bpf: Clarify a bpf_bprintf_prepare macro
      bpf: Avoid using ARRAY_SIZE on an uninitialized pointer

Florian Fainelli (2):
      net: dsa: bcm_sf2: Fix bcm_sf2_reg_rgmii_cntrl() call for non-RGMII port
      net: phy: Document phydev::dev_flags bits allocation

Francesco Ruggeri (1):
      ipv6: record frag_max_size in atomic fragments in input path

Fugang Duan (2):
      net: fec: fix the potential memory leak in fec_enet_init()
      net: fec: add defer probe for of_get_mac_address

Geert Uytterhoeven (1):
      dt-bindings: net: renesas,ether: Update Sergei's email address

George McCollister (2):
      net: hsr: fix mac_len checks
      net: dsa: microchip: enable phy errata workaround on 9567

Hayes Wang (1):
      r8152: check the informaton of the device

Hoang Le (2):
      tipc: make node link identity publish thread safe
      Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

Huazhong Tan (1):
      net: hns3: fix user's coalesce configuration lost issue

Ian Rogers (1):
      libbpf: Add NULL check to add_dummy_ksym_var

Ioana Ciornei (1):
      MAINTAINERS: remove Ioana Radulescu from dpaa2-eth

Jakub Kicinski (1):
      mlx5e: add add missing BH locking around napi_schdule()

Jeimon (1):
      net/nfc/rawsock.c: fix a permission check bug

Jesse Brandeburg (1):
      ixgbe: fix large MTU request from VF

Jian Shen (1):
      net: hns3: put off calling register_netdev() until client initialize complete

Jianbo Liu (1):
      net/mlx5: Set reformat action when needed for termination rules

Jiapeng Chong (1):
      bnx2x: Fix missing error code in bnx2x_iov_init_one()

Jiaran Zhang (1):
      net: hns3: fix incorrect resp_msg issue

Jim Ma (1):
      tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT

Jiri Olsa (2):
      bpf: Forbid trampoline attach for functions with variable arguments
      bpf: Add deny list of btf ids check for tracing programs

Joakim Zhang (3):
      net: stmmac: Fix MAC WoL not working if PHY does not support WoL
      net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()
      net: stmmac: fix system hang if change mac address after interface ifdown

Johan Hovold (2):
      net: hso: bail out on interrupt URB allocation failure
      net: hso: fix control-request directions

Johannes Berg (7):
      mac80211: drop A-MSDUs on old ciphers
      mac80211: add fragment cache to sta_info
      mac80211: check defrag PN against current frame
      mac80211: prevent attacks on TKIP/WEP as well
      mac80211: do not accept/forward invalid EAPOL frames
      bonding: init notify_work earlier to avoid uninitialized use
      netlink: disable IRQs for netlink_lock_table()

Jonathan Davies (1):
      net: cdc_eem: fix URL to CDC EEM 1.0 spec

Julian Wiedmann (2):
      net/smc: remove device from smcd_dev_list after failed device_add()
      MAINTAINERS: s390/net: add netdev list

Jussi Maki (3):
      selftests/bpf: Rewrite test_tc_redirect.sh as prog_tests/tc_redirect.c
      bpf: Set mac_len in bpf_skb_change_head
      selftests/bpf: Add test for l3 use of bpf_redirect_peer

Krzysztof Kozlowski (4):
      MAINTAINERS: nfc: drop Clément Perrochaud from NXP-NCI
      MAINTAINERS: nfc: add Krzysztof Kozlowski as maintainer
      MAINTAINERS: nfc: include linux-nfc mailing list
      MAINTAINERS: net: remove stale website link

Leon Romanovsky (1):
      net/mlx5: Don't overwrite HCA capabilities when setting MSI-X count

Liu Jian (1):
      bpftool: Add sock_release help info for cgroup attach/prog load command

Magnus Karlsson (1):
      samples/bpf: Consider frame size in tx_only of xdpsock sample

Maor Gottlieb (1):
      {net, RDMA}/mlx5: Fix override of log_max_qp by other device

Markus Bloechl (1):
      net: lan78xx: advertise tx software timestamping support

Martin KaFai Lau (1):
      bpf: Limit static tcp-cc functions in the .BTF_ids list to x86

Mathy Vanhoef (4):
      mac80211: assure all fragments are encrypted
      mac80211: prevent mixed key and fragment cache attacks
      mac80211: properly handle A-MSDUs that start with an RFC 1042 header
      cfg80211: mitigate A-MSDU aggregation attacks

Michael Chan (2):
      bnxt_en: Fix and improve .ndo_features_check().
      bnxt_en: Fix context memory setup for 64K page size.

Michael Walle (1):
      net: dsa: felix: re-enable TAS guard band mode

Norbert Slusarek (1):
      can: isotp: prevent race between isotp_bind() and isotp_setsockopt()

Paolo Abeni (5):
      mptcp: fix data stream corruption
      net: really orphan skbs tied to closing sk
      mptcp: avoid OOB access in setsockopt()
      mptcp: drop unconditional pr_warn on bad opt
      mptcp: avoid error message on infinite mapping

Parav Pandit (1):
      net/mlx5: SF, Fix show state inactive when its inactivated

Pavel Skripkin (1):
      net: usb: fix memory leak in smsc75xx_bind

Raju Rangoju (1):
      cxgb4: avoid accessing registers when clearing filters

Rao Shoaib (1):
      RDS tcp loopback connection can hang

Richard Sanger (1):
      net: packetmmap: fix only tx timestamp on request

Roi Dayan (4):
      netfilter: flowtable: Remove redundant hw refresh bit
      net/mlx5: Fix err prints and return when creating termination table
      net/mlx5e: Fix null deref accessing lag dev
      net/mlx5e: Make sure fib dev exists in fib event

Saeed Mahameed (1):
      net/mlx5e: reset XPS on error flow if netdev isn't registered yet

Saubhik Mukherjee (1):
      net: appletalk: cops: Fix data race in cops_probe1

Shannon Nelson (1):
      ionic: fix ptp support config breakage

Simon Horman (1):
      nfp: update maintainer and mailing list addresses

Sriram R (3):
      ath10k: Validate first subframe of A-MSDU before processing the list
      ath11k: Clear the fragment cache during key install
      ath11k: Drop multicast fragments

Stanislav Fomichev (1):
      selftests/bpf: Convert static to global in tc_redirect progs

Stefan Chulski (1):
      net: mvpp2: add buffer header handling in RX

Stefan Roese (2):
      net: ethernet: mtk_eth_soc: Fix DIM support for MT7628/88
      net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88

Stefano Brivio (1):
      netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version

Taehee Yoo (2):
      mld: fix panic in mld_newpack()
      sch_dsmark: fix a NULL deref in qdisc_reset()

Tao Liu (1):
      openvswitch: meter: fix race when getting now_ms.

Thadeu Lima de Souza Cascardo (1):
      bpf, ringbuf: Deny reserve of buffers larger than ringbuf

Vinicius Costa Gomes (1):
      MAINTAINERS: Add entries for CBS, ETF and taprio qdiscs

Vlad Buslov (2):
      net/mlx5e: Reject mirroring on source port change encap rules
      net: zero-initialize tc skb extension on allocation

Vladimir Oltean (7):
      net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count
      net: dsa: sja1105: fix VL lookup command packing for P/Q/R/S
      net: dsa: sja1105: call dsa_unregister_switch when allocating memory fails
      net: dsa: sja1105: add error handling in sja1105_setup()
      net: dsa: sja1105: error out on unsupported PHY mode
      net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
      net: dsa: sja1105: update existing VLANs from the bridge VLAN list

Vladyslav Tarasiuk (1):
      net/mlx4: Fix EEPROM dump support

Wei Yongjun (1):
      net: korina: Fix return value check in korina_probe()

Wen Gong (6):
      mac80211: extend protection against mixed key and fragment cache attacks
      ath10k: add CCMP PN replay protection for fragmented frames for PCIe
      ath10k: drop fragments with multicast DA for PCIe
      ath10k: drop fragments with multicast DA for SDIO
      ath10k: drop MPDU which has discard flag set by firmware for SDIO
      ath10k: Fix TKIP Michael MIC verification for PCIe

Xin Long (5):
      tipc: skb_linearize the head skb when reassembling msgs
      tipc: wait and exit until all work queues are done
      tipc: simplify the finalize work queue
      sctp: add the missing setting for asoc encap_port
      sctp: fix the proc_handler for sysctl encap_port

Yang Li (1):
      net: hns: Fix kernel-doc

Yinjun Zhang (1):
      bpf, offload: Reorder offload callback 'prepare' in verifier

YueHaibing (1):
      ethtool: stats: Fix a copy-paste error

Yunsheng Lin (4):
      net: sched: fix packet stuck problem for lockless qdisc
      net: sched: fix tx action rescheduling issue during deactivation
      net: sched: fix tx action reschedule issue with stopped queue
      net: hns3: check the return of skb_checksum_help()

Zhen Lei (1):
      net: bnx2: Fix error return code in bnx2_init_board()

Zheyu Ma (2):
      isdn: mISDN: netjet: Fix crash in nj_probe:
      net/qla3xxx: fix schedule while atomic in ql_sem_spinlock

Zong Li (1):
      net: macb: ensure the device is available before accessing GEMGXL control registers

Íñigo Huguet (1):
      net:sfc: fix non-freed irq in legacy irq mode

 Documentation/admin-guide/sysctl/kernel.rst        |  17 +-
 .../devicetree/bindings/net/renesas,ether.yaml     |   2 +-
 MAINTAINERS                                        |  22 +-
 arch/arm64/Kbuild                                  |   3 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   4 +-
 drivers/isdn/hardware/mISDN/netjet.c               |   1 -
 drivers/net/appletalk/cops.c                       |   4 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/dsa/bcm_sf2.c                          |   5 +-
 drivers/net/dsa/microchip/ksz9477.c                |   1 +
 drivers/net/dsa/mt7530.c                           |   8 -
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  15 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |  23 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  74 +-
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 138 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  10 +
 drivers/net/ethernet/cadence/macb_main.c           |   3 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |  80 ++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h      |   2 +
 .../chelsio/inline_crypto/chtls/chtls_io.c         |   6 +-
 drivers/net/ethernet/freescale/fec_main.c          |  24 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  21 +-
 drivers/net/ethernet/google/gve/gve_tx.c           |  10 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 110 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  64 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  16 +-
 drivers/net/ethernet/korina.c                      |  12 +-
 drivers/net/ethernet/lantiq_xrx200.c               |  14 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |  22 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  54 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   4 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  77 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  24 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          | 107 ++-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  28 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  61 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  22 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |  18 +-
 drivers/net/ethernet/microchip/encx24j600.c        |   2 +-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |   2 +-
 drivers/net/ethernet/pensando/Kconfig              |   1 +
 drivers/net/ethernet/qlogic/qla3xxx.c              |   2 +-
 drivers/net/ethernet/sfc/nic.c                     |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  32 +-
 drivers/net/ethernet/ti/netcp_core.c               |   4 +-
 drivers/net/ipa/ipa.h                              |   2 +
 drivers/net/ipa/ipa_mem.c                          |   3 +-
 drivers/net/mdio/mdio-octeon.c                     |   2 -
 drivers/net/mdio/mdio-thunder.c                    |   1 -
 drivers/net/phy/mdio_bus.c                         |   3 +-
 drivers/net/usb/cdc_eem.c                          |   2 +-
 drivers/net/usb/hso.c                              |  45 +-
 drivers/net/usb/lan78xx.c                          |   1 +
 drivers/net/usb/r8152.c                            |  42 +-
 drivers/net/usb/smsc75xx.c                         |   8 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 201 +++++-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |  14 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  34 +
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   6 +
 drivers/nfc/nfcmrvl/fw_dnld.h                      |   2 +-
 drivers/nfc/nfcmrvl/i2c.c                          |   2 +-
 drivers/nfc/nfcmrvl/nfcmrvl.h                      |   2 +-
 drivers/nfc/nfcmrvl/spi.c                          |   2 +-
 drivers/nfc/nfcmrvl/uart.c                         |   2 +-
 drivers/nfc/nfcmrvl/usb.c                          |   2 +-
 drivers/ptp/ptp_ocp.c                              |   4 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  19 +-
 include/linux/mlx5/driver.h                        |  44 +-
 include/linux/mlx5/mpfs.h                          |  18 +
 include/linux/phy.h                                |   5 +
 include/net/cfg80211.h                             |   4 +-
 include/net/netfilter/nf_flow_table.h              |   1 -
 include/net/nfc/nci_core.h                         |   1 +
 include/net/pkt_cls.h                              |  11 +
 include/net/pkt_sched.h                            |   7 +-
 include/net/sch_generic.h                          |  35 +-
 include/net/sock.h                                 |   4 +-
 init/Kconfig                                       |  41 +-
 kernel/bpf/Kconfig                                 |  89 +++
 kernel/bpf/bpf_lsm.c                               |   2 +
 kernel/bpf/btf.c                                   |  12 +
 kernel/bpf/helpers.c                               |  35 +-
 kernel/bpf/ringbuf.c                               |  24 +-
 kernel/bpf/syscall.c                               |   3 +-
 kernel/bpf/verifier.c                              |  94 ++-
 kernel/sysctl.c                                    |  29 +-
 net/Kconfig                                        |  27 -
 net/can/isotp.c                                    |  49 +-
 net/core/dev.c                                     |  29 +-
 net/core/filter.c                                  |   1 +
 net/core/sock.c                                    |   8 +-
 net/dsa/master.c                                   |   5 +-
 net/dsa/slave.c                                    |  12 +-
 net/ethtool/stats.c                                |   2 +-
 net/hsr/hsr_device.c                               |   2 +
 net/hsr/hsr_forward.c                              |  30 +-
 net/hsr/hsr_forward.h                              |   8 +-
 net/hsr/hsr_main.h                                 |   4 +-
 net/hsr/hsr_slave.c                                |  11 +-
 net/ipv4/bpf_tcp_ca.c                              |   2 +
 net/ipv6/mcast.c                                   |   3 -
 net/ipv6/reassembly.c                              |   4 +-
 net/mac80211/ieee80211_i.h                         |  36 +-
 net/mac80211/iface.c                               |  11 +-
 net/mac80211/key.c                                 |   7 +
 net/mac80211/key.h                                 |   2 +
 net/mac80211/rx.c                                  | 150 +++-
 net/mac80211/sta_info.c                            |   6 +-
 net/mac80211/sta_info.h                            |  33 +-
 net/mac80211/wpa.c                                 |  13 +-
 net/mptcp/options.c                                |   3 +-
 net/mptcp/pm_netlink.c                             |   8 +-
 net/mptcp/protocol.c                               |  20 +-
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/sockopt.c                                |   4 +-
 net/mptcp/subflow.c                                |   1 -
 net/netfilter/nf_flow_table_core.c                 |   3 +-
 net/netfilter/nf_flow_table_offload.c              |   7 +-
 net/netfilter/nft_set_pipapo.c                     |   4 +-
 net/netfilter/nft_set_pipapo.h                     |   2 +
 net/netfilter/nft_set_pipapo_avx2.c                |   3 +
 net/netlink/af_netlink.c                           |   6 +-
 net/nfc/nci/core.c                                 |   1 +
 net/nfc/nci/hci.c                                  |   5 +
 net/nfc/rawsock.c                                  |   2 +-
 net/openvswitch/meter.c                            |   8 +
 net/packet/af_packet.c                             |  10 +-
 net/rds/connection.c                               |  23 +-
 net/rds/tcp.c                                      |   4 +-
 net/rds/tcp.h                                      |   3 +-
 net/rds/tcp_listen.c                               |   6 +
 net/sched/cls_api.c                                |   2 +-
 net/sched/sch_dsmark.c                             |   3 +-
 net/sched/sch_fq_pie.c                             |  19 +-
 net/sched/sch_generic.c                            |  50 +-
 net/sctp/socket.c                                  |   1 +
 net/sctp/sysctl.c                                  |   2 +-
 net/smc/smc_ism.c                                  |  11 +-
 net/tipc/core.c                                    |   6 +-
 net/tipc/core.h                                    |  10 +-
 net/tipc/discover.c                                |   4 +-
 net/tipc/link.c                                    |   5 +
 net/tipc/link.h                                    |   1 +
 net/tipc/msg.c                                     |   9 +-
 net/tipc/net.c                                     |  15 +-
 net/tipc/node.c                                    |  12 +-
 net/tipc/socket.c                                  |   5 +-
 net/tipc/udp_media.c                               |   2 +
 net/tls/tls_sw.c                                   |  11 +-
 net/wireless/util.c                                |   7 +-
 samples/bpf/xdpsock_user.c                         |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   4 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   6 +-
 tools/bpf/bpftool/cgroup.c                         |   3 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/lib/bpf/libbpf.c                             |   3 +
 tools/lib/bpf/libbpf_internal.h                    |   5 +
 tools/testing/selftests/bpf/network_helpers.c      |   2 +-
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |  49 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c | 785 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |  33 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c        |   9 +-
 tools/testing/selftests/bpf/progs/test_tc_peer.c   |  56 +-
 tools/testing/selftests/bpf/test_tc_redirect.sh    | 216 ------
 tools/testing/selftests/bpf/verifier/stack_ptr.c   |   2 -
 .../selftests/bpf/verifier/value_ptr_arith.c       |   8 -
 tools/testing/selftests/nci/.gitignore             |   1 +
 .../tc-testing/tc-tests/qdiscs/fq_pie.json         |   8 +-
 189 files changed, 2944 insertions(+), 1094 deletions(-)
 create mode 100644 include/linux/mlx5/mpfs.h
 create mode 100644 kernel/bpf/Kconfig
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_redirect.c
 delete mode 100755 tools/testing/selftests/bpf/test_tc_redirect.sh
 create mode 100644 tools/testing/selftests/nci/.gitignore
