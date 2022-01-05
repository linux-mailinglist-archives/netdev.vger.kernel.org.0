Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52836485461
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbiAEOZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:35 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34878 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JTWvt3N0YzccKq;
        Wed,  5 Jan 2022 22:24:42 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 07/15] net: hns3: refactor PF rss set APIs with new common rss set APIs
Date:   Wed, 5 Jan 2022 22:20:07 +0800
Message-ID: <20220105142015.51097-8-huangguangbin2@huawei.com>
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

This patch uses new common rss set APIs to replace the old APIs in PF rss
module and deletes the old rss set APIs. The related macros are also
modified.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  28 --
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 290 +++---------------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  16 -
 3 files changed, 36 insertions(+), 298 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index ac0f2f17275b..0c7b943f57d8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -481,38 +481,10 @@ struct hclge_vf_num_cmd {
 };
 
 #define HCLGE_RSS_DEFAULT_OUTPORT_B	4
-#define HCLGE_RSS_HASH_KEY_OFFSET_B	4
-#define HCLGE_RSS_HASH_KEY_NUM		16
-struct hclge_rss_config_cmd {
-	u8 hash_config;
-	u8 rsv[7];
-	u8 hash_key[HCLGE_RSS_HASH_KEY_NUM];
-};
-
-struct hclge_rss_input_tuple_cmd {
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
 
-#define HCLGE_RSS_CFG_TBL_SIZE	16
 #define HCLGE_RSS_CFG_TBL_SIZE_H	4
-#define HCLGE_RSS_CFG_TBL_BW_H		2U
 #define HCLGE_RSS_CFG_TBL_BW_L		8U
 
-struct hclge_rss_indirection_table_cmd {
-	__le16 start_table_index;
-	__le16 rss_set_bitmap;
-	u8 rss_qid_h[HCLGE_RSS_CFG_TBL_SIZE_H];
-	u8 rss_qid_l[HCLGE_RSS_CFG_TBL_SIZE];
-};
-
 #define HCLGE_RSS_TC_OFFSET_S		0
 #define HCLGE_RSS_TC_OFFSET_M		GENMASK(10, 0)
 #define HCLGE_RSS_TC_SIZE_MSB_B		11
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1cf11b936972..8696038a0580 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1495,7 +1495,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 
 	ae_dev->dev_specs.max_non_tso_bd_num = HCLGE_MAX_NON_TSO_BD_NUM;
 	ae_dev->dev_specs.rss_ind_tbl_size = HCLGE_RSS_IND_TBL_SIZE;
-	ae_dev->dev_specs.rss_key_size = HCLGE_RSS_KEY_SIZE;
+	ae_dev->dev_specs.rss_key_size = HCLGE_COMM_RSS_KEY_SIZE;
 	ae_dev->dev_specs.max_tm_rate = HCLGE_ETHER_MAX_RATE;
 	ae_dev->dev_specs.max_int_gl = HCLGE_DEF_MAX_INT_GL;
 	ae_dev->dev_specs.max_frm_size = HCLGE_MAC_MAX_FRAME;
@@ -1535,7 +1535,7 @@ static void hclge_check_dev_specs(struct hclge_dev *hdev)
 	if (!dev_specs->rss_ind_tbl_size)
 		dev_specs->rss_ind_tbl_size = HCLGE_RSS_IND_TBL_SIZE;
 	if (!dev_specs->rss_key_size)
-		dev_specs->rss_key_size = HCLGE_RSS_KEY_SIZE;
+		dev_specs->rss_key_size = HCLGE_COMM_RSS_KEY_SIZE;
 	if (!dev_specs->max_tm_rate)
 		dev_specs->max_tm_rate = HCLGE_ETHER_MAX_RATE;
 	if (!dev_specs->max_qset_num)
@@ -4719,86 +4719,6 @@ static int hclge_put_vector(struct hnae3_handle *handle, int vector)
 	return 0;
 }
 
