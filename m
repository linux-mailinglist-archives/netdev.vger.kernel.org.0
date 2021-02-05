Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC93106CD
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBEIet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:34:49 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12429 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhBEIeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:34:08 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DX7vQ6DrkzjHM9;
        Fri,  5 Feb 2021 16:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 16:33:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 2/6] net: hns3: RSS indirection table use device specification
Date:   Fri, 5 Feb 2021 16:32:45 +0800
Message-ID: <1612513969-9278-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
References: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

As RSS indirection table size may be different in different
hardware. Instead of using macro, this value is better to use
device specification which querying from firmware.

BTW, RSS indirection table should be allocated by the queried
size instead the static array.

.get_rss_indir_size in struct hnae3_ae_ops is not used now,
so remove it as well.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 --
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  6 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 45 +++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 43 ++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  6 +--
 6 files changed, 66 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index fe09cf6..ba94b3c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -410,8 +410,6 @@ struct hnae3_ae_dev {
  *   Get the len of the regs dump
  * get_rss_key_size()
  *   Get rss key size
- * get_rss_indir_size()
- *   Get rss indirection table size
  * get_rss()
  *   Get rss table
  * set_rss()
@@ -555,7 +553,6 @@ struct hnae3_ae_ops {
 	int (*get_regs_len)(struct hnae3_handle *handle);
 
 	u32 (*get_rss_key_size)(struct hnae3_handle *handle);
-	u32 (*get_rss_indir_size)(struct hnae3_handle *handle);
 	int (*get_rss)(struct hnae3_handle *handle, u32 *indir, u8 *key,
 		       u8 *hfunc);
 	int (*set_rss)(struct hnae3_handle *handle, const u32 *indir,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e2fc443..79e0a9b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -859,11 +859,9 @@ static u32 hns3_get_rss_key_size(struct net_device *netdev)
 static u32 hns3_get_rss_indir_size(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 
-	if (!h->ae_algo->ops->get_rss_indir_size)
-		return 0;
-
-	return h->ae_algo->ops->get_rss_indir_size(h);
+	return ae_dev->dev_specs.rss_ind_tbl_size;
 }
 
 static int hns3_get_rss(struct net_device *netdev, u32 *indir, u8 *key,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 16ccb1a..4b89f36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4237,11 +4237,6 @@ static u32 hclge_get_rss_key_size(struct hnae3_handle *handle)
 	return HCLGE_RSS_KEY_SIZE;
 }
 
-static u32 hclge_get_rss_indir_size(struct hnae3_handle *handle)
-{
-	return HCLGE_RSS_IND_TBL_SIZE;
-}
-
 static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
 				  const u8 hfunc, const u8 *key)
 {
@@ -4283,6 +4278,7 @@ static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
 {
 	struct hclge_rss_indirection_table_cmd *req;
 	struct hclge_desc desc;
+	int rss_cfg_tbl_num;
 	u8 rss_msb_oft;
 	u8 rss_msb_val;
 	int ret;
@@ -4291,8 +4287,10 @@ static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
 	u32 j;
 
 	req = (struct hclge_rss_indirection_table_cmd *)desc.data;
+	rss_cfg_tbl_num = hdev->ae_dev->dev_specs.rss_ind_tbl_size /
+			  HCLGE_RSS_CFG_TBL_SIZE;
 
-	for (i = 0; i < HCLGE_RSS_CFG_TBL_NUM; i++) {
+	for (i = 0; i < rss_cfg_tbl_num; i++) {
 		hclge_cmd_setup_basic_desc
 			(&desc, HCLGE_OPC_RSS_INDIR_TABLE, false);
 
@@ -4398,6 +4396,7 @@ static int hclge_set_rss_input_tuple(struct hclge_dev *hdev)
 static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 			 u8 *key, u8 *hfunc)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	int i;
 
@@ -4422,7 +4421,7 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 
 	/* Get indirect table */
 	if (indir)
-		for (i = 0; i < HCLGE_RSS_IND_TBL_SIZE; i++)
+		for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
 			indir[i] =  vport->rss_indirection_tbl[i];
 
 	return 0;
@@ -4431,6 +4430,7 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			 const  u8 *key, const  u8 hfunc)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	u8 hash_algo;
@@ -4462,7 +4462,7 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	}
 
 	/* Update the shadow RSS table with user specified qids */
-	for (i = 0; i < HCLGE_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
 		vport->rss_indirection_tbl[i] = indir[i];
 
 	/* Update the hardware */
@@ -4703,14 +4703,15 @@ void hclge_rss_indir_init_cfg(struct hclge_dev *hdev)
 	int i, j;
 
 	for (j = 0; j < hdev->num_vmdq_vport + 1; j++) {
-		for (i = 0; i < HCLGE_RSS_IND_TBL_SIZE; i++)
+		for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 			vport[j].rss_indirection_tbl[i] =
 				i % vport[j].alloc_rss_size;
 	}
 }
 
-static void hclge_rss_init_cfg(struct hclge_dev *hdev)
+static int hclge_rss_init_cfg(struct hclge_dev *hdev)
 {
+	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
 	int i, rss_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
 	struct hclge_vport *vport = hdev->vport;
 
@@ -4718,6 +4719,8 @@ static void hclge_rss_init_cfg(struct hclge_dev *hdev)
 		rss_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
 
 	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
+		u16 *rss_ind_tbl;
+
 		vport[i].rss_tuple_sets.ipv4_tcp_en =
 			HCLGE_RSS_INPUT_TUPLE_OTHER;
 		vport[i].rss_tuple_sets.ipv4_udp_en =
@@ -4739,11 +4742,19 @@ static void hclge_rss_init_cfg(struct hclge_dev *hdev)
 
 		vport[i].rss_algo = rss_algo;
 
+		rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
+					   sizeof(*rss_ind_tbl), GFP_KERNEL);
+		if (!rss_ind_tbl)
+			return -ENOMEM;
+
+		vport[i].rss_indirection_tbl = rss_ind_tbl;
 		memcpy(vport[i].rss_hash_key, hclge_hash_key,
 		       HCLGE_RSS_KEY_SIZE);
 	}
 
 	hclge_rss_indir_init_cfg(hdev);
+
+	return 0;
 }
 
 int hclge_bind_ring_with_vector(struct hclge_vport *vport,
@@ -10581,7 +10592,12 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_mdiobus_unreg;
 	}
 
-	hclge_rss_init_cfg(hdev);
+	ret = hclge_rss_init_cfg(hdev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to init rss cfg, ret = %d\n", ret);
+		goto err_mdiobus_unreg;
+	}
+
 	ret = hclge_rss_init_hw(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Rss init fail, ret =%d\n", ret);
@@ -11072,6 +11088,7 @@ static void hclge_get_tqps_and_rss_info(struct hnae3_handle *handle,
 static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 			      bool rxfh_configured)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
@@ -11115,11 +11132,12 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 		goto out;
 
 	/* Reinitializes the rss indirect table according to the new RSS size */
-	rss_indir = kcalloc(HCLGE_RSS_IND_TBL_SIZE, sizeof(u32), GFP_KERNEL);
+	rss_indir = kcalloc(ae_dev->dev_specs.rss_ind_tbl_size, sizeof(u32),
+			    GFP_KERNEL);
 	if (!rss_indir)
 		return -ENOMEM;
 
-	for (i = 0; i < HCLGE_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
 		rss_indir[i] = i % kinfo->rss_size;
 
 	ret = hclge_set_rss(handle, rss_indir, NULL, 0);
@@ -11799,7 +11817,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_fec = hclge_get_fec,
 	.set_fec = hclge_set_fec,
 	.get_rss_key_size = hclge_get_rss_key_size,
-	.get_rss_indir_size = hclge_get_rss_indir_size,
 	.get_rss = hclge_get_rss,
 	.set_rss = hclge_set_rss,
 	.set_rss_tuple = hclge_set_rss_tuple,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 32e5f82..a9c67e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -97,8 +97,6 @@
 #define HCLGE_RSS_HASH_ALGO_SIMPLE	1
 #define HCLGE_RSS_HASH_ALGO_SYMMETRIC	2
 #define HCLGE_RSS_HASH_ALGO_MASK	GENMASK(3, 0)
-#define HCLGE_RSS_CFG_TBL_NUM \
-	(HCLGE_RSS_IND_TBL_SIZE / HCLGE_RSS_CFG_TBL_SIZE)
 
 #define HCLGE_RSS_INPUT_TUPLE_OTHER	GENMASK(3, 0)
 #define HCLGE_RSS_INPUT_TUPLE_SCTP	GENMASK(4, 0)
@@ -922,7 +920,7 @@ struct hclge_vport {
 
 	u8  rss_hash_key[HCLGE_RSS_KEY_SIZE]; /* User configured hash keys */
 	/* User configured lookup table entries */
-	u16 rss_indirection_tbl[HCLGE_RSS_IND_TBL_SIZE];
+	u16 *rss_indirection_tbl;
 	int rss_algo;		/* User configured hash algorithm */
 	/* User configured rss tuple sets */
 	struct hclge_rss_tuple_cfg rss_tuple_sets;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 674b3a2..1bc86be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -642,22 +642,20 @@ static u32 hclgevf_get_rss_key_size(struct hnae3_handle *handle)
 	return HCLGEVF_RSS_KEY_SIZE;
 }
 
-static u32 hclgevf_get_rss_indir_size(struct hnae3_handle *handle)
-{
-	return HCLGEVF_RSS_IND_TBL_SIZE;
-}
-
 static int hclgevf_set_rss_indir_table(struct hclgevf_dev *hdev)
 {
 	const u8 *indir = hdev->rss_cfg.rss_indirection_tbl;
 	struct hclgevf_rss_indirection_table_cmd *req;
 	struct hclgevf_desc desc;
+	int rss_cfg_tbl_num;
 	int status;
 	int i, j;
 
 	req = (struct hclgevf_rss_indirection_table_cmd *)desc.data;
+	rss_cfg_tbl_num = hdev->ae_dev->dev_specs.rss_ind_tbl_size /
+			  HCLGEVF_RSS_CFG_TBL_SIZE;
 
-	for (i = 0; i < HCLGEVF_RSS_CFG_TBL_NUM; i++) {
+	for (i = 0; i < rss_cfg_tbl_num; i++) {
 		hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_INDIR_TABLE,
 					     false);
 		req->start_table_index = i * HCLGEVF_RSS_CFG_TBL_SIZE;
@@ -795,7 +793,7 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 	}
 
 	if (indir)
-		for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+		for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 			indir[i] = rss_cfg->rss_indirection_tbl[i];
 
 	return 0;
@@ -838,7 +836,7 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	}
 
 	/* update the shadow RSS table with user specified qids */
-	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 		rss_cfg->rss_indirection_tbl[i] = indir[i];
 
 	/* update the hardware */
@@ -2482,8 +2480,9 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev, bool en)
 	return ret;
 }
 
-static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
+static int hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 {
+	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	struct hclgevf_rss_tuple_cfg *tuple_sets;
 	u32 i;
@@ -2492,7 +2491,16 @@ static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 	rss_cfg->rss_size = hdev->nic.kinfo.rss_size;
 	tuple_sets = &rss_cfg->rss_tuple_sets;
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		u8 *rss_ind_tbl;
+
 		rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
+
+		rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
+					   sizeof(*rss_ind_tbl), GFP_KERNEL);
+		if (!rss_ind_tbl)
+			return -ENOMEM;
+
+		rss_cfg->rss_indirection_tbl = rss_ind_tbl;
 		memcpy(rss_cfg->rss_hash_key, hclgevf_hash_key,
 		       HCLGEVF_RSS_KEY_SIZE);
 
@@ -2510,8 +2518,10 @@ static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 	}
 
 	/* Initialize RSS indirect table */
