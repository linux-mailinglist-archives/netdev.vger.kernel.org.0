Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E503913A5
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhEZJ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:29:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3950 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbhEZJ32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 05:29:28 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FqlsT6ZxpzCxBq;
        Wed, 26 May 2021 17:25:01 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 17:27:54 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 17:27:53 +0800
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
Subject: [RFC net-next 1/4] ethtool: extend coalesce API
Date:   Wed, 26 May 2021 17:27:39 +0800
Message-ID: <1622021262-8881-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
References: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support more coalesce parameters, expand struct
ethtool_coalesce to struct kernel_ethtool_coalesce, keep
struct ethtool_coalesce as the base(legacy) part, then the
new parameter can be added into struct kernel_ethtool_coalesce.

Also add new extack parameter for .set_coalesce and .get_coalesce
then some extra info can return to user with the netlink API.

Suggested-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |  24 +++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |  22 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |  24 +++--
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |  40 ++++----
 drivers/net/ethernet/broadcom/bcmsysport.c         |  40 ++++----
 drivers/net/ethernet/broadcom/bnx2.c               |  50 +++++-----
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |  18 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  52 ++++++-----
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  36 ++++----
 drivers/net/ethernet/broadcom/tg3.c                |  54 ++++++-----
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |  38 ++++----
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c |  66 ++++++-------
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |   6 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |  22 +++--
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  16 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |  29 +++---
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  16 ++--
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |  32 ++++---
 drivers/net/ethernet/cortina/gemini.c              |  22 +++--
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  36 +++++---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  16 ++--
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  28 +++---
 drivers/net/ethernet/freescale/fec_main.c          |  48 +++++-----
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  44 +++++----
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  24 +++--
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  48 +++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  42 +++++----
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |  13 ++-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |  28 +++---
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  28 +++---
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c   |  28 +++---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  14 ++-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  14 ++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  18 ++--
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |  48 +++++-----
 drivers/net/ethernet/intel/igbvf/ethtool.c         |  26 +++---
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  48 +++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |  34 ++++---
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |  34 ++++---
 drivers/net/ethernet/jme.c                         |  40 ++++----
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  20 ++--
 drivers/net/ethernet/marvell/mvneta.c              |  20 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  24 +++--
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  63 +++++++------
 drivers/net/ethernet/marvell/skge.c                |  36 ++++----
 drivers/net/ethernet/marvell/sky2.c                |  63 +++++++------
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  74 ++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  12 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  12 ++-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  12 ++-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  16 ++--
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  36 ++++----
 drivers/net/ethernet/ni/nixge.c                    |  20 ++--
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  42 +++++----
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |  36 ++++----
 drivers/net/ethernet/qlogic/qede/qede.h            |   3 +-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |  24 +++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  26 +++---
 drivers/net/ethernet/realtek/r8169_main.c          |  35 ++++---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c |  14 ++-
 drivers/net/ethernet/sfc/ethtool.c                 |  36 ++++----
 drivers/net/ethernet/sfc/falcon/ethtool.c          |  36 ++++----
 drivers/net/ethernet/socionext/netsec.c            |  49 +++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  14 ++-
 drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c |  20 ++--
 drivers/net/ethernet/tehuti/tehuti.c               |  28 +++---
 drivers/net/ethernet/ti/cpsw.c                     |   6 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c             |  12 ++-
 drivers/net/ethernet/ti/cpsw_new.c                 |   6 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |   6 +-
 drivers/net/ethernet/ti/davinci_emac.c             |  20 ++--
 drivers/net/ethernet/via/via-velocity.c            |  32 ++++---
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  32 ++++---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  20 ++--
 drivers/net/netdevsim/ethtool.c                    |  12 ++-
 drivers/net/tun.c                                  |  14 ++-
 drivers/net/usb/r8152.c                            |  16 ++--
 drivers/net/virtio_net.c                           |  18 ++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |  68 +++++++-------
 drivers/net/wireless/ath/wil6210/ethtool.c         |  25 +++--
 drivers/staging/qlge/qlge_ethtool.c                |  10 +-
 include/linux/ethtool.h                            |  13 ++-
 net/ethtool/coalesce.c                             | 102 +++++++++++----------
 net/ethtool/ioctl.c                                |  69 +++++++-------
 84 files changed, 1436 insertions(+), 1082 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 823f683..b712f3a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -72,40 +72,44 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
 }
 
 static int ipoib_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct ethtool_coalesce *cbase = &coal->base;
 
-	coal->rx_coalesce_usecs = priv->ethtool.coalesce_usecs;
-	coal->rx_max_coalesced_frames = priv->ethtool.max_coalesced_frames;
+	cbase->rx_coalesce_usecs = priv->ethtool.coalesce_usecs;
+	cbase->rx_max_coalesced_frames = priv->ethtool.max_coalesced_frames;
 
 	return 0;
 }
 
 static int ipoib_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct ethtool_coalesce *cbase = &coal->base;
 	int ret;
 
 	/*
 	 * These values are saved in the private data and returned
 	 * when ipoib_get_coalesce() is called
 	 */
-	if (coal->rx_coalesce_usecs       > 0xffff ||
-	    coal->rx_max_coalesced_frames > 0xffff)
+	if (cbase->rx_coalesce_usecs       > 0xffff ||
+	    cbase->rx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
 
 	ret = rdma_set_cq_moderation(priv->recv_cq,
-				     coal->rx_max_coalesced_frames,
-				     coal->rx_coalesce_usecs);
+				     cbase->rx_max_coalesced_frames,
+				     cbase->rx_coalesce_usecs);
 	if (ret && ret != -EOPNOTSUPP) {
 		ipoib_warn(priv, "failed modifying CQ (%d)\n", ret);
 		return ret;
 	}
 
-	priv->ethtool.coalesce_usecs       = coal->rx_coalesce_usecs;
-	priv->ethtool.max_coalesced_frames = coal->rx_max_coalesced_frames;
+	priv->ethtool.coalesce_usecs       = cbase->rx_coalesce_usecs;
+	priv->ethtool.max_coalesced_frames = cbase->rx_max_coalesced_frames;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 2fe7cce..7364174 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -353,23 +353,25 @@ static int ena_get_link_ksettings(struct net_device *netdev,
 }
 
 static int ena_get_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *coalesce)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 
 	if (!ena_com_interrupt_moderation_supported(ena_dev))
 		return -EOPNOTSUPP;
 
-	coalesce->tx_coalesce_usecs =
+	coal_base->tx_coalesce_usecs =
 		ena_com_get_nonadaptive_moderation_interval_tx(ena_dev) *
 			ena_dev->intr_delay_resolution;
 
-	coalesce->rx_coalesce_usecs =
+	coal_base->rx_coalesce_usecs =
 		ena_com_get_nonadaptive_moderation_interval_rx(ena_dev)
 		* ena_dev->intr_delay_resolution;
 
-	coalesce->use_adaptive_rx_coalesce =
+	coal_base->use_adaptive_rx_coalesce =
 		ena_com_get_adaptive_moderation_enabled(ena_dev);
 
 	return 0;
@@ -398,8 +400,10 @@ static void ena_update_rx_rings_nonadaptive_intr_moderation(struct ena_adapter *
 }
 
 static int ena_set_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *coalesce)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	int rc;
@@ -408,24 +412,24 @@ static int ena_set_coalesce(struct net_device *net_dev,
 		return -EOPNOTSUPP;
 
 	rc = ena_com_update_nonadaptive_moderation_interval_tx(ena_dev,
-							       coalesce->tx_coalesce_usecs);
+							       coal_base->tx_coalesce_usecs);
 	if (rc)
 		return rc;
 
 	ena_update_tx_rings_nonadaptive_intr_moderation(adapter);
 
 	rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
-							       coalesce->rx_coalesce_usecs);
+							       coal_base->rx_coalesce_usecs);
 	if (rc)
 		return rc;
 
 	ena_update_rx_rings_nonadaptive_intr_moderation(adapter);
 
-	if (coalesce->use_adaptive_rx_coalesce &&
+	if (coal_base->use_adaptive_rx_coalesce &&
 	    !ena_com_get_adaptive_moderation_enabled(ena_dev))
 		ena_com_enable_adaptive_moderation(ena_dev);
 
-	if (!coalesce->use_adaptive_rx_coalesce &&
+	if (!coal_base->use_adaptive_rx_coalesce &&
 	    ena_com_get_adaptive_moderation_enabled(ena_dev))
 		ena_com_disable_adaptive_moderation(ena_dev);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 61f39a0..41a871c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -428,31 +428,35 @@ static void xgbe_set_msglevel(struct net_device *netdev, u32 msglevel)
 }
 
 static int xgbe_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 
-	memset(ec, 0, sizeof(struct ethtool_coalesce));
+	memset(coal_base, 0, sizeof(struct ethtool_coalesce));
 
-	ec->rx_coalesce_usecs = pdata->rx_usecs;
-	ec->rx_max_coalesced_frames = pdata->rx_frames;
+	coal_base->rx_coalesce_usecs = pdata->rx_usecs;
+	coal_base->rx_max_coalesced_frames = pdata->rx_frames;
 
-	ec->tx_max_coalesced_frames = pdata->tx_frames;
+	coal_base->tx_max_coalesced_frames = pdata->tx_frames;
 
 	return 0;
 }
 
 static int xgbe_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
 	unsigned int rx_frames, rx_riwt, rx_usecs;
 	unsigned int tx_frames;
 
-	rx_riwt = hw_if->usec_to_riwt(pdata, ec->rx_coalesce_usecs);
-	rx_usecs = ec->rx_coalesce_usecs;
-	rx_frames = ec->rx_max_coalesced_frames;
+	rx_riwt = hw_if->usec_to_riwt(pdata, coal_base->rx_coalesce_usecs);
+	rx_usecs = coal_base->rx_coalesce_usecs;
+	rx_frames = coal_base->rx_max_coalesced_frames;
 
 	/* Use smallest possible value if conversion resulted in zero */
 	if (rx_usecs && !rx_riwt)
@@ -470,7 +474,7 @@ static int xgbe_set_coalesce(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	tx_frames = ec->tx_max_coalesced_frames;
+	tx_frames = coal_base->tx_max_coalesced_frames;
 
 	/* Check the bounds of values for Tx */
 	if (tx_frames > pdata->tx_desc_count) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index de2a934..d3b2704 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -547,8 +547,10 @@ static int aq_ethtool_set_rxnfc(struct net_device *ndev,
 }
 
 static int aq_ethtool_get_coalesce(struct net_device *ndev,
-				   struct ethtool_coalesce *coal)
+				   struct netlink_ext_ack *extack,
+				   struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
 
@@ -556,23 +558,25 @@ static int aq_ethtool_get_coalesce(struct net_device *ndev,
 
 	if (cfg->itr == AQ_CFG_INTERRUPT_MODERATION_ON ||
 	    cfg->itr == AQ_CFG_INTERRUPT_MODERATION_AUTO) {
-		coal->rx_coalesce_usecs = cfg->rx_itr;
-		coal->tx_coalesce_usecs = cfg->tx_itr;
-		coal->rx_max_coalesced_frames = 0;
-		coal->tx_max_coalesced_frames = 0;
+		coal_base->rx_coalesce_usecs = cfg->rx_itr;
+		coal_base->tx_coalesce_usecs = cfg->tx_itr;
+		coal_base->rx_max_coalesced_frames = 0;
+		coal_base->tx_max_coalesced_frames = 0;
 	} else {
-		coal->rx_coalesce_usecs = 0;
-		coal->tx_coalesce_usecs = 0;
-		coal->rx_max_coalesced_frames = 1;
-		coal->tx_max_coalesced_frames = 1;
+		coal_base->rx_coalesce_usecs = 0;
+		coal_base->tx_coalesce_usecs = 0;
+		coal_base->rx_max_coalesced_frames = 1;
+		coal_base->tx_max_coalesced_frames = 1;
 	}
 
 	return 0;
 }
 
 static int aq_ethtool_set_coalesce(struct net_device *ndev,
-				   struct ethtool_coalesce *coal)
+				   struct netlink_ext_ack *extack,
+				   struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg;
 
@@ -580,25 +584,25 @@ static int aq_ethtool_set_coalesce(struct net_device *ndev,
 
 	/* Atlantic only supports timing based coalescing
 	 */
-	if (coal->rx_max_coalesced_frames > 1 ||
-	    coal->tx_max_coalesced_frames > 1)
+	if (coal_base->rx_max_coalesced_frames > 1 ||
+	    coal_base->tx_max_coalesced_frames > 1)
 		return -EOPNOTSUPP;
 
 	/* We do not support frame counting. Check this
 	 */
-	if (!(coal->rx_max_coalesced_frames == !coal->rx_coalesce_usecs))
+	if (!(coal_base->rx_max_coalesced_frames == !coal_base->rx_coalesce_usecs))
 		return -EOPNOTSUPP;
-	if (!(coal->tx_max_coalesced_frames == !coal->tx_coalesce_usecs))
+	if (!(coal_base->tx_max_coalesced_frames == !coal_base->tx_coalesce_usecs))
 		return -EOPNOTSUPP;
 
-	if (coal->rx_coalesce_usecs > AQ_CFG_INTERRUPT_MODERATION_USEC_MAX ||
-	    coal->tx_coalesce_usecs > AQ_CFG_INTERRUPT_MODERATION_USEC_MAX)
+	if (coal_base->rx_coalesce_usecs > AQ_CFG_INTERRUPT_MODERATION_USEC_MAX ||
+	    coal_base->tx_coalesce_usecs > AQ_CFG_INTERRUPT_MODERATION_USEC_MAX)
 		return -EINVAL;
 
 	cfg->itr = AQ_CFG_INTERRUPT_MODERATION_ON;
 
-	cfg->rx_itr = coal->rx_coalesce_usecs;
-	cfg->tx_itr = coal->tx_coalesce_usecs;
+	cfg->rx_itr = coal_base->rx_coalesce_usecs;
+	cfg->tx_itr = coal_base->tx_coalesce_usecs;
 
 	return aq_nic_update_interrupt_moderation_settings(aq_nic);
 }
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index d9f0f0d..b19b372 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -607,28 +607,32 @@ static void bcm_sysport_set_tx_coalesce(struct bcm_sysport_tx_ring *ring,
 }
 
 static int bcm_sysport_get_coalesce(struct net_device *dev,
-				    struct ethtool_coalesce *ec)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	u32 reg;
 
 	reg = tdma_readl(priv, TDMA_DESC_RING_INTR_CONTROL(0));
 
-	ec->tx_coalesce_usecs = (reg >> RING_TIMEOUT_SHIFT) * 8192 / 1000;
-	ec->tx_max_coalesced_frames = reg & RING_INTR_THRESH_MASK;
+	coal_base->tx_coalesce_usecs = (reg >> RING_TIMEOUT_SHIFT) * 8192 / 1000;
+	coal_base->tx_max_coalesced_frames = reg & RING_INTR_THRESH_MASK;
 
 	reg = rdma_readl(priv, RDMA_MBDONE_INTR);
 
-	ec->rx_coalesce_usecs = (reg >> RDMA_TIMEOUT_SHIFT) * 8192 / 1000;
-	ec->rx_max_coalesced_frames = reg & RDMA_INTR_THRESH_MASK;
-	ec->use_adaptive_rx_coalesce = priv->dim.use_dim;
+	coal_base->rx_coalesce_usecs = (reg >> RDMA_TIMEOUT_SHIFT) * 8192 / 1000;
+	coal_base->rx_max_coalesced_frames = reg & RDMA_INTR_THRESH_MASK;
+	coal_base->use_adaptive_rx_coalesce = priv->dim.use_dim;
 
 	return 0;
 }
 
 static int bcm_sysport_set_coalesce(struct net_device *dev,
-				    struct ethtool_coalesce *ec)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct dim_cq_moder moder;
 	u32 usecs, pkts;
@@ -638,31 +642,31 @@ static int bcm_sysport_set_coalesce(struct net_device *dev,
 	 * divided by 1024, which yield roughly 8.192 us, our maximum value has
 	 * to fit in the RING_TIMEOUT_MASK (16 bits).
 	 */
-	if (ec->tx_max_coalesced_frames > RING_INTR_THRESH_MASK ||
-	    ec->tx_coalesce_usecs > (RING_TIMEOUT_MASK * 8) + 1 ||
-	    ec->rx_max_coalesced_frames > RDMA_INTR_THRESH_MASK ||
-	    ec->rx_coalesce_usecs > (RDMA_TIMEOUT_MASK * 8) + 1)
+	if (coal_base->tx_max_coalesced_frames > RING_INTR_THRESH_MASK ||
+	    coal_base->tx_coalesce_usecs > (RING_TIMEOUT_MASK * 8) + 1 ||
+	    coal_base->rx_max_coalesced_frames > RDMA_INTR_THRESH_MASK ||
+	    coal_base->rx_coalesce_usecs > (RDMA_TIMEOUT_MASK * 8) + 1)
 		return -EINVAL;
 
-	if ((ec->tx_coalesce_usecs == 0 && ec->tx_max_coalesced_frames == 0) ||
-	    (ec->rx_coalesce_usecs == 0 && ec->rx_max_coalesced_frames == 0))
+	if ((coal_base->tx_coalesce_usecs == 0 && coal_base->tx_max_coalesced_frames == 0) ||
+	    (coal_base->rx_coalesce_usecs == 0 && coal_base->rx_max_coalesced_frames == 0))
 		return -EINVAL;
 
 	for (i = 0; i < dev->num_tx_queues; i++)
-		bcm_sysport_set_tx_coalesce(&priv->tx_rings[i], ec);
+		bcm_sysport_set_tx_coalesce(&priv->tx_rings[i], coal_base);
 
-	priv->rx_coalesce_usecs = ec->rx_coalesce_usecs;
-	priv->rx_max_coalesced_frames = ec->rx_max_coalesced_frames;
+	priv->rx_coalesce_usecs = coal_base->rx_coalesce_usecs;
+	priv->rx_max_coalesced_frames = coal_base->rx_max_coalesced_frames;
 	usecs = priv->rx_coalesce_usecs;
 	pkts = priv->rx_max_coalesced_frames;
 
-	if (ec->use_adaptive_rx_coalesce && !priv->dim.use_dim) {
+	if (coal_base->use_adaptive_rx_coalesce && !priv->dim.use_dim) {
 		moder = net_dim_get_def_rx_moderation(priv->dim.dim.mode);
 		usecs = moder.usec;
 		pkts = moder.pkts;
 	}
 
-	priv->dim.use_dim = ec->use_adaptive_rx_coalesce;
+	priv->dim.use_dim = coal_base->use_adaptive_rx_coalesce;
 
 	/* Apply desired coalescing parameters */
 	bcm_sysport_set_rx_coalesce(priv, usecs, pkts);
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 2c5f36b..9577fbb 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7241,60 +7241,64 @@ bnx2_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	return rc;
 }
 
-static int
-bnx2_get_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+static int bnx2_get_coalesce(struct net_device *dev,
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct bnx2 *bp = netdev_priv(dev);
 
-	memset(coal, 0, sizeof(struct ethtool_coalesce));
+	memset(coal_base, 0, sizeof(struct ethtool_coalesce));
 
-	coal->rx_coalesce_usecs = bp->rx_ticks;
-	coal->rx_max_coalesced_frames = bp->rx_quick_cons_trip;
-	coal->rx_coalesce_usecs_irq = bp->rx_ticks_int;
-	coal->rx_max_coalesced_frames_irq = bp->rx_quick_cons_trip_int;
+	coal_base->rx_coalesce_usecs = bp->rx_ticks;
+	coal_base->rx_max_coalesced_frames = bp->rx_quick_cons_trip;
+	coal_base->rx_coalesce_usecs_irq = bp->rx_ticks_int;
+	coal_base->rx_max_coalesced_frames_irq = bp->rx_quick_cons_trip_int;
 
-	coal->tx_coalesce_usecs = bp->tx_ticks;
-	coal->tx_max_coalesced_frames = bp->tx_quick_cons_trip;
-	coal->tx_coalesce_usecs_irq = bp->tx_ticks_int;
-	coal->tx_max_coalesced_frames_irq = bp->tx_quick_cons_trip_int;
+	coal_base->tx_coalesce_usecs = bp->tx_ticks;
+	coal_base->tx_max_coalesced_frames = bp->tx_quick_cons_trip;
+	coal_base->tx_coalesce_usecs_irq = bp->tx_ticks_int;
+	coal_base->tx_max_coalesced_frames_irq = bp->tx_quick_cons_trip_int;
 
-	coal->stats_block_coalesce_usecs = bp->stats_ticks;
+	coal_base->stats_block_coalesce_usecs = bp->stats_ticks;
 
 	return 0;
 }
 
-static int
-bnx2_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+static int bnx2_set_coalesce(struct net_device *dev,
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct bnx2 *bp = netdev_priv(dev);
 
-	bp->rx_ticks = (u16) coal->rx_coalesce_usecs;
+	bp->rx_ticks = (u16)coal_base->rx_coalesce_usecs;
 	if (bp->rx_ticks > 0x3ff) bp->rx_ticks = 0x3ff;
 
-	bp->rx_quick_cons_trip = (u16) coal->rx_max_coalesced_frames;
+	bp->rx_quick_cons_trip = (u16)coal_base->rx_max_coalesced_frames;
 	if (bp->rx_quick_cons_trip > 0xff) bp->rx_quick_cons_trip = 0xff;
 
-	bp->rx_ticks_int = (u16) coal->rx_coalesce_usecs_irq;
+	bp->rx_ticks_int = (u16)coal_base->rx_coalesce_usecs_irq;
 	if (bp->rx_ticks_int > 0x3ff) bp->rx_ticks_int = 0x3ff;
 
-	bp->rx_quick_cons_trip_int = (u16) coal->rx_max_coalesced_frames_irq;
+	bp->rx_quick_cons_trip_int = (u16)coal_base->rx_max_coalesced_frames_irq;
 	if (bp->rx_quick_cons_trip_int > 0xff)
 		bp->rx_quick_cons_trip_int = 0xff;
 
-	bp->tx_ticks = (u16) coal->tx_coalesce_usecs;
+	bp->tx_ticks = (u16)coal_base->tx_coalesce_usecs;
 	if (bp->tx_ticks > 0x3ff) bp->tx_ticks = 0x3ff;
 
-	bp->tx_quick_cons_trip = (u16) coal->tx_max_coalesced_frames;
+	bp->tx_quick_cons_trip = (u16)coal_base->tx_max_coalesced_frames;
 	if (bp->tx_quick_cons_trip > 0xff) bp->tx_quick_cons_trip = 0xff;
 
-	bp->tx_ticks_int = (u16) coal->tx_coalesce_usecs_irq;
+	bp->tx_ticks_int = (u16)coal_base->tx_coalesce_usecs_irq;
 	if (bp->tx_ticks_int > 0x3ff) bp->tx_ticks_int = 0x3ff;
 
-	bp->tx_quick_cons_trip_int = (u16) coal->tx_max_coalesced_frames_irq;
+	bp->tx_quick_cons_trip_int = (u16)coal_base->tx_max_coalesced_frames_irq;
 	if (bp->tx_quick_cons_trip_int > 0xff) bp->tx_quick_cons_trip_int =
 		0xff;
 
-	bp->stats_ticks = coal->stats_block_coalesce_usecs;
+	bp->stats_ticks = coal_base->stats_block_coalesce_usecs;
 	if (bp->flags & BNX2_FLAG_BROKEN_STATS) {
 		if (bp->stats_ticks != 0 && bp->stats_ticks != USEC_PER_SEC)
 			bp->stats_ticks = USEC_PER_SEC;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index 32245bb..214067b0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1878,28 +1878,32 @@ static int bnx2x_set_eeprom(struct net_device *dev,
 }
 
 static int bnx2x_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct bnx2x *bp = netdev_priv(dev);
 
-	memset(coal, 0, sizeof(struct ethtool_coalesce));
+	memset(coal_base, 0, sizeof(struct ethtool_coalesce));
 
-	coal->rx_coalesce_usecs = bp->rx_ticks;
-	coal->tx_coalesce_usecs = bp->tx_ticks;
+	coal_base->rx_coalesce_usecs = bp->rx_ticks;
+	coal_base->tx_coalesce_usecs = bp->tx_ticks;
 
 	return 0;
 }
 
 static int bnx2x_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct bnx2x *bp = netdev_priv(dev);
 
-	bp->rx_ticks = (u16)coal->rx_coalesce_usecs;
+	bp->rx_ticks = (u16)coal_base->rx_coalesce_usecs;
 	if (bp->rx_ticks > BNX2X_MAX_COALESCE_TOUT)
 		bp->rx_ticks = BNX2X_MAX_COALESCE_TOUT;
 
-	bp->tx_ticks = (u16)coal->tx_coalesce_usecs;
+	bp->tx_ticks = (u16)coal_base->tx_coalesce_usecs;
 	if (bp->tx_ticks > BNX2X_MAX_COALESCE_TOUT)
 		bp->tx_ticks = BNX2X_MAX_COALESCE_TOUT;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index c664ec5..77be93e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -45,45 +45,49 @@ static void bnxt_set_msglevel(struct net_device *dev, u32 value)
 }
 
 static int bnxt_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_coal *hw_coal;
 	u16 mult;
 
-	memset(coal, 0, sizeof(*coal));
+	memset(coal_base, 0, sizeof(*coal_base));
 
-	coal->use_adaptive_rx_coalesce = bp->flags & BNXT_FLAG_DIM;
+	coal_base->use_adaptive_rx_coalesce = bp->flags & BNXT_FLAG_DIM;
 
 	hw_coal = &bp->rx_coal;
 	mult = hw_coal->bufs_per_record;
-	coal->rx_coalesce_usecs = hw_coal->coal_ticks;
-	coal->rx_max_coalesced_frames = hw_coal->coal_bufs / mult;
-	coal->rx_coalesce_usecs_irq = hw_coal->coal_ticks_irq;
-	coal->rx_max_coalesced_frames_irq = hw_coal->coal_bufs_irq / mult;
+	coal_base->rx_coalesce_usecs = hw_coal->coal_ticks;
+	coal_base->rx_max_coalesced_frames = hw_coal->coal_bufs / mult;
+	coal_base->rx_coalesce_usecs_irq = hw_coal->coal_ticks_irq;
+	coal_base->rx_max_coalesced_frames_irq = hw_coal->coal_bufs_irq / mult;
 
 	hw_coal = &bp->tx_coal;
 	mult = hw_coal->bufs_per_record;
-	coal->tx_coalesce_usecs = hw_coal->coal_ticks;
-	coal->tx_max_coalesced_frames = hw_coal->coal_bufs / mult;
-	coal->tx_coalesce_usecs_irq = hw_coal->coal_ticks_irq;
-	coal->tx_max_coalesced_frames_irq = hw_coal->coal_bufs_irq / mult;
+	coal_base->tx_coalesce_usecs = hw_coal->coal_ticks;
+	coal_base->tx_max_coalesced_frames = hw_coal->coal_bufs / mult;
+	coal_base->tx_coalesce_usecs_irq = hw_coal->coal_ticks_irq;
+	coal_base->tx_max_coalesced_frames_irq = hw_coal->coal_bufs_irq / mult;
 
-	coal->stats_block_coalesce_usecs = bp->stats_coal_ticks;
+	coal_base->stats_block_coalesce_usecs = bp->stats_coal_ticks;
 
 	return 0;
 }
 
 static int bnxt_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct bnxt *bp = netdev_priv(dev);
 	bool update_stats = false;
 	struct bnxt_coal *hw_coal;
 	int rc = 0;
 	u16 mult;
 
