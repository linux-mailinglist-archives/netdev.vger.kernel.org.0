Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A9B48546A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbiAEOZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:46 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:31143 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240694AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JTWsZ5KGVzRhf3;
        Wed,  5 Jan 2022 22:22:42 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 11/15] net: hns3: refactor VF rss init APIs with new common rss init APIs
Date:   Wed, 5 Jan 2022 22:20:11 +0800
Message-ID: <20220105142015.51097-12-huangguangbin2@huawei.com>
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

This patch uses common rss init APIs to replace the old APIs in VF rss
module and removes the old VF rss init APIs. Several related Subfunctions
and macros are also modified in this patch.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  18 --
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 183 +++---------------
 2 files changed, 25 insertions(+), 176 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index d48110728891..cbf620bcf31c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -97,24 +97,6 @@ struct hclgevf_cfg_gro_status_cmd {
 	u8 rsv[23];
 };
 
-#define HCLGEVF_RSS_DEFAULT_OUTPORT_B	4
-
-#define HCLGEVF_RSS_CFG_TBL_SIZE	16
-
-#define HCLGEVF_RSS_TC_OFFSET_S		0
-#define HCLGEVF_RSS_TC_OFFSET_M		GENMASK(10, 0)
-#define HCLGEVF_RSS_TC_SIZE_MSB_B	11
-#define HCLGEVF_RSS_TC_SIZE_S		12
-#define HCLGEVF_RSS_TC_SIZE_M		GENMASK(14, 12)
-#define HCLGEVF_RSS_TC_VALID_B		15
-#define HCLGEVF_MAX_TC_NUM		8
-#define HCLGEVF_RSS_TC_SIZE_MSB_OFFSET	3
-
-struct hclgevf_rss_tc_mode_cmd {
-	__le16 rss_tc_mode[HCLGEVF_MAX_TC_NUM];
-	u8 rsv[8];
-};
-
 #define HCLGEVF_LINK_STS_B	0
 #define HCLGEVF_LINK_STATUS	BIT(HCLGEVF_LINK_STS_B)
 struct hclgevf_link_status_cmd {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8859bdb0aa89..3c42ca50f590 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -31,14 +31,6 @@ static const struct pci_device_id ae_algovf_pci_tbl[] = {
 	{0, }
 };
 
-static const u8 hclgevf_hash_key[] = {
-	0x6D, 0x5A, 0x56, 0xDA, 0x25, 0x5B, 0x0E, 0xC2,
-	0x41, 0x67, 0x25, 0x3D, 0x43, 0xA3, 0x8F, 0xB0,
-	0xD0, 0xCA, 0x2B, 0xCB, 0xAE, 0x7B, 0x30, 0xB4,
-	0x77, 0xCB, 0x2D, 0xA3, 0x80, 0x30, 0xF2, 0x0C,
-	0x6A, 0x42, 0xB7, 0x3B, 0xBE, 0xAC, 0x01, 0xFA
-};
-
 MODULE_DEVICE_TABLE(pci, ae_algovf_pci_tbl);
 
 static const u32 cmdq_reg_addr_list[] = {HCLGE_COMM_NIC_CSQ_BASEADDR_L_REG,
@@ -475,7 +467,7 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 	kinfo->num_tx_desc = hdev->num_tx_desc;
 	kinfo->num_rx_desc = hdev->num_rx_desc;
 	kinfo->rx_buf_len = hdev->rx_buf_len;
-	for (i = 0; i < HCLGEVF_MAX_TC_NUM; i++)
+	for (i = 0; i < HCLGE_COMM_MAX_TC_NUM; i++)
 		if (hdev->hw_tc_map & BIT(i))
 			num_tc++;
 
@@ -633,52 +625,6 @@ static int hclgevf_get_vector_index(struct hclgevf_dev *hdev, int vector)
 	return -EINVAL;
 }
 
-static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
-{
-	struct hclgevf_rss_tc_mode_cmd *req;
-	u16 tc_offset[HCLGEVF_MAX_TC_NUM];
-	u16 tc_valid[HCLGEVF_MAX_TC_NUM];
-	u16 tc_size[HCLGEVF_MAX_TC_NUM];
-	struct hclge_desc desc;
-	u16 roundup_size;
-	unsigned int i;
-	int status;
-
-	req = (struct hclgevf_rss_tc_mode_cmd *)desc.data;
-
-	roundup_size = roundup_pow_of_two(rss_size);
-	roundup_size = ilog2(roundup_size);
-
-	for (i = 0; i < HCLGEVF_MAX_TC_NUM; i++) {
-		tc_valid[i] = 1;
-		tc_size[i] = roundup_size;
-		tc_offset[i] = (hdev->hw_tc_map & BIT(i)) ? rss_size * i : 0;
-	}
-
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_TC_MODE, false);
-	for (i = 0; i < HCLGEVF_MAX_TC_NUM; i++) {
-		u16 mode = 0;
-
-		hnae3_set_bit(mode, HCLGEVF_RSS_TC_VALID_B,
-			      (tc_valid[i] & 0x1));
-		hnae3_set_field(mode, HCLGEVF_RSS_TC_SIZE_M,
-				HCLGEVF_RSS_TC_SIZE_S, tc_size[i]);
-		hnae3_set_bit(mode, HCLGEVF_RSS_TC_SIZE_MSB_B,
-			      tc_size[i] >> HCLGEVF_RSS_TC_SIZE_MSB_OFFSET &
-			      0x1);
-		hnae3_set_field(mode, HCLGEVF_RSS_TC_OFFSET_M,
-				HCLGEVF_RSS_TC_OFFSET_S, tc_offset[i]);
-
-		req->rss_tc_mode[i] = cpu_to_le16(mode);
-	}
-	status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-	if (status)
-		dev_err(&hdev->pdev->dev,
-			"VF failed(=%d) to set rss tc mode\n", status);
-
-	return status;
-}
-
 /* for revision 0x20, vf shared the same rss config with pf */
 static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 {
@@ -749,36 +695,13 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	const u8 *rss_hash_key = rss_cfg->rss_hash_key;
-	u8 hash_algo;
 	int ret, i;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		ret = hclge_comm_parse_rss_hfunc(rss_cfg, hfunc, &hash_algo);
+		ret = hclge_comm_set_rss_hash_key(rss_cfg, &hdev->hw.hw, key,
+						  hfunc);
 		if (ret)
 			return ret;
-
-		/* Set the RSS Hash Key if specififed by the user */
-		if (key) {
-			ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw,
-							  hash_algo, key);
-			if (ret) {
-				dev_err(&hdev->pdev->dev,
-					"invalid hfunc type %u\n", hfunc);
-				return ret;
-			}
-
-			/* Update the shadow RSS key with user specified qids */
-			memcpy(rss_cfg->rss_hash_key, key,
-			       HCLGE_COMM_RSS_KEY_SIZE);
-		} else {
-			ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw,
-							  hash_algo,
-							  rss_hash_key);
-			if (ret)
-				return ret;
-		}
-		rss_cfg->rss_algo = hash_algo;
 	}
 
 	/* update the shadow RSS table with user specified qids */
