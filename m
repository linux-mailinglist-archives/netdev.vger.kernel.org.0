Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C36485463
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240751AbiAEOZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:36 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17328 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JTWvM2Vbrz9s1g;
        Wed,  5 Jan 2022 22:24:15 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
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
Subject: [PATCH net-next 10/15] net: hns3: refactor PF rss init APIs with new common rss init APIs
Date:   Wed, 5 Jan 2022 22:20:10 +0800
Message-ID: <20220105142015.51097-11-huangguangbin2@huawei.com>
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

This patch uses common rss init APIs to replace the old APIs in PF rss
module and deletes the old PF rss init APIs. Some related subfunctions and
macros are also modified in this patch.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   4 -
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 138 ++----------------
 2 files changed, 11 insertions(+), 131 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 0c7b943f57d8..a28d45e8f986 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -492,10 +492,6 @@ struct hclge_vf_num_cmd {
 #define HCLGE_RSS_TC_SIZE_M		GENMASK(14, 12)
 #define HCLGE_RSS_TC_SIZE_MSB_OFFSET	3
 #define HCLGE_RSS_TC_VALID_B		15
-struct hclge_rss_tc_mode_cmd {
-	__le16 rss_tc_mode[HCLGE_MAX_TC_NUM];
-	u8 rsv[8];
-};
 
 #define HCLGE_LINK_STATUS_UP_B	0
 #define HCLGE_LINK_STATUS_UP_M	BIT(HCLGE_LINK_STATUS_UP_B)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 8696038a0580..4d835be1fb2c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -371,14 +371,6 @@ static const struct hclge_mac_mgr_tbl_entry_cmd hclge_mgr_table[] = {
 	},
 };
 
-static const u8 hclge_hash_key[] = {
-	0x6D, 0x5A, 0x56, 0xDA, 0x25, 0x5B, 0x0E, 0xC2,
-	0x41, 0x67, 0x25, 0x3D, 0x43, 0xA3, 0x8F, 0xB0,
-	0xD0, 0xCA, 0x2B, 0xCB, 0xAE, 0x7B, 0x30, 0xB4,
-	0x77, 0xCB, 0x2D, 0xA3, 0x80, 0x30, 0xF2, 0x0C,
-	0x6A, 0x42, 0xB7, 0x3B, 0xBE, 0xAC, 0x01, 0xFA
-};
-
 static const u32 hclge_dfx_bd_offset_list[] = {
 	HCLGE_DFX_BIOS_BD_OFFSET,
 	HCLGE_DFX_SSU_0_BD_OFFSET,
@@ -4719,39 +4711,6 @@ static int hclge_put_vector(struct hnae3_handle *handle, int vector)
 	return 0;
 }
 
-static int hclge_set_rss_tc_mode(struct hclge_dev *hdev, u16 *tc_valid,
-				 u16 *tc_size, u16 *tc_offset)
-{
-	struct hclge_rss_tc_mode_cmd *req;
-	struct hclge_desc desc;
-	int ret;
-	int i;
-
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_TC_MODE, false);
-	req = (struct hclge_rss_tc_mode_cmd *)desc.data;
-
-	for (i = 0; i < HCLGE_MAX_TC_NUM; i++) {
-		u16 mode = 0;
-
-		hnae3_set_bit(mode, HCLGE_RSS_TC_VALID_B, (tc_valid[i] & 0x1));
-		hnae3_set_field(mode, HCLGE_RSS_TC_SIZE_M,
-				HCLGE_RSS_TC_SIZE_S, tc_size[i]);
-		hnae3_set_bit(mode, HCLGE_RSS_TC_SIZE_MSB_B,
-			      tc_size[i] >> HCLGE_RSS_TC_SIZE_MSB_OFFSET & 0x1);
-		hnae3_set_field(mode, HCLGE_RSS_TC_OFFSET_M,
-				HCLGE_RSS_TC_OFFSET_S, tc_offset[i]);
-
-		req->rss_tc_mode[i] = cpu_to_le16(mode);
-	}
-
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"Configure rss tc mode fail, status = %d\n", ret);
-
-	return ret;
-}
-
 static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 			 u8 *key, u8 *hfunc)
 {
@@ -4774,34 +4733,17 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	u8 hash_algo;
 	int ret, i;
 
-	ret = hclge_comm_parse_rss_hfunc(&hdev->rss_cfg, hfunc, &hash_algo);
+	ret = hclge_comm_set_rss_hash_key(rss_cfg, &hdev->hw.hw, key, hfunc);
 	if (ret) {
 		dev_err(&hdev->pdev->dev, "invalid hfunc type %u\n", hfunc);
 		return ret;
 	}
 
-	/* Set the RSS Hash Key if specififed by the user */
-	if (key) {
-		ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw, hash_algo, key);
-		if (ret)
-			return ret;
-
-		/* Update the shadow RSS key with user specified qids */
-		memcpy(hdev->rss_cfg.rss_hash_key, key, HCLGE_COMM_RSS_KEY_SIZE);
-	} else {
-		ret = hclge_comm_set_rss_algo_key(&hdev->hw.hw, hash_algo,
-						  hdev->rss_cfg.rss_hash_key);
-		if (ret)
-			return ret;
-	}
-	hdev->rss_cfg.rss_algo = hash_algo;
-
 	/* Update the shadow RSS table with user specified qids */
 	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
