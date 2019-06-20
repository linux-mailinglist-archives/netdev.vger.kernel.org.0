Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFE44CA06
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731776AbfFTIzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:55:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19048 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731448AbfFTIyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:36 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 80133515E186C54A14E1;
        Thu, 20 Jun 2019 16:54:33 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/11] net: hns3: add exception handling when enable NIC HW error interrupts
Date:   Thu, 20 Jun 2019 16:52:45 +0800
Message-ID: <1561020765-14481-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

If we failed to enable NIC HW error interrupts during client
initialization in some cases, we should do exception handling to clear
flags and free the resources.

Fixes: 00ea6e5fda9d ("net: hns3: delay and separate enabling of NIC and ROCE HW errors")
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b0a99c3..b25365c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8297,13 +8297,15 @@ static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 		goto init_nic_err;
 	}
 
-	hnae3_set_client_init_flag(client, ae_dev, 1);
-
 	/* Enable nic hw error interrupts */
 	ret = hclge_config_nic_hw_error(hdev, true);
-	if (ret)
+	if (ret) {
 		dev_err(&ae_dev->pdev->dev,
 			"fail(%d) to enable hw error interrupts\n", ret);
+		goto init_nic_err;
+	}
+
+	hnae3_set_client_init_flag(client, ae_dev, 1);
 
 	if (netif_msg_drv(&hdev->vport->nic))
 		hclge_info_show(hdev);
-- 
2.7.4

