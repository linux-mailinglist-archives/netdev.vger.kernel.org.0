Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474403198BF
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBLDZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:25:19 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13343 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhBLDZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:25:04 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DcJjC6xDyz7k14;
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
Subject: [PATCH V2 net-next 09/13] net: hns3: split out hclge_cmd_send()
Date:   Fri, 12 Feb 2021 11:24:13 +0800
Message-ID: <20210212032417.13076-1-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

hclge_cmd_send() is bloated, so split it into separate
functions for readability and maintainability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 100 +++++++++++-------
 1 file changed, 59 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index cb2c955ce52c..1bd0ddfaec4d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -194,6 +194,22 @@ struct errcode {
 	int common_errno;
 };
 
+static void hclge_cmd_copy_desc(struct hclge_hw *hw, struct hclge_desc *desc,
+				int num)
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
 static int hclge_cmd_convert_err_code(u16 desc_ret)
 {
 	struct errcode hclge_cmd_errcode[] = {
@@ -243,6 +259,44 @@ static int hclge_cmd_check_retval(struct hclge_hw *hw, struct hclge_desc *desc,
 	return hclge_cmd_convert_err_code(desc_ret);
 }
 
+static int hclge_cmd_check_result(struct hclge_hw *hw, struct hclge_desc *desc,
+				  int num, int ntc)
+{
+	struct hclge_dev *hdev = container_of(hw, struct hclge_dev, hw);
+	bool is_completed = false;
+	u32 timeout = 0;
+	int handle, ret;
+
+	/**
+	 * If the command is sync, wait for the firmware to write back,
+	 * if multi descriptors to be sent, use the first one to check
+	 */
+	if (HCLGE_SEND_SYNC(le16_to_cpu(desc->flag))) {
+		do {
+			if (hclge_cmd_csq_done(hw)) {
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
+		ret = hclge_cmd_check_retval(hw, desc, num, ntc);
+
+	/* Clean the command send queue */
+	handle = hclge_cmd_csq_clean(hw);
+	if (handle < 0)
+		ret = handle;
+	else if (handle != num)
+		dev_warn(&hdev->pdev->dev,
+			 "cleaned %d, need to clean %d\n", handle, num);
+	return ret;
+}
+
 /**
  * hclge_cmd_send - send command to command queue
  * @hw: pointer to the hw struct
@@ -256,11 +310,7 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 {
 	struct hclge_dev *hdev = container_of(hw, struct hclge_dev, hw);
 	struct hclge_cmq_ring *csq = &hw->cmq.csq;
-	struct hclge_desc *desc_to_use;
-	bool complete = false;
-	u32 timeout = 0;
-	int handle = 0;
-	int retval;
+	int ret;
 	int ntc;
 
 	spin_lock_bh(&hw->cmq.csq.lock);
@@ -284,49 +334,17 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 	 * which will be use for hardware to write back
 	 */
 	ntc = hw->cmq.csq.next_to_use;
-	while (handle < num) {
-		desc_to_use = &hw->cmq.csq.desc[hw->cmq.csq.next_to_use];
-		*desc_to_use = desc[handle];
-		(hw->cmq.csq.next_to_use)++;
-		if (hw->cmq.csq.next_to_use >= hw->cmq.csq.desc_num)
-			hw->cmq.csq.next_to_use = 0;
-		handle++;
-	}
+
+	hclge_cmd_copy_desc(hw, desc, num);
 
 	/* Write to hardware */
 	hclge_write_dev(hw, HCLGE_NIC_CSQ_TAIL_REG, hw->cmq.csq.next_to_use);
 
-	/**
-	 * If the command is sync, wait for the firmware to write back,
-	 * if multi descriptors to be sent, use the first one to check
-	 */
-	if (HCLGE_SEND_SYNC(le16_to_cpu(desc->flag))) {
-		do {
-			if (hclge_cmd_csq_done(hw)) {
-				complete = true;
-				break;
-			}
-			udelay(1);
-			timeout++;
-		} while (timeout < hw->cmq.tx_timeout);
-	}
-
-	if (!complete)
-		retval = -EBADE;
-	else
-		retval = hclge_cmd_check_retval(hw, desc, num, ntc);
-
-	/* Clean the command send queue */
-	handle = hclge_cmd_csq_clean(hw);
-	if (handle < 0)
-		retval = handle;
-	else if (handle != num)
-		dev_warn(&hdev->pdev->dev,
-			 "cleaned %d, need to clean %d\n", handle, num);
+	ret = hclge_cmd_check_result(hw, desc, num, ntc);
 
 	spin_unlock_bh(&hw->cmq.csq.lock);
 
-	return retval;
+	return ret;
 }
 
 static void hclge_set_default_capability(struct hclge_dev *hdev)
-- 
2.25.1