-		hdev->rss_cfg.rss_indirection_tbl[i] = indir[i];
+		rss_cfg->rss_indirection_tbl[i] = indir[i];
 
 	/* Update the hardware */
 	return hclge_comm_set_rss_indir_table(ae_dev, &hdev->hw.hw,
@@ -4812,41 +4754,17 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 			       struct ethtool_rxnfc *nfc)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_comm_rss_input_tuple_cmd *req;
 	struct hclge_dev *hdev = vport->back;
-	struct hclge_desc desc;
 	int ret;
 
-	if (nfc->data & ~(RXH_IP_SRC | RXH_IP_DST |
-			  RXH_L4_B_0_1 | RXH_L4_B_2_3))
-		return -EINVAL;
-
-	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_INPUT_TUPLE, false);
-
-	ret = hclge_comm_init_rss_tuple_cmd(&hdev->rss_cfg, nfc, hdev->ae_dev,
-					    req);
+	ret = hclge_comm_set_rss_tuple(hdev->ae_dev, &hdev->hw.hw,
+				       &hdev->rss_cfg, nfc);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"failed to init rss tuple cmd, ret = %d\n", ret);
+			"failed to set rss tuple, ret = %d.\n", ret);
 		return ret;
 	}
 
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"Set rss tuple fail, status = %d\n", ret);
-		return ret;
-	}
-
-	hdev->rss_cfg.rss_tuple_sets.ipv4_tcp_en = req->ipv4_tcp_en;
-	hdev->rss_cfg.rss_tuple_sets.ipv4_udp_en = req->ipv4_udp_en;
-	hdev->rss_cfg.rss_tuple_sets.ipv4_sctp_en = req->ipv4_sctp_en;
-	hdev->rss_cfg.rss_tuple_sets.ipv4_fragment_en = req->ipv4_fragment_en;
-	hdev->rss_cfg.rss_tuple_sets.ipv6_tcp_en = req->ipv6_tcp_en;
-	hdev->rss_cfg.rss_tuple_sets.ipv6_udp_en = req->ipv6_udp_en;
-	hdev->rss_cfg.rss_tuple_sets.ipv6_sctp_en = req->ipv6_sctp_en;
-	hdev->rss_cfg.rss_tuple_sets.ipv6_fragment_en = req->ipv6_fragment_en;
 	hclge_comm_get_rss_type(&vport->nic, &hdev->rss_cfg.rss_tuple_sets);
 	return 0;
 }
@@ -4918,7 +4836,8 @@ static int hclge_init_rss_tc_mode(struct hclge_dev *hdev)
 		tc_offset[i] = tc_info->tqp_offset[i];
 	}
 
-	return hclge_set_rss_tc_mode(hdev, tc_valid, tc_size, tc_offset);
+	return hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset, tc_valid,
+					  tc_size);
 }
 
 int hclge_rss_init_hw(struct hclge_dev *hdev)
@@ -4946,43 +4865,6 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	return hclge_init_rss_tc_mode(hdev);
 }
 
-static int hclge_rss_init_cfg(struct hclge_dev *hdev)
-{
-	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
-	int rss_algo = HCLGE_COMM_RSS_HASH_ALGO_TOEPLITZ;
-	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	u16 *rss_ind_tbl;
-
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
-		rss_algo = HCLGE_COMM_RSS_HASH_ALGO_SIMPLE;
-
-	rss_cfg->rss_tuple_sets.ipv4_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv4_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv4_sctp_en = HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
-	rss_cfg->rss_tuple_sets.ipv4_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv6_tcp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv6_udp_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-	rss_cfg->rss_tuple_sets.ipv6_sctp_en =
-		hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
-		HCLGE_COMM_RSS_INPUT_TUPLE_SCTP_NO_PORT :
-		HCLGE_COMM_RSS_INPUT_TUPLE_SCTP;
-	rss_cfg->rss_tuple_sets.ipv6_fragment_en = HCLGE_COMM_RSS_INPUT_TUPLE_OTHER;
-
-	rss_cfg->rss_algo = rss_algo;
-
-	rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
-				   sizeof(*rss_ind_tbl), GFP_KERNEL);
-	if (!rss_ind_tbl)
-		return -ENOMEM;
-
-	rss_cfg->rss_indirection_tbl = rss_ind_tbl;
-	memcpy(rss_cfg->rss_hash_key, hclge_hash_key, HCLGE_COMM_RSS_KEY_SIZE);
-
-	hclge_comm_rss_indir_init_cfg(hdev->ae_dev, rss_cfg);
-
-	return 0;
-}
-
 int hclge_bind_ring_with_vector(struct hclge_vport *vport,
 				int vector_id, bool en,
 				struct hnae3_ring_chain_node *ring_chain)
@@ -11588,7 +11470,8 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_mdiobus_unreg;
 	}
 
-	ret = hclge_rss_init_cfg(hdev);
+	ret = hclge_comm_rss_init_cfg(&hdev->vport->nic, hdev->ae_dev,
+				      &hdev->rss_cfg);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init rss cfg, ret = %d\n", ret);
 		goto err_mdiobus_unreg;
@@ -12125,7 +12008,8 @@ static int hclge_set_rss_tc_mode_cfg(struct hnae3_handle *handle)
 		tc_offset[i] = vport->nic.kinfo.rss_size * i;
 	}
 
-	return hclge_set_rss_tc_mode(hdev, tc_valid, tc_size, tc_offset);
+	return hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset, tc_valid,
+					  tc_size);
 }
 
 static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
-- 
2.33.0

