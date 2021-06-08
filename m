Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3263D39F75F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhFHNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:13:40 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5336 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhFHNNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:13:35 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FzrBX1FHbz6tsh;
        Tue,  8 Jun 2021 21:07:48 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: add the RAS compatibility adaptation solution
Date:   Tue, 8 Jun 2021 21:08:28 +0800
Message-ID: <1623157711-26846-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
References: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

To adapt to hardware modification and ensure that the driver is
compatible with the original error handling content, we need to add the
RAS compatibility adaptation solution.

Add a processing branch to the driver during error handling. In the new
processing branch, NIC fault information is integrated by the IMP. An
interaction command is added between the driver and IMP to query
and clear the fault source and interrupt source. The IMP integrates
error information and reports the highest reset level to the driver.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 320 +++++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  69 +++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  54 +++-
 5 files changed, 409 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 8f6ed8577aea..614763f5e877 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -178,7 +178,8 @@ static bool hclge_is_special_opcode(u16 opcode)
 			     HCLGE_QUERY_CLEAR_MPF_RAS_INT,
 			     HCLGE_QUERY_CLEAR_PF_RAS_INT,
 			     HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT,
-			     HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT};
+			     HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT,
+			     HCLGE_QUERY_ALL_ERR_INFO};
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(spec_opcode); i++) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index da78a6477e46..234f0a3beec1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -293,6 +293,8 @@ enum hclge_opcode_type {
 	HCLGE_QUERY_MSIX_INT_STS_BD_NUM	= 0x1513,
 	HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT	= 0x1514,
 	HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT	= 0x1515,
+	HCLGE_QUERY_ALL_ERR_BD_NUM		= 0x1516,
+	HCLGE_QUERY_ALL_ERR_INFO		= 0x1517,
 	HCLGE_CONFIG_ROCEE_RAS_INT_EN	= 0x1580,
 	HCLGE_QUERY_CLEAR_ROCEE_RAS_INT = 0x1581,
 	HCLGE_ROCEE_PF_RAS_INT_CMD	= 0x1584,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 540dd15d7771..36f8055bd859 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -631,6 +631,98 @@ static const struct hclge_hw_error hclge_rocee_qmm_ovf_err_int[] = {
 	{ /* sentinel */ }
 };
 
+static const struct hclge_hw_module_id hclge_hw_module_id_st[] = {
+	{
+		.module_id = MODULE_NONE,
+		.msg = "MODULE_NONE"
+	}, {
+		.module_id = MODULE_BIOS_COMMON,
+		.msg = "MODULE_BIOS_COMMON"
+	}, {
+		.module_id = MODULE_GE,
+		.msg = "MODULE_GE"
+	}, {
+		.module_id = MODULE_IGU_EGU,
+		.msg = "MODULE_IGU_EGU"
+	}, {
+		.module_id = MODULE_LGE,
+		.msg = "MODULE_LGE"
+	}, {
+		.module_id = MODULE_NCSI,
+		.msg = "MODULE_NCSI"
+	}, {
+		.module_id = MODULE_PPP,
+		.msg = "MODULE_PPP"
+	}, {
+		.module_id = MODULE_QCN,
+		.msg = "MODULE_QCN"
+	}, {
+		.module_id = MODULE_RCB_RX,
+		.msg = "MODULE_RCB_RX"
+	}, {
+		.module_id = MODULE_RTC,
+		.msg = "MODULE_RTC"
+	}, {
+		.module_id = MODULE_SSU,
+		.msg = "MODULE_SSU"
+	}, {
+		.module_id = MODULE_TM,
+		.msg = "MODULE_TM"
+	}, {
+		.module_id = MODULE_RCB_TX,
+		.msg = "MODULE_RCB_TX"
+	}, {
+		.module_id = MODULE_TXDMA,
+		.msg = "MODULE_TXDMA"
+	}, {
+		.module_id = MODULE_MASTER,
+		.msg = "MODULE_MASTER"
+	}
+};
+
+static const struct hclge_hw_type_id hclge_hw_type_id_st[] = {
+	{
+		.type_id = NONE_ERROR,
+		.msg = "none_error"
+	}, {
+		.type_id = FIFO_ERROR,
+		.msg = "fifo_error"
+	}, {
+		.type_id = MEMORY_ERROR,
+		.msg = "memory_error"
+	}, {
+		.type_id = POISON_ERROR,
+		.msg = "poison_error"
+	}, {
+		.type_id = MSIX_ECC_ERROR,
+		.msg = "msix_ecc_error"
+	}, {
+		.type_id = TQP_INT_ECC_ERROR,
+		.msg = "tqp_int_ecc_error"
+	}, {
+		.type_id = PF_ABNORMAL_INT_ERROR,
+		.msg = "pf_abnormal_int_error"
+	}, {
+		.type_id = MPF_ABNORMAL_INT_ERROR,
+		.msg = "mpf_abnormal_int_error"
+	}, {
+		.type_id = COMMON_ERROR,
+		.msg = "common_error"
+	}, {
+		.type_id = PORT_ERROR,
+		.msg = "port_error"
+	}, {
+		.type_id = ETS_ERROR,
+		.msg = "ets_error"
+	}, {
+		.type_id = NCSI_ERROR,
+		.msg = "ncsi_error"
+	}, {
+		.type_id = GLB_ERROR,
+		.msg = "glb_error"
+	}
+};
+
 static void hclge_log_error(struct device *dev, char *reg,
 			    const struct hclge_hw_error *err,
 			    u32 err_sts, unsigned long *reset_requests)
@@ -1892,11 +1984,8 @@ static int hclge_handle_pf_msix_error(struct hclge_dev *hdev,
 static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 					  unsigned long *reset_requests)
 {
-	struct hclge_mac_tnl_stats mac_tnl_stats;
-	struct device *dev = &hdev->pdev->dev;
 	u32 mpf_bd_num, pf_bd_num, bd_num;
 	struct hclge_desc *desc;
-	u32 status;
 	int ret;
 
 	/* query the number of bds for the MSIx int status */
@@ -1919,29 +2008,7 @@ static int hclge_handle_all_hw_msix_error(struct hclge_dev *hdev,
 	if (ret)
 		goto msi_error;
 
-	/* query and clear mac tnl interruptions */
-	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_QUERY_MAC_TNL_INT,
-				   true);
-	ret = hclge_cmd_send(&hdev->hw, &desc[0], 1);
-	if (ret) {
-		dev_err(dev, "query mac tnl int cmd failed (%d)\n", ret);
-		goto msi_error;
-	}
-
-	status = le32_to_cpu(desc->data[0]);
-	if (status) {
-		/* When mac tnl interrupt occurs, we record current time and
-		 * register status here in a fifo, then clear the status. So
-		 * that if link status changes suddenly at some time, we can
-		 * query them by debugfs.
-		 */
-		mac_tnl_stats.time = local_clock();
-		mac_tnl_stats.status = status;
-		kfifo_put(&hdev->mac_tnl_log, mac_tnl_stats);
-		ret = hclge_clear_mac_tnl_int(hdev);
-		if (ret)
-			dev_err(dev, "clear mac tnl int failed (%d)\n", ret);
-	}
+	ret = hclge_handle_mac_tnl(hdev);
 
 msi_error:
 	kfree(desc);
@@ -1963,10 +2030,43 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 	return hclge_handle_all_hw_msix_error(hdev, reset_requests);
 }
 
-void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
+int hclge_handle_mac_tnl(struct hclge_dev *hdev)
 {
-#define HCLGE_DESC_NO_DATA_LEN 8
+	struct hclge_mac_tnl_stats mac_tnl_stats;
+	struct device *dev = &hdev->pdev->dev;
+	struct hclge_desc desc;
+	u32 status;
+	int ret;
 
+	/* query and clear mac tnl interruptions */
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_MAC_TNL_INT, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(dev, "failed to query mac tnl int, ret = %d.\n", ret);
+		return ret;
+	}
+
+	status = le32_to_cpu(desc.data[0]);
+	if (status) {
+		/* When mac tnl interrupt occurs, we record current time and
+		 * register status here in a fifo, then clear the status. So
+		 * that if link status changes suddenly at some time, we can
+		 * query them by debugfs.
+		 */
+		mac_tnl_stats.time = local_clock();
+		mac_tnl_stats.status = status;
+		kfifo_put(&hdev->mac_tnl_log, mac_tnl_stats);
+		ret = hclge_clear_mac_tnl_int(hdev);
+		if (ret)
+			dev_err(dev, "failed to clear mac tnl int, ret = %d.\n",
+				ret);
+	}
+
+	return ret;
+}
+
+void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
+{
 	struct hclge_dev *hdev = ae_dev->priv;
 	struct device *dev = &hdev->pdev->dev;
 	u32 mpf_bd_num, pf_bd_num, bd_num;
@@ -2015,3 +2115,167 @@ void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev)
 msi_error:
 	kfree(desc);
 }
