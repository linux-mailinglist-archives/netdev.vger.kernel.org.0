Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F9365F546
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 21:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbjAEUhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 15:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjAEUhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 15:37:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF3361466;
        Thu,  5 Jan 2023 12:37:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67FD561C3A;
        Thu,  5 Jan 2023 20:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A757C433EF;
        Thu,  5 Jan 2023 20:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672951063;
        bh=CAS2HNo/tt/e+zQlEl8zeMGm9hRhzEsUZvAS6fr6aTs=;
        h=From:To:Cc:Subject:Date:From;
        b=BrstZ+FIukI0Sb95lk1O9e2lZJS/7fxGRoREnjIkRnXVjuNUxBekDhJJtnXZt2Do+
         rbzXHb0jnjAadCofEzIOEaI7FgniK3hGuk/GyMvOnl0w8C5Rq45QL8rJjP0i1XdMyU
         qQg2+F86235uYifWV64F4i2Cu0DK0hUbtDfY8wo8i3GP0NWpT0uKam+z0lxWOhLAgT
         KfhuWyL9tFUrvEjPysB8qemN+exAEPTOVKbxj7hxPvlkeWrObZWNYm+nTL6IhidzyA
         f0G/Px2Wy099wSNy4MpOT75Opi5raZ7PVOjg3NkxuhhW6+qo4j0cvIvUmquezbexNk
         g5NuHrZVsXvvg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.2-rc3
Date:   Thu,  5 Jan 2023 12:37:42 -0800
Message-Id: <20230105203742.3650621-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
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

The first post-xmas PR, a bit larger than I anticipated,
if I'm completely honest.

I counted 3 fixes here which you were CCed on. There are two
more outstanding issues - one pending Kalle's return, and one
in qdiscs.


The following changes since commit 609d3bc6230514a8ca79b377775b17e8c3d9ac93:

  Merge tag 'net-6.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-12-21 08:41:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc3

for you to fetch changes up to fe69230f05897b3de758427b574fc98025dfc907:

  caif: fix memory leak in cfctrl_linkup_request() (2023-01-05 10:19:36 +0100)

----------------------------------------------------------------
Including fixes from bpf, wifi, and netfilter.

Current release - regressions:

 - bpf: fix nullness propagation for reg to reg comparisons,
   avoid null-deref

 - inet: control sockets should not use current thread task_frag

 - bpf: always use maximal size for copy_array()

 - eth: bnxt_en: don't link netdev to a devlink port for VFs

Current release - new code bugs:

 - rxrpc: fix a couple of potential use-after-frees

 - netfilter: conntrack: fix IPv6 exthdr error check

 - wifi: iwlwifi: fw: skip PPAG for JF, avoid FW crashes

 - eth: dsa: qca8k: various fixes for the in-band register access

 - eth: nfp: fix schedule in atomic context when sync mc address

 - eth: renesas: rswitch: fix getting mac address from device tree

 - mobile: ipa: use proper endpoint mask for suspend

Previous releases - regressions:

 - tcp: add TIME_WAIT sockets in bhash2, fix regression caught
   by Jiri / python tests

 - net: tc: don't intepret cls results when asked to drop, fix
   oob-access

 - vrf: determine the dst using the original ifindex for multicast

 - eth: bnxt_en:
   - fix XDP RX path if BPF adjusted packet length
   - fix HDS (header placement) and jumbo thresholds for RX packets

 - eth: ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf,
   avoid memory corruptions

