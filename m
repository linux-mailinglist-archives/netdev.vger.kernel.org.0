Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B1C3BE3FE
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 09:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhGGH4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 03:56:20 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6762 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhGGH4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 03:56:19 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GKWkK5DyzzXpDf;
        Wed,  7 Jul 2021 15:48:09 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 15:53:38 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 7 Jul
 2021 15:53:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <ajayg@nvidia.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] stmmac: platform: Fix signedness bug in stmmac_probe_config_dt()
Date:   Wed, 7 Jul 2021 15:53:35 +0800
Message-ID: <20210707075335.26488-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "plat->phy_interface" variable is an enum and in this context GCC
will treat it as an unsigned int so the error handling is never
triggered.

Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 072eff8079d0..5ca710844cc1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -397,6 +397,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
+	int phy_mode;
 	void *ret;
 	int rc;
 
@@ -412,10 +413,11 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		eth_zero_addr(mac);
 	}
 
-	plat->phy_interface = device_get_phy_mode(&pdev->dev);
-	if (plat->phy_interface < 0)
-		return ERR_PTR(plat->phy_interface);
+	phy_mode = device_get_phy_mode(&pdev->dev);
+	if (phy_mode < 0)
+		return ERR_PTR(phy_mode);
 
+	plat->phy_interface = phy_mode;
 	plat->interface = stmmac_of_get_mac_mode(np);
 	if (plat->interface < 0)
 		plat->interface = plat->phy_interface;
-- 
2.20.1

