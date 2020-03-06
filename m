Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267AD17B4B1
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 03:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCFC6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 21:58:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38318 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727030AbgCFC6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 21:58:03 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 54E717A5546791D5836E;
        Fri,  6 Mar 2020 10:57:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Mar 2020 10:57:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 6/9] net: hns3: print out status register when VF receives unknown source interrupt
Date:   Fri, 6 Mar 2020 10:57:15 +0800
Message-ID: <1583463438-60953-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
References: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When received an unknown vector 0 interrupt, there is not a
helpful information for user to realize that now. So this patch
prints out the value of the status register for this case, and
uses dev_info() instead of dev_dbg() in hclge_check_event_cause().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index d659720..f199a23 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2002,7 +2002,10 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 		return HCLGEVF_VECTOR0_EVENT_MBX;
 	}
 
-	dev_dbg(&hdev->pdev->dev, "vector 0 interrupt from unknown source\n");
+	/* print other vector0 event source */
+	dev_info(&hdev->pdev->dev,
+		 "vector 0 interrupt from unknown source, cmdq_src = %#x\n",
+		 cmdq_stat_reg);
 
 	return HCLGEVF_VECTOR0_EVENT_OTHER;
 }
-- 
2.7.4

