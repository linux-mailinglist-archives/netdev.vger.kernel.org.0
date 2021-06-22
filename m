Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325543B028A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhFVLQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:16:50 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7377 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhFVLQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:16:46 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G8Nwb2WYfz71HS;
        Tue, 22 Jun 2021 19:10:23 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 19:14:27 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 22 Jun 2021 19:14:27 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
        <mark.rutland@arm.com>, <dbrazdil@google.com>, <qperret@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/3] net: hns3: add support for TX push mode
Date:   Tue, 22 Jun 2021 19:11:10 +0800
Message-ID: <1624360271-17525-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

For the device that supports the TX push capability, the BD can
be directly copied to the device memory. However, due to hardware
restrictions, the push mode can be used only when there are no
more than two BDs, otherwise, the doorbell mode based on device
memory is used.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 83 ++++++++++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  6 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 11 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 +++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 11 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  8 +++
 10 files changed, 126 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0b202f4def83..3979d5d2e842 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -163,6 +163,7 @@ struct hnae3_handle;
 
 struct hnae3_queue {
 	void __iomem *io_base;
+	void __iomem *mem_base;
 	struct hnae3_ae_algo *ae_algo;
 	struct hnae3_handle *handle;
 	int tqp_index;		/* index in a handle */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cdb5f14fb6bc..8649bd8e1b57 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2002,9 +2002,77 @@ static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
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
+#if defined(CONFIG_ARM64)
+	dgh();
+#endif
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
+#if defined(CONFIG_ARM64)
+	dgh();
+#endif
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
@@ -2014,11 +2082,12 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
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
@@ -2713,6 +2782,9 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		    tx_ring->stats.seg_pkt_cnt, tx_ring->stats.tx_more,
 		    tx_ring->stats.restart_queue, tx_ring->stats.tx_busy);
 
+	netdev_info(ndev, "tx_push: %llu, tx_mem_doorbell: %llu\n",
+		    tx_ring->stats.tx_push, tx_ring->stats.tx_mem_doorbell);
+
 	/* When mac received many pause frames continuous, it's unable to send
 	 * packets, which may cause tx timeout
 	 */
@@ -5060,6 +5132,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	if (hnae3_ae_dev_rxd_adv_layout_supported(ae_dev))
 		set_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state);
 
+	if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 15af3d93857b..277c4e1bdfa1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -6,6 +6,7 @@
 
 #include <linux/dim.h>
 #include <linux/if_vlan.h>
+#include <asm/barrier.h>
 
 #include "hnae3.h"
 
@@ -21,9 +22,12 @@ enum hns3_nic_state {
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
@@ -399,6 +403,8 @@ struct ring_stats {
 			u64 tx_pkts;
 			u64 tx_bytes;
 			u64 tx_more;
+			u64 tx_push;
+			u64 tx_mem_doorbell;
 			u64 restart_queue;
 			u64 tx_busy;
 			u64 tx_copy;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 82061ab6930f..155a58e11089 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -37,6 +37,8 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("packets", tx_pkts),
 	HNS3_TQP_STAT("bytes", tx_bytes),
 	HNS3_TQP_STAT("more", tx_more),
+	HNS3_TQP_STAT("push", tx_push),
+	HNS3_TQP_STAT("mem_doorbell", tx_mem_doorbell),
 	HNS3_TQP_STAT("wake", restart_queue),
 	HNS3_TQP_STAT("busy", tx_busy),
 	HNS3_TQP_STAT("copy", tx_copy),
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 887297e37cf3..fe985fd65870 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -395,6 +395,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B, ae_dev->caps);
 		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 	}
+	if (hnae3_get_bit(caps, HCLGE_CAP_TX_PUSH_B))
+		set_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps);
 }
 
 static __le32 hclge_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f3e482ab3c71..369b588abf84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1642,6 +1642,7 @@ static int hclge_config_gro(struct hclge_dev *hdev, bool en)
 
 static int hclge_alloc_tqps(struct hclge_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_tqp *tqp;
 	int i;
 
@@ -1675,6 +1676,14 @@ static int hclge_alloc_tqps(struct hclge_dev *hdev)
 					 (i - HCLGE_TQP_MAX_SIZE_DEV_V2) *
 					 HCLGE_TQP_REG_SIZE;
 
+		/* when device supports tx push and has device memory,
+		 * the queue can execute push mode or doorbell mode on
+		 * device memory.
+		 */
+		if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+			tqp->q.mem_base = hdev->hw.mem_base +
+					  HCLGE_TQP_MEM_OFFSET(hdev, i);
+
 		tqp++;
 	}
 
@@ -11249,8 +11258,6 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 
 static int hclge_dev_mem_map(struct hclge_dev *hdev)
 {
-#define HCLGE_MEM_BAR		4
-
 	struct pci_dev *pdev = hdev->pdev;
 	struct hclge_hw *hw = &hdev->hw;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3d3352491dba..db54fdf3ad38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -194,6 +194,14 @@ enum HLCGE_PORT_TYPE {
 #define HCLGE_VECTOR0_IMP_RD_POISON_B	5U
 #define HCLGE_VECTOR0_ALL_MSIX_ERR_B	6U
 
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
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index bd19a2d89f6c..55c56c28bb81 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -361,6 +361,8 @@ static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGEVF_CAP_RXD_ADV_LAYOUT_B))
 		set_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_TX_PUSH_B))
+		set_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps);
 }
 
 static __le32 hclgevf_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 52eaf82b7cd7..983894532b38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -396,6 +396,7 @@ static int hclgevf_get_pf_media_type(struct hclgevf_dev *hdev)
 
 static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclgevf_tqp *tqp;
 	int i;
 
@@ -429,6 +430,14 @@ static int hclgevf_alloc_tqps(struct hclgevf_dev *hdev)
 					 (i - HCLGEVF_TQP_MAX_SIZE_DEV_V2) *
 					 HCLGEVF_TQP_REG_SIZE;
 
+		/* when device supports tx push and has device memory,
+		 * the queue can execute push mode or doorbell mode on
+		 * device memory.
+		 */
+		if (test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+			tqp->q.mem_base = hdev->hw.mem_base +
+					  HCLGEVF_TQP_MEM_OFFSET(hdev, i);
+
 		tqp++;
 	}
 
@@ -3001,8 +3010,6 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 
 static int hclgevf_dev_mem_map(struct hclgevf_dev *hdev)
 {
-#define HCLGEVF_MEM_BAR		4
-
 	struct pci_dev *pdev = hdev->pdev;
 	struct hclgevf_hw *hw = &hdev->hw;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index d7d02848d674..cacb7c23ca1c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -125,6 +125,14 @@
 #define HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
 	(HCLGEVF_D_IP_BIT | HCLGEVF_S_IP_BIT | HCLGEVF_V_TAG_BIT)
 
+#define HCLGEVF_TQP_MEM_SIZE		0x10000
+#define HCLGEVF_MEM_BAR			4
+/* in the bar4, the first half is for roce, and the second half is for nic */
+#define HCLGEVF_NIC_MEM_OFFSET(hdev)	\
+	(pci_resource_len((hdev)->pdev, HCLGEVF_MEM_BAR) >> 1)
+#define HCLGEVF_TQP_MEM_OFFSET(hdev, i)	\
+	(HCLGEVF_NIC_MEM_OFFSET(hdev) + HCLGEVF_TQP_MEM_SIZE * (i))
+
 #define HCLGEVF_MAC_MAX_FRAME		9728
 
 #define HCLGEVF_STATS_TIMER_INTERVAL	36U
-- 
2.8.1

