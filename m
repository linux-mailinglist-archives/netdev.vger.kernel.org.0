Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E3F485468
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiAEOZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:44 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17327 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JTWvL3sqKz9s0B;
        Wed,  5 Jan 2022 22:24:14 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 08/15] net: hns3: refactor VF rss set APIs with new common rss set APIs
Date:   Wed, 5 Jan 2022 22:20:08 +0800
Message-ID: <20220105142015.51097-9-huangguangbin2@huawei.com>
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

This patch uses new common rss set APIs to replace the old APIs in VF rss
module and removes those old rss set APIs. The related macros in VF are
also modified.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  26 --
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 293 +++---------------
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  16 -
 3 files changed, 42 insertions(+), 293 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index ab8329e7d2bd..d48110728891 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -98,35 +98,9 @@ struct hclgevf_cfg_gro_status_cmd {
 };
 
 #define HCLGEVF_RSS_DEFAULT_OUTPORT_B	4
-#define HCLGEVF_RSS_HASH_KEY_OFFSET_B	4
-#define HCLGEVF_RSS_HASH_KEY_NUM	16
-struct hclgevf_rss_config_cmd {
-	u8 hash_config;
-	u8 rsv[7];
-	u8 hash_key[HCLGEVF_RSS_HASH_KEY_NUM];
-};
-
-struct hclgevf_rss_input_tuple_cmd {
-	u8 ipv4_tcp_en;
-	u8 ipv4_udp_en;
-	u8 ipv4_sctp_en;
-	u8 ipv4_fragment_en;
-	u8 ipv6_tcp_en;
-	u8 ipv6_udp_en;
-	u8 ipv6_sctp_en;
-	u8 ipv6_fragment_en;
-	u8 rsv[16];
-};
 
 #define HCLGEVF_RSS_CFG_TBL_SIZE	16
 
-struct hclgevf_rss_indirection_table_cmd {
-	__le16 start_table_index;
-	__le16 rss_set_bitmap;
-	u8 rsv[4];
-	u8 rss_result[HCLGEVF_RSS_CFG_TBL_SIZE];
-};
-
 #define HCLGEVF_RSS_TC_OFFSET_S		0
 #define HCLGEVF_RSS_TC_OFFSET_M		GENMASK(10, 0)
 #define HCLGEVF_RSS_TC_SIZE_MSB_B	11
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index c3aca7887cc7..8859bdb0aa89 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -633,81 +633,6 @@ static int hclgevf_get_vector_index(struct hclgevf_dev *hdev, int vector)
 	return -EINVAL;
 }
 
