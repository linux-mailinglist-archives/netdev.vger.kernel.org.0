Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EBA3198B1
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhBLDWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:22:32 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12512 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhBLDW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:22:27 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DcJfC5RFLzjMHk;
        Fri, 12 Feb 2021 11:20:19 +0800 (CST)
Received: from SZA170332453E.china.huawei.com (10.46.104.160) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Feb 2021 11:21:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 01/13] net: hns3: refactor out hclge_cmd_convert_err_code()
Date:   Fri, 12 Feb 2021 11:21:01 +0800
Message-ID: <20210212032113.5384-2-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210212032113.5384-1-tanhuazhong@huawei.com>
References: <20210212032113.5384-1-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.46.104.160]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

To improve code readability and maintainability, refactor
hclge_cmd_convert_err_code() with an array of imp_errcode
and common_errno mapping, instead of a bloated switch/case.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 55 +++++++++----------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 6546b47bef88..cb2c955ce52c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -189,36 +189,35 @@ static bool hclge_is_special_opcode(u16 opcode)
 	return false;
 }
 
+struct errcode {
+	u32 imp_errcode;
+	int common_errno;
+};
+
 static int hclge_cmd_convert_err_code(u16 desc_ret)
 {
-	switch (desc_ret) {
-	case HCLGE_CMD_EXEC_SUCCESS:
-		return 0;
-	case HCLGE_CMD_NO_AUTH:
-		return -EPERM;
-	case HCLGE_CMD_NOT_SUPPORTED:
-		return -EOPNOTSUPP;
-	case HCLGE_CMD_QUEUE_FULL:
-		return -EXFULL;
-	case HCLGE_CMD_NEXT_ERR:
-		return -ENOSR;
-	case HCLGE_CMD_UNEXE_ERR:
-		return -ENOTBLK;
-	case HCLGE_CMD_PARA_ERR:
-		return -EINVAL;
-	case HCLGE_CMD_RESULT_ERR:
-		return -ERANGE;
-	case HCLGE_CMD_TIMEOUT:
-		return -ETIME;
-	case HCLGE_CMD_HILINK_ERR:
-		return -ENOLINK;
-	case HCLGE_CMD_QUEUE_ILLEGAL:
-		return -ENXIO;
-	case HCLGE_CMD_INVALID:
-		return -EBADR;
-	default:
-		return -EIO;
-	}
+	struct errcode hclge_cmd_errcode[] = {
+		{HCLGE_CMD_EXEC_SUCCESS, 0},
+		{HCLGE_CMD_NO_AUTH, -EPERM},
+		{HCLGE_CMD_NOT_SUPPORTED, -EOPNOTSUPP},
+		{HCLGE_CMD_QUEUE_FULL, -EXFULL},
+		{HCLGE_CMD_NEXT_ERR, -ENOSR},
+		{HCLGE_CMD_UNEXE_ERR, -ENOTBLK},
+		{HCLGE_CMD_PARA_ERR, -EINVAL},
+		{HCLGE_CMD_RESULT_ERR, -ERANGE},
+		{HCLGE_CMD_TIMEOUT, -ETIME},
+		{HCLGE_CMD_HILINK_ERR, -ENOLINK},
+		{HCLGE_CMD_QUEUE_ILLEGAL, -ENXIO},
+		{HCLGE_CMD_INVALID, -EBADR},
+	};
+	u32 errcode_count = ARRAY_SIZE(hclge_cmd_errcode);
+	u32 i;
+
+	for (i = 0; i < errcode_count; i++)
+		if (hclge_cmd_errcode[i].imp_errcode == desc_ret)
+			return hclge_cmd_errcode[i].common_errno;
+
+	return -EIO;
 }
 
 static int hclge_cmd_check_retval(struct hclge_hw *hw, struct hclge_desc *desc,
-- 
2.25.1

