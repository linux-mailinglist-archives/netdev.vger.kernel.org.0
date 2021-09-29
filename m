Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D2841C995
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346180AbhI2QGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:50 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23251 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345588AbhI2QBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:01:21 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLc95hHyz8tTV;
        Wed, 29 Sep 2021 23:57:29 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:22 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:21 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 167/167] net: extend the type of netdev_features_t to bitmap
Date:   Wed, 29 Sep 2021 23:53:34 +0800
Message-ID: <20210929155334.12454-168-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extend the type of netdev_features_t to bitmap,
so it can support more than 64 bits. Changes the typedef of
netdev_features_t to unsigned long *, and use the macro
__DECLARE_NETDEV_FEATURE_MASK to declare a netdev feature
bitmap.

Then rewrite all the netdev_feature_xxx helpers with the new
prototype. For the "netdev_features_t" is "unsigned long *"
now, it's unnecessary to use "netdev_features_t *" in these
helpers. So removes them, and modify the codes which call them.
So does the functions prototype mentioned in the first 23
patches. With these changes, we can keep the behaviour consitent
with linkmode_xxx helpers.

It also changes the implement for ethtool set/get features. It's
unnecessary to convert netdev features to bitmap, and vice versa.

For the type of netdev_features_t is bitmap now, so use %*pb to
print the features, rather than %pNF.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  10 +-
 drivers/firewire/net.c                        |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  10 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c    |   2 +-
 drivers/net/bareudp.c                         |  14 +-
 drivers/net/bonding/bond_main.c               |  74 +++----
 drivers/net/bonding/bond_options.c            |   8 +-
 drivers/net/caif/caif_serial.c                |   2 +-
 drivers/net/can/dev/dev.c                     |   4 +-
 drivers/net/can/slcan.c                       |   4 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |   4 +-
 drivers/net/dummy.c                           |  12 +-
 drivers/net/ethernet/3com/3c59x.c             |   2 +-
 drivers/net/ethernet/3com/typhoon.c           |   8 +-
 drivers/net/ethernet/adaptec/starfire.c       |   6 +-
 drivers/net/ethernet/aeroflex/greth.c         |   8 +-
 drivers/net/ethernet/alacritech/slicoss.c     |   6 +-
 drivers/net/ethernet/alteon/acenic.c          |   6 +-
 drivers/net/ethernet/altera/altera_tse_main.c |   8 +-
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |   2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  30 ++-
 drivers/net/ethernet/amd/amd8111e.c           |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  24 +--
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  18 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |   4 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |   6 +-
 .../ethernet/aquantia/atlantic/aq_macsec.c    |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  16 +-
 drivers/net/ethernet/atheros/alx/main.c       |   6 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  14 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  16 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |  14 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  12 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |   6 +-
 drivers/net/ethernet/broadcom/b44.c           |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c    |   6 +-
 drivers/net/ethernet/broadcom/bgmac.c         |   8 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  27 ++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  20 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  40 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  66 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |   6 +-
 drivers/net/ethernet/broadcom/tg3.c           |  32 +--
 drivers/net/ethernet/brocade/bna/bnad.c       |  16 +-
 drivers/net/ethernet/cadence/macb_main.c      |  20 +-
 drivers/net/ethernet/calxeda/xgmac.c          |   8 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |  38 ++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  38 ++--
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  20 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  20 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  26 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c   |  16 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  34 +--
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  18 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c      |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  26 +--
 drivers/net/ethernet/cortina/gemini.c         |   8 +-
 drivers/net/ethernet/davicom/dm9000.c         |   8 +-
 drivers/net/ethernet/dnet.c                   |   2 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  18 +-
 drivers/net/ethernet/ethoc.c                  |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  14 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  12 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  10 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  16 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  10 +-
 drivers/net/ethernet/freescale/fec_main.c     |  12 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |   2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  10 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |   4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  26 +--
 drivers/net/ethernet/google/gve/gve_rx.c      |   2 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |   8 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  16 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  36 ++--
 .../net/ethernet/huawei/hinic/hinic_main.c    |  34 +--
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  12 +-
 drivers/net/ethernet/ibm/emac/core.c          |   8 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  38 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  36 ++--
 drivers/net/ethernet/intel/e100.c             |  10 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  28 +--
 drivers/net/ethernet/intel/e1000e/netdev.c    |  38 ++--
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   2 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  19 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  36 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  48 ++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  46 ++--
 drivers/net/ethernet/intel/igb/igb_main.c     |  42 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  28 +--
 drivers/net/ethernet/intel/igc/igc_main.c     |  52 ++---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  20 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  60 +++---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   4 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  30 +--
 drivers/net/ethernet/jme.c                    |  14 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  10 +-
 drivers/net/ethernet/marvell/mvneta.c         |  10 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  42 ++--
 .../marvell/octeontx2/nic/otx2_common.c       |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  26 +--
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  18 +-
 .../ethernet/marvell/prestera/prestera_main.c |   2 +-
 drivers/net/ethernet/marvell/skge.c           |   6 +-
 drivers/net/ethernet/marvell/sky2.c           |  29 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  18 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  66 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  16 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   4 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  11 +-
 .../mellanox/mlx5/core/en_accel/tls.c         |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 120 +++++------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  26 +--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  18 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  14 +-
 drivers/net/ethernet/micrel/ksz884x.c         |   8 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   6 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  14 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   6 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  20 +-
 drivers/net/ethernet/natsemi/ns83820.c        |   8 +-
 drivers/net/ethernet/neterion/s2io.c          |  14 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |  18 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |   8 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  44 ++--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  52 ++---
 drivers/net/ethernet/ni/nixge.c               |   4 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  16 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |   8 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |   4 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c      |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  50 ++---
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  22 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |   4 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |   2 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  10 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  34 +--
 drivers/net/ethernet/qlogic/qla3xxx.c         |   4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  16 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  28 +--
 drivers/net/ethernet/qualcomm/emac/emac.c     |  12 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  10 +-
 drivers/net/ethernet/realtek/8139cp.c         |  16 +-
 drivers/net/ethernet/realtek/8139too.c        |  10 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  30 +--
 drivers/net/ethernet/renesas/ravb_main.c      |  12 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  14 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   2 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  10 +-
 drivers/net/ethernet/sfc/ef10.c               |  18 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  20 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |   4 +-
 drivers/net/ethernet/sfc/efx.c                |  20 +-
 drivers/net/ethernet/sfc/efx_common.c         |  16 +-
 drivers/net/ethernet/sfc/efx_common.h         |   2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  26 ++-
 drivers/net/ethernet/sfc/falcon/net_driver.h  |   2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |   8 +-
 drivers/net/ethernet/sfc/net_driver.h         |   2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           |   8 +-
 drivers/net/ethernet/silan/sc92031.c          |   4 +-
 drivers/net/ethernet/socionext/netsec.c       |   4 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  32 +--
 drivers/net/ethernet/sun/cassini.c            |   4 +-
 drivers/net/ethernet/sun/ldmvsw.c             |   6 +-
 drivers/net/ethernet/sun/niu.c                |  10 +-
 drivers/net/ethernet/sun/sungem.c             |   8 +-
 drivers/net/ethernet/sun/sunhme.c             |  16 +-
 drivers/net/ethernet/sun/sunvnet.c            |   6 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |   4 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  36 ++--
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |   2 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  12 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  12 +-
 drivers/net/ethernet/ti/cpsw.c                |   4 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   2 +-
 drivers/net/ethernet/ti/netcp_core.c          |   8 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  12 +-
 drivers/net/ethernet/toshiba/spider_net.c     |   8 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |   4 +-
 drivers/net/ethernet/via/via-rhine.c          |   4 +-
 drivers/net/ethernet/via/via-velocity.c       |   6 +-
 drivers/net/ethernet/wiznet/w5100.c           |   2 +-
 drivers/net/ethernet/wiznet/w5300.c           |   2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |   6 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |   8 +-
 drivers/net/fjes/fjes_main.c                  |   2 +-
 drivers/net/geneve.c                          |  14 +-
 drivers/net/gtp.c                             |   2 +-
 drivers/net/hamradio/bpqether.c               |   4 +-
 drivers/net/hyperv/netvsc_drv.c               |  24 +--
 drivers/net/hyperv/rndis_filter.c             |  26 +--
 drivers/net/ifb.c                             |   8 +-
 drivers/net/ipa/ipa_modem.c                   |   4 +-
 drivers/net/ipvlan/ipvlan_main.c              |  30 +--
 drivers/net/ipvlan/ipvtap.c                   |   6 +-
 drivers/net/loopback.c                        |   8 +-
 drivers/net/macsec.c                          |  20 +-
 drivers/net/macvlan.c                         |  46 ++--
 drivers/net/macvtap.c                         |   6 +-
 drivers/net/net_failover.c                    |  40 ++--
 drivers/net/netdevsim/ipsec.c                 |   4 +-
 drivers/net/netdevsim/netdev.c                |   4 +-
 drivers/net/nlmon.c                           |   4 +-
 drivers/net/ntb_netdev.c                      |   6 +-
 drivers/net/ppp/ppp_generic.c                 |   2 +-
 drivers/net/rionet.c                          |   4 +-
 drivers/net/tap.c                             |  24 +--
 drivers/net/team/team.c                       |  46 ++--
 drivers/net/thunderbolt.c                     |   8 +-
 drivers/net/tun.c                             |  34 +--
 drivers/net/usb/aqc111.c                      |  14 +-
 drivers/net/usb/ax88179_178a.c                |  10 +-
 drivers/net/usb/cdc-phonet.c                  |   2 +-
 drivers/net/usb/cdc_mbim.c                    |   2 +-
 drivers/net/usb/lan78xx.c                     |  16 +-
 drivers/net/usb/r8152.c                       |  22 +-
 drivers/net/usb/smsc75xx.c                    |   6 +-
 drivers/net/usb/smsc95xx.c                    |   8 +-
 drivers/net/veth.c                            |  34 +--
 drivers/net/virtio_net.c                      |  34 +--
 drivers/net/vmxnet3/vmxnet3_drv.c             |  24 +--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  12 +-
 drivers/net/vmxnet3/vmxnet3_int.h             |   4 +-
 drivers/net/vrf.c                             |  16 +-
 drivers/net/vsockmon.c                        |   4 +-
 drivers/net/vxlan.c                           |  16 +-
 drivers/net/wireguard/device.c                |   8 +-
 drivers/net/wireless/ath/ath10k/mac.c         |   4 +-
 drivers/net/wireless/ath/ath11k/mac.c         |   4 +-
 drivers/net/wireless/ath/ath6kl/main.c        |  10 +-
 drivers/net/wireless/ath/wil6210/netdev.c     |   6 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |   4 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt7615/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7915/init.c  |   4 +-
 .../net/wireless/mediatek/mt76/mt7921/init.c  |   4 +-
 drivers/net/xen-netback/interface.c           |  10 +-
 drivers/net/xen-netfront.c                    |  22 +-
 drivers/s390/net/qeth_core_main.c             |  66 +++---
 drivers/s390/net/qeth_l2_main.c               |  28 +--
 drivers/s390/net/qeth_l3_main.c               |  16 +-
 drivers/staging/octeon/ethernet.c             |   4 +-
 drivers/staging/qlge/qlge_main.c              |  16 +-
 drivers/usb/gadget/function/f_phonet.c        |   2 +-
 include/linux/if_vlan.h                       |   2 +-
 include/linux/netdev_features.h               | 147 +++++++------
 include/linux/netdevice.h                     |  34 +--
 include/net/sock.h                            |   8 +-
 include/net/udp.h                             |   6 +-
 include/net/vxlan.h                           |   4 +-
 lib/test_bpf.c                                |   4 +-
 lib/vsprintf.c                                |   4 +-
 net/8021q/vlan.c                              |   2 +-
 net/8021q/vlan.h                              |   8 +-
 net/8021q/vlan_dev.c                          |  34 +--
 net/batman-adv/soft-interface.c               |   4 +-
 net/bridge/br_device.c                        |  14 +-
 net/bridge/br_if.c                            |   6 +-
 net/bridge/br_private.h                       |   2 +-
 net/core/dev.c                                | 200 +++++++++---------
 net/core/netpoll.c                            |   2 +-
 net/core/skbuff.c                             |   2 +-
 net/core/sock.c                               |  10 +-
 net/dccp/ipv4.c                               |   2 +-
 net/dccp/ipv6.c                               |   6 +-
 net/decnet/af_decnet.c                        |   2 +-
 net/decnet/dn_nsp_out.c                       |   2 +-
 net/dsa/slave.c                               |  20 +-
 net/ethtool/features.c                        |  92 +++-----
 net/ethtool/ioctl.c                           | 140 +++++++-----
 net/hsr/hsr_device.c                          |  20 +-
 net/ieee802154/6lowpan/core.c                 |   2 +-
 net/ieee802154/core.c                         |  10 +-
 net/ipv4/af_inet.c                            |   4 +-
 net/ipv4/esp4_offload.c                       |   6 +-
 net/ipv4/gre_offload.c                        |   4 +-
 net/ipv4/ip_gre.c                             |  28 +--
 net/ipv4/ip_output.c                          |   4 +-
 net/ipv4/ip_tunnel.c                          |   2 +-
 net/ipv4/ip_vti.c                             |   2 +-
 net/ipv4/ipip.c                               |   6 +-
 net/ipv4/ipmr.c                               |   2 +-
 net/ipv4/tcp.c                                |   6 +-
 net/ipv4/tcp_ipv4.c                           |   2 +-
 net/ipv4/tcp_offload.c                        |   4 +-
 net/ipv4/udp_offload.c                        |  10 +-
 net/ipv6/af_inet6.c                           |   2 +-
 net/ipv6/esp6_offload.c                       |   6 +-
 net/ipv6/inet6_connection_sock.c              |   2 +-
 net/ipv6/ip6_gre.c                            |  14 +-
 net/ipv6/ip6_offload.c                        |   2 +-
 net/ipv6/ip6_output.c                         |   4 +-
 net/ipv6/ip6_tunnel.c                         |   8 +-
 net/ipv6/ip6mr.c                              |   2 +-
 net/ipv6/sit.c                                |   8 +-
 net/ipv6/tcp_ipv6.c                           |   2 +-
 net/ipv6/udp_offload.c                        |   2 +-
 net/l2tp/l2tp_eth.c                           |   2 +-
 net/mac80211/iface.c                          |   8 +-
 net/mac80211/main.c                           |   4 +-
 net/mpls/mpls_gso.c                           |   2 +-
 net/nsh/nsh.c                                 |   2 +-
 net/openvswitch/datapath.c                    |   4 +-
 net/openvswitch/vport-internal_dev.c          |  16 +-
 net/phonet/pep-gprs.c                         |   4 +-
 net/sched/sch_cake.c                          |   4 +-
 net/sched/sch_netem.c                         |   4 +-
 net/sched/sch_taprio.c                        |   4 +-
 net/sched/sch_tbf.c                           |   4 +-
 net/sctp/offload.c                            |  10 +-
 net/wireless/core.c                           |  11 +-
 net/xfrm/xfrm_device.c                        |  12 +-
 net/xfrm/xfrm_interface.c                     |   6 +-
 333 files changed, 2453 insertions(+), 2447 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 2c32794a87b1..54d0c14d1df8 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1343,10 +1343,10 @@ static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
 }
 
 static void vector_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				  &features);
+				  features);
 }
 
 static int vector_set_features(struct net_device *dev,
@@ -1631,10 +1631,10 @@ static void vector_eth_configure(
 		.bpf			= NULL
 	});
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST,
-				&dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+				dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 	tasklet_setup(&vp->tx_poll, vector_tx_poll);
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 29f83b37f9ec..a2d3de88682b 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1383,8 +1383,8 @@ static void fwnet_init_dev(struct net_device *net)
 	net->netdev_ops		= &fwnet_netdev_ops;
 	net->watchdog_timeo	= 2 * HZ;
 	net->flags		= IFF_BROADCAST | IFF_MULTICAST;
-	netdev_feature_zero(&net->features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &net->features);
+	netdev_feature_zero(net->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, net->features);
 	net->addr_len		= FWNET_ALEN;
 	net->hard_header_len	= FWNET_HLEN;
 	net->type		= ARPHRD_IEEE1394;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5fd0b7a1bcb9..f49f7a56475e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -215,7 +215,7 @@ static int ipoib_stop(struct net_device *dev)
 }
 
 static void ipoib_fix_features(struct net_device *dev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
@@ -1851,13 +1851,13 @@ static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
-					&priv->dev->hw_features);
+					priv->dev->hw_features);
 
 		if (priv->hca_caps & IB_DEVICE_UD_TSO)
 			netdev_feature_set_bit(NETIF_F_TSO_BIT,
-					       &priv->dev->hw_features);
+					       priv->dev->hw_features);
 
-		netdev_feature_or(&priv->dev->features, priv->dev->features,
+		netdev_feature_or(priv->dev->features, priv->dev->features,
 				  priv->dev->hw_features);
 	}
 }
@@ -2122,7 +2122,7 @@ void ipoib_setup_common(struct net_device *dev)
 	dev->type		 = ARPHRD_INFINIBAND;
 	dev->tx_queue_len	 = ipoib_sendq_size * 2;
 	netdev_feature_set_bits(NETIF_F_VLAN_CHALLENGED	|
-				NETIF_F_HIGHDMA, &dev->features);
+				NETIF_F_HIGHDMA, dev->features);
 	netif_keep_dst(dev);
 
 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index d0437c302ef4..48e4be71c497 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -234,7 +234,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->rx_wr.sg_list = priv->rx_sge;
 
 	if (init_attr.cap.max_send_sge > 1)
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, dev->features);
 
 	priv->max_send_sge = init_attr.cap.max_send_sge;
 
diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 88be2288a78c..63ac30b2e083 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -535,14 +535,14 @@ static void bareudp_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &bareudp_type);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
-				&dev->features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+				dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
-				&dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->hw_features);
+				dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->hw_features);
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
 	dev->mtu = ETH_DATA_LEN;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6e64ad75b847..ef49adec2f69 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1362,7 +1362,7 @@ static void bond_netpoll_cleanup(struct net_device *bond_dev)
 /*---------------------------------- IOCTL ----------------------------------*/
 
 static void bond_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	struct bonding *bond = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(mask);
@@ -1376,13 +1376,13 @@ static void bond_fix_features(struct net_device *dev,
 		netdev_feature_clear_bits(BOND_TLS_FEATURES, features);
 #endif
 
-	netdev_feature_copy(&mask, *features);
+	netdev_feature_copy(mask, features);
 
 	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
 	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
 
 	bond_for_each_slave(bond, slave, iter) {
-		netdev_increment_features(features, *features,
+		netdev_increment_features(features, features,
 					  slave->dev->features, mask);
 	}
 	netdev_add_tso_features(features, mask);
@@ -1420,42 +1420,42 @@ static void bond_compute_features(struct bonding *bond)
 	unsigned int gso_max_size = GSO_MAX_SIZE;
 	u16 gso_max_segs = GSO_MAX_SEGS;
 
-	netdev_feature_zero(&vlan_features);
-	netdev_feature_set_bits(BOND_VLAN_FEATURES, &vlan_features);
-	netdev_feature_copy(&vlan_mask, vlan_features);
-	netdev_feature_zero(&enc_features);
-	netdev_feature_set_bits(BOND_ENC_FEATURES, &enc_features);
-	netdev_feature_copy(&enc_mask, enc_features);
+	netdev_feature_zero(vlan_features);
+	netdev_feature_set_bits(BOND_VLAN_FEATURES, vlan_features);
+	netdev_feature_copy(vlan_mask, vlan_features);
+	netdev_feature_zero(enc_features);
+	netdev_feature_set_bits(BOND_ENC_FEATURES, enc_features);
+	netdev_feature_copy(enc_mask, enc_features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	netdev_feature_zero(&xfrm_features);
-	netdev_feature_set_bits(BOND_XFRM_FEATURES, &xfrm_features);
-	netdev_feature_copy(&xfrm_mask, xfrm_features);
+	netdev_feature_zero(xfrm_features);
+	netdev_feature_set_bits(BOND_XFRM_FEATURES, xfrm_features);
+	netdev_feature_copy(xfrm_mask, xfrm_features);
 #endif /* CONFIG_XFRM_OFFLOAD */
-	netdev_feature_zero(&mpls_features);
-	netdev_feature_set_bits(BOND_MPLS_FEATURES, &mpls_features);
-	netdev_feature_copy(&mpls_mask, mpls_features);
+	netdev_feature_zero(mpls_features);
+	netdev_feature_set_bits(BOND_MPLS_FEATURES, mpls_features);
+	netdev_feature_copy(mpls_mask, mpls_features);
 
 	if (!bond_has_slaves(bond))
 		goto done;
-	netdev_feature_and_bits(NETIF_F_ALL_FOR_ALL, &vlan_features);
-	netdev_feature_and_bits(NETIF_F_ALL_FOR_ALL, &mpls_features);
+	netdev_feature_and_bits(NETIF_F_ALL_FOR_ALL, vlan_features);
+	netdev_feature_and_bits(NETIF_F_ALL_FOR_ALL, mpls_features);
 
 	bond_for_each_slave(bond, slave, iter) {
-		netdev_increment_features(&vlan_features, vlan_features,
+		netdev_increment_features(vlan_features, vlan_features,
 					  slave->dev->vlan_features,
 					  vlan_mask);
 
-		netdev_increment_features(&enc_features, enc_features,
+		netdev_increment_features(enc_features, enc_features,
 					  slave->dev->hw_enc_features,
 					  enc_mask);
 
 #ifdef CONFIG_XFRM_OFFLOAD
-		netdev_increment_features(&xfrm_features, xfrm_features,
+		netdev_increment_features(xfrm_features, xfrm_features,
 					  slave->dev->hw_enc_features,
 					  xfrm_mask);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
-		netdev_increment_features(&mpls_features, mpls_features,
+		netdev_increment_features(mpls_features, mpls_features,
 					  slave->dev->mpls_features,
 					  mpls_mask);
 
@@ -1469,16 +1469,16 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->hard_header_len = max_hard_header_len;
 
 done:
-	netdev_feature_copy(&bond_dev->vlan_features, vlan_features);
-	netdev_feature_copy(&bond_dev->hw_enc_features, enc_features);
+	netdev_feature_copy(bond_dev->vlan_features, vlan_features);
+	netdev_feature_copy(bond_dev->hw_enc_features, enc_features);
 	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL |
 				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX, &mpls_features);
+				NETIF_F_HW_VLAN_STAG_TX, mpls_features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	netdev_feature_or(&bond_dev->hw_enc_features, bond_dev->hw_enc_features,
+	netdev_feature_or(bond_dev->hw_enc_features, bond_dev->hw_enc_features,
 			  xfrm_features);
 #endif /* CONFIG_XFRM_OFFLOAD */
-	netdev_feature_copy(&bond_dev->mpls_features, mpls_features);
+	netdev_feature_copy(bond_dev->mpls_features, mpls_features);
 	bond_dev->gso_max_segs = gso_max_segs;
 	netif_set_gso_max_size(bond_dev, gso_max_size);
 
@@ -2309,7 +2309,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	struct sockaddr_storage ss;
 	int old_flags = bond_dev->flags;
 
-	netdev_feature_copy(&old_features, bond_dev->features);
+	netdev_feature_copy(old_features, bond_dev->features);
 	/* slave is not a slave or master is not master of this slave */
 	if (!(slave_dev->flags & IFF_SLAVE) ||
 	    !netdev_has_upper_dev(slave_dev, bond_dev)) {
@@ -5430,7 +5430,7 @@ void bond_setup(struct net_device *bond_dev)
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't acquire bond device's netif_tx_lock when transmitting */
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &bond_dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, bond_dev->features);
 
 	/* By default, we declare the bond to be fully
 	 * VLAN hardware accelerated capable. Special
@@ -5440,30 +5440,30 @@ void bond_setup(struct net_device *bond_dev)
 	 */
 
 	/* Don't allow bond devices to change network namespaces. */
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &bond_dev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, bond_dev->features);
 
-	netdev_feature_zero(&bond_dev->hw_features);
+	netdev_feature_zero(bond_dev->hw_features);
 	netdev_feature_set_bits(BOND_VLAN_FEATURES |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&bond_dev->hw_features);
+				bond_dev->hw_features);
 
-	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &bond_dev->hw_features);
-	netdev_feature_or(&bond_dev->features, bond_dev->features,
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, bond_dev->hw_features);
+	netdev_feature_or(bond_dev->features, bond_dev->features,
 			  bond_dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX,
-				&bond_dev->features);
+				bond_dev->features);
 #ifdef CONFIG_XFRM_OFFLOAD
-	netdev_feature_set_bits(BOND_XFRM_FEATURES, &bond_dev->hw_features);
+	netdev_feature_set_bits(BOND_XFRM_FEATURES, bond_dev->hw_features);
 	/* Only enable XFRM features if this is an active-backup config */
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		netdev_feature_set_bits(BOND_XFRM_FEATURES,
-					&bond_dev->features);
+					bond_dev->features);
 #endif /* CONFIG_XFRM_OFFLOAD */
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		netdev_feature_set_bits(BOND_TLS_FEATURES, &bond_dev->features);
+		netdev_feature_set_bits(BOND_TLS_FEATURES, bond_dev->features);
 #endif
 }
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index b0c3a28c2448..bc36053df6ea 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -779,10 +779,10 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		netdev_feature_set_bits(BOND_XFRM_FEATURES,
-					&bond->dev->wanted_features);
+					bond->dev->wanted_features);
 	else
 		netdev_feature_clear_bits(BOND_XFRM_FEATURES,
-					  &bond->dev->wanted_features);
+					  bond->dev->wanted_features);
 
 	return true;
 }
@@ -794,10 +794,10 @@ static bool bond_set_tls_features(struct bonding *bond)
 
 	if (bond_sk_check(bond))
 		netdev_feature_set_bits(BOND_TLS_FEATURES,
-					&bond->dev->wanted_features);
+					bond->dev->wanted_features);
 	else
 		netdev_feature_clear_bits(BOND_TLS_FEATURES,
-					  &bond->dev->wanted_features);
+					  bond->dev->wanted_features);
 
 	return true;
 }
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 96255e886ce0..bd55018a5de7 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -398,7 +398,7 @@ static void caifdev_setup(struct net_device *dev)
 {
 	struct ser_device *serdev = netdev_priv(dev);
 
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	dev->netdev_ops = &netdev_ops;
 	dev->type = ARPHRD_CAIF;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 97c61943125e..26f9ffe4a777 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -233,8 +233,8 @@ void can_setup(struct net_device *dev)
 
 	/* New-style flags. */
 	dev->flags = IFF_NOARP;
-	netdev_feature_zero(&dev->features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &dev->features);
+	netdev_feature_zero(dev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, dev->features);
 }
 
 /* Allocate and setup space for the CAN network device */
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 8af2cf00a021..e64724239441 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -450,8 +450,8 @@ static void slc_setup(struct net_device *dev)
 
 	/* New-style flags. */
 	dev->flags		= IFF_NOARP;
-	netdev_feature_zero(&dev->features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &dev->features);
+	netdev_feature_zero(dev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, dev->features);
 }
 
 /******************************************
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index f5b5807b2313..d17430efea71 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -640,7 +640,7 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
 		netdev_feature_set_bits(XRS7000X_SUPPORTED_HSR_FEATURES,
-					&slave->features);
+					slave->features);
 	}
 
 	return 0;
@@ -695,7 +695,7 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
 		slave = dsa_to_port(ds, hsr_pair[i])->slave;
 		netdev_feature_clear_bits(XRS7000X_SUPPORTED_HSR_FEATURES,
-					  &slave->features);
+					  slave->features);
 	}
 
 	return 0;
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index 54ebb638a57b..993a972f0219 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -123,13 +123,13 @@ static void dummy_setup(struct net_device *dev)
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
-	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST, &dev->features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST, dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->features);
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_HIGHDMA |
-				NETIF_F_LLTX, &dev->features);
-	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &dev->features);
-	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
-	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+				NETIF_F_LLTX, dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, dev->features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(dev->hw_enc_features, dev->hw_enc_features,
 			  dev->features);
 	eth_hw_addr_random(dev);
 
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index d5bdd8a97a61..e66bd7495a2a 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1447,7 +1447,7 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 		    ((hw_checksums[card_idx] == -1 && (vp->drv_flags & HAS_HWCKSM)) ||
 				hw_checksums[card_idx] == 1)) {
 			netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
-						&dev->features);
+						dev->features);
 		}
 	} else
 		dev->netdev_ops =  &vortex_netdev_ops;
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 5ec10b9217f1..b6d10f79a0ce 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2458,12 +2458,12 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * on the current 3XP firmware -- it does not respect the offload
 	 * settings -- so we only allow the user to toggle the TX processing.
 	 */
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-				NETIF_F_HW_VLAN_CTAG_TX, &dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_TX, dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM,
-				&dev->features);
+				dev->features);
 
 	err = register_netdev(dev);
 	if (err < 0) {
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index a9dcdada7a2c..ff9a7e4e1b9b 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -685,16 +685,16 @@ static int starfire_init_one(struct pci_dev *pdev,
 	/* Starfire can do TCP/UDP checksumming */
 	if (enable_hw_cksum)
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
-					&dev->features);
+					dev->features);
 #endif /* ZEROCOPY */
 
 #ifdef VLAN_SUPPORT
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&dev->features);
+				dev->features);
 #endif /* VLAN_RX_KILL_VID */
 #ifdef ADDR_64BITS
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 #endif /* ADDR_64BITS */
 
 	/* Serial EEPROM reads are hidden by the hardware. */
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 2c0fc8103386..65d5080aa759 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1485,11 +1485,11 @@ static int greth_of_probe(struct platform_device *ofdev)
 	GRETH_REGSAVE(regs->status, 0xFF);
 
 	if (greth->gbit_mac) {
-		netdev_feature_zero(&dev->hw_features);
+		netdev_feature_zero(dev->hw_features);
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-					NETIF_F_RXCSUM, &dev->hw_features);
-		netdev_feature_copy(&dev->features, dev->hw_features);
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+					NETIF_F_RXCSUM, dev->hw_features);
+		netdev_feature_copy(dev->features, dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
 
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index e0e10665726e..bad297c6b947 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1778,9 +1778,9 @@ static int slic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, dev);
 	dev->irq = pdev->irq;
 	dev->netdev_ops = &slic_netdev_ops;
-	netdev_feature_zero(&dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 
 	dev->ethtool_ops = &slic_ethtool_ops;
 
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 1e8a69297fa0..7fcf793dc848 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -469,9 +469,9 @@ static int acenic_probe_one(struct pci_dev *pdev,
 	ap->pdev = pdev;
 	ap->name = pci_name(pdev);
 
-	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM, &dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM, dev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &dev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, dev->features);
 
 	dev->watchdog_timeo = 5*HZ;
 	dev->min_mtu = 0;
@@ -591,7 +591,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
 	ap->name = dev->name;
 
 	if (ap->pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	pci_set_drvdata(pdev, dev);
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index b488140414e0..994521068241 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1551,15 +1551,15 @@ static int altera_tse_probe(struct platform_device *pdev)
 	/* Scatter/gather IO is not supported,
 	 * so it is turned off
 	 */
-	netdev_feature_clear_bit(NETIF_F_SG_BIT, &ndev->hw_features);
-	netdev_feature_or(&ndev->features, ndev->features, ndev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+	netdev_feature_clear_bit(NETIF_F_SG_BIT, ndev->hw_features);
+	netdev_feature_or(ndev->features, ndev->features, ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 
 	/* VLAN offloading of tagging, stripping and filtering is not
 	 * supported by hardware, but driver will accommodate the
 	 * extra 4-byte VLAN tag for processing by upper layers
 	 */
-	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, ndev->features);
 
 	/* setup NAPI interface */
 	netif_napi_add(ndev, &priv->napi, tse_poll, NAPI_POLL_WEIGHT);
diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index f5ec35fa4c63..ff51c2e58670 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -839,7 +839,7 @@ struct ena_admin_host_info {
 	u32 driver_version;
 
 	/* features bitmap */
-	u32 supported_network_features[2];
+	u32 supported_network_features[DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 32)];
 
 	/* ENA spec version of driver */
 	u16 ena_spec_version;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 3eda7401ce63..730d890d6c4f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3944,10 +3944,8 @@ static void ena_update_hints(struct ena_adapter *adapter,
 static void ena_update_host_info(struct ena_admin_host_info *host_info,
 				 struct net_device *netdev)
 {
-	host_info->supported_network_features[0] =
-		netdev->features & GENMASK_ULL(31, 0);
-	host_info->supported_network_features[1] =
-		(netdev->features & GENMASK_ULL(63, 32)) >> 32;
+	bitmap_to_arr32(host_info->supported_network_features, netdev->features,
+			NETDEV_FEATURE_COUNT);
 }
 
 static void ena_timer_service(struct timer_list *t)
@@ -4028,43 +4026,43 @@ static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 {
 	__DECLARE_NETDEV_FEATURE_MASK(dev_features);
 
-	netdev_feature_zero(&dev_features);
+	netdev_feature_zero(dev_features);
 
 	/* Set offload features */
 	if (feat->offload.tx &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_TX_L4_IPV4_CSUM_PART_MASK)
-		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &dev_features);
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, dev_features);
 
 	if (feat->offload.tx &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_TX_L4_IPV6_CSUM_PART_MASK)
-		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &dev_features);
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_IPV4_MASK)
-		netdev_feature_set_bit(NETIF_F_TSO_BIT, &dev_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_IPV6_MASK)
-		netdev_feature_set_bit(NETIF_F_TSO6_BIT, &dev_features);
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT, dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_ECN_MASK)
-		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &dev_features);
+		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, dev_features);
 
 	if (feat->offload.rx_supported &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV4_CSUM_MASK)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev_features);
 
 	if (feat->offload.rx_supported &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV6_CSUM_MASK)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev_features);
 
-	netdev_feature_copy(&netdev->features, dev_features);
+	netdev_feature_copy(netdev->features, dev_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_RXHASH |
 				NETIF_F_HIGHDMA,
-				&netdev->features);
+				netdev->features);
 
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  netdev->features);
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 }
 
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 1757eac19822..29ba85d7c579 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1792,7 +1792,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 #if AMD8111E_VLAN_TAG_USED
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&dev->features);
+				dev->features);
 #endif
 
 	lp = netdev_priv(dev);
@@ -1833,7 +1833,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 #if AMD8111E_VLAN_TAG_USED
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&dev->features);
+				dev->features);
 #endif
 	/* Probe the external PHY */
 	amd8111e_probe_ext_phy(dev);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 401060a2e020..1397997101fe 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2183,39 +2183,39 @@ static int xgbe_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 }
 
 static void xgbe_fix_features(struct net_device *netdev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(vxlan_base);
 
-	netdev_feature_zero(&vxlan_base);
+	netdev_feature_zero(vxlan_base);
 	netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 				NETIF_F_RX_UDP_TUNNEL_PORT,
-				&vxlan_base);
+				vxlan_base);
 
 	if (!pdata->hw_feat.vxn)
 		return;
 
 	/* VXLAN CSUM requires VXLAN base */
 	if (netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-				    *features) &&
-	    !netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_BIT, *features)) {
+				    features) &&
+	    !netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_BIT, features)) {
 		netdev_notice(netdev,
 			      "forcing tx udp tunnel support\n");
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT, features);
 	}
 
 	/* Can't do one without doing the other */
-	if (!netdev_feature_subset(*features, vxlan_base)) {
+	if (!netdev_feature_subset(features, vxlan_base)) {
 		netdev_notice(netdev,
 			      "forcing both tx and rx udp tunnel support\n");
-		netdev_feature_or(features, *features, vxlan_base);
+		netdev_feature_or(features, features, vxlan_base);
 	}
 
 	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				     *features)) {
+				     features)) {
 		if (!netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-					     *features)) {
+					     features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
 			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
@@ -2223,7 +2223,7 @@ static void xgbe_fix_features(struct net_device *netdev,
 		}
 	} else {
 		if (netdev_feature_test_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-					    *features)) {
+					    features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming off\n");
 			netdev_feature_clear_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
@@ -2277,7 +2277,7 @@ static int xgbe_set_features(struct net_device *netdev,
 					  features) && rxvlan_filter)
 		hw_if->disable_rx_vlan_filtering(pdata);
 
-	netdev_feature_copy(&pdata->netdev_features, features);
+	netdev_feature_copy(pdata->netdev_features, features);
 
 	DBGPR("<--xgbe_set_features\n");
 
@@ -2285,7 +2285,7 @@ static int xgbe_set_features(struct net_device *netdev,
 }
 
 static void xgbe_features_check(struct sk_buff *skb, struct net_device *netdev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	vlan_features_check(skb, features);
 	vxlan_features_check(skb, features);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index ace7324fcedf..a99b75728c72 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -342,7 +342,7 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 #endif
 
 	/* Set device features */
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM |
@@ -353,14 +353,14 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	if (pdata->hw_feat.rss)
 		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
 	if (pdata->hw_feat.vxn) {
-		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_zero(netdev->hw_enc_features);
 		netdev_feature_set_bits(NETIF_F_SG |
 					NETIF_F_IP_CSUM |
 					NETIF_F_IPV6_CSUM |
@@ -370,11 +370,11 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 					NETIF_F_GRO |
 					NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&netdev->hw_enc_features);
+					netdev->hw_enc_features);
 
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&netdev->hw_features);
+					netdev->hw_features);
 
 		netdev->udp_tunnel_nic_info = xgbe_get_udp_tunnel_info();
 	}
@@ -384,11 +384,11 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 				NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO |
 				NETIF_F_TSO6,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
-	netdev_feature_copy(&pdata->netdev_features, netdev->features);
+	netdev_feature_copy(pdata->netdev_features, netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->min_mtu = 0;
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 2903a0fea0c3..30769b82aa90 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -648,13 +648,13 @@ static int xge_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 
-	netdev_feature_set_bits(NETIF_F_GSO | NETIF_F_GRO, &ndev->features);
+	netdev_feature_set_bits(NETIF_F_GSO | NETIF_F_GRO, ndev->features);
 
 	ret = xge_get_resources(pdata);
 	if (ret)
 		goto err;
 
-	netdev_feature_copy(&ndev->hw_features, ndev->features);
+	netdev_feature_copy(ndev->hw_features, ndev->features);
 	xge_set_ethtool_ops(ndev);
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index ed67becb8654..10a6b16387f8 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2037,7 +2037,7 @@ static int xgene_enet_probe(struct platform_device *pdev)
 				NETIF_F_GSO |
 				NETIF_F_GRO |
 				NETIF_F_SG,
-				&ndev->features);
+				ndev->features);
 
 	of_id = of_match_device(xgene_enet_of_match, &pdev->dev);
 	if (of_id) {
@@ -2066,10 +2066,10 @@ static int xgene_enet_probe(struct platform_device *pdev)
 
 	if (pdata->phy_mode == PHY_INTERFACE_MODE_XGMII) {
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_RXCSUM,
-					&ndev->features);
+					ndev->features);
 		spin_lock_init(&pdata->mss_lock);
 	}
-	netdev_feature_copy(&ndev->hw_features, ndev->features);
+	netdev_feature_copy(ndev->hw_features, ndev->features);
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 0c10d8ba11c2..591f589c466a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1490,7 +1490,7 @@ int aq_macsec_init(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return -ENOMEM;
 
-	netdev_feature_set_bit(NETIF_F_HW_MACSEC_BIT, &nic->ndev->features);
+	netdev_feature_set_bit(NETIF_F_HW_MACSEC_BIT, nic->ndev->features);
 	nic->ndev->macsec_ops = &aq_macsec_ops;
 
 	return 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index a153b99f2166..4496bb5575b5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -174,7 +174,7 @@ static int aq_ndev_set_features(struct net_device *ndev,
 		}
 	}
 
-	netdev_feature_copy(&aq_cfg->features, features);
+	netdev_feature_copy(aq_cfg->features, features);
 
 	if (aq_cfg->aq_hw_caps->hw_features & NETIF_F_LRO) {
 		is_lro = netdev_feature_test_bit(NETIF_F_LRO_BIT, features);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 5e73a469861d..4c7ae4b0b63a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -144,8 +144,8 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 		cfg->link_irq_vec = 0;
 
 	cfg->link_speed_msk &= cfg->aq_hw_caps->link_speed_msk;
-	netdev_feature_zero(&cfg->features);
-	netdev_feature_set_bits(cfg->aq_hw_caps->hw_features, &cfg->features);
+	netdev_feature_zero(cfg->features);
+	netdev_feature_set_bits(cfg->aq_hw_caps->hw_features, cfg->features);
 	cfg->is_vlan_rx_strip =
 		netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
 					cfg->features);
@@ -373,16 +373,16 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	struct aq_nic_cfg_s *aq_nic_cfg = &self->aq_nic_cfg;
 
 	netdev_feature_set_bits(aq_hw_caps->hw_features,
-				&self->ndev->hw_features);
-	netdev_feature_zero(&self->ndev->features);
-	netdev_feature_set_bits(aq_hw_caps->hw_features, &self->ndev->features);
+				self->ndev->hw_features);
+	netdev_feature_zero(self->ndev->features);
+	netdev_feature_set_bits(aq_hw_caps->hw_features, self->ndev->features);
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 				NETIF_F_RXHASH | NETIF_F_SG |
 				NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6,
-				&self->ndev->vlan_features);
-	netdev_feature_zero(&self->ndev->gso_partial_features);
+				self->ndev->vlan_features);
+	netdev_feature_zero(self->ndev->gso_partial_features);
 	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
-			       &self->ndev->gso_partial_features);
+			       self->ndev->gso_partial_features);
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 2f79aa6f41a4..4451513b4371 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1099,7 +1099,7 @@ static int alx_init_sw(struct alx_priv *alx)
 
 
 static void alx_fix_features(struct net_device *netdev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
 	if (netdev->mtu > ALX_MAX_TSO_PKT_SIZE)
 		netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
@@ -1818,12 +1818,12 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_HW_CSUM |
 				NETIF_F_RXCSUM |
 				NETIF_F_TSO |
-				NETIF_F_TSO6, &netdev->hw_features);
+				NETIF_F_TSO6, netdev->hw_features);
 
 	if (alx_get_perm_macaddr(hw, hw->perm_addr)) {
 		dev_warn(&pdev->dev,
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1c8803f86900..b7be62fee950 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -505,7 +505,7 @@ static void atl1c_set_rxbufsize(struct atl1c_adapter *adapter,
 }
 
 static void atl1c_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 	struct atl1c_hw *hw = &adapter->hw;
@@ -514,7 +514,7 @@ static void atl1c_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -532,7 +532,7 @@ static int atl1c_set_features(struct net_device *netdev,
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1c_vlan_mode(netdev, features);
@@ -2630,14 +2630,14 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	atl1c_set_ethtool_ops(netdev);
 
 	/* TODO: add when ready */
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG		|
 				NETIF_F_HW_CSUM		|
 				NETIF_F_HW_VLAN_CTAG_RX	|
 				NETIF_F_TSO		|
-				NETIF_F_TSO6, &netdev->hw_features);
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, &netdev->features);
+				NETIF_F_TSO6, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, netdev->features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index d5ee30450f89..5f24a945d2bc 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -383,13 +383,13 @@ static int atl1e_set_mac_addr(struct net_device *netdev, void *p)
 }
 
 static void atl1e_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -401,7 +401,7 @@ static int atl1e_set_features(struct net_device *netdev,
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1e_vlan_mode(netdev, features);
 
@@ -2270,14 +2270,14 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 			  (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 	atl1e_set_ethtool_ops(netdev);
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO |
-				NETIF_F_HW_VLAN_CTAG_RX, &netdev->hw_features);
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, &netdev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, netdev->features);
 	/* not enabled by default */
 	netdev_feature_set_bits(NETIF_F_RXALL | NETIF_F_RXFCS,
-				&netdev->hw_features);
+				netdev->hw_features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index a717cd030c69..0310f35a0f54 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2988,18 +2988,18 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_common;
 
-	netdev_feature_zero(&netdev->features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->features);
+	netdev_feature_zero(netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, netdev->features);
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG | NETIF_F_TSO |
-				NETIF_F_HW_VLAN_CTAG_RX, &netdev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_RX, netdev->hw_features);
 
 	/* is this valid? see atl1_setup_mac_ctrl() */
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->features);
 
 	/* MTU range: 42 - 10218 */
 	netdev->min_mtu = ETH_ZLEN - (ETH_HLEN + VLAN_HLEN);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 943f2af0e3e6..0513696a1815 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -372,13 +372,13 @@ static void atl2_restore_vlan(struct atl2_adapter *adapter)
 }
 
 static void atl2_fix_features(struct net_device *netdev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -390,7 +390,7 @@ static int atl2_set_features(struct net_device *netdev,
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl2_vlan_mode(netdev, features);
 
@@ -1389,11 +1389,11 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, netdev->features);
 
 	/* Init PHY as early as possible due to power saving issue  */
 	atl2_phy_init(&adapter->hw);
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index ea5b6d73e2f1..0474ae3a2b82 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -238,13 +238,13 @@ static void atlx_restore_vlan(struct atlx_adapter *adapter)
 }
 
 static void atlx_fix_features(struct net_device *netdev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -256,7 +256,7 @@ static int atlx_set_features(struct net_device *netdev,
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atlx_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index d9e9742dec91..629c67f1f8cd 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2353,7 +2353,7 @@ static int b44_init_one(struct ssb_device *sdev,
 	SET_NETDEV_DEV(dev, sdev->dev);
 
 	/* No interesting netdevice features in this card... */
-	netdev_feature_set_bits(0, &dev->features);
+	netdev_feature_set_bits(0, dev->features);
 
 	bp = netdev_priv(dev);
 	bp->sdev = sdev;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0d686804fa6e..fc193e941e05 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2572,9 +2572,9 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_HIGHDMA |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_HW_VLAN_CTAG_TX, &dev->features);
-	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
-	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+				NETIF_F_HW_VLAN_CTAG_TX, dev->features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(dev->vlan_features, dev->vlan_features,
 			  dev->features);
 	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index c99800b8d812..7ff3d3a07d9e 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1535,11 +1535,11 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 		goto err_dma_free;
 	}
 
-	netdev_feature_zero(&net_dev->features);
+	netdev_feature_zero(net_dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM, &net_dev->features);
-	netdev_feature_copy(&net_dev->hw_features, net_dev->features);
-	netdev_feature_copy(&net_dev->vlan_features, net_dev->features);
+				NETIF_F_IPV6_CSUM, net_dev->features);
+	netdev_feature_copy(net_dev->hw_features, net_dev->features);
+	netdev_feature_copy(net_dev->vlan_features, net_dev->features);
 
 	/* Omit FCS from max MTU size */
 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 4be5a2fa0734..176abe820364 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7754,19 +7754,18 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 
 	/* TSO with VLAN tag won't work with current firmware */
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
-		netdev_feature_copy(&tmp, dev->hw_features);
-		netdev_feature_and_bits(NETIF_F_ALL_TSO, &tmp);
-		netdev_feature_or(&dev->vlan_features, dev->vlan_features,
-				  tmp);
+		netdev_feature_copy(tmp, dev->hw_features);
+		netdev_feature_and_bits(NETIF_F_ALL_TSO, tmp);
+		netdev_feature_or(dev->vlan_features, dev->vlan_features, tmp);
 	} else {
-		netdev_feature_clear_bits(NETIF_F_ALL_TSO, &dev->vlan_features);
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, dev->vlan_features);
 	}
 
 	if ((netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) !=
 	    !!(bp->rx_mode & BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG)) &&
 	    netif_running(dev)) {
 		bnx2_netif_stop(bp, false);
-		netdev_feature_copy(&dev->features, features);
+		netdev_feature_copy(dev->features, features);
 		bnx2_set_rx_mode(dev);
 		bnx2_fw_sync(bp, BNX2_DRV_MSG_CODE_KEEP_VLAN_UPDATE, 0, 1);
 		bnx2_netif_start(bp, false);
@@ -8216,7 +8215,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 
 	/* Configure DMA attributes. */
 	if (dma_set_mask(&pdev->dev, dma_mask) == 0) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 		rc = dma_set_coherent_mask(&pdev->dev, persist_dma_mask);
 		if (rc) {
 			dev_err(&pdev->dev,
@@ -8584,27 +8583,27 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	memcpy(dev->dev_addr, bp->mac_addr, ETH_ALEN);
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
 				NETIF_F_TSO | NETIF_F_TSO_ECN |
 				NETIF_F_RXHASH | NETIF_F_RXCSUM,
-				&dev->hw_features);
+				dev->hw_features);
 
 	if (BNX2_CHIP(bp) == BNX2_CHIP_5709)
 		netdev_feature_set_bits(NETIF_F_IPV6_CSUM | NETIF_F_TSO6,
-					&dev->hw_features);
+					dev->hw_features);
 
-	netdev_feature_copy(&dev->vlan_features, dev->hw_features);
+	netdev_feature_copy(dev->vlan_features, dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_RX, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->min_mtu = MIN_ETHERNET_PACKET_SIZE;
 	dev->max_mtu = MAX_ETHERNET_JUMBO_PACKET_SIZE;
 
 	if (!(bp->flags & BNX2_FLAG_CAN_KEEP_VLAN))
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					 &dev->hw_features);
+					 dev->hw_features);
 
 	if ((rc = register_netdev(dev))) {
 		dev_err(&pdev->dev, "Cannot register net device\n");
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 57709a295867..8d67a6364151 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4893,7 +4893,7 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu)
 	dev->mtu = new_mtu;
 
 	if (!bnx2x_mtu_allows_gro(new_mtu))
-		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &dev->features);
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, dev->features);
 
 	if (IS_PF(bp) && SHMEM2_HAS(bp, curr_cfg))
 		SHMEM2_WR(bp, curr_cfg, CURR_CFG_MET_OS);
@@ -4901,19 +4901,19 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu)
 	return bnx2x_reload_if_running(dev);
 }
 
-void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
+void bnx2x_fix_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
 	if (pci_num_vf(bp->pdev)) {
 		__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-		netdev_feature_xor(&changed, dev->features, *features);
+		netdev_feature_xor(changed, dev->features, features);
 
 		/* Revert the requested changes in features if they
 		 * would require internal reload of PF in bnx2x_set_features().
 		 */
-		if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features) &&
+		if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
 		    !bp->disable_tpa) {
 			if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
 						    dev->features))
@@ -4932,13 +4932,13 @@ void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
 	}
 
 	/* TPA requires Rx CSUM offloading */
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 
-	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, *features) ||
+	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, features) ||
 	    !bnx2x_mtu_allows_gro(dev->mtu))
 		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
-	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 }
 
@@ -4949,7 +4949,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 	bool bnx2x_reload = false;
 	int rc;
 
-	netdev_feature_xor(&changes, dev->features, features);
+	netdev_feature_xor(changes, dev->features, features);
 
 	/* VFs or non SRIOV PFs should be able to change loopback feature */
 	if (!pci_num_vf(bp->pdev)) {
@@ -4967,14 +4967,14 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 	}
 
 	/* Don't care about GRO changes */
-	netdev_feature_clear_bit(NETIF_F_GRO_BIT, &changes);
+	netdev_feature_clear_bit(NETIF_F_GRO_BIT, changes);
 
 	if (!netdev_feature_empty(changes))
 		bnx2x_reload = true;
 
 	if (bnx2x_reload) {
 		if (bp->recovery_state == BNX2X_RECOVERY_DONE) {
-			netdev_feature_copy(&dev->features, features);
+			netdev_feature_copy(dev->features, features);
 			rc = bnx2x_reload_if_running(dev);
 			return rc ? rc : 1;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index 4c66ef3e04bf..f4c82b93c9c0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -606,7 +606,7 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu);
 int bnx2x_fcoe_get_wwn(struct net_device *dev, u64 *wwn, int type);
 #endif
 
-void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features);
+void bnx2x_fix_features(struct net_device *dev, netdev_features_t features);
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features);
 
 /**
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 67fbe0ebf3b6..650ce1698ef7 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12333,9 +12333,9 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 	/* Set TPA flags */
 	if (bp->disable_tpa) {
 		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
-					  &bp->dev->hw_features);
+					  bp->dev->hw_features);
 		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
-					  &bp->dev->features);
+					  bp->dev->features);
 	}
 
 	if (CHIP_IS_E1(bp))
@@ -12837,7 +12837,7 @@ static int bnx2x_get_phys_port_id(struct net_device *netdev,
 }
 
 static void bnx2x_features_check(struct sk_buff *skb, struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	/*
 	 * A skb with gso_size + header length > 9700 will cause a
@@ -13192,62 +13192,62 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO |
 				NETIF_F_TSO_ECN | NETIF_F_TSO6 |
 				NETIF_F_RXCSUM | NETIF_F_LRO | NETIF_F_GRO |
 				NETIF_F_GRO_HW | NETIF_F_RXHASH |
-				NETIF_F_HW_VLAN_CTAG_TX, &dev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_TX, dev->hw_features);
 	if (!chip_is_e1x) {
 		netdev_feature_set_bits(NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM |
 				NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_UDP_TUNNEL |
 				NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				NETIF_F_GSO_PARTIAL, &dev->hw_features);
+				NETIF_F_GSO_PARTIAL, dev->hw_features);
 
-		netdev_feature_zero(&dev->hw_enc_features);
+		netdev_feature_zero(dev->hw_enc_features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_SG | NETIF_F_TSO |
 				NETIF_F_TSO_ECN | NETIF_F_TSO6 |
 				NETIF_F_GSO_IPXIP4 | NETIF_F_GSO_GRE |
 				NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 				NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				NETIF_F_GSO_PARTIAL, &dev->hw_enc_features);
+				NETIF_F_GSO_PARTIAL, dev->hw_enc_features);
 
-		netdev_feature_zero(&dev->gso_partial_features);
+		netdev_feature_zero(dev->gso_partial_features);
 		netdev_feature_set_bits(NETIF_F_GSO_GRE_CSUM |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&dev->gso_partial_features);
+					dev->gso_partial_features);
 
 		if (IS_PF(bp))
 			dev->udp_tunnel_nic_info = &bnx2x_udp_tunnels;
 	}
 
-	netdev_feature_zero(&dev->vlan_features);
+	netdev_feature_zero(dev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO |
 				NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-				NETIF_F_HIGHDMA, &dev->vlan_features);
+				NETIF_F_HIGHDMA, dev->vlan_features);
 
 	if (IS_PF(bp)) {
 		if (chip_is_e1x)
 			bp->accept_any_vlan = true;
 		else
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 	}
 	/* For VF we'll know whether to enable VLAN filtering after
 	 * getting a response to CHANNEL_TLV_ACQUIRE from PF.
 	 */
 
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, &dev->features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, dev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features))
-		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &dev->features);
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, dev->features);
 
 	/* Add Loopback capability to the device */
-	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, dev->features);
 
 #ifdef BCM_DCBNL
 	dev->dcbnl_ops = &bnx2x_dcbnl_ops;
@@ -13951,9 +13951,9 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 		/* VF with OLD Hypervisor or old PF do not support filtering */
 		if (bp->acquire_resp.pfdev_info.pf_cap & PFVF_CAP_VLAN_FILTER) {
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					       &dev->features);
+					       dev->features);
 		}
 #endif
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3d18839615a2..e55d22592d69 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6350,9 +6350,9 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 			bp->flags &= ~BNXT_FLAG_AGG_RINGS;
 			bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
 			netdev_feature_clear_bit(NETIF_F_LRO_BIT,
-						 &bp->dev->hw_features);
+						 bp->dev->hw_features);
 			netdev_feature_clear_bit(NETIF_F_LRO_BIT,
-						 &bp->dev->features);
+						 bp->dev->features);
 			bnxt_set_ring_params(bp);
 		}
 	}
@@ -10197,7 +10197,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	    !(bp->flags & BNXT_FLAG_USING_MSIX)) {
 		/* disable RFS if falling back to INTA */
 		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
-					 &bp->dev->hw_features);
+					 bp->dev->hw_features);
 		bp->flags &= ~BNXT_FLAG_RFS;
 	}
 
@@ -10903,13 +10903,13 @@ static bool bnxt_rfs_capable(struct bnxt *bp)
 }
 
 static void bnxt_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(vlan_features);
 	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	struct bnxt *bp = netdev_priv(dev);
 
-	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features) &&
 	    !bnxt_rfs_capable(bp))
 		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, features);
 
@@ -10917,18 +10917,18 @@ static void bnxt_fix_features(struct net_device *dev,
 		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
 					  features);
 
-	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 
-	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	netdev_feature_zero(&tmp);
-	netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_RX, &tmp);
-	netdev_feature_and(&vlan_features, *features, tmp);
+	netdev_feature_zero(tmp);
+	netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_RX, tmp);
+	netdev_feature_and(vlan_features, features, tmp);
 	if (!netdev_feature_equal(vlan_features, tmp)) {
 		if (netdev_feature_test_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
 					     dev->features))
@@ -11107,7 +11107,7 @@ static bool bnxt_tunl_check(struct bnxt *bp, struct sk_buff *skb, u8 l4_proto)
 }
 
 static void bnxt_features_check(struct sk_buff *skb, struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	u8 *l4_proto;
@@ -11974,15 +11974,15 @@ static void bnxt_set_dflt_rfs(struct bnxt *bp)
 {
 	struct net_device *dev = bp->dev;
 
-	netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, &dev->hw_features);
-	netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, &dev->features);
+	netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, dev->hw_features);
+	netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT, dev->features);
 	bp->flags &= ~BNXT_FLAG_RFS;
 	if (bnxt_rfs_supported(bp)) {
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, dev->hw_features);
 		if (bnxt_rfs_capable(bp)) {
 			bp->flags |= BNXT_FLAG_RFS;
 			netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
-					       &dev->features);
+					       dev->features);
 		}
 	}
 }
@@ -12968,9 +12968,9 @@ static int bnxt_get_dflt_rings(struct bnxt *bp, int *max_rx, int *max_tx,
 		}
 		bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
 		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
-					  &bp->dev->hw_features);
+					  bp->dev->hw_features);
 		netdev_feature_clear_bits(NETIF_F_LRO | NETIF_F_GRO_HW,
-					  &bp->dev->features);
+					  bp->dev->features);
 		bnxt_set_ring_params(bp);
 	}
 
@@ -13085,7 +13085,7 @@ static int bnxt_init_dflt_ring_mode(struct bnxt *bp)
 	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 	if (bnxt_rfs_supported(bp) && bnxt_rfs_capable(bp)) {
 		bp->flags |= BNXT_FLAG_RFS;
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &bp->dev->features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, bp->dev->features);
 	}
 init_dflt_ring_err:
 	bnxt_ulp_irq_restart(bp, rc);
@@ -13281,7 +13281,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto init_err_pci_clean;
 	}
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
@@ -13289,38 +13289,38 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_PARTIAL |
 				NETIF_F_RXHASH | NETIF_F_RXCSUM | NETIF_F_GRO,
-				&dev->hw_features);
+				dev->hw_features);
 
 	if (BNXT_SUPPORTS_TPA(bp))
-		netdev_feature_set_bit(NETIF_F_LRO_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, dev->hw_features);
 
-	netdev_feature_zero(&dev->hw_enc_features);
+	netdev_feature_zero(dev->hw_enc_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
 				NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_IPXIP4 |
-				NETIF_F_GSO_PARTIAL, &dev->hw_enc_features);
+				NETIF_F_GSO_PARTIAL, dev->hw_enc_features);
 	dev->udp_tunnel_nic_info = &bnxt_udp_tunnels;
 
-	netdev_feature_zero(&dev->gso_partial_features);
+	netdev_feature_zero(dev->gso_partial_features);
 	netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				NETIF_F_GSO_GRE_CSUM,
-				&dev->gso_partial_features);
-	netdev_feature_copy(&dev->vlan_features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->vlan_features);
+				dev->gso_partial_features);
+	netdev_feature_copy(dev->vlan_features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->vlan_features);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
 		netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_RX,
-					&dev->hw_features);
+					dev->hw_features);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_TX_INSERT)
 		netdev_feature_set_bits(BNXT_HW_FEATURE_VLAN_ALL_TX,
-					&dev->hw_features);
+					dev->hw_features);
 	if (BNXT_SUPPORTS_TPA(bp))
-		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, dev->features))
-		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &dev->features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, dev->features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index ff88f5ccb782..b3d885b7ac48 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -2052,8 +2052,8 @@ int bnxt_init_tc(struct bnxt *bp)
 		goto destroy_decap_table;
 
 	tc_info->enabled = true;
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &bp->dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &bp->dev->features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, bp->dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, bp->dev->features);
 	bp->tc_info = tc_info;
 
 	/* init indirect block notifications */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index d77beadf5921..df82fa6ce452 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -468,12 +468,12 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	/* Just inherit all the featues of the parent PF as the VF-R
 	 * uses the RX/TX rings of the parent PF
 	 */
-	netdev_feature_copy(&dev->hw_features, pf_dev->hw_features);
-	netdev_feature_copy(&dev->gso_partial_features,
+	netdev_feature_copy(dev->hw_features, pf_dev->hw_features);
+	netdev_feature_copy(dev->gso_partial_features,
 			    pf_dev->gso_partial_features);
-	netdev_feature_copy(&dev->vlan_features, pf_dev->vlan_features);
-	netdev_feature_copy(&dev->hw_enc_features, pf_dev->hw_enc_features);
-	netdev_feature_or(&dev->features, dev->features, pf_dev->features);
+	netdev_feature_copy(dev->vlan_features, pf_dev->vlan_features);
+	netdev_feature_copy(dev->hw_enc_features, pf_dev->hw_enc_features);
+	netdev_feature_or(dev->features, dev->features, pf_dev->features);
 	bnxt_vf_rep_eth_addr_gen(bp->pf.mac_addr, vf_rep->vf_idx,
 				 dev->perm_addr);
 	ether_addr_copy(dev->dev_addr, dev->perm_addr);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index a86f3c3db767..a591ab957cb3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -298,7 +298,7 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		if (rx > 1) {
 			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
 			netdev_feature_set_bit(NETIF_F_LRO_BIT,
-					       &bp->dev->hw_features);
+					       bp->dev->hw_features);
 		}
 	}
 	bp->tx_nr_rings_xdp = tx_xdp;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 1b12d0ae8f1f..2b005c7dc900 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4007,9 +4007,9 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	/* Set default features */
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-				NETIF_F_RXCSUM, &dev->features);
-	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
-	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+				NETIF_F_RXCSUM, dev->features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(dev->vlan_features, dev->vlan_features,
 			  dev->features);
 
 	/* Request the WOL interrupt and advertise suspend if available */
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 430082a11f9c..bc0f5362013d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7879,8 +7879,8 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		netif_tx_wake_queue(txq);
 	}
 
-	netdev_feature_copy(&tmp, tp->dev->features);
-	netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6, &tmp);
+	netdev_feature_copy(tmp, tp->dev->features);
+	netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6, tmp);
 	segs = skb_gso_segment(skb, tmp);
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
@@ -8306,7 +8306,7 @@ static void tg3_set_loopback(struct net_device *dev, netdev_features_t features)
 }
 
 static void tg3_fix_features(struct net_device *dev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
@@ -8318,7 +8318,7 @@ static int tg3_set_features(struct net_device *dev, netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
 	    netif_running(dev))
 		tg3_set_loopback(dev, features);
@@ -17565,7 +17565,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	char str[40];
 	u64 dma_mask, persist_dma_mask;
 
-	netdev_feature_zero(&features);
+	netdev_feature_zero(features);
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -17708,7 +17708,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if (dma_mask > DMA_BIT_MASK(32)) {
 		err = dma_set_mask(&pdev->dev, dma_mask);
 		if (!err) {
-			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &features);
+			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, features);
 			err = dma_set_coherent_mask(&pdev->dev,
 						    persist_dma_mask);
 			if (err < 0) {
@@ -17734,11 +17734,11 @@ static int tg3_init_one(struct pci_dev *pdev,
 	 */
 	if (tg3_chip_rev_id(tp) != CHIPREV_ID_5700_B0) {
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-					NETIF_F_RXCSUM, &features);
+					NETIF_F_RXCSUM, features);
 
 		if (tg3_flag(tp, 5755_PLUS))
 			netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-					       &features);
+					       features);
 	}
 
 	/* TSO is on by default on chips that support hardware TSO.
@@ -17749,23 +17749,23 @@ static int tg3_init_one(struct pci_dev *pdev,
 	     tg3_flag(tp, HW_TSO_2) ||
 	     tg3_flag(tp, HW_TSO_3)) &&
 	    netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, features))
-		netdev_feature_set_bit(NETIF_F_TSO_BIT, &features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, features);
 	if (tg3_flag(tp, HW_TSO_2) || tg3_flag(tp, HW_TSO_3)) {
 		if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, features))
-			netdev_feature_set_bit(NETIF_F_TSO6_BIT, &features);
+			netdev_feature_set_bit(NETIF_F_TSO6_BIT, features);
 		if (tg3_flag(tp, HW_TSO_3) ||
 		    tg3_asic_rev(tp) == ASIC_REV_5761 ||
 		    (tg3_asic_rev(tp) == ASIC_REV_5784 &&
 		     tg3_chip_rev(tp) != CHIPREV_5784_AX) ||
 		    tg3_asic_rev(tp) == ASIC_REV_5785 ||
 		    tg3_asic_rev(tp) == ASIC_REV_57780)
-			netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &features);
+			netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, features);
 	}
 
-	netdev_feature_or(&dev->features, dev->features, features);
+	netdev_feature_or(dev->features, dev->features, features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-			NETIF_F_HW_VLAN_CTAG_RX, &dev->features);
-	netdev_feature_or(&dev->vlan_features, dev->vlan_features, features);
+			NETIF_F_HW_VLAN_CTAG_RX, dev->features);
+	netdev_feature_or(dev->vlan_features, dev->vlan_features, features);
 
 	/*
 	 * Add loopback capability only for a subset of devices that support
@@ -17775,9 +17775,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if (tg3_asic_rev(tp) != ASIC_REV_5780 &&
 	    !tg3_flag(tp, CPMU_PRESENT))
 		/* Add the loopback capability */
-		netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &features);
+		netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, features);
 
-	netdev_feature_or(&dev->hw_features, dev->hw_features, features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 60 - 9000 or 1500, depending on hardware */
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index ed630cea4906..16262c7bb643 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3354,7 +3354,7 @@ static int bnad_set_features(struct net_device *dev, netdev_features_t features)
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct bnad *bnad = netdev_priv(dev);
 
-	netdev_feature_xor(&changed, features, dev->features);
+	netdev_feature_xor(changed, features, dev->features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
 	    netif_running(dev)) {
 		unsigned long flags;
@@ -3431,27 +3431,27 @@ bnad_netdev_init(struct bnad *bnad, bool using_dac)
 {
 	struct net_device *netdev = bnad->netdev;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&netdev->hw_features);
+				netdev->hw_features);
 
-	netdev_feature_zero(&netdev->vlan_features);
+	netdev_feature_zero(netdev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &netdev->features);
+			       netdev->features);
 
 	if (using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
 	netdev->mem_start = bnad->mmio_start;
 	netdev->mem_end = bnad->mmio_start + bnad->mmio_len - 1;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7ffaa706536e..ad6c6f4f7620 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2038,7 +2038,7 @@ static unsigned int macb_tx_map(struct macb *bp,
 }
 
 static void macb_features_check(struct sk_buff *skb, struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	unsigned int nr_frags, f;
 	unsigned int hdrlen;
@@ -3637,7 +3637,7 @@ static int macb_set_features(struct net_device *netdev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct macb *bp = netdev_priv(netdev);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	/* TX checksum offload */
 	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, changed))
@@ -3660,7 +3660,7 @@ static void macb_restore_features(struct macb *bp)
 	struct net_device *netdev = bp->dev;
 	struct ethtool_rx_fs_item *item;
 
-	netdev_feature_copy(&features, netdev->features);
+	netdev_feature_copy(features, netdev->features);
 
 	/* TX checksum offload */
 	macb_set_txcsum_feature(bp, features);
@@ -3946,20 +3946,20 @@ static int macb_init(struct platform_device *pdev)
 	}
 
 	/* Set features */
-	netdev_feature_zero(&dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, dev->hw_features);
 
 	/* Check LSO capability */
 	if (GEM_BFEXT(PBUF_LSO, gem_readl(bp, DCFG6)))
-		netdev_feature_set_bits(MACB_NETIF_LSO, &dev->hw_features);
+		netdev_feature_set_bits(MACB_NETIF_LSO, dev->hw_features);
 
 	/* Checksum offload is only available on gem with packet buffer */
 	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE))
 		netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM,
-					&dev->hw_features);
+					dev->hw_features);
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
-		netdev_feature_clear_bit(NETIF_F_SG_BIT, &dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+		netdev_feature_clear_bit(NETIF_F_SG_BIT, dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 
 	/* Check RX Flow Filters support.
 	 * Max Rx flows set by availability of screeners & compare regs:
@@ -3978,7 +3978,7 @@ static int macb_init(struct platform_device *pdev)
 			gem_writel_n(bp, ETHT, SCRT2_ETHT, reg);
 			/* Filtering is supported in hw but don't enable it in kernel now */
 			netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 			/* init Rx flow definitions */
 			bp->rx_fs_list.count = 0;
 			spin_lock_init(&bp->rx_fs_lock);
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 3679fed9beaf..6588841a8338 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1493,7 +1493,7 @@ static int xgmac_set_features(struct net_device *dev, netdev_features_t features
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	void __iomem *ioaddr = priv->base;
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
@@ -1776,12 +1776,12 @@ static int xgmac_probe(struct platform_device *pdev)
 		priv->wolopts = WAKE_MAGIC;	/* Magic Frame as default */
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA,
-				&ndev->hw_features);
+				ndev->hw_features);
 
 	if (readl(priv->base + XGMAC_DMA_HW_FEATURE) & DMA_HW_FEAT_TXCOESEL)
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-					NETIF_F_RXCSUM, &ndev->hw_features);
-	netdev_feature_or(&ndev->features, &ndev->features, &ndev->hw_features);
+					NETIF_F_RXCSUM, ndev->hw_features);
+	netdev_feature_or(ndev->features, ndev->features, ndev->hw_features);
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* MTU range: 46 - 9000 */
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index b9f610c48ca2..44b8874b0e14 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2719,38 +2719,38 @@ static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
  * Return: updated features list
  */
 static void liquidio_fix_features(struct net_device *netdev,
-				  netdev_features_t *request)
+				  netdev_features_t request)
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
 		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
 		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_TSO))
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_TSO6))
 		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_LRO))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
 
 	/*Disable LRO if RXCSUM is off */
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, request) &&
 	    netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features) &&
 	    (lio->dev_capability & NETIF_F_LRO))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				    *request) &&
+				    request) &&
 	    !(lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER))
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 					 request);
@@ -3589,35 +3589,35 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					  | NETIF_F_TSO | NETIF_F_TSO6
 					  | NETIF_F_LRO;
 
-		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_zero(netdev->hw_enc_features);
 		netdev_feature_set_bits(lio->enc_dev_capability,
-					&netdev->hw_enc_features);
+					netdev->hw_enc_features);
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT,
-					 &netdev->hw_enc_features);
+					 netdev->hw_enc_features);
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
 		lio->dev_capability |= NETIF_F_GSO_UDP_TUNNEL;
 
-		netdev_feature_zero(&netdev->vlan_features);
+		netdev_feature_zero(netdev->vlan_features);
 		netdev_feature_set_bits(lio->dev_capability,
-					&netdev->vlan_features);
+					netdev->vlan_features);
 		/* Add any unchangeable hw features */
 		lio->dev_capability |=  NETIF_F_HW_VLAN_CTAG_FILTER |
 					NETIF_F_HW_VLAN_CTAG_RX |
 					NETIF_F_HW_VLAN_CTAG_TX;
 
-		netdev_feature_zero(&netdev->features);
+		netdev_feature_zero(netdev->features);
 		netdev_feature_set_bits(lio->dev_capability,
-					&netdev->features);
-		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
+					netdev->features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, netdev->features);
 
-		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
 		netdev_feature_set_bits(lio->dev_capability,
-					&netdev->hw_features);
+					netdev->hw_features);
 		/*HW_VLAN_RX and HW_VLAN_FILTER is always on*/
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					 &netdev->hw_features);
+					 netdev->hw_features);
 
 		/* MTU range: 68 - 16000 */
 		netdev->min_mtu = LIO_MIN_MTU_SIZE;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 170c3b0aaaee..71fc6aeb438a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1816,32 +1816,32 @@ static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
  * @returns updated features list
  */
 static void liquidio_fix_features(struct net_device *netdev,
-				  netdev_features_t *request)
+				  netdev_features_t request)
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
 		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
 		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_TSO))
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_TSO6))
 		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, request);
 
-	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *request) &&
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, request) &&
 	    !(lio->dev_capability & NETIF_F_LRO))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
 
 	/* Disable LRO if RXCSUM is off */
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *request) &&
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, request) &&
 	    netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features) &&
 	    (lio->dev_capability & NETIF_F_LRO))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, request);
@@ -1857,7 +1857,7 @@ static int liquidio_set_features(struct net_device *netdev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct lio *lio = netdev_priv(netdev);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, changed))
 		return 0;
 
@@ -2116,33 +2116,33 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					  | NETIF_F_TSO | NETIF_F_TSO6
 					  | NETIF_F_LRO;
 
-		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_zero(netdev->hw_enc_features);
 		netdev_feature_set_bits(lio->enc_dev_capability,
-					&netdev->hw_enc_features);
+					netdev->hw_enc_features);
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT,
-					 &netdev->hw_enc_features);
+					 netdev->hw_enc_features);
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
-		netdev_feature_zero(&netdev->vlan_features);
+		netdev_feature_zero(netdev->vlan_features);
 		netdev_feature_set_bits(lio->enc_dev_capability,
-					&netdev->vlan_features);
+					netdev->vlan_features);
 
 		/* Add any unchangeable hw features */
 		lio->dev_capability |= NETIF_F_HW_VLAN_CTAG_FILTER |
 				       NETIF_F_HW_VLAN_CTAG_RX |
 				       NETIF_F_HW_VLAN_CTAG_TX;
 
-		netdev_feature_zero(&netdev->features);
+		netdev_feature_zero(netdev->features);
 		netdev_feature_set_bits(lio->enc_dev_capability,
-					&netdev->features);
-		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
+					netdev->features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, netdev->features);
 
-		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
 		netdev_feature_set_bits(lio->enc_dev_capability,
-					&netdev->hw_features);
+					netdev->hw_features);
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					 &netdev->hw_features);
+					 netdev->hw_features);
 
 		/* MTU range: 68 - 16000 */
 		netdev->min_mtu = LIO_MIN_MTU_SIZE;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index be88c1b8a0a2..b614036fb5d7 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1775,11 +1775,11 @@ static int nicvf_config_loopback(struct nicvf *nic,
 }
 
 static void nicvf_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
-	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, features) &&
 	    netif_running(netdev) && !nic->loopback_supported)
 		netdev_feature_clear_bit(NETIF_F_LOOPBACK_BIT, features);
 }
@@ -1790,7 +1790,7 @@ static int nicvf_set_features(struct net_device *netdev,
 	struct nicvf *nic = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		nicvf_config_vlan_stripping(nic, features);
@@ -2213,22 +2213,22 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_unregister_interrupts;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_SG |
 				NETIF_F_TSO | NETIF_F_GRO | NETIF_F_TSO6 |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_HW_VLAN_CTAG_RX, &netdev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_RX, netdev->hw_features);
 
-	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, netdev->hw_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, netdev->hw_features);
 
-	netdev_feature_zero(&netdev->vlan_features);
+	netdev_feature_zero(netdev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
 	netdev->netdev_ops = &nicvf_netdev_ops;
 	netdev->watchdog_timeo = NICVF_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 6d4fbb1bd303..91366404aa40 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -859,13 +859,13 @@ static int t1_set_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void t1_fix_features(struct net_device *dev, netdev_features_t *features)
+static void t1_fix_features(struct net_device *dev, netdev_features_t features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -877,7 +877,7 @@ static int t1_set_features(struct net_device *dev, netdev_features_t features)
 	struct adapter *adapter = dev->ml_priv;
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t1_vlan_mode(adapter, features);
 
@@ -1037,27 +1037,27 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->mem_end = mmio_start + mmio_len - 1;
 		netdev->ml_priv = adapter;
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-					NETIF_F_RXCSUM, &netdev->hw_features);
+					NETIF_F_RXCSUM, netdev->hw_features);
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 					NETIF_F_RXCSUM | NETIF_F_LLTX,
-					&netdev->features);
+					netdev->features);
 
 		if (pci_using_dac)
 			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-					       &netdev->features);
+					       netdev->features);
 		if (vlan_tso_capable(adapter)) {
 			netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 						NETIF_F_HW_VLAN_CTAG_RX,
-						&netdev->features);
+						netdev->features);
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 
 			/* T204: disable TSO */
 			if (!(is_T2(adapter)) || bi->port_number != 4) {
 				netdev_feature_set_bit(NETIF_F_TSO_BIT,
-						       &netdev->hw_features);
+						       netdev->hw_features);
 				netdev_feature_set_bit(NETIF_F_TSO_BIT,
-						       &netdev->features);
+						       netdev->features);
 			}
 		}
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 806d4a4d4ffe..1b71df4a4cee 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2253,10 +2253,10 @@ static int cxgb_siocdevprivate(struct net_device *dev,
 		if (t.lro >= 0) {
 			if (t.lro)
 				netdev_feature_set_bit(NETIF_F_GRO_BIT,
-						       &dev->wanted_features);
+						       dev->wanted_features);
 			else
 				netdev_feature_clear_bit(NETIF_F_GRO_BIT,
-							 &dev->wanted_features);
+							 dev->wanted_features);
 			netdev_update_features(dev);
 		}
 
@@ -2600,13 +2600,13 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 }
 
 static void cxgb_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -2617,7 +2617,7 @@ static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		cxgb_vlan_mode(dev, features);
 
@@ -3319,22 +3319,22 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->irq = pdev->irq;
 		netdev->mem_start = mmio_start;
 		netdev->mem_end = mmio_start + mmio_len - 1;
-		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 					NETIF_F_TSO | NETIF_F_RXCSUM |
 					NETIF_F_HW_VLAN_CTAG_RX,
-					&netdev->hw_features);
-		netdev_feature_or(&netdev->features, netdev->features,
+					netdev->hw_features);
+		netdev_feature_or(netdev->features, netdev->features,
 				  netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-				       &netdev->features);
-		netdev_feature_copy(&tmp, netdev->features);
-		netdev_feature_and_bits(VLAN_FEAT, &tmp);
-		netdev_feature_or(&netdev->vlan_features,
+				       netdev->features);
+		netdev_feature_copy(tmp, netdev->features);
+		netdev_feature_and_bits(VLAN_FEAT, tmp);
+		netdev_feature_or(netdev->vlan_features,
 				  netdev->vlan_features, tmp);
 		if (pci_using_dac)
 			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-					       &netdev->features);
+					       netdev->features);
 
 		netdev->netdev_ops = &cxgb_netdev_ops;
 		netdev->ethtool_ops = &cxgb_ethtool_ops;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
index a10ee671514b..eb1d9bb2c790 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
@@ -79,10 +79,10 @@ int cxgb_fcoe_enable(struct net_device *netdev)
 
 	dev_info(adap->pdev_dev, "Enabling FCoE offload features\n");
 
-	netdev_feature_set_bit(NETIF_F_FCOE_CRC_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_FCOE_CRC_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_FCOE_CRC_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_FCOE_CRC_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, netdev->vlan_features);
 
 	netdev_features_change(netdev);
 
@@ -110,10 +110,10 @@ int cxgb_fcoe_disable(struct net_device *netdev)
 
 	fcoe->flags &= ~CXGB_FCOE_ENABLED;
 
-	netdev_feature_clear_bit(NETIF_F_FCOE_CRC_BIT, &netdev->features);
-	netdev_feature_clear_bit(NETIF_F_FCOE_CRC_BIT, &netdev->vlan_features);
-	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
-	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, &netdev->vlan_features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_CRC_BIT, netdev->features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_CRC_BIT, netdev->vlan_features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, netdev->features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, netdev->vlan_features);
 
 	netdev_features_change(netdev);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 260695dd4f68..4c755457db27 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1277,7 +1277,7 @@ static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err;
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		return 0;
 
@@ -1286,9 +1286,9 @@ static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 			    netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
 						    features), true);
 	if (unlikely(err)) {
-		netdev_feature_copy(&dev->features, features);
+		netdev_feature_copy(dev->features, features);
 		netdev_feature_change_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					  &dev->features);
+					  dev->features);
 	}
 
 	return err;
@@ -3843,7 +3843,7 @@ static const struct udp_tunnel_nic_info cxgb_udp_tunnels = {
 };
 
 static void cxgb_features_check(struct sk_buff *skb, struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
@@ -3861,10 +3861,10 @@ static void cxgb_features_check(struct sk_buff *skb, struct net_device *dev,
 }
 
 static void cxgb_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	/* Disable GRO, if RX_CSUM is disabled */
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_GRO_BIT, features);
 }
 
@@ -6825,12 +6825,12 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pi->port_id = i;
 		netdev->irq = pdev->irq;
 
-		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
 		netdev_feature_set_bits(NETIF_F_SG | TSO_FLAGS |
 			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
 			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_TC | NETIF_F_NTUPLE, &netdev->hw_features);
+			NETIF_F_HW_TC | NETIF_F_NTUPLE, netdev->hw_features);
 
 		if (chip_ver > CHELSIO_T5) {
 			netdev_feature_set_bits(NETIF_F_IP_CSUM |
@@ -6839,11 +6839,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 						NETIF_F_GSO_UDP_TUNNEL |
 						NETIF_F_GSO_UDP_TUNNEL_CSUM |
 						NETIF_F_TSO | NETIF_F_TSO6,
-						&netdev->hw_enc_features);
+						netdev->hw_enc_features);
 			netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 						NETIF_F_GSO_UDP_TUNNEL_CSUM |
 						NETIF_F_HW_TLS_RECORD,
-						&netdev->hw_features);
+						netdev->hw_features);
 
 			if (adapter->rawf_cnt)
 				netdev->udp_tunnel_nic_info = &cxgb_udp_tunnels;
@@ -6851,15 +6851,15 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		if (highdma)
 			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-					       &netdev->hw_features);
-		netdev_feature_or(&netdev->features, netdev->features,
+					       netdev->hw_features);
+		netdev_feature_or(netdev->features, netdev->features,
 				  netdev->hw_features);
-		netdev_feature_copy(&netdev->vlan_features, netdev->features);
-		netdev_feature_and_bits(VLAN_FEAT, &netdev->vlan_features);
+		netdev_feature_copy(netdev->vlan_features, netdev->features);
+		netdev_feature_and_bits(VLAN_FEAT, netdev->vlan_features);
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
 			netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 			netdev->tlsdev_ops = &cxgb4_ktls_ops;
 			/* initialize the refcount */
 			refcount_set(&pi->adapter->chcr_ktls.ktls_refcount, 0);
@@ -6868,9 +6868,9 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_IPSEC_INLINE) {
 			netdev_feature_set_bit(NETIF_F_HW_ESP_BIT,
-					       &netdev->hw_enc_features);
+					       netdev->hw_enc_features);
 			netdev_feature_set_bit(NETIF_F_HW_ESP_BIT,
-					       &netdev->features);
+					       netdev->features);
 			netdev->xfrmdev_ops = &cxgb4_xfrmdev_ops;
 		}
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 5b2730de38c8..d906bb53792c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1174,13 +1174,13 @@ static int cxgb4vf_change_mtu(struct net_device *dev, int new_mtu)
 }
 
 static void cxgb4vf_fix_features(struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -1193,7 +1193,7 @@ static int cxgb4vf_set_features(struct net_device *dev,
 	struct port_info *pi = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t4vf_set_rxmode(pi->adapter, pi->viid, -1, -1, -1, -1,
 				netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -3072,19 +3072,19 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		pi->xact_addr_filt = -1;
 		netdev->irq = pdev->irq;
 
-		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
 		netdev_feature_set_bits(NETIF_F_SG | TSO_FLAGS | NETIF_F_GRO |
 					NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 					NETIF_F_RXCSUM |
 					NETIF_F_HW_VLAN_CTAG_TX |
 					NETIF_F_HW_VLAN_CTAG_RX,
-					&netdev->hw_features);
-		netdev_feature_copy(&netdev->features, netdev->hw_features);
+					netdev->hw_features);
+		netdev_feature_copy(netdev->features, netdev->hw_features);
 		if (pci_using_dac)
 			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-					       &netdev->features);
-		netdev_feature_copy(&netdev->vlan_features, netdev->features);
-		netdev_feature_and_bits(VLAN_FEAT, &netdev->vlan_features);
+					       netdev->features);
+		netdev_feature_copy(netdev->vlan_features, netdev->features);
+		netdev_feature_and_bits(VLAN_FEAT, netdev->vlan_features);
 
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 		netdev->min_mtu = 81;
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index d77266ef0035..54a0abb35577 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -751,7 +751,7 @@ static struct net_device *ep93xx_dev_alloc(struct ep93xx_eth_data *data)
 	dev->ethtool_ops = &ep93xx_ethtool_ops;
 	dev->netdev_ops = &ep93xx_netdev_ops;
 
-	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM, &dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM, dev->features);
 
 	return dev;
 }
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index fde5078c9132..cc799c321f36 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -241,7 +241,7 @@ static const struct udp_tunnel_nic_info enic_udp_tunnels = {
 };
 
 static void enic_features_check(struct sk_buff *skb, struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	const struct ethhdr *eth = (struct ethhdr *)skb_inner_mac_header(skb);
 	struct enic *enic = netdev_priv(dev);
@@ -2901,27 +2901,27 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	enic_set_ethtool_ops(netdev);
 
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, netdev->features);
 	if (ENIC_SETTING(enic, LOOP)) {
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-					 &netdev->features);
+					 netdev->features);
 		enic->loop_enable = 1;
 		enic->loop_tag = enic->config.loop_tag;
 		dev_info(dev, "loopback tag=0x%04x\n", enic->loop_tag);
 	}
 	if (ENIC_SETTING(enic, TXCSUM))
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
-					&netdev->hw_features);
+					netdev->hw_features);
 	if (ENIC_SETTING(enic, TSO))
 		netdev_feature_set_bits(NETIF_F_TSO |
 					NETIF_F_TSO6 | NETIF_F_TSO_ECN,
-					&netdev->hw_features);
+					netdev->hw_features);
 	if (ENIC_SETTING(enic, RSS))
 		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (ENIC_SETTING(enic, RXCSUM))
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (ENIC_SETTING(enic, VXLAN)) {
 		u64 patch_level;
 		u64 a1 = 0;
@@ -2933,8 +2933,8 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					NETIF_F_GSO_UDP_TUNNEL	|
 					NETIF_F_HW_CSUM		|
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&netdev->hw_enc_features);
-		netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+					netdev->hw_enc_features);
+		netdev_feature_or(netdev->hw_features, netdev->hw_features,
 				  netdev->hw_enc_features);
 		/* get bit mask from hw about supported offload bit level
 		 * BIT(0) = fw supports patch_level 0
@@ -2968,17 +2968,17 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 
 #ifdef CONFIG_RFS_ACCEL
-	netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, netdev->hw_features);
 #endif
 
 	if (using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index bc3575dc2a87..af8292b11d77 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1977,7 +1977,7 @@ static int gmac_change_mtu(struct net_device *netdev, int new_mtu)
 }
 
 static void gmac_fix_features(struct net_device *netdev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	if (netdev->mtu + ETH_HLEN + VLAN_HLEN > MTU_SIZE_BIT_MASK)
 		netdev_feature_clear_bits(GMAC_OFFLOAD_FEATURES, features);
@@ -2454,10 +2454,10 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	spin_lock_init(&port->config_lock);
 	gmac_clear_hw_stats(netdev);
 
-	netdev_feature_zero(&netdev->hw_features);
-	netdev_feature_set_bits(GMAC_OFFLOAD_FEATURES, &netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
+	netdev_feature_set_bits(GMAC_OFFLOAD_FEATURES, netdev->hw_features);
 	netdev_feature_set_bits(GMAC_OFFLOAD_FEATURES | NETIF_F_GRO,
-				&netdev->features);
+				netdev->features);
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
 	 * payloads of 10236 bytes minus VLAN and ethernet header
 	 */
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 8e4ca68c1986..16c75f13e5e5 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -589,7 +589,7 @@ static int dm9000_set_features(struct net_device *dev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	unsigned long flags;
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
@@ -1648,10 +1648,10 @@ dm9000_probe(struct platform_device *pdev)
 
 	/* dm9000a/b are capable of hardware checksum offload */
 	if (db->type == TYPE_DM9000A || db->type == TYPE_DM9000B) {
-		netdev_feature_zero(&ndev->hw_features);
+		netdev_feature_zero(ndev->hw_features);
 		netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM,
-					&ndev->hw_features);
-		netdev_feature_or(&ndev->features, ndev->features,
+					ndev->hw_features);
+		netdev_feature_or(ndev->features, ndev->features,
 				  ndev->hw_features);
 	}
 
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 70bfa9167a81..7fe4bf6ac7c6 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -763,7 +763,7 @@ static int dnet_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* TODO: Actually, we have some interesting features... */
-	netdev_feature_set_bits(0, &dev->features);
+	netdev_feature_set_bits(0, dev->features);
 
 	bp = netdev_priv(dev);
 	bp->dev = dev;
diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 48d14efcab13..4dbda8bdaba2 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -524,7 +524,7 @@ static int ec_bhf_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	pci_set_drvdata(dev, net_dev);
 	SET_NETDEV_DEV(net_dev, &dev->dev);
 
-	netdev_feature_zero(&net_dev->features);
+	netdev_feature_zero(net_dev->features);
 	net_dev->flags |= IFF_NOARP;
 
 	net_dev->netdev_ops = &ec_bhf_netdev_ops;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index b8faf899dfb3..a5ea3202e19d 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4005,7 +4005,7 @@ static int be_vxlan_set_port(struct net_device *netdev, unsigned int table,
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_GSO_UDP_TUNNEL,
-				&netdev->hw_enc_features);
+				netdev->hw_enc_features);
 
 	dev_info(dev, "Enabled VxLAN offloads for UDP port %d\n",
 		 be16_to_cpu(ti->port));
@@ -4027,7 +4027,7 @@ static int be_vxlan_unset_port(struct net_device *netdev, unsigned int table,
 	adapter->flags &= ~BE_FLAGS_VXLAN_OFFLOADS;
 	adapter->vxlan_port = 0;
 
-	netdev_feature_zero(&netdev->hw_enc_features);
+	netdev_feature_zero(netdev->hw_enc_features);
 	return 0;
 }
 
@@ -5069,7 +5069,7 @@ static struct be_cmd_work *be_alloc_work(struct be_adapter *adapter,
 }
 
 static void be_features_check(struct sk_buff *skb, struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	struct be_adapter *adapter = netdev_priv(dev);
 	u8 l4_hdr = 0;
@@ -5196,19 +5196,19 @@ static void be_netdev_init(struct net_device *netdev)
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_RXCSUM |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&netdev->hw_features);
+				netdev->hw_features);
 	if ((be_if_cap_flags(adapter) & BE_IF_FLAGS_RSS))
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, netdev->hw_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&netdev->features);
+				netdev->features);
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -5852,7 +5852,7 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 
 	status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (!status) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 	} else {
 		status = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (status) {
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 0bca71d3ebf0..2c0bae69de73 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1215,7 +1215,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	/* setup the net_device structure */
 	netdev->netdev_ops = &ethoc_netdev_ops;
 	netdev->watchdog_timeo = ETHOC_TIMEOUT;
-	netdev_feature_set_bits(0, &netdev->features);
+	netdev_feature_set_bits(0, netdev->features);
 	netdev->ethtool_ops = &ethoc_ethtool_ops;
 
 	/* setup NAPI */
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 8552bbaa8256..a740729f4a10 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1587,7 +1587,7 @@ static int ftgmac100_set_features(struct net_device *netdev,
 	if (!netif_running(netdev))
 		return 0;
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	/* Update the vlan filtering bit */
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		u32 maccr;
@@ -1905,25 +1905,25 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	priv->tx_q_entries = priv->new_tx_q_entries = DEF_TX_QUEUE_ENTRIES;
 
 	/* Base feature set */
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
 				NETIF_F_GRO | NETIF_F_SG |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	if (priv->use_ncsi)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
 		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT,
-					 &netdev->hw_features);
+					 netdev->hw_features);
 	if (np && of_get_property(np, "no-hw-checksum", NULL))
 		netdev_feature_clear_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM,
-					  &netdev->hw_features);
-	netdev_feature_or(&netdev->features, netdev->features,
+					  netdev->hw_features);
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 
 	/* register network device */
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 2087fd4adea8..e967aa4a9eb7 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -251,23 +251,23 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_LLTX | NETIF_F_RXHASH,
-				&net_dev->hw_features);
+				net_dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA,
-				&net_dev->hw_features);
+				net_dev->hw_features);
 
 	/* The kernels enables GSO automatically, if we declare NETIF_F_SG.
 	 * For conformity, we'll still declare GSO explicitly.
 	 */
-	netdev_feature_set_bit(NETIF_F_GSO_BIT, &net_dev->features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &net_dev->features);
+	netdev_feature_set_bit(NETIF_F_GSO_BIT, net_dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, net_dev->features);
 
 	net_dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	/* we do not want shared skbs on TX */
 	net_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 
-	netdev_feature_or(&net_dev->features, net_dev->features,
+	netdev_feature_or(net_dev->features, net_dev->features,
 			  net_dev->hw_features);
-	netdev_feature_copy(&net_dev->vlan_features, net_dev->features);
+	netdev_feature_copy(net_dev->vlan_features, net_dev->features);
 
 	if (is_valid_ether_addr(mac_addr)) {
 		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 796a311c1a0a..898cd7bb8afd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2146,7 +2146,7 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 	bool enable;
 	int err;
 
-	netdev_feature_xor(&changed, features, net_dev->features);
+	netdev_feature_xor(changed, features, net_dev->features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
 		enable = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 						 features);
@@ -4108,17 +4108,17 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	net_dev->priv_flags &= ~not_supported;
 
 	/* Features */
-	netdev_feature_zero(&net_dev->features);
+	netdev_feature_zero(net_dev->features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_SG | NETIF_F_HIGHDMA |
 				NETIF_F_LLTX | NETIF_F_HW_TC,
-				&net_dev->features);
-	netdev_feature_copy(&net_dev->hw_features, net_dev->features);
+				net_dev->features);
+	netdev_feature_copy(net_dev->hw_features, net_dev->features);
 
 	if (priv->dpni_attrs.vlan_filter_entries)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &net_dev->hw_features);
+				       net_dev->hw_features);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 8c2d9b6cf5dc..550ded78c177 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3275,10 +3275,10 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	/* The DPAA2 switch's ingress path depends on the VLAN table,
 	 * thus we are not able to disable VLAN filtering.
 	 */
-	netdev_feature_zero(&port_netdev->features);
+	netdev_feature_zero(port_netdev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_STAG_FILTER |
-				NETIF_F_HW_TC, &port_netdev->features);
+				NETIF_F_HW_TC, port_netdev->features);
 
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 719da3a38e36..c9a0bb4dc7ff 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2357,7 +2357,7 @@ int enetc_set_features(struct net_device *ndev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err = 0;
 
-	netdev_feature_xor(&changed, ndev->features, features);
+	netdev_feature_xor(changed, ndev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, changed))
 		enetc_set_rss(ndev, netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index e4a3b3d8d98f..a0f73dbf0296 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -707,7 +707,7 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, ndev->features, features);
+	netdev_feature_xor(changed, ndev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				    changed)) {
@@ -764,19 +764,19 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_LOOPBACK, &ndev->hw_features);
-	netdev_feature_zero(&ndev->features);
+				NETIF_F_LOOPBACK, ndev->hw_features);
+	netdev_feature_zero(ndev->features);
 	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, ndev->features);
 
 	if (si->num_rss)
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, ndev->hw_features);
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -785,8 +785,8 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &ndev->features);
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, ndev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, ndev->hw_features);
 	}
 
 	/* pick up primary MAC address from SI */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 615562e39783..22b07ef95360 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -120,17 +120,17 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
 				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &ndev->hw_features);
-	netdev_feature_zero(&ndev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, ndev->hw_features);
+	netdev_feature_zero(ndev->features);
 	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, ndev->features);
 
 	if (si->num_rss)
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, ndev->hw_features);
 
 	/* pick up primary MAC address from SI */
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 987267f897b9..03e2f3ca91bb 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3375,8 +3375,8 @@ static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 	struct fec_enet_private *fep = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_xor(changed, features, netdev->features);
+	netdev_feature_copy(netdev->features, features);
 
 	/* Receive checksum has been changed */
 	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
@@ -3393,7 +3393,7 @@ static int fec_set_features(struct net_device *netdev,
 	struct fec_enet_private *fep = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (netif_running(netdev) &&
 	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
@@ -3564,7 +3564,7 @@ static int fec_enet_init(struct net_device *ndev)
 	if (fep->quirks & FEC_QUIRK_HAS_VLAN)
 		/* enable hw VLAN support */
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-				       &ndev->features);
+				       ndev->features);
 
 	if (fep->quirks & FEC_QUIRK_HAS_CSUM) {
 		ndev->gso_max_segs = FEC_MAX_TSO_SEGS;
@@ -3572,7 +3572,7 @@ static int fec_enet_init(struct net_device *ndev)
 		/* enable hw accelerator */
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 					NETIF_F_RXCSUM | NETIF_F_SG |
-					NETIF_F_TSO, &ndev->features);
+					NETIF_F_TSO, ndev->features);
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
@@ -3581,7 +3581,7 @@ static int fec_enet_init(struct net_device *ndev)
 		fep->rx_align = 0x3f;
 	}
 
-	netdev_feature_copy(&ndev->hw_features, ndev->features);
+	netdev_feature_copy(ndev->hw_features, ndev->features);
 
 	fec_restart(ndev);
 
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 07965565d056..cd64e4a89a49 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1026,7 +1026,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 
 	netif_carrier_off(ndev);
 
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->features);
 
 	ret = register_netdev(ndev);
 	if (ret)
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 852b5d5d4f47..575a77a4c82b 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3247,20 +3247,20 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
-		netdev_feature_zero(&dev->hw_features);
+		netdev_feature_zero(dev->hw_features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
-					NETIF_F_RXCSUM, &dev->hw_features);
+					NETIF_F_RXCSUM, dev->hw_features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
 					NETIF_F_RXCSUM | NETIF_F_HIGHDMA,
-					&dev->features);
+					dev->features);
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 					NETIF_F_HW_VLAN_CTAG_RX,
-					&dev->hw_features);
+					dev->hw_features);
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-				       &dev->features);
+				       dev->features);
 	}
 
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index f90708d51ecf..158e5ec46eeb 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -507,7 +507,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err = 0;
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (!netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				      NETIF_F_HW_VLAN_CTAG_RX |
@@ -517,7 +517,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 	while (test_and_set_bit_lock(GFAR_RESETTING, &priv->state))
 		cpu_relax();
 
-	netdev_feature_copy(&dev->features, features);
+	netdev_feature_copy(dev->features, features);
 
 	if (dev->flags & IFF_UP) {
 		/* Now we take down the rings to rebuild them */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index e63476be8b76..d37717fa0541 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -719,7 +719,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	} else {
 		/* DQO supports LRO. */
 		netdev_feature_set_bit(NETIF_F_LRO_BIT,
-				       &priv->dev->hw_features);
+				       priv->dev->hw_features);
 		err = gve_set_desc_cnt_dqo(priv, descriptor, dev_op_dqo_rda);
 	}
 	if (err)
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 1e964410d4fd..f3c18c779052 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1116,11 +1116,11 @@ static int gve_set_features(struct net_device *netdev,
 	struct gve_priv *priv = netdev_priv(netdev);
 	int err;
 
-	netdev_feature_copy(&orig_features, netdev->features);
+	netdev_feature_copy(orig_features, netdev->features);
 
 	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features) !=
 	    netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
-		netdev_feature_change_bit(NETIF_F_LRO_BIT, &netdev->features);
+		netdev_feature_change_bit(NETIF_F_LRO_BIT, netdev->features);
 
 		if (netif_carrier_ok(netdev)) {
 			/* To make this process as simple as possible we
@@ -1143,7 +1143,7 @@ static int gve_set_features(struct net_device *netdev,
 	return 0;
 err:
 	/* Reverts the change on error. */
-	netdev_feature_copy(&netdev->features, orig_features);
+	netdev_feature_copy(netdev->features, orig_features);
 	netif_err(priv, drv, netdev,
 		  "Set features failed! !!! DISABLING ALL QUEUES !!!\n");
 	return err;
@@ -1521,16 +1521,16 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Features might be set in other locations as well (such as
 	 * `gve_adminq_describe_device`).
 	 */
-	netdev_feature_zero(&dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_TSO_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 	dev->watchdog_timeo = 5 * HZ;
 	dev->min_mtu = ETH_MIN_MTU;
 	netif_carrier_off(dev);
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index f91387efc7ef..27c420d336a0 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -591,7 +591,7 @@ bool gve_rx_poll(struct gve_notify_block *block, int budget)
 	struct gve_rx_ring *rx = block->rx;
 	bool repoll = false;
 
-	netdev_feature_copy(&feat, block->napi.dev->features);
+	netdev_feature_copy(feat, block->napi.dev->features);
 
 	/* If budget is 0, do all the work */
 	if (budget == 0)
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 90ac50df604d..7ceeb6400e25 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -672,7 +672,7 @@ int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 	u64 bytes = 0;
 	int err;
 
-	netdev_feature_copy(&feat, napi->dev->features);
+	netdev_feature_copy(feat, napi->dev->features);
 
 	while (work_done < budget) {
 		struct gve_rx_compl_desc_dqo *compl_desc =
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index da15dbf69475..aa5faf16d0e4 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1234,11 +1234,11 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 
 	if (HAS_CAP_TSO(priv->hw_cap))
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->hw_features);
 
-	netdev_feature_or(&ndev->features, ndev->features, ndev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->hw_features);
-	netdev_feature_or(&ndev->vlan_features, ndev->vlan_features,
+	netdev_feature_or(ndev->features, ndev->features, ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->hw_features);
+	netdev_feature_or(ndev->vlan_features, ndev->vlan_features,
 			  ndev->features);
 
 	ret = hix5hd2_init_hw_desc_queue(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 6a7235d94985..f235e125a0de 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1792,12 +1792,12 @@ static int hns_nic_set_features(struct net_device *netdev,
 		}
 		break;
 	}
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 	return 0;
 }
 
 static void hns_nic_fix_features(struct net_device *netdev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 
@@ -2330,25 +2330,25 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-				NETIF_F_GRO, &ndev->features);
+				NETIF_F_GRO, ndev->features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_RXCSUM, &ndev->vlan_features);
+				NETIF_F_RXCSUM, ndev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO,
-				&ndev->vlan_features);
+				ndev->vlan_features);
 
 	/* MTU range: 68 - 9578 (v1) or 9706 (v2) */
 	ndev->min_mtu = MAC_MIN_MTU;
 	switch (priv->enet_ver) {
 	case AE_VERSION_2:
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6 |
-					NETIF_F_NTUPLE, &ndev->features);
+					NETIF_F_NTUPLE, ndev->features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 					NETIF_F_RXCSUM | NETIF_F_SG |
 					NETIF_F_GSO | NETIF_F_GRO |
 					NETIF_F_TSO | NETIF_F_TSO6,
-					&ndev->hw_features);
+					ndev->hw_features);
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&ndev->vlan_features);
+					ndev->vlan_features);
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 		break;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ad522b163242..5ac15be5e902 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2322,7 +2322,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	bool enable;
 	int ret;
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, changed) &&
 	    h->ae_algo->ops->set_gro_en) {
@@ -2365,12 +2365,12 @@ static int hns3_nic_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 	return 0;
 }
 
 static void hns3_features_check(struct sk_buff *skb, struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 #define HNS3_MAX_HDR_LEN	480U
 #define HNS3_MAX_L4_HDR_LEN	60U
@@ -3148,55 +3148,55 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
-			       &netdev->gso_partial_features);
+			       netdev->gso_partial_features);
 
 	netdev_feature_set_bit_array(hns3_features_array,
 				     ARRAY_SIZE(hns3_features_array),
-				     &netdev->features);
+				     netdev->features);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, netdev->features);
 
 		if (!(h->flags & HNAE3_SUPPORT_VF))
 			netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
-					       &netdev->features);
+					       netdev->features);
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->features);
 	else
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-					&netdev->features);
+					netdev->features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->features);
 
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  netdev->features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &netdev->hw_features);
+					 netdev->hw_features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				  NETIF_F_HW_VLAN_CTAG_TX |
 				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW |
 				  NETIF_F_NTUPLE | NETIF_F_HW_TC,
-				  &netdev->vlan_features);
+				  netdev->vlan_features);
 
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  netdev->vlan_features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->hw_enc_features);
+			       netdev->hw_enc_features);
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index fc0765db66d1..bfd30511cdc5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -889,12 +889,12 @@ static int hinic_set_features(struct net_device *netdev,
 }
 
 static void hinic_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		netif_info(nic_dev, drv, netdev, "disabling LRO as RXCSUM is off\n");
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 	}
@@ -942,24 +942,24 @@ static const struct net_device_ops hinicvf_netdev_ops = {
 static void netdev_features_init(struct net_device *netdev)
 {
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_RXCSUM | NETIF_F_LRO |
 				NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM,
-				&netdev->hw_features);
+				netdev->hw_features);
 
-	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
+	netdev_feature_copy(netdev->vlan_features, netdev->hw_features);
 
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, &netdev->features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, netdev->features);
 
-	netdev_feature_zero(&netdev->hw_enc_features);
+	netdev_feature_zero(netdev->hw_enc_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
 				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
 				NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL,
-				&netdev->hw_enc_features);
+				netdev->hw_enc_features);
 }
 
 static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
@@ -1086,11 +1086,11 @@ static int set_features(struct hinic_dev *nic_dev,
 	int err = 0;
 
 	if (force_change)
-		netdev_feature_fill(&changed);
+		netdev_feature_fill(changed);
 	else
-		netdev_feature_xor(&changed, pre_features, features);
+		netdev_feature_xor(changed, pre_features, features);
 
-	netdev_feature_zero(&failed_features);
+	netdev_feature_zero(failed_features);
 
 	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, changed)) {
 		ret = hinic_port_set_tso(nic_dev,
@@ -1100,7 +1100,7 @@ static int set_features(struct hinic_dev *nic_dev,
 		if (ret) {
 			err = ret;
 			netdev_feature_set_bit(NETIF_F_TSO_BIT,
-					       &failed_features);
+					       failed_features);
 		}
 	}
 
@@ -1109,7 +1109,7 @@ static int set_features(struct hinic_dev *nic_dev,
 		if (ret) {
 			err = ret;
 			netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-					       &failed_features);
+					       failed_features);
 		}
 	}
 
@@ -1122,7 +1122,7 @@ static int set_features(struct hinic_dev *nic_dev,
 		if (ret) {
 			err = ret;
 			netdev_feature_set_bit(NETIF_F_LRO_BIT,
-					       &failed_features);
+					       failed_features);
 		}
 	}
 
@@ -1133,12 +1133,12 @@ static int set_features(struct hinic_dev *nic_dev,
 		if (ret) {
 			err = ret;
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					       &failed_features);
+					       failed_features);
 		}
 	}
 
 	if (err) {
-		netdev_feature_xor(&nic_dev->netdev->features, features, failed_features);
+		netdev_feature_xor(nic_dev->netdev->features, features, failed_features);
 		return -EIO;
 	}
 
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index dba57bb6684f..201a37670f55 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2991,20 +2991,20 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 	dev->netdev_ops = &ehea_netdev_ops;
 	ehea_set_ethtool_ops(dev);
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO |
 				NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_CTAG_TX,
-				&dev->hw_features);
-	netdev_feature_zero(&dev->features);
+				dev->hw_features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO |
 				NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM,
-				&dev->features);
-	netdev_feature_zero(&dev->vlan_features);
+				dev->features);
+	netdev_feature_zero(dev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_HIGHDMA |
-				NETIF_F_IP_CSUM, &dev->vlan_features);
+				NETIF_F_IP_CSUM, dev->vlan_features);
 	dev->watchdog_timeo = EHEA_WATCH_DOG_TIMEOUT;
 
 	/* MTU range: 68 - 9022 */
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index a2a45f39d363..4738c4c6119a 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3168,11 +3168,11 @@ static int emac_probe(struct platform_device *ofdev)
 		goto err_detach_tah;
 
 	if (dev->tah_dev) {
-		netdev_feature_zero(&ndev->hw_features);
+		netdev_feature_zero(ndev->hw_features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
-					&ndev->hw_features);
-		netdev_feature_copy(&ndev->features, ndev->hw_features);
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &ndev->features);
+					ndev->hw_features);
+		netdev_feature_copy(ndev->features, ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, ndev->features);
 	}
 	ndev->watchdog_timeo = 5 * HZ;
 	if (emac_phy_supports_gige(dev->phy_mode)) {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 834a9036469a..14c1d43172de 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -743,7 +743,7 @@ static void netdev_get_drvinfo(struct net_device *dev,
 }
 
 static void ibmveth_fix_features(struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	/*
 	 * Since the ibmveth firmware interface does not have the
@@ -754,7 +754,7 @@ static void ibmveth_fix_features(struct net_device *dev,
 	 * checksummed.
 	 */
 
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 }
 
@@ -804,7 +804,7 @@ static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
 
 			if (data == 1)
 				netdev_feature_clear_bit(NETIF_F_IP_CSUM_BIT,
-							 &dev->features);
+							 dev->features);
 
 		} else {
 			adapter->fw_ipv4_csum_support = data;
@@ -823,7 +823,7 @@ static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
 
 			if (data == 1)
 				netdev_feature_clear_bit(NETIF_F_IPV6_CSUM_BIT,
-							 &dev->features);
+							 dev->features);
 
 		} else
 			adapter->fw_ipv6_csum_support = data;
@@ -885,7 +885,7 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 			if (data == 1)
 				netdev_feature_clear_bits(NETIF_F_TSO |
 							  NETIF_F_TSO6,
-							  &dev->features);
+							  dev->features);
 			rc1 = -EIO;
 
 		} else {
@@ -898,7 +898,7 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 		 */
 		if (data == 1) {
 			netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
-						 &dev->features);
+						 dev->features);
 			netdev_info(dev, "TSO feature requires all partitions to have updated driver");
 		}
 		adapter->large_send = data;
@@ -925,20 +925,20 @@ static int ibmveth_set_features(struct net_device *dev,
 	if (rx_csum != adapter->rx_csum) {
 		rc1 = ibmveth_set_csum_offload(dev, rx_csum);
 		if (rc1 && !adapter->rx_csum) {
-			netdev_feature_copy(&dev->features, features);
+			netdev_feature_copy(dev->features, features);
 			netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
 						  NETIF_F_RXCSUM,
-						  &dev->features);
+						  dev->features);
 		}
 	}
 
 	if (large_send != adapter->large_send) {
 		rc2 = ibmveth_set_tso(dev, large_send);
 		if (rc2 && !adapter->large_send) {
-			netdev_feature_copy(&dev->features, features);
+			netdev_feature_copy(dev->features, features);
 			netdev_feature_clear_bits(NETIF_F_TSO |
 						  NETIF_F_TSO6,
-						  &dev->features);
+						  dev->features);
 		}
 	}
 
@@ -1703,13 +1703,13 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->netdev_ops = &ibmveth_netdev_ops;
 	netdev->ethtool_ops = &netdev_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
-	netdev_feature_zero(&netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
 	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-					NETIF_F_RXCSUM, &netdev->hw_features);
+					NETIF_F_RXCSUM, netdev->hw_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 
 	ret = h_illan_attributes(adapter->vdev->unit_address, 0, 0, &ret_attr);
@@ -1718,19 +1718,19 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	if (ret == H_SUCCESS && (ret_attr & IBMVETH_ILLAN_LRG_SND_SUPPORT) &&
 	    !old_large_send) {
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&netdev->hw_features);
-		netdev_feature_or(&netdev->features, netdev->features,
+					netdev->hw_features);
+		netdev_feature_or(netdev->features, netdev->features,
 				  netdev->hw_features);
 	} else {
-		netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->hw_features);
 	}
 
 	adapter->is_active_trunk = false;
 	if (ret == H_SUCCESS && (ret_attr & IBMVETH_ILLAN_ACTIVE_TRUNK)) {
 		adapter->is_active_trunk = true;
 		netdev_feature_set_bit(NETIF_F_FRAGLIST_BIT,
-				       &netdev->hw_features);
-		netdev_feature_set_bit(NETIF_F_FRAGLIST_BIT, &netdev->features);
+				       netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_FRAGLIST_BIT, netdev->features);
 	}
 
 	netdev->min_mtu = IBMVETH_MIN_MTU;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4008951a24fd..e3dba26f4502 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3004,7 +3004,7 @@ static int ibmvnic_change_mtu(struct net_device *netdev, int new_mtu)
 }
 
 static void ibmvnic_features_check(struct sk_buff *skb, struct net_device *dev,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	/* Some backing hardware adapters can not
 	 * handle packets with a MSS less than 224
@@ -4540,58 +4540,58 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	ctrl_buf->large_rx_ipv4 = 0;
 	ctrl_buf->large_rx_ipv6 = 0;
 
-	netdev_feature_zero(&old_hw_features);
+	netdev_feature_zero(old_hw_features);
 
 	if (adapter->state != VNIC_PROBING) {
-		netdev_feature_copy(&old_hw_features,
+		netdev_feature_copy(old_hw_features,
 				    adapter->netdev->hw_features);
-		netdev_feature_zero(&adapter->netdev->hw_features);
+		netdev_feature_zero(adapter->netdev->hw_features);
 	}
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO,
-				&adapter->netdev->hw_features);
+				adapter->netdev->hw_features);
 
 	if (buf->tcp_ipv4_chksum || buf->udp_ipv4_chksum)
 		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-				       &adapter->netdev->hw_features);
+				       adapter->netdev->hw_features);
 
 	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
 		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-				       &adapter->netdev->hw_features);
+				       adapter->netdev->hw_features);
 
 	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
 				     adapter->netdev->features))
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &adapter->netdev->hw_features);
+				       adapter->netdev->hw_features);
 
 	if (buf->large_tx_ipv4)
 		netdev_feature_set_bit(NETIF_F_TSO_BIT,
-				       &adapter->netdev->hw_features);
+				       adapter->netdev->hw_features);
 	if (buf->large_tx_ipv6)
 		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-				       &adapter->netdev->hw_features);
+				       adapter->netdev->hw_features);
 
 	if (adapter->state == VNIC_PROBING) {
-		netdev_feature_or(&adapter->netdev->features,
+		netdev_feature_or(adapter->netdev->features,
 				  adapter->netdev->features,
 				  adapter->netdev->hw_features);
 	} else if (!netdev_feature_equal(old_hw_features,
 					 adapter->netdev->hw_features)) {
 		__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
-		netdev_feature_zero(&tmp);
+		netdev_feature_zero(tmp);
 
 		/* disable features no longer supported */
-		netdev_feature_and(&adapter->netdev->features,
+		netdev_feature_and(adapter->netdev->features,
 				   adapter->netdev->features,
 				   adapter->netdev->hw_features);
 		/* turn on features now supported if previously enabled */
-		netdev_feature_xor(&tmp, old_hw_features,
+		netdev_feature_xor(tmp, old_hw_features,
 				   adapter->netdev->hw_features);
-		netdev_feature_and(&tmp, tmp, adapter->netdev->hw_features);
-		netdev_feature_and(&tmp, tmp,
+		netdev_feature_and(tmp, tmp, adapter->netdev->hw_features);
+		netdev_feature_and(tmp, tmp,
 				   adapter->netdev->wanted_features);
-		netdev_feature_or(&adapter->netdev->features,
+		netdev_feature_or(adapter->netdev->features,
 				  adapter->netdev->features, tmp);
 	}
 
@@ -5108,7 +5108,7 @@ static void handle_query_cap_rsp(union ibmvnic_crq *crq,
 		    be64_to_cpu(crq->query_capability.number);
 		if (adapter->vlan_header_insertion)
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
-					       &netdev->features);
+					       netdev->features);
 		netdev_dbg(netdev, "vlan_header_insertion = %lld\n",
 			   adapter->vlan_header_insertion);
 		break;
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 4208d8fd3b2e..5263a6aa9f3c 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2797,12 +2797,12 @@ static int e100_set_features(struct net_device *netdev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct nic *nic = netdev_priv(netdev);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (!netdev_feature_test_bits(NETIF_F_RXFCS | NETIF_F_RXALL, changed))
 		return 0;
 
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 	e100_exec_cb(nic, NULL, e100_configure);
 	return 1;
 }
@@ -2831,9 +2831,9 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!(netdev = alloc_etherdev(sizeof(struct nic))))
 		return -ENOMEM;
 
-	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, netdev->hw_features);
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, netdev->hw_features);
 
 	netdev->netdev_ops = &e100_netdev_ops;
 	netdev->ethtool_ops = &e100_ethtool_ops;
@@ -2891,7 +2891,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* D100 MAC doesn't allow rx of vlan packets with normal MTU */
 	if (nic->mac < mac_82558_D101_A4)
 		netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 	/* locks must be initialized before calling hw_reset */
 	spin_lock_init(&nic->cb_lock);
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 218b8a944645..110e3ffe0ea2 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -788,12 +788,12 @@ static int e1000_is_need_ioport(struct pci_dev *pdev)
 }
 
 static void e1000_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -806,7 +806,7 @@ static int e1000_set_features(struct net_device *netdev,
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		e1000_vlan_mode(netdev, features);
@@ -814,7 +814,7 @@ static int e1000_set_features(struct net_device *netdev,
 	if (!netdev_feature_test_bits(NETIF_F_RXCSUM | NETIF_F_RXALL, changed))
 		return 0;
 
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 	adapter->rx_csum = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
 						   features);
 
@@ -1037,40 +1037,40 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	if (hw->mac_type >= e1000_82543) {
-		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
 		netdev_feature_set_bits(NETIF_F_SG |
 					NETIF_F_HW_CSUM |
 					NETIF_F_HW_VLAN_CTAG_RX,
-					&netdev->hw_features);
-		netdev_feature_zero(&netdev->features);
+					netdev->hw_features);
+		netdev_feature_zero(netdev->features);
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 					NETIF_F_HW_VLAN_CTAG_FILTER,
-					&netdev->features);
+					netdev->features);
 	}
 
 	if ((hw->mac_type >= e1000_82544) &&
 	   (hw->mac_type != e1000_82547))
-		netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->hw_features);
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM |
 				NETIF_F_RXALL |
 				NETIF_F_RXFCS,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	if (pci_using_dac) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-				       &netdev->vlan_features);
+				       netdev->vlan_features);
 	}
 
 	netdev_feature_set_bits(NETIF_F_TSO |
 				NETIF_F_HW_CSUM |
 				NETIF_F_SG,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
 	/* Do not set IFF_UNICAST_FLT for VMWare's 82545EM */
 	if (hw->device_id != E1000_DEV_ID_82545EM_COPPER ||
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 4e36331c76d9..241d671b5035 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5316,15 +5316,15 @@ static void e1000_watchdog_task(struct work_struct *work)
 				case SPEED_100:
 					e_info("10/100 speed: disabling TSO\n");
 					netdev_feature_clear_bit(NETIF_F_TSO_BIT,
-								 &netdev->features);
+								 netdev->features);
 					netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
-								 &netdev->features);
+								 netdev->features);
 					break;
 				case SPEED_1000:
 					netdev_feature_clear_bit(NETIF_F_TSO_BIT,
-								 &netdev->features);
+								 netdev->features);
 					netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
-								 &netdev->features);
+								 netdev->features);
 					break;
 				default:
 					/* oops */
@@ -5332,9 +5332,9 @@ static void e1000_watchdog_task(struct work_struct *work)
 				}
 				if (hw->mac.type == e1000_pch_spt) {
 					netdev_feature_clear_bit(NETIF_F_TSO_BIT,
-								 &netdev->features);
+								 netdev->features);
 					netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
-								 &netdev->features);
+								 netdev->features);
 				}
 			}
 
@@ -7305,7 +7305,7 @@ static void e1000_eeprom_checks(struct e1000_adapter *adapter)
 }
 
 static void e1000_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
@@ -7317,7 +7317,7 @@ static void e1000_fix_features(struct net_device *netdev,
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -7330,7 +7330,7 @@ static int e1000_set_features(struct net_device *netdev,
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6, changed))
 		adapter->flags |= FLAG_TSO_FORCE;
@@ -7356,7 +7356,7 @@ static int e1000_set_features(struct net_device *netdev,
 		}
 	}
 
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 
 	if (netif_running(netdev))
 		e1000e_reinit_locked(adapter);
@@ -7546,7 +7546,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "PHY reset is blocked due to SOL/IDER session.\n");
 
 	/* Set initial default active device features */
-	netdev_feature_zero(&netdev->features);
+	netdev_feature_zero(netdev->features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX |
@@ -7555,30 +7555,30 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_RXHASH |
 				NETIF_F_RXCSUM |
 				NETIF_F_HW_CSUM,
-				&netdev->features);
+				netdev->features);
 
 	/* Set user-changeable features (subset of all device features) */
-	netdev_feature_copy(&netdev->hw_features, netdev->features);
-	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &netdev->hw_features);
+	netdev_feature_copy(netdev->hw_features, netdev->features);
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, netdev->hw_features);
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, netdev->hw_features);
 
 	if (adapter->flags & FLAG_HAS_HW_VLAN_FILTER)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_HW_CSUM,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (pci_using_dac) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-				       &netdev->vlan_features);
+				       netdev->vlan_features);
 	}
 
 	/* MTU range: 68 - max_hw_frame_size */
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index ed2871d62804..f66803b9c698 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -775,7 +775,7 @@ static int fm10k_tso(struct fm10k_ring *tx_ring,
 
 err_vxlan:
 	netdev_feature_clear_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-				 &tx_ring->netdev->features);
+				 tx_ring->netdev->features);
 	if (net_ratelimit())
 		netdev_err(tx_ring->netdev,
 			   "TSO requested for unsupported tunnel, disabling offload\n");
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index dbefa249e560..8525dee96b9f 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1505,7 +1505,7 @@ static void fm10k_dfwd_del_station(struct net_device *dev, void *priv)
 }
 
 static void fm10k_features_check(struct sk_buff *skb, struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	if (!skb->encapsulation || fm10k_tx_encap_offload(skb))
 		return;
@@ -1565,7 +1565,7 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 				NETIF_F_TSO_ECN |
 				NETIF_F_RXHASH |
 				NETIF_F_RXCSUM,
-				&dev->features);
+				dev->features);
 
 	/* Only the PF can support VXLAN and NVGRE tunnel offloads */
 	if (info->mac == fm10k_mac_pf) {
@@ -1576,22 +1576,22 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 					NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_IPV6_CSUM |
 					NETIF_F_SG,
-					&dev->hw_enc_features);
+					dev->hw_enc_features);
 
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-				       &dev->features);
+				       dev->features);
 
 		dev->udp_tunnel_nic_info = &fm10k_udp_tunnels;
 	}
 
 	/* all features defined to this point should be changeable */
-	netdev_feature_copy(&hw_features, dev->features);
+	netdev_feature_copy(hw_features, dev->features);
 
 	/* allow user to enable L2 forwarding acceleration */
-	netdev_feature_set_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT, &hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT, hw_features);
 
 	/* configure VLAN features */
-	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+	netdev_feature_or(dev->vlan_features, dev->vlan_features,
 			  dev->features);
 
 	/* we want to leave these both on as we cannot disable VLAN tag
@@ -1601,12 +1601,11 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&dev->features);
+				dev->features);
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev_feature_or(&dev->hw_features, dev->hw_features,
-			  hw_features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, hw_features);
 
 	/* MTU range: 68 - 15342 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index 48c1206246d0..6611cb8bda9c 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -306,10 +306,10 @@ static int fm10k_handle_reset(struct fm10k_intfc *interface)
 
 		if (hw->mac.vlan_override)
 			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-						 &netdev->features);
+						 netdev->features);
 		else
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					       &netdev->features);
+					       netdev->features);
 	}
 
 	err = netif_running(netdev) ? fm10k_open(netdev) : 0;
@@ -2012,9 +2012,9 @@ static int fm10k_sw_init(struct fm10k_intfc *interface,
 
 	/* update netdev with DMA restrictions */
 	if (dma_get_mask(&pdev->dev) > DMA_BIT_MASK(32)) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-				       &netdev->vlan_features);
+				       netdev->vlan_features);
 	}
 
 	/* reset and initialize the hardware so it is in a known state */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d4692a9f2a55..e9e3d1e9ff38 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12878,7 +12878,7 @@ static int i40e_ndo_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
  * @features: Offload features that the stack believes apply
  **/
 static void i40e_features_check(struct sk_buff *skb, struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	size_t len;
 
@@ -13329,7 +13329,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
 
-	netdev_feature_zero(&hw_enc_features);
+	netdev_feature_zero(hw_enc_features);
 	netdev_feature_set_bits(NETIF_F_SG_BIT			|
 				NETIF_F_IP_CSUM_BIT		|
 				NETIF_F_IPV6_CSUM_BIT		|
@@ -13350,50 +13350,50 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 				NETIF_F_SCTP_CRC_BIT		|
 				NETIF_F_RXHASH_BIT		|
 				NETIF_F_RXCSUM_BIT,
-				&hw_enc_features);
+				hw_enc_features);
 
 	if (!(pf->hw_features & I40E_HW_OUTER_UDP_CSUM_CAPABLE))
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-				       &netdev->gso_partial_features);
+				       netdev->gso_partial_features);
 
 	netdev->udp_tunnel_nic_info = &pf->udp_tunnel_nic;
 
 	netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
-			       &netdev->gso_partial_features);
+			       netdev->gso_partial_features);
 
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  hw_enc_features);
 
 	/* record features VLANs can make use of */
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  hw_enc_features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->vlan_features);
+			       netdev->vlan_features);
 
 	/* enable macvlan offloads */
 	netdev_feature_set_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 
-	netdev_feature_copy(&hw_features, hw_enc_features);
+	netdev_feature_copy(hw_features, hw_enc_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-			       &hw_features);
+			       hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-			       &hw_features);
+			       hw_features);
 
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED)) {
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &hw_features);
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, hw_features);
 	}
 
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  hw_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &netdev->features);
+			       netdev->features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->hw_enc_features);
+			       netdev->hw_enc_features);
 
 	if (vsi->type == I40E_VSI_MAIN) {
 		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 0897ee2740ee..9c24a6c0c78e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3356,7 +3356,7 @@ static int iavf_set_features(struct net_device *netdev,
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	/* Don't allow changing VLAN_RX flag when adapter is not capable
 	 * of VLAN offload
 	 */
@@ -3385,7 +3385,7 @@ static int iavf_set_features(struct net_device *netdev,
  * @features: Offload features that the stack believes apply
  **/
 static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	size_t len;
 
@@ -3444,7 +3444,7 @@ static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
  * Returns fixed-up features bits
  **/
 static void iavf_fix_features(struct net_device *netdev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
@@ -3537,7 +3537,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	}
 	adapter->num_req_queues = 0;
 
-	netdev_feature_zero(&hw_enc_features);
+	netdev_feature_zero(hw_enc_features);
 	netdev_feature_set_bits(NETIF_F_SG		|
 				NETIF_F_IP_CSUM		|
 				NETIF_F_IPV6_CSUM	|
@@ -3549,7 +3549,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 				NETIF_F_SCTP_CRC	|
 				NETIF_F_RXHASH		|
 				NETIF_F_RXCSUM,
-				&hw_enc_features);
+				hw_enc_features);
 
 	/* advertise to stack only if offloads for encapsulated packets is
 	 * supported
@@ -3562,49 +3562,49 @@ int iavf_process_config(struct iavf_adapter *adapter)
 					NETIF_F_GSO_IPXIP6		|
 					NETIF_F_GSO_UDP_TUNNEL_CSUM	|
 					NETIF_F_GSO_PARTIAL,
-					&hw_enc_features);
+					hw_enc_features);
 
 		if (!(vfres->vf_cap_flags &
 		      VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM))
 			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-					       &netdev->gso_partial_features);
+					       netdev->gso_partial_features);
 
 		netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
-				       &netdev->gso_partial_features);
+				       netdev->gso_partial_features);
 		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-				       &netdev->hw_enc_features);
-		netdev_feature_or(&netdev->hw_enc_features,
+				       netdev->hw_enc_features);
+		netdev_feature_or(netdev->hw_enc_features,
 				  netdev->hw_enc_features, hw_enc_features);
 	}
 	/* record features VLANs can make use of */
-	netdev_feature_or(&netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features,
 			  netdev->vlan_features, hw_enc_features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->vlan_features);
+			       netdev->vlan_features);
 
 	/* Write features and hw_features separately to avoid polluting
 	 * with, or dropping, features that are set when we registered.
 	 */
-	netdev_feature_copy(&hw_features, hw_enc_features);
+	netdev_feature_copy(hw_features, hw_enc_features);
 
 	/* Enable VLAN features if supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-					NETIF_F_HW_VLAN_CTAG_RX, &hw_features);
+					NETIF_F_HW_VLAN_CTAG_RX, hw_features);
 	/* Enable cloud filter if ADQ is supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ)
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, hw_features);
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
-		netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, &hw_features);
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, hw_features);
 
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  hw_features);
 
-	netdev_feature_or(&netdev->features, netdev->features, hw_features);
+	netdev_feature_or(netdev->features, netdev->features, hw_features);
 
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -3616,24 +3616,24 @@ int iavf_process_config(struct iavf_adapter *adapter)
 					     netdev->wanted_features) ||
 		    netdev->mtu < 576)
 			netdev_feature_clear_bit(NETIF_F_TSO_BIT,
-						 &netdev->features);
+						 netdev->features);
 		if (!netdev_feature_test_bit(NETIF_F_TSO6_BIT,
 					     netdev->wanted_features) ||
 		    netdev->mtu < 576)
 			netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
-						 &netdev->features);
+						 netdev->features);
 		if (!netdev_feature_test_bit(NETIF_F_TSO_ECN_BIT,
 					     netdev->wanted_features))
 			netdev_feature_clear_bit(NETIF_F_TSO_ECN_BIT,
-						 &netdev->features);
+						 netdev->features);
 		if (!netdev_feature_test_bit(NETIF_F_GRO_BIT,
 					     netdev->wanted_features))
 			netdev_feature_clear_bit(NETIF_F_GRO_BIT,
-						 &netdev->features);
+						 netdev->features);
 		if (!netdev_feature_test_bit(NETIF_F_GSO_BIT,
 					     netdev->wanted_features))
 			netdev_feature_clear_bit(NETIF_F_GSO_BIT,
-						 &netdev->features);
+						 netdev->features);
 	}
 
 	adapter->vsi.id = adapter->vsi_res->vsi_id;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index bb76ea65dbc1..822c48291680 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3065,34 +3065,34 @@ static void ice_set_netdev_features(struct net_device *netdev)
 
 	if (ice_is_safe_mode(pf)) {
 		/* safe mode */
-		netdev_feature_zero(&netdev->features);
+		netdev_feature_zero(netdev->features);
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA,
-					&netdev->features);
-		netdev_feature_copy(&netdev->hw_features, netdev->features);
+					netdev->features);
+		netdev_feature_copy(netdev->hw_features, netdev->features);
 		return;
 	}
 
-	netdev_feature_zero(&dflt_features);
+	netdev_feature_zero(dflt_features);
 	netdev_feature_set_bits(NETIF_F_SG		|
 				NETIF_F_HIGHDMA		|
 				NETIF_F_NTUPLE		|
 				NETIF_F_RXHASH,
-				&dflt_features);
+				dflt_features);
 
-	netdev_feature_zero(&csumo_features);
+	netdev_feature_zero(csumo_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM		|
 				NETIF_F_IP_CSUM		|
 				NETIF_F_SCTP_CRC	|
 				NETIF_F_IPV6_CSUM,
-				&csumo_features);
+				csumo_features);
 
-	netdev_feature_zero(&vlano_features);
+	netdev_feature_zero(vlano_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER	|
 				NETIF_F_HW_VLAN_CTAG_TX		|
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&vlano_features);
+				vlano_features);
 
-	netdev_feature_zero(&tso_features);
+	netdev_feature_zero(tso_features);
 	netdev_feature_set_bits(NETIF_F_TSO			|
 				NETIF_F_TSO_ECN			|
 				NETIF_F_TSO6			|
@@ -3104,34 +3104,34 @@ static void ice_set_netdev_features(struct net_device *netdev)
 				NETIF_F_GSO_IPXIP4		|
 				NETIF_F_GSO_IPXIP6		|
 				NETIF_F_GSO_UDP_L4,
-				&tso_features);
+				tso_features);
 
 	netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL_CSUM |
 				NETIF_F_GSO_GRE_CSUM,
-				&netdev->gso_partial_features);
+				netdev->gso_partial_features);
 	/* set features that user can change */
-	netdev_feature_or(&netdev->hw_features, dflt_features,
+	netdev_feature_or(netdev->hw_features, dflt_features,
 			  csumo_features);
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  vlano_features);
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  tso_features);
 
 	/* add support for HW_CSUM on packets with MPLS header */
-	netdev_feature_zero(&netdev->mpls_features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
+	netdev_feature_zero(netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->mpls_features);
 
 	/* enable features */
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 	/* encap and VLAN devices inherit default, csumo and tso features */
-	netdev_feature_or(&netdev->hw_enc_features, dflt_features,
+	netdev_feature_or(netdev->hw_enc_features, dflt_features,
 			  csumo_features);
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  tso_features);
-	netdev_feature_or(&netdev->vlan_features, dflt_features,
+	netdev_feature_or(netdev->vlan_features, dflt_features,
 			  csumo_features);
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  tso_features);
 }
 
@@ -7213,7 +7213,7 @@ int ice_stop(struct net_device *netdev)
  */
 static void ice_features_check(struct sk_buff *skb,
 			       struct net_device __always_unused *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	size_t len;
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e4582a4ec30e..3d67f5ced451 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2434,12 +2434,12 @@ void igb_reset(struct igb_adapter *adapter)
 }
 
 static void igb_fix_features(struct net_device *netdev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -2452,7 +2452,7 @@ static int igb_set_features(struct net_device *netdev,
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igb_vlan_mode(netdev, features);
@@ -2475,7 +2475,7 @@ static int igb_set_features(struct net_device *netdev,
 		adapter->nfc_filter_count = 0;
 	}
 
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 
 	if (netif_running(netdev))
 		igb_reinit_locked(adapter);
@@ -2507,7 +2507,7 @@ static int igb_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 #define IGB_MAX_NETWORK_HDR_LEN	511
 
 static void igb_features_check(struct sk_buff *skb, struct net_device *dev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
@@ -2539,7 +2539,7 @@ static void igb_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation &&
-	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 }
 
@@ -3278,14 +3278,14 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_RXHASH |
 				NETIF_F_RXCSUM |
 				NETIF_F_HW_CSUM,
-				&netdev->features);
+				netdev->features);
 
 	if (hw->mac.type >= e1000_82576)
 		netdev_feature_set_bits(NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4,
-					&netdev->features);
+					netdev->features);
 
 	if (hw->mac.type >= e1000_i350)
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->features);
 
 #define IGB_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				  NETIF_F_GSO_GRE_CSUM | \
@@ -3294,41 +3294,41 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  NETIF_F_GSO_UDP_TUNNEL | \
 				  NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_zero(netdev->gso_partial_features);
 	netdev_feature_set_bits(IGB_GSO_PARTIAL_FEATURES,
-				&netdev->gso_partial_features);
+				netdev->gso_partial_features);
 	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
 				IGB_GSO_PARTIAL_FEATURES,
-				&netdev->features);
+				netdev->features);
 
 	/* copy netdev features into list of user selectable features */
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  netdev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_RXALL,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	if (hw->mac.type >= e1000_i350)
 		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			       netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->mpls_features);
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&netdev->features);
+				netdev->features);
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 2cad7a2c1e59..4b89ee67f5e4 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2620,7 +2620,7 @@ static int igbvf_set_features(struct net_device *netdev,
 #define IGBVF_MAX_NETWORK_HDR_LEN	511
 
 static void igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
@@ -2650,7 +2650,7 @@ static void igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation &&
-	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 }
 
@@ -2770,14 +2770,14 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	adapter->bd_number = cards_found++;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_RXCSUM |
 				NETIF_F_HW_CSUM |
 				NETIF_F_SCTP_CRC,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 #define IGBVF_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				    NETIF_F_GSO_GRE_CSUM | \
@@ -2786,31 +2786,31 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				    NETIF_F_GSO_UDP_TUNNEL | \
 				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_zero(netdev->gso_partial_features);
 	netdev_feature_set_bits(IGBVF_GSO_PARTIAL_FEATURES,
-				&netdev->gso_partial_features);
+				netdev->gso_partial_features);
 	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
 				IGBVF_GSO_PARTIAL_FEATURES,
-				&netdev->hw_features);
+				netdev->hw_features);
 
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			       netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->mpls_features);
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&netdev->features);
+				netdev->features);
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index d5d79ed550fe..c23df9ce3f56 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4922,12 +4922,12 @@ static void igc_get_stats64(struct net_device *netdev,
 }
 
 static void igc_fix_features(struct net_device *netdev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
@@ -4940,7 +4940,7 @@ static int igc_set_features(struct net_device *netdev,
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igc_vlan_mode(netdev, features);
@@ -4952,7 +4952,7 @@ static int igc_set_features(struct net_device *netdev,
 	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features))
 		igc_flush_nfc_rules(adapter);
 
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 
 	if (netif_running(netdev))
 		igc_reinit_locked(adapter);
@@ -4963,7 +4963,7 @@ static int igc_set_features(struct net_device *netdev,
 }
 
 static void igc_features_check(struct sk_buff *skb, struct net_device *dev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
@@ -4993,7 +4993,7 @@ static void igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation &&
-	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_clear_bits(NETIF_F_TSO_BIT, features);
 }
 
@@ -6328,14 +6328,14 @@ static int igc_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	/* Add supported features to the features list*/
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_SCTP_CRC_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_SCTP_CRC_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->features);
 
 #define IGC_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				  NETIF_F_GSO_GRE_CSUM | \
@@ -6344,11 +6344,11 @@ static int igc_probe(struct pci_dev *pdev,
 				  NETIF_F_GSO_UDP_TUNNEL | \
 				  NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_zero(netdev->gso_partial_features);
 	netdev_feature_set_bits(IGC_GSO_PARTIAL_FEATURES,
-				&netdev->gso_partial_features);
+				netdev->gso_partial_features);
 	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL | IGC_GSO_PARTIAL_FEATURES,
-				&netdev->features);
+				netdev->features);
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
@@ -6356,22 +6356,22 @@ static int igc_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	/* copy netdev features into list of user selectable features */
-	netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-			       &netdev->hw_features);
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+			       netdev->hw_features);
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  netdev->features);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
-	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->mpls_features);
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  netdev->vlan_features);
 
 	/* MTU range: 68 - 9216 */
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 4357e43666c5..1e75c762a547 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -294,13 +294,13 @@ ixgb_reset(struct ixgb_adapter *adapter)
 }
 
 static void ixgb_fix_features(struct net_device *netdev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	/*
 	 * Tx VLAN insertion does not work per HW design when Rx stripping is
 	 * disabled.
 	 */
-	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					 features);
 }
@@ -311,7 +311,7 @@ ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (!netdev_feature_test_bits(NETIF_F_RXCSUM |
 				      NETIF_F_HW_VLAN_CTAG_RX,
@@ -438,22 +438,22 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_HW_CSUM |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&netdev->hw_features);
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+				netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &netdev->features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->hw_features);
+			       netdev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->hw_features);
 
 	if (pci_using_dac) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-				       &netdev->vlan_features);
+				       netdev->vlan_features);
 	}
 
 	/* MTU range: 68 - 16114 */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 57009d1c1490..2c2eaa20b028 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -859,7 +859,7 @@ int ixgbe_fcoe_enable(struct net_device *netdev)
 
 	/* enable FCoE and notify stack */
 	adapter->flags |= IXGBE_FLAG_FCOE_ENABLED;
-	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_FCOE_MTU_BIT, netdev->features);
 	netdev_features_change(netdev);
 
 	/* release existing queues and reallocate them */
@@ -899,7 +899,7 @@ int ixgbe_fcoe_disable(struct net_device *netdev)
 
 	/* disable FCoE and notify stack */
 	adapter->flags &= ~IXGBE_FLAG_FCOE_ENABLED;
-	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, &netdev->features);
+	netdev_feature_clear_bit(NETIF_F_FCOE_MTU_BIT, netdev->features);
 
 	netdev_features_change(netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index fc31773b2631..cae9740df669 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4904,7 +4904,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 	__DECLARE_NETDEV_FEATURE_MASK(features);
 	int count;
 
-	netdev_feature_copy(&features, netdev->features);
+	netdev_feature_copy(features, netdev->features);
 
 	/* Check for Promiscuous and All Multicast modes */
 	fctrl = IXGBE_READ_REG(hw, IXGBE_FCTRL);
@@ -4922,7 +4922,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 		fctrl |= (IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
 		vmolr |= IXGBE_VMOLR_MPE;
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &features);
+					 features);
 	} else {
 		if (netdev->flags & IFF_ALLMULTI) {
 			fctrl |= IXGBE_FCTRL_MPE;
@@ -9692,12 +9692,12 @@ void ixgbe_do_reset(struct net_device *netdev)
 }
 
 static void ixgbe_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then RSC/LRO should also be disabled */
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 
 	/* Turn off LRO if not RSC capable */
@@ -9705,7 +9705,7 @@ static void ixgbe_fix_features(struct net_device *netdev,
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 
 	if (adapter->xdp_prog &&
-	    netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
+	    netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
 		e_dev_err("LRO is not supported with XDP\n");
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 	}
@@ -9734,7 +9734,7 @@ static int ixgbe_set_features(struct net_device *netdev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	bool need_reset = false;
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 
 	/* Make sure RSC matches LRO, reset if change */
 	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
@@ -9789,7 +9789,7 @@ static int ixgbe_set_features(struct net_device *netdev,
 	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, changed))
 		need_reset = true;
 
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_L2FW_DOFFLOAD_BIT, changed) &&
 	    adapter->num_rx_pools > 1)
@@ -10082,7 +10082,7 @@ static void ixgbe_fwd_del(struct net_device *pdev, void *priv)
 #define IXGBE_MAX_NETWORK_HDR_LEN	511
 
 static void ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
@@ -10116,7 +10116,7 @@ static void ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * the TSO, so it's the exception.
 	 */
 	if (skb->encapsulation &&
-	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features)) {
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, features)) {
 #ifdef CONFIG_IXGBE_IPSEC
 		if (!secpath_exists(skb))
 #endif
@@ -10806,14 +10806,14 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 skip_sriov:
 
 #endif
-	netdev_feature_zero(&netdev->features);
+	netdev_feature_zero(netdev->features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_RXHASH |
 				NETIF_F_RXCSUM |
 				NETIF_F_HW_CSUM,
-				&netdev->features);
+				netdev->features);
 
 #define IXGBE_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				    NETIF_F_GSO_GRE_CSUM | \
@@ -10822,17 +10822,17 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				    NETIF_F_GSO_UDP_TUNNEL | \
 				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_zero(netdev->gso_partial_features);
 	netdev_feature_set_bits(IXGBE_GSO_PARTIAL_FEATURES,
-				&netdev->gso_partial_features);
+				netdev->gso_partial_features);
 	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
 				IXGBE_GSO_PARTIAL_FEATURES,
-				&netdev->features);
+				netdev->features);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
 		netdev_feature_set_bits(NETIF_F_SCTP_CRC |
 					NETIF_F_GSO_UDP_L4,
-					&netdev->features);
+					netdev->features);
 
 #ifdef CONFIG_IXGBE_IPSEC
 #define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
@@ -10840,45 +10840,45 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				 NETIF_F_GSO_ESP)
 
 	if (adapter->ipsec)
-		netdev_feature_set_bits(IXGBE_ESP_FEATURES, &netdev->features);
+		netdev_feature_set_bits(IXGBE_ESP_FEATURES, netdev->features);
 #endif
 	/* copy netdev features into list of user selectable features */
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  netdev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_RXALL |
 				NETIF_F_HW_L2FW_DOFFLOAD,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
 		netdev_feature_set_bits(NETIF_F_NTUPLE |
 					NETIF_F_HW_TC,
-					&netdev->hw_features);
+					netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->vlan_features);
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+			       netdev->vlan_features);
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  netdev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_HW_CSUM,
-				&netdev->mpls_features);
+				netdev->mpls_features);
 	netdev_feature_set_bits(IXGBE_GSO_PARTIAL_FEATURES,
-				&netdev->mpls_features);
+				netdev->mpls_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&netdev->features);
+				netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
@@ -10908,18 +10908,18 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		netdev_feature_set_bits(NETIF_F_FSO |
 					NETIF_F_FCOE_CRC,
-					&netdev->features);
+					netdev->features);
 
 		netdev_feature_set_bits(NETIF_F_FSO |
 					NETIF_F_FCOE_CRC |
 					NETIF_F_FCOE_MTU,
-					&netdev->vlan_features);
+					netdev->vlan_features);
 	}
 #endif /* IXGBE_FCOE */
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE)
-		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, netdev->hw_features);
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
-		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, netdev->features);
 
 	if (ixgbe_check_fw_error(adapter)) {
 		err = -EIO;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 60288efd19f9..3288a0d5d2f6 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -656,9 +656,9 @@ void ixgbevf_init_ipsec_offload(struct ixgbevf_adapter *adapter)
 				 NETIF_F_GSO_ESP)
 
 	netdev_feature_set_bits(IXGBEVF_ESP_FEATURES,
-				&adapter->netdev->features);
+				adapter->netdev->features);
 	netdev_feature_set_bits(IXGBEVF_ESP_FEATURES,
-				&adapter->netdev->hw_enc_features);
+				adapter->netdev->hw_enc_features);
 
 	return;
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index f3d7e744f400..8a851598fd3c 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4385,7 +4385,7 @@ static void ixgbevf_get_stats(struct net_device *netdev,
 #define IXGBEVF_MAX_NETWORK_HDR_LEN	511
 
 static void ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
@@ -4415,7 +4415,7 @@ static void ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation &&
-	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features))
+	    !netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 }
 
@@ -4587,14 +4587,14 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_sw_init;
 	}
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_RXCSUM |
 				NETIF_F_HW_CSUM |
 				NETIF_F_SCTP_CRC,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 #define IXGBEVF_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
 				      NETIF_F_GSO_GRE_CSUM | \
@@ -4603,37 +4603,37 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				      NETIF_F_GSO_UDP_TUNNEL | \
 				      NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-	netdev_feature_zero(&netdev->gso_partial_features);
+	netdev_feature_zero(netdev->gso_partial_features);
 	netdev_feature_set_bits(IXGBEVF_GSO_PARTIAL_FEATURES,
-				&netdev->gso_partial_features);
+				netdev->gso_partial_features);
 	netdev_feature_set_bits(NETIF_F_GSO_PARTIAL |
 				IXGBEVF_GSO_PARTIAL_FEATURES,
-				&netdev->hw_features);
+				netdev->hw_features);
 
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 	netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-			       &netdev->vlan_features);
+			       netdev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_HW_CSUM,
-				&netdev->mpls_features);
+				netdev->mpls_features);
 	netdev_feature_set_bits(IXGBEVF_GSO_PARTIAL_FEATURES,
-				&netdev->mpls_features);
-	netdev_feature_or(&netdev->hw_enc_features, netdev->hw_enc_features,
+				netdev->mpls_features);
+	netdev_feature_or(netdev->hw_enc_features, netdev->hw_enc_features,
 			  netdev->vlan_features);
 
 	/* set this bit last since it cannot be part of vlan_features */
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&netdev->features);
+				netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 3abd80bbe7dc..7e482ad9ca49 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2661,7 +2661,7 @@ jme_set_msglevel(struct net_device *netdev, u32 value)
 }
 
 static void jme_fix_features(struct net_device *netdev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
 	if (netdev->mtu > 1900)
 		netdev_feature_clear_bits(NETIF_F_ALL_TSO | NETIF_F_CSUM_MASK,
@@ -2955,15 +2955,15 @@ jme_init_one(struct pci_dev *pdev,
 	netdev->netdev_ops = &jme_netdev_ops;
 	netdev->ethtool_ops		= &jme_ethtool_ops;
 	netdev->watchdog_timeo		= TX_TIMEOUT;
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM |
 				NETIF_F_SG |
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_RXCSUM,
-				&netdev->hw_features);
-	netdev_feature_zero(&netdev->features);
+				netdev->hw_features);
+	netdev_feature_zero(netdev->features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM |
 				NETIF_F_SG |
@@ -2971,9 +2971,9 @@ jme_init_one(struct pci_dev *pdev,
 				NETIF_F_TSO6 |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&netdev->features);
+				netdev->features);
 	if (using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
 	/* MTU range: 1280 - 9202*/
 	netdev->min_mtu = IPV6_MIN_MTU;
@@ -3036,7 +3036,7 @@ jme_init_one(struct pci_dev *pdev,
 	jme->reg_gpreg1 = GPREG1_DEFAULT;
 
 	if (jme->reg_rxmcs & RXMCS_CHECKSUM)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->features);
 
 	/*
 	 * Get Max Read Req Size from PCI Config Space
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b14aab7f7aff..57b2b070866d 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3188,13 +3188,13 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	dev->watchdog_timeo = 2 * HZ;
 	dev->base_addr = 0;
 
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO,
-				&dev->features);
-	netdev_feature_copy(&dev->vlan_features, dev->features);
+				dev->features);
+	netdev_feature_copy(dev->vlan_features, dev->features);
 
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
-	netdev_feature_copy(&dev->hw_features, dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
+	netdev_feature_copy(dev->hw_features, dev->features);
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->gso_max_segs = MV643XX_MAX_TSO_SEGS;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 58e803942a93..4c0daadc09e9 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3771,7 +3771,7 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 }
 
 static void mvneta_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 
@@ -5340,12 +5340,12 @@ static int mvneta_probe(struct platform_device *pdev)
 		}
 	}
 
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM |
-				NETIF_F_TSO | NETIF_F_RXCSUM, &dev->features);
-	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
-	netdev_feature_or(&dev->vlan_features, dev->vlan_features,
+				NETIF_F_TSO | NETIF_F_RXCSUM, dev->features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(dev->vlan_features, dev->vlan_features,
 			  dev->features);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->gso_max_segs = MVNETA_MAX_TSO_SEGS;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 894b90a6ca49..3fc46c01d6c0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1267,8 +1267,8 @@ static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 {
 	__DECLARE_NETDEV_FEATURE_MASK(csums);
 
-	netdev_feature_zero(&csums);
-	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM, &csums);
+	netdev_feature_zero(csums);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM, csums);
 
 	/* Update L4 checksum when jumbo enable/disable on port.
 	 * Only port 0 supports hardware checksum offload due to
@@ -1277,14 +1277,14 @@ static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 	 * has 7 bits, so the maximum L3 offset is 128.
 	 */
 	if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-		netdev_feature_andnot(&port->dev->features,
+		netdev_feature_andnot(port->dev->features,
 				      port->dev->features, csums);
-		netdev_feature_andnot(&port->dev->hw_features,
+		netdev_feature_andnot(port->dev->hw_features,
 				      port->dev->hw_features, csums);
 	} else {
-		netdev_feature_or(&port->dev->features, port->dev->features,
+		netdev_feature_or(port->dev->features, port->dev->features,
 				  csums);
-		netdev_feature_or(&port->dev->hw_features,
+		netdev_feature_or(port->dev->hw_features,
 				  port->dev->hw_features, csums);
 	}
 }
@@ -1349,23 +1349,23 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
 			netdev_feature_clear_bits(NETIF_F_IP_CSUM |
 						  NETIF_F_IPV6_CSUM,
-						  &dev->features);
+						  dev->features);
 			netdev_feature_clear_bits(NETIF_F_IP_CSUM |
 						  NETIF_F_IPV6_CSUM,
-						  &dev->hw_features);
+						  dev->hw_features);
 		} else {
 			netdev_feature_set_bits(NETIF_F_IP_CSUM |
 						NETIF_F_IPV6_CSUM,
-						&dev->features);
+						dev->features);
 			netdev_feature_set_bits(NETIF_F_IP_CSUM |
 						NETIF_F_IPV6_CSUM,
-						&dev->hw_features);
+						dev->hw_features);
 		}
 	}
 
 out_set:
 	dev->mtu = mtu;
-	netdev_feature_copy(&dev->wanted_features, dev->features);
+	netdev_feature_copy(dev->wanted_features, dev->features);
 
 	netdev_update_features(dev);
 	return 0;
@@ -5291,7 +5291,7 @@ static int mvpp2_set_features(struct net_device *dev,
 	struct mvpp2_port *port = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
 		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
@@ -6933,24 +6933,24 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		}
 	}
 
-	netdev_feature_zero(&features);
+	netdev_feature_zero(features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM | NETIF_F_TSO, &features);
-	netdev_feature_copy(&dev->features, features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
-	netdev_feature_or(&dev->hw_features, dev->hw_features, features);
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO, features);
+	netdev_feature_copy(dev->features, features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_GRO |
-				NETIF_F_HW_VLAN_CTAG_FILTER, &dev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_FILTER, dev->hw_features);
 
 	if (mvpp22_rss_is_supported(port)) {
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &dev->hw_features);
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, dev->features);
 	}
 
 	if (!port->priv->percpu_pools)
 		mvpp2_set_hw_csum(port, port->pool_long->id);
 
-	netdev_feature_or(&dev->vlan_features, dev->vlan_features, features);
+	netdev_feature_or(dev->vlan_features, dev->vlan_features, features);
 	dev->gso_max_segs = MVPP2_MAX_TSO_SEGS;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 78f47a797728..4251c3877500 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -494,7 +494,7 @@ void otx2_setup_segmentation(struct otx2_nic *pfvf)
 	netdev_info(pfvf->netdev,
 		    "Failed to get LSO index for UDP GSO offload, disabling\n");
 	netdev_feature_clear_bit(NETIF_F_GSO_UDP_L4_BIT,
-				 &pfvf->netdev->hw_features);
+				 pfvf->netdev->hw_features);
 }
 
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 77806bedb8dd..00a550c5f1e9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1814,9 +1814,9 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 }
 
 static void otx2_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
@@ -1844,7 +1844,7 @@ static int otx2_set_features(struct net_device *netdev,
 	struct otx2_nic *pf = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
 	    netif_running(netdev))
@@ -2592,12 +2592,12 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
 				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-				NETIF_F_GSO_UDP_L4, &netdev->hw_features);
-	netdev_feature_or(&netdev->features, netdev->features,
+				NETIF_F_GSO_UDP_L4, netdev->hw_features);
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 
 	err = otx2_mcam_flow_init(pf);
@@ -2605,30 +2605,30 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_ptp_destroy;
 
 	if (pf->flags & OTX2_FLAG_NTUPLE_SUPPORT)
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, netdev->hw_features);
 
 	if (pf->flags & OTX2_FLAG_UCAST_FLTR_SUPPORT)
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* Support TSO on tag interface */
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX,
-				&netdev->hw_features);
+				netdev->hw_features);
 	if (pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
 					NETIF_F_HW_VLAN_STAG_RX,
-					&netdev->hw_features);
-	netdev_feature_or(&netdev->features, netdev->features,
+					netdev->hw_features);
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 
 	/* HW supports tc offload but mutually exclusive with n-tuple filters */
 	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->hw_features);
 
 	netdev_feature_set_bits(NETIF_F_LOOPBACK | NETIF_F_RXALL,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 5d493afc2924..c569c31388d5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -477,7 +477,7 @@ static int otx2vf_set_features(struct net_device *netdev,
 	struct otx2_nic *vf = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed)) {
 		if (!ntuple_enabled) {
 			otx2_mcam_flow_del(vf);
@@ -650,23 +650,23 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
 				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-				NETIF_F_GSO_UDP_L4, &netdev->hw_features);
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+				NETIF_F_GSO_UDP_L4, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 	/* Support TSO on tag interface */
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX,
-				&netdev->hw_features);
-	netdev_feature_or(&netdev->features, netdev->features,
+				netdev->hw_features);
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 
-	netdev_feature_set_bits(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
-	netdev_feature_set_bits(NETIF_F_RXALL_BIT, &netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_NTUPLE_BIT, netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_RXALL_BIT, netdev->hw_features);
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 41cfbecebd80..13e0a9626392 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -317,7 +317,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		goto err_dl_port_register;
 
 	netdev_feature_set_bits(NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC,
-				&dev->features);
+				dev->features);
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 069a0141ebab..3b1fc879913a 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3825,7 +3825,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	dev->max_mtu = ETH_JUMBO_MTU;
 
 	if (highmem)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	skge = netdev_priv(dev);
 	netif_napi_add(dev, &skge->napi, skge_poll, NAPI_WEIGHT);
@@ -3857,8 +3857,8 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 		timer_setup(&skge->link_timer, xm_link_timer, 0);
 	else {
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
-					NETIF_F_RXCSUM, &dev->hw_features);
-		netdev_feature_or(&dev->features, dev->features,
+					NETIF_F_RXCSUM, dev->hw_features);
+		netdev_feature_or(dev->features, dev->features,
 				  dev->hw_features);
 	}
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e5132f55e830..95c61c33154a 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1419,15 +1419,14 @@ static void sky2_vlan_mode(struct net_device *dev, netdev_features_t features)
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_ON);
 
-		netdev_feature_set_bits(SKY2_VLAN_OFFLOADS,
-					&dev->vlan_features);
+		netdev_feature_set_bits(SKY2_VLAN_OFFLOADS, dev->vlan_features);
 	} else {
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_OFF);
 
 		/* Can't do transmit offload of vlan without hw vlan */
 		netdev_feature_clear_bits(SKY2_VLAN_OFFLOADS,
-					  &dev->vlan_features);
+					  dev->vlan_features);
 	}
 }
 
@@ -2682,7 +2681,7 @@ static void sky2_rx_checksum(struct sky2_port *sky2, u32 status)
 		 * really broken, will get disabled again
 		 */
 		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
-					 &sky2->netdev->features);
+					 sky2->netdev->features);
 		sky2_write32(sky2->hw, Q_ADDR(rxqaddr[sky2->port], Q_CSR),
 			     BMU_DIS_RX_CHKSUM);
 	}
@@ -4365,7 +4364,7 @@ static int sky2_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom
 }
 
 static void sky2_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	const struct sky2_port *sky2 = netdev_priv(dev);
 	const struct sky2_hw *hw = sky2->hw;
@@ -4380,8 +4379,8 @@ static void sky2_fix_features(struct net_device *dev,
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
-	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
 	    (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
 		netdev_info(dev, "receive hashing forces receive checksum\n");
 		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, features);
@@ -4393,7 +4392,7 @@ static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 	struct sky2_port *sky2 = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed) &&
 	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
@@ -4681,7 +4680,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	/* Auto speed and flow control */
 	sky2->flags = SKY2_FLAG_AUTO_SPEED | SKY2_FLAG_AUTO_PAUSE;
 	if (hw->chip_id != CHIP_ID_YUKON_XL)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->hw_features);
 
 	sky2->flow_mode = FC_BOTH;
 
@@ -4701,24 +4700,24 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	sky2->port = port;
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO,
-				&dev->hw_features);
+				dev->hw_features);
 
 	if (highmem)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	/* Enable receive hashing unless hardware is known broken */
 	if (!(hw->flags & SKY2_HW_RSS_BROKEN))
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, dev->hw_features);
 
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 					NETIF_F_HW_VLAN_CTAG_RX,
-					&dev->hw_features);
+					dev->hw_features);
 		netdev_feature_set_bits(SKY2_VLAN_OFFLOADS,
-					&dev->vlan_features);
+					dev->vlan_features);
 	}
 
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 
 	/* MTU range: 60 - 1500 or 9000 */
 	dev->min_mtu = ETH_ZLEN;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bc944937645c..fefc2df149ab 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2023,9 +2023,9 @@ static int mtk_hwlro_get_fdir_all(struct net_device *dev,
 }
 
 static void mtk_fix_features(struct net_device *dev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
-	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
 		struct mtk_mac *mac = netdev_priv(dev);
 		int ip_cnt = mtk_hwlro_get_ip_cnt(mac);
 
@@ -3031,21 +3031,21 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
 	eth->netdev[id]->base_addr = (unsigned long)eth->base;
 
-	netdev_feature_zero(&eth->netdev[id]->hw_features);
+	netdev_feature_zero(eth->netdev[id]->hw_features);
 	netdev_feature_set_bits(eth->soc->hw_features[0],
-				&eth->netdev[id]->hw_features);
+				eth->netdev[id]->hw_features);
 	if (eth->hwlro)
 		netdev_feature_set_bit(NETIF_F_LRO_BIT,
-				       &eth->netdev[id]->hw_features);
+				       eth->netdev[id]->hw_features);
 
-	netdev_feature_zero(&eth->netdev[id]->vlan_features);
+	netdev_feature_zero(eth->netdev[id]->vlan_features);
 	netdev_feature_set_bits(eth->soc->hw_features[0],
-				&eth->netdev[id]->vlan_features);
+				eth->netdev[id]->vlan_features);
 	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				  NETIF_F_HW_VLAN_CTAG_RX,
-				  &eth->netdev[id]->vlan_features);
+				  eth->netdev[id]->vlan_features);
 	netdev_feature_set_bits(eth->soc->hw_features[0],
-				&eth->netdev[id]->features);
+				eth->netdev[id]->features);
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
 	eth->netdev[id]->irq = eth->irq[0];
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 222ba5bb7cc8..3754b1fe8a83 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2494,7 +2494,7 @@ static int mlx4_en_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 
 static void mlx4_en_fix_features(struct net_device *netdev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	struct mlx4_en_priv *en_priv = netdev_priv(netdev);
 	struct mlx4_en_dev *mdev = en_priv->mdev;
@@ -2503,7 +2503,7 @@ static void mlx4_en_fix_features(struct net_device *netdev,
 	 * enable/disable make sure S-TAG flag is always in same state as
 	 * C-TAG.
 	 */
-	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
 	    !(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_RX_BIT, features);
 	else
@@ -2679,7 +2679,7 @@ static const struct udp_tunnel_nic_info mlx4_udp_tunnels = {
 };
 
 static void mlx4_en_features_check(struct sk_buff *skb, struct net_device *dev,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	vlan_features_check(skb, features);
 	vxlan_features_check(skb, features);
@@ -3322,59 +3322,59 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	/*
 	 * Set driver features
 	 */
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM, &dev->hw_features);
+				NETIF_F_IPV6_CSUM, dev->hw_features);
 	if (mdev->LSO_support)
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&dev->hw_features);
+					dev->hw_features);
 
 	if (mdev->dev->caps.tunnel_offload_mode ==
 	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_PARTIAL,
-					&dev->hw_features);
+					dev->hw_features);
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_PARTIAL,
-					&dev->features);
-		netdev_feature_zero(&dev->gso_partial_features);
+					dev->features);
+		netdev_feature_zero(dev->gso_partial_features);
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-				       &dev->gso_partial_features);
-		netdev_feature_zero(&dev->hw_enc_features);
+				       dev->gso_partial_features);
+		netdev_feature_zero(dev->hw_enc_features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 					NETIF_F_RXCSUM |
 					NETIF_F_TSO | NETIF_F_TSO6 |
 					NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_PARTIAL,
-					&dev->hw_enc_features);
+					dev->hw_enc_features);
 
 		dev->udp_tunnel_nic_info = &mlx4_udp_tunnels;
 	}
 
-	netdev_feature_copy(&dev->vlan_features, dev->hw_features);
+	netdev_feature_copy(dev->vlan_features, dev->hw_features);
 
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_RXHASH,
-				&dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+				dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HIGHDMA |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&dev->features);
+				dev->features);
 	netdev_feature_set_bits(NETIF_F_LOOPBACK |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&dev->hw_features);
+				dev->hw_features);
 
 	if (!(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN)) {
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_STAG_RX |
 					NETIF_F_HW_VLAN_STAG_FILTER,
-					&dev->features);
+					dev->features);
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_RX_BIT,
-				       &dev->hw_features);
+				       dev->hw_features);
 	}
 
 	if (mlx4_is_slave(mdev->dev)) {
@@ -3384,7 +3384,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		err = get_phv_bit(mdev->dev, port, &phv);
 		if (!err && phv) {
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 			priv->pflags |= MLX4_EN_PRIV_FLAGS_PHV;
 		}
 		err = mlx4_get_is_vlan_offload_disabled(mdev->dev, port,
@@ -3395,31 +3395,31 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 						  NETIF_F_HW_VLAN_STAG_TX |
 						  NETIF_F_HW_VLAN_STAG_RX |
 						  NETIF_F_HW_VLAN_STAG_FILTER,
-						  &dev->hw_features);
+						  dev->hw_features);
 			netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
 						  NETIF_F_HW_VLAN_CTAG_RX |
 						  NETIF_F_HW_VLAN_STAG_TX |
 						  NETIF_F_HW_VLAN_STAG_RX,
-						  &dev->features);
+						  dev->features);
 		}
 	} else {
 		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_PHV_EN &&
 		    !(mdev->dev->caps.flags2 &
 		      MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 	}
 
 	if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_FCS_KEEP)
-		netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXFCS_BIT, dev->hw_features);
 
 	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_IGNORE_FCS)
-		netdev_feature_set_bit(NETIF_F_RXALL_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXALL_BIT, dev->hw_features);
 
 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED &&
 	    mdev->dev->caps.dmfs_high_steer_mode != MLX4_STEERING_DMFS_A0_STATIC)
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, dev->hw_features);
 
 	if (mdev->dev->caps.steering_mode != MLX4_STEERING_MODE_A0)
 		dev->priv_flags |= IFF_UNICAST_FLT;
@@ -3558,10 +3558,10 @@ int mlx4_en_reset_config(struct net_device *dev,
 		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
 					    features))
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					       &dev->features);
+					       dev->features);
 		else
 			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-						 &dev->features);
+						 dev->features);
 	} else if (ts_config.rx_filter == HWTSTAMP_FILTER_NONE) {
 		/* RX time-stamping is OFF, update the RX vlan offload
 		 * to the latest wanted state
@@ -3569,19 +3569,19 @@ int mlx4_en_reset_config(struct net_device *dev,
 		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
 					    dev->wanted_features))
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					       &dev->features);
+					       dev->features);
 		else
 			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-						 &dev->features);
+						 dev->features);
 	}
 
 	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT)) {
 		if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT, features))
 			netdev_feature_set_bit(NETIF_F_RXFCS_BIT,
-					       &dev->features);
+					       dev->features);
 		else
 			netdev_feature_clear_bit(NETIF_F_RXFCS_BIT,
-						 &dev->features);
+						 dev->features);
 	}
 
 	/* RX vlan offload and RX time-stamping can't co-exist !
@@ -3593,7 +3593,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 					    dev->features))
 			en_warn(priv, "Turning off RX vlan offload since RX time-stamping is ON\n");
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					 &dev->features);
+					 dev->features);
 	}
 
 	if (port_up) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index daf276c43d8a..8929a279aace 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1130,7 +1130,7 @@ void mlx5e_rx_dim_work(struct work_struct *work);
 void mlx5e_tx_dim_work(struct work_struct *work);
 
 void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
-			  netdev_features_t *features);
+			  netdev_features_t features);
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features);
 #ifdef CONFIG_MLX5_ESWITCH
 int mlx5e_set_vf_mac(struct net_device *dev, int vf, u8 *mac);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b703ea308429..8195e04e549d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -540,17 +540,17 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 
 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
 	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
-	netdev_feature_set_bit(NETIF_F_HW_ESP_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_HW_ESP_BIT, &netdev->hw_enc_features);
+	netdev_feature_set_bit(NETIF_F_HW_ESP_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_ESP_BIT, netdev->hw_enc_features);
 
 	if (!MLX5_CAP_ETH(mdev, swp_csum)) {
 		mlx5_core_dbg(mdev, "mlx5e: SWP checksum not supported\n");
 		return;
 	}
 
-	netdev_feature_set_bit(NETIF_F_HW_ESP_TX_CSUM_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_ESP_TX_CSUM_BIT, netdev->features);
 	netdev_feature_set_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
-			       &netdev->hw_enc_features);
+			       netdev->hw_enc_features);
 
 	if (!(mlx5_accel_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
 	    !MLX5_CAP_ETH(mdev, swp_lso)) {
@@ -560,10 +560,10 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 
 	if (mlx5_is_ipsec_device(mdev))
 		netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT,
-				       &netdev->gso_partial_features);
+				       netdev->gso_partial_features);
 
 	mlx5_core_dbg(mdev, "mlx5e: ESP GSO capability turned on\n");
-	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, &netdev->hw_enc_features);
+	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GSO_ESP_BIT, netdev->hw_enc_features);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index b0e92a7b4902..05a6c8f9a68c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -94,7 +94,7 @@ void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 			       struct mlx5_wqe_eth_seg *eseg);
 
 static inline void
-mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp = skb_sec_path(skb);
@@ -141,7 +141,7 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
 static inline void
-mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 {
 	netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
 				  features);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index bde7da10f442..384d224e9609 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -64,14 +64,13 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 
 	if (mlx5e_accel_is_ktls_tx(mdev)) {
 		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
-				       &netdev->hw_features);
-		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
-				       &netdev->features);
+				       netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT, netdev->features);
 	}
 
 	if (mlx5e_accel_is_ktls_rx(mdev))
 		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
 	netdev->tlsdev_ops = &mlx5e_ktls_ops;
 }
@@ -103,7 +102,7 @@ int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 		return -ENOMEM;
 
 	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT,
-				    &priv->netdev->features)) {
+				    priv->netdev->features)) {
 		err = mlx5e_accel_fs_tcp_create(priv);
 		if (err) {
 			destroy_workqueue(priv->tls->rx_wq);
@@ -120,7 +119,7 @@ void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 		return;
 
 	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT,
-				    &priv->netdev->features))
+				    priv->netdev->features))
 		mlx5e_accel_fs_tcp_destroy(priv);
 
 	destroy_workqueue(priv->tls->rx_wq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index bd2998782634..f8e8d20d0915 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -204,21 +204,21 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 	caps = mlx5_accel_tls_device_caps(priv->mdev);
 	if (caps & MLX5_ACCEL_TLS_TX) {
 		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
-				       &netdev->features);
+				       netdev->features);
 		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	}
 
 	if (caps & MLX5_ACCEL_TLS_RX) {
 		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
-				       &netdev->features);
+				       netdev->features);
 		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	}
 
 	if (!(caps & MLX5_ACCEL_TLS_LRO)) {
-		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
-		netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->hw_features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, netdev->features);
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, netdev->hw_features);
 	}
 
 	netdev->tlsdev_ops = &mlx5e_tls_ops;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 520e5c3e5fb7..7361d720c79b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1288,7 +1288,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
 			   err);
 		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
-					 &priv->netdev->hw_features);
+					 priv->netdev->hw_features);
 	}
 
 	err = mlx5e_create_inner_ttc_table(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 84a14756a171..8686f7840eb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3328,7 +3328,7 @@ static int set_feature_arfs(struct net_device *netdev, bool enable)
 #endif
 
 static int mlx5e_handle_feature(struct net_device *netdev,
-				netdev_features_t *features,
+				netdev_features_t features,
 				netdev_features_t wanted_features,
 				u32 feature_bit,
 				mlx5e_feature_handler feature_handler)
@@ -3337,7 +3337,7 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 	bool enable;
 	int err;
 
-	netdev_feature_xor(&changes, wanted_features, netdev->features);
+	netdev_feature_xor(changes, wanted_features, netdev->features);
 	enable = netdev_feature_test_bit(feature_bit, wanted_features);
 
 	if (!netdev_feature_test_bit(feature_bit, changes))
@@ -3359,10 +3359,10 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	__DECLARE_NETDEV_FEATURE_MASK(oper_features);
 	int err = 0;
 
-	netdev_feature_copy(&oper_features, netdev->features);
+	netdev_feature_copy(oper_features, netdev->features);
 
 #define MLX5E_HANDLE_FEATURE(feature, handler) \
-	mlx5e_handle_feature(netdev, &oper_features, features, feature, handler)
+	mlx5e_handle_feature(netdev, oper_features, features, feature, handler)
 
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO_BIT, set_feature_lro);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
@@ -3379,7 +3379,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 				    mlx5e_ktls_set_feature_rx);
 
 	if (err) {
-		netdev_feature_copy(&netdev->features, oper_features);
+		netdev_feature_copy(netdev->features, oper_features);
 		return -EINVAL;
 	}
 
@@ -3387,7 +3387,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 }
 
 static void mlx5e_fix_uplink_rep_features(struct net_device *netdev,
-					  netdev_features_t *features)
+					  netdev_features_t features)
 {
 	netdev_feature_clear_bit(NETIF_F_HW_TLS_RX_BIT, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT, netdev->features))
@@ -3403,7 +3403,7 @@ static void mlx5e_fix_uplink_rep_features(struct net_device *netdev,
 }
 
 static void mlx5e_fix_features(struct net_device *netdev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_params *params;
@@ -3421,7 +3421,7 @@ static void mlx5e_fix_features(struct net_device *netdev,
 	}
 
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
 			netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 		}
@@ -3854,7 +3854,7 @@ static bool mlx5e_gre_tunnel_inner_proto_offload_supported(struct mlx5_core_dev
 
 static void mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 					struct sk_buff *skb,
-					netdev_features_t *features)
+					netdev_features_t features)
 {
 	unsigned int offset = 0;
 	struct udphdr *udph;
@@ -3898,7 +3898,7 @@ static void mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 		break;
 #ifdef CONFIG_MLX5_EN_IPSEC
 	case IPPROTO_ESP:
-		mlx5e_ipsec_feature_check(skb, *features);
+		mlx5e_ipsec_feature_check(skb, features);
 #endif
 	}
 
@@ -3909,7 +3909,7 @@ static void mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 }
 
 void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
-			  netdev_features_t *features)
+			  netdev_features_t features)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
@@ -3918,8 +3918,8 @@ void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
-	    (netdev_feature_test_bits(NETIF_F_CSUM_MASK, *features) ||
-	     netdev_feature_test_bits(NETIF_F_GSO_MASK, *features)))
+	    (netdev_feature_test_bits(NETIF_F_CSUM_MASK, features) ||
+	     netdev_feature_test_bits(NETIF_F_GSO_MASK, features)))
 		mlx5e_tunnel_features_check(priv, skb, features);
 }
 
@@ -4327,23 +4327,23 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->ethtool_ops	  = &mlx5e_ethtool_ops;
 
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, netdev->vlan_features);
 
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->mpls_features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &netdev->mpls_features);
-	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->mpls_features);
-	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, netdev->mpls_features);
 
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-			       &netdev->hw_enc_features);
+			       netdev->hw_enc_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-			       &netdev->hw_enc_features);
+			       netdev->hw_enc_features);
 
 	/* Tunneled LRO is not supported in the driver, and the same RQs are
 	 * shared between inner and outer TIRs, so the driver can't disable LRO
@@ -4354,83 +4354,83 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    !MLX5_CAP_ETH(mdev, tunnel_lro_vxlan) &&
 	    !MLX5_CAP_ETH(mdev, tunnel_lro_gre) &&
 	    mlx5e_check_fragmented_striding_rq_cap(mdev))
-		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->vlan_features);
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, netdev->vlan_features);
 
-	netdev_feature_copy(&netdev->hw_features, netdev->vlan_features);
+	netdev_feature_copy(netdev->hw_features, netdev->vlan_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 
 	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
 		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 		netdev_feature_set_bit(NETIF_F_TSO_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 		netdev_feature_set_bit(NETIF_F_GSO_PARTIAL_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-				       &netdev->vlan_features);
+				       netdev->vlan_features);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
 		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
-				       &netdev->gso_partial_features);
+				       netdev->gso_partial_features);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
 		netdev_feature_set_bits(NETIF_F_GSO_IPXIP4 |
 					NETIF_F_GSO_IPXIP6,
-					&netdev->hw_features);
+					netdev->hw_features);
 		netdev_feature_set_bits(NETIF_F_GSO_IPXIP4 |
 					NETIF_F_GSO_IPXIP6,
-					&netdev->hw_enc_features);
+					netdev->hw_enc_features);
 		netdev_feature_set_bits(NETIF_F_GSO_IPXIP4 |
 					NETIF_F_GSO_IPXIP6,
-					&netdev->gso_partial_features);
+					netdev->gso_partial_features);
 	}
 
-	netdev_feature_set_bit(NETIF_F_GSO_PARTIAL_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GSO_PARTIAL_BIT, netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
-			       &netdev->gso_partial_features);
-	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, &netdev->features);
+			       netdev->gso_partial_features);
+	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT, netdev->features);
 
 	mlx5_query_port_fcs(mdev, &fcs_supported, &fcs_enabled);
 
 	if (fcs_supported)
-		netdev_feature_set_bit(NETIF_F_RXALL_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXALL_BIT, netdev->hw_features);
 
 	if (MLX5_CAP_ETH(mdev, scatter_fcs))
-		netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXFCS_BIT, netdev->hw_features);
 
 	if (mlx5_qos_is_supported(mdev))
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->hw_features);
 
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 
 	/* Defaults */
 	if (fcs_enabled)
-		netdev_feature_clear_bit(NETIF_F_RXALL_BIT, &netdev->features);
-	netdev_feature_clear_bit(NETIF_F_LRO_BIT, &netdev->features);
-	netdev_feature_clear_bit(NETIF_F_RXFCS_BIT, &netdev->features);
+		netdev_feature_clear_bit(NETIF_F_RXALL_BIT, netdev->features);
+	netdev_feature_clear_bit(NETIF_F_LRO_BIT, netdev->features);
+	netdev_feature_clear_bit(NETIF_F_RXFCS_BIT, netdev->features);
 
 #define FT_CAP(f) MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.f)
 	if (FT_CAP(flow_modify_en) &&
@@ -4438,15 +4438,15 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    FT_CAP(identified_miss_table_mode) &&
 	    FT_CAP(flow_table_modify)) {
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->hw_features);
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, netdev->hw_features);
 #endif
 	}
 
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, netdev->features);
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 113f11a7ba69..5333e3b09add 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -633,20 +633,20 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->watchdog_timeo    = 15 * HZ;
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->hw_features);
 #endif
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->hw_features);
-
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->hw_features);
+
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &netdev->features);
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, netdev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, netdev->features);
 }
 
 static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
@@ -1010,7 +1010,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	mlx5e_rep_neigh_init(rpriv);
 	mlx5e_rep_bridge_init(priv);
 
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->wanted_features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->wanted_features);
 
 	rtnl_lock();
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index b06c5fadfa4c..2e18a68a5690 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -87,14 +87,14 @@ int mlx5i_init(struct mlx5_core_dev *mdev, struct net_device *netdev)
 	mlx5e_timestamp_init(priv);
 
 	/* netdev init */
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_TSO6_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, netdev->hw_features);
 
 	netdev->netdev_ops = &mlx5i_netdev_ops;
 	netdev->ethtool_ops = &mlx5i_ethtool_ops;
@@ -327,7 +327,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
 			   err);
 		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
-					 &priv->netdev->hw_features);
+					 priv->netdev->hw_features);
 	}
 
 	err = mlx5e_create_ttc_table(priv);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 620346d392b1..0907de696b1d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1112,7 +1112,7 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 	__DECLARE_NETDEV_FEATURE_MASK(changes);
 	int err;
 
-	netdev_feature_xor(&changes, wanted_features, dev->features);
+	netdev_feature_xor(changes, wanted_features, dev->features);
 
 	if (!netdev_feature_test_bit(feature_bit, changes))
 		return 0;
@@ -1125,9 +1125,9 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 	}
 
 	if (enable)
-		netdev_feature_set_bit(feature_bit, &dev->features);
+		netdev_feature_set_bit(feature_bit, dev->features);
 	else
-		netdev_feature_clear_bit(feature_bit, &dev->features);
+		netdev_feature_clear_bit(feature_bit, dev->features);
 	return 0;
 }
 static int mlxsw_sp_set_features(struct net_device *dev,
@@ -1136,14 +1136,14 @@ static int mlxsw_sp_set_features(struct net_device *dev,
 	__DECLARE_NETDEV_FEATURE_MASK(oper_features);
 	int err = 0;
 
-	netdev_feature_copy(&oper_features, dev->features);
+	netdev_feature_copy(oper_features, dev->features);
 	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC_BIT,
 				       mlxsw_sp_feature_hw_tc);
 	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_LOOPBACK_BIT,
 				       mlxsw_sp_feature_loopback);
 
 	if (err) {
-		netdev_feature_copy(&dev->features, oper_features);
+		netdev_feature_copy(dev->features, oper_features);
 		return -EINVAL;
 	}
 
@@ -1574,9 +1574,9 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 
 	netdev_feature_set_bits(NETIF_F_NETNS_LOCAL | NETIF_F_LLTX |
 				NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_HW_TC, &dev->features);
+				NETIF_F_HW_TC, dev->features);
 	netdev_feature_set_bits(NETIF_F_HW_TC | NETIF_F_LOOPBACK,
-				&dev->hw_features);
+				dev->hw_features);
 
 	dev->min_mtu = 0;
 	dev->max_mtu = ETH_MAX_MTU;
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index a7bbe1c2fb01..297f9caafe45 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6702,17 +6702,17 @@ static int __init netdev_init(struct net_device *dev)
 	/* 500 ms timeout */
 	dev->watchdog_timeo = HZ / 2;
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_RXCSUM,
-				&dev->hw_features);
+				dev->hw_features);
 
 	/*
 	 * Hardware does not really support IPv6 checksum generation, but
 	 * driver actually runs faster with this on.
 	 */
-	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT, dev->hw_features);
 
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 
 	sema_init(&priv->proc_sem, 1);
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 00f06f690078..b392733259eb 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2807,10 +2807,10 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 
 	adapter->netdev->netdev_ops = &lan743x_netdev_ops;
 	adapter->netdev->ethtool_ops = &lan743x_ethtool_ops;
-	netdev_feature_zero(&adapter->netdev->features);
+	netdev_feature_zero(adapter->netdev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM,
-				&adapter->netdev->features);
-	netdev_feature_copy(&adapter->netdev->hw_features,
+				adapter->netdev->features);
+	netdev_feature_copy(adapter->netdev->hw_features,
 			    adapter->netdev->features);
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 859cf1b58051..6370f6c9c443 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1803,14 +1803,14 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 
 	netdev_lockdep_set_classes(ndev);
 
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM, &ndev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->hw_features);
-	netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6, &ndev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
-	netdev_feature_copy(&ndev->features, ndev->hw_features);
-	netdev_feature_zero(&ndev->vlan_features);
+				NETIF_F_IPV6_CSUM, ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6, ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, ndev->hw_features);
+	netdev_feature_copy(ndev->features, ndev->hw_features);
+	netdev_feature_zero(ndev->vlan_features);
 
 	err = register_netdev(ndev);
 	if (err) {
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 224dcf2d2a76..518593bfb0c2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -729,7 +729,7 @@ static int ocelot_set_features(struct net_device *dev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int port = priv->chip_port;
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_TC_BIT, dev->features) &&
 	    !netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features) &&
@@ -1704,9 +1704,9 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	dev->ethtool_ops = &ocelot_ethtool_ops;
 
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
-				NETIF_F_HW_TC, &dev->hw_features);
+				NETIF_F_HW_TC, dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC,
-				&dev->features);
+				dev->features);
 
 	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
 	dev->dev_addr[ETH_ALEN - 1] += port;
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index b0a6b1211534..18b9f6d3b53d 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2892,8 +2892,8 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	netdev_tx_t status;
 
-	netdev_feature_copy(&tmp, dev->features);
-	netdev_feature_clear_bit(NETIF_F_TSO6_BIT, &tmp);
+	netdev_feature_copy(tmp, dev->features);
+	netdev_feature_clear_bit(NETIF_F_TSO6_BIT, tmp);
 	segs = skb_gso_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto drop;
@@ -3871,27 +3871,27 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->mtu = myri10ge_initial_mtu;
 
 	netdev->netdev_ops = &myri10ge_netdev_ops;
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(mgp->features | NETIF_F_RXCSUM,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	/* fake NETIF_F_HW_VLAN_CTAG_RX for good GRO performance */
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 
 	if (dac_enabled)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
-	netdev_feature_set_bits(mgp->features, &netdev->vlan_features);
+	netdev_feature_set_bits(mgp->features, netdev->vlan_features);
 
 	if (mgp->fw_ver_tiny < 37)
 		netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
-					 &netdev->vlan_features);
+					 netdev->vlan_features);
 	if (mgp->fw_ver_tiny < 32)
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT,
-					 &netdev->vlan_features);
+					 netdev->vlan_features);
 
 	/* make sure we can get an irq, and that MSI can be
 	 * setup (if available). */
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index ed2e9fe01e1e..8f1a6757ffcb 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2139,8 +2139,8 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	ns83820_getmac(dev, ndev->dev_addr);
 
 	/* Yes, we support dumb IP checksum on transmit */
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
-	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, ndev->features);
 
 	ndev->min_mtu = 0;
 
@@ -2148,13 +2148,13 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	/* We also support hardware vlan acceleration */
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&ndev->features);
+				ndev->features);
 #endif
 
 	if (using_dac) {
 		printk(KERN_INFO "%s: using 64 bit addressing.\n",
 			ndev->name);
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 	}
 
 	printk(KERN_INFO "%s: ns83820 v" VERSION ": DP83820 v%u.%u: %pM io=0x%08lx irq=%d f=%s\n",
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 79165cf28549..81a3c6fc602c 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6569,7 +6569,7 @@ static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 	struct s2io_nic *sp = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, dev->features);
+	netdev_feature_xor(changed, features, dev->features);
 
 	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, changed) &&
 	    netif_running(dev)) {
@@ -6577,7 +6577,7 @@ static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 
 		s2io_stop_all_tx_queue(sp);
 		s2io_card_down(sp);
-		netdev_feature_copy(&dev->features, features);
+		netdev_feature_copy(dev->features, features);
 		rc = s2io_card_up(sp);
 		if (rc)
 			s2io_reset(sp);
@@ -7865,17 +7865,17 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 	/*  Driver entry points */
 	dev->netdev_ops = &s2io_netdev_ops;
 	dev->ethtool_ops = &netdev_ethtool_ops;
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_RXCSUM | NETIF_F_LRO,
-				&dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+				dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX,
-				&dev->features);
+				dev->features);
 	if (sp->high_dma_flag == true)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 	dev->watchdog_timeo = WATCH_DOG_TIMEOUT;
 	INIT_WORK(&sp->rst_timer_task, s2io_restart_nic);
 	INIT_WORK(&sp->set_link_task, s2io_set_link);
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 98184a71aad5..fa7749f90600 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2641,11 +2641,11 @@ static void vxge_poll_vp_lockup(struct timer_list *t)
 }
 
 static void vxge_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, *features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	/* Enabling RTH requires some of the logic in vxge_device_register and a
 	 * vpath reset.  Due to these restrictions, only allow modification
@@ -2661,7 +2661,7 @@ static int vxge_set_features(struct net_device *dev, netdev_features_t features)
 	struct vxgedev *vdev = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (!netdev_feature_test_bit(NETIF_F_RXHASH_BIT, changed))
 		return 0;
@@ -3398,20 +3398,20 @@ static int vxge_device_register(struct __vxge_hw_device *hldev,
 
 	SET_NETDEV_DEV(ndev, &vdev->pdev->dev);
 
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_SG |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&ndev->hw_features);
+				ndev->hw_features);
 	if (vdev->config.rth_steering != NO_STEERING)
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, ndev->hw_features);
 
-	netdev_feature_or(&ndev->features, ndev->features,
+	netdev_feature_or(ndev->features, ndev->features,
 			  ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&ndev->features);
+				ndev->features);
 
 	ndev->netdev_ops = &vxge_netdev_ops;
 
@@ -3435,7 +3435,7 @@ static int vxge_device_register(struct __vxge_hw_device *hldev,
 		"%s : checksumming enabled", __func__);
 
 	if (high_dma) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 		vxge_debug_init(vxge_hw_device_trace_level_get(hldev),
 			"%s : using High DMA", __func__);
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index a5bee5d35d2c..bdd799f6600f 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -588,15 +588,15 @@ int nfp_net_tls_init(struct nfp_net *nn)
 
 	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_RX) {
 		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_HW_TLS_RX_BIT,
-				       &netdev->features);
+				       netdev->features);
 	}
 	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_TX) {
 		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_HW_TLS_TX_BIT,
-				       &netdev->features);
+				       netdev->features);
 	}
 
 	netdev->tlsdev_ops = &nfp_net_tls_ops;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 38d3066aaf7c..56de9a36ef16 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3527,7 +3527,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 
 	new_ctrl = nn->dp.ctrl;
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
@@ -3590,8 +3590,10 @@ static int nfp_net_set_features(struct net_device *netdev,
 	if (err)
 		return err;
 
-	nn_dbg(nn, "Feature change 0x%llx -> 0x%llx (changed=0x%llx)\n",
-	       netdev->features, features, changed);
+	nn_dbg(nn, "Feature change %*pb -> %*pb (changed=%*pb)\n",
+	       NETDEV_FEATURE_COUNT, netdev->features,
+	       NETDEV_FEATURE_COUNT, features,
+	       NETDEV_FEATURE_COUNT, changed);
 
 	if (new_ctrl == nn->dp.ctrl)
 		return 0;
@@ -3608,7 +3610,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 }
 
 static void nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	u8 l4_hdr;
 
@@ -4041,55 +4043,55 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	if (nn->cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev_feature_zero(&netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->hw_features);
 
 	if (nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY) {
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXCSUM) {
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-					&netdev->hw_features);
+					netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_GATHER) {
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_GATHER;
 	}
 	if ((nn->cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    nn->cap & NFP_NET_CFG_CTRL_LSO2) {
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&netdev->hw_features);
+					netdev->hw_features);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					 NFP_NET_CFG_CTRL_LSO;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_RSS_ANY)
 		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
 			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_NVGRE) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
 			netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_NVGRE;
 	}
 	if (nn->cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
-		netdev_feature_copy(&netdev->hw_enc_features,
+		netdev_feature_copy(netdev->hw_enc_features,
 				    netdev->hw_features);
 
-	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
+	netdev_feature_copy(netdev->vlan_features, netdev->hw_features);
 
 	if (nn->cap & NFP_NET_CFG_CTRL_RXVLAN) {
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_RXVLAN;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXVLAN) {
@@ -4097,24 +4099,24 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 			nn_warn(nn, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		} else {
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 			nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXVLAN;
 		}
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_CTAG_FILTER) {
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
 
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 
 	if (nfp_app_has_tc(nn->app) && nn->port)
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->hw_features);
 
 	/* Advertise but disable TSO by default. */
 	netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
-				  &netdev->features);
+				  netdev->features);
 	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_LSO_ANY;
 
 	/* Finalise the netdev setup */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 42e211017384..67638db09019 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -233,7 +233,7 @@ static int nfp_repr_open(struct net_device *netdev)
 }
 
 static void nfp_repr_fix_features(struct net_device *netdev,
-				  netdev_features_t *features)
+				  netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(lower_features);
 	__DECLARE_NETDEV_FEATURE_MASK(old_features);
@@ -242,16 +242,16 @@ static void nfp_repr_fix_features(struct net_device *netdev,
 
 	lower_dev = repr->dst->u.port_info.lower_dev;
 
-	netdev_feature_copy(&old_features, *features);
-	netdev_feature_copy(&lower_features, lower_dev->features);
+	netdev_feature_copy(old_features, features);
+	netdev_feature_copy(lower_features, lower_dev->features);
 	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
 				     lower_features))
-		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &lower_features);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, lower_features);
 
-	netdev_intersect_features(features, *features, lower_features);
+	netdev_intersect_features(features, features, lower_features);
 	netdev_feature_and_bits(NETIF_F_SOFT_FEATURES | NETIF_F_HW_TC,
-				&old_features);
-	netdev_feature_or(features, *features, old_features);
+				old_features);
+	netdev_feature_or(features, features, old_features);
 	netdev_feature_set_bit(NETIF_F_LLTX_BIT, features);
 }
 
@@ -343,66 +343,66 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	if (repr_cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev_feature_zero(&netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_RXCSUM_ANY)
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_TXCSUM)
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-					&netdev->hw_features);
+					netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_GATHER)
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
 	if ((repr_cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    repr_cap & NFP_NET_CFG_CTRL_LSO2)
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&netdev->hw_features);
+					netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_RSS_ANY)
 		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO)
 			netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 	}
 	if (repr_cap & NFP_NET_CFG_CTRL_NVGRE) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO)
 			netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 	}
 	if (repr_cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
-		netdev_feature_copy(&netdev->hw_enc_features,
+		netdev_feature_copy(netdev->hw_enc_features,
 				    netdev->hw_features);
 
-	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
+	netdev_feature_copy(netdev->vlan_features, netdev->hw_features);
 
 	if (repr_cap & NFP_NET_CFG_CTRL_RXVLAN)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (repr_cap & NFP_NET_CFG_CTRL_TXVLAN) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO2)
 			netdev_warn(netdev, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		else
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-					       &netdev->hw_features);
+					       netdev->hw_features);
 	}
 	if (repr_cap & NFP_NET_CFG_CTRL_CTAG_FILTER)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 
 	/* Advertise but disable TSO by default. */
 	netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
-				  &netdev->features);
+				  netdev->features);
 	netdev->gso_max_segs = NFP_NET_LSO_MAX_SEGS;
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, netdev->features);
 
 	if (nfp_app_has_tc(app)) {
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->features);
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, netdev->hw_features);
 	}
 
 	err = nfp_app_repr_init(app, netdev);
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 8c4f8211c021..603e3a4ccfa2 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1273,8 +1273,8 @@ static int nixge_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
-	netdev_feature_zero(&ndev->features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
+	netdev_feature_zero(ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->features);
 	ndev->netdev_ops = &nixge_netdev_ops;
 	ndev->ethtool_ops = &nixge_ethtool_ops;
 
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 0c408d420d79..7bb500488b7f 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4922,11 +4922,11 @@ static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
 }
 
 static void nv_fix_features(struct net_device *dev,
-			    netdev_features_t *features)
+			    netdev_features_t features)
 {
 	/* vlan is dependent on rx checksum offload */
 	if (netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_TX |
-				     NETIF_F_HW_VLAN_CTAG_RX, *features))
+				     NETIF_F_HW_VLAN_CTAG_RX, features))
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, features);
 }
 
@@ -4958,7 +4958,7 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 	u8 __iomem *base = get_hwbase(dev);
 	int retval;
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
 	    netif_running(dev)) {
@@ -5791,7 +5791,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 					 "64-bit DMA failed, using 32-bit addressing\n");
 			else
 				netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-						       &dev->features);
+						       dev->features);
 		}
 	} else if (id->driver_data & DEV_HAS_LARGEDESC) {
 		/* packet format 2: supports jumbo frames */
@@ -5811,7 +5811,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 		np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
 					NETIF_F_TSO | NETIF_F_RXCSUM,
-					&dev->hw_features);
+					dev->hw_features);
 	}
 
 	np->vlanctl_bits = 0;
@@ -5819,13 +5819,13 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 		np->vlanctl_bits = NVREG_VLANCONTROL_ENABLE;
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
 					NETIF_F_HW_VLAN_CTAG_TX,
-					&dev->hw_features);
+					dev->hw_features);
 	}
 
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 
 	/* Add loopback capability to the device. */
-	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_LOOPBACK_BIT, dev->hw_features);
 
 	/* MTU range: 64 - 1500 or 9100 */
 	dev->min_mtu = ETH_ZLEN + ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 7e25af846448..a63d62a3fe77 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2212,7 +2212,7 @@ static int pch_gbe_set_features(struct net_device *netdev,
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
@@ -2525,10 +2525,10 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	netdev->watchdog_timeo = PCH_GBE_WATCHDOG_PERIOD;
 	netif_napi_add(netdev, &adapter->napi,
 		       pch_gbe_napi_poll, PCH_GBE_RX_WEIGHT);
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM, &netdev->hw_features);
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+				NETIF_F_IPV6_CSUM, netdev->hw_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 	pch_gbe_set_ethtool_ops(netdev);
 
 	/* MTU range: 46 - 10300 */
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
index 1e3a909a08c5..2f714aa32b9f 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
@@ -478,7 +478,7 @@ void pch_gbe_check_options(struct pch_gbe_adapter *adapter)
 		pch_gbe_validate_option(&val, &opt, adapter);
 		if (!val)
 			netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
-						 &dev->features);
+						 dev->features);
 	}
 	{ /* Checksum Offload Enable/Disable */
 		static const struct pch_gbe_option opt = {
@@ -491,7 +491,7 @@ void pch_gbe_check_options(struct pch_gbe_adapter *adapter)
 		pch_gbe_validate_option(&val, &opt, adapter);
 		if (!val)
 			netdev_feature_clear_bits(NETIF_F_CSUM_MASK,
-						  &dev->features);
+						  dev->features);
 	}
 	{ /* Flow Control */
 		static const struct pch_gbe_option opt = {
diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 2af65e8a27fd..7da85751d1e1 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1699,10 +1699,10 @@ pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &mac->napi, pasemi_mac_poll, 64);
 
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_LLTX | NETIF_F_SG |
 				NETIF_F_HIGHDMA | NETIF_F_GSO,
-				&dev->features);
+				dev->features);
 
 	mac->dma_pdev = pci_get_device(PCI_VENDOR_ID_PASEMI, 0xa007, NULL);
 	if (!mac->dma_pdev) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 62178c7b9cc1..e521eb0f080a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1608,7 +1608,7 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	int err;
 
 	/* set up what we expect to support by default */
-	netdev_feature_zero(&features);
+	netdev_feature_zero(features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER |
@@ -1618,74 +1618,74 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 				NETIF_F_TSO |
 				NETIF_F_TSO6 |
 				NETIF_F_TSO_ECN,
-				&features);
+				features);
 
 	if (lif->nxqs > 1)
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, features);
 
 	err = ionic_set_nic_features(lif, features);
 	if (err)
 		return err;
 
 	/* tell the netdev what we actually can support */
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_TX_TAG)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_STRIP)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_FILTER)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_RX_HASH)
 		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (lif->hw_features & IONIC_ETH_HW_TX_SG)
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
 
 	if (lif->hw_features & IONIC_ETH_HW_TX_CSUM)
 		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_RX_CSUM)
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO)
 		netdev_feature_set_bit(NETIF_F_TSO_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPV6)
 		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_ECN)
 		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE)
 		netdev_feature_set_bit(NETIF_F_GSO_GRE_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE_CSUM)
 		netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP4)
 		netdev_feature_set_bit(NETIF_F_GSO_IPXIP4_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP6)
 		netdev_feature_set_bit(NETIF_F_GSO_IPXIP6_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP)
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP_CSUM)
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 
-	netdev_feature_or(&netdev->hw_features, netdev->hw_features,
+	netdev_feature_or(netdev->hw_features, netdev->hw_features,
 			  netdev->hw_enc_features);
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
-	netdev_feature_copy(&features, netdev->features);
-	netdev_feature_clear_bits(NETIF_F_VLAN_FEATURES, &features);
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_copy(features, netdev->features);
+	netdev_feature_clear_bits(NETIF_F_VLAN_FEATURES, features);
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 487b2039a7b3..07602aef1221 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -518,9 +518,9 @@ static void netxen_set_multicast_list(struct net_device *dev)
 }
 
 static void netxen_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		netdev_info(dev, "disabling LRO as RXCSUM is off\n");
 
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
@@ -1345,32 +1345,32 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 
 	netdev->ethtool_ops = &netxen_nic_ethtool_ops;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-				NETIF_F_RXCSUM, &netdev->hw_features);
+				NETIF_F_RXCSUM, netdev->hw_features);
 
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
 		netdev_feature_set_bits(NETIF_F_IPV6_CSUM | NETIF_F_TSO6,
-					&netdev->hw_features);
+					netdev->hw_features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->hw_features);
 
 	if (adapter->pci_using_dac) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-				       &netdev->vlan_features);
+				       netdev->vlan_features);
 	}
 
 	if (adapter->capabilities & NX_FW_CAPABILITY_FVLANTX)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
 	if (adapter->capabilities & NX_FW_CAPABILITY_HW_LRO)
 		netdev_feature_set_bit(NETIF_F_LRO_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 
 	netdev->irq = adapter->msix_entries[0].vector;
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index dc5041c289eb..79622ca45242 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -528,7 +528,7 @@ int qede_xdp_transmit(struct net_device *dev, int n_frames,
 u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 		      struct net_device *sb_dev);
 void qede_features_check(struct sk_buff *skb, struct net_device *dev,
-			 netdev_features_t *features);
+			 netdev_features_t features);
 int qede_alloc_rx_buffer(struct qede_rx_queue *rxq, bool allow_lazy);
 int qede_free_tx_pkt(struct qede_dev *edev,
 		     struct qede_tx_queue *txq, int *len);
@@ -545,7 +545,7 @@ int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid);
 void qede_vlan_mark_nonconfigured(struct qede_dev *edev);
 int qede_configure_vlan_filters(struct qede_dev *edev);
 
-void qede_fix_features(struct net_device *dev, netdev_features_t *features);
+void qede_fix_features(struct net_device *dev, netdev_features_t features);
 int qede_set_features(struct net_device *dev, netdev_features_t features);
 void qede_set_rx_mode(struct net_device *ndev);
 void qede_config_rx_mode(struct net_device *ndev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 5a1c975c00e1..bfeeb656367d 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1027,7 +1027,7 @@ int qede_change_mtu(struct net_device *ndev, int new_mtu)
 		   "Configuring MTU size of %d\n", new_mtu);
 
 	if (new_mtu > PAGE_SIZE)
-		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &ndev->features);
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, ndev->features);
 
 	/* Set the mtu field and re-start the interface if needed */
 	args.u.mtu = new_mtu;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 684565231c25..9c481f69b39c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -907,15 +907,15 @@ void qede_vlan_mark_nonconfigured(struct qede_dev *edev)
 static void qede_set_features_reload(struct qede_dev *edev,
 				     struct qede_reload_args *args)
 {
-	netdev_feature_copy(&edev->ndev->features, args->u.features);
+	netdev_feature_copy(edev->ndev->features, args->u.features);
 }
 
-void qede_fix_features(struct net_device *dev, netdev_features_t *features)
+void qede_fix_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
 	if (edev->xdp_prog || edev->ndev->mtu > PAGE_SIZE ||
-	    !netdev_feature_test_bit(NETIF_F_GRO_BIT, *features))
+	    !netdev_feature_test_bit(NETIF_F_GRO_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 }
 
@@ -925,7 +925,7 @@ int qede_set_features(struct net_device *dev, netdev_features_t features)
 	__DECLARE_NETDEV_FEATURE_MASK(changes);
 	bool need_reload = false;
 
-	netdev_feature_xor(&changes, features, dev->features);
+	netdev_feature_xor(changes, features, dev->features);
 
 	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, changes))
 		need_reload = true;
@@ -933,7 +933,7 @@ int qede_set_features(struct net_device *dev, netdev_features_t features)
 	if (need_reload) {
 		struct qede_reload_args args;
 
-		netdev_feature_copy(&args.u.features, features);
+		netdev_feature_copy(args.u.features, features);
 		args.func = &qede_set_features_reload;
 
 		/* Make sure that we definitely need to reload.
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 2d49c95c8b45..f636d8bffaff 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1748,7 +1748,7 @@ u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 #define QEDE_MAX_TUN_HDR_LEN 48
 
 void qede_features_check(struct sk_buff *skb, struct net_device *dev,
-			 netdev_features_t *features)
+			 netdev_features_t features)
 {
 	if (skb->encapsulation) {
 		u8 l4_proto = 0;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index e0a38e3e4ec8..cecc3b7aeb74 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -789,36 +789,36 @@ static void qede_init_ndev(struct qede_dev *edev)
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* user-changeble features */
-	netdev_feature_zero(&hw_features);
+	netdev_feature_zero(hw_features);
 	netdev_feature_set_bits(NETIF_F_GRO | NETIF_F_GRO_HW | NETIF_F_SG |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_TC,
-				&hw_features);
+				hw_features);
 
 	if (edev->dev_info.common.b_arfs_capable)
-		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &hw_features);
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, hw_features);
 
 	if (edev->dev_info.common.vxlan_enable ||
 	    edev->dev_info.common.geneve_enable)
 		udp_tunnel_enable = true;
 
 	if (udp_tunnel_enable || edev->dev_info.common.gre_enable) {
-		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &hw_features);
-		netdev_feature_zero(&ndev->hw_enc_features);
+		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, hw_features);
+		netdev_feature_zero(ndev->hw_enc_features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 					NETIF_F_SG | NETIF_F_TSO |
 					NETIF_F_TSO_ECN | NETIF_F_TSO6 |
 					NETIF_F_RXCSUM,
-					&ndev->hw_enc_features);
+					ndev->hw_enc_features);
 	}
 
 	if (udp_tunnel_enable) {
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&hw_features);
+					hw_features);
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&ndev->hw_enc_features);
+					ndev->hw_enc_features);
 
 		qede_set_udp_tunnels(edev);
 	}
@@ -826,22 +826,22 @@ static void qede_init_ndev(struct qede_dev *edev)
 	if (edev->dev_info.common.gre_enable) {
 		netdev_feature_set_bits(NETIF_F_GSO_GRE |
 					NETIF_F_GSO_GRE_CSUM,
-					&hw_features);
+					hw_features);
 		netdev_feature_set_bits(NETIF_F_GSO_GRE |
 					NETIF_F_GSO_GRE_CSUM,
-					&ndev->hw_enc_features);
+					ndev->hw_enc_features);
 	}
 
-	netdev_feature_copy(&ndev->vlan_features, hw_features);
+	netdev_feature_copy(ndev->vlan_features, hw_features);
 	netdev_feature_set_bits(NETIF_F_RXHASH | NETIF_F_RXCSUM |
-				NETIF_F_HIGHDMA, &ndev->vlan_features);
-	netdev_feature_copy(&ndev->features, hw_features);
+				NETIF_F_HIGHDMA, ndev->vlan_features);
+	netdev_feature_copy(ndev->features, hw_features);
 	netdev_feature_set_bits(NETIF_F_RXHASH | NETIF_F_RXCSUM |
 				NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA |
 				NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_HW_VLAN_CTAG_TX, &ndev->features);
+				NETIF_F_HW_VLAN_CTAG_TX, ndev->features);
 
-	netdev_feature_copy(&ndev->hw_features, hw_features);
+	netdev_feature_copy(ndev->hw_features, hw_features);
 
 	/* MTU range: 46 - 9600 */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
@@ -1506,7 +1506,7 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 	} else {
 		rxq->rx_buf_seg_size = PAGE_SIZE;
 		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT,
-					 &edev->ndev->features);
+					 edev->ndev->features);
 	}
 
 	/* Allocate the parallel driver ring for Rx buffers */
@@ -2398,7 +2398,7 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 
 	if (qede_alloc_arfs(edev)) {
 		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
-					 &edev->ndev->features);
+					 edev->ndev->features);
 		edev->dev_info.common.b_arfs_capable = false;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index c396ee012915..51cc821f91b5 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3797,10 +3797,10 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 	qdev->msg_enable = netif_msg_init(debug, default_msg);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 	if (qdev->device_id == QL3032_DEVICE_ID)
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
-					&ndev->features);
+					ndev->features);
 
 	qdev->mem_map_registers = pci_ioremap_bar(pdev, 1);
 	if (!qdev->mem_map_registers) {
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index 7fbf895becdd..5b012bd9814b 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -1622,7 +1622,7 @@ int qlcnic_82xx_read_phys_port_id(struct qlcnic_adapter *);
 int qlcnic_fw_cmd_set_mtu(struct qlcnic_adapter *adapter, int mtu);
 int qlcnic_fw_cmd_set_drv_version(struct qlcnic_adapter *, u32);
 int qlcnic_change_mtu(struct net_device *netdev, int new_mtu);
-void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features);
+void qlcnic_fix_features(struct net_device *netdev, netdev_features_t features);
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features);
 int qlcnic_config_bridged_mode(struct qlcnic_adapter *adapter, u32 enable);
 void qlcnic_update_cmd_producer(struct qlcnic_host_tx_ring *);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index ee055e9e8eda..85edd7717dee 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1021,7 +1021,7 @@ int qlcnic_change_mtu(struct net_device *netdev, int mtu)
 }
 
 static void qlcnic_process_flags(struct qlcnic_adapter *adapter,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	u32 offload_flags = adapter->offload_flags;
 
@@ -1057,7 +1057,7 @@ static void qlcnic_process_flags(struct qlcnic_adapter *adapter,
 	}
 }
 
-void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
+void qlcnic_fix_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
@@ -1067,19 +1067,19 @@ void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 		if (adapter->flags & QLCNIC_APP_CHANGED_FLAGS) {
 			qlcnic_process_flags(adapter, features);
 		} else {
-			netdev_feature_xor(&changed, *features,
+			netdev_feature_xor(changed, features,
 					   netdev->features);
 			netdev_feature_and_bits(NETIF_F_RXCSUM |
 						NETIF_F_IP_CSUM |
 						NETIF_F_IPV6_CSUM |
 						NETIF_F_TSO |
 						NETIF_F_TSO6,
-						&changed);
-			netdev_feature_xor(features, *features, changed);
+						changed);
+			netdev_feature_xor(features, features, changed);
 		}
 	}
 
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 }
 
@@ -1090,14 +1090,14 @@ int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int hw_lro;
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	hw_lro = netdev_feature_test_bit(NETIF_F_LRO_BIT, features) ?
 		QLCNIC_LRO_ENABLED : 0;
 
 	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	netdev_feature_change_bit(NETIF_F_LRO_BIT, &netdev->features);
+	netdev_feature_change_bit(NETIF_F_LRO_BIT, netdev->features);
 
 	if (qlcnic_config_hw_lro(adapter, hw_lro))
 		return -EIO;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 53f33fb6d80b..81786f27844c 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -493,7 +493,7 @@ static const struct udp_tunnel_nic_info qlcnic_udp_tunnels = {
 };
 
 static void qlcnic_features_check(struct sk_buff *skb, struct net_device *dev,
-				  netdev_features_t *features)
+				  netdev_features_t features)
 {
 	vlan_features_check(skb, features);
 	vxlan_features_check(skb, features);
@@ -2277,54 +2277,54 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev,
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_GRO |
-				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, netdev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
-				NETIF_F_IPV6_CSUM, &netdev->vlan_features);
+				NETIF_F_IPV6_CSUM, netdev->vlan_features);
 
 	if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&netdev->features);
+					netdev->features);
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&netdev->vlan_features);
+					netdev->vlan_features);
 	}
 
 	if (pci_using_dac) {
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, netdev->features);
 		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-				       &netdev->vlan_features);
+				       netdev->vlan_features);
 	}
 
 	if (qlcnic_vlan_tx_check(adapter))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 	if (qlcnic_sriov_vf_check(adapter))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 	if (adapter->ahw->capabilities & QLCNIC_FW_CAPABILITY_HW_LRO)
-		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, netdev->features);
 
 	if (qlcnic_encap_tx_offload(adapter)) {
 		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
-				       &netdev->features);
+				       netdev->features);
 
 		/* encapsulation Tx offload supported by Adapter */
 		netdev_feature_set_bits(NETIF_F_IP_CSUM		|
 					NETIF_F_GSO_UDP_TUNNEL	|
 					NETIF_F_TSO		|
 					NETIF_F_TSO6,
-					&netdev->hw_enc_features);
+					netdev->hw_enc_features);
 	}
 
 	if (qlcnic_encap_rx_offload(adapter)) {
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &netdev->hw_enc_features);
+				       netdev->hw_enc_features);
 
 		netdev->udp_tunnel_nic_info = &qlcnic_udp_tunnels;
 	}
 
-	netdev_feature_copy(&netdev->hw_features, netdev->features);
+	netdev_feature_copy(netdev->hw_features, netdev->features);
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->irq = adapter->msix_entries[0].vector;
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 53a83c12cb53..c8be8759f2af 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -178,7 +178,7 @@ static int emac_set_features(struct net_device *netdev,
 	struct emac_adapter *adpt = netdev_priv(netdev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, features, netdev->features);
+	netdev_feature_xor(changed, features, netdev->features);
 
 	/* We only need to reprogram the hardware if the VLAN tag features
 	 * have changed, and if it's already running.
@@ -193,7 +193,7 @@ static int emac_set_features(struct net_device *netdev,
 	/* emac_mac_mode_config() uses netdev->features to configure the EMAC,
 	 * so make sure it's set first.
 	 */
-	netdev_feature_copy(&netdev->features, features);
+	netdev_feature_copy(netdev->features, features);
 
 	return emac_reinit_locked(adpt);
 }
@@ -671,15 +671,15 @@ static int emac_probe(struct platform_device *pdev)
 	}
 
 	/* set hw features */
-	netdev_feature_zero(&netdev->features);
+	netdev_feature_zero(netdev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 				NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
-				NETIF_F_HW_VLAN_CTAG_TX, &netdev->features);
-	netdev_feature_copy(&netdev->hw_features, netdev->features);
+				NETIF_F_HW_VLAN_CTAG_TX, netdev->features);
+	netdev_feature_copy(netdev->hw_features, netdev->features);
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
 	/* MTU range: 46 - 9194 */
 	netdev->min_mtu = EMAC_MIN_ETH_FRAME_SIZE -
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d6d3dabe7c11..4d03846535e6 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -236,7 +236,7 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->needs_free_netdev = true;
 	rmnet_dev->ethtool_ops = &rmnet_ethtool_ops;
 
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &rmnet_dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, rmnet_dev->features);
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	rmnet_dev->addr_assign_type = NET_ADDR_RANDOM;
@@ -261,11 +261,11 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		return -EBUSY;
 	}
 
-	netdev_feature_zero(&rmnet_dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &rmnet_dev->hw_features);
+	netdev_feature_zero(rmnet_dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, rmnet_dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				&rmnet_dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &rmnet_dev->hw_features);
+				rmnet_dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, rmnet_dev->hw_features);
 
 	priv->real_dev = real_dev;
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 5ef5b41c7aab..f57ff0cd89bb 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1855,7 +1855,7 @@ static void cp_set_d3_state (struct cp_private *cp)
 }
 
 static void cp_features_check(struct sk_buff *skb, struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	if (skb_shinfo(skb)->gso_size > MSSMask)
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
@@ -1961,8 +1961,8 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	cp->cpcmd = (pci_using_dac ? PCIDAC : 0) |
 		    PCIMulRW | RxChkSum | CpRxOn | CpTxOn;
 
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->hw_features);
 
 	regs = ioremap(pciaddr, CP_REGS_SIZE);
 	if (!regs) {
@@ -1989,17 +1989,17 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &dev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, dev->features);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &dev->hw_features);
-	netdev_feature_zero(&dev->vlan_features);
+				NETIF_F_HW_VLAN_CTAG_RX, dev->hw_features);
+	netdev_feature_zero(dev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-				NETIF_F_HIGHDMA, &dev->vlan_features);
+				NETIF_F_HIGHDMA, dev->vlan_features);
 
 	/* MTU range: 60 - 4096 */
 	dev->min_mtu = CP_MIN_MTU;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index bb8ed95c70ad..7cd11b6d68a1 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -904,7 +904,7 @@ static int rtl8139_set_features(struct net_device *dev, netdev_features_t featur
 	unsigned long flags;
 	void __iomem *ioaddr = tp->mmio_addr;
 
-	netdev_feature_xor(&changed, features, dev->features);
+	netdev_feature_xor(changed, features, dev->features);
 
 	if (!netdev_feature_test_bit(NETIF_F_RXALL_BIT, changed))
 		return 0;
@@ -1011,11 +1011,11 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	 * features
 	 */
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA,
-				&dev->features);
-	netdev_feature_copy(&dev->vlan_features, dev->features);
+				dev->features);
+	netdev_feature_copy(dev->vlan_features, dev->features);
 
-	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, dev->hw_features);
 
 	/* MTU range: 68 - 1770 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3fdc1da3eb52..eecf96e6e29b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1432,7 +1432,7 @@ static int rtl8169_get_regs_len(struct net_device *dev)
 }
 
 static void rtl8169_fix_features(struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
@@ -4329,7 +4329,7 @@ static unsigned int rtl_last_frag_len(struct sk_buff *skb)
 }
 
 /* Workaround for hw issues with TSO on RTL8168evl */
-static void rtl8168evl_fix_tso(struct sk_buff *skb, netdev_features_t *features)
+static void rtl8168evl_fix_tso(struct sk_buff *skb, netdev_features_t features)
 {
 	/* IPv4 header has options field */
 	if (vlan_get_protocol(skb) == htons(ETH_P_IP) &&
@@ -4346,7 +4346,7 @@ static void rtl8168evl_fix_tso(struct sk_buff *skb, netdev_features_t *features)
 }
 
 static void rtl8169_features_check(struct sk_buff *skb, struct net_device *dev,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	int transport_offset = skb_transport_offset(skb);
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -5322,7 +5322,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
 	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	rtl_init_rxcfg(tp);
 
@@ -5346,13 +5346,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
 				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &dev->hw_features);
-	netdev_feature_zero(&dev->vlan_features);
+				NETIF_F_HW_VLAN_CTAG_RX, dev->hw_features);
+	netdev_feature_zero(dev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO,
-				&dev->vlan_features);
+				dev->vlan_features);
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	/*
@@ -5362,13 +5362,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (tp->mac_version == RTL_GIGA_MAC_VER_05)
 		/* Disallow toggling */
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					 &dev->hw_features);
+					 dev->hw_features);
 
 	if (rtl_chip_supports_csum_v2(tp))
 		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-				       &dev->hw_features);
+				       dev->hw_features);
 
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 
 	/* There has been a number of reports that using SG/TSO results in
 	 * tx timeouts. However for a lot of people SG/TSO works fine.
@@ -5377,18 +5377,18 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6,
-					&dev->hw_features);
+					dev->hw_features);
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
 	} else {
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO,
-					&dev->hw_features);
+					dev->hw_features);
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V1;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
 	}
 
-	netdev_feature_set_bit(NETIF_F_RXALL_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXALL_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXFCS_BIT, dev->hw_features);
 
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e4fcda147396..4b999b4e903d 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1925,14 +1925,14 @@ static int ravb_set_features_rx_csum(struct net_device *ndev,
 {
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, ndev->features, features);
+	netdev_feature_xor(changed, ndev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed))
 		ravb_set_rx_csum(ndev,
 				 netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
 							 features));
 
-	netdev_feature_copy(&ndev->features, features);
+	netdev_feature_copy(ndev->features, features);
 
 	return 0;
 }
@@ -2172,10 +2172,10 @@ static int ravb_probe(struct platform_device *pdev)
 
 	info = of_device_get_match_data(&pdev->dev);
 
-	netdev_feature_zero(&ndev->features);
-	netdev_feature_set_bits(info->net_features, &ndev->features);
-	netdev_feature_zero(&ndev->hw_features);
-	netdev_feature_set_bits(info->net_hw_features, &ndev->hw_features);
+	netdev_feature_zero(ndev->features);
+	netdev_feature_set_bits(info->net_features, ndev->features);
+	netdev_feature_zero(ndev->hw_features);
+	netdev_feature_set_bits(info->net_hw_features, ndev->hw_features);
 
 	reset_control_deassert(rstc);
 	pm_runtime_enable(&pdev->dev);
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index a8fc9e42feca..35c7777ae5a6 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2936,7 +2936,7 @@ static int sh_eth_set_features(struct net_device *ndev,
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, ndev->features, features);
+	netdev_feature_xor(changed, ndev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed) &&
 	    mdp->cd->rx_csum)
@@ -2944,7 +2944,7 @@ static int sh_eth_set_features(struct net_device *ndev,
 				   netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
 							   features));
 
-	netdev_feature_copy(&ndev->features, features);
+	netdev_feature_copy(ndev->features, features);
 
 	return 0;
 }
@@ -3298,10 +3298,10 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	ndev->min_mtu = ETH_MIN_MTU;
 
 	if (mdp->cd->rx_csum) {
-		netdev_feature_zero(&ndev->features);
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &ndev->features);
-		netdev_feature_zero(&ndev->hw_features);
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &ndev->hw_features);
+		netdev_feature_zero(ndev->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, ndev->features);
+		netdev_feature_zero(ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, ndev->hw_features);
 	}
 
 	/* set function */
@@ -3354,7 +3354,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 		}
 		mdp->port = port;
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &ndev->features);
+				       ndev->features);
 
 		/* Need to init only the first port of the two sharing a TSU */
 		if (port == 0) {
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 10d987854ab4..561c5d5757b5 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2590,7 +2590,7 @@ static int rocker_probe_port(struct rocker *rocker, unsigned int port_number)
 	rocker_carrier_init(rocker_port);
 
 	netdev_feature_set_bits(NETIF_F_NETNS_LOCAL | NETIF_F_SG,
-				&dev->features);
+				dev->features);
 
 	/* MTU range: 68 - 9000 */
 	dev->min_mtu = ROCKER_PORT_MIN_MTU;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index b8b6e3164ad5..8afe25568dd5 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1777,7 +1777,7 @@ static int sxgbe_set_features(struct net_device *dev,
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
@@ -2104,13 +2104,13 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 
 	ndev->netdev_ops = &sxgbe_netdev_ops;
 
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM |
 				NETIF_F_RXCSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-				NETIF_F_GRO, &ndev->hw_features);
-	netdev_feature_or(&ndev->features, ndev->features, ndev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+				NETIF_F_GRO, ndev->hw_features);
+	netdev_feature_or(ndev->features, ndev->features, ndev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
 	/* assign filtering support */
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 426a56a6f48e..63d5adec3f04 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -628,7 +628,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	if (nic_data->datapath_caps &
 	    (1 << MC_CMD_GET_CAPABILITIES_OUT_RX_INCLUDE_FCS_LBN))
 		netdev_feature_set_bit(NETIF_F_RXFCS_BIT,
-				       &efx->net_dev->hw_features);
+				       efx->net_dev->hw_features);
 
 	rc = efx_mcdi_port_get_number(efx);
 	if (rc < 0)
@@ -1308,7 +1308,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	__DECLARE_NETDEV_FEATURE_MASK(hw_enc_features);
 	int rc;
 
-	netdev_feature_zero(&hw_enc_features);
+	netdev_feature_zero(hw_enc_features);
 
 	if (nic_data->must_check_datapath_caps) {
 		rc = efx_ef10_init_datapath_caps(efx);
@@ -1355,26 +1355,26 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-					&hw_enc_features);
+					hw_enc_features);
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		__DECLARE_NETDEV_FEATURE_MASK(encap_tso_features);
 
-		netdev_feature_zero(&encap_tso_features);
+		netdev_feature_zero(encap_tso_features);
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_GRE |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_GRE_CSUM,
-					&encap_tso_features);
+					encap_tso_features);
 
-		netdev_feature_or(&hw_enc_features, hw_enc_features,
+		netdev_feature_or(hw_enc_features, hw_enc_features,
 				  encap_tso_features);
-		netdev_feature_set_bit(NETIF_F_TSO_BIT, &hw_enc_features);
-		netdev_feature_or(&efx->net_dev->features,
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, hw_enc_features);
+		netdev_feature_or(efx->net_dev->features,
 				  efx->net_dev->features,
 				  encap_tso_features);
 	}
-	netdev_feature_copy(&efx->net_dev->hw_enc_features, hw_enc_features);
+	netdev_feature_copy(efx->net_dev->hw_enc_features, hw_enc_features);
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index e16cf6bc6ba1..0fd82d758074 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -186,24 +186,24 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 		struct net_device *net_dev = efx->net_dev;
 		__DECLARE_NETDEV_FEATURE_MASK(tso);
 
-		netdev_feature_zero(&tso);
+		netdev_feature_zero(tso);
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6 |
 					NETIF_F_GSO_PARTIAL |
 					NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM,
-					&tso);
+					tso);
 
-		netdev_feature_or(&net_dev->features, net_dev->features, tso);
-		netdev_feature_or(&net_dev->hw_features, net_dev->hw_features,
+		netdev_feature_or(net_dev->features, net_dev->features, tso);
+		netdev_feature_or(net_dev->hw_features, net_dev->hw_features,
 				  tso);
-		netdev_feature_or(&net_dev->hw_enc_features,
+		netdev_feature_or(net_dev->hw_enc_features,
 				  net_dev->hw_enc_features, tso);
 		/* EF100 HW can only offload outer checksums if they are UDP,
 		 * so for GRE_CSUM we have to use GSO_PARTIAL.
 		 */
 		netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
-				       &net_dev->gso_partial_features);
+				       net_dev->gso_partial_features);
 	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
@@ -1121,14 +1121,14 @@ static int ef100_probe_main(struct efx_nic *efx)
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
 	netdev_feature_set_bits(efx->type->offload_features[0],
-				&net_dev->features);
+				net_dev->features);
 	netdev_feature_set_bits(efx->type->offload_features[0],
-				&net_dev->hw_features);
+				net_dev->hw_features);
 	netdev_feature_set_bits(efx->type->offload_features[0],
-				&net_dev->hw_enc_features);
+				net_dev->hw_enc_features);
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
 				NETIF_F_HIGHDMA | NETIF_F_ALL_TSO,
-				&net_dev->vlan_features);
+				net_dev->vlan_features);
 
 	/* Populate design-parameter defaults */
 	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 2e449b5b34e3..56276ca5e27d 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -244,10 +244,10 @@ static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 	if (port_flags &
 	    (1 << MC_CMD_VPORT_ALLOC_IN_FLAG_VLAN_RESTRICT_LBN))
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &efx->fixed_features);
+				       efx->fixed_features);
 	else
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &efx->fixed_features);
+					 efx->fixed_features);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 7c909e8bfdde..3bbaba1f4786 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1006,31 +1006,31 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	/* Determine netdevice features */
 	netdev_feature_set_bits(efx->type->offload_features[0] | NETIF_F_SG |
 				NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL,
-				&net_dev->features);
+				net_dev->features);
 
 	if (efx->type->offload_features[0] & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
-		netdev_feature_set_bit(NETIF_F_TSO6_BIT, &net_dev->features);
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT, net_dev->features);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		netdev_feature_clear_bits(NETIF_F_ALL_TSO, &net_dev->features);
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, net_dev->features);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
 				NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
-				NETIF_F_RXCSUM, &net_dev->vlan_features);
+				NETIF_F_RXCSUM, net_dev->vlan_features);
 
-	netdev_feature_andnot(&tmp, net_dev->features, efx->fixed_features);
-	netdev_feature_or(&net_dev->hw_features, net_dev->hw_features, tmp);
+	netdev_feature_andnot(tmp, net_dev->features, efx->fixed_features);
+	netdev_feature_or(net_dev->hw_features, net_dev->hw_features, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
-	netdev_feature_clear_bit(NETIF_F_RXALL_BIT, &net_dev->features);
+	netdev_feature_clear_bit(NETIF_F_RXALL_BIT, net_dev->features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				 &net_dev->features);
-	netdev_feature_or(&net_dev->features, net_dev->features,
+				 net_dev->features);
+	netdev_feature_or(net_dev->features, net_dev->features,
 			  efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
@@ -1064,7 +1064,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct efx_nic_type *) entry->driver_data;
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 8eac2466e33b..ee9af0bf9dd3 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -225,7 +225,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	netdev_feature_xor(&changed, net_dev->features, data);
+	netdev_feature_xor(changed, net_dev->features, data);
 	if (netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				     NETIF_F_RXFCS, changed)) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
@@ -412,12 +412,12 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	netdev_feature_copy(&old_features, efx->net_dev->features);
-	netdev_feature_or(&efx->net_dev->hw_features,
+	netdev_feature_copy(old_features, efx->net_dev->features);
+	netdev_feature_or(efx->net_dev->hw_features,
 			  efx->net_dev->hw_features, efx->net_dev->features);
-	netdev_feature_andnot(&efx->net_dev->hw_features,
+	netdev_feature_andnot(efx->net_dev->hw_features,
 			      efx->net_dev->hw_features, efx->fixed_features);
-	netdev_feature_or(&efx->net_dev->features, efx->net_dev->features,
+	netdev_feature_or(efx->net_dev->features, efx->net_dev->features,
 			  efx->fixed_features);
 	if (!netdev_feature_equal(efx->net_dev->features, old_features))
 		netdev_features_change(efx->net_dev);
@@ -1361,12 +1361,12 @@ static bool efx_can_encap_offloads(struct efx_nic *efx, struct sk_buff *skb)
 }
 
 void efx_features_check(struct sk_buff *skb, struct net_device *dev,
-			netdev_features_t *features)
+			netdev_features_t features)
 {
 	struct efx_nic *efx = netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (netdev_feature_test_bits(NETIF_F_GSO_MASK, *features))
+		if (netdev_feature_test_bits(NETIF_F_GSO_MASK, features))
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
@@ -1375,7 +1375,7 @@ void efx_features_check(struct sk_buff *skb, struct net_device *dev,
 				netdev_feature_clear_bits(NETIF_F_GSO_MASK,
 							  features);
 		if (netdev_feature_test_bits(NETIF_F_GSO_MASK |
-					     NETIF_F_CSUM_MASK, *features))
+					     NETIF_F_CSUM_MASK, features))
 			if (!efx_can_encap_offloads(efx, skb))
 				netdev_feature_clear_bits(NETIF_F_GSO_MASK |
 							  NETIF_F_CSUM_MASK,
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index c4fea3997704..83d632b2584e 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -106,7 +106,7 @@ int efx_change_mtu(struct net_device *net_dev, int new_mtu);
 extern const struct pci_error_handlers efx_err_handlers;
 
 void efx_features_check(struct sk_buff *skb, struct net_device *dev,
-			netdev_features_t *features);
+			netdev_features_t features);
 
 int efx_get_phys_port_id(struct net_device *net_dev,
 			 struct netdev_phys_item_id *ppid);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f4bde5771ba2..1231ad0516e6 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -640,12 +640,12 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	netdev_feature_copy(&old_features, efx->net_dev->features);
-	netdev_feature_or(&efx->net_dev->hw_features,
+	netdev_feature_copy(old_features, efx->net_dev->features);
+	netdev_feature_or(efx->net_dev->hw_features,
 			  efx->net_dev->hw_features, efx->net_dev->features);
-	netdev_feature_andnot(&efx->net_dev->hw_features,
+	netdev_feature_andnot(efx->net_dev->hw_features,
 			      efx->net_dev->hw_features, efx->fixed_features);
-	netdev_feature_or(&efx->net_dev->features, efx->net_dev->features,
+	netdev_feature_or(efx->net_dev->features, efx->net_dev->features,
 			  efx->fixed_features);
 	if (!netdev_feature_equal(efx->net_dev->features, old_features))
 		netdev_features_change(efx->net_dev);
@@ -2208,7 +2208,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	netdev_feature_xor(&changed, net_dev->features, data);
+	netdev_feature_xor(changed, net_dev->features, data);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				    changed)) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
@@ -2894,7 +2894,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct ef4_nic_type *) entry->driver_data;
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
@@ -2916,16 +2916,14 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	netdev_feature_set_bits(efx->type->offload_features[0],
-				&net_dev->features);
-	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM,
-				&net_dev->features);
+	netdev_feature_set_bits(efx->type->offload_features[0], net_dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM, net_dev->features);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
 				NETIF_F_HIGHDMA | NETIF_F_RXCSUM,
-				&net_dev->vlan_features);
+				net_dev->vlan_features);
 
-	netdev_feature_andnot(&net_dev->hw_features, net_dev->features,
+	netdev_feature_andnot(net_dev->hw_features, net_dev->features,
 			      efx->fixed_features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
@@ -2933,8 +2931,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
 	netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				 &net_dev->features);
-	netdev_feature_or(&net_dev->features, net_dev->features,
+				 net_dev->features);
+	netdev_feature_or(net_dev->features, net_dev->features,
 			  efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 4b66f69f516b..922c8aa8bcd1 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1299,7 +1299,7 @@ static inline struct ef4_rx_buffer *ef4_rx_buffer(struct ef4_rx_queue *rx_queue,
  * always in features.
  */
 static inline void ef4_supported_features(const struct ef4_nic *efx,
-					  netdev_features_t *supported)
+					  netdev_features_t supported)
 {
 	const struct net_device *net_dev = efx->net_dev;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index c19950974b62..6e8257a70e20 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1321,7 +1321,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 	if (rc)
 		goto fail;
 
-	efx_supported_features(efx, &supported);
+	efx_supported_features(efx, supported);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				    supported) &&
 	    !(efx_mcdi_filter_match_supported(table, false,
@@ -1331,11 +1331,11 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		netif_info(efx, probe, net_dev,
 			   "VLAN filters are not supported in this firmware variant\n");
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &net_dev->features);
+					 net_dev->features);
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &efx->fixed_features);
+					 efx->fixed_features);
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &net_dev->hw_features);
+					 net_dev->hw_features);
 	}
 
 	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index ca29a3786ea2..d5763f77c9a2 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1682,7 +1682,7 @@ efx_channel_tx_old_fill_level(struct efx_channel *channel)
  * always in features.
  */
 static inline void efx_supported_features(const struct efx_nic *efx,
-					  netdev_features_t *supported)
+					  netdev_features_t supported)
 {
 	const struct net_device *net_dev = efx->net_dev;
 
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index ee72fc529e30..8c8e17b9df67 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -927,12 +927,12 @@ static int ioc3eth_probe(struct platform_device *pdev)
 	dev->watchdog_timeo	= 5 * HZ;
 	dev->netdev_ops		= &ioc3_netdev_ops;
 	dev->ethtool_ops	= &ioc3_ethtool_ops;
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
-				&dev->hw_features);
-	netdev_feature_zero(&dev->features);
+				dev->hw_features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_HIGHDMA,
-				&dev->features);
+				dev->features);
 
 	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
 	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index ad8aa980d7e3..758d7f28c1a6 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -1436,10 +1436,10 @@ static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	/* faked with skb_copy_and_csum_dev */
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				&dev->features);
+				dev->features);
 
 	dev->netdev_ops		= &sc92031_netdev_ops;
 	dev->watchdog_timeo	= TX_TIMEOUT;
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 9e1943434e7e..56e576964f3f 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2105,8 +2105,8 @@ static int netsec_probe(struct platform_device *pdev)
 
 	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_RXCSUM | NETIF_F_GSO |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				&ndev->features);
-	netdev_feature_copy(&ndev->hw_features, ndev->features);
+				ndev->features);
+	netdev_feature_copy(ndev->hw_features, ndev->features);
 
 	priv->rx_cksum_offload_flag = true;
 
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index efdcb7f3853f..34a47761dbba 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1595,9 +1595,9 @@ static int ave_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
-				&ndev->features);
+				ndev->features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
-				&ndev->hw_features);
+				ndev->hw_features);
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b3e9c9d52096..09de5490f2ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5464,7 +5464,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 }
 
 static void stmmac_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
@@ -5484,7 +5484,7 @@ static void stmmac_fix_features(struct net_device *dev,
 
 	/* Disable tso if asked by ethtool */
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *features))
+		if (netdev_feature_test_bit(NETIF_F_TSO_BIT, features))
 			priv->tso = true;
 		else
 			priv->tso = false;
@@ -6869,28 +6869,28 @@ int stmmac_dvr_probe(struct device *device,
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
 				NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM,
-				&ndev->hw_features);
+				ndev->hw_features);
 
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
-		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_HW_TC_BIT, ndev->hw_features);
 	}
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
-					&ndev->hw_features);
+					ndev->hw_features);
 		if (priv->plat->has_gmac4)
 			netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
-					       &ndev->hw_features);
+					       ndev->hw_features);
 		priv->tso = true;
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
 	if (priv->dma_cap.sphen) {
-		netdev_feature_set_bit(NETIF_F_GRO_BIT, &ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_GRO_BIT, ndev->hw_features);
 		priv->sph_cap = true;
 		priv->sph = priv->sph_cap;
 		dev_info(priv->device, "SPH feature enabled\n");
@@ -6928,27 +6928,27 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
-	netdev_feature_or(&ndev->features, ndev->features,
+	netdev_feature_or(ndev->features, ndev->features,
 			  ndev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_STAG_RX,
-				&ndev->features);
+				ndev->features);
 	if (priv->dma_cap.vlhash) {
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &ndev->features);
+				       ndev->features);
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
-				       &ndev->features);
+				       ndev->features);
 	}
 	if (priv->dma_cap.vlins) {
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-				       &ndev->features);
+				       ndev->features);
 		if (priv->dma_cap.dvlan)
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
-					       &ndev->features);
+					       ndev->features);
 	}
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
@@ -6960,7 +6960,7 @@ int stmmac_dvr_probe(struct device *device,
 		priv->rss.table[i] = ethtool_rxfh_indir_default(i, rxq);
 
 	if (priv->dma_cap.rssen && priv->plat->rss_en)
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, ndev->features);
 
 	/* MTU range: 46 - hw-specific max */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 785e11f0bd34..6d5bc5b06776 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5085,10 +5085,10 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Cassini features. */
 	if ((cp->cas_flags & CAS_FLAG_NO_HW_CSUM) == 0)
 		netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG,
-					&dev->features);
+					dev->features);
 
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	/* MTU range: 60 - varies or 9000 */
 	dev->min_mtu = CAS_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 2a01557f71e0..aa21d3a4c774 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -249,9 +249,9 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 	dev->ethtool_ops = &vsw_ethtool_ops;
 	dev->watchdog_timeo = VSW_TX_TIMEOUT;
 
-	netdev_feature_zero(&dev->hw_features);
-	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG, &dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG, dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index bcbf23c2ac06..a6b8b831db9d 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9711,11 +9711,11 @@ static void niu_device_announce(struct niu *np)
 
 static void niu_set_basic_features(struct net_device *dev)
 {
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXHASH,
-				&dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+				dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
 }
 
 static int niu_pci_init_one(struct pci_dev *pdev,
@@ -9781,7 +9781,7 @@ static int niu_pci_init_one(struct pci_dev *pdev,
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 	if (!err)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 	if (err) {
 		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 79b243520e68..859ec88e8fac 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2988,12 +2988,12 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, dev);
 
 	/* We can do scatter/gather and HW checksum */
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM,
-				&dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+				dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 	if (pci_using_dac)
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	/* MTU range: 68 - 1500 (Jumbo mode is broken) */
 	dev->min_mtu = GEM_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 26ef236949be..5820b3f9d52b 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2801,11 +2801,11 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
-				&dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+				dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
 
 	hp->irq = op->archdata.irqs[0];
 
@@ -3119,11 +3119,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
-				&dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+				dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
 	/* Hook up PCI register/descriptor accessors. */
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 1c5c85885a0a..334d501f653f 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -312,11 +312,11 @@ static struct vnet *vnet_new(const u64 *local_mac,
 	dev->ethtool_ops = &vnet_ethtool_ops;
 	dev->watchdog_timeo = VNET_TX_TIMEOUT;
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_GSO | NETIF_F_ALL_TSO |
 				NETIF_F_HW_CSUM | NETIF_F_SG,
-				&dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
+				dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 534c10e353d4..d637d1ca80ff 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1275,8 +1275,8 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_size = datalen;
 		skb_shinfo(skb)->gso_segs = gso_segs;
 	}
-	netdev_feature_copy(&tmp, dev->features);
-	netdev_feature_clear_bit(NETIF_F_TSO_BIT, &tmp);
+	netdev_feature_copy(tmp, dev->features);
+	netdev_feature_clear_bit(NETIF_F_TSO_BIT, tmp);
 	segs = skb_gso_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto out_dropped;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index 4e61f92c6512..9594094c31f9 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -179,47 +179,47 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 
 	/* Set device features */
 	if (pdata->hw_feat.tso) {
-		netdev_feature_zero(&netdev->hw_features);
-		netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
-		netdev_feature_set_bit(NETIF_F_TSO6_BIT, &netdev->hw_features);
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT, netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	} else if (pdata->hw_feat.tx_coe) {
-		netdev_feature_zero(&netdev->hw_features);
+		netdev_feature_zero(netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	}
 
 	if (pdata->hw_feat.rx_coe) {
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &netdev->hw_features);
-		netdev_feature_set_bit(NETIF_F_GRO_BIT, &netdev->hw_features);
+				       netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_GRO_BIT, netdev->hw_features);
 	}
 
 	if (pdata->hw_feat.rss)
 		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
-	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+	netdev_feature_or(netdev->vlan_features, netdev->vlan_features,
 			  netdev->hw_features);
 
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-			       &netdev->hw_features);
+			       netdev->hw_features);
 	if (pdata->hw_feat.sa_vlan_ins)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 	if (pdata->hw_feat.vlhash)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &netdev->hw_features);
+				       netdev->hw_features);
 
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
-	netdev_feature_copy(&pdata->netdev_features, netdev->features);
+	netdev_feature_copy(pdata->netdev_features, netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 927915547311..f37e47af9956 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -921,7 +921,7 @@ static int xlgmac_set_features(struct net_device *netdev,
 					  features) && rxvlan_filter)
 		hw_ops->disable_rx_vlan_filtering(pdata);
 
-	netdev_feature_copy(&pdata->netdev_features, features);
+	netdev_feature_copy(pdata->netdev_features, features);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index b91cb899beaa..82b8907ecfff 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1980,21 +1980,21 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* these fields are used for info purposes only
 		 * so we can have them same for all ports of the board */
 		ndev->if_port = port;
-		netdev_feature_zero(&ndev->features);
+		netdev_feature_zero(ndev->features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
 					NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_TX |
 					NETIF_F_HW_VLAN_CTAG_RX |
 					NETIF_F_HW_VLAN_CTAG_FILTER |
 					NETIF_F_RXCSUM,
-					&ndev->features);
-		netdev_feature_zero(&ndev->hw_features);
+					ndev->features);
+		netdev_feature_zero(ndev->hw_features);
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
 					NETIF_F_TSO | NETIF_F_HW_VLAN_CTAG_TX,
-					&ndev->hw_features);
+					ndev->hw_features);
 
 		if (pci_using_dac)
 			netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-					       &ndev->features);
+					       ndev->features);
 
 	/************** priv ****************/
 		priv = nic->priv[port] = netdev_priv(ndev);
@@ -2031,7 +2031,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 * set multicast list callback has to use priv->tx_lock.
 		 */
 #ifdef BDX_LLTX
-		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, ndev->features);
 #endif
 		/* MTU range: 60 - 16384 */
 		ndev->min_mtu = ETH_ZLEN;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index da28db9fa6ed..5a09f5dd76f2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1975,23 +1975,23 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
 	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
-	netdev_feature_zero(&port->ndev->hw_features);
+	netdev_feature_zero(port->ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_RXCSUM |
 				NETIF_F_HW_CSUM |
 				NETIF_F_HW_TC,
-				&port->ndev->hw_features);
-	netdev_feature_copy(&port->ndev->features, port->ndev->hw_features);
+				port->ndev->hw_features);
+	netdev_feature_copy(port->ndev->features, port->ndev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &port->ndev->features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &port->ndev->vlan_features);
+			       port->ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, port->ndev->vlan_features);
 	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
 	/* Disable TX checksum offload by default due to HW bug */
 	if (common->pdata.quirks & AM65_CPSW_QUIRK_I2027_NO_TX_CSUM)
 		netdev_feature_clear_bit(NETIF_F_HW_CSUM_BIT,
-					 &port->ndev->features);
+					 port->ndev->features);
 
 	ndev_priv->stats = netdev_alloc_pcpu_stats(struct am65_cpsw_ndev_stats);
 	if (!ndev_priv->stats)
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 025fef70665d..b734cf196051 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1465,7 +1465,7 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 	priv_sl2->emac_port = 1;
 	cpsw->slaves[1].ndev = ndev;
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, ndev->features);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
@@ -1645,7 +1645,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	cpsw->slaves[0].ndev = ndev;
 
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_HW_VLAN_CTAG_RX, &ndev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, ndev->features);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 25fa7eb9ad1e..bb74eca6aac4 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1409,7 +1409,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 					NETIF_F_HW_VLAN_CTAG_RX |
 					NETIF_F_NETNS_LOCAL,
-					&ndev->features);
+					ndev->features);
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
 		SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index a0129d484f45..a6c4dbba9033 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1976,11 +1976,11 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		return -ENOMEM;
 	}
 
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &ndev->features);
-	netdev_feature_copy(&ndev->hw_features, ndev->features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->vlan_features);
+			       ndev->features);
+	netdev_feature_copy(ndev->hw_features, ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->vlan_features);
 
 	/* MTU range: 68 - 9486 */
 	ndev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index f502108bd88c..46373291ad83 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1461,14 +1461,14 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	int status;
 	u64 v1, v2;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
-				&netdev->hw_features);
+				netdev->hw_features);
 
-	netdev_feature_zero(&netdev->features);
-	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &netdev->features);
+	netdev_feature_zero(netdev->features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, netdev->features);
 	if (GELIC_CARD_RX_CSUM_DEFAULT)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->features);
 
 	status = lv1_net_control(bus_id(card), dev_id(card),
 				 GELIC_LV1_GET_MAC_ADDRESS,
@@ -1489,7 +1489,7 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 		 * we can not receive vlan packets
 		 */
 		netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT,
-				       &netdev->features);
+				       netdev->features);
 	}
 
 	/* MTU range: 64 - 1518 */
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 2c8bfb02e9fb..84a937811c25 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2274,13 +2274,13 @@ spider_net_setup_netdev(struct spider_net_card *card)
 
 	spider_net_setup_netdev_ops(netdev);
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM,
-				&netdev->hw_features);
+				netdev->hw_features);
 	if (SPIDER_NET_RX_CSUM_DEFAULT)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, netdev->features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_LLTX,
-				&netdev->features);
+				netdev->features);
 
 	/* some time: NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 	 *		NETIF_F_HW_VLAN_CTAG_FILTER
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 3ab07ead9ce4..e2ae886a3540 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1609,8 +1609,8 @@ tsi108_init_one(struct platform_device *pdev)
 	 * a new function skb_csum_dev() in net/core/skbuff.c).
 	 */
 
-	netdev_feature_zero(&dev->features);
-	netdev_feature_set_bits(NETIF_F_HIGHDMA_BIT, &dev->features);
+	netdev_feature_zero(dev->features);
+	netdev_feature_set_bits(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	spin_lock_init(&data->txlock);
 	spin_lock_init(&data->misclock);
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 77b6cc9b2d63..d4a2736d908e 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -967,13 +967,13 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 
 	if (rp->quirks & rqRhineI)
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
-					&dev->features);
+					dev->features);
 
 	if (rp->quirks & rqMgmt)
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 					NETIF_F_HW_VLAN_CTAG_RX |
 					NETIF_F_HW_VLAN_CTAG_FILTER,
-					&dev->features);
+					dev->features);
 
 	/* dev->name not defined before register_netdev()! */
 	rc = register_netdev(dev);
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 583752b0d1cf..a2f4855eb60b 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2847,15 +2847,15 @@ static int velocity_probe(struct device *dev, int irq,
 	netif_napi_add(netdev, &vptr->napi, velocity_poll,
 							VELOCITY_NAPI_WEIGHT);
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG |
 				NETIF_F_HW_VLAN_CTAG_TX,
-				&netdev->hw_features);
+				netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_IP_CSUM,
-				&netdev->features);
+				netdev->features);
 
 	/* MTU range: 64 - 9000 */
 	netdev->min_mtu = VELOCITY_MIN_MTU;
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index 739d1c1f285e..18aabab7ec3e 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1136,7 +1136,7 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 	/* This chip doesn't support VLAN packets with normal MTU,
 	 * so disable VLAN for this device.
 	 */
-	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, ndev->features);
 
 	err = register_netdev(ndev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index fe2b05e82320..54e92fe738b4 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -608,7 +608,7 @@ static int w5300_probe(struct platform_device *pdev)
 	/* This chip doesn't support VLAN packets with normal MTU,
 	 * so disable VLAN for this device.
 	 */
-	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, ndev->features);
 
 	err = register_netdev(ndev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index b9c6341a7e47..0e736c2c2c4c 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1388,8 +1388,8 @@ static int temac_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-	netdev_feature_zero(&ndev->features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
+	netdev_feature_zero(ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->features);
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
@@ -1473,7 +1473,7 @@ static int temac_probe(struct platform_device *pdev)
 	}
 	if (lp->temac_features & TEMAC_FEATURE_TX_CSUM)
 		/* Can checksum TCP/UDP over IPv4. */
-		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, ndev->features);
 
 	/* Defaults for IRQ delay/coalescing setup.  These are
 	 * configuration values, so does not belong in device-tree.
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4740c2337ba5..7d9ca9cf19ae 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1859,8 +1859,8 @@ static int axienet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	netdev_feature_zero(&ndev->features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
+	netdev_feature_zero(ndev->features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, ndev->features);
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
@@ -1924,7 +1924,7 @@ static int axienet_probe(struct platform_device *pdev)
 			lp->features |= XAE_FEATURE_PARTIAL_TX_CSUM;
 			/* Can checksum TCP/UDP over IPv4. */
 			netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-					       &ndev->features);
+					       ndev->features);
 			break;
 		case 2:
 			lp->csum_offload_on_tx_path =
@@ -1932,7 +1932,7 @@ static int axienet_probe(struct platform_device *pdev)
 			lp->features |= XAE_FEATURE_FULL_TX_CSUM;
 			/* Can checksum TCP/UDP over IPv4. */
 			netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-					       &ndev->features);
+					       ndev->features);
 			break;
 		default:
 			lp->csum_offload_on_tx_path = XAE_NO_CSUM_OFFLOAD;
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 583d21ad25c8..a621ad63d38a 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1345,7 +1345,7 @@ static void fjes_netdev_setup(struct net_device *netdev)
 	netdev->min_mtu = fjes_support_mtu[0];
 	netdev->max_mtu = fjes_support_mtu[3];
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &netdev->features);
+			       netdev->features);
 }
 
 static void fjes_irq_watch_task(struct work_struct *work)
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index d2179c103300..c09d4451ea01 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1219,16 +1219,16 @@ static void geneve_setup(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &geneve_type);
 
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
-				&dev->features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+				dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->features);
 
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
-				&dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->hw_features);
+				dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->hw_features);
 
 	/* MTU range: 68 - (something less than 65535) */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index ddc55d3432f7..f456cc20cba3 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -639,7 +639,7 @@ static void gtp_link_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
 
 	dev->priv_flags	|= IFF_NO_QUEUE;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	netif_keep_dst(dev);
 
 	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index cd4520ddaf62..9884933e20ff 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -461,8 +461,8 @@ static void bpq_setup(struct net_device *dev)
 	memcpy(dev->dev_addr,  &ax25_defaddr, AX25_ADDR_LEN);
 
 	dev->flags      = 0;
-	netdev_feature_zero(&dev->features);
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features); /* Allow recursion */
+	netdev_feature_zero(dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features); /* Allow recursion */
 
 #if IS_ENABLED(CONFIG_AX25)
 	dev->header_ops      = &ax25_header_ops;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 84b3bce287cb..572532ed1d10 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1207,8 +1207,8 @@ static void netvsc_init_settings(struct net_device *dev)
 	ndc->speed = SPEED_UNKNOWN;
 	ndc->duplex = DUPLEX_FULL;
 
-	netdev_feature_zero(&dev->features);
-	netdev_feature_set_bit(NETIF_F_LRO_BIT, &dev->features);
+	netdev_feature_zero(dev->features);
+	netdev_feature_set_bit(NETIF_F_LRO_BIT, dev->features);
 }
 
 static int netvsc_get_link_ksettings(struct net_device *dev,
@@ -1923,7 +1923,7 @@ static int netvsc_set_ringparam(struct net_device *ndev,
 }
 
 static void netvsc_fix_features(struct net_device *ndev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
@@ -1931,7 +1931,7 @@ static void netvsc_fix_features(struct net_device *ndev,
 	if (!nvdev || nvdev->destroy)
 		return;
 
-	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features) &&
 	    netvsc_xdp_get(nvdev)) {
 		netdev_feature_change_bit(NETIF_F_LRO_BIT, features);
 		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
@@ -1951,7 +1951,7 @@ static int netvsc_set_features(struct net_device *ndev,
 	if (!nvdev || nvdev->destroy)
 		return -ENODEV;
 
-	netdev_feature_xor(&change, features, ndev->features);
+	netdev_feature_xor(change, features, ndev->features);
 
 	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, change))
 		goto syncvf;
@@ -1969,15 +1969,15 @@ static int netvsc_set_features(struct net_device *ndev,
 	ret = rndis_filter_set_offload_params(ndev, nvdev, &offloads);
 
 	if (ret) {
-		netdev_feature_change_bit(NETIF_F_LRO_BIT, &features);
-		netdev_feature_copy(&ndev->features, features);
+		netdev_feature_change_bit(NETIF_F_LRO_BIT, features);
+		netdev_feature_copy(ndev->features, features);
 	}
 
 syncvf:
 	if (!vf_netdev)
 		return ret;
 
-	netdev_feature_copy(&vf_netdev->wanted_features, features);
+	netdev_feature_copy(vf_netdev->wanted_features, features);
 	netdev_update_features(vf_netdev);
 
 	return ret;
@@ -2391,7 +2391,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	if (ndev->needed_headroom < vf_netdev->needed_headroom)
 		ndev->needed_headroom = vf_netdev->needed_headroom;
 
-	netdev_feature_copy(&vf_netdev->wanted_features, ndev->features);
+	netdev_feature_copy(vf_netdev->wanted_features, ndev->features);
 	netdev_update_features(vf_netdev);
 
 	prog = netvsc_xdp_get(netvsc_dev);
@@ -2556,10 +2556,10 @@ static int netvsc_probe(struct hv_device *dev,
 		schedule_work(&nvdev->subchan_work);
 
 	/* hw_features computed in rndis_netdev_set_hwcaps() */
-	netdev_feature_copy(&net->features, net->hw_features);
+	netdev_feature_copy(net->features, net->hw_features);
 	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &net->features);
-	netdev_feature_copy(&net->vlan_features, net->features);
+				NETIF_F_HW_VLAN_CTAG_RX, net->features);
+	netdev_feature_copy(net->vlan_features, net->features);
 
 	netdev_lockdep_set_classes(net);
 
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index f0206cd90678..21d1b4ceda64 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1364,17 +1364,17 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 
 	/* Reset previously set hw_features flags */
 	netdev_feature_clear_bits(NETVSC_SUPPORTED_HW_FEATURES,
-				  &net->hw_features);
+				  net->hw_features);
 	net_device_ctx->tx_checksum_mask = 0;
 
 	/* Compute tx offload settings based on hw capabilities */
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &net->hw_features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &net->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &net->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, net->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, net->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXHASH_BIT, net->hw_features);
 
 	if ((hwcaps.csum.ip4_txcsum & NDIS_TXCSUM_ALL_TCP4) == NDIS_TXCSUM_ALL_TCP4) {
 		/* Can checksum TCP */
-		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &net->hw_features);
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, net->hw_features);
 		net_device_ctx->tx_checksum_mask |= TRANSPORT_INFO_IPV4_TCP;
 
 		offloads.tcp_ip_v4_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_ENABLED;
@@ -1382,7 +1382,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 		if (hwcaps.lsov2.ip4_encap & NDIS_OFFLOAD_ENCAP_8023) {
 			offloads.lso_v2_ipv4 = NDIS_OFFLOAD_PARAMETERS_LSOV2_ENABLED;
 			netdev_feature_set_bit(NETIF_F_TSO_BIT,
-					       &net->hw_features);
+					       net->hw_features);
 
 			if (hwcaps.lsov2.ip4_maxsz < gso_max_size)
 				gso_max_size = hwcaps.lsov2.ip4_maxsz;
@@ -1396,7 +1396,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 
 	if ((hwcaps.csum.ip6_txcsum & NDIS_TXCSUM_ALL_TCP6) == NDIS_TXCSUM_ALL_TCP6) {
 		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-				       &net->hw_features);
+				       net->hw_features);
 
 		offloads.tcp_ip_v6_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_ENABLED;
 		net_device_ctx->tx_checksum_mask |= TRANSPORT_INFO_IPV6_TCP;
@@ -1405,7 +1405,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 		    (hwcaps.lsov2.ip6_opts & NDIS_LSOV2_CAP_IP6) == NDIS_LSOV2_CAP_IP6) {
 			offloads.lso_v2_ipv6 = NDIS_OFFLOAD_PARAMETERS_LSOV2_ENABLED;
 			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-					       &net->hw_features);
+					       net->hw_features);
 
 			if (hwcaps.lsov2.ip6_maxsz < gso_max_size)
 				gso_max_size = hwcaps.lsov2.ip6_maxsz;
@@ -1418,7 +1418,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	}
 
 	if (hwcaps.rsc.ip4 && hwcaps.rsc.ip6) {
-		netdev_feature_set_bit(NETIF_F_LRO_BIT, &net->hw_features);
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, net->hw_features);
 
 		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, net->features)) {
 			offloads.rsc_ip_v4 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
@@ -1432,10 +1432,10 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	/* In case some hw_features disappeared we need to remove them from
 	 * net->features list as they're no longer supported.
 	 */
-	netdev_feature_fill(&tmp);
-	netdev_feature_clear_bits(NETVSC_SUPPORTED_HW_FEATURES, &tmp);
-	netdev_feature_or(&tmp, tmp, net->hw_features);
-	netdev_feature_and(&net->features, net->features, tmp);
+	netdev_feature_fill(tmp);
+	netdev_feature_clear_bits(NETVSC_SUPPORTED_HW_FEATURES, tmp);
+	netdev_feature_or(tmp, tmp, net->hw_features);
+	netdev_feature_and(net->features, net->features, tmp);
 
 	netif_set_gso_max_size(net, gso_max_size);
 
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index c7cf224f8bed..dede1921fb02 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -213,13 +213,13 @@ static void ifb_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->tx_queue_len = TX_Q_LIMIT;
 
-	netdev_feature_set_bits(IFB_FEATURES, &dev->features);
-	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
-	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+	netdev_feature_set_bits(IFB_FEATURES, dev->features);
+	netdev_feature_or(dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(dev->hw_enc_features, dev->hw_enc_features,
 			  dev->features);
 	netdev_feature_set_bits(IFB_FEATURES & ~(NETIF_F_HW_VLAN_CTAG_TX |
 						 NETIF_F_HW_VLAN_STAG_TX),
-				&dev->vlan_features);
+				dev->vlan_features);
 
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index a7657e16a72a..ec6d3cef8860 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -216,8 +216,8 @@ static void ipa_modem_netdev_setup(struct net_device *netdev)
 	netdev->needed_headroom = sizeof(struct rmnet_map_header);
 	netdev->needed_tailroom = IPA_NETDEV_TAILROOM;
 	netdev->watchdog_timeo = IPA_NETDEV_TIMEOUT * HZ;
-	netdev_feature_zero(&netdev->hw_features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, netdev->hw_features);
 }
 
 /** ipa_modem_suspend() - suspend callback
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index e77e4dc2aa60..144f21f2c819 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -135,13 +135,13 @@ static int ipvlan_init(struct net_device *dev)
 
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
-	netdev_feature_copy(&dev->features, phy_dev->features);
-	netdev_feature_and_bits(IPVLAN_FEATURES, &dev->features);
-	netdev_feature_set_bits(IPVLAN_ALWAYS_ON, &dev->features);
-	netdev_feature_copy(&dev->vlan_features, phy_dev->vlan_features);
-	netdev_feature_and_bits(IPVLAN_FEATURES, &dev->vlan_features);
-	netdev_feature_set_bits(IPVLAN_ALWAYS_ON_OFLOADS, &dev->vlan_features);
-	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+	netdev_feature_copy(dev->features, phy_dev->features);
+	netdev_feature_and_bits(IPVLAN_FEATURES, dev->features);
+	netdev_feature_set_bits(IPVLAN_ALWAYS_ON, dev->features);
+	netdev_feature_copy(dev->vlan_features, phy_dev->vlan_features);
+	netdev_feature_and_bits(IPVLAN_FEATURES, dev->vlan_features);
+	netdev_feature_set_bits(IPVLAN_ALWAYS_ON_OFLOADS, dev->vlan_features);
+	netdev_feature_or(dev->hw_enc_features, dev->hw_enc_features,
 			  dev->features);
 	dev->gso_max_size = phy_dev->gso_max_size;
 	dev->gso_max_segs = phy_dev->gso_max_segs;
@@ -239,18 +239,18 @@ static netdev_tx_t ipvlan_start_xmit(struct sk_buff *skb,
 }
 
 static void ipvlan_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
-	netdev_feature_fill(&tmp);
-	netdev_feature_clear_bits(IPVLAN_FEATURES, &tmp);
-	netdev_feature_or(&tmp, tmp, ipvlan->sfeatures);
-	netdev_feature_and(features, *features, tmp);
+	netdev_feature_fill(tmp);
+	netdev_feature_clear_bits(IPVLAN_FEATURES, tmp);
+	netdev_feature_or(tmp, tmp, ipvlan->sfeatures);
+	netdev_feature_and(features, features, tmp);
 	netdev_increment_features(features, ipvlan->phy_dev->features,
-				  *features, *features);
+				  features, features);
 	netdev_feature_set_bits(IPVLAN_ALWAYS_ON, features);
 	netdev_feature_and_bits(IPVLAN_FEATURES | IPVLAN_ALWAYS_ON, features);
 }
@@ -574,8 +574,8 @@ int ipvlan_link_new(struct net *src_net, struct net_device *dev,
 
 	ipvlan->phy_dev = phy_dev;
 	ipvlan->dev = dev;
-	netdev_feature_zero(&ipvlan->sfeatures);
-	netdev_feature_set_bits(IPVLAN_FEATURES, &ipvlan->sfeatures);
+	netdev_feature_zero(ipvlan->sfeatures);
+	netdev_feature_set_bits(IPVLAN_FEATURES, ipvlan->sfeatures);
 	if (!tb[IFLA_MTU])
 		ipvlan_adjust_mtu(ipvlan, phy_dev);
 	INIT_LIST_HEAD(&ipvlan->addrs);
diff --git a/drivers/net/ipvlan/ipvtap.c b/drivers/net/ipvlan/ipvtap.c
index fd11ce806cc7..ffa3ca4aab91 100644
--- a/drivers/net/ipvlan/ipvtap.c
+++ b/drivers/net/ipvlan/ipvtap.c
@@ -70,7 +70,7 @@ static void ipvtap_update_features(struct tap_dev *tap,
 	struct ipvtap_dev *vlantap = container_of(tap, struct ipvtap_dev, tap);
 	struct ipvl_dev *vlan = &vlantap->vlan;
 
-	netdev_feature_copy(&vlan->sfeatures, features);
+	netdev_feature_copy(vlan->sfeatures, features);
 	netdev_update_features(vlan->dev);
 }
 
@@ -86,8 +86,8 @@ static int ipvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	netdev_feature_zero(&vlantap->tap.tap_features);
-	netdev_feature_set_bits(TUN_OFFLOADS, &vlantap->tap.tap_features);
+	netdev_feature_zero(vlantap->tap.tap_features);
+	netdev_feature_set_bits(TUN_OFFLOADS, vlantap->tap.tap_features);
 	vlantap->tap.count_tx_dropped = ipvtap_count_tx_dropped;
 	vlantap->tap.update_features =	ipvtap_update_features;
 	vlantap->tap.count_rx_dropped = ipvtap_count_rx_dropped;
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 23cad6442959..a84b49ce0d25 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -174,15 +174,15 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->flags		= IFF_LOOPBACK;
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
 	netif_keep_dst(dev);
-	netdev_feature_zero(&dev->hw_features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->hw_features);
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->hw_features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
 				NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM |
 				NETIF_F_RXCSUM | NETIF_F_SCTP_CRC |
 				NETIF_F_HIGHDMA | NETIF_F_LLTX |
 				NETIF_F_NETNS_LOCAL | NETIF_F_VLAN_CHALLENGED |
-				NETIF_F_LOOPBACK, &dev->hw_features);
+				NETIF_F_LOOPBACK, dev->hw_features);
 	dev->ethtool_ops	= eth_ops;
 	dev->header_ops		= hdr_ops;
 	dev->netdev_ops		= dev_ops;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 8693decea5e8..e761ebba8f40 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3441,15 +3441,15 @@ static int macsec_dev_init(struct net_device *dev)
 		 *   VLAN_FEATURES - they require additional ops
 		 *   HW_MACSEC - no reason to report it
 		 */
-		netdev_feature_copy(&dev->features, real_dev->features);
+		netdev_feature_copy(dev->features, real_dev->features);
 		netdev_feature_clear_bits(NETIF_F_VLAN_FEATURES |
 					  NETIF_F_HW_MACSEC,
-					  &dev->features);
+					  dev->features);
 	} else {
-		netdev_feature_copy(&dev->features, real_dev->features);
-		netdev_feature_and_bits(SW_MACSEC_FEATURES, &dev->features);
+		netdev_feature_copy(dev->features, real_dev->features);
+		netdev_feature_and_bits(SW_MACSEC_FEATURES, dev->features);
 		netdev_feature_set_bits(NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE,
-					&dev->features);
+					dev->features);
 	}
 
 	dev->needed_headroom = real_dev->needed_headroom +
@@ -3474,7 +3474,7 @@ static void macsec_dev_uninit(struct net_device *dev)
 }
 
 static void macsec_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
@@ -3487,11 +3487,11 @@ static void macsec_fix_features(struct net_device *dev,
 		return;
 	}
 
-	netdev_feature_copy(&tmp, real_dev->features);
-	netdev_feature_and_bits(SW_MACSEC_FEATURES, &tmp);
+	netdev_feature_copy(tmp, real_dev->features);
+	netdev_feature_and_bits(SW_MACSEC_FEATURES, tmp);
 	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES,
-				&tmp);
-	netdev_feature_and(features, *features, tmp);
+				tmp);
+	netdev_feature_and(features, features, tmp);
 	netdev_feature_set_bit(NETIF_F_LLTX_BIT, features);
 }
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d373b4557206..8502fd55a7b9 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -894,14 +894,14 @@ static int macvlan_init(struct net_device *dev)
 
 	dev->state		= (dev->state & ~MACVLAN_STATE_MASK) |
 				  (lowerdev->state & MACVLAN_STATE_MASK);
-	netdev_feature_copy(&dev->features, lowerdev->features);
-	netdev_feature_and_bits(MACVLAN_FEATURES, &dev->features);
-	netdev_feature_set_bits(ALWAYS_ON_FEATURES, &dev->features);
-	netdev_feature_set_bit(NETIF_F_LRO_BIT, &dev->hw_features);
-	netdev_feature_copy(&dev->vlan_features, lowerdev->vlan_features);
-	netdev_feature_and_bits(MACVLAN_FEATURES, &dev->vlan_features);
-	netdev_feature_set_bits(ALWAYS_ON_OFFLOADS, &dev->vlan_features);
-	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+	netdev_feature_copy(dev->features, lowerdev->features);
+	netdev_feature_and_bits(MACVLAN_FEATURES, dev->features);
+	netdev_feature_set_bits(ALWAYS_ON_FEATURES, dev->features);
+	netdev_feature_set_bit(NETIF_F_LRO_BIT, dev->hw_features);
+	netdev_feature_copy(dev->vlan_features, lowerdev->vlan_features);
+	netdev_feature_and_bits(MACVLAN_FEATURES, dev->vlan_features);
+	netdev_feature_set_bits(ALWAYS_ON_OFFLOADS, dev->vlan_features);
+	netdev_feature_or(dev->hw_enc_features, dev->hw_enc_features,
 			  dev->features);
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
@@ -1072,26 +1072,26 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 }
 
 static void macvlan_fix_features(struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(lowerdev_features);
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
-	netdev_feature_copy(&lowerdev_features, vlan->lowerdev->features);
+	netdev_feature_copy(lowerdev_features, vlan->lowerdev->features);
 	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
-	netdev_feature_fill(&tmp);
-	netdev_feature_clear_bits(MACVLAN_FEATURES, &tmp);
-	netdev_feature_or(&tmp, tmp, vlan->set_features);
-	netdev_feature_and(features, *features, tmp);
-	netdev_feature_copy(&mask, *features);
-
-	netdev_feature_fill(&tmp);
-	netdev_feature_clear_bit(NETIF_F_LRO_BIT, &tmp);
-	netdev_feature_or(&tmp, tmp, *features);
-	netdev_feature_and(&lowerdev_features, lowerdev_features, tmp);
-	netdev_increment_features(features, lowerdev_features, *features, mask);
+	netdev_feature_fill(tmp);
+	netdev_feature_clear_bits(MACVLAN_FEATURES, tmp);
+	netdev_feature_or(tmp, tmp, vlan->set_features);
+	netdev_feature_and(features, features, tmp);
+	netdev_feature_copy(mask, features);
+
+	netdev_feature_fill(tmp);
+	netdev_feature_clear_bit(NETIF_F_LRO_BIT, tmp);
+	netdev_feature_or(tmp, tmp, features);
+	netdev_feature_and(lowerdev_features, lowerdev_features, tmp);
+	netdev_increment_features(features, lowerdev_features, features, mask);
 	netdev_feature_set_bits(ALWAYS_ON_FEATURES, features);
 	netdev_feature_and_bits(ALWAYS_ON_FEATURES | MACVLAN_FEATURES,
 				features);
@@ -1471,8 +1471,8 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	vlan->lowerdev = lowerdev;
 	vlan->dev      = dev;
 	vlan->port     = port;
-	netdev_feature_zero(&vlan->set_features);
-	netdev_feature_set_bits(MACVLAN_FEATURES, &vlan->set_features);
+	netdev_feature_zero(vlan->set_features);
+	netdev_feature_set_bits(MACVLAN_FEATURES, vlan->set_features);
 
 	vlan->mode     = MACVLAN_MODE_VEPA;
 	if (data && data[IFLA_MACVLAN_MODE])
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 2162080133bb..8b605fec86a4 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -74,7 +74,7 @@ static void macvtap_update_features(struct tap_dev *tap,
 	struct macvtap_dev *vlantap = container_of(tap, struct macvtap_dev, tap);
 	struct macvlan_dev *vlan = &vlantap->vlan;
 
-	netdev_feature_copy(&vlan->set_features, features);
+	netdev_feature_copy(vlan->set_features, features);
 	netdev_update_features(vlan->dev);
 }
 
@@ -90,8 +90,8 @@ static int macvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	netdev_feature_zero(&vlantap->tap.tap_features);
-	netdev_feature_set_bits(TUN_OFFLOADS, &vlantap->tap.tap_features);
+	netdev_feature_zero(vlantap->tap.tap_features);
+	netdev_feature_set_bits(TUN_OFFLOADS, vlantap->tap.tap_features);
 
 	/* Register callbacks for rx/tx drops accounting and updating
 	 * net_device features
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 16375fb5c958..09cf24614b92 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -389,21 +389,21 @@ static void net_failover_compute_features(struct net_device *dev)
 	__DECLARE_NETDEV_FEATURE_MASK(vlan_mask);
 	__DECLARE_NETDEV_FEATURE_MASK(enc_mask);
 
-	netdev_feature_zero(&vlan_features);
+	netdev_feature_zero(vlan_features);
 	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES & NETIF_F_ALL_FOR_ALL,
-				&vlan_features);
-	netdev_feature_zero(&enc_features);
-	netdev_feature_set_bits(FAILOVER_ENC_FEATURES, &enc_features);
-	netdev_feature_zero(&vlan_mask);
-	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES, &vlan_mask);
-	netdev_feature_copy(&enc_mask, enc_features);
+				vlan_features);
+	netdev_feature_zero(enc_features);
+	netdev_feature_set_bits(FAILOVER_ENC_FEATURES, enc_features);
+	netdev_feature_zero(vlan_mask);
+	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES, vlan_mask);
+	netdev_feature_copy(enc_mask, enc_features);
 
 	primary_dev = rcu_dereference(nfo_info->primary_dev);
 	if (primary_dev) {
-		netdev_increment_features(&vlan_features, vlan_features,
+		netdev_increment_features(vlan_features, vlan_features,
 					  primary_dev->vlan_features,
 					  vlan_mask);
-		netdev_increment_features(&enc_features, enc_features,
+		netdev_increment_features(enc_features, enc_features,
 					  primary_dev->hw_enc_features,
 					  enc_features);
 
@@ -414,10 +414,10 @@ static void net_failover_compute_features(struct net_device *dev)
 
 	standby_dev = rcu_dereference(nfo_info->standby_dev);
 	if (standby_dev) {
-		netdev_increment_features(&vlan_features, vlan_features,
+		netdev_increment_features(vlan_features, vlan_features,
 					  standby_dev->vlan_features,
 					  vlan_mask);
-		netdev_increment_features(&enc_features, enc_features,
+		netdev_increment_features(enc_features, enc_features,
 					  standby_dev->hw_enc_features,
 					  enc_features);
 
@@ -426,9 +426,9 @@ static void net_failover_compute_features(struct net_device *dev)
 			max_hard_header_len = standby_dev->hard_header_len;
 	}
 
-	netdev_feature_copy(&dev->vlan_features, vlan_features);
-	netdev_feature_copy(&dev->hw_enc_features, enc_features);
-	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &dev->hw_enc_features);
+	netdev_feature_copy(dev->vlan_features, vlan_features);
+	netdev_feature_copy(dev->hw_enc_features, enc_features);
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, dev->hw_enc_features);
 	dev->hard_header_len = max_hard_header_len;
 
 	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -743,22 +743,22 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 				       IFF_TX_SKB_SHARING);
 
 	/* don't acquire failover netdev's netif_tx_lock when transmitting */
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &failover_dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, failover_dev->features);
 
 	/* Don't allow failover devices to change network namespaces. */
 	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-			       &failover_dev->features);
+			       failover_dev->features);
 
-	netdev_feature_zero(&failover_dev->hw_features);
+	netdev_feature_zero(failover_dev->hw_features);
 	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&failover_dev->hw_features);
+				failover_dev->hw_features);
 
 	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL,
-				&failover_dev->hw_features);
-	netdev_feature_or(&failover_dev->features, failover_dev->features,
+				failover_dev->hw_features);
+	netdev_feature_or(failover_dev->features, failover_dev->features,
 			  failover_dev->hw_features);
 
 	memcpy(failover_dev->dev_addr, standby_dev->dev_addr,
diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index 3b77c376e34f..8f30c9d11ed0 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -280,8 +280,8 @@ void nsim_ipsec_init(struct netdevsim *ns)
 				 NETIF_F_HW_ESP_TX_CSUM | \
 				 NETIF_F_GSO_ESP)
 
-	netdev_feature_set_bits(NSIM_ESP_FEATURES, &ns->netdev->features);
-	netdev_feature_set_bits(NSIM_ESP_FEATURES, &ns->netdev->hw_enc_features);
+	netdev_feature_set_bits(NSIM_ESP_FEATURES, ns->netdev->features);
+	netdev_feature_set_bits(NSIM_ESP_FEATURES, ns->netdev->hw_enc_features);
 
 	ns->ipsec.pfile = debugfs_create_file("ipsec", 0400,
 					      ns->nsim_dev_port->ddir, ns,
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 895b5487bbee..3186286e8c40 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -293,8 +293,8 @@ static void nsim_setup(struct net_device *dev)
 				NETIF_F_SG |
 				NETIF_F_FRAGLIST |
 				NETIF_F_HW_CSUM |
-				NETIF_F_TSO, &dev->features);
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &dev->hw_features);
+				NETIF_F_TSO, dev->features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, dev->hw_features);
 	dev->max_mtu = ETH_MAX_MTU;
 }
 
diff --git a/drivers/net/nlmon.c b/drivers/net/nlmon.c
index 66af97852b76..bfacc43505bd 100644
--- a/drivers/net/nlmon.c
+++ b/drivers/net/nlmon.c
@@ -89,9 +89,9 @@ static void nlmon_setup(struct net_device *dev)
 	dev->ethtool_ops = &nlmon_ethtool_ops;
 	dev->needs_free_netdev = true;
 
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
-				NETIF_F_HIGHDMA | NETIF_F_LLTX, &dev->features);
+				NETIF_F_HIGHDMA | NETIF_F_LLTX, dev->features);
 	dev->flags = IFF_NOARP;
 
 	/* That's rather a softlimit here, which, of course,
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index aaaf118e778f..a7f2039e6cbd 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -420,12 +420,12 @@ static int ntb_netdev_probe(struct device *client_dev)
 	dev = netdev_priv(ndev);
 	dev->ndev = ndev;
 	dev->pdev = pdev;
-	netdev_feature_zero(&ndev->features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+	netdev_feature_zero(ndev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev_feature_copy(&ndev->hw_features, ndev->features);
+	netdev_feature_copy(ndev->hw_features, ndev->features);
 	ndev->watchdog_timeo = msecs_to_jiffies(NTB_TX_TIMEOUT_MS);
 
 	eth_random_addr(ndev->perm_addr);
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index d1bc1f10ddb7..8bbb5fce7c02 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1610,7 +1610,7 @@ static void ppp_setup(struct net_device *dev)
 	dev->netdev_ops = &ppp_netdev_ops;
 	SET_NETDEV_DEVTYPE(dev, &ppp_type);
 
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 
 	dev->hard_header_len = PPP_HDRLEN;
 	dev->mtu = PPP_MRU;
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index eac3e882cf5a..4e86ed1735e9 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -513,8 +513,8 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 	/* MTU range: 68 - 4082 */
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = RIONET_MAX_MTU;
-	netdev_feature_zero(&ndev->features);
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &ndev->features);
+	netdev_feature_zero(ndev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, ndev->features);
 	SET_NETDEV_DEV(ndev, &mport->dev);
 	ndev->ethtool_ops = &rionet_ethtool_ops;
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 49da4d101517..80012b78bfcb 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -323,8 +323,8 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct tap_dev *tap;
 	struct tap_queue *q;
 
-	netdev_feature_zero(&features);
-	netdev_feature_set_bits(TAP_FEATURES, &features);
+	netdev_feature_zero(features);
+	netdev_feature_set_bits(TAP_FEATURES, features);
 
 	tap = tap_dev_get_rcu(dev);
 	if (!tap)
@@ -341,7 +341,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	 * enabled.
 	 */
 	if (q->flags & IFF_VNET_HDR)
-		netdev_feature_or(&features, features, tap->tap_features);
+		netdev_feature_or(features, features, tap->tap_features);
 	if (netif_needs_gso(skb, features)) {
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
@@ -931,22 +931,22 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	if (!tap)
 		return -ENOLINK;
 
-	netdev_feature_zero(&feature_mask);
-	netdev_feature_copy(&features, tap->dev->features);
+	netdev_feature_zero(feature_mask);
+	netdev_feature_copy(features, tap->dev->features);
 
 	if (arg & TUN_F_CSUM) {
-		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &feature_mask);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, feature_mask);
 
 		if (arg & (TUN_F_TSO4 | TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN)
 				netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
-						       &feature_mask);
+						       feature_mask);
 			if (arg & TUN_F_TSO4)
 				netdev_feature_set_bit(NETIF_F_TSO_BIT,
-						       &feature_mask);
+						       feature_mask);
 			if (arg & TUN_F_TSO6)
 				netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-						       &feature_mask);
+						       feature_mask);
 		}
 	}
 
@@ -959,14 +959,14 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * user-space will not receive TSO frames.
 	 */
 	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6, feature_mask))
-		netdev_feature_set_bits(RX_OFFLOADS, &features);
+		netdev_feature_set_bits(RX_OFFLOADS, features);
 	else
-		netdev_feature_clear_bits(RX_OFFLOADS, &features);
+		netdev_feature_clear_bits(RX_OFFLOADS, features);
 
 	/* tap_features are the same as features on tun/tap and
 	 * reflect user expectations.
 	 */
-	netdev_feature_copy(&tap->tap_features, feature_mask);
+	netdev_feature_copy(tap->tap_features, feature_mask);
 	if (tap->update_features)
 		tap->update_features(tap, features);
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 79171c8c7379..79413ebb9644 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -993,21 +993,21 @@ static void __team_compute_features(struct team *team)
 	__DECLARE_NETDEV_FEATURE_MASK(mask_vlan);
 	__DECLARE_NETDEV_FEATURE_MASK(mask_enc);
 
-	netdev_feature_zero(&vlan_features);
+	netdev_feature_zero(vlan_features);
 	netdev_feature_set_bits(TEAM_VLAN_FEATURES & NETIF_F_ALL_FOR_ALL,
-				&vlan_features);
-	netdev_feature_zero(&enc_features);
-	netdev_feature_set_bits(TEAM_ENC_FEATURES, &enc_features);
-	netdev_feature_zero(&mask_vlan);
-	netdev_feature_set_bits(TEAM_VLAN_FEATURES, &mask_vlan);
-	netdev_feature_zero(&mask_enc);
-	netdev_feature_set_bits(TEAM_ENC_FEATURES, &mask_enc);
+				vlan_features);
+	netdev_feature_zero(enc_features);
+	netdev_feature_set_bits(TEAM_ENC_FEATURES, enc_features);
+	netdev_feature_zero(mask_vlan);
+	netdev_feature_set_bits(TEAM_VLAN_FEATURES, mask_vlan);
+	netdev_feature_zero(mask_enc);
+	netdev_feature_set_bits(TEAM_ENC_FEATURES, mask_enc);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		netdev_increment_features(&vlan_features, vlan_features,
+		netdev_increment_features(vlan_features, vlan_features,
 					  port->dev->vlan_features, mask_vlan);
-		netdev_increment_features(&enc_features, enc_features,
+		netdev_increment_features(enc_features, enc_features,
 					  port->dev->hw_enc_features, mask_enc);
 
 		dst_release_flag &= port->dev->priv_flags;
@@ -1016,12 +1016,12 @@ static void __team_compute_features(struct team *team)
 	}
 	rcu_read_unlock();
 
-	netdev_feature_copy(&team->dev->vlan_features, vlan_features);
-	netdev_feature_copy(&team->dev->hw_enc_features, enc_features);
+	netdev_feature_copy(team->dev->vlan_features, vlan_features);
+	netdev_feature_copy(team->dev->hw_enc_features, enc_features);
 	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX,
-				&team->dev->hw_enc_features);
+				team->dev->hw_enc_features);
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2006,19 +2006,19 @@ static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 }
 
 static void team_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	struct team_port *port;
 	struct team *team = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(mask);
 
-	netdev_feature_copy(&mask, *features);
+	netdev_feature_copy(mask, features);
 	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
 	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		netdev_increment_features(features, *features,
+		netdev_increment_features(features, features,
 					  port->dev->features, mask);
 	}
 	rcu_read_unlock();
@@ -2172,22 +2172,22 @@ static void team_setup(struct net_device *dev)
 	 */
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
 
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
-	netdev_feature_set_bit(NETIF_F_GRO_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
+	netdev_feature_set_bit(NETIF_F_GRO_BIT, dev->features);
 
 	/* Don't allow team devices to change network namespaces. */
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features);
 
 	netdev_feature_set_bits(TEAM_VLAN_FEATURES |
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&dev->hw_features);
+				dev->hw_features);
 
-	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &dev->hw_features);
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, dev->hw_features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX,
-				&dev->features);
+				dev->features);
 }
 
 static int team_newlink(struct net *src_net, struct net_device *dev,
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 0fd4cd06fa6b..f3b06408788f 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1257,12 +1257,12 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	 * we need to announce support for most of the offloading
 	 * features here.
 	 */
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_ALL_TSO | NETIF_F_GRO |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				&dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+				dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 66c566291b16..c80826edf193 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1080,14 +1080,14 @@ static void tun_net_mclist(struct net_device *dev)
 }
 
 static void tun_net_fix_features(struct net_device *dev,
-				 netdev_features_t *features)
+				 netdev_features_t features)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
-	netdev_feature_and(&tmp, *features, tun->set_features);
+	netdev_feature_and(tmp, features, tun->set_features);
 	netdev_feature_clear_bits(TUN_USER_FEATURES, features);
-	netdev_feature_or(features, *features, tmp);
+	netdev_feature_or(features, features, tmp);
 }
 
 static void tun_set_headroom(struct net_device *dev, int new_hr)
@@ -2729,18 +2729,18 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun_net_init(dev);
 		tun_flow_init(tun);
 
-		netdev_feature_zero(&dev->hw_features);
+		netdev_feature_zero(dev->hw_features);
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
 					TUN_USER_FEATURES |
 					NETIF_F_HW_VLAN_CTAG_TX |
 					NETIF_F_HW_VLAN_STAG_TX,
-					&dev->hw_features);
-		netdev_feature_copy(&dev->features, dev->hw_features);
-		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
-		netdev_feature_copy(&dev->vlan_features, dev->features);
+					dev->hw_features);
+		netdev_feature_copy(dev->features, dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
+		netdev_feature_copy(dev->vlan_features, dev->features);
 		netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
 					  NETIF_F_HW_VLAN_STAG_TX,
-					  &dev->vlan_features);
+					  dev->vlan_features);
 
 		tun->flags = (tun->flags & ~TUN_FEATURES) |
 			      (ifr->ifr_flags & TUN_FEATURES);
@@ -2804,24 +2804,24 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(features);
 
-	netdev_feature_zero(&features);
+	netdev_feature_zero(features);
 
 	if (arg & TUN_F_CSUM) {
-		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, features);
 		arg &= ~TUN_F_CSUM;
 
 		if (arg & (TUN_F_TSO4|TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN) {
 				netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
-						       &features);
+						       features);
 				arg &= ~TUN_F_TSO_ECN;
 			}
 			if (arg & TUN_F_TSO4)
 				netdev_feature_set_bit(NETIF_F_TSO_BIT,
-						       &features);
+						       features);
 			if (arg & TUN_F_TSO6)
 				netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-						       &features);
+						       features);
 			arg &= ~(TUN_F_TSO4|TUN_F_TSO6);
 		}
 
@@ -2833,10 +2833,10 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 	if (arg)
 		return -EINVAL;
 
-	netdev_feature_copy(&tun->set_features, features);
+	netdev_feature_copy(tun->set_features, features);
 	netdev_feature_clear_bits(TUN_USER_FEATURES,
-				  &tun->dev->wanted_features);
-	netdev_feature_or(&tun->dev->wanted_features,
+				  tun->dev->wanted_features);
+	netdev_feature_or(tun->dev->wanted_features,
 			  tun->dev->wanted_features, features);
 	netdev_update_features(tun->dev);
 
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 45305d74692e..25282e83e866 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -571,7 +571,7 @@ static int aqc111_set_features(struct net_device *net,
 	u16 reg16 = 0;
 	u8 reg8 = 0;
 
-	netdev_feature_xor(&changed, net->features, features);
+	netdev_feature_xor(changed, net->features, features);
 	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
 		reg8 ^= SFR_TXCOE_TCP | SFR_TXCOE_UDP;
@@ -733,10 +733,10 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (usb_device_no_sg_constraint(dev->udev))
 		dev->can_dma_sg = 1;
 
-	netdev_feature_set_bits(AQ_SUPPORT_HW_FEATURE, &dev->net->hw_features);
-	netdev_feature_set_bits(AQ_SUPPORT_FEATURE, &dev->net->features);
+	netdev_feature_set_bits(AQ_SUPPORT_HW_FEATURE, dev->net->hw_features);
+	netdev_feature_set_bits(AQ_SUPPORT_FEATURE, dev->net->features);
 	netdev_feature_set_bits(AQ_SUPPORT_VLAN_FEATURE,
-				&dev->net->vlan_features);
+				dev->net->vlan_features);
 
 	netif_set_gso_max_size(dev->net, 65535);
 
@@ -1000,10 +1000,10 @@ static int aqc111_reset(struct usbnet *dev)
 	if (usb_device_no_sg_constraint(dev->udev))
 		dev->can_dma_sg = 1;
 
-	netdev_feature_set_bits(AQ_SUPPORT_HW_FEATURE, &dev->net->hw_features);
-	netdev_feature_set_bits(AQ_SUPPORT_FEATURE, &dev->net->features);
+	netdev_feature_set_bits(AQ_SUPPORT_HW_FEATURE, dev->net->hw_features);
+	netdev_feature_set_bits(AQ_SUPPORT_FEATURE, dev->net->features);
 	netdev_feature_set_bits(AQ_SUPPORT_VLAN_FEATURE,
-				&dev->net->vlan_features);
+				dev->net->vlan_features);
 
 	/* Power up ethernet PHY */
 	aqc111_data->phy_cfg = AQ_PHY_POWER_EN;
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index b11b4bba443e..1dc377dcd1bd 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -954,7 +954,7 @@ ax88179_set_features(struct net_device *net, netdev_features_t features)
 	struct usbnet *dev = netdev_priv(net);
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
-	netdev_feature_xor(&changed, net->features, features);
+	netdev_feature_xor(changed, net->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
@@ -1380,10 +1380,10 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.supports_gmii = 1;
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_RXCSUM, &dev->net->features);
+				NETIF_F_RXCSUM, dev->net->features);
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM, &dev->net->hw_features);
+				 NETIF_F_RXCSUM, dev->net->hw_features);
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
@@ -1667,10 +1667,10 @@ static int ax88179_reset(struct usbnet *dev)
 			  1, 1, tmp);
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				NETIF_F_RXCSUM, &dev->net->features);
+				NETIF_F_RXCSUM, dev->net->features);
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM, &dev->net->hw_features);
+				 NETIF_F_RXCSUM, dev->net->hw_features);
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index a65be627dc03..7fb5ccb6a888 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -275,7 +275,7 @@ static const struct net_device_ops usbpn_ops = {
 
 static void usbpn_setup(struct net_device *dev)
 {
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	dev->netdev_ops		= &usbpn_ops;
 	dev->header_ops		= &phonet_header_ops;
 	dev->type		= ARPHRD_PHONET;
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 964e5260364a..67c280e5fe36 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -186,7 +186,7 @@ static int cdc_mbim_bind(struct usbnet *dev, struct usb_interface *intf)
 	/* no need to put the VLAN tci in the packet headers */
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_FILTER,
-				&dev->net->features);
+				dev->net->features);
 
 	/* monitor VLAN additions and removals */
 	dev->net->netdev_ops = &cdc_mbim_netdev_ops;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index aad719ebf318..b17da35f5cb0 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3250,28 +3250,28 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 
 	INIT_WORK(&pdata->set_vlan, lan78xx_deferred_vlan_write);
 
-	netdev_feature_zero(&dev->net->features);
+	netdev_feature_zero(dev->net->features);
 
 	if (DEFAULT_TX_CSUM_ENABLE)
 		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
-				       &dev->net->features);
+				       dev->net->features);
 
 	if (DEFAULT_RX_CSUM_ENABLE)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->net->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->net->features);
 
 	if (DEFAULT_TSO_CSUM_ENABLE)
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_SG,
-					&dev->net->features);
+					dev->net->features);
 
 	if (DEFAULT_VLAN_RX_OFFLOAD)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-				       &dev->net->features);
+				       dev->net->features);
 
 	if (DEFAULT_VLAN_FILTER_ENABLE)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &dev->net->features);
+				       dev->net->features);
 
-	netdev_feature_copy(&dev->net->hw_features, dev->net->features);
+	netdev_feature_copy(dev->net->hw_features, dev->net->features);
 
 	ret = lan78xx_setup_irq_domain(dev);
 	if (ret < 0) {
@@ -3984,7 +3984,7 @@ static void lan78xx_tx_timeout(struct net_device *net, unsigned int txqueue)
 
 static void lan78xx_features_check(struct sk_buff *skb,
 				   struct net_device *netdev,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
 		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 61d2175c63d7..5f130a5ccf82 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2096,9 +2096,9 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
 
-		netdev_feature_copy(&features, tp->netdev->features);
+		netdev_feature_copy(features, tp->netdev->features);
 		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_IPV6_CSUM |
-					  NETIF_F_TSO6, &features);
+					  NETIF_F_TSO6, features);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR(segs) || !segs)
 			goto drop;
@@ -2744,7 +2744,7 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 }
 
 static void rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
 	int max_offset = mss ? GTTCPHO_MAX : TCPHO_MAX;
@@ -3241,7 +3241,7 @@ static int rtl8152_set_features(struct net_device *dev,
 	if (ret < 0)
 		goto out;
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 
 	mutex_lock(&tp->control);
 
@@ -9583,23 +9583,23 @@ static int rtl8152_probe(struct usb_interface *intf,
 				NETIF_F_TSO | NETIF_F_FRAGLIST |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
 				NETIF_F_HW_VLAN_CTAG_RX |
-				NETIF_F_HW_VLAN_CTAG_TX, &netdev->features);
-	netdev_feature_zero(&netdev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_TX, netdev->features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
 				NETIF_F_TSO | NETIF_F_FRAGLIST |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
 				NETIF_F_HW_VLAN_CTAG_RX |
-				NETIF_F_HW_VLAN_CTAG_TX, &netdev->hw_features);
-	netdev_feature_zero(&netdev->vlan_features);
+				NETIF_F_HW_VLAN_CTAG_TX, netdev->hw_features);
+	netdev_feature_zero(netdev->vlan_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 				NETIF_F_HIGHDMA | NETIF_F_FRAGLIST |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO6,
-				&netdev->vlan_features);
+				netdev->vlan_features);
 
 	if (tp->version == RTL_VER_01) {
-		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, &netdev->features);
+		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT, netdev->features);
 		netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
-					 &netdev->hw_features);
+					 netdev->hw_features);
 	}
 
 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 87ad30084d2b..cb4d880708cc 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1473,14 +1473,14 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	if (DEFAULT_TX_CSUM_ENABLE)
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-					&dev->net->features);
+					dev->net->features);
 
 	if (DEFAULT_RX_CSUM_ENABLE)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->net->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->net->features);
 
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_RXCSUM,
-				&dev->net->hw_features);
+				dev->net->hw_features);
 
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 1bedb67af06f..bec3b6be3701 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1081,13 +1081,13 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	 */
 	if (DEFAULT_TX_CSUM_ENABLE)
 		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-				       &dev->net->features);
+				       dev->net->features);
 	if (DEFAULT_RX_CSUM_ENABLE)
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->net->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->net->features);
 
-	netdev_feature_zero(&dev->net->hw_features);
+	netdev_feature_zero(dev->net->hw_features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
-				&dev->net->hw_features);
+				dev->net->hw_features);
 	set_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 
 	smsc95xx_init_mac_address(dev);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 6603dcaf4c84..c85a49c69c16 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1077,7 +1077,7 @@ static int veth_enable_xdp(struct net_device *dev)
 				 * is supposed to get GRO working
 				 */
 				netdev_feature_set_bit(NETIF_F_GRO_BIT,
-						       &dev->features);
+						       dev->features);
 				netdev_features_change(dev);
 			}
 		}
@@ -1107,7 +1107,7 @@ static void veth_disable_xdp(struct net_device *dev)
 		 */
 		if (!veth_gro_requested(dev) && netif_running(dev)) {
 			netdev_feature_clear_bit(NETIF_F_GRO_BIT,
-						 &dev->features);
+						 dev->features);
 			netdev_features_change(dev);
 		}
 	}
@@ -1386,7 +1386,7 @@ static int veth_get_iflink(const struct net_device *dev)
 }
 
 static void veth_fix_features(struct net_device *dev,
-			      netdev_features_t *features)
+			      netdev_features_t features)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
@@ -1410,7 +1410,7 @@ static int veth_set_features(struct net_device *dev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err;
 
-	netdev_feature_xor(&changed, features, dev->features);
+	netdev_feature_xor(changed, features, dev->features);
 
 	if (!netdev_feature_test_bit(NETIF_F_GRO_BIT, changed) ||
 	    !(dev->flags & IFF_UP) || priv->_xdp_prog)
@@ -1494,7 +1494,7 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 		if (!old_prog) {
 			netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
-						  &peer->hw_features);
+						  peer->hw_features);
 			peer->max_mtu = max_mtu;
 		}
 	}
@@ -1506,7 +1506,7 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 			if (peer) {
 				netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-							&peer->hw_features);
+							peer->hw_features);
 				peer->max_mtu = ETH_MAX_MTU;
 			}
 		}
@@ -1571,24 +1571,24 @@ static void veth_setup(struct net_device *dev)
 
 	dev->netdev_ops = &veth_netdev_ops;
 	dev->ethtool_ops = &veth_ethtool_ops;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
-	netdev_feature_set_bits(VETH_FEATURES, &dev->features);
-	netdev_feature_copy(&dev->vlan_features, dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
+	netdev_feature_set_bits(VETH_FEATURES, dev->features);
+	netdev_feature_copy(dev->vlan_features, dev->features);
 	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				  NETIF_F_HW_VLAN_STAG_TX |
 				  NETIF_F_HW_VLAN_CTAG_RX |
 				  NETIF_F_HW_VLAN_STAG_RX,
-				  &dev->vlan_features);
+				  dev->vlan_features);
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	netdev_feature_zero(&dev->hw_features);
-	netdev_feature_set_bits(VETH_FEATURES, &dev->hw_features);
-	netdev_feature_copy(&dev->hw_enc_features, dev->hw_features);
-	netdev_feature_zero(&dev->mpls_features);
+	netdev_feature_zero(dev->hw_features);
+	netdev_feature_set_bits(VETH_FEATURES, dev->hw_features);
+	netdev_feature_copy(dev->hw_enc_features, dev->hw_features);
+	netdev_feature_zero(dev->mpls_features);
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE,
-				&dev->mpls_features);
+				dev->mpls_features);
 }
 
 /*
@@ -1615,8 +1615,8 @@ static struct rtnl_link_ops veth_link_ops;
 
 static void veth_disable_gro(struct net_device *dev)
 {
-	netdev_feature_clear_bit(NETIF_F_GRO_BIT, &dev->features);
-	netdev_feature_clear_bit(NETIF_F_GRO_BIT, &dev->wanted_features);
+	netdev_feature_clear_bit(NETIF_F_GRO_BIT, dev->features);
+	netdev_feature_clear_bit(NETIF_F_GRO_BIT, dev->wanted_features);
 	netdev_update_features(dev);
 }
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 96dc985a3fb0..e709334b77e4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2909,7 +2909,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		vi->cvq = vqs[total_vqs - 1];
 		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					       &vi->dev->features);
+					       vi->dev->features);
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -3120,8 +3120,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
 			   IFF_TX_SKB_NO_LINEAR;
 	dev->netdev_ops = &virtnet_netdev;
-	netdev_feature_zero(&dev->features);
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->features);
+	netdev_feature_zero(dev->features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->features);
 
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
@@ -3130,47 +3130,47 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
 		/* This opens up the world of extra features. */
 		netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG,
-					&dev->hw_features);
+					dev->hw_features);
 		if (csum)
 			netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG,
-						&dev->features);
+						dev->features);
 
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
 			netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO_ECN |
 						NETIF_F_TSO6,
-						&dev->hw_features);
+						dev->hw_features);
 		}
 		/* Individual feature bits: what can host handle? */
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO4))
 			netdev_feature_set_bit(NETIF_F_TSO_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO6))
 			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
 			netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT,
-					       &dev->hw_features);
+					       dev->hw_features);
 
-		netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, dev->features);
 
 		if (gso) {
 			__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
-			netdev_feature_copy(&tmp, dev->hw_features);
-			netdev_feature_and_bits(NETIF_F_ALL_TSO, &tmp);
-			netdev_feature_or(&dev->features, dev->features, tmp);
+			netdev_feature_copy(tmp, dev->hw_features);
+			netdev_feature_and_bits(NETIF_F_ALL_TSO, tmp);
+			netdev_feature_or(dev->features, dev->features, tmp);
 		}
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
-		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, dev->features);
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
-		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, &dev->hw_features);
+		netdev_feature_set_bit(NETIF_F_GRO_HW_BIT, dev->hw_features);
 
-	netdev_feature_copy(&dev->vlan_features, dev->features);
+	netdev_feature_copy(dev->vlan_features, dev->features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = MIN_MTU;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 06acbad37a6d..e3abfdc4a24b 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3172,19 +3172,19 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool dma64)
 {
 	struct net_device *netdev = adapter->netdev;
 
-	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
 				NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO |
 				NETIF_F_TSO6 | NETIF_F_LRO,
-				&netdev->hw_features);
+				netdev->hw_features);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&netdev->hw_features);
+					netdev->hw_features);
 
-		netdev_feature_zero(&netdev->hw_enc_features);
+		netdev_feature_zero(netdev->hw_enc_features);
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM |
 					NETIF_F_HW_CSUM |
 					NETIF_F_HW_VLAN_CTAG_TX |
@@ -3192,19 +3192,19 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool dma64)
 					NETIF_F_TSO | NETIF_F_TSO6 |
 					NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&netdev->hw_enc_features);
+					netdev->hw_enc_features);
 	}
 
 	if (dma64)
 		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
-				       &netdev->hw_features);
-	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
+				       netdev->hw_features);
+	netdev_feature_copy(netdev->vlan_features, netdev->hw_features);
 	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				  NETIF_F_HW_VLAN_CTAG_RX,
-				  &netdev->vlan_features);
-	netdev_feature_copy(&netdev->features, netdev->hw_features);
+				  netdev->vlan_features);
+	netdev_feature_copy(netdev->features, netdev->hw_features);
 	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-			       &netdev->features);
+			       netdev->features);
 }
 
 
@@ -3650,8 +3650,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	    adapter->intr.type == VMXNET3_IT_MSIX) {
 		adapter->rss = true;
 		netdev_feature_set_bit(NETIF_F_RXHASH_BIT,
-				       &netdev->hw_features);
-		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, &netdev->features);
+				       netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, netdev->features);
 		dev_dbg(&pdev->dev, "RSS is enabled.\n");
 	} else {
 		adapter->rss = false;
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index e9035e80d5ae..c72d7efdb8d7 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -247,15 +247,15 @@ vmxnet3_get_strings(struct net_device *netdev, u32 stringset, u8 *buf)
 }
 
 void vmxnet3_fix_features(struct net_device *netdev,
-			  netdev_features_t *features)
+			  netdev_features_t features)
 {
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 }
 
 void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
-			    netdev_features_t *features)
+			    netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -315,7 +315,7 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
 					NETIF_F_TSO | NETIF_F_TSO6 |
 					NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
 					NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					&netdev->hw_enc_features);
+					netdev->hw_enc_features);
 	}
 }
 
@@ -331,7 +331,7 @@ static void vmxnet3_disable_encap_offloads(struct net_device *netdev)
 					  NETIF_F_TSO | NETIF_F_TSO6 |
 					  NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
 					  NETIF_F_GSO_UDP_TUNNEL_CSUM,
-					  &netdev->hw_enc_features);
+					  netdev->hw_enc_features);
 	}
 }
 
@@ -344,7 +344,7 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	unsigned long flags;
 	u8 udp_tun_enabled;
 
-	netdev_feature_xor(&changed, netdev->features, features);
+	netdev_feature_xor(changed, netdev->features, features);
 	udp_tun_enabled = netdev_feature_test_bits(tun_offload_mask,
 						   netdev->features);
 	if (netdev_feature_test_bits(NETIF_F_RXCSUM | NETIF_F_LRO |
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index aed4e1bf9298..a64b0498eaae 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -476,11 +476,11 @@ void
 vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 
 void
-vmxnet3_fix_features(struct net_device *netdev, netdev_features_t *features);
+vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
 
 void
 vmxnet3_features_check(struct sk_buff *skb,
-		       struct net_device *netdev, netdev_features_t *features);
+		       struct net_device *netdev, netdev_features_t features);
 
 int
 vmxnet3_set_features(struct net_device *netdev, netdev_features_t features);
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index aee9e0fa0842..f2c4f229558e 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1653,23 +1653,23 @@ static void vrf_setup(struct net_device *dev)
 	eth_hw_addr_random(dev);
 
 	/* don't acquire vrf device's netif_tx_lock when transmitting */
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 
 	/* don't allow vrf devices to change network namespaces. */
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features);
 
 	/* does not make sense for a VLAN to be added to a vrf device */
-	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, dev->features);
 
 	/* enable offload features */
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->features);
 	netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CRC,
-				&dev->features);
+				dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA,
-				&dev->features);
+				dev->features);
 
-	netdev_feature_copy(&dev->hw_features, dev->features);
-	netdev_feature_copy(&dev->hw_enc_features, dev->features);
+	netdev_feature_copy(dev->hw_features, dev->features);
+	netdev_feature_copy(dev->hw_enc_features, dev->features);
 
 	/* default to no qdisc; user can add if desired */
 	dev->priv_flags |= IFF_NO_QUEUE;
diff --git a/drivers/net/vsockmon.c b/drivers/net/vsockmon.c
index 047d04115fd9..b6013e2e65e6 100644
--- a/drivers/net/vsockmon.c
+++ b/drivers/net/vsockmon.c
@@ -106,10 +106,10 @@ static void vsockmon_setup(struct net_device *dev)
 	dev->ethtool_ops = &vsockmon_ethtool_ops;
 	dev->needs_free_netdev = true;
 
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
 				NETIF_F_HIGHDMA | NETIF_F_LLTX,
-				&dev->features);
+				dev->features);
 
 	dev->flags = IFF_NOARP;
 
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 1978dfc71056..b3e656044a7f 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3294,17 +3294,17 @@ static void vxlan_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	SET_NETDEV_DEVTYPE(dev, &vxlan_type);
 
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
-				&dev->features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+				dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->features);
 
-	netdev_feature_copy(&dev->vlan_features, dev->features);
+	netdev_feature_copy(dev->vlan_features, dev->features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
-				&dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
-	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->hw_features);
+				dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, dev->hw_features);
 
 	netif_keep_dst(dev);
 	dev->priv_flags |= IFF_NO_QUEUE;
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 9c58f5208909..b689592f0cf1 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -271,10 +271,10 @@ static void wg_setup(struct net_device *dev)
 	dev->type = ARPHRD_NONE;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 	dev->priv_flags |= IFF_NO_QUEUE;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
-	netdev_feature_set_bits(WG_NETDEV_FEATURES, &dev->features);
-	netdev_feature_set_bits(WG_NETDEV_FEATURES, &dev->hw_features);
-	netdev_feature_set_bits(WG_NETDEV_FEATURES, &dev->hw_enc_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
+	netdev_feature_set_bits(WG_NETDEV_FEATURES, dev->features);
+	netdev_feature_set_bits(WG_NETDEV_FEATURES, dev->hw_features);
+	netdev_feature_set_bits(WG_NETDEV_FEATURES, dev->hw_enc_features);
 	dev->mtu = ETH_DATA_LEN - overhead;
 	dev->max_mtu = round_down(INT_MAX, MESSAGE_PADDING_MULTIPLE) - overhead;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 493d15f4d4e9..6875cc89523f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -10120,9 +10120,9 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->sar_capa = &ath10k_sar_capa;
 
 	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
-		netdev_feature_zero(&ar->hw->netdev_features);
+		netdev_feature_zero(ar->hw->netdev_features);
 		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
-				       &ar->hw->netdev_features);
+				       ar->hw->netdev_features);
 	}
 
 	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ba892c4ab3eb..9ed47b7d37a0 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6570,9 +6570,9 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ath11k_reg_init(ar);
 
 	if (!test_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags)) {
-		netdev_feature_zero(&ar->hw->netdev_features);
+		netdev_feature_zero(ar->hw->netdev_features);
 		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
-				       &ar->hw->netdev_features);
+				       ar->hw->netdev_features);
 		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
 		ieee80211_hw_set(ar->hw, SUPPORT_FAST_XMIT);
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index cbf0e5dcac02..9b0f101e9f4c 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1133,9 +1133,9 @@ static int ath6kl_set_features(struct net_device *dev,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			netdev_feature_copy(&dev->features, features);
+			netdev_feature_copy(dev->features, features);
 			netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
-						 &dev->features);
+						 dev->features);
 			return err;
 		}
 	} else if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
@@ -1145,9 +1145,9 @@ static int ath6kl_set_features(struct net_device *dev,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			netdev_feature_copy(&dev->features, features);
+			netdev_feature_copy(dev->features, features);
 			netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-					       &dev->features);
+					       dev->features);
 			return err;
 		}
 	}
@@ -1310,7 +1310,7 @@ void init_netdev(struct net_device *dev)
 	if (!test_bit(ATH6KL_FW_CAPABILITY_NO_IP_CHECKSUM,
 		      ar->fw_capabilities))
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
-					&dev->hw_features);
+					dev->hw_features);
 
 	return;
 }
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index b29a4d6c3c0f..15df5809d289 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -335,13 +335,13 @@ wil_vif_alloc(struct wil6210_priv *wil, const char *name,
 	ndev->netdev_ops = &wil_netdev_ops;
 	wil_set_ethtoolops(ndev);
 	ndev->ieee80211_ptr = wdev;
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 				NETIF_F_SG | NETIF_F_GRO |
 				NETIF_F_TSO | NETIF_F_TSO6,
-				&ndev->hw_features);
+				ndev->hw_features);
 
-	netdev_feature_or(&ndev->features, ndev->features, ndev->hw_features);
+	netdev_feature_or(ndev->features, ndev->features, ndev->hw_features);
 
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index d04bff1a60f4..7a76b73fc9a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -616,9 +616,9 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
 	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, ndev->features);
 	else
-		netdev_feature_clear_bit(NETIF_F_IP_CSUM_BIT, &ndev->features);
+		netdev_feature_clear_bit(NETIF_F_IP_CSUM_BIT, ndev->features);
 
 	if (brcmf_cfg80211_up(ndev)) {
 		bphy_err(drvr, "failed to bring up cfg80211\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 81df8565a22f..421799d1b2b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -102,9 +102,9 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 
 	if (priv->trans->max_skb_frags) {
-		netdev_feature_zero(&hw->netdev_features);
+		netdev_feature_zero(hw->netdev_features);
 		netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG,
-					&hw->netdev_features);
+					hw->netdev_features);
 	}
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index fdfda9cc55f3..b577bb4cdb27 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -388,9 +388,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		ieee80211_hw_set(hw, USES_RSS);
 
 	if (mvm->trans->max_skb_frags) {
-		netdev_feature_zero(&hw->netdev_features);
+		netdev_feature_zero(hw->netdev_features);
 		netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG,
-					&hw->netdev_features);
+					hw->netdev_features);
 	}
 
 	hw->queues = IEEE80211_NUM_ACS;
@@ -706,11 +706,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	}
 
-	netdev_feature_set_bits(mvm->cfg->features[0], &hw->netdev_features);
+	netdev_feature_set_bits(mvm->cfg->features[0], hw->netdev_features);
 	if (!iwl_mvm_is_csum_supported(mvm))
 		netdev_feature_clear_bits(IWL_TX_CSUM_NETIF_FLAGS |
 					  NETIF_F_RXCSUM,
-					  &hw->netdev_features);
+					  hw->netdev_features);
 
 	if (mvm->cfg->vht_mu_mimo_supported)
 		wiphy_ext_feature_set(hw->wiphy,
@@ -1455,7 +1455,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	netdev_feature_or(&mvmvif->features, mvmvif->features,
+	netdev_feature_or(mvmvif->features, mvmvif->features,
 			  hw->netdev_features);
 
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index aaf8c15a99ad..39c450acc1a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -840,8 +840,8 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u16 snap_ip_tcp, pad;
 	u8 tid;
 
-	netdev_feature_zero(&netdev_flags);
-	netdev_feature_set_bits(NETIF_F_CSUM_MASK | NETIF_F_SG, &netdev_flags);
+	netdev_feature_zero(netdev_flags);
+	netdev_feature_set_bits(NETIF_F_CSUM_MASK | NETIF_F_SG, netdev_flags);
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
@@ -858,7 +858,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_IPV6) &&
 	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
 	    IPPROTO_TCP) {
-		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, &netdev_flags);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, netdev_flags);
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index e690e095ba60..2fcd066ee9b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -363,8 +363,8 @@ mt7615_init_wiphy(struct ieee80211_hw *hw)
 	hw->max_rates = 3;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 11;
-	netdev_feature_zero(&hw->netdev_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
+	netdev_feature_zero(hw->netdev_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index a3ab1a5f3f94..12b953075509 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -217,8 +217,8 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
-	netdev_feature_zero(&hw->netdev_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
+	netdev_feature_zero(hw->netdev_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 368d6cfb2881..cf1aa49b611b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -51,8 +51,8 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = 64;
 	hw->max_tx_aggregation_subframes = 128;
-	netdev_feature_zero(&hw->netdev_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
+	netdev_feature_zero(hw->netdev_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 8acfc1f1e716..2bfd615ad3c0 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -375,7 +375,7 @@ static int xenvif_change_mtu(struct net_device *dev, int mtu)
 }
 
 static void xenvif_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct xenvif *vif = netdev_priv(dev);
 
@@ -532,13 +532,13 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	INIT_LIST_HEAD(&vif->fe_mcast_addr);
 
 	dev->netdev_ops	= &xenvif_netdev_ops;
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_FRAGLIST,
-				&dev->hw_features);
-	netdev_feature_copy(&dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+				dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, dev->features);
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
 	dev->tx_queue_len = XENVIF_QUEUE_LENGTH;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 1c5b58ebe844..a2da87b58cc7 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -735,7 +735,7 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 		spin_unlock_irqrestore(&queue->tx_lock, flags);
 		goto drop;
 	}
-	netif_skb_features(skb, &features);
+	netif_skb_features(skb, features);
 	if (unlikely(netif_needs_gso(skb, features))) {
 		spin_unlock_irqrestore(&queue->tx_lock, flags);
 		goto drop;
@@ -1387,24 +1387,24 @@ static void xennet_release_rx_bufs(struct netfront_queue *queue)
 }
 
 static void xennet_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	struct netfront_info *np = netdev_priv(dev);
 
-	if (netdev_feature_test_bit(NETIF_F_SG_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_SG_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-sg", 0))
 		netdev_feature_clear_bit(NETIF_F_SG_BIT, features);
 
-	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend,
 				  "feature-ipv6-csum-offload", 0))
 		netdev_feature_clear_bit(NETIF_F_IPV6_CSUM_BIT, features);
 
-	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv4", 0))
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 
-	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, features) &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv6", 0))
 		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 }
@@ -1605,21 +1605,21 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	netdev->netdev_ops	= &xennet_netdev_ops;
 
-	netdev_feature_zero(&netdev->features);
+	netdev_feature_zero(netdev->features);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-				NETIF_F_GSO_ROBUST, &netdev->features);
-	netdev_feature_zero(&netdev->hw_features);
+				NETIF_F_GSO_ROBUST, netdev->features);
+	netdev_feature_zero(netdev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_IPV6_CSUM |
 				NETIF_F_TSO | NETIF_F_TSO6,
-				&netdev->hw_features);
+				netdev->hw_features);
 	/*
          * Assume that all hw features are available for now. This set
          * will be adjusted by the call to netdev_update_features() in
          * xennet_connect() which is the earliest point where we can
          * negotiate with the backend regarding supported features.
          */
-	netdev_feature_or(&netdev->features, netdev->features,
+	netdev_feature_or(netdev->features, netdev->features,
 			  netdev->hw_features);
 
 	netdev->ethtool_ops = &xennet_ethtool_ops;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 82c4ae2ae064..5b33e380c3eb 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6386,10 +6386,10 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 
 	dev->ethtool_ops = &qeth_ethtool_ops;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, dev->vlan_features);
 	if (IS_IQD(card))
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, dev->features);
 
 	return dev;
 }
@@ -6836,18 +6836,18 @@ void qeth_enable_hw_features(struct net_device *dev)
 	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct qeth_card *card = dev->ml_priv;
 
-	netdev_feature_copy(&features, dev->features);
+	netdev_feature_copy(features, dev->features);
 	/* force-off any feature that might need an IPA sequence.
 	 * netdev_update_features() will restart them.
 	 */
-	netdev_feature_andnot(&dev->features, dev->features,
+	netdev_feature_andnot(dev->features, dev->features,
 			      dev->hw_features);
 	/* toggle VLAN filter, so that VIDs are re-programmed: */
 	if (IS_LAYER2(card) && IS_VM_NIC(card)) {
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &dev->features);
+					 dev->features);
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &dev->wanted_features);
+				       dev->wanted_features);
 	}
 	netdev_update_features(dev);
 	if (!netdev_feature_equal(features, dev->features))
@@ -6863,14 +6863,14 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 	__DECLARE_NETDEV_FEATURE_MASK(ipv6_features);
 	__DECLARE_NETDEV_FEATURE_MASK(ipv4_features);
 
-	netdev_features_zero(&ipv6_features);
-	netdev_features_zero(&ipv4_features);
-	netdev_features_set_bit(NETIF_F_TSO6_BIT, &ipv6_features);
-	netdev_features_set_bit(NETIF_F_TSO_BIT, &ipv4_features);
+	netdev_features_zero(ipv6_features);
+	netdev_features_zero(ipv4_features);
+	netdev_features_set_bit(NETIF_F_TSO6_BIT, ipv6_features);
+	netdev_features_set_bit(NETIF_F_TSO_BIT, ipv4_features);
 	if (!card->info.has_lp2lp_cso_v6)
-		netdev_features_set_bit(NETIF_F_IPV6_CSUM_BIT, &ipv6_features);
+		netdev_features_set_bit(NETIF_F_IPV6_CSUM_BIT, ipv6_features);
 	if (!card->info.has_lp2lp_cso_v4)
-		netdev_features_set_bit(NETIF_F_IP_CSUM_BIT, &ipv4_features);
+		netdev_features_set_bit(NETIF_F_IP_CSUM_BIT, ipv4_features);
 
 	if (netdev_feature_intersects(ipv6_features, changed) &&
 	    !netdev_feature_intersects(ipv6_features, actual))
@@ -6889,7 +6889,7 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 	QETH_CARD_TEXT(card, 2, "setfeat");
 	QETH_CARD_HEX(card, 2, &features, sizeof(features));
 
-	netdev_feature_xor(&changed, dev->features, features);
+	netdev_feature_xor(changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, changed)) {
 		rc = qeth_set_ipa_csum(card,
 				       netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT,
@@ -6897,7 +6897,7 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4,
 				       &card->info.has_lp2lp_cso_v4);
 		if (rc)
-			netdev_feature_change_bit(NETIF_F_IP_CSUM_BIT, &changed);
+			netdev_feature_change_bit(NETIF_F_IP_CSUM_BIT, changed);
 	}
 	if (netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, changed)) {
 		rc = qeth_set_ipa_csum(card,
@@ -6906,14 +6906,14 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV6,
 				       &card->info.has_lp2lp_cso_v6);
 		if (rc)
-			netdev_feature_change_bit(NETIF_F_IPV6_CSUM_BIT, &changed);
+			netdev_feature_change_bit(NETIF_F_IPV6_CSUM_BIT, changed);
 	}
 	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		rc = qeth_set_ipa_rx_csum(card,
 					  netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
 								  features));
 		if (rc)
-			netdev_feature_change_bit(NETIF_F_RXCSUM_BIT, &changed);
+			netdev_feature_change_bit(NETIF_F_RXCSUM_BIT, changed);
 	}
 	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, changed)) {
 		rc = qeth_set_ipa_tso(card,
@@ -6921,7 +6921,7 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 							      features),
 				      QETH_PROT_IPV4);
 		if (rc)
-			netdev_feature_change_bit(NETIF_F_TSO_BIT, &changed);
+			netdev_feature_change_bit(NETIF_F_TSO_BIT, changed);
 	}
 	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, changed)) {
 		rc = qeth_set_ipa_tso(card,
@@ -6929,24 +6929,24 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 							      features),
 				      QETH_PROT_IPV6);
 		if (rc)
-			netdev_feature_change_bit(NETIF_F_TSO6_BIT, &changed);
+			netdev_feature_change_bit(NETIF_F_TSO6_BIT, changed);
 	}
 
-	netdev_feature_xor(&tmp1, dev->features, features);
-	netdev_feature_xor(&tmp2, dev->features, changed);
+	netdev_feature_xor(tmp1, dev->features, features);
+	netdev_feature_xor(tmp2, dev->features, changed);
 	qeth_check_restricted_features(card, tmp1, tmp2);
 
 	/* everything changed successfully? */
-	netdev_feature_xor(&tmp1, dev->features, features);
+	netdev_feature_xor(tmp1, dev->features, features);
 	if (netdev_feature_equal(tmp1, changed))
 		return 0;
 	/* something went wrong. save changed features and return error */
-	netdev_feature_xor(&dev->features, dev->features, changed);
+	netdev_feature_xor(dev->features, dev->features, changed);
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(qeth_set_features);
 
-void qeth_fix_features(struct net_device *dev, netdev_features_t *features)
+void qeth_fix_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qeth_card *card = dev->ml_priv;
 
@@ -6963,12 +6963,12 @@ void qeth_fix_features(struct net_device *dev, netdev_features_t *features)
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_TSO))
 		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 
-	QETH_CARD_HEX(card, 2, features, sizeof(*features));
+	QETH_CARD_HEX(card, 2, features, sizeof(features));
 }
 EXPORT_SYMBOL_GPL(qeth_fix_features);
 
 void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
-			 netdev_features_t *features)
+			 netdev_features_t features)
 {
 	struct qeth_card *card = dev->ml_priv;
 
@@ -6977,27 +6977,27 @@ void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 	    READ_ONCE(card->options.isolation) != ISOLATION_MODE_FWD) {
 		__DECLARE_NETDEV_FEATURE_MASK(restricted);
 
-		netdev_feature_zero(&restricted);
-		if (skb_is_gso(skb) && !netif_needs_gso(skb, *features))
-			netdev_feature_set_bits(NETIF_F_ALL_TSO, &restricted);
+		netdev_feature_zero(restricted);
+		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
+			netdev_feature_set_bits(NETIF_F_ALL_TSO, restricted);
 
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
 			if (!card->info.has_lp2lp_cso_v4)
 				netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-						       &restricted);
+						       restricted);
 
 			if (restricted && qeth_next_hop_is_local_v4(card, skb))
 				netdev_feature_andnot(features, features,
-						      &restricted);
+						      restricted);
 			break;
 		case htons(ETH_P_IPV6):
 			if (!card->info.has_lp2lp_cso_v6)
 				netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-						       &restricted);
+						       restricted);
 
 			if (restricted && qeth_next_hop_is_local_v6(card, skb))
-				netdev_feature_andnot(features, *features,
+				netdev_feature_andnot(features, features,
 						      restricted);
 			break;
 		default:
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c9750d3e842c..7718d043412e 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1080,49 +1080,49 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 
 	if (IS_OSM(card)) {
 		netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT,
-				       &card->dev->features);
+				       card->dev->features);
 	} else {
 		if (!IS_VM_NIC(card))
 			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					       &card->dev->hw_features);
+					       card->dev->hw_features);
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &card->dev->features);
+				       card->dev->features);
 	}
 
 	if (IS_OSD(card) && !IS_VM_NIC(card)) {
-		netdev_feature_set_bit(NETIF_F_SG_BIT, &card->dev->features);
+		netdev_feature_set_bit(NETIF_F_SG_BIT, card->dev->features);
 		/* OSA 3S and earlier has no RX/TX support */
 		if (qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM)) {
 			netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-					       &card->dev->hw_features);
+					       card->dev->hw_features);
 			netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
-					       &card->dev->vlan_features);
+					       card->dev->vlan_features);
 		}
 	}
 	if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
 		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-				       &card->dev->hw_features);
+				       card->dev->hw_features);
 		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-				       &card->dev->vlan_features);
+				       card->dev->vlan_features);
 	}
 	if (qeth_is_supported(card, IPA_INBOUND_CHECKSUM) ||
 	    qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6)) {
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &card->dev->hw_features);
+				       card->dev->hw_features);
 		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
-				       &card->dev->vlan_features);
+				       card->dev->vlan_features);
 	}
 	if (qeth_is_supported(card, IPA_OUTBOUND_TSO)) {
 		netdev_feature_set_bit(NETIF_F_TSO_BIT,
-				       &card->dev->hw_features);
+				       card->dev->hw_features);
 		netdev_feature_set_bit(NETIF_F_TSO_BIT,
-				       &card->dev->vlan_features);
+				       card->dev->vlan_features);
 	}
 	if (qeth_is_supported6(card, IPA_OUTBOUND_TSO)) {
 		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-				       &card->dev->hw_features);
+				       card->dev->hw_features);
 		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-				       &card->dev->vlan_features);
+				       card->dev->vlan_features);
 	}
 
 	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 54416c37f52f..23f03f497a2b 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1880,26 +1880,26 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 
 		if (!IS_VM_NIC(card)) {
 			netdev_feature_set_bit(NETIF_F_SG_BIT,
-					       &card->dev->features);
+					       card->dev->features);
 			netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_RXCSUM |
 						NETIF_F_IP_CSUM,
-						&card->dev->hw_features);
+						card->dev->hw_features);
 			netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_RXCSUM |
 						NETIF_F_IP_CSUM,
-						&card->dev->vlan_features);
+						card->dev->vlan_features);
 		}
 
 		if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
 			netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-					       &card->dev->hw_features);
+					       card->dev->hw_features);
 			netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
-					       &card->dev->vlan_features);
+					       card->dev->vlan_features);
 		}
 		if (qeth_is_supported6(card, IPA_OUTBOUND_TSO)) {
 			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-					       &card->dev->hw_features);
+					       card->dev->hw_features);
 			netdev_feature_set_bit(NETIF_F_TSO6_BIT,
-					       &card->dev->vlan_features);
+					       card->dev->vlan_features);
 		}
 
 		/* allow for de-acceleration of NETIF_F_HW_VLAN_CTAG_TX: */
@@ -1924,7 +1924,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 
 	card->dev->needed_headroom = headroom;
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX, &card->dev->features);
+				NETIF_F_HW_VLAN_CTAG_RX, card->dev->features);
 
 	netif_keep_dst(card->dev);
 	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index e427f65ebc5c..a5d91e85f079 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -423,10 +423,10 @@ int cvm_oct_common_init(struct net_device *dev)
 
 	if (priv->queue != -1)
 		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM,
-					&dev->features);
+					dev->features);
 
 	/* We do our own locking, Linux doesn't need to */
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	dev->ethtool_ops = &cvm_oct_ethtool_ops;
 
 	cvm_oct_set_mac_filter(dev);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 61b7cb6d1396..65de116e8f7c 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2259,7 +2259,7 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 	}
 
 	/* update the features with resent change */
-	netdev_feature_copy(&ndev->features, features);
+	netdev_feature_copy(ndev->features, features);
 
 	if (need_restart) {
 		status = qlge_adapter_up(qdev);
@@ -2279,7 +2279,7 @@ static int qlge_set_features(struct net_device *ndev,
 	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err;
 
-	netdev_feature_xor(&changed, ndev->features, features);
+	netdev_feature_xor(changed, ndev->features, features);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		/* Update the behavior of vlan accel in the adapter */
@@ -4577,7 +4577,7 @@ static int qlge_probe(struct pci_dev *pdev,
 		goto netdev_free;
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_zero(ndev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG |
 				NETIF_F_IP_CSUM |
 				NETIF_F_TSO |
@@ -4586,17 +4586,17 @@ static int qlge_probe(struct pci_dev *pdev,
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER |
 				NETIF_F_RXCSUM,
-				&ndev->hw_features);
-	netdev_feature_copy(&ndev->features, ndev->hw_features);
-	netdev_feature_copy(&ndev->vlan_features, ndev->hw_features);
+				ndev->hw_features);
+	netdev_feature_copy(ndev->features, ndev->hw_features);
+	netdev_feature_copy(ndev->vlan_features, ndev->hw_features);
 	/* vlan gets same features (except vlan filter) */
 	netdev_feature_clear_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
 				  NETIF_F_HW_VLAN_CTAG_TX |
 				  NETIF_F_HW_VLAN_CTAG_RX,
-				  &ndev->vlan_features);
+				  ndev->vlan_features);
 
 	if (test_bit(QL_DMA64, &qdev->flags))
-		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, ndev->features);
 
 	/*
 	 * Set up net_device structure.
diff --git a/drivers/usb/gadget/function/f_phonet.c b/drivers/usb/gadget/function/f_phonet.c
index 1d63d28425e6..bcb04c6be552 100644
--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -267,7 +267,7 @@ static const struct net_device_ops pn_netdev_ops = {
 
 static void pn_net_setup(struct net_device *dev)
 {
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= PHONET_DEV_MTU;
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 6565a62db842..a6f14a74f7c2 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -731,7 +731,7 @@ static inline bool skb_vlan_tagged_multi(struct sk_buff *skb)
  * Returns features without unsafe ones if the skb has multiple tags.
  */
 static inline void vlan_features_check(struct sk_buff *skb,
-				       netdev_features_t *features)
+				       netdev_features_t features)
 {
 	if (skb_vlan_tagged_multi(skb)) {
 		/* In the case of multi-tagged packets, use a direct mask
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index b5013b3e3e48..de2fbe1fd127 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -9,7 +9,7 @@
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
-typedef u64 netdev_features_t;
+typedef unsigned long *netdev_features_t;
 
 enum {
 	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
@@ -103,11 +103,12 @@ enum {
 
 #define NETDEV_FEATURE_DWORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 64)
 
+/* declare a netdev feature bitmap */
 #define __DECLARE_NETDEV_FEATURE_MASK(name)	\
-	netdev_features_t name
+	DECLARE_BITMAP(name, NETDEV_FEATURE_COUNT)
 
 /* copy'n'paste compression ;) */
-#define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
+#define __NETIF_F_BIT(bit)	((u64)1 << (bit))
 #define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
 
 #define NETIF_F_FCOE_CRC	__NETIF_F(FCOE_CRC)
@@ -174,37 +175,17 @@ enum {
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
 
-/* Finds the next feature with the highest number of the range of start till 0.
- */
-static inline int find_next_netdev_feature(u64 feature, unsigned long start)
-{
-	/* like BITMAP_LAST_WORD_MASK() for u64
-	 * this sets the most significant 64 - start to 0.
-	 */
-	feature &= ~0ULL >> (-start & ((sizeof(feature) * 8) - 1));
-
-	return fls64(feature) - 1;
-}
-
 /* This goes for the MSB to the LSB through the set feature bits,
  * mask_addr should be a u64 and bit an int
  */
 #define for_each_netdev_feature(mask_addr, bit)				\
-	for ((bit) = find_next_netdev_feature((mask_addr),		\
-					      NETDEV_FEATURE_COUNT);	\
-	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	for_each_set_bit(bit, (unsigned long *)mask_addr, NETDEV_FEATURE_COUNT)
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
 #define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
 				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
 
-/* remember that ((t)1 << t_BITS) is undefined in C99 */
-#define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
-		(__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) - 1)) & \
-		~NETIF_F_NEVER_CHANGE)
-
 /* Segmentation offload feature mask */
 #define NETIF_F_GSO_MASK	(__NETIF_F_BIT(NETIF_F_GSO_LAST + 1) - \
 		__NETIF_F_BIT(NETIF_F_GSO_SHIFT))
@@ -266,73 +247,72 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-static inline void netdev_feature_zero(netdev_features_t *dst)
+static inline void netdev_feature_zero(unsigned long *dst)
 {
-	*dst = 0;
+	bitmap_zero(dst, NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_fill(netdev_features_t *dst)
+static inline void netdev_feature_fill(unsigned long *dst)
 {
-	*dst = ~0;
+	bitmap_fill(dst, NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_copy(netdev_features_t *dst,
-				       const netdev_features_t src)
+static inline void netdev_feature_copy(unsigned long *dst,
+				       const unsigned long *src)
 {
-	*dst = src;
+	bitmap_copy(dst, src, NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_and(netdev_features_t *dst,
-				      const netdev_features_t a,
-				      const netdev_features_t b)
+static inline void netdev_feature_and(unsigned long *dst,
+				      const unsigned long *a,
+				      const unsigned long *b)
 {
-	*dst = a & b;
+	bitmap_and(dst, a, b, NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_or(netdev_features_t *dst,
-				     const netdev_features_t a,
-				     const netdev_features_t b)
+static inline void netdev_feature_or(unsigned long *dst,
+				     const unsigned long *a,
+				     const unsigned long *b)
 {
-	*dst = a | b;
+	bitmap_or(dst, a, b, NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_xor(netdev_features_t *dst,
-				      const netdev_features_t a,
-				      const netdev_features_t b)
+static inline void netdev_feature_xor(unsigned long *dst,
+				      const unsigned long *a,
+				      const unsigned long *b)
 {
-	*dst = a ^ b;
+	bitmap_xor(dst, a, b, NETDEV_FEATURE_COUNT);
 }
 
-static inline bool netdev_feature_empty(netdev_features_t src)
+static inline bool netdev_feature_empty(const unsigned long *src)
 {
-	return src == 0;
+	return bitmap_empty(src, NETDEV_FEATURE_COUNT);
 }
 
-static inline bool netdev_feature_equal(const netdev_features_t src1,
-					const netdev_features_t src2)
+static inline bool netdev_feature_equal(const unsigned long *src1,
+					const unsigned long *src2)
 {
-	return src1 == src2;
+	return bitmap_equal(src1, src2, NETDEV_FEATURE_COUNT);
 }
 
-static inline int netdev_feature_andnot(netdev_features_t *dst,
-					const netdev_features_t src1,
-					const netdev_features_t src2)
+static inline int netdev_feature_andnot(netdev_features_t dst,
+					const unsigned long *src1,
+					const unsigned long *src2)
 {
-	*dst = src1 & ~src2;
-	return 0;
+	return bitmap_andnot(dst, src1, src2,  NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_set_bit(int nr, netdev_features_t *addr)
+static inline void netdev_feature_set_bit(int nr, unsigned long *addr)
 {
-	*addr |= __NETIF_F_BIT(nr);
+	__set_bit(nr, addr);
 }
 
-static inline void netdev_feature_clear_bit(int nr, netdev_features_t *addr)
+static inline void netdev_feature_clear_bit(int nr, unsigned long *addr)
 {
-	*addr &= ~(__NETIF_F_BIT(nr));
+	__clear_bit(nr, addr);
 }
 
-static inline void netdev_feature_mod_bit(int nr, netdev_features_t *addr,
+static inline void netdev_feature_mod_bit(int nr, unsigned long *addr,
 					  int set)
 {
 	if (set)
@@ -341,19 +321,19 @@ static inline void netdev_feature_mod_bit(int nr, netdev_features_t *addr,
 		netdev_feature_clear_bit(nr, addr);
 }
 
-static inline void netdev_feature_change_bit(int nr, netdev_features_t *addr)
+static inline void netdev_feature_change_bit(int nr, unsigned long *addr)
 {
-	*addr ^= __NETIF_F_BIT(nr);
+	__change_bit(nr, addr);
 }
 
-static inline int netdev_feature_test_bit(int nr, const netdev_features_t addr)
+static inline int netdev_feature_test_bit(int nr, const unsigned long *addr)
 {
-	return (addr & __NETIF_F_BIT(nr)) > 0;
+	return test_bit(nr, addr);
 }
 
 static inline void netdev_feature_set_bit_array(const int *array,
 						int array_size,
-						netdev_features_t *addr)
+						unsigned long *addr)
 {
 	int i;
 
@@ -362,41 +342,58 @@ static inline void netdev_feature_set_bit_array(const int *array,
 }
 
 /* only be used for the first 64 bits features */
-static inline void netdev_feature_set_bits(u64 bits, netdev_features_t *addr)
+static inline void netdev_feature_set_bits(u64 bits, unsigned long *addr)
 {
-	*addr |= bits;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
+
+	netdev_feature_zero(tmp);
+	bitmap_from_u64(tmp, bits);
+	netdev_feature_or(addr, addr, tmp);
 }
 
 /* only be used for the first 64 bits features */
-static inline void netdev_feature_clear_bits(u64 bits, netdev_features_t *addr)
+static inline void netdev_feature_clear_bits(u64 bits, unsigned long *addr)
 {
-	*addr &= ~bits;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
+
+	netdev_feature_zero(tmp);
+	bitmap_from_u64(tmp, bits);
+	netdev_feature_andnot(addr, addr, tmp);
 }
 
 /* only be used for the first 64 bits features */
 static inline bool netdev_feature_test_bits(u64 bits,
-					    const netdev_features_t addr)
+					    const unsigned long *addr)
 {
-	return (addr & bits) > 0;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
+
+	netdev_feature_zero(tmp);
+	bitmap_from_u64(tmp, bits);
+	netdev_feature_and(tmp, tmp, addr);
+	return netdev_feature_empty(tmp);
 }
 
 /* only be used for the first 64 bits features */
 static inline void netdev_feature_and_bits(u64 bits,
-					   netdev_features_t *addr)
+					   unsigned long *addr)
 {
-	*addr &= bits;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
+
+	netdev_feature_zero(tmp);
+	bitmap_from_u64(tmp, bits);
+	netdev_feature_and(addr, tmp, addr);
 }
 
 static inline int netdev_feature_intersects(const netdev_features_t src1,
 					    const netdev_features_t src2)
 {
-	return (src1 & src2) > 0;
+	return bitmap_intersects(src1, src2, NETDEV_FEATURE_COUNT);
 }
 
-static inline int netdev_feature_subset(const netdev_features_t src1,
-					const netdev_features_t src2)
+static inline int netdev_feature_subset(const unsigned long *src1,
+					const unsigned long *src2)
 {
-	return (src1 & src2) == src2;
+	return bitmap_subset(src1, src2, NETDEV_FEATURE_COUNT);
 }
 
 #endif	/* _LINUX_NETDEV_FEATURES_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4d36b747165c..1ae8a32f74f2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1354,7 +1354,7 @@ struct net_device_ops {
 						  struct net_device *dev);
 	void			(*ndo_features_check)(struct sk_buff *skb,
 						      struct net_device *dev,
-						      netdev_features_t *features);
+						      netdev_features_t features);
 	u16			(*ndo_select_queue)(struct net_device *dev,
 						    struct sk_buff *skb,
 						    struct net_device *sb_dev);
@@ -1482,7 +1482,7 @@ struct net_device_ops {
 	struct net_device*	(*ndo_sk_get_lower_dev)(struct net_device *dev,
 							struct sock *sk);
 	void			(*ndo_fix_features)(struct net_device *dev,
-						    netdev_features_t *features);
+						    netdev_features_t features);
 	int			(*ndo_set_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_neigh_construct)(struct net_device *dev,
@@ -5021,7 +5021,7 @@ const char *netdev_drivername(const struct net_device *dev);
 
 void linkwatch_run_queue(void);
 
-static inline void netdev_intersect_features(netdev_features_t *ret,
+static inline void netdev_intersect_features(netdev_features_t ret,
 					     netdev_features_t f1,
 					     netdev_features_t f2)
 {
@@ -5029,37 +5029,37 @@ static inline void netdev_intersect_features(netdev_features_t *ret,
 	    netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, f2)) {
 		if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, f1))
 			netdev_feature_set_bits(NETIF_F_IP_CSUM |
-						NETIF_F_IPV6_CSUM, &f1);
+						NETIF_F_IPV6_CSUM, f1);
 		else
 			netdev_feature_set_bits(NETIF_F_IP_CSUM |
-						NETIF_F_IPV6_CSUM, &f2);
+						NETIF_F_IPV6_CSUM, f2);
 	}
 
 	netdev_feature_and(ret, f1, f2);
 }
 
 static inline void netdev_get_wanted_features(struct net_device *dev,
-					      netdev_features_t *wanted)
+					      netdev_features_t wanted)
 {
 	netdev_feature_andnot(wanted, dev->features, dev->hw_features);
-	netdev_feature_or(wanted, *wanted, dev->wanted_features);
+	netdev_feature_or(wanted, wanted, dev->wanted_features);
 }
 
-void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
+void netdev_increment_features(netdev_features_t ret, netdev_features_t all,
 			       netdev_features_t one, netdev_features_t mask);
 
 /* Allow TSO being used on stacked device :
  * Performing the GSO segmentation before last device
  * is a performance improvement.
  */
-static inline void netdev_add_tso_features(netdev_features_t *features,
+static inline void netdev_add_tso_features(netdev_features_t features,
 					   netdev_features_t mask)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(one);
 
-	netdev_feature_zero(&one);
-	netdev_feature_set_bits(NETIF_F_ALL_TSO, &one);
-	netdev_increment_features(features, *features, one, mask);
+	netdev_feature_zero(one);
+	netdev_feature_set_bits(NETIF_F_ALL_TSO, one);
+	netdev_increment_features(features, features, one, mask);
 }
 
 int __netdev_update_features(struct net_device *dev);
@@ -5070,10 +5070,10 @@ void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 					struct net_device *dev);
 
 void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
-			     netdev_features_t *features);
-void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
+			     netdev_features_t features);
+void netif_skb_features(struct sk_buff *skb, netdev_features_t features);
 
-static inline bool net_gso_ok(netdev_features_t features, int gso_type)
+static inline bool net_gso_ok(const unsigned long *features, int gso_type)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(feature);
 
@@ -5098,8 +5098,8 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
 
-	netdev_feature_zero(&feature);
-	netdev_feature_set_bits((u64)gso_type << NETIF_F_GSO_SHIFT, &feature);
+	netdev_feature_zero(feature);
+	netdev_feature_set_bits((u64)gso_type << NETIF_F_GSO_SHIFT, feature);
 
 	return netdev_feature_subset(features, feature);
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 6107aa6731e6..4dd67072d36f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2050,16 +2050,16 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst);
 
 static inline void sk_nocaps_add(struct sock *sk, netdev_features_t flags)
 {
-	netdev_feature_or(&sk->sk_route_nocaps, sk->sk_route_nocaps, flags);
-	netdev_feature_andnot(&sk->sk_route_caps, sk->sk_route_caps, flags);
+	netdev_feature_or(sk->sk_route_nocaps, sk->sk_route_nocaps, flags);
+	netdev_feature_andnot(sk->sk_route_caps, sk->sk_route_caps, flags);
 }
 
 static inline void sk_nocaps_add_gso(struct sock *sk)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(gso_flags);
 
-	netdev_feature_zero(&gso_flags);
-	netdev_feature_set_bits(NETIF_F_GSO_MASK, &gso_flags);
+	netdev_feature_zero(gso_flags);
+	netdev_feature_set_bits(NETIF_F_GSO_MASK, gso_flags);
 	sk_nocaps_add(sk, gso_flags);
 }
 
diff --git a/include/net/udp.h b/include/net/udp.h
index 42681e7e2eba..d09c555860ec 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -484,15 +484,15 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *segs;
 
-	netdev_feature_zero(&features);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &features);
+	netdev_feature_zero(features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, features);
 
 	/* Avoid csum recalculation by skb_segment unless userspace explicitly
 	 * asks for the final checksum values
 	 */
 	if (!inet_get_convert_csum(sk))
 		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-					&features);
+					features);
 
 	/* UDP segmentation expects packets of type CHECKSUM_PARTIAL or
 	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index dba14ed12c5d..2e30dea70621 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -297,7 +297,7 @@ struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
 
 static inline void vxlan_features_check(struct sk_buff *skb,
-					netdev_features_t *features)
+					netdev_features_t features)
 {
 	u8 l4_hdr = 0;
 
@@ -321,7 +321,7 @@ static inline void vxlan_features_check(struct sk_buff *skb,
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
-	      !can_checksum_protocol(*features, inner_eth_hdr(skb)->h_proto))))
+	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto))))
 		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
 					  features);
 }
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 68c1cebdb300..ec6aeef2c291 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8909,8 +8909,8 @@ static __init int test_skb_segment_single(const struct skb_segment_test *test)
 		goto done;
 	}
 
-	netdev_feature_zero(&features);
-	netdev_feature_set_bits(test->features[0], &features);
+	netdev_feature_zero(features);
+	netdev_feature_set_bits(test->features[0], features);
 	segs = skb_segment(skb, features);
 	if (!IS_ERR(segs)) {
 		kfree_skb_list(segs);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d7ad44f2c8f5..9a109a7288b8 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1754,8 +1754,8 @@ char *netdev_bits(char *buf, char *end, const void *addr,
 
 	switch (fmt[1]) {
 	case 'F':
-		num = *(const netdev_features_t *)addr;
-		size = sizeof(netdev_features_t);
+		num = *(const u64 *)addr;
+		size = sizeof(u64);
 		break;
 	default:
 		return error_string(buf, end, "(%pN?)", spec);
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 8a50deff286a..d230e08ddcd5 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -340,7 +340,7 @@ static void vlan_transfer_features(struct net_device *dev,
 
 	vlandev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
 	vlandev->priv_flags |= (vlan->real_dev->priv_flags & IFF_XMIT_DST_RELEASE);
-	vlan_tnl_features(vlan->real_dev, &vlandev->hw_enc_features);
+	vlan_tnl_features(vlan->real_dev, vlandev->hw_enc_features);
 
 	netdev_update_features(vlandev);
 }
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 9ed1d1c8f547..e81659ea6583 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -104,15 +104,15 @@ static inline struct net_device *vlan_find_dev(struct net_device *real_dev,
 }
 
 static inline void vlan_tnl_features(struct net_device *real_dev,
-				     netdev_features_t *tnl)
+				     netdev_features_t tnl)
 {
 	netdev_feature_zero(tnl);
 	netdev_feature_set_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE |
 				NETIF_F_GSO_ENCAP_ALL, tnl);
-	netdev_feature_and(tnl, *tnl, real_dev->hw_enc_features);
+	netdev_feature_and(tnl, tnl, real_dev->hw_enc_features);
 
-	if (netdev_feature_test_bits(NETIF_F_GSO_ENCAP_ALL, *tnl) &&
-	    netdev_feature_test_bits(NETIF_F_CSUM_MASK, *tnl)) {
+	if (netdev_feature_test_bits(NETIF_F_GSO_ENCAP_ALL, tnl) &&
+	    netdev_feature_test_bits(NETIF_F_CSUM_MASK, tnl)) {
 		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, tnl);
 		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, tnl);
 		return;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 4062917584de..008c9fc093ac 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -566,24 +566,24 @@ static int vlan_dev_init(struct net_device *dev)
 	if (vlan->flags & VLAN_FLAG_BRIDGE_BINDING)
 		dev->state |= (1 << __LINK_STATE_NOCARRIER);
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
 				NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE |
 				NETIF_F_GSO_ENCAP_ALL |
 				NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
-				NETIF_F_ALL_FCOE, &dev->hw_features);
+				NETIF_F_ALL_FCOE, dev->hw_features);
 
-	netdev_feature_or(&dev->features, dev->features, dev->hw_features);
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_or(dev->features, dev->features, dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	dev->gso_max_size = real_dev->gso_max_size;
 	dev->gso_max_segs = real_dev->gso_max_segs;
 	if (netdev_feature_test_bits(NETIF_F_VLAN_FEATURES, dev->features))
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
-	netdev_feature_copy(&dev->vlan_features, real_dev->vlan_features);
-	netdev_feature_clear_bits(NETIF_F_ALL_FCOE, &dev->vlan_features);
-	vlan_tnl_features(real_dev, &dev->hw_enc_features);
-	netdev_feature_copy(&dev->mpls_features, real_dev->mpls_features);
+	netdev_feature_copy(dev->vlan_features, real_dev->vlan_features);
+	netdev_feature_clear_bits(NETIF_F_ALL_FCOE, dev->vlan_features);
+	vlan_tnl_features(real_dev, dev->hw_enc_features);
+	netdev_feature_copy(dev->mpls_features, real_dev->mpls_features);
 
 	/* ipv6 shared card related stuff */
 	dev->dev_id = real_dev->dev_id;
@@ -637,29 +637,29 @@ void vlan_dev_uninit(struct net_device *dev)
 }
 
 static void vlan_dev_fix_features(struct net_device *dev,
-				  netdev_features_t *features)
+				  netdev_features_t features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
 	__DECLARE_NETDEV_FEATURE_MASK(lower_features);
 	__DECLARE_NETDEV_FEATURE_MASK(old_features);
 	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
-	netdev_feature_copy(&tmp, real_dev->vlan_features);
-	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &tmp);
-	netdev_feature_copy(&old_features, *features);
-	netdev_intersect_features(&lower_features, tmp, real_dev->features);
+	netdev_feature_copy(tmp, real_dev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, tmp);
+	netdev_feature_copy(old_features, features);
+	netdev_intersect_features(lower_features, tmp, real_dev->features);
 
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
 	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
 				     lower_features))
-		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &lower_features);
-	netdev_intersect_features(features, *features, lower_features);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, lower_features);
+	netdev_intersect_features(features, features, lower_features);
 
 	netdev_feature_and_bits(NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE,
-				&old_features);
-	netdev_feature_or(features, *features, old_features);
+				old_features);
+	netdev_feature_or(features, features, old_features);
 	netdev_feature_set_bit(NETIF_F_LLTX_BIT, features);
 }
 
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 9bf40d24e3a4..a4dabb004f32 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -1001,8 +1001,8 @@ static void batadv_softif_init_early(struct net_device *dev)
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = batadv_softif_free;
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
-				NETIF_F_NETNS_LOCAL, &dev->features);
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+				NETIF_F_NETNS_LOCAL, dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	dev->priv_flags |= IFF_NO_QUEUE;
 
 	/* can't call min_mtu, because the needed variables
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index c9894b9944ab..bb6984a137ad 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -288,7 +288,7 @@ static int br_get_link_ksettings(struct net_device *dev,
 	return 0;
 }
 
-static void br_fix_features(struct net_device *dev, netdev_features_t *features)
+static void br_fix_features(struct net_device *dev, netdev_features_t features)
 {
 	struct net_bridge *br = netdev_priv(dev);
 
@@ -490,17 +490,17 @@ void br_dev_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &br_type);
 	dev->priv_flags = IFF_EBRIDGE | IFF_NO_QUEUE;
 
-	netdev_feature_zero(&dev->features);
+	netdev_feature_zero(dev->features);
 	netdev_feature_set_bits(COMMON_FEATURES | NETIF_F_LLTX |
 				NETIF_F_NETNS_LOCAL |
 				NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX,
-				&dev->features);
-	netdev_feature_zero(&dev->hw_features);
+				dev->features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(COMMON_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX, &dev->hw_features);
-	netdev_feature_zero(&dev->vlan_features);
-	netdev_feature_set_bits(COMMON_FEATURES, &dev->vlan_features);
+				NETIF_F_HW_VLAN_STAG_TX, dev->hw_features);
+	netdev_feature_zero(dev->vlan_features);
+	netdev_feature_set_bits(COMMON_FEATURES, dev->vlan_features);
 
 	br->dev = dev;
 	spin_lock_init(&br->lock);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index d210031df22a..10ecd8cbec77 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -532,7 +532,7 @@ static void br_set_gso_limits(struct net_bridge *br)
 /*
  * Recomputes features using slave's features
  */
-void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
+void br_features_recompute(struct net_bridge *br, netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct net_bridge_port *p;
@@ -540,11 +540,11 @@ void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
 	if (list_empty(&br->port_list))
 		return;
 
-	netdev_feature_copy(&mask, *features);
+	netdev_feature_copy(mask, features);
 	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
 
 	list_for_each_entry(p, &br->port_list, list) {
-		netdev_increment_features(features, *features, p->dev->features,
+		netdev_increment_features(features, features, p->dev->features,
 					  mask);
 	}
 	netdev_add_tso_features(features, mask);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1f5cff791827..65cfd210472e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -824,7 +824,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	      struct netlink_ext_ack *extack);
 int br_del_if(struct net_bridge *br, struct net_device *dev);
 void br_mtu_auto_adjust(struct net_bridge *br);
-void br_features_recompute(struct net_bridge *br, netdev_features_t *features);
+void br_features_recompute(struct net_bridge *br, netdev_features_t features);
 void br_port_flags_change(struct net_bridge_port *port, unsigned long mask);
 void br_manage_promisc(struct net_bridge *br);
 int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index d0f04bdcc00e..a5b75883826c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1636,7 +1636,7 @@ void dev_disable_lro(struct net_device *dev)
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	netdev_feature_clear_bit(NETIF_F_LRO_BIT, &dev->wanted_features);
+	netdev_feature_clear_bit(NETIF_F_LRO_BIT, dev->wanted_features);
 	netdev_update_features(dev);
 
 	if (unlikely(netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features)))
@@ -1657,7 +1657,7 @@ EXPORT_SYMBOL(dev_disable_lro);
  */
 static void dev_disable_gro_hw(struct net_device *dev)
 {
-	netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &dev->wanted_features);
+	netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, dev->wanted_features);
 	netdev_update_features(dev);
 
 	if (unlikely(netdev_feature_test_bit(NETIF_F_GRO_HW_BIT,
@@ -3385,15 +3385,15 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		__DECLARE_NETDEV_FEATURE_MASK(partial_features);
 		struct net_device *dev = skb->dev;
 
-		netdev_feature_and(&partial_features, dev->features,
+		netdev_feature_and(partial_features, dev->features,
 				   dev->gso_partial_features);
 		netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT,
-				       &partial_features);
-		netdev_feature_or(&partial_features, partial_features,
+				       partial_features);
+		netdev_feature_or(partial_features, partial_features,
 				  features);
 		if (!skb_gso_ok(skb, partial_features))
 			netdev_feature_clear_bit(NETIF_F_GSO_PARTIAL_BIT,
-						 &features);
+						 features);
 	}
 
 	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
@@ -3452,21 +3452,21 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
  * instead of standard features for the netdev.
  */
 #if IS_ENABLED(CONFIG_NET_MPLS_GSO)
-static void net_mpls_features(struct sk_buff *skb, netdev_features_t *features,
+static void net_mpls_features(struct sk_buff *skb, netdev_features_t features,
 			      __be16 type)
 {
 	if (eth_p_mpls(type))
-		netdev_feature_and(features, *features,
+		netdev_feature_and(features, features,
 				   skb->dev->mpls_features);
 }
 #else
-static void net_mpls_features(struct sk_buff *skb, netdev_features_t *features,
+static void net_mpls_features(struct sk_buff *skb, netdev_features_t features,
 			      __be16 type)
 {
 }
 #endif
 
-static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
+static void harmonize_features(struct sk_buff *skb, netdev_features_t features)
 {
 	__be16 type;
 
@@ -3474,7 +3474,7 @@ static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 	net_mpls_features(skb, features, type);
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
-	    !can_checksum_protocol(*features, type)) {
+	    !can_checksum_protocol(features, type)) {
 		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
 					  features);
 	}
@@ -3483,21 +3483,21 @@ static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 }
 
 void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
 }
 EXPORT_SYMBOL(passthru_features_check);
 
 static void dflt_features_check(struct sk_buff *skb,
 				struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	vlan_features_check(skb, features);
 }
 
 static void gso_features_check(const struct sk_buff *skb,
 			       struct net_device *dev,
-			       netdev_features_t *features)
+			       netdev_features_t features)
 {
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
@@ -3519,7 +3519,7 @@ static void gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		netdev_feature_andnot(features, *features,
+		netdev_feature_andnot(features, features,
 				      dev->gso_partial_features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
@@ -3535,7 +3535,7 @@ static void gso_features_check(const struct sk_buff *skb,
 	}
 }
 
-void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
+void netif_skb_features(struct sk_buff *skb, netdev_features_t features)
 {
 	struct net_device *dev = skb->dev;
 
@@ -3549,15 +3549,15 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		netdev_feature_and(features, *features, dev->hw_enc_features);
+		netdev_feature_and(features, features, dev->hw_enc_features);
 
 	if (skb_vlan_tagged(skb)) {
 		__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
-		netdev_feature_copy(&tmp, dev->vlan_features);
+		netdev_feature_copy(tmp, dev->vlan_features);
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX_BIT |
-					NETIF_F_HW_VLAN_STAG_TX_BIT, &tmp);
-		netdev_intersect_features(features, *features, tmp);
+					NETIF_F_HW_VLAN_STAG_TX_BIT, tmp);
+		netdev_intersect_features(features, features, tmp);
 	}
 
 	if (dev->netdev_ops->ndo_features_check)
@@ -3651,7 +3651,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 {
 	__DECLARE_NETDEV_FEATURE_MASK(features);
 
-	netif_skb_features(skb, &features);
+	netif_skb_features(skb, features);
 	skb = validate_xmit_vlan(skb, features);
 	if (unlikely(!skb))
 		goto out_null;
@@ -9801,18 +9801,18 @@ static void net_set_todo(struct net_device *dev)
 
 static void netdev_sync_upper_features(struct net_device *lower,
 				       struct net_device *upper,
-				       netdev_features_t *features)
+				       netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(upper_disables);
 	int feature_bit;
 
-	netdev_feature_zero(&upper_disables);
-	netdev_feature_set_bits(NETIF_F_UPPER_DISABLES, &upper_disables);
+	netdev_feature_zero(upper_disables);
+	netdev_feature_set_bits(NETIF_F_UPPER_DISABLES, upper_disables);
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		if (!netdev_feature_test_bit(feature_bit,
 					     upper->wanted_features) &&
-		    netdev_feature_test_bit(feature_bit, *features)) {
+		    netdev_feature_test_bit(feature_bit, features)) {
 			netdev_dbg(lower, "Dropping feature bit %d, upper dev %s has it off.\n",
 				   feature_bit, upper->name);
 			netdev_feature_clear_bit(feature_bit, features);
@@ -9826,8 +9826,8 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	__DECLARE_NETDEV_FEATURE_MASK(upper_disables);
 	int feature_bit;
 
-	netdev_feature_zero(&upper_disables);
-	netdev_feature_set_bits(NETIF_F_UPPER_DISABLES, &upper_disables);
+	netdev_feature_zero(upper_disables);
+	netdev_feature_set_bits(NETIF_F_UPPER_DISABLES, upper_disables);
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		if (!netdev_feature_test_bit(feature_bit, features) &&
@@ -9835,7 +9835,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
 			netdev_dbg(upper, "Disabling feature bit %d on lower dev %s.\n",
 				   feature_bit, lower->name);
 			netdev_feature_clear_bit(feature_bit,
-						 &lower->wanted_features);
+						 lower->wanted_features);
 			__netdev_update_features(lower);
 
 			if (unlikely(netdev_feature_test_bit(feature_bit,
@@ -9849,103 +9849,103 @@ static void netdev_sync_lower_features(struct net_device *upper,
 }
 
 static void netdev_fix_features(struct net_device *dev,
-				netdev_features_t *features)
+				netdev_features_t features)
 {
 	/* Fix illegal checksum combinations */
-	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features) &&
 	    netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
-				     *features)) {
+				     features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
 		netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
 					  features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if (netdev_feature_test_bits(NETIF_F_ALL_TSO, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_SG_BIT, *features)) {
+	if (netdev_feature_test_bits(NETIF_F_ALL_TSO, features) &&
+	    !netdev_feature_test_bit(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
 		netdev_feature_clear_bits(NETIF_F_ALL_TSO, features);
 	}
 
-	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, *features)) {
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
 		netdev_feature_clear_bit(NETIF_F_TSO_BIT, features);
 		netdev_feature_clear_bit(NETIF_F_TSO_ECN_BIT, features);
 	}
 
-	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, *features)) {
+	if (netdev_feature_test_bit(NETIF_F_TSO6_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
 		netdev_feature_clear_bit(NETIF_F_TSO6_BIT, features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if (netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_TSO_BIT, *features))
+	if (netdev_feature_test_bit(NETIF_F_TSO_MANGLEID_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_TSO_BIT, features))
 		netdev_feature_clear_bit(NETIF_F_TSO_MANGLEID_BIT, features);
 
 	/* TSO ECN requires that TSO is present as well. */
-	if (netdev_feature_test_bit(NETIF_F_TSO_ECN_BIT, *features) &&
+	if (netdev_feature_test_bit(NETIF_F_TSO_ECN_BIT, features) &&
 	    !netdev_feature_test_bits(NETIF_F_ALL_TSO & ~NETIF_F_TSO_ECN,
-				      *features))
+				      features))
 		netdev_feature_clear_bit(NETIF_F_TSO_ECN_BIT, features);
 
 	/* Software GSO depends on SG. */
-	if (netdev_feature_test_bit(NETIF_F_GSO_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_SG_BIT, *features)) {
+	if (netdev_feature_test_bit(NETIF_F_GSO_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
 		netdev_feature_clear_bit(NETIF_F_GSO_BIT, features);
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if (netdev_feature_intersects(*features, dev->gso_partial_features) &&
-	    !netdev_feature_test_bit(NETIF_F_GSO_PARTIAL_BIT, *features)) {
+	if (netdev_feature_intersects(features, dev->gso_partial_features) &&
+	    !netdev_feature_test_bit(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		netdev_feature_andnot(features, *features,
+		netdev_feature_andnot(features, features,
 				      dev->gso_partial_features);
 	}
 
-	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features)) {
+		if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
 			netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT, *features)) {
-		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, *features)) {
+	if (netdev_feature_test_bit(NETIF_F_RXFCS_BIT, features)) {
+		if (netdev_feature_test_bit(NETIF_F_LRO_BIT, features)) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
 			netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 		}
 
-		if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, *features)) {
+		if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
 			netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 		}
 	}
 
-	if (netdev_feature_test_bit(NETIF_F_HW_TLS_TX_BIT, *features)) {
-		if ((!netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, *features) ||
-		     !netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, *features)) &&
-		    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *features)) {
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_TX_BIT, features)) {
+		if ((!netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, features) ||
+		     !netdev_feature_test_bit(NETIF_F_IPV6_CSUM_BIT, features)) &&
+		    !netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, features)) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
 			netdev_feature_clear_bit(NETIF_F_HW_TLS_TX_BIT,
 						 features);
 		}
 	}
 
-	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT, *features) &&
-	    !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
+	if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT, features) &&
+	    !netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
 		netdev_feature_clear_bit(NETIF_F_HW_TLS_RX_BIT, features);
 	}
@@ -9960,23 +9960,24 @@ int __netdev_update_features(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	netdev_get_wanted_features(dev, &features);
+	netdev_get_wanted_features(dev, features);
 
 	if (dev->netdev_ops->ndo_fix_features)
-		dev->netdev_ops->ndo_fix_features(dev, &features);
+		dev->netdev_ops->ndo_fix_features(dev, features);
 
 	/* driver might be less strict about feature dependencies */
-	netdev_fix_features(dev, &features);
+	netdev_fix_features(dev, features);
 
 	/* some features can't be enabled if they're off on an upper device */
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
-		netdev_sync_upper_features(dev, upper, &features);
+		netdev_sync_upper_features(dev, upper, features);
 
 	if (netdev_feature_equal(dev->features, features))
 		goto sync_lower;
 
-	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
-		&dev->features, &features);
+	netdev_dbg(dev, "Features changed: %*pb -> %*pb\n",
+		   NETDEV_FEATURE_COUNT, dev->features,
+		   NETDEV_FEATURE_COUNT, features);
 
 	if (dev->netdev_ops->ndo_set_features)
 		err = dev->netdev_ops->ndo_set_features(dev, features);
@@ -9985,8 +9986,9 @@ int __netdev_update_features(struct net_device *dev)
 
 	if (unlikely(err < 0)) {
 		netdev_err(dev,
-			"set_features() failed (%d); wanted %pNF, left %pNF\n",
-			err, &features, &dev->features);
+			"set_features() failed (%d); wanted %*pb, left %*pb\n",
+			err, NETDEV_FEATURE_COUNT, features,
+			NETDEV_FEATURE_COUNT, dev->features);
 		/* return non-0 since some features might have changed and
 		 * it's better to fire a spurious notification than miss it
 		 */
@@ -10003,7 +10005,7 @@ int __netdev_update_features(struct net_device *dev)
 	if (!err) {
 		__DECLARE_NETDEV_FEATURE_MASK(diff);
 
-		netdev_feature_xor(&diff, features, dev->features);
+		netdev_feature_xor(diff, features, dev->features);
 
 		if (netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, diff)) {
 			/* udp_tunnel_{get,drop}_rx_info both need
@@ -10015,7 +10017,7 @@ int __netdev_update_features(struct net_device *dev)
 			 */
 			if (netdev_feature_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
 						    features)) {
-				netdev_feature_copy(&dev->features, features);
+				netdev_feature_copy(dev->features, features);
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
@@ -10025,7 +10027,7 @@ int __netdev_update_features(struct net_device *dev)
 		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
 			if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 						    features)) {
-				netdev_feature_copy(&dev->features, features);
+				netdev_feature_copy(dev->features, features);
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
@@ -10035,14 +10037,14 @@ int __netdev_update_features(struct net_device *dev)
 		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
 			if (netdev_feature_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 						    features)) {
-				netdev_feature_copy(&dev->features, features);
+				netdev_feature_copy(dev->features, features);
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		netdev_feature_copy(&dev->features, features);
+		netdev_feature_copy(dev->features, features);
 	}
 
 	return err < 0 ? 0 : 1;
@@ -10231,8 +10233,6 @@ int register_netdevice(struct net_device *dev)
 	int ret;
 	struct net *net = dev_net(dev);
 
-	BUILD_BUG_ON(sizeof(netdev_features_t) * BITS_PER_BYTE <
-		     NETDEV_FEATURE_COUNT);
 	BUG_ON(dev_boot_phase);
 	ASSERT_RTNL();
 
@@ -10289,22 +10289,22 @@ int register_netdevice(struct net_device *dev)
 	 * software offloads (GSO and GRO).
 	 */
 	netdev_feature_set_bits(NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF,
-				&dev->hw_features);
-	netdev_feature_set_bits(NETIF_F_SOFT_FEATURES, &dev->features);
+				dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SOFT_FEATURES, dev->features);
 
 	if (dev->udp_tunnel_nic_info) {
 		netdev_feature_set_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
-				       &dev->features);
+				       dev->features);
 		netdev_feature_set_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
-				       &dev->hw_features);
+				       dev->hw_features);
 	}
 
-	netdev_feature_and(&dev->wanted_features, dev->features,
+	netdev_feature_and(dev->wanted_features, dev->features,
 			   dev->hw_features);
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		netdev_feature_set_bit(NETIF_F_NOCACHE_COPY_BIT,
-				       &dev->hw_features);
+				       dev->hw_features);
 
 	/* If IPv4 TCP segmentation offload is supported we should also
 	 * allow the device to enable segmenting the frame with the option
@@ -10313,29 +10313,29 @@ int register_netdevice(struct net_device *dev)
 	 */
 	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->hw_features))
 		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-				       &dev->hw_features);
+				       dev->hw_features);
 	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->vlan_features))
 		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-				       &dev->vlan_features);
+				       dev->vlan_features);
 	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->mpls_features))
 		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-				       &dev->mpls_features);
+				       dev->mpls_features);
 	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, dev->hw_enc_features))
 		netdev_feature_set_bit(NETIF_F_TSO_MANGLEID_BIT,
-				       &dev->hw_enc_features);
+				       dev->hw_enc_features);
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
-	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &dev->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, dev->vlan_features);
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_GSO_PARTIAL,
-				&dev->hw_enc_features);
+				dev->hw_enc_features);
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &dev->mpls_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, dev->mpls_features);
 
 	ret = call_netdevice_notifiers(NETDEV_POST_INIT, dev);
 	ret = notifier_to_errno(ret);
@@ -11370,29 +11370,29 @@ static int dev_cpu_dead(unsigned int oldcpu)
  *	@one to the master device with current feature set @all.  Will not
  *	enable anything that is off in @mask. Returns the new feature set.
  */
-void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
+void netdev_increment_features(netdev_features_t ret, netdev_features_t all,
 			       netdev_features_t one, netdev_features_t mask)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, mask))
-		netdev_feature_set_bits(NETIF_F_CSUM_MASK, &mask);
-	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
+		netdev_feature_set_bits(NETIF_F_CSUM_MASK, mask);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, mask);
 
 	netdev_feature_copy(ret, all);
-	netdev_feature_zero(&tmp);
-	netdev_feature_set_bits(NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK, &tmp);
-	netdev_feature_and(&tmp, tmp, one);
-	netdev_feature_and(&tmp, tmp, mask);
-	netdev_feature_or(ret, *ret, tmp);
+	netdev_feature_zero(tmp);
+	netdev_feature_set_bits(NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK, tmp);
+	netdev_feature_and(tmp, tmp, one);
+	netdev_feature_and(tmp, tmp, mask);
+	netdev_feature_or(ret, ret, tmp);
 
-	netdev_feature_fill(&tmp);
-	netdev_feature_clear_bits(NETIF_F_ALL_FOR_ALL, &tmp);
-	netdev_feature_or(&tmp, tmp, one);
-	netdev_feature_and(ret, *ret, tmp);
+	netdev_feature_fill(tmp);
+	netdev_feature_clear_bits(NETIF_F_ALL_FOR_ALL, tmp);
+	netdev_feature_or(tmp, tmp, one);
+	netdev_feature_and(ret, ret, tmp);
 
 	/* If one device supports hw checksumming, set for all. */
-	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, *ret))
+	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, ret))
 		netdev_feature_clear_bits(NETIF_F_CSUM_MASK & ~NETIF_F_HW_CSUM,
 					  ret);
 }
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 83cfc0c5a200..8764ec8fc729 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -77,7 +77,7 @@ static netdev_tx_t netpoll_start_xmit(struct sk_buff *skb,
 	__DECLARE_NETDEV_FEATURE_MASK(features);
 	netdev_tx_t status = NETDEV_TX_OK;
 
-	netif_skb_features(skb, &features);
+	netif_skb_features(skb, features);
 
 	if (skb_vlan_tag_present(skb) &&
 	    !vlan_hw_offload_capable(features, skb->vlan_proto)) {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e229c1c0ce41..aeca054962cd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3992,7 +3992,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		 * skbs; we do so by disabling SG.
 		 */
 		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
-			netdev_feature_clear_bit(NETIF_F_SG_BIT, &features);
+			netdev_feature_clear_bit(NETIF_F_SG_BIT, features);
 	}
 
 	__skb_push(head_skb, doffset);
diff --git a/net/core/sock.c b/net/core/sock.c
index 84a414606eb7..c098b5b427dc 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2146,20 +2146,20 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	u32 max_segs = 1;
 
 	sk_dst_set(sk, dst);
-	netdev_feature_or(&sk->sk_route_caps, dst->dev->features,
+	netdev_feature_or(sk->sk_route_caps, dst->dev->features,
 			  sk->sk_route_forced_caps);
 	if (netdev_feature_test_bit(NETIF_F_GSO_BIT, sk->sk_route_caps))
 		netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-					&sk->sk_route_caps);
-	netdev_feature_andnot(&sk->sk_route_caps, sk->sk_route_caps,
+					sk->sk_route_caps);
+	netdev_feature_andnot(sk->sk_route_caps, sk->sk_route_caps,
 			      sk->sk_route_nocaps);
 	if (sk_can_gso(sk)) {
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
 			netdev_feature_clear_bits(NETIF_F_GSO_MASK,
-						  &sk->sk_route_caps);
+						  sk->sk_route_caps);
 		} else {
 			netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM,
-						&sk->sk_route_caps);
+						sk->sk_route_caps);
 			sk->sk_gso_max_size = dst->dev->gso_max_size;
 			max_segs = max_t(u32, dst->dev->gso_max_segs, 1);
 		}
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index f6161a100dbe..790ee6f8703a 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -138,7 +138,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
 	ip_rt_put(rt);
-	netdev_feature_zero(&sk->sk_route_caps);
+	netdev_feature_zero(sk->sk_route_caps);
 	inet->inet_dport = 0;
 	goto out;
 }
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 0f966e02ddc4..df45a5f31d6b 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -489,9 +489,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	 */
 
 	ip6_dst_store(newsk, dst, NULL, NULL);
-	netdev_feature_copy(&newsk->sk_route_caps, dst->dev->features);
+	netdev_feature_copy(newsk->sk_route_caps, dst->dev->features);
 	netdev_feature_clear_bits(NETIF_F_IP_CSUM | NETIF_F_TSO,
-				  &newsk->sk_route_caps);
+				  newsk->sk_route_caps);
 	newdp6 = (struct dccp6_sock *)newsk;
 	newinet = inet_sk(newsk);
 	newinet->pinet6 = &newdp6->inet6;
@@ -971,7 +971,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
-	netdev_feature_zero(&sk->sk_route_caps);
+	netdev_feature_zero(sk->sk_route_caps);
 	return err;
 }
 
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 83138e013c46..483d387be206 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -949,7 +949,7 @@ static int __dn_connect(struct sock *sk, struct sockaddr_dn *addr, int addrlen,
 	if (dn_route_output_sock(&sk->sk_dst_cache, &fld, sk, flags) < 0)
 		goto out;
 	dst = __sk_dst_get(sk);
-	netdev_feature_copy(&sk->sk_route_caps, dst->dev->features);
+	netdev_feature_copy(sk->sk_route_caps, dst->dev->features);
 	sock->state = SS_CONNECTING;
 	scp->state = DN_CI;
 	scp->segsize_loc = dst_metric_advmss(dst);
diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
index 613e81bb6ed8..c627aedda93f 100644
--- a/net/decnet/dn_nsp_out.c
+++ b/net/decnet/dn_nsp_out.c
@@ -89,7 +89,7 @@ static void dn_nsp_send(struct sk_buff *skb)
 	fld.flowidn_proto = DNPROTO_NSP;
 	if (dn_route_output_sock(&sk->sk_dst_cache, &fld, sk, 0) == 0) {
 		dst = sk_dst_get(sk);
-		netdev_feature_copy(&sk->sk_route_caps, dst->dev->features);
+		netdev_feature_copy(sk->sk_route_caps, dst->dev->features);
 		goto try_again;
 	}
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index dbd53653b5f0..04ae41af6fd0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1461,13 +1461,13 @@ int dsa_slave_manage_vlan_filtering(struct net_device *slave,
 
 	if (vlan_filtering) {
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &slave->features);
+				       slave->features);
 
 		err = vlan_for_each(slave, dsa_slave_restore_vlan, slave);
 		if (err) {
 			vlan_for_each(slave, dsa_slave_clear_vlan, slave);
 			netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-						 &slave->features);
+						 slave->features);
 			return err;
 		}
 	} else {
@@ -1476,7 +1476,7 @@ int dsa_slave_manage_vlan_filtering(struct net_device *slave,
 			return err;
 
 		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					 &slave->features);
+					 slave->features);
 	}
 
 	return 0;
@@ -1886,16 +1886,16 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 
 	p->xmit = cpu_dp->tag_ops->xmit;
 
-	netdev_feature_copy(&slave->features, master->vlan_features);
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &slave->features);
-	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, &slave->hw_features);
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &slave->features);
+	netdev_feature_copy(slave->features, master->vlan_features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, slave->features);
+	netdev_feature_set_bit(NETIF_F_HW_TC_BIT, slave->hw_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, slave->features);
 	if (slave->needed_tailroom)
 		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_FRAGLIST,
-					  &slave->features);
+					  slave->features);
 	if (ds->needs_standalone_vlan_filtering)
 		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-				       &slave->features);
+				       slave->features);
 }
 
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
@@ -1974,7 +1974,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
 	slave_dev->dev.of_node = port->dn;
-	netdev_feature_copy(&slave_dev->vlan_features, master->vlan_features);
+	netdev_feature_copy(slave_dev->vlan_features, master->vlan_features);
 
 	p = netdev_priv(slave_dev);
 	slave_dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 93c6238c7ade..dd231c1da383 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -27,10 +27,7 @@ const struct nla_policy ethnl_features_get_policy[] = {
 
 static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
 {
-	unsigned int i;
-
-	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
-		dest[i] = src >> (32 * i);
+	bitmap_to_arr32(dest, src, NETDEV_FEATURE_COUNT);
 }
 
 static int features_prepare_data(const struct ethnl_req_info *req_base,
@@ -38,14 +35,17 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 				 struct genl_info *info)
 {
 	struct features_reply_data *data = FEATURES_REPDATA(reply_base);
+	__DECLARE_NETDEV_FEATURE_MASK(nochange_features);
 	__DECLARE_NETDEV_FEATURE_MASK(all_features);
 	struct net_device *dev = reply_base->dev;
 
 	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
 	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
 	ethnl_features_to_bitmap32(data->active, dev->features);
-	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
-	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
+	netdev_feature_zero(nochange_features);
+	netdev_feature_set_bits(NETIF_F_NEVER_CHANGE, nochange_features);
+	ethnl_features_to_bitmap32(data->nochange, nochange_features);
+	netdev_feature_fill(all_features);
 	ethnl_features_to_bitmap32(data->all, all_features);
 
 	return 0;
@@ -131,29 +131,6 @@ const struct nla_policy ethnl_features_set_policy[] = {
 	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
 };
 
-static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
-{
-	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
-	unsigned int i;
-
-	bitmap_zero(dest, NETDEV_FEATURE_COUNT);
-	for (i = 0; i < words; i++)
-		dest[i] = (unsigned long)(val >> (i * BITS_PER_LONG));
-}
-
-static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
-{
-	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
-	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
-	netdev_features_t ret = 0;
-	unsigned int i;
-
-	for (i = 0; i < words; i++)
-		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
-	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
-	return ret;
-}
-
 static int features_send_reply(struct net_device *dev, struct genl_info *info,
 			       const unsigned long *wanted,
 			       const unsigned long *wanted_mask,
@@ -210,14 +187,15 @@ static int features_send_reply(struct net_device *dev, struct genl_info *info,
 
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 {
-	DECLARE_BITMAP(wanted_diff_mask, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(active_diff_mask, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(old_active, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(old_wanted, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(new_active, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(new_wanted, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
+	__DECLARE_NETDEV_FEATURE_MASK(wanted_diff_mask);
+	__DECLARE_NETDEV_FEATURE_MASK(active_diff_mask);
+	__DECLARE_NETDEV_FEATURE_MASK(old_active);
+	__DECLARE_NETDEV_FEATURE_MASK(old_wanted);
+	__DECLARE_NETDEV_FEATURE_MASK(new_active);
+	__DECLARE_NETDEV_FEATURE_MASK(new_wanted);
+	__DECLARE_NETDEV_FEATURE_MASK(req_wanted);
+	__DECLARE_NETDEV_FEATURE_MASK(req_mask);
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
@@ -235,45 +213,43 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	dev = req_info.dev;
 
 	rtnl_lock();
-	ethnl_features_to_bitmap(old_active, dev->features);
-	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
+	netdev_feature_copy(old_active, dev->features);
+	netdev_feature_copy(old_wanted, dev->wanted_features);
 	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
 				 netdev_features_strings, info->extack);
 	if (ret < 0)
 		goto out_rtnl;
-	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
+	if (netdev_feature_test_bits(NETIF_F_NEVER_CHANGE, req_mask)) {
 		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
 		ret = -EINVAL;
 		goto out_rtnl;
 	}
 
 	/* set req_wanted bits not in req_mask from old_wanted */
-	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
-	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		dev->wanted_features &= ~dev->hw_features;
-		dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+	netdev_feature_and(req_wanted, req_wanted, req_mask);
+	netdev_feature_andnot(new_wanted, old_wanted, req_mask);
+	netdev_feature_or(req_wanted, new_wanted, req_wanted);
+	if (!netdev_feature_equal(req_wanted, old_wanted)) {
+		netdev_feature_andnot(dev->wanted_features,
+				      dev->wanted_features, dev->hw_features);
+		netdev_feature_and(tmp, req_wanted, dev->hw_features);
+		netdev_feature_or(dev->wanted_features, dev->wanted_features,
+				  tmp);
 		__netdev_update_features(dev);
 	}
-	ethnl_features_to_bitmap(new_active, dev->features);
-	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
+	mod = !netdev_feature_equal(old_active, new_active);
 
 	ret = 0;
 	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
 		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
 
-		bitmap_xor(wanted_diff_mask, req_wanted, new_active,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_xor(active_diff_mask, old_active, new_active,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_and(new_active, new_active, active_diff_mask,
-			   NETDEV_FEATURE_COUNT);
+		netdev_feature_xor(wanted_diff_mask, req_wanted, new_active);
+		netdev_feature_xor(active_diff_mask, old_active, new_active);
+		netdev_feature_and(wanted_diff_mask, wanted_diff_mask,
+				   req_mask);
+		netdev_feature_and(req_wanted, req_wanted, wanted_diff_mask);
+		netdev_feature_and(new_active, new_active, active_diff_mask);
 
 		ret = features_send_reply(dev, info, req_wanted,
 					  wanted_diff_mask, new_active,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 0b2e98e97f58..dcc946d87954 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -64,19 +64,29 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 		.size = ETHTOOL_DEV_FEATURE_WORDS,
 	};
 	struct ethtool_get_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
+	__DECLARE_NETDEV_FEATURE_MASK(nochange_features);
+	u32 nochange[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 wanted[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 active[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 hw[ETHTOOL_DEV_FEATURE_WORDS];
 	u32 __user *sizeaddr;
 	u32 copy_size;
 	int i;
 
 	/* in case feature bits run out again */
-	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(netdev_features_t));
-
+	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(dev->features));
+
+	bitmap_to_arr32(hw, dev->hw_features, NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(wanted, dev->wanted_features, NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(active, dev->features, NETDEV_FEATURE_COUNT);
+	netdev_feature_zero(nochange_features);
+	netdev_feature_set_bits(NETIF_F_NEVER_CHANGE, nochange_features);
+	bitmap_to_arr32(nochange, nochange_features, NETDEV_FEATURE_COUNT);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		features[i].available = (u32)(dev->hw_features >> (32 * i));
-		features[i].requested = (u32)(dev->wanted_features >> (32 * i));
-		features[i].active = (u32)(dev->features >> (32 * i));
-		features[i].never_changed =
-			(u32)(NETIF_F_NEVER_CHANGE >> (32 * i));
+		features[i].available = hw[i];
+		features[i].requested = wanted[i];
+		features[i].active = active[i];
+		features[i].never_changed = nochange[i];
 	}
 
 	sizeaddr = useraddr + offsetof(struct ethtool_gfeatures, size);
@@ -100,7 +110,12 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
-	netdev_features_t wanted = 0, valid = 0;
+	u32 requested_arr[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 valid_arr[ETHTOOL_DEV_FEATURE_WORDS];
+	__DECLARE_NETDEV_FEATURE_MASK(nochange);
+	__DECLARE_NETDEV_FEATURE_MASK(wanted);
+	__DECLARE_NETDEV_FEATURE_MASK(valid);
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	int i, ret = 0;
 
 	if (copy_from_user(&cmd, useraddr, sizeof(cmd)))
@@ -113,24 +128,35 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(features, useraddr, sizeof(features)))
 		return -EFAULT;
 
+	netdev_feature_zero(wanted);
+	netdev_feature_zero(valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		valid |= (netdev_features_t)features[i].valid << (32 * i);
-		wanted |= (netdev_features_t)features[i].requested << (32 * i);
+		requested_arr[i] = features[i].requested;
+		valid_arr[i] = features[i].valid;
 	}
+	bitmap_from_arr32(wanted, requested_arr, NETDEV_FEATURE_COUNT);
+	bitmap_from_arr32(valid, valid_arr, NETDEV_FEATURE_COUNT);
 
-	if (valid & ~NETIF_F_ETHTOOL_BITS)
+	netdev_feature_zero(nochange);
+	netdev_feature_set_bits(NETIF_F_NEVER_CHANGE, nochange);
+	if (netdev_feature_intersects(valid, nochange))
 		return -EINVAL;
 
-	if (valid & ~dev->hw_features) {
-		valid &= dev->hw_features;
+	netdev_feature_andnot(tmp, valid, dev->hw_features);
+	if (!netdev_feature_empty(tmp)) {
+		netdev_feature_and(valid, valid, dev->hw_features);
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
-	dev->wanted_features &= ~valid;
-	dev->wanted_features |= wanted & valid;
+	netdev_feature_andnot(dev->wanted_features, dev->wanted_features,
+			      valid);
+	netdev_feature_and(tmp, wanted, valid);
+	netdev_feature_or(dev->wanted_features, dev->wanted_features, tmp);
 	__netdev_update_features(dev);
 
-	if ((dev->wanted_features ^ dev->features) & valid)
+	netdev_feature_xor(tmp, dev->wanted_features, dev->features);
+	netdev_feature_and(tmp, tmp, valid);
+	if (!netdev_feature_empty(tmp))
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
@@ -195,34 +221,35 @@ static void __ethtool_get_strings(struct net_device *dev,
 		ops->get_strings(dev, stringset, data);
 }
 
-static void ethtool_get_feature_mask(u32 eth_cmd, netdev_features_t *mask)
+static void ethtool_get_feature_mask(u32 eth_cmd, netdev_features_t mask)
 {
 	/* feature masks of legacy discrete ethtool ops */
-
+	netdev_feature_zero(mask);
 	switch (eth_cmd) {
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
-		*mask = NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC | NETIF_F_SCTP_CRC;
+		netdev_feature_set_bits(NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC |
+					NETIF_F_SCTP_CRC, mask);
 		break;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
-		*mask = NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, mask);
 		break;
 	case ETHTOOL_GSG:
 	case ETHTOOL_SSG:
-		*mask = NETIF_F_SG | NETIF_F_FRAGLIST;
+		netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST, mask);
 		break;
 	case ETHTOOL_GTSO:
 	case ETHTOOL_STSO:
-		*mask = NETIF_F_ALL_TSO;
+		netdev_feature_set_bits(NETIF_F_ALL_TSO, mask);
 		break;
 	case ETHTOOL_GGSO:
 	case ETHTOOL_SGSO:
-		*mask = NETIF_F_GSO;
+		netdev_feature_set_bit(NETIF_F_GSO_BIT, mask);
 		break;
 	case ETHTOOL_GGRO:
 	case ETHTOOL_SGRO:
-		*mask = NETIF_F_GRO;
+		netdev_feature_set_bit(NETIF_F_GRO_BIT, mask);
 		break;
 	default:
 		BUG();
@@ -235,9 +262,9 @@ static int ethtool_get_one_feature(struct net_device *dev,
 	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct ethtool_value edata;
 
-	ethtool_get_feature_mask(ethcmd, &mask);
+	ethtool_get_feature_mask(ethcmd, mask);
 	edata.cmd = ethcmd;
-	edata.data = !!(dev->features & mask);
+	edata.data = netdev_feature_intersects(dev->features, mask);
 
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
 		return -EFAULT;
@@ -253,15 +280,17 @@ static int ethtool_set_one_feature(struct net_device *dev,
 	if (copy_from_user(&edata, useraddr, sizeof(edata)))
 		return -EFAULT;
 
-	ethtool_get_feature_mask(ethcmd, &mask);
-	mask &= dev->hw_features;
-	if (!mask)
+	ethtool_get_feature_mask(ethcmd, mask);
+	netdev_feature_and(mask, mask, dev->hw_features);
+	if (netdev_feature_empty(mask))
 		return -EOPNOTSUPP;
 
 	if (edata.data)
-		dev->wanted_features |= mask;
+		netdev_feature_and(dev->wanted_features, dev->wanted_features,
+				   mask);
 	else
-		dev->wanted_features &= ~mask;
+		netdev_feature_andnot(dev->wanted_features,
+				      dev->wanted_features, mask);
 
 	__netdev_update_features(dev);
 
@@ -278,15 +307,17 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 {
 	u32 flags = 0;
 
-	if (dev->features & NETIF_F_LRO)
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features))
 		flags |= ETH_FLAG_LRO;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				    dev->features))
 		flags |= ETH_FLAG_RXVLAN;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    dev->features))
 		flags |= ETH_FLAG_TXVLAN;
-	if (dev->features & NETIF_F_NTUPLE)
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, dev->features))
 		flags |= ETH_FLAG_NTUPLE;
-	if (dev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT, dev->features))
 		flags |= ETH_FLAG_RXHASH;
 
 	return flags;
@@ -294,29 +325,38 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
-	netdev_features_t features = 0, changed;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
 
+	netdev_feature_zero(features);
+
 	if (data & ETH_FLAG_LRO)
-		features |= NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, features);
 	if (data & ETH_FLAG_RXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
 	if (data & ETH_FLAG_TXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
 	if (data & ETH_FLAG_NTUPLE)
-		features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, features);
 	if (data & ETH_FLAG_RXHASH)
-		features |= NETIF_F_RXHASH;
+		netdev_feature_set_bit(NETIF_F_RXHASH_BIT, features);
 
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->features) & ETH_ALL_FEATURES;
-	if (changed & ~dev->hw_features)
-		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
-
-	dev->wanted_features =
-		(dev->wanted_features & ~changed) | (features & changed);
+	netdev_feature_xor(changed, features, dev->features);
+	netdev_feature_and_bits(ETH_ALL_FEATURES, changed);
+	netdev_feature_andnot(tmp, changed, dev->hw_features);
+	if (!netdev_feature_empty(tmp))
+		return netdev_feature_intersects(changed, dev->hw_features) ?
+			-EINVAL : -EOPNOTSUPP;
+
+	netdev_feature_andnot(dev->wanted_features, dev->wanted_features,
+			      changed);
+	netdev_feature_and(tmp, features, changed);
+	netdev_feature_or(dev->wanted_features, dev->wanted_features, tmp);
 
 	__netdev_update_features(dev);
 
@@ -2783,7 +2823,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 		if (rc < 0)
 			goto out;
 	}
-	old_features = dev->features;
+	netdev_feature_copy(old_features, dev->features);
 
 	switch (ethcmd) {
 	case ETHTOOL_GSET:
@@ -2998,7 +3038,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 	if (dev->ethtool_ops->complete)
 		dev->ethtool_ops->complete(dev);
 
-	if (old_features != dev->features)
+	if (!netdev_feature_equal(old_features, dev->features))
 		netdev_features_change(dev);
 out:
 	if (dev->dev.parent)
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 7a4c5e79eb5f..b853113579ea 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -178,12 +178,12 @@ static int hsr_dev_close(struct net_device *dev)
 }
 
 static void hsr_features_recompute(struct hsr_priv *hsr,
-				   netdev_features_t *features)
+				   netdev_features_t features)
 {
 	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct hsr_port *port;
 
-	netdev_feature_copy(&mask, *features);
+	netdev_feature_copy(mask, features);
 
 	/* Mask out all features that, if supported by one device, should be
 	 * enabled for all devices (see NETIF_F_ONE_FOR_ALL).
@@ -194,12 +194,12 @@ static void hsr_features_recompute(struct hsr_priv *hsr,
 	 */
 	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
 	hsr_for_each_port(hsr, port)
-		netdev_increment_features(features, *features,
+		netdev_increment_features(features, features,
 					  port->dev->features, mask);
 }
 
 static void hsr_fix_features(struct net_device *dev,
-			     netdev_features_t *features)
+			     netdev_features_t features)
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
 
@@ -445,25 +445,25 @@ void hsr_dev_setup(struct net_device *dev)
 
 	dev->needs_free_netdev = true;
 
-	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_zero(dev->hw_features);
 	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
 				NETIF_F_HIGHDMA |
 				NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
-				NETIF_F_HW_VLAN_CTAG_TX, &dev->hw_features);
+				NETIF_F_HW_VLAN_CTAG_TX, dev->hw_features);
 
-	netdev_feature_copy(&dev->features, dev->hw_features);
+	netdev_feature_copy(dev->features, dev->hw_features);
 
 	/* Prevent recursive tx locking */
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 
 	/* VLAN on top of HSR needs testing and probably some work on
 	 * hsr_header_create() etc.
 	 */
-	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, dev->features);
 	/* Not sure about this. Taken from bridge code. netdev_features.h says
 	 * it means "Does not change network namespaces".
 	 */
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features);
 }
 
 /* Return true if dev is a HSR master; return false otherwise.
diff --git a/net/ieee802154/6lowpan/core.c b/net/ieee802154/6lowpan/core.c
index 23a0b7e4474f..17e653b68f02 100644
--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -115,7 +115,7 @@ static void lowpan_setup(struct net_device *ldev)
 	ldev->netdev_ops	= &lowpan_netdev_ops;
 	ldev->header_ops	= &lowpan_header_ops;
 	ldev->needs_free_netdev	= true;
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &ldev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, ldev->features);
 }
 
 static int lowpan_validate(struct nlattr *tb[], struct nlattr *data[],
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 04d613a8e7c2..ff2ebf1f6da1 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -205,12 +205,12 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 		if (!wpan_dev->netdev)
 			continue;
 		netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
-					 &wpan_dev->netdev->features);
+					 wpan_dev->netdev->features);
 		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
 		if (err)
 			break;
 		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-				       &wpan_dev->netdev->features);
+				       wpan_dev->netdev->features);
 	}
 
 	if (err) {
@@ -223,12 +223,12 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			if (!wpan_dev->netdev)
 				continue;
 			netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
-						 &wpan_dev->netdev->features);
+						 wpan_dev->netdev->features);
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
 			WARN_ON(err);
 			netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-					       &wpan_dev->netdev->features);
+					       wpan_dev->netdev->features);
 		}
 
 		return err;
@@ -273,7 +273,7 @@ static int cfg802154_netdev_notifier_call(struct notifier_block *nb,
 	switch (state) {
 		/* TODO NETDEV_DEVTYPE */
 	case NETDEV_REGISTER:
-		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features);
 		wpan_dev->identifier = ++rdev->wpan_dev_id;
 		list_add_rcu(&wpan_dev->list, &rdev->wpan_dev_list);
 		rdev->devlist_generation++;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index e3384a815537..6912c925e453 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1295,7 +1295,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		err = PTR_ERR(rt);
 
 		/* Routing failed... */
-		netdev_feature_zero(&sk->sk_route_caps);
+		netdev_feature_zero(sk->sk_route_caps);
 		/*
 		 * Other protocols have to map its equivalent state to TCP_SYN_SENT.
 		 * DCCP maps its DCCP_REQUESTING state to TCP_SYN_SENT. -acme
@@ -1357,7 +1357,7 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		netdev_feature_and(&features, features,
+		netdev_feature_and(features, features,
 				   skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += ihl;
 
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 2c0b7a4e5489..be6d8b65589c 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -214,19 +214,19 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	netdev_feature_copy(&esp_features, features);
+	netdev_feature_copy(esp_features, features);
 	if ((!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT,
 				      skb->dev->gso_partial_features) &&
 	     !netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features)) ||
 	    x->xso.dev != skb->dev)
 		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_CSUM_MASK |
-					  NETIF_F_SCTP_CRC, &esp_features);
+					  NETIF_F_SCTP_CRC, esp_features);
 	else if (!netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
 					  features) &&
 		 !netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT,
 					  skb->dev->gso_partial_features))
 		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_SCTP_CRC,
-					  &esp_features);
+					  esp_features);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 65f22fa749be..7b14537ec3c9 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -43,10 +43,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
 	skb->encap_hdr_csum = need_csum;
 
-	netdev_feature_and(&features, features, skb->dev->hw_enc_features);
+	netdev_feature_and(features, features, skb->dev->hw_enc_features);
 
 	if (need_csum)
-		netdev_feature_clear_bit(NETIF_F_SCTP_CRC_BIT, &features);
+		netdev_feature_clear_bit(NETIF_F_SCTP_CRC_BIT, features);
 
 	need_ipsec = skb_dst(skb) && dst_xfrm(skb_dst(skb));
 	/* Try to offload checksum if possible */
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index e083ef6a8454..0a00cd4ee099 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -768,21 +768,21 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
 		    tunnel->encap.type == TUNNEL_ENCAP_NONE) {
 			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-						&dev->features);
+						dev->features);
 			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-						&dev->hw_features);
+						dev->hw_features);
 		} else {
 			netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
-						  &dev->features);
+						  dev->features);
 			netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
-						  &dev->hw_features);
+						  dev->hw_features);
 		}
-		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	} else {
 		netdev_feature_clear_bits(NETIF_F_GSO_SOFTWARE,
-					  &dev->hw_features);
+					  dev->hw_features);
 		netdev_feature_clear_bits(NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE,
-					  &dev->features);
+					  dev->features);
 	}
 }
 
@@ -964,8 +964,8 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
 	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
-	netdev_feature_set_bits(GRE_FEATURES, &dev->features);
-	netdev_feature_set_bits(GRE_FEATURES, &dev->hw_features);
+	netdev_feature_set_bits(GRE_FEATURES, dev->features);
+	netdev_feature_set_bits(GRE_FEATURES, dev->hw_features);
 
 	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
 		/* TCP offload with GRE SEQ is not supported, nor
@@ -975,15 +975,15 @@ static void __gre_tunnel_init(struct net_device *dev)
 		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
 		    (tunnel->encap.type == TUNNEL_ENCAP_NONE)) {
 			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-						&dev->features);
+						dev->features);
 			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-						&dev->hw_features);
+						dev->hw_features);
 		}
 
 		/* Can use a lockless transmit, unless we generate
 		 * output sequences
 		 */
-		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	}
 }
 
@@ -1311,8 +1311,8 @@ static int erspan_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen +
 		       erspan_hdr_len(tunnel->erspan_ver);
 
-	netdev_feature_set_bits(GRE_FEATURES, &dev->features);
-	netdev_feature_set_bits(GRE_FEATURES, &dev->hw_features);
+	netdev_feature_set_bits(GRE_FEATURES, dev->features);
+	netdev_feature_set_bits(GRE_FEATURES, dev->hw_features);
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE;
 	netif_keep_dst(dev);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8a065badcf2d..9f4f5c47d79b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -255,9 +255,9 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 *    bridged to a NETIF_F_TSO tunnel stacked over an interface with an
 	 *    insufficient MTU.
 	 */
-	netif_skb_features(skb, &features);
+	netif_skb_features(skb, features);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
-	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index ac5671e5ea28..1ba68f27c3fe 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -1073,7 +1073,7 @@ int ip_tunnel_init_net(struct net *net, unsigned int ip_tnl_net_id,
 	 */
 	if (!IS_ERR(itn->fb_tunnel_dev)) {
 		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-				       &itn->fb_tunnel_dev->features);
+				       itn->fb_tunnel_dev->features);
 
 		itn->fb_tunnel_dev->mtu = ip_tunnel_bind_dev(itn->fb_tunnel_dev);
 		ip_tunnel_add(itn, netdev_priv(itn->fb_tunnel_dev));
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index bf94ef6a1f2c..51ce35ac0d51 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -430,7 +430,7 @@ static int vti_tunnel_init(struct net_device *dev)
 
 	dev->flags		= IFF_NOARP;
 	dev->addr_len		= 4;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index b587d472fad5..186149241f25 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -368,11 +368,11 @@ static void ipip_tunnel_setup(struct net_device *dev)
 	dev->type		= ARPHRD_TUNNEL;
 	dev->flags		= IFF_NOARP;
 	dev->addr_len		= 4;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	netif_keep_dst(dev);
 
-	netdev_feature_set_bits(IPIP_FEATURES, &dev->features);
-	netdev_feature_set_bits(IPIP_FEATURES, &dev->hw_features);
+	netdev_feature_set_bits(IPIP_FEATURES, dev->features);
+	netdev_feature_set_bits(IPIP_FEATURES, dev->hw_features);
 	ip_tunnel_setup(dev, ipip_net_id);
 }
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 750a4a102014..1f8f8d78955c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -532,7 +532,7 @@ static void reg_vif_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &reg_vif_netdev_ops;
 	dev->needs_free_netdev	= true;
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features);
 }
 
 static struct net_device *ipmr_reg_vif(struct net *net, struct mr_table *mrt)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d573815a3186..6d0df63de53a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -457,8 +457,8 @@ void tcp_init_sock(struct sock *sk)
 	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
 
 	sk_sockets_allocated_inc(sk);
-	netdev_feature_zero(&sk->sk_route_forced_caps);
-	netdev_feature_set_bit(NETIF_F_GSO_BIT, &sk->sk_route_forced_caps);
+	netdev_feature_zero(sk->sk_route_forced_caps);
+	netdev_feature_set_bit(NETIF_F_GSO_BIT, sk->sk_route_forced_caps);
 }
 EXPORT_SYMBOL(tcp_init_sock);
 
@@ -1167,7 +1167,7 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 		if (err) {
 			tcp_set_state(sk, TCP_CLOSE);
 			inet->inet_dport = 0;
-			netdev_feature_zero(&sk->sk_route_caps);
+			netdev_feature_zero(sk->sk_route_caps);
 		}
 	}
 	flags = (msg->msg_flags & MSG_DONTWAIT) ? O_NONBLOCK : 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5b42b4e8e83f..29e85d3592b0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -323,7 +323,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
 	ip_rt_put(rt);
-	netdev_feature_zero(&sk->sk_route_caps);
+	netdev_feature_zero(sk->sk_route_caps);
 	inet->inet_dport = 0;
 	return err;
 }
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 2f4b7489f1a2..e602df5d59bb 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -82,8 +82,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb->len <= mss))
 		goto out;
 
-	netdev_feature_copy(&tmp, features);
-	netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, &tmp);
+	netdev_feature_copy(tmp, features);
+	netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, tmp);
 	if (skb_gso_ok(skb, tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e4c14e142bde..7cce9758bae1 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -71,18 +71,18 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 						   NETIF_F_IP_CSUM,
 						   skb->dev->features));
 
-	netdev_feature_and(&features, features, skb->dev->hw_enc_features);
+	netdev_feature_and(features, features, skb->dev->hw_enc_features);
 	if (need_csum)
-		netdev_feature_clear_bit(NETIF_F_SCTP_CRC_BIT, &features);
+		netdev_feature_clear_bit(NETIF_F_SCTP_CRC_BIT, features);
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
 	 * instead set the flag based on our outer checksum offload value.
 	 */
 	if (remcsum) {
-		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, &features);
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 		if (!need_csum || offload_csum)
-			netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
+			netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, features);
 	}
 
 	/* segment inner packet. */
@@ -418,7 +418,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 	 * software prior to segmenting the frame.
 	 */
 	if (!skb->encap_hdr_csum)
-		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, features);
 
 	/* Fragment the skb. IP headers of the fragments are updated in
 	 * inet_gso_segment()
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 94a4e1adce7b..e570b261a65d 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -833,7 +833,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 
 		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
-			netdev_feature_zero(&sk->sk_route_caps);
+			netdev_feature_zero(sk->sk_route_caps);
 			sk->sk_err_soft = -PTR_ERR(dst);
 			return PTR_ERR(dst);
 		}
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 3ce9360071f4..6b98681c04c4 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -253,14 +253,14 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	netdev_feature_copy(&esp_features, features);
+	netdev_feature_copy(esp_features, features);
 	if (!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features) ||
 	    x->xso.dev != skb->dev)
 		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_CSUM_MASK |
-					  NETIF_F_SCTP_CRC, &esp_features);
+					  NETIF_F_SCTP_CRC, esp_features);
 	else if (!netdev_feature_test_bit(NETIF_F_HW_ESP_TX_CSUM_BIT, features))
 		netdev_feature_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_SCTP_CRC,
-					  &esp_features);
+					  esp_features);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 6d8314846355..7e156bb8a941 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -121,7 +121,7 @@ int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl_unused
 	dst = inet6_csk_route_socket(sk, &fl6);
 	if (IS_ERR(dst)) {
 		sk->sk_err_soft = -PTR_ERR(dst);
-		netdev_feature_zero(&sk->sk_route_caps);
+		netdev_feature_zero(sk->sk_route_caps);
 		kfree_skb(skb);
 		return PTR_ERR(dst);
 	}
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 336ddf0b3586..8d053acc5797 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -385,7 +385,7 @@ static struct ip6_tnl *ip6gre_tunnel_locate(struct net *net,
 
 	/* Can use a lockless transmit, unless we generate output sequences */
 	if (!(nt->parms.o_flags & TUNNEL_SEQ))
-		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 
 	ip6gre_tunnel_link(ign, nt);
 	return nt;
@@ -1439,8 +1439,8 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 {
 	struct ip6_tnl *nt = netdev_priv(dev);
 
-	netdev_feature_set_bits(GRE6_FEATURES, &dev->features);
-	netdev_feature_set_bits(GRE6_FEATURES, &dev->hw_features);
+	netdev_feature_set_bits(GRE6_FEATURES, dev->features);
+	netdev_feature_set_bits(GRE6_FEATURES, dev->hw_features);
 
 	if (!(nt->parms.o_flags & TUNNEL_SEQ)) {
 		/* TCP offload with GRE SEQ is not supported, nor
@@ -1450,15 +1450,15 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 		if (!(nt->parms.o_flags & TUNNEL_CSUM) ||
 		    nt->encap.type == TUNNEL_ENCAP_NONE) {
 			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-						&dev->features);
+						dev->features);
 			netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE,
-						&dev->hw_features);
+						dev->hw_features);
 		}
 
 		/* Can use a lockless transmit, unless we generate
 		 * output sequences
 		 */
-		netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+		netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	}
 }
 
@@ -1601,7 +1601,7 @@ static int __net_init ip6gre_init_net(struct net *net)
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
 	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-			       &ign->fb_tunnel_dev->features);
+			       ign->fb_tunnel_dev->features);
 
 
 	ip6gre_fb_tunnel_init(ign->fb_tunnel_dev);
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 4c3ba4b4ba51..ee37ff87b942 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -93,7 +93,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		netdev_feature_and(&features, features,
+		netdev_feature_and(features, features,
 				   skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += sizeof(*ipv6h);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 72acb065abc0..40705f598d9b 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -146,8 +146,8 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 * describing the cases where GSO segment length exceeds the
 	 * egress MTU.
 	 */
-	netif_skb_features(skb, &features);
-	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	netif_skb_features(skb, features);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 012f3ad0e7c0..ebe8d5bf0027 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1833,11 +1833,11 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 	dev->type = ARPHRD_TUNNEL6;
 	dev->flags |= IFF_NOARP;
 	dev->addr_len = sizeof(struct in6_addr);
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	netif_keep_dst(dev);
 
-	netdev_feature_set_bits(IPXIPX_FEATURES, &dev->features);
-	netdev_feature_set_bits(IPXIPX_FEATURES, &dev->hw_features);
+	netdev_feature_set_bits(IPXIPX_FEATURES, dev->features);
+	netdev_feature_set_bits(IPXIPX_FEATURES, dev->hw_features);
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	dev->addr_assign_type = NET_ADDR_RANDOM;
@@ -2280,7 +2280,7 @@ static int __net_init ip6_tnl_init_net(struct net *net)
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
 	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-			       &ip6n->fb_tnl_dev->features);
+			       ip6n->fb_tnl_dev->features);
 
 	err = ip6_fb_tnl_dev_init(ip6n->fb_tnl_dev);
 	if (err < 0)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index daf2a4b13112..f261d27f8b4d 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -636,7 +636,7 @@ static void reg_vif_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &reg_vif_netdev_ops;
 	dev->needs_free_netdev	= true;
-	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features);
 }
 
 static struct net_device *ip6mr_reg_vif(struct net *net, struct mr_table *mrt)
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 58aa23267d41..32d105c890d9 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1438,9 +1438,9 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	netif_keep_dst(dev);
 	dev->addr_len		= 4;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
-	netdev_feature_set_bits(SIT_FEATURES, &dev->features);
-	netdev_feature_set_bits(SIT_FEATURES, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
+	netdev_feature_set_bits(SIT_FEATURES, dev->features);
+	netdev_feature_set_bits(SIT_FEATURES, dev->hw_features);
 }
 
 static int ipip6_tunnel_init(struct net_device *dev)
@@ -1919,7 +1919,7 @@ static int __net_init sit_init_net(struct net *net)
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
 	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-			       &sitn->fb_tunnel_dev->features);
+			       sitn->fb_tunnel_dev->features);
 
 	err = register_netdev(sitn->fb_tunnel_dev);
 	if (err)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 9152b6013a1d..0db35251cb64 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -341,7 +341,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	tcp_set_state(sk, TCP_CLOSE);
 failure:
 	inet->inet_dport = 0;
-	netdev_feature_zero(&sk->sk_route_caps);
+	netdev_feature_zero(sk->sk_route_caps);
 	return err;
 }
 
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 5911c603bd0b..9090d4380a68 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -69,7 +69,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		 * software prior to segmenting the frame.
 		 */
 		if (!skb->encap_hdr_csum)
-			netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &features);
+			netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, features);
 
 		/* Check if there is enough headroom to insert fragment header. */
 		tnl_hlen = skb_tnl_header_len(skb);
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 9fb916cec24e..d7e2b1ab548b 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -117,7 +117,7 @@ static void l2tp_eth_dev_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &l2tpeth_type);
 	ether_setup(dev);
 	dev->priv_flags		&= ~IFF_TX_SKB_SHARING;
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
 	dev->netdev_ops		= &l2tp_eth_netdev_ops;
 	dev->needs_free_netdev	= true;
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index fa5fc30db294..5980e3eb0620 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2040,11 +2040,11 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		if (type == NL80211_IFTYPE_STATION)
 			sdata->u.mgd.use_4addr = params->use_4addr;
 
-		netdev_feature_or(&ndev->features, ndev->features,
+		netdev_feature_or(ndev->features, ndev->features,
 				  local->hw.netdev_features);
-		netdev_feature_copy(&tmp, ndev->features);
-		netdev_feature_and_bits(MAC80211_SUPPORTED_FEATURES_TX, &tmp);
-		netdev_feature_or(&ndev->hw_features, ndev->hw_features, tmp);
+		netdev_feature_copy(tmp, ndev->features);
+		netdev_feature_and_bits(MAC80211_SUPPORTED_FEATURES_TX, tmp);
+		netdev_feature_or(ndev->hw_features, ndev->hw_features, tmp);
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0cc11097f3ae..e72a72ae3f13 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -961,8 +961,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	}
 
 	/* Only HW csum features are currently compatible with mac80211 */
-	netdev_feature_copy(&tmp, hw->netdev_features);
-	netdev_feature_clear_bits(MAC80211_SUPPORTED_FEATURES, &tmp);
+	netdev_feature_copy(tmp, hw->netdev_features);
+	netdev_feature_clear_bits(MAC80211_SUPPORTED_FEATURES, tmp);
 	if (WARN_ON(!netdev_feature_empty(tmp)))
 		return -EINVAL;
 
diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index 8d733c4427bd..1d945f4df9a9 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -43,7 +43,7 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	/* Segment inner packet. */
-	netdev_feature_and(&mpls_features, skb->dev->mpls_features, features);
+	netdev_feature_and(mpls_features, skb->dev->mpls_features, features);
 	segs = skb_mac_gso_segment(skb, mpls_features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, mpls_protocol, mpls_hlen, mac_offset,
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index 9cc1b15891ef..edac8c2d1ff2 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -104,7 +104,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb->mac_len = proto == htons(ETH_P_TEB) ? ETH_HLEN : 0;
 	skb->protocol = proto;
 
-	netdev_feature_and_bits(NETIF_F_SG, &features);
+	netdev_feature_and_bits(NETIF_F_SG, features);
 	segs = skb_mac_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index aad26e4cd2cb..8c1068c825c1 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -324,8 +324,8 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 	int err;
 
 	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
-	netdev_feature_zero(&feature);
-	netdev_feature_set_bit(NETIF_F_SG_BIT, &feature);
+	netdev_feature_zero(feature);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, feature);
 	segs = __skb_gso_segment(skb, feature, false);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 27b7322be008..35b86fa528ad 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -108,19 +108,19 @@ static void do_setup(struct net_device *netdev)
 	netdev->ethtool_ops = &internal_dev_ethtool_ops;
 	netdev->rtnl_link_ops = &internal_dev_link_ops;
 
-	netdev_feature_zero(&netdev->features);
+	netdev_feature_zero(netdev->features);
 	netdev_feature_set_bits(NETIF_F_LLTX | NETIF_F_SG | NETIF_F_FRAGLIST |
 				NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
 				NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL,
-				&netdev->features);
+				netdev->features);
 
-	netdev_feature_copy(&netdev->vlan_features, netdev->features);
-	netdev_feature_copy(&netdev->hw_enc_features, netdev->features);
+	netdev_feature_copy(netdev->vlan_features, netdev->features);
+	netdev_feature_copy(netdev->hw_enc_features, netdev->features);
 	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
 				NETIF_F_HW_VLAN_STAG_TX,
-				&netdev->features);
-	netdev_feature_copy(&netdev->hw_features, netdev->features);
-	netdev_feature_clear_bit(NETIF_F_LLTX_BIT, &netdev->hw_features);
+				netdev->features);
+	netdev_feature_copy(netdev->hw_features, netdev->features);
+	netdev_feature_clear_bit(NETIF_F_LLTX_BIT, netdev->hw_features);
 
 	eth_hw_addr_random(netdev);
 }
@@ -158,7 +158,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 	/* Restrict bridge port to current netns. */
 	if (vport->port_no == OVSP_LOCAL)
 		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-				       &vport->dev->features);
+				       vport->dev->features);
 
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
diff --git a/net/phonet/pep-gprs.c b/net/phonet/pep-gprs.c
index 0f6e6c1f3ec1..92417003d0fd 100644
--- a/net/phonet/pep-gprs.c
+++ b/net/phonet/pep-gprs.c
@@ -212,8 +212,8 @@ static const struct net_device_ops gprs_netdev_ops = {
 
 static void gprs_setup(struct net_device *dev)
 {
-	netdev_feature_zero(&dev->features);
-	netdev_feature_set_bit(NETIF_F_FRAGLIST_BIT, &dev->features);
+	netdev_feature_zero(dev->features);
+	netdev_feature_set_bit(NETIF_F_FRAGLIST_BIT, dev->features);
 	dev->type		= ARPHRD_PHONET_PIPE;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= GPRS_DEFAULT_MTU;
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index fc45f242381e..c3a433b50d73 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1743,8 +1743,8 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		struct sk_buff *segs, *nskb;
 		unsigned int slen = 0, numsegs = 0;
 
-		netif_skb_features(skb, &features);
-		netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+		netif_skb_features(skb, features);
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 313591a9c879..16248784e36f 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -415,8 +415,8 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *segs;
 
-	netif_skb_features(skb, &features);
-	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	netif_skb_features(skb, features);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs)) {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 2ff999208324..7ac56b916a86 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -457,8 +457,8 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		struct sk_buff *segs, *nskb;
 		int ret;
 
-		netif_skb_features(skb, &features);
-		netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+		netif_skb_features(skb, features);
+		netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 6b6b347da52f..4e90910ff999 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -196,8 +196,8 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
 	int ret, nb;
 
-	netif_skb_features(skb, &features);
-	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
+	netif_skb_features(skb, features);
+	netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs))
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index 10d569bd9ef8..2f98e5516c0b 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -51,8 +51,8 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 
 	__skb_pull(skb, sizeof(*sh));
 
-	netdev_feature_copy(&tmp, features);
-	netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, &tmp);
+	netdev_feature_copy(tmp, features);
+	netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, tmp);
 	if (skb_gso_ok(skb, tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 		struct skb_shared_info *pinfo = skb_shinfo(skb);
@@ -71,9 +71,9 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 		goto out;
 	}
 
-	netdev_feature_copy(&tmp, features);
-	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &tmp);
-	netdev_feature_clear_bit(NETIF_F_SG_BIT, &tmp);
+	netdev_feature_copy(tmp, features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, tmp);
+	netdev_feature_clear_bit(NETIF_F_SG_BIT, tmp);
 	segs = skb_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto out;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5849ebf7ca5f..5c179a254b79 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -165,12 +165,12 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		if (!wdev->netdev)
 			continue;
 		netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
-					 &wdev->netdev->features);
+					 wdev->netdev->features);
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
 		if (err)
 			break;
 		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-				       &wdev->netdev->features);
+				       wdev->netdev->features);
 	}
 
 	if (err) {
@@ -183,12 +183,12 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			if (!wdev->netdev)
 				continue;
 			netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
-						 &wdev->netdev->features);
+						 wdev->netdev->features);
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
 			WARN_ON(err);
 			netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-					       &wdev->netdev->features);
+					       wdev->netdev->features);
 		}
 
 		return err;
@@ -1388,8 +1388,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
 		wdev->netdev = dev;
 		/* can only change netns with wiphy */
-		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
-				       &dev->features);
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, dev->features);
 
 		cfg80211_init_wdev(wdev);
 		break;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index e3eeef8bfe89..a42fc5e1b587 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -112,12 +112,12 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (!xo || (xo->flags & XFRM_XMIT))
 		return skb;
 
-	netdev_feature_copy(&esp_features, features);
+	netdev_feature_copy(esp_features, features);
 
 	if (!netdev_feature_test_bit(NETIF_F_HW_ESP_BIT, features)) {
-		netdev_feature_copy(&esp_features, features);
+		netdev_feature_copy(esp_features, features);
 		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_CSUM_MASK,
-					  &esp_features);
+					  esp_features);
 	}
 
 	sp = skb_sec_path(skb);
@@ -144,7 +144,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 		/* Packet got rerouted, fixup features and segment it. */
 		netdev_feature_clear_bits(NETIF_F_HW_ESP | NETIF_F_GSO_ESP,
-					  &esp_features);
+					  esp_features);
 
 		segs = skb_gso_segment(skb, esp_features);
 		if (IS_ERR(segs)) {
@@ -158,7 +158,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	if (!skb->next) {
-		netdev_feature_or(&esp_features, esp_features,
+		netdev_feature_or(esp_features, esp_features,
 				  skb->dev->gso_partial_features);
 		xfrm_outer_mode_prep(x, skb);
 
@@ -180,7 +180,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	}
 
 	skb_list_walk_safe(skb, skb2, nskb) {
-		netdev_feature_or(&esp_features, esp_features,
+		netdev_feature_or(esp_features, esp_features,
 				  skb->dev->gso_partial_features);
 		skb_mark_not_on_list(skb2);
 
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index e14068d45b19..f87029ee805a 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -590,9 +590,9 @@ static int xfrmi_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
-	netdev_feature_set_bits(XFRMI_FEATURES, &dev->features);
-	netdev_feature_set_bits(XFRMI_FEATURES, &dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, dev->features);
+	netdev_feature_set_bits(XFRMI_FEATURES, dev->features);
+	netdev_feature_set_bits(XFRMI_FEATURES, dev->hw_features);
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.33.0

