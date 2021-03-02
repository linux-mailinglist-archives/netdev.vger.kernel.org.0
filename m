Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B240632A354
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382099AbhCBIzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:55:33 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13408 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835943AbhCBG3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:29:04 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DqRwL1RSRzjTLh;
        Tue,  2 Mar 2021 14:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 14:27:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 2/9] net: hns3: refactor out hclge_fd_get_tuple()
Date:   Tue, 2 Mar 2021 14:27:48 +0800
Message-ID: <1614666475-13059-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
References: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

The process of function hclge_fd_get_tuple() is complex and
prolix. To make it more readable, extract the process of each
flow-type tuple to a single function.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 220 +++++++++++----------
 1 file changed, 117 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3491698..8d313d5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5789,144 +5789,158 @@ static int hclge_fd_update_rule_list(struct hclge_dev *hdev,
 	return 0;
 }
 
-static int hclge_fd_get_tuple(struct hclge_dev *hdev,
-			      struct ethtool_rx_flow_spec *fs,
-			      struct hclge_fd_rule *rule)
+static void hclge_fd_get_tcpip4_tuple(struct hclge_dev *hdev,
+				      struct ethtool_rx_flow_spec *fs,
+				      struct hclge_fd_rule *rule, u8 ip_proto)
 {
-	u32 flow_type = fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
+	rule->tuples.src_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->h_u.tcp_ip4_spec.ip4src);
+	rule->tuples_mask.src_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->m_u.tcp_ip4_spec.ip4src);
 
-	switch (flow_type) {
-	case SCTP_V4_FLOW:
-	case TCP_V4_FLOW:
-	case UDP_V4_FLOW:
-		rule->tuples.src_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->h_u.tcp_ip4_spec.ip4src);
-		rule->tuples_mask.src_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->m_u.tcp_ip4_spec.ip4src);
+	rule->tuples.dst_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->h_u.tcp_ip4_spec.ip4dst);
+	rule->tuples_mask.dst_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->m_u.tcp_ip4_spec.ip4dst);
 
-		rule->tuples.dst_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->h_u.tcp_ip4_spec.ip4dst);
-		rule->tuples_mask.dst_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->m_u.tcp_ip4_spec.ip4dst);
+	rule->tuples.src_port = be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc);
+	rule->tuples_mask.src_port = be16_to_cpu(fs->m_u.tcp_ip4_spec.psrc);
 
-		rule->tuples.src_port = be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc);
-		rule->tuples_mask.src_port =
-				be16_to_cpu(fs->m_u.tcp_ip4_spec.psrc);
+	rule->tuples.dst_port = be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst);
+	rule->tuples_mask.dst_port = be16_to_cpu(fs->m_u.tcp_ip4_spec.pdst);
 
-		rule->tuples.dst_port = be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst);
-		rule->tuples_mask.dst_port =
-				be16_to_cpu(fs->m_u.tcp_ip4_spec.pdst);
+	rule->tuples.ip_tos = fs->h_u.tcp_ip4_spec.tos;
+	rule->tuples_mask.ip_tos = fs->m_u.tcp_ip4_spec.tos;
 
-		rule->tuples.ip_tos = fs->h_u.tcp_ip4_spec.tos;
-		rule->tuples_mask.ip_tos = fs->m_u.tcp_ip4_spec.tos;
+	rule->tuples.ether_proto = ETH_P_IP;
+	rule->tuples_mask.ether_proto = 0xFFFF;
 
-		rule->tuples.ether_proto = ETH_P_IP;
-		rule->tuples_mask.ether_proto = 0xFFFF;
+	rule->tuples.ip_proto = ip_proto;
+	rule->tuples_mask.ip_proto = 0xFF;
+}
 
-		break;
-	case IP_USER_FLOW:
-		rule->tuples.src_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->h_u.usr_ip4_spec.ip4src);
-		rule->tuples_mask.src_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->m_u.usr_ip4_spec.ip4src);
+static void hclge_fd_get_ip4_tuple(struct hclge_dev *hdev,
+				   struct ethtool_rx_flow_spec *fs,
+				   struct hclge_fd_rule *rule)
+{
+	rule->tuples.src_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->h_u.usr_ip4_spec.ip4src);
+	rule->tuples_mask.src_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->m_u.usr_ip4_spec.ip4src);
 
-		rule->tuples.dst_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->h_u.usr_ip4_spec.ip4dst);
-		rule->tuples_mask.dst_ip[IPV4_INDEX] =
-				be32_to_cpu(fs->m_u.usr_ip4_spec.ip4dst);
+	rule->tuples.dst_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->h_u.usr_ip4_spec.ip4dst);
+	rule->tuples_mask.dst_ip[IPV4_INDEX] =
+			be32_to_cpu(fs->m_u.usr_ip4_spec.ip4dst);
 
