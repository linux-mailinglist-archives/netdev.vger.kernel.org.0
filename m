Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D802C4C9EE
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbfFTIyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:54:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731245AbfFTIya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 04:54:30 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 86D9074FE51818E8CF2E;
        Thu, 20 Jun 2019 16:54:28 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 20 Jun 2019 16:54:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/11] net: hns3: restore the MAC autoneg state after reset
Date:   Thu, 20 Jun 2019 16:52:38 +0800
Message-ID: <1561020765-14481-5-git-send-email-tanhuazhong@huawei.com>
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

When doing global reset, the MAC autoneg state of fibre
port is set to default, which may cause user configuration
lost. This patch fixes it by restore the MAC autoneg state
after reset.

Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6e97837..0772ca1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2400,6 +2400,15 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 		return ret;
 	}
 
+	if (hdev->hw.mac.support_autoneg) {
+		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.autoneg);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"Config mac autoneg fail ret=%d\n", ret);
+			return ret;
+		}
+	}
+
 	mac->link = 0;
 
 	if (mac->user_fec_mode & BIT(HNAE3_FEC_USER_DEF)) {
-- 
2.7.4

