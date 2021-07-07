Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A137A3BE3F3
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 09:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhGGHyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 03:54:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6441 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhGGHyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 03:54:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GKWkx5nNPz764d;
        Wed,  7 Jul 2021 15:48:41 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 15:52:09 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 7 Jul
 2021 15:52:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <zhangqing@loongson.cn>,
        <yuehaibing@huawei.com>, <jiaxun.yang@flygoat.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] stmmac: dwmac-loongson: Fix unsigned comparison to zero
Date:   Wed, 7 Jul 2021 15:50:57 +0800
Message-ID: <20210707075057.34348-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

plat->phy_interface is unsigned integer, so the condition
can't be less than zero and the warning will never printed.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index e108b0d2bd28..4c9a37dd0d3f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -49,9 +49,9 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 {
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_resources res;
-	bool mdio = false;
-	int ret, i;
 	struct device_node *np;
+	int ret, i, phy_mode;
+	bool mdio = false;
 
 	np = dev_of_node(&pdev->dev);
 
@@ -108,10 +108,11 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (plat->bus_id < 0)
 		plat->bus_id = pci_dev_id(pdev);
 
-	plat->phy_interface = device_get_phy_mode(&pdev->dev);
-	if (plat->phy_interface < 0)
+	phy_mode = device_get_phy_mode(&pdev->dev);
+	if (phy_mode < 0)
 		dev_err(&pdev->dev, "phy_mode not found\n");
 
+	plat->phy_interface = phy_mode;
 	plat->interface = PHY_INTERFACE_MODE_GMII;
 
 	pci_set_master(pdev);
-- 
2.20.1

