Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5219E2C7050
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 19:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbgK1Rzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 12:55:51 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8452 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731732AbgK1ENA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 23:13:00 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CjcxS3JgbzhhYq;
        Sat, 28 Nov 2020 11:51:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 11:51:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 4/7] net: hns3: add udp tunnel checksum segmentation support
Date:   Sat, 28 Nov 2020 11:51:47 +0800
Message-ID: <1606535510-44346-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
References: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the device who has the capability to handle udp tunnel
checksum segmentation, add support for it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 24 ++++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  4 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  1 +
 8 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 0632607..78b4886 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -87,6 +87,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B,
 	HNAE3_DEV_SUPPORT_HW_PAD_B,
 	HNAE3_DEV_SUPPORT_STASH_B,
+	HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B,
 };
 
 #define hnae3_dev_fd_supported(hdev) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 044552d..cb0cc6d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -224,7 +224,8 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	dev_info(dev, "(TX)ol2_len: %u\n", tx_desc->tx.ol2_len);
 	dev_info(dev, "(TX)ol3_len: %u\n", tx_desc->tx.ol3_len);
 	dev_info(dev, "(TX)ol4_len: %u\n", tx_desc->tx.ol4_len);
-	dev_info(dev, "(TX)paylen: %u\n", le32_to_cpu(tx_desc->tx.paylen));
+	dev_info(dev, "(TX)paylen_ol4cs: %u\n",
+		 le32_to_cpu(tx_desc->tx.paylen_ol4cs));
 	dev_info(dev, "(TX)vld_ra_ri: %u\n",
 		 le16_to_cpu(tx_desc->tx.bdtp_fe_sc_vld_ra_ri));
 	dev_info(dev, "(TX)mss_hw_csum: %u\n", mss_hw_csum);
@@ -328,6 +329,9 @@ static void hns3_dbg_dev_caps(struct hnae3_handle *h)
 		 test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, caps) ? "yes" : "no");
 	dev_info(&h->pdev->dev, "support HW TX csum: %s\n",
 		 test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, caps) ? "yes" : "no");
+	dev_info(&h->pdev->dev, "support UDP tunnel csum: %s\n",
+		 test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, caps) ?
+		 "yes" : "no");
 }
 
 static void hns3_dbg_dev_specs(struct hnae3_handle *h)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 34b8a7d..3ad7f98 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -695,7 +695,7 @@ void hns3_enable_vlan_filter(struct net_device *netdev, bool enable)
 	}
 }
 
-static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
+static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
 			u16 *mss, u32 *type_cs_vlan_tso)
 {
 	u32 l4_offset, hdr_len;
@@ -723,7 +723,8 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 	/* tunnel packet */
 	if (skb_shinfo(skb)->gso_type & (SKB_GSO_GRE |
 					 SKB_GSO_GRE_CSUM |
-					 SKB_GSO_UDP_TUNNEL)) {
+					 SKB_GSO_UDP_TUNNEL |
+					 SKB_GSO_UDP_TUNNEL_CSUM)) {
 		/* reset l3&l4 pointers from outer to inner headers */
 		l3.hdr = skb_inner_network_header(skb);
 		l4.hdr = skb_inner_transport_header(skb);
@@ -752,9 +753,13 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 	}
 
 	/* find the txbd field values */
-	*paylen = skb->len - hdr_len;
+	*paylen_fdop_ol4cs = skb->len - hdr_len;
 	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_TSO_B, 1);
 
+	/* offload outer UDP header checksum */
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)
+		hns3_set_field(*paylen_fdop_ol4cs, HNS3_TXD_OL4CS_B, 1);
+
 	/* get MSS for TSO */
 	*mss = skb_shinfo(skb)->gso_size;
 
@@ -1065,8 +1070,8 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			      struct sk_buff *skb, struct hns3_desc *desc)
 {
 	u32 ol_type_vlan_len_msec = 0;
+	u32 paylen_ol4cs = skb->len;
 	u32 type_cs_vlan_tso = 0;
-	u32 paylen = skb->len;
 	u16 mss_hw_csum = 0;
 	u16 inner_vtag = 0;
 	u16 out_vtag = 0;
@@ -1125,7 +1130,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			return ret;
 		}
 
-		ret = hns3_set_tso(skb, &paylen, &mss_hw_csum,
+		ret = hns3_set_tso(skb, &paylen_ol4cs, &mss_hw_csum,
 				   &type_cs_vlan_tso);
 		if (unlikely(ret < 0)) {
 			u64_stats_update_begin(&ring->syncp);
@@ -1140,7 +1145,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 	desc->tx.ol_type_vlan_len_msec =
 		cpu_to_le32(ol_type_vlan_len_msec);
 	desc->tx.type_cs_vlan_tso_len = cpu_to_le32(type_cs_vlan_tso);
-	desc->tx.paylen = cpu_to_le32(paylen);
+	desc->tx.paylen_ol4cs = cpu_to_le32(paylen_ol4cs);
 	desc->tx.mss_hw_csum = cpu_to_le16(mss_hw_csum);
 	desc->tx.vlan_tag = cpu_to_le16(inner_vtag);
 	desc->tx.outer_vlan_tag = cpu_to_le16(out_vtag);
@@ -2399,6 +2404,13 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		netdev->vlan_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 		netdev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	}
+
+	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps)) {
+		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	}
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 5de00fb..0a7b606 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -172,6 +172,8 @@ enum hns3_nic_state {
 #define HNS3_TXD_DECTTL_S			12
 #define HNS3_TXD_DECTTL_M			(0xf << HNS3_TXD_DECTTL_S)
 
+#define HNS3_TXD_OL4CS_B			22
+
 #define HNS3_TXD_MSS_S				0
 #define HNS3_TXD_MSS_M				(0x3fff << HNS3_TXD_MSS_S)
 #define HNS3_TXD_HW_CS_B			14
@@ -264,7 +266,7 @@ struct __packed hns3_desc {
 			};
 		};
 
-			__le32 paylen;
+			__le32 paylen_ol4cs;
 			__le16 bdtp_fe_sc_vld_ra_ri;
 			__le16 mss_hw_csum;
 		} tx;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index fbd90e6..85986c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -357,6 +357,8 @@ static void hclge_parse_capability(struct hclge_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGE_CAP_HW_TX_CSUM_B))
 		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGE_CAP_UDP_TUNNEL_CSUM_B))
+		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
 }
 
 static enum hclge_cmd_status
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 44f92bb..49cbd95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -382,6 +382,7 @@ enum HCLGE_CAP_BITS {
 	HCLGE_CAP_TQP_TXRX_INDEP_B,
 	HCLGE_CAP_HW_PAD_B,
 	HCLGE_CAP_STASH_B,
+	HCLGE_CAP_UDP_TUNNEL_CSUM_B,
 };
 
 #define HCLGE_QUERY_CAP_LENGTH		3
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index a4e7024..e04c0cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -338,6 +338,8 @@ static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGEVF_CAP_HW_TX_CSUM_B))
 		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_UDP_TUNNEL_CSUM_B))
+		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
 }
 
 static int hclgevf_cmd_query_version_and_capability(struct hclgevf_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 42a8190..82eed25 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -158,6 +158,7 @@ enum HCLGEVF_CAP_BITS {
 	HCLGEVF_CAP_TQP_TXRX_INDEP_B,
 	HCLGEVF_CAP_HW_PAD_B,
 	HCLGEVF_CAP_STASH_B,
+	HCLGEVF_CAP_UDP_TUNNEL_CSUM_B,
 };
 
 #define HCLGEVF_QUERY_CAP_LENGTH		3
-- 
2.7.4

