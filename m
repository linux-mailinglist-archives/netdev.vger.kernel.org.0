Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA24182992
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbgCLHMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:12:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11635 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388089AbgCLHMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 03:12:19 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 16476B0A14B8EB317EBF;
        Thu, 12 Mar 2020 15:12:14 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Mar 2020 15:12:06 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/4] net: hns3: fix RMW issue for VLAN filter switch
Date:   Thu, 12 Mar 2020 15:11:05 +0800
Message-ID: <1583997066-24773-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
References: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

According to the user manual, the ingress and egress VLAN filter
are configured at the same time. Currently, hclge_init_vlan_config()
and hclge_set_vlan_spoofchk() will both change the VLAN filter
switch. So it's necessary to read the old configuration before
modifying it.

Fixes: 22044f95faa0 ("net: hns3: add support for spoof check setting")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6deeb96..06d0ed0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7745,16 +7745,27 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 	struct hclge_desc desc;
 	int ret;
 
-	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_FILTER_CTRL, false);
-
+	/* read current vlan filter parameter */
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_VLAN_FILTER_CTRL, true);
 	req = (struct hclge_vlan_filter_ctrl_cmd *)desc.data;
 	req->vlan_type = vlan_type;
-	req->vlan_fe = filter_en ? fe_type : 0;
 	req->vf_id = vf_id;
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get vlan filter config, ret = %d.\n", ret);
+		return ret;
+	}
+
+	/* modify and write new config parameter */
+	hclge_cmd_reuse_desc(&desc, false);
+	req->vlan_fe = filter_en ?
+			(req->vlan_fe | fe_type) : (req->vlan_fe & ~fe_type);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-		dev_err(&hdev->pdev->dev, "set vlan filter fail, ret =%d.\n",
+		dev_err(&hdev->pdev->dev, "failed to set vlan filter, ret = %d.\n",
 			ret);
 
 	return ret;
-- 
2.7.4

