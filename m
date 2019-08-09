Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0B86FA4
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405309AbfHICdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:33:38 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59000 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732708AbfHICdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:37 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 188FED2665E4EE2AB05C;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: add DFX registers information for ethtool -d
Date:   Fri, 9 Aug 2019 10:31:12 +0800
Message-ID: <1565317878-31806-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Now we can use ethtool -d command to dump some registers. However,
these registers information is not enough to find out where the problem is.

This patch adds DFX registers information after original registers
when use ethtool -d commmand to dump registers. Also, using macro
replaces some related magic number.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  12 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 342 ++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 3 files changed, 301 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index f16bfc6..933dec5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -14,16 +14,8 @@ static int hclge_dbg_get_dfx_bd_num(struct hclge_dev *hdev, int offset)
 	struct hclge_desc desc[4];
 	int ret;
 
-	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_DFX_BD_NUM, true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_DFX_BD_NUM, true);
-	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_OPC_DFX_BD_NUM, true);
-	desc[2].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[3], HCLGE_OPC_DFX_BD_NUM, true);
-
-	ret = hclge_cmd_send(&hdev->hw, desc, 4);
-	if (ret != HCLGE_CMD_EXEC_SUCCESS) {
+	ret = hclge_query_bd_num_cmd_send(hdev, desc);
+	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"get dfx bdnum fail, status is %d.\n", ret);
 		return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 381f195..7d7ab9e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -36,6 +36,20 @@
 
 #define HCLGE_RESET_MAX_FAIL_CNT	5
 
+/* Get DFX BD number offset */
+#define HCLGE_DFX_BIOS_BD_OFFSET        1
+#define HCLGE_DFX_SSU_0_BD_OFFSET       2
+#define HCLGE_DFX_SSU_1_BD_OFFSET       3
+#define HCLGE_DFX_IGU_BD_OFFSET         4
+#define HCLGE_DFX_RPU_0_BD_OFFSET       5
+#define HCLGE_DFX_RPU_1_BD_OFFSET       6
+#define HCLGE_DFX_NCSI_BD_OFFSET        7
+#define HCLGE_DFX_RTC_BD_OFFSET         8
+#define HCLGE_DFX_PPP_BD_OFFSET         9
+#define HCLGE_DFX_RCB_BD_OFFSET         10
+#define HCLGE_DFX_TQP_BD_OFFSET         11
+#define HCLGE_DFX_SSU_2_BD_OFFSET       12
+
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps);
 static int hclge_init_vlan_config(struct hclge_dev *hdev);
 static void hclge_sync_vlan_filter(struct hclge_dev *hdev);
@@ -317,6 +331,36 @@ static const u8 hclge_hash_key[] = {
 	0x6A, 0x42, 0xB7, 0x3B, 0xBE, 0xAC, 0x01, 0xFA
 };
 
+static const u32 hclge_dfx_bd_offset_list[] = {
+	HCLGE_DFX_BIOS_BD_OFFSET,
+	HCLGE_DFX_SSU_0_BD_OFFSET,
+	HCLGE_DFX_SSU_1_BD_OFFSET,
+	HCLGE_DFX_IGU_BD_OFFSET,
+	HCLGE_DFX_RPU_0_BD_OFFSET,
+	HCLGE_DFX_RPU_1_BD_OFFSET,
+	HCLGE_DFX_NCSI_BD_OFFSET,
+	HCLGE_DFX_RTC_BD_OFFSET,
+	HCLGE_DFX_PPP_BD_OFFSET,
+	HCLGE_DFX_RCB_BD_OFFSET,
+	HCLGE_DFX_TQP_BD_OFFSET,
+	HCLGE_DFX_SSU_2_BD_OFFSET
+};
+
+static const enum hclge_opcode_type hclge_dfx_reg_opcode_list[] = {
+	HCLGE_OPC_DFX_BIOS_COMMON_REG,
+	HCLGE_OPC_DFX_SSU_REG_0,
+	HCLGE_OPC_DFX_SSU_REG_1,
+	HCLGE_OPC_DFX_IGU_EGU_REG,
+	HCLGE_OPC_DFX_RPU_REG_0,
+	HCLGE_OPC_DFX_RPU_REG_1,
+	HCLGE_OPC_DFX_NCSI_REG,
+	HCLGE_OPC_DFX_RTC_REG,
+	HCLGE_OPC_DFX_PPP_REG,
+	HCLGE_OPC_DFX_RCB_REG,
+	HCLGE_OPC_DFX_TQP_REG,
+	HCLGE_OPC_DFX_SSU_REG_2
+};
+
 static int hclge_mac_update_stats_defective(struct hclge_dev *hdev)
 {
 #define HCLGE_MAC_CMD_NUM 21
@@ -9332,106 +9376,314 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 }
 
 #define MAX_SEPARATE_NUM	4