-	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < rss_ind_tbl_size; i++)
 		rss_cfg->rss_indirection_tbl[i] = i % rss_cfg->rss_size;
+
+	return 0;
 }
 
 static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
@@ -3266,7 +3276,12 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 
 	/* Initialize RSS for this VF */
-	hclgevf_rss_init_cfg(hdev);
+	ret = hclgevf_rss_init_cfg(hdev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to init rss cfg, ret = %d\n", ret);
+		goto err_config;
+	}
+
 	ret = hclgevf_rss_init_hw(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
@@ -3444,11 +3459,12 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 		goto out;
 
 	/* Reinitializes the rss indirect table according to the new RSS size */
-	rss_indir = kcalloc(HCLGEVF_RSS_IND_TBL_SIZE, sizeof(u32), GFP_KERNEL);
+	rss_indir = kcalloc(hdev->ae_dev->dev_specs.rss_ind_tbl_size,
+			    sizeof(u32), GFP_KERNEL);
 	if (!rss_indir)
 		return -ENOMEM;
 
-	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 		rss_indir[i] = i % kinfo->rss_size;
 
 	hdev->rss_cfg.rss_size = kinfo->rss_size;
@@ -3687,7 +3703,6 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.get_strings = hclgevf_get_strings,
 	.get_sset_count = hclgevf_get_sset_count,
 	.get_rss_key_size = hclgevf_get_rss_key_size,
-	.get_rss_indir_size = hclgevf_get_rss_indir_size,
 	.get_rss = hclgevf_get_rss,
 	.set_rss = hclgevf_set_rss,
 	.get_rss_tuple = hclgevf_get_rss_tuple,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index f6d817a..6147bd7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -113,8 +113,7 @@
 #define HCLGEVF_RSS_HASH_ALGO_SIMPLE	1
 #define HCLGEVF_RSS_HASH_ALGO_SYMMETRIC	2
 #define HCLGEVF_RSS_HASH_ALGO_MASK	0xf
-#define HCLGEVF_RSS_CFG_TBL_NUM \
-	(HCLGEVF_RSS_IND_TBL_SIZE / HCLGEVF_RSS_CFG_TBL_SIZE)
+
 #define HCLGEVF_RSS_INPUT_TUPLE_OTHER	GENMASK(3, 0)
 #define HCLGEVF_RSS_INPUT_TUPLE_SCTP	GENMASK(4, 0)
 #define HCLGEVF_D_PORT_BIT		BIT(0)
@@ -217,7 +216,8 @@ struct hclgevf_rss_cfg {
 	u32 hash_algo;
 	u32 rss_size;
 	u8 hw_tc_map;
-	u8  rss_indirection_tbl[HCLGEVF_RSS_IND_TBL_SIZE]; /* shadow table */
+	/* shadow table */
+	u8 *rss_indirection_tbl;
 	struct hclgevf_rss_tuple_cfg rss_tuple_sets;
 };
 
-- 
2.7.4

