Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1417D42A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfHAD6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:58:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3689 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729784AbfHAD56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:57:58 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 88576F82D78B676EA873;
        Thu,  1 Aug 2019 11:57:56 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 1 Aug 2019 11:57:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: simplify hclge_cmd_query_error()
Date:   Thu, 1 Aug 2019 11:55:41 +0800
Message-ID: <1564631745-36733-9-git-send-email-tanhuazhong@huawei.com>
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

From: Weihang Li <liweihang@hisilicon.com>

The 4th and 5th parameter of hclge_cmd_query_error is useless, so this
patch removes them.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c    | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 0a72438..05a4cdb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -652,16 +652,11 @@ static void hclge_log_error(struct device *dev, char *reg,
  * @desc: descriptor for describing the command
  * @cmd:  command opcode
  * @flag: flag for extended command structure
- * @w_num: offset for setting the read interrupt type.
- * @int_type: select which type of the interrupt for which the error
- * info will be read(RAS-CE/RAS-NFE/RAS-FE etc).
  *
  * This function query the error info from hw register/s using command
  */
 static int hclge_cmd_query_error(struct hclge_dev *hdev,
-				 struct hclge_desc *desc, u32 cmd,
-				 u16 flag, u8 w_num,
-				 enum hclge_err_int_type int_type)
+				 struct hclge_desc *desc, u32 cmd, u16 flag)
 {
 	struct device *dev = &hdev->pdev->dev;
 	int desc_num = 1;
@@ -673,8 +668,6 @@ static int hclge_cmd_query_error(struct hclge_dev *hdev,
 		hclge_cmd_setup_basic_desc(&desc[1], cmd, true);
 		desc_num = 2;
 	}
-	if (w_num)
-		desc[0].data[w_num] = cpu_to_le32(int_type);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc[0], desc_num);
 	if (ret)
@@ -872,8 +865,7 @@ static int hclge_config_tm_hw_err_int(struct hclge_dev *hdev, bool en)
 	}
 
 	/* configure TM QCN hw errors */
-	ret = hclge_cmd_query_error(hdev, &desc, HCLGE_TM_QCN_MEM_INT_CFG,
-				    0, 0, 0);
+	ret = hclge_cmd_query_error(hdev, &desc, HCLGE_TM_QCN_MEM_INT_CFG, 0);
 	if (ret) {
 		dev_err(dev, "fail(%d) to read TM QCN CFG status\n", ret);
 		return ret;
@@ -1410,7 +1402,7 @@ static int hclge_log_rocee_ecc_error(struct hclge_dev *hdev)
 
 	ret = hclge_cmd_query_error(hdev, &desc[0],
 				    HCLGE_QUERY_ROCEE_ECC_RAS_INFO_CMD,
-				    HCLGE_CMD_FLAG_NEXT, 0, 0);
+				    HCLGE_CMD_FLAG_NEXT);
 	if (ret) {
 		dev_err(dev, "failed(%d) to query ROCEE ECC error sts\n", ret);
 		return ret;
@@ -1434,7 +1426,7 @@ static int hclge_log_rocee_ovf_error(struct hclge_dev *hdev)
 
 	/* read overflow error status */
 	ret = hclge_cmd_query_error(hdev, &desc[0], HCLGE_ROCEE_PF_RAS_INT_CMD,
-				    0, 0, 0);
+				    0);
 	if (ret) {
 		dev_err(dev, "failed(%d) to query ROCEE OVF error sts\n", ret);
 		return ret;
@@ -1483,8 +1475,7 @@ hclge_log_and_clear_rocee_ras_error(struct hclge_dev *hdev)
 
 	/* read RAS error interrupt status */
 	ret = hclge_cmd_query_error(hdev, &desc[0],
-				    HCLGE_QUERY_CLEAR_ROCEE_RAS_INT,
-				    0, 0, 0);
+				    HCLGE_QUERY_CLEAR_ROCEE_RAS_INT, 0);
 	if (ret) {
 		dev_err(dev, "failed(%d) to query ROCEE RAS INT SRC\n", ret);
 		/* reset everything for now */
-- 
2.7.4

