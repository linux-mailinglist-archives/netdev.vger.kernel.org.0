Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3210394A18
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 05:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhE2DYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 23:24:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2519 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhE2DYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 23:24:12 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FsRcn2McVzYr85;
        Sat, 29 May 2021 11:19:53 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 11:22:33 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 11:22:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jesse.brandeburg@intel.com>,
        <jacob.e.keller@intel.com>, <ioana.ciornei@nxp.com>,
        <vladimir.oltean@nxp.com>, <sgoutham@marvell.com>,
        <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: [RFC V2 net-next 1/3] ethtool: extend coalesce setting uAPI with CQE mode
Date:   Sat, 29 May 2021 11:22:14 +0800
Message-ID: <1622258536-55776-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
References: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there many drivers who support CQE mode configuration,
some configure it as a fixed when initialized, some provide an
interface to change it by ethtool private flags. In order make it
more generic, add two new 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
'ETHTOOL_A_COALESCE_USE_CQE_RX' coalesce attributes, then these
parameters can be accessed by ethtool netlink coalesce uAPI.

In order to support more coalesce parameters through netlink,
add an new structure kernel_ethtool_coalesce, and keep
struct ethtool_coalesce as the base(legacy) part, then the
new parameter can be added into struct kernel_ethtool_coalesce.

Also add new extack parameter for .set_coalesce and .get_coalesce
then some extra info can return to user with the netlink API.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 Documentation/networking/ethtool-netlink.rst       |  4 +++
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |  8 ++++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |  8 ++++--
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |  8 ++++--
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |  8 ++++--
 drivers/net/ethernet/broadcom/bcmsysport.c         |  8 ++++--
 drivers/net/ethernet/broadcom/bnx2.c               | 12 ++++++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |  8 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  8 ++++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  8 ++++--
 drivers/net/ethernet/broadcom/tg3.c                | 10 ++++++--
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    | 12 ++++++---
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c |  8 ++++--
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |  4 ++-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |  8 ++++--
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  8 ++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |  8 ++++--
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  8 ++++--
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |  8 ++++--
 drivers/net/ethernet/cortina/gemini.c              |  8 ++++--
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  8 ++++--
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++++--
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  8 ++++--
 drivers/net/ethernet/freescale/fec_main.c          | 14 +++++++----
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  8 ++++--
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  8 ++++--
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  8 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  8 ++++--
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |  8 ++++--
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |  8 ++++--
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  8 ++++--
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c   |  8 ++++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  8 ++++--
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  8 ++++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c       | 12 ++++++---
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |  8 ++++--
 drivers/net/ethernet/intel/igbvf/ethtool.c         |  8 ++++--
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  8 ++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |  8 ++++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |  8 ++++--
 drivers/net/ethernet/jme.c                         | 12 ++++++---
 drivers/net/ethernet/marvell/mv643xx_eth.c         | 12 ++++++---
 drivers/net/ethernet/marvell/mvneta.c              |  8 ++++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  8 ++++--
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  8 ++++--
 drivers/net/ethernet/marvell/skge.c                |  8 ++++--
 drivers/net/ethernet/marvell/sky2.c                |  8 ++++--
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  8 ++++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  8 ++++--
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  8 ++++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   | 12 ++++++---
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  8 ++++--
 drivers/net/ethernet/ni/nixge.c                    |  8 ++++--
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  8 ++++--
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |  8 ++++--
 drivers/net/ethernet/qlogic/qede/qede.h            |  4 ++-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |  8 ++++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  8 ++++--
 drivers/net/ethernet/realtek/r8169_main.c          | 10 ++++++--
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c |  8 ++++--
 drivers/net/ethernet/sfc/ethtool.c                 |  8 ++++--
 drivers/net/ethernet/sfc/falcon/ethtool.c          |  8 ++++--
 drivers/net/ethernet/socionext/netsec.c            | 10 +++++---
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  8 ++++--
 drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c |  8 ++++--
 drivers/net/ethernet/tehuti/tehuti.c               | 12 ++++++---
 drivers/net/ethernet/ti/cpsw.c                     |  2 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c             |  8 ++++--
 drivers/net/ethernet/ti/cpsw_new.c                 |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |  8 ++++--
 drivers/net/ethernet/ti/davinci_emac.c             |  8 ++++--
 drivers/net/ethernet/via/via-velocity.c            |  8 ++++--
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  8 ++++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  8 ++++--
 drivers/net/netdevsim/ethtool.c                    |  8 ++++--
 drivers/net/tun.c                                  |  8 ++++--
 drivers/net/usb/r8152.c                            |  8 ++++--
 drivers/net/virtio_net.c                           |  8 ++++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c              | 12 ++++++---
 drivers/net/wireless/ath/wil6210/ethtool.c         |  8 ++++--
 drivers/s390/net/qeth_ethtool.c                    |  4 ++-
 drivers/staging/qlge/qlge_ethtool.c                | 10 ++++++--
 include/linux/ethtool.h                            | 22 +++++++++++++---
 include/uapi/linux/ethtool_netlink.h               |  2 ++
 net/ethtool/coalesce.c                             | 29 ++++++++++++++++++----
 net/ethtool/ioctl.c                                | 15 ++++++++---
 net/ethtool/netlink.h                              |  2 +-
 88 files changed, 561 insertions(+), 191 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 25131df..8e8c6b3 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -937,6 +937,8 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    timer reset in CQE, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    timer reset in CQE, Rx
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
@@ -975,6 +977,8 @@ Request contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    timer reset in CQE, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    timer reset in CQE, Rx
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 823f683..a09ca21 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -72,7 +72,9 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
 }
 
 static int ipoib_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
@@ -83,7 +85,9 @@ static int ipoib_get_coalesce(struct net_device *dev,
 }
 
 static int ipoib_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	int ret;
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 2fe7cce..17c966f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -353,7 +353,9 @@ static int ena_get_link_ksettings(struct net_device *netdev,
 }
 
 static int ena_get_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *coalesce)
+			    struct ethtool_coalesce *coalesce,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
@@ -398,7 +400,9 @@ static void ena_update_rx_rings_nonadaptive_intr_moderation(struct ena_adapter *
 }
 
 static int ena_set_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *coalesce)
+			    struct ethtool_coalesce *coalesce,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 61f39a0..bafc51c3 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -428,7 +428,9 @@ static void xgbe_set_msglevel(struct net_device *netdev, u32 msglevel)
 }
 
 static int xgbe_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 
