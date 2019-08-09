Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3348882A5
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436781AbfHISgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:36:32 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:38462 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407418AbfHISgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:36:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E0B3CC0C9D
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565375791; bh=WxITugwYKZ5PHSm1HF7I5A/rEoAQe/9PJ9Rc31CVYFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=liOF/EMzOt8o++bQ0IeAD+lut7RGhyLNEix/QBM2NBjkRau/NcSIp5bZV57NH/WOK
         FEHg11Ri5ko8LscT7mfxAwCuEkRzDyxwS72K28X5MW5REYkaeT8y44GW5bibCyERSH
         bx6d8kRQBwkF3aMmERrAIe4HGSveddsc/wVJC3pFRXgPdPTswOhNZs6lGKKWH9xVxR
         NpiSD/CcFftbX9D4AiO6atf3t9dN4KR1RERicxrblOTHQjoNI0VTXIthjHUhyXslzm
         mCiw+OecG12wqUQqMRjdXlb82k18sJdENZXgPodb4drlQ37rtBzoRfp9QcJBZ8ne+B
         WOPtEigZcd8ig==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 87454A0079;
        Fri,  9 Aug 2019 18:36:29 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next 10/12] net: stmmac: xgmac: Add EEE support
Date:   Fri,  9 Aug 2019 20:36:18 +0200
Message-Id: <c4f9c2a899025cd8903b9031b2da001b06456a68.1565375521.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for EEE in XGMAC cores by implementing the necessary
callbacks.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 12 ++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 75 ++++++++++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  1 +
 3 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 3fb023953023..79c145ba25a8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -71,6 +71,7 @@
 #define XGMAC_PSRQ(x)			GENMASK((x) * 8 + 7, (x) * 8)
 #define XGMAC_PSRQ_SHIFT(x)		((x) * 8)
 #define XGMAC_INT_STATUS		0x000000b0
+#define XGMAC_LPIIS			BIT(5)
 #define XGMAC_PMTIS			BIT(4)
 #define XGMAC_INT_EN			0x000000b4
 #define XGMAC_TSIE			BIT(12)
@@ -88,10 +89,21 @@
 #define XGMAC_RWKPKTEN			BIT(2)
 #define XGMAC_MGKPKTEN			BIT(1)
 #define XGMAC_PWRDWN			BIT(0)
+#define XGMAC_LPI_CTRL			0x000000d0
+#define XGMAC_TXCGE			BIT(21)
+#define XGMAC_LPITXA			BIT(19)
+#define XGMAC_PLS			BIT(17)
+#define XGMAC_LPITXEN			BIT(16)
+#define XGMAC_RLPIEX			BIT(3)
+#define XGMAC_RLPIEN			BIT(2)
+#define XGMAC_TLPIEX			BIT(1)
+#define XGMAC_TLPIEN			BIT(0)
+#define XGMAC_LPI_TIMER_CTRL		0x000000d4
 #define XGMAC_HW_FEATURE0		0x0000011c
 #define XGMAC_HWFEAT_SAVLANINS		BIT(27)
 #define XGMAC_HWFEAT_RXCOESEL		BIT(16)
 #define XGMAC_HWFEAT_TXCOESEL		BIT(14)
+#define XGMAC_HWFEAT_EEESEL		BIT(13)
 #define XGMAC_HWFEAT_TSSEL		BIT(12)
 #define XGMAC_HWFEAT_AVSEL		BIT(11)
 #define XGMAC_HWFEAT_RAVSEL		BIT(10)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 16e3a0a0c826..353dca543672 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -253,6 +253,7 @@ static int dwxgmac2_host_irq_status(struct mac_device_info *hw,
 {
 	void __iomem *ioaddr = hw->pcsr;
 	u32 stat, en;
+	int ret = 0;
 
 	en = readl(ioaddr + XGMAC_INT_EN);
 	stat = readl(ioaddr + XGMAC_INT_STATUS);
@@ -264,7 +265,24 @@ static int dwxgmac2_host_irq_status(struct mac_device_info *hw,
 		readl(ioaddr + XGMAC_PMT);
 	}
 
-	return 0;
+	if (stat & XGMAC_LPIIS) {
+		u32 lpi = readl(ioaddr + XGMAC_LPI_CTRL);
+
+		if (lpi & XGMAC_TLPIEN) {
+			ret |= CORE_IRQ_TX_PATH_IN_LPI_MODE;
+			x->irq_tx_path_in_lpi_mode_n++;
+		}
+		if (lpi & XGMAC_TLPIEX) {
+			ret |= CORE_IRQ_TX_PATH_EXIT_LPI_MODE;
+			x->irq_tx_path_exit_lpi_mode_n++;
+		}
+		if (lpi & XGMAC_RLPIEN)
+			x->irq_rx_path_in_lpi_mode_n++;
+		if (lpi & XGMAC_RLPIEX)
+			x->irq_rx_path_exit_lpi_mode_n++;
+	}
+
+	return ret;
 }
 
 static int dwxgmac2_host_mtl_irq_status(struct mac_device_info *hw, u32 chan)
