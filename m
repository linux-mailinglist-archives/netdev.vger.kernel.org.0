Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3037D7D422
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfHAD6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:58:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729786AbfHAD6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:58:01 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 82BC4E3B6AD18570666C;
        Thu,  1 Aug 2019 11:57:56 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: clear reset interrupt status in hclge_irq_handle()
Date:   Thu, 1 Aug 2019 11:55:44 +0800
Message-ID: <1564631745-36733-12-git-send-email-tanhuazhong@huawei.com>
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

Currently, the reset interrupt is cleared in the reset task, which
is too late. Since, when the hardware finish the previous reset,
it can begin to do a new global/IMP reset, if this new coming reset
type is same as the previous one, the driver will clear them together,
then driver can not get that there is another reset, but the hardware
still wait for the driver to deal with the second one.

So this patch clears PF's reset interrupt status in the
hclge_irq_handle(), the hardware waits for handshaking from
driver before doing reset, so the driver and hardware deal with reset
one by one.

BTW, when VF doing global/IMP reset, it reads PF's reset interrupt
register to get that whether PF driver's re-initialization is done,
since VF's re-initialization should be done after PF's. So we add
a new command and a register bit to do that. When VF receive reset
interrupt, it sets up this bit, and PF finishes re-initialization
send command to clear this bit, then VF do re-initialization.

Fixes: 4ed340ab8f49 ("net: hns3: Add reset process in hclge_main")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  8 +++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 34 ++++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 29 +++++++++++-------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  3 ++
 4 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 63cf9a7..dade20a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -86,6 +86,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_QUERY_PF_RSRC		= 0x0023,
 	HCLGE_OPC_QUERY_VF_RSRC		= 0x0024,
 	HCLGE_OPC_GET_CFG_PARAM		= 0x0025,
+	HCLGE_OPC_PF_RST_DONE		= 0x0026,
 
 	HCLGE_OPC_STATS_64_BIT		= 0x0030,
 	HCLGE_OPC_STATS_32_BIT		= 0x0031,
@@ -878,6 +879,13 @@ struct hclge_reset_cmd {
 	u8 rsv[22];
 };
 
+#define HCLGE_PF_RESET_DONE_BIT		BIT(0)
+
+struct hclge_pf_rst_done_cmd {
+	u8 pf_rst_done;
+	u8 rsv[23];
+};
+
 #define HCLGE_CMD_SERDES_SERIAL_INNER_LOOP_B	BIT(0)
 #define HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B	BIT(2)
 #define HCLGE_CMD_SERDES_DONE_B			BIT(0)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index abe4cee..c4841c3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2876,10 +2876,15 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 		break;
 	}
 
-	/* clear the source of interrupt if it is not cause by reset */
+	hclge_clear_event_cause(hdev, event_cause, clearval);
+
+	/* Enable interrupt if it is not cause by reset. And when
+	 * clearval equal to 0, it means interrupt status may be
+	 * cleared by hardware before driver reads status register.
+	 * For this case, vector0 interrupt also should be enabled.
+	 */
 	if (!clearval ||
 	    event_cause == HCLGE_VECTOR0_EVENT_MBX) {
-		hclge_clear_event_cause(hdev, event_cause, clearval);
 		hclge_enable_vector(&hdev->misc_vector, true);
 	}
 
@@ -3253,7 +3258,13 @@ static void hclge_clear_reset_cause(struct hclge_dev *hdev)
 	if (!clearval)
 		return;
 
-	hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG, clearval);
+	/* For revision 0x20, the reset interrupt source
+	 * can only be cleared after hardware reset done
+	 */
+	if (hdev->pdev->revision == 0x20)
+		hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG,
+				clearval);
+
 	hclge_enable_vector(&hdev->misc_vector, true);
 }
 
@@ -3374,6 +3385,18 @@ static bool hclge_reset_err_handle(struct hclge_dev *hdev)
 	return false;
 }
 