-		rule->tuples.ip_tos = fs->h_u.usr_ip4_spec.tos;
-		rule->tuples_mask.ip_tos = fs->m_u.usr_ip4_spec.tos;
+	rule->tuples.ip_tos = fs->h_u.usr_ip4_spec.tos;
+	rule->tuples_mask.ip_tos = fs->m_u.usr_ip4_spec.tos;
 
-		rule->tuples.ip_proto = fs->h_u.usr_ip4_spec.proto;
-		rule->tuples_mask.ip_proto = fs->m_u.usr_ip4_spec.proto;
+	rule->tuples.ip_proto = fs->h_u.usr_ip4_spec.proto;
+	rule->tuples_mask.ip_proto = fs->m_u.usr_ip4_spec.proto;
 
-		rule->tuples.ether_proto = ETH_P_IP;
-		rule->tuples_mask.ether_proto = 0xFFFF;
+	rule->tuples.ether_proto = ETH_P_IP;
+	rule->tuples_mask.ether_proto = 0xFFFF;
+}
 
-		break;
-	case SCTP_V6_FLOW:
-	case TCP_V6_FLOW:
-	case UDP_V6_FLOW:
-		be32_to_cpu_array(rule->tuples.src_ip,
-				  fs->h_u.tcp_ip6_spec.ip6src, IPV6_SIZE);
-		be32_to_cpu_array(rule->tuples_mask.src_ip,
-				  fs->m_u.tcp_ip6_spec.ip6src, IPV6_SIZE);
+static void hclge_fd_get_tcpip6_tuple(struct hclge_dev *hdev,
+				      struct ethtool_rx_flow_spec *fs,
+				      struct hclge_fd_rule *rule, u8 ip_proto)
+{
+	be32_to_cpu_array(rule->tuples.src_ip, fs->h_u.tcp_ip6_spec.ip6src,
+			  IPV6_SIZE);
+	be32_to_cpu_array(rule->tuples_mask.src_ip, fs->m_u.tcp_ip6_spec.ip6src,
+			  IPV6_SIZE);
 
-		be32_to_cpu_array(rule->tuples.dst_ip,
-				  fs->h_u.tcp_ip6_spec.ip6dst, IPV6_SIZE);
-		be32_to_cpu_array(rule->tuples_mask.dst_ip,
-				  fs->m_u.tcp_ip6_spec.ip6dst, IPV6_SIZE);
+	be32_to_cpu_array(rule->tuples.dst_ip, fs->h_u.tcp_ip6_spec.ip6dst,
+			  IPV6_SIZE);
+	be32_to_cpu_array(rule->tuples_mask.dst_ip, fs->m_u.tcp_ip6_spec.ip6dst,
+			  IPV6_SIZE);
 
-		rule->tuples.src_port = be16_to_cpu(fs->h_u.tcp_ip6_spec.psrc);
-		rule->tuples_mask.src_port =
-				be16_to_cpu(fs->m_u.tcp_ip6_spec.psrc);
+	rule->tuples.src_port = be16_to_cpu(fs->h_u.tcp_ip6_spec.psrc);
+	rule->tuples_mask.src_port = be16_to_cpu(fs->m_u.tcp_ip6_spec.psrc);
 
-		rule->tuples.dst_port = be16_to_cpu(fs->h_u.tcp_ip6_spec.pdst);
-		rule->tuples_mask.dst_port =
-				be16_to_cpu(fs->m_u.tcp_ip6_spec.pdst);
+	rule->tuples.dst_port = be16_to_cpu(fs->h_u.tcp_ip6_spec.pdst);
+	rule->tuples_mask.dst_port = be16_to_cpu(fs->m_u.tcp_ip6_spec.pdst);
 
-		rule->tuples.ether_proto = ETH_P_IPV6;
-		rule->tuples_mask.ether_proto = 0xFFFF;
+	rule->tuples.ether_proto = ETH_P_IPV6;
+	rule->tuples_mask.ether_proto = 0xFFFF;
 
-		break;
-	case IPV6_USER_FLOW:
-		be32_to_cpu_array(rule->tuples.src_ip,
-				  fs->h_u.usr_ip6_spec.ip6src, IPV6_SIZE);
-		be32_to_cpu_array(rule->tuples_mask.src_ip,
-				  fs->m_u.usr_ip6_spec.ip6src, IPV6_SIZE);
+	rule->tuples.ip_proto = ip_proto;
+	rule->tuples_mask.ip_proto = 0xFF;
+}
 
