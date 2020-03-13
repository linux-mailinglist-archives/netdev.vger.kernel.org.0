Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74435184282
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 09:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCMIY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 04:24:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38218 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgCMIY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 04:24:28 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BF70989F9F3AB0862FD1;
        Fri, 13 Mar 2020 16:24:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 13 Mar 2020 16:24:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/2] net: hns3: add a conversion for mailbox's response code
Date:   Fri, 13 Mar 2020 16:23:42 +0800
Message-ID: <1584087823-61800-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584087823-61800-1-git-send-email-tanhuazhong@huawei.com>
References: <1584087823-61800-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, when mailbox handling fails, the PF driver
just responds 1 to the VF driver. It is not sufficient
for the VF driver to find out why its mailbox fails.

So the error should be responded to VF, but the error
is type int and the response field in struct
hclge_mbx_pf_to_vf_cmd is type u16, a conversion is
needed.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c   | 16 +++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c |  7 ++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 3d850f6..b5dcbc6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -5,6 +5,11 @@
 #include "hclge_mbx.h"
 #include "hnae3.h"
 
+static u16 hclge_errno_to_resp(int errno)
+{
+	return abs(errno);
+}
+
 /* hclge_gen_resp_to_vf: used to generate a synchronous response to VF when PF
  * receives a mailbox message from VF.
  * @vport: pointer to struct hclge_vport
@@ -21,6 +26,7 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 	struct hclge_dev *hdev = vport->back;
 	enum hclge_cmd_status status;
 	struct hclge_desc desc;
+	u16 resp;
 
 	resp_pf_to_vf = (struct hclge_mbx_pf_to_vf_cmd *)desc.data;
 
@@ -43,7 +49,15 @@ static int hclge_gen_resp_to_vf(struct hclge_vport *vport,
 	resp_pf_to_vf->msg[0] = HCLGE_MBX_PF_VF_RESP;
 	resp_pf_to_vf->msg[1] = vf_to_pf_req->msg[0];
 	resp_pf_to_vf->msg[2] = vf_to_pf_req->msg[1];
-	resp_pf_to_vf->msg[3] = (resp_status == 0) ? 0 : 1;
+	resp = hclge_errno_to_resp(resp_status);
+	if (resp < SHRT_MAX) {
+		resp_pf_to_vf->msg[3] = resp;
+	} else {
+		dev_err(&hdev->pdev->dev,
+			"failed to send response to VF, response status %d is out-of-bound\n",
+			resp);
+		return -EINVAL;
+	}
 
 	if (resp_data && resp_data_len > 0)
 		memcpy(&resp_pf_to_vf->msg[4], resp_data, resp_data_len);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 7cbd715..5b481f9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -5,6 +5,11 @@
 #include "hclgevf_main.h"
 #include "hnae3.h"
 
+static int hclgevf_resp_to_errno(u16 resp_code)
+{
+	return resp_code ? -resp_code : 0;
+}
+
 static void hclgevf_reset_mbx_resp_status(struct hclgevf_dev *hdev)
 {
 	/* this function should be called with mbx_resp.mbx_mutex held
@@ -193,7 +198,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 
 			resp->origin_mbx_msg = (req->msg[1] << 16);
 			resp->origin_mbx_msg |= req->msg[2];
-			resp->resp_status = req->msg[3];
+			resp->resp_status = hclgevf_resp_to_errno(req->msg[3]);
 
 			temp = (u8 *)&req->msg[4];
 			for (i = 0; i < HCLGE_MBX_MAX_RESP_DATA_SIZE; i++) {
-- 
2.7.4

