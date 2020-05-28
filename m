Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92641E613F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389915AbgE1MrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:47:05 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5365 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389864AbgE1Mqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 08:46:49 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 39562BCE9ACB898CEFC3;
        Thu, 28 May 2020 20:46:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 20:46:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/11] net: hns3: refactor hclge_query_bd_num_cmd_send()
Date:   Thu, 28 May 2020 20:45:04 +0800
Message-ID: <1590669912-21867-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
References: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to improve code maintainability and readability, rewrite
the process of BDs' initialization in hclge_query_bd_num_cmd_send().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 21ad23e..6c84413 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10725,16 +10725,19 @@ static int hclge_get_64_bit_regs(struct hclge_dev *hdev, u32 regs_num,
 
 int hclge_query_bd_num_cmd_send(struct hclge_dev *hdev, struct hclge_desc *desc)
 {
-	/*prepare 4 commands to query DFX BD number*/
-	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_OPC_DFX_BD_NUM, true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_OPC_DFX_BD_NUM, true);
-	desc[1].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[2], HCLGE_OPC_DFX_BD_NUM, true);
-	desc[2].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-	hclge_cmd_setup_basic_desc(&desc[3], HCLGE_OPC_DFX_BD_NUM, true);
+	int i;
+
+	/* initialize command BD except the last one */
+	for (i = 0; i < HCLGE_GET_DFX_REG_TYPE_CNT - 1; i++) {
+		hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_DFX_BD_NUM,
+					   true);
+		desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+	}
+
+	/* initialize the last command BD */
+	hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_DFX_BD_NUM, true);
 
-	return hclge_cmd_send(&hdev->hw, desc, 4);
+	return hclge_cmd_send(&hdev->hw, desc, HCLGE_GET_DFX_REG_TYPE_CNT);
 }
 
 static int hclge_get_dfx_reg_bd_num(struct hclge_dev *hdev,
-- 
2.7.4