-static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
-				  const u8 hfunc, const u8 *key)
-{
-	struct hclge_rss_config_cmd *req;
-	unsigned int key_offset = 0;
-	struct hclge_desc desc;
-	int key_counts;
-	int key_size;
-	int ret;
-
-	key_counts = HCLGE_RSS_KEY_SIZE;
-	req = (struct hclge_rss_config_cmd *)desc.data;
-
-	while (key_counts) {
-		hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_GENERIC_CONFIG,
-					   false);
-
-		req->hash_config |= (hfunc & HCLGE_RSS_HASH_ALGO_MASK);
-		req->hash_config |= (key_offset << HCLGE_RSS_HASH_KEY_OFFSET_B);
-
-		key_size = min(HCLGE_RSS_HASH_KEY_NUM, key_counts);
-		memcpy(req->hash_key,
-		       key + key_offset * HCLGE_RSS_HASH_KEY_NUM, key_size);
-
-		key_counts -= key_size;
-		key_offset++;
-		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Configure RSS config fail, status = %d\n",
-				ret);
-			return ret;
-		}
-	}
-	return 0;
-}
-
-static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
-{
-	struct hclge_rss_indirection_table_cmd *req;
-	struct hclge_desc desc;
-	int rss_cfg_tbl_num;
-	u8 rss_msb_oft;
-	u8 rss_msb_val;
-	int ret;
-	u16 qid;
-	int i;
-	u32 j;
-
-	req = (struct hclge_rss_indirection_table_cmd *)desc.data;
-	rss_cfg_tbl_num = hdev->ae_dev->dev_specs.rss_ind_tbl_size /
-			  HCLGE_RSS_CFG_TBL_SIZE;
-
-	for (i = 0; i < rss_cfg_tbl_num; i++) {
-		hclge_cmd_setup_basic_desc
-			(&desc, HCLGE_OPC_RSS_INDIR_TABLE, false);
-
-		req->start_table_index =
-			cpu_to_le16(i * HCLGE_RSS_CFG_TBL_SIZE);
-		req->rss_set_bitmap = cpu_to_le16(HCLGE_RSS_SET_BITMAP_MSK);
-		for (j = 0; j < HCLGE_RSS_CFG_TBL_SIZE; j++) {
-			qid = indir[i * HCLGE_RSS_CFG_TBL_SIZE + j];
-			req->rss_qid_l[j] = qid & 0xff;
-			rss_msb_oft =
-				j * HCLGE_RSS_CFG_TBL_BW_H / BITS_PER_BYTE;
-			rss_msb_val = (qid >> HCLGE_RSS_CFG_TBL_BW_L & 0x1) <<
-				(j * HCLGE_RSS_CFG_TBL_BW_H % BITS_PER_BYTE);
-			req->rss_qid_h[rss_msb_oft] |= rss_msb_val;
-		}
-		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"Configure rss indir table fail,status = %d\n",
-				ret);
-			return ret;
-		}
-	}
-	return 0;
-}
-
 static int hclge_set_rss_tc_mode(struct hclge_dev *hdev, u16 *tc_valid,
 				 u16 *tc_size, u16 *tc_offset)
 {
@@ -4832,65 +4752,17 @@ static int hclge_set_rss_tc_mode(struct hclge_dev *hdev, u16 *tc_valid,
 	return ret;
 }
 
-static int hclge_set_rss_input_tuple(struct hclge_dev *hdev)
-{
-	struct hclge_rss_input_tuple_cmd *req;
-	struct hclge_desc desc;
-	int ret;
-
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_INPUT_TUPLE, false);
-
-	req = (struct hclge_rss_input_tuple_cmd *)desc.data;
-
-	/* Get the tuple cfg from pf */
-	req->ipv4_tcp_en = hdev->rss_cfg.rss_tuple_sets.ipv4_tcp_en;
-	req->ipv4_udp_en = hdev->rss_cfg.rss_tuple_sets.ipv4_udp_en;
-	req->ipv4_sctp_en = hdev->rss_cfg.rss_tuple_sets.ipv4_sctp_en;
-	req->ipv4_fragment_en = hdev->rss_cfg.rss_tuple_sets.ipv4_fragment_en;
-	req->ipv6_tcp_en = hdev->rss_cfg.rss_tuple_sets.ipv6_tcp_en;
-	req->ipv6_udp_en = hdev->rss_cfg.rss_tuple_sets.ipv6_udp_en;
-	req->ipv6_sctp_en = hdev->rss_cfg.rss_tuple_sets.ipv6_sctp_en;
-	req->ipv6_fragment_en = hdev->rss_cfg.rss_tuple_sets.ipv6_fragment_en;
-	hclge_comm_get_rss_type(&hdev->vport[0].nic,
-				&hdev->rss_cfg.rss_tuple_sets);
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"Configure rss input fail, status = %d\n", ret);
-	return ret;
-}
-
 static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 			 u8 *key, u8 *hfunc)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_comm_rss_cfg *rss_cfg = &vport->back->rss_cfg;
-	int i;
 
-	/* Get hash algorithm */
-	if (hfunc) {
-		switch (rss_cfg->rss_algo) {
-		case HCLGE_RSS_HASH_ALGO_TOEPLITZ:
-			*hfunc = ETH_RSS_HASH_TOP;
-			break;
-		case HCLGE_RSS_HASH_ALGO_SIMPLE:
-			*hfunc = ETH_RSS_HASH_XOR;
-			break;
-		default:
-			*hfunc = ETH_RSS_HASH_UNKNOWN;
-			break;
-		}
-	}
-
-	/* Get the RSS Key required by the user */
-	if (key)
-		memcpy(key, rss_cfg->rss_hash_key, HCLGE_RSS_KEY_SIZE);
+	hclge_comm_get_rss_hash_info(rss_cfg, key, hfunc);
 
