Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821DC49ADA3
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445573AbiAYH3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:29:52 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17807 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445150AbiAYH1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 02:27:07 -0500
Received: from kwepemi500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Jjdg751j7z9sS4;
        Tue, 25 Jan 2022 15:25:39 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500021.china.huawei.com (7.221.188.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:26:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:26:58 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [RESEND PATCH net-next 1/2] net: hns3: add support for TX push mode
Date:   Tue, 25 Jan 2022 15:21:48 +0800
Message-ID: <20220125072149.56604-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220125072149.56604-1-huangguangbin2@huawei.com>
References: <20220125072149.56604-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

For the device that supports the TX push capability, the BD can
be directly copied to the device memory. However, due to hardware
restrictions, the push mode can be used only when there are no
more than two BDs, otherwise, the doorbell mode based on device
memory is used.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 79 ++++++++++++++++++-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  6 ++
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  2 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 11 ++-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  8 ++
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 11 ++-
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  8 ++
 8 files changed, 118 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9298fbecb31a..6f18c9a03231 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -167,6 +167,7 @@ struct hnae3_handle;
 
 struct hnae3_queue {
 	void __iomem *io_base;
+	void __iomem *mem_base;
 	struct hnae3_ae_algo *ae_algo;
 	struct hnae3_handle *handle;
 	int tqp_index;		/* index in a handle */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index babc5d7a3b52..0b8a73c40b12 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2028,9 +2028,73 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 	return bd_num;
 }
 
+static void hns3_tx_push_bd(struct hns3_enet_ring *ring, int num)
+{
+#define HNS3_BYTES_PER_64BIT		8
+
+	struct hns3_desc desc[HNS3_MAX_PUSH_BD_NUM] = {};
+	int offset = 0;
+
+	/* make sure everything is visible to device before
+	 * excuting tx push or updating doorbell
+	 */
+	dma_wmb();
+
+	do {
+		int idx = (ring->next_to_use - num + ring->desc_num) %
+			  ring->desc_num;
+
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.tx_push++;
+		u64_stats_update_end(&ring->syncp);
+		memcpy(&desc[offset], &ring->desc[idx],
+		       sizeof(struct hns3_desc));
+		offset++;
+	} while (--num);
+
+	__iowrite64_copy(ring->tqp->mem_base, desc,
+			 (sizeof(struct hns3_desc) * HNS3_MAX_PUSH_BD_NUM) /
+			 HNS3_BYTES_PER_64BIT);
+
+	io_stop_wc();
+}
+
+static void hns3_tx_mem_doorbell(struct hns3_enet_ring *ring)
+{
+#define HNS3_MEM_DOORBELL_OFFSET	64
+
+	__le64 bd_num = cpu_to_le64((u64)ring->pending_buf);
+
+	/* make sure everything is visible to device before
+	 * excuting tx push or updating doorbell
+	 */
+	dma_wmb();
+
+	__iowrite64_copy(ring->tqp->mem_base + HNS3_MEM_DOORBELL_OFFSET,
+			 &bd_num, 1);
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.tx_mem_doorbell += ring->pending_buf;
+	u64_stats_update_end(&ring->syncp);
+
+	io_stop_wc();
+}
+
 static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 			     bool doorbell)
 {
+	struct net_device *netdev = ring_to_netdev(ring);
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+
+	/* when tx push is enabled, the packet whose number of BD below
+	 * HNS3_MAX_PUSH_BD_NUM can be pushed directly.
+	 */
+	if (test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state) && num &&
+	    !ring->pending_buf && num <= HNS3_MAX_PUSH_BD_NUM && doorbell) {
+		hns3_tx_push_bd(ring, num);
+		WRITE_ONCE(ring->last_to_use, ring->next_to_use);
+		return;
+	}
+
 	ring->pending_buf += num;
 
 	if (!doorbell) {
@@ -2038,11 +2102,12 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 		return;
 	}
 
-	if (!ring->pending_buf)
-		return;
+	if (ring->tqp->mem_base)
+		hns3_tx_mem_doorbell(ring);
+	else
+		writel(ring->pending_buf,
+		       ring->tqp->io_base + HNS3_RING_TX_RING_TAIL_REG);
 
-	writel(ring->pending_buf,
-	       ring->tqp->io_base + HNS3_RING_TX_RING_TAIL_REG);
 	ring->pending_buf = 0;
 	WRITE_ONCE(ring->last_to_use, ring->next_to_use);
 }
@@ -2732,6 +2797,9 @@ static void hns3_dump_queue_stats(struct net_device *ndev,
 		    "seg_pkt_cnt: %llu, tx_more: %llu, restart_queue: %llu, tx_busy: %llu\n",
 		    tx_ring->stats.seg_pkt_cnt, tx_ring->stats.tx_more,
 		    tx_ring->stats.restart_queue, tx_ring->stats.tx_busy);
+
+	netdev_info(ndev, "tx_push: %llu, tx_mem_doorbell: %llu\n",
+		    tx_ring->stats.tx_push, tx_ring->stats.tx_mem_doorbell);
 }
 
 static void hns3_dump_queue_reg(struct net_device *ndev,
@@ -5094,6 +5162,9 @@ static void hns3_state_init(struct hnae3_handle *handle)
 
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
+	if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->supported_pflags);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index a05a0c7423ce..4a3253692dcc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -7,6 +7,7 @@
 #include <linux/dim.h>
 #include <linux/if_vlan.h>
 #include <net/page_pool.h>
+#include <asm/barrier.h>
 
 #include "hnae3.h"
 
