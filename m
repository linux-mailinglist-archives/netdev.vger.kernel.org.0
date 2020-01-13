Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7F1395D4
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgAMQYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:24:54 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:37166 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbgAMQYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:24:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D3709C05DF;
        Mon, 13 Jan 2020 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578932661; bh=+Et9MFkbtSRJVkOU4n9NKLthz4fCYsmxr3gPjk2wX0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=bjI2dpJ0TEEDXyA+bjNLyPs2cWdmWwJwoHb8ZAp8rog5Ig0yeuJNLu2mvlaUdSC0s
         dUfVAoPF2v9FZHDsj8gjfJZwOIMibUAeIVEkSfvKof4r1MtfiX5piTNCFgp7Bc15EF
         nkO+h7M4S2hwzbzs6qg56Mm6grHJlK7b8rc0MANHlX0GtdPhfMRjWX99hPhLRw5FWF
         4PwtGptxV3aPYzAiRFCzSn6a+/+kyiqD8WmHiPYV53Rrj/oGBlGNJP6EY3WfGAF6/d
         F4xM007Pz9qu5PCUJ5L33Yemj/tEdJKbNkLJp7MMgcpcA67TZW5nMReUNP51Yqeb77
         0dbK7c737TUKA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6F76CA0066;
        Mon, 13 Jan 2020 16:24:19 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/8] net: stmmac: xgmac: Add TBS support
Date:   Mon, 13 Jan 2020 17:24:11 +0100
Message-Id: <8036baa14425e1ff1f2d3a7dd60acbe010144e59.1578932287.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds all the necessary HW hooks to support TBS feature in XGMAC cores.

Changes from v1:
- Remove unneeded LT shift as the IP already does this.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 13 ++++++++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |  9 ++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 24 ++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 64d13e50e403..6c3b8a950f58 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -139,6 +139,7 @@
 #define XGMAC_HWFEAT_TXQCNT		GENMASK(9, 6)
 #define XGMAC_HWFEAT_RXQCNT		GENMASK(3, 0)
 #define XGMAC_HW_FEATURE3		0x00000128
+#define XGMAC_HWFEAT_TBSSEL		BIT(27)
 #define XGMAC_HWFEAT_FPESEL		BIT(26)
 #define XGMAC_HWFEAT_ESTWID		GENMASK(24, 23)
 #define XGMAC_HWFEAT_ESTDEP		GENMASK(22, 20)
@@ -346,6 +347,13 @@
 #define XGMAC_TDPS			GENMASK(29, 0)
 #define XGMAC_RX_EDMA_CTRL		0x00003044
 #define XGMAC_RDPS			GENMASK(29, 0)
+#define XGMAC_DMA_TBS_CTRL0		0x00003054
+#define XGMAC_DMA_TBS_CTRL1		0x00003058
+#define XGMAC_DMA_TBS_CTRL2		0x0000305c
+#define XGMAC_DMA_TBS_CTRL3		0x00003060
+#define XGMAC_FTOS			GENMASK(31, 8)
+#define XGMAC_FTOV			BIT(0)
+#define XGMAC_DEF_FTOS			(XGMAC_FTOS | XGMAC_FTOV)
 #define XGMAC_DMA_SAFETY_INT_STATUS	0x00003064
 #define XGMAC_MCSIS			BIT(31)
 #define XGMAC_MSUIS			BIT(29)
@@ -360,6 +368,7 @@
 #define XGMAC_SPH			BIT(24)
 #define XGMAC_PBLx8			BIT(16)
 #define XGMAC_DMA_CH_TX_CONTROL(x)	(0x00003104 + (0x80 * (x)))
+#define XGMAC_EDSE			BIT(28)
 #define XGMAC_TxPBL			GENMASK(21, 16)
 #define XGMAC_TxPBL_SHIFT		16
 #define XGMAC_TSE			BIT(12)
@@ -404,6 +413,9 @@
 #define XGMAC_REGSIZE			((0x0000317c + (0x80 * 15)) / 4)
 
 /* Descriptors */