@@ -443,7 +445,9 @@ static int xgbe_get_coalesce(struct net_device *netdev,
 }
 
 static int xgbe_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index de2a934..a9ef054 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -547,7 +547,9 @@ static int aq_ethtool_set_rxnfc(struct net_device *ndev,
 }
 
 static int aq_ethtool_get_coalesce(struct net_device *ndev,
-				   struct ethtool_coalesce *coal)
+				   struct ethtool_coalesce *coal,
+				   struct kernel_ethtool_coalesce *kernel_coal,
+				   struct netlink_ext_ack *extack)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
@@ -571,7 +573,9 @@ static int aq_ethtool_get_coalesce(struct net_device *ndev,
 }
 
 static int aq_ethtool_set_coalesce(struct net_device *ndev,
-				   struct ethtool_coalesce *coal)
+				   struct ethtool_coalesce *coal,
+				   struct kernel_ethtool_coalesce *kernel_coal,
+				   struct netlink_ext_ack *extack)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index d9f0f0d..7fa1b695 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -607,7 +607,9 @@ static void bcm_sysport_set_tx_coalesce(struct bcm_sysport_tx_ring *ring,
 }
 
 static int bcm_sysport_get_coalesce(struct net_device *dev,
-				    struct ethtool_coalesce *ec)
+				    struct ethtool_coalesce *ec,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	u32 reg;
@@ -627,7 +629,9 @@ static int bcm_sysport_get_coalesce(struct net_device *dev,
 }
 
 static int bcm_sysport_set_coalesce(struct net_device *dev,
-				    struct ethtool_coalesce *ec)
+				    struct ethtool_coalesce *ec,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct dim_cq_moder moder;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index bee6cfa..b23936d 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7241,8 +7241,10 @@ bnx2_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	return rc;
 }
 
-static int
-bnx2_get_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+static int bnx2_get_coalesce(struct net_device *dev,
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
@@ -7263,8 +7265,10 @@ bnx2_get_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
 	return 0;
 }
 
-static int
-bnx2_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+static int bnx2_set_coalesce(struct net_device *dev,
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 32245bb..472a3a4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1878,7 +1878,9 @@ static int bnx2x_set_eeprom(struct net_device *dev,
 }
 
 static int bnx2x_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
@@ -1891,7 +1893,9 @@ static int bnx2x_get_coalesce(struct net_device *dev,
 }
 
 static int bnx2x_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c664ec5..8b368ba 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -45,7 +45,9 @@ static void bnxt_set_msglevel(struct net_device *dev, u32 value)
 }
 
 static int bnxt_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_coal *hw_coal;
@@ -75,7 +77,9 @@ static int bnxt_get_coalesce(struct net_device *dev,
 }
 
 static int bnxt_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	bool update_stats = false;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023..9dbbfd0 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -828,7 +828,9 @@ static void bcmgenet_set_msglevel(struct net_device *dev, u32 level)
 }
 
 static int bcmgenet_get_coalesce(struct net_device *dev,
-				 struct ethtool_coalesce *ec)
+				 struct ethtool_coalesce *ec,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rx_ring *ring;
@@ -890,7 +892,9 @@ static void bcmgenet_set_ring_rx_coalesce(struct bcmgenet_rx_ring *ring,
 }
 
 static int bcmgenet_set_coalesce(struct net_device *dev,
-				 struct ethtool_coalesce *ec)
+				 struct ethtool_coalesce *ec,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned int i;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index b0e4964..fd2b6db 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14040,7 +14040,10 @@ static int tg3_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return -EOPNOTSUPP;
 }
 
-static int tg3_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int tg3_get_coalesce(struct net_device *dev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
@@ -14048,7 +14051,10 @@ static int tg3_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	return 0;
 }
 
-static int tg3_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int tg3_set_coalesce(struct net_device *dev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct tg3 *tp = netdev_priv(dev);
 	u32 max_rxcoal_tick_int = 0, max_txcoal_tick_int = 0;
diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 265c2fa..391b85f 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -307,8 +307,10 @@ bnad_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wolinfo)
 	wolinfo->wolopts = 0;
 }
 
-static int
-bnad_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *coalesce)
+static int bnad_get_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *coalesce,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct bnad *bnad = netdev_priv(netdev);
 	unsigned long flags;
@@ -328,8 +330,10 @@ bnad_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *coalesce)
 	return 0;
 }
 
-static int
-bnad_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *coalesce)
+static int bnad_set_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *coalesce,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct bnad *bnad = netdev_priv(netdev);
 	unsigned long flags;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index 66f2c553..2b97478 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -2108,7 +2108,9 @@ static int octnet_set_intrmod_cfg(struct lio *lio,
 }
 
 static int lio_get_intr_coalesce(struct net_device *netdev,
-				 struct ethtool_coalesce *intr_coal)
+				 struct ethtool_coalesce *intr_coal,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
@@ -2412,7 +2414,9 @@ oct_cfg_tx_intrcnt(struct lio *lio,
 }
 
 static int lio_set_intr_coalesce(struct net_device *netdev,
-				 struct ethtool_coalesce *intr_coal)
+				 struct ethtool_coalesce *intr_coal,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct lio *lio = GET_LIO(netdev);
 	int ret;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index 2f218fb..7f28821 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -456,7 +456,9 @@ static void nicvf_get_regs(struct net_device *dev,
 }
 
 static int nicvf_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *cmd)
+			      struct ethtool_coalesce *cmd,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 512da98..15aa0d8 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -748,7 +748,9 @@ static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	return 0;
 }
 
-static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c,
+			struct kernel_ethtool_coalesce *kernel_coal,
+			struct netlink_ext_ack *extack)
 {
 	struct adapter *adapter = dev->ml_priv;
 
@@ -759,7 +761,9 @@ static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
 	return 0;
 }
 
-static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c,
+			struct kernel_ethtool_coalesce *kernel_coal,
+			struct netlink_ext_ack *extack)
 {
 	struct adapter *adapter = dev->ml_priv;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 84ad726..c22ddbd 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1996,7 +1996,9 @@ static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	return 0;
 }
 
-static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c,
+			struct kernel_ethtool_coalesce *kernel_coal,
+			struct netlink_ext_ack *extack)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
@@ -2017,7 +2019,9 @@ static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
 	return 0;
 }
 
-static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c,
+			struct kernel_ethtool_coalesce *kernel_coal,
+			struct netlink_ext_ack *extack)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 61ea3ec..f1dfb45 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1147,7 +1147,9 @@ static int set_dbqtimer_tickval(struct net_device *dev,
 }
 
 static int set_coalesce(struct net_device *dev,
-			struct ethtool_coalesce *coalesce)
+			struct ethtool_coalesce *coalesce,
+			struct kernel_ethtool_coalesce *kernel_coal,
+			struct netlink_ext_ack *extack)
 {
 	int ret;
 
@@ -1163,7 +1165,9 @@ static int set_coalesce(struct net_device *dev,
 				    coalesce->tx_coalesce_usecs);
 }
 
-static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c,
+			struct kernel_ethtool_coalesce *kernel_coal,
+			struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	const struct adapter *adap = pi->adapter;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 2820a0b..fabe4eb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1647,7 +1647,9 @@ static int cxgb4vf_set_ringparam(struct net_device *dev,
  * interrupt holdoff timer to be read on all of the device's Queue Sets.
  */
 static int cxgb4vf_get_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *coalesce)
+				struct ethtool_coalesce *coalesce,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	const struct adapter *adapter = pi->adapter;
@@ -1667,7 +1669,9 @@ static int cxgb4vf_get_coalesce(struct net_device *dev,
  * the interrupt holdoff timer on any of the device's Queue Sets.
  */
 static int cxgb4vf_set_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *coalesce)
