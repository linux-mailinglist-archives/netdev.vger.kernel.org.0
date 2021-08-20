Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98E33F27BC
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbhHTHkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:40:19 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8899 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238804AbhHTHjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:39:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GrYM02vxLz8svT;
        Fri, 20 Aug 2021 15:35:08 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 15:39:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 15:39:12 +0800
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
Subject: [PATCH V3 net-next 3/4] net: hns3: add support for EQE/CQE mode configuration
Date:   Fri, 20 Aug 2021 15:35:19 +0800
Message-ID: <1629444920-25437-4-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For device whose version is above V3(include V3), the GL can
select EQE or CQE mode, so adds support for it.

In CQE mode, the coalesced timer will restart when the first new
completion occurs, while in EQE mode, the timer will not restart.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 49 +++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  8 ++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  1 +
 5 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 848bed8..1d51fae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -774,6 +774,7 @@ struct hnae3_knic_private_info {
 
 	u16 int_rl_setting;
 	enum pkt_hash_types rss_type;
+	void __iomem *io_base;
 };
 
 struct hnae3_roce_private_info {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fcbeb1f..1bd83d7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4473,9 +4473,7 @@ static void hns3_tx_dim_work(struct work_struct *work)
 static void hns3_nic_init_dim(struct hns3_enet_tqp_vector *tqp_vector)
 {
 	INIT_WORK(&tqp_vector->rx_group.dim.work, hns3_rx_dim_work);
-	tqp_vector->rx_group.dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 	INIT_WORK(&tqp_vector->tx_group.dim.work, hns3_tx_dim_work);
-	tqp_vector->tx_group.dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 }
 
 static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
@@ -5023,6 +5021,48 @@ static void hns3_info_show(struct hns3_nic_priv *priv)
 	dev_info(priv->dev, "Max mtu size: %u\n", priv->netdev->max_mtu);
 }
 
+static void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
+				    enum dim_cq_period_mode mode, bool is_tx)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
+	struct hnae3_handle *handle = priv->ae_handle;
+	int i;
+
+	if (is_tx) {
+		priv->tx_cqe_mode = mode;
+
+		for (i = 0; i < priv->vector_num; i++)
+			priv->tqp_vector[i].tx_group.dim.mode = mode;
+	} else {
+		priv->rx_cqe_mode = mode;
+
+		for (i = 0; i < priv->vector_num; i++)
+			priv->tqp_vector[i].rx_group.dim.mode = mode;
+	}
+
+	/* only device version above V3(include V3), GL can switch CQ/EQ
+	 * period mode.
+	 */
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3) {
+		u32 new_mode;
+		u64 reg;
+
+		new_mode = (mode == DIM_CQ_PERIOD_MODE_START_FROM_CQE) ?
+			HNS3_CQ_MODE_CQE : HNS3_CQ_MODE_EQE;
+		reg = is_tx ? HNS3_GL1_CQ_MODE_REG : HNS3_GL0_CQ_MODE_REG;
+
+		writel(new_mode, handle->kinfo.io_base + reg);
+	}
+}
+
+static void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
+				     enum dim_cq_period_mode tx_mode,
+				     enum dim_cq_period_mode rx_mode)
+{
+	hns3_set_cq_period_mode(priv, tx_mode, true);
+	hns3_set_cq_period_mode(priv, rx_mode, false);
+}
+
 static int hns3_client_init(struct hnae3_handle *handle)
 {
 	struct pci_dev *pdev = handle->pdev;
@@ -5090,6 +5130,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 		goto out_init_ring;
 	}
 
+	hns3_cq_period_mode_init(priv, DIM_CQ_PERIOD_MODE_START_FROM_EQE,
+				 DIM_CQ_PERIOD_MODE_START_FROM_EQE);
+
 	ret = hns3_init_phy(netdev);
 	if (ret)
 		goto out_init_phy;
@@ -5422,6 +5465,8 @@ static int hns3_reset_notify_init_enet(struct hnae3_handle *handle)
 	if (ret)
 		goto err_uninit_vector;
 
+	hns3_cq_period_mode_init(priv, priv->tx_cqe_mode, priv->rx_cqe_mode);
+
 	/* the device can work without cpu rmap, only aRFS needs it */
 	ret = hns3_set_rx_cpu_rmap(netdev);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index b0e696b..ff45825 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -202,6 +202,12 @@ enum hns3_nic_state {
 
 #define HNS3_RING_EN_B				0
 
+#define HNS3_GL0_CQ_MODE_REG			0x20d00
+#define HNS3_GL1_CQ_MODE_REG			0x20d04
+#define HNS3_GL2_CQ_MODE_REG			0x20d08
+#define HNS3_CQ_MODE_EQE			1U
+#define HNS3_CQ_MODE_CQE			0U
+
 enum hns3_pkt_l2t_type {
 	HNS3_L2_TYPE_UNICAST,
 	HNS3_L2_TYPE_MULTICAST,
@@ -572,6 +578,8 @@ struct hns3_nic_priv {
 
 	unsigned long state;
 
+	enum dim_cq_period_mode tx_cqe_mode;
+	enum dim_cq_period_mode rx_cqe_mode;
 	struct hns3_enet_coalesce tx_coal;
 	struct hns3_enet_coalesce rx_coal;
 	u32 tx_copybreak;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8779a63..f688209 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1814,6 +1814,7 @@ static int hclge_vport_setup(struct hclge_vport *vport, u16 num_tqps)
 	nic->pdev = hdev->pdev;
 	nic->ae_algo = &ae_algo;
 	nic->numa_node_mask = hdev->numa_node_mask;
+	nic->kinfo.io_base = hdev->hw.io_base;
 
 	ret = hclge_knic_setup(vport, num_tqps,
 			       hdev->num_tx_desc, hdev->num_rx_desc);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 3a19f08..ff65173 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -539,6 +539,7 @@ static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
 	nic->pdev = hdev->pdev;
 	nic->numa_node_mask = hdev->numa_node_mask;
 	nic->flags |= HNAE3_SUPPORT_VF;
+	nic->kinfo.io_base = hdev->hw.io_base;
 
 	ret = hclgevf_knic_setup(hdev);
 	if (ret)
-- 
2.8.1

