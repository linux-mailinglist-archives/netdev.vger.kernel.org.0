Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5516E2C279
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfE1JFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:05:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17615 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727488AbfE1JEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:41 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 61BEE4B246610A3D1FE3;
        Tue, 28 May 2019 17:04:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 09/12] net: hns3: add handshake with hardware while doing reset
Date:   Tue, 28 May 2019 17:02:59 +0800
Message-ID: <1559034182-24737-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When reset happens, the hardware reset should begin after the
driver has finished its preparatory work, otherwise it may cause
some hardware error.

Before Hardware's reset, it will wait for the driver to write
bit HCLGE_NIC_CMQ_ENABLE of register HCLGE_NIC_CSQ_DEPTH_REG
to 1, while the driver finishes its preparatory work will do that.
BTW, since some cases this register will be cleared, so it needs
some sync time before driver's writing.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c    |  6 ++----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 10 ++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c  |  2 --
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |  7 ++++++-
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index fbd904e..e532905 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -110,8 +110,7 @@ static void hclge_cmd_config_regs(struct hclge_cmq_ring *ring)
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_BASEADDR_H_REG,
 				upper_32_bits(dma));
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_DEPTH_REG,
-				(ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S) |
-				HCLGE_NIC_CMQ_ENABLE);
+				ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S);
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_HEAD_REG, 0);
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_TAIL_REG, 0);
 	} else {
@@ -120,8 +119,7 @@ static void hclge_cmd_config_regs(struct hclge_cmq_ring *ring)
 		hclge_write_dev(hw, HCLGE_NIC_CRQ_BASEADDR_H_REG,
 				upper_32_bits(dma));
 		hclge_write_dev(hw, HCLGE_NIC_CRQ_DEPTH_REG,
-				(ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S) |
-				HCLGE_NIC_CMQ_ENABLE);
+				ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S);
 		hclge_write_dev(hw, HCLGE_NIC_CRQ_HEAD_REG, 0);
 		hclge_write_dev(hw, HCLGE_NIC_CRQ_TAIL_REG, 0);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b7106a5..a563815 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3197,6 +3197,8 @@ static int hclge_reset_prepare_down(struct hclge_dev *hdev)
 
 static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 {
+#define HCLGE_RESET_SYNC_TIME 100
+
 	u32 reg_val;
 	int ret = 0;
 
@@ -3205,7 +3207,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		/* There is no mechanism for PF to know if VF has stopped IO
 		 * for now, just wait 100 ms for VF to stop IO
 		 */
-		msleep(100);
+		msleep(HCLGE_RESET_SYNC_TIME);
 		ret = hclge_func_reset_cmd(hdev, 0);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
@@ -3225,7 +3227,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		/* There is no mechanism for PF to know if VF has stopped IO
 		 * for now, just wait 100 ms for VF to stop IO
 		 */
-		msleep(100);
+		msleep(HCLGE_RESET_SYNC_TIME);
 		set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 		set_bit(HNAE3_FLR_DOWN, &hdev->flr_state);
 		hdev->rst_stats.flr_rst_cnt++;
@@ -3239,6 +3241,10 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		break;
 	}
 
+	/* inform hardware that preparatory work is done */
+	msleep(HCLGE_RESET_SYNC_TIME);
+	hclge_write_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG,
+			HCLGE_NIC_CMQ_ENABLE);
 	dev_info(&hdev->pdev->dev, "prepare wait ok\n");
 
 	return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 71f356f..e1588c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -98,7 +98,6 @@ static void hclgevf_cmd_config_regs(struct hclgevf_cmq_ring *ring)
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_H_REG, reg_val);
 
 		reg_val = (ring->desc_num >> HCLGEVF_NIC_CMQ_DESC_NUM_S);
-		reg_val |= HCLGEVF_NIC_CMQ_ENABLE;
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG, reg_val);
 
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG, 0);
@@ -110,7 +109,6 @@ static void hclgevf_cmd_config_regs(struct hclgevf_cmq_ring *ring)
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_BASEADDR_H_REG, reg_val);
 
 		reg_val = (ring->desc_num >> HCLGEVF_NIC_CMQ_DESC_NUM_S);
-		reg_val |= HCLGEVF_NIC_CMQ_ENABLE;
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_DEPTH_REG, reg_val);
 
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_HEAD_REG, 0);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 9d5a4f8..ee1eeca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1414,6 +1414,8 @@ static int hclgevf_reset_stack(struct hclgevf_dev *hdev)
 
 static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 {
+#define HCLGEVF_RESET_SYNC_TIME 100
+
 	int ret = 0;
 
 	switch (hdev->reset_type) {
@@ -1431,7 +1433,10 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 	}
 
 	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
-
+	/* inform hardware that preparatory work is done */
+	msleep(HCLGEVF_RESET_SYNC_TIME);
+	hclgevf_write_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG,
+			  HCLGEVF_NIC_CMQ_ENABLE);
 	dev_info(&hdev->pdev->dev, "prepare reset(%d) wait done, ret:%d\n",
 		 hdev->reset_type, ret);
 
-- 
2.7.4

