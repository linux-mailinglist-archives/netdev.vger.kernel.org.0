Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BDC14395
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfEFCuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7166 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbfEFCuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:23 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AEB28BD8126886C23700;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: combine len and checksum handling for inner and outer header.
Date:   Mon, 6 May 2019 10:48:47 +0800
Message-ID: <1557110932-683-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
References: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

When filling len and checksum info to description, there is some
similar checking or calculation.

So this patch adds hns3_set_l2l3l4 to fill the inner(/normal)
header's len and checksum info. If it is a encapsulation skb, it
calls hns3_set_outer_l2l3l4 to handle the outer header's len and
checksum info, in order to avoid some similar checking or
calculation.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 192 ++++++++++--------------
 1 file changed, 81 insertions(+), 111 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9170743..7224b38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -737,79 +737,6 @@ static int hns3_get_l4_protocol(struct sk_buff *skb, u8 *ol4_proto,
 	return 0;
 }
 
-static void hns3_set_l2l3l4_len(struct sk_buff *skb, u8 ol4_proto,
-				u8 il4_proto, u32 *type_cs_vlan_tso,
-				u32 *ol_type_vlan_len_msec)
-{
-	unsigned char *l2_hdr = skb->data;
-	u8 l4_proto = ol4_proto;
-	union l3_hdr_info l3;
-	union l4_hdr_info l4;
-	u32 l2_len;
-	u32 l3_len;
-	u32 l4_len;
-
-	l3.hdr = skb_network_header(skb);
-	l4.hdr = skb_transport_header(skb);
-
-	/* tunnel packet */
-	if (skb->encapsulation) {
-		/* not MAC in UDP, MAC in GRE (0x6558) */
-		if (!(ol4_proto == IPPROTO_UDP || ol4_proto == IPPROTO_GRE))
-			return;
-
-		/* compute OL2 header size, defined in 2 Bytes */
-		l2_len = l3.hdr - skb->data;
-		hns3_set_field(*ol_type_vlan_len_msec,
-			       HNS3_TXD_L2LEN_S, l2_len >> 1);
-
-		/* compute OL3 header size, defined in 4 Bytes */
-		l3_len = l4.hdr - l3.hdr;
-		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L3LEN_S,
-			       l3_len >> 2);
-
-		l2_hdr = skb_inner_mac_header(skb);
-		/* compute OL4 header size, defined in 4 Bytes. */
-		l4_len = l2_hdr - l4.hdr;
-		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L4LEN_S,
-			       l4_len >> 2);
-
-		/* switch to inner header */
-		l2_hdr = skb_inner_mac_header(skb);
-		l3.hdr = skb_inner_network_header(skb);
-		l4.hdr = skb_inner_transport_header(skb);
-		l4_proto = il4_proto;
-	}
-
-	l2_len = l3.hdr - l2_hdr;
-	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L2LEN_S, l2_len >> 1);
-
-	/* compute inner(/normal) L3 header size, defined in 4 Bytes */
-	l3_len = l4.hdr - l3.hdr;
-	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3LEN_S, l3_len >> 2);
-
-	/* compute inner(/normal) L4 header size, defined in 4 Bytes */
-	switch (l4_proto) {
-	case IPPROTO_TCP:
-		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4LEN_S,
-			       l4.tcp->doff);
-		break;
-	case IPPROTO_SCTP:
-		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4LEN_S,
-			       (sizeof(struct sctphdr) >> 2));
-		break;
-	case IPPROTO_UDP:
-		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4LEN_S,
-			       (sizeof(struct udphdr) >> 2));
-		break;
-	default:
-		/* skb packet types not supported by hardware,
-		 * txbd len fild doesn't be filled.
-		 */
-		return;
-	}
-}
-
 /* when skb->encapsulation is 0, skb->ip_summed is CHECKSUM_PARTIAL
  * and it is udp packet, which has a dest port as the IANA assigned.
  * the hardware is expected to do the checksum offload, but the
@@ -831,46 +758,71 @@ static bool hns3_tunnel_csum_bug(struct sk_buff *skb)
 	return true;
 }
 
-static int hns3_set_l3l4_type_csum(struct sk_buff *skb, u8 ol4_proto,
-				   u8 il4_proto, u32 *type_cs_vlan_tso,
-				   u32 *ol_type_vlan_len_msec)
+static void hns3_set_outer_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
+				  u32 *ol_type_vlan_len_msec)
 {
+	u32 l2_len, l3_len, l4_len;
+	unsigned char *il2_hdr;
 	union l3_hdr_info l3;
-	u32 l4_proto = ol4_proto;
+	union l4_hdr_info l4;
 
 	l3.hdr = skb_network_header(skb);
+	l4.hdr = skb_transport_header(skb);
 
-	/* define OL3 type and tunnel type(OL4).*/
-	if (skb->encapsulation) {
-		/* define outer network header type.*/
-		if (skb->protocol == htons(ETH_P_IP)) {
-			if (skb_is_gso(skb))
-				hns3_set_field(*ol_type_vlan_len_msec,
-					       HNS3_TXD_OL3T_S,
-					       HNS3_OL3T_IPV4_CSUM);
-			else
-				hns3_set_field(*ol_type_vlan_len_msec,
-					       HNS3_TXD_OL3T_S,
-					       HNS3_OL3T_IPV4_NO_CSUM);
-
-		} else if (skb->protocol == htons(ETH_P_IPV6)) {
-			hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_OL3T_S,
-				       HNS3_OL3T_IPV6);
-		}
+	/* compute OL2 header size, defined in 2 Bytes */
+	l2_len = l3.hdr - skb->data;
+	hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L2LEN_S, l2_len >> 1);
+
+	/* compute OL3 header size, defined in 4 Bytes */
+	l3_len = l4.hdr - l3.hdr;
+	hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L3LEN_S, l3_len >> 2);
 
