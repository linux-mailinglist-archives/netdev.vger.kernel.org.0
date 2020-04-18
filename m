Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F351AEA53
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgDRGsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:48:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54280 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbgDRGs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 02:48:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1C1733D0F3A361891DAD;
        Sat, 18 Apr 2020 14:48:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 18 Apr 2020 14:48:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/10] net: hns3: split out hclge_get_fd_rule_info()
Date:   Sat, 18 Apr 2020 14:47:01 +0800
Message-ID: <1587192429-11463-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
References: <1587192429-11463-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

hclge_get_fd_rule_info() is bloated, this patch separates
it into several standalone functions for readability and
maintainability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 303 +++++++++++----------
 1 file changed, 159 insertions(+), 144 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6381c0f..0aa8db1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5938,6 +5938,149 @@ static int hclge_get_fd_rule_cnt(struct hnae3_handle *handle,
 	return 0;
 }
 
+static void hclge_fd_get_tcpip4_info(struct hclge_fd_rule *rule,
+				     struct ethtool_tcpip4_spec *spec,
+				     struct ethtool_tcpip4_spec *spec_mask)
+{
+	spec->ip4src = cpu_to_be32(rule->tuples.src_ip[IPV4_INDEX]);
+	spec_mask->ip4src = rule->unused_tuple & BIT(INNER_SRC_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.src_ip[IPV4_INDEX]);
+
+	spec->ip4dst = cpu_to_be32(rule->tuples.dst_ip[IPV4_INDEX]);
+	spec_mask->ip4dst = rule->unused_tuple & BIT(INNER_DST_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.dst_ip[IPV4_INDEX]);
+
+	spec->psrc = cpu_to_be16(rule->tuples.src_port);
+	spec_mask->psrc = rule->unused_tuple & BIT(INNER_SRC_PORT) ?
+			0 : cpu_to_be16(rule->tuples_mask.src_port);
+
+	spec->pdst = cpu_to_be16(rule->tuples.dst_port);
+	spec_mask->pdst = rule->unused_tuple & BIT(INNER_DST_PORT) ?
+			0 : cpu_to_be16(rule->tuples_mask.dst_port);
+
+	spec->tos = rule->tuples.ip_tos;
+	spec_mask->tos = rule->unused_tuple & BIT(INNER_IP_TOS) ?
+			0 : rule->tuples_mask.ip_tos;
+}
+
+static void hclge_fd_get_ip4_info(struct hclge_fd_rule *rule,
+				  struct ethtool_usrip4_spec *spec,
+				  struct ethtool_usrip4_spec *spec_mask)
+{
+	spec->ip4src = cpu_to_be32(rule->tuples.src_ip[IPV4_INDEX]);
+	spec_mask->ip4src = rule->unused_tuple & BIT(INNER_SRC_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.src_ip[IPV4_INDEX]);
+
+	spec->ip4dst = cpu_to_be32(rule->tuples.dst_ip[IPV4_INDEX]);
+	spec_mask->ip4dst = rule->unused_tuple & BIT(INNER_DST_IP) ?
+			0 : cpu_to_be32(rule->tuples_mask.dst_ip[IPV4_INDEX]);
+
+	spec->tos = rule->tuples.ip_tos;
+	spec_mask->tos = rule->unused_tuple & BIT(INNER_IP_TOS) ?
+			0 : rule->tuples_mask.ip_tos;
+
+	spec->proto = rule->tuples.ip_proto;
+	spec_mask->proto = rule->unused_tuple & BIT(INNER_IP_PROTO) ?
+			0 : rule->tuples_mask.ip_proto;
+
+	spec->ip_ver = ETH_RX_NFC_IP4;
+}
+
+static void hclge_fd_get_tcpip6_info(struct hclge_fd_rule *rule,
+				     struct ethtool_tcpip6_spec *spec,
+				     struct ethtool_tcpip6_spec *spec_mask)
+{
+	cpu_to_be32_array(spec->ip6src,
+			  rule->tuples.src_ip, IPV6_SIZE);
+	cpu_to_be32_array(spec->ip6dst,
+			  rule->tuples.dst_ip, IPV6_SIZE);
+	if (rule->unused_tuple & BIT(INNER_SRC_IP))
+		memset(spec_mask->ip6src, 0, sizeof(spec_mask->ip6src));
+	else
+		cpu_to_be32_array(spec_mask->ip6src, rule->tuples_mask.src_ip,
+				  IPV6_SIZE);
+
+	if (rule->unused_tuple & BIT(INNER_DST_IP))
+		memset(spec_mask->ip6dst, 0, sizeof(spec_mask->ip6dst));
+	else
+		cpu_to_be32_array(spec_mask->ip6dst, rule->tuples_mask.dst_ip,
+				  IPV6_SIZE);
+
+	spec->psrc = cpu_to_be16(rule->tuples.src_port);
+	spec_mask->psrc = rule->unused_tuple & BIT(INNER_SRC_PORT) ?
+			0 : cpu_to_be16(rule->tuples_mask.src_port);
+
+	spec->pdst = cpu_to_be16(rule->tuples.dst_port);
+	spec_mask->pdst = rule->unused_tuple & BIT(INNER_DST_PORT) ?
+			0 : cpu_to_be16(rule->tuples_mask.dst_port);
+}
+
+static void hclge_fd_get_ip6_info(struct hclge_fd_rule *rule,
+				  struct ethtool_usrip6_spec *spec,
+				  struct ethtool_usrip6_spec *spec_mask)
+{
+	cpu_to_be32_array(spec->ip6src, rule->tuples.src_ip, IPV6_SIZE);
+	cpu_to_be32_array(spec->ip6dst, rule->tuples.dst_ip, IPV6_SIZE);
+	if (rule->unused_tuple & BIT(INNER_SRC_IP))
+		memset(spec_mask->ip6src, 0, sizeof(spec_mask->ip6src));
+	else
+		cpu_to_be32_array(spec_mask->ip6src,
+				  rule->tuples_mask.src_ip, IPV6_SIZE);
+
+	if (rule->unused_tuple & BIT(INNER_DST_IP))
+		memset(spec_mask->ip6dst, 0, sizeof(spec_mask->ip6dst));
+	else
+		cpu_to_be32_array(spec_mask->ip6dst,
+				  rule->tuples_mask.dst_ip, IPV6_SIZE);
+
+	spec->l4_proto = rule->tuples.ip_proto;
+	spec_mask->l4_proto = rule->unused_tuple & BIT(INNER_IP_PROTO) ?
+			0 : rule->tuples_mask.ip_proto;
+}
+
+static void hclge_fd_get_ether_info(struct hclge_fd_rule *rule,
+				    struct ethhdr *spec,
+				    struct ethhdr *spec_mask)
+{
+	ether_addr_copy(spec->h_source, rule->tuples.src_mac);
+	ether_addr_copy(spec->h_dest, rule->tuples.dst_mac);
+
+	if (rule->unused_tuple & BIT(INNER_SRC_MAC))
+		eth_zero_addr(spec_mask->h_source);
+	else
+		ether_addr_copy(spec_mask->h_source, rule->tuples_mask.src_mac);
+
+	if (rule->unused_tuple & BIT(INNER_DST_MAC))
+		eth_zero_addr(spec_mask->h_dest);
+	else
+		ether_addr_copy(spec_mask->h_dest, rule->tuples_mask.dst_mac);
+
+	spec->h_proto = cpu_to_be16(rule->tuples.ether_proto);
+	spec_mask->h_proto = rule->unused_tuple & BIT(INNER_ETH_TYPE) ?
+			0 : cpu_to_be16(rule->tuples_mask.ether_proto);
+}
+
+static void hclge_fd_get_ext_info(struct ethtool_rx_flow_spec *fs,
+				  struct hclge_fd_rule *rule)
+{
+	if (fs->flow_type & FLOW_EXT) {
+		fs->h_ext.vlan_tci = cpu_to_be16(rule->tuples.vlan_tag1);
+		fs->m_ext.vlan_tci =
+				rule->unused_tuple & BIT(INNER_VLAN_TAG_FST) ?
+				cpu_to_be16(VLAN_VID_MASK) :
+				cpu_to_be16(rule->tuples_mask.vlan_tag1);
+	}
+
+	if (fs->flow_type & FLOW_MAC_EXT) {
+		ether_addr_copy(fs->h_ext.h_dest, rule->tuples.dst_mac);
+		if (rule->unused_tuple & BIT(INNER_DST_MAC))
+			eth_zero_addr(fs->m_u.ether_spec.h_dest);
+		else
+			ether_addr_copy(fs->m_u.ether_spec.h_dest,
+					rule->tuples_mask.dst_mac);
+	}
+}
+
 static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 				  struct ethtool_rxnfc *cmd)
 {
@@ -5970,162 +6113,34 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 	case SCTP_V4_FLOW:
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
-		fs->h_u.tcp_ip4_spec.ip4src =
-				cpu_to_be32(rule->tuples.src_ip[IPV4_INDEX]);
-		fs->m_u.tcp_ip4_spec.ip4src =
-			rule->unused_tuple & BIT(INNER_SRC_IP) ?
-			0 : cpu_to_be32(rule->tuples_mask.src_ip[IPV4_INDEX]);
-
-		fs->h_u.tcp_ip4_spec.ip4dst =
-				cpu_to_be32(rule->tuples.dst_ip[IPV4_INDEX]);
-		fs->m_u.tcp_ip4_spec.ip4dst =
-			rule->unused_tuple & BIT(INNER_DST_IP) ?
-			0 : cpu_to_be32(rule->tuples_mask.dst_ip[IPV4_INDEX]);
-
-		fs->h_u.tcp_ip4_spec.psrc = cpu_to_be16(rule->tuples.src_port);
-		fs->m_u.tcp_ip4_spec.psrc =
-				rule->unused_tuple & BIT(INNER_SRC_PORT) ?
-				0 : cpu_to_be16(rule->tuples_mask.src_port);
-
-		fs->h_u.tcp_ip4_spec.pdst = cpu_to_be16(rule->tuples.dst_port);
-		fs->m_u.tcp_ip4_spec.pdst =
-				rule->unused_tuple & BIT(INNER_DST_PORT) ?
-				0 : cpu_to_be16(rule->tuples_mask.dst_port);
-
-		fs->h_u.tcp_ip4_spec.tos = rule->tuples.ip_tos;
-		fs->m_u.tcp_ip4_spec.tos =
-				rule->unused_tuple & BIT(INNER_IP_TOS) ?
-				0 : rule->tuples_mask.ip_tos;
-
+		hclge_fd_get_tcpip4_info(rule, &fs->h_u.tcp_ip4_spec,
+					 &fs->m_u.tcp_ip4_spec);
 		break;
 	case IP_USER_FLOW:
-		fs->h_u.usr_ip4_spec.ip4src =
-				cpu_to_be32(rule->tuples.src_ip[IPV4_INDEX]);
-		fs->m_u.tcp_ip4_spec.ip4src =
-			rule->unused_tuple & BIT(INNER_SRC_IP) ?
-			0 : cpu_to_be32(rule->tuples_mask.src_ip[IPV4_INDEX]);
-
-		fs->h_u.usr_ip4_spec.ip4dst =
-				cpu_to_be32(rule->tuples.dst_ip[IPV4_INDEX]);
-		fs->m_u.usr_ip4_spec.ip4dst =
-			rule->unused_tuple & BIT(INNER_DST_IP) ?
-			0 : cpu_to_be32(rule->tuples_mask.dst_ip[IPV4_INDEX]);
-
-		fs->h_u.usr_ip4_spec.tos = rule->tuples.ip_tos;
-		fs->m_u.usr_ip4_spec.tos =
-				rule->unused_tuple & BIT(INNER_IP_TOS) ?
-				0 : rule->tuples_mask.ip_tos;
-
-		fs->h_u.usr_ip4_spec.proto = rule->tuples.ip_proto;
-		fs->m_u.usr_ip4_spec.proto =
-				rule->unused_tuple & BIT(INNER_IP_PROTO) ?
-				0 : rule->tuples_mask.ip_proto;
-
-		fs->h_u.usr_ip4_spec.ip_ver = ETH_RX_NFC_IP4;
-
+		hclge_fd_get_ip4_info(rule, &fs->h_u.usr_ip4_spec,
+				      &fs->m_u.usr_ip4_spec);
 		break;
 	case SCTP_V6_FLOW:
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
-		cpu_to_be32_array(fs->h_u.tcp_ip6_spec.ip6src,
-				  rule->tuples.src_ip, IPV6_SIZE);
-		if (rule->unused_tuple & BIT(INNER_SRC_IP))
-			memset(fs->m_u.tcp_ip6_spec.ip6src, 0,
-			       sizeof(int) * IPV6_SIZE);
-		else
-			cpu_to_be32_array(fs->m_u.tcp_ip6_spec.ip6src,
-					  rule->tuples_mask.src_ip, IPV6_SIZE);
-
-		cpu_to_be32_array(fs->h_u.tcp_ip6_spec.ip6dst,
-				  rule->tuples.dst_ip, IPV6_SIZE);
-		if (rule->unused_tuple & BIT(INNER_DST_IP))
-			memset(fs->m_u.tcp_ip6_spec.ip6dst, 0,
-			       sizeof(int) * IPV6_SIZE);
-		else
-			cpu_to_be32_array(fs->m_u.tcp_ip6_spec.ip6dst,
-					  rule->tuples_mask.dst_ip, IPV6_SIZE);
-
-		fs->h_u.tcp_ip6_spec.psrc = cpu_to_be16(rule->tuples.src_port);
-		fs->m_u.tcp_ip6_spec.psrc =
-				rule->unused_tuple & BIT(INNER_SRC_PORT) ?
-				0 : cpu_to_be16(rule->tuples_mask.src_port);
-
-		fs->h_u.tcp_ip6_spec.pdst = cpu_to_be16(rule->tuples.dst_port);
-		fs->m_u.tcp_ip6_spec.pdst =
-				rule->unused_tuple & BIT(INNER_DST_PORT) ?
-				0 : cpu_to_be16(rule->tuples_mask.dst_port);
-
+		hclge_fd_get_tcpip6_info(rule, &fs->h_u.tcp_ip6_spec,
+					 &fs->m_u.tcp_ip6_spec);
 		break;
 	case IPV6_USER_FLOW:
-		cpu_to_be32_array(fs->h_u.usr_ip6_spec.ip6src,
-				  rule->tuples.src_ip, IPV6_SIZE);
-		if (rule->unused_tuple & BIT(INNER_SRC_IP))
-			memset(fs->m_u.usr_ip6_spec.ip6src, 0,
-			       sizeof(int) * IPV6_SIZE);
-		else
-			cpu_to_be32_array(fs->m_u.usr_ip6_spec.ip6src,
-					  rule->tuples_mask.src_ip, IPV6_SIZE);
-
-		cpu_to_be32_array(fs->h_u.usr_ip6_spec.ip6dst,
-				  rule->tuples.dst_ip, IPV6_SIZE);
-		if (rule->unused_tuple & BIT(INNER_DST_IP))
-			memset(fs->m_u.usr_ip6_spec.ip6dst, 0,
-			       sizeof(int) * IPV6_SIZE);
-		else
-			cpu_to_be32_array(fs->m_u.usr_ip6_spec.ip6dst,
-					  rule->tuples_mask.dst_ip, IPV6_SIZE);
-
-		fs->h_u.usr_ip6_spec.l4_proto = rule->tuples.ip_proto;
-		fs->m_u.usr_ip6_spec.l4_proto =
-				rule->unused_tuple & BIT(INNER_IP_PROTO) ?
-				0 : rule->tuples_mask.ip_proto;
-
-		break;
-	case ETHER_FLOW:
-		ether_addr_copy(fs->h_u.ether_spec.h_source,
-				rule->tuples.src_mac);
-		if (rule->unused_tuple & BIT(INNER_SRC_MAC))
-			eth_zero_addr(fs->m_u.ether_spec.h_source);
-		else
-			ether_addr_copy(fs->m_u.ether_spec.h_source,
-					rule->tuples_mask.src_mac);
-
-		ether_addr_copy(fs->h_u.ether_spec.h_dest,
-				rule->tuples.dst_mac);
-		if (rule->unused_tuple & BIT(INNER_DST_MAC))
-			eth_zero_addr(fs->m_u.ether_spec.h_dest);
-		else
-			ether_addr_copy(fs->m_u.ether_spec.h_dest,
-					rule->tuples_mask.dst_mac);
-
-		fs->h_u.ether_spec.h_proto =
-				cpu_to_be16(rule->tuples.ether_proto);
-		fs->m_u.ether_spec.h_proto =
-				rule->unused_tuple & BIT(INNER_ETH_TYPE) ?
-				0 : cpu_to_be16(rule->tuples_mask.ether_proto);
-
+		hclge_fd_get_ip6_info(rule, &fs->h_u.usr_ip6_spec,
+				      &fs->m_u.usr_ip6_spec);
 		break;
+	/* The flow type of fd rule has been checked before adding in to rule
+	 * list. As other flow types have been handled, it must be ETHER_FLOW
+	 * for the default case
+	 */
 	default:
-		spin_unlock_bh(&hdev->fd_rule_lock);
-		return -EOPNOTSUPP;
-	}
-
-	if (fs->flow_type & FLOW_EXT) {
-		fs->h_ext.vlan_tci = cpu_to_be16(rule->tuples.vlan_tag1);
-		fs->m_ext.vlan_tci =
-				rule->unused_tuple & BIT(INNER_VLAN_TAG_FST) ?
-				cpu_to_be16(VLAN_VID_MASK) :
-				cpu_to_be16(rule->tuples_mask.vlan_tag1);
+		hclge_fd_get_ether_info(rule, &fs->h_u.ether_spec,
+					&fs->m_u.ether_spec);
+		break;
 	}
 
-	if (fs->flow_type & FLOW_MAC_EXT) {
-		ether_addr_copy(fs->h_ext.h_dest, rule->tuples.dst_mac);
-		if (rule->unused_tuple & BIT(INNER_DST_MAC))
-			eth_zero_addr(fs->m_u.ether_spec.h_dest);
-		else
-			ether_addr_copy(fs->m_u.ether_spec.h_dest,
-					rule->tuples_mask.dst_mac);
-	}
+	hclge_fd_get_ext_info(fs, rule);
 
 	if (rule->action == HCLGE_FD_ACTION_DROP_PACKET) {
 		fs->ring_cookie = RX_CLS_FLOW_DISC;
-- 
2.7.4

