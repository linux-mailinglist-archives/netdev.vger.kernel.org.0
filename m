Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A870A268C89
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgINNt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:49:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726749AbgINNs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 09:48:27 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A6888F9F7507770BC7B9;
        Mon, 14 Sep 2020 21:47:12 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 21:47:04 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <zengweiliang.zengweiliang@huawei.com>
Subject: [PATCH net-next] hinic: add vxlan segmentation and cs offload support
Date:   Mon, 14 Sep 2020 21:48:23 +0800
Message-ID: <20200914134823.8243-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NETIF_F_GSO_UDP_TUNNEL and NETIF_F_GSO_UDP_TUNNEL_CSUM features
to support vxlan segmentation and checksum offload. Ipip and ipv6
tunnel packets are regarded as non-tunnel pkt for hw and as for other
type of tunnel pkts, checksum offload is disabled.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_main.c    |  7 ++-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  | 51 +++++++++++++++----
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 797c55a1d9c6..2c63e3a690cd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -929,11 +929,16 @@ static void netdev_features_init(struct net_device *netdev)
 	netdev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
 			      NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
 			      NETIF_F_RXCSUM | NETIF_F_LRO |
-			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
+			      NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
 	netdev->vlan_features = netdev->hw_features;
 
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+
+	netdev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
+				  NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
+				  NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL;
 }
 
 static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index a97498ee6914..502f00e1e2d0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -357,6 +357,7 @@ static int offload_csum(struct hinic_sq_task *task, u32 *queue_info,
 	enum hinic_l4_offload_type l4_offload;
 	u32 offset, l4_len, network_hdr_len;
 	enum hinic_l3_offload_type l3_type;
+	u32 tunnel_type = NOT_TUNNEL;
 	union hinic_l3 ip;
 	union hinic_l4 l4;
 	u8 l4_proto;
@@ -367,27 +368,55 @@ static int offload_csum(struct hinic_sq_task *task, u32 *queue_info,
 	if (skb->encapsulation) {
 		u32 l4_tunnel_len;
 
+		tunnel_type = TUNNEL_UDP_NO_CSUM;
 		ip.hdr = skb_network_header(skb);
 
-		if (ip.v4->version == 4)
+		if (ip.v4->version == 4) {
 			l3_type = IPV4_PKT_NO_CHKSUM_OFFLOAD;
-		else if (ip.v4->version == 6)
+			l4_proto = ip.v4->protocol;
+		} else if (ip.v4->version == 6) {
+			unsigned char *exthdr;
+			__be16 frag_off;
 			l3_type = IPV6_PKT;
-		else
+			tunnel_type = TUNNEL_UDP_CSUM;
+			exthdr = ip.hdr + sizeof(*ip.v6);
+			l4_proto = ip.v6->nexthdr;
+			l4.hdr = skb_transport_header(skb);
+			if (l4.hdr != exthdr)
+				ipv6_skip_exthdr(skb, exthdr - skb->data,
+						 &l4_proto, &frag_off);
+		} else {
 			l3_type = L3TYPE_UNKNOWN;
+			l4_proto = IPPROTO_RAW;
+		}
 
 		hinic_task_set_outter_l3(task, l3_type,
 					 skb_network_header_len(skb));
 
-		l4_tunnel_len = skb_inner_network_offset(skb) -
-				skb_transport_offset(skb);
-
-		hinic_task_set_tunnel_l4(task, TUNNEL_UDP_NO_CSUM,
-					 l4_tunnel_len);
+		switch (l4_proto) {
+		case IPPROTO_UDP:
+			l4_tunnel_len = skb_inner_network_offset(skb) -
+					skb_transport_offset(skb);
+			ip.hdr = skb_inner_network_header(skb);
+			l4.hdr = skb_inner_transport_header(skb);
+			network_hdr_len = skb_inner_network_header_len(skb);
+			break;
+		case IPPROTO_IPIP:
+		case IPPROTO_IPV6:
+			tunnel_type = NOT_TUNNEL;
+			l4_tunnel_len = 0;
+
+			ip.hdr = skb_inner_network_header(skb);
+			l4.hdr = skb_transport_header(skb);
+			network_hdr_len = skb_network_header_len(skb);
+			break;
+		default:
+			/* Unsupported tunnel packet, disable csum offload */
+			skb_checksum_help(skb);
+			return 0;
+		}
 
-		ip.hdr = skb_inner_network_header(skb);
-		l4.hdr = skb_inner_transport_header(skb);
-		network_hdr_len = skb_inner_network_header_len(skb);
+		hinic_task_set_tunnel_l4(task, tunnel_type, l4_tunnel_len);
 	} else {
 		ip.hdr = skb_network_header(skb);
 		l4.hdr = skb_transport_header(skb);
-- 
2.17.1

