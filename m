Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDDE138CD8
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgAMIaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:30:00 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:54412 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728911AbgAMI35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 03:29:57 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 961BC40690;
        Mon, 13 Jan 2020 08:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578904197; bh=BxJWPDLDjNhqzcZSiJs2uXr5wWIvRToQ2ZYcTSy6BWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=RPM4Yx/CUMfMziPVqt7XyxbTiroQPUU6MjZlWZpAam7CmEm2kdjHOIwL4qTC+m4X1
         1pBLSLYn78j7/81N+ch0/GSSFvPctbUpREJ6oImTcjKTnfvQE5gJxfzBY7ifd5nHfE
         X2Fi+f8RI2Gjr53z6TUoRn5QU1V71NTzNzq5ApimP5a+X668FL9LudfdlGeeadDXco
         6ZhhrB+MQG+Fo1VsJ3+ysdzmUTUNJZP0kjZg+EYiGjRhrS5Gt8q3pWMpbKyDVCPaER
         TIhw2xz7CnsxM7g/wj9JOc88bxRe7qA5NsQXcftOe4rTvKj/PzFARyagojccHAzRk4
         Cz5silz4CeaEA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 44F6AA006E;
        Mon, 13 Jan 2020 08:29:54 +0000 (UTC)
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
Subject: [PATCH net-next 3/6] net: stmmac: xgmac: Add TBS support
Date:   Mon, 13 Jan 2020 09:29:37 +0100
Message-Id: <de2e406afabf1ea1ec1173f244629166c873b60c.1578903874.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578903874.git.Jose.Abreu@synopsys.com>
References: <cover.1578903874.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578903874.git.Jose.Abreu@synopsys.com>
References: <cover.1578903874.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds all the necessary HW hooks to support TBS feature in XGMAC cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 14 +++++++++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |  9 ++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 24 ++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 64d13e50e403..b4d0e0b8ee2e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -11,6 +11,7 @@
 
 /* Misc */
 #define XGMAC_JUMBO_LEN			16368
+#define XGMAC_LT_SHIFT			8 /* LT is in 256ns base */
 
 /* MAC Registers */
 #define XGMAC_TX_CONFIG			0x00000000
@@ -139,6 +140,7 @@
 #define XGMAC_HWFEAT_TXQCNT		GENMASK(9, 6)
 #define XGMAC_HWFEAT_RXQCNT		GENMASK(3, 0)
 #define XGMAC_HW_FEATURE3		0x00000128
+#define XGMAC_HWFEAT_TBSSEL		BIT(27)
 #define XGMAC_HWFEAT_FPESEL		BIT(26)
 #define XGMAC_HWFEAT_ESTWID		GENMASK(24, 23)
 #define XGMAC_HWFEAT_ESTDEP		GENMASK(22, 20)
@@ -346,6 +348,13 @@
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
@@ -360,6 +369,7 @@
 #define XGMAC_SPH			BIT(24)
 #define XGMAC_PBLx8			BIT(16)
 #define XGMAC_DMA_CH_TX_CONTROL(x)	(0x00003104 + (0x80 * (x)))
+#define XGMAC_EDSE			BIT(28)
 #define XGMAC_TxPBL			GENMASK(21, 16)
 #define XGMAC_TxPBL_SHIFT		16
 #define XGMAC_TSE			BIT(12)
@@ -404,6 +414,9 @@
 #define XGMAC_REGSIZE			((0x0000317c + (0x80 * 15)) / 4)
 
 /* Descriptors */
+#define XGMAC_TDES0_LTV			BIT(31)
+#define XGMAC_TDES0_LT			GENMASK(7, 0)
+#define XGMAC_TDES1_LT			GENMASK(31, 8)
 #define XGMAC_TDES2_IVT			GENMASK(31, 16)
 #define XGMAC_TDES2_IVT_SHIFT		16
 #define XGMAC_TDES2_IOC			BIT(31)
@@ -422,6 +435,7 @@
 #define XGMAC_TDES3_TCMSSV		BIT(26)
 #define XGMAC_TDES3_SAIC		GENMASK(25, 23)
 #define XGMAC_TDES3_SAIC_SHIFT		23
+#define XGMAC_TDES3_TBSV		BIT(24)
 #define XGMAC_TDES3_THL			GENMASK(22, 19)
 #define XGMAC_TDES3_THL_SHIFT		19
 #define XGMAC_TDES3_IVTIR		GENMASK(19, 18)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index bd5838ce1e8a..7b3f054ba415 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -339,6 +339,14 @@ static void dwxgmac2_set_vlan(struct dma_desc *p, u32 type)
 	p->des2 |= cpu_to_le32(type & XGMAC_TDES2_VTIR);
 }
 
+static void dwxgmac2_set_tbs(struct dma_edesc *p, u32 sec, u32 nsec)
+{
+	p->des4 = cpu_to_le32((sec & XGMAC_TDES0_LT) | XGMAC_TDES0_LTV);
+	p->des5 = cpu_to_le32((nsec >> XGMAC_LT_SHIFT) & XGMAC_TDES1_LT);
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