-static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
-				    const u8 hfunc, const u8 *key)
-{
-	struct hclgevf_rss_config_cmd *req;
-	unsigned int key_offset = 0;
-	struct hclge_desc desc;
-	int key_counts;
-	int key_size;
-	int ret;
-
-	key_counts = HCLGEVF_RSS_KEY_SIZE;
-	req = (struct hclgevf_rss_config_cmd *)desc.data;
-
-	while (key_counts) {
-		hclgevf_cmd_setup_basic_desc(&desc,
-					     HCLGEVF_OPC_RSS_GENERIC_CONFIG,
-					     false);
-
-		req->hash_config |= (hfunc & HCLGEVF_RSS_HASH_ALGO_MASK);
-		req->hash_config |=
-			(key_offset << HCLGEVF_RSS_HASH_KEY_OFFSET_B);
-
-		key_size = min(HCLGEVF_RSS_HASH_KEY_NUM, key_counts);
-		memcpy(req->hash_key,
-		       key + key_offset * HCLGEVF_RSS_HASH_KEY_NUM, key_size);
-
-		key_counts -= key_size;
-		key_offset++;
-		ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Configure RSS config fail, status = %d\n",
-				ret);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
-static int hclgevf_set_rss_indir_table(struct hclgevf_dev *hdev)
-{
-	const u16 *indir = hdev->rss_cfg.rss_indirection_tbl;
-	struct hclgevf_rss_indirection_table_cmd *req;
-	struct hclge_desc desc;
-	int rss_cfg_tbl_num;
-	int status;
-	int i, j;
-
-	req = (struct hclgevf_rss_indirection_table_cmd *)desc.data;
-	rss_cfg_tbl_num = hdev->ae_dev->dev_specs.rss_ind_tbl_size /
-			  HCLGEVF_RSS_CFG_TBL_SIZE;
-
-	for (i = 0; i < rss_cfg_tbl_num; i++) {
-		hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INDIR_TABLE,
-					     false);
-		req->start_table_index =
-			cpu_to_le16(i * HCLGEVF_RSS_CFG_TBL_SIZE);
-		req->rss_set_bitmap = cpu_to_le16(HCLGEVF_RSS_SET_BITMAP_MSK);
-		for (j = 0; j < HCLGEVF_RSS_CFG_TBL_SIZE; j++)
-			req->rss_result[j] =
-				indir[i * HCLGEVF_RSS_CFG_TBL_SIZE + j];
-
-		status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-		if (status) {
-			dev_err(&hdev->pdev->dev,
-				"VF failed(=%d) to set RSS indirection table\n",
-				status);
-			return status;
-		}
-	}
-
-	return 0;
-}
-
 static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 {
 	struct hclgevf_rss_tc_mode_cmd *req;
@@ -766,7 +691,7 @@ static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 	int ret;
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_RSS_KEY, 0);
-	msg_num = (HCLGEVF_RSS_KEY_SIZE + HCLGEVF_RSS_MBX_RESP_LEN - 1) /
+	msg_num = (HCLGE_COMM_RSS_KEY_SIZE + HCLGEVF_RSS_MBX_RESP_LEN - 1) /
 			HCLGEVF_RSS_MBX_RESP_LEN;
 	for (index = 0; index < msg_num; index++) {
 		send_msg.data[0] = index;
@@ -783,7 +708,7 @@ static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 		if (index == msg_num - 1)
 			memcpy(&rss_cfg->rss_hash_key[hash_key_index],
 			       &resp_msg[0],
-			       HCLGEVF_RSS_KEY_SIZE - hash_key_index);
+			       HCLGE_COMM_RSS_KEY_SIZE - hash_key_index);
 		else
 			memcpy(&rss_cfg->rss_hash_key[hash_key_index],
 			       &resp_msg[0], HCLGEVF_RSS_MBX_RESP_LEN);
@@ -797,28 +722,10 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	int i, ret;
+	int ret;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		/* Get hash algorithm */
-		if (hfunc) {
-			switch (rss_cfg->rss_algo) {
-			case HCLGEVF_RSS_HASH_ALGO_TOEPLITZ:
-				*hfunc = ETH_RSS_HASH_TOP;
-				break;
-			case HCLGEVF_RSS_HASH_ALGO_SIMPLE:
-				*hfunc = ETH_RSS_HASH_XOR;
-				break;
-			default:
-				*hfunc = ETH_RSS_HASH_UNKNOWN;
-				break;
-			}
-		}
-
-		/* Get the RSS Key required by the user */
-		if (key)
-			memcpy(key, rss_cfg->rss_hash_key,
-			       HCLGEVF_RSS_KEY_SIZE);
+		hclge_comm_get_rss_hash_info(rss_cfg, key, hfunc);
 	} else {
 		if (hfunc)
 			*hfunc = ETH_RSS_HASH_TOP;
@@ -827,13 +734,12 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 			if (ret)
 				return ret;
 			memcpy(key, rss_cfg->rss_hash_key,
-			       HCLGEVF_RSS_KEY_SIZE);
+			       HCLGE_COMM_RSS_KEY_SIZE);
 		}
 	}
 
-	if (indir)
-		for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
-			indir[i] = rss_cfg->rss_indirection_tbl[i];
+	hclge_comm_get_rss_indir_tbl(rss_cfg, indir,
+				     hdev->ae_dev->dev_specs.rss_ind_tbl_size);
 
 	return 0;
 }
@@ -843,6 +749,7 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	const u8 *rss_hash_key = rss_cfg->rss_hash_key;
 	u8 hash_algo;
 	int ret, i;
 
@@ -853,7 +760,8 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 
 		/* Set the RSS Hash Key if specififed by the user */
 		if (key) {
-			ret = hclgevf_set_rss_algo_key(hdev, hash_algo, key);
+			ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw,
+							  hash_algo, key);
 			if (ret) {
 				dev_err(&hdev->pdev->dev,
 					"invalid hfunc type %u\n", hfunc);
@@ -862,10 +770,11 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 
 			/* Update the shadow RSS key with user specified qids */
 			memcpy(rss_cfg->rss_hash_key, key,
-			       HCLGEVF_RSS_KEY_SIZE);
+			       HCLGE_COMM_RSS_KEY_SIZE);
 		} else {
-			ret = hclgevf_set_rss_algo_key(hdev, hash_algo,
-						       rss_cfg->rss_hash_key);
+			ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw,
+							  hash_algo,
+							  rss_hash_key);
 			if (ret)
 				return ret;
 		}
