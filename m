Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FAC7D42E
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbfHAD62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:58:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39556 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729837AbfHAD57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:59 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B0B05C60DECD380EE615;
        Thu,  1 Aug 2019 11:57:56 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/12] net: hns3: fix some reset handshake issue
Date:   Thu, 1 Aug 2019 11:55:43 +0800
Message-ID: <1564631745-36733-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
References: <1564631745-36733-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the driver sets handshake status to tell the hardware
that the driver have downed the netdev and it can continue with
reset process. The driver will clear the handshake status when
re-initializing the CMDQ, and does not recover this status
when reset fail, which may cause the hardware to wait for
the handshake status to be set and not being able to continue
with reset process.

So this patch delays clearing handshake status just before UP,
and recovers this status when reset fail.

BTW, this patch adds a new function hclge(vf)_reset_handshake() to
deal with the reset handshake issue, and renames
HCLGE(VF)_NIC_CMQ_ENABLE to HCLGE(VF)_NIC_SW_RST_RDY which
represents this register bit more accurately.

Fixes: ada13ee3db7b ("net: hns3: add handshake with hardware while doing reset")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  7 +++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  7 +++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 23 ++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  4 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  7 +++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 31 +++++++++++++++++-----
 6 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index c20b972..ecf58cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -103,14 +103,17 @@ static void hclge_cmd_config_regs(struct hclge_cmq_ring *ring)
 	dma_addr_t dma = ring->desc_dma_addr;
 	struct hclge_dev *hdev = ring->dev;
 	struct hclge_hw *hw = &hdev->hw;
+	u32 reg_val;
 
 	if (ring->ring_type == HCLGE_TYPE_CSQ) {
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_BASEADDR_L_REG,
 				lower_32_bits(dma));
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_BASEADDR_H_REG,
 				upper_32_bits(dma));
-		hclge_write_dev(hw, HCLGE_NIC_CSQ_DEPTH_REG,
-				ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S);
+		reg_val = hclge_read_dev(hw, HCLGE_NIC_CSQ_DEPTH_REG);
+		reg_val &= HCLGE_NIC_SW_RST_RDY;
+		reg_val |= ring->desc_num >> HCLGE_NIC_CMQ_DESC_NUM_S;
+		hclge_write_dev(hw, HCLGE_NIC_CSQ_DEPTH_REG, reg_val);
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_HEAD_REG, 0);
 		hclge_write_dev(hw, HCLGE_NIC_CSQ_TAIL_REG, 0);
 	} else {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index cfa77dd..63cf9a7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -907,8 +907,11 @@ struct hclge_serdes_lb_cmd {
 #define HCLGE_NIC_CRQ_DEPTH_REG		0x27020
 #define HCLGE_NIC_CRQ_TAIL_REG		0x27024
 #define HCLGE_NIC_CRQ_HEAD_REG		0x27028
-#define HCLGE_NIC_CMQ_EN_B		16
-#define HCLGE_NIC_CMQ_ENABLE		BIT(HCLGE_NIC_CMQ_EN_B)
+
+/* this bit indicates that the driver is ready for hardware reset */
+#define HCLGE_NIC_SW_RST_RDY_B		16
+#define HCLGE_NIC_SW_RST_RDY		BIT(HCLGE_NIC_SW_RST_RDY_B)
+
 #define HCLGE_NIC_CMQ_DESC_NUM		1024
 #define HCLGE_NIC_CMQ_DESC_NUM_S	3
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4317c8f..abe4cee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3274,6 +3274,19 @@ static int hclge_reset_prepare_down(struct hclge_dev *hdev)
 	return ret;
 }
 
+static void hclge_reset_handshake(struct hclge_dev *hdev, bool enable)
+{
+	u32 reg_val;
+
+	reg_val = hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG);
+	if (enable)
+		reg_val |= HCLGE_NIC_SW_RST_RDY;
+	else
+		reg_val &= ~HCLGE_NIC_SW_RST_RDY;
+
+	hclge_write_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG, reg_val);
+}
+
 static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 {
 #define HCLGE_RESET_SYNC_TIME 100
@@ -3322,8 +3335,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 
 	/* inform hardware that preparatory work is done */
 	msleep(HCLGE_RESET_SYNC_TIME);
-	hclge_write_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG,
-			HCLGE_NIC_CMQ_ENABLE);
+	hclge_reset_handshake(hdev, true);
 	dev_info(&hdev->pdev->dev, "prepare wait ok\n");
 
 	return ret;
@@ -3354,6 +3366,10 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 	}
 
 	hclge_clear_reset_cause(hdev);
