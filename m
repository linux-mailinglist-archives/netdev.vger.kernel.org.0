Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D5A1B8B10
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 04:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgDZCP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 22:15:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2897 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbgDZCPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 22:15:10 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1E4877C31D0918A63385;
        Sun, 26 Apr 2020 10:15:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sun, 26 Apr 2020 10:15:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 2/9] net: hns3: remove unnecessary parameter 'is_alloc' in hclge_set_umv_space()
Date:   Sun, 26 Apr 2020 10:13:41 +0800
Message-ID: <1587867228-9955-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587867228-9955-1-git-send-email-tanhuazhong@huawei.com>
References: <1587867228-9955-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Since hclge_set_umv_space() is only called by hclge_init_umv_space(),
so parameter 'is_alloc' is redundant.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index ccf269a..fe6e60a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7195,7 +7195,7 @@ static int hclge_add_mac_vlan_tbl(struct hclge_vport *vport,
 }
 
 static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
-			       u16 *allocated_size, bool is_alloc)
+			       u16 *allocated_size)
 {
 	struct hclge_umv_spc_alc_cmd *req;
 	struct hclge_desc desc;
@@ -7203,20 +7203,17 @@ static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
 
 	req = (struct hclge_umv_spc_alc_cmd *)desc.data;
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MAC_VLAN_ALLOCATE, false);
-	if (!is_alloc)
-		hnae3_set_bit(req->allocate, HCLGE_UMV_SPC_ALC_B, 1);
 
 	req->space_size = cpu_to_le32(space_size);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"%s umv space failed for cmd_send, ret =%d\n",
-			is_alloc ? "allocate" : "free", ret);
+		dev_err(&hdev->pdev->dev, "failed to set umv space, ret = %d\n",
+			ret);
 		return ret;
 	}
 
-	if (is_alloc && allocated_size)
+	if (allocated_size)
 		*allocated_size = le32_to_cpu(desc.data[1]);
 
 	return 0;
@@ -7227,8 +7224,7 @@ static int hclge_init_umv_space(struct hclge_dev *hdev)
 	u16 allocated_size = 0;
 	int ret;
 
-	ret = hclge_set_umv_space(hdev, hdev->wanted_umv_size, &allocated_size,
-				  true);
+	ret = hclge_set_umv_space(hdev, hdev->wanted_umv_size, &allocated_size);
 	if (ret)
 		return ret;
 
-- 
2.7.4