@@ -877,86 +786,8 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 		rss_cfg->rss_indirection_tbl[i] = indir[i];
 
 	/* update the hardware */
-	return hclgevf_set_rss_indir_table(hdev);
-}
-
-static u8 hclgevf_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
-{
-	u8 hash_sets = nfc->data & RXH_L4_B_0_1 ? HCLGEVF_S_PORT_BIT : 0;
-
-	if (nfc->data & RXH_L4_B_2_3)
-		hash_sets |= HCLGEVF_D_PORT_BIT;
-	else
-		hash_sets &= ~HCLGEVF_D_PORT_BIT;
-
-	if (nfc->data & RXH_IP_SRC)
-		hash_sets |= HCLGEVF_S_IP_BIT;
-	else
-		hash_sets &= ~HCLGEVF_S_IP_BIT;
-
-	if (nfc->data & RXH_IP_DST)
-		hash_sets |= HCLGEVF_D_IP_BIT;
-	else
-		hash_sets &= ~HCLGEVF_D_IP_BIT;
-
-	if (nfc->flow_type == SCTP_V4_FLOW || nfc->flow_type == SCTP_V6_FLOW)
-		hash_sets |= HCLGEVF_V_TAG_BIT;
-
-	return hash_sets;
-}
-
-static int hclgevf_init_rss_tuple_cmd(struct hnae3_handle *handle,
-				      struct ethtool_rxnfc *nfc,
-				      struct hclgevf_rss_input_tuple_cmd *req)
-{
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	u8 tuple_sets;
-
-	req->ipv4_tcp_en = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
-	req->ipv4_udp_en = rss_cfg->rss_tuple_sets.ipv4_udp_en;
-	req->ipv4_sctp_en = rss_cfg->rss_tuple_sets.ipv4_sctp_en;
-	req->ipv4_fragment_en = rss_cfg->rss_tuple_sets.ipv4_fragment_en;
-	req->ipv6_tcp_en = rss_cfg->rss_tuple_sets.ipv6_tcp_en;
-	req->ipv6_udp_en = rss_cfg->rss_tuple_sets.ipv6_udp_en;
-	req->ipv6_sctp_en = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
-	req->ipv6_fragment_en = rss_cfg->rss_tuple_sets.ipv6_fragment_en;
-
-	tuple_sets = hclgevf_get_rss_hash_bits(nfc);
-	switch (nfc->flow_type) {
-	case TCP_V4_FLOW:
-		req->ipv4_tcp_en = tuple_sets;
-		break;
-	case TCP_V6_FLOW:
-		req->ipv6_tcp_en = tuple_sets;
-		break;
-	case UDP_V4_FLOW:
-		req->ipv4_udp_en = tuple_sets;
-		break;
-	case UDP_V6_FLOW:
-		req->ipv6_udp_en = tuple_sets;
-		break;
-	case SCTP_V4_FLOW:
-		req->ipv4_sctp_en = tuple_sets;
-		break;
-	case SCTP_V6_FLOW:
-		if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 &&
-		    (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)))
-			return -EINVAL;
-
-		req->ipv6_sctp_en = tuple_sets;
-		break;
-	case IPV4_FLOW:
-		req->ipv4_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		break;
-	case IPV6_FLOW:
-		req->ipv6_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
+	return hclge_comm_set_rss_indir_table(hdev->ae_dev, &hdev->hw.hw,
+					      rss_cfg->rss_indirection_tbl);
 }
 
 static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
@@ -964,7 +795,7 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	struct hclgevf_rss_input_tuple_cmd *req;
+	struct hclge_comm_rss_input_tuple_cmd *req;
 	struct hclge_desc desc;
 	int ret;
 
@@ -975,10 +806,10 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 	    ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3))
 		return -EINVAL;
 
-	req = (struct hclgevf_rss_input_tuple_cmd *)desc.data;
+	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INPUT_TUPLE, false);
 
