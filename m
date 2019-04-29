Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2161DBE2
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 08:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfD2GQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 02:16:12 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:13858 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726566AbfD2GQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 02:16:12 -0400
X-UUID: e3f6f3fe8f2846218ffa58333dfa2f85-20190429
X-UUID: e3f6f3fe8f2846218ffa58333dfa2f85-20190429
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1680094737; Mon, 29 Apr 2019 14:16:09 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 29 Apr 2019 14:16:07 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 29 Apr 2019 14:16:06 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>
Subject: [PATCH 2/4] net: stmmac: fix csr_clk can't be zero issue
Date:   Mon, 29 Apr 2019 14:15:54 +0800
Message-ID: <1556518556-32464-3-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1556518556-32464-1-git-send-email-biao.huang@mediatek.com>
References: <1556518556-32464-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6EC60DAFCA4A070922698989D92C07849BD0C3902B4CB805DB4315D970FCF4642000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The specific clk_csr value can be zero, and
stmmac_clk is necessary for MDC clock which can be set dynamically.
So, change the condition from plat->clk_csr to plat->stmmac_clk to
fix clk_csr can't be zero issue.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 818ad88..9e89b94 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4376,7 +4376,7 @@ int stmmac_dvr_probe(struct device *device,
 	 * set the MDC clock dynamically according to the csr actual
 	 * clock input.
 	 */
-	if (!priv->plat->clk_csr)
+	if (priv->plat->stmmac_clk)
 		stmmac_clk_csr_set(priv);
 	else
 		priv->clk_csr = priv->plat->clk_csr;
-- 
1.7.9.5

