Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA7394A1C
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 05:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhE2DYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 23:24:20 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2457 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhE2DYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 23:24:11 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FsRcW4T7Tz67Mf;
        Sat, 29 May 2021 11:19:39 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [RFC V2 net-next 3/3] net: hns3: add ethtool support for CQE/EQE mode configuration
Date:   Sat, 29 May 2021 11:22:16 +0800
Message-ID: <1622258536-55776-4-git-send-email-tanhuazhong@huawei.com>
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

Add support in ethtool for switching EQE/CQE mode.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 18 +++++++++++++++++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 40e65c3..98a9bd9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4549,9 +4549,9 @@ static void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
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
index b9f9599..3ef9fbc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1159,6 +1159,11 @@ static int hns3_get_coalesce(struct net_device *netdev,
 	cmd->tx_max_coalesced_frames = tx_coal->int_ql;
 	cmd->rx_max_coalesced_frames = rx_coal->int_ql;
 
+	kernel_coal->use_cqe_mode_tx = (priv->tx_cqe_mode ==
+					DIM_CQ_PERIOD_MODE_START_FROM_CQE);
+	kernel_coal->use_cqe_mode_rx = (priv->rx_cqe_mode ==
+					DIM_CQ_PERIOD_MODE_START_FROM_CQE);
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
 
@@ -1353,6 +1360,14 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	for (i = 0; i < queue_num; i++)
 		hns3_set_coalesce_per_queue(netdev, cmd, i);
 
+	tx_mode = kernel_coal->use_cqe_mode_tx ?
+		  DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		  DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	rx_mode = kernel_coal->use_cqe_mode_rx ?
+		  DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		  DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+	hns3_cq_period_mode_init(priv, tx_mode, rx_mode);
+
 	return 0;
 }
 
@@ -1604,7 +1619,8 @@ static int hns3_set_priv_flags(struct net_device *netdev, u32 pflags)
 				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
 				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
 				 ETHTOOL_COALESCE_TX_USECS_HIGH |	\
-				 ETHTOOL_COALESCE_MAX_FRAMES)
+				 ETHTOOL_COALESCE_MAX_FRAMES	|	\
+				 ETHTOOL_COALESCE_USE_CQE)
 
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
-- 
2.7.4

