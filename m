Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F6089A1E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfHLJo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:44:29 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:50880 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727487AbfHLJoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:44:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B28D2C2172;
        Mon, 12 Aug 2019 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565603065; bh=Yqqy98nccpQa2Xd9tZBNqR9lQ/hDKyKO5COzb0xnQ24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=dHCmdW0co3ydW4lLvy73jmWETZDP9a5m27Bg5Uf/Ld3dkWDpSX3RNCTlhUtUUxHsL
         MIHI8XRYyAM2McHC6dlbZMPMOUXF12BDQ9DHK6LIavz+OMgGi116W5xCTYI5qaplxU
         bZTeLbliiOX8d23AjAsFnBja+FtaTnH3WSgpH3QU43n6WL+YVCsPtbumHMQECZpb8J
         jdDyRM5mti72gk36odNe0IXpdGedWEoY0+UT+3Hvz0e019Be9cpZjsQNoqVfabsMFR
         r2G63sPXR/mFKsAR79O1mVSoR0b59TmDpWhVXs4nba+L1MvfYpEbCKwLil/4ZFXN5m
         33s12fnl9HDmg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 78A20A007A;
        Mon, 12 Aug 2019 09:44:23 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 10/12] net: stmmac: xgmac: Add EEE support
Date:   Mon, 12 Aug 2019 11:44:09 +0200
Message-Id: <870480f81d0146d6615fdae351a63e06adc59d1b.1565602974.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for EEE in XGMAC cores by implementing the necessary
callbacks.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
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
index d0e7b62cc2ae..d8483d088711 100644
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
@@ -1105,10 +1170,10 @@ const struct stmmac_ops dwxgmac210_ops = {
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

