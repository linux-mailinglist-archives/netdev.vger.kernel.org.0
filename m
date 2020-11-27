Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64B02C6126
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgK0Irx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:47:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7744 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgK0Irx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:47:53 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cj7Xw41YCzkhCZ;
        Fri, 27 Nov 2020 16:47:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 27 Nov 2020 16:47:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/7] net: hns3: add support for TX hardware checksum offload
Date:   Fri, 27 Nov 2020 16:47:17 +0800
Message-ID: <1606466842-57749-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the device that supports TX hardware checksum, the hardware
can calculate the checksum from the start and fill the checksum
to the offset position, which reduces the operations of
calculating the type and header length of L3/L4. So add this
feature for the HNS3 ethernet driver.

The previous simple BD description is unsuitable, rename it as
HW TX CSUM.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  6 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  6 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 62 ++++++++++++++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 10 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  2 +-
 8 files changed, 74 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f6fac24..0632607 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -81,7 +81,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B,
 	HNAE3_DEV_SUPPORT_PTP_B,
 	HNAE3_DEV_SUPPORT_INT_QL_B,
-	HNAE3_DEV_SUPPORT_SIMPLE_BD_B,
+	HNAE3_DEV_SUPPORT_HW_TX_CSUM_B,
 	HNAE3_DEV_SUPPORT_TX_PUSH_B,
 	HNAE3_DEV_SUPPORT_PHY_IMP_B,
 	HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B,
@@ -113,8 +113,8 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_dev_int_ql_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, (hdev)->ae_dev->caps)
 
-#define hnae3_dev_simple_bd_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_SIMPLE_BD_B, (hdev)->ae_dev->caps)
+#define hnae3_dev_hw_csum_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, (hdev)->ae_dev->caps)
 
 #define hnae3_dev_tx_push_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index a5ebca8..044552d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -178,6 +178,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	u32 tx_index, rx_index;
 	u32 q_num, value;
 	dma_addr_t addr;
+	u16 mss_hw_csum;
 	int cnt;
 
 	cnt = sscanf(&cmd_buf[8], "%u %u", &q_num, &tx_index);
@@ -206,6 +207,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 
 	tx_desc = &ring->desc[tx_index];
 	addr = le64_to_cpu(tx_desc->addr);
+	mss_hw_csum = le16_to_cpu(tx_desc->tx.mss_hw_csum);
 	dev_info(dev, "TX Queue Num: %u, BD Index: %u\n", q_num, tx_index);
 	dev_info(dev, "(TX)addr: %pad\n", &addr);
 	dev_info(dev, "(TX)vlan_tag: %u\n", le16_to_cpu(tx_desc->tx.vlan_tag));
@@ -225,7 +227,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	dev_info(dev, "(TX)paylen: %u\n", le32_to_cpu(tx_desc->tx.paylen));
 	dev_info(dev, "(TX)vld_ra_ri: %u\n",
 		 le16_to_cpu(tx_desc->tx.bdtp_fe_sc_vld_ra_ri));
-	dev_info(dev, "(TX)mss: %u\n", le16_to_cpu(tx_desc->tx.mss));
+	dev_info(dev, "(TX)mss_hw_csum: %u\n", mss_hw_csum);
 
 	ring = &priv->ring[q_num + h->kinfo.num_tqps];
 	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_RX_RING_TAIL_REG);
@@ -324,6 +326,8 @@ static void hns3_dbg_dev_caps(struct hnae3_handle *h)
 		 test_bit(HNAE3_DEV_SUPPORT_PTP_B, caps) ? "yes" : "no");
 	dev_info(&h->pdev->dev, "support INT QL: %s\n",
 		 test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support HW TX csum: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, caps) ? "yes" : "no");
 }
 
 static void hns3_dbg_dev_specs(struct hnae3_handle *h)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5a706a3..e022bea 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1055,15 +1055,31 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 	return 0;
 }
 