Previous releases - always broken:

 - ulp: prevent ULP without clone op from entering the LISTEN status

 - veth: fix race with AF_XDP exposing old or uninitialized descriptors

 - bpf:
   - pull before calling skb_postpull_rcsum() (fix checksum support
     and avoid a WARN())
   - fix panic due to wrong pageattr of im->image (when livepatch
     and kretfunc coexist)
   - keep a reference to the mm, in case the task is dead

 - mptcp: fix deadlock in fastopen error path

 - netfilter:
   - nf_tables: perform type checking for existing sets
   - nf_tables: honor set timeout and garbage collection updates
   - ipset: fix hash:net,port,net hang with /0 subnet
   - ipset: avoid hung task warning when adding/deleting entries

 - selftests: net:
   - fix cmsg_so_mark.sh test hang on non-x86 systems
   - fix the arp_ndisc_evict_nocarrier test for IPv6

 - usb: rndis_host: secure rndis_query check against int overflow

 - eth: r8169: fix dmar pte write access during suspend/resume with WOL

 - eth: lan966x: fix configuration of the PCS

 - eth: sparx5: fix reading of the MAC address

 - eth: qed: allow sleep in qed_mcp_trace_dump()

 - eth: hns3:
   - fix interrupts re-initialization after VF FLR
   - fix handling of promisc when MAC addr table gets full
   - refine the handling for VF heartbeat

 - eth: mlx5:
   - properly handle ingress QinQ-tagged packets on VST
   - fix io_eq_size and event_eq_size params validation on big endian
   - fix RoCE setting at HCA level if not supported at all
   - don't turn CQE compression on by default for IPoIB

 - eth: ena:
   - fix toeplitz initial hash key value
   - account for the number of XDP-processed bytes in interface stats
   - fix rx_copybreak value update

Misc:

 - ethtool: harden phy stat handling against buggy drivers

 - docs: netdev: convert maintainer's doc from FAQ to a normal document

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Conole (1):
      net: openvswitch: release vport resources on failure

Adham Faris (1):
      net/mlx5e: Fix hw mtu initializing at XDP SQ allocation

Alex Elder (1):
      net: ipa: use proper endpoint mask for suspend

Alexei Starovoitov (2):
      selftests/bpf: Temporarily disable part of btf_dump:var_data test.
      Merge branch 'bpf: fix the crash caused by task iterators over vma'

Antoine Tenart (1):
      net: vrf: determine the dst using the original ifindex for multicast

Anton Protopopov (1):
      bpftool: Fix linkage with statically built libllvm

Anuradha Weeraman (1):
      net: ethernet: marvell: octeontx2: Fix uninitialized variable warning

Arnd Bergmann (2):
      wifi: mt76: mt7996: select CONFIG_RELAY
      wifi: ath9k: use proper statements in conditionals

Caleb Sander (1):
      qed: allow sleep in qed_mcp_trace_dump()

Chris Mi (2):
      net/mlx5e: CT: Fix ct debugfs folder name
      net/mlx5e: Always clear dest encap in neigh-update-del

Christian Marangi (5):
      net: dsa: qca8k: fix wrong length value for mgmt eth packet
      net: dsa: tag_qca: fix wrong MGMT_DATA2 size
      Revert "net: dsa: qca8k: cache lo and hi for mdio write"
      net: dsa: qca8k: introduce single mii read/write lo/hi
      net: dsa: qca8k: improve mdio master read/write by using single lo/hi

Chuang Wang (1):
      bpf: Fix panic due to wrong pageattr of im->image

Chunhao Lin (2):
      r8169: move rtl_wol_enable_rx() and rtl_prepare_power_down()
      r8169: fix dmar pte write access is not set error

Daniil Tatianin (5):
      qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure
      net/ethtool/ioctl: return -EOPNOTSUPP if we have no phy stats
      net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats
      net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers
      drivers/net/bonding/bond_3ad: return when there's no aggregator

David Arinzon (7):
      net: ena: Fix toeplitz initial hash value
      net: ena: Don't register memory info on XDP exchange
      net: ena: Account for the number of processed bytes in XDP
      net: ena: Use bitmask to indicate packet redirection
      net: ena: Fix rx_copybreak value update
      net: ena: Set default value for RX interrupt moderation
      net: ena: Update NUMA TPH hint register upon NUMA node update

David Howells (1):
      rxrpc: Fix a couple of potential use-after-frees

