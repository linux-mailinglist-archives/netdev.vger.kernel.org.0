Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC56430BE6A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhBBMlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:41:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12107 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhBBMlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:41:17 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVPWk3GCMz162dt;
        Tue,  2 Feb 2021 20:39:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 20:40:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/7] net: hns3: RSS indirection table and key use device specifications
Date:   Tue, 2 Feb 2021 20:39:48 +0800
Message-ID: <1612269593-18691-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

As RSS indirection table size and RSS key size may be different in
different hardware. Instead of using macro, their values are better
to use device specifications which querying from firmware.

The arrays of RSS indirection table and RSS key are defined to the
max specification of all hardwares, so they can be used in each
device.

.get_rss_key_size and .get_rss_indir_size in struct hnae3_ae_ops
are not used now, so remove them as well.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  6 ---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 12 ++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 41 ++++++++++----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 10 ++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 44 +++++++++-------------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  | 11 ++++--
 6 files changed, 53 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index fe09cf6..f4c8d72 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -408,10 +408,6 @@ struct hnae3_ae_dev {
  *   Get regs dump
  * get_regs_len()
  *   Get the len of the regs dump
- * get_rss_key_size()
- *   Get rss key size
- * get_rss_indir_size()
- *   Get rss indirection table size
  * get_rss()
  *   Get rss table
  * set_rss()
@@ -554,8 +550,6 @@ struct hnae3_ae_ops {
 			 void *data);
 	int (*get_regs_len)(struct hnae3_handle *handle);
 
-	u32 (*get_rss_key_size)(struct hnae3_handle *handle);
-	u32 (*get_rss_indir_size)(struct hnae3_handle *handle);
 	int (*get_rss)(struct hnae3_handle *handle, u32 *indir, u8 *key,
 		       u8 *hfunc);
 	int (*set_rss)(struct hnae3_handle *handle, const u32 *indir,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e2fc443..c4b308e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -849,21 +849,17 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 static u32 hns3_get_rss_key_size(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 
-	if (!h->ae_algo->ops->get_rss_key_size)
-		return 0;
-
-	return h->ae_algo->ops->get_rss_key_size(h);
+	return ae_dev->dev_specs.rss_key_size;
 }
 
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
index 16ccb1a..a8aa388 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4232,16 +4232,6 @@ static int hclge_put_vector(struct hnae3_handle *handle, int vector)
 	return 0;
 }
 
-static u32 hclge_get_rss_key_size(struct hnae3_handle *handle)
-{
-	return HCLGE_RSS_KEY_SIZE;
-}
-
-static u32 hclge_get_rss_indir_size(struct hnae3_handle *handle)
-{
-	return HCLGE_RSS_IND_TBL_SIZE;
-}
-
 static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
 				  const u8 hfunc, const u8 *key)
 {
@@ -4252,7 +4242,7 @@ static int hclge_set_rss_algo_key(struct hclge_dev *hdev,
 	int key_size;
 	int ret;
 
-	key_counts = HCLGE_RSS_KEY_SIZE;
+	key_counts = hdev->ae_dev->dev_specs.rss_key_size;
 	req = (struct hclge_rss_config_cmd *)desc.data;
 
 	while (key_counts) {
@@ -4283,6 +4273,7 @@ static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
 {
 	struct hclge_rss_indirection_table_cmd *req;
 	struct hclge_desc desc;
+	int rss_cfg_tbl_num;
 	u8 rss_msb_oft;
 	u8 rss_msb_val;
 	int ret;
@@ -4291,8 +4282,10 @@ static int hclge_set_rss_indir_table(struct hclge_dev *hdev, const u16 *indir)
 	u32 j;
 
 	req = (struct hclge_rss_indirection_table_cmd *)desc.data;
+	rss_cfg_tbl_num = hdev->ae_dev->dev_specs.rss_ind_tbl_size /
+			  HCLGE_RSS_CFG_TBL_SIZE;
 
-	for (i = 0; i < HCLGE_RSS_CFG_TBL_NUM; i++) {
+	for (i = 0; i < rss_cfg_tbl_num; i++) {
 		hclge_cmd_setup_basic_desc
 			(&desc, HCLGE_OPC_RSS_INDIR_TABLE, false);
 
@@ -4398,6 +4391,7 @@ static int hclge_set_rss_input_tuple(struct hclge_dev *hdev)
 static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 			 u8 *key, u8 *hfunc)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	int i;
 
@@ -4418,11 +4412,12 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 
 	/* Get the RSS Key required by the user */
 	if (key)
-		memcpy(key, vport->rss_hash_key, HCLGE_RSS_KEY_SIZE);
+		memcpy(key, vport->rss_hash_key,
+		       ae_dev->dev_specs.rss_key_size);
 
 	/* Get indirect table */
 	if (indir)
-		for (i = 0; i < HCLGE_RSS_IND_TBL_SIZE; i++)
+		for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
 			indir[i] =  vport->rss_indirection_tbl[i];
 
 	return 0;
@@ -4431,6 +4426,7 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			 const  u8 *key, const  u8 hfunc)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	u8 hash_algo;
@@ -4457,12 +4453,13 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			return ret;
 
 		/* Update the shadow RSS key with user specified qids */
-		memcpy(vport->rss_hash_key, key, HCLGE_RSS_KEY_SIZE);
+		memcpy(vport->rss_hash_key, key,
+		       ae_dev->dev_specs.rss_key_size);
 		vport->rss_algo = hash_algo;
 	}
 
 	/* Update the shadow RSS table with user specified qids */
-	for (i = 0; i < HCLGE_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
 		vport->rss_indirection_tbl[i] = indir[i];
 
 	/* Update the hardware */
@@ -4703,7 +4700,7 @@ void hclge_rss_indir_init_cfg(struct hclge_dev *hdev)
 	int i, j;
 
 	for (j = 0; j < hdev->num_vmdq_vport + 1; j++) {
-		for (i = 0; i < HCLGE_RSS_IND_TBL_SIZE; i++)
+		for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 			vport[j].rss_indirection_tbl[i] =
 				i % vport[j].alloc_rss_size;
 	}
@@ -4740,7 +4737,7 @@ static void hclge_rss_init_cfg(struct hclge_dev *hdev)
 		vport[i].rss_algo = rss_algo;
 
 		memcpy(vport[i].rss_hash_key, hclge_hash_key,
-		       HCLGE_RSS_KEY_SIZE);
+		       hdev->ae_dev->dev_specs.rss_key_size);
 	}
 
 	hclge_rss_indir_init_cfg(hdev);
@@ -11072,6 +11069,7 @@ static void hclge_get_tqps_and_rss_info(struct hnae3_handle *handle,
 static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
 			      bool rxfh_configured)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
 	u16 tc_offset[HCLGE_MAX_TC_NUM] = {0};
@@ -11115,11 +11113,12 @@ static int hclge_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
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
@@ -11798,8 +11797,6 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.check_port_speed = hclge_check_port_speed,
 	.get_fec = hclge_get_fec,
 	.set_fec = hclge_set_fec,
-	.get_rss_key_size = hclge_get_rss_key_size,
-	.get_rss_indir_size = hclge_get_rss_indir_size,
 	.get_rss = hclge_get_rss,
 	.set_rss = hclge_set_rss,
 	.set_rss_tuple = hclge_set_rss_tuple,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 32e5f82..2bb1dd4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -90,15 +90,15 @@
 #define HCLGE_TQP_INTR_GL2_REG		0x20300
 #define HCLGE_TQP_INTR_RL_REG		0x20900
 
+#define HCLGE_RSS_IND_TBL_SIZE_MAX	512
 #define HCLGE_RSS_IND_TBL_SIZE		512
 #define HCLGE_RSS_SET_BITMAP_MSK	GENMASK(15, 0)
+#define HCLGE_RSS_KEY_SIZE_MAX		40
 #define HCLGE_RSS_KEY_SIZE		40
 #define HCLGE_RSS_HASH_ALGO_TOEPLITZ	0
 #define HCLGE_RSS_HASH_ALGO_SIMPLE	1
 #define HCLGE_RSS_HASH_ALGO_SYMMETRIC	2
 #define HCLGE_RSS_HASH_ALGO_MASK	GENMASK(3, 0)
-#define HCLGE_RSS_CFG_TBL_NUM \
-	(HCLGE_RSS_IND_TBL_SIZE / HCLGE_RSS_CFG_TBL_SIZE)
 
 #define HCLGE_RSS_INPUT_TUPLE_OTHER	GENMASK(3, 0)
 #define HCLGE_RSS_INPUT_TUPLE_SCTP	GENMASK(4, 0)
@@ -919,10 +919,10 @@ struct hclge_vf_info {
 
 struct hclge_vport {
 	u16 alloc_tqps;	/* Allocated Tx/Rx queues */
-
-	u8  rss_hash_key[HCLGE_RSS_KEY_SIZE]; /* User configured hash keys */
+	/* User configured hash keys */
+	u8  rss_hash_key[HCLGE_RSS_KEY_SIZE_MAX];
 	/* User configured lookup table entries */
-	u16 rss_indirection_tbl[HCLGE_RSS_IND_TBL_SIZE];
+	u16  rss_indirection_tbl[HCLGE_RSS_IND_TBL_SIZE_MAX];
 	int rss_algo;		/* User configured hash algorithm */
 	/* User configured rss tuple sets */
 	struct hclge_rss_tuple_cfg rss_tuple_sets;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 674b3a2..2578d9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -607,7 +607,7 @@ static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
 	int key_size;
 	int ret;
 
-	key_counts = HCLGEVF_RSS_KEY_SIZE;
+	key_counts = hdev->ae_dev->dev_specs.rss_key_size;
 	req = (struct hclgevf_rss_config_cmd *)desc.data;
 
 	while (key_counts) {
@@ -637,27 +637,20 @@ static int hclgevf_set_rss_algo_key(struct hclgevf_dev *hdev,
 	return 0;
 }
 
-static u32 hclgevf_get_rss_key_size(struct hnae3_handle *handle)
-{
-	return HCLGEVF_RSS_KEY_SIZE;
-}
-
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
@@ -721,6 +714,7 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 {
 #define HCLGEVF_RSS_MBX_RESP_LEN	8
+	u16 rss_key_size = hdev->ae_dev->dev_specs.rss_key_size;
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 resp_msg[HCLGEVF_RSS_MBX_RESP_LEN];
 	struct hclge_vf_to_pf_msg send_msg;
@@ -729,7 +723,7 @@ static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 	int ret;
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_GET_RSS_KEY, 0);
-	msg_num = (HCLGEVF_RSS_KEY_SIZE + HCLGEVF_RSS_MBX_RESP_LEN - 1) /
+	msg_num = (rss_key_size + HCLGEVF_RSS_MBX_RESP_LEN - 1) /
 			HCLGEVF_RSS_MBX_RESP_LEN;
 	for (index = 0; index < msg_num; index++) {
 		send_msg.data[0] = index;
@@ -745,8 +739,7 @@ static int hclgevf_get_rss_hash_key(struct hclgevf_dev *hdev)
 		hash_key_index = HCLGEVF_RSS_MBX_RESP_LEN * index;
 		if (index == msg_num - 1)
 			memcpy(&rss_cfg->rss_hash_key[hash_key_index],
-			       &resp_msg[0],
-			       HCLGEVF_RSS_KEY_SIZE - hash_key_index);
+			       &resp_msg[0], rss_key_size - hash_key_index);
 		else
 			memcpy(&rss_cfg->rss_hash_key[hash_key_index],
 			       &resp_msg[0], HCLGEVF_RSS_MBX_RESP_LEN);
@@ -781,7 +774,7 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 		/* Get the RSS Key required by the user */
 		if (key)
 			memcpy(key, rss_cfg->rss_hash_key,
-			       HCLGEVF_RSS_KEY_SIZE);
+			       hdev->ae_dev->dev_specs.rss_key_size);
 	} else {
 		if (hfunc)
 			*hfunc = ETH_RSS_HASH_TOP;
@@ -790,12 +783,12 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 			if (ret)
 				return ret;
 			memcpy(key, rss_cfg->rss_hash_key,
-			       HCLGEVF_RSS_KEY_SIZE);
+			       hdev->ae_dev->dev_specs.rss_key_size);
 		}
 	}
 
 	if (indir)
-		for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+		for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 			indir[i] = rss_cfg->rss_indirection_tbl[i];
 
 	return 0;
@@ -833,12 +826,12 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 
 			/* Update the shadow RSS key with user specified qids */
 			memcpy(rss_cfg->rss_hash_key, key,
-			       HCLGEVF_RSS_KEY_SIZE);
+			       hdev->ae_dev->dev_specs.rss_key_size);
 		}
 	}
 
 	/* update the shadow RSS table with user specified qids */
