Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47812B15DB
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 07:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKMGcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 01:32:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8079 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgKMGcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 01:32:22 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CXTCT0t77zLwD6;
        Fri, 13 Nov 2020 14:32:05 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 13 Nov 2020 14:32:17 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <vineetha.g.jaya.kumaran@intel.com>,
        <rusaimi.amira.rusaimi@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: stmmac: dwmac-intel-plat: fix error return code in intel_eth_plat_probe()
Date:   Fri, 13 Nov 2020 14:34:03 +0800
Message-ID: <1605249243-17262-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 9efc9b2b04c7 ("net: stmmac: Add dwmac-intel-plat for GBE driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index f61cb99..82b1c7a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -113,8 +113,10 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 		/* Enable TX clock */
 		if (dwmac->data->tx_clk_en) {
 			dwmac->tx_clk = devm_clk_get(&pdev->dev, "tx_clk");
-			if (IS_ERR(dwmac->tx_clk))
+			if (IS_ERR(dwmac->tx_clk)) {
+				ret = PTR_ERR(dwmac->tx_clk);
 				goto err_remove_config_dt;
+			}
 
 			clk_prepare_enable(dwmac->tx_clk);
 
-- 
2.9.5

