Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81643485464
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbiAEOZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:37 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:31142 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240688AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JTWsX4pbLzRhds;
        Wed,  5 Jan 2022 22:22:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 06/15] net: hns3: create new set of common rss set APIs for PF and VF module
Date:   Wed, 5 Jan 2022 22:20:06 +0800
Message-ID: <20220105142015.51097-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, hns3 PF and VF rss module have two sets of rss set APIs to
configure rss. There is no need to keep two sets of these same APIs.

So this patch creates new set of common rss set APIs for PF and VF reuse.
These new APIs will be used to unify old APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.h         |   3 +
 .../hns3/hns3_common/hclge_comm_rss.c         | 180 ++++++++++++++++++
 .../hns3/hns3_common/hclge_comm_rss.h         |  48 ++++-
 3 files changed, 230 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 000c95534207..85296bf87e9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -110,6 +110,9 @@ enum HCLGE_COMM_API_CAP_BITS {
 
 enum hclge_comm_opcode_type {
 	HCLGE_COMM_OPC_QUERY_FW_VER		= 0x0001,
+	HCLGE_COMM_OPC_RSS_GENERIC_CFG		= 0x0D01,
+	HCLGE_COMM_OPC_RSS_INPUT_TUPLE		= 0x0D02,
+	HCLGE_COMM_OPC_RSS_INDIR_TABLE		= 0x0D07,
 	HCLGE_COMM_OPC_IMP_COMPAT_CFG		= 0x701A,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
index 70bf4504d41e..fde9b8098203 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -87,6 +87,92 @@ int hclge_comm_get_rss_tuple(struct hclge_comm_rss_cfg *rss_cfg, int flow_type,
 	return 0;
 }
 
+static void
+hclge_comm_append_rss_msb_info(struct hclge_comm_rss_ind_tbl_cmd *req,
+			       u16 qid, u32 j)
+{
+	u8 rss_msb_oft;
+	u8 rss_msb_val;
+
+	rss_msb_oft =
+		j * HCLGE_COMM_RSS_CFG_TBL_BW_H / BITS_PER_BYTE;
+	rss_msb_val = (qid >> HCLGE_COMM_RSS_CFG_TBL_BW_L & 0x1) <<
+		(j * HCLGE_COMM_RSS_CFG_TBL_BW_H % BITS_PER_BYTE);
+	req->rss_qid_h[rss_msb_oft] |= rss_msb_val;
+}
+
+int hclge_comm_set_rss_indir_table(struct hnae3_ae_dev *ae_dev,
+				   struct hclge_comm_hw *hw, const u16 *indir)
+{
+	struct hclge_comm_rss_ind_tbl_cmd *req;
+	struct hclge_desc desc;
+	u16 rss_cfg_tbl_num;
+	int ret;
+	u16 qid;
+	u16 i;
+	u32 j;
+
+	req = (struct hclge_comm_rss_ind_tbl_cmd *)desc.data;
+	rss_cfg_tbl_num = ae_dev->dev_specs.rss_ind_tbl_size /
+			  HCLGE_COMM_RSS_CFG_TBL_SIZE;
+
+	for (i = 0; i < rss_cfg_tbl_num; i++) {
+		hclge_comm_cmd_setup_basic_desc(&desc,
+						HCLGE_COMM_OPC_RSS_INDIR_TABLE,
+						false);
+
+		req->start_table_index =
+			cpu_to_le16(i * HCLGE_COMM_RSS_CFG_TBL_SIZE);
+		req->rss_set_bitmap =
+			cpu_to_le16(HCLGE_COMM_RSS_SET_BITMAP_MSK);
+		for (j = 0; j < HCLGE_COMM_RSS_CFG_TBL_SIZE; j++) {
+			qid = indir[i * HCLGE_COMM_RSS_CFG_TBL_SIZE + j];
+			req->rss_qid_l[j] = qid & 0xff;
+			hclge_comm_append_rss_msb_info(req, qid, j);
+		}
+		ret = hclge_comm_cmd_send(hw, &desc, 1);
+		if (ret) {
+			dev_err(&hw->cmq.csq.pdev->dev,
+				"failed to configure rss table, ret = %d.\n",
+				ret);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
+				   struct hclge_comm_hw *hw, bool is_pf,
+				   struct hclge_comm_rss_cfg *rss_cfg)
+{
+	struct hclge_comm_rss_input_tuple_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_RSS_INPUT_TUPLE,
+					false);
+
+	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
+
+	req->ipv4_tcp_en = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
+	req->ipv4_udp_en = rss_cfg->rss_tuple_sets.ipv4_udp_en;
+	req->ipv4_sctp_en = rss_cfg->rss_tuple_sets.ipv4_sctp_en;
+	req->ipv4_fragment_en = rss_cfg->rss_tuple_sets.ipv4_fragment_en;
+	req->ipv6_tcp_en = rss_cfg->rss_tuple_sets.ipv6_tcp_en;
+	req->ipv6_udp_en = rss_cfg->rss_tuple_sets.ipv6_udp_en;
+	req->ipv6_sctp_en = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
+	req->ipv6_fragment_en = rss_cfg->rss_tuple_sets.ipv6_fragment_en;
+
+	if (is_pf)
+		hclge_comm_get_rss_type(nic, &rss_cfg->rss_tuple_sets);
+
+	ret = hclge_comm_cmd_send(hw, &desc, 1);
+	if (ret)
+		dev_err(&hw->cmq.csq.pdev->dev,
+			"failed to configure rss input, ret = %d.\n", ret);
+	return ret;
+}
+
 void hclge_comm_get_rss_hash_info(struct hclge_comm_rss_cfg *rss_cfg, u8 *key,
 				  u8 *hfunc)
 {
@@ -122,6 +208,47 @@ void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss_cfg *rss_cfg,
 		indir[i] = rss_cfg->rss_indirection_tbl[i];
 }
 
+int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *hw, const u8 hfunc,
+				const u8 *key)
+{
+	struct hclge_comm_rss_config_cmd *req;
+	unsigned int key_offset = 0;
+	struct hclge_desc desc;
+	int key_counts;
+	int key_size;
+	int ret;
+
+	key_counts = HCLGE_COMM_RSS_KEY_SIZE;
+	req = (struct hclge_comm_rss_config_cmd *)desc.data;
+
+	while (key_counts) {
+		hclge_comm_cmd_setup_basic_desc(&desc,
+						HCLGE_COMM_OPC_RSS_GENERIC_CFG,
+						false);
+
+		req->hash_config |= (hfunc & HCLGE_COMM_RSS_HASH_ALGO_MASK);
+		req->hash_config |=
+			(key_offset << HCLGE_COMM_RSS_HASH_KEY_OFFSET_B);
+
+		key_size = min(HCLGE_COMM_RSS_HASH_KEY_NUM, key_counts);
+		memcpy(req->hash_key,
+		       key + key_offset * HCLGE_COMM_RSS_HASH_KEY_NUM,
+		       key_size);
+
+		key_counts -= key_size;
+		key_offset++;
+		ret = hclge_comm_cmd_send(hw, &desc, 1);
+		if (ret) {
+			dev_err(&hw->cmq.csq.pdev->dev,
+				"failed to configure RSS key, ret = %d.\n",
+				ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
 {
 	u8 hash_sets = nfc->data & RXH_L4_B_0_1 ? HCLGE_COMM_S_PORT_BIT : 0;
@@ -147,6 +274,59 @@ u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
 	return hash_sets;
 }
 
+int hclge_comm_init_rss_tuple_cmd(struct hclge_comm_rss_cfg *rss_cfg,
+				  struct ethtool_rxnfc *nfc,
+				  struct hnae3_ae_dev *ae_dev,
+				  struct hclge_comm_rss_input_tuple_cmd *req)
+{
+	u8 tuple_sets;
+
+	req->ipv4_tcp_en = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
+	req->ipv4_udp_en = rss_cfg->rss_tuple_sets.ipv4_udp_en;
+	req->ipv4_sctp_en = rss_cfg->rss_tuple_sets.ipv4_sctp_en;
+	req->ipv4_fragment_en = rss_cfg->rss_tuple_sets.ipv4_fragment_en;
+	req->ipv6_tcp_en = rss_cfg->rss_tuple_sets.ipv6_tcp_en;
+	req->ipv6_udp_en = rss_cfg->rss_tuple_sets.ipv6_udp_en;
+	req->ipv6_sctp_en = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
+	req->ipv6_fragment_en = rss_cfg->rss_tuple_sets.ipv6_fragment_en;
+
+	tuple_sets = hclge_comm_get_rss_hash_bits(nfc);
+	switch (nfc->flow_type) {
+	case TCP_V4_FLOW:
+		req->ipv4_tcp_en = tuple_sets;
+		break;
+	case TCP_V6_FLOW:
+		req->ipv6_tcp_en = tuple_sets;
+		break;
+	case UDP_V4_FLOW:
+		req->ipv4_udp_en = tuple_sets;
+		break;
+	case UDP_V6_FLOW:
+		req->ipv6_udp_en = tuple_sets;
+		break;
+	case SCTP_V4_FLOW:
+		req->ipv4_sctp_en = tuple_sets;
+		break;
+	case SCTP_V6_FLOW:
+		if (ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 &&
+		    (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)))
+			return -EINVAL;
+
+		req->ipv6_sctp_en = tuple_sets;
+		break;
+	case IPV4_FLOW:
+		req->ipv4_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+		break;
+	case IPV6_FLOW:
+		req->ipv6_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 u64 hclge_comm_convert_rss_tuple(u8 tuple_sets)
 {
 	u64 tuple_data = 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
index 66f9efa853ca..f32f99b02aa1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 
 #include "hnae3.h"
+#include "hclge_comm_cmd.h"
 
 #define HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ	0
 #define HCLGE_COMM_RSS_HASH_ALGO_SIMPLE		1
@@ -34,6 +35,20 @@ struct hclge_comm_rss_tuple_cfg {
 };
 
 #define HCLGE_COMM_RSS_KEY_SIZE		40
+#define HCLGE_COMM_RSS_CFG_TBL_SIZE	16
+#define HCLGE_COMM_RSS_CFG_TBL_BW_H	2U
+#define HCLGE_COMM_RSS_CFG_TBL_BW_L	8U
+#define HCLGE_COMM_RSS_CFG_TBL_SIZE_H	4
+#define HCLGE_COMM_RSS_SET_BITMAP_MSK	GENMASK(15, 0)
+#define HCLGE_COMM_RSS_HASH_ALGO_MASK	GENMASK(3, 0)
+#define HCLGE_COMM_RSS_HASH_KEY_OFFSET_B	4
+
+#define HCLGE_COMM_RSS_HASH_KEY_NUM	16
+struct hclge_comm_rss_config_cmd {
+	u8 hash_config;
+	u8 rsv[7];
+	u8 hash_key[HCLGE_COMM_RSS_HASH_KEY_NUM];
+};
 
 struct hclge_comm_rss_cfg {
 	u8 rss_hash_key[HCLGE_COMM_RSS_KEY_SIZE]; /* user configured hash keys */
@@ -46,6 +61,25 @@ struct hclge_comm_rss_cfg {
 	u32 rss_size;
 };
 
+struct hclge_comm_rss_input_tuple_cmd {
+	u8 ipv4_tcp_en;
+	u8 ipv4_udp_en;
+	u8 ipv4_sctp_en;
+	u8 ipv4_fragment_en;
+	u8 ipv6_tcp_en;
+	u8 ipv6_udp_en;
+	u8 ipv6_sctp_en;
+	u8 ipv6_fragment_en;
+	u8 rsv[16];
+};
+
+struct hclge_comm_rss_ind_tbl_cmd {
+	__le16 start_table_index;
+	__le16 rss_set_bitmap;
+	u8 rss_qid_h[HCLGE_COMM_RSS_CFG_TBL_SIZE_H];
+	u8 rss_qid_l[HCLGE_COMM_RSS_CFG_TBL_SIZE];
+};
+
 u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle);
 void hclge_comm_get_rss_type(struct hnae3_handle *nic,
 			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets);
@@ -58,8 +92,20 @@ int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cfg *rss_cfg,
 void hclge_comm_get_rss_hash_info(struct hclge_comm_rss_cfg *rss_cfg, u8 *key,
 				  u8 *hfunc);
 void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss_cfg *rss_cfg,
-				  u32 *indir, u16 rss_ind_tbl_size);
+				  u32 *indir, __le16 rss_ind_tbl_size);
+int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *hw, const u8 hfunc,
+				const u8 *key);
 u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc);
+int hclge_comm_init_rss_tuple_cmd(struct hclge_comm_rss_cfg *rss_cfg,
+				  struct ethtool_rxnfc *nfc,
+				  struct hnae3_ae_dev *ae_dev,
+				  struct hclge_comm_rss_input_tuple_cmd *req);
 u64 hclge_comm_convert_rss_tuple(u8 tuple_sets);
+int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
+				   struct hclge_comm_hw *hw,  bool is_pf,
+				   struct hclge_comm_rss_cfg *rss_cfg);
+int hclge_comm_set_rss_indir_table(struct hnae3_ae_dev *ae_dev,
+				   struct hclge_comm_hw *hw, const u16 *indir);
+
 
 #endif
-- 
2.33.0