+				struct ethtool_coalesce *coalesce,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 1a9803f..12ffc14 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -298,7 +298,9 @@ static void enic_set_msglevel(struct net_device *netdev, u32 value)
 }
 
 static int enic_get_coalesce(struct net_device *netdev,
-	struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct enic *enic = netdev_priv(netdev);
 	struct enic_rx_coal *rxcoal = &enic->rx_coalesce_setting;
@@ -343,7 +345,9 @@ static int enic_coalesce_valid(struct enic *enic,
 }
 
 static int enic_set_coalesce(struct net_device *netdev,
-	struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct enic *enic = netdev_priv(netdev);
 	u32 tx_coalesce_usecs;
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8df6f08..75ea23d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2144,7 +2144,9 @@ static int gmac_set_ringparam(struct net_device *netdev,
 }
 
 static int gmac_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 
@@ -2156,7 +2158,9 @@ static int gmac_get_coalesce(struct net_device *netdev,
 }
 
 static int gmac_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 99cc1c4..f995530 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -315,7 +315,9 @@ static int be_read_dump_data(struct be_adapter *adapter, u32 dump_len,
 }
 
 static int be_get_coalesce(struct net_device *netdev,
-			   struct ethtool_coalesce *et)
+			   struct ethtool_coalesce *et,
+			   struct kernel_ethtool_coalesce *kernel_coal,
+			   struct netlink_ext_ack *extack)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	struct be_aic_obj *aic = &adapter->aic_obj[0];
@@ -338,7 +340,9 @@ static int be_get_coalesce(struct net_device *netdev,
  * eqd cmd is issued in the worker thread.
  */
 static int be_set_coalesce(struct net_device *netdev,
-			   struct ethtool_coalesce *et)
+			   struct ethtool_coalesce *et,
+			   struct kernel_ethtool_coalesce *kernel_coal,
+			   struct netlink_ext_ack *extack)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	struct be_aic_obj *aic = &adapter->aic_obj[0];
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 1268996..763d2c7 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -513,7 +513,9 @@ static int dpaa_get_ts_info(struct net_device *net_dev,
 }
 
 static int dpaa_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *c)
+			     struct ethtool_coalesce *c,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct qman_portal *portal;
 	u32 period;
@@ -530,7 +532,9 @@ static int dpaa_get_coalesce(struct net_device *dev,
 }
 
 static int dpaa_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *c)
+			     struct ethtool_coalesce *c,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	const cpumask_t *cpus = qman_affine_cpus();
 	bool needs_revert[NR_CPUS] = {false};
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index ebccaf0..9690e36 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -585,7 +585,9 @@ static void enetc_get_ringparam(struct net_device *ndev,
 }
 
 static int enetc_get_coalesce(struct net_device *ndev,
-			      struct ethtool_coalesce *ic)
+			      struct ethtool_coalesce *ic,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_int_vector *v = priv->int_vector[0];
@@ -602,7 +604,9 @@ static int enetc_get_coalesce(struct net_device *ndev,
 }
 
 static int enetc_set_coalesce(struct net_device *ndev,
-			      struct ethtool_coalesce *ic)
+			      struct ethtool_coalesce *ic,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	u32 rx_ictt, tx_ictt;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ad82cff..bd74a31 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2578,8 +2578,10 @@ static void fec_enet_itr_coal_set(struct net_device *ndev)
 	}
 }
 
-static int
-fec_enet_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
+static int fec_enet_get_coalesce(struct net_device *ndev,
+				 struct ethtool_coalesce *ec,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
@@ -2595,8 +2597,10 @@ fec_enet_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 	return 0;
 }
 
-static int
-fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
+static int fec_enet_set_coalesce(struct net_device *ndev,
+				 struct ethtool_coalesce *ec,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct device *dev = &fep->pdev->dev;
@@ -2648,7 +2652,7 @@ static void fec_enet_itr_coal_init(struct net_device *ndev)
 	ec.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
 	ec.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
 
-	fec_enet_set_coalesce(ndev, &ec);
+	fec_enet_set_coalesce(ndev, &ec, NULL, NULL);
 }
 
 static int fec_enet_get_tunable(struct net_device *netdev,
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index cc7d4f9..7b32ed2 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -243,7 +243,9 @@ static unsigned int gfar_ticks2usecs(struct gfar_private *priv,
 /* Get the coalescing parameters, and put them in the cvals
  * structure.  */
 static int gfar_gcoalesce(struct net_device *dev,
-			  struct ethtool_coalesce *cvals)
+			  struct ethtool_coalesce *cvals,
+			  struct kernel_ethtool_coalesce *kernel_coal,
+			  struct netlink_ext_ack *extack)
 {
 	struct gfar_private *priv = netdev_priv(dev);
 	struct gfar_priv_rx_q *rx_queue = NULL;
@@ -280,7 +282,9 @@ static int gfar_gcoalesce(struct net_device *dev,
  * in order for coalescing to be active
  */
 static int gfar_scoalesce(struct net_device *dev,
-			  struct ethtool_coalesce *cvals)
+			  struct ethtool_coalesce *cvals,
+			  struct kernel_ethtool_coalesce *kernel_coal,
+			  struct netlink_ext_ack *extack)
 {
 	struct gfar_private *priv = netdev_priv(dev);
 	int i, err = 0;
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 12f6c24..09579c8 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -796,7 +796,9 @@ static void hip04_tx_timeout_task(struct work_struct *work)
 }
 
 static int hip04_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct hip04_priv *priv = netdev_priv(netdev);
 
@@ -807,7 +809,9 @@ static int hip04_get_coalesce(struct net_device *netdev,
 }
 
 static int hip04_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct hip04_priv *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 7e62dcf..8f6892f 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -734,7 +734,9 @@ static int hns_set_pauseparam(struct net_device *net_dev,
  * Return 0 on success, negative on failure.
  */
 static int hns_get_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *ec)
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct hns_nic_priv *priv = netdev_priv(net_dev);
 	struct hnae_ae_ops *ops;
@@ -778,7 +780,9 @@ static int hns_get_coalesce(struct net_device *net_dev,
  * Return 0 on success, negative on failure.
  */
 static int hns_set_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *ec)
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct hns_nic_priv *priv = netdev_priv(net_dev);
 	struct hnae_ae_ops *ops;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c1ea403..b9f9599 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1135,7 +1135,9 @@ static void hns3_get_channels(struct net_device *netdev,
 }
 
 static int hns3_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
+			     struct ethtool_coalesce *cmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
@@ -1317,7 +1319,9 @@ static void hns3_set_coalesce_per_queue(struct net_device *netdev,
 }
 
 static int hns3_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
+			     struct ethtool_coalesce *cmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 162d3c3..b431c30 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -795,13 +795,17 @@ static int __hinic_set_coalesce(struct net_device *netdev,
 }
 
 static int hinic_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	return __hinic_get_coalesce(netdev, coal, COALESCE_ALL_QUEUE);
 }
 
 static int hinic_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	return __hinic_set_coalesce(netdev, coal, COALESCE_ALL_QUEUE);
 }
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 3c51ee9..0a57172 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1739,7 +1739,9 @@ static int e1000_set_phys_id(struct net_device *netdev,
 }
 
 static int e1000_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -1755,7 +1757,9 @@ static int e1000_get_coalesce(struct net_device *netdev,
 }
 
 static int e1000_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 06442e6..9b2071d 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -1991,7 +1991,9 @@ static int e1000_set_phys_id(struct net_device *netdev,
 }
 
 static int e1000_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -2004,7 +2006,9 @@ static int e1000_get_coalesce(struct net_device *netdev,
 }
 
 static int e1000_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 66776ba..0d37f01 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -632,7 +632,9 @@ static int fm10k_set_ringparam(struct net_device *netdev,
 }
 
 static int fm10k_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct fm10k_intfc *interface = netdev_priv(dev);
 
