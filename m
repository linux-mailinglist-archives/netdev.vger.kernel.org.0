Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DC73531FC
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 03:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhDCBgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 21:36:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15471 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbhDCBgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 21:36:41 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FBzx15RhvzyN3l;
        Sat,  3 Apr 2021 09:34:29 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.74.55) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Sat, 3 Apr 2021 09:36:30 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH net 2/2] net: hns3: Remove un-necessary 'else-if' in the hclge_reset_event()
Date:   Sat, 3 Apr 2021 02:35:20 +0100
Message-ID: <20210403013520.22108-3-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
In-Reply-To: <20210403013520.22108-1-salil.mehta@huawei.com>
References: <20210403013520.22108-1-salil.mehta@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.74.55]
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
index 7ad0722383f5..2ed464e13d1b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3981,7 +3981,9 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
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

