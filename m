Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE873EAE43
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 03:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238366AbhHMBts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 21:49:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8014 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238309AbhHMBtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 21:49:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gm60r1G6szYp3R;
        Fri, 13 Aug 2021 09:49:00 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 09:49:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 09:49:17 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <moyufeng@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: [RFC V3 net-next 0/4] ethtool: extend coalesce uAPI
Date:   Fri, 13 Aug 2021 09:45:25 +0800
Message-ID: <1628819129-23332-1-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support some configuration in coalesce uAPI, this RFC
extends coalesce uAPI and add support for CQE mode.

Below is some test result with HNS3 driver:
1. old ethtool(ioctl) + new kernel:
estuary:/$ ethtool -c eth0
Coalesce parameters for eth0:
Adaptive RX: on  TX: on
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 20
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 20
tx-frames: 0
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frame-low: 0
tx-usecs-low: 0
tx-frame-low: 0

rx-usecs-high: 0
rx-frame-high: 0
tx-usecs-high: 0
tx-frame-high: 0

2. ethtool(netlink with cqe mode) + kernel without cqe mode:
estuary:/$ ethtool -c eth0
Coalesce parameters for eth0:
Adaptive RX: on  TX: on
stats-block-usecs: n/a
sample-interval: n/a
pkt-rate-low: n/a
pkt-rate-high: n/a

rx-usecs: 20
rx-frames: 0
rx-usecs-irq: n/a
rx-frames-irq: n/a

tx-usecs: 20
tx-frames: 0
tx-usecs-irq: n/a
tx-frames-irq: n/a

rx-usecs-low: n/a
rx-frame-low: n/a
tx-usecs-low: n/a
tx-frame-low: n/a

rx-usecs-high: 0
rx-frame-high: n/a
tx-usecs-high: 0
tx-frame-high: n/a

CQE mode RX: n/a  TX: n/a

3. ethool(netlink with cqe mode) + kernel with cqe mode:
estuary:/$ ethtool -c eth0
Coalesce parameters for eth0:
Adaptive RX: on  TX: on
stats-block-usecs: n/a
sample-interval: n/a
pkt-rate-low: n/a
pkt-rate-high: n/a

rx-usecs: 20
rx-frames: 0
rx-usecs-irq: n/a
rx-frames-irq: n/a

tx-usecs: 20
tx-frames: 0
tx-usecs-irq: n/a
tx-frames-irq: n/a

rx-usecs-low: n/a
rx-frame-low: n/a
tx-usecs-low: n/a
tx-frame-low: n/a

rx-usecs-high: 0
rx-frame-high: n/a
tx-usecs-high: 0
tx-frame-high: n/a

CQE mode RX: off  TX: off

4. ethool(netlink without cqe mode) + kernel with cqe mode:
estuary:/$ ethtool -c eth0
Coalesce parameters for eth0:
Adaptive RX: on  TX: on
stats-block-usecs: n/a
sample-interval: n/a
pkt-rate-low: n/a
pkt-rate-high: n/a

rx-usecs: 20
rx-frames: 0
rx-usecs-irq: n/a
rx-frames-irq: n/a

tx-usecs: 20
tx-frames: 0
tx-usecs-irq: n/a
tx-frames-irq: n/a

rx-usecs-low: n/a
rx-frame-low: n/a
tx-usecs-low: n/a
tx-frame-low: n/a

rx-usecs-high: 0
rx-frame-high: n/a
tx-usecs-high: 0
tx-frame-high: n/a

Change log:
V2 -> V3:
         1. split #1 into adding new parameter and adding new attributes.
         2. use NLA_POLICY_MAX(NLA_U8, 1) instead of NLA_U8.
         3. modify the description of CQE in Document. 

V1 -> V2:
         refactor #1&#2 in V1 suggestted by Jakub Kicinski.

