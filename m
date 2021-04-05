Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5A83545D5
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhDERI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:08:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15546 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbhDERI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:08:26 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FDcVH6Hh1zPnfd;
        Tue,  6 Apr 2021 01:05:27 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.69.183) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 01:08:03 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH V2 net 2/2] net: hns3: Remove un-necessary 'else-if' in the hclge_reset_event()
Date:   Mon, 5 Apr 2021 18:06:45 +0100
Message-ID: <20210405170645.29620-3-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
In-Reply-To: <20210405170645.29620-1-salil.mehta@huawei.com>
References: <20210405170645.29620-1-salil.mehta@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.69.183]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code to defer the reset(which caps the frequency of the reset) schedules the
timer and returns. Hence, following 'else-if' looks un-necessary.

Fixes: 9de0b86f6444 ("net: hns3: Prevent to request reset frequently")
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 58d210bbb311..2dd2af269b46 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3980,7 +3980,9 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 				  HCLGE_RESET_INTERVAL))) {
 		mod_timer(&hdev->reset_timer, jiffies + HCLGE_RESET_INTERVAL);
 		return;
-	} else if (hdev->default_reset_request) {
+	}
+
+	if (hdev->default_reset_request) {
 		hdev->reset_level =
 			hclge_get_reset_level(ae_dev,
 					      &hdev->default_reset_request);
-- 
2.17.1