-#define SEPARATOR_VALUE		0xFFFFFFFF
+#define SEPARATOR_VALUE		0xFDFCFBFA
 #define REG_NUM_PER_LINE	4
 #define REG_LEN_PER_LINE	(REG_NUM_PER_LINE * sizeof(u32))
+#define REG_SEPARATOR_LINE	1
+#define REG_NUM_REMAIN_MASK	3
+#define BD_LIST_MAX_NUM		30
 
-static int hclge_get_regs_len(struct hnae3_handle *handle)
+int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev, struct hclge_desc *desc)
 {
-	int cmdq_lines, common_lines, ring_lines, tqp_intr_lines;
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
-	u32 regs_num_32_bit, regs_num_64_bit;
+	/*prepare 4 commands to query DFX BD number*/
+	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_DFX_BD_NUM, true);
+	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_DFX_BD_NUM, true);
+	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_OPC_DFX_BD_NUM, true);
+	desc[2].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	hclge_cmd_setup_basic_desc(&desc[3], HCLGE_OPC_DFX_BD_NUM, true);
+
+	return hclge_cmd_send(&hdev->hw, desc, 4);
+}
+
+static int hclge_get_dfx_reg_bd_num(struct hclge_dev *hdev,
+				    int *bd_num_list,
+				    u32 type_num)
+{
+#define HCLGE_DFX_REG_BD_NUM	4
+
+	u32 entries_per_desc, desc_index, index, offset, i;
+	struct hclge_desc desc[HCLGE_DFX_REG_BD_NUM];
 	int ret;
 
-	ret = hclge_get_regs_num(hdev, &regs_num_32_bit, &regs_num_64_bit);
+	ret = hclge_query_bd_num_cmd_send(hdev, desc);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"Get register number failed, ret = %d.\n", ret);
-		return -EOPNOTSUPP;
+			"Get dfx bd num fail, status is %d.\n", ret);
+		return ret;
 	}
 
-	cmdq_lines = sizeof(cmdq_reg_addr_list) / REG_LEN_PER_LINE + 1;
-	common_lines = sizeof(common_reg_addr_list) / REG_LEN_PER_LINE + 1;
-	ring_lines = sizeof(ring_reg_addr_list) / REG_LEN_PER_LINE + 1;
-	tqp_intr_lines = sizeof(tqp_intr_reg_addr_list) / REG_LEN_PER_LINE + 1;
+	entries_per_desc = ARRAY_SIZE(desc[0].data);
+	for (i = 0; i < type_num; i++) {
+		offset = hclge_dfx_bd_offset_list[i];
+		index = offset % entries_per_desc;
+		desc_index = offset / entries_per_desc;
+		bd_num_list[i] = le32_to_cpu(desc[desc_index].data[index]);
+	}
 
-	return (cmdq_lines + common_lines + ring_lines * kinfo->num_tqps +
-		tqp_intr_lines * (hdev->num_msi_used - 1)) * REG_LEN_PER_LINE +
-		regs_num_32_bit * sizeof(u32) + regs_num_64_bit * sizeof(u64);
+	return ret;
 }
 
