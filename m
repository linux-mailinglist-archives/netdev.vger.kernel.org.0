Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E51F3F9716
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244903AbhH0Jda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:33:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9372 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244750AbhH0JdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:33:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GwvX90DvWz8vgP;
        Fri, 27 Aug 2021 17:28:09 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [PATCH net-next 4/8] net: hns3: use memcpy to simplify code
Date:   Fri, 27 Aug 2021 17:28:20 +0800
Message-ID: <1630056504-31725-5-git-send-email-huangguangbin2@huawei.com>
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

Use memcpy to copy req->msg.resp_data to resp->additional_info,
to simplify the code and improve a little efficiency.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 50309506bb60..d42e2715ab6c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -163,8 +163,6 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 	struct hclgevf_desc *desc;
 	u16 *msg_q;
 	u16 flag;
-	u8 *temp;
-	int i;
 
 	resp = &hdev->mbx_resp;
 	crq = &hdev->hw.cmq.crq;
@@ -212,11 +210,8 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 			resp->resp_status =
 				hclgevf_resp_to_errno(req->msg.resp_status);
 
-			temp = (u8 *)req->msg.resp_data;
-			for (i = 0; i < HCLGE_MBX_MAX_RESP_DATA_SIZE; i++) {
-				resp->additional_info[i] = *temp;
-				temp++;
-			}
+			memcpy(resp->additional_info, req->msg.resp_data,
+			       HCLGE_MBX_MAX_RESP_DATA_SIZE * sizeof(u8));
 
 			/* If match_id is not zero, it means PF support
 			 * match_id. If the match_id is right, VF get the
-- 
2.8.1

