Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117495BBCF3
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiIRJt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiIRJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:54 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A130FE016
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:48 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjf42GHhzHnkd;
        Sun, 18 Sep 2022 17:47:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:46 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 00/55] net: extend the type of netdev_features_t to bitmap
Date:   Sun, 18 Sep 2022 09:42:41 +0000
Message-ID: <20220918094336.28958-1-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
by some precompile dependency.[patch 55]

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
work(replacing the netdev features operator by helpers). To make the
semantic patches simple, I split the complex expressions of
netdev_features to simple logical operation. [patch 14~15]

For the prototype of netdev_features_t is no longer u64, so it's incorrect
to assigne 0 to it, use netdev_empty_features intead. [patch 16]

Some drivers defines macroes and functions wich use NETIF_F_XXX as
parameter. For all the macroes NETIF_F_XXX will be removed at last, so
change these macroes and functions to use NETIF_F_XXX_BIT. [patch 17~23]

With above preparation, then apply the semantic patches to do the
expression transition. For example,
replace expression "ndev->hw_features |= NETIF_F_TSO;" by
"netdev_hw_feature_set(ndev, NETIF_F_TSO_BIT)". [patch 24~35, 54]

For the prototype of netdev_features_t is larger than 8 bytes, so it's
not recommend to be passed direclty. There are many function in kernel
use netdev_features_t as parameter or return value, change the prototype
of these functions by using netdev_features_t *. [patch 36~53]

With the prototype is no longer u64, the implementation of print
interface for netdev features(%pNF) is changed to bitmap. [patch 55]

The former discussion please see [1][2][3][4][5][6].
[1]:https://www.spinics.net/lists/netdev/msg769952.html
[2]:https://www.spinics.net/lists/netdev/msg777764.html
[3]:https://www.spinics.net/lists/netdev/msg778921.html
[4]:https://www.spinics.net/lists/netdev/msg809293.html
[5]:https://www.spinics.net/lists/netdev/msg814349.html
[6]: https://www.spinics.net/lists/netdev/msg838709.html

ChangeLog:
V7->V8:
fix comments from Alexander Lobakin:
change the prototype of netdev_features_and and other similar helpers
reduce the using of netdev_emtpy_features
fix some typo issue
use netdev_features_set/clear_set to replace the definition of feature set
refine the build check for net_gso_ok()
change the prototype of functions using netdev_features_t
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

