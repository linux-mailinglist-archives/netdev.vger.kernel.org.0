Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41797227E27
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgGULHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:07:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726715AbgGULHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:07:04 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 262E89AF6C99D8120B89;
        Tue, 21 Jul 2020 19:07:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Jul 2020 19:06:55 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong tan <tanhuazhong@huawei.com>
Subject: [PATCH net 4/4] net: hns3: fix return value error when query MAC link status fail
Date:   Tue, 21 Jul 2020 19:03:54 +0800
Message-ID: <1595329434-46766-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
References: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, PF queries the MAC link status per second by calling
function hclge_get_mac_link_status(). It return the error code
when failed to send cmdq command to firmware. It's incorrect,
because this return value is used as the MAC link status, which
0 means link down, and none-zero means link up. So fixes it.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 49 ++++++++++------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  3 ++
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d6bfdc6..bb4a632 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2673,11 +2673,10 @@ void hclge_task_schedule(struct hclge_dev *hdev, unsigned long delay_time)
 				    delay_time);
 }
 
-static int hclge_get_mac_link_status(struct hclge_dev *hdev)
+static int hclge_get_mac_link_status(struct hclge_dev *hdev, int *link_status)
 {
 	struct hclge_link_status_cmd *req;
 	struct hclge_desc desc;
-	int link_status;
 	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_LINK_STATUS, true);
@@ -2689,33 +2688,25 @@ static int hclge_get_mac_link_status(struct hclge_dev *hdev)
 	}
 
 	req = (struct hclge_link_status_cmd *)desc.data;
-	link_status = req->status & HCLGE_LINK_STATUS_UP_M;
+	*link_status = (req->status & HCLGE_LINK_STATUS_UP_M) > 0 ?
+		HCLGE_LINK_STATUS_UP : HCLGE_LINK_STATUS_DOWN;
 
-	return !!link_status;
+	return 0;
 }
 
-static int hclge_get_mac_phy_link(struct hclge_dev *hdev)
+static int hclge_get_mac_phy_link(struct hclge_dev *hdev, int *link_status)
 {
-	unsigned int mac_state;
-	int link_stat;
+	struct phy_device *phydev = hdev->hw.mac.phydev;
+
+	*link_status = HCLGE_LINK_STATUS_DOWN;
 
 	if (test_bit(HCLGE_STATE_DOWN, &hdev->state))
 		return 0;
 
-	mac_state = hclge_get_mac_link_status(hdev);
-
-	if (hdev->hw.mac.phydev) {
-		if (hdev->hw.mac.phydev->state == PHY_RUNNING)
-			link_stat = mac_state &
-				hdev->hw.mac.phydev->link;
-		else
-			link_stat = 0;
-
-	} else {
-		link_stat = mac_state;
-	}
+	if (phydev && (phydev->state != PHY_RUNNING || !phydev->link))
+		return 0;
 
-	return !!link_stat;
+	return hclge_get_mac_link_status(hdev, link_status);
 }
 
 static void hclge_update_link_status(struct hclge_dev *hdev)
@@ -2725,6 +2716,7 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	struct hnae3_handle *rhandle;
 	struct hnae3_handle *handle;
 	int state;
+	int ret;
 	int i;
 
 	if (!client)
@@ -2733,7 +2725,12 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	if (test_and_set_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state))
 		return;
 
-	state = hclge_get_mac_phy_link(hdev);
+	ret = hclge_get_mac_phy_link(hdev, &state);
+	if (ret) {
+		clear_bit(HCLGE_STATE_LINK_UPDATING, &hdev->state);
+		return;
+	}
+
 	if (state != hdev->hw.mac.link) {
 		for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
 			handle = &hdev->vport[i].nic;
@@ -6524,14 +6521,15 @@ static int hclge_mac_link_status_wait(struct hclge_dev *hdev, int link_ret)
 {
 #define HCLGE_MAC_LINK_STATUS_NUM  100
 
+	int link_status;
 	int i = 0;
 	int ret;
 
 	do {
-		ret = hclge_get_mac_link_status(hdev);
-		if (ret < 0)
+		ret = hclge_get_mac_link_status(hdev, &link_status);
+		if (ret)
 			return ret;
-		else if (ret == link_ret)
+		if (link_status == link_ret)
 			return 0;
 
 		msleep(HCLGE_LINK_STATUS_MS);
@@ -6542,9 +6540,6 @@ static int hclge_mac_link_status_wait(struct hclge_dev *hdev, int link_ret)
 static int hclge_mac_phy_link_status_wait(struct hclge_dev *hdev, bool en,
 					  bool is_phy)
 {
-#define HCLGE_LINK_STATUS_DOWN 0
-#define HCLGE_LINK_STATUS_UP   1
-
 	int link_ret;
 
 	link_ret = en ? HCLGE_LINK_STATUS_UP : HCLGE_LINK_STATUS_DOWN;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 46e6e0f..9bbdd45 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -317,6 +317,9 @@ enum hclge_link_fail_code {
 	HCLGE_LF_XSFP_ABSENT,
 };
 
+#define HCLGE_LINK_STATUS_DOWN 0
+#define HCLGE_LINK_STATUS_UP   1
+
 #define HCLGE_PG_NUM		4
 #define HCLGE_SCH_MODE_SP	0
 #define HCLGE_SCH_MODE_DWRR	1
-- 
2.7.4

