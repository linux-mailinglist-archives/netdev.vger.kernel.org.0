Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0143877CB
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 13:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242209AbhERLhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 07:37:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3582 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbhERLhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 07:37:33 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fkv5P5jShzsRmG;
        Tue, 18 May 2021 19:33:29 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:14 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 19:36:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 1/4] net: hns3: fix incorrect resp_msg issue
Date:   Tue, 18 May 2021 19:36:00 +0800
Message-ID: <1621337763-61946-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
References: <1621337763-61946-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

In hclge_mbx_handler(), if there are two consecutive mailbox
messages that requires resp_msg, the resp_msg is not cleared
after processing the first message, which will cause the resp_msg
data of second message incorrect.

Fix it by clearing the resp_msg before processing every mailbox
message.

Fixes: bb5790b71bad ("net: hns3: refactor mailbox response scheme between PF and VF")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 8e5f9dc..f1c9f4a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -710,7 +710,6 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 	unsigned int flag;
 	int ret = 0;
 
-	memset(&resp_msg, 0, sizeof(resp_msg));
 	/* handle all the mailbox requests in the queue */
 	while (!hclge_cmd_crq_empty(&hdev->hw)) {
 		if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state)) {
@@ -738,6 +737,9 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 
 		trace_hclge_pf_mbx_get(hdev, req);
 
+		/* clear the resp_msg before processing every mailbox message */
+		memset(&resp_msg, 0, sizeof(resp_msg));
+
 		switch (req->msg.code) {
 		case HCLGE_MBX_MAP_RING_TO_VECTOR:
 			ret = hclge_map_unmap_ring_to_vf_vector(vport, true,
-- 
2.7.4