Jian Shen (55):
  net: introduce operation helpers for netdev features
  net: replace general features macroes with global netdev_features
    variables
  treewide: replace multiple feature bits with
    DECLARE_NETDEV_FEATURE_SET
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
  treewide: adjust the handle for netdev features '0'
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
  treewide: use netdev_features_andnot/clear helpers
  treewide: use netdev_features_xor helpers
  treewide: use netdev_feature_test helpers
  treewide: use netdev_features_intersects helpers
  treewide: use netdev_features_and/mask helpers
  treewide: use netdev_features_subset helpers
  treewide: use netdev_features_equal helpers
  treewide: use netdev_features_empty helpers
  net: adjust the prototype of netdev_increment_features()
  net: adjust the prototype of netdev_add_tso_features()
  net: core: adjust prototype of several functions used in
    net/core/dev.c
  net: adjust the prototype of netdev_intersect_features()
  net: adjust the prototype of netif_skb_features()
  net: adjust the prototype of xxx_features_check()
  net: adjust the prototype of ndo_fix_features
  net: adjust the prototype of xxx_set_features()
  net: adjust the prototype fo xxx_gso_segment() family
  net: vlan: adjust the prototype of vlan functions
  net: adjust the prototype of netif_needs_gso() and relative functions
  net: adjust the prototype of skb_needs_linearize()
  net: adjust the prototype of validate_xmit_xfrm() and relative
    functions
  net: adjust the prototype of can_checksum_protocol()
  net: tap: adjust the prototype of update_features()
  net: mlx4: adjust the prototype of check_csum() and
    mlx4_en_update_loopback_state()
  net: gve: adjust the prototype of gve_rx(), gve_clean_rx_done() and
    gve_rx_complete_skb()
  net: sfc: adjust the prototype of xxx_supported_features()
  treewide: use netdev_features_copy helpers
  net: redefine the prototype of netdev_features_t

 arch/um/drivers/vector_kern.c                 |  16 +-
 arch/um/drivers/vector_transports.c           |  32 +-
 drivers/firewire/net.c                        |   4 +-
 drivers/hsi/clients/ssi_protocol.c            |   2 +-
 drivers/infiniband/hw/hfi1/netdev.h           |   1 +
 drivers/infiniband/hw/hfi1/vnic_main.c        |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib.h          |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  19 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c    |   2 +-
 drivers/misc/sgi-xp/xpnet.c                   |   3 +-
 drivers/net/amt.c                             |  13 +-
 drivers/net/bareudp.c                         |  15 +-
 drivers/net/bonding/bond_main.c               | 143 ++--
 drivers/net/bonding/bond_options.c            |   8 +-
 drivers/net/caif/caif_serial.c                |   3 +-
 drivers/net/can/dev/dev.c                     |   4 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |  17 +-
 drivers/net/dummy.c                           |  14 +-
 drivers/net/ethernet/3com/3c59x.c             |  10 +-
 drivers/net/ethernet/3com/typhoon.c           |  31 +-
 drivers/net/ethernet/adaptec/starfire.c       |   9 +-
 drivers/net/ethernet/aeroflex/greth.c         |  12 +-
 drivers/net/ethernet/alacritech/slicoss.c     |   6 +-
 drivers/net/ethernet/alteon/acenic.c          |   9 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  10 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  47 +-
 drivers/net/ethernet/amd/amd8111e.c           |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c      |  14 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  81 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  57 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h          |   1 +
 drivers/net/ethernet/apm/xgene-v2/main.c      |   5 +-
 drivers/net/ethernet/apm/xgene-v2/main.h      |   1 +
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  19 +-
 .../ethernet/aquantia/atlantic/aq_filters.c   |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   2 +-
 .../ethernet/aquantia/atlantic/aq_macsec.c    |   2 +-
 .../ethernet/aquantia/atlantic/aq_macsec.h    |   1 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  92 ++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  23 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   8 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  17 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  15 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  29 +-
 drivers/net/ethernet/atheros/alx/main.c       |  20 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h    |   1 +
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  44 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h    |   1 +
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  59 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  21 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  39 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |  27 +-
 drivers/net/ethernet/broadcom/b44.c           |   3 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |  36 +-
 drivers/net/ethernet/broadcom/bgmac.c         |  10 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  52 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  60 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   5 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 101 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 157 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   4 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  17 +-
 drivers/net/ethernet/broadcom/tg3.c           |  68 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  45 +-
 drivers/net/ethernet/cadence/macb_main.c      |  90 ++-
 drivers/net/ethernet/calxeda/xgmac.c          |  23 +-
 .../net/ethernet/cavium/liquidio/lio_core.c   |   4 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   | 147 ++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 117 +--
 .../ethernet/cavium/liquidio/octeon_network.h |   4 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  52 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |   7 +-
 .../ethernet/cavium/thunder/nicvf_queues.h    |   2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  51 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c       |  10 +-
 drivers/net/ethernet/chelsio/cxgb/sge.h       |   2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  73 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |   8 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c   |  16 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 110 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.h |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |   8 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  56 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |   4 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c  |   2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   3 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  60 +-
 drivers/net/ethernet/cortina/gemini.c         |  28 +-
 drivers/net/ethernet/davicom/dm9000.c         |  23 +-
 drivers/net/ethernet/davicom/dm9051.c         |   2 +-
 drivers/net/ethernet/dnet.c                   |   3 +-
 drivers/net/ethernet/ec_bhf.c                 |   3 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  62 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |  16 +-
 drivers/net/ethernet/ethoc.c                  |   3 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  34 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  21 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  42 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   8 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  29 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  48 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  31 +-
 drivers/net/ethernet/freescale/fec_main.c     |  31 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |   2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  34 +-
 drivers/net/ethernet/freescale/gianfar.h      |   2 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  12 +-
 .../ethernet/fungible/funeth/funeth_ktls.c    |   4 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  47 +-
 .../net/ethernet/fungible/funeth/funeth_rx.c  |   4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   5 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  28 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |  10 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  11 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  52 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 107 +--
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |   4 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    | 104 ++-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |   4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  22 +-
 drivers/net/ethernet/ibm/emac/core.c          |   7 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  66 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  57 +-
 drivers/net/ethernet/intel/e100.c             |  25 +-
 drivers/net/ethernet/intel/e1000/e1000.h      |   1 +
 drivers/net/ethernet/intel/e1000/e1000_main.c |  85 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    | 108 +--
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   6 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  59 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  11 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  12 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 133 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   6 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   5 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 307 ++++----
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |   8 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 285 ++++---
 drivers/net/ethernet/intel/ice/ice_repr.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  11 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 158 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c     | 100 +--
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/igc/igc_mac.c      |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c     | 139 ++--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  46 +-
 .../net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c   |   2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |   7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 224 +++---
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |   6 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  16 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |   1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 111 +--
 drivers/net/ethernet/jme.c                    |  55 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  18 +-
 drivers/net/ethernet/marvell/mvneta.c         |  22 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  58 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   |   6 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  31 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   2 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  59 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   6 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  30 +-
 .../ethernet/marvell/prestera/prestera_main.c |   4 +-
 drivers/net/ethernet/marvell/skge.c           |  12 +-
 drivers/net/ethernet/marvell/sky2.c           |  81 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  80 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  12 +-
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c  |  11 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 181 ++---
 .../net/ethernet/mellanox/mlx4/en_resources.c |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  18 +-
 .../net/ethernet/mellanox/mlx4/en_selftest.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   8 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  16 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  16 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  10 +-
 .../mellanox/mlx5/core/en_accel/macsec.c      |   6 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 277 +++----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  22 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  24 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  40 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  13 +-
 drivers/net/ethernet/microchip/lan743x_main.c |  14 +-
 .../ethernet/microchip/lan966x/lan966x_fdma.c |   2 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   5 +-
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  17 +-
 drivers/net/ethernet/mscc/ocelot.c            |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  22 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  33 +-
 drivers/net/ethernet/natsemi/ns83820.c        |  11 +-
 drivers/net/ethernet/neterion/s2io.c          |  32 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |   8 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |   4 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  |   4 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 135 ++--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  69 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.c |   6 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.h |   3 +-
 drivers/net/ethernet/ni/nixge.c               |   4 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  74 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  15 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |   4 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |   6 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 114 +--
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   6 +-
 .../ethernet/qlogic/netxen/netxen_nic_init.c  |   4 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  47 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |  10 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |   3 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  20 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  21 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  67 +-
 drivers/net/ethernet/qlogic/qla3xxx.c         |   6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |   7 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  72 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  52 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |   4 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  28 +-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |   7 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  10 +-
 drivers/net/ethernet/realtek/8139cp.c         |  45 +-
 drivers/net/ethernet/realtek/8139too.c        |  28 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  91 +--
 drivers/net/ethernet/renesas/ravb.h           |   7 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  43 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  25 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |   7 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  21 +-
 drivers/net/ethernet/sfc/ef10.c               |  35 +-
 drivers/net/ethernet/sfc/ef100_netdev.c       |  11 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  31 +-
 drivers/net/ethernet/sfc/ef100_rep.c          |   4 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |   4 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |   8 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |   6 +-
 drivers/net/ethernet/sfc/efx.c                |  58 +-
 drivers/net/ethernet/sfc/efx_common.c         |  38 +-
 drivers/net/ethernet/sfc/efx_common.h         |   6 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  59 +-
 drivers/net/ethernet/sfc/falcon/efx.h         |   3 +
 drivers/net/ethernet/sfc/falcon/falcon.c      |   4 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   8 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |   4 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  17 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c   |   2 +-
 drivers/net/ethernet/sfc/net_driver.h         |   8 +-
 drivers/net/ethernet/sfc/rx.c                 |   2 +-
 drivers/net/ethernet/sfc/rx_common.c          |   4 +-
 drivers/net/ethernet/sfc/rx_common.h          |   4 +
 drivers/net/ethernet/sfc/siena/efx.c          |  46 +-
 drivers/net/ethernet/sfc/siena/efx.h          |   2 +
 drivers/net/ethernet/sfc/siena/efx_common.c   |  40 +-
 drivers/net/ethernet/sfc/siena/efx_common.h   |   7 +-
 drivers/net/ethernet/sfc/siena/farch.c        |   2 +-
 .../net/ethernet/sfc/siena/mcdi_port_common.c |   2 +-
 drivers/net/ethernet/sfc/siena/net_driver.h   |   8 +-
 drivers/net/ethernet/sfc/siena/rx.c           |   2 +-
 drivers/net/ethernet/sfc/siena/rx_common.c    |   4 +-
 drivers/net/ethernet/sfc/siena/siena.c        |   3 +-
 drivers/net/ethernet/sfc/siena/tx_common.c    |   4 +-
 drivers/net/ethernet/sfc/tx_common.c          |   4 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |  10 +-
 drivers/net/ethernet/silan/sc92031.c          |   7 +-
 drivers/net/ethernet/socionext/netsec.c       |  14 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   7 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  56 +-
 .../stmicro/stmmac/stmmac_selftests.c         |   4 +-
 drivers/net/ethernet/sun/cassini.c            |   6 +-
 drivers/net/ethernet/sun/ldmvsw.c             |   5 +-
 drivers/net/ethernet/sun/niu.c                |  12 +-
 drivers/net/ethernet/sun/sungem.c             |  11 +-
 drivers/net/ethernet/sun/sunhme.c             |  13 +-
 drivers/net/ethernet/sun/sunvnet.c            |   7 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |   5 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  29 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c |  14 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  34 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |   1 +
 drivers/net/ethernet/tehuti/tehuti.c          |  22 +-
 drivers/net/ethernet/tehuti/tehuti.h          |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  19 +-
 drivers/net/ethernet/ti/cpsw.c                |   7 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   9 +-
 drivers/net/ethernet/ti/netcp_core.c          |   8 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  13 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  11 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |   3 +-
 drivers/net/ethernet/via/via-rhine.c          |   8 +-
 drivers/net/ethernet/via/via-velocity.c       |  13 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |   3 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   3 +-
 drivers/net/ethernet/wiznet/w5100.c           |   3 +-
 drivers/net/ethernet/wiznet/w5300.c           |   3 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  39 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |   8 +-
 drivers/net/fjes/fjes_main.c                  |   3 +-
 drivers/net/geneve.c                          |  16 +-
 drivers/net/gtp.c                             |   2 +-
 drivers/net/hamradio/bpqether.c               |   4 +-
 drivers/net/hyperv/hyperv_net.h               |   6 +-
 drivers/net/hyperv/netvsc_bpf.c               |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |  62 +-
 drivers/net/hyperv/rndis_filter.c             |  27 +-
 drivers/net/ifb.c                             |  25 +-
 drivers/net/ipa/ipa_modem.c                   |   4 +-
 drivers/net/ipvlan/ipvlan_main.c              |  87 ++-
 drivers/net/ipvlan/ipvtap.c                   |  13 +-
 drivers/net/loopback.c                        |  22 +-
 drivers/net/macsec.c                          |  56 +-
 drivers/net/macvlan.c                         |  99 ++-
 drivers/net/macvtap.c                         |  13 +-
 drivers/net/net_failover.c                    |  76 +-
 drivers/net/netdevsim/ipsec.c                 |  12 +-
 drivers/net/netdevsim/netdev.c                |  16 +-
 drivers/net/netdevsim/netdevsim.h             |   1 +
 drivers/net/nlmon.c                           |   8 +-
 drivers/net/ntb_netdev.c                      |   6 +-
 drivers/net/ppp/ppp_generic.c                 |   2 +-
 drivers/net/rionet.c                          |   4 +-
 drivers/net/tap.c                             |  48 +-
 drivers/net/team/team.c                       |  97 ++-
 drivers/net/thunderbolt.c                     |  11 +-
 drivers/net/tun.c                             |  55 +-
 drivers/net/usb/aqc111.c                      |  65 +-
 drivers/net/usb/aqc111.h                      |  14 -
 drivers/net/usb/ax88179_178a.c                |  23 +-
 drivers/net/usb/cdc-phonet.c                  |   3 +-
 drivers/net/usb/cdc_mbim.c                    |   4 +-
 drivers/net/usb/lan78xx.c                     |  49 +-
 drivers/net/usb/r8152.c                       |  78 +-
 drivers/net/usb/smsc75xx.c                    |  18 +-
 drivers/net/usb/smsc95xx.c                    |  21 +-
 drivers/net/veth.c                            |  78 +-
 drivers/net/virtio_net.c                      |  62 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  76 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 108 ++-
 drivers/net/vmxnet3/vmxnet3_int.h             |  12 +-
 drivers/net/vrf.c                             |  22 +-
 drivers/net/vsockmon.c                        |   7 +-
 drivers/net/vxlan/vxlan_core.c                |  18 +-
 drivers/net/wireguard/device.c                |  22 +-
 drivers/net/wireless/ath/ath10k/mac.c         |   8 +-
 drivers/net/wireless/ath/ath11k/mac.c         |   5 +-
 drivers/net/wireless/ath/ath6kl/core.h        |   1 +
 drivers/net/wireless/ath/ath6kl/main.c        |  15 +-
 drivers/net/wireless/ath/ath6kl/txrx.c        |   4 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |  11 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |   4 +-
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
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  30 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   8 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  23 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  20 +-
 .../net/wireless/mediatek/mt76/mt7615/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7915/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7921/init.c  |   4 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c           |  16 +-
 drivers/net/xen-netback/interface.c           |  27 +-
 drivers/net/xen-netfront.c                    |  48 +-
 drivers/s390/block/dasd_devmap.c              |   2 +-
 drivers/s390/net/qeth_core.h                  |   9 +-
 drivers/s390/net/qeth_core_main.c             | 132 ++--
 drivers/s390/net/qeth_l2_main.c               |  34 +-
 drivers/s390/net/qeth_l3_main.c               |  44 +-
 drivers/scsi/fcoe/fcoe.c                      |  12 +-
 drivers/staging/octeon/ethernet.c             |   6 +-
 drivers/staging/qlge/qlge_main.c              |  58 +-
 drivers/usb/gadget/function/f_phonet.c        |   3 +-
 include/linux/if_tap.h                        |   3 +-
 include/linux/if_vlan.h                       |  27 +-
 include/linux/netdev_feature_helpers.h        | 724 ++++++++++++++++++
 include/linux/netdev_features.h               | 178 ++---
 include/linux/netdevice.h                     | 175 +++--
 include/linux/skbuff.h                        |  79 +-
 include/linux/tcp.h                           |   1 +
 include/net/bonding.h                         |   5 +-
 include/net/inet_common.h                     |   2 +-
 include/net/ip_tunnels.h                      |   3 +-
 include/net/net_failover.h                    |   8 +-
 include/net/pkt_cls.h                         |   2 +-
 include/net/sock.h                            |   7 +-
 include/net/tcp.h                             |   2 +-
 include/net/udp.h                             |  13 +-
 include/net/udp_tunnel.h                      |   8 +-
 include/net/vxlan.h                           |  16 +-
 include/net/xfrm.h                            |  11 +-
 lib/test_bpf.c                                |  37 +-
 lib/vsprintf.c                                |   9 +-
 net/8021q/vlan.c                              |  10 +-
 net/8021q/vlan.h                              |  24 +-
 net/8021q/vlan_core.c                         |   4 +-
 net/8021q/vlan_dev.c                          |  55 +-
 net/batman-adv/soft-interface.c               |   6 +-
 net/bridge/br_device.c                        |  26 +-
 net/bridge/br_if.c                            |  17 +-
 net/bridge/br_private.h                       |   3 +-
 net/core/Makefile                             |   2 +-
 net/core/dev.c                                | 411 +++++-----
 net/core/dev.h                                |   2 +
 net/core/gro.c                                |   5 +-
 net/core/netdev_features.c                    | 226 ++++++
 net/core/netpoll.c                            |   4 +-
 net/core/pktgen.c                             |   6 +-
 net/core/skbuff.c                             |  22 +-
 net/core/skmsg.c                              |   2 +-
 net/core/sock.c                               |  16 +-
 net/dccp/ipv4.c                               |   2 +-
 net/dccp/ipv6.c                               |   8 +-
 net/dsa/slave.c                               |  25 +-
 net/ethtool/common.h                          |   1 +
 net/ethtool/features.c                        | 126 ++-
 net/ethtool/ioctl.c                           | 136 ++--
 net/hsr/hsr_device.c                          |  37 +-
 net/hsr/hsr_forward.c                         |   8 +-
 net/hsr/hsr_framereg.c                        |   2 +-
 net/hsr/hsr_slave.c                           |   2 +-
 net/ieee802154/6lowpan/core.c                 |   2 +-
 net/ieee802154/core.c                         |  15 +-
 net/ipv4/af_inet.c                            |  13 +-
 net/ipv4/esp4_offload.c                       |  42 +-
 net/ipv4/gre_offload.c                        |  12 +-
 net/ipv4/ip_gre.c                             |  31 +-
 net/ipv4/ip_output.c                          |  24 +-
 net/ipv4/ip_tunnel.c                          |   3 +-
 net/ipv4/ip_vti.c                             |   2 +-
 net/ipv4/ipip.c                               |  20 +-
 net/ipv4/ipmr.c                               |   2 +-
 net/ipv4/tcp.c                                |  10 +-
 net/ipv4/tcp_ipv4.c                           |   2 +-
 net/ipv4/tcp_offload.c                        |  11 +-
 net/ipv4/udp_offload.c                        |  47 +-
 net/ipv6/af_inet6.c                           |   2 +-
 net/ipv6/esp6_offload.c                       |  36 +-
 net/ipv6/inet6_connection_sock.c              |   2 +-
 net/ipv6/ip6_gre.c                            |  23 +-
 net/ipv6/ip6_offload.c                        |  14 +-
 net/ipv6/ip6_output.c                         |  20 +-
 net/ipv6/ip6_tunnel.c                         |  22 +-
 net/ipv6/ip6mr.c                              |   2 +-
 net/ipv6/sit.c                                |  22 +-
 net/ipv6/tcp_ipv6.c                           |   2 +-
 net/ipv6/tcpv6_offload.c                      |   2 +-
 net/ipv6/udp_offload.c                        |  13 +-
 net/l2tp/l2tp_eth.c                           |   2 +-
 net/mac80211/ieee80211_i.h                    |  13 +-
 net/mac80211/iface.c                          |   9 +-
 net/mac80211/main.c                           |  24 +-
 net/mac80211/tx.c                             |   4 +-
 net/mpls/mpls_gso.c                           |   7 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c         |   3 +-
 net/netfilter/nfnetlink_queue.c               |   5 +-
 net/nsh/nsh.c                                 |  10 +-
 net/openvswitch/datapath.c                    |  10 +-
 net/openvswitch/vport-internal_dev.c          |  22 +-
 net/phonet/pep-gprs.c                         |   4 +-
 net/sched/sch_cake.c                          |   6 +-
 net/sched/sch_netem.c                         |   6 +-
 net/sched/sch_taprio.c                        |   6 +-
 net/sched/sch_tbf.c                           |   7 +-
 net/sctp/offload.c                            |  13 +-
 net/sctp/output.c                             |   2 +-
 net/sunrpc/sunrpc.h                           |   2 +-
 net/tls/tls_device.c                          |   8 +-
 net/wireless/core.c                           |  15 +-
 net/xfrm/xfrm_device.c                        |  40 +-
 net/xfrm/xfrm_interface.c                     |  16 +-
 net/xfrm/xfrm_output.c                        |   9 +-
 508 files changed, 8214 insertions(+), 5558 deletions(-)
 create mode 100644 include/linux/netdev_feature_helpers.h
 create mode 100644 net/core/netdev_features.c

-- 
2.33.0

