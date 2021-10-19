Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7669F43384E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhJSOXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:23:17 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29910 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhJSOXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HYbQD54NFzbn8J;
        Tue, 19 Oct 2021 22:16:20 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 7/8] net: hns3: fix vf reset workqueue cannot exit
Date:   Tue, 19 Oct 2021 22:16:34 +0800
Message-ID: <20211019141635.43695-8-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211019141635.43695-1-huangguangbin2@huawei.com>
References: <20211019141635.43695-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The task of VF reset is performed through the workqueue. It checks the
value of hdev->reset_pending to determine whether to exit the loop.
However, the value of hdev->reset_pending may also be assigned by
the interrupt function hclgevf_misc_irq_handle(), which may cause the
loop fail to exit and keep occupying the workqueue. This loop is not
necessary, so remove it and the workqueue will be rescheduled if the
reset needs to be retried or a new reset occurs.

Fixes: 1cc9bc6e5867 ("net: hns3: split hclgevf_reset() into preparing and rebuilding part")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5fdac8685f95..bef6b98e2f50 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2273,9 +2273,9 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 		hdev->reset_attempts = 0;
 
 		hdev->last_reset_time = jiffies;
-		while ((hdev->reset_type =
-			hclgevf_get_reset_level(hdev, &hdev->reset_pending))
-		       != HNAE3_NONE_RESET)
+		hdev->reset_type =
+			hclgevf_get_reset_level(hdev, &hdev->reset_pending);
+		if (hdev->reset_type != HNAE3_NONE_RESET)
 			hclgevf_reset(hdev);
 	} else if (test_and_clear_bit(HCLGEVF_RESET_REQUESTED,
 				      &hdev->reset_state)) {
-- 
2.33.0