+/* check if the hardware is capable of checksum offloading */
+static bool hns3_check_hw_tx_csum(struct sk_buff *skb)
+{
+	struct hns3_nic_priv *priv = netdev_priv(skb->dev);
+
+	/* Kindly note, due to backward compatibility of the TX descriptor,
+	 * HW checksum of the non-IP packets and GSO packets is handled at
+	 * different place in the following code
+	 */
+	if (skb->csum_not_inet || skb_is_gso(skb) ||
+	    !test_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state))
+		return false;
+
+	return true;
+}
+
 static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			      struct sk_buff *skb, struct hns3_desc *desc)
 {
 	u32 ol_type_vlan_len_msec = 0;
 	u32 type_cs_vlan_tso = 0;
 	u32 paylen = skb->len;
+	u16 mss_hw_csum = 0;
 	u16 inner_vtag = 0;
 	u16 out_vtag = 0;
-	u16 mss = 0;
 	int ret;
 
 	ret = hns3_handle_vtags(ring, skb);
@@ -1088,6 +1104,17 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 ol4_proto, il4_proto;
 
+		if (hns3_check_hw_tx_csum(skb)) {
+			/* set checksum start and offset, defined in 2 Bytes */
+			hns3_set_field(type_cs_vlan_tso, HNS3_TXD_CSUM_START_S,
+				       skb_checksum_start_offset(skb) >> 1);
+			hns3_set_field(ol_type_vlan_len_msec,
+				       HNS3_TXD_CSUM_OFFSET_S,
+				       skb->csum_offset >> 1);
+			mss_hw_csum |= BIT(HNS3_TXD_HW_CS_B);
+			goto out_hw_tx_csum;
+		}
+
 		skb_reset_mac_len(skb);
 
 		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
@@ -1108,7 +1135,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			return ret;
 		}
 
-		ret = hns3_set_tso(skb, &paylen, &mss,
+		ret = hns3_set_tso(skb, &paylen, &mss_hw_csum,
 				   &type_cs_vlan_tso);
 		if (unlikely(ret < 0)) {
 			u64_stats_update_begin(&ring->syncp);
@@ -1118,12 +1145,13 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 		}
 	}
 
+out_hw_tx_csum:
 	/* Set txbd */
 	desc->tx.ol_type_vlan_len_msec =
 		cpu_to_le32(ol_type_vlan_len_msec);
 	desc->tx.type_cs_vlan_tso_len = cpu_to_le32(type_cs_vlan_tso);
 	desc->tx.paylen = cpu_to_le32(paylen);
-	desc->tx.mss = cpu_to_le16(mss);
+	desc->tx.mss_hw_csum = cpu_to_le16(mss_hw_csum);
 	desc->tx.vlan_tag = cpu_to_le16(inner_vtag);
 	desc->tx.outer_vlan_tag = cpu_to_le16(out_vtag);
 
@@ -2326,8 +2354,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
+	netdev->hw_enc_features |= NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
@@ -2335,8 +2362,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
-	netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_HW_VLAN_CTAG_FILTER |
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
 		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
@@ -2344,16 +2370,15 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
 		NETIF_F_FRAGLIST;
 
-	netdev->vlan_features |=
-		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
+	netdev->vlan_features |= NETIF_F_RXCSUM |
 		NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO |
 		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
 		NETIF_F_FRAGLIST;
 
-	netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
+	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
+		NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
@@ -2376,6 +2401,18 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		netdev->vlan_features |= NETIF_F_GSO_UDP_L4;
 		netdev->hw_enc_features |= NETIF_F_GSO_UDP_L4;
 	}
+
+	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps)) {
+		netdev->hw_features |= NETIF_F_HW_CSUM;
+		netdev->features |= NETIF_F_HW_CSUM;
+		netdev->vlan_features |= NETIF_F_HW_CSUM;
+		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
+	} else {
+		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->vlan_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	}
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
@@ -4178,6 +4215,9 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	/* MTU range: (ETH_MIN_MTU(kernel default) - 9702) */
 	netdev->max_mtu = HNS3_MAX_MTU;
 