-	/* Get indirect table */
-	if (indir)
-		for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
-			indir[i] =  rss_cfg->rss_indirection_tbl[i];
+	hclge_comm_get_rss_indir_tbl(rss_cfg, indir,
+				     ae_dev->dev_specs.rss_ind_tbl_size);
 
 	return 0;
 }
@@ -4901,6 +4773,7 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 hash_algo;
 	int ret, i;
 
@@ -4912,15 +4785,15 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 
 	/* Set the RSS Hash Key if specififed by the user */
 	if (key) {
-		ret = hclge_set_rss_algo_key(hdev, hash_algo, key);
+		ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw, hash_algo, key);
 		if (ret)
 			return ret;
 
 		/* Update the shadow RSS key with user specified qids */
-		memcpy(hdev->rss_cfg.rss_hash_key, key, HCLGE_RSS_KEY_SIZE);
+		memcpy(hdev->rss_cfg.rss_hash_key, key, HCLGE_COMM_RSS_KEY_SIZE);
 	} else {
-		ret = hclge_set_rss_algo_key(hdev, hash_algo,
-					     hdev->rss_cfg.rss_hash_key);
+		ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw, hash_algo,
+						  hdev->rss_cfg.rss_hash_key);
 		if (ret)
 			return ret;
 	}
@@ -4931,95 +4804,16 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 		hdev->rss_cfg.rss_indirection_tbl[i] = indir[i];
 
 	/* Update the hardware */
-	return hclge_set_rss_indir_table(hdev,
-					 hdev->rss_cfg.rss_indirection_tbl);
-}
-
-static u8 hclge_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
-{
-	u8 hash_sets = nfc->data & RXH_L4_B_0_1 ? HCLGE_S_PORT_BIT : 0;
-
-	if (nfc->data & RXH_L4_B_2_3)
-		hash_sets |= HCLGE_D_PORT_BIT;
-	else
-		hash_sets &= ~HCLGE_D_PORT_BIT;
-
-	if (nfc->data & RXH_IP_SRC)
-		hash_sets |= HCLGE_S_IP_BIT;
-	else
-		hash_sets &= ~HCLGE_S_IP_BIT;
-
-	if (nfc->data & RXH_IP_DST)
-		hash_sets |= HCLGE_D_IP_BIT;
-	else
-		hash_sets &= ~HCLGE_D_IP_BIT;
-
-	if (nfc->flow_type == SCTP_V4_FLOW || nfc->flow_type == SCTP_V6_FLOW)
-		hash_sets |= HCLGE_V_TAG_BIT;
-
-	return hash_sets;
-}
-
-static int hclge_init_rss_tuple_cmd(struct hclge_vport *vport,
-				    struct ethtool_rxnfc *nfc,
-				    struct hclge_rss_input_tuple_cmd *req)
-{
-	struct hclge_dev *hdev = vport->back;
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
-	tuple_sets = hclge_get_rss_hash_bits(nfc);
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
-		req->ipv4_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-		break;
-	case IPV6_FLOW:
-		req->ipv6_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
+	return hclge_comm_set_rss_indir_table(ae_dev, &hdev->hw.hw,
+					      rss_cfg->rss_indirection_tbl);
 }
 
 static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 			       struct ethtool_rxnfc *nfc)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_comm_rss_input_tuple_cmd *req;
 	struct hclge_dev *hdev = vport->back;
-	struct hclge_rss_input_tuple_cmd *req;
 	struct hclge_desc desc;
 	int ret;
 
@@ -5027,10 +4821,11 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 			  RXH_L4_B_0_1 | RXH_L4_B_2_3))
 		return -EINVAL;
 
-	req = (struct hclge_rss_input_tuple_cmd *)desc.data;
+	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_INPUT_TUPLE, false);
 
-	ret = hclge_init_rss_tuple_cmd(vport, nfc, req);
+	ret = hclge_comm_init_rss_tuple_cmd(&hdev->rss_cfg, nfc, hdev->ae_dev,
+					    req);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to init rss tuple cmd, ret = %d\n", ret);
@@ -5056,22 +4851,6 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 	return 0;
 }
 