David S. Miller (13):
      Merge tag 'for-netdev' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'netdev-doc-defaq'
      Merge branch 'rswitch-fixes'
      Merge branch 'bnxt_en-fixes'
      Merge branch 'ethtool_gert_phy_stats-fixes'
      Merge branch 'r8169-fixes'
      Merge branch 'tcp-bhash2-fixes'
      Merge tag 'mlx5-fixes-2022-12-28' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ena-fixes'
      Merge branch 'dsa-qca8k-fixes'
      Merge branch 'selftests-fix'
      Merge branch 'cls_drop-fix'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Dragos Tatulea (1):
      net/mlx5e: IPoIB, Don't allow CQE compression to be turned on by default

Eli Cohen (1):
      net/mlx5: Lag, fix failure to cancel delayed bond work

Eric Dumazet (2):
      bonding: fix lockdep splat in bond_miimon_commit()
      inet: control sockets should not use current thread task_frag

Florian Westphal (1):
      netfilter: conntrack: fix ipv6 exthdr error check

Geetha sowjanya (1):
      octeontx2-pf: Fix lmtst ID used in aura free

Hao Sun (2):
      bpf: fix nullness propagation for reg to reg comparisons
      selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID

Hawkins Jiawei (1):
      net: sched: fix memory leak in tcindex_set_parms

Horatiu Vultur (2):
      net: lan966x: Fix configuration of the PCS
      net: sparx5: Fix reading of the MAC address

Hou Tao (1):
      bpf: Define sock security related BTF IDs under CONFIG_SECURITY_NETWORK

Ido Schimmel (1):
      vxlan: Fix memory leaks in error path

Jakub Kicinski (7):
      bpf: pull before calling skb_postpull_rcsum()
      Merge tag 'wireless-2022-12-21' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'mptcp-locking-fixes'
      Merge branch 'net-hns3-fix-some-bug-for-hns3'
      docs: netdev: reshuffle sections in prep for de-FAQization
      docs: netdev: convert to a non-FAQ document
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jamal Hadi Salim (2):
      net: sched: atm: dont intepret cls results when asked to drop
      net: sched: cbq: dont intepret cls results when asked to drop

Jian Shen (3):
      net: hns3: fix miss L3E checking for rx packet
      net: hns3: fix VF promisc mode not update when mac table full
      net: hns3: refine the handling for VF heartbeat

Jie Wang (1):
      net: hns3: add interrupts re-initialization while doing VF FLR

Jiguang Xiao (1):
      net: amd-xgbe: add missed tasklet_kill

Jiri Pirko (1):
      net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path

Johannes Berg (1):
      wifi: iwlwifi: fw: skip PPAG for JF

Johnny S. Lee (1):
      net: dsa: mv88e6xxx: depend on PTP conditionally

Jozsef Kadlecsik (2):
      netfilter: ipset: fix hash:net,port,net hang with /0 subnet
      netfilter: ipset: Rework long task execution when adding/deleting entries

Kees Cook (1):
      bpf: Always use maximal size for copy_array()

Kui-Feng Lee (2):
      bpf: keep a reference to the mm, in case the task is dead.
      selftests/bpf: add a test for iter/task_vma for short-lived processes

Kuniyuki Iwashima (2):
      tcp: Add TIME_WAIT sockets in bhash2.
      tcp: Add selftest for bind() and TIME_WAIT.

Lukas Bulwahn (1):
      wifi: ti: remove obsolete lines in the Makefile

Maciej Fijalkowski (1):
      ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf

Maor Dickman (1):
      net/mlx5e: Set geneve_tlv_option_0_exist when matching on geneve option

Martin KaFai Lau (1):
      selftests/bpf: Test bpf_skb_adjust_room on CHECKSUM_PARTIAL

Miaoqian Lin (2):
      nfc: Fix potential resource leaks
      net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe

Michael Chan (4):
      bnxt_en: Simplify bnxt_xdp_buff_init()
      bnxt_en: Fix XDP RX path
      bnxt_en: Fix first buffer size calculations for XDP multi-buffer
      bnxt_en: Fix HDS and jumbo thresholds for RX packets