@@ -25,9 +26,12 @@ enum hns3_nic_state {
 	HNS3_NIC_STATE2_RESET_REQUESTED,
 	HNS3_NIC_STATE_HW_TX_CSUM_ENABLE,
 	HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE,
+	HNS3_NIC_STATE_TX_PUSH_ENABLE,
 	HNS3_NIC_STATE_MAX
 };
 
+#define HNS3_MAX_PUSH_BD_NUM		2
+
 #define HNS3_RING_RX_RING_BASEADDR_L_REG	0x00000
 #define HNS3_RING_RX_RING_BASEADDR_H_REG	0x00004
 #define HNS3_RING_RX_RING_BD_NUM_REG		0x00008
@@ -410,6 +414,8 @@ struct ring_stats {
 			u64 tx_pkts;
 			u64 tx_bytes;
 			u64 tx_more;
+			u64 tx_push;
+			u64 tx_mem_doorbell;
 			u64 restart_queue;
 			u64 tx_busy;
 			u64 tx_copy;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c06c39ece80d..6469238ae090 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -23,6 +23,8 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("packets", tx_pkts),
 	HNS3_TQP_STAT("bytes", tx_bytes),
 	HNS3_TQP_STAT("more", tx_more),
+	HNS3_TQP_STAT("push", tx_push),
+	HNS3_TQP_STAT("mem_doorbell", tx_mem_doorbell),
 	HNS3_TQP_STAT("wake", restart_queue),
 	HNS3_TQP_STAT("busy", tx_busy),
 	HNS3_TQP_STAT("copy", tx_copy),
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 24f7afacae02..78d0498bdabc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1643,6 +1643,7 @@ static int hclge_config_gro(struct hclge_dev *hdev)
 
 static int hclge_alloc_tqps(struct hclge_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_comm_tqp *tqp;
 	int i;
 
@@ -1676,6 +1677,14 @@ static int hclge_alloc_tqps(struct hclge_dev *hdev)
 					 (i - HCLGE_TQP_MAX_SIZE_DEV_V2) *
 					 HCLGE_TQP_REG_SIZE;
 
+		/* when device supports tx push and has device memory,
+		 * the queue can execute push mode or doorbell mode on
+		 * device memory.
+		 */
+		if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+			tqp->q.mem_base = hdev->hw.hw.mem_base +
+					  HCLGE_TQP_MEM_OFFSET(hdev, i);
+
 		tqp++;
 	}
 
@@ -11008,8 +11017,6 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 
 static int hclge_dev_mem_map(struct hclge_dev *hdev)
 {
-#define HCLGE_MEM_BAR		4
-
 	struct pci_dev *pdev = hdev->pdev;
 	struct hclge_hw *hw = &hdev->hw;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index adfb26e79262..f7f5a4b09068 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -169,6 +169,14 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_VECTOR0_ALL_MSIX_ERR_B	6U
 #define HCLGE_TRIGGER_IMP_RESET_B	7U
 
+#define HCLGE_TQP_MEM_SIZE		0x10000
+#define HCLGE_MEM_BAR			4
+/* in the bar4, the first half is for roce, and the second half is for nic */
+#define HCLGE_NIC_MEM_OFFSET(hdev)	\
+	(pci_resource_len((hdev)->pdev, HCLGE_MEM_BAR) >> 1)
+#define HCLGE_TQP_MEM_OFFSET(hdev, i)	\
+	(HCLGE_NIC_MEM_OFFSET(hdev) + HCLGE_TQP_MEM_SIZE * (i))
+
 #define HCLGE_MAC_DEFAULT_FRAME \
 	(ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN + ETH_DATA_LEN)
 #define HCLGE_MAC_MIN_FRAME		64
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 7df87610ad96..c2224e4c17a3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -321,6 +321,7 @@ static int hclgevf_get_pf_media_type(struct hclgevf_dev *hdev)
 
 static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_comm_tqp *tqp;
 	int i;
 
@@ -354,6 +355,14 @@ static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 					 (i - HCLGEVF_TQP_MAX_SIZE_DEV_V2) *
 					 HCLGEVF_TQP_REG_SIZE;
 
+		/* when device supports tx push and has device memory,
+		 * the queue can execute push mode or doorbell mode on
+		 * device memory.
+		 */
+		if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+			tqp->q.mem_base = hdev->hw.hw.mem_base +
+					  HCLGEVF_TQP_MEM_OFFSET(hdev, i);
+
 		tqp++;
 	}
 
@@ -2547,8 +2556,6 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 
 static int hclgevf_dev_mem_map(struct hclgevf_dev *hdev)
 {
-#define HCLGEVF_MEM_BAR		4
-
 	struct pci_dev *pdev = hdev->pdev;
 	struct hclgevf_hw *hw = &hdev->hw;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 502ca1ce1a90..4b00fd44f118 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -96,6 +96,14 @@
 
 #define HCLGEVF_RSS_IND_TBL_SIZE		512
 
+#define HCLGEVF_TQP_MEM_SIZE		0x10000
+#define HCLGEVF_MEM_BAR			4
+/* in the bar4, the first half is for roce, and the second half is for nic */
+#define HCLGEVF_NIC_MEM_OFFSET(hdev)	\
+	(pci_resource_len((hdev)->pdev, HCLGEVF_MEM_BAR) >> 1)
+#define HCLGEVF_TQP_MEM_OFFSET(hdev, i)		\
+	(HCLGEVF_NIC_MEM_OFFSET(hdev) + HCLGEVF_TQP_MEM_SIZE * (i))
+
 #define HCLGEVF_MAC_MAX_FRAME		9728
 
 #define HCLGEVF_STATS_TIMER_INTERVAL	36U
-- 
2.33.0

