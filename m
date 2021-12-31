Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D715748235A
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhLaK1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:27:44 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29318 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhLaK1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:42 -0500
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JQLt54kbszbjlb;
        Fri, 31 Dec 2021 18:27:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:39 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 04/13] net: hns3: create new set of unified hclge_comm_cmd_send APIs
Date:   Fri, 31 Dec 2021 18:22:34 +0800
Message-ID: <20211231102243.3006-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
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

This patch create new set of unified hclge_comm_cmd_send APIs for PF and VF
cmdq module. Subfunctions called by hclge_comm_cmd_send are also created
include cmdq result check, cmdq return code conversion and ring space
opertaion APIs.

These new common cmdq APIs will be used to replace the old PF and VF cmdq
APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.c         | 259 ++++++++++++++++++
 .../hns3/hns3_common/hclge_comm_cmd.h         |  66 +++++
 2 files changed, 325 insertions(+)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
new file mode 100644
index 000000000000..89e999248b9a
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (c) 2021-2021 Hisilicon Limited.
+
+#include "hnae3.h"
+#include "hclge_comm_cmd.h"
+
+static bool hclge_is_elem_in_array(const u16 *spec_opcode, u32 size, u16 opcode)
+{
+	u32 i;
+
+	for (i = 0; i < size; i++) {
+		if (spec_opcode[i] == opcode)
+			return true;
+	}
+
+	return false;
+}
+
+static const u16 pf_spec_opcode[] = { HCLGE_COMM_OPC_STATS_64_BIT,
+				      HCLGE_COMM_OPC_STATS_32_BIT,
+				      HCLGE_COMM_OPC_STATS_MAC,
+				      HCLGE_COMM_OPC_STATS_MAC_ALL,
+				      HCLGE_COMM_OPC_QUERY_32_BIT_REG,
+				      HCLGE_COMM_OPC_QUERY_64_BIT_REG,
+				      HCLGE_COMM_QUERY_CLEAR_MPF_RAS_INT,
+				      HCLGE_COMM_QUERY_CLEAR_PF_RAS_INT,
+				      HCLGE_COMM_QUERY_CLEAR_ALL_MPF_MSIX_INT,
+				      HCLGE_COMM_QUERY_CLEAR_ALL_PF_MSIX_INT,
+				      HCLGE_COMM_QUERY_ALL_ERR_INFO };
+
+static const u16 vf_spec_opcode[] = { HCLGE_COMM_OPC_STATS_64_BIT,
+				      HCLGE_COMM_OPC_STATS_32_BIT,
+				      HCLGE_COMM_OPC_STATS_MAC };
+
+static bool hclge_comm_is_special_opcode(u16 opcode, bool is_pf)
+{
+	/* these commands have several descriptors,
+	 * and use the first one to save opcode and return value
+	 */
+	const u16 *spec_opcode = is_pf ? pf_spec_opcode : vf_spec_opcode;
+	u32 size = is_pf ? ARRAY_SIZE(pf_spec_opcode) :
+				ARRAY_SIZE(vf_spec_opcode);
+
+	return hclge_is_elem_in_array(spec_opcode, size, opcode);
+}
+
+static int hclge_comm_ring_space(struct hclge_comm_cmq_ring *ring)
+{
+	int ntc = ring->next_to_clean;
+	int ntu = ring->next_to_use;
+	int used = (ntu - ntc + ring->desc_num) % ring->desc_num;
+
+	return ring->desc_num - used - 1;
+}
+
+static void hclge_comm_cmd_copy_desc(struct hclge_comm_hw *hw,
+				     struct hclge_desc *desc, int num)
+{
+	struct hclge_desc *desc_to_use;
+	int handle = 0;
+
+	while (handle < num) {
+		desc_to_use = &hw->cmq.csq.desc[hw->cmq.csq.next_to_use];
+		*desc_to_use = desc[handle];
+		(hw->cmq.csq.next_to_use)++;
+		if (hw->cmq.csq.next_to_use >= hw->cmq.csq.desc_num)
+			hw->cmq.csq.next_to_use = 0;
+		handle++;
+	}
+}
+
+static int hclge_comm_is_valid_csq_clean_head(struct hclge_comm_cmq_ring *ring,
+					      int head)
+{
+	int ntc = ring->next_to_clean;
+	int ntu = ring->next_to_use;
+
+	if (ntu > ntc)
+		return head >= ntc && head <= ntu;
+
+	return head >= ntc || head <= ntu;
+}
+
+static int hclge_comm_cmd_csq_clean(struct hclge_comm_hw *hw)
+{
+	struct hclge_comm_cmq_ring *csq = &hw->cmq.csq;
+	int clean;
+	u32 head;
+
+	head = hclge_comm_read_dev(hw, HCLGE_COMM_NIC_CSQ_HEAD_REG);
+	rmb(); /* Make sure head is ready before touch any data */
+
+	if (!hclge_comm_is_valid_csq_clean_head(csq, head)) {
+		dev_warn(&hw->cmq.csq.pdev->dev, "wrong cmd head (%u, %d-%d)\n",
+			 head, csq->next_to_use, csq->next_to_clean);
+		dev_warn(&hw->cmq.csq.pdev->dev,
+			 "Disabling any further commands to IMP firmware\n");
+		set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hw->comm_state);
+		dev_warn(&hw->cmq.csq.pdev->dev,
+			 "IMP firmware watchdog reset soon expected!\n");
+		return -EIO;
+	}
+
+	clean = (head - csq->next_to_clean + csq->desc_num) % csq->desc_num;
+	csq->next_to_clean = head;
+	return clean;
+}
+
+static int hclge_comm_cmd_csq_done(struct hclge_comm_hw *hw)
+{
+	u32 head = hclge_comm_read_dev(hw, HCLGE_COMM_NIC_CSQ_HEAD_REG);
+	return head == hw->cmq.csq.next_to_use;
+}
+
+static void hclge_comm_wait_for_resp(struct hclge_comm_hw *hw,
+				     bool *is_completed)
+{
+	u32 timeout = 0;
+
+	do {
+		if (hclge_comm_cmd_csq_done(hw)) {
+			*is_completed = true;
+			break;
+		}
+		udelay(1);
+		timeout++;
+	} while (timeout < hw->cmq.tx_timeout);
+}
+
+static int hclge_comm_cmd_convert_err_code(u16 desc_ret)
+{
+	struct hclge_comm_errcode hclge_comm_cmd_errcode[] = {
+		{ HCLGE_COMM_CMD_EXEC_SUCCESS, 0 },
+		{ HCLGE_COMM_CMD_NO_AUTH, -EPERM },
+		{ HCLGE_COMM_CMD_NOT_SUPPORTED, -EOPNOTSUPP },
+		{ HCLGE_COMM_CMD_QUEUE_FULL, -EXFULL },
+		{ HCLGE_COMM_CMD_NEXT_ERR, -ENOSR },
+		{ HCLGE_COMM_CMD_UNEXE_ERR, -ENOTBLK },
+		{ HCLGE_COMM_CMD_PARA_ERR, -EINVAL },
+		{ HCLGE_COMM_CMD_RESULT_ERR, -ERANGE },
+		{ HCLGE_COMM_CMD_TIMEOUT, -ETIME },
+		{ HCLGE_COMM_CMD_HILINK_ERR, -ENOLINK },
+		{ HCLGE_COMM_CMD_QUEUE_ILLEGAL, -ENXIO },
+		{ HCLGE_COMM_CMD_INVALID, -EBADR },
+	};
+	u32 errcode_count = ARRAY_SIZE(hclge_comm_cmd_errcode);
+	u32 i;
+
+	for (i = 0; i < errcode_count; i++)
+		if (hclge_comm_cmd_errcode[i].imp_errcode == desc_ret)
+			return hclge_comm_cmd_errcode[i].common_errno;
+
+	return -EIO;
+}
+
+static int hclge_comm_cmd_check_retval(struct hclge_comm_hw *hw,
+				       struct hclge_desc *desc, int num,
+				       int ntc, bool is_pf)
+{
+	u16 opcode, desc_ret;
+	int handle;
+
+	opcode = le16_to_cpu(desc[0].opcode);
+	for (handle = 0; handle < num; handle++) {
+		desc[handle] = hw->cmq.csq.desc[ntc];
+		ntc++;
+		if (ntc >= hw->cmq.csq.desc_num)
+			ntc = 0;
+	}
+	if (likely(!hclge_comm_is_special_opcode(opcode, is_pf)))
+		desc_ret = le16_to_cpu(desc[num - 1].retval);
+	else
+		desc_ret = le16_to_cpu(desc[0].retval);
+
+	hw->cmq.last_status = desc_ret;
+
+	return hclge_comm_cmd_convert_err_code(desc_ret);
+}
+
+static int hclge_comm_cmd_check_result(struct hclge_comm_hw *hw,
+				       struct hclge_desc *desc,
+				       int num, int ntc, bool is_pf)
+{
+	bool is_completed = false;
+	int handle, ret;
+
+	/* If the command is sync, wait for the firmware to write back,
+	 * if multi descriptors to be sent, use the first one to check
+	 */
+	if (HCLGE_COMM_SEND_SYNC(le16_to_cpu(desc->flag)))
+		hclge_comm_wait_for_resp(hw, &is_completed);
+
+	if (!is_completed)
+		ret = -EBADE;
+	else
+		ret = hclge_comm_cmd_check_retval(hw, desc, num, ntc, is_pf);
+
+	/* Clean the command send queue */
+	handle = hclge_comm_cmd_csq_clean(hw);
+	if (handle < 0)
+		ret = handle;
+	else if (handle != num)
+		dev_warn(&hw->cmq.csq.pdev->dev,
+			 "cleaned %d, need to clean %d\n", handle, num);
+	return ret;
+}
+
+/**
+ * hclge_comm_cmd_send - send command to command queue
+ * @hw: pointer to the hw struct
+ * @desc: prefilled descriptor for describing the command
+ * @num : the number of descriptors to be sent
+ * @is_pf: bool to judge pf/vf module
+ *
+ * This is the main send command for command queue, it
+ * sends the queue, cleans the queue, etc
+ **/
+int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
+			int num, bool is_pf)
+{
+	struct hclge_comm_cmq_ring *csq = &hw->cmq.csq;
+	int ret;
+	int ntc;
+
+	spin_lock_bh(&hw->cmq.csq.lock);
+
+	if (test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hw->comm_state)) {
+		spin_unlock_bh(&hw->cmq.csq.lock);
+		return -EBUSY;
+	}
+
+	if (num > hclge_comm_ring_space(&hw->cmq.csq)) {
+		/* If CMDQ ring is full, SW HEAD and HW HEAD may be different,
+		 * need update the SW HEAD pointer csq->next_to_clean
+		 */
+		csq->next_to_clean =
+			hclge_comm_read_dev(hw, HCLGE_COMM_NIC_CSQ_HEAD_REG);
+		spin_unlock_bh(&hw->cmq.csq.lock);
+		return -EBUSY;
+	}
+
+	/**
+	 * Record the location of desc in the ring for this time
+	 * which will be use for hardware to write back
+	 */
+	ntc = hw->cmq.csq.next_to_use;
+
+	hclge_comm_cmd_copy_desc(hw, desc, num);
+
+	/* Write to hardware */
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_TAIL_REG,
+			     hw->cmq.csq.next_to_use);
+
+	ret = hclge_comm_cmd_check_result(hw, desc, num, ntc, is_pf);
+
+	spin_unlock_bh(&hw->cmq.csq.lock);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index f1e39003ceeb..5164c666cae7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -7,6 +7,52 @@
 
 #include "hnae3.h"
 
