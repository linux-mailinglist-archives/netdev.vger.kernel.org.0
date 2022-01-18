Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158BF492058
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiARHa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:30:56 -0500
Received: from mo-csw-fb1114.securemx.jp ([210.130.202.173]:46878 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiARHaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 02:30:55 -0500
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1114) id 20I5k8FR002771; Tue, 18 Jan 2022 14:46:09 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 20I5jmUW030006; Tue, 18 Jan 2022 14:45:48 +0900
X-Iguazu-Qid: 2wHHOe8oPqfgLHbULq
X-Iguazu-QSIG: v=2; s=0; t=1642484748; q=2wHHOe8oPqfgLHbULq; m=VAOczg2DnS8QSbYDBwK1TRj1xM0/+Rg5QHs9/nZdNRM=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1113) id 20I5jkJl031006
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Jan 2022 14:45:46 +0900
X-SA-MID: 30475378
From:   Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp
Subject: [PATCH 2/2] net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode
Date:   Tue, 18 Jan 2022 14:39:50 +0900
X-TSB-HOP: ON
X-TSB-HOP2: ON
Message-Id: <20220118053950.2605-3-yuji2.ishikawa@toshiba.co.jp>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
References: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bit pattern of the ETHER_CLOCK_SEL register for RMII/MII mode should be fixed.
Also, some control bits should be modified with a specific sequence.

Signed-off-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 32 ++++++++++++-------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index 43a446cea..dde5b772a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -96,31 +96,41 @@ static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 	val |= ETHER_CLK_SEL_TX_O_E_N_IN;
 	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 
+	/* Set Clock-Mux, Start clock, Set TX_O direction */
 	switch (dwmac->phy_intf_sel) {
 	case ETHER_CONFIG_INTF_RGMII:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val &= ~ETHER_CLK_SEL_TX_O_E_N_IN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	case ETHER_CONFIG_INTF_RMII:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV |
-			ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC | ETHER_CLK_SEL_TX_O_E_N_IN |
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV | ETHER_CLK_SEL_TX_O_E_N_IN |
 			ETHER_CLK_SEL_RMII_CLK_SEL_RX_C;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RMII_CLK_RST;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RMII_CLK_EN | ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	case ETHER_CONFIG_INTF_MII:
 	default:
 		val = clk_sel_val | ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC |
-			ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV | ETHER_CLK_SEL_TX_O_E_N_IN |
-			ETHER_CLK_SEL_RMII_CLK_EN;
+			ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC | ETHER_CLK_SEL_TX_O_E_N_IN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
+
+		val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
+		writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
 		break;
 	}
 
-	/* Start clock */
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-	val |= ETHER_CLK_SEL_RX_TX_CLK_EN;
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-
-	val &= ~ETHER_CLK_SEL_TX_O_E_N_IN;
-	writel(val, dwmac->reg + REG_ETHER_CLOCK_SEL);
-
 	spin_unlock_irqrestore(&dwmac->lock, flags);
 }
 
-- 
2.17.1


