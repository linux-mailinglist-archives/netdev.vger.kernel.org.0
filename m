Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3918833B285
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhCOMXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:23:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13614 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCOMX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:23:29 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DzbBP6vb8z17Lbg;
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
Subject: [PATCH net-next 3/9] net: hns3: refactor for function hclge_fd_convert_tuple
Date:   Mon, 15 Mar 2021 20:23:45 +0800
Message-ID: <1615811031-55209-4-git-send-email-tanhuazhong@huawei.com>
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

Currently, there are too many branches for hclge_fd_convert_tuple().
And it may be more when add new tuples. Refactor it by sorting the
tuples according to their length. So it only needs several KEY_OPT
now, and being flexible to add new tuples.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 189 +++++++++------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  12 ++
 2 files changed, 97 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a17831f..3d601c9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -384,36 +384,56 @@ static const struct key_info meta_data_key_info[] = {
 };
 
 static const struct key_info tuple_key_info[] = {
-	{ OUTER_DST_MAC, 48},
-	{ OUTER_SRC_MAC, 48},
-	{ OUTER_VLAN_TAG_FST, 16},
-	{ OUTER_VLAN_TAG_SEC, 16},
-	{ OUTER_ETH_TYPE, 16},
-	{ OUTER_L2_RSV, 16},
-	{ OUTER_IP_TOS, 8},
-	{ OUTER_IP_PROTO, 8},
-	{ OUTER_SRC_IP, 32},
-	{ OUTER_DST_IP, 32},
-	{ OUTER_L3_RSV, 16},
-	{ OUTER_SRC_PORT, 16},
-	{ OUTER_DST_PORT, 16},
-	{ OUTER_L4_RSV, 32},
-	{ OUTER_TUN_VNI, 24},
-	{ OUTER_TUN_FLOW_ID, 8},
-	{ INNER_DST_MAC, 48},
-	{ INNER_SRC_MAC, 48},
-	{ INNER_VLAN_TAG_FST, 16},
-	{ INNER_VLAN_TAG_SEC, 16},
-	{ INNER_ETH_TYPE, 16},
-	{ INNER_L2_RSV, 16},
-	{ INNER_IP_TOS, 8},
-	{ INNER_IP_PROTO, 8},
-	{ INNER_SRC_IP, 32},
-	{ INNER_DST_IP, 32},
-	{ INNER_L3_RSV, 16},
-	{ INNER_SRC_PORT, 16},
-	{ INNER_DST_PORT, 16},
-	{ INNER_L4_RSV, 32},
+	{ OUTER_DST_MAC, 48, KEY_OPT_MAC, -1, -1 },
+	{ OUTER_SRC_MAC, 48, KEY_OPT_MAC, -1, -1 },
+	{ OUTER_VLAN_TAG_FST, 16, KEY_OPT_LE16, -1, -1 },
+	{ OUTER_VLAN_TAG_SEC, 16, KEY_OPT_LE16, -1, -1 },
+	{ OUTER_ETH_TYPE, 16, KEY_OPT_LE16, -1, -1 },
+	{ OUTER_L2_RSV, 16, KEY_OPT_LE16, -1, -1 },
+	{ OUTER_IP_TOS, 8, KEY_OPT_U8, -1, -1 },
+	{ OUTER_IP_PROTO, 8, KEY_OPT_U8, -1, -1 },
+	{ OUTER_SRC_IP, 32, KEY_OPT_IP, -1, -1 },
+	{ OUTER_DST_IP, 32, KEY_OPT_IP, -1, -1 },
+	{ OUTER_L3_RSV, 16, KEY_OPT_LE16, -1, -1 },
+	{ OUTER_SRC_PORT, 16, KEY_OPT_LE16, -1, -1 },
+	{ OUTER_DST_PORT, 16, KEY_OPT_LE16, -1, -1 },
+	{ OUTER_L4_RSV, 32, KEY_OPT_LE32, -1, -1 },
+	{ OUTER_TUN_VNI, 24, KEY_OPT_VNI, -1, -1 },
+	{ OUTER_TUN_FLOW_ID, 8, KEY_OPT_U8, -1, -1 },
+	{ INNER_DST_MAC, 48, KEY_OPT_MAC,
+	  offsetof(struct hclge_fd_rule, tuples.dst_mac),
+	  offsetof(struct hclge_fd_rule, tuples_mask.dst_mac) },
+	{ INNER_SRC_MAC, 48, KEY_OPT_MAC,
+	  offsetof(struct hclge_fd_rule, tuples.src_mac),
+	  offsetof(struct hclge_fd_rule, tuples_mask.src_mac) },
+	{ INNER_VLAN_TAG_FST, 16, KEY_OPT_LE16,
+	  offsetof(struct hclge_fd_rule, tuples.vlan_tag1),
+	  offsetof(struct hclge_fd_rule, tuples_mask.vlan_tag1) },
+	{ INNER_VLAN_TAG_SEC, 16, KEY_OPT_LE16, -1, -1 },
+	{ INNER_ETH_TYPE, 16, KEY_OPT_LE16,
+	  offsetof(struct hclge_fd_rule, tuples.ether_proto),
+	  offsetof(struct hclge_fd_rule, tuples_mask.ether_proto) },
+	{ INNER_L2_RSV, 16, KEY_OPT_LE16, -1, -1 },
+	{ INNER_IP_TOS, 8, KEY_OPT_U8,
+	  offsetof(struct hclge_fd_rule, tuples.ip_tos),
+	  offsetof(struct hclge_fd_rule, tuples_mask.ip_tos) },
+	{ INNER_IP_PROTO, 8, KEY_OPT_U8,
+	  offsetof(struct hclge_fd_rule, tuples.ip_proto),
+	  offsetof(struct hclge_fd_rule, tuples_mask.ip_proto) },
+	{ INNER_SRC_IP, 32, KEY_OPT_IP,
+	  offsetof(struct hclge_fd_rule, tuples.src_ip),
+	  offsetof(struct hclge_fd_rule, tuples_mask.src_ip) },
+	{ INNER_DST_IP, 32, KEY_OPT_IP,
+	  offsetof(struct hclge_fd_rule, tuples.dst_ip),
+	  offsetof(struct hclge_fd_rule, tuples_mask.dst_ip) },
+	{ INNER_L3_RSV, 16, KEY_OPT_LE16, -1, -1 },
+	{ INNER_SRC_PORT, 16, KEY_OPT_LE16,
+	  offsetof(struct hclge_fd_rule, tuples.src_port),
+	  offsetof(struct hclge_fd_rule, tuples_mask.src_port) },
+	{ INNER_DST_PORT, 16, KEY_OPT_LE16,
+	  offsetof(struct hclge_fd_rule, tuples.dst_port),
+	  offsetof(struct hclge_fd_rule, tuples_mask.dst_port) },
+	{ INNER_L4_RSV, 32, KEY_OPT_LE32, -1, -1 },
 };
 
 static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