@@ -646,7 +648,9 @@ static int fm10k_get_coalesce(struct net_device *dev,
 }
 
 static int fm10k_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct fm10k_intfc *interface = netdev_priv(dev);
 	u16 tx_itr, rx_itr;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index ccd5b94..aef9803 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2819,7 +2819,9 @@ static int __i40e_get_coalesce(struct net_device *netdev,
  * __i40e_get_coalesce for more details.
  **/
 static int i40e_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	return __i40e_get_coalesce(netdev, ec, -1);
 }
@@ -2991,7 +2993,9 @@ static int __i40e_set_coalesce(struct net_device *netdev,
  * This will set each queue to the same coalesce settings.
  **/
 static int i40e_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	return __i40e_set_coalesce(netdev, ec, -1);
 }
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index af43fbd..c21d26d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -692,7 +692,9 @@ static int __iavf_get_coalesce(struct net_device *netdev,
  * only represents the settings of queue 0.
  **/
 static int iavf_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	return __iavf_get_coalesce(netdev, ec, -1);
 }
@@ -808,7 +810,9 @@ static int __iavf_set_coalesce(struct net_device *netdev,
  * Change current coalescing settings for every queue.
  **/
 static int iavf_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	return __iavf_set_coalesce(netdev, ec, -1);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d9ddd0b..23e80b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3586,8 +3586,10 @@ __ice_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	return 0;
 }
 
-static int
-ice_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int ice_get_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	return __ice_get_coalesce(netdev, ec, -1);
 }
@@ -3805,8 +3807,10 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	return 0;
 }
 
-static int
-ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int ice_set_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	return __ice_set_coalesce(netdev, ec, -1);
 }
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 636a1b1..0847988 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2182,7 +2182,9 @@ static int igb_set_phys_id(struct net_device *netdev,
 }
 
 static int igb_set_coalesce(struct net_device *netdev,
-			    struct ethtool_coalesce *ec)
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	int i;
@@ -2238,7 +2240,9 @@ static int igb_set_coalesce(struct net_device *netdev,
 }
 
 static int igb_get_coalesce(struct net_device *netdev,
-			    struct ethtool_coalesce *ec)
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index f4835eb..06e5bd6 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -314,7 +314,9 @@ static int igbvf_set_wol(struct net_device *netdev,
 }
 
 static int igbvf_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
@@ -327,7 +329,9 @@ static int igbvf_get_coalesce(struct net_device *netdev,
 }
 
 static int igbvf_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 2cb1243..185b103 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -875,7 +875,9 @@ static void igc_ethtool_get_stats(struct net_device *netdev,
 }
 
 static int igc_ethtool_get_coalesce(struct net_device *netdev,
-				    struct ethtool_coalesce *ec)
+				    struct ethtool_coalesce *ec,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
@@ -895,7 +897,9 @@ static int igc_ethtool_get_coalesce(struct net_device *netdev,
 }
 
 static int igc_ethtool_set_coalesce(struct net_device *netdev,
-				    struct ethtool_coalesce *ec)
+				    struct ethtool_coalesce *ec,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	int i;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 4ceaca0..fc26e4d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2358,7 +2358,9 @@ static int ixgbe_set_phys_id(struct net_device *netdev,
 }
 
 static int ixgbe_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
@@ -2412,7 +2414,9 @@ static bool ixgbe_update_rsc(struct ixgbe_adapter *adapter)
 }
 
 static int ixgbe_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_q_vector *q_vector;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index e49fb1c..8380f90 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -787,7 +787,9 @@ static int ixgbevf_nway_reset(struct net_device *netdev)
 }
 
 static int ixgbevf_get_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
@@ -811,7 +813,9 @@ static int ixgbevf_get_coalesce(struct net_device *netdev,
 }
 
 static int ixgbevf_set_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 	struct ixgbevf_q_vector *q_vector;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index f1b9284..cf5c33d 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2400,8 +2400,10 @@ jme_get_regs(struct net_device *netdev, struct ethtool_regs *regs, void *p)
 	mdio_memcpy(jme, p32, JME_PHY_REG_NR);
 }
 
-static int
-jme_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecmd)
+static int jme_get_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ecmd,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct jme_adapter *jme = netdev_priv(netdev);
 
@@ -2437,8 +2439,10 @@ jme_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecmd)
 	return 0;
 }
 
-static int
-jme_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecmd)
+static int jme_set_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ecmd,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct jme_adapter *jme = netdev_priv(netdev);
 	struct dynpcc_info *dpi = &(jme->dpi);
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index d207bfc..c20e4f6 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1611,8 +1611,10 @@ static void mv643xx_eth_get_drvinfo(struct net_device *dev,
 	strlcpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
 }
 
-static int
-mv643xx_eth_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int mv643xx_eth_get_coalesce(struct net_device *dev,
+				    struct ethtool_coalesce *ec,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
@@ -1622,8 +1624,10 @@ mv643xx_eth_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	return 0;
 }
 
-static int
-mv643xx_eth_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int mv643xx_eth_set_coalesce(struct net_device *dev,
+				    struct ethtool_coalesce *ec,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5cd9b..776ea6dc 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4501,7 +4501,9 @@ static int mvneta_ethtool_nway_reset(struct net_device *dev)
 
 /* Set interrupt coalescing for ethtools */
 static int mvneta_ethtool_set_coalesce(struct net_device *dev,
-				       struct ethtool_coalesce *c)
+				       struct ethtool_coalesce *c,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 	int queue;
@@ -4525,7 +4527,9 @@ static int mvneta_ethtool_set_coalesce(struct net_device *dev,
 
 /* get coalescing for ethtools */
 static int mvneta_ethtool_get_coalesce(struct net_device *dev,
-				       struct ethtool_coalesce *c)
+				       struct ethtool_coalesce *c,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d4fb620..53d0f88 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5373,7 +5373,9 @@ static int mvpp2_ethtool_nway_reset(struct net_device *dev)
 
 /* Set interrupt coalescing for ethtools */
 static int mvpp2_ethtool_set_coalesce(struct net_device *dev,
-				      struct ethtool_coalesce *c)
+				      struct ethtool_coalesce *c,
+				      struct kernel_ethtool_coalesce *kernel_coal,
+				      struct netlink_ext_ack *extack)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	int queue;
@@ -5406,7 +5408,9 @@ static int mvpp2_ethtool_set_coalesce(struct net_device *dev,
 
 /* get coalescing for ethtools */
 static int mvpp2_ethtool_get_coalesce(struct net_device *dev,
-				      struct ethtool_coalesce *c)
+				      struct ethtool_coalesce *c,
+				      struct kernel_ethtool_coalesce *kernel_coal,
+				      struct netlink_ext_ack *extack)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 9d9a2e4..2efc0e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -410,7 +410,9 @@ static int otx2_set_ringparam(struct net_device *netdev,
 }
 
 static int otx2_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
+			     struct ethtool_coalesce *cmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_hw *hw = &pfvf->hw;
@@ -424,7 +426,9 @@ static int otx2_get_coalesce(struct net_device *netdev,
 }
 
 static int otx2_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct ethtool_coalesce *ec,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_hw *hw = &pfvf->hw;
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index d4bb27b..63191e85 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -615,7 +615,9 @@ static inline u32 skge_usecs2clk(const struct skge_hw *hw, u32 usec)
 }
 
 static int skge_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct skge_port *skge = netdev_priv(dev);
 	struct skge_hw *hw = skge->hw;
