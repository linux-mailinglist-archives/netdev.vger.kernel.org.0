Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07D541C98D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346135AbhI2QGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23336 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345723AbhI2QAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:25 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX72l8QzRd8d;
        Wed, 29 Sep 2021 23:53:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 139/167] net: natsemi: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:06 +0800
Message-ID: <20210929155334.12454-140-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/natsemi/ns83820.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 72794d158871..ed2e9fe01e1e 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2139,20 +2139,22 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	ns83820_getmac(dev, ndev->dev_addr);
 
 	/* Yes, we support dumb IP checksum on transmit */
-	ndev->features |= NETIF_F_SG;
-	ndev->features |= NETIF_F_IP_CSUM;
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &ndev->features);
+	netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &ndev->features);
 
 	ndev->min_mtu = 0;
 
 #ifdef NS83820_VLAN_ACCEL_SUPPORT
 	/* We also support hardware vlan acceleration */
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX,
+				&ndev->features);
 #endif
 
 	if (using_dac) {
 		printk(KERN_INFO "%s: using 64 bit addressing.\n",
 			ndev->name);
-		ndev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
 	}
 
 	printk(KERN_INFO "%s: ns83820 v" VERSION ": DP83820 v%u.%u: %pM io=0x%08lx irq=%d f=%s\n",
@@ -2160,7 +2162,8 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 		(unsigned)readl(dev->base + SRR) >> 8,
 		(unsigned)readl(dev->base + SRR) & 0xff,
 		ndev->dev_addr, addr, pci_dev->irq,
-		(ndev->features & NETIF_F_HIGHDMA) ? "h,sg" : "sg"
+		netdev_feature_test_bit(NETIF_F_HIGHDMA_BIT,
+					ndev->features) ? "h,sg" : "sg"
 		);
 
 #ifdef PHY_CODE_IS_FINISHED
-- 
2.33.0

