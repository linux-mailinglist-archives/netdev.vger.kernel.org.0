Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF383F866A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbhHZL1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:27:02 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15219 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241887AbhHZL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:41 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GwL9p1tjMz19VdH;
        Thu, 26 Aug 2021 19:25:18 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 3/7] net: hns3: fix speed unknown issue in bond 4
Date:   Thu, 26 Aug 2021 19:21:57 +0800
Message-ID: <1629976921-43438-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
References: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

In bond 4, when the link goes down and up repeatedly, the bond may get an
unknown speed, and then this port can not work.

The driver notify netif_carrier_on() before update the link state, when the
bond receive carrier on, will query the speed of the port, if the query
operation happens before updating the link state, will get an unknown
speed. So need to notify netif_carrier_on() after update the link state.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index ac88608a94b6..78408136f253 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2952,12 +2952,12 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	}
 
 	if (state != hdev->hw.mac.link) {
+		hdev->hw.mac.link = state;
 		client->ops->link_status_change(handle, state);
 		hclge_config_mac_tnl_int(hdev, state);
 		if (rclient && rclient->ops->link_status_change)
 			rclient->ops->link_status_change(rhandle, state);
 
-		hdev->hw.mac.link = state;
 		hclge_push_link_status(hdev);
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8784d61e833f..f25580366879 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -506,10 +506,10 @@ void hclgevf_update_link_status(struct hclgevf_dev *hdev, int link_state)
 	link_state =
 		test_bit(HCLGEVF_STATE_DOWN, &hdev->state) ? 0 : link_state;
 	if (link_state != hdev->hw.mac.link) {
+		hdev->hw.mac.link = link_state;
 		client->ops->link_status_change(handle, !!link_state);
 		if (rclient && rclient->ops->link_status_change)
 			rclient->ops->link_status_change(rhandle, !!link_state);
-		hdev->hw.mac.link = link_state;
 	}
 
 	clear_bit(HCLGEVF_STATE_LINK_UPDATING, &hdev->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 772b2f8acd2e..b339b9bc0625 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -323,8 +323,8 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			flag = (u8)msg_q[5];
 
 			/* update upper layer with new link link status */
-			hclgevf_update_link_status(hdev, link_status);
 			hclgevf_update_speed_duplex(hdev, speed, duplex);
+			hclgevf_update_link_status(hdev, link_status);
 
 			if (flag & HCLGE_MBX_PUSH_LINK_STATUS_EN)
 				set_bit(HCLGEVF_STATE_PF_PUSH_LINK_STATUS,
-- 
2.8.1

