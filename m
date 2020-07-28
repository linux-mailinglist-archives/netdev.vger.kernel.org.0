Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B143322FF76
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgG1CTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:19:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8282 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726357AbgG1CTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 22:19:15 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7887DCF508FBD69A4FE7;
        Tue, 28 Jul 2020 10:19:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 10:19:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/5] net: hns3: add reset check for VF updating port based VLAN
Date:   Tue, 28 Jul 2020 10:16:50 +0800
Message-ID: <1595902612-12880-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
References: <1595902612-12880-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently hclgevf_update_port_base_vlan_info() may be called when
VF is resetting,  which may cause hns3_nic_net_open() being called
twice unexpectedly.

So fix it by adding a reset check for it, and extend critical
region for rntl_lock in hclgevf_update_port_base_vlan_info().

Fixes: 92f11ea177cd ("net: hns3: fix set port based VLAN issue for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 30 +++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index a10b022..b8b72ac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3439,23 +3439,35 @@ void hclgevf_update_port_base_vlan_info(struct hclgevf_dev *hdev, u16 state,
 {
 	struct hnae3_handle *nic = &hdev->nic;
 	struct hclge_vf_to_pf_msg send_msg;
+	int ret;
 
 	rtnl_lock();
-	hclgevf_notify_client(hdev, HNAE3_DOWN_CLIENT);
-	rtnl_unlock();
+
+	if (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state)) {
+		dev_warn(&hdev->pdev->dev,
+			 "is resetting when updating port based vlan info\n");
+		rtnl_unlock();
+		return;
+	}
+
+	ret = hclgevf_notify_client(hdev, HNAE3_DOWN_CLIENT);
+	if (ret) {
+		rtnl_unlock();
+		return;
+	}
 
 	/* send msg to PF and wait update port based vlan info */
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
 			       HCLGE_MBX_PORT_BASE_VLAN_CFG);
 	memcpy(send_msg.data, port_base_vlan_info, data_size);
-	hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
-
-	if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
-		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_DISABLE;
-	else
-		nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+	if (!ret) {
+		if (state == HNAE3_PORT_BASE_VLAN_DISABLE)
+			nic->port_base_vlan_state = state;
+		else
+			nic->port_base_vlan_state = HNAE3_PORT_BASE_VLAN_ENABLE;
+	}
 
-	rtnl_lock();
 	hclgevf_notify_client(hdev, HNAE3_UP_CLIENT);
 	rtnl_unlock();
 }
-- 
2.7.4

