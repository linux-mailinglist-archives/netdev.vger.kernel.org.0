Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE5831348F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhBHOHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:07:49 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57092 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhBHN6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:58:39 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 23/24] net: stmmac: Use pclk to set MDC clock frequency
Date:   Mon, 8 Feb 2021 16:56:07 +0300
Message-ID: <20210208135609.7685-24-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In accordance with [1] the MDC clock frequency is supposed to be selected
with respect to the CSR clock frequency. CSR clock can be either tied to
the DW MAC system clock (GMAC main clock) or supplied via a dedicated
clk_csr_i signal. Current MDC clock selection procedure handles the former
case while having no support of the later one. That's wrong for the
devices which have separate system and CSR clocks. Let's fix it by first
trying to get the synchro-signal rate from the "pclk" clock, if it hasn't
been specified then fall-back to the "stmmaceth" clock.

[1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
    October 2013, p. 424.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a8dec219c295..03acf14d76de 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -206,7 +206,12 @@ static void stmmac_clk_csr_set(struct stmmac_priv *priv)
 {
 	u32 clk_rate;
 
-	clk_rate = clk_get_rate(priv->plat->stmmac_clk);
+	/* If APB clock has been specified then it is supposed to be used
+	 * to select the CSR mode. Otherwise the application clock is the
+	 * source of the periodic signal for the CSR interface.
+	 */
+	clk_rate = clk_get_rate(priv->plat->pclk) ?:
+		   clk_get_rate(priv->plat->stmmac_clk);
 
 	/* Platform provided default clk_csr would be assumed valid
 	 * for all other cases except for the below mentioned ones.
-- 
2.29.2