@@ -639,7 +641,9 @@ static int skge_get_coalesce(struct net_device *dev,
 
 /* Note: interrupt timer is per board, but can turn on/off per port */
 static int skge_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct skge_port *skge = netdev_priv(dev);
 	struct skge_hw *hw = skge->hw;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 324c280..0b8bc30 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4052,7 +4052,9 @@ static int sky2_set_pauseparam(struct net_device *dev,
 }
 
 static int sky2_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
@@ -4087,7 +4089,9 @@ static int sky2_get_coalesce(struct net_device *dev,
 
 /* Note: this affect both ports */
 static int sky2_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct ethtool_coalesce *ecmd,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 3616b77..ef518b1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -998,7 +998,9 @@ mlx4_en_set_link_ksettings(struct net_device *dev,
 }
 
 static int mlx4_en_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+				struct ethtool_coalesce *coal,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
@@ -1020,7 +1022,9 @@ static int mlx4_en_get_coalesce(struct net_device *dev,
 }
 
 static int mlx4_en_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+				struct ethtool_coalesce *coal,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 8360289..af4c1bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -512,7 +512,9 @@ int mlx5e_ethtool_get_coalesce(struct mlx5e_priv *priv,
 }
 
 static int mlx5e_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
@@ -630,7 +632,9 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 }
 
 static int mlx5e_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv    = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 34eb111..004026c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -248,7 +248,9 @@ static int mlx5e_rep_set_channels(struct net_device *dev,
 }
 
 static int mlx5e_rep_get_coalesce(struct net_device *netdev,
-				  struct ethtool_coalesce *coal)
+				  struct ethtool_coalesce *coal,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
@@ -256,7 +258,9 @@ static int mlx5e_rep_get_coalesce(struct net_device *netdev,
 }
 
 static int mlx5e_rep_set_coalesce(struct net_device *netdev,
-				  struct ethtool_coalesce *coal)
+				  struct ethtool_coalesce *coal,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 97d96fc..d89d564 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -99,7 +99,9 @@ static void mlx5i_get_channels(struct net_device *dev,
 }
 
 static int mlx5i_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
 
@@ -107,7 +109,9 @@ static int mlx5i_set_coalesce(struct net_device *netdev,
 }
 
 static int mlx5i_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct ethtool_coalesce *coal,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c84c8bf..46d1001 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1651,8 +1651,10 @@ myri10ge_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info)
 	strlcpy(info->bus_info, pci_name(mgp->pdev), sizeof(info->bus_info));
 }
 
-static int
-myri10ge_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *coal)
+static int myri10ge_get_coalesce(struct net_device *netdev,
+				 struct ethtool_coalesce *coal,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
@@ -1660,8 +1662,10 @@ myri10ge_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *coal)
 	return 0;
 }
 
-static int
-myri10ge_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *coal)
+static int myri10ge_set_coalesce(struct net_device *netdev,
+				 struct ethtool_coalesce *coal,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1b48244..b7bef48 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1076,7 +1076,9 @@ static void nfp_net_get_regs(struct net_device *netdev,
 }
 
 static int nfp_net_get_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 
@@ -1325,7 +1327,9 @@ nfp_port_get_module_eeprom(struct net_device *netdev,
 }
 
 static int nfp_net_set_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	unsigned int factor;
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a6861df..20f50cd 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -994,7 +994,9 @@ static void nixge_ethtools_get_drvinfo(struct net_device *ndev,
 }
 
 static int nixge_ethtools_get_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *ecoalesce)
+				       struct ethtool_coalesce *ecoalesce,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct nixge_priv *priv = netdev_priv(ndev);
 	u32 regval = 0;
@@ -1009,7 +1011,9 @@ static int nixge_ethtools_get_coalesce(struct net_device *ndev,
 }
 
 static int nixge_ethtools_set_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *ecoalesce)
+				       struct ethtool_coalesce *ecoalesce,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct nixge_priv *priv = netdev_priv(ndev);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 6583be5..e2c15a1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -408,7 +408,9 @@ static int ionic_set_fecparam(struct net_device *netdev,
 }
 
 static int ionic_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coalesce)
+			      struct ethtool_coalesce *coalesce,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
@@ -426,7 +428,9 @@ static int ionic_get_coalesce(struct net_device *netdev,
 }
 
 static int ionic_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coalesce)
+			      struct ethtool_coalesce *coalesce,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_identity *ident;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index dd22cb0..a075643 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -731,7 +731,9 @@ netxen_nic_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
  * firmware coalescing to default.
  */
 static int netxen_set_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct ethtool_coalesce *ethcoal,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 
@@ -775,7 +777,9 @@ static int netxen_set_intr_coalesce(struct net_device *netdev,
 }
 
 static int netxen_get_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct ethtool_coalesce *ethcoal,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 2e62a2c..8df446d 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -588,7 +588,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 			    struct flow_cls_offload *f);
 
 void qede_forced_speed_maps_init(void);
-int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal);
+int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal,
+		      struct kernel_ethtool_coalesce *kernel_coal,
+		      struct netlink_ext_ack *extack);
 int qede_set_per_coalesce(struct net_device *dev, u32 queue,
 			  struct ethtool_coalesce *coal);
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 1560ad3..d99abb3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -760,7 +760,9 @@ static int qede_flash_device(struct net_device *dev,
 }
 
 static int qede_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	void *rx_handle = NULL, *tx_handle = NULL;
 	struct qede_dev *edev = netdev_priv(dev);
@@ -819,7 +821,9 @@ static int qede_get_coalesce(struct net_device *dev,
 	return rc;
 }
 
-int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal,
+		      struct kernel_ethtool_coalesce *kernel_coal,
+		      struct netlink_ext_ack *extack)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_fastpath *fp;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index d8f0863..7ac4b5f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1527,7 +1527,9 @@ qlcnic_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
  * firmware coalescing to default.
  */
 static int qlcnic_set_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct ethtool_coalesce *ethcoal,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	int err;