+	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
+		set_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state);
+
 	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
 
 	if (netif_msg_drv(handle))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 40681a0..5de00fb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -18,6 +18,7 @@ enum hns3_nic_state {
 	HNS3_NIC_STATE_SERVICE_INITED,
 	HNS3_NIC_STATE_SERVICE_SCHED,
 	HNS3_NIC_STATE2_RESET_REQUESTED,
+	HNS3_NIC_STATE_HW_TX_CSUM_ENABLE,
 	HNS3_NIC_STATE_MAX
 };
 
@@ -145,6 +146,9 @@ enum hns3_nic_state {
 #define HNS3_TXD_L4LEN_S			24
 #define HNS3_TXD_L4LEN_M			(0xff << HNS3_TXD_L4LEN_S)
 
+#define HNS3_TXD_CSUM_START_S		8
+#define HNS3_TXD_CSUM_START_M		(0xffff << HNS3_TXD_CSUM_START_S)
+
 #define HNS3_TXD_OL3T_S				0
 #define HNS3_TXD_OL3T_M				(0x3 << HNS3_TXD_OL3T_S)
 #define HNS3_TXD_OVLAN_B			2
@@ -152,6 +156,9 @@ enum hns3_nic_state {
 #define HNS3_TXD_TUNTYPE_S			4
 #define HNS3_TXD_TUNTYPE_M			(0xf << HNS3_TXD_TUNTYPE_S)
 
+#define HNS3_TXD_CSUM_OFFSET_S		8
+#define HNS3_TXD_CSUM_OFFSET_M		(0xffff << HNS3_TXD_CSUM_OFFSET_S)
+
 #define HNS3_TXD_BDTYPE_S			0
 #define HNS3_TXD_BDTYPE_M			(0xf << HNS3_TXD_BDTYPE_S)
 #define HNS3_TXD_FE_B				4
@@ -167,6 +174,7 @@ enum hns3_nic_state {
 
 #define HNS3_TXD_MSS_S				0
 #define HNS3_TXD_MSS_M				(0x3fff << HNS3_TXD_MSS_S)
+#define HNS3_TXD_HW_CS_B			14
 
 #define HNS3_VECTOR_TX_IRQ			BIT_ULL(0)
 #define HNS3_VECTOR_RX_IRQ			BIT_ULL(1)
@@ -258,7 +266,7 @@ struct __packed hns3_desc {
 
 			__le32 paylen;
 			__le16 bdtp_fe_sc_vld_ra_ri;
-			__le16 mss;
+			__le16 mss_hw_csum;
 		} tx;
 
 		struct {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index e6321dd..fbd90e6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -355,6 +355,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_INT_QL_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_TQP_TXRX_INDEP_B))
 		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_HW_TX_CSUM_B))
+		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
 }
 
 static enum hclge_cmd_status
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 6d7ba20..44f92bb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -376,7 +376,7 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_FD_FORWARD_TC_B,
 	HCLGE_CAP_PTP_B,
 	HCLGE_CAP_INT_QL_B,
-	HCLGE_CAP_SIMPLE_BD_B,
+	HCLGE_CAP_HW_TX_CSUM_B,
 	HCLGE_CAP_TX_PUSH_B,
 	HCLGE_CAP_PHY_IMP_B,
 	HCLGE_CAP_TQP_TXRX_INDEP_B,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 66866c1..a4e7024 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -336,6 +336,8 @@ static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_INT_QL_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGEVF_CAP_TQP_TXRX_INDEP_B))
 		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_HW_TX_CSUM_B))
+		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
 }
 
 static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 8b34a63..42a8190 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -152,7 +152,7 @@ enum HCLGEVF_CAP_BITS {
 	HCLGEVF_CAP_FD_FORWARD_TC_B,
 	HCLGEVF_CAP_PTP_B,
 	HCLGEVF_CAP_INT_QL_B,
-	HCLGEVF_CAP_SIMPLE_BD_B,
+	HCLGEVF_CAP_HW_TX_CSUM_B,
 	HCLGEVF_CAP_TX_PUSH_B,
 	HCLGEVF_CAP_PHY_IMP_B,
 	HCLGEVF_CAP_TQP_TXRX_INDEP_B,
-- 
2.7.4