-	if (coal->use_adaptive_rx_coalesce) {
+	if (coal_base->use_adaptive_rx_coalesce) {
 		bp->flags |= BNXT_FLAG_DIM;
 	} else {
 		if (bp->flags & BNXT_FLAG_DIM) {
@@ -94,20 +98,20 @@ static int bnxt_set_coalesce(struct net_device *dev,
 
 	hw_coal = &bp->rx_coal;
 	mult = hw_coal->bufs_per_record;
-	hw_coal->coal_ticks = coal->rx_coalesce_usecs;
-	hw_coal->coal_bufs = coal->rx_max_coalesced_frames * mult;
-	hw_coal->coal_ticks_irq = coal->rx_coalesce_usecs_irq;
-	hw_coal->coal_bufs_irq = coal->rx_max_coalesced_frames_irq * mult;
+	hw_coal->coal_ticks = coal_base->rx_coalesce_usecs;
+	hw_coal->coal_bufs = coal_base->rx_max_coalesced_frames * mult;
+	hw_coal->coal_ticks_irq = coal_base->rx_coalesce_usecs_irq;
+	hw_coal->coal_bufs_irq = coal_base->rx_max_coalesced_frames_irq * mult;
 
 	hw_coal = &bp->tx_coal;
 	mult = hw_coal->bufs_per_record;
-	hw_coal->coal_ticks = coal->tx_coalesce_usecs;
-	hw_coal->coal_bufs = coal->tx_max_coalesced_frames * mult;
-	hw_coal->coal_ticks_irq = coal->tx_coalesce_usecs_irq;
-	hw_coal->coal_bufs_irq = coal->tx_max_coalesced_frames_irq * mult;
+	hw_coal->coal_ticks = coal_base->tx_coalesce_usecs;
+	hw_coal->coal_bufs = coal_base->tx_max_coalesced_frames * mult;
+	hw_coal->coal_ticks_irq = coal_base->tx_coalesce_usecs_irq;
+	hw_coal->coal_bufs_irq = coal_base->tx_max_coalesced_frames_irq * mult;
 
-	if (bp->stats_coal_ticks != coal->stats_block_coalesce_usecs) {
-		u32 stats_ticks = coal->stats_block_coalesce_usecs;
+	if (bp->stats_coal_ticks != coal_base->stats_block_coalesce_usecs) {
+		u32 stats_ticks = coal_base->stats_block_coalesce_usecs;
 
 		/* Allow 0, which means disable. */
 		if (stats_ticks)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023..c2ae8af 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -828,27 +828,29 @@ static void bcmgenet_set_msglevel(struct net_device *dev, u32 level)
 }
 
 static int bcmgenet_get_coalesce(struct net_device *dev,
-				 struct ethtool_coalesce *ec)
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rx_ring *ring;
 	unsigned int i;
 
-	ec->tx_max_coalesced_frames =
+	coal_base->tx_max_coalesced_frames =
 		bcmgenet_tdma_ring_readl(priv, DESC_INDEX,
 					 DMA_MBUF_DONE_THRESH);
-	ec->rx_max_coalesced_frames =
+	coal_base->rx_max_coalesced_frames =
 		bcmgenet_rdma_ring_readl(priv, DESC_INDEX,
 					 DMA_MBUF_DONE_THRESH);
-	ec->rx_coalesce_usecs =
+	coal_base->rx_coalesce_usecs =
 		bcmgenet_rdma_readl(priv, DMA_RING16_TIMEOUT) * 8192 / 1000;
 
 	for (i = 0; i < priv->hw_params->rx_queues; i++) {
 		ring = &priv->rx_rings[i];
-		ec->use_adaptive_rx_coalesce |= ring->dim.use_dim;
+		coal_base->use_adaptive_rx_coalesce |= ring->dim.use_dim;
 	}
 	ring = &priv->rx_rings[DESC_INDEX];
-	ec->use_adaptive_rx_coalesce |= ring->dim.use_dim;
+	coal_base->use_adaptive_rx_coalesce |= ring->dim.use_dim;
 
 	return 0;
 }
@@ -890,8 +892,10 @@ static void bcmgenet_set_ring_rx_coalesce(struct bcmgenet_rx_ring *ring,
 }
 
 static int bcmgenet_set_coalesce(struct net_device *dev,
-				 struct ethtool_coalesce *ec)
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	unsigned int i;
 
@@ -899,13 +903,13 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
 	 * divided by 1024, which yields roughly 8.192us, our maximum value
 	 * has to fit in the DMA_TIMEOUT_MASK (16 bits)
 	 */
-	if (ec->tx_max_coalesced_frames > DMA_INTR_THRESHOLD_MASK ||
-	    ec->tx_max_coalesced_frames == 0 ||
-	    ec->rx_max_coalesced_frames > DMA_INTR_THRESHOLD_MASK ||
-	    ec->rx_coalesce_usecs > (DMA_TIMEOUT_MASK * 8) + 1)
+	if (coal_base->tx_max_coalesced_frames > DMA_INTR_THRESHOLD_MASK ||
+	    coal_base->tx_max_coalesced_frames == 0 ||
+	    coal_base->rx_max_coalesced_frames > DMA_INTR_THRESHOLD_MASK ||
+	    coal_base->rx_coalesce_usecs > (DMA_TIMEOUT_MASK * 8) + 1)
 		return -EINVAL;
 
-	if (ec->rx_coalesce_usecs == 0 && ec->rx_max_coalesced_frames == 0)
+	if (coal_base->rx_coalesce_usecs == 0 && coal_base->rx_max_coalesced_frames == 0)
 		return -EINVAL;
 
 	/* GENET TDMA hardware does not support a configurable timeout, but will
@@ -918,15 +922,15 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
 	 */
 	for (i = 0; i < priv->hw_params->tx_queues; i++)
 		bcmgenet_tdma_ring_writel(priv, i,
-					  ec->tx_max_coalesced_frames,
+					  coal_base->tx_max_coalesced_frames,
 					  DMA_MBUF_DONE_THRESH);
 	bcmgenet_tdma_ring_writel(priv, DESC_INDEX,
-				  ec->tx_max_coalesced_frames,
+				  coal_base->tx_max_coalesced_frames,
 				  DMA_MBUF_DONE_THRESH);
 
 	for (i = 0; i < priv->hw_params->rx_queues; i++)
-		bcmgenet_set_ring_rx_coalesce(&priv->rx_rings[i], ec);
-	bcmgenet_set_ring_rx_coalesce(&priv->rx_rings[DESC_INDEX], ec);
+		bcmgenet_set_ring_rx_coalesce(&priv->rx_rings[i], coal_base);
+	bcmgenet_set_ring_rx_coalesce(&priv->rx_rings[DESC_INDEX], coal_base);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index b0e4964..d7832ca 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14040,16 +14040,22 @@ static int tg3_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return -EOPNOTSUPP;
 }
 
-static int tg3_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int tg3_get_coalesce(struct net_device *dev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct tg3 *tp = netdev_priv(dev);
 
-	memcpy(ec, &tp->coal, sizeof(*ec));
+	memcpy(coal_base, &tp->coal, sizeof(*coal_base));
 	return 0;
 }
 
-static int tg3_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int tg3_set_coalesce(struct net_device *dev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct tg3 *tp = netdev_priv(dev);
 	u32 max_rxcoal_tick_int = 0, max_txcoal_tick_int = 0;
 	u32 max_stat_coal_ticks = 0, min_stat_coal_ticks = 0;
@@ -14061,30 +14067,30 @@ static int tg3_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 		min_stat_coal_ticks = MIN_STAT_COAL_TICKS;
 	}
 
-	if ((ec->rx_coalesce_usecs > MAX_RXCOL_TICKS) ||
-	    (!ec->rx_coalesce_usecs) ||
-	    (ec->tx_coalesce_usecs > MAX_TXCOL_TICKS) ||
-	    (!ec->tx_coalesce_usecs) ||
-	    (ec->rx_max_coalesced_frames > MAX_RXMAX_FRAMES) ||
-	    (ec->tx_max_coalesced_frames > MAX_TXMAX_FRAMES) ||
-	    (ec->rx_coalesce_usecs_irq > max_rxcoal_tick_int) ||
-	    (ec->tx_coalesce_usecs_irq > max_txcoal_tick_int) ||
-	    (ec->rx_max_coalesced_frames_irq > MAX_RXCOAL_MAXF_INT) ||
-	    (ec->tx_max_coalesced_frames_irq > MAX_TXCOAL_MAXF_INT) ||
-	    (ec->stats_block_coalesce_usecs > max_stat_coal_ticks) ||
-	    (ec->stats_block_coalesce_usecs < min_stat_coal_ticks))
+	if ((coal_base->rx_coalesce_usecs > MAX_RXCOL_TICKS) ||
+	    (!coal_base->rx_coalesce_usecs) ||
+	    (coal_base->tx_coalesce_usecs > MAX_TXCOL_TICKS) ||
+	    (!coal_base->tx_coalesce_usecs) ||
+	    (coal_base->rx_max_coalesced_frames > MAX_RXMAX_FRAMES) ||
+	    (coal_base->tx_max_coalesced_frames > MAX_TXMAX_FRAMES) ||
+	    (coal_base->rx_coalesce_usecs_irq > max_rxcoal_tick_int) ||
+	    (coal_base->tx_coalesce_usecs_irq > max_txcoal_tick_int) ||
+	    (coal_base->rx_max_coalesced_frames_irq > MAX_RXCOAL_MAXF_INT) ||
+	    (coal_base->tx_max_coalesced_frames_irq > MAX_TXCOAL_MAXF_INT) ||
+	    (coal_base->stats_block_coalesce_usecs > max_stat_coal_ticks) ||
+	    (coal_base->stats_block_coalesce_usecs < min_stat_coal_ticks))
 		return -EINVAL;
 
 	/* Only copy relevant parameters, ignore all others. */
-	tp->coal.rx_coalesce_usecs = ec->rx_coalesce_usecs;
-	tp->coal.tx_coalesce_usecs = ec->tx_coalesce_usecs;
-	tp->coal.rx_max_coalesced_frames = ec->rx_max_coalesced_frames;
-	tp->coal.tx_max_coalesced_frames = ec->tx_max_coalesced_frames;
-	tp->coal.rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
-	tp->coal.tx_coalesce_usecs_irq = ec->tx_coalesce_usecs_irq;
-	tp->coal.rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
-	tp->coal.tx_max_coalesced_frames_irq = ec->tx_max_coalesced_frames_irq;
-	tp->coal.stats_block_coalesce_usecs = ec->stats_block_coalesce_usecs;
+	tp->coal.rx_coalesce_usecs = coal_base->rx_coalesce_usecs;
+	tp->coal.tx_coalesce_usecs = coal_base->tx_coalesce_usecs;
+	tp->coal.rx_max_coalesced_frames = coal_base->rx_max_coalesced_frames;
+	tp->coal.tx_max_coalesced_frames = coal_base->tx_max_coalesced_frames;
+	tp->coal.rx_coalesce_usecs_irq = coal_base->rx_coalesce_usecs_irq;
+	tp->coal.tx_coalesce_usecs_irq = coal_base->tx_coalesce_usecs_irq;
+	tp->coal.rx_max_coalesced_frames_irq = coal_base->rx_max_coalesced_frames_irq;
+	tp->coal.tx_max_coalesced_frames_irq = coal_base->tx_max_coalesced_frames_irq;
+	tp->coal.stats_block_coalesce_usecs = coal_base->stats_block_coalesce_usecs;
 
 	if (netif_running(dev)) {
 		tg3_full_lock(tp, 0);
diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 265c2fa..6900537 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -307,41 +307,45 @@ bnad_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wolinfo)
 	wolinfo->wolopts = 0;
 }
 
-static int
-bnad_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *coalesce)
+static int bnad_get_coalesce(struct net_device *netdev,
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct bnad *bnad = netdev_priv(netdev);
 	unsigned long flags;
 
 	/* Lock rqd. to access bnad->bna_lock */
 	spin_lock_irqsave(&bnad->bna_lock, flags);
-	coalesce->use_adaptive_rx_coalesce =
+	coal_base->use_adaptive_rx_coalesce =
 		(bnad->cfg_flags & BNAD_CF_DIM_ENABLED) ? true : false;
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
 
-	coalesce->rx_coalesce_usecs = bnad->rx_coalescing_timeo *
+	coal_base->rx_coalesce_usecs = bnad->rx_coalescing_timeo *
 					BFI_COALESCING_TIMER_UNIT;
-	coalesce->tx_coalesce_usecs = bnad->tx_coalescing_timeo *
+	coal_base->tx_coalesce_usecs = bnad->tx_coalescing_timeo *
 					BFI_COALESCING_TIMER_UNIT;
-	coalesce->tx_max_coalesced_frames = BFI_TX_INTERPKT_COUNT;
+	coal_base->tx_max_coalesced_frames = BFI_TX_INTERPKT_COUNT;
 
 	return 0;
 }
 
-static int
-bnad_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *coalesce)
+static int bnad_set_coalesce(struct net_device *netdev,
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct bnad *bnad = netdev_priv(netdev);
 	unsigned long flags;
 	int to_del = 0;
 
-	if (coalesce->rx_coalesce_usecs == 0 ||
-	    coalesce->rx_coalesce_usecs >
+	if (coal_base->rx_coalesce_usecs == 0 ||
+	    coal_base->rx_coalesce_usecs >
 	    BFI_MAX_COALESCING_TIMEO * BFI_COALESCING_TIMER_UNIT)
 		return -EINVAL;
 
-	if (coalesce->tx_coalesce_usecs == 0 ||
-	    coalesce->tx_coalesce_usecs >
+	if (coal_base->tx_coalesce_usecs == 0 ||
+	    coal_base->tx_coalesce_usecs >
 	    BFI_MAX_COALESCING_TIMEO * BFI_COALESCING_TIMER_UNIT)
 		return -EINVAL;
 
@@ -352,7 +356,7 @@ bnad_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *coalesce)
 	 * stack.
 	 */
 	spin_lock_irqsave(&bnad->bna_lock, flags);
-	if (coalesce->use_adaptive_rx_coalesce) {
+	if (coal_base->use_adaptive_rx_coalesce) {
 		if (!(bnad->cfg_flags & BNAD_CF_DIM_ENABLED)) {
 			bnad->cfg_flags |= BNAD_CF_DIM_ENABLED;
 			bnad_dim_timer_start(bnad);
@@ -374,16 +378,16 @@ bnad_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *coalesce)
 			bnad_rx_coalescing_timeo_set(bnad);
 		}
 	}
-	if (bnad->tx_coalescing_timeo != coalesce->tx_coalesce_usecs /
+	if (bnad->tx_coalescing_timeo != coal_base->tx_coalesce_usecs /
 					BFI_COALESCING_TIMER_UNIT) {
-		bnad->tx_coalescing_timeo = coalesce->tx_coalesce_usecs /
+		bnad->tx_coalescing_timeo = coal_base->tx_coalesce_usecs /
 						BFI_COALESCING_TIMER_UNIT;
 		bnad_tx_coalescing_timeo_set(bnad);
 	}
 
-	if (bnad->rx_coalescing_timeo != coalesce->rx_coalesce_usecs /
+	if (bnad->rx_coalescing_timeo != coal_base->rx_coalesce_usecs /
 					BFI_COALESCING_TIMER_UNIT) {
-		bnad->rx_coalescing_timeo = coalesce->rx_coalesce_usecs /
+		bnad->rx_coalescing_timeo = coal_base->rx_coalesce_usecs /
 						BFI_COALESCING_TIMER_UNIT;
 
 		if (!(bnad->cfg_flags & BNAD_CF_DIM_ENABLED))
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index 66f2c553..0246109 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -2108,8 +2108,10 @@ static int octnet_set_intrmod_cfg(struct lio *lio,
 }
 
 static int lio_get_intr_coalesce(struct net_device *netdev,
-				 struct ethtool_coalesce *intr_coal)
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *intr_coal)
 {
+	struct ethtool_coalesce *coal_base = &intr_coal->base;
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
 	struct octeon_instr_queue *iq;
@@ -2122,12 +2124,12 @@ static int lio_get_intr_coalesce(struct net_device *netdev,
 	case OCTEON_CN23XX_PF_VID:
 	case OCTEON_CN23XX_VF_VID: {
 		if (!intrmod_cfg.rx_enable) {
-			intr_coal->rx_coalesce_usecs = oct->rx_coalesce_usecs;
-			intr_coal->rx_max_coalesced_frames =
+			coal_base->rx_coalesce_usecs = oct->rx_coalesce_usecs;
+			coal_base->rx_max_coalesced_frames =
 				oct->rx_max_coalesced_frames;
 		}
 		if (!intrmod_cfg.tx_enable)
-			intr_coal->tx_max_coalesced_frames =
+			coal_base->tx_max_coalesced_frames =
 				oct->tx_max_coalesced_frames;
 		break;
 	}
@@ -2137,13 +2139,13 @@ static int lio_get_intr_coalesce(struct net_device *netdev,
 			(struct octeon_cn6xxx *)oct->chip;
 
 		if (!intrmod_cfg.rx_enable) {
-			intr_coal->rx_coalesce_usecs =
+			coal_base->rx_coalesce_usecs =
 				CFG_GET_OQ_INTR_TIME(cn6xxx->conf);
-			intr_coal->rx_max_coalesced_frames =
+			coal_base->rx_max_coalesced_frames =
 				CFG_GET_OQ_INTR_PKT(cn6xxx->conf);
 		}
 		iq = oct->instr_queue[lio->linfo.txpciq[0].s.q_no];
-		intr_coal->tx_max_coalesced_frames = iq->fill_threshold;
+		coal_base->tx_max_coalesced_frames = iq->fill_threshold;
 		break;
 	}
 	default:
@@ -2151,30 +2153,30 @@ static int lio_get_intr_coalesce(struct net_device *netdev,
 		return -EINVAL;
 	}
 	if (intrmod_cfg.rx_enable) {
-		intr_coal->use_adaptive_rx_coalesce =
+		coal_base->use_adaptive_rx_coalesce =
 			intrmod_cfg.rx_enable;
-		intr_coal->rate_sample_interval =
+		coal_base->rate_sample_interval =
 			intrmod_cfg.check_intrvl;
-		intr_coal->pkt_rate_high =
+		coal_base->pkt_rate_high =
 			intrmod_cfg.maxpkt_ratethr;
-		intr_coal->pkt_rate_low =
+		coal_base->pkt_rate_low =
 			intrmod_cfg.minpkt_ratethr;
-		intr_coal->rx_max_coalesced_frames_high =
+		coal_base->rx_max_coalesced_frames_high =
 			intrmod_cfg.rx_maxcnt_trigger;
-		intr_coal->rx_coalesce_usecs_high =
+		coal_base->rx_coalesce_usecs_high =
 			intrmod_cfg.rx_maxtmr_trigger;
-		intr_coal->rx_coalesce_usecs_low =
+		coal_base->rx_coalesce_usecs_low =
 			intrmod_cfg.rx_mintmr_trigger;
-		intr_coal->rx_max_coalesced_frames_low =
+		coal_base->rx_max_coalesced_frames_low =
 			intrmod_cfg.rx_mincnt_trigger;
 	}
 	if ((OCTEON_CN23XX_PF(oct) || OCTEON_CN23XX_VF(oct)) &&
 	    (intrmod_cfg.tx_enable)) {
-		intr_coal->use_adaptive_tx_coalesce =
+		coal_base->use_adaptive_tx_coalesce =
 			intrmod_cfg.tx_enable;
-		intr_coal->tx_max_coalesced_frames_high =
+		coal_base->tx_max_coalesced_frames_high =
 			intrmod_cfg.tx_maxcnt_trigger;
-		intr_coal->tx_max_coalesced_frames_low =
+		coal_base->tx_max_coalesced_frames_low =
 			intrmod_cfg.tx_mincnt_trigger;
 	}
 	return 0;
@@ -2412,8 +2414,10 @@ oct_cfg_tx_intrcnt(struct lio *lio,
 }
 
 static int lio_set_intr_coalesce(struct net_device *netdev,
-				 struct ethtool_coalesce *intr_coal)
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *intr_coal)
 {
+	struct ethtool_coalesce *coal_base = &intr_coal->base;
 	struct lio *lio = GET_LIO(netdev);
 	int ret;
 	struct octeon_device *oct = lio->oct_dev;
@@ -2426,17 +2430,17 @@ static int lio_set_intr_coalesce(struct net_device *netdev,
 	case OCTEON_CN66XX:
 		db_min = CN6XXX_DB_MIN;
 		db_max = CN6XXX_DB_MAX;
-		if ((intr_coal->tx_max_coalesced_frames >= db_min) &&
-		    (intr_coal->tx_max_coalesced_frames <= db_max)) {
+		if ((coal_base->tx_max_coalesced_frames >= db_min) &&
+		    (coal_base->tx_max_coalesced_frames <= db_max)) {
 			for (j = 0; j < lio->linfo.num_txpciq; j++) {
 				q_no = lio->linfo.txpciq[j].s.q_no;
 				oct->instr_queue[q_no]->fill_threshold =
-					intr_coal->tx_max_coalesced_frames;
+					coal_base->tx_max_coalesced_frames;
 			}
 		} else {
 			dev_err(&oct->pci_dev->dev,
 				"LIQUIDIO: Invalid tx-frames:%d. Range is min:%d max:%d\n",
-				intr_coal->tx_max_coalesced_frames,
+				coal_base->tx_max_coalesced_frames,
 				db_min, db_max);
 			return -EINVAL;
 		}
@@ -2448,20 +2452,20 @@ static int lio_set_intr_coalesce(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	intrmod.rx_enable = intr_coal->use_adaptive_rx_coalesce ? 1 : 0;
-	intrmod.tx_enable = intr_coal->use_adaptive_tx_coalesce ? 1 : 0;
+	intrmod.rx_enable = coal_base->use_adaptive_rx_coalesce ? 1 : 0;
+	intrmod.tx_enable = coal_base->use_adaptive_tx_coalesce ? 1 : 0;
 	intrmod.rx_frames = CFG_GET_OQ_INTR_PKT(octeon_get_conf(oct));
 	intrmod.rx_usecs = CFG_GET_OQ_INTR_TIME(octeon_get_conf(oct));
 	intrmod.tx_frames = CFG_GET_IQ_INTR_PKT(octeon_get_conf(oct));
 
-	ret = oct_cfg_adaptive_intr(lio, &intrmod, intr_coal);
+	ret = oct_cfg_adaptive_intr(lio, &intrmod, coal_base);
 
-	if (!intr_coal->use_adaptive_rx_coalesce) {
-		ret = oct_cfg_rx_intrtime(lio, &intrmod, intr_coal);
+	if (!coal_base->use_adaptive_rx_coalesce) {
+		ret = oct_cfg_rx_intrtime(lio, &intrmod, coal_base);
 		if (ret)
 			goto ret_intrmod;
 
-		ret = oct_cfg_rx_intrcnt(lio, &intrmod, intr_coal);
+		ret = oct_cfg_rx_intrcnt(lio, &intrmod, coal_base);
 		if (ret)
 			goto ret_intrmod;
 	} else {
@@ -2471,8 +2475,8 @@ static int lio_set_intr_coalesce(struct net_device *netdev,
 			CFG_GET_OQ_INTR_PKT(octeon_get_conf(oct));
 	}
 
-	if (!intr_coal->use_adaptive_tx_coalesce) {
-		ret = oct_cfg_tx_intrcnt(lio, &intrmod, intr_coal);
+	if (!coal_base->use_adaptive_tx_coalesce) {
+		ret = oct_cfg_tx_intrcnt(lio, &intrmod, coal_base);
 		if (ret)
 			goto ret_intrmod;
 	} else {
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index 2f218fb..6bf0c6c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -456,11 +456,13 @@ static void nicvf_get_regs(struct net_device *dev,
 }
 
 static int nicvf_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *cmd)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *cmd)
 {
+	struct ethtool_coalesce *coal_base = &cmd->base;
 	struct nicvf *nic = netdev_priv(netdev);
 
-	cmd->rx_coalesce_usecs = nic->cq_coalesce_usecs;
+	coal_base->rx_coalesce_usecs = nic->cq_coalesce_usecs;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 512da98..9f22583 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -748,24 +748,30 @@ static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	return 0;
 }
 
-static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int set_coalesce(struct net_device *dev,
+			struct netlink_ext_ack *extack,
+			struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct adapter *adapter = dev->ml_priv;
 
-	adapter->params.sge.rx_coalesce_usecs = c->rx_coalesce_usecs;
-	adapter->params.sge.coalesce_enable = c->use_adaptive_rx_coalesce;
-	adapter->params.sge.sample_interval_usecs = c->rate_sample_interval;
+	adapter->params.sge.rx_coalesce_usecs = coal_base->rx_coalesce_usecs;
+	adapter->params.sge.coalesce_enable = coal_base->use_adaptive_rx_coalesce;
+	adapter->params.sge.sample_interval_usecs = coal_base->rate_sample_interval;
 	t1_sge_set_coalesce_params(adapter->sge, &adapter->params.sge);
 	return 0;
 }
 
-static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int get_coalesce(struct net_device *dev,
+			struct netlink_ext_ack *extack,
+			struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct adapter *adapter = dev->ml_priv;
 
-	c->rx_coalesce_usecs = adapter->params.sge.rx_coalesce_usecs;
-	c->rate_sample_interval = adapter->params.sge.sample_interval_usecs;
-	c->use_adaptive_rx_coalesce = adapter->params.sge.coalesce_enable;
+	coal_base->rx_coalesce_usecs = adapter->params.sge.rx_coalesce_usecs;
+	coal_base->rate_sample_interval = adapter->params.sge.sample_interval_usecs;
+	coal_base->use_adaptive_rx_coalesce = adapter->params.sge.coalesce_enable;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 84ad726..2c884df 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1996,34 +1996,40 @@ static int set_sge_param(struct net_device *dev, struct ethtool_ringparam *e)
 	return 0;
 }
 
-static int set_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int set_coalesce(struct net_device *dev,
+			struct netlink_ext_ack *extack,
+			struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
 	struct qset_params *qsp;
 	struct sge_qset *qs;
 	int i;
 
-	if (c->rx_coalesce_usecs * 10 > M_NEWTIMER)
+	if (coal_base->rx_coalesce_usecs * 10 > M_NEWTIMER)
 		return -EINVAL;
 
 	for (i = 0; i < pi->nqsets; i++) {
 		qsp = &adapter->params.sge.qset[i];
 		qs = &adapter->sge.qs[i];
-		qsp->coalesce_usecs = c->rx_coalesce_usecs;
+		qsp->coalesce_usecs = coal_base->rx_coalesce_usecs;
 		t3_update_qset_coalesce(qs, qsp);
 	}
 
 	return 0;
 }
 
-static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int get_coalesce(struct net_device *dev,
+			struct netlink_ext_ack *extack,
+			struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
 	struct qset_params *q = adapter->params.sge.qset;
 
-	c->rx_coalesce_usecs = q->coalesce_usecs;
+	coal_base->rx_coalesce_usecs = q->coalesce_usecs;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 61ea3ec..23a61a3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1147,34 +1147,39 @@ static int set_dbqtimer_tickval(struct net_device *dev,
 }
 
 static int set_coalesce(struct net_device *dev,
-			struct ethtool_coalesce *coalesce)
+			struct netlink_ext_ack *extack,
+			struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	int ret;
 
-	set_adaptive_rx_setting(dev, coalesce->use_adaptive_rx_coalesce);
+	set_adaptive_rx_setting(dev, coal_base->use_adaptive_rx_coalesce);
 
-	ret = set_rx_intr_params(dev, coalesce->rx_coalesce_usecs,
-				 coalesce->rx_max_coalesced_frames);
+	ret = set_rx_intr_params(dev, coal_base->rx_coalesce_usecs,
+				 coal_base->rx_max_coalesced_frames);
 	if (ret)
 		return ret;
 
 	return set_dbqtimer_tickval(dev,
-				    coalesce->tx_coalesce_usecs_irq,
-				    coalesce->tx_coalesce_usecs);
+				    coal_base->tx_coalesce_usecs_irq,
+				    coal_base->tx_coalesce_usecs);
 }
 
-static int get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int get_coalesce(struct net_device *dev,
+			struct netlink_ext_ack *extack,
+			struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	const struct port_info *pi = netdev_priv(dev);
 	const struct adapter *adap = pi->adapter;
 	const struct sge_rspq *rq = &adap->sge.ethrxq[pi->first_qset].rspq;
 
-	c->rx_coalesce_usecs = qtimer_val(adap, rq);
-	c->rx_max_coalesced_frames = (rq->intr_params & QINTR_CNT_EN_F) ?
+	coal_base->rx_coalesce_usecs = qtimer_val(adap, rq);
+	coal_base->rx_max_coalesced_frames = (rq->intr_params & QINTR_CNT_EN_F) ?
 		adap->sge.counter_val[rq->pktcnt_idx] : 0;
-	c->use_adaptive_rx_coalesce = get_adaptive_rx_setting(dev);
-	c->tx_coalesce_usecs_irq = get_dbqtimer_tick(dev);
-	c->tx_coalesce_usecs = get_dbqtimer(dev);
+	coal_base->use_adaptive_rx_coalesce = get_adaptive_rx_setting(dev);
+	coal_base->tx_coalesce_usecs_irq = get_dbqtimer_tick(dev);
+	coal_base->tx_coalesce_usecs = get_dbqtimer(dev);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 2820a0b..f43a269 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1647,14 +1647,16 @@ static int cxgb4vf_set_ringparam(struct net_device *dev,
  * interrupt holdoff timer to be read on all of the device's Queue Sets.
  */
 static int cxgb4vf_get_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *coalesce)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	const struct port_info *pi = netdev_priv(dev);
 	const struct adapter *adapter = pi->adapter;
 	const struct sge_rspq *rspq = &adapter->sge.ethrxq[pi->first_qset].rspq;
 
-	coalesce->rx_coalesce_usecs = qtimer_val(adapter, rspq);
-	coalesce->rx_max_coalesced_frames =
+	coal_base->rx_coalesce_usecs = qtimer_val(adapter, rspq);
+	coal_base->rx_max_coalesced_frames =
 		((rspq->intr_params & QINTR_CNT_EN_F)
 		 ? adapter->sge.counter_val[rspq->pktcnt_idx]
 		 : 0);
@@ -1667,15 +1669,17 @@ static int cxgb4vf_get_coalesce(struct net_device *dev,
  * the interrupt holdoff timer on any of the device's Queue Sets.
  */
 static int cxgb4vf_set_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *coalesce)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	const struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
 
 	return set_rxq_intr_params(adapter,
 				   &adapter->sge.ethrxq[pi->first_qset].rspq,
-				   coalesce->rx_coalesce_usecs,
-				   coalesce->rx_max_coalesced_frames);
+				   coal_base->rx_coalesce_usecs,
+				   coal_base->rx_max_coalesced_frames);
 }
 
 /*
diff --git a/drivers/net/ethernet/cisco/enic/enic_ethtool.c b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
index 1a9803f..3050d39 100644
--- a/drivers/net/ethernet/cisco/enic/enic_ethtool.c
+++ b/drivers/net/ethernet/cisco/enic/enic_ethtool.c
@@ -298,18 +298,20 @@ static void enic_set_msglevel(struct net_device *netdev, u32 value)
 }
 
 static int enic_get_coalesce(struct net_device *netdev,
-	struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct enic *enic = netdev_priv(netdev);
 	struct enic_rx_coal *rxcoal = &enic->rx_coalesce_setting;
 
 	if (vnic_dev_get_intr_mode(enic->vdev) == VNIC_DEV_INTR_MODE_MSIX)
-		ecmd->tx_coalesce_usecs = enic->tx_coalesce_usecs;
-	ecmd->rx_coalesce_usecs = enic->rx_coalesce_usecs;
+		coal_base->tx_coalesce_usecs = enic->tx_coalesce_usecs;
+	coal_base->rx_coalesce_usecs = enic->rx_coalesce_usecs;
 	if (rxcoal->use_adaptive_rx_coalesce)
-		ecmd->use_adaptive_rx_coalesce = 1;
-	ecmd->rx_coalesce_usecs_low = rxcoal->small_pkt_range_start;
-	ecmd->rx_coalesce_usecs_high = rxcoal->range_end;
+		coal_base->use_adaptive_rx_coalesce = 1;
+	coal_base->rx_coalesce_usecs_low = rxcoal->small_pkt_range_start;
+	coal_base->rx_coalesce_usecs_high = rxcoal->range_end;
 
 	return 0;
 }
@@ -343,8 +345,10 @@ static int enic_coalesce_valid(struct enic *enic,
 }
 
 static int enic_set_coalesce(struct net_device *netdev,
-	struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct enic *enic = netdev_priv(netdev);
 	u32 tx_coalesce_usecs;
 	u32 rx_coalesce_usecs;
@@ -355,18 +359,18 @@ static int enic_set_coalesce(struct net_device *netdev,
 	int ret;
 	struct enic_rx_coal *rxcoal = &enic->rx_coalesce_setting;
 
-	ret = enic_coalesce_valid(enic, ecmd);
+	ret = enic_coalesce_valid(enic, coal_base);
 	if (ret)
 		return ret;
 	coalesce_usecs_max = vnic_dev_get_intr_coal_timer_max(enic->vdev);
-	tx_coalesce_usecs = min_t(u32, ecmd->tx_coalesce_usecs,
+	tx_coalesce_usecs = min_t(u32, coal_base->tx_coalesce_usecs,
 				  coalesce_usecs_max);
-	rx_coalesce_usecs = min_t(u32, ecmd->rx_coalesce_usecs,
+	rx_coalesce_usecs = min_t(u32, coal_base->rx_coalesce_usecs,
 				  coalesce_usecs_max);
 
-	rx_coalesce_usecs_low = min_t(u32, ecmd->rx_coalesce_usecs_low,
+	rx_coalesce_usecs_low = min_t(u32, coal_base->rx_coalesce_usecs_low,
 				      coalesce_usecs_max);
-	rx_coalesce_usecs_high = min_t(u32, ecmd->rx_coalesce_usecs_high,
+	rx_coalesce_usecs_high = min_t(u32, coal_base->rx_coalesce_usecs_high,
 				       coalesce_usecs_max);
 
 	if (vnic_dev_get_intr_mode(enic->vdev) == VNIC_DEV_INTR_MODE_MSIX) {
@@ -377,10 +381,10 @@ static int enic_set_coalesce(struct net_device *netdev,
 		}
 		enic->tx_coalesce_usecs = tx_coalesce_usecs;
 	}
-	rxcoal->use_adaptive_rx_coalesce = !!ecmd->use_adaptive_rx_coalesce;
+	rxcoal->use_adaptive_rx_coalesce = !!coal_base->use_adaptive_rx_coalesce;
 	if (!rxcoal->use_adaptive_rx_coalesce)
 		enic_intr_coal_set_rx(enic, rx_coalesce_usecs);
-	if (ecmd->rx_coalesce_usecs_high) {
+	if (coal_base->rx_coalesce_usecs_high) {
 		rxcoal->range_end = rx_coalesce_usecs_high;
 		rxcoal->small_pkt_range_start = rx_coalesce_usecs_low;
 		rxcoal->large_pkt_range_start = rx_coalesce_usecs_low +
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8df6f08..e7167de 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2144,29 +2144,33 @@ static int gmac_set_ringparam(struct net_device *netdev,
 }
 
 static int gmac_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 
-	ecmd->rx_max_coalesced_frames = 1;
-	ecmd->tx_max_coalesced_frames = port->irq_every_tx_packets;
-	ecmd->rx_coalesce_usecs = port->rx_coalesce_nsecs / 1000;
+	coal_base->rx_max_coalesced_frames = 1;
+	coal_base->tx_max_coalesced_frames = port->irq_every_tx_packets;
+	coal_base->rx_coalesce_usecs = port->rx_coalesce_nsecs / 1000;
 
 	return 0;
 }
 
 static int gmac_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 
-	if (ecmd->tx_max_coalesced_frames < 1)
+	if (coal_base->tx_max_coalesced_frames < 1)
 		return -EINVAL;
-	if (ecmd->tx_max_coalesced_frames >= 1 << port->txq_order)
+	if (coal_base->tx_max_coalesced_frames >= 1 << port->txq_order)
 		return -EINVAL;
 
-	port->irq_every_tx_packets = ecmd->tx_max_coalesced_frames;
-	port->rx_coalesce_nsecs = ecmd->rx_coalesce_usecs * 1000;
+	port->irq_every_tx_packets = coal_base->tx_max_coalesced_frames;
+	port->rx_coalesce_nsecs = coal_base->rx_coalesce_usecs * 1000;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 99cc1c4..aa8aca0 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -315,21 +315,23 @@ static int be_read_dump_data(struct be_adapter *adapter, u32 dump_len,
 }
 
 static int be_get_coalesce(struct net_device *netdev,
-			   struct ethtool_coalesce *et)
+			   struct netlink_ext_ack *extack,
+			   struct kernel_ethtool_coalesce *et)
 {
+	struct ethtool_coalesce *coal_base = &et->base;
 	struct be_adapter *adapter = netdev_priv(netdev);
 	struct be_aic_obj *aic = &adapter->aic_obj[0];
 
-	et->rx_coalesce_usecs = aic->prev_eqd;
-	et->rx_coalesce_usecs_high = aic->max_eqd;
-	et->rx_coalesce_usecs_low = aic->min_eqd;
+	coal_base->rx_coalesce_usecs = aic->prev_eqd;
+	coal_base->rx_coalesce_usecs_high = aic->max_eqd;
+	coal_base->rx_coalesce_usecs_low = aic->min_eqd;
 
-	et->tx_coalesce_usecs = aic->prev_eqd;
-	et->tx_coalesce_usecs_high = aic->max_eqd;
-	et->tx_coalesce_usecs_low = aic->min_eqd;
+	coal_base->tx_coalesce_usecs = aic->prev_eqd;
+	coal_base->tx_coalesce_usecs_high = aic->max_eqd;
+	coal_base->tx_coalesce_usecs_low = aic->min_eqd;
 
-	et->use_adaptive_rx_coalesce = adapter->aic_enabled;
-	et->use_adaptive_tx_coalesce = adapter->aic_enabled;
+	coal_base->use_adaptive_rx_coalesce = adapter->aic_enabled;
+	coal_base->use_adaptive_tx_coalesce = adapter->aic_enabled;
 
 	return 0;
 }
@@ -338,19 +340,23 @@ static int be_get_coalesce(struct net_device *netdev,
  * eqd cmd is issued in the worker thread.
  */
 static int be_set_coalesce(struct net_device *netdev,
-			   struct ethtool_coalesce *et)
+			   struct netlink_ext_ack *extack,
+			   struct kernel_ethtool_coalesce *et)
 {
+	struct ethtool_coalesce *coal_base = &et->base;
 	struct be_adapter *adapter = netdev_priv(netdev);
 	struct be_aic_obj *aic = &adapter->aic_obj[0];
 	struct be_eq_obj *eqo;
 	int i;
 
-	adapter->aic_enabled = et->use_adaptive_rx_coalesce;
+	adapter->aic_enabled = coal_base->use_adaptive_rx_coalesce;
 
 	for_all_evt_queues(adapter, eqo, i) {
-		aic->max_eqd = min(et->rx_coalesce_usecs_high, BE_MAX_EQD);
-		aic->min_eqd = min(et->rx_coalesce_usecs_low, aic->max_eqd);
-		aic->et_eqd = min(et->rx_coalesce_usecs, aic->max_eqd);
+		aic->max_eqd = min(coal_base->rx_coalesce_usecs_high,
+				   BE_MAX_EQD);
+		aic->min_eqd = min(coal_base->rx_coalesce_usecs_low,
+				   aic->max_eqd);
+		aic->et_eqd = min(coal_base->rx_coalesce_usecs, aic->max_eqd);
 		aic->et_eqd = max(aic->et_eqd, aic->min_eqd);
 		aic++;
 	}
@@ -360,7 +366,7 @@ static int be_set_coalesce(struct net_device *netdev,
 	 * FW cmd, so that we don't have to calculate the delay multiplier
 	 * encode value each time EQ_DB is rung
 	 */
-	if (!et->use_adaptive_rx_coalesce && skyhawk_chip(adapter))
+	if (!coal_base->use_adaptive_rx_coalesce && skyhawk_chip(adapter))
 		be_eqd_update(adapter, true);
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 1268996..1fb7a27 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -513,8 +513,10 @@ static int dpaa_get_ts_info(struct net_device *net_dev,
 }
 
 static int dpaa_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *c)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct qman_portal *portal;
 	u32 period;
 	u8 thresh;
@@ -523,15 +525,17 @@ static int dpaa_get_coalesce(struct net_device *dev,
 	qman_portal_get_iperiod(portal, &period);
 	qman_dqrr_get_ithresh(portal, &thresh);
 
-	c->rx_coalesce_usecs = period;
-	c->rx_max_coalesced_frames = thresh;
+	coal_base->rx_coalesce_usecs = period;
+	coal_base->rx_max_coalesced_frames = thresh;
 
 	return 0;
 }
 
 static int dpaa_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *c)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	const cpumask_t *cpus = qman_affine_cpus();
 	bool needs_revert[NR_CPUS] = {false};
 	struct qman_portal *portal;
@@ -539,8 +543,8 @@ static int dpaa_set_coalesce(struct net_device *dev,
 	u8 thresh, prev_thresh;
 	int cpu, res;
 
-	period = c->rx_coalesce_usecs;
-	thresh = c->rx_max_coalesced_frames;
+	period = coal_base->rx_coalesce_usecs;
+	thresh = coal_base->rx_max_coalesced_frames;
 
 	/* save previous values */
 	portal = qman_get_affine_portal(smp_processor_id());
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index ebccaf0..8e889a6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -585,41 +585,45 @@ static void enetc_get_ringparam(struct net_device *ndev,
 }
 
 static int enetc_get_coalesce(struct net_device *ndev,
-			      struct ethtool_coalesce *ic)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ic)
 {
+	struct ethtool_coalesce *coal_base = &ic->base;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_int_vector *v = priv->int_vector[0];
 
-	ic->tx_coalesce_usecs = enetc_cycles_to_usecs(priv->tx_ictt);
-	ic->rx_coalesce_usecs = enetc_cycles_to_usecs(v->rx_ictt);
+	coal_base->tx_coalesce_usecs = enetc_cycles_to_usecs(priv->tx_ictt);
+	coal_base->rx_coalesce_usecs = enetc_cycles_to_usecs(v->rx_ictt);
 
-	ic->tx_max_coalesced_frames = ENETC_TXIC_PKTTHR;
-	ic->rx_max_coalesced_frames = ENETC_RXIC_PKTTHR;
+	coal_base->tx_max_coalesced_frames = ENETC_TXIC_PKTTHR;
+	coal_base->rx_max_coalesced_frames = ENETC_RXIC_PKTTHR;
 
-	ic->use_adaptive_rx_coalesce = priv->ic_mode & ENETC_IC_RX_ADAPTIVE;
+	coal_base->use_adaptive_rx_coalesce = priv->ic_mode & ENETC_IC_RX_ADAPTIVE;
 
 	return 0;
 }
 
 static int enetc_set_coalesce(struct net_device *ndev,
-			      struct ethtool_coalesce *ic)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ic)
 {
+	struct ethtool_coalesce *coal_base = &ic->base;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	u32 rx_ictt, tx_ictt;
 	int i, ic_mode;
 	bool changed;
 
-	tx_ictt = enetc_usecs_to_cycles(ic->tx_coalesce_usecs);
-	rx_ictt = enetc_usecs_to_cycles(ic->rx_coalesce_usecs);
+	tx_ictt = enetc_usecs_to_cycles(coal_base->tx_coalesce_usecs);
+	rx_ictt = enetc_usecs_to_cycles(coal_base->rx_coalesce_usecs);
 
-	if (ic->rx_max_coalesced_frames != ENETC_RXIC_PKTTHR)
+	if (coal_base->rx_max_coalesced_frames != ENETC_RXIC_PKTTHR)
 		return -EOPNOTSUPP;
 
-	if (ic->tx_max_coalesced_frames != ENETC_TXIC_PKTTHR)
+	if (coal_base->tx_max_coalesced_frames != ENETC_TXIC_PKTTHR)
 		return -EOPNOTSUPP;
 
 	ic_mode = ENETC_IC_NONE;
-	if (ic->use_adaptive_rx_coalesce) {
+	if (coal_base->use_adaptive_rx_coalesce) {
 		ic_mode |= ENETC_IC_RX_ADAPTIVE;
 		rx_ictt = 0x1;
 	} else {
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f2065f9..b878c34 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2574,26 +2574,30 @@ static void fec_enet_itr_coal_set(struct net_device *ndev)
 	}
 }
 
-static int
-fec_enet_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
+static int fec_enet_get_coalesce(struct net_device *ndev,
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
 	if (!(fep->quirks & FEC_QUIRK_HAS_COALESCE))
 		return -EOPNOTSUPP;
 
-	ec->rx_coalesce_usecs = fep->rx_time_itr;
-	ec->rx_max_coalesced_frames = fep->rx_pkts_itr;
+	coal_base->rx_coalesce_usecs = fep->rx_time_itr;
+	coal_base->rx_max_coalesced_frames = fep->rx_pkts_itr;
 
-	ec->tx_coalesce_usecs = fep->tx_time_itr;
-	ec->tx_max_coalesced_frames = fep->tx_pkts_itr;
+	coal_base->tx_coalesce_usecs = fep->tx_time_itr;
+	coal_base->tx_max_coalesced_frames = fep->tx_pkts_itr;
 
 	return 0;
 }
 
-static int
-fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
+static int fec_enet_set_coalesce(struct net_device *ndev,
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	struct device *dev = &fep->pdev->dev;
 	unsigned int cycle;
@@ -2601,33 +2605,33 @@ fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 	if (!(fep->quirks & FEC_QUIRK_HAS_COALESCE))
 		return -EOPNOTSUPP;
 
-	if (ec->rx_max_coalesced_frames > 255) {
+	if (coal_base->rx_max_coalesced_frames > 255) {
 		dev_err(dev, "Rx coalesced frames exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-	if (ec->tx_max_coalesced_frames > 255) {
+	if (coal_base->tx_max_coalesced_frames > 255) {
 		dev_err(dev, "Tx coalesced frame exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, ec->rx_coalesce_usecs);
+	cycle = fec_enet_us_to_itr_clock(ndev, coal_base->rx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
 		dev_err(dev, "Rx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-	cycle = fec_enet_us_to_itr_clock(ndev, ec->tx_coalesce_usecs);
+	cycle = fec_enet_us_to_itr_clock(ndev, coal_base->tx_coalesce_usecs);
 	if (cycle > 0xFFFF) {
 		dev_err(dev, "Tx coalesced usec exceed hardware limitation\n");
 		return -EINVAL;
 	}
 
-	fep->rx_time_itr = ec->rx_coalesce_usecs;
-	fep->rx_pkts_itr = ec->rx_max_coalesced_frames;
+	fep->rx_time_itr = coal_base->rx_coalesce_usecs;
+	fep->rx_pkts_itr = coal_base->rx_max_coalesced_frames;
 
-	fep->tx_time_itr = ec->tx_coalesce_usecs;
-	fep->tx_pkts_itr = ec->tx_max_coalesced_frames;
+	fep->tx_time_itr = coal_base->tx_coalesce_usecs;
+	fep->tx_pkts_itr = coal_base->tx_max_coalesced_frames;
 
 	fec_enet_itr_coal_set(ndev);
 
@@ -2636,15 +2640,15 @@ fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 
 static void fec_enet_itr_coal_init(struct net_device *ndev)
 {
-	struct ethtool_coalesce ec;
+	struct kernel_ethtool_coalesce ec;
 
-	ec.rx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.rx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
+	ec.base.rx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
+	ec.base.rx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
 
-	ec.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
+	ec.base.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
+	ec.base.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
 
-	fec_enet_set_coalesce(ndev, &ec);
+	fec_enet_set_coalesce(ndev, NULL, &ec);
 }
 
 static int fec_enet_get_tunable(struct net_device *netdev,
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index cc7d4f9..c202bba 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -243,8 +243,10 @@ static unsigned int gfar_ticks2usecs(struct gfar_private *priv,
 /* Get the coalescing parameters, and put them in the cvals
  * structure.  */
 static int gfar_gcoalesce(struct net_device *dev,
-			  struct ethtool_coalesce *cvals)
+			  struct netlink_ext_ack *extack,
+			  struct kernel_ethtool_coalesce *cvals)
 {
+	struct ethtool_coalesce *coal_base = &cvals->base;
 	struct gfar_private *priv = netdev_priv(dev);
 	struct gfar_priv_rx_q *rx_queue = NULL;
 	struct gfar_priv_tx_q *tx_queue = NULL;
@@ -266,11 +268,11 @@ static int gfar_gcoalesce(struct net_device *dev,
 	rxcount = get_icft_value(rx_queue->rxic);
 	txtime  = get_ictt_value(tx_queue->txic);
 	txcount = get_icft_value(tx_queue->txic);
-	cvals->rx_coalesce_usecs = gfar_ticks2usecs(priv, rxtime);
-	cvals->rx_max_coalesced_frames = rxcount;
+	coal_base->rx_coalesce_usecs = gfar_ticks2usecs(priv, rxtime);
+	coal_base->rx_max_coalesced_frames = rxcount;
 
-	cvals->tx_coalesce_usecs = gfar_ticks2usecs(priv, txtime);
-	cvals->tx_max_coalesced_frames = txcount;
+	coal_base->tx_coalesce_usecs = gfar_ticks2usecs(priv, txtime);
+	coal_base->tx_max_coalesced_frames = txcount;
 
 	return 0;
 }
@@ -280,8 +282,10 @@ static int gfar_gcoalesce(struct net_device *dev,
  * in order for coalescing to be active
  */
 static int gfar_scoalesce(struct net_device *dev,
-			  struct ethtool_coalesce *cvals)
+			  struct netlink_ext_ack *extack,
+			  struct kernel_ethtool_coalesce *cvals)
 {
+	struct ethtool_coalesce *coal_base = &cvals->base;
 	struct gfar_private *priv = netdev_priv(dev);
 	int i, err = 0;
 
@@ -292,26 +296,26 @@ static int gfar_scoalesce(struct net_device *dev,
 		return -ENODEV;
 
 	/* Check the bounds of the values */
-	if (cvals->rx_coalesce_usecs > GFAR_MAX_COAL_USECS) {
+	if (coal_base->rx_coalesce_usecs > GFAR_MAX_COAL_USECS) {
 		netdev_info(dev, "Coalescing is limited to %d microseconds\n",
 			    GFAR_MAX_COAL_USECS);
 		return -EINVAL;
 	}
 
-	if (cvals->rx_max_coalesced_frames > GFAR_MAX_COAL_FRAMES) {
+	if (coal_base->rx_max_coalesced_frames > GFAR_MAX_COAL_FRAMES) {
 		netdev_info(dev, "Coalescing is limited to %d frames\n",
 			    GFAR_MAX_COAL_FRAMES);
 		return -EINVAL;
 	}
 
 	/* Check the bounds of the values */
-	if (cvals->tx_coalesce_usecs > GFAR_MAX_COAL_USECS) {
+	if (coal_base->tx_coalesce_usecs > GFAR_MAX_COAL_USECS) {
 		netdev_info(dev, "Coalescing is limited to %d microseconds\n",
 			    GFAR_MAX_COAL_USECS);
 		return -EINVAL;
 	}
 
-	if (cvals->tx_max_coalesced_frames > GFAR_MAX_COAL_FRAMES) {
+	if (coal_base->tx_max_coalesced_frames > GFAR_MAX_COAL_FRAMES) {
 		netdev_info(dev, "Coalescing is limited to %d frames\n",
 			    GFAR_MAX_COAL_FRAMES);
 		return -EINVAL;
@@ -321,8 +325,8 @@ static int gfar_scoalesce(struct net_device *dev,
 		cpu_relax();
 
 	/* Set up rx coalescing */
-	if ((cvals->rx_coalesce_usecs == 0) ||
-	    (cvals->rx_max_coalesced_frames == 0)) {
+	if ((coal_base->rx_coalesce_usecs == 0) ||
+	    (coal_base->rx_max_coalesced_frames == 0)) {
 		for (i = 0; i < priv->num_rx_queues; i++)
 			priv->rx_queue[i]->rxcoalescing = 0;
 	} else {
@@ -331,14 +335,13 @@ static int gfar_scoalesce(struct net_device *dev,
 	}
 
 	for (i = 0; i < priv->num_rx_queues; i++) {
-		priv->rx_queue[i]->rxic = mk_ic_value(
-			cvals->rx_max_coalesced_frames,
-			gfar_usecs2ticks(priv, cvals->rx_coalesce_usecs));
+		priv->rx_queue[i]->rxic = mk_ic_value(coal_base->rx_max_coalesced_frames,
+						      gfar_usecs2ticks(priv, coal_base->rx_coalesce_usecs));
 	}
 
 	/* Set up tx coalescing */
-	if ((cvals->tx_coalesce_usecs == 0) ||
-	    (cvals->tx_max_coalesced_frames == 0)) {
+	if ((coal_base->tx_coalesce_usecs == 0) ||
+	    (coal_base->tx_max_coalesced_frames == 0)) {
 		for (i = 0; i < priv->num_tx_queues; i++)
 			priv->tx_queue[i]->txcoalescing = 0;
 	} else {
@@ -347,9 +350,10 @@ static int gfar_scoalesce(struct net_device *dev,
 	}
 
 	for (i = 0; i < priv->num_tx_queues; i++) {
-		priv->tx_queue[i]->txic = mk_ic_value(
-			cvals->tx_max_coalesced_frames,
-			gfar_usecs2ticks(priv, cvals->tx_coalesce_usecs));
+		priv->tx_queue[i]->txic =
+			mk_ic_value(coal_base->tx_max_coalesced_frames,
+				    gfar_usecs2ticks(priv,
+				    coal_base->tx_coalesce_usecs));
 	}
 
 	if (dev->flags & IFF_UP) {
diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 12f6c24..db12c9e 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -796,29 +796,33 @@ static void hip04_tx_timeout_task(struct work_struct *work)
 }
 
 static int hip04_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct hip04_priv *priv = netdev_priv(netdev);
 
-	ec->tx_coalesce_usecs = priv->tx_coalesce_usecs;
-	ec->tx_max_coalesced_frames = priv->tx_coalesce_frames;
+	coal_base->tx_coalesce_usecs = priv->tx_coalesce_usecs;
+	coal_base->tx_max_coalesced_frames = priv->tx_coalesce_frames;
 
 	return 0;
 }
 
 static int hip04_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct hip04_priv *priv = netdev_priv(netdev);
 
-	if ((ec->tx_coalesce_usecs > HIP04_MAX_TX_COALESCE_USECS ||
-	     ec->tx_coalesce_usecs < HIP04_MIN_TX_COALESCE_USECS) ||
-	    (ec->tx_max_coalesced_frames > HIP04_MAX_TX_COALESCE_FRAMES ||
-	     ec->tx_max_coalesced_frames < HIP04_MIN_TX_COALESCE_FRAMES))
+	if ((coal_base->tx_coalesce_usecs > HIP04_MAX_TX_COALESCE_USECS ||
+	     coal_base->tx_coalesce_usecs < HIP04_MIN_TX_COALESCE_USECS) ||
+	    (coal_base->tx_max_coalesced_frames > HIP04_MAX_TX_COALESCE_FRAMES ||
+	     coal_base->tx_max_coalesced_frames < HIP04_MIN_TX_COALESCE_FRAMES))
 		return -EINVAL;
 
-	priv->tx_coalesce_usecs = ec->tx_coalesce_usecs;
-	priv->tx_coalesce_frames = ec->tx_max_coalesced_frames;
+	priv->tx_coalesce_usecs = coal_base->tx_coalesce_usecs;
+	priv->tx_coalesce_frames = coal_base->tx_max_coalesced_frames;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 7e62dcf..84d7cea 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -734,38 +734,40 @@ static int hns_set_pauseparam(struct net_device *net_dev,
  * Return 0 on success, negative on failure.
  */
 static int hns_get_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *ec)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct hns_nic_priv *priv = netdev_priv(net_dev);
 	struct hnae_ae_ops *ops;
 
 	ops = priv->ae_handle->dev->ops;
 
-	ec->use_adaptive_rx_coalesce = priv->ae_handle->coal_adapt_en;
-	ec->use_adaptive_tx_coalesce = priv->ae_handle->coal_adapt_en;
+	coal_base->use_adaptive_rx_coalesce = priv->ae_handle->coal_adapt_en;
+	coal_base->use_adaptive_tx_coalesce = priv->ae_handle->coal_adapt_en;
 
 	if ((!ops->get_coalesce_usecs) ||
 	    (!ops->get_max_coalesced_frames))
 		return -ESRCH;
 
 	ops->get_coalesce_usecs(priv->ae_handle,
-					&ec->tx_coalesce_usecs,
-					&ec->rx_coalesce_usecs);
+					&coal_base->tx_coalesce_usecs,
+					&coal_base->rx_coalesce_usecs);
 
 	ops->get_max_coalesced_frames(
 		priv->ae_handle,
-		&ec->tx_max_coalesced_frames,
-		&ec->rx_max_coalesced_frames);
+		&coal_base->tx_max_coalesced_frames,
+		&coal_base->rx_max_coalesced_frames);
 
 	ops->get_coalesce_range(priv->ae_handle,
-				&ec->tx_max_coalesced_frames_low,
-				&ec->rx_max_coalesced_frames_low,
-				&ec->tx_max_coalesced_frames_high,
-				&ec->rx_max_coalesced_frames_high,
-				&ec->tx_coalesce_usecs_low,
-				&ec->rx_coalesce_usecs_low,
-				&ec->tx_coalesce_usecs_high,
-				&ec->rx_coalesce_usecs_high);
+				&coal_base->tx_max_coalesced_frames_low,
+				&coal_base->rx_max_coalesced_frames_low,
+				&coal_base->tx_max_coalesced_frames_high,
+				&coal_base->rx_max_coalesced_frames_high,
+				&coal_base->tx_coalesce_usecs_low,
+				&coal_base->rx_coalesce_usecs_low,
+				&coal_base->tx_coalesce_usecs_high,
+				&coal_base->rx_coalesce_usecs_high);
 
 	return 0;
 }
@@ -778,30 +780,32 @@ static int hns_get_coalesce(struct net_device *net_dev,
  * Return 0 on success, negative on failure.
  */
 static int hns_set_coalesce(struct net_device *net_dev,
-			    struct ethtool_coalesce *ec)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct hns_nic_priv *priv = netdev_priv(net_dev);
 	struct hnae_ae_ops *ops;
 	int rc1, rc2;
 
 	ops = priv->ae_handle->dev->ops;
 
-	if (ec->tx_coalesce_usecs != ec->rx_coalesce_usecs)
+	if (coal_base->tx_coalesce_usecs != coal_base->rx_coalesce_usecs)
 		return -EINVAL;
 
 	if ((!ops->set_coalesce_usecs) ||
 	    (!ops->set_coalesce_frames))
 		return -ESRCH;
 
-	if (ec->use_adaptive_rx_coalesce != priv->ae_handle->coal_adapt_en)
-		priv->ae_handle->coal_adapt_en = ec->use_adaptive_rx_coalesce;
+	if (coal_base->use_adaptive_rx_coalesce != priv->ae_handle->coal_adapt_en)
+		priv->ae_handle->coal_adapt_en = coal_base->use_adaptive_rx_coalesce;
 
 	rc1 = ops->set_coalesce_usecs(priv->ae_handle,
-				      ec->rx_coalesce_usecs);
+				      coal_base->rx_coalesce_usecs);
 
 	rc2 = ops->set_coalesce_frames(priv->ae_handle,
-				       ec->tx_max_coalesced_frames,
-				       ec->rx_max_coalesced_frames);
+				       coal_base->tx_max_coalesced_frames,
+				       coal_base->rx_max_coalesced_frames);
 
 	if (rc1 || rc2)
 		return -EINVAL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c1ea403..0042be0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1135,27 +1135,29 @@ static void hns3_get_channels(struct net_device *netdev,
 }
 
 static int hns3_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *cmd)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
 	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
+	struct ethtool_coalesce *coal_base = &cmd->base;
 	struct hnae3_handle *h = priv->ae_handle;
 
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
-	cmd->use_adaptive_tx_coalesce = tx_coal->adapt_enable;
-	cmd->use_adaptive_rx_coalesce = rx_coal->adapt_enable;
+	coal_base->use_adaptive_tx_coalesce = tx_coal->adapt_enable;
+	coal_base->use_adaptive_rx_coalesce = rx_coal->adapt_enable;
 
-	cmd->tx_coalesce_usecs = tx_coal->int_gl;
-	cmd->rx_coalesce_usecs = rx_coal->int_gl;
+	coal_base->tx_coalesce_usecs = tx_coal->int_gl;
+	coal_base->rx_coalesce_usecs = rx_coal->int_gl;
 
-	cmd->tx_coalesce_usecs_high = h->kinfo.int_rl_setting;
-	cmd->rx_coalesce_usecs_high = h->kinfo.int_rl_setting;
+	coal_base->tx_coalesce_usecs_high = h->kinfo.int_rl_setting;
+	coal_base->rx_coalesce_usecs_high = h->kinfo.int_rl_setting;
 
-	cmd->tx_max_coalesced_frames = tx_coal->int_ql;
-	cmd->rx_max_coalesced_frames = rx_coal->int_ql;
+	coal_base->tx_max_coalesced_frames = tx_coal->int_ql;
+	coal_base->rx_max_coalesced_frames = rx_coal->int_ql;
 
 	return 0;
 }
@@ -1317,8 +1319,10 @@ static void hns3_set_coalesce_per_queue(struct net_device *netdev,
 }
 
 static int hns3_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *cmd)
 {
+	struct ethtool_coalesce *coal_base = &cmd->base;
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
@@ -1330,24 +1334,24 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
-	ret = hns3_check_coalesce_para(netdev, cmd);
+	ret = hns3_check_coalesce_para(netdev, coal_base);
 	if (ret)
 		return ret;
 
 	h->kinfo.int_rl_setting =
-		hns3_rl_round_down(cmd->rx_coalesce_usecs_high);
+		hns3_rl_round_down(coal_base->rx_coalesce_usecs_high);
 
-	tx_coal->adapt_enable = cmd->use_adaptive_tx_coalesce;
-	rx_coal->adapt_enable = cmd->use_adaptive_rx_coalesce;
+	tx_coal->adapt_enable = coal_base->use_adaptive_tx_coalesce;
+	rx_coal->adapt_enable = coal_base->use_adaptive_rx_coalesce;
 
-	tx_coal->int_gl = cmd->tx_coalesce_usecs;
-	rx_coal->int_gl = cmd->rx_coalesce_usecs;
+	tx_coal->int_gl = coal_base->tx_coalesce_usecs;
+	rx_coal->int_gl = coal_base->rx_coalesce_usecs;
 
-	tx_coal->int_ql = cmd->tx_max_coalesced_frames;
-	rx_coal->int_ql = cmd->rx_max_coalesced_frames;
+	tx_coal->int_ql = coal_base->tx_max_coalesced_frames;
+	rx_coal->int_ql = coal_base->rx_max_coalesced_frames;
 
 	for (i = 0; i < queue_num; i++)
-		hns3_set_coalesce_per_queue(netdev, cmd, i);
+		hns3_set_coalesce_per_queue(netdev, coal_base, i);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 162d3c3..daeca65 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -795,15 +795,20 @@ static int __hinic_set_coalesce(struct net_device *netdev,
 }
 
 static int hinic_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
-	return __hinic_get_coalesce(netdev, coal, COALESCE_ALL_QUEUE);
+	struct ethtool_coalesce *coal_base = &coal->base;
+	return __hinic_get_coalesce(netdev, coal_base, COALESCE_ALL_QUEUE);
 }
 
 static int hinic_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
-	return __hinic_set_coalesce(netdev, coal, COALESCE_ALL_QUEUE);
+	struct ethtool_coalesce *coal_base = &coal->base;
+
+	return __hinic_set_coalesce(netdev, coal_base, COALESCE_ALL_QUEUE);
 }
 
 static int hinic_get_per_queue_coalesce(struct net_device *netdev, u32 queue,
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index f976e9d..c6905ed 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -1739,43 +1739,47 @@ static int e1000_set_phys_id(struct net_device *netdev,
 }
 
 static int e1000_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->hw.mac_type < e1000_82545)
 		return -EOPNOTSUPP;
 
 	if (adapter->itr_setting <= 4)
-		ec->rx_coalesce_usecs = adapter->itr_setting;
+		coal_base->rx_coalesce_usecs = adapter->itr_setting;
 	else
-		ec->rx_coalesce_usecs = 1000000 / adapter->itr_setting;
+		coal_base->rx_coalesce_usecs = 1000000 / adapter->itr_setting;
 
 	return 0;
 }
 
 static int e1000_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 
 	if (hw->mac_type < e1000_82545)
 		return -EOPNOTSUPP;
 
-	if ((ec->rx_coalesce_usecs > E1000_MAX_ITR_USECS) ||
-	    ((ec->rx_coalesce_usecs > 4) &&
-	     (ec->rx_coalesce_usecs < E1000_MIN_ITR_USECS)) ||
-	    (ec->rx_coalesce_usecs == 2))
+	if ((coal_base->rx_coalesce_usecs > E1000_MAX_ITR_USECS) ||
+	    ((coal_base->rx_coalesce_usecs > 4) &&
+	     (coal_base->rx_coalesce_usecs < E1000_MIN_ITR_USECS)) ||
+	    (coal_base->rx_coalesce_usecs == 2))
 		return -EINVAL;
 
-	if (ec->rx_coalesce_usecs == 4) {
+	if (coal_base->rx_coalesce_usecs == 4) {
 		adapter->itr = adapter->itr_setting = 4;
-	} else if (ec->rx_coalesce_usecs <= 3) {
+	} else if (coal_base->rx_coalesce_usecs <= 3) {
 		adapter->itr = 20000;
-		adapter->itr_setting = ec->rx_coalesce_usecs;
+		adapter->itr_setting = coal_base->rx_coalesce_usecs;
 	} else {
-		adapter->itr = (1000000 / ec->rx_coalesce_usecs);
+		adapter->itr = (1000000 / coal_base->rx_coalesce_usecs);
 		adapter->itr_setting = adapter->itr & ~3;
 	}
 
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 06442e6..3ed60d6 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -1991,37 +1991,41 @@ static int e1000_set_phys_id(struct net_device *netdev,
 }
 
 static int e1000_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->itr_setting <= 4)
-		ec->rx_coalesce_usecs = adapter->itr_setting;
+		coal_base->rx_coalesce_usecs = adapter->itr_setting;
 	else
-		ec->rx_coalesce_usecs = 1000000 / adapter->itr_setting;
+		coal_base->rx_coalesce_usecs = 1000000 / adapter->itr_setting;
 
 	return 0;
 }
 
 static int e1000_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	if ((ec->rx_coalesce_usecs > E1000_MAX_ITR_USECS) ||
-	    ((ec->rx_coalesce_usecs > 4) &&
-	     (ec->rx_coalesce_usecs < E1000_MIN_ITR_USECS)) ||
-	    (ec->rx_coalesce_usecs == 2))
+	if ((coal_base->rx_coalesce_usecs > E1000_MAX_ITR_USECS) ||
+	    ((coal_base->rx_coalesce_usecs > 4) &&
+	     (coal_base->rx_coalesce_usecs < E1000_MIN_ITR_USECS)) ||
+	    (coal_base->rx_coalesce_usecs == 2))
 		return -EINVAL;
 
-	if (ec->rx_coalesce_usecs == 4) {
+	if (coal_base->rx_coalesce_usecs == 4) {
 		adapter->itr_setting = 4;
 		adapter->itr = adapter->itr_setting;
-	} else if (ec->rx_coalesce_usecs <= 3) {
+	} else if (coal_base->rx_coalesce_usecs <= 3) {
 		adapter->itr = 20000;
-		adapter->itr_setting = ec->rx_coalesce_usecs;
+		adapter->itr_setting = coal_base->rx_coalesce_usecs;
 	} else {
-		adapter->itr = (1000000 / ec->rx_coalesce_usecs);
+		adapter->itr = (1000000 / coal_base->rx_coalesce_usecs);
 		adapter->itr_setting = adapter->itr & ~3;
 	}
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 66776ba..47e7176 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -632,40 +632,44 @@ static int fm10k_set_ringparam(struct net_device *netdev,
 }
 
 static int fm10k_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct fm10k_intfc *interface = netdev_priv(dev);
 
-	ec->use_adaptive_tx_coalesce = ITR_IS_ADAPTIVE(interface->tx_itr);
-	ec->tx_coalesce_usecs = interface->tx_itr & ~FM10K_ITR_ADAPTIVE;
+	coal_base->use_adaptive_tx_coalesce = ITR_IS_ADAPTIVE(interface->tx_itr);
+	coal_base->tx_coalesce_usecs = interface->tx_itr & ~FM10K_ITR_ADAPTIVE;
 
-	ec->use_adaptive_rx_coalesce = ITR_IS_ADAPTIVE(interface->rx_itr);
-	ec->rx_coalesce_usecs = interface->rx_itr & ~FM10K_ITR_ADAPTIVE;
+	coal_base->use_adaptive_rx_coalesce = ITR_IS_ADAPTIVE(interface->rx_itr);
+	coal_base->rx_coalesce_usecs = interface->rx_itr & ~FM10K_ITR_ADAPTIVE;
 
 	return 0;
 }
 
 static int fm10k_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct fm10k_intfc *interface = netdev_priv(dev);
 	u16 tx_itr, rx_itr;
 	int i;
 
 	/* verify limits */
-	if ((ec->rx_coalesce_usecs > FM10K_ITR_MAX) ||
-	    (ec->tx_coalesce_usecs > FM10K_ITR_MAX))
+	if ((coal_base->rx_coalesce_usecs > FM10K_ITR_MAX) ||
+	    (coal_base->tx_coalesce_usecs > FM10K_ITR_MAX))
 		return -EINVAL;
 
 	/* record settings */
-	tx_itr = ec->tx_coalesce_usecs;
-	rx_itr = ec->rx_coalesce_usecs;
+	tx_itr = coal_base->tx_coalesce_usecs;
+	rx_itr = coal_base->rx_coalesce_usecs;
 
 	/* set initial values for adaptive ITR */
-	if (ec->use_adaptive_tx_coalesce)
+	if (coal_base->use_adaptive_tx_coalesce)
 		tx_itr = FM10K_ITR_ADAPTIVE | FM10K_TX_ITR_DEFAULT;
 
-	if (ec->use_adaptive_rx_coalesce)
+	if (coal_base->use_adaptive_rx_coalesce)
 		rx_itr = FM10K_ITR_ADAPTIVE | FM10K_RX_ITR_DEFAULT;
 
 	/* update interface */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index ccd5b94..3f4e8bb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2819,9 +2819,12 @@ static int __i40e_get_coalesce(struct net_device *netdev,
  * __i40e_get_coalesce for more details.
  **/
 static int i40e_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ec)
 {
-	return __i40e_get_coalesce(netdev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __i40e_get_coalesce(netdev, coal_base, -1);
 }
 
 /**
@@ -2991,9 +2994,12 @@ static int __i40e_set_coalesce(struct net_device *netdev,
  * This will set each queue to the same coalesce settings.
  **/
 static int i40e_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ec)
 {
-	return __i40e_set_coalesce(netdev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __i40e_set_coalesce(netdev, coal_base, -1);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index af43fbd..6adf873 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -692,9 +692,12 @@ static int __iavf_get_coalesce(struct net_device *netdev,
  * only represents the settings of queue 0.
  **/
 static int iavf_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ec)
 {
-	return __iavf_get_coalesce(netdev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __iavf_get_coalesce(netdev, coal_base, -1);
 }
 
 /**
@@ -808,9 +811,12 @@ static int __iavf_set_coalesce(struct net_device *netdev,
  * Change current coalescing settings for every queue.
  **/
 static int iavf_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ec)
 {
-	return __iavf_set_coalesce(netdev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __iavf_set_coalesce(netdev, coal_base, -1);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d9ddd0b..2a60939 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3586,10 +3586,13 @@ __ice_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	return 0;
 }
 
-static int
-ice_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int ice_get_coalesce(struct net_device *netdev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
-	return __ice_get_coalesce(netdev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __ice_get_coalesce(netdev, coal_base, -1);
 }
 
 static int
@@ -3805,10 +3808,13 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	return 0;
 }
 
-static int
-ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int ice_set_coalesce(struct net_device *netdev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
-	return __ice_set_coalesce(netdev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __ice_set_coalesce(netdev, coal_base, -1);
 }
 
 static int
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 7545da2..fa156c9 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2182,45 +2182,47 @@ static int igb_set_phys_id(struct net_device *netdev,
 }
 
 static int igb_set_coalesce(struct net_device *netdev,
-			    struct ethtool_coalesce *ec)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	int i;
 
-	if ((ec->rx_coalesce_usecs > IGB_MAX_ITR_USECS) ||
-	    ((ec->rx_coalesce_usecs > 3) &&
-	     (ec->rx_coalesce_usecs < IGB_MIN_ITR_USECS)) ||
-	    (ec->rx_coalesce_usecs == 2))
+	if ((coal_base->rx_coalesce_usecs > IGB_MAX_ITR_USECS) ||
+	    ((coal_base->rx_coalesce_usecs > 3) &&
+	     (coal_base->rx_coalesce_usecs < IGB_MIN_ITR_USECS)) ||
+	    (coal_base->rx_coalesce_usecs == 2))
 		return -EINVAL;
 
-	if ((ec->tx_coalesce_usecs > IGB_MAX_ITR_USECS) ||
-	    ((ec->tx_coalesce_usecs > 3) &&
-	     (ec->tx_coalesce_usecs < IGB_MIN_ITR_USECS)) ||
-	    (ec->tx_coalesce_usecs == 2))
+	if ((coal_base->tx_coalesce_usecs > IGB_MAX_ITR_USECS) ||
+	    ((coal_base->tx_coalesce_usecs > 3) &&
+	     (coal_base->tx_coalesce_usecs < IGB_MIN_ITR_USECS)) ||
+	    (coal_base->tx_coalesce_usecs == 2))
 		return -EINVAL;
 
-	if ((adapter->flags & IGB_FLAG_QUEUE_PAIRS) && ec->tx_coalesce_usecs)
+	if ((adapter->flags & IGB_FLAG_QUEUE_PAIRS) && coal_base->tx_coalesce_usecs)
 		return -EINVAL;
 
 	/* If ITR is disabled, disable DMAC */
-	if (ec->rx_coalesce_usecs == 0) {
+	if (coal_base->rx_coalesce_usecs == 0) {
 		if (adapter->flags & IGB_FLAG_DMAC)
 			adapter->flags &= ~IGB_FLAG_DMAC;
 	}
 
 	/* convert to rate of irq's per second */
-	if (ec->rx_coalesce_usecs && ec->rx_coalesce_usecs <= 3)
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs;
+	if (coal_base->rx_coalesce_usecs && coal_base->rx_coalesce_usecs <= 3)
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs;
 	else
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs << 2;
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs << 2;
 
 	/* convert to rate of irq's per second */
 	if (adapter->flags & IGB_FLAG_QUEUE_PAIRS)
 		adapter->tx_itr_setting = adapter->rx_itr_setting;
-	else if (ec->tx_coalesce_usecs && ec->tx_coalesce_usecs <= 3)
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs;
+	else if (coal_base->tx_coalesce_usecs && coal_base->tx_coalesce_usecs <= 3)
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs;
 	else
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs << 2;
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs << 2;
 
 	for (i = 0; i < adapter->num_q_vectors; i++) {
 		struct igb_q_vector *q_vector = adapter->q_vector[i];
@@ -2238,20 +2240,22 @@ static int igb_set_coalesce(struct net_device *netdev,
 }
 
 static int igb_get_coalesce(struct net_device *netdev,
-			    struct ethtool_coalesce *ec)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->rx_itr_setting <= 3)
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting;
 	else
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
 
 	if (!(adapter->flags & IGB_FLAG_QUEUE_PAIRS)) {
 		if (adapter->tx_itr_setting <= 3)
-			ec->tx_coalesce_usecs = adapter->tx_itr_setting;
+			coal_base->tx_coalesce_usecs = adapter->tx_itr_setting;
 		else
-			ec->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
+			coal_base->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index f4835eb..3dbb449 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -314,34 +314,38 @@ static int igbvf_set_wol(struct net_device *netdev,
 }
 
 static int igbvf_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->requested_itr <= 3)
-		ec->rx_coalesce_usecs = adapter->requested_itr;
+		coal_base->rx_coalesce_usecs = adapter->requested_itr;
 	else
-		ec->rx_coalesce_usecs = adapter->current_itr >> 2;
+		coal_base->rx_coalesce_usecs = adapter->current_itr >> 2;
 
 	return 0;
 }
 
 static int igbvf_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 
-	if ((ec->rx_coalesce_usecs >= IGBVF_MIN_ITR_USECS) &&
-	    (ec->rx_coalesce_usecs <= IGBVF_MAX_ITR_USECS)) {
-		adapter->current_itr = ec->rx_coalesce_usecs << 2;
+	if ((coal_base->rx_coalesce_usecs >= IGBVF_MIN_ITR_USECS) &&
+	    (coal_base->rx_coalesce_usecs <= IGBVF_MAX_ITR_USECS)) {
+		adapter->current_itr = coal_base->rx_coalesce_usecs << 2;
 		adapter->requested_itr = 1000000000 /
 					(adapter->current_itr * 256);
-	} else if ((ec->rx_coalesce_usecs == 3) ||
-		   (ec->rx_coalesce_usecs == 2)) {
+	} else if ((coal_base->rx_coalesce_usecs == 3) ||
+		   (coal_base->rx_coalesce_usecs == 2)) {
 		adapter->current_itr = IGBVF_START_ITR;
-		adapter->requested_itr = ec->rx_coalesce_usecs;
-	} else if (ec->rx_coalesce_usecs == 0) {
+		adapter->requested_itr = coal_base->rx_coalesce_usecs;
+	} else if (coal_base->rx_coalesce_usecs == 0) {
 		/* The user's desire is to turn off interrupt throttling
 		 * altogether, but due to HW limitations, we can't do that.
 		 * Instead we set a very small value in EITR, which would
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 9722449..7e7f929 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -875,65 +875,69 @@ static void igc_ethtool_get_stats(struct net_device *netdev,
 }
 
 static int igc_ethtool_get_coalesce(struct net_device *netdev,
-				    struct ethtool_coalesce *ec)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->rx_itr_setting <= 3)
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting;
 	else
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
 
 	if (!(adapter->flags & IGC_FLAG_QUEUE_PAIRS)) {
 		if (adapter->tx_itr_setting <= 3)
-			ec->tx_coalesce_usecs = adapter->tx_itr_setting;
+			coal_base->tx_coalesce_usecs = adapter->tx_itr_setting;
 		else
-			ec->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
+			coal_base->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
 	}
 
 	return 0;
 }
 
 static int igc_ethtool_set_coalesce(struct net_device *netdev,
-				    struct ethtool_coalesce *ec)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	int i;
 
-	if (ec->rx_coalesce_usecs > IGC_MAX_ITR_USECS ||
-	    (ec->rx_coalesce_usecs > 3 &&
-	     ec->rx_coalesce_usecs < IGC_MIN_ITR_USECS) ||
-	    ec->rx_coalesce_usecs == 2)
+	if (coal_base->rx_coalesce_usecs > IGC_MAX_ITR_USECS ||
+	    (coal_base->rx_coalesce_usecs > 3 &&
+	     coal_base->rx_coalesce_usecs < IGC_MIN_ITR_USECS) ||
+	    coal_base->rx_coalesce_usecs == 2)
 		return -EINVAL;
 
-	if (ec->tx_coalesce_usecs > IGC_MAX_ITR_USECS ||
-	    (ec->tx_coalesce_usecs > 3 &&
-	     ec->tx_coalesce_usecs < IGC_MIN_ITR_USECS) ||
-	    ec->tx_coalesce_usecs == 2)
+	if (coal_base->tx_coalesce_usecs > IGC_MAX_ITR_USECS ||
+	    (coal_base->tx_coalesce_usecs > 3 &&
+	     coal_base->tx_coalesce_usecs < IGC_MIN_ITR_USECS) ||
+	    coal_base->tx_coalesce_usecs == 2)
 		return -EINVAL;
 
-	if ((adapter->flags & IGC_FLAG_QUEUE_PAIRS) && ec->tx_coalesce_usecs)
+	if ((adapter->flags & IGC_FLAG_QUEUE_PAIRS) && coal_base->tx_coalesce_usecs)
 		return -EINVAL;
 
 	/* If ITR is disabled, disable DMAC */
-	if (ec->rx_coalesce_usecs == 0) {
+	if (coal_base->rx_coalesce_usecs == 0) {
 		if (adapter->flags & IGC_FLAG_DMAC)
 			adapter->flags &= ~IGC_FLAG_DMAC;
 	}
 
 	/* convert to rate of irq's per second */
-	if (ec->rx_coalesce_usecs && ec->rx_coalesce_usecs <= 3)
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs;
+	if (coal_base->rx_coalesce_usecs && coal_base->rx_coalesce_usecs <= 3)
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs;
 	else
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs << 2;
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs << 2;
 
 	/* convert to rate of irq's per second */
 	if (adapter->flags & IGC_FLAG_QUEUE_PAIRS)
 		adapter->tx_itr_setting = adapter->rx_itr_setting;
-	else if (ec->tx_coalesce_usecs && ec->tx_coalesce_usecs <= 3)
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs;
+	else if (coal_base->tx_coalesce_usecs && coal_base->tx_coalesce_usecs <= 3)
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs;
 	else
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs << 2;
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs << 2;
 
 	for (i = 0; i < adapter->num_q_vectors; i++) {
 		struct igc_q_vector *q_vector = adapter->q_vector[i];
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 4ceaca0..7e70979 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2358,15 +2358,17 @@ static int ixgbe_set_phys_id(struct net_device *netdev,
 }
 
 static int ixgbe_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	/* only valid if in constant ITR mode */
 	if (adapter->rx_itr_setting <= 1)
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting;
 	else
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
 
 	/* if in mixed tx/rx queues per vector mode, report only rx settings */
 	if (adapter->q_vector[0]->tx.count && adapter->q_vector[0]->rx.count)
@@ -2374,9 +2376,9 @@ static int ixgbe_get_coalesce(struct net_device *netdev,
 
 	/* only valid if in constant ITR mode */
 	if (adapter->tx_itr_setting <= 1)
-		ec->tx_coalesce_usecs = adapter->tx_itr_setting;
+		coal_base->tx_coalesce_usecs = adapter->tx_itr_setting;
 	else
-		ec->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
+		coal_base->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
 
 	return 0;
 }
@@ -2412,8 +2414,10 @@ static bool ixgbe_update_rsc(struct ixgbe_adapter *adapter)
 }
 
 static int ixgbe_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_q_vector *q_vector;
 	int i;
@@ -2422,31 +2426,31 @@ static int ixgbe_set_coalesce(struct net_device *netdev,
 
 	if (adapter->q_vector[0]->tx.count && adapter->q_vector[0]->rx.count) {
 		/* reject Tx specific changes in case of mixed RxTx vectors */
-		if (ec->tx_coalesce_usecs)
+		if (coal_base->tx_coalesce_usecs)
 			return -EINVAL;
 		tx_itr_prev = adapter->rx_itr_setting;
 	} else {
 		tx_itr_prev = adapter->tx_itr_setting;
 	}
 
-	if ((ec->rx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)) ||
-	    (ec->tx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)))
+	if ((coal_base->rx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)) ||
+	    (coal_base->tx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)))
 		return -EINVAL;
 
-	if (ec->rx_coalesce_usecs > 1)
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs << 2;
+	if (coal_base->rx_coalesce_usecs > 1)
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs << 2;
 	else
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs;
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs;
 
 	if (adapter->rx_itr_setting == 1)
 		rx_itr_param = IXGBE_20K_ITR;
 	else
 		rx_itr_param = adapter->rx_itr_setting;
 
-	if (ec->tx_coalesce_usecs > 1)
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs << 2;
+	if (coal_base->tx_coalesce_usecs > 1)
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs << 2;
 	else
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs;
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs;
 
 	if (adapter->tx_itr_setting == 1)
 		tx_itr_param = IXGBE_12K_ITR;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index e49fb1c..5dfc2e3d 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -787,15 +787,17 @@ static int ixgbevf_nway_reset(struct net_device *netdev)
 }
 
 static int ixgbevf_get_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
 	/* only valid if in constant ITR mode */
 	if (adapter->rx_itr_setting <= 1)
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting;
 	else
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
+		coal_base->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
 
 	/* if in mixed Tx/Rx queues per vector mode, report only Rx settings */
 	if (adapter->q_vector[0]->tx.count && adapter->q_vector[0]->rx.count)
@@ -803,16 +805,18 @@ static int ixgbevf_get_coalesce(struct net_device *netdev,
 
 	/* only valid if in constant ITR mode */
 	if (adapter->tx_itr_setting <= 1)
-		ec->tx_coalesce_usecs = adapter->tx_itr_setting;
+		coal_base->tx_coalesce_usecs = adapter->tx_itr_setting;
 	else
-		ec->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
+		coal_base->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
 
 	return 0;
 }
 
 static int ixgbevf_set_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 	struct ixgbevf_q_vector *q_vector;
 	int num_vectors, i;
@@ -820,27 +824,27 @@ static int ixgbevf_set_coalesce(struct net_device *netdev,
 
 	/* don't accept Tx specific changes if we've got mixed RxTx vectors */
 	if (adapter->q_vector[0]->tx.count &&
-	    adapter->q_vector[0]->rx.count && ec->tx_coalesce_usecs)
+	    adapter->q_vector[0]->rx.count && coal_base->tx_coalesce_usecs)
 		return -EINVAL;
 
-	if ((ec->rx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)) ||
-	    (ec->tx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)))
+	if ((coal_base->rx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)) ||
+	    (coal_base->tx_coalesce_usecs > (IXGBE_MAX_EITR >> 2)))
 		return -EINVAL;
 
-	if (ec->rx_coalesce_usecs > 1)
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs << 2;
+	if (coal_base->rx_coalesce_usecs > 1)
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs << 2;
 	else
-		adapter->rx_itr_setting = ec->rx_coalesce_usecs;
+		adapter->rx_itr_setting = coal_base->rx_coalesce_usecs;
 
 	if (adapter->rx_itr_setting == 1)
 		rx_itr_param = IXGBE_20K_ITR;
 	else
 		rx_itr_param = adapter->rx_itr_setting;
 
-	if (ec->tx_coalesce_usecs > 1)
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs << 2;
+	if (coal_base->tx_coalesce_usecs > 1)
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs << 2;
 	else
-		adapter->tx_itr_setting = ec->tx_coalesce_usecs;
+		adapter->tx_itr_setting = coal_base->tx_coalesce_usecs;
 
 	if (adapter->tx_itr_setting == 1)
 		tx_itr_param = IXGBE_12K_ITR;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index f1b9284..43a06a4 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2400,35 +2400,37 @@ jme_get_regs(struct net_device *netdev, struct ethtool_regs *regs, void *p)
 	mdio_memcpy(jme, p32, JME_PHY_REG_NR);
 }
 
-static int
-jme_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecmd)
+static int jme_get_coalesce(struct net_device *netdev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct jme_adapter *jme = netdev_priv(netdev);
 
-	ecmd->tx_coalesce_usecs = PCC_TX_TO;
-	ecmd->tx_max_coalesced_frames = PCC_TX_CNT;
+	coal_base->tx_coalesce_usecs = PCC_TX_TO;
+	coal_base->tx_max_coalesced_frames = PCC_TX_CNT;
 
 	if (test_bit(JME_FLAG_POLL, &jme->flags)) {
-		ecmd->use_adaptive_rx_coalesce = false;
-		ecmd->rx_coalesce_usecs = 0;
-		ecmd->rx_max_coalesced_frames = 0;
+		coal_base->use_adaptive_rx_coalesce = false;
+		coal_base->rx_coalesce_usecs = 0;
+		coal_base->rx_max_coalesced_frames = 0;
 		return 0;
 	}
 
-	ecmd->use_adaptive_rx_coalesce = true;
+	coal_base->use_adaptive_rx_coalesce = true;
 
 	switch (jme->dpi.cur) {
 	case PCC_P1:
-		ecmd->rx_coalesce_usecs = PCC_P1_TO;
-		ecmd->rx_max_coalesced_frames = PCC_P1_CNT;
+		coal_base->rx_coalesce_usecs = PCC_P1_TO;
+		coal_base->rx_max_coalesced_frames = PCC_P1_CNT;
 		break;
 	case PCC_P2:
-		ecmd->rx_coalesce_usecs = PCC_P2_TO;
-		ecmd->rx_max_coalesced_frames = PCC_P2_CNT;
+		coal_base->rx_coalesce_usecs = PCC_P2_TO;
+		coal_base->rx_max_coalesced_frames = PCC_P2_CNT;
 		break;
 	case PCC_P3:
-		ecmd->rx_coalesce_usecs = PCC_P3_TO;
-		ecmd->rx_max_coalesced_frames = PCC_P3_CNT;
+		coal_base->rx_coalesce_usecs = PCC_P3_TO;
+		coal_base->rx_max_coalesced_frames = PCC_P3_CNT;
 		break;
 	default:
 		break;
@@ -2437,16 +2439,18 @@ jme_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecmd)
 	return 0;
 }
 
-static int
-jme_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecmd)
+static int jme_set_coalesce(struct net_device *netdev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct jme_adapter *jme = netdev_priv(netdev);
 	struct dynpcc_info *dpi = &(jme->dpi);
 
 	if (netif_running(netdev))
 		return -EBUSY;
 
-	if (ecmd->use_adaptive_rx_coalesce &&
+	if (coal_base->use_adaptive_rx_coalesce &&
 	    test_bit(JME_FLAG_POLL, &jme->flags)) {
 		clear_bit(JME_FLAG_POLL, &jme->flags);
 		jme->jme_rx = netif_rx;
@@ -2455,7 +2459,7 @@ jme_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecmd)
 		dpi->cnt		= 0;
 		jme_set_rx_pcc(jme, PCC_P1);
 		jme_interrupt_mode(jme);
-	} else if (!(ecmd->use_adaptive_rx_coalesce) &&
+	} else if (!(coal_base->use_adaptive_rx_coalesce) &&
 		   !(test_bit(JME_FLAG_POLL, &jme->flags))) {
 		set_bit(JME_FLAG_POLL, &jme->flags);
 		jme->jme_rx = netif_receive_skb;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index d207bfc..e64e73d 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1611,24 +1611,28 @@ static void mv643xx_eth_get_drvinfo(struct net_device *dev,
 	strlcpy(drvinfo->bus_info, "platform", sizeof(drvinfo->bus_info));
 }
 
-static int
-mv643xx_eth_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int mv643xx_eth_get_coalesce(struct net_device *dev,
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
-	ec->rx_coalesce_usecs = get_rx_coal(mp);
-	ec->tx_coalesce_usecs = get_tx_coal(mp);
+	coal_base->rx_coalesce_usecs = get_rx_coal(mp);
+	coal_base->tx_coalesce_usecs = get_tx_coal(mp);
 
 	return 0;
 }
 
-static int
-mv643xx_eth_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int mv643xx_eth_set_coalesce(struct net_device *dev,
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
 
-	set_rx_coal(mp, ec->rx_coalesce_usecs);
-	set_tx_coal(mp, ec->tx_coalesce_usecs);
+	set_rx_coal(mp, coal_base->rx_coalesce_usecs);
+	set_tx_coal(mp, coal_base->tx_coalesce_usecs);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5cd9b..fede8d5 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4501,22 +4501,24 @@ static int mvneta_ethtool_nway_reset(struct net_device *dev)
 
 /* Set interrupt coalescing for ethtools */
 static int mvneta_ethtool_set_coalesce(struct net_device *dev,
-				       struct ethtool_coalesce *c)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct mvneta_port *pp = netdev_priv(dev);
 	int queue;
 
 	for (queue = 0; queue < rxq_number; queue++) {
 		struct mvneta_rx_queue *rxq = &pp->rxqs[queue];
-		rxq->time_coal = c->rx_coalesce_usecs;
-		rxq->pkts_coal = c->rx_max_coalesced_frames;
+		rxq->time_coal = coal_base->rx_coalesce_usecs;
+		rxq->pkts_coal = coal_base->rx_max_coalesced_frames;
 		mvneta_rx_pkts_coal_set(pp, rxq, rxq->pkts_coal);
 		mvneta_rx_time_coal_set(pp, rxq, rxq->time_coal);
 	}
 
 	for (queue = 0; queue < txq_number; queue++) {
 		struct mvneta_tx_queue *txq = &pp->txqs[queue];
-		txq->done_pkts_coal = c->tx_max_coalesced_frames;
+		txq->done_pkts_coal = coal_base->tx_max_coalesced_frames;
 		mvneta_tx_done_pkts_coal_set(pp, txq, txq->done_pkts_coal);
 	}
 
@@ -4525,14 +4527,16 @@ static int mvneta_ethtool_set_coalesce(struct net_device *dev,
 
 /* get coalescing for ethtools */
 static int mvneta_ethtool_get_coalesce(struct net_device *dev,
-				       struct ethtool_coalesce *c)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct mvneta_port *pp = netdev_priv(dev);
 
-	c->rx_coalesce_usecs        = pp->rxqs[0].time_coal;
-	c->rx_max_coalesced_frames  = pp->rxqs[0].pkts_coal;
+	coal_base->rx_coalesce_usecs        = pp->rxqs[0].time_coal;
+	coal_base->rx_max_coalesced_frames  = pp->rxqs[0].pkts_coal;
 
-	c->tx_max_coalesced_frames =  pp->txqs[0].done_pkts_coal;
+	coal_base->tx_max_coalesced_frames =  pp->txqs[0].done_pkts_coal;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b2259bf..a6d118e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5337,29 +5337,31 @@ static int mvpp2_ethtool_nway_reset(struct net_device *dev)
 
 /* Set interrupt coalescing for ethtools */
 static int mvpp2_ethtool_set_coalesce(struct net_device *dev,
-				      struct ethtool_coalesce *c)
+				      struct netlink_ext_ack *extack,
+				      struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct mvpp2_port *port = netdev_priv(dev);
 	int queue;
 
 	for (queue = 0; queue < port->nrxqs; queue++) {
 		struct mvpp2_rx_queue *rxq = port->rxqs[queue];
 
-		rxq->time_coal = c->rx_coalesce_usecs;
-		rxq->pkts_coal = c->rx_max_coalesced_frames;
+		rxq->time_coal = coal_base->rx_coalesce_usecs;
+		rxq->pkts_coal = coal_base->rx_max_coalesced_frames;
 		mvpp2_rx_pkts_coal_set(port, rxq);
 		mvpp2_rx_time_coal_set(port, rxq);
 	}
 
 	if (port->has_tx_irqs) {
-		port->tx_time_coal = c->tx_coalesce_usecs;
+		port->tx_time_coal = coal_base->tx_coalesce_usecs;
 		mvpp2_tx_time_coal_set(port);
 	}
 
 	for (queue = 0; queue < port->ntxqs; queue++) {
 		struct mvpp2_tx_queue *txq = port->txqs[queue];
 
-		txq->done_pkts_coal = c->tx_max_coalesced_frames;
+		txq->done_pkts_coal = coal_base->tx_max_coalesced_frames;
 
 		if (port->has_tx_irqs)
 			mvpp2_tx_pkts_coal_set(port, txq);
@@ -5370,14 +5372,16 @@ static int mvpp2_ethtool_set_coalesce(struct net_device *dev,
 
 /* get coalescing for ethtools */
 static int mvpp2_ethtool_get_coalesce(struct net_device *dev,
-				      struct ethtool_coalesce *c)
+				      struct netlink_ext_ack *extack,
+				      struct kernel_ethtool_coalesce *c)
 {
+	struct ethtool_coalesce *coal_base = &c->base;
 	struct mvpp2_port *port = netdev_priv(dev);
 
-	c->rx_coalesce_usecs       = port->rxqs[0]->time_coal;
-	c->rx_max_coalesced_frames = port->rxqs[0]->pkts_coal;
-	c->tx_max_coalesced_frames = port->txqs[0]->done_pkts_coal;
-	c->tx_coalesce_usecs       = port->tx_time_coal;
+	coal_base->rx_coalesce_usecs       = port->rxqs[0]->time_coal;
+	coal_base->rx_max_coalesced_frames = port->rxqs[0]->pkts_coal;
+	coal_base->tx_max_coalesced_frames = port->txqs[0]->done_pkts_coal;
+	coal_base->tx_coalesce_usecs       = port->tx_time_coal;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index f4962a9..9166a8c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -410,66 +410,75 @@ static int otx2_set_ringparam(struct net_device *netdev,
 }
 
 static int otx2_get_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *cmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *cmd)
 {
+	struct ethtool_coalesce *coal_base = &cmd->base;
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_hw *hw = &pfvf->hw;
 
-	cmd->rx_coalesce_usecs = hw->cq_time_wait;
-	cmd->rx_max_coalesced_frames = hw->cq_ecount_wait;
-	cmd->tx_coalesce_usecs = hw->cq_time_wait;
-	cmd->tx_max_coalesced_frames = hw->cq_ecount_wait;
+	coal_base->rx_coalesce_usecs = hw->cq_time_wait;
+	coal_base->rx_max_coalesced_frames = hw->cq_ecount_wait;
+	coal_base->tx_coalesce_usecs = hw->cq_time_wait;
+	coal_base->tx_max_coalesced_frames = hw->cq_ecount_wait;
 
 	return 0;
 }
 
 static int otx2_set_coalesce(struct net_device *netdev,
-			     struct ethtool_coalesce *ec)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_hw *hw = &pfvf->hw;
 	int qidx;
 
-	if (!ec->rx_max_coalesced_frames || !ec->tx_max_coalesced_frames)
+	if (!coal_base->rx_max_coalesced_frames || !coal_base->tx_max_coalesced_frames)
 		return 0;
 
 	/* 'cq_time_wait' is 8bit and is in multiple of 100ns,
 	 * so clamp the user given value to the range of 1 to 25usec.
 	 */
-	ec->rx_coalesce_usecs = clamp_t(u32, ec->rx_coalesce_usecs,
-					1, CQ_TIMER_THRESH_MAX);
-	ec->tx_coalesce_usecs = clamp_t(u32, ec->tx_coalesce_usecs,
-					1, CQ_TIMER_THRESH_MAX);
+	coal_base->rx_coalesce_usecs = clamp_t(u32,
+					       coal_base->rx_coalesce_usecs,
+					       1, CQ_TIMER_THRESH_MAX);
+	coal_base->tx_coalesce_usecs = clamp_t(u32,
+					       coal_base->tx_coalesce_usecs,
+					       1, CQ_TIMER_THRESH_MAX);
 
 	/* Rx and Tx are mapped to same CQ, check which one
 	 * is changed, if both then choose the min.
 	 */
-	if (hw->cq_time_wait == ec->rx_coalesce_usecs)
-		hw->cq_time_wait = ec->tx_coalesce_usecs;
-	else if (hw->cq_time_wait == ec->tx_coalesce_usecs)
-		hw->cq_time_wait = ec->rx_coalesce_usecs;
+	if (hw->cq_time_wait == coal_base->rx_coalesce_usecs)
+		hw->cq_time_wait = coal_base->tx_coalesce_usecs;
+	else if (hw->cq_time_wait == coal_base->tx_coalesce_usecs)
+		hw->cq_time_wait = coal_base->rx_coalesce_usecs;
 	else
-		hw->cq_time_wait = min_t(u8, ec->rx_coalesce_usecs,
-					 ec->tx_coalesce_usecs);
+		hw->cq_time_wait = min_t(u8, coal_base->rx_coalesce_usecs,
+					 coal_base->tx_coalesce_usecs);
 
 	/* Max ecount_wait supported is 16bit,
 	 * so clamp the user given value to the range of 1 to 64k.
 	 */
-	ec->rx_max_coalesced_frames = clamp_t(u32, ec->rx_max_coalesced_frames,
-					      1, U16_MAX);
-	ec->tx_max_coalesced_frames = clamp_t(u32, ec->tx_max_coalesced_frames,
-					      1, U16_MAX);
+	coal_base->rx_max_coalesced_frames = clamp_t(u32,
+						     coal_base->rx_max_coalesced_frames,
+						     1, U16_MAX);
+	coal_base->tx_max_coalesced_frames = clamp_t(u32,
+						     coal_base->tx_max_coalesced_frames,
+						     1, U16_MAX);
 
 	/* Rx and Tx are mapped to same CQ, check which one
 	 * is changed, if both then choose the min.
 	 */
-	if (hw->cq_ecount_wait == ec->rx_max_coalesced_frames)
-		hw->cq_ecount_wait = ec->tx_max_coalesced_frames;
-	else if (hw->cq_ecount_wait == ec->tx_max_coalesced_frames)
-		hw->cq_ecount_wait = ec->rx_max_coalesced_frames;
+	if (hw->cq_ecount_wait == coal_base->rx_max_coalesced_frames)
+		hw->cq_ecount_wait = coal_base->tx_max_coalesced_frames;
+	else if (hw->cq_ecount_wait == coal_base->tx_max_coalesced_frames)
+		hw->cq_ecount_wait = coal_base->rx_max_coalesced_frames;
 	else
-		hw->cq_ecount_wait = min_t(u16, ec->rx_max_coalesced_frames,
-					   ec->tx_max_coalesced_frames);
+		hw->cq_ecount_wait = min_t(u16,
+					   coal_base->rx_max_coalesced_frames,
+					   coal_base->tx_max_coalesced_frames);
 
 	if (netif_running(netdev)) {
 		for (qidx = 0; qidx < pfvf->hw.cint_cnt; qidx++)
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index d4bb27b..5f4e2fe 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -615,23 +615,25 @@ static inline u32 skge_usecs2clk(const struct skge_hw *hw, u32 usec)
 }
 
 static int skge_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct skge_port *skge = netdev_priv(dev);
 	struct skge_hw *hw = skge->hw;
 	int port = skge->port;
 
-	ecmd->rx_coalesce_usecs = 0;
-	ecmd->tx_coalesce_usecs = 0;
+	coal_base->rx_coalesce_usecs = 0;
+	coal_base->tx_coalesce_usecs = 0;
 
 	if (skge_read32(hw, B2_IRQM_CTRL) & TIM_START) {
 		u32 delay = skge_clk2usec(hw, skge_read32(hw, B2_IRQM_INI));
 		u32 msk = skge_read32(hw, B2_IRQM_MSK);
 
 		if (msk & rxirqmask[port])
-			ecmd->rx_coalesce_usecs = delay;
+			coal_base->rx_coalesce_usecs = delay;
 		if (msk & txirqmask[port])
-			ecmd->tx_coalesce_usecs = delay;
+			coal_base->tx_coalesce_usecs = delay;
 	}
 
 	return 0;
@@ -639,32 +641,34 @@ static int skge_get_coalesce(struct net_device *dev,
 
 /* Note: interrupt timer is per board, but can turn on/off per port */
 static int skge_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct skge_port *skge = netdev_priv(dev);
 	struct skge_hw *hw = skge->hw;
 	int port = skge->port;
 	u32 msk = skge_read32(hw, B2_IRQM_MSK);
 	u32 delay = 25;
 
-	if (ecmd->rx_coalesce_usecs == 0)
+	if (coal_base->rx_coalesce_usecs == 0) {
 		msk &= ~rxirqmask[port];
-	else if (ecmd->rx_coalesce_usecs < 25 ||
-		 ecmd->rx_coalesce_usecs > 33333)
+	} else if (coal_base->rx_coalesce_usecs < 25 ||
+		 coal_base->rx_coalesce_usecs > 33333) {
 		return -EINVAL;
-	else {
+	} else {
 		msk |= rxirqmask[port];
-		delay = ecmd->rx_coalesce_usecs;
+		delay = coal_base->rx_coalesce_usecs;
 	}
 
-	if (ecmd->tx_coalesce_usecs == 0)
+	if (coal_base->tx_coalesce_usecs == 0) {
 		msk &= ~txirqmask[port];
-	else if (ecmd->tx_coalesce_usecs < 25 ||
-		 ecmd->tx_coalesce_usecs > 33333)
+	} else if (coal_base->tx_coalesce_usecs < 25 ||
+		 coal_base->tx_coalesce_usecs > 33333) {
 		return -EINVAL;
-	else {
+	} else {
 		msk |= txirqmask[port];
-		delay = min(delay, ecmd->rx_coalesce_usecs);
+		delay = min(delay, coal_base->rx_coalesce_usecs);
 	}
 
 	skge_write32(hw, B2_IRQM_MSK, msk);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 324c280..fb2a492 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4052,85 +4052,90 @@ static int sky2_set_pauseparam(struct net_device *dev,
 }
 
 static int sky2_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
 
 	if (sky2_read8(hw, STAT_TX_TIMER_CTRL) == TIM_STOP)
-		ecmd->tx_coalesce_usecs = 0;
+		coal_base->tx_coalesce_usecs = 0;
 	else {
 		u32 clks = sky2_read32(hw, STAT_TX_TIMER_INI);
-		ecmd->tx_coalesce_usecs = sky2_clk2us(hw, clks);
+		coal_base->tx_coalesce_usecs = sky2_clk2us(hw, clks);
 	}
-	ecmd->tx_max_coalesced_frames = sky2_read16(hw, STAT_TX_IDX_TH);
+	coal_base->tx_max_coalesced_frames = sky2_read16(hw, STAT_TX_IDX_TH);
 
 	if (sky2_read8(hw, STAT_LEV_TIMER_CTRL) == TIM_STOP)
-		ecmd->rx_coalesce_usecs = 0;
+		coal_base->rx_coalesce_usecs = 0;
 	else {
 		u32 clks = sky2_read32(hw, STAT_LEV_TIMER_INI);
-		ecmd->rx_coalesce_usecs = sky2_clk2us(hw, clks);
+		coal_base->rx_coalesce_usecs = sky2_clk2us(hw, clks);
 	}
-	ecmd->rx_max_coalesced_frames = sky2_read8(hw, STAT_FIFO_WM);
+	coal_base->rx_max_coalesced_frames = sky2_read8(hw, STAT_FIFO_WM);
 
 	if (sky2_read8(hw, STAT_ISR_TIMER_CTRL) == TIM_STOP)
-		ecmd->rx_coalesce_usecs_irq = 0;
+		coal_base->rx_coalesce_usecs_irq = 0;
 	else {
 		u32 clks = sky2_read32(hw, STAT_ISR_TIMER_INI);
-		ecmd->rx_coalesce_usecs_irq = sky2_clk2us(hw, clks);
+		coal_base->rx_coalesce_usecs_irq = sky2_clk2us(hw, clks);
 	}
 
-	ecmd->rx_max_coalesced_frames_irq = sky2_read8(hw, STAT_FIFO_ISR_WM);
+	coal_base->rx_max_coalesced_frames_irq = sky2_read8(hw, STAT_FIFO_ISR_WM);
 
 	return 0;
 }
 
 /* Note: this affect both ports */
 static int sky2_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *ecmd)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
 	const u32 tmax = sky2_clk2us(hw, 0x0ffffff);
 
-	if (ecmd->tx_coalesce_usecs > tmax ||
-	    ecmd->rx_coalesce_usecs > tmax ||
-	    ecmd->rx_coalesce_usecs_irq > tmax)
+	if (coal_base->tx_coalesce_usecs > tmax ||
+	    coal_base->rx_coalesce_usecs > tmax ||
+	    coal_base->rx_coalesce_usecs_irq > tmax)
 		return -EINVAL;
 
-	if (ecmd->tx_max_coalesced_frames >= sky2->tx_ring_size-1)
+	if (coal_base->tx_max_coalesced_frames >= sky2->tx_ring_size - 1)
 		return -EINVAL;
-	if (ecmd->rx_max_coalesced_frames > RX_MAX_PENDING)
+	if (coal_base->rx_max_coalesced_frames > RX_MAX_PENDING)
 		return -EINVAL;
-	if (ecmd->rx_max_coalesced_frames_irq > RX_MAX_PENDING)
+	if (coal_base->rx_max_coalesced_frames_irq > RX_MAX_PENDING)
 		return -EINVAL;
 
-	if (ecmd->tx_coalesce_usecs == 0)
+	if (coal_base->tx_coalesce_usecs == 0) {
 		sky2_write8(hw, STAT_TX_TIMER_CTRL, TIM_STOP);
-	else {
+	} else {
 		sky2_write32(hw, STAT_TX_TIMER_INI,
-			     sky2_us2clk(hw, ecmd->tx_coalesce_usecs));
+			     sky2_us2clk(hw, coal_base->tx_coalesce_usecs));
 		sky2_write8(hw, STAT_TX_TIMER_CTRL, TIM_START);
 	}
-	sky2_write16(hw, STAT_TX_IDX_TH, ecmd->tx_max_coalesced_frames);
+	sky2_write16(hw, STAT_TX_IDX_TH, coal_base->tx_max_coalesced_frames);
 
-	if (ecmd->rx_coalesce_usecs == 0)
+	if (coal_base->rx_coalesce_usecs == 0) {
 		sky2_write8(hw, STAT_LEV_TIMER_CTRL, TIM_STOP);
-	else {
+	} else {
 		sky2_write32(hw, STAT_LEV_TIMER_INI,
-			     sky2_us2clk(hw, ecmd->rx_coalesce_usecs));
+			     sky2_us2clk(hw, coal_base->rx_coalesce_usecs));
 		sky2_write8(hw, STAT_LEV_TIMER_CTRL, TIM_START);
 	}
-	sky2_write8(hw, STAT_FIFO_WM, ecmd->rx_max_coalesced_frames);
+	sky2_write8(hw, STAT_FIFO_WM, coal_base->rx_max_coalesced_frames);
 
-	if (ecmd->rx_coalesce_usecs_irq == 0)
+	if (coal_base->rx_coalesce_usecs_irq == 0) {
 		sky2_write8(hw, STAT_ISR_TIMER_CTRL, TIM_STOP);
-	else {
+	} else {
 		sky2_write32(hw, STAT_ISR_TIMER_INI,
-			     sky2_us2clk(hw, ecmd->rx_coalesce_usecs_irq));
+			     sky2_us2clk(hw, coal_base->rx_coalesce_usecs_irq));
 		sky2_write8(hw, STAT_ISR_TIMER_CTRL, TIM_START);
 	}
-	sky2_write8(hw, STAT_FIFO_ISR_WM, ecmd->rx_max_coalesced_frames_irq);
+	sky2_write8(hw, STAT_FIFO_ISR_WM,
+		    coal_base->rx_max_coalesced_frames_irq);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 1434df6..fd3b859 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -998,75 +998,79 @@ mlx4_en_set_link_ksettings(struct net_device *dev,
 }
 
 static int mlx4_en_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
-	coal->tx_coalesce_usecs = priv->tx_usecs;
-	coal->tx_max_coalesced_frames = priv->tx_frames;
-	coal->tx_max_coalesced_frames_irq = priv->tx_work_limit;
+	coal_base->tx_coalesce_usecs = priv->tx_usecs;
+	coal_base->tx_max_coalesced_frames = priv->tx_frames;
+	coal_base->tx_max_coalesced_frames_irq = priv->tx_work_limit;
 
-	coal->rx_coalesce_usecs = priv->rx_usecs;
-	coal->rx_max_coalesced_frames = priv->rx_frames;
+	coal_base->rx_coalesce_usecs = priv->rx_usecs;
+	coal_base->rx_max_coalesced_frames = priv->rx_frames;
 
-	coal->pkt_rate_low = priv->pkt_rate_low;
-	coal->rx_coalesce_usecs_low = priv->rx_usecs_low;
-	coal->pkt_rate_high = priv->pkt_rate_high;
-	coal->rx_coalesce_usecs_high = priv->rx_usecs_high;
-	coal->rate_sample_interval = priv->sample_interval;
-	coal->use_adaptive_rx_coalesce = priv->adaptive_rx_coal;
+	coal_base->pkt_rate_low = priv->pkt_rate_low;
+	coal_base->rx_coalesce_usecs_low = priv->rx_usecs_low;
+	coal_base->pkt_rate_high = priv->pkt_rate_high;
+	coal_base->rx_coalesce_usecs_high = priv->rx_usecs_high;
+	coal_base->rate_sample_interval = priv->sample_interval;
+	coal_base->use_adaptive_rx_coalesce = priv->adaptive_rx_coal;
 
 	return 0;
 }
 
 static int mlx4_en_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *coal)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 
-	if (!coal->tx_max_coalesced_frames_irq)
+	if (!coal_base->tx_max_coalesced_frames_irq)
 		return -EINVAL;
 
-	if (coal->tx_coalesce_usecs > MLX4_EN_MAX_COAL_TIME ||
-	    coal->rx_coalesce_usecs > MLX4_EN_MAX_COAL_TIME ||
-	    coal->rx_coalesce_usecs_low > MLX4_EN_MAX_COAL_TIME ||
-	    coal->rx_coalesce_usecs_high > MLX4_EN_MAX_COAL_TIME) {
+	if (coal_base->tx_coalesce_usecs > MLX4_EN_MAX_COAL_TIME ||
+	    coal_base->rx_coalesce_usecs > MLX4_EN_MAX_COAL_TIME ||
+	    coal_base->rx_coalesce_usecs_low > MLX4_EN_MAX_COAL_TIME ||
+	    coal_base->rx_coalesce_usecs_high > MLX4_EN_MAX_COAL_TIME) {
 		netdev_info(dev, "%s: maximum coalesce time supported is %d usecs\n",
 			    __func__, MLX4_EN_MAX_COAL_TIME);
 		return -ERANGE;
 	}
 
-	if (coal->tx_max_coalesced_frames > MLX4_EN_MAX_COAL_PKTS ||
-	    coal->rx_max_coalesced_frames > MLX4_EN_MAX_COAL_PKTS) {
+	if (coal_base->tx_max_coalesced_frames > MLX4_EN_MAX_COAL_PKTS ||
+	    coal_base->rx_max_coalesced_frames > MLX4_EN_MAX_COAL_PKTS) {
 		netdev_info(dev, "%s: maximum coalesced frames supported is %d\n",
 			    __func__, MLX4_EN_MAX_COAL_PKTS);
 		return -ERANGE;
 	}
 
-	priv->rx_frames = (coal->rx_max_coalesced_frames ==
+	priv->rx_frames = (coal_base->rx_max_coalesced_frames ==
 			   MLX4_EN_AUTO_CONF) ?
 				MLX4_EN_RX_COAL_TARGET :
-				coal->rx_max_coalesced_frames;
-	priv->rx_usecs = (coal->rx_coalesce_usecs ==
+				coal_base->rx_max_coalesced_frames;
+	priv->rx_usecs = (coal_base->rx_coalesce_usecs ==
 			  MLX4_EN_AUTO_CONF) ?
 				MLX4_EN_RX_COAL_TIME :
-				coal->rx_coalesce_usecs;
+				coal_base->rx_coalesce_usecs;
 
 	/* Setting TX coalescing parameters */
-	if (coal->tx_coalesce_usecs != priv->tx_usecs ||
-	    coal->tx_max_coalesced_frames != priv->tx_frames) {
-		priv->tx_usecs = coal->tx_coalesce_usecs;
-		priv->tx_frames = coal->tx_max_coalesced_frames;
+	if (coal_base->tx_coalesce_usecs != priv->tx_usecs ||
+	    coal_base->tx_max_coalesced_frames != priv->tx_frames) {
+		priv->tx_usecs = coal_base->tx_coalesce_usecs;
+		priv->tx_frames = coal_base->tx_max_coalesced_frames;
 	}
 
 	/* Set adaptive coalescing params */
-	priv->pkt_rate_low = coal->pkt_rate_low;
-	priv->rx_usecs_low = coal->rx_coalesce_usecs_low;
-	priv->pkt_rate_high = coal->pkt_rate_high;
-	priv->rx_usecs_high = coal->rx_coalesce_usecs_high;
-	priv->sample_interval = coal->rate_sample_interval;
-	priv->adaptive_rx_coal = coal->use_adaptive_rx_coalesce;
-	priv->tx_work_limit = coal->tx_max_coalesced_frames_irq;
+	priv->pkt_rate_low = coal_base->pkt_rate_low;
+	priv->rx_usecs_low = coal_base->rx_coalesce_usecs_low;
+	priv->pkt_rate_high = coal_base->pkt_rate_high;
+	priv->rx_usecs_high = coal_base->rx_coalesce_usecs_high;
+	priv->sample_interval = coal_base->rate_sample_interval;
+	priv->adaptive_rx_coal = coal_base->use_adaptive_rx_coalesce;
+	priv->tx_work_limit = coal_base->tx_max_coalesced_frames_irq;
 
 	return mlx4_en_moderation_update(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 8360289..90cc1fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -512,11 +512,13 @@ int mlx5e_ethtool_get_coalesce(struct mlx5e_priv *priv,
 }
 
 static int mlx5e_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	return mlx5e_ethtool_get_coalesce(priv, coal);
+	return mlx5e_ethtool_get_coalesce(priv, coal_base);
 }
 
 #define MLX5E_MAX_COAL_TIME		MLX5_MAX_CQ_PERIOD
@@ -630,11 +632,13 @@ int mlx5e_ethtool_set_coalesce(struct mlx5e_priv *priv,
 }
 
 static int mlx5e_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx5e_priv *priv    = netdev_priv(netdev);
 
-	return mlx5e_ethtool_set_coalesce(priv, coal);
+	return mlx5e_ethtool_set_coalesce(priv, coal_base);
 }
 
 static void ptys2ethtool_supported_link(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 34eb111..545b9fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -248,19 +248,23 @@ static int mlx5e_rep_set_channels(struct net_device *dev,
 }
 
 static int mlx5e_rep_get_coalesce(struct net_device *netdev,
-				  struct ethtool_coalesce *coal)
+				  struct netlink_ext_ack *extack,
+				  struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	return mlx5e_ethtool_get_coalesce(priv, coal);
+	return mlx5e_ethtool_get_coalesce(priv, coal_base);
 }
 
 static int mlx5e_rep_set_coalesce(struct net_device *netdev,
-				  struct ethtool_coalesce *coal)
+				  struct netlink_ext_ack *extack,
+				  struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	return mlx5e_ethtool_set_coalesce(priv, coal);
+	return mlx5e_ethtool_set_coalesce(priv, coal_base);
 }
 
 static u32 mlx5e_rep_get_rxfh_key_size(struct net_device *netdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 97d96fc..0a45ddc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -99,19 +99,23 @@ static void mlx5i_get_channels(struct net_device *dev,
 }
 
 static int mlx5i_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
 
-	return mlx5e_ethtool_set_coalesce(priv, coal);
+	return mlx5e_ethtool_set_coalesce(priv, coal_base);
 }
 
 static int mlx5i_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coal)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
 
-	return mlx5e_ethtool_get_coalesce(priv, coal);
+	return mlx5e_ethtool_get_coalesce(priv, coal_base);
 }
 
 static int mlx5i_get_ts_info(struct net_device *netdev,
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c84c8bf..cedb4fe 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1651,21 +1651,25 @@ myri10ge_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info)
 	strlcpy(info->bus_info, pci_name(mgp->pdev), sizeof(info->bus_info));
 }
 
-static int
-myri10ge_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *coal)
+static int myri10ge_get_coalesce(struct net_device *netdev,
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
-	coal->rx_coalesce_usecs = mgp->intr_coal_delay;
+	coal_base->rx_coalesce_usecs = mgp->intr_coal_delay;
 	return 0;
 }
 
-static int
-myri10ge_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *coal)
+static int myri10ge_set_coalesce(struct net_device *netdev,
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
-	mgp->intr_coal_delay = coal->rx_coalesce_usecs;
+	mgp->intr_coal_delay = coal_base->rx_coalesce_usecs;
 	put_be32(htonl(mgp->intr_coal_delay), mgp->intr_coal_delay_ptr);
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1b48244..c234a9a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1076,17 +1076,19 @@ static void nfp_net_get_regs(struct net_device *netdev,
 }
 
 static int nfp_net_get_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_IRQMOD))
 		return -EINVAL;
 
-	ec->rx_coalesce_usecs       = nn->rx_coalesce_usecs;
-	ec->rx_max_coalesced_frames = nn->rx_coalesce_max_frames;
-	ec->tx_coalesce_usecs       = nn->tx_coalesce_usecs;
-	ec->tx_max_coalesced_frames = nn->tx_coalesce_max_frames;
+	coal_base->rx_coalesce_usecs       = nn->rx_coalesce_usecs;
+	coal_base->rx_max_coalesced_frames = nn->rx_coalesce_max_frames;
+	coal_base->tx_coalesce_usecs       = nn->tx_coalesce_usecs;
+	coal_base->tx_max_coalesced_frames = nn->tx_coalesce_max_frames;
 
 	return 0;
 }
@@ -1325,8 +1327,10 @@ nfp_port_get_module_eeprom(struct net_device *netdev,
 }
 
 static int nfp_net_set_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *ec)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct nfp_net *nn = netdev_priv(netdev);
 	unsigned int factor;
 
@@ -1353,29 +1357,29 @@ static int nfp_net_set_coalesce(struct net_device *netdev,
 		return -EINVAL;
 
 	/* ensure valid configuration */
-	if (!ec->rx_coalesce_usecs && !ec->rx_max_coalesced_frames)
+	if (!coal_base->rx_coalesce_usecs && !coal_base->rx_max_coalesced_frames)
 		return -EINVAL;
 
-	if (!ec->tx_coalesce_usecs && !ec->tx_max_coalesced_frames)
+	if (!coal_base->tx_coalesce_usecs && !coal_base->tx_max_coalesced_frames)
 		return -EINVAL;
 
-	if (ec->rx_coalesce_usecs * factor >= ((1 << 16) - 1))
+	if (coal_base->rx_coalesce_usecs * factor >= ((1 << 16) - 1))
 		return -EINVAL;
 
-	if (ec->tx_coalesce_usecs * factor >= ((1 << 16) - 1))
+	if (coal_base->tx_coalesce_usecs * factor >= ((1 << 16) - 1))
 		return -EINVAL;
 
-	if (ec->rx_max_coalesced_frames >= ((1 << 16) - 1))
+	if (coal_base->rx_max_coalesced_frames >= ((1 << 16) - 1))
 		return -EINVAL;
 
-	if (ec->tx_max_coalesced_frames >= ((1 << 16) - 1))
+	if (coal_base->tx_max_coalesced_frames >= ((1 << 16) - 1))
 		return -EINVAL;
 
 	/* configuration is valid */
-	nn->rx_coalesce_usecs      = ec->rx_coalesce_usecs;
-	nn->rx_coalesce_max_frames = ec->rx_max_coalesced_frames;
-	nn->tx_coalesce_usecs      = ec->tx_coalesce_usecs;
-	nn->tx_coalesce_max_frames = ec->tx_max_coalesced_frames;
+	nn->rx_coalesce_usecs      = coal_base->rx_coalesce_usecs;
+	nn->rx_coalesce_max_frames = coal_base->rx_max_coalesced_frames;
+	nn->tx_coalesce_usecs      = coal_base->tx_coalesce_usecs;
+	nn->tx_coalesce_max_frames = coal_base->tx_max_coalesced_frames;
 
 	/* write configuration to device */
 	nfp_net_coalesce_write_cfg(nn);
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a6861df..0ae4383 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -994,23 +994,27 @@ static void nixge_ethtools_get_drvinfo(struct net_device *ndev,
 }
 
 static int nixge_ethtools_get_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *ecoalesce)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *ecoalesce)
 {
+	struct ethtool_coalesce *coal_base = &ecoalesce->base;
 	struct nixge_priv *priv = netdev_priv(ndev);
 	u32 regval = 0;
 
 	regval = nixge_dma_read_reg(priv, XAXIDMA_RX_CR_OFFSET);
-	ecoalesce->rx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
+	coal_base->rx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
 					     >> XAXIDMA_COALESCE_SHIFT;
 	regval = nixge_dma_read_reg(priv, XAXIDMA_TX_CR_OFFSET);
-	ecoalesce->tx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
+	coal_base->tx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
 					     >> XAXIDMA_COALESCE_SHIFT;
 	return 0;
 }
 
 static int nixge_ethtools_set_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *ecoalesce)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *ecoalesce)
 {
+	struct ethtool_coalesce *coal_base = &ecoalesce->base;
 	struct nixge_priv *priv = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
@@ -1019,10 +1023,10 @@ static int nixge_ethtools_set_coalesce(struct net_device *ndev,
 		return -EBUSY;
 	}
 
-	if (ecoalesce->rx_max_coalesced_frames)
-		priv->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
-	if (ecoalesce->tx_max_coalesced_frames)
-		priv->coalesce_count_tx = ecoalesce->tx_max_coalesced_frames;
+	if (coal_base->rx_max_coalesced_frames)
+		priv->coalesce_count_rx = coal_base->rx_max_coalesced_frames;
+	if (coal_base->tx_max_coalesced_frames)
+		priv->coalesce_count_tx = coal_base->tx_max_coalesced_frames;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 6583be5..1263883 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -408,26 +408,30 @@ static int ionic_set_fecparam(struct net_device *netdev,
 }
 
 static int ionic_get_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coalesce)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	coalesce->tx_coalesce_usecs = lif->tx_coalesce_usecs;
-	coalesce->rx_coalesce_usecs = lif->rx_coalesce_usecs;
+	coal_base->tx_coalesce_usecs = lif->tx_coalesce_usecs;
+	coal_base->rx_coalesce_usecs = lif->rx_coalesce_usecs;
 
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
-		coalesce->use_adaptive_tx_coalesce = test_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
+		coal_base->use_adaptive_tx_coalesce = test_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
 	else
-		coalesce->use_adaptive_tx_coalesce = 0;
+		coal_base->use_adaptive_tx_coalesce = 0;
 
-	coalesce->use_adaptive_rx_coalesce = test_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
+	coal_base->use_adaptive_rx_coalesce = test_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
 
 	return 0;
 }
 
 static int ionic_set_coalesce(struct net_device *netdev,
-			      struct ethtool_coalesce *coalesce)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_identity *ident;
 	u32 rx_coal, rx_dim;
@@ -443,8 +447,8 @@ static int ionic_set_coalesce(struct net_device *netdev,
 
 	/* Tx normally shares Rx interrupt, so only change Rx if not split */
 	if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) &&
-	    (coalesce->tx_coalesce_usecs != lif->rx_coalesce_usecs ||
-	     coalesce->use_adaptive_tx_coalesce)) {
+	    (coal_base->tx_coalesce_usecs != lif->rx_coalesce_usecs ||
+	     coal_base->use_adaptive_tx_coalesce)) {
 		netdev_warn(netdev, "only rx parameters can be changed\n");
 		return -EINVAL;
 	}
@@ -452,11 +456,13 @@ static int ionic_set_coalesce(struct net_device *netdev,
 	/* Convert the usec request to a HW usable value.  If they asked
 	 * for non-zero and it resolved to zero, bump it up
 	 */
-	rx_coal = ionic_coal_usec_to_hw(lif->ionic, coalesce->rx_coalesce_usecs);
-	if (!rx_coal && coalesce->rx_coalesce_usecs)
+	rx_coal = ionic_coal_usec_to_hw(lif->ionic,
+					coal_base->rx_coalesce_usecs);
+	if (!rx_coal && coal_base->rx_coalesce_usecs)
 		rx_coal = 1;
-	tx_coal = ionic_coal_usec_to_hw(lif->ionic, coalesce->tx_coalesce_usecs);
-	if (!tx_coal && coalesce->tx_coalesce_usecs)
+	tx_coal = ionic_coal_usec_to_hw(lif->ionic,
+					coal_base->tx_coalesce_usecs);
+	if (!tx_coal && coal_base->tx_coalesce_usecs)
 		tx_coal = 1;
 
 	if (rx_coal > IONIC_INTR_CTRL_COAL_MAX ||
@@ -464,16 +470,16 @@ static int ionic_set_coalesce(struct net_device *netdev,
 		return -ERANGE;
 
 	/* Save the new values */
-	lif->rx_coalesce_usecs = coalesce->rx_coalesce_usecs;
+	lif->rx_coalesce_usecs = coal_base->rx_coalesce_usecs;
 	lif->rx_coalesce_hw = rx_coal;
 
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
-		lif->tx_coalesce_usecs = coalesce->tx_coalesce_usecs;
+		lif->tx_coalesce_usecs = coal_base->tx_coalesce_usecs;
 	else
-		lif->tx_coalesce_usecs = coalesce->rx_coalesce_usecs;
+		lif->tx_coalesce_usecs = coal_base->rx_coalesce_usecs;
 	lif->tx_coalesce_hw = tx_coal;
 
-	if (coalesce->use_adaptive_rx_coalesce) {
+	if (coal_base->use_adaptive_rx_coalesce) {
 		set_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
 		rx_dim = rx_coal;
 	} else {
@@ -481,7 +487,7 @@ static int ionic_set_coalesce(struct net_device *netdev,
 		rx_dim = 0;
 	}
 
-	if (coalesce->use_adaptive_tx_coalesce) {
+	if (coal_base->use_adaptive_tx_coalesce) {
 		set_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
 		tx_dim = tx_coal;
 	} else {
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
index dd22cb0..1bdb220 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c
@@ -731,8 +731,10 @@ netxen_nic_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
  * firmware coalescing to default.
  */
 static int netxen_set_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ethcoal)
 {
+	struct ethtool_coalesce *coal_base = &ethcoal->base;
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 
 	if (!NX_IS_REVISION_P3(adapter->ahw.revision_id))
@@ -745,14 +747,14 @@ static int netxen_set_intr_coalesce(struct net_device *netdev,
 	* Return Error if unsupported values or
 	* unsupported parameters are set.
 	*/
-	if (ethcoal->rx_coalesce_usecs > 0xffff ||
-		ethcoal->rx_max_coalesced_frames > 0xffff ||
-		ethcoal->tx_coalesce_usecs > 0xffff ||
-		ethcoal->tx_max_coalesced_frames > 0xffff)
+	if (coal_base->rx_coalesce_usecs > 0xffff ||
+	    coal_base->rx_max_coalesced_frames > 0xffff ||
+	    coal_base->tx_coalesce_usecs > 0xffff ||
+	    coal_base->tx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
 
-	if (!ethcoal->rx_coalesce_usecs ||
-		!ethcoal->rx_max_coalesced_frames) {
+	if (!coal_base->rx_coalesce_usecs ||
+	    !coal_base->rx_max_coalesced_frames) {
 		adapter->coal.flags = NETXEN_NIC_INTR_DEFAULT;
 		adapter->coal.normal.data.rx_time_us =
 			NETXEN_DEFAULT_INTR_COALESCE_RX_TIME_US;
@@ -761,13 +763,13 @@ static int netxen_set_intr_coalesce(struct net_device *netdev,
 	} else {
 		adapter->coal.flags = 0;
 		adapter->coal.normal.data.rx_time_us =
-		ethcoal->rx_coalesce_usecs;
+		coal_base->rx_coalesce_usecs;
 		adapter->coal.normal.data.rx_packets =
-		ethcoal->rx_max_coalesced_frames;
+		coal_base->rx_max_coalesced_frames;
 	}
-	adapter->coal.normal.data.tx_time_us = ethcoal->tx_coalesce_usecs;
+	adapter->coal.normal.data.tx_time_us = coal_base->tx_coalesce_usecs;
 	adapter->coal.normal.data.tx_packets =
-	ethcoal->tx_max_coalesced_frames;
+	coal_base->tx_max_coalesced_frames;
 
 	netxen_config_intr_coalesce(adapter);
 
@@ -775,8 +777,10 @@ static int netxen_set_intr_coalesce(struct net_device *netdev,
 }
 
 static int netxen_get_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ethcoal)
 {
+	struct ethtool_coalesce *coal_base = &ethcoal->base;
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 
 	if (!NX_IS_REVISION_P3(adapter->ahw.revision_id))
@@ -785,11 +789,11 @@ static int netxen_get_intr_coalesce(struct net_device *netdev,
 	if (adapter->is_up != NETXEN_ADAPTER_UP_MAGIC)
 		return -EINVAL;
 
-	ethcoal->rx_coalesce_usecs = adapter->coal.normal.data.rx_time_us;
-	ethcoal->tx_coalesce_usecs = adapter->coal.normal.data.tx_time_us;
-	ethcoal->rx_max_coalesced_frames =
+	coal_base->rx_coalesce_usecs = adapter->coal.normal.data.rx_time_us;
+	coal_base->tx_coalesce_usecs = adapter->coal.normal.data.tx_time_us;
+	coal_base->rx_max_coalesced_frames =
 		adapter->coal.normal.data.rx_packets;
-	ethcoal->tx_max_coalesced_frames =
+	coal_base->tx_max_coalesced_frames =
 		adapter->coal.normal.data.tx_packets;
 
 	return 0;
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 2e62a2c..9e00fe66 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -588,7 +588,8 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 			    struct flow_cls_offload *f);
 
 void qede_forced_speed_maps_init(void);
-int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal);
+int qede_set_coalesce(struct net_device *dev, struct netlink_ext_ack *extack,
+		      struct kernel_ethtool_coalesce *coal);
 int qede_set_per_coalesce(struct net_device *dev, u32 queue,
 			  struct ethtool_coalesce *coal);
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 1560ad3..9e1167a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -760,8 +760,10 @@ static int qede_flash_device(struct net_device *dev,
 }
 
 static int qede_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	void *rx_handle = NULL, *tx_handle = NULL;
 	struct qede_dev *edev = netdev_priv(dev);
 	u16 rx_coal, tx_coal, i, rc = 0;
@@ -770,7 +772,7 @@ static int qede_get_coalesce(struct net_device *dev,
 	rx_coal = QED_DEFAULT_RX_USECS;
 	tx_coal = QED_DEFAULT_TX_USECS;
 
-	memset(coal, 0, sizeof(struct ethtool_coalesce));
+	memset(coal_base, 0, sizeof(struct ethtool_coalesce));
 
 	__qede_lock(edev);
 	if (edev->state == QEDE_STATE_OPEN) {
@@ -813,14 +815,16 @@ static int qede_get_coalesce(struct net_device *dev,
 out:
 	__qede_unlock(edev);
 
-	coal->rx_coalesce_usecs = rx_coal;
-	coal->tx_coalesce_usecs = tx_coal;
+	coal_base->rx_coalesce_usecs = rx_coal;
+	coal_base->tx_coalesce_usecs = tx_coal;
 
 	return rc;
 }
 
-int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+int qede_set_coalesce(struct net_device *dev, struct netlink_ext_ack *extack,
+		      struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_fastpath *fp;
 	int i, rc = 0;
@@ -831,17 +835,17 @@ int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
 		return -EINVAL;
 	}
 
-	if (coal->rx_coalesce_usecs > QED_COALESCE_MAX ||
-	    coal->tx_coalesce_usecs > QED_COALESCE_MAX) {
+	if (coal_base->rx_coalesce_usecs > QED_COALESCE_MAX ||
+	    coal_base->tx_coalesce_usecs > QED_COALESCE_MAX) {
 		DP_INFO(edev,
 			"Can't support requested %s coalesce value [max supported value %d]\n",
-			coal->rx_coalesce_usecs > QED_COALESCE_MAX ? "rx" :
+			coal_base->rx_coalesce_usecs > QED_COALESCE_MAX ? "rx" :
 			"tx", QED_COALESCE_MAX);
 		return -EINVAL;
 	}
 
-	rxc = (u16)coal->rx_coalesce_usecs;
-	txc = (u16)coal->tx_coalesce_usecs;
+	rxc = (u16)coal_base->rx_coalesce_usecs;
+	txc = (u16)coal_base->tx_coalesce_usecs;
 	for_each_queue(i) {
 		fp = &edev->fp_array[i];
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index d8a3eca..4f33151 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1526,8 +1526,10 @@ qlcnic_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
  * firmware coalescing to default.
  */
 static int qlcnic_set_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ethcoal)
 {
+	struct ethtool_coalesce *coal_base = &ethcoal->base;
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	int err;
 
@@ -1538,29 +1540,31 @@ static int qlcnic_set_intr_coalesce(struct net_device *netdev,
 	* Return Error if unsupported values or
 	* unsupported parameters are set.
 	*/
-	if (ethcoal->rx_coalesce_usecs > 0xffff ||
-	    ethcoal->rx_max_coalesced_frames > 0xffff ||
-	    ethcoal->tx_coalesce_usecs > 0xffff ||
-	    ethcoal->tx_max_coalesced_frames > 0xffff)
+	if (coal_base->rx_coalesce_usecs > 0xffff ||
+	    coal_base->rx_max_coalesced_frames > 0xffff ||
+	    coal_base->tx_coalesce_usecs > 0xffff ||
+	    coal_base->tx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
 
-	err = qlcnic_config_intr_coalesce(adapter, ethcoal);
+	err = qlcnic_config_intr_coalesce(adapter, coal_base);
 
 	return err;
 }
 
 static int qlcnic_get_intr_coalesce(struct net_device *netdev,
-			struct ethtool_coalesce *ethcoal)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *ethcoal)
 {
+	struct ethtool_coalesce *coal_base = &ethcoal->base;
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->is_up != QLCNIC_ADAPTER_UP_MAGIC)
 		return -EINVAL;
 
-	ethcoal->rx_coalesce_usecs = adapter->ahw->coal.rx_time_us;
-	ethcoal->rx_max_coalesced_frames = adapter->ahw->coal.rx_packets;
-	ethcoal->tx_coalesce_usecs = adapter->ahw->coal.tx_time_us;
-	ethcoal->tx_max_coalesced_frames = adapter->ahw->coal.tx_packets;
+	coal_base->rx_coalesce_usecs = adapter->ahw->coal.rx_time_us;
+	coal_base->rx_max_coalesced_frames = adapter->ahw->coal.rx_packets;
+	coal_base->tx_coalesce_usecs = adapter->ahw->coal.tx_time_us;
+	coal_base->tx_max_coalesced_frames = adapter->ahw->coal.tx_packets;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1663e04..4bacf59 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1749,8 +1749,11 @@ rtl_coalesce_info(struct rtl8169_private *tp)
 	return ERR_PTR(-ELNRNG);
 }
 
-static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int rtl_get_coalesce(struct net_device *dev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct rtl8169_private *tp = netdev_priv(dev);
 	const struct rtl_coalesce_info *ci;
 	u32 scale, c_us, c_fr;
@@ -1759,7 +1762,7 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	if (rtl_is_8125(tp))
 		return -EOPNOTSUPP;
 
-	memset(ec, 0, sizeof(*ec));
+	memset(coal_base, 0, sizeof(*coal_base));
 
 	/* get rx/tx scale corresponding to current speed and CPlusCmd[0:1] */
 	ci = rtl_coalesce_info(tp);
@@ -1771,17 +1774,17 @@ static int rtl_get_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	intrmit = RTL_R16(tp, IntrMitigate);
 
 	c_us = FIELD_GET(RTL_COALESCE_TX_USECS, intrmit);
-	ec->tx_coalesce_usecs = DIV_ROUND_UP(c_us * scale, 1000);
+	coal_base->tx_coalesce_usecs = DIV_ROUND_UP(c_us * scale, 1000);
 
 	c_fr = FIELD_GET(RTL_COALESCE_TX_FRAMES, intrmit);
 	/* ethtool_coalesce states usecs and max_frames must not both be 0 */
-	ec->tx_max_coalesced_frames = (c_us || c_fr) ? c_fr * 4 : 1;
+	coal_base->tx_max_coalesced_frames = (c_us || c_fr) ? c_fr * 4 : 1;
 
 	c_us = FIELD_GET(RTL_COALESCE_RX_USECS, intrmit);
-	ec->rx_coalesce_usecs = DIV_ROUND_UP(c_us * scale, 1000);
+	coal_base->rx_coalesce_usecs = DIV_ROUND_UP(c_us * scale, 1000);
 
 	c_fr = FIELD_GET(RTL_COALESCE_RX_FRAMES, intrmit);
-	ec->rx_max_coalesced_frames = (c_us || c_fr) ? c_fr * 4 : 1;
+	coal_base->rx_max_coalesced_frames = (c_us || c_fr) ? c_fr * 4 : 1;
 
 	return 0;
 }
@@ -1807,11 +1810,14 @@ static int rtl_coalesce_choose_scale(struct rtl8169_private *tp, u32 usec,
 	return -ERANGE;
 }
 
-static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
+static int rtl_set_coalesce(struct net_device *dev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct rtl8169_private *tp = netdev_priv(dev);
-	u32 tx_fr = ec->tx_max_coalesced_frames;
-	u32 rx_fr = ec->rx_max_coalesced_frames;
+	u32 tx_fr = coal_base->tx_max_coalesced_frames;
+	u32 rx_fr = coal_base->rx_max_coalesced_frames;
 	u32 coal_usec_max, units;
 	u16 w = 0, cp01 = 0;
 	int scale;
@@ -1822,7 +1828,8 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	if (rx_fr > RTL_COALESCE_FRAME_MAX || tx_fr > RTL_COALESCE_FRAME_MAX)
 		return -ERANGE;
 
-	coal_usec_max = max(ec->rx_coalesce_usecs, ec->tx_coalesce_usecs);
+	coal_usec_max = max(coal_base->rx_coalesce_usecs,
+			    coal_base->tx_coalesce_usecs);
 	scale = rtl_coalesce_choose_scale(tp, coal_usec_max, &cp01);
 	if (scale < 0)
 		return scale;
@@ -1843,16 +1850,16 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 		tx_fr = 0;
 
 	/* HW requires time limit to be set if frame limit is set */
-	if ((tx_fr && !ec->tx_coalesce_usecs) ||
-	    (rx_fr && !ec->rx_coalesce_usecs))
+	if ((tx_fr && !coal_base->tx_coalesce_usecs) ||
+	    (rx_fr && !coal_base->rx_coalesce_usecs))
 		return -EINVAL;
 
 	w |= FIELD_PREP(RTL_COALESCE_TX_FRAMES, DIV_ROUND_UP(tx_fr, 4));
 	w |= FIELD_PREP(RTL_COALESCE_RX_FRAMES, DIV_ROUND_UP(rx_fr, 4));
 
-	units = DIV_ROUND_UP(ec->tx_coalesce_usecs * 1000U, scale);
+	units = DIV_ROUND_UP(coal_base->tx_coalesce_usecs * 1000U, scale);
 	w |= FIELD_PREP(RTL_COALESCE_TX_USECS, units);
-	units = DIV_ROUND_UP(ec->rx_coalesce_usecs * 1000U, scale);
+	units = DIV_ROUND_UP(coal_base->rx_coalesce_usecs * 1000U, scale);
 	w |= FIELD_PREP(RTL_COALESCE_RX_USECS, units);
 
 	RTL_W16(tp, IntrMitigate, w);
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
index 7f8b10c..eaf4af8 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c
@@ -274,26 +274,30 @@ static u32 sxgbe_usec2riwt(u32 usec, struct sxgbe_priv_data *priv)
 }
 
 static int sxgbe_get_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 
 	if (priv->use_riwt)
-		ec->rx_coalesce_usecs = sxgbe_riwt2usec(priv->rx_riwt, priv);
+		coal_base->rx_coalesce_usecs = sxgbe_riwt2usec(priv->rx_riwt, priv);
 
 	return 0;
 }
 
 static int sxgbe_set_coalesce(struct net_device *dev,
-			      struct ethtool_coalesce *ec)
+			      struct netlink_ext_ack *extack,
+			      struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 	unsigned int rx_riwt;
 
-	if (!ec->rx_coalesce_usecs)
+	if (!coal_base->rx_coalesce_usecs)
 		return -EINVAL;
 
-	rx_riwt = sxgbe_usec2riwt(ec->rx_coalesce_usecs, priv);
+	rx_riwt = sxgbe_usec2riwt(coal_base->rx_coalesce_usecs, priv);
 
 	if ((rx_riwt > SXGBE_MAX_DMA_RIWT) || (rx_riwt < SXGBE_MIN_DMA_RIWT))
 		return -EINVAL;
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 058d9fe..2186aaf 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -97,26 +97,30 @@ static void efx_ethtool_get_regs(struct net_device *net_dev,
  */
 
 static int efx_ethtool_get_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct efx_nic *efx = netdev_priv(net_dev);
 	unsigned int tx_usecs, rx_usecs;
 	bool rx_adaptive;
 
 	efx_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &rx_adaptive);
 
-	coalesce->tx_coalesce_usecs = tx_usecs;
-	coalesce->tx_coalesce_usecs_irq = tx_usecs;
-	coalesce->rx_coalesce_usecs = rx_usecs;
-	coalesce->rx_coalesce_usecs_irq = rx_usecs;
-	coalesce->use_adaptive_rx_coalesce = rx_adaptive;
+	coal_base->tx_coalesce_usecs = tx_usecs;
+	coal_base->tx_coalesce_usecs_irq = tx_usecs;
+	coal_base->rx_coalesce_usecs = rx_usecs;
+	coal_base->rx_coalesce_usecs_irq = rx_usecs;
+	coal_base->use_adaptive_rx_coalesce = rx_adaptive;
 
 	return 0;
 }
 
 static int efx_ethtool_set_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct efx_channel *channel;
 	unsigned int tx_usecs, rx_usecs;
@@ -125,22 +129,22 @@ static int efx_ethtool_set_coalesce(struct net_device *net_dev,
 
 	efx_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &adaptive);
 
-	if (coalesce->rx_coalesce_usecs != rx_usecs)
-		rx_usecs = coalesce->rx_coalesce_usecs;
+	if (coal_base->rx_coalesce_usecs != rx_usecs)
+		rx_usecs = coal_base->rx_coalesce_usecs;
 	else
-		rx_usecs = coalesce->rx_coalesce_usecs_irq;
+		rx_usecs = coal_base->rx_coalesce_usecs_irq;
 
-	adaptive = coalesce->use_adaptive_rx_coalesce;
+	adaptive = coal_base->use_adaptive_rx_coalesce;
 
 	/* If channels are shared, TX IRQ moderation can be quietly
 	 * overridden unless it is changed from its old value.
 	 */
-	rx_may_override_tx = (coalesce->tx_coalesce_usecs == tx_usecs &&
-			      coalesce->tx_coalesce_usecs_irq == tx_usecs);
-	if (coalesce->tx_coalesce_usecs != tx_usecs)
-		tx_usecs = coalesce->tx_coalesce_usecs;
+	rx_may_override_tx = (coal_base->tx_coalesce_usecs == tx_usecs &&
+			      coal_base->tx_coalesce_usecs_irq == tx_usecs);
+	if (coal_base->tx_coalesce_usecs != tx_usecs)
+		tx_usecs = coal_base->tx_coalesce_usecs;
 	else
-		tx_usecs = coalesce->tx_coalesce_usecs_irq;
+		tx_usecs = coal_base->tx_coalesce_usecs_irq;
 
 	rc = efx_init_irq_moderation(efx, tx_usecs, rx_usecs, adaptive,
 				     rx_may_override_tx);
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index a6bae6a..586a94a 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -577,26 +577,30 @@ static int ef4_ethtool_nway_reset(struct net_device *net_dev)
  */
 
 static int ef4_ethtool_get_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct ef4_nic *efx = netdev_priv(net_dev);
 	unsigned int tx_usecs, rx_usecs;
 	bool rx_adaptive;
 
 	ef4_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &rx_adaptive);
 
-	coalesce->tx_coalesce_usecs = tx_usecs;
-	coalesce->tx_coalesce_usecs_irq = tx_usecs;
-	coalesce->rx_coalesce_usecs = rx_usecs;
-	coalesce->rx_coalesce_usecs_irq = rx_usecs;
-	coalesce->use_adaptive_rx_coalesce = rx_adaptive;
+	coal_base->tx_coalesce_usecs = tx_usecs;
+	coal_base->tx_coalesce_usecs_irq = tx_usecs;
+	coal_base->rx_coalesce_usecs = rx_usecs;
+	coal_base->rx_coalesce_usecs_irq = rx_usecs;
+	coal_base->use_adaptive_rx_coalesce = rx_adaptive;
 
 	return 0;
 }
 
 static int ef4_ethtool_set_coalesce(struct net_device *net_dev,
-				    struct ethtool_coalesce *coalesce)
+				    struct netlink_ext_ack *extack,
+				    struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct ef4_nic *efx = netdev_priv(net_dev);
 	struct ef4_channel *channel;
 	unsigned int tx_usecs, rx_usecs;
@@ -605,22 +609,22 @@ static int ef4_ethtool_set_coalesce(struct net_device *net_dev,
 
 	ef4_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &adaptive);
 
-	if (coalesce->rx_coalesce_usecs != rx_usecs)
-		rx_usecs = coalesce->rx_coalesce_usecs;
+	if (coal_base->rx_coalesce_usecs != rx_usecs)
+		rx_usecs = coal_base->rx_coalesce_usecs;
 	else
-		rx_usecs = coalesce->rx_coalesce_usecs_irq;
+		rx_usecs = coal_base->rx_coalesce_usecs_irq;
 
-	adaptive = coalesce->use_adaptive_rx_coalesce;
+	adaptive = coal_base->use_adaptive_rx_coalesce;
 
 	/* If channels are shared, TX IRQ moderation can be quietly
 	 * overridden unless it is changed from its old value.
 	 */
-	rx_may_override_tx = (coalesce->tx_coalesce_usecs == tx_usecs &&
-			      coalesce->tx_coalesce_usecs_irq == tx_usecs);
-	if (coalesce->tx_coalesce_usecs != tx_usecs)
-		tx_usecs = coalesce->tx_coalesce_usecs;
+	rx_may_override_tx = (coal_base->tx_coalesce_usecs == tx_usecs &&
+			      coal_base->tx_coalesce_usecs_irq == tx_usecs);
+	if (coal_base->tx_coalesce_usecs != tx_usecs)
+		tx_usecs = coal_base->tx_coalesce_usecs;
 	else
-		tx_usecs = coalesce->tx_coalesce_usecs_irq;
+		tx_usecs = coal_base->tx_coalesce_usecs_irq;
 
 	rc = ef4_init_irq_moderation(efx, tx_usecs, rx_usecs, adaptive,
 				     rx_may_override_tx);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index dfc85cc..c6a8ed9 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -290,7 +290,7 @@ struct netsec_desc_ring {
 
 struct netsec_priv {
 	struct netsec_desc_ring desc_ring[NETSEC_RING_MAX];
-	struct ethtool_coalesce et_coalesce;
+	struct kernel_ethtool_coalesce et_coalesce;
 	struct bpf_prog *xdp_prog;
 	spinlock_t reglock; /* protect reg access */
 	struct napi_struct napi;
@@ -532,43 +532,48 @@ static void netsec_et_get_drvinfo(struct net_device *net_device,
 }
 
 static int netsec_et_get_coalesce(struct net_device *net_device,
-				  struct ethtool_coalesce *et_coalesce)
+				  struct netlink_ext_ack *extack,
+				  struct kernel_ethtool_coalesce *et_coalesce)
 {
+	struct ethtool_coalesce *coal_base = &et_coalesce->base;
 	struct netsec_priv *priv = netdev_priv(net_device);
 
-	*et_coalesce = priv->et_coalesce;
+	*coal_base = priv->et_coalesce.base;
 
 	return 0;
 }
 
 static int netsec_et_set_coalesce(struct net_device *net_device,
-				  struct ethtool_coalesce *et_coalesce)
+				  struct netlink_ext_ack *extack,
+				  struct kernel_ethtool_coalesce *et_coalesce)
 {
+	struct ethtool_coalesce *cbase = &et_coalesce->base;
 	struct netsec_priv *priv = netdev_priv(net_device);
+	struct ethtool_coalesce *et_cbase = &priv->et_coalesce.base;
 
-	priv->et_coalesce = *et_coalesce;
+	*et_cbase = *cbase;
 
-	if (priv->et_coalesce.tx_coalesce_usecs < 50)
-		priv->et_coalesce.tx_coalesce_usecs = 50;
-	if (priv->et_coalesce.tx_max_coalesced_frames < 1)
-		priv->et_coalesce.tx_max_coalesced_frames = 1;
+	if (et_cbase->tx_coalesce_usecs < 50)
+		et_cbase->tx_coalesce_usecs = 50;
+	if (et_cbase->tx_max_coalesced_frames < 1)
+		et_cbase->tx_max_coalesced_frames = 1;
 
 	netsec_write(priv, NETSEC_REG_NRM_TX_DONE_TXINT_PKTCNT,
-		     priv->et_coalesce.tx_max_coalesced_frames);
+		     et_cbase->tx_max_coalesced_frames);
 	netsec_write(priv, NETSEC_REG_NRM_TX_TXINT_TMR,
-		     priv->et_coalesce.tx_coalesce_usecs);
+		     et_cbase->tx_coalesce_usecs);
 	netsec_write(priv, NETSEC_REG_NRM_TX_INTEN_SET, NRM_TX_ST_TXDONE);
 	netsec_write(priv, NETSEC_REG_NRM_TX_INTEN_SET, NRM_TX_ST_TMREXP);
 
-	if (priv->et_coalesce.rx_coalesce_usecs < 50)
-		priv->et_coalesce.rx_coalesce_usecs = 50;
-	if (priv->et_coalesce.rx_max_coalesced_frames < 1)
-		priv->et_coalesce.rx_max_coalesced_frames = 1;
+	if (et_cbase->rx_coalesce_usecs < 50)
+		et_cbase->rx_coalesce_usecs = 50;
+	if (et_cbase->rx_max_coalesced_frames < 1)
+		et_cbase->rx_max_coalesced_frames = 1;
 
 	netsec_write(priv, NETSEC_REG_NRM_RX_RXINT_PKTCNT,
-		     priv->et_coalesce.rx_max_coalesced_frames);
+		     et_cbase->rx_max_coalesced_frames);
 	netsec_write(priv, NETSEC_REG_NRM_RX_RXINT_TMR,
-		     priv->et_coalesce.rx_coalesce_usecs);
+		     et_cbase->rx_coalesce_usecs);
 	netsec_write(priv, NETSEC_REG_NRM_RX_INTEN_SET, NRM_RX_ST_PKTCNT);
 	netsec_write(priv, NETSEC_REG_NRM_RX_INTEN_SET, NRM_RX_ST_TMREXP);
 
@@ -1547,7 +1552,7 @@ static int netsec_start_gmac(struct netsec_priv *priv)
 	netsec_write(priv, NETSEC_REG_NRM_RX_INTEN_CLR, ~0);
 	netsec_write(priv, NETSEC_REG_NRM_TX_INTEN_CLR, ~0);
 
-	netsec_et_set_coalesce(priv->ndev, &priv->et_coalesce);
+	netsec_et_set_coalesce(priv->ndev, NULL, &priv->et_coalesce);
 
 	if (netsec_mac_write(priv, GMAC_REG_OMR, value))
 		return -ETIMEDOUT;
@@ -2074,10 +2079,10 @@ static int netsec_probe(struct platform_device *pdev)
 	}
 
 	/* default for throughput */
-	priv->et_coalesce.rx_coalesce_usecs = 500;
-	priv->et_coalesce.rx_max_coalesced_frames = 8;
-	priv->et_coalesce.tx_coalesce_usecs = 500;
-	priv->et_coalesce.tx_max_coalesced_frames = 8;
+	priv->et_coalesce.base.rx_coalesce_usecs = 500;
+	priv->et_coalesce.base.rx_max_coalesced_frames = 8;
+	priv->et_coalesce.base.tx_coalesce_usecs = 500;
+	priv->et_coalesce.base.tx_max_coalesced_frames = 8;
 
 	ret = device_property_read_u32(&pdev->dev, "max-frame-size",
 				       &ndev->max_mtu);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1f6d749..6b675a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -807,9 +807,12 @@ static int __stmmac_get_coalesce(struct net_device *dev,
 }
 
 static int stmmac_get_coalesce(struct net_device *dev,
-			       struct ethtool_coalesce *ec)
+			       struct netlink_ext_ack *extack,
+			       struct kernel_ethtool_coalesce *ec)
 {
-	return __stmmac_get_coalesce(dev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __stmmac_get_coalesce(dev, coal_base, -1);
 }
 
 static int stmmac_get_per_queue_coalesce(struct net_device *dev, u32 queue,
@@ -891,9 +894,12 @@ static int __stmmac_set_coalesce(struct net_device *dev,
 }
 
 static int stmmac_set_coalesce(struct net_device *dev,
-			       struct ethtool_coalesce *ec)
+			       struct netlink_ext_ack *extack,
+			       struct kernel_ethtool_coalesce *ec)
 {
-	return __stmmac_set_coalesce(dev, ec, -1);
+	struct ethtool_coalesce *coal_base = &ec->base;
+
+	return __stmmac_set_coalesce(dev, coal_base, -1);
 }
 
 static int stmmac_set_per_queue_coalesce(struct net_device *dev, u32 queue,
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
index bc198ead..4c4a6e1 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c
@@ -147,29 +147,33 @@ static void xlgmac_ethtool_get_channels(struct net_device *netdev,
 }
 
 static int xlgmac_ethtool_get_coalesce(struct net_device *netdev,
-				       struct ethtool_coalesce *ec)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 
-	ec->rx_coalesce_usecs = pdata->rx_usecs;
-	ec->rx_max_coalesced_frames = pdata->rx_frames;
-	ec->tx_max_coalesced_frames = pdata->tx_frames;
+	coal_base->rx_coalesce_usecs = pdata->rx_usecs;
+	coal_base->rx_max_coalesced_frames = pdata->rx_frames;
+	coal_base->tx_max_coalesced_frames = pdata->tx_frames;
 
 	return 0;
 }
 
 static int xlgmac_ethtool_set_coalesce(struct net_device *netdev,
-				       struct ethtool_coalesce *ec)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 	struct xlgmac_hw_ops *hw_ops = &pdata->hw_ops;
 	unsigned int rx_frames, rx_riwt, rx_usecs;
 	unsigned int tx_frames;
 
-	rx_usecs = ec->rx_coalesce_usecs;
+	rx_usecs = coal_base->rx_coalesce_usecs;
 	rx_riwt = hw_ops->usec_to_riwt(pdata, rx_usecs);
-	rx_frames = ec->rx_max_coalesced_frames;
-	tx_frames = ec->tx_max_coalesced_frames;
+	rx_frames = coal_base->rx_max_coalesced_frames;
+	tx_frames = coal_base->tx_max_coalesced_frames;
 
 	if ((rx_riwt > XLGMAC_MAX_DMA_RIWT) ||
 	    (rx_riwt < XLGMAC_MIN_DMA_RIWT) ||
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index d054c6e..e485295 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2159,9 +2159,11 @@ bdx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
  * @netdev
  * @ecoal
  */
-static int
-bdx_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
+static int bdx_get_coalesce(struct net_device *netdev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ecoal)
 {
+	struct ethtool_coalesce *coal_base = &ecoal->base;
 	u32 rdintcm;
 	u32 tdintcm;
 	struct bdx_priv *priv = netdev_priv(netdev);
@@ -2171,12 +2173,12 @@ bdx_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
 
 	/* PCK_TH measures in multiples of FIFO bytes
 	   We translate to packets */
-	ecoal->rx_coalesce_usecs = GET_INT_COAL(rdintcm) * INT_COAL_MULT;
-	ecoal->rx_max_coalesced_frames =
+	coal_base->rx_coalesce_usecs = GET_INT_COAL(rdintcm) * INT_COAL_MULT;
+	coal_base->rx_max_coalesced_frames =
 	    ((GET_PCK_TH(rdintcm) * PCK_TH_MULT) / sizeof(struct rxf_desc));
 
-	ecoal->tx_coalesce_usecs = GET_INT_COAL(tdintcm) * INT_COAL_MULT;
-	ecoal->tx_max_coalesced_frames =
+	coal_base->tx_coalesce_usecs = GET_INT_COAL(tdintcm) * INT_COAL_MULT;
+	coal_base->tx_max_coalesced_frames =
 	    ((GET_PCK_TH(tdintcm) * PCK_TH_MULT) / BDX_TXF_DESC_SZ);
 
 	/* adaptive parameters ignored */
@@ -2188,9 +2190,11 @@ bdx_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
  * @netdev
  * @ecoal
  */
-static int
-bdx_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
+static int bdx_set_coalesce(struct net_device *netdev,
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ecoal)
 {
+	struct ethtool_coalesce *coal_base = &ecoal->base;
 	u32 rdintcm;
 	u32 tdintcm;
 	struct bdx_priv *priv = netdev_priv(netdev);
@@ -2200,10 +2204,10 @@ bdx_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ecoal)
 	int tx_max_coal;
 
 	/* Check for valid input */
-	rx_coal = ecoal->rx_coalesce_usecs / INT_COAL_MULT;
-	tx_coal = ecoal->tx_coalesce_usecs / INT_COAL_MULT;
-	rx_max_coal = ecoal->rx_max_coalesced_frames;
-	tx_max_coal = ecoal->tx_max_coalesced_frames;
+	rx_coal = coal_base->rx_coalesce_usecs / INT_COAL_MULT;
+	tx_coal = coal_base->tx_coalesce_usecs / INT_COAL_MULT;
+	rx_max_coal = coal_base->rx_max_coalesced_frames;
+	tx_max_coal = coal_base->tx_max_coalesced_frames;
 
 	/* Translate from packets to multiples of FIFO bytes */
 	rx_max_coal =
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c0cd7de..0529122 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -842,10 +842,10 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 	/* Enable Interrupt pacing if configured */
 	if (cpsw->coal_intvl != 0) {
-		struct ethtool_coalesce coal;
+		struct kernel_ethtool_coalesce coal;
 
-		coal.rx_coalesce_usecs = cpsw->coal_intvl;
-		cpsw_set_coalesce(ndev, &coal);
+		coal.base.rx_coalesce_usecs = cpsw->coal_intvl;
+		cpsw_set_coalesce(ndev, NULL, &coal);
 	}
 
 	cpdma_ctlr_start(cpsw->dma);
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 4619c3a..48a15d3 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -152,15 +152,17 @@ void cpsw_set_msglevel(struct net_device *ndev, u32 value)
 	priv->msg_enable = value;
 }
 
-int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal)
+int cpsw_get_coalesce(struct net_device *ndev, struct netlink_ext_ack *extack,
+		      struct kernel_ethtool_coalesce *coal)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 
-	coal->rx_coalesce_usecs = cpsw->coal_intvl;
+	coal->base.rx_coalesce_usecs = cpsw->coal_intvl;
 	return 0;
 }
 
-int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal)
+int cpsw_set_coalesce(struct net_device *ndev, struct netlink_ext_ack *extack,
+		      struct kernel_ethtool_coalesce *coal)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	u32 int_ctrl;
@@ -170,12 +172,12 @@ int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal)
 	u32 coal_intvl = 0;
 	struct cpsw_common *cpsw = priv->cpsw;
 
-	coal_intvl = coal->rx_coalesce_usecs;
+	coal_intvl = coal->base.rx_coalesce_usecs;
 
 	int_ctrl =  readl(&cpsw->wr_regs->int_control);
 	prescale = cpsw->bus_freq_mhz * 4;
 
-	if (!coal->rx_coalesce_usecs) {
+	if (!coal->base.rx_coalesce_usecs) {
 		int_ctrl &= ~(CPSW_INTPRESCALE_MASK | CPSW_INTPACEEN);
 		goto update_return;
 	}
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 69b7a4e..7182e1d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -890,10 +890,10 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 	/* Enable Interrupt pacing if configured */
 	if (cpsw->coal_intvl != 0) {
-		struct ethtool_coalesce coal;
+		struct kernel_ethtool_coalesce coal;
 
-		coal.rx_coalesce_usecs = cpsw->coal_intvl;
-		cpsw_set_coalesce(ndev, &coal);
+		coal.base.rx_coalesce_usecs = cpsw->coal_intvl;
+		cpsw_set_coalesce(ndev, NULL, &coal);
 	}
 
 	cpdma_ctlr_start(cpsw->dma);
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index a323bea..c1f6af3 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -462,8 +462,10 @@ void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
 void cpsw_set_msglevel(struct net_device *ndev, u32 value);
-int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal);
-int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal);
+int cpsw_get_coalesce(struct net_device *ndev, struct netlink_ext_ack *extack,
+		      struct kernel_ethtool_coalesce *coal);
+int cpsw_set_coalesce(struct net_device *ndev, struct netlink_ext_ack *extack,
+		      struct kernel_ethtool_coalesce *coal);
 int cpsw_get_sset_count(struct net_device *ndev, int sset);
 void cpsw_get_strings(struct net_device *ndev, u32 stringset, u8 *data);
 void cpsw_get_ethtool_stats(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index f9417b4..02ec4a6 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -388,11 +388,13 @@ static void emac_get_drvinfo(struct net_device *ndev,
  *
  */
 static int emac_get_coalesce(struct net_device *ndev,
-				struct ethtool_coalesce *coal)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct emac_priv *priv = netdev_priv(ndev);
 
-	coal->rx_coalesce_usecs = priv->coal_intvl;
+	coal_base->rx_coalesce_usecs = priv->coal_intvl;
 	return 0;
 
 }
@@ -406,16 +408,18 @@ static int emac_get_coalesce(struct net_device *ndev,
  *
  */
 static int emac_set_coalesce(struct net_device *ndev,
-				struct ethtool_coalesce *coal)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct emac_priv *priv = netdev_priv(ndev);
 	u32 int_ctrl, num_interrupts = 0;
 	u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;
 
-	if (!coal->rx_coalesce_usecs)
+	if (!coal_base->rx_coalesce_usecs)
 		return -EINVAL;
 
-	coal_intvl = coal->rx_coalesce_usecs;
+	coal_intvl = coal_base->rx_coalesce_usecs;
 
 	switch (priv->version) {
 	case EMAC_VERSION_2:
@@ -1459,10 +1463,10 @@ static int emac_dev_open(struct net_device *ndev)
 
 	/* Enable Interrupt pacing if configured */
 	if (priv->coal_intvl != 0) {
-		struct ethtool_coalesce coal;
+		struct kernel_ethtool_coalesce coal;
 
-		coal.rx_coalesce_usecs = (priv->coal_intvl << 4);
-		emac_set_coalesce(ndev, &coal);
+		coal.base.rx_coalesce_usecs = (priv->coal_intvl << 4);
+		emac_set_coalesce(ndev, NULL, &coal);
 	}
 
 	cpdma_ctlr_start(priv->dma);
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 88426b5..d70c9eb 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -3520,44 +3520,48 @@ static void set_pending_timer_val(int *val, u32 us)
 
 
 static int velocity_get_coalesce(struct net_device *dev,
-		struct ethtool_coalesce *ecmd)
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct velocity_info *vptr = netdev_priv(dev);
 
-	ecmd->tx_max_coalesced_frames = vptr->options.tx_intsup;
-	ecmd->rx_max_coalesced_frames = vptr->options.rx_intsup;
+	coal_base->tx_max_coalesced_frames = vptr->options.tx_intsup;
+	coal_base->rx_max_coalesced_frames = vptr->options.rx_intsup;
 
-	ecmd->rx_coalesce_usecs = get_pending_timer_val(vptr->options.rxqueue_timer);
-	ecmd->tx_coalesce_usecs = get_pending_timer_val(vptr->options.txqueue_timer);
+	coal_base->rx_coalesce_usecs = get_pending_timer_val(vptr->options.rxqueue_timer);
+	coal_base->tx_coalesce_usecs = get_pending_timer_val(vptr->options.txqueue_timer);
 
 	return 0;
 }
 
 static int velocity_set_coalesce(struct net_device *dev,
-		struct ethtool_coalesce *ecmd)
+				 struct netlink_ext_ack *extack,
+				 struct kernel_ethtool_coalesce *ecmd)
 {
+	struct ethtool_coalesce *coal_base = &ecmd->base;
 	struct velocity_info *vptr = netdev_priv(dev);
 	int max_us = 0x3f * 64;
 	unsigned long flags;
 
 	/* 6 bits of  */
-	if (ecmd->tx_coalesce_usecs > max_us)
+	if (coal_base->tx_coalesce_usecs > max_us)
 		return -EINVAL;
-	if (ecmd->rx_coalesce_usecs > max_us)
+	if (coal_base->rx_coalesce_usecs > max_us)
 		return -EINVAL;
 
-	if (ecmd->tx_max_coalesced_frames > 0xff)
+	if (coal_base->tx_max_coalesced_frames > 0xff)
 		return -EINVAL;
-	if (ecmd->rx_max_coalesced_frames > 0xff)
+	if (coal_base->rx_max_coalesced_frames > 0xff)
 		return -EINVAL;
 
-	vptr->options.rx_intsup = ecmd->rx_max_coalesced_frames;
-	vptr->options.tx_intsup = ecmd->tx_max_coalesced_frames;
+	vptr->options.rx_intsup = coal_base->rx_max_coalesced_frames;
+	vptr->options.tx_intsup = coal_base->tx_max_coalesced_frames;
 
 	set_pending_timer_val(&vptr->options.rxqueue_timer,
-			ecmd->rx_coalesce_usecs);
+			coal_base->rx_coalesce_usecs);
 	set_pending_timer_val(&vptr->options.txqueue_timer,
-			ecmd->tx_coalesce_usecs);
+			coal_base->tx_coalesce_usecs);
 
 	/* Setup the interrupt suppression and queue timers */
 	spin_lock_irqsave(&vptr->lock, flags);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index a1f5f07..8a39904 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1292,20 +1292,24 @@ static int ll_temac_ethtools_set_ringparam(struct net_device *ndev,
 }
 
 static int ll_temac_ethtools_get_coalesce(struct net_device *ndev,
-					  struct ethtool_coalesce *ec)
+					  struct netlink_ext_ack *extack,
+					  struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct temac_local *lp = netdev_priv(ndev);
 
-	ec->rx_max_coalesced_frames = lp->coalesce_count_rx;
-	ec->tx_max_coalesced_frames = lp->coalesce_count_tx;
-	ec->rx_coalesce_usecs = (lp->coalesce_delay_rx * 512) / 100;
-	ec->tx_coalesce_usecs = (lp->coalesce_delay_tx * 512) / 100;
+	coal_base->rx_max_coalesced_frames = lp->coalesce_count_rx;
+	coal_base->tx_max_coalesced_frames = lp->coalesce_count_tx;
+	coal_base->rx_coalesce_usecs = (lp->coalesce_delay_rx * 512) / 100;
+	coal_base->tx_coalesce_usecs = (lp->coalesce_delay_tx * 512) / 100;
 	return 0;
 }
 
 static int ll_temac_ethtools_set_coalesce(struct net_device *ndev,
-					  struct ethtool_coalesce *ec)
+					  struct netlink_ext_ack *extack,
+					  struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct temac_local *lp = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
@@ -1314,19 +1318,19 @@ static int ll_temac_ethtools_set_coalesce(struct net_device *ndev,
 		return -EFAULT;
 	}
 
-	if (ec->rx_max_coalesced_frames)
-		lp->coalesce_count_rx = ec->rx_max_coalesced_frames;
-	if (ec->tx_max_coalesced_frames)
-		lp->coalesce_count_tx = ec->tx_max_coalesced_frames;
+	if (coal_base->rx_max_coalesced_frames)
+		lp->coalesce_count_rx = coal_base->rx_max_coalesced_frames;
+	if (coal_base->tx_max_coalesced_frames)
+		lp->coalesce_count_tx = coal_base->tx_max_coalesced_frames;
 	/* With typical LocalLink clock speed of 200 MHz and
 	 * C_PRESCALAR=1023, each delay count corresponds to 5.12 us.
 	 */
-	if (ec->rx_coalesce_usecs)
+	if (coal_base->rx_coalesce_usecs)
 		lp->coalesce_delay_rx =
-			min(255U, (ec->rx_coalesce_usecs * 100) / 512);
-	if (ec->tx_coalesce_usecs)
+			min(255U, (coal_base->rx_coalesce_usecs * 100) / 512);
+	if (coal_base->tx_coalesce_usecs)
 		lp->coalesce_delay_tx =
-			min(255U, (ec->tx_coalesce_usecs * 100) / 512);
+			min(255U, (coal_base->tx_coalesce_usecs * 100) / 512);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b508c94..ec7afaa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1408,15 +1408,17 @@ axienet_ethtools_set_pauseparam(struct net_device *ndev,
  * Return: 0 always
  */
 static int axienet_ethtools_get_coalesce(struct net_device *ndev,
-					 struct ethtool_coalesce *ecoalesce)
+					 struct netlink_ext_ack *extack,
+					 struct kernel_ethtool_coalesce *ecoalesce)
 {
+	struct ethtool_coalesce *coal_base = &ecoalesce->base;
 	u32 regval = 0;
 	struct axienet_local *lp = netdev_priv(ndev);
 	regval = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	ecoalesce->rx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
+	coal_base->rx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
 					     >> XAXIDMA_COALESCE_SHIFT;
 	regval = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	ecoalesce->tx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
+	coal_base->tx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
 					     >> XAXIDMA_COALESCE_SHIFT;
 	return 0;
 }
@@ -1433,8 +1435,10 @@ static int axienet_ethtools_get_coalesce(struct net_device *ndev,
  * Return: 0, on success, Non-zero error value on failure.
  */
 static int axienet_ethtools_set_coalesce(struct net_device *ndev,
-					 struct ethtool_coalesce *ecoalesce)
+					 struct netlink_ext_ack *extack,
+					 struct kernel_ethtool_coalesce *ecoalesce)
 {
+	struct ethtool_coalesce *coal_base = &ecoalesce->base;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
@@ -1443,10 +1447,10 @@ static int axienet_ethtools_set_coalesce(struct net_device *ndev,
 		return -EFAULT;
 	}
 
-	if (ecoalesce->rx_max_coalesced_frames)
-		lp->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
-	if (ecoalesce->tx_max_coalesced_frames)
-		lp->coalesce_count_tx = ecoalesce->tx_max_coalesced_frames;
+	if (coal_base->rx_max_coalesced_frames)
+		lp->coalesce_count_rx = coal_base->rx_max_coalesced_frames;
+	if (coal_base->tx_max_coalesced_frames)
+		lp->coalesce_count_tx = coal_base->tx_max_coalesced_frames;
 
 	return 0;
 }
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index c9ae525..f622c64 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -43,20 +43,24 @@ nsim_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
 }
 
 static int nsim_get_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct netdevsim *ns = netdev_priv(dev);
 
-	memcpy(coal, &ns->ethtool.coalesce, sizeof(ns->ethtool.coalesce));
+	memcpy(coal_base, &ns->ethtool.coalesce, sizeof(ns->ethtool.coalesce));
 	return 0;
 }
 
 static int nsim_set_coalesce(struct net_device *dev,
-			     struct ethtool_coalesce *coal)
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
+	struct ethtool_coalesce *coal_base = &coal->base;
 	struct netdevsim *ns = netdev_priv(dev);
 
-	memcpy(&ns->ethtool.coalesce, coal, sizeof(ns->ethtool.coalesce));
+	memcpy(&ns->ethtool.coalesce, coal_base, sizeof(ns->ethtool.coalesce));
 	return 0;
 }
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2ced021..0ce2844 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3510,24 +3510,28 @@ static void tun_set_msglevel(struct net_device *dev, u32 value)
 }
 
 static int tun_get_coalesce(struct net_device *dev,
-			    struct ethtool_coalesce *ec)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct tun_struct *tun = netdev_priv(dev);
 
-	ec->rx_max_coalesced_frames = tun->rx_batched;
+	coal_base->rx_max_coalesced_frames = tun->rx_batched;
 
 	return 0;
 }
 
 static int tun_set_coalesce(struct net_device *dev,
-			    struct ethtool_coalesce *ec)
+			    struct netlink_ext_ack *extack,
+			    struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct tun_struct *tun = netdev_priv(dev);
 
-	if (ec->rx_max_coalesced_frames > NAPI_POLL_WEIGHT)
+	if (coal_base->rx_max_coalesced_frames > NAPI_POLL_WEIGHT)
 		tun->rx_batched = NAPI_POLL_WEIGHT;
 	else
-		tun->rx_batched = ec->rx_max_coalesced_frames;
+		tun->rx_batched = coal_base->rx_max_coalesced_frames;
 
 	return 0;
 }
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 136ea065..3b365f4 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8784,8 +8784,10 @@ static int rtl8152_nway_reset(struct net_device *dev)
 }
 
 static int rtl8152_get_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *coalesce)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct r8152 *tp = netdev_priv(netdev);
 
 	switch (tp->version) {
@@ -8797,14 +8799,16 @@ static int rtl8152_get_coalesce(struct net_device *netdev,
 		break;
 	}
 
-	coalesce->rx_coalesce_usecs = tp->coalesce;
+	coal_base->rx_coalesce_usecs = tp->coalesce;
 
 	return 0;
 }
 
 static int rtl8152_set_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *coalesce)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *coalesce)
 {
+	struct ethtool_coalesce *coal_base = &coalesce->base;
 	struct r8152 *tp = netdev_priv(netdev);
 	int ret;
 
@@ -8817,7 +8821,7 @@ static int rtl8152_set_coalesce(struct net_device *netdev,
 		break;
 	}
 
-	if (coalesce->rx_coalesce_usecs > COALESCE_SLOW)
+	if (coal_base->rx_coalesce_usecs > COALESCE_SLOW)
 		return -EINVAL;
 
 	ret = usb_autopm_get_interface(tp->intf);
@@ -8826,8 +8830,8 @@ static int rtl8152_set_coalesce(struct net_device *netdev,
 
 	mutex_lock(&tp->control);
 
-	if (tp->coalesce != coalesce->rx_coalesce_usecs) {
-		tp->coalesce = coalesce->rx_coalesce_usecs;
+	if (tp->coalesce != coal_base->rx_coalesce_usecs) {
+		tp->coalesce = coal_base->rx_coalesce_usecs;
 
 		if (netif_running(netdev) && netif_carrier_ok(netdev)) {
 			netif_stop_queue(netdev);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 073fec4..7bd3b76 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2288,16 +2288,18 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
 }
 
 static int virtnet_set_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *ec)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, napi_weight;
 
-	if (ec->tx_max_coalesced_frames > 1 ||
-	    ec->rx_max_coalesced_frames != 1)
+	if (coal_base->tx_max_coalesced_frames > 1 ||
+	    coal_base->rx_max_coalesced_frames != 1)
 		return -EINVAL;
 
-	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
+	napi_weight = coal_base->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
 	if (napi_weight ^ vi->sq[0].napi.weight) {
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
@@ -2309,18 +2311,20 @@ static int virtnet_set_coalesce(struct net_device *dev,
 }
 
 static int virtnet_get_coalesce(struct net_device *dev,
-				struct ethtool_coalesce *ec)
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct ethtool_coalesce ec_default = {
 		.cmd = ETHTOOL_GCOALESCE,
 		.rx_max_coalesced_frames = 1,
 	};
 	struct virtnet_info *vi = netdev_priv(dev);
 
-	memcpy(ec, &ec_default, sizeof(ec_default));
+	memcpy(coal_base, &ec_default, sizeof(ec_default));
 
 	if (vi->sq[0].napi.weight)
-		ec->tx_max_coalesced_frames = 1;
+		coal_base->tx_max_coalesced_frames = 1;
 
 	return 0;
 }
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index c0bd9cb..9e18389 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1015,9 +1015,11 @@ vmxnet3_set_rss(struct net_device *netdev, const u32 *p, const u8 *key,
 }
 #endif
 
-static int
-vmxnet3_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int vmxnet3_get_coalesce(struct net_device *netdev,
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
 	if (!VMXNET3_VERSION_GE_3(adapter))
@@ -1028,19 +1030,19 @@ vmxnet3_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 		/* struct ethtool_coalesce is already initialized to 0 */
 		break;
 	case VMXNET3_COALESCE_ADAPT:
-		ec->use_adaptive_rx_coalesce = true;
+		coal_base->use_adaptive_rx_coalesce = true;
 		break;
 	case VMXNET3_COALESCE_STATIC:
-		ec->tx_max_coalesced_frames =
+		coal_base->tx_max_coalesced_frames =
 			adapter->coal_conf->coalPara.coalStatic.tx_comp_depth;
-		ec->rx_max_coalesced_frames =
+		coal_base->rx_max_coalesced_frames =
 			adapter->coal_conf->coalPara.coalStatic.rx_depth;
 		break;
 	case VMXNET3_COALESCE_RBC: {
 		u32 rbc_rate;
 
 		rbc_rate = adapter->coal_conf->coalPara.coalRbc.rbc_rate;
-		ec->rx_coalesce_usecs = VMXNET3_COAL_RBC_USECS(rbc_rate);
+		coal_base->rx_coalesce_usecs = VMXNET3_COAL_RBC_USECS(rbc_rate);
 	}
 		break;
 	default:
@@ -1050,9 +1052,11 @@ vmxnet3_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 	return 0;
 }
 
-static int
-vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
+static int vmxnet3_set_coalesce(struct net_device *netdev,
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *ec)
 {
+	struct ethtool_coalesce *coal_base = &ec->base;
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	struct Vmxnet3_DriverShared *shared = adapter->shared;
 	union Vmxnet3_CmdInfo *cmdInfo = &shared->cu.cmdInfo;
@@ -1061,25 +1065,25 @@ vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 	if (!VMXNET3_VERSION_GE_3(adapter))
 		return -EOPNOTSUPP;
 
-	if ((ec->rx_coalesce_usecs == 0) &&
-	    (ec->use_adaptive_rx_coalesce == 0) &&
-	    (ec->tx_max_coalesced_frames == 0) &&
-	    (ec->rx_max_coalesced_frames == 0)) {
+	if ((coal_base->rx_coalesce_usecs == 0) &&
+	    (coal_base->use_adaptive_rx_coalesce == 0) &&
+	    (coal_base->tx_max_coalesced_frames == 0) &&
+	    (coal_base->rx_max_coalesced_frames == 0)) {
 		memset(adapter->coal_conf, 0, sizeof(*adapter->coal_conf));
 		adapter->coal_conf->coalMode = VMXNET3_COALESCE_DISABLED;
 		goto done;
 	}
 
-	if (ec->rx_coalesce_usecs != 0) {
+	if (coal_base->rx_coalesce_usecs != 0) {
 		u32 rbc_rate;
 
-		if ((ec->use_adaptive_rx_coalesce != 0) ||
-		    (ec->tx_max_coalesced_frames != 0) ||
-		    (ec->rx_max_coalesced_frames != 0)) {
+		if ((coal_base->use_adaptive_rx_coalesce != 0) ||
+		    (coal_base->tx_max_coalesced_frames != 0) ||
+		    (coal_base->rx_max_coalesced_frames != 0)) {
 			return -EINVAL;
 		}
 
-		rbc_rate = VMXNET3_COAL_RBC_RATE(ec->rx_coalesce_usecs);
+		rbc_rate = VMXNET3_COAL_RBC_RATE(coal_base->rx_coalesce_usecs);
 		if (rbc_rate < VMXNET3_COAL_RBC_MIN_RATE ||
 		    rbc_rate > VMXNET3_COAL_RBC_MAX_RATE) {
 			return -EINVAL;
@@ -1091,10 +1095,10 @@ vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 		goto done;
 	}
 
-	if (ec->use_adaptive_rx_coalesce != 0) {
-		if ((ec->rx_coalesce_usecs != 0) ||
-		    (ec->tx_max_coalesced_frames != 0) ||
-		    (ec->rx_max_coalesced_frames != 0)) {
+	if (coal_base->use_adaptive_rx_coalesce != 0) {
+		if ((coal_base->rx_coalesce_usecs != 0) ||
+		    (coal_base->tx_max_coalesced_frames != 0) ||
+		    (coal_base->rx_max_coalesced_frames != 0)) {
 			return -EINVAL;
 		}
 		memset(adapter->coal_conf, 0, sizeof(*adapter->coal_conf));
@@ -1102,16 +1106,16 @@ vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 		goto done;
 	}
 
-	if ((ec->tx_max_coalesced_frames != 0) ||
-	    (ec->rx_max_coalesced_frames != 0)) {
-		if ((ec->rx_coalesce_usecs != 0) ||
-		    (ec->use_adaptive_rx_coalesce != 0)) {
+	if ((coal_base->tx_max_coalesced_frames != 0) ||
+	    (coal_base->rx_max_coalesced_frames != 0)) {
+		if ((coal_base->rx_coalesce_usecs != 0) ||
+		    (coal_base->use_adaptive_rx_coalesce != 0)) {
 			return -EINVAL;
 		}
 
-		if ((ec->tx_max_coalesced_frames >
-		    VMXNET3_COAL_STATIC_MAX_DEPTH) ||
-		    (ec->rx_max_coalesced_frames >
+		if ((coal_base->tx_max_coalesced_frames >
+		     VMXNET3_COAL_STATIC_MAX_DEPTH) ||
+		    (coal_base->rx_max_coalesced_frames >
 		     VMXNET3_COAL_STATIC_MAX_DEPTH)) {
 			return -EINVAL;
 		}
@@ -1120,13 +1124,13 @@ vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 		adapter->coal_conf->coalMode = VMXNET3_COALESCE_STATIC;
 
 		adapter->coal_conf->coalPara.coalStatic.tx_comp_depth =
-			(ec->tx_max_coalesced_frames ?
-			 ec->tx_max_coalesced_frames :
+			(coal_base->tx_max_coalesced_frames ?
+			 coal_base->tx_max_coalesced_frames :
 			 VMXNET3_COAL_STATIC_DEFAULT_DEPTH);
 
 		adapter->coal_conf->coalPara.coalStatic.rx_depth =
-			(ec->rx_max_coalesced_frames ?
-			 ec->rx_max_coalesced_frames :
+			(coal_base->rx_max_coalesced_frames ?
+			 coal_base->rx_max_coalesced_frames :
 			 VMXNET3_COAL_STATIC_DEFAULT_DEPTH);
 
 		adapter->coal_conf->coalPara.coalStatic.tx_depth =
diff --git a/drivers/net/wireless/ath/wil6210/ethtool.c b/drivers/net/wireless/ath/wil6210/ethtool.c
index e481674..6819c32 100644
--- a/drivers/net/wireless/ath/wil6210/ethtool.c
+++ b/drivers/net/wireless/ath/wil6210/ethtool.c
@@ -12,8 +12,10 @@
 #include "wil6210.h"
 
 static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *cp)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *cp)
 {
+	struct ethtool_coalesce *coal_base = &cp->base;
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	u32 tx_itr_en, tx_itr_val = 0;
 	u32 rx_itr_en, rx_itr_val = 0;
@@ -36,8 +38,8 @@ static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 
 	wil_pm_runtime_put(wil);
 
-	cp->tx_coalesce_usecs = tx_itr_val;
-	cp->rx_coalesce_usecs = rx_itr_val;
+	coal_base->tx_coalesce_usecs = tx_itr_val;
+	coal_base->rx_coalesce_usecs = rx_itr_val;
 	ret = 0;
 
 out:
@@ -46,15 +48,18 @@ static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 }
 
 static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *cp)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *cp)
 {
+	struct ethtool_coalesce *coal_base = &cp->base;
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	int ret;
 
 	mutex_lock(&wil->mutex);
 	wil_dbg_misc(wil, "ethtoolops_set_coalesce: rx %d usec, tx %d usec\n",
-		     cp->rx_coalesce_usecs, cp->tx_coalesce_usecs);
+		     coal_base->rx_coalesce_usecs,
+		     coal_base->tx_coalesce_usecs);
 
 	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		wil_dbg_misc(wil, "No IRQ coalescing in monitor mode\n");
@@ -66,12 +71,12 @@ static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
 	 * ignore other parameters
 	 */
 
-	if (cp->rx_coalesce_usecs > WIL6210_ITR_TRSH_MAX ||
-	    cp->tx_coalesce_usecs > WIL6210_ITR_TRSH_MAX)
+	if (coal_base->rx_coalesce_usecs > WIL6210_ITR_TRSH_MAX ||
+	    coal_base->tx_coalesce_usecs > WIL6210_ITR_TRSH_MAX)
 		goto out_bad;
 
-	wil->tx_max_burst_duration = cp->tx_coalesce_usecs;
-	wil->rx_max_burst_duration = cp->rx_coalesce_usecs;
+	wil->tx_max_burst_duration = coal_base->tx_coalesce_usecs;
+	wil->rx_max_burst_duration = coal_base->rx_coalesce_usecs;
 
 	ret = wil_pm_runtime_get(wil);
 	if (ret < 0)
@@ -89,7 +94,7 @@ static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
 out_bad:
 	wil_dbg_misc(wil, "Unsupported coalescing params. Raw command:\n");
 	print_hex_dump_debug("DBG[MISC] coal ", DUMP_PREFIX_OFFSET, 16, 4,
-			     cp, sizeof(*cp), false);
+			     coal_base, sizeof(*coal_base), false);
 	mutex_unlock(&wil->mutex);
 	return -EINVAL;
 }
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index b70570b..1516988 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -621,9 +621,12 @@ static void qlge_get_regs(struct net_device *ndev,
 		regs->len = sizeof(struct qlge_reg_dump);
 }
 
-static int qlge_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
+static int qlge_get_coalesce(struct net_device *ndev,
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
+	struct ethtool_coalesce *c = &coal->base;
 
 	c->rx_coalesce_usecs = qdev->rx_coalesce_usecs;
 	c->tx_coalesce_usecs = qdev->tx_coalesce_usecs;
@@ -644,9 +647,12 @@ static int qlge_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *c
 	return 0;
 }
 
-static int qlge_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
+static int qlge_set_coalesce(struct net_device *ndev,
+			     struct netlink_ext_ack *extack,
+			     struct kernel_ethtool_coalesce *coal)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
+	struct ethtool_coalesce *c = &coal->base;
 
 	/* Validate user parameters. */
 	if (c->rx_coalesce_usecs > qdev->rx_ring_size / 2)
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e030f75..1030540 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -15,6 +15,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/compat.h>
+#include <linux/netlink.h>
 #include <uapi/linux/ethtool.h>
 
 #ifdef CONFIG_COMPAT
@@ -176,6 +177,10 @@ extern int
 __ethtool_get_link_ksettings(struct net_device *dev,
 			     struct ethtool_link_ksettings *link_ksettings);
 
+struct kernel_ethtool_coalesce {
+	struct ethtool_coalesce	base;
+};
+
 /**
  * ethtool_intersect_link_masks - Given two link masks, AND them together
  * @dst: first mask and where result is stored
@@ -606,8 +611,12 @@ struct ethtool_ops {
 			      struct ethtool_eeprom *, u8 *);
 	int	(*set_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
-	int	(*get_coalesce)(struct net_device *, struct ethtool_coalesce *);
-	int	(*set_coalesce)(struct net_device *, struct ethtool_coalesce *);
+	int	(*get_coalesce)(struct net_device *,
+				struct netlink_ext_ack *,
+				struct kernel_ethtool_coalesce *);
+	int	(*set_coalesce)(struct net_device *,
+				struct netlink_ext_ack *,
+				struct kernel_ethtool_coalesce *);
 	void	(*get_ringparam)(struct net_device *,
 				 struct ethtool_ringparam *);
 	int	(*set_ringparam)(struct net_device *,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 1d6bc13..70e6331 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -9,7 +9,7 @@ struct coalesce_req_info {
 
 struct coalesce_reply_data {
 	struct ethnl_reply_data		base;
-	struct ethtool_coalesce		coalesce;
+	struct kernel_ethtool_coalesce	coalesce;
 	u32				supported_params;
 };
 
@@ -61,6 +61,7 @@ static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
 				 struct genl_info *info)
 {
 	struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -70,7 +71,7 @@ static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
-	ret = dev->ethtool_ops->get_coalesce(dev, &data->coalesce);
+	ret = dev->ethtool_ops->get_coalesce(dev, extack, &data->coalesce);
 	ethnl_ops_complete(dev);
 
 	return ret;
@@ -124,53 +125,53 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 			       const struct ethnl_reply_data *reply_base)
 {
 	const struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
-	const struct ethtool_coalesce *coal = &data->coalesce;
+	const struct ethtool_coalesce *cbase = &data->coalesce.base;
 	u32 supported = data->supported_params;
 
 	if (coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS,
-			     coal->rx_coalesce_usecs, supported) ||
+			     cbase->rx_coalesce_usecs, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES,
-			     coal->rx_max_coalesced_frames, supported) ||
+			     cbase->rx_max_coalesced_frames, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_IRQ,
-			     coal->rx_coalesce_usecs_irq, supported) ||
+			     cbase->rx_coalesce_usecs_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ,
-			     coal->rx_max_coalesced_frames_irq, supported) ||
+			     cbase->rx_max_coalesced_frames_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS,
-			     coal->tx_coalesce_usecs, supported) ||
+			     cbase->tx_coalesce_usecs, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES,
-			     coal->tx_max_coalesced_frames, supported) ||
+			     cbase->tx_max_coalesced_frames, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_IRQ,
-			     coal->tx_coalesce_usecs_irq, supported) ||
+			     cbase->tx_coalesce_usecs_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ,
-			     coal->tx_max_coalesced_frames_irq, supported) ||
+			     cbase->tx_max_coalesced_frames_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_STATS_BLOCK_USECS,
-			     coal->stats_block_coalesce_usecs, supported) ||
+			     cbase->stats_block_coalesce_usecs, supported) ||
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX,
-			      coal->use_adaptive_rx_coalesce, supported) ||
+			      cbase->use_adaptive_rx_coalesce, supported) ||
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX,
-			      coal->use_adaptive_tx_coalesce, supported) ||
+			      cbase->use_adaptive_tx_coalesce, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_PKT_RATE_LOW,
-			     coal->pkt_rate_low, supported) ||
+			     cbase->pkt_rate_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_LOW,
-			     coal->rx_coalesce_usecs_low, supported) ||
+			     cbase->rx_coalesce_usecs_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW,
-			     coal->rx_max_coalesced_frames_low, supported) ||
+			     cbase->rx_max_coalesced_frames_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_LOW,
-			     coal->tx_coalesce_usecs_low, supported) ||
+			     cbase->tx_coalesce_usecs_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW,
-			     coal->tx_max_coalesced_frames_low, supported) ||
+			     cbase->tx_max_coalesced_frames_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_PKT_RATE_HIGH,
-			     coal->pkt_rate_high, supported) ||
+			     cbase->pkt_rate_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_HIGH,
-			     coal->rx_coalesce_usecs_high, supported) ||
+			     cbase->rx_coalesce_usecs_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH,
-			     coal->rx_max_coalesced_frames_high, supported) ||
+			     cbase->rx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_HIGH,
-			     coal->tx_coalesce_usecs_high, supported) ||
+			     cbase->tx_coalesce_usecs_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
-			     coal->tx_max_coalesced_frames_high, supported) ||
+			     cbase->tx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
-			     coal->rate_sample_interval, supported))
+			     cbase->rate_sample_interval, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -219,7 +220,8 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 {
-	struct ethtool_coalesce coalesce = {};
+	struct kernel_ethtool_coalesce coalesce = {};
+	struct ethtool_coalesce *cbase = &coalesce.base;
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	const struct ethtool_ops *ops;
@@ -255,59 +257,59 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
-	ret = ops->get_coalesce(dev, &coalesce);
+	ret = ops->get_coalesce(dev, info->extack, &coalesce);
 	if (ret < 0)
 		goto out_ops;
 
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs,
+	ethnl_update_u32(&cbase->rx_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames,
+	ethnl_update_u32(&cbase->rx_max_coalesced_frames,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES], &mod);
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs_irq,
+	ethnl_update_u32(&cbase->rx_coalesce_usecs_irq,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS_IRQ], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_irq,
+	ethnl_update_u32(&cbase->rx_max_coalesced_frames_irq,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs,
+	ethnl_update_u32(&cbase->tx_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames,
+	ethnl_update_u32(&cbase->tx_max_coalesced_frames,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs_irq,
+	ethnl_update_u32(&cbase->tx_coalesce_usecs_irq,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS_IRQ], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_irq,
+	ethnl_update_u32(&cbase->tx_max_coalesced_frames_irq,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ], &mod);
-	ethnl_update_u32(&coalesce.stats_block_coalesce_usecs,
+	ethnl_update_u32(&cbase->stats_block_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS], &mod);
-	ethnl_update_bool32(&coalesce.use_adaptive_rx_coalesce,
+	ethnl_update_bool32(&cbase->use_adaptive_rx_coalesce,
 			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX], &mod);
-	ethnl_update_bool32(&coalesce.use_adaptive_tx_coalesce,
+	ethnl_update_bool32(&cbase->use_adaptive_tx_coalesce,
 			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX], &mod);
-	ethnl_update_u32(&coalesce.pkt_rate_low,
+	ethnl_update_u32(&cbase->pkt_rate_low,
 			 tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW], &mod);
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs_low,
+	ethnl_update_u32(&cbase->rx_coalesce_usecs_low,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS_LOW], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_low,
+	ethnl_update_u32(&cbase->rx_max_coalesced_frames_low,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs_low,
+	ethnl_update_u32(&cbase->tx_coalesce_usecs_low,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS_LOW], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_low,
+	ethnl_update_u32(&cbase->tx_max_coalesced_frames_low,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW], &mod);
-	ethnl_update_u32(&coalesce.pkt_rate_high,
+	ethnl_update_u32(&cbase->pkt_rate_high,
 			 tb[ETHTOOL_A_COALESCE_PKT_RATE_HIGH], &mod);
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs_high,
+	ethnl_update_u32(&cbase->rx_coalesce_usecs_high,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS_HIGH], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_high,
+	ethnl_update_u32(&cbase->rx_max_coalesced_frames_high,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs_high,
+	ethnl_update_u32(&cbase->tx_coalesce_usecs_high,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_high,
+	ethnl_update_u32(&cbase->tx_max_coalesced_frames_high,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
-	ethnl_update_u32(&coalesce.rate_sample_interval,
+	ethnl_update_u32(&cbase->rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
 
-	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->set_coalesce(dev, info->extack, &coalesce);
 	if (ret < 0)
 		goto out_ops;
 	ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3fa7a39..3da8487 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1513,71 +1513,74 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 static noinline_for_stack int ethtool_get_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
-	struct ethtool_coalesce coalesce = { .cmd = ETHTOOL_GCOALESCE };
+	struct kernel_ethtool_coalesce coalesce = {
+		.base = { .cmd = ETHTOOL_GCOALESCE }
+	};
 	int ret;
 
 	if (!dev->ethtool_ops->get_coalesce)
 		return -EOPNOTSUPP;
 
-	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->get_coalesce(dev, NULL, &coalesce);
 	if (ret)
 		return ret;
 
-	if (copy_to_user(useraddr, &coalesce, sizeof(coalesce)))
+	if (copy_to_user(useraddr, &coalesce.base, sizeof(coalesce.base)))
 		return -EFAULT;
 	return 0;
 }
 
 static bool
 ethtool_set_coalesce_supported(struct net_device *dev,
-			       struct ethtool_coalesce *coalesce)
+			       struct kernel_ethtool_coalesce *coalesce)
 {
 	u32 supported_params = dev->ethtool_ops->supported_coalesce_params;
+	struct ethtool_coalesce *cbase = &coalesce->base;
 	u32 nonzero_params = 0;
 
-	if (coalesce->rx_coalesce_usecs)
+	if (cbase->rx_coalesce_usecs)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS;
-	if (coalesce->rx_max_coalesced_frames)
+	if (cbase->rx_max_coalesced_frames)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES;
-	if (coalesce->rx_coalesce_usecs_irq)
+	if (cbase->rx_coalesce_usecs_irq)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS_IRQ;
-	if (coalesce->rx_max_coalesced_frames_irq)
+	if (cbase->rx_max_coalesced_frames_irq)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ;
-	if (coalesce->tx_coalesce_usecs)
+	if (cbase->tx_coalesce_usecs)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS;
-	if (coalesce->tx_max_coalesced_frames)
+	if (cbase->tx_max_coalesced_frames)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES;
-	if (coalesce->tx_coalesce_usecs_irq)
+	if (cbase->tx_coalesce_usecs_irq)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS_IRQ;
-	if (coalesce->tx_max_coalesced_frames_irq)
+	if (cbase->tx_max_coalesced_frames_irq)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ;
-	if (coalesce->stats_block_coalesce_usecs)
+	if (cbase->stats_block_coalesce_usecs)
 		nonzero_params |= ETHTOOL_COALESCE_STATS_BLOCK_USECS;
-	if (coalesce->use_adaptive_rx_coalesce)
+	if (cbase->use_adaptive_rx_coalesce)
 		nonzero_params |= ETHTOOL_COALESCE_USE_ADAPTIVE_RX;
-	if (coalesce->use_adaptive_tx_coalesce)
+	if (cbase->use_adaptive_tx_coalesce)
 		nonzero_params |= ETHTOOL_COALESCE_USE_ADAPTIVE_TX;
-	if (coalesce->pkt_rate_low)
+	if (cbase->pkt_rate_low)
 		nonzero_params |= ETHTOOL_COALESCE_PKT_RATE_LOW;
-	if (coalesce->rx_coalesce_usecs_low)
+	if (cbase->rx_coalesce_usecs_low)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS_LOW;
-	if (coalesce->rx_max_coalesced_frames_low)
+	if (cbase->rx_max_coalesced_frames_low)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW;
-	if (coalesce->tx_coalesce_usecs_low)
+	if (cbase->tx_coalesce_usecs_low)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS_LOW;
-	if (coalesce->tx_max_coalesced_frames_low)
+	if (cbase->tx_max_coalesced_frames_low)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW;
-	if (coalesce->pkt_rate_high)
+	if (cbase->pkt_rate_high)
 		nonzero_params |= ETHTOOL_COALESCE_PKT_RATE_HIGH;
-	if (coalesce->rx_coalesce_usecs_high)
+	if (cbase->rx_coalesce_usecs_high)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS_HIGH;
-	if (coalesce->rx_max_coalesced_frames_high)
+	if (cbase->rx_max_coalesced_frames_high)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH;
-	if (coalesce->tx_coalesce_usecs_high)
+	if (cbase->tx_coalesce_usecs_high)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS_HIGH;
-	if (coalesce->tx_max_coalesced_frames_high)
+	if (cbase->tx_max_coalesced_frames_high)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH;
-	if (coalesce->rate_sample_interval)
+	if (cbase->rate_sample_interval)
 		nonzero_params |= ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL;
 
 	return (supported_params & nonzero_params) == nonzero_params;
@@ -1586,19 +1589,19 @@ ethtool_set_coalesce_supported(struct net_device *dev,
 static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
-	struct ethtool_coalesce coalesce;
+	struct kernel_ethtool_coalesce coalesce;
 	int ret;
 
 	if (!dev->ethtool_ops->set_coalesce)
 		return -EOPNOTSUPP;
 
-	if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
+	if (copy_from_user(&coalesce.base, useraddr, sizeof(coalesce.base)))
 		return -EFAULT;
 
 	if (!ethtool_set_coalesce_supported(dev, &coalesce))
 		return -EOPNOTSUPP;
 
-	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->set_coalesce(dev, NULL, &coalesce);
 	if (!ret)
 		ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
 	return ret;
@@ -2389,7 +2392,7 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
 		return -ENOMEM;
 
 	for_each_set_bit(bit, queue_mask, MAX_NUM_QUEUE) {
-		struct ethtool_coalesce coalesce;
+		struct kernel_ethtool_coalesce coalesce = {};
 
 		ret = dev->ethtool_ops->get_per_queue_coalesce(dev, bit, tmp);
 		if (ret != 0)
@@ -2397,7 +2400,7 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
 
 		tmp++;
 
-		if (copy_from_user(&coalesce, useraddr, sizeof(coalesce))) {
+		if (copy_from_user(&coalesce.base, useraddr, sizeof(coalesce.base))) {
 			ret = -EFAULT;
 			goto roll_back;
 		}
@@ -2407,11 +2410,11 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
 			goto roll_back;
 		}
 
-		ret = dev->ethtool_ops->set_per_queue_coalesce(dev, bit, &coalesce);
+		ret = dev->ethtool_ops->set_per_queue_coalesce(dev, bit, &coalesce.base);
 		if (ret != 0)
 			goto roll_back;
 
-		useraddr += sizeof(coalesce);
+		useraddr += sizeof(coalesce.base);
 	}
 
 roll_back:
-- 
2.7.4

