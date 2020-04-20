Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25501AFFC8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgDTCSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:18:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54802 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbgDTCSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:18:45 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 313C714BD5F73E5B6CA4;
        Mon, 20 Apr 2020 10:18:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 10:18:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 01/10] net: hns3: split out hclge_fd_check_ether_tuple()
Date:   Mon, 20 Apr 2020 10:17:26 +0800
Message-ID: <1587349055-4403-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
References: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For readability and maintainability, this patch separates the
handling part of each flow type in hclge_fd_check_ether_tuple()
into standalone functions.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 285 +++++++++++++--------
 1 file changed, 173 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a758f9a..80d0651 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5244,157 +5244,158 @@ static int hclge_config_action(struct hclge_dev *hdev, u8 stage,
 	return hclge_fd_ad_config(hdev, stage, ad_data.ad_id, &ad_data);
 }
 
-static int hclge_fd_check_spec(struct hclge_dev *hdev,
-			       struct ethtool_rx_flow_spec *fs, u32 *unused)
+static int hclge_fd_check_tcpip4_tuple(struct ethtool_tcpip4_spec *spec,
+				       u32 *unused_tuple)
 {
-	struct ethtool_tcpip4_spec *tcp_ip4_spec;
-	struct ethtool_usrip4_spec *usr_ip4_spec;
-	struct ethtool_tcpip6_spec *tcp_ip6_spec;
-	struct ethtool_usrip6_spec *usr_ip6_spec;
-	struct ethhdr *ether_spec;
-
-	if (fs->location >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
+	if (!spec || !unused_tuple)
 		return -EINVAL;
 
-	if (!(fs->flow_type & hdev->fd_cfg.proto_support))
-		return -EOPNOTSUPP;
-
-	if ((fs->flow_type & FLOW_EXT) &&
-	    (fs->h_ext.data[0] != 0 || fs->h_ext.data[1] != 0)) {
-		dev_err(&hdev->pdev->dev, "user-def bytes are not supported\n");
-		return -EOPNOTSUPP;
-	}
+	*unused_tuple |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC);
 
-	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
-	case SCTP_V4_FLOW:
-	case TCP_V4_FLOW:
-	case UDP_V4_FLOW:
-		tcp_ip4_spec = &fs->h_u.tcp_ip4_spec;
-		*unused |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC);
+	if (!spec->ip4src)
+		*unused_tuple |= BIT(INNER_SRC_IP);
 
-		if (!tcp_ip4_spec->ip4src)
-			*unused |= BIT(INNER_SRC_IP);
+	if (!spec->ip4dst)
+		*unused_tuple |= BIT(INNER_DST_IP);
 
-		if (!tcp_ip4_spec->ip4dst)
-			*unused |= BIT(INNER_DST_IP);
+	if (!spec->psrc)
+		*unused_tuple |= BIT(INNER_SRC_PORT);
 
-		if (!tcp_ip4_spec->psrc)
-			*unused |= BIT(INNER_SRC_PORT);
+	if (!spec->pdst)
+		*unused_tuple |= BIT(INNER_DST_PORT);
 
-		if (!tcp_ip4_spec->pdst)
-			*unused |= BIT(INNER_DST_PORT);
+	if (!spec->tos)
+		*unused_tuple |= BIT(INNER_IP_TOS);
 
-		if (!tcp_ip4_spec->tos)
-			*unused |= BIT(INNER_IP_TOS);
+	return 0;
+}
 
-		break;
-	case IP_USER_FLOW:
-		usr_ip4_spec = &fs->h_u.usr_ip4_spec;
-		*unused |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
-			BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
+static int hclge_fd_check_ip4_tuple(struct ethtool_usrip4_spec *spec,
+				    u32 *unused_tuple)
+{
+	if (!spec || !unused_tuple)
+		return -EINVAL;
 
-		if (!usr_ip4_spec->ip4src)
-			*unused |= BIT(INNER_SRC_IP);
+	*unused_tuple |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
+		BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
 
-		if (!usr_ip4_spec->ip4dst)
-			*unused |= BIT(INNER_DST_IP);
+	if (!spec->ip4src)
+		*unused_tuple |= BIT(INNER_SRC_IP);
 
-		if (!usr_ip4_spec->tos)
-			*unused |= BIT(INNER_IP_TOS);
+	if (!spec->ip4dst)
+		*unused_tuple |= BIT(INNER_DST_IP);
 
-		if (!usr_ip4_spec->proto)
-			*unused |= BIT(INNER_IP_PROTO);
+	if (!spec->tos)
+		*unused_tuple |= BIT(INNER_IP_TOS);
 
-		if (usr_ip4_spec->l4_4_bytes)
-			return -EOPNOTSUPP;
+	if (!spec->proto)
+		*unused_tuple |= BIT(INNER_IP_PROTO);
 
-		if (usr_ip4_spec->ip_ver != ETH_RX_NFC_IP4)
-			return -EOPNOTSUPP;
+	if (spec->l4_4_bytes)
+		return -EOPNOTSUPP;
 
-		break;
-	case SCTP_V6_FLOW:
-	case TCP_V6_FLOW:
-	case UDP_V6_FLOW:
-		tcp_ip6_spec = &fs->h_u.tcp_ip6_spec;
-		*unused |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
-			BIT(INNER_IP_TOS);
+	if (spec->ip_ver != ETH_RX_NFC_IP4)
+		return -EOPNOTSUPP;
 
-		/* check whether src/dst ip address used */
-		if (!tcp_ip6_spec->ip6src[0] && !tcp_ip6_spec->ip6src[1] &&
-		    !tcp_ip6_spec->ip6src[2] && !tcp_ip6_spec->ip6src[3])
-			*unused |= BIT(INNER_SRC_IP);
+	return 0;
+}
 
