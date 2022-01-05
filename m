Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC59148546B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbiAEOZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:48 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29325 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240691AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JTWvt6Nd6zbjn1;
        Wed,  5 Jan 2022 22:24:42 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 09/15] net: hns3: create new set of common rss init APIs for PF and VF reuse
Date:   Wed, 5 Jan 2022 22:20:09 +0800
Message-ID: <20220105142015.51097-10-huangguangbin2@huawei.com>
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

This patch creates new set of common rss init APIs for PF and VF rss
module. Subfunctions called by rss init process are also created include
rss tuple configuration and rss indirect table configuration.

These new common rss init APIs will be used to replace the old PF and VF
rss init APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
 .../hns3/hns3_common/hclge_comm_rss.c         | 184 +++++++++++++++++-
 .../hns3/hns3_common/hclge_comm_rss.h         |  33 +++-
 3 files changed, 213 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 85296bf87e9f..eb034f8f87db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -113,6 +113,7 @@ enum hclge_comm_opcode_type {
 	HCLGE_COMM_OPC_RSS_GENERIC_CFG		= 0x0D01,
 	HCLGE_COMM_OPC_RSS_INPUT_TUPLE		= 0x0D02,
 	HCLGE_COMM_OPC_RSS_INDIR_TABLE		= 0x0D07,
+	HCLGE_COMM_OPC_RSS_TC_MODE		= 0x0D08,
 	HCLGE_COMM_OPC_IMP_COMPAT_CFG		= 0x701A,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
index fde9b8098203..700d1f4dc090 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -3,8 +3,190 @@
 #include <linux/skbuff.h>
 
 #include "hnae3.h"
+#include "hclge_comm_cmd.h"
 #include "hclge_comm_rss.h"
 
+static const u8 hclge_comm_hash_key[] = {
+	0x6D, 0x5A, 0x56, 0xDA, 0x25, 0x5B, 0x0E, 0xC2,
+	0x41, 0x67, 0x25, 0x3D, 0x43, 0xA3, 0x8F, 0xB0,
+	0xD0, 0xCA, 0x2B, 0xCB, 0xAE, 0x7B, 0x30, 0xB4,
+	0x77, 0xCB, 0x2D, 0xA3, 0x80, 0x30, 0xF2, 0x0C,
+	0x6A, 0x42, 0xB7, 0x3B, 0xBE, 0xAC, 0x01, 0xFA
+};
+
+static void
+hclge_comm_init_rss_tuple(struct hnae3_ae_dev *ae_dev,
+			  struct hclge_comm_rss_tuple_cfg *rss_tuple_cfg)
+{
+	rss_tuple_cfg->ipv4_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_tuple_cfg->ipv4_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_tuple_cfg->ipv4_sctp_en = HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
+	rss_tuple_cfg->ipv4_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_tuple_cfg->ipv6_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_tuple_cfg->ipv6_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_tuple_cfg->ipv6_sctp_en =
+		ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
+		HCLGE_COMM_RSS_INPUT_TUPLE_SCTP_NO_PORT :
+		HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
+	rss_tuple_cfg->ipv6_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+}
+
+int hclge_comm_rss_init_cfg(struct hnae3_handle *nic,
+			    struct hnae3_ae_dev *ae_dev,
+			    struct hclge_comm_rss_cfg *rss_cfg)
+{
+	u16 rss_ind_tbl_size = ae_dev->dev_specs.rss_ind_tbl_size;
+	int rss_algo = HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ;
+	u16 *rss_ind_tbl;
+
+	if (nic->flags & HNAE3_SUPPORT_VF)
+		rss_cfg->rss_size = nic->kinfo.rss_size;
+
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+		rss_algo = HCLGE_COMM_RSS_HASH_ALGO_SIMPLE;
+
+	hclge_comm_init_rss_tuple(ae_dev, &rss_cfg->rss_tuple_sets);
+
+	rss_cfg->rss_algo = rss_algo;
+
+	rss_ind_tbl = devm_kcalloc(&ae_dev->pdev->dev, rss_ind_tbl_size,
+				   sizeof(*rss_ind_tbl), GFP_KERNEL);
+	if (!rss_ind_tbl)
+		return -ENOMEM;
+
+	rss_cfg->rss_indirection_tbl = rss_ind_tbl;
+	memcpy(rss_cfg->rss_hash_key, hclge_comm_hash_key,
+	       HCLGE_COMM_RSS_KEY_SIZE);
+
+	hclge_comm_rss_indir_init_cfg(ae_dev, rss_cfg);
+
+	return 0;
+}
+
+void hclge_comm_get_rss_tc_info(u16 rss_size, u8 hw_tc_map, u16 *tc_offset,
+				u16 *tc_valid, u16 *tc_size)
+{
+	u16 roundup_size;
+	u32 i;
+
+	roundup_size = roundup_pow_of_two(rss_size);
+	roundup_size = ilog2(roundup_size);
+
+	for (i = 0; i < HCLGE_COMM_MAX_TC_NUM; i++) {
+		tc_valid[i] = 1;
+		tc_size[i] = roundup_size;
+		tc_offset[i] = (hw_tc_map & BIT(i)) ? rss_size * i : 0;
+	}
+}
+
+int hclge_comm_set_rss_tc_mode(struct hclge_comm_hw *hw, u16 *tc_offset,
+			       u16 *tc_valid, u16 *tc_size)
+{
+	struct hclge_comm_rss_tc_mode_cmd *req;
+	struct hclge_desc desc;
+	unsigned int i;
+	int ret;
+
+	req = (struct hclge_comm_rss_tc_mode_cmd *)desc.data;
+
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_RSS_TC_MODE,
+					false);
+	for (i = 0; i < HCLGE_COMM_MAX_TC_NUM; i++) {
+		u16 mode = 0;
+
+		hnae3_set_bit(mode, HCLGE_COMM_RSS_TC_VALID_B,
+			      (tc_valid[i] & 0x1));
+		hnae3_set_field(mode, HCLGE_COMM_RSS_TC_SIZE_M,
+				HCLGE_COMM_RSS_TC_SIZE_S, tc_size[i]);
+		hnae3_set_bit(mode, HCLGE_COMM_RSS_TC_SIZE_MSB_B,
+			      tc_size[i] >> HCLGE_COMM_RSS_TC_SIZE_MSB_OFFSET &
+			      0x1);
+		hnae3_set_field(mode, HCLGE_COMM_RSS_TC_OFFSET_M,
+				HCLGE_COMM_RSS_TC_OFFSET_S, tc_offset[i]);
+
+		req->rss_tc_mode[i] = cpu_to_le16(mode);
+	}
+
+	ret = hclge_comm_cmd_send(hw, &desc, 1);
+	if (ret)
+		dev_err(&hw->cmq.csq.pdev->dev,
+			"failed to set rss tc mode, ret = %d.\n", ret);
+
+	return ret;
+}
+
+int hclge_comm_set_rss_hash_key(struct hclge_comm_rss_cfg *rss_cfg,
+				struct hclge_comm_hw *hw, const u8 *key,
+				const u8 hfunc)
+{
+	u8 hash_algo;
+	int ret;
+
+	ret = hclge_comm_parse_rss_hfunc(rss_cfg, hfunc, &hash_algo);
+	if (ret)
+		return ret;
+
+	/* Set the RSS Hash Key if specififed by the user */
+	if (key) {
+		ret = hclge_comm_set_rss_algo_key(hw, hash_algo, key);
+		if (ret)
+			return ret;
+
+		/* Update the shadow RSS key with user specified qids */
+		memcpy(rss_cfg->rss_hash_key, key, HCLGE_COMM_RSS_KEY_SIZE);
+	} else {
+		ret = hclge_comm_set_rss_algo_key(hw, hash_algo,
+						  rss_cfg->rss_hash_key);
+		if (ret)
+			return ret;
+	}
+	rss_cfg->rss_algo = hash_algo;
+
+	return 0;
+}
+
+int hclge_comm_set_rss_tuple(struct hnae3_ae_dev *ae_dev,
+			     struct hclge_comm_hw *hw,
+			     struct hclge_comm_rss_cfg *rss_cfg,
+			     struct ethtool_rxnfc *nfc)
+{
+	struct hclge_comm_rss_input_tuple_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	if (nfc->data &
+	    ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3))
+		return -EINVAL;
+
+	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_RSS_INPUT_TUPLE,
+					false);
+
+	ret = hclge_comm_init_rss_tuple_cmd(rss_cfg, nfc, ae_dev, req);
+	if (ret) {
+		dev_err(&hw->cmq.csq.pdev->dev,
+			"failed to init rss tuple cmd, ret = %d.\n", ret);
+		return ret;
+	}
+
+	ret = hclge_comm_cmd_send(hw, &desc, 1);
+	if (ret) {
+		dev_err(&hw->cmq.csq.pdev->dev,
+			"failed to set rss tuple, ret = %d.\n", ret);
+		return ret;
+	}
+
+	rss_cfg->rss_tuple_sets.ipv4_tcp_en = req->ipv4_tcp_en;
+	rss_cfg->rss_tuple_sets.ipv4_udp_en = req->ipv4_udp_en;
+	rss_cfg->rss_tuple_sets.ipv4_sctp_en = req->ipv4_sctp_en;
+	rss_cfg->rss_tuple_sets.ipv4_fragment_en = req->ipv4_fragment_en;
+	rss_cfg->rss_tuple_sets.ipv6_tcp_en = req->ipv6_tcp_en;
+	rss_cfg->rss_tuple_sets.ipv6_udp_en = req->ipv6_udp_en;
+	rss_cfg->rss_tuple_sets.ipv6_sctp_en = req->ipv6_sctp_en;
+	rss_cfg->rss_tuple_sets.ipv6_fragment_en = req->ipv6_fragment_en;
+	return 0;
+}
+
 u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle)
 {
 	return HCLGE_COMM_RSS_KEY_SIZE;
@@ -249,7 +431,7 @@ int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *hw, const u8 hfunc,
 	return 0;
 }
 
