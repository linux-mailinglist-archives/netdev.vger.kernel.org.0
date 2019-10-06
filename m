Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6F6CD1A3
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 13:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfJFLR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 07:17:29 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:50030 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfJFLR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 07:17:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9230FC03B1;
        Sun,  6 Oct 2019 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570360648; bh=TCnuD7ST5ILnum1CP+NipPAW9rfdx0oXmNK8a18Tmik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=MMD/XXp49v1s9kVmb1aYJL46/TiUtrBRJS0wrGhPhW6gmFob821KguGj6fkWVsp3u
         dUb+7qoGIQNyNHYtK34Qi86HdsHo7ORV3GpGb9168vCjDe0KILOQayrrCEsCnXaSVc
         SkthMLUF0L2t7N11SVe8hK0Wq82CB2hqL5JAyg9Yq3QFvjGXUiqlUiOAtBh61q1Qyk
         ViDvWHFfu13TyPk4J0svzoAIJKZojTh/dnVJ5Umt4bzqqQJ+8Q7Xv2XKFKP089nx6E
         XfZIvqCzMEDbFSo5mDAMjkB66kYenS6A9Fvryz6jf0j4KVVxeq6BNDlOaaxtGfDCxY
         qHMTSkhcydrHQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 174B0A0068;
        Sun,  6 Oct 2019 11:17:26 +0000 (UTC)
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
Subject: [PATCH net-next 3/3] net: stmmac: Implement L3/L4 Filters in GMAC4+
Date:   Sun,  6 Oct 2019 13:17:14 +0200
Message-Id: <228bda8c149785c3b313d04a908b080b64ee0c37.1570360411.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1570360411.git.Jose.Abreu@synopsys.com>
References: <cover.1570360411.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1570360411.git.Jose.Abreu@synopsys.com>
References: <cover.1570360411.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>

GMAC4+ cores support Layer 3 and Layer 4 filtering. Add the
corresponding callbacks in these cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  21 +++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 106 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |   1 +
 3 files changed, 128 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 2fe45fa3c482..07e97f45755d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -43,6 +43,10 @@
 #define GMAC_ARP_ADDR			0x00000210
 #define GMAC_ADDR_HIGH(reg)		(0x300 + reg * 8)
 #define GMAC_ADDR_LOW(reg)		(0x304 + reg * 8)
+#define GMAC_L3L4_CTRL(reg)		(0x900 + (reg) * 0x30)
+#define GMAC_L4_ADDR(reg)		(0x904 + (reg) * 0x30)
+#define GMAC_L3_ADDR0(reg)		(0x910 + (reg) * 0x30)
+#define GMAC_L3_ADDR1(reg)		(0x914 + (reg) * 0x30)
 
 /* RX Queues Routing */
 #define GMAC_RXQCTRL_AVCPQ_MASK		GENMASK(2, 0)
@@ -67,6 +71,7 @@
 #define GMAC_PACKET_FILTER_PCF		BIT(7)
 #define GMAC_PACKET_FILTER_HPF		BIT(10)
 #define GMAC_PACKET_FILTER_VTFE		BIT(16)
+#define GMAC_PACKET_FILTER_IPFE		BIT(20)
 
 #define GMAC_MAX_PERFECT_ADDRESSES	128
 
