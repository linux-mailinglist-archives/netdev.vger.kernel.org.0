Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0485F9A2
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfGDOGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:06:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8704 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727576AbfGDOGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 10:06:41 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0AFFA5B9C1AEE576C324;
        Thu,  4 Jul 2019 22:06:27 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 4 Jul 2019 22:06:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/9] net: hns3: add all IMP return code
Date:   Thu, 4 Jul 2019 22:04:23 +0800
Message-ID: <1562249068-40176-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
References: <1562249068-40176-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Currently, the HNS3 driver just defines part of IMP return code,
This patch supplements all the remaining IMP return code, and adds
a function to convert this code to the error number.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 43 +++++++++++++++++-----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  8 ++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 38 ++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   | 14 +++++--
 4 files changed, 85 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 667c3be..22f6acd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -188,12 +188,43 @@ static bool hclge_is_special_opcode(u16 opcode)
 	return false;
 }
 
+static int hclge_cmd_convert_err_code(u16 desc_ret)
+{
+	switch (desc_ret) {
+	case HCLGE_CMD_EXEC_SUCCESS:
+		return 0;
+	case HCLGE_CMD_NO_AUTH:
+		return -EPERM;
+	case HCLGE_CMD_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case HCLGE_CMD_QUEUE_FULL:
+		return -EXFULL;
+	case HCLGE_CMD_NEXT_ERR:
+		return -ENOSR;
+	case HCLGE_CMD_UNEXE_ERR:
+		return -ENOTBLK;
+	case HCLGE_CMD_PARA_ERR:
+		return -EINVAL;
+	case HCLGE_CMD_RESULT_ERR:
+		return -ERANGE;
+	case HCLGE_CMD_TIMEOUT:
+		return -ETIME;
+	case HCLGE_CMD_HILINK_ERR:
+		return -ENOLINK;
+	case HCLGE_CMD_QUEUE_ILLEGAL:
+		return -ENXIO;
+	case HCLGE_CMD_INVALID:
+		return -EBADR;
+	default:
+		return -EIO;
+	}
+}
+
 static int hclge_cmd_check_retval(struct hclge_hw *hw, struct hclge_desc *desc,
 				  int num, int ntc)
 {
 	u16 opcode, desc_ret;
 	int handle;
-	int retval;
 
 	opcode = le16_to_cpu(desc[0].opcode);
 	for (handle = 0; handle < num; handle++) {
@@ -207,17 +238,9 @@ static int hclge_cmd_check_retval(struct hclge_hw *hw, struct hclge_desc *desc,
 	else
 		desc_ret = le16_to_cpu(desc[0].retval);
 
-	if (desc_ret == HCLGE_CMD_EXEC_SUCCESS)
-		retval = 0;
-	else if (desc_ret == HCLGE_CMD_NO_AUTH)
-		retval = -EPERM;
-	else if (desc_ret == HCLGE_CMD_NOT_SUPPORTED)
-		retval = -EOPNOTSUPP;
-	else
-		retval = -EIO;
 	hw->cmq.last_status = desc_ret;
 
-	return retval;
+	return hclge_cmd_convert_err_code(desc_ret);
 }
 
 /**
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index d23ab2b..96840d8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -41,6 +41,14 @@ enum hclge_cmd_return_status {
 	HCLGE_CMD_NO_AUTH	= 1,
 	HCLGE_CMD_NOT_SUPPORTED	= 2,
 	HCLGE_CMD_QUEUE_FULL	= 3,
+	HCLGE_CMD_NEXT_ERR	= 4,
+	HCLGE_CMD_UNEXE_ERR	= 5,
+	HCLGE_CMD_PARA_ERR	= 6,
+	HCLGE_CMD_RESULT_ERR	= 7,
+	HCLGE_CMD_TIMEOUT	= 8,
+	HCLGE_CMD_HILINK_ERR	= 9,
+	HCLGE_CMD_QUEUE_ILLEGAL	= 10,
+	HCLGE_CMD_INVALID	= 11,
 };
 
 enum hclge_cmd_status {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 31db6d6..652b796 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -177,6 +177,38 @@ void hclgevf_cmd_setup_basic_desc(struct hclgevf_desc *desc,
 		desc->flag &= cpu_to_le16(~HCLGEVF_CMD_FLAG_WR);
 }
 
+static int hclgevf_cmd_convert_err_code(u16 desc_ret)
+{
+	switch (desc_ret) {
+	case HCLGEVF_CMD_EXEC_SUCCESS:
+		return 0;
+	case HCLGEVF_CMD_NO_AUTH:
+		return -EPERM;
+	case HCLGEVF_CMD_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case HCLGEVF_CMD_QUEUE_FULL:
+		return -EXFULL;
+	case HCLGEVF_CMD_NEXT_ERR:
+		return -ENOSR;
+	case HCLGEVF_CMD_UNEXE_ERR:
+		return -ENOTBLK;
+	case HCLGEVF_CMD_PARA_ERR:
+		return -EINVAL;
+	case HCLGEVF_CMD_RESULT_ERR:
+		return -ERANGE;
+	case HCLGEVF_CMD_TIMEOUT:
+		return -ETIME;
+	case HCLGEVF_CMD_HILINK_ERR:
+		return -ENOLINK;
+	case HCLGEVF_CMD_QUEUE_ILLEGAL:
+		return -ENXIO;
+	case HCLGEVF_CMD_INVALID:
+		return -EBADR;
+	default:
+		return -EIO;
+	}
+}
+
 /* hclgevf_cmd_send - send command to command queue
  * @hw: pointer to the hw struct
  * @desc: prefilled descriptor for describing the command
@@ -259,11 +291,7 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 			else
 				retval = le16_to_cpu(desc[0].retval);
 
-			if ((enum hclgevf_cmd_return_status)retval ==
-			    HCLGEVF_CMD_EXEC_SUCCESS)
-				status = 0;
-			else
-				status = -EIO;
+			status = hclgevf_cmd_convert_err_code(retval);
 			hw->cmq.last_status = (enum hclgevf_cmd_status)retval;
 			ntc++;
 			handle++;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 47030b4..127a434 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -46,9 +46,17 @@ struct hclgevf_cmq_ring {
 
 enum hclgevf_cmd_return_status {
 	HCLGEVF_CMD_EXEC_SUCCESS	= 0,
-	HCLGEVF_CMD_NO_AUTH	= 1,
-	HCLGEVF_CMD_NOT_EXEC	= 2,
-	HCLGEVF_CMD_QUEUE_FULL	= 3,
+	HCLGEVF_CMD_NO_AUTH		= 1,
+	HCLGEVF_CMD_NOT_SUPPORTED	= 2,
+	HCLGEVF_CMD_QUEUE_FULL		= 3,
+	HCLGEVF_CMD_NEXT_ERR		= 4,
+	HCLGEVF_CMD_UNEXE_ERR		= 5,
+	HCLGEVF_CMD_PARA_ERR		= 6,
+	HCLGEVF_CMD_RESULT_ERR		= 7,
+	HCLGEVF_CMD_TIMEOUT		= 8,
+	HCLGEVF_CMD_HILINK_ERR		= 9,
+	HCLGEVF_CMD_QUEUE_ILLEGAL	= 10,
+	HCLGEVF_CMD_INVALID		= 11,
 };
 
 enum hclgevf_cmd_status {
-- 
2.7.4