@@ -5371,96 +5391,57 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 static bool hclge_fd_convert_tuple(u32 tuple_bit, u8 *key_x, u8 *key_y,
 				   struct hclge_fd_rule *rule)
 {
+	int offset, moffset, ip_offset;
+	enum HCLGE_FD_KEY_OPT key_opt;
 	u16 tmp_x_s, tmp_y_s;
 	u32 tmp_x_l, tmp_y_l;
+	u8 *p = (u8 *)rule;
 	int i;
 
-	if (rule->unused_tuple & tuple_bit)
+	if (rule->unused_tuple & BIT(tuple_bit))
 		return true;
 
-	switch (tuple_bit) {
-	case BIT(INNER_DST_MAC):
-		for (i = 0; i < ETH_ALEN; i++) {
-			calc_x(key_x[ETH_ALEN - 1 - i], rule->tuples.dst_mac[i],
-			       rule->tuples_mask.dst_mac[i]);
-			calc_y(key_y[ETH_ALEN - 1 - i], rule->tuples.dst_mac[i],
-			       rule->tuples_mask.dst_mac[i]);
-		}
+	key_opt = tuple_key_info[tuple_bit].key_opt;
+	offset = tuple_key_info[tuple_bit].offset;
+	moffset = tuple_key_info[tuple_bit].moffset;
 
-		return true;
-	case BIT(INNER_SRC_MAC):
-		for (i = 0; i < ETH_ALEN; i++) {
-			calc_x(key_x[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
-			       rule->tuples_mask.src_mac[i]);
-			calc_y(key_y[ETH_ALEN - 1 - i], rule->tuples.src_mac[i],
-			       rule->tuples_mask.src_mac[i]);
-		}
+	switch (key_opt) {
+	case KEY_OPT_U8:
+		calc_x(*key_x, p[offset], p[moffset]);
+		calc_y(*key_y, p[offset], p[moffset]);
 
 		return true;
-	case BIT(INNER_VLAN_TAG_FST):
-		calc_x(tmp_x_s, rule->tuples.vlan_tag1,
-		       rule->tuples_mask.vlan_tag1);
-		calc_y(tmp_y_s, rule->tuples.vlan_tag1,
-		       rule->tuples_mask.vlan_tag1);
+	case KEY_OPT_LE16:
+		calc_x(tmp_x_s, *(u16 *)(&p[offset]), *(u16 *)(&p[moffset]));
+		calc_y(tmp_y_s, *(u16 *)(&p[offset]), *(u16 *)(&p[moffset]));
 		*(__le16 *)key_x = cpu_to_le16(tmp_x_s);
 		*(__le16 *)key_y = cpu_to_le16(tmp_y_s);
 
 		return true;
-	case BIT(INNER_ETH_TYPE):
-		calc_x(tmp_x_s, rule->tuples.ether_proto,
-		       rule->tuples_mask.ether_proto);
-		calc_y(tmp_y_s, rule->tuples.ether_proto,
-		       rule->tuples_mask.ether_proto);
-		*(__le16 *)key_x = cpu_to_le16(tmp_x_s);
-		*(__le16 *)key_y = cpu_to_le16(tmp_y_s);
-
-		return true;
-	case BIT(INNER_IP_TOS):
-		calc_x(*key_x, rule->tuples.ip_tos, rule->tuples_mask.ip_tos);
-		calc_y(*key_y, rule->tuples.ip_tos, rule->tuples_mask.ip_tos);
-
-		return true;
-	case BIT(INNER_IP_PROTO):
-		calc_x(*key_x, rule->tuples.ip_proto,
-		       rule->tuples_mask.ip_proto);
-		calc_y(*key_y, rule->tuples.ip_proto,
-		       rule->tuples_mask.ip_proto);
-
-		return true;
-	case BIT(INNER_SRC_IP):
-		calc_x(tmp_x_l, rule->tuples.src_ip[IPV4_INDEX],
-		       rule->tuples_mask.src_ip[IPV4_INDEX]);
-		calc_y(tmp_y_l, rule->tuples.src_ip[IPV4_INDEX],
-		       rule->tuples_mask.src_ip[IPV4_INDEX]);
+	case KEY_OPT_LE32:
+		calc_x(tmp_x_l, *(u32 *)(&p[offset]), *(u32 *)(&p[moffset]));
+		calc_y(tmp_y_l, *(u32 *)(&p[offset]), *(u32 *)(&p[moffset]));
 		*(__le32 *)key_x = cpu_to_le32(tmp_x_l);
 		*(__le32 *)key_y = cpu_to_le32(tmp_y_l);
 
 		return true;
-	case BIT(INNER_DST_IP):
-		calc_x(tmp_x_l, rule->tuples.dst_ip[IPV4_INDEX],
-		       rule->tuples_mask.dst_ip[IPV4_INDEX]);
-		calc_y(tmp_y_l, rule->tuples.dst_ip[IPV4_INDEX],
-		       rule->tuples_mask.dst_ip[IPV4_INDEX]);
-		*(__le32 *)key_x = cpu_to_le32(tmp_x_l);
-		*(__le32 *)key_y = cpu_to_le32(tmp_y_l);
-
-		return true;
-	case BIT(INNER_SRC_PORT):
-		calc_x(tmp_x_s, rule->tuples.src_port,
-		       rule->tuples_mask.src_port);
-		calc_y(tmp_y_s, rule->tuples.src_port,
-		       rule->tuples_mask.src_port);
-		*(__le16 *)key_x = cpu_to_le16(tmp_x_s);
-		*(__le16 *)key_y = cpu_to_le16(tmp_y_s);
+	case KEY_OPT_MAC:
+		for (i = 0; i < ETH_ALEN; i++) {
+			calc_x(key_x[ETH_ALEN - 1 - i], p[offset + i],
+			       p[moffset + i]);
+			calc_y(key_y[ETH_ALEN - 1 - i], p[offset + i],
+			       p[moffset + i]);
+		}
 
 		return true;
-	case BIT(INNER_DST_PORT):
-		calc_x(tmp_x_s, rule->tuples.dst_port,
-		       rule->tuples_mask.dst_port);
-		calc_y(tmp_y_s, rule->tuples.dst_port,
-		       rule->tuples_mask.dst_port);
-		*(__le16 *)key_x = cpu_to_le16(tmp_x_s);
-		*(__le16 *)key_y = cpu_to_le16(tmp_y_s);
+	case KEY_OPT_IP:
+		ip_offset = IPV4_INDEX * sizeof(u32);
+		calc_x(tmp_x_l, *(u32 *)(&p[offset + ip_offset]),
+		       *(u32 *)(&p[moffset + ip_offset]));
+		calc_y(tmp_y_l, *(u32 *)(&p[offset + ip_offset]),
+		       *(u32 *)(&p[moffset + ip_offset]));
+		*(__le32 *)key_x = cpu_to_le32(tmp_x_l);
+		*(__le32 *)key_y = cpu_to_le32(tmp_y_l);
 
 		return true;
 	default:
@@ -5548,12 +5529,12 @@ static int hclge_config_key(struct hclge_dev *hdev, u8 stage,
 
 	for (i = 0 ; i < MAX_TUPLE; i++) {
 		bool tuple_valid;
-		u32 check_tuple;
 
 		tuple_size = tuple_key_info[i].key_length / 8;
-		check_tuple = key_cfg->tuple_active & BIT(i);
+		if (!(key_cfg->tuple_active & BIT(i)))
+			continue;
 
-		tuple_valid = hclge_fd_convert_tuple(check_tuple, cur_key_x,
+		tuple_valid = hclge_fd_convert_tuple(i, cur_key_x,
 						     cur_key_y, rule);
 		if (tuple_valid) {
 			cur_key_x += tuple_size;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 19d7f28..6fe7455 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -548,9 +548,21 @@ enum HCLGE_FD_META_DATA {
 	MAX_META_DATA,
 };
 
+enum HCLGE_FD_KEY_OPT {
+	KEY_OPT_U8,
+	KEY_OPT_LE16,
+	KEY_OPT_LE32,
+	KEY_OPT_MAC,
+	KEY_OPT_IP,
+	KEY_OPT_VNI,
+};
+
 struct key_info {
 	u8 key_type;
 	u8 key_length; /* use bit as unit */
+	enum HCLGE_FD_KEY_OPT key_opt;
+	int offset;
+	int moffset;
 };
 
 #define MAX_KEY_LENGTH	400
-- 
2.7.4