+
+	/* recover the handshake status when reset fail */
+	hclge_reset_handshake(hdev, true);
+
 	dev_err(&hdev->pdev->dev, "Reset fail!\n");
 	return false;
 }
@@ -3372,6 +3388,9 @@ static int hclge_reset_prepare_up(struct hclge_dev *hdev)
 		break;
 	}
 
+	/* clear up the handshake status after re-initialize done */
+	hclge_reset_handshake(hdev, false);
+
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 8f21eb3..55d3c78 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -97,7 +97,9 @@ static void hclgevf_cmd_config_regs(struct hclgevf_cmq_ring *ring)
 		reg_val = (u32)((ring->desc_dma_addr >> 31) >> 1);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_H_REG, reg_val);
 
-		reg_val = (ring->desc_num >> HCLGEVF_NIC_CMQ_DESC_NUM_S);
+		reg_val = hclgevf_read_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG);
+		reg_val &= HCLGEVF_NIC_SW_RST_RDY;
+		reg_val |= (ring->desc_num >> HCLGEVF_NIC_CMQ_DESC_NUM_S);
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG, reg_val);
 
 		hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG, 0);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 127a434..f830eef 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -244,8 +244,11 @@ struct hclgevf_cfg_tx_queue_pointer_cmd {
 #define HCLGEVF_NIC_CRQ_DEPTH_REG	0x27020
 #define HCLGEVF_NIC_CRQ_TAIL_REG	0x27024
 #define HCLGEVF_NIC_CRQ_HEAD_REG	0x27028
-#define HCLGEVF_NIC_CMQ_EN_B		16
-#define HCLGEVF_NIC_CMQ_ENABLE		BIT(HCLGEVF_NIC_CMQ_EN_B)
+
+/* this bit indicates that the driver is ready for hardware reset */
+#define HCLGEVF_NIC_SW_RST_RDY_B	16
+#define HCLGEVF_NIC_SW_RST_RDY		BIT(HCLGEVF_NIC_SW_RST_RDY_B)
+
 #define HCLGEVF_NIC_CMQ_DESC_NUM	1024
 #define HCLGEVF_NIC_CMQ_DESC_NUM_S	3
 #define HCLGEVF_NIC_CMDQ_INT_SRC_REG	0x27100
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ae0e6a6..340d89e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1426,6 +1426,20 @@ static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 	return 0;
 }
 
+static void hclgevf_reset_handshake(struct hclgevf_dev *hdev, bool enable)
+{
+	u32 reg_val;
+
+	reg_val = hclgevf_read_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG);
+	if (enable)
+		reg_val |= HCLGEVF_NIC_SW_RST_RDY;
+	else
+		reg_val &= ~HCLGEVF_NIC_SW_RST_RDY;
+
+	hclgevf_write_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG,
+			  reg_val);
+}
+
 static int hclgevf_reset_stack(struct hclgevf_dev *hdev)
 {
 	int ret;
@@ -1448,7 +1462,14 @@ static int hclgevf_reset_stack(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
-	return hclgevf_notify_client(hdev, HNAE3_RESTORE_CLIENT);
+	ret = hclgevf_notify_client(hdev, HNAE3_RESTORE_CLIENT);
+	if (ret)
+		return ret;
+
+	/* clear handshake status with IMP */
+	hclgevf_reset_handshake(hdev, false);
+
+	return 0;
 }
 
 static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
@@ -1474,8 +1495,7 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
 	/* inform hardware that preparatory work is done */
 	msleep(HCLGEVF_RESET_SYNC_TIME);
-	hclgevf_write_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG,
-			  HCLGEVF_NIC_CMQ_ENABLE);
+	hclgevf_reset_handshake(hdev, true);
 	dev_info(&hdev->pdev->dev, "prepare reset(%d) wait done, ret:%d\n",
 		 hdev->reset_type, ret);
 
@@ -1484,6 +1504,8 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 
 static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 {
+	/* recover handshake status with IMP when reset fail */
+	hclgevf_reset_handshake(hdev, true);
 	hdev->rst_stats.rst_fail_cnt++;
 	dev_err(&hdev->pdev->dev, "failed to reset VF(%d)\n",
 		hdev->rst_stats.rst_fail_cnt);
@@ -1494,9 +1516,6 @@ static void hclgevf_reset_err_handle(struct hclgevf_dev *hdev)
 	if (hclgevf_is_reset_pending(hdev)) {
 		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 		hclgevf_reset_task_schedule(hdev);
-	} else {
-		hclgevf_write_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG,
-				  HCLGEVF_NIC_CMQ_ENABLE);
 	}
 }
 
-- 
2.7.4

