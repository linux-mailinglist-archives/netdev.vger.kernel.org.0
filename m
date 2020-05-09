Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1381CBFD1
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 11:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgEIJ3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 05:29:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4378 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727086AbgEIJ3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 05:29:06 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 65F8A76E6C49B76A88C6;
        Sat,  9 May 2020 17:29:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 17:28:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/5] net: hns3: disable auto-negotiation off with 1000M setting in ethtool
Date:   Sat, 9 May 2020 17:27:41 +0800
Message-ID: <1589016461-10130-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The 802.3 specification does not specify the behavior of
auto-negotiation off with 1000M in PHY. Therefore, some PHY
compatibility issues occur. This patch forbids the setting of
this unreasonable mode by ethtool in driver.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 1a105f2..6b1545f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -773,8 +773,13 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 		  cmd->base.autoneg, cmd->base.speed, cmd->base.duplex);
 
 	/* Only support ksettings_set for netdev with phy attached for now */
-	if (netdev->phydev)
+	if (netdev->phydev) {
+		if (cmd->base.speed == SPEED_1000 &&
+		    cmd->base.autoneg == AUTONEG_DISABLE)
+			return -EINVAL;
+
 		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
+	}
 
 	if (handle->pdev->revision == 0x20)
 		return -EOPNOTSUPP;
-- 
2.7.4