@@ -1551,7 +1553,9 @@ static int qlcnic_set_intr_coalesce(struct net_device *netdev,
 }
 
 static int qlcnic_get_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct ethtool_coalesce *ethcoal,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1663e04..946fbe7f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1749,7 +1749,10 @@ rtl_coalesce_info(struct rtl8169_private *tp)
 	return ERR_PTR(-ELNRNG);
 }
 
-static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int rtl_get_coalesce(struct net_device *dev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	const struct rtl_coalesce_info *ci;
@@ -1807,7 +1810,10 @@ static int rtl_coalesce_choose_scale(struct rtl8169_private *tp, u32 usec,
 	return -ERANGE;
 }
 
-static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int rtl_set_coalesce(struct net_device *dev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 	u32 tx_fr = ec->tx_max_coalesced_frames;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
index 7f8b10c..98edb01 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
@@ -274,7 +274,9 @@ static u32 sxgbe_usec2riwt(u32 usec, struct sxgbe_priv_data *priv)
 }
 
 static int sxgbe_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 
@@ -285,7 +287,9 @@ static int sxgbe_get_coalesce(struct net_device *dev,
 }
 
 static int sxgbe_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 	unsigned int rx_riwt;
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 058d9fe..e002ce2 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -97,7 +97,9 @@ static void efx_ethtool_get_regs(struct net_device *net_dev,
  */
 
 static int efx_ethtool_get_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct ethtool_coalesce *coalesce,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	unsigned int tx_usecs, rx_usecs;
@@ -115,7 +117,9 @@ static int efx_ethtool_get_coalesce(struct net_device *net_dev,
 }
 
 static int efx_ethtool_set_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct ethtool_coalesce *coalesce,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_channel *channel;
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index a6bae6a..137e8a7 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -577,7 +577,9 @@ static int ef4_ethtool_nway_reset(struct net_device *net_dev)
  */
 
 static int ef4_ethtool_get_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct ethtool_coalesce *coalesce,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 	unsigned int tx_usecs, rx_usecs;
@@ -595,7 +597,9 @@ static int ef4_ethtool_get_coalesce(struct net_device *net_dev,
 }
 
 static int ef4_ethtool_set_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct ethtool_coalesce *coalesce,
+				    struct kernel_ethtool_coalesce *kernel_coal,
+				    struct netlink_ext_ack *extack)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 	struct ef4_channel *channel;
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index dfc85cc..babccf6 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -532,7 +532,9 @@ static void netsec_et_get_drvinfo(struct net_device *net_device,
 }
 
 static int netsec_et_get_coalesce(struct net_device *net_device,
-				  struct ethtool_coalesce *et_coalesce)
+				  struct ethtool_coalesce *et_coalesce,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
 {
 	struct netsec_priv *priv = netdev_priv(net_device);
 
@@ -542,7 +544,9 @@ static int netsec_et_get_coalesce(struct net_device *net_device,
 }
 
 static int netsec_et_set_coalesce(struct net_device *net_device,
-				  struct ethtool_coalesce *et_coalesce)
+				  struct ethtool_coalesce *et_coalesce,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
 {
 	struct netsec_priv *priv = netdev_priv(net_device);
 
@@ -1547,7 +1551,7 @@ static int netsec_start_gmac(struct netsec_priv *priv)
 	netsec_write(priv, NETSEC_REG_NRM_RX_INTEN_CLR, ~0);
 	netsec_write(priv, NETSEC_REG_NRM_TX_INTEN_CLR, ~0);
 
-	netsec_et_set_coalesce(priv->ndev, &priv->et_coalesce);
+	netsec_et_set_coalesce(priv->ndev, &priv->et_coalesce, NULL, NULL);
 
 	if (netsec_mac_write(priv, GMAC_REG_OMR, value))
 		return -ETIMEDOUT;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1f6d749..9d7f9cb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -807,7 +807,9 @@ static int __stmmac_get_coalesce(struct net_device *dev,
 }
 
 static int stmmac_get_coalesce(struct net_device *dev,
-			       struct ethtool_coalesce *ec)
+			       struct ethtool_coalesce *ec,
+			       struct kernel_ethtool_coalesce *kernel_coal,
+			       struct netlink_ext_ack *extack)
 {
 	return __stmmac_get_coalesce(dev, ec, -1);
 }
@@ -891,7 +893,9 @@ static int __stmmac_set_coalesce(struct net_device *dev,
 }
 
 static int stmmac_set_coalesce(struct net_device *dev,
-			       struct ethtool_coalesce *ec)
+			       struct ethtool_coalesce *ec,
+			       struct kernel_ethtool_coalesce *kernel_coal,
+			       struct netlink_ext_ack *extack)
 {
 	return __stmmac_set_coalesce(dev, ec, -1);
 }
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
index bc198ead..0b34757 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
@@ -147,7 +147,9 @@ static void xlgmac_ethtool_get_channels(struct net_device *netdev,
 }
 
 static int xlgmac_ethtool_get_coalesce(struct net_device *netdev,
-				       struct ethtool_coalesce *ec)
+				       struct ethtool_coalesce *ec,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 
@@ -159,7 +161,9 @@ static int xlgmac_ethtool_get_coalesce(struct net_device *netdev,
 }
 
 static int xlgmac_ethtool_set_coalesce(struct net_device *netdev,
-				       struct ethtool_coalesce *ec)
+				       struct ethtool_coalesce *ec,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 	struct xlgmac_hw_ops *hw_ops = &pdata->hw_ops;
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index d054c6e..7aebb22 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2159,8 +2159,10 @@ bdx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
  * @netdev
  * @ecoal
  */
-static int
-bdx_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
+static int bdx_get_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ecoal,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	u32 rdintcm;
 	u32 tdintcm;
@@ -2188,8 +2190,10 @@ bdx_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
  * @netdev
  * @ecoal
  */
-static int
-bdx_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
+static int bdx_set_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ecoal,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	u32 rdintcm;
 	u32 tdintcm;
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c0cd7de..84c4efb 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -845,7 +845,7 @@ static int cpsw_ndo_open(struct net_device *ndev)
 		struct ethtool_coalesce coal;
 
 		coal.rx_coalesce_usecs = cpsw->coal_intvl;
-		cpsw_set_coalesce(ndev, &coal);
+		cpsw_set_coalesce(ndev, &coal, NULL, NULL);
 	}
 
 	cpdma_ctlr_start(cpsw->dma);
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 4619c3a..158c8d3 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -152,7 +152,9 @@ void cpsw_set_msglevel(struct net_device *ndev, u32 value)
 	priv->msg_enable = value;
 }
 
-int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal)
+int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
+		      struct kernel_ethtool_coalesce *kernel_coal,
+		      struct netlink_ext_ack *extack)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 
@@ -160,7 +162,9 @@ int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal)
 	return 0;
 }
 
-int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal)
+int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
+		      struct kernel_ethtool_coalesce *kernel_coal,
+		      struct netlink_ext_ack *extack)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	u32 int_ctrl;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 69b7a4e..c9e4e87 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -893,7 +893,7 @@ static int cpsw_ndo_open(struct net_device *ndev)
 		struct ethtool_coalesce coal;
 
 		coal.rx_coalesce_usecs = cpsw->coal_intvl;
