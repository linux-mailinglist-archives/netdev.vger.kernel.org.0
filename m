Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4160485460
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbiAEOZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:34 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34877 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240686AbiAEOZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:20 -0500
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JTWvs1rcxzccLK;
        Wed,  5 Jan 2022 22:24:41 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 04/15] net: hns3: refactor PF rss get APIs with new common rss get APIs
Date:   Wed, 5 Jan 2022 22:20:04 +0800
Message-ID: <20220105142015.51097-5-huangguangbin2@huawei.com>
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
child member of hclge_dev and deletes the original child rss parameter
members in vport. All the vport child rss parameter members used in PF rss
module is modified according to the new hclge_comm_rss_cfg.

Secondly PF rss get APIs are refactored to use new common rss get APIs. The
old rss get APIs in PF are deleted.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 193 ++++++------------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  23 +--
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |   2 +-
 5 files changed, 67 insertions(+), 160 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 375ebf105a9a..69b8673436ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -203,7 +203,7 @@ static int hclge_map_update(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	hclge_rss_indir_init_cfg(hdev);
+	hclge_comm_rss_indir_init_cfg(hdev->ae_dev, &hdev->rss_cfg);
 
 	return hclge_rss_init_hw(hdev);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a365b9412437..1cf11b936972 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4719,11 +4719,6 @@ static int hclge_put_vector(struct hnae3_handle *handle, int vector)
 	return 0;
 }
 
