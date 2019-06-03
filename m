Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147553264C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfFCB6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:58:30 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:17119 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbfFCB6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:58:30 -0400
X-UUID: 75b13cd02ce44708a49515b0002abebd-20190603
X-UUID: 75b13cd02ce44708a49515b0002abebd-20190603
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1054470933; Mon, 03 Jun 2019 09:58:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 3 Jun 2019 09:58:19 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 3 Jun 2019 09:58:18 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <andrew@lunn.ch>
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
        <boon.leong.ong@intel.com>
Subject: [v2, PATCH 1/4] net: stmmac: dwmac-mediatek: enable Ethernet power domain
Date:   Mon, 3 Jun 2019 09:58:03 +0800
Message-ID: <1559527086-7227-2-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559527086-7227-1-git-send-email-biao.huang@mediatek.com>
References: <1559527086-7227-1-git-send-email-biao.huang@mediatek.com>
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
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 126b66b..b84269e 100644
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
-- 
1.7.9.5