-	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 		rss_cfg->rss_indirection_tbl[i] = indir[i];
 
 	/* update the hardware */
@@ -2494,7 +2487,7 @@ static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
 		memcpy(rss_cfg->rss_hash_key, hclgevf_hash_key,
-		       HCLGEVF_RSS_KEY_SIZE);
+		       hdev->ae_dev->dev_specs.rss_key_size);
 
 		tuple_sets->ipv4_tcp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
 		tuple_sets->ipv4_udp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
@@ -2510,7 +2503,7 @@ static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 	}
 
 	/* Initialize RSS indirect table */
-	for (i = 0; i < HCLGEVF_RSS_IND_TBL_SIZE; i++)
+	for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
 		rss_cfg->rss_indirection_tbl[i] = i % rss_cfg->rss_size;
 }
 
@@ -3444,11 +3437,12 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
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
@@ -3686,8 +3680,6 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.update_stats = hclgevf_update_stats,
 	.get_strings = hclgevf_get_strings,
 	.get_sset_count = hclgevf_get_sset_count,
-	.get_rss_key_size = hclgevf_get_rss_key_size,
-	.get_rss_indir_size = hclgevf_get_rss_indir_size,
 	.get_rss = hclgevf_get_rss,
 	.set_rss = hclgevf_set_rss,
 	.get_rss_tuple = hclgevf_get_rss_tuple,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index f6d817a..004e30d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -106,15 +106,16 @@
 #define HCLGEVF_VF_RST_ING		0x07008
 #define HCLGEVF_VF_RST_ING_BIT		BIT(16)
 