-		cpsw_set_coalesce(ndev, &coal);
+		cpsw_set_coalesce(ndev, &coal, NULL, NULL);
 	}
 
 	cpdma_ctlr_start(cpsw->dma);
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index a323bea..6df4925 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -462,8 +462,12 @@ void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
 void cpsw_set_msglevel(struct net_device *ndev, u32 value);
-int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal);
-int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal);
+int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
+		      struct kernel_ethtool_coalesce *kernel_coal,
+		      struct netlink_ext_ack *extack);
+int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
+		      struct kernel_ethtool_coalesce *kernel_coal,
+		      struct netlink_ext_ack *extack);
 int cpsw_get_sset_count(struct net_device *ndev, int sset);
 void cpsw_get_strings(struct net_device *ndev, u32 stringset, u8 *data);
 void cpsw_get_ethtool_stats(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index f9417b4..6f95267 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -388,7 +388,9 @@ static void emac_get_drvinfo(struct net_device *ndev,
  *
  */
 static int emac_get_coalesce(struct net_device *ndev,
-				struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct emac_priv *priv = netdev_priv(ndev);
 
@@ -406,7 +408,9 @@ static int emac_get_coalesce(struct net_device *ndev,
  *
  */
 static int emac_set_coalesce(struct net_device *ndev,
-				struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct emac_priv *priv = netdev_priv(ndev);
 	u32 int_ctrl, num_interrupts = 0;
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 88426b5..7b6556d 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -3520,7 +3520,9 @@ static void set_pending_timer_val(int *val, u32 us)
 
 
 static int velocity_get_coalesce(struct net_device *dev,
-		struct ethtool_coalesce *ecmd)
+				 struct ethtool_coalesce *ecmd,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct velocity_info *vptr = netdev_priv(dev);
 
@@ -3534,7 +3536,9 @@ static int velocity_get_coalesce(struct net_device *dev,
 }
 
 static int velocity_set_coalesce(struct net_device *dev,
-		struct ethtool_coalesce *ecmd)
+				 struct ethtool_coalesce *ecmd,
+				 struct kernel_ethtool_coalesce *kernel_coal,
+				 struct netlink_ext_ack *extack)
 {
 	struct velocity_info *vptr = netdev_priv(dev);
 	int max_us = 0x3f * 64;
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index a1f5f07..7d375f4 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1292,7 +1292,9 @@ static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
 }
 
 static int ll_temac_ethtools_get_coalesce(struct net_device *ndev,
-					  struct ethtool_coalesce *ec)
+					  struct ethtool_coalesce *ec,
+					  struct kernel_ethtool_coalesce *kernel_coal,
+					  struct netlink_ext_ack *extack)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 
@@ -1304,7 +1306,9 @@ static int ll_temac_ethtools_get_coalesce(struct net_device *ndev,
 }
 
 static int ll_temac_ethtools_set_coalesce(struct net_device *ndev,
-					  struct ethtool_coalesce *ec)
+					  struct ethtool_coalesce *ec,
+					  struct kernel_ethtool_coalesce *kernel_coal,
+					  struct netlink_ext_ack *extack)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b508c94..e71c310 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1408,7 +1408,9 @@ axienet_ethtools_set_pauseparam(struct net_device *ndev,
  * Return: 0 always
  */
 static int axienet_ethtools_get_coalesce(struct net_device *ndev,
-					 struct ethtool_coalesce *ecoalesce)
+					 struct ethtool_coalesce *ecoalesce,
+					 struct kernel_ethtool_coalesce *kernel_coal,
+					 struct netlink_ext_ack *extack)
 {
 	u32 regval = 0;
 	struct axienet_local *lp = netdev_priv(ndev);
@@ -1433,7 +1435,9 @@ static int axienet_ethtools_get_coalesce(struct net_device *ndev,
  * Return: 0, on success, Non-zero error value on failure.
  */
 static int axienet_ethtools_set_coalesce(struct net_device *ndev,
-					 struct ethtool_coalesce *ecoalesce)
+					 struct ethtool_coalesce *ecoalesce,
+					 struct kernel_ethtool_coalesce *kernel_coal,
+					 struct netlink_ext_ack *extack)
 {
 	struct axienet_local *lp = netdev_priv(ndev);
 
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index c9ae525..b03a051 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -43,7 +43,9 @@ nsim_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
 }
 
 static int nsim_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
@@ -52,7 +54,9 @@ static int nsim_get_coalesce(struct net_device *dev,
 }
 
 static int nsim_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2ced021..fecc9a1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3510,7 +3510,9 @@ static void tun_set_msglevel(struct net_device *dev, u32 value)
 }
 
 static int tun_get_coalesce(struct net_device *dev,
-			    struct ethtool_coalesce *ec)
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
@@ -3520,7 +3522,9 @@ static int tun_get_coalesce(struct net_device *dev,
 }
 
 static int tun_set_coalesce(struct net_device *dev,
-			    struct ethtool_coalesce *ec)
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_coal,
+			    struct netlink_ext_ack *extack)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f6abb2f..9fdb4aa 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8819,7 +8819,9 @@ static int rtl8152_nway_reset(struct net_device *dev)
 }
 
 static int rtl8152_get_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *coalesce)
+				struct ethtool_coalesce *coalesce,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
@@ -8838,7 +8840,9 @@ static int rtl8152_get_coalesce(struct net_device *netdev,
 }
 
 static int rtl8152_set_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *coalesce)
+				struct ethtool_coalesce *coalesce,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 	int ret;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 073fec4..ee43a9f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2288,7 +2288,9 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
 }
 
 static int virtnet_set_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *ec)
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, napi_weight;
@@ -2309,7 +2311,9 @@ static int virtnet_set_coalesce(struct net_device *dev,
 }
 
 static int virtnet_get_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *ec)
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct ethtool_coalesce ec_default = {
 		.cmd = ETHTOOL_GCOALESCE,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index c0bd9cb..28ccd27 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1015,8 +1015,10 @@ vmxnet3_set_rss(struct net_device *netdev, const u32 *p, const u8 *key,
 }
 #endif
 
-static int
-vmxnet3_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int vmxnet3_get_coalesce(struct net_device *netdev,
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -1050,8 +1052,10 @@ vmxnet3_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 	return 0;
 }
 
-static int
-vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int vmxnet3_set_coalesce(struct net_device *netdev,
+				struct ethtool_coalesce *ec,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	struct Vmxnet3_DriverShared *shared = adapter->shared;
diff --git a/drivers/net/wireless/ath/wil6210/ethtool.c b/drivers/net/wireless/ath/wil6210/ethtool.c
index e481674..e766a76 100644
--- a/drivers/net/wireless/ath/wil6210/ethtool.c
+++ b/drivers/net/wireless/ath/wil6210/ethtool.c
@@ -12,7 +12,9 @@
 #include "wil6210.h"
 
 static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *cp)
+				       struct ethtool_coalesce *cp,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	u32 tx_itr_en, tx_itr_val = 0;
@@ -46,7 +48,9 @@ static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 }
 
 static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *cp)
