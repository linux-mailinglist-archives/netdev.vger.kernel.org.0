Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6153913A4
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhEZJ3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:29:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3975 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbhEZJ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 05:29:27 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fqlrd4V6HzQsSm;
        Wed, 26 May 2021 17:24:17 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 17:27:54 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 17:27:54 +0800
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
Subject: [RFC net-next 4/4] net: hns3: add ethtool support for CQE/EQE mode configuration
Date:   Wed, 26 May 2021 17:27:42 +0800
Message-ID: <1622021262-8881-5-git-send-email-tanhuazhong@huawei.com>
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

Add support in ethtool for switching EQE/CQE mode.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 16 +++++++++++++++-
 include/linux/ethtool.h                            |  2 ++
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3399f26..2096f22 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4553,9 +4553,9 @@ static void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
 	}
 }
 
-static void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
-				     enum dim_cq_period_mode tx_mode,
-				     enum dim_cq_period_mode rx_mode)
+void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
+			      enum dim_cq_period_mode tx_mode,
+			      enum dim_cq_period_mode rx_mode)
 {
 	hns3_set_cq_period_mode(priv, tx_mode, true);
 	hns3_set_cq_period_mode(priv, rx_mode, false);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 8445596..b031fd0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -666,4 +666,7 @@ void hns3_dbg_register_debugfs(const char *debugfs_dir_name);
 void hns3_dbg_unregister_debugfs(void);
 void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size);
 u16 hns3_get_max_available_channels(struct hnae3_handle *h);
+void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
+			      enum dim_cq_period_mode tx_mode,
+			      enum dim_cq_period_mode rx_mode);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 0042be0..b1fcd3e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1159,6 +1159,11 @@ static int hns3_get_coalesce(struct net_device *netdev,
 	coal_base->tx_max_coalesced_frames = tx_coal->int_ql;
 	coal_base->rx_max_coalesced_frames = rx_coal->int_ql;
 
+	cmd->use_cqe_mode_tx = (priv->tx_cqe_mode ==
+				DIM_CQ_PERIOD_MODE_START_FROM_CQE);
+	cmd->use_cqe_mode_rx = (priv->rx_cqe_mode ==
+				DIM_CQ_PERIOD_MODE_START_FROM_CQE);
+
 	return 0;
 }
 
@@ -1328,6 +1333,8 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	struct hns3_enet_coalesce *tx_coal = &priv->tx_coal;
 	struct hns3_enet_coalesce *rx_coal = &priv->rx_coal;
 	u16 queue_num = h->kinfo.num_tqps;
+	enum dim_cq_period_mode tx_mode;
+	enum dim_cq_period_mode rx_mode;
 	int ret;
 	int i;
 
@@ -1353,6 +1360,12 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	for (i = 0; i < queue_num; i++)
 		hns3_set_coalesce_per_queue(netdev, coal_base, i);
 
+	tx_mode = cmd->use_cqe_mode_tx ? DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		  DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	rx_mode = cmd->use_cqe_mode_rx ? DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		  DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	hns3_cq_period_mode_init(priv, tx_mode, rx_mode);
+
 	return 0;
 }
 
@@ -1604,7 +1617,8 @@ static int hns3_set_priv_flags(struct net_device *netdev, u32 pflags)
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
 				 ETHTOOL_COALESCE_TX_USECS_HIGH |	\
-				 ETHTOOL_COALESCE_MAX_FRAMES)
+				 ETHTOOL_COALESCE_MAX_FRAMES	|	\
+				 ETHTOOL_COALESCE_USE_CQE)
 
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9d0a386..4867008 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -250,6 +250,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_RX_USECS_HIGH | \
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
+#define ETHTOOL_COALESCE_USE_CQE					\
+	(ETHTOOL_COALESCE_USE_CQE_RX | ETHTOOL_COALESCE_USE_CQE_TX)
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
-- 
2.7.4