-		be32_to_cpu_array(rule->tuples.dst_ip,
-				  fs->h_u.usr_ip6_spec.ip6dst, IPV6_SIZE);
-		be32_to_cpu_array(rule->tuples_mask.dst_ip,
-				  fs->m_u.usr_ip6_spec.ip6dst, IPV6_SIZE);
+static void hclge_fd_get_ip6_tuple(struct hclge_dev *hdev,
+				   struct ethtool_rx_flow_spec *fs,
+				   struct hclge_fd_rule *rule)
+{
+	be32_to_cpu_array(rule->tuples.src_ip, fs->h_u.usr_ip6_spec.ip6src,
+			  IPV6_SIZE);
+	be32_to_cpu_array(rule->tuples_mask.src_ip, fs->m_u.usr_ip6_spec.ip6src,
+			  IPV6_SIZE);
 
-		rule->tuples.ip_proto = fs->h_u.usr_ip6_spec.l4_proto;
-		rule->tuples_mask.ip_proto = fs->m_u.usr_ip6_spec.l4_proto;
+	be32_to_cpu_array(rule->tuples.dst_ip, fs->h_u.usr_ip6_spec.ip6dst,
+			  IPV6_SIZE);
+	be32_to_cpu_array(rule->tuples_mask.dst_ip, fs->m_u.usr_ip6_spec.ip6dst,
+			  IPV6_SIZE);
 
-		rule->tuples.ether_proto = ETH_P_IPV6;
-		rule->tuples_mask.ether_proto = 0xFFFF;
+	rule->tuples.ip_proto = fs->h_u.usr_ip6_spec.l4_proto;
+	rule->tuples_mask.ip_proto = fs->m_u.usr_ip6_spec.l4_proto;
 
-		break;
-	case ETHER_FLOW:
-		ether_addr_copy(rule->tuples.src_mac,
-				fs->h_u.ether_spec.h_source);
-		ether_addr_copy(rule->tuples_mask.src_mac,
-				fs->m_u.ether_spec.h_source);
+	rule->tuples.ether_proto = ETH_P_IPV6;
+	rule->tuples_mask.ether_proto = 0xFFFF;
+}
 
-		ether_addr_copy(rule->tuples.dst_mac,
-				fs->h_u.ether_spec.h_dest);
-		ether_addr_copy(rule->tuples_mask.dst_mac,
-				fs->m_u.ether_spec.h_dest);
+static void hclge_fd_get_ether_tuple(struct hclge_dev *hdev,
+				     struct ethtool_rx_flow_spec *fs,
+				     struct hclge_fd_rule *rule)
+{
+	ether_addr_copy(rule->tuples.src_mac, fs->h_u.ether_spec.h_source);
+	ether_addr_copy(rule->tuples_mask.src_mac, fs->m_u.ether_spec.h_source);
 
-		rule->tuples.ether_proto =
-				be16_to_cpu(fs->h_u.ether_spec.h_proto);
-		rule->tuples_mask.ether_proto =
-				be16_to_cpu(fs->m_u.ether_spec.h_proto);
+	ether_addr_copy(rule->tuples.dst_mac, fs->h_u.ether_spec.h_dest);
+	ether_addr_copy(rule->tuples_mask.dst_mac, fs->m_u.ether_spec.h_dest);
 
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
+	rule->tuples.ether_proto = be16_to_cpu(fs->h_u.ether_spec.h_proto);
+	rule->tuples_mask.ether_proto = be16_to_cpu(fs->m_u.ether_spec.h_proto);
+}
+
+static int hclge_fd_get_tuple(struct hclge_dev *hdev,
+			      struct ethtool_rx_flow_spec *fs,
+			      struct hclge_fd_rule *rule)
+{
+	u32 flow_type = fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT);
 
 	switch (flow_type) {
 	case SCTP_V4_FLOW:
-	case SCTP_V6_FLOW:
-		rule->tuples.ip_proto = IPPROTO_SCTP;
-		rule->tuples_mask.ip_proto = 0xFF;
+		hclge_fd_get_tcpip4_tuple(hdev, fs, rule, IPPROTO_SCTP);
 		break;
 	case TCP_V4_FLOW:
-	case TCP_V6_FLOW:
-		rule->tuples.ip_proto = IPPROTO_TCP;
-		rule->tuples_mask.ip_proto = 0xFF;
+		hclge_fd_get_tcpip4_tuple(hdev, fs, rule, IPPROTO_TCP);
 		break;
 	case UDP_V4_FLOW:
+		hclge_fd_get_tcpip4_tuple(hdev, fs, rule, IPPROTO_UDP);
+		break;
+	case IP_USER_FLOW:
+		hclge_fd_get_ip4_tuple(hdev, fs, rule);
+		break;
+	case SCTP_V6_FLOW:
+		hclge_fd_get_tcpip6_tuple(hdev, fs, rule, IPPROTO_SCTP);
+		break;
+	case TCP_V6_FLOW:
+		hclge_fd_get_tcpip6_tuple(hdev, fs, rule, IPPROTO_TCP);
+		break;
 	case UDP_V6_FLOW:
-		rule->tuples.ip_proto = IPPROTO_UDP;
-		rule->tuples_mask.ip_proto = 0xFF;
+		hclge_fd_get_tcpip6_tuple(hdev, fs, rule, IPPROTO_UDP);
 		break;
-	default:
+	case IPV6_USER_FLOW:
+		hclge_fd_get_ip6_tuple(hdev, fs, rule);
 		break;
+	case ETHER_FLOW:
+		hclge_fd_get_ether_tuple(hdev, fs, rule);
+		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
 	if (fs->flow_type & FLOW_EXT) {
-- 
2.7.4

