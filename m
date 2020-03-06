Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B508B17B4B4
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 03:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCFC6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 21:58:18 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38320 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbgCFC6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 21:58:02 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 66351D6014C0E3BD13FE;
        Fri,  6 Mar 2020 10:57:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Mar 2020 10:57:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/9] net: hns3: add a check before PF inform VF to reset
Date:   Fri, 6 Mar 2020 10:57:14 +0800
Message-ID: <1583463438-60953-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
References: <1583463438-60953-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

When setting VF's MAC from PF, if the VF driver not loaded, the
firmware will return error to PF.

So PF should check whether VF is alive before sending message to
VF when setting VF's MAC.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6da55fb3..69e2008 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7617,11 +7617,17 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 	}
 
 	ether_addr_copy(vport->vf_info.mac, mac_addr);
-	dev_info(&hdev->pdev->dev,
-		 "MAC of VF %d has been set to %pM, and it will be reinitialized!\n",
-		 vf, mac_addr);
 
-	return hclge_inform_reset_assert_to_vf(vport);
+	if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
+		dev_info(&hdev->pdev->dev,
+			 "MAC of VF %d has been set to %pM, and it will be reinitialized!\n",
+			 vf, mac_addr);
+		return hclge_inform_reset_assert_to_vf(vport);
+	}
+
+	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %pM\n",
+		 vf, mac_addr);
+	return 0;
 }
 
 static int hclge_add_mgr_tbl(struct hclge_dev *hdev,
-- 
2.7.4

