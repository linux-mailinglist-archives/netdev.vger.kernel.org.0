Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204EE33B282
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhCOMXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:23:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13610 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhCOMX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:23:27 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DzbBP5L4sz17LbS;
        Mon, 15 Mar 2021 20:21:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 20:23:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/9] net: hns3: refactor out hclge_fd_get_tuple()
Date:   Mon, 15 Mar 2021 20:23:44 +0800
Message-ID: <1615811031-55209-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
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
index 4929220..a17831f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5935,144 +5935,158 @@ static int hclge_fd_update_rule_list(struct hclge_dev *hdev,
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

