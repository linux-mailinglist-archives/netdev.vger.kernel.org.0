Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9EA86FC8
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404787AbfHICtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:49:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48888 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729476AbfHICtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:49:24 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E46D8D91BFA54964D24E;
        Fri,  9 Aug 2019 10:33:31 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: fix interrupt clearing error for VF
Date:   Fri, 9 Aug 2019 10:31:08 +0800
Message-ID: <1565317878-31806-3-git-send-email-tanhuazhong@huawei.com>
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

Currently, VF driver has two kinds of interrupts, reset & CMDQ RX.
For revision 0x21, according to the UM, each interrupt should be
cleared by write 0 to the corresponding bit, but the implementation
writes 0 to the whole register in fact, it will clear other
interrupt at the same time, then the VF will loss the interrupt.
But for revision 0x20, this interrupt clear register is a read &
write register, for compatible, we just keep the old implementation
for 0x20.

This patch fixes it, also, adds a new register for reading the interrupt
status according to hardware user manual.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Fixes: b90fcc5bd904 ("net: hns3: add reset handling for VF when doing Core/Global/IMP reset")

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 28 +++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  2 ++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ce82b2b..d8b8281 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1889,21 +1889,20 @@ static void hclgevf_clear_event_cause(struct hclgevf_dev *hdev, u32 regclr)
 static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 						      u32 *clearval)
 {
-	u32 val, cmdq_src_reg, rst_ing_reg;
+	u32 val, cmdq_stat_reg, rst_ing_reg;
 
 	/* fetch the events from their corresponding regs */
-	cmdq_src_reg = hclgevf_read_dev(&hdev->hw,
-					HCLGEVF_VECTOR0_CMDQ_SRC_REG);
+	cmdq_stat_reg = hclgevf_read_dev(&hdev->hw,
+					 HCLGEVF_VECTOR0_CMDQ_STAT_REG);
 
-	if (BIT(HCLGEVF_VECTOR0_RST_INT_B) & cmdq_src_reg) {
+	if (BIT(HCLGEVF_VECTOR0_RST_INT_B) & cmdq_stat_reg) {
 		rst_ing_reg = hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING);
 		dev_info(&hdev->pdev->dev,
 			 "receive reset interrupt 0x%x!\n", rst_ing_reg);
 		set_bit(HNAE3_VF_RESET, &hdev->reset_pending);
 		set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 		set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
-		cmdq_src_reg &= ~BIT(HCLGEVF_VECTOR0_RST_INT_B);
-		*clearval = cmdq_src_reg;
+		*clearval = ~(1U << HCLGEVF_VECTOR0_RST_INT_B);
 		hdev->rst_stats.vf_rst_cnt++;
 		/* set up VF hardware reset status, its PF will clear
 		 * this status when PF has initialized done.
@@ -1915,9 +1914,20 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 	}
 
 	/* check for vector0 mailbox(=CMDQ RX) event source */
-	if (BIT(HCLGEVF_VECTOR0_RX_CMDQ_INT_B) & cmdq_src_reg) {
-		cmdq_src_reg &= ~BIT(HCLGEVF_VECTOR0_RX_CMDQ_INT_B);
-		*clearval = cmdq_src_reg;
+	if (BIT(HCLGEVF_VECTOR0_RX_CMDQ_INT_B) & cmdq_stat_reg) {
+		/* for revision 0x21, clearing interrupt is writing bit 0
+		 * to the clear register, writing bit 1 means to keep the
+		 * old value.
+		 * for revision 0x20, the clear register is a read & write
+		 * register, so we should just write 0 to the bit we are
+		 * handling, and keep other bits as cmdq_stat_reg.
+		 */
+		if (hdev->pdev->revision >= 0x21)
+			*clearval = ~(1U << HCLGEVF_VECTOR0_RX_CMDQ_INT_B);
+		else
+			*clearval = cmdq_stat_reg &
+				    ~BIT(HCLGEVF_VECTOR0_RX_CMDQ_INT_B);
+
 		return HCLGEVF_VECTOR0_EVENT_MBX;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index f0736b0..4ccf107 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -87,6 +87,8 @@
 
 /* Vector0 interrupt CMDQ event source register(RW) */
 #define HCLGEVF_VECTOR0_CMDQ_SRC_REG	0x27100
+/* Vector0 interrupt CMDQ event status register(RO) */
+#define HCLGEVF_VECTOR0_CMDQ_STAT_REG	0x27104
 /* CMDQ register bits for RX event(=MBX event) */
 #define HCLGEVF_VECTOR0_RX_CMDQ_INT_B	1
 /* RST register bits for RESET event */
-- 
2.7.4

