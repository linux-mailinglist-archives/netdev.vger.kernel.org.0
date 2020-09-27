Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476AD279F30
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgI0HPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:15:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14247 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730423AbgI0HPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:45 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 774C4237626CB6EA11D4;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:32 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/10] net: hns3: delete redundant PCI revision judgement
Date:   Sun, 27 Sep 2020 15:12:40 +0800
Message-ID: <1601190768-50075-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Fibre device of PCI revision 0x20 don't support autoneg, and the ops
get_autoneg() return AUTONEG_DISABLE so function hns3_nway_reset()
will return earlier than judging PCI revision.

Function hclge_handle_rocee_ras_error() don't need to judge PCI
revision again because its caller hclge_handle_hw_ras_error() has
judged once.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c     | 3 ---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index df28811..96b4d97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1076,9 +1076,6 @@ static int hns3_nway_reset(struct net_device *netdev)
 	if (phy)
 		return genphy_restart_aneg(phy);
 
-	if (handle->pdev->revision == 0x20)
-		return -EOPNOTSUPP;
-
 	return ops->restart_autoneg(handle);
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 5d80efd..9ee55ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1577,8 +1577,7 @@ static void hclge_handle_rocee_ras_error(struct hnae3_ae_dev *ae_dev)
 	struct hclge_dev *hdev = ae_dev->priv;
 	enum hnae3_reset_type reset_type;
 
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) ||
-	    hdev->pdev->revision < 0x21)
+	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
 		return;
 
 	reset_type = hclge_log_and_clear_rocee_ras_error(hdev);
-- 
2.7.4