-		/* define tunnel type(OL4).*/
-		switch (l4_proto) {
-		case IPPROTO_UDP:
+	il2_hdr = skb_inner_mac_header(skb);
+	/* compute OL4 header size, defined in 4 Bytes. */
+	l4_len = il2_hdr - l4.hdr;
+	hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L4LEN_S, l4_len >> 2);
+
+	/* define outer network header type */
+	if (skb->protocol == htons(ETH_P_IP)) {
+		if (skb_is_gso(skb))
 			hns3_set_field(*ol_type_vlan_len_msec,
-				       HNS3_TXD_TUNTYPE_S,
-				       HNS3_TUN_MAC_IN_UDP);
-			break;
-		case IPPROTO_GRE:
+				       HNS3_TXD_OL3T_S,
+				       HNS3_OL3T_IPV4_CSUM);
+		else
 			hns3_set_field(*ol_type_vlan_len_msec,
-				       HNS3_TXD_TUNTYPE_S,
-				       HNS3_TUN_NVGRE);
-			break;
-		default:
+				       HNS3_TXD_OL3T_S,
+				       HNS3_OL3T_IPV4_NO_CSUM);
+
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_OL3T_S,
+			       HNS3_OL3T_IPV6);
+	}
+
+	if (ol4_proto == IPPROTO_UDP)
+		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_TUNTYPE_S,
+			       HNS3_TUN_MAC_IN_UDP);
+	else if (ol4_proto == IPPROTO_GRE)
+		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_TUNTYPE_S,
+			       HNS3_TUN_NVGRE);
+}
+
+static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
+			   u8 il4_proto, u32 *type_cs_vlan_tso,
+			   u32 *ol_type_vlan_len_msec)
+{
+	unsigned char *l2_hdr = l2_hdr = skb->data;
+	u32 l4_proto = ol4_proto;
+	union l4_hdr_info l4;
+	union l3_hdr_info l3;
+	u32 l2_len, l3_len;
+
+	l4.hdr = skb_transport_header(skb);
+	l3.hdr = skb_network_header(skb);
+
+	/* handle encapsulation skb */
+	if (skb->encapsulation) {
+		/* If this is a not UDP/GRE encapsulation skb */
+		if (!(ol4_proto == IPPROTO_UDP || ol4_proto == IPPROTO_GRE)) {
 			/* drop the skb tunnel packet if hardware don't support,
 			 * because hardware can't calculate csum when TSO.
 			 */
@@ -884,7 +836,12 @@ static int hns3_set_l3l4_type_csum(struct sk_buff *skb, u8 ol4_proto,
 			return 0;
 		}
 
+		hns3_set_outer_l2l3l4(skb, ol4_proto, ol_type_vlan_len_msec);
+
+		/* switch to inner header */
+		l2_hdr = skb_inner_mac_header(skb);
 		l3.hdr = skb_inner_network_header(skb);
+		l4.hdr = skb_inner_transport_header(skb);
 		l4_proto = il4_proto;
 	}
 
@@ -902,11 +859,22 @@ static int hns3_set_l3l4_type_csum(struct sk_buff *skb, u8 ol4_proto,
 			       HNS3_L3T_IPV6);
 	}
 
+	/* compute inner(/normal) L2 header size, defined in 2 Bytes */
+	l2_len = l3.hdr - l2_hdr;
+	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L2LEN_S, l2_len >> 1);
+
+	/* compute inner(/normal) L3 header size, defined in 4 Bytes */
+	l3_len = l4.hdr - l3.hdr;
+	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3LEN_S, l3_len >> 2);
+
+	/* compute inner(/normal) L4 header size, defined in 4 Bytes */
 	switch (l4_proto) {
 	case IPPROTO_TCP:
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4T_S,
 			       HNS3_L4T_TCP);
+		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4LEN_S,
+			       l4.tcp->doff);
 		break;
 	case IPPROTO_UDP:
 		if (hns3_tunnel_csum_bug(skb))
@@ -915,11 +883,15 @@ static int hns3_set_l3l4_type_csum(struct sk_buff *skb, u8 ol4_proto,
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4T_S,
 			       HNS3_L4T_UDP);
+		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4LEN_S,
+			       (sizeof(struct udphdr) >> 2));
 		break;
 	case IPPROTO_SCTP:
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4T_S,
 			       HNS3_L4T_SCTP);
+		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4LEN_S,
+			       (sizeof(struct sctphdr) >> 2));
 		break;
 	default:
 		/* drop the skb tunnel packet if hardware don't support,
@@ -1050,12 +1022,10 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 			ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
 			if (unlikely(ret))
 				return ret;
-			hns3_set_l2l3l4_len(skb, ol4_proto, il4_proto,
-					    &type_cs_vlan_tso,
-					    &ol_type_vlan_len_msec);
-			ret = hns3_set_l3l4_type_csum(skb, ol4_proto, il4_proto,
-						      &type_cs_vlan_tso,
-						      &ol_type_vlan_len_msec);
+
+			ret = hns3_set_l2l3l4(skb, ol4_proto, il4_proto,
+					      &type_cs_vlan_tso,
+					      &ol_type_vlan_len_msec);
 			if (unlikely(ret))
 				return ret;
 
-- 
2.7.4