@@ -794,44 +717,18 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 				 struct ethtool_rxnfc *nfc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	struct hclge_comm_rss_input_tuple_cmd *req;
-	struct hclge_desc desc;
 	int ret;
 
 	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
 
-	if (nfc->data &
-	    ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 | RXH_L4_B_2_3))
-		return -EINVAL;
-
-	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INPUT_TUPLE, false);
-
-	ret = hclge_comm_init_rss_tuple_cmd(rss_cfg, nfc, hdev->ae_dev, req);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed to init rss tuple cmd, ret = %d\n", ret);
-		return ret;
-	}
-
-	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-	if (ret) {
+	ret = hclge_comm_set_rss_tuple(hdev->ae_dev, &hdev->hw.hw,
+				       &hdev->rss_cfg, nfc);
+	if (ret)
 		dev_err(&hdev->pdev->dev,
-			"Set rss tuple fail, status = %d\n", ret);
-		return ret;
-	}
+		"failed to set rss tuple, ret = %d.\n", ret);
 
-	rss_cfg->rss_tuple_sets.ipv4_tcp_en = req->ipv4_tcp_en;
-	rss_cfg->rss_tuple_sets.ipv4_udp_en = req->ipv4_udp_en;
-	rss_cfg->rss_tuple_sets.ipv4_sctp_en = req->ipv4_sctp_en;
-	rss_cfg->rss_tuple_sets.ipv4_fragment_en = req->ipv4_fragment_en;
-	rss_cfg->rss_tuple_sets.ipv6_tcp_en = req->ipv6_tcp_en;
-	rss_cfg->rss_tuple_sets.ipv6_udp_en = req->ipv6_udp_en;
-	rss_cfg->rss_tuple_sets.ipv6_sctp_en = req->ipv6_sctp_en;
-	rss_cfg->rss_tuple_sets.ipv6_fragment_en = req->ipv6_fragment_en;
-	return 0;
+	return ret;
 }
 
 static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