+#define XGMAC_TDES0_LTV			BIT(31)
+#define XGMAC_TDES0_LT			GENMASK(7, 0)
+#define XGMAC_TDES1_LT			GENMASK(31, 8)
 #define XGMAC_TDES2_IVT			GENMASK(31, 16)
 #define XGMAC_TDES2_IVT_SHIFT		16
 #define XGMAC_TDES2_IOC			BIT(31)
@@ -422,6 +434,7 @@
 #define XGMAC_TDES3_TCMSSV		BIT(26)
 #define XGMAC_TDES3_SAIC		GENMASK(25, 23)
 #define XGMAC_TDES3_SAIC_SHIFT		23
+#define XGMAC_TDES3_TBSV		BIT(24)
 #define XGMAC_TDES3_THL			GENMASK(22, 19)
 #define XGMAC_TDES3_THL_SHIFT		19
 #define XGMAC_TDES3_IVTIR		GENMASK(19, 18)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index bd5838ce1e8a..c3d654cfa9ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -339,6 +339,14 @@ static void dwxgmac2_set_vlan(struct dma_desc *p, u32 type)
 	p->des2 |= cpu_to_le32(type & XGMAC_TDES2_VTIR);
 }
 
+static void dwxgmac2_set_tbs(struct dma_edesc *p, u32 sec, u32 nsec)
+{
+	p->des4 = cpu_to_le32((sec & XGMAC_TDES0_LT) | XGMAC_TDES0_LTV);
+	p->des5 = cpu_to_le32(nsec & XGMAC_TDES1_LT);
+	p->des6 = 0;
+	p->des7 = 0;
+}
+
 const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.tx_status = dwxgmac2_get_tx_status,
 	.rx_status = dwxgmac2_get_rx_status,
@@ -368,4 +376,5 @@ const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.set_sarc = dwxgmac2_set_sarc,
 	.set_vlan_tag = dwxgmac2_set_vlan_tag,
 	.set_vlan = dwxgmac2_set_vlan,
+	.set_tbs = dwxgmac2_set_tbs,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index bbbfa793a367..77308c5c5d29 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -429,6 +429,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 
 	/* MAC HW feature 3 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE3);
+	dma_cap->tbssel = (hw_cap & XGMAC_HWFEAT_TBSSEL) >> 27;
 	dma_cap->fpesel = (hw_cap & XGMAC_HWFEAT_FPESEL) >> 26;
 	dma_cap->estwid = (hw_cap & XGMAC_HWFEAT_ESTWID) >> 23;
 	dma_cap->estdep = (hw_cap & XGMAC_HWFEAT_ESTDEP) >> 20;
@@ -523,6 +524,28 @@ static void dwxgmac2_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
 	writel(value, ioaddr + XGMAC_DMA_CH_CONTROL(chan));
 }
 
+static int dwxgmac2_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
+{
+	u32 value = readl(ioaddr + XGMAC_DMA_CH_TX_CONTROL(chan));
+
+	if (en)
+		value |= XGMAC_EDSE;
+	else
+		value &= ~XGMAC_EDSE;
+
+	writel(value, ioaddr + XGMAC_DMA_CH_TX_CONTROL(chan));
+
+	value = readl(ioaddr + XGMAC_DMA_CH_TX_CONTROL(chan)) & XGMAC_EDSE;
+	if (en && !value)
+		return -EIO;
+
+	writel(XGMAC_DEF_FTOS, ioaddr + XGMAC_DMA_TBS_CTRL0);
+	writel(XGMAC_DEF_FTOS, ioaddr + XGMAC_DMA_TBS_CTRL1);
+	writel(XGMAC_DEF_FTOS, ioaddr + XGMAC_DMA_TBS_CTRL2);
+	writel(XGMAC_DEF_FTOS, ioaddr + XGMAC_DMA_TBS_CTRL3);
+	return 0;
+}
+
 const struct stmmac_dma_ops dwxgmac210_dma_ops = {
 	.reset = dwxgmac2_dma_reset,
 	.init = dwxgmac2_dma_init,
@@ -550,4 +573,5 @@ const struct stmmac_dma_ops dwxgmac210_dma_ops = {
 	.qmode = dwxgmac2_qmode,
 	.set_bfsize = dwxgmac2_set_bfsize,
 	.enable_sph = dwxgmac2_enable_sph,
+	.enable_tbs = dwxgmac2_enable_tbs,
 };
-- 
2.7.4