-static u32 hclge_get_rss_key_size(struct hnae3_handle *handle)
-{
-	return HCLGE_RSS_KEY_SIZE;
-}
-
 static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
 				  const u8 hfunc, const u8 *key)
 {
@@ -4837,22 +4832,6 @@ static int hclge_set_rss_tc_mode(struct hclge_dev *hdev, u16 *tc_valid,
 	return ret;
 }
 
-static void hclge_get_rss_type(struct hclge_vport *vport)
-{
-	if (vport->rss_tuple_sets.ipv4_tcp_en ||
-	    vport->rss_tuple_sets.ipv4_udp_en ||
-	    vport->rss_tuple_sets.ipv4_sctp_en ||
-	    vport->rss_tuple_sets.ipv6_tcp_en ||
-	    vport->rss_tuple_sets.ipv6_udp_en ||
-	    vport->rss_tuple_sets.ipv6_sctp_en)
-		vport->nic.kinfo.rss_type = PKT_HASH_TYPE_L4;
-	else if (vport->rss_tuple_sets.ipv4_fragment_en ||
-		 vport->rss_tuple_sets.ipv6_fragment_en)
-		vport->nic.kinfo.rss_type = PKT_HASH_TYPE_L3;
-	else
-		vport->nic.kinfo.rss_type = PKT_HASH_TYPE_NONE;
-}
-
 static int hclge_set_rss_input_tuple(struct hclge_dev *hdev)
 {
 	struct hclge_rss_input_tuple_cmd *req;
@@ -4864,15 +4843,16 @@ static int hclge_set_rss_input_tuple(struct hclge_dev *hdev)
 	req = (struct hclge_rss_input_tuple_cmd *)desc.data;
 
 	/* Get the tuple cfg from pf */
-	req->ipv4_tcp_en = hdev->vport[0].rss_tuple_sets.ipv4_tcp_en;
-	req->ipv4_udp_en = hdev->vport[0].rss_tuple_sets.ipv4_udp_en;
-	req->ipv4_sctp_en = hdev->vport[0].rss_tuple_sets.ipv4_sctp_en;
-	req->ipv4_fragment_en = hdev->vport[0].rss_tuple_sets.ipv4_fragment_en;
-	req->ipv6_tcp_en = hdev->vport[0].rss_tuple_sets.ipv6_tcp_en;
-	req->ipv6_udp_en = hdev->vport[0].rss_tuple_sets.ipv6_udp_en;
-	req->ipv6_sctp_en = hdev->vport[0].rss_tuple_sets.ipv6_sctp_en;
-	req->ipv6_fragment_en = hdev->vport[0].rss_tuple_sets.ipv6_fragment_en;
-	hclge_get_rss_type(&hdev->vport[0]);
+	req->ipv4_tcp_en = hdev->rss_cfg.rss_tuple_sets.ipv4_tcp_en;
+	req->ipv4_udp_en = hdev->rss_cfg.rss_tuple_sets.ipv4_udp_en;
+	req->ipv4_sctp_en = hdev->rss_cfg.rss_tuple_sets.ipv4_sctp_en;
+	req->ipv4_fragment_en = hdev->rss_cfg.rss_tuple_sets.ipv4_fragment_en;
+	req->ipv6_tcp_en = hdev->rss_cfg.rss_tuple_sets.ipv6_tcp_en;
+	req->ipv6_udp_en = hdev->rss_cfg.rss_tuple_sets.ipv6_udp_en;
+	req->ipv6_sctp_en = hdev->rss_cfg.rss_tuple_sets.ipv6_sctp_en;
+	req->ipv6_fragment_en = hdev->rss_cfg.rss_tuple_sets.ipv6_fragment_en;
+	hclge_comm_get_rss_type(&hdev->vport[0].nic,
+				&hdev->rss_cfg.rss_tuple_sets);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
 		dev_err(&hdev->pdev->dev,
@@ -4885,11 +4865,12 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_comm_rss_cfg *rss_cfg = &vport->back->rss_cfg;
 	int i;
 
 	/* Get hash algorithm */
 	if (hfunc) {
-		switch (vport->rss_algo) {
+		switch (rss_cfg->rss_algo) {
 		case HCLGE_RSS_HASH_ALGO_TOEPLITZ:
 			*hfunc = ETH_RSS_HASH_TOP;
 			break;
@@ -4904,34 +4885,16 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 
 	/* Get the RSS Key required by the user */
 	if (key)
-		memcpy(key, vport->rss_hash_key, HCLGE_RSS_KEY_SIZE);
+		memcpy(key, rss_cfg->rss_hash_key, HCLGE_RSS_KEY_SIZE);
 
 	/* Get indirect table */
 	if (indir)
 		for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
-			indir[i] =  vport->rss_indirection_tbl[i];
+			indir[i] =  rss_cfg->rss_indirection_tbl[i];
 
 	return 0;
 }
 
-static int hclge_parse_rss_hfunc(struct hclge_vport *vport, const u8 hfunc,
-				 u8 *hash_algo)
-{
-	switch (hfunc) {
-	case ETH_RSS_HASH_TOP:
-		*hash_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
-		return 0;
-	case ETH_RSS_HASH_XOR:
-		*hash_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
-		return 0;
-	case ETH_RSS_HASH_NO_CHANGE:
-		*hash_algo = vport->rss_algo;
-		return 0;
-	default:
-		return -EINVAL;
-	}
-}
-
 static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			 const  u8 *key, const  u8 hfunc)
 {
@@ -4941,7 +4904,7 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	u8 hash_algo;
 	int ret, i;
 
-	ret = hclge_parse_rss_hfunc(vport, hfunc, &hash_algo);
+	ret = hclge_comm_parse_rss_hfunc(&hdev->rss_cfg, hfunc, &hash_algo);
 	if (ret) {
 		dev_err(&hdev->pdev->dev, "invalid hfunc type %u\n", hfunc);
 		return ret;
@@ -4954,21 +4917,22 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			return ret;
 
 		/* Update the shadow RSS key with user specified qids */
-		memcpy(vport->rss_hash_key, key, HCLGE_RSS_KEY_SIZE);
+		memcpy(hdev->rss_cfg.rss_hash_key, key, HCLGE_RSS_KEY_SIZE);
 	} else {
 		ret = hclge_set_rss_algo_key(hdev, hash_algo,
-					     vport->rss_hash_key);
+					     hdev->rss_cfg.rss_hash_key);
 		if (ret)
 			return ret;
 	}
-	vport->rss_algo = hash_algo;
+	hdev->rss_cfg.rss_algo = hash_algo;
 
 	/* Update the shadow RSS table with user specified qids */
 	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
-		vport->rss_indirection_tbl[i] = indir[i];
+		hdev->rss_cfg.rss_indirection_tbl[i] = indir[i];
 
 	/* Update the hardware */
-	return hclge_set_rss_indir_table(hdev, vport->rss_indirection_tbl);
+	return hclge_set_rss_indir_table(hdev,
+					 hdev->rss_cfg.rss_indirection_tbl);
 }
 
 static u8 hclge_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
@@ -5001,16 +4965,17 @@ static int hclge_init_rss_tuple_cmd(struct hclge_vport *vport,
 				    struct hclge_rss_input_tuple_cmd *req)
 {
 	struct hclge_dev *hdev = vport->back;
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 tuple_sets;
 
-	req->ipv4_tcp_en = vport->rss_tuple_sets.ipv4_tcp_en;
-	req->ipv4_udp_en = vport->rss_tuple_sets.ipv4_udp_en;
-	req->ipv4_sctp_en = vport->rss_tuple_sets.ipv4_sctp_en;
-	req->ipv4_fragment_en = vport->rss_tuple_sets.ipv4_fragment_en;
-	req->ipv6_tcp_en = vport->rss_tuple_sets.ipv6_tcp_en;
-	req->ipv6_udp_en = vport->rss_tuple_sets.ipv6_udp_en;
-	req->ipv6_sctp_en = vport->rss_tuple_sets.ipv6_sctp_en;
-	req->ipv6_fragment_en = vport->rss_tuple_sets.ipv6_fragment_en;
+	req->ipv4_tcp_en = rss_cfg->rss_tuple_sets.ipv4_tcp_en;
+	req->ipv4_udp_en = rss_cfg->rss_tuple_sets.ipv4_udp_en;
+	req->ipv4_sctp_en = rss_cfg->rss_tuple_sets.ipv4_sctp_en;
+	req->ipv4_fragment_en = rss_cfg->rss_tuple_sets.ipv4_fragment_en;
+	req->ipv6_tcp_en = rss_cfg->rss_tuple_sets.ipv6_tcp_en;
+	req->ipv6_udp_en = rss_cfg->rss_tuple_sets.ipv6_udp_en;
+	req->ipv6_sctp_en = rss_cfg->rss_tuple_sets.ipv6_sctp_en;
+	req->ipv6_fragment_en = rss_cfg->rss_tuple_sets.ipv6_fragment_en;
 
 	tuple_sets = hclge_get_rss_hash_bits(nfc);
 	switch (nfc->flow_type) {
@@ -5079,48 +5044,15 @@ static int hclge_set_rss_tuple(struct hnae3_handle *handle,
 		return ret;
 	}
 
-	vport->rss_tuple_sets.ipv4_tcp_en = req->ipv4_tcp_en;
-	vport->rss_tuple_sets.ipv4_udp_en = req->ipv4_udp_en;
-	vport->rss_tuple_sets.ipv4_sctp_en = req->ipv4_sctp_en;
-	vport->rss_tuple_sets.ipv4_fragment_en = req->ipv4_fragment_en;
-	vport->rss_tuple_sets.ipv6_tcp_en = req->ipv6_tcp_en;
-	vport->rss_tuple_sets.ipv6_udp_en = req->ipv6_udp_en;
-	vport->rss_tuple_sets.ipv6_sctp_en = req->ipv6_sctp_en;
-	vport->rss_tuple_sets.ipv6_fragment_en = req->ipv6_fragment_en;
-	hclge_get_rss_type(vport);
-	return 0;
-}
-
-static int hclge_get_vport_rss_tuple(struct hclge_vport *vport, int flow_type,
-				     u8 *tuple_sets)
-{
-	switch (flow_type) {
-	case TCP_V4_FLOW:
-		*tuple_sets = vport->rss_tuple_sets.ipv4_tcp_en;
-		break;
-	case UDP_V4_FLOW:
-		*tuple_sets = vport->rss_tuple_sets.ipv4_udp_en;
-		break;
-	case TCP_V6_FLOW:
-		*tuple_sets = vport->rss_tuple_sets.ipv6_tcp_en;
-		break;
-	case UDP_V6_FLOW:
-		*tuple_sets = vport->rss_tuple_sets.ipv6_udp_en;
-		break;
-	case SCTP_V4_FLOW:
-		*tuple_sets = vport->rss_tuple_sets.ipv4_sctp_en;
-		break;
-	case SCTP_V6_FLOW:
-		*tuple_sets = vport->rss_tuple_sets.ipv6_sctp_en;
-		break;
-	case IPV4_FLOW:
-	case IPV6_FLOW:
-		*tuple_sets = HCLGE_S_IP_BIT | HCLGE_D_IP_BIT;
-		break;
-	default:
-		return -EINVAL;
-	}
-
+	hdev->rss_cfg.rss_tuple_sets.ipv4_tcp_en = req->ipv4_tcp_en;
+	hdev->rss_cfg.rss_tuple_sets.ipv4_udp_en = req->ipv4_udp_en;
+	hdev->rss_cfg.rss_tuple_sets.ipv4_sctp_en = req->ipv4_sctp_en;
+	hdev->rss_cfg.rss_tuple_sets.ipv4_fragment_en = req->ipv4_fragment_en;
+	hdev->rss_cfg.rss_tuple_sets.ipv6_tcp_en = req->ipv6_tcp_en;
+	hdev->rss_cfg.rss_tuple_sets.ipv6_udp_en = req->ipv6_udp_en;
+	hdev->rss_cfg.rss_tuple_sets.ipv6_sctp_en = req->ipv6_sctp_en;
+	hdev->rss_cfg.rss_tuple_sets.ipv6_fragment_en = req->ipv6_fragment_en;
+	hclge_comm_get_rss_type(&vport->nic, &hdev->rss_cfg.rss_tuple_sets);
 	return 0;
 }
 
@@ -5149,7 +5081,8 @@ static int hclge_get_rss_tuple(struct hnae3_handle *handle,
 
 	nfc->data = 0;
 
-	ret = hclge_get_vport_rss_tuple(vport, nfc->flow_type, &tuple_sets);
+	ret = hclge_comm_get_rss_tuple(&vport->back->rss_cfg, nfc->flow_type,
+				       &tuple_sets);
 	if (ret || !tuple_sets)
 		return ret;
 
@@ -5211,10 +5144,9 @@ static int hclge_init_rss_tc_mode(struct hclge_dev *hdev)
 
 int hclge_rss_init_hw(struct hclge_dev *hdev)
 {
-	struct hclge_vport *vport = hdev->vport;
-	u16 *rss_indir = vport[0].rss_indirection_tbl;
-	u8 *key = vport[0].rss_hash_key;
-	u8 hfunc = vport[0].rss_algo;
+	u16 *rss_indir = hdev->rss_cfg.rss_indirection_tbl;
+	u8 *key = hdev->rss_cfg.rss_hash_key;
+	u8 hfunc = hdev->rss_cfg.rss_algo;
 	int ret;
 
 	ret = hclge_set_rss_indir_table(hdev, rss_indir);
@@ -5232,48 +5164,39 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 	return hclge_init_rss_tc_mode(hdev);
 }
 
-void hclge_rss_indir_init_cfg(struct hclge_dev *hdev)
-{
-	struct hclge_vport *vport = &hdev->vport[0];
-	int i;
-
-	for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
-		vport->rss_indirection_tbl[i] = i % vport->alloc_rss_size;
-}
-
 static int hclge_rss_init_cfg(struct hclge_dev *hdev)
 {
 	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
 	int rss_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
-	struct hclge_vport *vport = &hdev->vport[0];
+	struct hclge_comm_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u16 *rss_ind_tbl;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 		rss_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
 
-	vport->rss_tuple_sets.ipv4_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	vport->rss_tuple_sets.ipv4_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	vport->rss_tuple_sets.ipv4_sctp_en = HCLGE_RSS_INPUT_TUPLE_SCTP;
-	vport->rss_tuple_sets.ipv4_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	vport->rss_tuple_sets.ipv6_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	vport->rss_tuple_sets.ipv6_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
-	vport->rss_tuple_sets.ipv6_sctp_en =
+	rss_cfg->rss_tuple_sets.ipv4_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv4_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv4_sctp_en = HCLGE_RSS_INPUT_TUPLE_SCTP;
+	rss_cfg->rss_tuple_sets.ipv4_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv6_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv6_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv6_sctp_en =
 		hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
 		HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT :
 		HCLGE_RSS_INPUT_TUPLE_SCTP;
-	vport->rss_tuple_sets.ipv6_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	rss_cfg->rss_tuple_sets.ipv6_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
 
-	vport->rss_algo = rss_algo;
+	rss_cfg->rss_algo = rss_algo;
 
 	rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
 				   sizeof(*rss_ind_tbl), GFP_KERNEL);
 	if (!rss_ind_tbl)
 		return -ENOMEM;
 
-	vport->rss_indirection_tbl = rss_ind_tbl;
-	memcpy(vport->rss_hash_key, hclge_hash_key, HCLGE_RSS_KEY_SIZE);
+	rss_cfg->rss_indirection_tbl = rss_ind_tbl;
+	memcpy(rss_cfg->rss_hash_key, hclge_hash_key, HCLGE_RSS_KEY_SIZE);
 
-	hclge_rss_indir_init_cfg(hdev);
+	hclge_comm_rss_indir_init_cfg(hdev->ae_dev, rss_cfg);
 
 	return 0;
 }
@@ -13213,7 +13136,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.check_port_speed = hclge_check_port_speed,
 	.get_fec = hclge_get_fec,
 	.set_fec = hclge_set_fec,
-	.get_rss_key_size = hclge_get_rss_key_size,
+	.get_rss_key_size = hclge_comm_get_rss_key_size,
 	.get_rss = hclge_get_rss,
 	.set_rss = hclge_set_rss,
 	.set_rss_tuple = hclge_set_rss_tuple,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9764094aadec..85139b1377e9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -13,6 +13,7 @@
 #include "hclge_cmd.h"
 #include "hclge_ptp.h"
 #include "hnae3.h"
+#include "hclge_comm_rss.h"
 
 #define HCLGE_MOD_VERSION "1.0"
 #define HCLGE_DRIVER_NAME "hclge"
@@ -968,6 +969,7 @@ struct hclge_dev {
 	cpumask_t affinity_mask;
 	struct hclge_ptp *ptp;
 	struct devlink *devlink;
+	struct hclge_comm_rss_cfg rss_cfg;
 };
 
 /* VPort level vlan tag configuration for TX direction */
@@ -994,17 +996,6 @@ struct hclge_rx_vtag_cfg {
 	bool strip_tag2_discard_en; /* Outer vlan tag discard for BD enable */
 };
 
-struct hclge_rss_tuple_cfg {
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
 enum HCLGE_VPORT_STATE {
 	HCLGE_VPORT_STATE_ALIVE,
 	HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
@@ -1038,15 +1029,6 @@ struct hclge_vf_info {
 struct hclge_vport {
 	u16 alloc_tqps;	/* Allocated Tx/Rx queues */
 
-	u8  rss_hash_key[HCLGE_RSS_KEY_SIZE]; /* User configured hash keys */
-	/* User configured lookup table entries */
-	u16 *rss_indirection_tbl;
-	int rss_algo;		/* User configured hash algorithm */
-	/* User configured rss tuple sets */
-	struct hclge_rss_tuple_cfg rss_tuple_sets;
-
-	u16 alloc_rss_size;
-
 	u16 qs_offset;
 	u32 bw_limit;		/* VSI BW Limit (0 = disabled) */
 	u8  dwrr;
@@ -1125,7 +1107,6 @@ int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable);
 
 int hclge_buffer_alloc(struct hclge_dev *hdev);
 int hclge_rss_init_hw(struct hclge_dev *hdev);
-void hclge_rss_indir_init_cfg(struct hclge_dev *hdev);
 
 void hclge_mbx_handler(struct hclge_dev *hdev);
 int hclge_reset_tqp(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index db13033b60f4..6799d16de34b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -4,6 +4,7 @@
 #include "hclge_main.h"
 #include "hclge_mbx.h"
 #include "hnae3.h"
+#include "hclge_comm_rss.h"
 
 #define CREATE_TRACE_POINTS
 #include "hclge_trace.h"
@@ -612,15 +613,17 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 {
 #define HCLGE_RSS_MBX_RESP_LEN	8
 	struct hclge_dev *hdev = vport->back;
+	struct hclge_comm_rss_cfg *rss_cfg;
 	u8 index;
 
 	index = mbx_req->msg.data[0];
+	rss_cfg = &hdev->rss_cfg;
 
 	/* Check the query index of rss_hash_key from VF, make sure no
 	 * more than the size of rss_hash_key.
 	 */
 	if (((index + 1) * HCLGE_RSS_MBX_RESP_LEN) >
-	      sizeof(vport[0].rss_hash_key)) {
+	      sizeof(rss_cfg->rss_hash_key)) {
 		dev_warn(&hdev->pdev->dev,
 			 "failed to get the rss hash key, the index(%u) invalid !\n",
 			 index);
@@ -628,7 +631,7 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 	}
 
 	memcpy(resp_msg->data,
-	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
+	       &rss_cfg->rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
 	resp_msg->len = HCLGE_RSS_MBX_RESP_LEN;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 3edbfc8d17e8..089f4444b7e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -678,8 +678,8 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	hclge_tm_update_kinfo_rss_size(vport);
 	kinfo->num_tqps = hclge_vport_get_tqp_num(vport);
 	vport->dwrr = 100;  /* 100 percent as init */
-	vport->alloc_rss_size = kinfo->rss_size;
 	vport->bw_limit = hdev->tm_info.pg_info[0].bw_limit;
+	hdev->rss_cfg.rss_size = kinfo->rss_size;
 
 	/* when enable mqprio, the tc_info has been updated. */
 	if (kinfo->tc_info.mqprio_active)
-- 
2.33.0