-	ret = hclgevf_init_rss_tuple_cmd(handle, nfc, req);
+	ret = hclge_comm_init_rss_tuple_cmd(rss_cfg, nfc, hdev->ae_dev, req);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to init rss tuple cmd, ret = %d\n", ret);
@@ -1003,22 +834,6 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 	return 0;
 }
 
-static u64 hclgevf_convert_rss_tuple(u8 tuple_sets)
-{
-	u64 tuple_data = 0;
-
-	if (tuple_sets & HCLGEVF_D_PORT_BIT)
-		tuple_data |= RXH_L4_B_2_3;
-	if (tuple_sets & HCLGEVF_S_PORT_BIT)
-		tuple_data |= RXH_L4_B_0_1;
-	if (tuple_sets & HCLGEVF_D_IP_BIT)
-		tuple_data |= RXH_IP_DST;
-	if (tuple_sets & HCLGEVF_S_IP_BIT)
-		tuple_data |= RXH_IP_SRC;
-
-	return tuple_data;
-}
-
 static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
 				 struct ethtool_rxnfc *nfc)
 {
@@ -1036,38 +851,11 @@ static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
 	if (ret || !tuple_sets)
 		return ret;
 
-	nfc->data = hclgevf_convert_rss_tuple(tuple_sets);
+	nfc->data = hclge_comm_convert_rss_tuple(tuple_sets);
 
 	return 0;
 }
 
-static int hclgevf_set_rss_input_tuple(struct hclgevf_dev *hdev,
-				       struct hclge_comm_rss_cfg *rss_cfg)
-{
-	struct hclgevf_rss_input_tuple_cmd *req;
-	struct hclge_desc desc;
-	int ret;
-
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INPUT_TUPLE, false);
-
-	req = (struct hclgevf_rss_input_tuple_cmd *)desc.data;
-
-	req->ipv4_tcp_en = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
-	req->ipv4_udp_en = rss_cfg->rss_tuple_sets.ipv4_udp_en;
-	req->ipv4_sctp_en = rss_cfg->rss_tuple_sets.ipv4_sctp_en;
-	req->ipv4_fragment_en = rss_cfg->rss_tuple_sets.ipv4_fragment_en;
-	req->ipv6_tcp_en = rss_cfg->rss_tuple_sets.ipv6_tcp_en;
-	req->ipv6_udp_en = rss_cfg->rss_tuple_sets.ipv6_udp_en;
-	req->ipv6_sctp_en = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
-	req->ipv6_fragment_en = rss_cfg->rss_tuple_sets.ipv6_fragment_en;
-
-	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"Configure rss input fail, status = %d\n", ret);
-	return ret;
-}
-
 static int hclgevf_get_tc_size(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
@@ -2570,13 +2358,13 @@ static int hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 	struct hclge_comm_rss_tuple_cfg *tuple_sets;
 	u32 i;
 
-	rss_cfg->rss_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
+	rss_cfg->rss_algo = HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ;
 	rss_cfg->rss_size = hdev->nic.kinfo.rss_size;
 	tuple_sets = &rss_cfg->rss_tuple_sets;
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		u16 *rss_ind_tbl;
 
-		rss_cfg->rss_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
+		rss_cfg->rss_algo = HCLGE_COMM_RSS_HASH_ALGO_SIMPLE;
 
 		rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
 					   sizeof(*rss_ind_tbl), GFP_KERNEL);
@@ -2585,19 +2373,19 @@ static int hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 
 		rss_cfg->rss_indirection_tbl = rss_ind_tbl;
 		memcpy(rss_cfg->rss_hash_key, hclgevf_hash_key,
-		       HCLGEVF_RSS_KEY_SIZE);
-
-		tuple_sets->ipv4_tcp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv4_udp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv4_sctp_en = HCLGEVF_RSS_INPUT_TUPLE_SCTP;
-		tuple_sets->ipv4_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv6_tcp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv6_udp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+		       HCLGE_COMM_RSS_KEY_SIZE);
+
+		tuple_sets->ipv4_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv4_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv4_sctp_en = HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
+		tuple_sets->ipv4_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv6_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+		tuple_sets->ipv6_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
 		tuple_sets->ipv6_sctp_en =
 			hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
