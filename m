Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3660C48545E
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbiAEOZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:33 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31071 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240687AbiAEOZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:20 -0500
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JTWrX2ldFz1DKQn;
        Wed,  5 Jan 2022 22:21:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
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
Subject: [PATCH net-next 05/15] net: hns3: refactor VF rss get APIs with new common rss get APIs
Date:   Wed, 5 Jan 2022 22:20:05 +0800
Message-ID: <20220105142015.51097-6-huangguangbin2@huawei.com>
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

This patch firstly uses new rss parameter struct(hclge_comm_rss_cfg) as
child member of hclgevf_dev and deletes the original child rss parameter
member(hclgevf_rss_cfg). All the rss parameter members used in VF rss
module is modified according to the new hclge_comm_rss_cfg.

Secondly VF rss get APIs are refactored to use new common rss get APIs. The
old rss get APIs in VF are deleted.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 99 +++++--------------
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      | 24 +----
 2 files changed, 24 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 66a65594d286..c3aca7887cc7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -9,6 +9,7 @@
 #include "hclge_mbx.h"
 #include "hnae3.h"
 #include "hclgevf_devlink.h"
+#include "hclge_comm_rss.h"
 
 #define HCLGEVF_NAME	"hclgevf"
 
@@ -672,14 +673,9 @@ static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
 	return 0;
 }
 