Michał Grzelak (1):
      dt-bindings: net: marvell,orion-mdio: Fix examples

Moshe Shemesh (1):
      net/mlx5: E-Switch, properly handle ingress tagged packets on VST

Pablo Neira Ayuso (4):
      netfilter: nf_tables: consolidate set description
      netfilter: nf_tables: add function to create set stateful expressions
      netfilter: nf_tables: perform type checking for existing sets
      netfilter: nf_tables: honor set timeout and garbage collection updates

Paolo Abeni (3):
      mptcp: fix deadlock in fastopen error path
      mptcp: fix lockdep false positive
      net/ulp: prevent ULP without clone op from entering the LISTEN status

Pedro Tammela (1):
      net/sched: fix retpoline wrapper compilation on configs without tc filters

Po-Hsu Lin (3):
      selftests: net: fix cmsg_so_mark.sh test hang
      selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier
      selftests: net: return non-zero for failures reported in arp_ndisc_evict_nocarrier

Randy Dunlap (1):
      net: sched: htb: fix htb_classify() kernel-doc

Ronak Doshi (1):
      vmxnet3: correctly report csum_level for encapsulated packet

Rong Tao (1):
      atm: uapi: fix spelling typos in comments

Samuel Holland (1):
      dt-bindings: net: sun8i-emac: Add phy-supply property

Sean Anderson (3):
      powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
      net: phy: Update documentation for get_rate_matching
      net: dpaa: Fix dtsec check for PCS availability

Shawn Bohrer (1):
      veth: Fix race with AF_XDP exposing old or uninitialized descriptors

Shay Drory (3):
      net/mlx5: Fix io_eq_size and event_eq_size params validation
      net/mlx5: Avoid recovery in probe flows
      net/mlx5: Fix RoCE setting at HCA level

Srivatsa S. Bhat (VMware) (1):
      MAINTAINERS: Update maintainers for ptp_vmw driver

Stanislav Fomichev (1):
      selftests/bpf: Add host-tools to gitignore

Szymon Heidrich (1):
      usb: rndis_host: Secure rndis_query check against int overflow

Tariq Toukan (1):
      net/mlx5e: Fix RX reporter for XSK RQs

Uwe Kleine-König (2):
      net: ethernet: broadcom: bcm63xx_enet: Drop empty platform remove function
      net: ethernet: freescale: enetc: Drop empty platform remove function

Vikas Gupta (1):
      bnxt_en: fix devlink port registration to netdev

Xuezhi Zhang (1):
      s390/qeth: convert sysfs snprintf to sysfs_emit

Yinjun Zhang (1):
      nfp: fix schedule in atomic context when sync mc address

Yoshihiro Shimoda (2):
      net: ethernet: renesas: rswitch: Fix error path in renesas_eth_sw_probe()
      net: ethernet: renesas: rswitch: Fix getting mac address from device tree

