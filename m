Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2AC668965
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 03:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbjAMCIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 21:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjAMCIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 21:08:51 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF54A5472A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:08:48 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NtPtY4YqgzRrJv;
        Fri, 13 Jan 2023 10:07:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 13 Jan 2023 10:08:46 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <wangjie125@huawei.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
Date:   Fri, 13 Jan 2023 10:08:29 +0800
Message-ID: <20230113020829.48451-3-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230113020829.48451-1-lanhao@huawei.com>
References: <20230113020829.48451-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently hns3 driver supports vf fault detect feature. Several ras caused
by VF resources don't need to do PF function reset for recovery. The driver
only needs to reset the specified VF.

So this patch adds process in ras module. New process will get detailed
information about ras and do the most correct measures based on these
accurate information.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
 .../hisilicon/hns3/hns3pf/hclge_err.c         | 113 +++++++++++++++++-
 .../hisilicon/hns3/hns3pf/hclge_err.h         |   2 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   1 +
 6 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index cd85c360335d..76a6230ccfee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -265,6 +265,7 @@ enum hnae3_reset_type {
 	HNAE3_GLOBAL_RESET,
 	HNAE3_IMP_RESET,
 	HNAE3_NONE_RESET,
+	HNAE3_VF_EXP_RESET,
 	HNAE3_MAX_RESET,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index ca3692dc2848..8f823cdc0543 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -92,6 +92,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_DFX_SSU_REG_2		= 0x004F,
 
 	HCLGE_OPC_QUERY_DEV_SPECS	= 0x0050,
+	HCLGE_OPC_GET_QUEUE_ERR_VF      = 0x0067,
 
 	/* MAC command */
 	HCLGE_OPC_CONFIG_MAC_MODE	= 0x0301,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 6efd768cc07c..cf8f3882304a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1299,10 +1299,12 @@ static const struct hclge_hw_type_id hclge_hw_type_id_st[] = {
 		.msg = "tqp_int_ecc_error"
 	}, {
 		.type_id = PF_ABNORMAL_INT_ERROR,
-		.msg = "pf_abnormal_int_error"
+		.msg = "pf_abnormal_int_error",
+		.cause_by_vf = true
 	}, {
 		.type_id = MPF_ABNORMAL_INT_ERROR,
-		.msg = "mpf_abnormal_int_error"
+		.msg = "mpf_abnormal_int_error",
+		.cause_by_vf = true
 	}, {
 		.type_id = COMMON_ERROR,
 		.msg = "common_error"
@@ -2757,7 +2759,7 @@ void hclge_handle_occurred_error(struct hclge_dev *hdev)
 		hclge_handle_error_info_log(ae_dev);
 }
 
-static void
+static bool
 hclge_handle_error_type_reg_log(struct device *dev,
 				struct hclge_mod_err_info *mod_info,
 				struct hclge_type_reg_err_info *type_reg_info)
@@ -2768,6 +2770,7 @@ hclge_handle_error_type_reg_log(struct device *dev,
 	u8 mod_id, total_module, type_id, total_type, i, is_ras;
 	u8 index_module = MODULE_NONE;
 	u8 index_type = NONE_ERROR;
+	bool cause_by_vf = false;
 
 	mod_id = mod_info->mod_id;
 	type_id = type_reg_info->type_id & HCLGE_ERR_TYPE_MASK;
@@ -2786,6 +2789,7 @@ hclge_handle_error_type_reg_log(struct device *dev,
 	for (i = 0; i < total_type; i++) {
 		if (type_id == hclge_hw_type_id_st[i].type_id) {
 			index_type = i;
+			cause_by_vf = hclge_hw_type_id_st[i].cause_by_vf;
 			break;
 		}
 	}
@@ -2803,6 +2807,8 @@ hclge_handle_error_type_reg_log(struct device *dev,
 	dev_err(dev, "reg_value:\n");
 	for (i = 0; i < type_reg_info->reg_num; i++)
 		dev_err(dev, "0x%08x\n", type_reg_info->hclge_reg[i]);
+
+	return cause_by_vf;
 }
 
 static void hclge_handle_error_module_log(struct hnae3_ae_dev *ae_dev,
@@ -2813,6 +2819,7 @@ static void hclge_handle_error_module_log(struct hnae3_ae_dev *ae_dev,
 	struct device *dev = &hdev->pdev->dev;
 	struct hclge_mod_err_info *mod_info;
 	struct hclge_sum_err_info *sum_info;
+	bool cause_by_vf = false;
 	u8 mod_num, err_num, i;
 	u32 offset = 0;
 
@@ -2841,12 +2848,16 @@ static void hclge_handle_error_module_log(struct hnae3_ae_dev *ae_dev,
 
 			type_reg_info = (struct hclge_type_reg_err_info *)
 					    &buf[offset++];
-			hclge_handle_error_type_reg_log(dev, mod_info,
-							type_reg_info);
+			if (hclge_handle_error_type_reg_log(dev, mod_info,
+							    type_reg_info))
+				cause_by_vf = true;
 
 			offset += type_reg_info->reg_num;
 		}
 	}
+
+	if (hnae3_ae_dev_vf_fault_supported(hdev->ae_dev) && cause_by_vf)
+		set_bit(HNAE3_VF_EXP_RESET, &ae_dev->hw_err_reset_req);
 }
 
 static int hclge_query_all_err_bd_num(struct hclge_dev *hdev, u32 *bd_num)
@@ -2938,3 +2949,95 @@ int hclge_handle_error_info_log(struct hnae3_ae_dev *ae_dev)
 out:
 	return ret;
 }
+
+static bool hclge_reset_vf_in_bitmap(struct hclge_dev *hdev,
+				     unsigned long *bitmap)
+{
+	struct hclge_vport *vport;
+	bool exist_set = false;
+	int func_id;
+	int ret;
+
+	func_id = find_first_bit(bitmap, HCLGE_VPORT_NUM);
+	if (func_id == PF_VPORT_ID)
+		return false;
+
+	while (func_id != HCLGE_VPORT_NUM) {
+		vport = hclge_get_vf_vport(hdev,
+					   func_id - HCLGE_VF_VPORT_START_NUM);
+		if (!vport) {
+			dev_err(&hdev->pdev->dev, "invalid func id(%d)\n",
+				func_id);
+			return false;
+		}
+
+		dev_info(&hdev->pdev->dev, "do function %d recovery.", func_id);
+
+		ret = hclge_reset_tqp(&vport->nic);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to reset tqp, ret = %d.", ret);
+			return false;
+		}
+
+		ret = hclge_func_reset_cmd(hdev, func_id);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to reset func %d, ret = %d.",
+				func_id, ret);
+			return false;
+		}
+
+		exist_set = true;
+		clear_bit(func_id, bitmap);
+		func_id = find_first_bit(bitmap, HCLGE_VPORT_NUM);
+	}
+
+	return exist_set;
+}
+
+static void hclge_get_vf_fault_bitmap(struct hclge_desc *desc,
+				      unsigned long *bitmap)
+{
+#define HCLGE_FIR_FAULT_BYTES	24
+#define HCLGE_SEC_FAULT_BYTES	8
+
+	u8 *buff;
+
+	memcpy(bitmap, desc[0].data, HCLGE_FIR_FAULT_BYTES);
+	buff = (u8 *)bitmap + HCLGE_FIR_FAULT_BYTES;
+	memcpy(buff, desc[1].data, HCLGE_SEC_FAULT_BYTES);
+}
+
+int hclge_handle_vf_queue_err_ras(struct hclge_dev *hdev)
+{
+	unsigned long vf_fault_bitmap[BITS_TO_LONGS(HCLGE_VPORT_NUM)];
+	struct hclge_desc desc[2];
+	bool cause_by_vf = false;
+	int ret;
+
+	if (!hnae3_ae_dev_vf_fault_supported(hdev->ae_dev) ||
+	    !test_and_clear_bit(HNAE3_VF_EXP_RESET,
+				&hdev->ae_dev->hw_err_reset_req))
+		return 0;
+
+	hclge_comm_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_GET_QUEUE_ERR_VF,
+					true);
+	desc[0].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+	hclge_comm_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_GET_QUEUE_ERR_VF,
+					true);
+
+	ret = hclge_comm_cmd_send(&hdev->hw.hw, desc, 2);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get vf bitmap, ret = %d.\n", ret);
+		return ret;
+	}
+	hclge_get_vf_fault_bitmap(desc, vf_fault_bitmap);
+
+	cause_by_vf = hclge_reset_vf_in_bitmap(hdev, vf_fault_bitmap);
+	if (cause_by_vf)
+		hdev->ae_dev->hw_err_reset_req = 0;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index 86be6fb32990..68b738affa66 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -196,6 +196,7 @@ struct hclge_hw_module_id {
 struct hclge_hw_type_id {
 	enum hclge_err_type_list type_id;
 	const char *msg;
+	bool cause_by_vf; /* indicate the error may from vf exception */
 };
 
 struct hclge_sum_err_info {
@@ -228,4 +229,5 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 			       unsigned long *reset_requests);
 int hclge_handle_error_info_log(struct hnae3_ae_dev *ae_dev);
 int hclge_handle_mac_tnl(struct hclge_dev *hdev);
+int hclge_handle_vf_queue_err_ras(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 07ad5f35219e..a1f1f72db8a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3520,7 +3520,7 @@ static int hclge_get_status(struct hnae3_handle *handle)
 	return hdev->hw.mac.link;
 }
 
-static struct hclge_vport *hclge_get_vf_vport(struct hclge_dev *hdev, int vf)
+struct hclge_vport *hclge_get_vf_vport(struct hclge_dev *hdev, int vf)
 {
 	if (!pci_num_vf(hdev->pdev)) {
 		dev_err(&hdev->pdev->dev,
@@ -4559,6 +4559,7 @@ static void hclge_handle_err_recovery(struct hclge_dev *hdev)
 	if (hclge_find_error_source(hdev)) {
 		hclge_handle_error_info_log(ae_dev);
 		hclge_handle_mac_tnl(hdev);
+		hclge_handle_vf_queue_err_ras(hdev);
 	}
 
 	hclge_handle_err_reset_request(hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 13f23d606e77..73cfc26f5389 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1148,4 +1148,5 @@ int hclge_dbg_dump_rst_info(struct hclge_dev *hdev, char *buf, int len);
 int hclge_push_vf_link_status(struct hclge_vport *vport);
 int hclge_enable_vport_vlan_filter(struct hclge_vport *vport, bool request_en);
 int hclge_mac_update_stats(struct hclge_dev *hdev);
+struct hclge_vport *hclge_get_vf_vport(struct hclge_dev *hdev, int vf);
 #endif
-- 
2.30.0