-static void hclge_get_regs(struct hnae3_handle *handle, u32 *version,
-			   void *data)
+static int hclge_dfx_reg_cmd_send(struct hclge_dev *hdev,
+				  struct hclge_desc *desc_src, int bd_num,
+				  enum hclge_opcode_type cmd)
 {
-	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
-	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hclge_dev *hdev = vport->back;
-	u32 regs_num_32_bit, regs_num_64_bit;
-	int i, j, reg_um, separator_num;
+	struct hclge_desc *desc = desc_src;
+	int i, ret;
+
+	hclge_cmd_setup_basic_desc(desc, cmd, true);
+	for (i = 0; i < bd_num - 1; i++) {
+		desc->flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc++;
+		hclge_cmd_setup_basic_desc(desc, cmd, true);
+	}
+
+	desc = desc_src;
+	ret = hclge_cmd_send(&hdev->hw, desc, bd_num);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"Query dfx reg cmd(0x%x) send fail, status is %d.\n",
+			cmd, ret);
+
+	return ret;
+}
+
+static int hclge_dfx_reg_fetch_data(struct hclge_desc *desc_src, int bd_num,
+				    void *data)
+{
+	int entries_per_desc, reg_num, separator_num, desc_index, index, i;
+	struct hclge_desc *desc = desc_src;
 	u32 *reg = data;
+
+	entries_per_desc = ARRAY_SIZE(desc->data);
+	reg_num = entries_per_desc * bd_num;
+	separator_num = REG_NUM_PER_LINE - (reg_num & REG_NUM_REMAIN_MASK);
+	for (i = 0; i < reg_num; i++) {
+		index = i % entries_per_desc;
+		desc_index = i / entries_per_desc;
+		*reg++ = le32_to_cpu(desc[desc_index].data[index]);
+	}
+	for (i = 0; i < separator_num; i++)
+		*reg++ = SEPARATOR_VALUE;
+
+	return reg_num + separator_num;
+}
+
+static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
+{
+	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
+	int data_len_per_desc, data_len, bd_num, i;
+	int bd_num_list[BD_LIST_MAX_NUM];
 	int ret;
 
-	*version = hdev->fw_version;
+	ret = hclge_get_dfx_reg_bd_num(hdev, bd_num_list, dfx_reg_type_num);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"Get dfx reg bd num fail, status is %d.\n", ret);
+		return ret;
+	}
 
-	ret = hclge_get_regs_num(hdev, &regs_num_32_bit, &regs_num_64_bit);
+	data_len_per_desc = FIELD_SIZEOF(struct hclge_desc, data);
+	*len = 0;
+	for (i = 0; i < dfx_reg_type_num; i++) {
+		bd_num = bd_num_list[i];
+		data_len = data_len_per_desc * bd_num;
+		*len += (data_len / REG_LEN_PER_LINE + 1) * REG_LEN_PER_LINE;
+	}
+
+	return ret;
+}
+
+static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
+{
+	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
+	int bd_num, bd_num_max, buf_len, i;
+	int bd_num_list[BD_LIST_MAX_NUM];
+	struct hclge_desc *desc_src;
+	u32 *reg = data;
+	int ret;
+
+	ret = hclge_get_dfx_reg_bd_num(hdev, bd_num_list, dfx_reg_type_num);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"Get register number failed, ret = %d.\n", ret);
-		return;
+			"Get dfx reg bd num fail, status is %d.\n", ret);
+		return ret;
+	}
+
+	bd_num_max = bd_num_list[0];
+	for (i = 1; i < dfx_reg_type_num; i++)
+		bd_num_max = max_t(int, bd_num_max, bd_num_list[i]);
+
+	buf_len = sizeof(*desc_src) * bd_num_max;
+	desc_src = kzalloc(buf_len, GFP_KERNEL);
+	if (!desc_src) {
+		dev_err(&hdev->pdev->dev, "%s kzalloc failed\n", __func__);
+		return -ENOMEM;
 	}
 
