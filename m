Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C23355496
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhDFNKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:10:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15138 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhDFNKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 09:10:39 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FF79X6H5BzmdGJ;
        Tue,  6 Apr 2021 21:07:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 21:10:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net] net: hns3: clear VF down state bit before request link status
Date:   Tue, 6 Apr 2021 21:10:43 +0800
Message-ID: <1617714643-25535-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Currently, the VF down state bit is cleared after VF sending
link status request command. There is problem that when VF gets
link status replied from PF, the down state bit may still set
as 1. In this case, the link status replied from PF will be
ignored and always set VF link status to down.

To fix this problem, clear VF down state bit before VF requests
link status.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 700e068..14b83ec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2624,14 +2624,14 @@ static int hclgevf_ae_start(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
+	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
+
 	hclgevf_reset_tqp_stats(handle);
 
 	hclgevf_request_link_info(hdev);
 
 	hclgevf_update_link_mode(hdev);
 
-	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
-
 	return 0;
 }
 
-- 
2.7.4

