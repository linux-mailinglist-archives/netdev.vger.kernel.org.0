Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31023179D99
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 02:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgCEBsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 20:48:37 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:50176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgCEBsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 20:48:37 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 44727AE23C716FD804E0;
        Thu,  5 Mar 2020 09:48:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 09:48:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net] net: hns3: fix a not link up issue when fibre port supports autoneg
Date:   Thu, 5 Mar 2020 09:47:53 +0800
Message-ID: <1583372873-26924-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

When fibre port supports auto-negotiation, the IMP(Intelligent
Management Process) processes the speed of auto-negotiation
and the  user's speed separately.
For below case, the port will get a not link up problem.
step 1: disables auto-negotiation and sets speed to A, then
the driver's MAC speed will be updated to A.
step 2: enables auto-negotiation and MAC gets negotiated
speed B, then the driver's MAC speed will be updated to B
through querying in periodical task.
step 3: MAC gets new negotiated speed A.
step 4: disables auto-negotiation and sets speed to B before
periodical task query new MAC speed A, the driver will  ignore
the speed configuration.

This patch fixes it by skipping speed and duplex checking when
fibre port supports auto-negotiation.

Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 492bc94..acf0c29f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2446,10 +2446,12 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 
 int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex)
 {
+	struct hclge_mac *mac = &hdev->hw.mac;
 	int ret;
 
 	duplex = hclge_check_speed_dup(duplex, speed);
-	if (hdev->hw.mac.speed == speed && hdev->hw.mac.duplex == duplex)
+	if (!mac->support_autoneg && mac->speed == speed &&
+	    mac->duplex == duplex)
 		return 0;
 
 	ret = hclge_cfg_mac_speed_dup_hw(hdev, speed, duplex);
-- 
2.7.4