@@ -357,6 +375,53 @@ static void dwxgmac2_get_umac_addr(struct mac_device_info *hw,
 	addr[5] = (hi_addr >> 8) & 0xff;
 }
 
+static void dwxgmac2_set_eee_mode(struct mac_device_info *hw,
+				  bool en_tx_lpi_clockgating)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = readl(ioaddr + XGMAC_LPI_CTRL);
+
+	value |= XGMAC_LPITXEN | XGMAC_LPITXA;
+	if (en_tx_lpi_clockgating)
+		value |= XGMAC_TXCGE;
+
+	writel(value, ioaddr + XGMAC_LPI_CTRL);
+}
+
+static void dwxgmac2_reset_eee_mode(struct mac_device_info *hw)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = readl(ioaddr + XGMAC_LPI_CTRL);
+	value &= ~(XGMAC_LPITXEN | XGMAC_LPITXA | XGMAC_TXCGE);
+	writel(value, ioaddr + XGMAC_LPI_CTRL);
+}
+
+static void dwxgmac2_set_eee_pls(struct mac_device_info *hw, int link)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = readl(ioaddr + XGMAC_LPI_CTRL);
+	if (link)
+		value |= XGMAC_PLS;
+	else
+		value &= ~XGMAC_PLS;
+	writel(value, ioaddr + XGMAC_LPI_CTRL);
+}
+
+static void dwxgmac2_set_eee_timer(struct mac_device_info *hw, int ls, int tw)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = (tw & 0xffff) | ((ls & 0x3ff) << 16);
+	writel(value, ioaddr + XGMAC_LPI_TIMER_CTRL);
+}
+
 static void dwxgmac2_set_mchash(void __iomem *ioaddr, u32 *mcfilterbits,
 				int mcbitslog2)
 {
@@ -1112,10 +1177,10 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.pmt = dwxgmac2_pmt,
 	.set_umac_addr = dwxgmac2_set_umac_addr,
 	.get_umac_addr = dwxgmac2_get_umac_addr,
-	.set_eee_mode = NULL,
-	.reset_eee_mode = NULL,
-	.set_eee_timer = NULL,
-	.set_eee_pls = NULL,
+	.set_eee_mode = dwxgmac2_set_eee_mode,
+	.reset_eee_mode = dwxgmac2_reset_eee_mode,
+	.set_eee_timer = dwxgmac2_set_eee_timer,
+	.set_eee_pls = dwxgmac2_set_eee_pls,
 	.pcs_ctrl_ane = NULL,
 	.pcs_rane = NULL,
 	.pcs_get_adv_lp = NULL,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 42c13d144203..f2d5901fbaff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -361,6 +361,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE0);
 	dma_cap->rx_coe = (hw_cap & XGMAC_HWFEAT_RXCOESEL) >> 16;
 	dma_cap->tx_coe = (hw_cap & XGMAC_HWFEAT_TXCOESEL) >> 14;
+	dma_cap->eee = (hw_cap & XGMAC_HWFEAT_EEESEL) >> 13;
 	dma_cap->atime_stamp = (hw_cap & XGMAC_HWFEAT_TSSEL) >> 12;
 	dma_cap->av = (hw_cap & XGMAC_HWFEAT_AVSEL) >> 11;
 	dma_cap->av &= (hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10;
-- 
2.7.4

