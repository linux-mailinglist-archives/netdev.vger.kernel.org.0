Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBAC35FFEB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhDOCVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:21:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16463 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhDOCVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:21:07 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FLNLB3Z0yzwS2l;
        Thu, 15 Apr 2021 10:18:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 10:20:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH RESEND net-next 2/2] net: hns3: VF not request link status when PF support push link status feature
Date:   Thu, 15 Apr 2021 10:20:39 +0800
Message-ID: <1618453239-10451-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618453239-10451-1-git-send-email-tanhuazhong@huawei.com>
References: <1618453239-10451-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

To reduce the processing of unnecessary mailbox command when PF supports
actively push its link status to VFs, VFs stop sending request link
status command in periodic service task in this case.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 8 +++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  | 6 ++++++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 07aa26b..07066c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2340,10 +2340,11 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 	if (!(hdev->serv_processed_cnt % HCLGEVF_STATS_TIMER_INTERVAL))
 		hclgevf_tqps_update_stats(handle);
 
-	/* request the link status from the PF. PF would be able to tell VF
-	 * about such updates in future so we might remove this later
+	/* VF does not need to request link status when this bit is set, because
+	 * PF will push its link status to VFs when link status changed.
 	 */
-	hclgevf_request_link_info(hdev);
+	if (!test_bit(HCLGEVF_STATE_PF_PUSH_LINK_STATUS, &hdev->state))
+		hclgevf_request_link_info(hdev);
 
 	hclgevf_update_link_mode(hdev);
 
@@ -2657,6 +2658,7 @@ static int hclgevf_ae_start(struct hnae3_handle *handle)
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
 	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
+	clear_bit(HCLGEVF_STATE_PF_PUSH_LINK_STATUS, &hdev->state);
 
 	hclgevf_reset_tqp_stats(handle);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index ade6e7f..956095b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -152,6 +152,7 @@ enum hclgevf_states {
 	HCLGEVF_STATE_LINK_UPDATING,
 	HCLGEVF_STATE_PROMISC_CHANGED,
 	HCLGEVF_STATE_RST_FAIL,
+	HCLGEVF_STATE_PF_PUSH_LINK_STATUS,
 };
 
 struct hclgevf_mac {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 5b2dcd9..9b17735 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -276,6 +276,7 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 	u8 duplex;
 	u32 speed;
 	u32 tail;
+	u8 flag;
 	u8 idx;
 
 	/* we can safely clear it now as we are at start of the async message
@@ -300,11 +301,16 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			link_status = msg_q[1];
 			memcpy(&speed, &msg_q[2], sizeof(speed));
 			duplex = (u8)msg_q[4];
+			flag = (u8)msg_q[5];
 
 			/* update upper layer with new link link status */
 			hclgevf_update_link_status(hdev, link_status);
 			hclgevf_update_speed_duplex(hdev, speed, duplex);
 
+			if (flag & HCLGE_MBX_PUSH_LINK_STATUS_EN)
+				set_bit(HCLGEVF_STATE_PF_PUSH_LINK_STATUS,
+					&hdev->state);
+
 			break;
 		case HCLGE_MBX_LINK_STAT_MODE:
 			idx = (u8)msg_q[1];
-- 
2.7.4

