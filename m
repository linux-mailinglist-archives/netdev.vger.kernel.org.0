Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FBE380275
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhEND0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3672 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhEND0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB1x2qz1BMPj;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: refactor out RX completion checksum
Date:   Fri, 14 May 2021 11:25:10 +0800
Message-ID: <1620962720-62216-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
References: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only when RXD advanced layout is enabled, in some cases
(e.g. ip fragments), the checksum of entire packet will be
calculated and filled in the least significant 16 bits of
the unused addr field.

So refactor out the handling of RX completion checksum: adjust
the location of the checksum in RX descriptor, and use ptype table
to identify whether this kind of checksum is calculated.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 10 -------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 32 ++++++++++++----------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    | 12 ++++----
 3 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index e58a2c1..e405fef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -260,16 +260,6 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	dev_info(dev, "(RX)addr: %pad\n", &addr);
 	dev_info(dev, "(RX)l234_info: %u\n", l234info);
 
-	if (l234info & BIT(HNS3_RXD_L2_CSUM_B)) {
-		u32 lo, hi;
-
-		lo = hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_L_M,
-				     HNS3_RXD_L2_CSUM_L_S);
-		hi = hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_H_M,
-				     HNS3_RXD_L2_CSUM_H_S);
-		dev_info(dev, "(RX)csum: %u\n", lo | hi << 8);
-	}
-
 	dev_info(dev, "(RX)pkt_len: %u\n", le16_to_cpu(rx_desc->rx.pkt_len));
 	dev_info(dev, "(RX)size: %u\n", le16_to_cpu(rx_desc->rx.size));
 	dev_info(dev, "(RX)rss_hash: %u\n", le32_to_cpu(rx_desc->rx.rss_hash));
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 712a6db..5826d86 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3252,20 +3252,20 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 	return 0;
 }
 
-static void hns3_checksum_complete(struct hns3_enet_ring *ring,
-				   struct sk_buff *skb, u32 l234info)
+static bool hns3_checksum_complete(struct hns3_enet_ring *ring,
+				   struct sk_buff *skb, u32 ptype, u16 csum)
 {
-	u32 lo, hi;
+	if (ptype == HNS3_INVALID_PTYPE ||
+	    hns3_rx_ptype_tbl[ptype].ip_summed != CHECKSUM_COMPLETE)
+		return false;
 
 	u64_stats_update_begin(&ring->syncp);
 	ring->stats.csum_complete++;
 	u64_stats_update_end(&ring->syncp);
 	skb->ip_summed = CHECKSUM_COMPLETE;
-	lo = hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_L_M,
-			     HNS3_RXD_L2_CSUM_L_S);
-	hi = hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_H_M,
-			     HNS3_RXD_L2_CSUM_H_S);
-	skb->csum = csum_unfold((__force __sum16)(lo | hi << 8));
+	skb->csum = csum_unfold((__force __sum16)csum);
+
+	return true;
 }
 
 static void hns3_rx_handle_csum(struct sk_buff *skb, u32 l234info,
@@ -3307,7 +3307,8 @@ static void hns3_rx_handle_csum(struct sk_buff *skb, u32 l234info,
 }
 
 static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
-			     u32 l234info, u32 bd_base_info, u32 ol_info)
+			     u32 l234info, u32 bd_base_info, u32 ol_info,
+			     u16 csum)
 {
 	struct net_device *netdev = ring_to_netdev(ring);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -3324,10 +3325,8 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 		ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
 					HNS3_RXD_PTYPE_S);
 
-	if (l234info & BIT(HNS3_RXD_L2_CSUM_B)) {
-		hns3_checksum_complete(ring, skb, l234info);
+	if (hns3_checksum_complete(ring, skb, ptype, csum))
 		return;
-	}
 
 	/* check if hardware has done checksum */
 	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
@@ -3527,7 +3526,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
 
 static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 				     struct sk_buff *skb, u32 l234info,
-				     u32 bd_base_info, u32 ol_info)
+				     u32 bd_base_info, u32 ol_info, u16 csum)
 {
 	struct net_device *netdev = ring_to_netdev(ring);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -3538,7 +3537,8 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 						    HNS3_RXD_GRO_SIZE_S);
 	/* if there is no HW GRO, do not set gro params */
 	if (!skb_shinfo(skb)->gso_size) {
-		hns3_rx_checksum(ring, skb, l234info, bd_base_info, ol_info);
+		hns3_rx_checksum(ring, skb, l234info, bd_base_info, ol_info,
+				 csum);
 		return 0;
 	}
 
@@ -3588,6 +3588,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	struct hns3_desc *desc;
 	unsigned int len;
 	int pre_ntc, ret;
+	u16 csum;
 
 	/* bdinfo handled below is only valid on the last BD of the
 	 * current packet, and ring->next_to_clean indicates the first
@@ -3599,6 +3600,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	bd_base_info = le32_to_cpu(desc->rx.bd_base_info);
 	l234info = le32_to_cpu(desc->rx.l234_info);
 	ol_info = le32_to_cpu(desc->rx.ol_info);
+	csum = le16_to_cpu(desc->csum);
 
 	/* Based on hw strategy, the tag offloaded will be stored at
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
@@ -3631,7 +3633,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 
 	/* This is needed in order to enable forwarding support */
 	ret = hns3_set_gro_and_checksum(ring, skb, l234info,
-					bd_base_info, ol_info);
+					bd_base_info, ol_info, csum);
 	if (unlikely(ret)) {
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.rx_err_cnt++;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 843642b..c9aebda 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -83,12 +83,6 @@ enum hns3_nic_state {
 #define HNS3_RXD_STRP_TAGP_S			13
 #define HNS3_RXD_STRP_TAGP_M			(0x3 << HNS3_RXD_STRP_TAGP_S)
 
-#define HNS3_RXD_L2_CSUM_B			15
-#define HNS3_RXD_L2_CSUM_L_S			4
-#define HNS3_RXD_L2_CSUM_L_M			(0xff << HNS3_RXD_L2_CSUM_L_S)
-#define HNS3_RXD_L2_CSUM_H_S			24
-#define HNS3_RXD_L2_CSUM_H_M			(0xff << HNS3_RXD_L2_CSUM_H_S)
-
 #define HNS3_RXD_L2E_B				16
 #define HNS3_RXD_L3E_B				17
 #define HNS3_RXD_L4E_B				18
@@ -242,7 +236,10 @@ enum hns3_pkt_tun_type {
 
 /* hardware spec ring buffer format */
 struct __packed hns3_desc {
-	__le64 addr;
+	union {
+		__le64 addr;
+		__le16 csum;
+	};
 	union {
 		struct {
 			__le16 vlan_tag;
@@ -409,6 +406,7 @@ struct ring_stats {
 			u64 rx_multicast;
 			u64 non_reuse_pg;
 		};
+		__le16 csum;
 	};
 };
 
-- 
2.7.4

