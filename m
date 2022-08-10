Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD658E541
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiHJDNz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Aug 2022 23:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiHJDNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACF981B15
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:45 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M2Zjt6lt4zGpJw;
        Wed, 10 Aug 2022 11:12:18 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:43 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 00/36] net: extend the type of netdev_features_t to bitmap
Date:   Wed, 10 Aug 2022 11:05:48 +0800
Message-ID: <20220810030624.34711-1-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t is u64, and the number
of netdevice feature bits is 64 now. So there is no space to
introduce new feature bit.

This patchset try to solve it by change the prototype of
netdev_features_t from u64 to structure below:
	typedef struct {
		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
	} netdev_features_t;

With this change, it's necessary to introduce a set of bitmap
operation helpers for netdev features. [patch 1]

To avoid mistake using NETIF_F_XXX as NETIF_F_XXX_BIT as
input macroes for above helpers, remove all the macroes
of NETIF_F_XXX. Serveal macroes remained temporarily
by some precompile dependency.[patch 36]

The features group macroes in netdev_features.h are replaced
by a set of const features defined in netdev_features.c. [patch 2-3]
For example:
macro NETIF_F_ALL_TSO is replaced by netdev_all_tso_features

There are some drivers(e.g. sfc) use netdev_features in global
structure initialization. Changed the its netdev_features_t memeber
to netdev_features_t *, and make it prefer to a netdev_features_t
global variables. [patch 4~9]

Also, there are many features(e.g. NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK)
are used by several drivers, replaces them with global netdev features
variables, in order to simple the expressions.[patch 10~13]

As suggestion from Andrew Lunn, I wrote some semantic patches to do the
work(replacing the netdev features operator by helpers). To make the semantic
patches simple, I split the complex expressions of netdev_features to simple
logical operation. [patch 14~15]

For the prototype of netdev_features_t is no longer u64, so it's incorrect
to assigne 0 to it, use netdev_empty_features intead. [patch 16]

Some drivers defines macroes and functions wich use NETIF_F_XXX as parameter.
For all the macroes NETIF_F_XXX will be removed at last, so change these
macroes and functions to use NETIF_F_XXX_BIT. [patch 17~23]

With above preparation, then apply the semantic patches to do the expression
transition. For example, replace expression "ndev->hw_features |= NETIF_F_TSO;"
by "netdev_hw_feature_set(ndev, NETIF_F_TSO_BIT)". [patch 24~35]

With the prototype is no longer u64, the implementation of print interface
for netdev features(%pNF) is changed to bitmap. [patch 36]

I removed the netdev_features_copy and netdev_xxx_features() helpers in
this patchset. It make the expressions being more complex. For example,
expression "dev->features = dev->hw_features", it's too ugly to use
"netdev_active_features_copy(dev, netdev_hw_features(hw))". I will
try to find better way for this, avoiding the nic drivers to modify
netdev_features directly.

The former discussion please see [1][2][3][4][5].
[1]:https://www.spinics.net/lists/netdev/msg769952.html
[2]:https://www.spinics.net/lists/netdev/msg777764.html
[3]:https://lore.kernel.org/netdev/20211107101519.29264-1-shenjian15@huawei.com/T/
[4]:https://www.spinics.net/lists/netdev/msg809293.html
[5]:https://www.spinics.net/lists/netdev/msg814349.html

ChangeLog:
V6->V7: 
Add netdev_feature_change helpers, remove netdev_features_copy
and netdev_xxx_features helpers.
Complete the treewide netdev features changes.
Suggestions from Alexander Lobakin:
refine the definition of DECLARE_NETDEV_FEATURE_SET, and remove
useless blank lines.
V5-V6: suggestions from Jakub Kicinski:
drop the rename for netdev->features
simplify names of some helpers, and move them to a new header file
refine the implement for netdev_features_set_array
V4->V5:
adjust the patch structure, use semantic patch with coccinelle
V3->V4:
rename netdev->features to netdev->active_features
remove helpes for handle first 64 bits
remove __NETIF_F(name) macroes
replace features group macroes with const features
V2->V3:
use structure for bitmap, suggest by Edward Cree
V1->V2:
Extend the prototype from u64 to bitmap, suggest by Andrew Lunn


