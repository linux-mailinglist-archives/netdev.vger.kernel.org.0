Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FE3828C
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbfFGCF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:05:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58474 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728170AbfFGCFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:05:22 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DD5AADDEFCBC988AB9CA;
        Fri,  7 Jun 2019 10:05:17 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 7 Jun 2019 10:05:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 03/12] net: hns3: make HW GRO handling compliant with SW GRO
Date:   Fri, 7 Jun 2019 10:03:04 +0800
Message-ID: <1559872993-14507-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
References: <1559872993-14507-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently when a GRO packet is assembled by HW, the checksum is
modified to reflect the entire packet by HW and skb->ip_summed is
set to CHECKSUM_UNNECESSARY, which is not compliant with SW GRO.

This patch sets up skb's network and transport header, sets the
GRO packet's checksum according to pseudo header and set the
skb->ip_summed to CHECKSUM_PARTIAL.

This patch also use gso_size to distinguish GRO packet from
normal packet, use eth_type_vlan to check the VLAN type and set
the SKB_GSO_TCP_FIXEDID according to BD info during HW GRO info
processing.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 44 +++++++++++++++++--------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0501b78..c37509e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -17,6 +17,7 @@
 #include <linux/sctp.h>
 #include <linux/vermagic.h>
 #include <net/gre.h>
+#include <net/ip6_checksum.h>
 #include <net/pkt_cls.h>
 #include <net/tcp.h>
 #include <net/vxlan.h>
@@ -2384,13 +2385,13 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	}
 }
 
-static int hns3_gro_complete(struct sk_buff *skb)
+static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 {
 	__be16 type = skb->protocol;
 	struct tcphdr *th;
 	int depth = 0;
 
-	while (type == htons(ETH_P_8021Q)) {
+	while (eth_type_vlan(type)) {
 		struct vlan_hdr *vh;
 
 		if ((depth + VLAN_HLEN) > skb_headlen(skb))
@@ -2401,10 +2402,24 @@ static int hns3_gro_complete(struct sk_buff *skb)
 		depth += VLAN_HLEN;
 	}
 
+	skb_set_network_header(skb, depth);
+
 	if (type == htons(ETH_P_IP)) {
+		const struct iphdr *iph = ip_hdr(skb);
+
 		depth += sizeof(struct iphdr);
+		skb_set_transport_header(skb, depth);
+		th = tcp_hdr(skb);
+		th->check = ~tcp_v4_check(skb->len - depth, iph->saddr,
+					  iph->daddr, 0);
 	} else if (type == htons(ETH_P_IPV6)) {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+
 		depth += sizeof(struct ipv6hdr);
+		skb_set_transport_header(skb, depth);
+		th = tcp_hdr(skb);
+		th->check = ~tcp_v6_check(skb->len - depth, &iph->saddr,
+					  &iph->daddr, 0);
 	} else {
 		netdev_err(skb->dev,
 			   "Error: FW GRO supports only IPv4/IPv6, not 0x%04x, depth: %d\n",
@@ -2412,13 +2427,16 @@ static int hns3_gro_complete(struct sk_buff *skb)
 		return -EFAULT;
 	}
 
-	th = (struct tcphdr *)(skb->data + depth);
 	skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
 	if (th->cwr)
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
 
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	if (l234info & BIT(HNS3_RXD_GRO_FIXID_B))
+		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID;
 
+	skb->csum_start = (unsigned char *)th - skb->head;
+	skb->csum_offset = offsetof(struct tcphdr, check);
+	skb->ip_summed = CHECKSUM_PARTIAL;
 	return 0;
 }
 
@@ -2656,18 +2674,20 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 				     struct sk_buff *skb, u32 l234info,
 				     u32 bd_base_info, u32 ol_info)
 {
-	u16 gro_count;
 	u32 l3_type;
 
-	gro_count = hnae3_get_field(l234info, HNS3_RXD_GRO_COUNT_M,
-				    HNS3_RXD_GRO_COUNT_S);
+	skb_shinfo(skb)->gso_size = hnae3_get_field(bd_base_info,
+						    HNS3_RXD_GRO_SIZE_M,
+						    HNS3_RXD_GRO_SIZE_S);
 	/* if there is no HW GRO, do not set gro params */
-	if (!gro_count) {
+	if (!skb_shinfo(skb)->gso_size) {
 		hns3_rx_checksum(ring, skb, l234info, bd_base_info, ol_info);
 		return 0;
 	}
 
-	NAPI_GRO_CB(skb)->count = gro_count;
+	NAPI_GRO_CB(skb)->count = hnae3_get_field(l234info,
+						  HNS3_RXD_GRO_COUNT_M,
+						  HNS3_RXD_GRO_COUNT_S);
 
 	l3_type = hnae3_get_field(l234info, HNS3_RXD_L3ID_M,
 				  HNS3_RXD_L3ID_S);
@@ -2678,11 +2698,7 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 	else
 		return -EFAULT;
 
-	skb_shinfo(skb)->gso_size = hnae3_get_field(bd_base_info,
-						    HNS3_RXD_GRO_SIZE_M,
-						    HNS3_RXD_GRO_SIZE_S);
-
-	return  hns3_gro_complete(skb);
+	return  hns3_gro_complete(skb, l234info);
 }
 
 static void hns3_set_rx_skb_rss_type(struct hns3_enet_ring *ring,
-- 
2.7.4