+#define HCLGEVF_RSS_IND_TBL_SIZE_MAX		512
 #define HCLGEVF_RSS_IND_TBL_SIZE		512
 #define HCLGEVF_RSS_SET_BITMAP_MSK	0xffff
+#define HCLGEVF_RSS_KEY_SIZE_MAX	40
 #define HCLGEVF_RSS_KEY_SIZE		40
 #define HCLGEVF_RSS_HASH_ALGO_TOEPLITZ	0
 #define HCLGEVF_RSS_HASH_ALGO_SIMPLE	1
 #define HCLGEVF_RSS_HASH_ALGO_SYMMETRIC	2
 #define HCLGEVF_RSS_HASH_ALGO_MASK	0xf
-#define HCLGEVF_RSS_CFG_TBL_NUM \
-	(HCLGEVF_RSS_IND_TBL_SIZE / HCLGEVF_RSS_CFG_TBL_SIZE)
+
 #define HCLGEVF_RSS_INPUT_TUPLE_OTHER	GENMASK(3, 0)
 #define HCLGEVF_RSS_INPUT_TUPLE_SCTP	GENMASK(4, 0)
 #define HCLGEVF_D_PORT_BIT		BIT(0)
@@ -213,11 +214,13 @@ struct hclgevf_rss_tuple_cfg {
 };
 
 struct hclgevf_rss_cfg {
-	u8  rss_hash_key[HCLGEVF_RSS_KEY_SIZE]; /* user configured hash keys */
+	/* user configured hash keys */
+	u8  rss_hash_key[HCLGEVF_RSS_KEY_SIZE_MAX];
 	u32 hash_algo;
 	u32 rss_size;
 	u8 hw_tc_map;
-	u8  rss_indirection_tbl[HCLGEVF_RSS_IND_TBL_SIZE]; /* shadow table */
+	/* shadow table */
+	u8  rss_indirection_tbl[HCLGEVF_RSS_IND_TBL_SIZE_MAX];
 	struct hclgevf_rss_tuple_cfg rss_tuple_sets;
 };
 
-- 
2.7.4

