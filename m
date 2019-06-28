Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040015997A
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 13:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfF1Lwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 07:52:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726957AbfF1LwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 07:52:16 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0EF133EF71519E55BB0D;
        Fri, 28 Jun 2019 19:52:11 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 19:52:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: optimize the CSQ cmd error handling
Date:   Fri, 28 Jun 2019 19:50:18 +0800
Message-ID: <1561722618-12168-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

If CMDQ ring is full, hclge_cmd_send may return directly, but IMP still
working and HW pointer changed, SW ring pointer do not match the HW
pointer. This patch update the SW pointer every time when the space is
full, so it can work normally next time if IMP and HW still working.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c    | 15 ++++++++++++---
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c  | 19 ++++++++++++++-----
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 7a3bde7..667c3be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -232,6 +232,7 @@ static int hclge_cmd_check_retval(struct hclge_hw *hw, struct hclge_desc *desc,
 int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 {
 	struct hclge_dev *hdev = container_of(hw, struct hclge_dev, hw);
+	struct hclge_cmq_ring *csq = &hw->cmq.csq;
 	struct hclge_desc *desc_to_use;
 	bool complete = false;
 	u32 timeout = 0;
@@ -241,8 +242,16 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 
 	spin_lock_bh(&hw->cmq.csq.lock);
 
-	if (num > hclge_ring_space(&hw->cmq.csq) ||
-	    test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state)) {
+	if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state)) {
+		spin_unlock_bh(&hw->cmq.csq.lock);
+		return -EBUSY;
+	}
+
+	if (num > hclge_ring_space(&hw->cmq.csq)) {
+		/* If CMDQ ring is full, SW HEAD and HW HEAD may be different,
+		 * need update the SW HEAD pointer csq->next_to_clean
+		 */
+		csq->next_to_clean = hclge_read_dev(hw, HCLGE_NIC_CSQ_HEAD_REG);
 		spin_unlock_bh(&hw->cmq.csq.lock);
 		return -EBUSY;
 	}
@@ -280,7 +289,7 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 	}
 
 	if (!complete) {
-		retval = -EAGAIN;
+		retval = -EBADE;
 	} else {
 		retval = hclge_cmd_check_retval(hw, desc, num, ntc);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index e1588c0..31db6d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -188,6 +188,7 @@ void hclgevf_cmd_setup_basic_desc(struct hclgevf_desc *desc,
 int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 {
 	struct hclgevf_dev *hdev = (struct hclgevf_dev *)hw->hdev;
+	struct hclgevf_cmq_ring *csq = &hw->cmq.csq;
 	struct hclgevf_desc *desc_to_use;
 	bool complete = false;
 	u32 timeout = 0;
@@ -199,8 +200,17 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 
 	spin_lock_bh(&hw->cmq.csq.lock);
 
-	if (num > hclgevf_ring_space(&hw->cmq.csq) ||
-	    test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state)) {
+	if (test_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state)) {
+		spin_unlock_bh(&hw->cmq.csq.lock);
+		return -EBUSY;
+	}
+
+	if (num > hclgevf_ring_space(&hw->cmq.csq)) {
+		/* If CMDQ ring is full, SW HEAD and HW HEAD may be different,
+		 * need update the SW HEAD pointer csq->next_to_clean
+		 */
+		csq->next_to_clean = hclgevf_read_dev(hw,
+						      HCLGEVF_NIC_CSQ_HEAD_REG);
 		spin_unlock_bh(&hw->cmq.csq.lock);
 		return -EBUSY;
 	}
@@ -263,14 +273,13 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 	}
 
 	if (!complete)
-		status = -EAGAIN;
+		status = -EBADE;
 
 	/* Clean the command send queue */
 	handle = hclgevf_cmd_csq_clean(hw);
-	if (handle != num) {
+	if (handle != num)
 		dev_warn(&hdev->pdev->dev,
 			 "cleaned %d, need to clean %d\n", handle, num);
-	}
 
 	spin_unlock_bh(&hw->cmq.csq.lock);
 
-- 
2.7.4