+	for (i = 0; i < dfx_reg_type_num; i++) {
+		bd_num = bd_num_list[i];
+		ret = hclge_dfx_reg_cmd_send(hdev, desc_src, bd_num,
+					     hclge_dfx_reg_opcode_list[i]);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"Get dfx reg fail, status is %d.\n", ret);
+			break;
+		}
+
+		reg += hclge_dfx_reg_fetch_data(desc_src, bd_num, reg);
+	}
+
+	kfree(desc_src);
+	return ret;
+}
+
+static int hclge_fetch_pf_reg(struct hclge_dev *hdev, void *data,
+			      struct hnae3_knic_private_info *kinfo)
+{
+#define HCLGE_RING_REG_OFFSET		0x200
+#define HCLGE_RING_INT_REG_OFFSET	0x4
+
+	int i, j, reg_num, separator_num;
+	int data_num_sum;
+	u32 *reg = data;
+
 	/* fetching per-PF registers valus from PF PCIe register space */
-	reg_um = sizeof(cmdq_reg_addr_list) / sizeof(u32);
-	separator_num = MAX_SEPARATE_NUM - reg_um % REG_NUM_PER_LINE;
-	for (i = 0; i < reg_um; i++)
+	reg_num = ARRAY_SIZE(cmdq_reg_addr_list);
+	separator_num = MAX_SEPARATE_NUM - (reg_num & REG_NUM_REMAIN_MASK);
+	for (i = 0; i < reg_num; i++)
 		*reg++ = hclge_read_dev(&hdev->hw, cmdq_reg_addr_list[i]);
 	for (i = 0; i < separator_num; i++)
 		*reg++ = SEPARATOR_VALUE;
+	data_num_sum = reg_num + separator_num;
 
-	reg_um = sizeof(common_reg_addr_list) / sizeof(u32);
-	separator_num = MAX_SEPARATE_NUM - reg_um % REG_NUM_PER_LINE;
-	for (i = 0; i < reg_um; i++)
+	reg_num = ARRAY_SIZE(common_reg_addr_list);
+	separator_num = MAX_SEPARATE_NUM - (reg_num & REG_NUM_REMAIN_MASK);
+	for (i = 0; i < reg_num; i++)
 		*reg++ = hclge_read_dev(&hdev->hw, common_reg_addr_list[i]);
 	for (i = 0; i < separator_num; i++)
 		*reg++ = SEPARATOR_VALUE;
+	data_num_sum += reg_num + separator_num;
 
-	reg_um = sizeof(ring_reg_addr_list) / sizeof(u32);
-	separator_num = MAX_SEPARATE_NUM - reg_um % REG_NUM_PER_LINE;
+	reg_num = ARRAY_SIZE(ring_reg_addr_list);
+	separator_num = MAX_SEPARATE_NUM - (reg_num & REG_NUM_REMAIN_MASK);
 	for (j = 0; j < kinfo->num_tqps; j++) {
-		for (i = 0; i < reg_um; i++)
+		for (i = 0; i < reg_num; i++)
 			*reg++ = hclge_read_dev(&hdev->hw,
 						ring_reg_addr_list[i] +
-						0x200 * j);
+						HCLGE_RING_REG_OFFSET * j);
 		for (i = 0; i < separator_num; i++)
 			*reg++ = SEPARATOR_VALUE;
 	}
+	data_num_sum += (reg_num + separator_num) * kinfo->num_tqps;
 
-	reg_um = sizeof(tqp_intr_reg_addr_list) / sizeof(u32);
-	separator_num = MAX_SEPARATE_NUM - reg_um % REG_NUM_PER_LINE;
+	reg_num = ARRAY_SIZE(tqp_intr_reg_addr_list);
+	separator_num = MAX_SEPARATE_NUM - (reg_num & REG_NUM_REMAIN_MASK);
 	for (j = 0; j < hdev->num_msi_used - 1; j++) {
-		for (i = 0; i < reg_um; i++)
+		for (i = 0; i < reg_num; i++)
 			*reg++ = hclge_read_dev(&hdev->hw,
 						tqp_intr_reg_addr_list[i] +
-						4 * j);
+						HCLGE_RING_INT_REG_OFFSET * j);
 		for (i = 0; i < separator_num; i++)
 			*reg++ = SEPARATOR_VALUE;
 	}
