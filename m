Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51590274F7D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgIWDUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:20:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbgIWDUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 23:20:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D5BA0A1DDCE5F48A8D1E;
        Wed, 23 Sep 2020 11:20:50 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 23 Sep 2020 11:20:44 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next v2] net: microchip: Make `lan743x_pm_suspend` function return right value
Date:   Wed, 23 Sep 2020 11:21:40 +0800
Message-ID: <20200923032140.16514-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/microchip/lan743x_main.c: In function lan743x_pm_suspend:

`ret` is set but not used. In fact, `pci_prepare_to_sleep` function value should
be the right value of `lan743x_pm_suspend` function, therefore, fix it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index de93cc6ebc1a..7e236c9ee4b1 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3038,7 +3038,6 @@ static int lan743x_pm_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
-	int ret;
 
 	lan743x_pcidev_shutdown(pdev);
 
@@ -3051,9 +3050,7 @@ static int lan743x_pm_suspend(struct device *dev)
 		lan743x_pm_set_wol(adapter);
 
 	/* Host sets PME_En, put D3hot */
-	ret = pci_prepare_to_sleep(pdev);
-
-	return 0;
+	return pci_prepare_to_sleep(pdev);;
 }
 
 static int lan743x_pm_resume(struct device *dev)
-- 
2.17.1