+static int hclge_set_rst_done(struct hclge_dev *hdev)
+{
+	struct hclge_pf_rst_done_cmd *req;
+	struct hclge_desc desc;
+
+	req = (struct hclge_pf_rst_done_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PF_RST_DONE, false);
+	req->pf_rst_done |= HCLGE_PF_RESET_DONE_BIT;
+
+	return hclge_cmd_send(&hdev->hw, &desc, 1);
+}
+
 static int hclge_reset_prepare_up(struct hclge_dev *hdev)
 {
 	int ret = 0;
@@ -3384,6 +3407,11 @@ static int hclge_reset_prepare_up(struct hclge_dev *hdev)
 	case HNAE3_FLR_RESET:
 		ret = hclge_set_all_vf_rst(hdev, false);
 		break;
+	case HNAE3_GLOBAL_RESET:
+		/* fall through */
+	case HNAE3_IMP_RESET:
+		ret = hclge_set_rst_done(hdev);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 340d89e..ce82b2b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1396,19 +1396,22 @@ static int hclgevf_reset_wait(struct hclgevf_dev *hdev)
 	u32 val;
 	int ret;
 
-	/* wait to check the hardware reset completion status */
-	val = hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING);
-	dev_info(&hdev->pdev->dev, "checking vf resetting status: %x\n", val);
-
 	if (hdev->reset_type == HNAE3_FLR_RESET)
 		return hclgevf_flr_poll_timeout(hdev,
 						HCLGEVF_RESET_WAIT_US,
 						HCLGEVF_RESET_WAIT_CNT);
-
-	ret = readl_poll_timeout(hdev->hw.io_base + HCLGEVF_RST_ING, val,
-				 !(val & HCLGEVF_RST_ING_BITS),
-				 HCLGEVF_RESET_WAIT_US,
-				 HCLGEVF_RESET_WAIT_TIMEOUT_US);
+	else if (hdev->reset_type == HNAE3_VF_RESET)
+		ret = readl_poll_timeout(hdev->hw.io_base +
+					 HCLGEVF_VF_RST_ING, val,
+					 !(val & HCLGEVF_VF_RST_ING_BIT),
+					 HCLGEVF_RESET_WAIT_US,
+					 HCLGEVF_RESET_WAIT_TIMEOUT_US);
+	else
+		ret = readl_poll_timeout(hdev->hw.io_base +
+					 HCLGEVF_RST_ING, val,
+					 !(val & HCLGEVF_RST_ING_BITS),
+					 HCLGEVF_RESET_WAIT_US,
+					 HCLGEVF_RESET_WAIT_TIMEOUT_US);
 
 	/* hardware completion status should be available by this time */
 	if (ret) {
@@ -1886,7 +1889,7 @@ static void hclgevf_clear_event_cause(struct hclgevf_dev *hdev, u32 regclr)
 static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 						      u32 *clearval)
 {
-	u32 cmdq_src_reg, rst_ing_reg;
+	u32 val, cmdq_src_reg, rst_ing_reg;
 
 	/* fetch the events from their corresponding regs */
 	cmdq_src_reg = hclgevf_read_dev(&hdev->hw,
@@ -1902,6 +1905,12 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 		cmdq_src_reg &= ~BIT(HCLGEVF_VECTOR0_RST_INT_B);
 		*clearval = cmdq_src_reg;
 		hdev->rst_stats.vf_rst_cnt++;
+		/* set up VF hardware reset status, its PF will clear
+		 * this status when PF has initialized done.
+		 */
+		val = hclgevf_read_dev(&hdev->hw, HCLGEVF_VF_RST_ING);
+		hclgevf_write_dev(&hdev->hw, HCLGEVF_VF_RST_ING,
+				  val | HCLGEVF_VF_RST_ING_BIT);
 		return HCLGEVF_VECTOR0_EVENT_RST;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 5a9e309..f0736b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -103,6 +103,9 @@
 	(HCLGEVF_FUN_RST_ING_BIT | HCLGEVF_GLOBAL_RST_ING_BIT | \
 	 HCLGEVF_CORE_RST_ING_BIT | HCLGEVF_IMP_RST_ING_BIT)
 
+#define HCLGEVF_VF_RST_ING		0x07008
+#define HCLGEVF_VF_RST_ING_BIT		BIT(16)
+
 #define HCLGEVF_RSS_IND_TBL_SIZE		512
 #define HCLGEVF_RSS_SET_BITMAP_MSK	0xffff
 #define HCLGEVF_RSS_KEY_SIZE		40
-- 
2.7.4

