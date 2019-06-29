Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9BF5AA0E
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 12:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfF2KQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 06:16:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49108 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726839AbfF2KQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 06:16:39 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 33FCA289E10B9AADC0D9;
        Sat, 29 Jun 2019 18:16:36 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sat, 29 Jun 2019 18:16:29 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next] hinic: add vlan offload support
Date:   Sat, 29 Jun 2019 02:26:27 +0000
Message-ID: <20190629022627.25396-1-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds vlan offload support for the HINIC driver.

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 ++
 .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  | 15 ++++++++++
 .../net/ethernet/huawei/hinic/hinic_main.c    |  9 ++++--
 .../net/ethernet/huawei/hinic/hinic_port.c    | 30 +++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 13 ++++++++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  | 13 ++++++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  | 17 +++++++++++
 7 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index e83e3bf850d5..984c98f33258 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -45,6 +45,8 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_RX_CSUM	= 26,
 
+	HINIC_PORT_CMD_SET_RX_VLAN_OFFLOAD = 27,
+
 	HINIC_PORT_CMD_GET_PORT_STATISTICS = 28,
 
 	HINIC_PORT_CMD_CLEAR_PORT_STATISTICS = 29,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
index c6b809e24983..f4b6d2c1061f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h
@@ -222,6 +222,8 @@
 
 #define RQ_CQE_OFFOLAD_TYPE_PKT_TYPE_SHIFT		0
 #define RQ_CQE_OFFOLAD_TYPE_PKT_TYPE_MASK		0xFFFU
+#define RQ_CQE_OFFOLAD_TYPE_VLAN_EN_SHIFT		21
+#define RQ_CQE_OFFOLAD_TYPE_VLAN_EN_MASK		0x1U
 
 #define RQ_CQE_OFFOLAD_TYPE_GET(val, member)		(((val) >> \
 				RQ_CQE_OFFOLAD_TYPE_##member##_SHIFT) & \
@@ -230,6 +232,19 @@
 #define HINIC_GET_RX_PKT_TYPE(offload_type)	\
 			RQ_CQE_OFFOLAD_TYPE_GET(offload_type, PKT_TYPE)
 
+#define HINIC_GET_RX_VLAN_OFFLOAD_EN(offload_type)	\
+			RQ_CQE_OFFOLAD_TYPE_GET(offload_type, VLAN_EN)
+
+#define RQ_CQE_SGE_VLAN_MASK				0xFFFFU
+#define RQ_CQE_SGE_VLAN_SHIFT				0
+
+#define RQ_CQE_SGE_GET(val, member)			(((val) >> \
+					RQ_CQE_SGE_##member##_SHIFT) & \
+					RQ_CQE_SGE_##member##_MASK)
+
+#define HINIC_GET_RX_VLAN_TAG(vlan_len)	\
+		RQ_CQE_SGE_GET(vlan_len, VLAN)
+
 #define HINIC_RSS_TYPE_VALID_SHIFT			23
 #define HINIC_RSS_TYPE_TCP_IPV6_EXT_SHIFT		24
 #define HINIC_RSS_TYPE_IPV6_EXT_SHIFT			25
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 1b917543feac..0eb83d529eac 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -830,14 +830,14 @@ static const struct net_device_ops hinic_netdev_ops = {
 	.ndo_get_stats64 = hinic_get_stats64,
 	.ndo_fix_features = hinic_fix_features,
 	.ndo_set_features = hinic_set_features,
-
 };
 
 static void netdev_features_init(struct net_device *netdev)
 {
 	netdev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
 			      NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM | NETIF_F_LRO;
+			      NETIF_F_RXCSUM | NETIF_F_LRO |
+			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
 
 	netdev->vlan_features = netdev->hw_features;
 
@@ -917,6 +917,11 @@ static int set_features(struct hinic_dev *nic_dev,
 					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
 	}
 
+	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+		err = hinic_set_rx_vlan_offload(nic_dev,
+						!!(features &
+						   NETIF_F_HW_VLAN_CTAG_RX));
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index c07adf793215..1bbeb91be808 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -431,6 +431,36 @@ int hinic_set_rx_csum_offload(struct hinic_dev *nic_dev, u32 en)
 	return 0;
 }
 
