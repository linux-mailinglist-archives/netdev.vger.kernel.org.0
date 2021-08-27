Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FEA3F9710
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244727AbhH0JdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:33:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8787 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244737AbhH0JdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:33:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GwvcF3ZX7zYsXP;
        Fri, 27 Aug 2021 17:31:41 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/8] net: hns3: package new functions to simplify hclgevf_mbx_handler code
Date:   Fri, 27 Aug 2021 17:28:22 +0800
Message-ID: <1630056504-31725-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
References: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch packages two new function to simplify the function
hclgevf_mbx_handler, and it can reduce the code cycle complexity
and make code more concise.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   | 103 +++++++++++----------
 1 file changed, 55 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 46d06e1d04f9..fdc66fae0960 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -155,15 +155,66 @@ static bool hclgevf_cmd_crq_empty(struct hclgevf_hw *hw)
 	return tail == hw->cmq.crq.next_to_use;
 }
 
+static void hclgevf_handle_mbx_response(struct hclgevf_dev *hdev,
+					struct hclge_mbx_pf_to_vf_cmd *req)
+{
+	struct hclgevf_mbx_resp_status *resp = &hdev->mbx_resp;
+
+	if (resp->received_resp)
+		dev_warn(&hdev->pdev->dev,
+			 "VF mbx resp flag not clear(%u)\n",
+			 req->msg.vf_mbx_msg_code);
+
+	resp->origin_mbx_msg =
+			(req->msg.vf_mbx_msg_code << 16);
+	resp->origin_mbx_msg |= req->msg.vf_mbx_msg_subcode;
+	resp->resp_status =
+		hclgevf_resp_to_errno(req->msg.resp_status);
+	memcpy(resp->additional_info, req->msg.resp_data,
+	       HCLGE_MBX_MAX_RESP_DATA_SIZE * sizeof(u8));
+	if (req->match_id) {
+		/* If match_id is not zero, it means PF support match_id.
+		 * if the match_id is right, VF get the right response, or
+		 * ignore the response. and driver will clear hdev->mbx_resp
+		 * when send next message which need response.
+		 */
+		if (req->match_id == resp->match_id)
+			resp->received_resp = true;
+	} else {
+		resp->received_resp = true;
+	}
+}
+
+static void hclgevf_handle_mbx_msg(struct hclgevf_dev *hdev,
+				   struct hclge_mbx_pf_to_vf_cmd *req)
+{
+	/* we will drop the async msg if we find ARQ as full
+	 * and continue with next message
+	 */
+	if (atomic_read(&hdev->arq.count) >=
+	    HCLGE_MBX_MAX_ARQ_MSG_NUM) {
+		dev_warn(&hdev->pdev->dev,
+			 "Async Q full, dropping msg(%u)\n",
+			 req->msg.code);
+		return;
+	}
+
+	/* tail the async message in arq */
+	memcpy(hdev->arq.msg_q[hdev->arq.tail], &req->msg,
+	       HCLGE_MBX_MAX_ARQ_MSG_SIZE * sizeof(u16));
+	hclge_mbx_tail_ptr_move_arq(hdev->arq);
+	atomic_inc(&hdev->arq.count);
+
+	hclgevf_mbx_task_schedule(hdev);
+}
+
 void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 {
-	struct hclgevf_mbx_resp_status *resp;
 	struct hclge_mbx_pf_to_vf_cmd *req;
 	struct hclgevf_cmq_ring *crq;
 	struct hclgevf_desc *desc;
 	u16 flag;
 
-	resp = &hdev->mbx_resp;
 	crq = &hdev->hw.cmq.crq;
 
 	while (!hclgevf_cmd_crq_empty(&hdev->hw)) {
@@ -197,58 +248,14 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		 */
 		switch (req->msg.code) {
 		case HCLGE_MBX_PF_VF_RESP:
-			if (resp->received_resp)
-				dev_warn(&hdev->pdev->dev,
-					 "VF mbx resp flag not clear(%u)\n",
-					 req->msg.vf_mbx_msg_code);
-			resp->received_resp = true;
-
-			resp->origin_mbx_msg =
-					(req->msg.vf_mbx_msg_code << 16);
-			resp->origin_mbx_msg |= req->msg.vf_mbx_msg_subcode;
-			resp->resp_status =
-				hclgevf_resp_to_errno(req->msg.resp_status);
-
-			memcpy(resp->additional_info, req->msg.resp_data,
-			       HCLGE_MBX_MAX_RESP_DATA_SIZE * sizeof(u8));
-
-			/* If match_id is not zero, it means PF support
-			 * match_id. If the match_id is right, VF get the
-			 * right response, otherwise ignore the response.
-			 * Driver will clear hdev->mbx_resp when send
-			 * next message which need response.
-			 */
-			if (req->match_id) {
-				if (req->match_id == resp->match_id)
-					resp->received_resp = true;
-			} else {
-				resp->received_resp = true;
-			}
+			hclgevf_handle_mbx_response(hdev, req);
 			break;
 		case HCLGE_MBX_LINK_STAT_CHANGE:
 		case HCLGE_MBX_ASSERTING_RESET:
 		case HCLGE_MBX_LINK_STAT_MODE:
 		case HCLGE_MBX_PUSH_VLAN_INFO:
 		case HCLGE_MBX_PUSH_PROMISC_INFO:
-			/* we will drop the async msg if we find ARQ as full
-			 * and continue with next message
-			 */
-			if (atomic_read(&hdev->arq.count) >=
-			    HCLGE_MBX_MAX_ARQ_MSG_NUM) {
-				dev_warn(&hdev->pdev->dev,
-					 "Async Q full, dropping msg(%u)\n",
-					 req->msg.code);
-				break;
-			}
-
-			/* tail the async message in arq */
-			memcpy(hdev->arq.msg_q[hdev->arq.tail], &req->msg,
-			       HCLGE_MBX_MAX_ARQ_MSG_SIZE * sizeof(u16));
-			hclge_mbx_tail_ptr_move_arq(hdev->arq);
-			atomic_inc(&hdev->arq.count);
-
-			hclgevf_mbx_task_schedule(hdev);
-
+			hclgevf_handle_mbx_msg(hdev, req);
 			break;
 		default:
 			dev_err(&hdev->pdev->dev,
-- 
2.8.1

