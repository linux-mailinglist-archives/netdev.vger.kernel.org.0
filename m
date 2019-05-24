Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC1290F1
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 08:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388869AbfEXG0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 02:26:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:14809 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388051AbfEXG0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 02:26:24 -0400
X-UUID: 11b01a1f3a6a4d4cb21edba42fb58a89-20190524
X-UUID: 11b01a1f3a6a4d4cb21edba42fb58a89-20190524
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 874709294; Fri, 24 May 2019 14:26:17 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 May 2019 14:26:15 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 24 May 2019 14:26:14 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.comi>,
        <boon.leong.ong@intel.com>
Subject: [v4, PATCH 2/3] net: stmmac: fix csr_clk can't be zero issue
Date:   Fri, 24 May 2019 14:26:08 +0800
Message-ID: <1558679169-26752-3-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1558679169-26752-1-git-send-email-biao.huang@mediatek.com>
References: <1558679169-26752-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 86EFF50A2E3E7471BBF624373C15CF06603E1AF3736B7DA1286DF202D2EDBB822000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The specific clk_csr value can be zero, and
stmmac_clk is necessary for MDC clock which can be set dynamically.
So, change the condition from plat->clk_csr to plat->stmmac_clk to
fix clk_csr can't be zero issue.

Fixes: cd7201f477b9 ("stmmac: MDC clock dynamically based on the csr clock input")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    6 +++---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06487a6..b2feb6c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4380,10 +4380,10 @@ int stmmac_dvr_probe(struct device *device,
 	 * set the MDC clock dynamically according to the csr actual
 	 * clock input.
 	 */
-	if (!priv->plat->clk_csr)
-		stmmac_clk_csr_set(priv);
-	else
+	if (priv->plat->clk_csr >= 0)
 		priv->clk_csr = priv->plat->clk_csr;
+	else
+		stmmac_clk_csr_set(priv);
 
 	stmmac_check_pcs_mode(priv);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 3031f2b..f45bfbe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -408,7 +408,10 @@ struct plat_stmmacenet_data *
 	/* Default to phy auto-detection */
 	plat->phy_addr = -1;
 
-	/* Get clk_csr from device tree */
+	/* Default to get clk_csr from stmmac_clk_crs_set(),
+	 * or get clk_csr from device tree.
+	 */
+	plat->clk_csr = -1;
 	of_property_read_u32(np, "clk_csr", &plat->clk_csr);
 
 	/* "snps,phy-addr" is not a standard property. Mark it as deprecated
-- 
1.7.9.5