Jian Shen (36):
  net: introduce operation helpers for netdev features
  net: replace general features macroes with global netdev_features
    variables
  net: replace multiple feature bits with DECLARE_NETDEV_FEATURE_SET
  net: sfc: replace const features initialization with
    DECLARE_NETDEV_FEATURE_SET
  net: atlantic: replace const features initialization with
    NETDEV_FEATURE_SET
  iwlwifi: replace const features initialization with NETDEV_FEATURE_SET
  net: ethernet: mtk_eth_soc: replace const features initialization with
    NETDEV_FEATURE_SET
  ravb: replace const features initialization with NETDEV_FEATURE_SET
  test_bpf: replace const features initialization with
    NETDEV_FEATURE_SET
  treewide: replace NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK by
    netdev_csum_gso_features_mask
  treewide: replace NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM by
    netdev_ip_csum_features
  treewide: replace NETIF_F_TSO | NETIF_F_TSO6 by
    netdev_general_tso_features
  treewide: replace VLAN tag feature array by const vlan features
  net: simplify the netdev features expressions for xxx_gso_segment
  treewide: simplify the netdev features expression
  treewide: use replace features '0' by netdev_empty_features
  treewide: adjust features initialization
  net: mlx4: adjust the net device feature relative macroes
  net: mlx5e: adjust net device feature relative macroes
  net: mlxsw: adjust input parameter for function
    mlxsw_sp_handle_feature
  net: iavf: adjust net device features relative macroes
  net: core: adjust netdev_sync_xxx_features
  net: adjust the build check for net_gso_ok()
  treewide: use netdev_feature_add helpers
  treewide: use netdev_features_or/set helpers
  treewide: use netdev_feature_change helpers
  treewide: use netdev_feature_del helpers
  treewide: use netdev_features_andnot and netdev_features_clear helpers
  treewide: use netdev_features_xor helpers
  treewide: use netdev_feature_test helpers
  treewide: use netdev_features_intersects helpers
  net: use netdev_features_and and netdev_features_mask helpers
  treewide: use netdev_features_subset helpers
  treewide: use netdev_features_equal helpers
  treewide: use netdev_features_empty helpers
  net: redefine the prototype of netdev_features_t

 arch/um/drivers/vector_kern.c                 |   9 +-
 arch/um/drivers/vector_transports.c           |  49 +-
 drivers/firewire/net.c                        |   4 +-
 drivers/hsi/clients/ssi_protocol.c            |   2 +-
 drivers/infiniband/hw/hfi1/vnic_main.c        |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib.h          |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  21 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c    |   2 +-
 drivers/misc/sgi-xp/xpnet.c                   |   3 +-
 drivers/net/amt.c                             |  20 +-
 drivers/net/bareudp.c                         |  25 +-
 drivers/net/bonding/bond_main.c               | 101 ++-
 drivers/net/bonding/bond_options.c            |   9 +-
 drivers/net/caif/caif_serial.c                |   2 +-
 drivers/net/can/dev/dev.c                     |   4 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |  15 +-
 drivers/net/dummy.c                           |  19 +-
 drivers/net/ethernet/3com/3c59x.c             |  10 +-
 drivers/net/ethernet/3com/typhoon.c           |  20 +-
 drivers/net/ethernet/adaptec/starfire.c       |  12 +-
 drivers/net/ethernet/aeroflex/greth.c         |  15 +-
 drivers/net/ethernet/alacritech/slicoss.c     |   6 +-
 drivers/net/ethernet/alteon/acenic.c          |  12 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  10 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  49 +-
 drivers/net/ethernet/amd/amd8111e.c           |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c      |  14 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  56 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  69 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |   4 +-
 drivers/net/ethernet/apm/xgene-v2/main.h      |   1 +
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  21 +-
 .../ethernet/aquantia/atlantic/aq_filters.c   |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   2 +-
 .../ethernet/aquantia/atlantic/aq_macsec.c    |   2 +-
 .../ethernet/aquantia/atlantic/aq_macsec.h    |   1 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  89 ++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  29 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   3 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   8 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  17 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  15 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  29 +-
 drivers/net/ethernet/atheros/alx/main.c       |  19 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h    |   1 +
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  34 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h    |   1 +
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  39 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  24 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  19 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |  13 +-
 drivers/net/ethernet/broadcom/b44.c           |   3 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  34 +-
 drivers/net/ethernet/broadcom/bgmac.c         |   9 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  50 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  49 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 115 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 158 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   5 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  16 +-
 drivers/net/ethernet/broadcom/tg3.c           |  49 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  51 +-
 drivers/net/ethernet/cadence/macb_main.c      |  62 +-
 drivers/net/ethernet/calxeda/xgmac.c          |  25 +-
 .../net/ethernet/cavium/liquidio/lio_core.c   |   4 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 137 ++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 114 +--
 .../ethernet/cavium/liquidio/octeon_network.h |   4 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  51 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |   2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  46 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c       |   8 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  67 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c   |  16 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 102 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |   8 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  56 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |   4 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   7 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  62 +-
 drivers/net/ethernet/cortina/gemini.c         |  29 +-
 drivers/net/ethernet/davicom/dm9000.c         |  20 +-
 drivers/net/ethernet/davicom/dm9051.c         |   2 +-
 drivers/net/ethernet/dnet.c                   |   3 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  64 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |   4 +-
 drivers/net/ethernet/ethoc.c                  |   3 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  40 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  25 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  43 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  10 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  26 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  59 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  42 +-
 drivers/net/ethernet/freescale/fec_main.c     |  25 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |   2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  40 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |   7 +-
 .../ethernet/fungible/funeth/funeth_ktls.c    |   5 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  55 +-
 .../net/ethernet/fungible/funeth/funeth_rx.c  |   4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   5 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  26 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |   4 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   4 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  62 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 101 ++-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |   4 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  86 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |   4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  34 +-
 drivers/net/ethernet/ibm/emac/core.c          |  10 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  58 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  48 +-
 drivers/net/ethernet/intel/e100.c             |  20 +-
 drivers/net/ethernet/intel/e1000/e1000.h      |   1 +
 drivers/net/ethernet/intel/e1000/e1000_main.c |  71 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    | 109 +--
 drivers/net/ethernet/intel/fm10k/fm10k.h      |   1 +
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   6 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  51 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  10 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  12 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 133 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   6 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 231 +++---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |   8 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 223 +++---
 drivers/net/ethernet/intel/ice/ice_repr.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   8 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 141 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  93 ++-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/igc/igc_mac.c      |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c     | 127 +--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  38 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   1 +
 .../net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c   |   2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |   6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 231 +++---
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  17 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |   1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 115 +--
 drivers/net/ethernet/jme.c                    |  50 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  13 +-
 drivers/net/ethernet/marvell/mvneta.c         |  21 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  61 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   |   6 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  27 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  56 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   6 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  32 +-
 .../ethernet/marvell/prestera/prestera_main.c |   4 +-
 drivers/net/ethernet/marvell/skge.c           |  15 +-
 drivers/net/ethernet/marvell/sky2.c           |  66 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  74 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  12 +-
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c  |   7 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 170 ++--
 .../net/ethernet/mellanox/mlx4/en_resources.c |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  14 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   5 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  16 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   4 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |   4 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 215 ++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  22 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  22 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  37 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  15 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   9 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c |   2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   6 +-
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  21 +-
 drivers/net/ethernet/mscc/ocelot.c            |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  23 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  36 +-
 drivers/net/ethernet/natsemi/ns83820.c        |  11 +-
 drivers/net/ethernet/neterion/s2io.c          |  34 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |   8 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |   4 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  |   4 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   | 109 +--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  48 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.c |   3 +-
 drivers/net/ethernet/ni/nixge.c               |   4 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  57 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  14 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |   4 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |  11 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 108 +--
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   6 +-
 .../ethernet/qlogic/netxen/netxen_nic_init.c  |   4 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  50 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |   3 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |   8 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   6 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  81 +-
 drivers/net/ethernet/qlogic/qla3xxx.c         |   9 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  57 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  52 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |   4 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  27 +-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |   7 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  14 +-
 drivers/net/ethernet/realtek/8139cp.c         |  38 +-
 drivers/net/ethernet/realtek/8139too.c        |  26 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  70 +-
 drivers/net/ethernet/renesas/ravb.h           |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  39 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  20 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |   7 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  24 +-
 drivers/net/ethernet/sfc/ef10.c               |  35 +-
 drivers/net/ethernet/sfc/ef100_netdev.c       |  15 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  33 +-
 drivers/net/ethernet/sfc/ef100_rep.c          |   4 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |   4 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |   8 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |   6 +-
 drivers/net/ethernet/sfc/efx.c                |  72 +-
 drivers/net/ethernet/sfc/efx_common.c         |  28 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  62 +-
 drivers/net/ethernet/sfc/falcon/efx.h         |   3 +
 drivers/net/ethernet/sfc/falcon/falcon.c      |   4 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   5 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |   4 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  15 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c   |   2 +-
 drivers/net/ethernet/sfc/net_driver.h         |   5 +-
 drivers/net/ethernet/sfc/rx.c                 |   2 +-
 drivers/net/ethernet/sfc/rx_common.c          |   5 +-
 drivers/net/ethernet/sfc/rx_common.h          |   4 +
 drivers/net/ethernet/sfc/siena/efx.c          |  56 +-
 drivers/net/ethernet/sfc/siena/efx.h          |   2 +
 drivers/net/ethernet/sfc/siena/efx_common.c   |  28 +-
 drivers/net/ethernet/sfc/siena/farch.c        |   2 +-
 .../net/ethernet/sfc/siena/mcdi_port_common.c |   2 +-
 drivers/net/ethernet/sfc/siena/net_driver.h   |   5 +-
 drivers/net/ethernet/sfc/siena/rx.c           |   2 +-
 drivers/net/ethernet/sfc/siena/rx_common.c    |   4 +-
 drivers/net/ethernet/sfc/siena/siena.c        |   3 +-
 drivers/net/ethernet/sfc/siena/tx_common.c    |   2 +-
 drivers/net/ethernet/sfc/tx_common.c          |   2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |  15 +-
 drivers/net/ethernet/silan/sc92031.c          |  11 +-
 drivers/net/ethernet/socionext/netsec.c       |  13 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   7 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  53 +-
 .../stmicro/stmmac/stmmac_selftests.c         |   4 +-
 drivers/net/ethernet/sun/cassini.c            |   9 +-
 drivers/net/ethernet/sun/ldmvsw.c             |   7 +-
 drivers/net/ethernet/sun/niu.c                |  16 +-
 drivers/net/ethernet/sun/sungem.c             |  13 +-
 drivers/net/ethernet/sun/sunhme.c             |  15 +-
 drivers/net/ethernet/sun/sunvnet.c            |  10 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |   4 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  27 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c |  14 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  30 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |   1 +
 drivers/net/ethernet/tehuti/tehuti.c          |  27 +-
 drivers/net/ethernet/tehuti/tehuti.h          |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  23 +-
 drivers/net/ethernet/ti/cpsw.c                |   7 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  11 +-
 drivers/net/ethernet/ti/netcp_core.c          |   6 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  13 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  11 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |   3 +-
 drivers/net/ethernet/via/via-rhine.c          |  11 +-
 drivers/net/ethernet/via/via-velocity.c       |  19 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   3 +-
 drivers/net/ethernet/wiznet/w5100.c           |   3 +-
 drivers/net/ethernet/wiznet/w5300.c           |   3 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |   6 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |   8 +-
 drivers/net/fjes/fjes_main.c                  |   3 +-
 drivers/net/geneve.c                          |  24 +-
 drivers/net/gtp.c                             |   2 +-
 drivers/net/hamradio/bpqether.c               |   4 +-
 drivers/net/hyperv/hyperv_net.h               |   5 +-
 drivers/net/hyperv/netvsc_bpf.c               |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |  32 +-
 drivers/net/hyperv/rndis_filter.c             |  27 +-
 drivers/net/ifb.c                             |  27 +-
 drivers/net/ipa/ipa_modem.c                   |   4 +-
 drivers/net/ipvlan/ipvlan_main.c              |  83 +-
 drivers/net/ipvlan/ipvtap.c                   |  12 +-
 drivers/net/loopback.c                        |  25 +-
 drivers/net/macsec.c                          |  41 +-
 drivers/net/macvlan.c                         |  88 ++-
 drivers/net/macvtap.c                         |  12 +-
 drivers/net/net_failover.c                    |  46 +-
 drivers/net/netdevsim/ipsec.c                 |  13 +-
 drivers/net/netdevsim/netdev.c                |  19 +-
 drivers/net/netdevsim/netdevsim.h             |   1 +
 drivers/net/nlmon.c                           |  11 +-
 drivers/net/ntb_netdev.c                      |   4 +-
 drivers/net/ppp/ppp_generic.c                 |   3 +-
 drivers/net/rionet.c                          |   4 +-
 drivers/net/tap.c                             |  40 +-
 drivers/net/team/team.c                       |  67 +-
 drivers/net/thunderbolt.c                     |  14 +-
 drivers/net/tun.c                             |  57 +-
 drivers/net/usb/aqc111.c                      |  62 +-
 drivers/net/usb/aqc111.h                      |  14 -
 drivers/net/usb/ax88179_178a.c                |  23 +-
 drivers/net/usb/cdc-phonet.c                  |   3 +-
 drivers/net/usb/cdc_mbim.c                    |   4 +-
 drivers/net/usb/lan78xx.c                     |  34 +-
 drivers/net/usb/r8152.c                       |  81 +-
 drivers/net/usb/smsc75xx.c                    |  18 +-
 drivers/net/usb/smsc95xx.c                    |  17 +-
 drivers/net/veth.c                            |  72 +-
 drivers/net/virtio_net.c                      |  59 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  82 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  93 ++-
 drivers/net/vmxnet3/vmxnet3_int.h             |   1 +
 drivers/net/vrf.c                             |  20 +-
 drivers/net/vsockmon.c                        |  11 +-
 drivers/net/vxlan/vxlan_core.c                |  24 +-
 drivers/net/wireguard/device.c                |  24 +-
 drivers/net/wireless/ath/ath10k/mac.c         |   7 +-
 drivers/net/wireless/ath/ath11k/mac.c         |   4 +-
 drivers/net/wireless/ath/ath6kl/core.h        |   1 +
 drivers/net/wireless/ath/ath6kl/main.c        |  16 +-
 drivers/net/wireless/ath/ath6kl/txrx.c        |   4 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |  16 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |   5 +-
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c |   2 +
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c |   4 +
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c |   3 +
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c |   7 +
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |   2 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |   8 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  15 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  33 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   8 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  28 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  11 +-
 .../net/wireless/mediatek/mt76/mt7615/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7915/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7921/init.c  |   4 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c           |  16 +-
 drivers/net/xen-netback/interface.c           |  27 +-
 drivers/net/xen-netfront.c                    |  42 +-
 drivers/s390/net/qeth_core_main.c             | 109 +--
 drivers/s390/net/qeth_l2_main.c               |  34 +-
 drivers/s390/net/qeth_l3_main.c               |  37 +-
 drivers/scsi/fcoe/fcoe.c                      |  12 +-
 drivers/staging/octeon/ethernet.c             |   9 +-
 drivers/staging/qlge/qlge_main.c              |  47 +-
 drivers/usb/gadget/function/f_phonet.c        |   3 +-
 include/linux/if_vlan.h                       |  14 +-
 include/linux/netdev_features.h               | 221 +++---
 include/linux/netdev_features_helper.h        | 742 ++++++++++++++++++
 include/linux/netdevice.h                     | 110 +--
 include/linux/skbuff.h                        |   4 +-
 include/net/bonding.h                         |   5 +-
 include/net/ip_tunnels.h                      |   2 +-
 include/net/net_failover.h                    |   8 +-
 include/net/pkt_cls.h                         |   2 +-
 include/net/sock.h                            |   5 +-
 include/net/udp.h                             |   7 +-
 include/net/udp_tunnel.h                      |   8 +-
 include/net/vxlan.h                           |   2 +-
 lib/test_bpf.c                                |  42 +-
 lib/vsprintf.c                                |  11 +-
 net/8021q/vlan.c                              |   6 +-
 net/8021q/vlan.h                              |  18 +-
 net/8021q/vlan_core.c                         |   4 +-
 net/8021q/vlan_dev.c                          |  42 +-
 net/batman-adv/soft-interface.c               |   9 +-
 net/bridge/br_device.c                        |  27 +-
 net/bridge/br_if.c                            |   2 +-
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                | 350 ++++++---
 net/core/netdev_features.c                    | 281 +++++++
 net/core/pktgen.c                             |   6 +-
 net/core/skbuff.c                             |  10 +-
 net/core/skmsg.c                              |   2 +-
 net/core/sock.c                               |  14 +-
 net/dccp/ipv4.c                               |   2 +-
 net/dccp/ipv6.c                               |   8 +-
 net/dsa/slave.c                               |  26 +-
 net/ethtool/features.c                        |  95 +--
 net/ethtool/ioctl.c                           | 133 ++--
 net/hsr/hsr_device.c                          |  21 +-
 net/hsr/hsr_forward.c                         |   8 +-
 net/hsr/hsr_framereg.c                        |   2 +-
 net/hsr/hsr_slave.c                           |   2 +-
 net/ieee802154/6lowpan/core.c                 |   3 +-
 net/ieee802154/core.c                         |  15 +-
 net/ipv4/af_inet.c                            |   4 +-
 net/ipv4/esp4_offload.c                       |  22 +-
 net/ipv4/gre_offload.c                        |   6 +-
 net/ipv4/ip_gre.c                             |  31 +-
 net/ipv4/ip_output.c                          |  19 +-
 net/ipv4/ip_tunnel.c                          |   3 +-
 net/ipv4/ip_vti.c                             |   3 +-
 net/ipv4/ipip.c                               |  21 +-
 net/ipv4/ipmr.c                               |   2 +-
 net/ipv4/tcp.c                                |   8 +-
 net/ipv4/tcp_ipv4.c                           |   2 +-
 net/ipv4/tcp_offload.c                        |   3 +-
 net/ipv4/udp_offload.c                        |  20 +-
 net/ipv6/af_inet6.c                           |   2 +-
 net/ipv6/esp6_offload.c                       |  16 +-
 net/ipv6/inet6_connection_sock.c              |   2 +-
 net/ipv6/ip6_gre.c                            |  21 +-
 net/ipv6/ip6_offload.c                        |   2 +-
 net/ipv6/ip6_output.c                         |  15 +-
 net/ipv6/ip6_tunnel.c                         |  23 +-
 net/ipv6/ip6mr.c                              |   3 +-
 net/ipv6/sit.c                                |  23 +-
 net/ipv6/tcp_ipv6.c                           |   2 +-
 net/ipv6/udp_offload.c                        |   2 +-
 net/l2tp/l2tp_eth.c                           |   2 +-
 net/mac80211/ieee80211_i.h                    |  13 +-
 net/mac80211/iface.c                          |   9 +-
 net/mac80211/main.c                           |  28 +-
 net/mac80211/tx.c                             |   2 +-
 net/mpls/mpls_gso.c                           |   3 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c         |   2 +-
 net/netfilter/nfnetlink_queue.c               |   2 +-
 net/nsh/nsh.c                                 |   5 +-
 net/openvswitch/datapath.c                    |   7 +-
 net/openvswitch/vport-internal_dev.c          |  21 +-
 net/phonet/pep-gprs.c                         |   4 +-
 net/sched/sch_cake.c                          |   2 +-
 net/sched/sch_netem.c                         |   2 +-
 net/sched/sch_taprio.c                        |   2 +-
 net/sched/sch_tbf.c                           |   3 +-
 net/sctp/offload.c                            |  12 +-
 net/sctp/output.c                             |   2 +-
 net/sunrpc/sunrpc.h                           |   2 +-
 net/tls/tls_device.c                          |   8 +-
 net/wireless/core.c                           |  15 +-
 net/xfrm/xfrm_device.c                        |  26 +-
 net/xfrm/xfrm_interface.c                     |  18 +-
 net/xfrm/xfrm_output.c                        |   5 +-
 481 files changed, 8116 insertions(+), 4331 deletions(-)
 create mode 100644 include/linux/netdev_features_helper.h
 create mode 100644 net/core/netdev_features.c

-- 
2.33.0