+
+static void
+hclge_handle_error_type_reg_log(struct device *dev,
+				struct hclge_mod_err_info *mod_info,
+				struct hclge_type_reg_err_info *type_reg_info)
+{
+#define HCLGE_ERR_TYPE_MASK 0x7F
+#define HCLGE_ERR_TYPE_IS_RAS_OFFSET 7
+
+	u8 mod_id, total_module, type_id, total_type, i, is_ras;
+
+	mod_id = mod_info->mod_id;
+	type_id = type_reg_info->type_id & HCLGE_ERR_TYPE_MASK;
+	is_ras = type_reg_info->type_id >> HCLGE_ERR_TYPE_IS_RAS_OFFSET;
+
+	total_module = ARRAY_SIZE(hclge_hw_module_id_st);
+	total_type = ARRAY_SIZE(hclge_hw_type_id_st);
+
+	if (mod_id < total_module && type_id < total_type)
+		dev_err(dev,
+			"found %s %s, is %s error.\n",
+			hclge_hw_module_id_st[mod_id].msg,
+			hclge_hw_type_id_st[type_id].msg,
+			is_ras ? "ras" : "msix");
+	else
+		dev_err(dev,
+			"unknown module[%u] or type[%u].\n", mod_id, type_id);
+
+	dev_err(dev, "reg_value:\n");
+	for (i = 0; i < type_reg_info->reg_num; i++)
+		dev_err(dev, "0x%08x\n", type_reg_info->hclge_reg[i]);
+}
+
+static void hclge_handle_error_module_log(struct hnae3_ae_dev *ae_dev,
+					  const u32 *buf, u32 buf_size)
+{
+	struct hclge_type_reg_err_info *type_reg_info;
+	struct hclge_dev *hdev = ae_dev->priv;
+	struct device *dev = &hdev->pdev->dev;
+	struct hclge_mod_err_info *mod_info;
+	struct hclge_sum_err_info *sum_info;
+	u8 mod_num, err_num, i;
+	u32 offset = 0;
+
+	sum_info = (struct hclge_sum_err_info *)&buf[offset++];
+	if (sum_info->reset_type &&
+	    sum_info->reset_type != HNAE3_NONE_RESET)
+		set_bit(sum_info->reset_type, &ae_dev->hw_err_reset_req);
+	mod_num = sum_info->mod_num;
+
+	while (mod_num--) {
+		if (offset >= buf_size) {
+			dev_err(dev, "The offset(%u) exceeds buf's size(%u).\n",
+				offset, buf_size);
+			return;
+		}
+		mod_info = (struct hclge_mod_err_info *)&buf[offset++];
+		err_num = mod_info->err_num;
+
+		for (i = 0; i < err_num; i++) {
+			if (offset >= buf_size) {
+				dev_err(dev,
+					"The offset(%u) exceeds buf size(%u).\n",
+					offset, buf_size);
+				return;
+			}
+
+			type_reg_info = (struct hclge_type_reg_err_info *)
+					    &buf[offset++];
+			hclge_handle_error_type_reg_log(dev, mod_info,
+							type_reg_info);
+
+			offset += type_reg_info->reg_num;
+		}
+	}
+}
+
+static int hclge_query_all_err_bd_num(struct hclge_dev *hdev, u32 *bd_num)
+{
+	struct device *dev = &hdev->pdev->dev;
+	struct hclge_desc desc_bd;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc_bd, HCLGE_QUERY_ALL_ERR_BD_NUM, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc_bd, 1);
+	if (ret) {
+		dev_err(dev, "failed to query error bd_num, ret = %d.\n", ret);
+		return ret;
+	}
+
+	*bd_num = le32_to_cpu(desc_bd.data[0]);
+	if (!(*bd_num)) {
+		dev_err(dev, "The value of bd_num is 0!\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hclge_query_all_err_info(struct hclge_dev *hdev,
+				    struct hclge_desc *desc, u32 bd_num)
+{
+	struct device *dev = &hdev->pdev->dev;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(desc, HCLGE_QUERY_ALL_ERR_INFO, true);
+	ret = hclge_cmd_send(&hdev->hw, desc, bd_num);
+	if (ret)
+		dev_err(dev, "failed to query error info, ret = %d.\n", ret);
+
+	return ret;
+}
+
+int hclge_handle_error_info_log(struct hnae3_ae_dev *ae_dev)
+{
+	u32 bd_num, desc_len, buf_len, buf_size, i;
+	struct hclge_dev *hdev = ae_dev->priv;
+	struct hclge_desc *desc;
+	__le32 *desc_data;
+	u32 *buf;
+	int ret;
+
+	ret = hclge_query_all_err_bd_num(hdev, &bd_num);
+	if (ret)
+		goto out;
+
+	desc_len = bd_num * sizeof(struct hclge_desc);
+	desc = kzalloc(desc_len, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = hclge_query_all_err_info(hdev, desc, bd_num);
+	if (ret)
+		goto err_desc;
+
+	buf_len = bd_num * sizeof(struct hclge_desc) - HCLGE_DESC_NO_DATA_LEN;
+	buf_size = buf_len / sizeof(u32);
+
+	desc_data = kzalloc(buf_len, GFP_KERNEL);
+	if (!desc_data)
+		return -ENOMEM;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto err_buf_alloc;
+	}
+
+	memcpy(desc_data, &desc[0].data[0], buf_len);
+	for (i = 0; i < buf_size; i++)
+		buf[i] = le32_to_cpu(desc_data[i]);
+
+	hclge_handle_error_module_log(ae_dev, buf, buf_size);
+	kfree(buf);
+
+err_buf_alloc:
+	kfree(desc_data);
+err_desc:
+	kfree(desc);
+out:
+	return ret;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
index d647f3c84134..27ab772c665e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h
@@ -107,6 +107,10 @@
 #define HCLGE_ROCEE_OVF_ERR_INT_MASK		0x10000
 #define HCLGE_ROCEE_OVF_ERR_TYPE_MASK		0x3F
 
+#define HCLGE_DESC_DATA_MAX			8
+#define HCLGE_REG_NUM_MAX			256
+#define HCLGE_DESC_NO_DATA_LEN			8
+
 enum hclge_err_int_type {
 	HCLGE_ERR_INT_MSIX = 0,
 	HCLGE_ERR_INT_RAS_CE = 1,
@@ -114,6 +118,40 @@ enum hclge_err_int_type {
 	HCLGE_ERR_INT_RAS_FE = 3,
 };
 
+enum hclge_mod_name_list {
+	MODULE_NONE		= 0,
+	MODULE_BIOS_COMMON	= 1,
+	MODULE_GE		= 2,
+	MODULE_IGU_EGU		= 3,
+	MODULE_LGE		= 4,
+	MODULE_NCSI		= 5,
+	MODULE_PPP		= 6,
+	MODULE_QCN		= 7,
+	MODULE_RCB_RX		= 8,
+	MODULE_RTC		= 9,
+	MODULE_SSU		= 10,
+	MODULE_TM		= 11,
+	MODULE_RCB_TX		= 12,
+	MODULE_TXDMA		= 13,
+	MODULE_MASTER		= 14,
+};
+
+enum hclge_err_type_list {
+	NONE_ERROR		= 0,
+	FIFO_ERROR		= 1,
+	MEMORY_ERROR		= 2,
+	POISON_ERROR		= 3,
+	MSIX_ECC_ERROR		= 4,
+	TQP_INT_ECC_ERROR	= 5,
+	PF_ABNORMAL_INT_ERROR	= 6,
+	MPF_ABNORMAL_INT_ERROR	= 7,
+	COMMON_ERROR		= 8,
+	PORT_ERROR		= 9,
+	ETS_ERROR		= 10,
+	NCSI_ERROR		= 11,
+	GLB_ERROR		= 12,
+};
+
 struct hclge_hw_blk {
 	u32 msk;
 	const char *name;
@@ -126,6 +164,35 @@ struct hclge_hw_error {
 	enum hnae3_reset_type reset_level;
 };
 
+struct hclge_hw_module_id {
+	enum hclge_mod_name_list module_id;
+	const char *msg;
+};
+
+struct hclge_hw_type_id {
+	enum hclge_err_type_list type_id;
+	const char *msg;
+};
+
+struct hclge_sum_err_info {
+	u8 reset_type;
+	u8 mod_num;
+	u8 rsv[2];
+};
+
+struct hclge_mod_err_info {
+	u8 mod_id;
+	u8 err_num;
+	u8 rsv[2];
+};
+
+struct hclge_type_reg_err_info {
+	u8 type_id;
+	u8 reg_num;
+	u8 rsv[2];
+	u32 hclge_reg[HCLGE_REG_NUM_MAX];
+};
+
 int hclge_config_mac_tnl_int(struct hclge_dev *hdev, bool en);
 int hclge_config_nic_hw_error(struct hclge_dev *hdev, bool state);
 int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en);
@@ -133,4 +200,6 @@ void hclge_handle_all_hns_hw_errors(struct hnae3_ae_dev *ae_dev);
 pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev);
 int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 			       unsigned long *reset_requests);
+int hclge_handle_error_info_log(struct hnae3_ae_dev *ae_dev);
+int hclge_handle_mac_tnl(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d5be3bc50b5c..3c08fc71b951 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4236,11 +4236,49 @@ static void hclge_reset_subtask(struct hclge_dev *hdev)
 	hdev->reset_type = HNAE3_NONE_RESET;
 }
 
+static void hclge_handle_err_reset_request(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	enum hnae3_reset_type reset_type;
+
+	if (ae_dev->hw_err_reset_req) {
+		reset_type = hclge_get_reset_level(ae_dev,
+						   &ae_dev->hw_err_reset_req);
+		hclge_set_def_reset_request(ae_dev, reset_type);
+	}
+
+	if (hdev->default_reset_request && ae_dev->ops->reset_event)
+		ae_dev->ops->reset_event(hdev->pdev, NULL);
+
+	/* enable interrupt after error handling complete */
+	hclge_enable_vector(&hdev->misc_vector, true);
+}
+
+static void hclge_handle_err_recovery(struct hclge_dev *hdev)
+{
+	u32 mask_val = HCLGE_RAS_REG_NFE_MASK | HCLGE_RAS_REG_ROCEE_ERR_MASK;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	u32 msix_src_flag, hw_err_src_flag;
+
+	msix_src_flag = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS) &
+			HCLGE_VECTOR0_REG_MSIX_MASK;
+
+	hw_err_src_flag = hclge_read_dev(&hdev->hw,
+					 HCLGE_RAS_PF_OTHER_INT_STS_REG) &
+			  mask_val;
+
+	if (msix_src_flag || hw_err_src_flag) {
+		hclge_handle_error_info_log(ae_dev);
+		hclge_handle_mac_tnl(hdev);
+	}
+
+	hclge_handle_err_reset_request(hdev);
+}
+
 static void hclge_misc_err_recovery(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct device *dev = &hdev->pdev->dev;
-	enum hnae3_reset_type reset_type;
 	u32 msix_sts_reg;
 
 	msix_sts_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
@@ -4250,17 +4288,10 @@ static void hclge_misc_err_recovery(struct hclge_dev *hdev)
 			dev_info(dev, "received msix interrupt 0x%x\n",
 				 msix_sts_reg);
 	}
-	hclge_enable_vector(&hdev->misc_vector, true);
 
 	hclge_handle_hw_ras_error(ae_dev);
-	if (ae_dev->hw_err_reset_req) {
-		reset_type = hclge_get_reset_level(ae_dev,
-						   &ae_dev->hw_err_reset_req);
-		hclge_set_def_reset_request(ae_dev, reset_type);
-	}
 
-	if (hdev->default_reset_request && ae_dev->ops->reset_event)
-		ae_dev->ops->reset_event(hdev->pdev, NULL);
+	hclge_handle_err_reset_request(hdev);
 }
 
 static void hclge_errhand_service_task(struct hclge_dev *hdev)
@@ -4268,7 +4299,10 @@ static void hclge_errhand_service_task(struct hclge_dev *hdev)
 	if (!test_and_clear_bit(HCLGE_STATE_ERR_SERVICE_SCHED, &hdev->state))
 		return;
 
-	hclge_misc_err_recovery(hdev);
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+		hclge_handle_err_recovery(hdev);
+	else
+		hclge_misc_err_recovery(hdev);
 }
 
 static void hclge_reset_service_task(struct hclge_dev *hdev)
-- 
2.8.1

