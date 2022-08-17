Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802C2597180
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240206AbiHQOjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240218AbiHQOjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:39:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875219C52A;
        Wed, 17 Aug 2022 07:38:00 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M79Ww5WM7z1N7L5;
        Wed, 17 Aug 2022 22:34:36 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 22:37:57 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 22:37:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <idosch@nvidia.com>,
        <linux@rempel-privat.de>, <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/2] net: hns3: support set/get VxLAN rule of rx flow director by ethtool
Date:   Wed, 17 Aug 2022 22:35:38 +0800
Message-ID: <20220817143538.43717-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817143538.43717-1-huangguangbin2@huawei.com>
References: <20220817143538.43717-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support rule type of vxlan4 and vxlan6 for rx flow
director by command ethtool -u/-U.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 272 +++++++++++++++++-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   2 +
 2 files changed, 271 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fae79764dc44..ed4e6732a287 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -15,6 +15,7 @@
 #include <linux/crash_dump.h>
 #include <net/ipv6.h>
 #include <net/rtnetlink.h>
+#include <net/vxlan.h>
 #include "hclge_cmd.h"
 #include "hclge_dcb.h"
 #include "hclge_main.h"
@@ -427,7 +428,9 @@ static const struct key_info tuple_key_info[] = {
 	{ OUTER_SRC_PORT, 16, KEY_OPT_LE16, -1, -1 },
 	{ OUTER_DST_PORT, 16, KEY_OPT_LE16, -1, -1 },
 	{ OUTER_L4_RSV, 32, KEY_OPT_LE32, -1, -1 },
-	{ OUTER_TUN_VNI, 24, KEY_OPT_VNI, -1, -1 },
+	{ OUTER_TUN_VNI, 24, KEY_OPT_VNI,
+	  offsetof(struct hclge_fd_rule, tuples.outer_tun_vni),
+	  offsetof(struct hclge_fd_rule, tuples_mask.outer_tun_vni) },
 	{ OUTER_TUN_FLOW_ID, 8, KEY_OPT_U8, -1, -1 },
 	{ INNER_DST_MAC, 48, KEY_OPT_MAC,
 	  offsetof(struct hclge_fd_rule, tuples.dst_mac),
@@ -5369,8 +5372,9 @@ static int hclge_init_fd_config(struct hclge_dev *hdev)
 
 	/* If use max 400bit key, we can support tuples for ether type */
 	if (hdev->fd_cfg.fd_mode == HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1) {
-		key_cfg->tuple_active |=
-				BIT(INNER_DST_MAC) | BIT(INNER_SRC_MAC);
+		key_cfg->tuple_active |= BIT(INNER_DST_MAC) |
+					 BIT(INNER_SRC_MAC) |
+					 BIT(OUTER_TUN_VNI);
 		if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
 			key_cfg->tuple_active |= HCLGE_FD_TUPLE_USER_DEF_TUPLES;
 	}
@@ -5482,6 +5486,8 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 static bool hclge_fd_convert_tuple(u32 tuple_bit, u8 *key_x, u8 *key_y,
 				   struct hclge_fd_rule *rule)
 {
+#define HCLGE_VNI_LENGTH	3
+
 	int offset, moffset, ip_offset;
 	enum HCLGE_FD_KEY_OPT key_opt;
 	u16 tmp_x_s, tmp_y_s;
@@ -5534,6 +5540,14 @@ static bool hclge_fd_convert_tuple(u32 tuple_bit, u8 *key_x, u8 *key_y,
 		*(__le32 *)key_x = cpu_to_le32(tmp_x_l);
 		*(__le32 *)key_y = cpu_to_le32(tmp_y_l);
 
+		return true;
+	case KEY_OPT_VNI:
+		calc_x(tmp_x_l, *(u32 *)(&p[offset]), *(u32 *)(&p[moffset]));
+		calc_y(tmp_y_l, *(u32 *)(&p[offset]), *(u32 *)(&p[moffset]));
+		for (i = 0; i < HCLGE_VNI_LENGTH; i++) {
+			key_x[i] = (cpu_to_le32(tmp_x_l) >> (i * BITS_PER_BYTE)) & 0xFF;
+			key_y[i] = (cpu_to_le32(tmp_y_l) >> (i * BITS_PER_BYTE)) & 0xFF;
+		}
 		return true;
 	default:
 		return false;
@@ -5756,6 +5770,45 @@ static int hclge_fd_check_ip4_tuple(struct ethtool_usrip4_spec *spec,
 	return 0;
 }
 
+static int hclge_fd_check_vxlan4_tuple(struct ethtool_rx_flow_spec *fs,
+				       u32 *unused_tuple)
+{
+	struct ethtool_vxlan4_spec *spec = &fs->h_u.vxlan_ip4_spec;
+	struct ethtool_vxlan4_spec *mask = &fs->m_u.vxlan_ip4_spec;
+
+	/* Vni is only 24 bits and must be greater than 0, and it can not be
+	 * masked.
+	 */
+	if (!spec->vni || be32_to_cpu(spec->vni) >= VXLAN_N_VID ||
+	    mask->vni != HCLGE_FD_VXLAN_VNI_UNMASK || !unused_tuple)
+		return -EINVAL;
+
+	*unused_tuple |= BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
+
+	if (is_zero_ether_addr(spec->src))
+		*unused_tuple |= BIT(INNER_SRC_MAC);
+
+	if (is_zero_ether_addr(spec->dst))
+		*unused_tuple |= BIT(INNER_DST_MAC);
+
+	if (!spec->eth_type)
+		*unused_tuple |= BIT(INNER_ETH_TYPE);
+
+	if (!spec->ip4src)
+		*unused_tuple |= BIT(INNER_SRC_IP);
+
+	if (!spec->ip4dst)
+		*unused_tuple |= BIT(INNER_DST_IP);
+
+	if (!spec->tos)
+		*unused_tuple |= BIT(INNER_IP_TOS);
+
+	if (!spec->l4_proto)
+		*unused_tuple |= BIT(INNER_IP_PROTO);
+
+	return 0;
+}
+
 static int hclge_fd_check_tcpip6_tuple(struct ethtool_tcpip6_spec *spec,
 				       u32 *unused_tuple)
 {
@@ -5811,6 +5864,45 @@ static int hclge_fd_check_ip6_tuple(struct ethtool_usrip6_spec *spec,
 	return 0;
 }
 
+static int hclge_fd_check_vxlan6_tuple(struct ethtool_rx_flow_spec *fs,
+				       u32 *unused_tuple)
+{
+	struct ethtool_vxlan6_spec *spec = &fs->h_u.vxlan_ip6_spec;
+	struct ethtool_vxlan6_spec *mask = &fs->m_u.vxlan_ip6_spec;
+
+	/* Vni is only 24 bits and must be greater than 0, and it can not be
+	 * masked.
+	 */
+	if (!spec->vni || be32_to_cpu(spec->vni) >= VXLAN_N_VID ||
+	    mask->vni != HCLGE_FD_VXLAN_VNI_UNMASK || !unused_tuple)
+		return -EINVAL;
+
+	*unused_tuple |= BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
+
+	if (is_zero_ether_addr(spec->src))
+		*unused_tuple |= BIT(INNER_SRC_MAC);
+
+	if (is_zero_ether_addr(spec->dst))
+		*unused_tuple |= BIT(INNER_DST_MAC);
+
+	if (!spec->eth_type)
+		*unused_tuple |= BIT(INNER_ETH_TYPE);
+
+	if (ipv6_addr_any((struct in6_addr *)spec->ip6src))
+		*unused_tuple |= BIT(INNER_SRC_IP);
+
+	if (ipv6_addr_any((struct in6_addr *)spec->ip6dst))
+		*unused_tuple |= BIT(INNER_DST_IP);
+
+	if (!spec->tclass)
+		*unused_tuple |= BIT(INNER_IP_TOS);
+
+	if (!spec->l4_proto)
+		*unused_tuple |= BIT(INNER_IP_PROTO);
+
+	return 0;
+}
+
 static int hclge_fd_check_ether_tuple(struct ethhdr *spec, u32 *unused_tuple)
 {
 	if (!spec || !unused_tuple)
@@ -5993,6 +6085,9 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 		ret = hclge_fd_check_ip4_tuple(&fs->h_u.usr_ip4_spec,
 					       unused_tuple);
 		break;
+	case VXLAN_V4_FLOW:
+		ret = hclge_fd_check_vxlan4_tuple(fs, unused_tuple);
+		break;
 	case SCTP_V6_FLOW:
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
@@ -6003,6 +6098,9 @@ static int hclge_fd_check_spec(struct hclge_dev *hdev,
 		ret = hclge_fd_check_ip6_tuple(&fs->h_u.usr_ip6_spec,
 					       unused_tuple);
 		break;
+	case VXLAN_V6_FLOW:
+		ret = hclge_fd_check_vxlan6_tuple(fs, unused_tuple);
+		break;
 	case ETHER_FLOW:
 		if (hdev->fd_cfg.fd_mode !=
 			HCLGE_FD_MODE_DEPTH_2K_WIDTH_400B_STAGE_1) {
@@ -6085,6 +6183,37 @@ static void hclge_fd_get_ip4_tuple(struct hclge_dev *hdev,
 	rule->tuples_mask.ether_proto = 0xFFFF;
 }
 
+static void hclge_fd_get_vxlan4_tuple(struct ethtool_rx_flow_spec *fs,
+				      struct hclge_fd_rule *rule)
+{
+	struct ethtool_vxlan4_spec *h = &fs->h_u.vxlan_ip4_spec;
+	struct ethtool_vxlan4_spec *m = &fs->m_u.vxlan_ip4_spec;
+
+	rule->tuples.outer_tun_vni = be32_to_cpu(h->vni);
+	rule->tuples_mask.outer_tun_vni = be32_to_cpu(m->vni);
+
+	ether_addr_copy(rule->tuples.src_mac, h->src);
+	ether_addr_copy(rule->tuples_mask.src_mac, m->src);
+
+	ether_addr_copy(rule->tuples.dst_mac, h->dst);
+	ether_addr_copy(rule->tuples_mask.dst_mac, m->dst);
+
+	rule->tuples.ether_proto = be16_to_cpu(h->eth_type);
+	rule->tuples_mask.ether_proto = be16_to_cpu(m->eth_type);
+
+	rule->tuples.ip_tos = h->tos;
+	rule->tuples_mask.ip_tos = m->tos;
+
+	rule->tuples.ip_proto = h->l4_proto;
+	rule->tuples_mask.ip_proto = m->l4_proto;
+
+	rule->tuples.src_ip[IPV4_INDEX] = be32_to_cpu(h->ip4src);
+	rule->tuples_mask.src_ip[IPV4_INDEX] = be32_to_cpu(m->ip4src);
+
+	rule->tuples.dst_ip[IPV4_INDEX] = be32_to_cpu(h->ip4dst);
+	rule->tuples_mask.dst_ip[IPV4_INDEX] = be32_to_cpu(m->ip4dst);
+}
+
 static void hclge_fd_get_tcpip6_tuple(struct hclge_dev *hdev,
 				      struct ethtool_rx_flow_spec *fs,
 				      struct hclge_fd_rule *rule, u8 ip_proto)
@@ -6139,6 +6268,37 @@ static void hclge_fd_get_ip6_tuple(struct hclge_dev *hdev,
 	rule->tuples_mask.ether_proto = 0xFFFF;
 }
 
+static void hclge_fd_get_vxlan6_tuple(struct ethtool_rx_flow_spec *fs,
+				      struct hclge_fd_rule *rule)
+{
+	struct ethtool_vxlan6_spec *h = &fs->h_u.vxlan_ip6_spec;
+	struct ethtool_vxlan6_spec *m = &fs->m_u.vxlan_ip6_spec;
+
+	rule->tuples.outer_tun_vni = be32_to_cpu(h->vni);
+	rule->tuples_mask.outer_tun_vni = be32_to_cpu(m->vni);
+
+	ether_addr_copy(rule->tuples.src_mac, h->src);
+	ether_addr_copy(rule->tuples_mask.src_mac, m->src);
+
+	ether_addr_copy(rule->tuples.dst_mac, h->dst);
+	ether_addr_copy(rule->tuples_mask.dst_mac, m->dst);
+
+	rule->tuples.ether_proto = be16_to_cpu(h->eth_type);
+	rule->tuples_mask.ether_proto = be16_to_cpu(m->eth_type);
+
+	rule->tuples.ip_tos = h->tclass;
+	rule->tuples_mask.ip_tos = m->tclass;
+
+	rule->tuples.ip_proto = h->l4_proto;
+	rule->tuples_mask.ip_proto = m->l4_proto;
+
+	be32_to_cpu_array(rule->tuples.src_ip, h->ip6src, IPV6_SIZE);
+	be32_to_cpu_array(rule->tuples_mask.src_ip, m->ip6src, IPV6_SIZE);
+
+	be32_to_cpu_array(rule->tuples.dst_ip, h->ip6dst, IPV6_SIZE);
+	be32_to_cpu_array(rule->tuples_mask.dst_ip, m->ip6dst, IPV6_SIZE);
+}
+
 static void hclge_fd_get_ether_tuple(struct hclge_dev *hdev,
 				     struct ethtool_rx_flow_spec *fs,
 				     struct hclge_fd_rule *rule)
@@ -6196,6 +6356,9 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 	case IP_USER_FLOW:
 		hclge_fd_get_ip4_tuple(hdev, fs, rule);
 		break;
+	case VXLAN_V4_FLOW:
+		hclge_fd_get_vxlan4_tuple(fs, rule);
+		break;
 	case SCTP_V6_FLOW:
 		hclge_fd_get_tcpip6_tuple(hdev, fs, rule, IPPROTO_SCTP);
 		break;
@@ -6208,6 +6371,9 @@ static int hclge_fd_get_tuple(struct hclge_dev *hdev,
 	case IPV6_USER_FLOW:
 		hclge_fd_get_ip6_tuple(hdev, fs, rule);
 		break;
+	case VXLAN_V6_FLOW:
+		hclge_fd_get_vxlan6_tuple(fs, rule);
+		break;
 	case ETHER_FLOW:
 		hclge_fd_get_ether_tuple(hdev, fs, rule);
 		break;
@@ -6554,6 +6720,48 @@ static void hclge_fd_get_ip4_info(struct hclge_fd_rule *rule,
 	spec->ip_ver = ETH_RX_NFC_IP4;
 }
 
+static void hclge_fd_get_vxlan4_info(struct hclge_fd_rule *rule,
+				     struct ethtool_vxlan4_spec *spec,
+				     struct ethtool_vxlan4_spec *spec_mask)
+{
+	spec->vni = cpu_to_be32(rule->tuples.outer_tun_vni);
+	spec_mask->vni = rule->unused_tuple & BIT(OUTER_TUN_VNI) ? 0 :
+			 cpu_to_be32(rule->tuples_mask.outer_tun_vni);
+
+	ether_addr_copy(spec->src, rule->tuples.src_mac);
+	ether_addr_copy(spec->dst, rule->tuples.dst_mac);
+
+	if (rule->unused_tuple & BIT(INNER_SRC_MAC))
+		eth_zero_addr(spec_mask->src);
+	else
+		ether_addr_copy(spec_mask->src, rule->tuples_mask.src_mac);
+
+	if (rule->unused_tuple & BIT(INNER_DST_MAC))
+		eth_zero_addr(spec_mask->dst);
+	else
+		ether_addr_copy(spec_mask->dst, rule->tuples_mask.dst_mac);
+
+	spec->eth_type = cpu_to_be16(rule->tuples.ether_proto);
+	spec_mask->eth_type = rule->unused_tuple & BIT(INNER_ETH_TYPE) ? 0 :
+			     cpu_to_be16(rule->tuples_mask.ether_proto);
+
+	spec->tos = rule->tuples.ip_tos;
+	spec_mask->tos = rule->unused_tuple & BIT(INNER_IP_TOS) ? 0 :
+			 rule->tuples_mask.ip_tos;
+
+	spec->l4_proto = rule->tuples.ip_proto;
+	spec_mask->l4_proto = rule->unused_tuple & BIT(INNER_IP_PROTO) ? 0 :
+			     rule->tuples_mask.ip_proto;
+
+	spec->ip4src = cpu_to_be32(rule->tuples.src_ip[IPV4_INDEX]);
+	spec_mask->ip4src = rule->unused_tuple & BIT(INNER_SRC_IP) ? 0 :
+			    cpu_to_be32(rule->tuples_mask.src_ip[IPV4_INDEX]);
+
+	spec->ip4dst = cpu_to_be32(rule->tuples.dst_ip[IPV4_INDEX]);
+	spec_mask->ip4dst = rule->unused_tuple & BIT(INNER_DST_IP) ? 0 :
+			    cpu_to_be32(rule->tuples_mask.dst_ip[IPV4_INDEX]);
+}
+
 static void hclge_fd_get_tcpip6_info(struct hclge_fd_rule *rule,
 				     struct ethtool_tcpip6_spec *spec,
 				     struct ethtool_tcpip6_spec *spec_mask)
@@ -6614,6 +6822,56 @@ static void hclge_fd_get_ip6_info(struct hclge_fd_rule *rule,
 			0 : rule->tuples_mask.ip_proto;
 }
 
+static void hclge_fd_get_vxlan6_info(struct hclge_fd_rule *rule,
+				     struct ethtool_vxlan6_spec *spec,
+				     struct ethtool_vxlan6_spec *spec_mask)
+{
+	spec->vni = cpu_to_be32(rule->tuples.outer_tun_vni);
+	spec_mask->vni = rule->unused_tuple & BIT(OUTER_TUN_VNI) ? 0 :
+			 cpu_to_be32(rule->tuples_mask.outer_tun_vni);
+
+	ether_addr_copy(spec->src, rule->tuples.src_mac);
+	ether_addr_copy(spec->dst, rule->tuples.dst_mac);
+
+	if (rule->unused_tuple & BIT(INNER_SRC_MAC))
+		eth_zero_addr(spec_mask->src);
+	else
+		ether_addr_copy(spec_mask->src, rule->tuples_mask.src_mac);
+
+	if (rule->unused_tuple & BIT(INNER_DST_MAC))
+		eth_zero_addr(spec_mask->dst);
+	else
+		ether_addr_copy(spec_mask->dst, rule->tuples_mask.dst_mac);
+
+	spec->eth_type = cpu_to_be16(rule->tuples.ether_proto);
+	spec_mask->eth_type = rule->unused_tuple & BIT(INNER_ETH_TYPE) ? 0 :
+			     cpu_to_be16(rule->tuples_mask.ether_proto);
+
+	spec->tclass = rule->tuples.ip_tos;
+	spec_mask->tclass = rule->unused_tuple & BIT(INNER_IP_TOS) ? 0 :
+			    rule->tuples_mask.ip_tos;
+
+	spec->l4_proto = rule->tuples.ip_proto;
+	spec_mask->l4_proto = rule->unused_tuple & BIT(INNER_IP_PROTO) ? 0 :
+			     rule->tuples_mask.ip_proto;
+
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
+}
+
 static void hclge_fd_get_ether_info(struct hclge_fd_rule *rule,
 				    struct ethhdr *spec,
 				    struct ethhdr *spec_mask)
@@ -6740,6 +6998,10 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 		hclge_fd_get_ip4_info(rule, &fs->h_u.usr_ip4_spec,
 				      &fs->m_u.usr_ip4_spec);
 		break;
+	case VXLAN_V4_FLOW:
+		hclge_fd_get_vxlan4_info(rule, &fs->h_u.vxlan_ip4_spec,
+					 &fs->m_u.vxlan_ip4_spec);
+		break;
 	case SCTP_V6_FLOW:
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
@@ -6750,6 +7012,10 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 		hclge_fd_get_ip6_info(rule, &fs->h_u.usr_ip6_spec,
 				      &fs->m_u.usr_ip6_spec);
 		break;
+	case VXLAN_V6_FLOW:
+		hclge_fd_get_vxlan6_info(rule, &fs->h_u.vxlan_ip6_spec,
+					 &fs->m_u.vxlan_ip6_spec);
+		break;
 	/* The flow type of fd rule has been checked before adding in to rule
 	 * list. As other flow types have been handled, it must be ETHER_FLOW
 	 * for the default case
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 18caddd541f8..db1681709868 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -594,6 +594,7 @@ struct key_info {
 #define HCLGE_FD_USER_DEF_DATA		GENMASK(15, 0)
 #define HCLGE_FD_USER_DEF_OFFSET	GENMASK(15, 0)
 #define HCLGE_FD_USER_DEF_OFFSET_UNMASK	GENMASK(15, 0)
+#define HCLGE_FD_VXLAN_VNI_UNMASK	GENMASK(31, 0)
 
 /* assigned by firmware, the real filter number for each pf may be less */
 #define MAX_FD_FILTER_NUM	4096
@@ -687,6 +688,7 @@ struct hclge_fd_rule_tuples {
 	u32 l4_user_def;
 	u8 ip_tos;
 	u8 ip_proto;
+	u32 outer_tun_vni;
 };
 
 struct hclge_fd_rule {
-- 
2.33.0