-static u32 hclgevf_get_rss_key_size(struct hnae3_handle *handle)
-{
-	return HCLGEVF_RSS_KEY_SIZE;
-}
-
 static int hclgevf_set_rss_indir_table(struct hclgevf_dev *hdev)
 {
-	const u8 *indir = hdev->rss_cfg.rss_indirection_tbl;
+	const u16 *indir = hdev->rss_cfg.rss_indirection_tbl;
 	struct hclgevf_rss_indirection_table_cmd *req;
 	struct hclge_desc desc;
 	int rss_cfg_tbl_num;
@@ -762,7 +758,7 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RSS_MBX_RESP_LEN	8
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 resp_msg[HCLGEVF_RSS_MBX_RESP_LEN];
 	struct hclge_vf_to_pf_msg send_msg;
 	u16 msg_num, hash_key_index;
@@ -800,13 +796,13 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 			   u8 *hfunc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	int i, ret;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		/* Get hash algorithm */
 		if (hfunc) {
-			switch (rss_cfg->hash_algo) {
+			switch (rss_cfg->rss_algo) {
 			case HCLGEVF_RSS_HASH_ALGO_TOEPLITZ:
 				*hfunc = ETH_RSS_HASH_TOP;
 				break;
@@ -842,34 +838,16 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 	return 0;
 }
 
-static int hclgevf_parse_rss_hfunc(struct hclgevf_dev *hdev, const u8 hfunc,
-				   u8 *hash_algo)
-{
-	switch (hfunc) {
-	case ETH_RSS_HASH_TOP:
-		*hash_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
-		return 0;
-	case ETH_RSS_HASH_XOR:
-		*hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
-		return 0;
-	case ETH_RSS_HASH_NO_CHANGE:
-		*hash_algo = hdev->rss_cfg.hash_algo;
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
 static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			   const u8 *key, const u8 hfunc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 hash_algo;
 	int ret, i;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		ret = hclgevf_parse_rss_hfunc(hdev, hfunc, &hash_algo);
+		ret = hclge_comm_parse_rss_hfunc(rss_cfg, hfunc, &hash_algo);
 		if (ret)
 			return ret;
 
@@ -891,7 +869,7 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			if (ret)
 				return ret;
 		}
-		rss_cfg->hash_algo = hash_algo;
+		rss_cfg->rss_algo = hash_algo;
 	}
 
 	/* update the shadow RSS table with user specified qids */
@@ -932,7 +910,7 @@ static int hclgevf_init_rss_tuple_cmd(struct hnae3_handle *handle,
 				      struct hclgevf_rss_input_tuple_cmd *req)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 tuple_sets;
 
 	req->ipv4_tcp_en = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
@@ -985,7 +963,7 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 				 struct ethtool_rxnfc *nfc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	struct hclgevf_rss_input_tuple_cmd *req;
 	struct hclge_desc desc;
 	int ret;
@@ -1025,39 +1003,6 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 	return 0;
 }
 
-static int hclgevf_get_rss_tuple_by_flow_type(struct hclgevf_dev *hdev,
-					      int flow_type, u8 *tuple_sets)
-{
-	switch (flow_type) {
-	case TCP_V4_FLOW:
-		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv4_tcp_en;
-		break;
-	case UDP_V4_FLOW:
-		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv4_udp_en;
-		break;
-	case TCP_V6_FLOW:
-		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv6_tcp_en;
-		break;
-	case UDP_V6_FLOW:
-		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv6_udp_en;
-		break;
-	case SCTP_V4_FLOW:
-		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv4_sctp_en;
-		break;
-	case SCTP_V6_FLOW:
-		*tuple_sets = hdev->rss_cfg.rss_tuple_sets.ipv6_sctp_en;
-		break;
-	case IPV4_FLOW:
-	case IPV6_FLOW:
-		*tuple_sets = HCLGEVF_S_IP_BIT | HCLGEVF_D_IP_BIT;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static u64 hclgevf_convert_rss_tuple(u8 tuple_sets)
 {
 	u64 tuple_data = 0;
@@ -1086,8 +1031,8 @@ static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
 
 	nfc->data = 0;
 
-	ret = hclgevf_get_rss_tuple_by_flow_type(hdev, nfc->flow_type,
-						 &tuple_sets);
+	ret = hclge_comm_get_rss_tuple(&hdev->rss_cfg, nfc->flow_type,
+				       &tuple_sets);
 	if (ret || !tuple_sets)
 		return ret;
 
@@ -1097,7 +1042,7 @@ static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
 }
 
 static int hclgevf_set_rss_input_tuple(struct hclgevf_dev *hdev,
-				       struct hclgevf_rss_cfg *rss_cfg)
+				       struct hclge_comm_rss_cfg *rss_cfg)
 {
 	struct hclgevf_rss_input_tuple_cmd *req;
 	struct hclge_desc desc;
@@ -1126,7 +1071,7 @@ static int hclgevf_set_rss_input_tuple(struct hclgevf_dev *hdev,
 static int hclgevf_get_tc_size(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 
 	return rss_cfg->rss_size;
 }
@@ -2621,17 +2566,17 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev)
 static int hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 {
 	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
-	struct hclgevf_rss_tuple_cfg *tuple_sets;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_tuple_cfg *tuple_sets;
 	u32 i;
 
-	rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
+	rss_cfg->rss_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
 	rss_cfg->rss_size = hdev->nic.kinfo.rss_size;
 	tuple_sets = &rss_cfg->rss_tuple_sets;
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		u8 *rss_ind_tbl;
+		u16 *rss_ind_tbl;
 
-		rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
+		rss_cfg->rss_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
 
 		rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
 					   sizeof(*rss_ind_tbl), GFP_KERNEL);
@@ -2664,11 +2609,11 @@ static int hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 
 static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 {
-	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	int ret;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		ret = hclgevf_set_rss_algo_key(hdev, rss_cfg->hash_algo,
+		ret = hclgevf_set_rss_algo_key(hdev, rss_cfg->rss_algo,
 					       rss_cfg->rss_hash_key);
 		if (ret)
 			return ret;
@@ -3892,7 +3837,7 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.update_stats = hclgevf_update_stats,
 	.get_strings = hclgevf_get_strings,
 	.get_sset_count = hclgevf_get_sset_count,
-	.get_rss_key_size = hclgevf_get_rss_key_size,
+	.get_rss_key_size = hclge_comm_get_rss_key_size,
 	.get_rss = hclgevf_get_rss,
 	.set_rss = hclgevf_set_rss,
 	.get_rss_tuple = hclgevf_get_rss_tuple,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 20db6edab306..b6cb6ac5c145 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -10,6 +10,7 @@
 #include "hclge_mbx.h"
 #include "hclgevf_cmd.h"
 #include "hnae3.h"
+#include "hclge_comm_rss.h"
 
 #define HCLGEVF_MOD_VERSION "1.0"
 #define HCLGEVF_DRIVER_NAME "hclgevf"
@@ -190,27 +191,6 @@ struct hclgevf_cfg {
 	u32 numa_node_map;
 };
 
-struct hclgevf_rss_tuple_cfg {
-	u8 ipv4_tcp_en;
-	u8 ipv4_udp_en;
-	u8 ipv4_sctp_en;
-	u8 ipv4_fragment_en;
-	u8 ipv6_tcp_en;
-	u8 ipv6_udp_en;
-	u8 ipv6_sctp_en;
-	u8 ipv6_fragment_en;
-};
-
-struct hclgevf_rss_cfg {
-	u8  rss_hash_key[HCLGEVF_RSS_KEY_SIZE]; /* user configured hash keys */
-	u32 hash_algo;
-	u32 rss_size;
-	u8 hw_tc_map;
-	/* shadow table */
-	u8 *rss_indirection_tbl;
-	struct hclgevf_rss_tuple_cfg rss_tuple_sets;
-};
-
 struct hclgevf_misc_vector {
 	u8 __iomem *addr;
 	int vector_irq;
@@ -255,7 +235,7 @@ struct hclgevf_dev {
 	struct hnae3_ae_dev *ae_dev;
 	struct hclgevf_hw hw;
 	struct hclgevf_misc_vector misc_vector;
-	struct hclgevf_rss_cfg rss_cfg;
+	struct hclge_comm_rss_cfg rss_cfg;
 	unsigned long state;
 	unsigned long flr_state;
 	unsigned long default_reset_request;
-- 
2.33.0