-u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
+static u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
 {
 	u8 hash_sets = nfc->data & RXH_L4_B_0_1 ? HCLGE_COMM_S_PORT_BIT : 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
index f32f99b02aa1..aa1d7a6ff4ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -22,6 +22,15 @@
 #define HCLGE_COMM_V_TAG_BIT		BIT(4)
 #define HCLGE_COMM_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
 	(HCLGE_COMM_D_IP_BIT | HCLGE_COMM_S_IP_BIT | HCLGE_COMM_V_TAG_BIT)
+#define HCLGE_COMM_MAX_TC_NUM		8
+
+#define HCLGE_COMM_RSS_TC_OFFSET_S		0
+#define HCLGE_COMM_RSS_TC_OFFSET_M		GENMASK(10, 0)
+#define HCLGE_COMM_RSS_TC_SIZE_MSB_B	11
+#define HCLGE_COMM_RSS_TC_SIZE_S		12
+#define HCLGE_COMM_RSS_TC_SIZE_M		GENMASK(14, 12)
+#define HCLGE_COMM_RSS_TC_VALID_B		15
+#define HCLGE_COMM_RSS_TC_SIZE_MSB_OFFSET	3
 
 struct hclge_comm_rss_tuple_cfg {
 	u8 ipv4_tcp_en;
@@ -80,6 +89,11 @@ struct hclge_comm_rss_ind_tbl_cmd {
 	u8 rss_qid_l[HCLGE_COMM_RSS_CFG_TBL_SIZE];
 };
 
+struct hclge_comm_rss_tc_mode_cmd {
+	__le16 rss_tc_mode[HCLGE_COMM_MAX_TC_NUM];
+	u8 rsv[8];
+};
+
 u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle);
 void hclge_comm_get_rss_type(struct hnae3_handle *nic,
 			     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets);
@@ -95,17 +109,28 @@ void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss_cfg *rss_cfg,
 				  u32 *indir, __le16 rss_ind_tbl_size);
 int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *hw, const u8 hfunc,
 				const u8 *key);
