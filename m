Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604392F9B6
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfE3Jnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:43:37 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:26634 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727201AbfE3Jne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 05:43:34 -0400
X-UUID: a37f927f87c849e2837598a28e804af8-20190530
X-UUID: a37f927f87c849e2837598a28e804af8-20190530
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1287917618; Thu, 30 May 2019 17:43:27 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 30 May 2019 17:43:26 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 30 May 2019 17:43:25 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>,
        <boon.leong.ong@intel.com>, <andrew@lunn.ch>
Subject: [RESEND, PATCH 1/4] net: stmmac: dwmac-mediatek: enable Ethernet power domain
Date:   Thu, 30 May 2019 17:43:15 +0800
Message-ID: <1559209398-3607-2-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559209398-3607-1-git-send-email-biao.huang@mediatek.com>
References: <1559209398-3607-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add Ethernet power on/off operations in init/exit flow.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 126b66b..3c7a60f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -9,6 +9,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_net.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/stmmac.h>
 
@@ -298,6 +299,9 @@ static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
 		return ret;
 	}
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	return 0;
 }
 
@@ -307,6 +311,9 @@ static void mediatek_dwmac_exit(struct platform_device *pdev, void *priv)
 	const struct mediatek_dwmac_variant *variant = plat->variant;
 
 	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 }
 
 static int mediatek_dwmac_probe(struct platform_device *pdev)
@@ -364,6 +371,15 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int mediatek_dwmac_remove(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = stmmac_pltfr_remove(pdev);
+
+	return ret;
+}
+
 static const struct of_device_id mediatek_dwmac_match[] = {
 	{ .compatible = "mediatek,mt2712-gmac",
 	  .data = &mt2712_gmac_variant },
@@ -374,7 +390,7 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 
 static struct platform_driver mediatek_dwmac_driver = {
 	.probe  = mediatek_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove = mediatek_dwmac_remove,
 	.driver = {
 		.name           = "dwmac-mediatek",
 		.pm		= &stmmac_pltfr_pm_ops,
-- 
1.7.9.5

