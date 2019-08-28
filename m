Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0ACA04CB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfH1OZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:25:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50138 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726711AbfH1OZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 20AF8B2662C5AD952F02;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:31 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: fix incorrect type in assignment.
Date:   Wed, 28 Aug 2019 22:23:11 +0800
Message-ID: <1567002196-63242-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

This patch fixes some incorrect type in assignment reported by sparse.
Those sparse warning as below:
- warning : restricted __le16 degrades to integer
- warning : cast from restricted __le32
- warning : expected restricted __le32
- warning : cast from restricted __be32
- warning : cast from restricted __be16
- warning : cast to restricted __le16

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 38 ++++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   | 10 +++---
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 2425b3f..d986c36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -930,32 +930,44 @@ static int hclge_config_ppu_error_interrupts(struct hclge_dev *hdev, u32 cmd,
 	/* configure PPU error interrupts */
 	if (cmd == HCLGE_PPU_MPF_ECC_INT_CMD) {
 		hclge_cmd_setup_basic_desc(&desc[0], cmd, false);
-		desc[0].flag |= HCLGE_CMD_FLAG_NEXT;
+		desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
 		hclge_cmd_setup_basic_desc(&desc[1], cmd, false);
 		if (en) {
-			desc[0].data[0] = HCLGE_PPU_MPF_ABNORMAL_INT0_EN;
-			desc[0].data[1] = HCLGE_PPU_MPF_ABNORMAL_INT1_EN;
-			desc[1].data[3] = HCLGE_PPU_MPF_ABNORMAL_INT3_EN;
-			desc[1].data[4] = HCLGE_PPU_MPF_ABNORMAL_INT2_EN;
+			desc[0].data[0] =
+				cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT0_EN);
+			desc[0].data[1] =
+				cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT1_EN);
+			desc[1].data[3] =
+				cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT3_EN);
+			desc[1].data[4] =
+				cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT2_EN);
 		}
 
-		desc[1].data[0] = HCLGE_PPU_MPF_ABNORMAL_INT0_EN_MASK;
-		desc[1].data[1] = HCLGE_PPU_MPF_ABNORMAL_INT1_EN_MASK;
-		desc[1].data[2] = HCLGE_PPU_MPF_ABNORMAL_INT2_EN_MASK;
-		desc[1].data[3] |= HCLGE_PPU_MPF_ABNORMAL_INT3_EN_MASK;
+		desc[1].data[0] =
+			cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT0_EN_MASK);
+		desc[1].data[1] =
+			cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT1_EN_MASK);
+		desc[1].data[2] =
+			cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT2_EN_MASK);
+		desc[1].data[3] |=
+			cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT3_EN_MASK);
 		desc_num = 2;
 	} else if (cmd == HCLGE_PPU_MPF_OTHER_INT_CMD) {
 		hclge_cmd_setup_basic_desc(&desc[0], cmd, false);
 		if (en)
-			desc[0].data[0] = HCLGE_PPU_MPF_ABNORMAL_INT2_EN2;
+			desc[0].data[0] =
+				cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT2_EN2);
 
-		desc[0].data[2] = HCLGE_PPU_MPF_ABNORMAL_INT2_EN2_MASK;
+		desc[0].data[2] =
+			cpu_to_le32(HCLGE_PPU_MPF_ABNORMAL_INT2_EN2_MASK);
 	} else if (cmd == HCLGE_PPU_PF_OTHER_INT_CMD) {
 		hclge_cmd_setup_basic_desc(&desc[0], cmd, false);
 		if (en)
-			desc[0].data[0] = HCLGE_PPU_PF_ABNORMAL_INT_EN;
+			desc[0].data[0] =
+				cpu_to_le32(HCLGE_PPU_PF_ABNORMAL_INT_EN);
 
-		desc[0].data[2] = HCLGE_PPU_PF_ABNORMAL_INT_EN_MASK;
+		desc[0].data[2] =
+			cpu_to_le32(HCLGE_PPU_PF_ABNORMAL_INT_EN_MASK);
 	} else {
 		dev_err(dev, "Invalid cmd to configure PPU error interrupts\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 6a96987..a108191 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -277,9 +277,9 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 
 		switch (msg_q[0]) {
 		case HCLGE_MBX_LINK_STAT_CHANGE:
-			link_status = le16_to_cpu(msg_q[1]);
+			link_status = msg_q[1];
 			memcpy(&speed, &msg_q[2], sizeof(speed));
-			duplex = (u8)le16_to_cpu(msg_q[4]);
+			duplex = (u8)msg_q[4];
 
 			/* update upper layer with new link link status */
 			hclgevf_update_link_status(hdev, link_status);
@@ -287,7 +287,7 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 
 			break;
 		case HCLGE_MBX_LINK_STAT_MODE:
-			idx = (u8)le16_to_cpu(msg_q[1]);
+			idx = (u8)msg_q[1];
 			if (idx)
 				memcpy(&hdev->hw.mac.supported, &msg_q[2],
 				       sizeof(unsigned long));
@@ -301,14 +301,14 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			 * has been completely reset. After this stack should
 			 * eventually be re-initialized.
 			 */
-			reset_type = le16_to_cpu(msg_q[1]);
+			reset_type = (enum hnae3_reset_type)msg_q[1];
 			set_bit(reset_type, &hdev->reset_pending);
 			set_bit(HCLGEVF_RESET_PENDING, &hdev->reset_state);
 			hclgevf_reset_task_schedule(hdev);
 
 			break;
 		case HCLGE_MBX_PUSH_VLAN_INFO:
-			state = le16_to_cpu(msg_q[1]);
+			state = msg_q[1];
 			vlan_info = &msg_q[1];
 			hclgevf_update_port_base_vlan_info(hdev, state,
 							   (u8 *)vlan_info, 8);
-- 
2.7.4

