Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FF13198BC
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhBLDZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:25:11 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13344 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhBLDZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:25:04 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DcJjC6hznz7jxd;
        Fri, 12 Feb 2021 11:22:55 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:24:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 10/13] net: hns3: split out hclgevf_cmd_send()
Date:   Fri, 12 Feb 2021 11:24:14 +0800
Message-ID: <20210212032417.13076-2-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210212032417.13076-1-tanhuazhong@huawei.com>
References: <20210212032417.13076-1-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

hclgevf_cmd_send() is bloated, so split it into separate
functions for readability and maintainability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 141 ++++++++++--------
 1 file changed, 81 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 603665e5bf39..46700c427849 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -181,6 +181,22 @@ struct vf_errcode {
 	int common_errno;
 };
 
+static void hclgevf_cmd_copy_desc(struct hclgevf_hw *hw,
+				  struct hclgevf_desc *desc, int num)
+{
+	struct hclgevf_desc *desc_to_use;
+	int handle = 0;
+
+	while (handle < num) {
+		desc_to_use = &hw->cmq.csq.desc[hw->cmq.csq.next_to_use];
+		*desc_to_use = desc[handle];
+		(hw->cmq.csq.next_to_use)++;
+		if (hw->cmq.csq.next_to_use == hw->cmq.csq.desc_num)
+			hw->cmq.csq.next_to_use = 0;
+		handle++;
+	}
+}
+
 static int hclgevf_cmd_convert_err_code(u16 desc_ret)
 {
 	struct vf_errcode hclgevf_cmd_errcode[] = {
@@ -207,6 +223,66 @@ static int hclgevf_cmd_convert_err_code(u16 desc_ret)
 	return -EIO;
 }
 
+static int hclgevf_cmd_check_retval(struct hclgevf_hw *hw,
+				    struct hclgevf_desc *desc, int num, int ntc)
+{
+	u16 opcode, desc_ret;
+	int handle;
+
+	opcode = le16_to_cpu(desc[0].opcode);
+	for (handle = 0; handle < num; handle++) {
+		/* Get the result of hardware write back */
+		desc[handle] = hw->cmq.csq.desc[ntc];
+		ntc++;
+		if (ntc == hw->cmq.csq.desc_num)
+			ntc = 0;
+	}
+	if (likely(!hclgevf_is_special_opcode(opcode)))
+		desc_ret = le16_to_cpu(desc[num - 1].retval);
+	else
+		desc_ret = le16_to_cpu(desc[0].retval);
+	hw->cmq.last_status = desc_ret;
+
+	return hclgevf_cmd_convert_err_code(desc_ret);
+}
+
+static int hclgevf_cmd_check_result(struct hclgevf_hw *hw,
+				    struct hclgevf_desc *desc, int num, int ntc)
+{
+	struct hclgevf_dev *hdev = (struct hclgevf_dev *)hw->hdev;
+	bool is_completed = false;
+	u32 timeout = 0;
+	int handle, ret;
+
+	/* If the command is sync, wait for the firmware to write back,
+	 * if multi descriptors to be sent, use the first one to check
+	 */
+	if (HCLGEVF_SEND_SYNC(le16_to_cpu(desc->flag))) {
+		do {
+			if (hclgevf_cmd_csq_done(hw)) {
+				is_completed = true;
+				break;
+			}
+			udelay(1);
+			timeout++;
+		} while (timeout < hw->cmq.tx_timeout);
+	}
+
+	if (!is_completed)
+		ret = -EBADE;
+	else
+		ret = hclgevf_cmd_check_retval(hw, desc, num, ntc);
+
+	/* Clean the command send queue */
+	handle = hclgevf_cmd_csq_clean(hw);
+	if (handle < 0)
+		ret = handle;
+	else if (handle != num)
+		dev_warn(&hdev->pdev->dev,
+			 "cleaned %d, need to clean %d\n", handle, num);
+	return ret;
+}
+
 /* hclgevf_cmd_send - send command to command queue
  * @hw: pointer to the hw struct
  * @desc: prefilled descriptor for describing the command
@@ -219,13 +295,7 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 {
 	struct hclgevf_dev *hdev = (struct hclgevf_dev *)hw->hdev;
 	struct hclgevf_cmq_ring *csq = &hw->cmq.csq;
-	struct hclgevf_desc *desc_to_use;
-	bool complete = false;
-	u32 timeout = 0;
-	int handle = 0;
-	int status = 0;
-	u16 retval;
-	u16 opcode;
+	int ret;
 	int ntc;
 
 	spin_lock_bh(&hw->cmq.csq.lock);
@@ -249,67 +319,18 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 	 * which will be use for hardware to write back
 	 */
 	ntc = hw->cmq.csq.next_to_use;
-	opcode = le16_to_cpu(desc[0].opcode);
-	while (handle < num) {
-		desc_to_use = &hw->cmq.csq.desc[hw->cmq.csq.next_to_use];
-		*desc_to_use = desc[handle];
-		(hw->cmq.csq.next_to_use)++;
-		if (hw->cmq.csq.next_to_use == hw->cmq.csq.desc_num)
-			hw->cmq.csq.next_to_use = 0;
-		handle++;
-	}
+
+	hclgevf_cmd_copy_desc(hw, desc, num);
 
 	/* Write to hardware */
 	hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG,
 			  hw->cmq.csq.next_to_use);
 
-	/* If the command is sync, wait for the firmware to write back,
-	 * if multi descriptors to be sent, use the first one to check
-	 */
-	if (HCLGEVF_SEND_SYNC(le16_to_cpu(desc->flag))) {
-		do {
-			if (hclgevf_cmd_csq_done(hw))
-				break;
-			udelay(1);
-			timeout++;
-		} while (timeout < hw->cmq.tx_timeout);
-	}
-
-	if (hclgevf_cmd_csq_done(hw)) {
-		complete = true;
-		handle = 0;
-
-		while (handle < num) {
-			/* Get the result of hardware write back */
-			desc_to_use = &hw->cmq.csq.desc[ntc];
-			desc[handle] = *desc_to_use;
-
-			if (likely(!hclgevf_is_special_opcode(opcode)))
-				retval = le16_to_cpu(desc[handle].retval);
-			else
-				retval = le16_to_cpu(desc[0].retval);
-
-			status = hclgevf_cmd_convert_err_code(retval);
-			hw->cmq.last_status = (enum hclgevf_cmd_status)retval;
-			ntc++;
-			handle++;
-			if (ntc == hw->cmq.csq.desc_num)
-				ntc = 0;
-		}
-	}
-
-	if (!complete)
-		status = -EBADE;
-
-	/* Clean the command send queue */
-	handle = hclgevf_cmd_csq_clean(hw);
-	if (handle != num)
-		dev_warn(&hdev->pdev->dev,
-			 "cleaned %d, need to clean %d\n", handle, num);
+	ret = hclgevf_cmd_check_result(hw, desc, num, ntc);
 
 	spin_unlock_bh(&hw->cmq.csq.lock);
 
-	return status;
+	return ret;
 }
 
 static void hclgevf_set_default_capability(struct hclgevf_dev *hdev)
-- 
2.25.1