Yufeng Mo (4):
  ethtool: add two coalesce attributes for CQE mode
  ethtool: extend coalesce setting uAPI with CQE mode
  net: hns3: add support for EQE/CQE mode configuration
  net: hns3: add ethtool support for CQE/EQE mode configuration

 Documentation/networking/ethtool-netlink.rst       |  8 ++++
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |  8 +++-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |  8 +++-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |  8 +++-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |  8 +++-
 drivers/net/ethernet/broadcom/bcmsysport.c         |  8 +++-
 drivers/net/ethernet/broadcom/bnx2.c               | 12 ++++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |  8 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  8 +++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  8 +++-
 drivers/net/ethernet/broadcom/tg3.c                | 10 ++++-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    | 12 ++++--
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c |  8 +++-
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |  4 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |  8 +++-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  8 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |  8 +++-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  8 +++-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |  8 +++-
 drivers/net/ethernet/cortina/gemini.c              |  8 +++-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  8 +++-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 +++-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  8 +++-
 drivers/net/ethernet/freescale/fec_main.c          | 14 ++++---
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  8 +++-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  8 +++-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  8 +++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 49 +++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 11 +++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 26 ++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |  8 +++-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |  8 +++-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  8 +++-
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c   |  8 +++-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  8 +++-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  8 +++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       | 12 ++++--
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |  8 +++-
 drivers/net/ethernet/intel/igbvf/ethtool.c         |  8 +++-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  8 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |  8 +++-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |  8 +++-
 drivers/net/ethernet/jme.c                         | 12 ++++--
 drivers/net/ethernet/marvell/mv643xx_eth.c         | 12 ++++--
 drivers/net/ethernet/marvell/mvneta.c              | 14 +++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    | 14 +++++--
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  8 +++-
 drivers/net/ethernet/marvell/skge.c                |  8 +++-
 drivers/net/ethernet/marvell/sky2.c                |  8 +++-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  8 +++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  8 +++-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  8 +++-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   | 12 ++++--
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  8 +++-
 drivers/net/ethernet/ni/nixge.c                    | 14 +++++--
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  8 +++-
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |  8 +++-
 drivers/net/ethernet/qlogic/qede/qede.h            |  4 +-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |  8 +++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  8 +++-
 drivers/net/ethernet/realtek/r8169_main.c          | 10 ++++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c |  8 +++-
 drivers/net/ethernet/sfc/ethtool.c                 |  8 +++-
 drivers/net/ethernet/sfc/falcon/ethtool.c          |  8 +++-
 drivers/net/ethernet/socionext/netsec.c            | 10 +++--
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  8 +++-
 drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c | 14 +++++--
 drivers/net/ethernet/tehuti/tehuti.c               | 12 ++++--
 drivers/net/ethernet/ti/cpsw.c                     |  2 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c             |  8 +++-
 drivers/net/ethernet/ti/cpsw_new.c                 |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |  8 +++-
 drivers/net/ethernet/ti/davinci_emac.c             |  8 +++-
 drivers/net/ethernet/via/via-velocity.c            |  8 +++-
 drivers/net/ethernet/xilinx/ll_temac_main.c        | 14 +++++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 14 +++++--
 drivers/net/netdevsim/ethtool.c                    |  8 +++-
 drivers/net/tun.c                                  |  8 +++-
 drivers/net/usb/r8152.c                            |  8 +++-
 drivers/net/virtio_net.c                           |  8 +++-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              | 12 ++++--
 drivers/net/wireless/ath/wil6210/ethtool.c         | 14 +++++--
 drivers/s390/net/qeth_ethtool.c                    |  4 +-
 drivers/staging/qlge/qlge_ethtool.c                | 10 ++++-
 include/linux/ethtool.h                            | 22 ++++++++--
 include/uapi/linux/ethtool_netlink.h               |  2 +
 net/ethtool/coalesce.c                             | 29 ++++++++++---
 net/ethtool/ioctl.c                                | 15 +++++--
 net/ethtool/netlink.h                              |  2 +-
 93 files changed, 671 insertions(+), 208 deletions(-)

-- 
2.8.1

