Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CFC32678
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 04:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfFCCLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 22:11:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726921AbfFCCLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 22:11:02 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D70414A3C23838B1B565;
        Mon,  3 Jun 2019 10:11:00 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 3 Jun 2019 10:10:52 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 09/10] net: hns3: add opcode about query and clear RAS & MSI-X to special opcode
Date:   Mon, 3 Jun 2019 10:09:21 +0800
Message-ID: <1559527762-22931-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
References: <1559527762-22931-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

There are four commands being used to query and clear RAS and MSI-X
interrupts status. They should be contained in array of special opcodes
because these commands have several descriptors, and we need to judge
return value in the first descriptor rather than the last one as other
opcodes. In addition, we shouldn't set the NEXT_FLAG of first descriptor.

This patch fixes above issues.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 16 ----------------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index e532905..7a3bde7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -173,7 +173,11 @@ static bool hclge_is_special_opcode(u16 opcode)
 			     HCLGE_OPC_STATS_MAC,
 			     HCLGE_OPC_STATS_MAC_ALL,
 			     HCLGE_OPC_QUERY_32_BIT_REG,
-			     HCLGE_OPC_QUERY_64_BIT_REG};
+			     HCLGE_OPC_QUERY_64_BIT_REG,
+			     HCLGE_QUERY_CLEAR_MPF_RAS_INT,
+			     HCLGE_QUERY_CLEAR_PF_RAS_INT,
+			     HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT,
+			     HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT};
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(spec_opcode); i++) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 83b07ce..b4a7e6a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1098,8 +1098,6 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 	/* query all main PF RAS errors */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_QUERY_CLEAR_MPF_RAS_INT,
 				   true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
 	if (ret) {
 		dev_err(dev, "query all mpf ras int cmd failed (%d)\n", ret);
@@ -1262,8 +1260,6 @@ static int hclge_handle_mpf_ras_error(struct hclge_dev *hdev,
 
 	/* clear all main PF RAS errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
 	if (ret)
 		dev_err(dev, "clear all mpf ras int cmd failed (%d)\n", ret);
@@ -1293,8 +1289,6 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 	/* query all PF RAS errors */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_QUERY_CLEAR_PF_RAS_INT,
 				   true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
 	if (ret) {
 		dev_err(dev, "query all pf ras int cmd failed (%d)\n", ret);
@@ -1348,8 +1342,6 @@ static int hclge_handle_pf_ras_error(struct hclge_dev *hdev,
 
 	/* clear all PF RAS errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], num);
 	if (ret)
 		dev_err(dev, "clear all pf ras int cmd failed (%d)\n", ret);
@@ -1667,8 +1659,6 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 	/* query all main PF MSIx errors */
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT,
 				   true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], mpf_bd_num);
 	if (ret) {
 		dev_err(dev, "query all mpf msix int cmd failed (%d)\n",
@@ -1700,8 +1690,6 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 
 	/* clear all main PF MSIx errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], mpf_bd_num);
 	if (ret) {
 		dev_err(dev, "clear all mpf msix int cmd failed (%d)\n",
@@ -1713,8 +1701,6 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 	memset(desc, 0, bd_num * sizeof(struct hclge_desc));
 	hclge_cmd_setup_basic_desc(&desc[0], HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT,
 				   true);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], pf_bd_num);
 	if (ret) {
 		dev_err(dev, "query all pf msix int cmd failed (%d)\n",
@@ -1753,8 +1739,6 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 
 	/* clear all PF MSIx errors */
 	hclge_cmd_reuse_desc(&desc[0], false);
-	desc[0].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], pf_bd_num);
 	if (ret) {
 		dev_err(dev, "clear all pf msix int cmd failed (%d)\n",
-- 
2.7.4

