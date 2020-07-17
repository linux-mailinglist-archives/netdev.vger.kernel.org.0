Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73A5223959
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgGQKdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:33:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37478 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726040AbgGQKdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 06:33:38 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 286BFE465BD03B9B8474;
        Fri, 17 Jul 2020 18:33:35 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 17 Jul 2020 18:33:33 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <mark.einon@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: ethernet: et131x: Remove unused variable 'pm_csr'
Date:   Fri, 17 Jul 2020 18:33:30 +0800
Message-ID: <1594982010-30679-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gcc report warning as follows:

drivers/net/ethernet/agere/et131x.c:953:6: warning:
 variable 'pm_csr' set but not used [-Wunused-but-set-variable]
  953 |  u32 pm_csr;
      |      ^~~~~~
drivers/net/ethernet/agere/et131x.c:1002:6:warning:
 variable 'pm_csr' set but not used [-Wunused-but-set-variable]
 1002 |  u32 pm_csr;
      |      ^~~~~~
drivers/net/ethernet/agere/et131x.c:3446:8: warning:
 variable 'pm_csr' set but not used [-Wunused-but-set-variable]
 3446 |    u32 pm_csr;
      |        ^~~~~~

After commit 38df6492eb51 ("et131x: Add PCIe gigabit ethernet driver
et131x to drivers/net"), 'pm_csr' is never used in these functions,
so removing it to avoid build warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/agere/et131x.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 865892c..8806e1e 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -950,7 +950,6 @@ static void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 	u32 hash2 = 0;
 	u32 hash3 = 0;
 	u32 hash4 = 0;
-	u32 pm_csr;
 
 	/* If ET131X_PACKET_TYPE_MULTICAST is specified, then we provision
 	 * the multi-cast LIST.  If it is NOT specified, (and "ALL" is not
@@ -984,7 +983,7 @@ static void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 	}
 
 	/* Write out the new hash to the device */
-	pm_csr = readl(&adapter->regs->global.pm_csr);
+	readl(&adapter->regs->global.pm_csr);
 	if (!et1310_in_phy_coma(adapter)) {
 		writel(hash1, &rxmac->multi_hash1);
 		writel(hash2, &rxmac->multi_hash2);
@@ -999,7 +998,6 @@ static void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
 	u32 uni_pf1;
 	u32 uni_pf2;
 	u32 uni_pf3;
-	u32 pm_csr;
 
 	/* Set up unicast packet filter reg 3 to be the first two octets of
 	 * the MAC address for both address
@@ -1025,7 +1023,7 @@ static void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
 		  (adapter->addr[4] << ET_RX_UNI_PF_ADDR1_5_SHIFT) |
 		   adapter->addr[5];
 
-	pm_csr = readl(&adapter->regs->global.pm_csr);
+	readl(&adapter->regs->global.pm_csr);
 	if (!et1310_in_phy_coma(adapter)) {
 		writel(uni_pf1, &rxmac->uni_pf_addr1);
 		writel(uni_pf2, &rxmac->uni_pf_addr2);
@@ -3443,12 +3441,10 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 		 * send a pause packet, otherwise just exit
 		 */
 		if (adapter->flow == FLOW_TXONLY || adapter->flow == FLOW_BOTH) {
-			u32 pm_csr;
-
 			/* Tell the device to send a pause packet via the back
 			 * pressure register (bp req and bp xon/xoff)
 			 */
-			pm_csr = readl(&iomem->global.pm_csr);
+			readl(&iomem->global.pm_csr);
 			if (!et1310_in_phy_coma(adapter))
 				writel(3, &iomem->txmac.bp_ctrl);
 		}
-- 
1.8.3.1