-static u64 hclge_convert_rss_tuple(u8 tuple_sets)
-{
-	u64 tuple_data = 0;
-
-	if (tuple_sets & HCLGE_D_PORT_BIT)
-		tuple_data |= RXH_L4_B_2_3;
-	if (tuple_sets & HCLGE_S_PORT_BIT)
-		tuple_data |= RXH_L4_B_0_1;
-	if (tuple_sets & HCLGE_D_IP_BIT)
-		tuple_data |= RXH_IP_DST;
-	if (tuple_sets & HCLGE_S_IP_BIT)
-		tuple_data |= RXH_IP_SRC;
-
-	return tuple_data;
-}
-
 static int hclge_get_rss_tuple(struct hnae3_handle *handle,
 			       struct ethtool_rxnfc *nfc)
 {
@@ -5086,7 +4865,7 @@ static int hclge_get_rss_tuple(struct hnae3_handle *handle,
 	if (ret || !tuple_sets)
 		return ret;
 
-	nfc->data = hclge_convert_rss_tuple(tuple_sets);
+	nfc->data = hclge_comm_convert_rss_tuple(tuple_sets);
 
 	return 0;
 }
@@ -5149,15 +4928,18 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	u8 hfunc = hdev->rss_cfg.rss_algo;
 	int ret;
 
-	ret = hclge_set_rss_indir_table(hdev, rss_indir);
+	ret = hclge_comm_set_rss_indir_table(hdev->ae_dev, &hdev->hw.hw,
+					     rss_indir);
 	if (ret)
 		return ret;
 
-	ret = hclge_set_rss_algo_key(hdev, hfunc, key);
+	ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw, hfunc, key);
 	if (ret)
 		return ret;
 
-	ret = hclge_set_rss_input_tuple(hdev);
+	ret = hclge_comm_set_rss_input_tuple(&hdev->vport[0].nic,
+					     &hdev->hw.hw, true,
+					     &hdev->rss_cfg);
 	if (ret)
 		return ret;
 
@@ -5167,24 +4949,24 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 static int hclge_rss_init_cfg(struct hclge_dev *hdev)
 {
 	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
-	int rss_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
+	int rss_algo = HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ;
 	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u16 *rss_ind_tbl;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
-		rss_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
-
-	rss_cfg->rss_tuple_sets.ipv4_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv4_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv4_sctp_en = HCLGE_RSS_INPUT_TUPLE_SCTP;
-	rss_cfg->rss_tuple_sets.ipv4_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv6_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv6_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+		rss_algo = HCLGE_COMM_RSS_HASH_ALGO_SIMPLE;
+
+	rss_cfg->rss_tuple_sets.ipv4_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv4_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv4_sctp_en = HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
+	rss_cfg->rss_tuple_sets.ipv4_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv6_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv6_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
 	rss_cfg->rss_tuple_sets.ipv6_sctp_en =
 		hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
-		HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT :
-		HCLGE_RSS_INPUT_TUPLE_SCTP;
-	rss_cfg->rss_tuple_sets.ipv6_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+		HCLGE_COMM_RSS_INPUT_TUPLE_SCTP_NO_PORT :
+		HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
+	rss_cfg->rss_tuple_sets.ipv6_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
 
 	rss_cfg->rss_algo = rss_algo;
 
@@ -5194,7 +4976,7 @@ static int hclge_rss_init_cfg(struct hclge_dev *hdev)
 		return -ENOMEM;
 
 	rss_cfg->rss_indirection_tbl = rss_ind_tbl;
-	memcpy(rss_cfg->rss_hash_key, hclge_hash_key, HCLGE_RSS_KEY_SIZE);
+	memcpy(rss_cfg->rss_hash_key, hclge_hash_key, HCLGE_COMM_RSS_KEY_SIZE);
 
 	hclge_comm_rss_indir_init_cfg(hdev->ae_dev, rss_cfg);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 85139b1377e9..d4436d593350 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -81,22 +81,6 @@
 #define HCLGE_TQP_INTR_RL_REG		0x20900
 
 #define HCLGE_RSS_IND_TBL_SIZE		512
-#define HCLGE_RSS_SET_BITMAP_MSK	GENMASK(15, 0)
-#define HCLGE_RSS_KEY_SIZE		40
-#define HCLGE_RSS_HASH_ALGO_TOEPLITZ	0
-#define HCLGE_RSS_HASH_ALGO_SIMPLE	1
-#define HCLGE_RSS_HASH_ALGO_SYMMETRIC	2
-#define HCLGE_RSS_HASH_ALGO_MASK	GENMASK(3, 0)
-
-#define HCLGE_RSS_INPUT_TUPLE_OTHER	GENMASK(3, 0)
-#define HCLGE_RSS_INPUT_TUPLE_SCTP	GENMASK(4, 0)
-#define HCLGE_D_PORT_BIT		BIT(0)
-#define HCLGE_S_PORT_BIT		BIT(1)
-#define HCLGE_D_IP_BIT			BIT(2)
-#define HCLGE_S_IP_BIT			BIT(3)
-#define HCLGE_V_TAG_BIT			BIT(4)
-#define HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
-		(HCLGE_D_IP_BIT | HCLGE_S_IP_BIT | HCLGE_V_TAG_BIT)
 
 #define HCLGE_RSS_TC_SIZE_0		1
 #define HCLGE_RSS_TC_SIZE_1		2
-- 
2.33.0