-					HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT :
-					HCLGEVF_RSS_INPUT_TUPLE_SCTP;
-		tuple_sets->ipv6_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
+					HCLGE_COMM_RSS_INPUT_TUPLE_SCTP_NO_PORT :
+					HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
+		tuple_sets->ipv6_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
 	}
 
 	/* Initialize RSS indirect table */
@@ -2613,17 +2401,20 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 	int ret;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		ret = hclgevf_set_rss_algo_key(hdev, rss_cfg->rss_algo,
-					       rss_cfg->rss_hash_key);
+		ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw,
+						  rss_cfg->rss_algo,
+						  rss_cfg->rss_hash_key);
 		if (ret)
 			return ret;
 
-		ret = hclgevf_set_rss_input_tuple(hdev, rss_cfg);
+		ret = hclge_comm_set_rss_input_tuple(&hdev->nic, &hdev->hw.hw,
+						     false, rss_cfg);
 		if (ret)
 			return ret;
 	}
 
-	ret = hclgevf_set_rss_indir_table(hdev);
+	ret = hclge_comm_set_rss_indir_table(hdev->ae_dev, &hdev->hw.hw,
+					     rss_cfg->rss_indirection_tbl);
 	if (ret)
 		return ret;
 
@@ -3148,7 +2939,7 @@ static void hclgevf_set_default_dev_specs(struct hclgevf_dev *hdev)
 	ae_dev->dev_specs.max_non_tso_bd_num =
 					HCLGEVF_MAX_NON_TSO_BD_NUM;
 	ae_dev->dev_specs.rss_ind_tbl_size = HCLGEVF_RSS_IND_TBL_SIZE;
-	ae_dev->dev_specs.rss_key_size = HCLGEVF_RSS_KEY_SIZE;
+	ae_dev->dev_specs.rss_key_size = HCLGE_COMM_RSS_KEY_SIZE;
 	ae_dev->dev_specs.max_int_gl = HCLGEVF_DEF_MAX_INT_GL;
 	ae_dev->dev_specs.max_frm_size = HCLGEVF_MAC_MAX_FRAME;
 }
@@ -3181,7 +2972,7 @@ static void hclgevf_check_dev_specs(struct hclgevf_dev *hdev)
 	if (!dev_specs->rss_ind_tbl_size)
 		dev_specs->rss_ind_tbl_size = HCLGEVF_RSS_IND_TBL_SIZE;
 	if (!dev_specs->rss_key_size)
-		dev_specs->rss_key_size = HCLGEVF_RSS_KEY_SIZE;
+		dev_specs->rss_key_size = HCLGE_COMM_RSS_KEY_SIZE;
 	if (!dev_specs->max_int_gl)
 		dev_specs->max_int_gl = HCLGEVF_DEF_MAX_INT_GL;
 	if (!dev_specs->max_frm_size)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index b6cb6ac5c145..50e347a2ed18 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -94,22 +94,6 @@
 #define HCLGEVF_WAIT_RESET_DONE		100
 
 #define HCLGEVF_RSS_IND_TBL_SIZE		512
-#define HCLGEVF_RSS_SET_BITMAP_MSK	0xffff
-#define HCLGEVF_RSS_KEY_SIZE		40
-#define HCLGEVF_RSS_HASH_ALGO_TOEPLITZ	0
-#define HCLGEVF_RSS_HASH_ALGO_SIMPLE	1
-#define HCLGEVF_RSS_HASH_ALGO_SYMMETRIC	2
-#define HCLGEVF_RSS_HASH_ALGO_MASK	0xf
-
-#define HCLGEVF_RSS_INPUT_TUPLE_OTHER	GENMASK(3, 0)
-#define HCLGEVF_RSS_INPUT_TUPLE_SCTP	GENMASK(4, 0)
-#define HCLGEVF_D_PORT_BIT		BIT(0)
-#define HCLGEVF_S_PORT_BIT		BIT(1)
-#define HCLGEVF_D_IP_BIT		BIT(2)
-#define HCLGEVF_S_IP_BIT		BIT(3)
-#define HCLGEVF_V_TAG_BIT		BIT(4)
-#define HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
-	(HCLGEVF_D_IP_BIT | HCLGEVF_S_IP_BIT | HCLGEVF_V_TAG_BIT)
 
 #define HCLGEVF_MAC_MAX_FRAME		9728
 
-- 
2.33.0

