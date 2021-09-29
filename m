Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E6B41C8E4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbhI2P7s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Sep 2021 11:59:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13832 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhI2P7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:39 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWJ4lNNz8ymr;
        Wed, 29 Sep 2021 23:53:16 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 000/167] net: extend the netdev_features_t
Date:   Wed, 29 Sep 2021 23:50:47 +0800
Message-ID: <20210929155334.12454-1-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t is u64, and the number
of netdevice feature bits is 64 now. So there is no space to
introduce new feature bit.

This patchset try to solve it by change the prototype of
netdev_features_t from u64 to bitmap. With this change,
it's necessary to introduce a set of bitmap operation helpers
for netdev features. Meanwhile, the functions which use
netdev_features_t as return value are also need to be changed,
return the result as an output parameter.

With above changes, it will affect hundreds of files, and all the
nic drivers. To make it easy to be reviewed, split the changes
to 167 patches to 5 parts.

patch 1~22: convert the prototype which use netdev_features_t
as return value
patch 24: introduce fake helpers for bitmap operation
patch 25~165: use netdev_feature_xxx helpers
patch 166: use macro __DECLARE_NETDEV_FEATURE_MASK to replace
netdev_feature_t declaration.
patch 167: change the type of netdev_features_t to bitmap,
and rewrite the bitmap helpers.

Sorry to send a so huge patchset, I wanna to get more suggestions
to finish this work, to make it much more reviewable and feasible.

The former discussing for the changes, see [1]
[1]. https://www.spinics.net/lists/netdev/msg753528.html

ChangeLog:
V1->V2:
use bitmap by comment from Andrew Lunn