@@ -2351,53 +2248,12 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev)
 	return ret;
 }
 
-static int hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
-{
-	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
-	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	struct hclge_comm_rss_tuple_cfg *tuple_sets;
-	u32 i;
-
-	rss_cfg->rss_algo = HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ;
-	rss_cfg->rss_size = hdev->nic.kinfo.rss_size;
-	tuple_sets = &rss_cfg->rss_tuple_sets;
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		u16 *rss_ind_tbl;
-
-		rss_cfg->rss_algo = HCLGE_COMM_RSS_HASH_ALGO_SIMPLE;
-
-		rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
-					   sizeof(*rss_ind_tbl), GFP_KERNEL);
-		if (!rss_ind_tbl)
-			return -ENOMEM;
-
-		rss_cfg->rss_indirection_tbl = rss_ind_tbl;
-		memcpy(rss_cfg->rss_hash_key, hclgevf_hash_key,
-		       HCLGE_COMM_RSS_KEY_SIZE);
-
-		tuple_sets->ipv4_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv4_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv4_sctp_en = HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
-		tuple_sets->ipv4_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv6_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv6_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv6_sctp_en =
-			hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
-					HCLGE_COMM_RSS_INPUT_TUPLE_SCTP_NO_PORT :
-					HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
-		tuple_sets->ipv6_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-	}
-
-	/* Initialize RSS indirect table */
-	for (i = 0; i < rss_ind_tbl_size; i++)
-		rss_cfg->rss_indirection_tbl[i] = i % rss_cfg->rss_size;
-
-	return 0;
-}
-
 static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 {
 	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	u16 tc_offset[HCLGE_COMM_MAX_TC_NUM];
+	u16 tc_valid[HCLGE_COMM_MAX_TC_NUM];
+	u16 tc_size[HCLGE_COMM_MAX_TC_NUM];
 	int ret;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
@@ -2418,7 +2274,11 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
-	return hclgevf_set_rss_tc_mode(hdev, rss_cfg->rss_size);
+	hclge_comm_get_rss_tc_info(rss_cfg->rss_size, hdev->hw_tc_map,
+				   tc_offset, tc_valid, tc_size);
+
+	return hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset,
+					  tc_valid, tc_size);
 }
 
 static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev)
@@ -3187,7 +3047,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 
 	/* Initialize RSS for this VF */
-	ret = hclgevf_rss_init_cfg(hdev);
+	ret = hclge_comm_rss_init_cfg(&hdev->nic, hdev->ae_dev,
+				      &hdev->rss_cfg);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init rss cfg, ret = %d\n", ret);
 		goto err_config;
@@ -3361,6 +3222,9 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	u16 tc_offset[HCLGE_COMM_MAX_TC_NUM];
+	u16 tc_valid[HCLGE_COMM_MAX_TC_NUM];
+	u16 tc_size[HCLGE_COMM_MAX_TC_NUM];
 	u16 cur_rss_size = kinfo->rss_size;
 	u16 cur_tqps = kinfo->num_tqps;
 	u32 *rss_indir;
@@ -3369,7 +3233,10 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 
 	hclgevf_update_rss_size(handle, new_tqps_num);
 
-	ret = hclgevf_set_rss_tc_mode(hdev, kinfo->rss_size);
+	hclge_comm_get_rss_tc_info(cur_rss_size, hdev->hw_tc_map,
+				   tc_offset, tc_valid, tc_size);
+	ret = hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset,
+					 tc_valid, tc_size);
 	if (ret)
 		return ret;
 
-- 
2.33.0