-		if (!tcp_ip6_spec->ip6dst[0] && !tcp_ip6_spec->ip6dst[1] &&
-		    !tcp_ip6_spec->ip6dst[2] && !tcp_ip6_spec->ip6dst[3])
-			*unused |= BIT(INNER_DST_IP);
+static int hclge_fd_check_tcpip6_tuple(struct ethtool_tcpip6_spec *spec,
+				       u32 *unused_tuple)
+{
+	if (!spec || !unused_tuple)
+		return -EINVAL;
 
-		if (!tcp_ip6_spec->psrc)
-			*unused |= BIT(INNER_SRC_PORT);
+	*unused_tuple |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
+		BIT(INNER_IP_TOS);
 
-		if (!tcp_ip6_spec->pdst)
-			*unused |= BIT(INNER_DST_PORT);
+	/* check whether src/dst ip address used */
+	if (!spec->ip6src[0] && !spec->ip6src[1] &&
+	    !spec->ip6src[2] && !spec->ip6src[3])
+		*unused_tuple |= BIT(INNER_SRC_IP);
 
-		if (tcp_ip6_spec->tclass)
-			return -EOPNOTSUPP;
+	if (!spec->ip6dst[0] && !spec->ip6dst[1] &&
+	    !spec->ip6dst[2] && !spec->ip6dst[3])
+		*unused_tuple |= BIT(INNER_DST_IP);
 
-		break;
-	case IPV6_USER_FLOW:
-		usr_ip6_spec = &fs->h_u.usr_ip6_spec;
-		*unused |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
-			BIT(INNER_IP_TOS) | BIT(INNER_SRC_PORT) |
-			BIT(INNER_DST_PORT);
+	if (!spec->psrc)
+		*unused_tuple |= BIT(INNER_SRC_PORT);
 
-		/* check whether src/dst ip address used */
-		if (!usr_ip6_spec->ip6src[0] && !usr_ip6_spec->ip6src[1] &&
-		    !usr_ip6_spec->ip6src[2] && !usr_ip6_spec->ip6src[3])
-			*unused |= BIT(INNER_SRC_IP);
+	if (!spec->pdst)
+		*unused_tuple |= BIT(INNER_DST_PORT);
 
-		if (!usr_ip6_spec->ip6dst[0] && !usr_ip6_spec->ip6dst[1] &&
-		    !usr_ip6_spec->ip6dst[2] && !usr_ip6_spec->ip6dst[3])
-			*unused |= BIT(INNER_DST_IP);
+	if (spec->tclass)
+		return -EOPNOTSUPP;
 
-		if (!usr_ip6_spec->l4_proto)
-			*unused |= BIT(INNER_IP_PROTO);
+	return 0;
+}
 
-		if (usr_ip6_spec->tclass)
-			return -EOPNOTSUPP;
+static int hclge_fd_check_ip6_tuple(struct ethtool_usrip6_spec *spec,
+				    u32 *unused_tuple)
+{
+	if (!spec || !unused_tuple)
+		return -EINVAL;
 
-		if (usr_ip6_spec->l4_4_bytes)
-			return -EOPNOTSUPP;
+	*unused_tuple |= BIT(INNER_SRC_MAC) | BIT(INNER_DST_MAC) |
+		BIT(INNER_IP_TOS) | BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
 
-		break;
-	case ETHER_FLOW:
-		ether_spec = &fs->h_u.ether_spec;
-		*unused |= BIT(INNER_SRC_IP) | BIT(INNER_DST_IP) |
-			BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT) |
-			BIT(INNER_IP_TOS) | BIT(INNER_IP_PROTO);
+	/* check whether src/dst ip address used */
+	if (!spec->ip6src[0] && !spec->ip6src[1] &&
+	    !spec->ip6src[2] && !spec->ip6src[3])
+		*unused_tuple |= BIT(INNER_SRC_IP);
 
-		if (is_zero_ether_addr(ether_spec->h_source))
-			*unused |= BIT(INNER_SRC_MAC);
+	if (!spec->ip6dst[0] && !spec->ip6dst[1] &&
+	    !spec->ip6dst[2] && !spec->ip6dst[3])
+		*unused_tuple |= BIT(INNER_DST_IP);
 
