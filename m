Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BB22608D6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgIHDCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:02:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728470AbgIHDCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:02:32 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B38739E199F4AEA5642F;
        Tue,  8 Sep 2020 11:02:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Sep 2020 11:02:19 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/7] net: hns3: skip periodic service task if reset failed
Date:   Tue, 8 Sep 2020 10:59:49 +0800
Message-ID: <1599533994-32744-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
References: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

When reset fails, if there are some pending jobs for the periodic
service task, it does not do anything except print error each
time the task is scheduled. So skip the periodic service task if
reset failed.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d553ed7..40d68a4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3944,6 +3944,9 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
 {
 	unsigned long delta = round_jiffies_relative(HZ);
 
+	if (test_bit(HCLGE_STATE_RST_FAIL, &hdev->state))
+		return;
+
 	/* Always handle the link updating to make sure link state is
 	 * updated when it is triggered by mbx.
 	 */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 20dd04c..20dd50d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2186,6 +2186,9 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 	unsigned long delta = round_jiffies_relative(HZ);
 	struct hnae3_handle *handle = &hdev->nic;
 
+	if (test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state))
+		return;
+
 	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
 		delta = jiffies - hdev->last_serv_processed;
 
-- 
2.7.4