Jian Shen (167):
  net: convert the prototype of netdev_intersect_features
  net: convert the prototype of netdev_get_wanted_features
  net: convert the prototype of net_mpls_features
  net: convert the prototype of harmonize_features
  net: convert the prototype of gso_features_check
  net: convert the prototype of vlan_features_check
  net: convert the prototype of vxlan_features_check
  net: convert the prototype of dflt_features_check
  net: convert the prototype of ndo_features_check
  net: convert the prototype of netif_skb_features
  net: convert the prototype of ndo_fix_features
  net: convert the prototype of netdev_fix_features
  net: convert the prototype of netdev_sync_upper_features
  net: convert the prototype of br_features_recompute
  net: convert the prototype of netdev_add_tso_features
  net: convert the prototype of netdev_increment_features
  net: convert the prototype of hsr_features_recompute
  net: mlx5: convert prototype of mlx5e_ipsec_feature_check,
    mlx5e_tunnel_features_check and mlx5e_fix_uplink_rep_features
  net: sfc: convert the prototype of xxx_supported_features
  net: qlogic: convert the prototype of qlcnic_process_flags
  net: realtek: convert the prototype of rtl8168evl_fix_tso
  ethtool: convert the prototype of ethtool_get_feature_mask
  net: add netdev feature helpers
  net: core: use netdev feature helpers
  skbuff: use netdev feature helpers
  net: vlan: use netdev feature helpers
  bridge: use netdev feature helpers
  ipvlan: use netdev feature helpers
  veth: use netdev feature helpers
  bonding: use netdev feature helpers
  net: tun: use netdev feature helpers
  net: tap: use netdev feature helpers
  net: geneve: use netdev feature helpers
  hv_netvsc: use netdev feature helpers
  macvlan: use netdev feature helpers
  macsec: use netdev feature helpers
  net: tls: use netdev feature helpers
  s390: qeth: use netdev feature helpers
  dsa: use netdev feature helpers
  macvtap: use netdev feature helpers
  team: use netdev feature helpers
  vmxnet3: use netdev feature helpers
  net_failover: use netdev feature helpers
  pktgen: use netdev feature helpers
  net: sched: use netdev feature helpers
  netdevsim: use netdev feature helpers
  virtio_net: use netdev feature helpers
  net: ipv4: use netdev feature helpers
  net: ipv6: use netdev feature helpers
  net: hsr: use netdev feature helpers
  net: mpls: use netdev feature helpers
  net: nsh: use netdev feature helpers
  net: decnet: use netdev feature helpers
  net: dccp: use netdev feature helpers
  net: l2tp: use netdev feature helpers
  net: ntb_netdev: use netdev feature helpers
  net: thunderbolt: use netdev feature helpers
  net: phonet: use netdev feature helpers
  net: vrf: use netdev feature helpers
  net: sctp: use netdev feature helpers
  vxlan: use netdev feature helpers
  xen-netback: use netdev feature helpers
  xen-netfront: use netdev feature helpers
  sock: use netdev feature helpers
  sunrpc: use netdev feature helpers
  net: caif: use netdev feature helpers
  net: loopback: use netdev feature helpers
  net: dummy: use netdev_feature helpers
  net: mac80211: use netdev feature helpers
  net: ifb: use netdev feature helpers
  net: bareudp: use netdev feature helpers
  net: rionet: use netdev feature helpers
  net: gtp: use netdev feature helpers
  net: vsockmon: use netdev feature helpers
  net: nlmon: use netdev feature helpers
  net: wireguard: use netdev feature helpers
  net: can: use netdev feature helpers
  net: ppp: use netdev feature helpers
  net: ipa: use netdev feature helpers
  net: fjes: use netdev feature helpers
  net: usb: use netdev feature helpers
  net: wireless: use netdev feature helpers
  net: realtek: use netdev feature helpers
  net: broadcom: use netdev feature helpers
  net: intel: use netdev feature helpers
  net: hisilicon: use netdev feature helpers
  net: mellanox: use netdev feature helpers
  net: atlantic: use netdev feature helpers
  net: atheros: use netdev feature helpers
  net: chelsio: use netdev feature helpers
  net: davicom: use netdev feature helpers
  net: freescale: use netdev feature helpers
  net: synopsys: use netdev feature helpers
  net: sfc: use netdev feature helpers
  net: qualcomm: use netdev feature helpers
  net: nvidia: use netdev feature helpers
  net: faraday: use netdev feature helpers
  net: google: use netdev feature helpers
  net: hinic: use netdev feature helpers
  net: ibm: use netdev feature helpers
  net: ionic: use netdev feature helpers
  net: jme: use netdev feature helpers
  net: micrel: use netdev feature helpers
  net: cavium: use netdev feature helpers
  net: cadence: use netdev feature helpers
  net: mediatek: use netdev feature helpers
  net: marvell: use netdev feature helpers
  net: socionext: use netdev feature helpers
  net: qlogic: use netdev feature helpers
  net: nfp: use netdev feature helpers
  net: mscc: use netdev feature helpers
  net: oki-semi: use netdev feature helpers
  net: renesas: use netdev feature helpers
  net: neterion: use netdev feature helpers
  net: cortina: use netdev feature helpers
  net: stmmac: use netdev feature helpers
  net: sxgbe: use netdev feature helpers
  net: xgmac: use netdev feature helpers
  net: altera: use netdev feature helpers
  net: ti: use netdev feature helpers
  net: benet: use netdev feature helpers
  net: amd: use netdev feature helpers
  net: bna: use netdev feature helpers
  net: enic: use netdev feature helpers
  net: 3com: use netdev feature helpers
  net: aeroflex: use netdev feature helpers
  net: sun: use netdev feature helpers
  net: mana: use netdev feature helpers
  net: myricom: use netdev feature helpers
  net: alacritech: use netdev feature helpers
  net: toshiba: use netdev feature helpers
  net: tehuti: use netdev feature helpers
  net: alteon: use netdev feature helpers
  net: ena: use netdev feature helpers
  net: sgi: use netdev feature helpers
  net: microchip: use netdev feature helpers
  net: ni: use netdev feature helpers
  net: apm: use netdev feature helpers
  net: natsemi: use netdev feature helpers
  net: xilinx: use netdev feature helpers
  net: pasemi: use netdev feature helpers
  net: rocker: use netdev feature helpers
  net: silan: use netdev feature helpers
  net: adaptec: use netdev feature helpers
  net: tundra: use netdev feature helpers
  net: via: use netdev feature helpers
  net: wiznet: use netdev feature helpers
  net: dnet: use netdev feature helpers
  net: ethoc: use netdev feature helpers
  RDMA: ipoib: use netdev feature helpers
  um: use netdev feature helpers
  scsi: fcoe: use netdev feature helpers
  net: ipvs: use netdev feature helpers
  net: xfrm: use netdev feature helpers
  net: cirrus: use netdev feature helpers
  net: ec_bhf: use netdev feature helpers
  net: hamradio: use netdev feature helpers
  net: batman: use netdev feature helpers
  net: ieee802154: use netdev feature helpers
  test_bpf: change the prototype of features
  net: openvswitch: use netdev feature helpers
  firewire: use netdev feature helpers
  staging: qlge: use netdev feature helpers
  staging: octeon: use netdev feature helpers
  net: sock: add helper sk_nocaps_add_gso()
  treewide: introduce macro __DECLARE_NETDEV_FEATURE_MASK
  net: extend the type of netdev_features_t to bitmap

 arch/um/drivers/vector_kern.c                 |  15 +-
 drivers/firewire/net.c                        |   3 +-
 drivers/infiniband/hw/hfi1/vnic_main.c        |   7 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  21 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c    |   2 +-
 drivers/net/bareudp.c                         |  16 +-
 drivers/net/bonding/bond_main.c               | 136 +++---
 drivers/net/bonding/bond_options.c            |  12 +-
 drivers/net/caif/caif_serial.c                |   2 +-
 drivers/net/can/dev/dev.c                     |   3 +-
 drivers/net/can/slcan.c                       |   3 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |   6 +-
 drivers/net/dummy.c                           |  14 +-
 drivers/net/ethernet/3com/3c59x.c             |   9 +-
 drivers/net/ethernet/3com/typhoon.c           |  10 +-
 drivers/net/ethernet/adaptec/starfire.c       |   9 +-
 drivers/net/ethernet/aeroflex/greth.c         |  12 +-
 drivers/net/ethernet/alacritech/slicoss.c     |   5 +-
 drivers/net/ethernet/alteon/acenic.c          |   7 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  11 +-
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |   2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  50 ++-
 drivers/net/ethernet/amd/amd8111e.c           |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c      |  20 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  93 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  68 +--
 drivers/net/ethernet/amd/xgbe/xgbe.h          |   2 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |   5 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  21 +-
 .../ethernet/aquantia/atlantic/aq_filters.c   |  12 +-
 .../ethernet/aquantia/atlantic/aq_macsec.c    |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  27 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  28 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   3 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |   3 +-
 drivers/net/ethernet/atheros/alx/main.c       |  23 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  33 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  44 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  15 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  27 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |  20 +-
 drivers/net/ethernet/broadcom/b44.c           |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  24 +-
 drivers/net/ethernet/broadcom/bgmac.c         |   8 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  48 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  67 +--
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   3 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  93 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 171 ++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  11 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   3 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  12 +-
 drivers/net/ethernet/broadcom/tg3.c           |  62 +--
 drivers/net/ethernet/brocade/bna/bnad.c       |  48 +-
 drivers/net/ethernet/cadence/macb_main.c      |  81 ++--
 drivers/net/ethernet/calxeda/xgmac.c          |  20 +-
 .../net/ethernet/cavium/liquidio/lio_core.c   |   6 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  95 ++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  79 ++--
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  50 ++-
 .../ethernet/cavium/thunder/nicvf_queues.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  50 ++-
 drivers/net/ethernet/chelsio/cxgb/sge.c       |  12 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  60 ++-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  10 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c   |  16 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  88 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  14 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  39 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |   8 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   3 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  74 +--
 drivers/net/ethernet/cortina/gemini.c         |  18 +-
 drivers/net/ethernet/davicom/dm9000.c         |  24 +-
 drivers/net/ethernet/dnet.c                   |   2 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  68 +--
 drivers/net/ethernet/ethoc.c                  |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  38 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  23 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  44 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   5 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  34 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  38 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  16 +-
 drivers/net/ethernet/freescale/fec_main.c     |  29 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |   2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  39 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  11 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   6 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  31 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |   8 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   8 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  52 ++-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 109 +++--
 .../net/ethernet/huawei/hinic/hinic_main.c    |  80 ++--
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |   5 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  22 +-
 drivers/net/ethernet/ibm/emac/core.c          |   7 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  76 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  69 +--
 drivers/net/ethernet/intel/e100.c             |  26 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  82 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c    | 129 +++---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   9 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  65 +--
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 122 ++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 153 ++++---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 177 +++++---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   9 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 150 ++++---
 drivers/net/ethernet/intel/igbvf/netdev.c     |  86 ++--
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   3 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 130 +++---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  49 +-
 .../net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c   |   3 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 215 +++++----
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |   6 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   9 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 105 +++--
 drivers/net/ethernet/jme.c                    |  49 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  14 +-
 drivers/net/ethernet/marvell/mvneta.c         |  22 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  73 +--
 .../marvell/octeontx2/nic/otx2_common.c       |   3 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  85 ++--
 .../marvell/octeontx2/nic/otx2_txrx.c         |   8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  35 +-
 .../ethernet/marvell/prestera/prestera_main.c |   3 +-
 drivers/net/ethernet/marvell/skge.c           |  11 +-
 drivers/net/ethernet/marvell/sky2.c           |  75 ++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  68 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   2 +-
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c  |   8 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 198 +++++----
 .../net/ethernet/mellanox/mlx4/en_resources.c |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  19 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  15 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  14 +-
 .../mellanox/mlx5/core/en_accel/tls.c         |  16 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |   6 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 250 ++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  25 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  19 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  36 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  10 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   7 +-
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  20 +-
 drivers/net/ethernet/mscc/ocelot.c            |   3 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  18 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  31 +-
 drivers/net/ethernet/natsemi/ns83820.c        |  13 +-
 drivers/net/ethernet/neterion/s2io.c          |  32 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |  49 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |  12 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 118 +++--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  76 ++--
 drivers/net/ethernet/netronome/nfp/nfp_port.c |   3 +-
 drivers/net/ethernet/ni/nixge.c               |   3 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  66 +--
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  13 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |   6 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |   6 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 125 +++---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   9 +-
 .../ethernet/qlogic/netxen/netxen_nic_init.c  |   3 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  50 ++-
 drivers/net/ethernet/qlogic/qede/qede.h       |  10 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |   2 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  19 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  23 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  67 +--
 drivers/net/ethernet/qlogic/qla3xxx.c         |   5 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |   3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  72 +--
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |   3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  57 +--
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |   6 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  25 +-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  10 +-
 drivers/net/ethernet/realtek/8139cp.c         |  39 +-
 drivers/net/ethernet/realtek/8139too.c        |  28 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  85 ++--
 drivers/net/ethernet/renesas/ravb.h           |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  24 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  28 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   3 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  19 +-
 drivers/net/ethernet/sfc/ef10.c               |  41 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  43 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |   6 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |  11 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |   6 +-
 drivers/net/ethernet/sfc/efx.c                |  32 +-
 drivers/net/ethernet/sfc/efx_common.c         |  41 +-
 drivers/net/ethernet/sfc/efx_common.h         |   4 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  44 +-
 drivers/net/ethernet/sfc/falcon/falcon.c      |   4 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   9 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |   6 +-
 drivers/net/ethernet/sfc/farch.c              |   2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  21 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c   |   3 +-
 drivers/net/ethernet/sfc/net_driver.h         |   9 +-
 drivers/net/ethernet/sfc/rx.c                 |   3 +-
 drivers/net/ethernet/sfc/rx_common.c          |   5 +-
 drivers/net/ethernet/sfc/siena.c              |   4 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |  11 +-
 drivers/net/ethernet/silan/sc92031.c          |   6 +-
 drivers/net/ethernet/socionext/netsec.c       |  10 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   6 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  62 +--
 .../stmicro/stmmac/stmmac_selftests.c         |   6 +-
 drivers/net/ethernet/sun/cassini.c            |   5 +-
 drivers/net/ethernet/sun/ldmvsw.c             |   5 +-
 drivers/net/ethernet/sun/niu.c                |  11 +-
 drivers/net/ethernet/sun/sungem.c             |  11 +-
 drivers/net/ethernet/sun/sunhme.c             |  14 +-
 drivers/net/ethernet/sun/sunvnet.c            |   8 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |   5 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  45 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c |  20 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  41 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |   2 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  22 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  23 +-
 drivers/net/ethernet/ti/cpsw.c                |   6 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   7 +-
 drivers/net/ethernet/ti/netcp_core.c          |   9 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  14 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  12 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |   3 +-
 drivers/net/ethernet/via/via-rhine.c          |  10 +-
 drivers/net/ethernet/via/via-velocity.c       |  14 +-
 drivers/net/ethernet/wiznet/w5100.c           |   2 +-
 drivers/net/ethernet/wiznet/w5300.c           |   2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |   5 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |   9 +-
 drivers/net/fjes/fjes_main.c                  |   3 +-
 drivers/net/geneve.c                          |  18 +-
 drivers/net/gtp.c                             |   2 +-
 drivers/net/hamradio/bpqether.c               |   3 +-
 drivers/net/hyperv/netvsc_bpf.c               |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |  46 +-
 drivers/net/hyperv/rndis_filter.c             |  30 +-
 drivers/net/ifb.c                             |  12 +-
 drivers/net/ipa/ipa_modem.c                   |   3 +-
 drivers/net/ipvlan/ipvlan.h                   |   2 +-
 drivers/net/ipvlan/ipvlan_main.c              |  40 +-
 drivers/net/ipvlan/ipvtap.c                   |   5 +-
 drivers/net/loopback.c                        |  20 +-
 drivers/net/macsec.c                          |  49 +-
 drivers/net/macvlan.c                         |  58 ++-
 drivers/net/macvtap.c                         |   5 +-
 drivers/net/net_failover.c                    |  77 ++--
 drivers/net/netdevsim/ipsec.c                 |   4 +-
 drivers/net/netdevsim/netdev.c                |  15 +-
 drivers/net/nlmon.c                           |   5 +-
 drivers/net/ntb_netdev.c                      |   5 +-
 drivers/net/ppp/ppp_generic.c                 |   2 +-
 drivers/net/rionet.c                          |   3 +-
 drivers/net/tap.c                             |  38 +-
 drivers/net/team/team.c                       |  90 ++--
 drivers/net/thunderbolt.c                     |  10 +-
 drivers/net/tun.c                             |  53 ++-
 drivers/net/usb/aqc111.c                      |  42 +-
 drivers/net/usb/ax88179_178a.c                |  26 +-
 drivers/net/usb/cdc-phonet.c                  |   2 +-
 drivers/net/usb/cdc_mbim.c                    |   4 +-
 drivers/net/usb/lan78xx.c                     |  46 +-
 drivers/net/usb/r8152.c                       |  71 +--
 drivers/net/usb/smsc75xx.c                    |  14 +-
 drivers/net/usb/smsc95xx.c                    |  19 +-
 drivers/net/veth.c                            |  67 +--
 drivers/net/virtio_net.c                      |  50 ++-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  75 ++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  88 ++--
 drivers/net/vmxnet3/vmxnet3_int.h             |   4 +-
 drivers/net/vrf.c                             |  20 +-
 drivers/net/vsockmon.c                        |   6 +-
 drivers/net/vxlan.c                           |  21 +-
 drivers/net/wireguard/device.c                |   8 +-
 drivers/net/wireless/ath/ath10k/mac.c         |   7 +-
 drivers/net/wireless/ath/ath11k/mac.c         |   4 +-
 drivers/net/wireless/ath/ath6kl/main.c        |  15 +-
 drivers/net/wireless/ath/ath6kl/txrx.c        |   6 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |  11 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |   4 +-
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   2 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |   7 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  10 +-
 .../net/wireless/mediatek/mt76/mt7615/init.c  |   3 +-
 .../net/wireless/mediatek/mt76/mt7915/init.c  |   3 +-
 .../net/wireless/mediatek/mt76/mt7921/init.c  |   3 +-
 drivers/net/xen-netback/interface.c           |  27 +-
 drivers/net/xen-netfront.c                    |  53 ++-
 drivers/s390/net/qeth_core.h                  |   7 +-
 drivers/s390/net/qeth_core_main.c             | 139 +++---
 drivers/s390/net/qeth_l2_main.c               |  44 +-
 drivers/s390/net/qeth_l3_main.c               |  49 +-
 drivers/scsi/fcoe/fcoe.c                      |  14 +-
 drivers/staging/octeon/ethernet.c             |   5 +-
 drivers/staging/qlge/qlge_main.c              |  59 +--
 drivers/usb/gadget/function/f_phonet.c        |   2 +-
 include/linux/if_macvlan.h                    |   2 +-
 include/linux/if_tap.h                        |   2 +-
 include/linux/if_vlan.h                       |  22 +-
 include/linux/netdev_features.h               | 181 +++++++-
 include/linux/netdevice.h                     | 122 ++---
 include/linux/skbuff.h                        |   6 +-
 include/net/mac80211.h                        |   2 +-
 include/net/pkt_cls.h                         |   2 +-
 include/net/sock.h                            |  22 +-
 include/net/udp.h                             |   8 +-
 include/net/udp_tunnel.h                      |  12 +-
 include/net/vxlan.h                           |  13 +-
 lib/test_bpf.c                                |  21 +-
 lib/vsprintf.c                                |   4 +-
 net/8021q/vlan.c                              |  11 +-
 net/8021q/vlan.h                              |  24 +-
 net/8021q/vlan_core.c                         |   6 +-
 net/8021q/vlan_dev.c                          |  57 +--
 net/batman-adv/soft-interface.c               |   5 +-
 net/bridge/br_device.c                        |  21 +-
 net/bridge/br_if.c                            |  19 +-
 net/bridge/br_private.h                       |   3 +-
 net/core/dev.c                                | 420 ++++++++++--------
 net/core/netpoll.c                            |   4 +-
 net/core/pktgen.c                             |   6 +-
 net/core/skbuff.c                             |  10 +-
 net/core/skmsg.c                              |   3 +-
 net/core/sock.c                               |  17 +-
 net/dccp/ipv4.c                               |   2 +-
 net/dccp/ipv6.c                               |   7 +-
 net/decnet/af_decnet.c                        |   2 +-
 net/decnet/dn_nsp_out.c                       |   2 +-
 net/dsa/slave.c                               |  24 +-
 net/ethtool/features.c                        |  94 ++--
 net/ethtool/ioctl.c                           | 158 ++++---
 net/hsr/hsr_device.c                          |  40 +-
 net/hsr/hsr_forward.c                         |  11 +-
 net/hsr/hsr_framereg.c                        |   3 +-
 net/hsr/hsr_slave.c                           |   3 +-
 net/ieee802154/6lowpan/core.c                 |   2 +-
 net/ieee802154/core.c                         |  14 +-
 net/ipv4/af_inet.c                            |   5 +-
 net/ipv4/esp4_offload.c                       |  28 +-
 net/ipv4/gre_offload.c                        |   8 +-
 net/ipv4/ip_gre.c                             |  36 +-
 net/ipv4/ip_output.c                          |  27 +-
 net/ipv4/ip_tunnel.c                          |   4 +-
 net/ipv4/ip_vti.c                             |   2 +-
 net/ipv4/ipip.c                               |   6 +-
 net/ipv4/ipmr.c                               |   2 +-
 net/ipv4/tcp.c                                |  10 +-
 net/ipv4/tcp_ipv4.c                           |   6 +-
 net/ipv4/tcp_offload.c                        |   5 +-
 net/ipv4/tcp_output.c                         |   2 +-
 net/ipv4/udp_offload.c                        |  28 +-
 net/ipv6/af_inet6.c                           |   2 +-
 net/ipv6/esp6_offload.c                       |  19 +-
 net/ipv6/inet6_connection_sock.c              |   2 +-
 net/ipv6/ip6_gre.c                            |  17 +-
 net/ipv6/ip6_offload.c                        |   3 +-
 net/ipv6/ip6_output.c                         |  24 +-
 net/ipv6/ip6_tunnel.c                         |   9 +-
 net/ipv6/ip6mr.c                              |   2 +-
 net/ipv6/sit.c                                |   9 +-
 net/ipv6/tcp_ipv6.c                           |   2 +-
 net/ipv6/udp_offload.c                        |   2 +-
 net/l2tp/l2tp_eth.c                           |   2 +-
 net/mac80211/iface.c                          |  10 +-
 net/mac80211/main.c                           |   5 +-
 net/mpls/mpls_gso.c                           |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c         |   3 +-
 net/nsh/nsh.c                                 |   2 +-
 net/openvswitch/datapath.c                    |   5 +-
 net/openvswitch/vport-internal_dev.c          |  24 +-
 net/phonet/pep-gprs.c                         |   3 +-
 net/sched/sch_cake.c                          |   6 +-
 net/sched/sch_netem.c                         |   6 +-
 net/sched/sch_taprio.c                        |   6 +-
 net/sched/sch_tbf.c                           |   6 +-
 net/sctp/offload.c                            |  12 +-
 net/sctp/output.c                             |   2 +-
 net/sunrpc/sunrpc.h                           |   2 +-
 net/tls/tls_device.c                          |  10 +-
 net/wireless/core.c                           |  14 +-
 net/xfrm/xfrm_device.c                        |  31 +-
 net/xfrm/xfrm_interface.c                     |   6 +-
 net/xfrm/xfrm_output.c                        |   4 +-
 424 files changed, 6584 insertions(+), 4459 deletions(-)

-- 
2.33.0

