Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E7D25FAE1
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgIGM7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 08:59:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37172 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729344AbgIGM65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 08:58:57 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3ACA2A99BE5BDE1BFBE0;
        Mon,  7 Sep 2020 20:58:26 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 7 Sep 2020 20:58:22 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: stmmac: remove redundant null check before clk_disable_unprepare()
Date:   Mon, 7 Sep 2020 20:57:24 +0800
Message-ID: <1599483444-43331-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because clk_prepare_enable() and clk_disable_unprepare() already checked
NULL clock parameter, so the additional checks are unnecessary, just
remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89b2b34..c553047 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -788,8 +788,7 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 
 static void stmmac_release_ptp(struct stmmac_priv *priv)
 {
-	if (priv->plat->clk_ptp_ref)
-		clk_disable_unprepare(priv->plat->clk_ptp_ref);
+	clk_disable_unprepare(priv->plat->clk_ptp_ref);
 	stmmac_ptp_unregister(priv);
 }
 
@@ -5108,8 +5107,7 @@ int stmmac_suspend(struct device *dev)
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
-		if (priv->plat->clk_ptp_ref)
-			clk_disable_unprepare(priv->plat->clk_ptp_ref);
+		clk_disable_unprepare(priv->plat->clk_ptp_ref);
 		clk_disable_unprepare(priv->plat->pclk);
 		clk_disable_unprepare(priv->plat->stmmac_clk);
 	}
-- 
2.9.5

