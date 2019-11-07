Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B33F2440
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbfKGB3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:29:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728129AbfKGB3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 20:29:53 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3161EDFB9257EB2A553C;
        Thu,  7 Nov 2019 09:29:51 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 7 Nov 2019 09:29:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net] net: hns3: add compatible handling for command HCLGE_OPC_PF_RST_DONE
Date:   Thu, 7 Nov 2019 09:30:19 +0800
Message-ID: <1573090219-9785-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since old firmware does not support HCLGE_OPC_PF_RST_DONE, it will
return -EOPNOTSUPP to the driver when received this command. So
for this case, it should just print a warning and return success
to the caller.

Fixes: 72e2fb07997c ("net: hns3: clear reset interrupt status in hclge_irq_handle()")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e02e01b..16f7d0e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3587,12 +3587,28 @@ static int hclge_set_rst_done(struct hclge_dev *hdev)
 {
 	struct hclge_pf_rst_done_cmd *req;
 	struct hclge_desc desc;
+	int ret;
 
 	req = (struct hclge_pf_rst_done_cmd *)desc.data;
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_PF_RST_DONE, false);
 	req->pf_rst_done |= HCLGE_PF_RESET_DONE_BIT;
 
-	return hclge_cmd_send(&hdev->hw, &desc, 1);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	/* To be compatible with the old firmware, which does not support
+	 * command HCLGE_OPC_PF_RST_DONE, just print a warning and
+	 * return success
+	 */
+	if (ret == -EOPNOTSUPP) {
+		dev_warn(&hdev->pdev->dev,
+			 "current firmware does not support command(0x%x)!\n",
+			 HCLGE_OPC_PF_RST_DONE);
+		return 0;
+	} else if (ret) {
+		dev_err(&hdev->pdev->dev, "assert PF reset done fail %d!\n",
+			ret);
+	}
+
+	return ret;
 }
 
 static int hclge_reset_prepare_up(struct hclge_dev *hdev)
-- 
2.7.4