+#define HCLGE_COMM_CMD_FLAG_NO_INTR		BIT(4)
+
+#define HCLGE_COMM_SEND_SYNC(flag) \
+	((flag) & HCLGE_COMM_CMD_FLAG_NO_INTR)
+
+#define HCLGE_COMM_NIC_CSQ_TAIL_REG		0x27010
+#define HCLGE_COMM_NIC_CSQ_HEAD_REG		0x27014
+
+enum hclge_comm_cmd_return_status {
+	HCLGE_COMM_CMD_EXEC_SUCCESS	= 0,
+	HCLGE_COMM_CMD_NO_AUTH		= 1,
+	HCLGE_COMM_CMD_NOT_SUPPORTED	= 2,
+	HCLGE_COMM_CMD_QUEUE_FULL	= 3,
+	HCLGE_COMM_CMD_NEXT_ERR		= 4,
+	HCLGE_COMM_CMD_UNEXE_ERR	= 5,
+	HCLGE_COMM_CMD_PARA_ERR		= 6,
+	HCLGE_COMM_CMD_RESULT_ERR	= 7,
+	HCLGE_COMM_CMD_TIMEOUT		= 8,
+	HCLGE_COMM_CMD_HILINK_ERR	= 9,
+	HCLGE_COMM_CMD_QUEUE_ILLEGAL	= 10,
+	HCLGE_COMM_CMD_INVALID		= 11,
+};
+
+enum hclge_comm_special_cmd {
+	HCLGE_COMM_OPC_STATS_64_BIT		= 0x0030,
+	HCLGE_COMM_OPC_STATS_32_BIT		= 0x0031,
+	HCLGE_COMM_OPC_STATS_MAC		= 0x0032,
+	HCLGE_COMM_OPC_STATS_MAC_ALL		= 0x0034,
+	HCLGE_COMM_OPC_QUERY_32_BIT_REG		= 0x0041,
+	HCLGE_COMM_OPC_QUERY_64_BIT_REG		= 0x0042,
+	HCLGE_COMM_QUERY_CLEAR_MPF_RAS_INT	= 0x1511,
+	HCLGE_COMM_QUERY_CLEAR_PF_RAS_INT	= 0x1512,
+	HCLGE_COMM_QUERY_CLEAR_ALL_MPF_MSIX_INT	= 0x1514,
+	HCLGE_COMM_QUERY_CLEAR_ALL_PF_MSIX_INT	= 0x1515,
+	HCLGE_COMM_QUERY_ALL_ERR_INFO		= 0x1517,
+};
+
+enum hclge_comm_cmd_state {
+	HCLGE_COMM_STATE_CMD_DISABLE,
+};
+
+struct hclge_comm_errcode {
+	u32 imp_errcode;
+	int common_errno;
+};
+
 #define HCLGE_DESC_DATA_LEN		6
 struct hclge_desc {
 	__le16 opcode;
@@ -52,4 +98,24 @@ struct hclge_comm_hw {
 	unsigned long comm_state;
 };
 
+static inline void hclge_comm_write_reg(void __iomem *base, u32 reg, u32 value)
+{
+	writel(value, base + reg);
+}
+
+static inline u32 hclge_comm_read_reg(u8 __iomem *base, u32 reg)
+{
+	u8 __iomem *reg_addr = READ_ONCE(base);
+
+	return readl(reg_addr + reg);
+}
+
+#define hclge_comm_write_dev(a, reg, value) \
+	hclge_comm_write_reg((a)->io_base, reg, value)
+#define hclge_comm_read_dev(a, reg) \
+	hclge_comm_read_reg((a)->io_base, reg)
+
+int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
+			int num, bool is_pf);
+
 #endif
-- 
2.33.0