+int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en)
+{
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_vlan_cfg vlan_cfg;
+	struct hinic_hwif *hwif;
+	struct pci_dev *pdev;
+	u16 out_size;
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	hwif = hwdev->hwif;
+	pdev = hwif->pdev;
+	vlan_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	vlan_cfg.vlan_rx_offload = en;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_RX_VLAN_OFFLOAD,
+				 &vlan_cfg, sizeof(vlan_cfg),
+				 &vlan_cfg, &out_size);
+	if (err || !out_size || vlan_cfg.status) {
+		dev_err(&pdev->dev,
+			"Failed to set rx vlan offload, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, vlan_cfg.status, out_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int hinic_set_max_qnum(struct hinic_dev *nic_dev, u8 num_rqs)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 16140a13000b..1bc47c7a5c00 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -223,6 +223,16 @@ struct hinic_lro_timer {
 	u32	timer;
 };
 
+struct hinic_vlan_cfg {
+	u8      status;
+	u8      version;
+	u8      rsvd0[6];
+
+	u16     func_id;
+	u8      vlan_rx_offload;
+	u8      rsvd1[5];
+};
+
 struct hinic_rss_template_mgmt {
 	u8	status;
 	u8	version;
@@ -558,4 +568,7 @@ int hinic_get_phy_port_stats(struct hinic_dev *nic_dev,
 
 int hinic_get_vport_stats(struct hinic_dev *nic_dev,
 			  struct hinic_vport_stats *stats);
+
+int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en);
+
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 609ad4333cdd..56ea6d692f1c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -18,6 +18,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/prefetch.h>
 #include <linux/cpumask.h>
+#include <linux/if_vlan.h>
 #include <asm/barrier.h>
 
 #include "hinic_common.h"
@@ -325,6 +326,7 @@ static int rx_recv_jumbo_pkt(struct hinic_rxq *rxq, struct sk_buff *head_skb,
 static int rxq_recv(struct hinic_rxq *rxq, int budget)
 {
 	struct hinic_qp *qp = container_of(rxq->rq, struct hinic_qp, rq);
+	struct net_device *netdev = rxq->netdev;
 	u64 pkt_len = 0, rx_bytes = 0;
 	struct hinic_rq *rq = rxq->rq;
 	struct hinic_rq_wqe *rq_wqe;
@@ -334,8 +336,11 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 	struct hinic_sge sge;
 	unsigned int status;
 	struct sk_buff *skb;
+	u32 offload_type;
 	u16 ci, num_lro;
 	u16 num_wqe = 0;
+	u32 vlan_len;
+	u16 vid;
 
 	while (pkts < budget) {
 		num_wqes = 0;
@@ -368,6 +373,14 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 		hinic_rq_put_wqe(rq, ci,
 				 (num_wqes + 1) * HINIC_RQ_WQE_SIZE);
 
+		offload_type = be32_to_cpu(cqe->offload_type);
+		vlan_len = be32_to_cpu(cqe->len);
+		if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		    HINIC_GET_RX_VLAN_OFFLOAD_EN(offload_type)) {
+			vid = HINIC_GET_RX_VLAN_TAG(vlan_len);
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
+		}
+
 		skb_record_rx_queue(skb, qp->q_id);
 		skb->protocol = eth_type_trans(skb, rxq->netdev);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index f4f76370cd65..9c78251f9c39 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -407,10 +407,20 @@ static int offload_csum(struct hinic_sq_task *task, u32 *queue_info,
 	return 1;
 }
 
+static void offload_vlan(struct hinic_sq_task *task, u32 *queue_info,
+			 u16 vlan_tag, u16 vlan_pri)
+{
+	task->pkt_info0 |= HINIC_SQ_TASK_INFO0_SET(vlan_tag, VLAN_TAG) |
+				HINIC_SQ_TASK_INFO0_SET(1U, VLAN_OFFLOAD);
+
+	*queue_info |= HINIC_SQ_CTRL_SET(vlan_pri, QUEUE_INFO_PRI);
+}
+
 static int hinic_tx_offload(struct sk_buff *skb, struct hinic_sq_task *task,
 			    u32 *queue_info)
 {
 	enum hinic_offload_type offload = 0;
+	u16 vlan_tag;
 	int enabled;
 
 	enabled = offload_tso(task, queue_info, skb);
@@ -424,6 +434,13 @@ static int hinic_tx_offload(struct sk_buff *skb, struct hinic_sq_task *task,
 		return -EPROTONOSUPPORT;
 	}
 
+	if (unlikely(skb_vlan_tag_present(skb))) {
+		vlan_tag = skb_vlan_tag_get(skb);
+		offload_vlan(task, queue_info, vlan_tag,
+			     vlan_tag >> VLAN_PRIO_SHIFT);
+		offload |= TX_OFFLOAD_VLAN;
+	}
+
 	if (offload)
 		hinic_task_set_l2hdr(task, skb_network_offset(skb));
 
-- 
2.17.1

