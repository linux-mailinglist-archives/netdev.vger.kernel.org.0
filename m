Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E27D4176D8
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 16:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346812AbhIXOfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 10:35:52 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:17191 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhIXOft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 10:35:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HGDyw00PWz1DH9q;
        Fri, 24 Sep 2021 22:32:55 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:07 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>,
        <linux-s390@vger.kernel.org>
Subject: [PATCH V2 net-next 0/6] ethtool: add support to set/get tx copybreak buf size and rx buf len
Date:   Fri, 24 Sep 2021 22:29:53 +0800
Message-ID: <20210924142959.7798-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support to set/get tx copybreak buf size and rx buf len via
ethtool and hns3 driver implements them.

Tx copybreak buf size is used for tx copybreak feature which for small size
packet or frag. Use ethtool --get-tunable command to get it, and ethtool
--set-tunable command to set it, examples are as follow:

1. set tx spare buf size to 102400:
$ ethtool --set-tunable eth1 tx-buf-size 102400

2. get tx spare buf size:
$ ethtool --get-tunable eth1 tx-buf-size
tx-buf-size: 102400

Rx buf len is buffer length of each rx BD. Use ethtool -g command to get
it, and ethtool -G command to set it, examples are as follow:

1. set rx buf len to 4096
$ ethtool -G eth1 rx-buf-len 4096

2. get rx buf len
$ ethtool -g eth1
...
RX Buf Len:     4096


Change log:
V1 -> V2
1.Add documentation for rx buf len and tx copybreak buf size.
2.Extend structure ringparam_ext for extenal ring params.
3.Change type of ETHTOOL_A_RINGS_RX_BUF_LEN from NLA_U32 to
  NLA_POLICY_MIN(NLA_U32, 1).
4.Add supported_ring_params in ethtool_ops to indicate if support external
  params.



Hao Chen (6):
  ethtool: add support to set/get tx copybreak buf size via ethtool
  net: hns3: add support to set/get tx copybreak buf size via ethtool
    for hns3 driver
  ethtool: add support to set/get rx buf len via ethtool
  ethtool: extend ringparam setting uAPI with rx_buf_len
  net: hns3: add support to set/get rx buf len via ethtool for hns3
    driver
  net: hns3: remove the way to set tx spare buf via module parameter

 Documentation/networking/ethtool-netlink.rst  |  26 ++++
 arch/um/drivers/vector_kern.c                 |   4 +-
 drivers/net/can/c_can/c_can_ethtool.c         |   4 +-
 drivers/net/ethernet/3com/typhoon.c           |   4 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   8 +-
 drivers/net/ethernet/amd/pcnet32.c            |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  |   8 +-
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   8 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |   8 +-
 drivers/net/ethernet/broadcom/b44.c           |   8 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c  |  16 ++-
 drivers/net/ethernet/broadcom/bnx2.c          |   8 +-
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |   8 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   8 +-
 drivers/net/ethernet/broadcom/tg3.c           |  10 +-
 .../net/ethernet/brocade/bna/bnad_ethtool.c   |   8 +-
 drivers/net/ethernet/cadence/macb_main.c      |   8 +-
 .../ethernet/cavium/liquidio/lio_ethtool.c    |   8 +-
 .../ethernet/cavium/thunder/nicvf_ethtool.c   |   8 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |   8 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |   8 +-
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |   8 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |   8 +-
 .../net/ethernet/cisco/enic/enic_ethtool.c    |   8 +-
 drivers/net/ethernet/cortina/gemini.c         |   8 +-
 .../net/ethernet/emulex/benet/be_ethtool.c    |   4 +-
 drivers/net/ethernet/ethoc.c                  |   8 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |   8 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   4 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |   8 +-
 .../net/ethernet/freescale/ucc_geth_ethtool.c |   8 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |   4 +-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  11 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   2 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 116 ++++++++++++++++--
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |   8 +-
 drivers/net/ethernet/ibm/emac/core.c          |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |   8 +-
 drivers/net/ethernet/intel/e100.c             |   8 +-
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |   8 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c   |   8 +-
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |   8 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   8 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  12 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   8 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   8 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c    |   8 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   8 +-
 .../net/ethernet/intel/ixgb/ixgb_ethtool.c    |   8 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |   8 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |   8 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   8 +-
 drivers/net/ethernet/marvell/mvneta.c         |   8 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   8 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   8 +-
 drivers/net/ethernet/marvell/skge.c           |   8 +-
 drivers/net/ethernet/marvell/sky2.c           |   8 +-
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   8 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   8 +-
 .../mellanox/mlx5/core/ipoib/ethtool.c        |   8 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c  |   4 +-
 drivers/net/ethernet/micrel/ksz884x.c         |   5 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |   4 +-
 drivers/net/ethernet/neterion/s2io.c          |   4 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |   8 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  10 +-
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |  10 +-
 .../net/ethernet/pasemi/pasemi_mac_ethtool.c  |   4 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   8 +-
 .../qlogic/netxen/netxen_nic_ethtool.c        |   8 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |   8 +-
 .../ethernet/qlogic/qlcnic/qlcnic_ethtool.c   |   8 +-
 .../net/ethernet/qualcomm/emac/emac-ethtool.c |   8 +-
 drivers/net/ethernet/qualcomm/qca_debug.c     |   8 +-
 drivers/net/ethernet/realtek/8139cp.c         |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c     |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c      |   8 +-
 drivers/net/ethernet/renesas/sh_eth.c         |   8 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c      |   4 +-
 drivers/net/ethernet/sfc/ethtool.c            |   8 +-
 drivers/net/ethernet/sfc/falcon/ethtool.c     |   8 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   8 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  10 +-
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c   |   4 +-
 drivers/net/ethernet/ti/cpmac.c               |   8 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c        |   8 +-
 drivers/net/ethernet/ti/cpsw_priv.h           |   8 +-
 .../net/ethernet/toshiba/spider_net_ethtool.c |   4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  14 ++-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  14 ++-
 drivers/net/hyperv/netvsc_drv.c               |   8 +-
 drivers/net/netdevsim/ethtool.c               |   8 +-
 drivers/net/usb/r8152.c                       |   8 +-
 drivers/net/virtio_net.c                      |   4 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |   8 +-
 drivers/s390/net/qeth_ethtool.c               |   4 +-
 include/linux/ethtool.h                       |  18 ++-
 include/uapi/linux/ethtool.h                  |   9 ++
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/common.c                          |   1 +
 net/ethtool/ioctl.c                           |  10 +-
 net/ethtool/netlink.h                         |   2 +-
 net/ethtool/rings.c                           |  32 ++++-
 net/mac80211/ethtool.c                        |   8 +-
 106 files changed, 738 insertions(+), 205 deletions(-)

-- 
2.33.0

