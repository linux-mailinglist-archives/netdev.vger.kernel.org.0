Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752D44CA04
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfFTIyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731359AbfFTIyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:33 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 63EC487C0F5CE521EECD;
        Thu, 20 Jun 2019 16:54:28 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/11] net: hns3: remove VF VLAN filter entry inexistent warning print
Date:   Thu, 20 Jun 2019 16:52:36 +0800
Message-ID: <1561020765-14481-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
References: <1561020765-14481-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For VF VLAN filter is disabled when VF VLAN table is full, then the
new VLAN ID won't be added into VF VLAN table, it will always print
fail log when remove these VLAN IDs. If user has added too many
VLANs, it will cause massive verbose print logs.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b328662..90cbdbe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7112,12 +7112,13 @@ static int hclge_set_vf_vlan_common(struct hclge_dev *hdev, u16 vfid,
 		if (!req0->resp_code)
 			return 0;
 
-		if (req0->resp_code == HCLGE_VF_VLAN_DEL_NO_FOUND) {
-			dev_warn(&hdev->pdev->dev,
-				 "vlan %d filter is not in vf vlan table\n",
-				 vlan);
+		/* vf vlan filter is disabled when vf vlan table is full,
+		 * then new vlan id will not be added into vf vlan table.
+		 * Just return 0 without warning, avoid massive verbose
+		 * print logs when unload.
+		 */
+		if (req0->resp_code == HCLGE_VF_VLAN_DEL_NO_FOUND)
 			return 0;
-		}
 
 		dev_err(&hdev->pdev->dev,
 			"Kill vf vlan filter fail, ret =%d.\n",
-- 
2.7.4