-u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc);
 int hclge_comm_init_rss_tuple_cmd(struct hclge_comm_rss_cfg *rss_cfg,
 				  struct ethtool_rxnfc *nfc,
 				  struct hnae3_ae_dev *ae_dev,
 				  struct hclge_comm_rss_input_tuple_cmd *req);
 u64 hclge_comm_convert_rss_tuple(u8 tuple_sets);
 int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
-				   struct hclge_comm_hw *hw,  bool is_pf,
+				   struct hclge_comm_hw *hw, bool is_pf,
 				   struct hclge_comm_rss_cfg *rss_cfg);
 int hclge_comm_set_rss_indir_table(struct hnae3_ae_dev *ae_dev,
 				   struct hclge_comm_hw *hw, const u16 *indir);
-
-
+int hclge_comm_rss_init_cfg(struct hnae3_handle *nic,
+			    struct hnae3_ae_dev *ae_dev,
+			    struct hclge_comm_rss_cfg *rss_cfg);
+void hclge_comm_get_rss_tc_info(u16 rss_size, u8 hw_tc_map, u16 *tc_offset,
+				u16 *tc_valid, u16 *tc_size);
+int hclge_comm_set_rss_tc_mode(struct hclge_comm_hw *hw, u16 *tc_offset,
+			       u16 *tc_valid, u16 *tc_size);
+int hclge_comm_set_rss_hash_key(struct hclge_comm_rss_cfg *rss_cfg,
+				struct hclge_comm_hw *hw, const u8 *key,
+				const u8 hfunc);
+int hclge_comm_set_rss_tuple(struct hnae3_ae_dev *ae_dev,
+			     struct hclge_comm_hw *hw,
+			     struct hclge_comm_rss_cfg *rss_cfg,
+			     struct ethtool_rxnfc *nfc);
 #endif
-- 
2.33.0