+				       struct ethtool_coalesce *cp,
+				       struct kernel_ethtool_coalesce *kernel_coal,
+				       struct netlink_ext_ack *extack)
 {
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 3a51bbf..80a3ab5 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -124,7 +124,9 @@ static void __qeth_set_coalesce(struct net_device *dev,
 }
 
 static int qeth_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct ethtool_coalesce *coal,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct qeth_card *card = dev->ml_priv;
 	struct qeth_qdio_out_q *queue;
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index b70570b..df3fc2c 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -621,7 +621,10 @@ static void qlge_get_regs(struct net_device *ndev,
 		regs->len = sizeof(struct qlge_reg_dump);
 }
 
-static int qlge_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
+static int qlge_get_coalesce(struct net_device *ndev,
+			     struct ethtool_coalesce *c,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
@@ -644,7 +647,10 @@ static int qlge_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *c
 	return 0;
 }
 
-static int qlge_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
+static int qlge_set_coalesce(struct net_device *ndev,
+			     struct ethtool_coalesce *c,
+			     struct kernel_ethtool_coalesce *kernel_coal,
+			     struct netlink_ext_ack *extack)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e030f75..b2d2f3d 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -15,6 +15,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/compat.h>
+#include <linux/netlink.h>
 #include <uapi/linux/ethtool.h>
 
 #ifdef CONFIG_COMPAT
@@ -176,6 +177,11 @@ extern int
 __ethtool_get_link_ksettings(struct net_device *dev,
 			     struct ethtool_link_ksettings *link_ksettings);
 
+struct kernel_ethtool_coalesce {
+	u8 use_cqe_mode_tx;
+	u8 use_cqe_mode_rx;
+};
+
 /**
  * ethtool_intersect_link_masks - Given two link masks, AND them together
  * @dst: first mask and where result is stored
@@ -215,7 +221,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
 #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
-#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(21, 0)
+#define ETHTOOL_COALESCE_USE_CQE_RX		BIT(22)
+#define ETHTOOL_COALESCE_USE_CQE_TX		BIT(23)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(23, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
@@ -241,6 +249,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_RX_USECS_HIGH | \
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
+#define ETHTOOL_COALESCE_USE_CQE					\
+	(ETHTOOL_COALESCE_USE_CQE_RX | ETHTOOL_COALESCE_USE_CQE_TX)
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
@@ -606,8 +616,14 @@ struct ethtool_ops {
 			      struct ethtool_eeprom *, u8 *);
 	int	(*set_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
-	int	(*get_coalesce)(struct net_device *, struct ethtool_coalesce *);
-	int	(*set_coalesce)(struct net_device *, struct ethtool_coalesce *);
+	int	(*get_coalesce)(struct net_device *,
+				struct ethtool_coalesce *,
+				struct kernel_ethtool_coalesce *,
+				struct netlink_ext_ack *);
+	int	(*set_coalesce)(struct net_device *,
+				struct ethtool_coalesce *,
+				struct kernel_ethtool_coalesce *,
+				struct netlink_ext_ack *);
 	void	(*get_ringparam)(struct net_device *,
 				 struct ethtool_ringparam *);
 	int	(*set_ringparam)(struct net_device *,
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 825cfda..1ad32a4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -375,6 +375,8 @@ enum {
 	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,		/* u8 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,		/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 1d6bc13..224b45a 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -10,6 +10,7 @@ struct coalesce_req_info {
 struct coalesce_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_coalesce		coalesce;
+	struct kernel_ethtool_coalesce	kernel_coalesce;
 	u32				supported_params;
 };
 
@@ -61,6 +62,7 @@ static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
 				 struct genl_info *info)
 {
 	struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -70,7 +72,8 @@ static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
-	ret = dev->ethtool_ops->get_coalesce(dev, &data->coalesce);
+	ret = dev->ethtool_ops->get_coalesce(dev, &data->coalesce,
+					     &data->kernel_coalesce, extack);
 	ethnl_ops_complete(dev);
 
 	return ret;
@@ -100,7 +103,9 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
-	       nla_total_size(sizeof(u32));	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
+	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_TX */
+	       nla_total_size(sizeof(u8));	/* _USE_CQE_MODE_RX */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -124,6 +129,7 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 			       const struct ethnl_reply_data *reply_base)
 {
 	const struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	const struct kernel_ethtool_coalesce *kcoal = &data->kernel_coalesce;
 	const struct ethtool_coalesce *coal = &data->coalesce;
 	u32 supported = data->supported_params;
 
@@ -170,7 +176,11 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
 			     coal->tx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
-			     coal->rate_sample_interval, supported))
+			     coal->rate_sample_interval, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
+			      kcoal->use_cqe_mode_tx, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
+			      kcoal->use_cqe_mode_rx, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -215,10 +225,13 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= { .type = NLA_U8 },
+	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= { .type = NLA_U8 },
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 {
+	struct kernel_ethtool_coalesce kernel_coalesce = {};
 	struct ethtool_coalesce coalesce = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
@@ -255,7 +268,8 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
-	ret = ops->get_coalesce(dev, &coalesce);
+	ret = ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
+				info->extack);
 	if (ret < 0)
 		goto out_ops;
 
@@ -303,11 +317,16 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
 	ethnl_update_u32(&coalesce.rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
+	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_tx,
+			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod);
+	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_rx,
+			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
 
-	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce, &kernel_coalesce,
+					     info->extack);
 	if (ret < 0)
 		goto out_ops;
 	ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3fa7a39..1a492b9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1514,12 +1514,14 @@ static noinline_for_stack int ethtool_get_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
 	struct ethtool_coalesce coalesce = { .cmd = ETHTOOL_GCOALESCE };
+	struct kernel_ethtool_coalesce kernel_coalesce = {};
 	int ret;
 
 	if (!dev->ethtool_ops->get_coalesce)
 		return -EOPNOTSUPP;
 
-	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
+					     NULL);
 	if (ret)
 		return ret;
 
@@ -1586,19 +1588,26 @@ ethtool_set_coalesce_supported(struct net_device *dev,
 static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
+	struct kernel_ethtool_coalesce kernel_coalesce = {};
 	struct ethtool_coalesce coalesce;
 	int ret;
 
-	if (!dev->ethtool_ops->set_coalesce)
+	if (!dev->ethtool_ops->set_coalesce && !dev->ethtool_ops->get_coalesce)
 		return -EOPNOTSUPP;
 
+	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
+					     NULL);
+	if (ret)
+		return ret;
+
 	if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
 		return -EFAULT;
 
 	if (!ethtool_set_coalesce_supported(dev, &coalesce))
 		return -EOPNOTSUPP;
 
-	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce, &kernel_coalesce,
+					     NULL);
 	if (!ret)
 		ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
 	return ret;
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 8abcbc1..868e33e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -369,7 +369,7 @@ extern const struct nla_policy ethnl_rings_set_policy[ETHTOOL_A_RINGS_TX + 1];
 extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEADER + 1];
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
-extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL + 1];
+extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
 extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
 extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
-- 
2.7.4

