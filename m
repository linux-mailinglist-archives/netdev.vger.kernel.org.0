Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FA03CD063
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhGSIgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:36:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7390 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbhGSIgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:36:01 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GSx2j2nlPz7wGB;
        Mon, 19 Jul 2021 17:13:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:16:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <fengchengwen@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net 2/4] net: hns3: add match_id to check mailbox response from PF to VF
Date:   Mon, 19 Jul 2021 17:13:06 +0800
Message-ID: <1626685988-25869-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
References: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

When VF need response from PF, VF will wait (1us - 1s) to receive
the response, or it will wait timeout and the VF action fails.
If VF do not receive response in 1st action because timeout,
the 2nd action may receive response for the 1st action, and get
incorrect response data.VF must reciveve the right response from
PF,or it will cause unexpected error.

This patch adds match_id to check mailbox response from PF to VF,
to make sure VF get the right response:
1. The message sent from VF was labelled with match_id which was a
unique 16-bit non-zero value.
2. The response sent from PF will label with match_id which got from
the request.
3. The VF uses the match_id to match request and response message.

This scheme depends on PF driver supports match_id, if PF driver doesn't
support then VF will uses the original scheme.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h       |  1 +
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 56b573e47072..aa86a81c8f4a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -98,6 +98,7 @@ struct hclgevf_mbx_resp_status {
 	u32 origin_mbx_msg;
 	bool received_resp;
 	int resp_status;
+	u16 match_id;
 	u8 additional_info[HCLGE_MBX_MAX_RESP_DATA_SIZE];
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 9b17735b9f4c..772b2f8acd2e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -13,6 +13,7 @@ static int hclgevf_resp_to_errno(u16 resp_code)
 	return resp_code ? -resp_code : 0;
 }
 
+#define HCLGEVF_MBX_MATCH_ID_START	1
 static void hclgevf_reset_mbx_resp_status(struct hclgevf_dev *hdev)
 {
 	/* this function should be called with mbx_resp.mbx_mutex held
@@ -21,6 +22,10 @@ static void hclgevf_reset_mbx_resp_status(struct hclgevf_dev *hdev)
 	hdev->mbx_resp.received_resp  = false;
 	hdev->mbx_resp.origin_mbx_msg = 0;
 	hdev->mbx_resp.resp_status    = 0;
+	hdev->mbx_resp.match_id++;
+	/* Update match_id and ensure the value of match_id is not zero */
+	if (hdev->mbx_resp.match_id == 0)
+		hdev->mbx_resp.match_id = HCLGEVF_MBX_MATCH_ID_START;
 	memset(hdev->mbx_resp.additional_info, 0, HCLGE_MBX_MAX_RESP_DATA_SIZE);
 }
 
@@ -115,6 +120,7 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 	if (need_resp) {
 		mutex_lock(&hdev->mbx_resp.mbx_mutex);
 		hclgevf_reset_mbx_resp_status(hdev);
+		req->match_id = hdev->mbx_resp.match_id;
 		status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 		if (status) {
 			dev_err(&hdev->pdev->dev,
@@ -211,6 +217,19 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 				resp->additional_info[i] = *temp;
 				temp++;
 			}
+
+			/* If match_id is not zero, it means PF support
+			 * match_id. If the match_id is right, VF get the
+			 * right response, otherwise ignore the response.
+			 * Driver will clear hdev->mbx_resp when send
+			 * next message which need response.
+			 */
+			if (req->match_id) {
+				if (req->match_id == resp->match_id)
+					resp->received_resp = true;
+			} else {
+				resp->received_resp = true;
+			}
 			break;
 		case HCLGE_MBX_LINK_STAT_CHANGE:
 		case HCLGE_MBX_ASSERTING_RESET:
-- 
2.8.1