-		if (is_zero_ether_addr(ether_spec->h_dest))
-			*unused |= BIT(INNER_DST_MAC);
+	if (!spec->l4_proto)
+		*unused_tuple |= BIT(INNER_IP_PROTO);
 
-		if (!ether_spec->h_proto)
-			*unused |= BIT(INNER_ETH_TYPE);
+	if (spec->tclass)
+		return -EOPNOTSUPP;
 
-		break;
-	default:
+	if (spec->l4_4_bytes)
 		return -EOPNOTSUPP;
-	}
 
+	return 0;
+}
+
+static int hclge_fd_check_ether_tuple(struct ethhdr *spec, u32 *unused_tuple)
+{
+	if (!spec || !unused_tuple)
+		return -EINVAL;
+
+	*unused_tuple |= BIT(INNER_SRC_IP) | BIT(INNER_DST_IP) |
+		BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT) |
+		BIT(INNER_IP_TOS) | BIT(INNER_IP_PROTO);
+
+	if (is_zero_ether_addr(spec->h_source))
+		*unused_tuple |= BIT(INNER_SRC_MAC);
+
+	if (is_zero_ether_addr(spec->h_dest))
+		*unused_tuple |= BIT(INNER_DST_MAC);
+
+	if (!spec->h_proto)
+		*unused_tuple |= BIT(INNER_ETH_TYPE);
+
+	return 0;
+}
+
+static int hclge_fd_check_ext_tuple(struct hclge_dev *hdev,
+				    struct ethtool_rx_flow_spec *fs,
+				    u32 *unused_tuple)
+{
 	if ((fs->flow_type & FLOW_EXT)) {
 		if (fs->h_ext.vlan_etype)
 			return -EOPNOTSUPP;
 		if (!fs->h_ext.vlan_tci)
-			*unused |= BIT(INNER_VLAN_TAG_FST);
+			*unused_tuple |= BIT(INNER_VLAN_TAG_FST);
 
-		if (fs->m_ext.vlan_tci) {
-			if (be16_to_cpu(fs->h_ext.vlan_tci) >= VLAN_N_VID)
-				return -EINVAL;
-		}
+		if (fs->m_ext.vlan_tci &&
+		    be16_to_cpu(fs->h_ext.vlan_tci) >= VLAN_N_VID)
+			return -EINVAL;
 	} else {
-		*unused |= BIT(INNER_VLAN_TAG_FST);
+		*unused_tuple |= BIT(INNER_VLAN_TAG_FST);
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {
@@ -5402,14 +5403,74 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 			return -EOPNOTSUPP;
 
 		if (is_zero_ether_addr(fs->h_ext.h_dest))
-			*unused |= BIT(INNER_DST_MAC);
+			*unused_tuple |= BIT(INNER_DST_MAC);
 		else
-			*unused &= ~(BIT(INNER_DST_MAC));
+			*unused_tuple &= ~(BIT(INNER_DST_MAC));
 	}
 
 	return 0;
 }
 
+static int hclge_fd_check_spec(struct hclge_dev *hdev,
+			       struct ethtool_rx_flow_spec *fs,
+			       u32 *unused_tuple)
+{
+	int ret;
+
+	if (fs->location >= hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1])
+		return -EINVAL;
+
+	if (!(fs->flow_type & hdev->fd_cfg.proto_support))
+		return -EOPNOTSUPP;
+
+	if ((fs->flow_type & FLOW_EXT) &&
+	    (fs->h_ext.data[0] != 0 || fs->h_ext.data[1] != 0)) {
+		dev_err(&hdev->pdev->dev, "user-def bytes are not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
+	case SCTP_V4_FLOW:
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+		ret = hclge_fd_check_tcpip4_tuple(&fs->h_u.tcp_ip4_spec,
+						  unused_tuple);
+		break;
+	case IP_USER_FLOW:
+		ret = hclge_fd_check_ip4_tuple(&fs->h_u.usr_ip4_spec,
+					       unused_tuple);
+		break;
+	case SCTP_V6_FLOW:
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+		ret = hclge_fd_check_tcpip6_tuple(&fs->h_u.tcp_ip6_spec,
+						  unused_tuple);
+		break;
+	case IPV6_USER_FLOW:
+		ret = hclge_fd_check_ip6_tuple(&fs->h_u.usr_ip6_spec,
+					       unused_tuple);
+		break;
+	case ETHER_FLOW:
+		if (hdev->fd_cfg.fd_mode !=
+			HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1) {
+			dev_err(&hdev->pdev->dev,
+				"ETHER_FLOW is not supported in current fd mode!\n");
+			return -EOPNOTSUPP;
+		}
+
+		ret = hclge_fd_check_ether_tuple(&fs->h_u.ether_spec,
+						 unused_tuple);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (ret)
+		return ret;
+
+	return hclge_fd_check_ext_tuple(hdev, fs, unused_tuple);
+}
+
 static bool hclge_fd_rule_exist(struct hclge_dev *hdev, u16 location)
 {
 	struct hclge_fd_rule *rule = NULL;
-- 
2.7.4

