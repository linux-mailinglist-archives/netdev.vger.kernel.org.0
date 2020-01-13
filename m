Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8333C1395CE
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgAMQYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:24:44 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:37190 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728852AbgAMQYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:24:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BC4E8C05D9;
        Mon, 13 Jan 2020 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578932661; bh=SJfJtymLuA5sj3nU7fhk3qVinT8jJUkDJ/b0uHZWdKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gZq5h5xI2rNniQyqmzgpkAiagYaa5kL/Z0VZaXoUZ15KZ0oOiDNI6dgEEpMcp5lkn
         GdAzT4SzmxUf554L9XKegVuJzmeXVIWehuECmZIGLzBihh/cSg/6skaNa9nD7TG8DT
         aUo965DstNQxTubf82for/NnTzxmqMyFKeS+s3H59DPIiO+uAS/GmhLLLEpERF41ga
         N0D799pMCG3UkNMUA3oCj2VYQcSQr0QmqAG0Sbh2uEUzgfVbMsZD0jUoYOsVqOpPIm
         POZ7ECdVZuKlRyyA/bXcZUfuw6MEmZrYJ7HkyyQtVcYKYcD4U/LH0+Eb7Bn6tED4F0
         7Tzy3OtuRjtOg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 76E2FA006A;
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
Subject: [PATCH net-next v3 4/8] net: stmmac: gmac4+: Add TBS support
Date:   Mon, 13 Jan 2020 17:24:12 +0100
Message-Id: <7829e3558fbc67d217946a0271cc4f48da26876b.1578932287.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds all the necessary HW hooks to support TBS feature in QoS cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c | 10 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h |  7 +++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   | 21 +++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |  7 +++++++
 5 files changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 2e6b60a476c6..af50af27550b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -239,6 +239,7 @@ enum power_event {
 
 /* MAC HW features3 bitmap */
 #define GMAC_HW_FEAT_ASP		GENMASK(29, 28)
+#define GMAC_HW_FEAT_TBSSEL		BIT(27)
 #define GMAC_HW_FEAT_FPESEL		BIT(26)
 #define GMAC_HW_FEAT_ESTWID		GENMASK(21, 20)
 #define GMAC_HW_FEAT_ESTDEP		GENMASK(19, 17)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index 3e14da69f378..eff82065a501 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -10,6 +10,7 @@
 
 #include <linux/stmmac.h>
 #include "common.h"
+#include "dwmac4.h"
 #include "dwmac4_descs.h"
 
 static int dwmac4_wrback_get_tx_status(void *data, struct stmmac_extra_stats *x,
@@ -505,6 +506,14 @@ static void dwmac4_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
 	p->des3 = cpu_to_le32(upper_32_bits(addr) | RDES3_BUFFER2_VALID_ADDR);
 }
 
+static void dwmac4_set_tbs(struct dma_edesc *p, u32 sec, u32 nsec)
+{
+	p->des4 = cpu_to_le32((sec & TDES4_LT) | TDES4_LTV);
+	p->des5 = cpu_to_le32(nsec & TDES5_LT);
+	p->des6 = 0;
+	p->des7 = 0;
+}
+
 const struct stmmac_desc_ops dwmac4_desc_ops = {
 	.tx_status = dwmac4_wrback_get_tx_status,
 	.rx_status = dwmac4_wrback_get_rx_status,
@@ -534,6 +543,7 @@ const struct stmmac_desc_ops dwmac4_desc_ops = {
 	.set_vlan = dwmac4_set_vlan,
 	.get_rx_header_len = dwmac4_get_rx_header_len,
 	.set_sec_addr = dwmac4_set_sec_addr,
+	.set_tbs = dwmac4_set_tbs,
 };
 
 const struct stmmac_mode_ops dwmac4_ring_mode_ops = {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h
index 6d92109dc9aa..6da070ccd737 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h
@@ -73,6 +73,13 @@
 #define TDES3_CONTEXT_TYPE		BIT(30)
 #define	TDES3_CONTEXT_TYPE_SHIFT	30
 
+/* TDES4 */
+#define TDES4_LTV			BIT(31)
+#define TDES4_LT			GENMASK(7, 0)
+
+/* TDES5 */
+#define TDES5_LT			GENMASK(31, 8)
+
 /* TDS3 use for both format (read and write back) */
 #define TDES3_OWN			BIT(31)
 #define TDES3_OWN_SHIFT			31
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 213d44482ffa..bb29bfcd62c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -404,6 +404,7 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 
 	/* 5.10 Features */
 	dma_cap->asp = (hw_cap & GMAC_HW_FEAT_ASP) >> 28;
+	dma_cap->tbssel = (hw_cap & GMAC_HW_FEAT_TBSSEL) >> 27;
 	dma_cap->fpesel = (hw_cap & GMAC_HW_FEAT_FPESEL) >> 26;
 	dma_cap->estwid = (hw_cap & GMAC_HW_FEAT_ESTWID) >> 20;
 	dma_cap->estdep = (hw_cap & GMAC_HW_FEAT_ESTDEP) >> 17;
@@ -471,6 +472,25 @@ static void dwmac4_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
 	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
 }
 
+static int dwmac4_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
+{
+	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+
+	if (en)
+		value |= DMA_CONTROL_EDSE;
+	else
+		value &= ~DMA_CONTROL_EDSE;
+
+	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+
+	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan)) & DMA_CONTROL_EDSE;
+	if (en && !value)
+		return -EIO;
+
+	writel(DMA_TBS_DEF_FTOS, ioaddr + DMA_TBS_CTRL);
+	return 0;
+}
+
 const struct stmmac_dma_ops dwmac4_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
@@ -527,4 +547,5 @@ const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.qmode = dwmac4_qmode,
 	.set_bfsize = dwmac4_set_bfsize,
 	.enable_sph = dwmac4_enable_sph,
+	.enable_tbs = dwmac4_enable_tbs,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index bcb6d5190f3d..8391ca63d943 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -22,6 +22,7 @@
 #define DMA_DEBUG_STATUS_1		0x00001010
 #define DMA_DEBUG_STATUS_2		0x00001014
 #define DMA_AXI_BUS_MODE		0x00001028
+#define DMA_TBS_CTRL			0x00001050
 
 /* DMA Bus Mode bitmap */
 #define DMA_BUS_MODE_SFT_RESET		BIT(0)
@@ -82,6 +83,11 @@
 
 #define DMA_AXI_BURST_LEN_MASK		0x000000FE
 
+/* DMA TBS Control */
+#define DMA_TBS_FTOS			GENMASK(31, 8)
+#define DMA_TBS_FTOV			BIT(0)
+#define DMA_TBS_DEF_FTOS		(DMA_TBS_FTOS | DMA_TBS_FTOV)
+
 /* Following DMA defines are chanels oriented */
 #define DMA_CHAN_BASE_ADDR		0x00001100
 #define DMA_CHAN_BASE_OFFSET		0x80
@@ -114,6 +120,7 @@
 #define DMA_CONTROL_MSS_MASK		GENMASK(13, 0)
 
 /* DMA Tx Channel X Control register defines */
+#define DMA_CONTROL_EDSE		BIT(28)
 #define DMA_CONTROL_TSE			BIT(12)
 #define DMA_CONTROL_OSP			BIT(4)
 #define DMA_CONTROL_ST			BIT(0)
-- 
2.7.4

