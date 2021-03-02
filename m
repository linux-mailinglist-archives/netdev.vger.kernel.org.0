Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F47E32A355
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382105AbhCBIzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:55:54 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13410 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835944AbhCBG3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:29:05 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DqRwL1CjtzjTLf;
        Tue,  2 Mar 2021 14:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 14:27:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 4/9] net: hns3: add support for traffic class tuple support for flow director by ethtool
Date:   Tue, 2 Mar 2021 14:27:50 +0800
Message-ID: <1614666475-13059-5-git-send-email-tanhuazhong@huawei.com>
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

The hardware supports to parse and match the traffic class field
of IPv6 packet for flow director, uses the same tuple as ip tos.
So removes the limitation of configure 'tclass' by driver.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 27 ++++++++++++++++------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8a3a2eb..0a121ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5519,8 +5519,7 @@ static int hclge_fd_check_tcpip6_tuple(struct ethtool_tcpip6_spec *spec,
 	if (!spec || !unused_tuple)
 		return -EINVAL;
 
-	*unused_tuple |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
-		BIT(INNER_IP_TOS);
+	*unused_tuple |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC);
 
 	/* check whether src/dst ip address used */
 	if (ipv6_addr_any((struct in6_addr *)spec->ip6src))
@@ -5535,8 +5534,8 @@ static int hclge_fd_check_tcpip6_tuple(struct ethtool_tcpip6_spec *spec,
 	if (!spec->pdst)
 		*unused_tuple |= BIT(INNER_DST_PORT);
 
-	if (spec->tclass)
-		return -EOPNOTSUPP;
+	if (!spec->tclass)
+		*unused_tuple |= BIT(INNER_IP_TOS);
 
 	return 0;
 }
@@ -5548,7 +5547,7 @@ static int hclge_fd_check_ip6_tuple(struct ethtool_usrip6_spec *spec,
 		return -EINVAL;
 
 	*unused_tuple |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
-		BIT(INNER_IP_TOS) | BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
+			BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
 
 	/* check whether src/dst ip address used */
 	if (ipv6_addr_any((struct in6_addr *)spec->ip6src))
@@ -5560,8 +5559,8 @@ static int hclge_fd_check_ip6_tuple(struct ethtool_usrip6_spec *spec,
 	if (!spec->l4_proto)
 		*unused_tuple |= BIT(INNER_IP_PROTO);
 
-	if (spec->tclass)
-		return -EOPNOTSUPP;
+	if (!spec->tclass)
+		*unused_tuple |= BIT(INNER_IP_TOS);
 
 	if (spec->l4_4_bytes)
 		return -EOPNOTSUPP;
@@ -5847,6 +5846,9 @@ static void hclge_fd_get_tcpip6_tuple(struct hclge_dev *hdev,
 	rule->tuples.ether_proto = ETH_P_IPV6;
 	rule->tuples_mask.ether_proto = 0xFFFF;
 
+	rule->tuples.ip_tos = fs->h_u.tcp_ip6_spec.tclass;
+	rule->tuples_mask.ip_tos = fs->m_u.tcp_ip6_spec.tclass;
+
 	rule->tuples.ip_proto = ip_proto;
 	rule->tuples_mask.ip_proto = 0xFF;
 }
@@ -5868,6 +5870,9 @@ static void hclge_fd_get_ip6_tuple(struct hclge_dev *hdev,
 	rule->tuples.ip_proto = fs->h_u.usr_ip6_spec.l4_proto;
 	rule->tuples_mask.ip_proto = fs->m_u.usr_ip6_spec.l4_proto;
 
+	rule->tuples.ip_tos = fs->h_u.tcp_ip6_spec.tclass;
+	rule->tuples_mask.ip_tos = fs->m_u.tcp_ip6_spec.tclass;
+
 	rule->tuples.ether_proto = ETH_P_IPV6;
 	rule->tuples_mask.ether_proto = 0xFFFF;
 }
@@ -6277,6 +6282,10 @@ static void hclge_fd_get_tcpip6_info(struct hclge_fd_rule *rule,
 		cpu_to_be32_array(spec_mask->ip6dst, rule->tuples_mask.dst_ip,
 				  IPV6_SIZE);
 
+	spec->tclass = rule->tuples.ip_tos;
+	spec_mask->tclass = rule->unused_tuple & BIT(INNER_IP_TOS) ?
+			0 : rule->tuples_mask.ip_tos;
+
 	spec->psrc = cpu_to_be16(rule->tuples.src_port);
 	spec_mask->psrc = rule->unused_tuple & BIT(INNER_SRC_PORT) ?
 			0 : cpu_to_be16(rule->tuples_mask.src_port);
@@ -6304,6 +6313,10 @@ static void hclge_fd_get_ip6_info(struct hclge_fd_rule *rule,
 		cpu_to_be32_array(spec_mask->ip6dst,
 				  rule->tuples_mask.dst_ip, IPV6_SIZE);
 
+	spec->tclass = rule->tuples.ip_tos;
+	spec_mask->tclass = rule->unused_tuple & BIT(INNER_IP_TOS) ?
+			0 : rule->tuples_mask.ip_tos;
+
 	spec->l4_proto = rule->tuples.ip_proto;
 	spec_mask->l4_proto = rule->unused_tuple & BIT(INNER_IP_PROTO) ?
 			0 : rule->tuples_mask.ip_proto;
-- 
2.7.4

