Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B7916AD6A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBXRaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:30:05 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53255 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgBXRaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:30:05 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1j6HYO-0004HT-08; Mon, 24 Feb 2020 18:30:00 +0100
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1j6HYM-0007ZI-2z; Mon, 24 Feb 2020 18:29:58 +0100
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     kernel@pengutronix.de, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: ethernet: stmmac: don't warn about missing optional wakeup IRQ
Date:   Mon, 24 Feb 2020 18:29:55 +0100
Message-Id: <20200224172956.28744-2-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224172956.28744-1-a.fatoum@pengutronix.de>
References: <20200224172956.28744-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "stm32_pwr_wakeup" is optional per the binding and the driver
handles its absence gracefully. Request it with
platform_get_irq_byname_optional, so its absence doesn't needlessly
clutter the log.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index dc84e5066bf8..b2dc99289687 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -324,7 +324,7 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 	/* Get IRQ information early to have an ability to ask for deferred
 	 * probe if needed before we went too far with resource allocation.
 	 */
-	dwmac->irq_pwr_wakeup = platform_get_irq_byname(pdev,
+	dwmac->irq_pwr_wakeup = platform_get_irq_byname_optional(pdev,
 							"stm32_pwr_wakeup");
 	if (dwmac->irq_pwr_wakeup == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
-- 
2.25.0