@@ -202,6 +207,7 @@ enum power_event {
 #define GMAC_HW_FEAT_MIISEL		BIT(0)
 
 /* MAC HW features1 bitmap */
+#define GMAC_HW_FEAT_L3L4FNUM		GENMASK(30, 27)
 #define GMAC_HW_HASH_TB_SZ		GENMASK(25, 24)
 #define GMAC_HW_FEAT_AVSEL		BIT(20)
 #define GMAC_HW_TSOEN			BIT(18)
@@ -228,6 +234,21 @@ enum power_event {
 #define GMAC_HI_DCS_SHIFT		16
 #define GMAC_HI_REG_AE			BIT(31)
 
+/* L3/L4 Filters regs */
+#define GMAC_L4DPIM0			BIT(21)
+#define GMAC_L4DPM0			BIT(20)
+#define GMAC_L4SPIM0			BIT(19)
+#define GMAC_L4SPM0			BIT(18)
+#define GMAC_L4PEN0			BIT(16)
+#define GMAC_L3DAIM0			BIT(5)
+#define GMAC_L3DAM0			BIT(4)
+#define GMAC_L3SAIM0			BIT(3)
+#define GMAC_L3SAM0			BIT(2)
+#define GMAC_L3PEN0			BIT(0)
+#define GMAC_L4DP0			GENMASK(31, 16)
+#define GMAC_L4DP0_SHIFT		16
+#define GMAC_L4SP0			GENMASK(15, 0)
+
 /*  MTL registers */
 #define MTL_OPERATION_MODE		0x00000c00
 #define MTL_FRPE			BIT(15)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 1a04815d1d65..dda3e5b50f4d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -809,6 +809,106 @@ static void dwmac4_set_arp_offload(struct mac_device_info *hw, bool en,
 	writel(value, ioaddr + GMAC_CONFIG);
 }
 
+static int dwmac4_config_l3_filter(struct mac_device_info *hw, u32 filter_no,
+				   bool en, bool ipv6, bool sa, bool inv,
+				   u32 match)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = readl(ioaddr + GMAC_PACKET_FILTER);
+	value |= GMAC_PACKET_FILTER_IPFE;
+	writel(value, ioaddr + GMAC_PACKET_FILTER);
+
+	value = readl(ioaddr + GMAC_L3L4_CTRL(filter_no));
+
+	/* For IPv6 not both SA/DA filters can be active */
+	if (ipv6) {
+		value |= GMAC_L3PEN0;
+		value &= ~(GMAC_L3SAM0 | GMAC_L3SAIM0);
+		value &= ~(GMAC_L3DAM0 | GMAC_L3DAIM0);
+		if (sa) {
+			value |= GMAC_L3SAM0;
+			if (inv)
+				value |= GMAC_L3SAIM0;
+		} else {
+			value |= GMAC_L3DAM0;
+			if (inv)
+				value |= GMAC_L3DAIM0;
+		}
+	} else {
+		value &= ~GMAC_L3PEN0;
+		if (sa) {
+			value |= GMAC_L3SAM0;
+			if (inv)
+				value |= GMAC_L3SAIM0;
+		} else {
+			value |= GMAC_L3DAM0;
+			if (inv)
+				value |= GMAC_L3DAIM0;
+		}
+	}
+
+	writel(value, ioaddr + GMAC_L3L4_CTRL(filter_no));
+
+	if (sa) {
+		writel(match, ioaddr + GMAC_L3_ADDR0(filter_no));
+	} else {
+		writel(match, ioaddr + GMAC_L3_ADDR1(filter_no));
+	}
+
+	if (!en)
+		writel(0, ioaddr + GMAC_L3L4_CTRL(filter_no));
+
+	return 0;
+}
+
+static int dwmac4_config_l4_filter(struct mac_device_info *hw, u32 filter_no,
+				   bool en, bool udp, bool sa, bool inv,
+				   u32 match)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = readl(ioaddr + GMAC_PACKET_FILTER);
+	value |= GMAC_PACKET_FILTER_IPFE;
+	writel(value, ioaddr + GMAC_PACKET_FILTER);
+
+	value = readl(ioaddr + GMAC_L3L4_CTRL(filter_no));
+	if (udp) {
+		value |= GMAC_L4PEN0;
+	} else {
+		value &= ~GMAC_L4PEN0;
+	}
+
+	value &= ~(GMAC_L4SPM0 | GMAC_L4SPIM0);
+	value &= ~(GMAC_L4DPM0 | GMAC_L4DPIM0);
+	if (sa) {
+		value |= GMAC_L4SPM0;
+		if (inv)
+			value |= GMAC_L4SPIM0;
+	} else {
+		value |= GMAC_L4DPM0;
+		if (inv)
+			value |= GMAC_L4DPIM0;
+	}
+
+	writel(value, ioaddr + GMAC_L3L4_CTRL(filter_no));
+
+	if (sa) {
+		value = match & GMAC_L4SP0;
+	} else {
+		value = (match << GMAC_L4DP0_SHIFT) & GMAC_L4DP0;
+	}
+
+	writel(value, ioaddr + GMAC_L4_ADDR(filter_no));
+
+	if (!en)
+		writel(0, ioaddr + GMAC_L3L4_CTRL(filter_no));
+
+	return 0;
+}
+
 const struct stmmac_ops dwmac4_ops = {
 	.core_init = dwmac4_core_init,
 	.set_mac = stmmac_set_mac,
@@ -843,6 +943,8 @@ const struct stmmac_ops dwmac4_ops = {
 	.sarc_configure = dwmac4_sarc_configure,
 	.enable_vlan = dwmac4_enable_vlan,
 	.set_arp_offload = dwmac4_set_arp_offload,
+	.config_l3_filter = dwmac4_config_l3_filter,
+	.config_l4_filter = dwmac4_config_l4_filter,
 };
 
 const struct stmmac_ops dwmac410_ops = {
@@ -879,6 +981,8 @@ const struct stmmac_ops dwmac410_ops = {
 	.sarc_configure = dwmac4_sarc_configure,
 	.enable_vlan = dwmac4_enable_vlan,
 	.set_arp_offload = dwmac4_set_arp_offload,
+	.config_l3_filter = dwmac4_config_l3_filter,
+	.config_l4_filter = dwmac4_config_l4_filter,
 };
 
 const struct stmmac_ops dwmac510_ops = {
@@ -920,6 +1024,8 @@ const struct stmmac_ops dwmac510_ops = {
 	.sarc_configure = dwmac4_sarc_configure,
 	.enable_vlan = dwmac4_enable_vlan,
 	.set_arp_offload = dwmac4_set_arp_offload,
+	.config_l3_filter = dwmac4_config_l3_filter,
+	.config_l4_filter = dwmac4_config_l4_filter,
 };
 
 int dwmac4_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 229059cef949..b24c89572745 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -364,6 +364,7 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 
 	/* MAC HW feature1 */
 	hw_cap = readl(ioaddr + GMAC_HW_FEATURE1);
+	dma_cap->l3l4fnum = (hw_cap & GMAC_HW_FEAT_L3L4FNUM) >> 27;
 	dma_cap->hash_tb_sz = (hw_cap & GMAC_HW_HASH_TB_SZ) >> 24;
 	dma_cap->av = (hw_cap & GMAC_HW_FEAT_AVSEL) >> 20;
 	dma_cap->tsoen = (hw_cap & GMAC_HW_TSOEN) >> 18;
-- 
2.7.4

