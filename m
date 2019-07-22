Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1376F947
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 08:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfGVGCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 02:02:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2733 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfGVGCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 02:02:32 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D98A4B0725B57E8EB4CC;
        Mon, 22 Jul 2019 14:02:30 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Mon, 22 Jul 2019 14:02:19 +0800
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
Subject: [PATCH net] net: hns: fix LED configuration for marvell phy
Date:   Mon, 22 Jul 2019 13:59:12 +0800
Message-ID: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit(net: phy: marvell: change default m88e1510 LED configuration),
the active LED of Hip07 devices is always off, because Hip07 just
use 2 LEDs.
This patch adds a phy_register_fixup_for_uid() for m88e1510 to
correct the LED configuration.

Fixes: 077772468ec1 ("net: phy: marvell: change default m88e1510 LED configuration")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Reviewed-by: linyunsheng <linyunsheng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 2235dd5..5b213eb 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/marvell_phy.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
@@ -1149,6 +1150,13 @@ static void hns_nic_adjust_link(struct net_device *ndev)
 	}
 }
 
+static int hns_phy_marvell_fixup(struct phy_device *phydev)
+{
+	phydev->dev_flags |= MARVELL_PHY_LED0_LINK_LED1_ACTIVE;
+
+	return 0;
+}
+
 /**
  *hns_nic_init_phy - init phy
  *@ndev: net device
@@ -1174,6 +1182,16 @@ int hns_nic_init_phy(struct net_device *ndev, struct hnae_handle *h)
 	if (h->phy_if != PHY_INTERFACE_MODE_XGMII) {
 		phy_dev->dev_flags = 0;
 
+		/* register the PHY fixup (for Marvell 88E1510) */
+		ret = phy_register_fixup_for_uid(MARVELL_PHY_ID_88E1510,
+						 MARVELL_PHY_ID_MASK,
+						 hns_phy_marvell_fixup);
+		/* we can live without it, so just issue a warning */
+		if (ret)
+			netdev_warn(ndev,
+				    "Cannot register PHY fixup, ret=%d\n",
+				    ret);
+
 		ret = phy_connect_direct(ndev, phy_dev, hns_nic_adjust_link,
 					 h->phy_if);
 	} else {
@@ -2430,8 +2448,11 @@ static int hns_nic_dev_remove(struct platform_device *pdev)
 		hns_nic_uninit_ring_data(priv);
 	priv->ring_data = NULL;
 
-	if (ndev->phydev)
+	if (ndev->phydev) {
+		phy_unregister_fixup_for_uid(MARVELL_PHY_ID_88E1510,
+					     MARVELL_PHY_ID_MASK);
 		phy_disconnect(ndev->phydev);
+	}
 
 	if (!IS_ERR_OR_NULL(priv->ae_handle))
 		hnae_put_handle(priv->ae_handle);
-- 
2.8.1