Zhengchao Shao (1):
      caif: fix memory leak in cfctrl_linkup_request()

 .../bindings/net/allwinner,sun8i-a83t-emac.yaml    |   3 +
 .../bindings/net/marvell,orion-mdio.yaml           |  30 +-
 Documentation/process/maintainer-netdev.rst        | 369 +++++++++++----------
 MAINTAINERS                                        |   4 +-
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |  16 +
 drivers/net/bonding/bond_3ad.c                     |   1 +
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/dsa/mv88e6xxx/Kconfig                  |   4 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   | 164 +++++----
 drivers/net/dsa/qca/qca8k.h                        |   5 -
 drivers/net/ethernet/amazon/ena/ena_com.c          |  29 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  83 +++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |  17 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   3 +
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c           |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   4 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   6 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  27 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  15 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   6 +-
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c  |   6 -
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  10 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 132 +++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   7 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  71 +++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   2 +-
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   7 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   9 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |   7 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   6 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 .../net/ethernet/microchip/lan966x/lan966x_port.c  |   2 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   7 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  61 +++-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |  28 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |  10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   8 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  58 ++--
 drivers/net/ethernet/renesas/rswitch.c             |  10 +-
 drivers/net/ipa/ipa_interrupt.c                    |   3 +-
 drivers/net/phy/xilinx_gmii2rgmii.c                |   1 +
 drivers/net/usb/rndis_host.c                       |   3 +-
 drivers/net/veth.c                                 |   5 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   8 +
 drivers/net/vrf.c                                  |   6 +-
 drivers/net/vxlan/vxlan_core.c                     |  19 +-
 drivers/net/wireless/ath/ath9k/htc.h               |  14 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   5 +
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |   1 +
 drivers/net/wireless/ti/Makefile                   |   3 -
 drivers/s390/net/qeth_core_sys.c                   |  12 +-
 include/linux/dsa/tag_qca.h                        |   4 +-
 include/linux/mlx5/device.h                        |   5 +
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/phy.h                                |   5 +-
 include/net/inet_hashtables.h                      |   4 +
 include/net/inet_timewait_sock.h                   |   5 +
 include/net/netfilter/nf_tables.h                  |  25 +-
 include/net/tc_wrapper.h                           |   4 +-
 include/trace/events/rxrpc.h                       |   6 +-
 include/uapi/linux/atmbr2684.h                     |   2 +-
 kernel/bpf/bpf_lsm.c                               |   2 +
 kernel/bpf/task_iter.c                             |  39 ++-
 kernel/bpf/trampoline.c                            |   4 +
 kernel/bpf/verifier.c                              |  21 +-
 net/caif/cfctrl.c                                  |   6 +-
 net/core/filter.c                                  |   7 +-
 net/ethtool/ioctl.c                                | 107 +++---
 net/ipv4/af_inet.c                                 |   1 +
 net/ipv4/inet_connection_sock.c                    |  40 ++-
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/inet_timewait_sock.c                      |  31 +-
 net/ipv4/tcp_ulp.c                                 |   4 +
 net/mptcp/protocol.c                               |  20 +-
 net/mptcp/protocol.h                               |   4 +-
 net/mptcp/subflow.c                                |  19 +-
 net/netfilter/ipset/ip_set_core.c                  |   7 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |  14 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c           |  13 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |  13 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c         |  13 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |  13 +-
 net/netfilter/ipset/ip_set_hash_net.c              |  17 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |  15 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |  23 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |  19 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c       |  40 +--
 net/netfilter/nf_conntrack_proto.c                 |   7 +-
 net/netfilter/nf_tables_api.c                      | 261 ++++++++++-----
 net/nfc/netlink.c                                  |  52 ++-
 net/openvswitch/datapath.c                         |   8 +-
 net/rxrpc/recvmsg.c                                |  14 +-
 net/sched/cls_tcindex.c                            |  12 +-
 net/sched/sch_atm.c                                |   5 +-
 net/sched/sch_cbq.c                                |   4 +-
 net/sched/sch_htb.c                                |   8 +-
 tools/bpf/bpftool/Makefile                         |   4 +
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |   1 +
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  73 ++++
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |   2 +-
 .../selftests/bpf/prog_tests/decap_sanity.c        |  85 +++++
 .../selftests/bpf/prog_tests/jeq_infer_not_null.c  |   9 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |   6 +
 tools/testing/selftests/bpf/progs/decap_sanity.c   |  68 ++++
 .../selftests/bpf/progs/jeq_infer_not_null_fail.c  |  42 +++
 tools/testing/selftests/net/.gitignore             |   1 +
 .../selftests/net/arp_ndisc_evict_nocarrier.sh     |  15 +-
 tools/testing/selftests/net/bind_timewait.c        |  92 +++++
 tools/testing/selftests/net/cmsg_sender.c          |   2 +-
 128 files changed, 1984 insertions(+), 840 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/decap_sanity.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/decap_sanity.c
 create mode 100644 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
 create mode 100644 tools/testing/selftests/net/bind_timewait.c
