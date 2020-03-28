Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A90F196410
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 08:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgC1HK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 03:10:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35100 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbgC1HK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 03:10:56 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 870DFD21A1FDC62E4E5C;
        Sat, 28 Mar 2020 15:10:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Mar 2020 15:10:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 4/4] net: hns3: fix set and get link ksettings issue
Date:   Sat, 28 Mar 2020 15:09:58 +0800
Message-ID: <1585379398-36224-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
References: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

When device is not open, the service task which update the port
information per second is not running. In this case, the port
capabilities, including speed ability, autoneg ability, media type,
may be incorrect. Then get/set link ksetting may fail.

This patch fixes it by updating the port information before getting/
setting link ksettings when device is not open, and start timer
task immediately by setting delay time to 0 when device opens.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b351807..0e03c3a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6765,7 +6765,7 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 	struct hclge_dev *hdev = vport->back;
 
 	if (enable) {
-		hclge_task_schedule(hdev, round_jiffies_relative(HZ));
+		hclge_task_schedule(hdev, 0);
 	} else {
 		/* Set the DOWN flag here to disable link updating */
 		set_bit(HCLGE_STATE_DOWN, &hdev->state);
@@ -8979,6 +8979,12 @@ static void hclge_get_media_type(struct hnae3_handle *handle, u8 *media_type,
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
+	/* When nic is down, the service task is not running, doesn't update
+	 * the port information per second. Query the port information before
+	 * return the media type, ensure getting the correct media information.
+	 */
+	hclge_update_port_info(hdev);
+
 	if (media_type)
 		*media_type = hdev->hw.mac.media_type;
 
-- 
2.7.4