+	data_num_sum += (reg_num + separator_num) * (hdev->num_msi_used - 1);
+
+	return data_num_sum;
+}
+
+static int hclge_get_regs_len(struct hnae3_handle *handle)
+{
+	int cmdq_lines, common_lines, ring_lines, tqp_intr_lines;
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	int regs_num_32_bit, regs_num_64_bit, dfx_regs_len;
+	int regs_lines_32_bit, regs_lines_64_bit;
+	int ret;
+
+	ret = hclge_get_regs_num(hdev, &regs_num_32_bit, &regs_num_64_bit);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"Get register number failed, ret = %d.\n", ret);
+		return ret;
+	}
+
+	ret = hclge_get_dfx_reg_len(hdev, &dfx_regs_len);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"Get dfx reg len failed, ret = %d.\n", ret);
+		return ret;
+	}
+
+	cmdq_lines = sizeof(cmdq_reg_addr_list) / REG_LEN_PER_LINE +
+		REG_SEPARATOR_LINE;
+	common_lines = sizeof(common_reg_addr_list) / REG_LEN_PER_LINE +
+		REG_SEPARATOR_LINE;
+	ring_lines = sizeof(ring_reg_addr_list) / REG_LEN_PER_LINE +
+		REG_SEPARATOR_LINE;
+	tqp_intr_lines = sizeof(tqp_intr_reg_addr_list) / REG_LEN_PER_LINE +
+		REG_SEPARATOR_LINE;
+	regs_lines_32_bit = regs_num_32_bit * sizeof(u32) / REG_LEN_PER_LINE +
+		REG_SEPARATOR_LINE;
+	regs_lines_64_bit = regs_num_64_bit * sizeof(u64) / REG_LEN_PER_LINE +
+		REG_SEPARATOR_LINE;
+
+	return (cmdq_lines + common_lines + ring_lines * kinfo->num_tqps +
+		tqp_intr_lines * (hdev->num_msi_used - 1) + regs_lines_32_bit +
+		regs_lines_64_bit) * REG_LEN_PER_LINE + dfx_regs_len;
+}
+
+static void hclge_get_regs(struct hnae3_handle *handle, u32 *version,
+			   void *data)
+{
+	struct hnae3_knic_private_info *kinfo = &handle->kinfo;
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 regs_num_32_bit, regs_num_64_bit;
+	int i, reg_num, separator_num, ret;
+	u32 *reg = data;
+
+	*version = hdev->fw_version;
+
+	ret = hclge_get_regs_num(hdev, &regs_num_32_bit, &regs_num_64_bit);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"Get register number failed, ret = %d.\n", ret);
+		return;
+	}
+
+	reg += hclge_fetch_pf_reg(hdev, reg, kinfo);
 
-	/* fetching PF common registers values from firmware */
 	ret = hclge_get_32_bit_regs(hdev, regs_num_32_bit, reg);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Get 32 bit register failed, ret = %d.\n", ret);
 		return;
 	}
+	reg_num = regs_num_32_bit;
+	reg += reg_num;
+	separator_num = MAX_SEPARATE_NUM - (reg_num & REG_NUM_REMAIN_MASK);
+	for (i = 0; i < separator_num; i++)
+		*reg++ = SEPARATOR_VALUE;
 
-	reg += regs_num_32_bit;
 	ret = hclge_get_64_bit_regs(hdev, regs_num_64_bit, reg);
-	if (ret)
+	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Get 64 bit register failed, ret = %d.\n", ret);
+		return;
+	}
+	reg_num = regs_num_64_bit * 2;
+	reg += reg_num;
+	separator_num = MAX_SEPARATE_NUM - (reg_num & REG_NUM_REMAIN_MASK);
+	for (i = 0; i < separator_num; i++)
+		*reg++ = SEPARATOR_VALUE;
+
+	ret = hclge_get_dfx_reg(hdev, reg);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"Get dfx register failed, ret = %d.\n", ret);
 }
 
 static int hclge_set_led_status(struct hclge_dev *hdev, u8 locate_led_status)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index c9b9867f..f6d9b57 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1029,4 +1029,6 @@ int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 				      u16 state, u16 vlan_tag, u16 qos,
 				      u16 vlan_proto);
 void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time);
+int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev,
+				struct hclge_desc *desc);
 #endif
-- 
2.7.4

