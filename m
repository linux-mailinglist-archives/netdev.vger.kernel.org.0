Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB95AED61
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbfIJOld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:41:33 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:42900 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732106AbfIJOlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 10:41:32 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 61E27C2B55;
        Tue, 10 Sep 2019 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568126491; bh=WXb3k5kCzoIqB0+MtuE+z0LkMBJLvWOptqMwOn7VXow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DaRe0YkgTbbaPL71rZVUpSLT35ofKxuwgfuk4lS6ziJpDwHFBg6hojL0xGWP0dSJf
         Y4bEm+bCfQKysQaqSKPuRQvL73WiG3cECCtImeez0muWjLEztjnxGwrPtPpj5XHAii
         h8newO+ZVZRf57KgmaTzECB1MLy4J1Va5H2tCN2yu2xAwydL4dvrjYgnoqy+PT8PyC
         nOQ9rrAhuBZJJJQcsf0TxdxUjLs/hZ26vwYdRouWpiX1AH/Cs0+E9ycfsdmw4n+hJ1
         TfV2YOO1LCjHf1g+QSMrKZV02FJv1E9PUQFE0EFeWMcBhZcqgGjmvSh7yKVUdvAfl/
         ksZzbVHL62hzA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 24FAAA006F;
        Tue, 10 Sep 2019 14:41:30 +0000 (UTC)
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
Subject: [PATCH net-next 6/6] net: stmmac: ARP Offload for GMAC4+ Cores
Date:   Tue, 10 Sep 2019 16:41:27 +0200
Message-Id: <9423c111db514a03abfe6ee7f74052245a859d1f.1568126225.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the ARP Offload feature in GMAC4 and GMAC5 cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  3 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 19 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index e88dac1dd765..89a3420eba42 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -40,6 +40,7 @@
 #define GMAC_HW_FEATURE3		0x00000128
 #define GMAC_MDIO_ADDR			0x00000200
 #define GMAC_MDIO_DATA			0x00000204
+#define GMAC_ARP_ADDR			0x00000210
 #define GMAC_ADDR_HIGH(reg)		(0x300 + reg * 8)
 #define GMAC_ADDR_LOW(reg)		(0x304 + reg * 8)
 
@@ -165,6 +166,7 @@ enum power_event {
 #define GMAC_DEBUG_RPESTS		BIT(0)
 
 /* MAC config */
+#define GMAC_CONFIG_ARPEN		BIT(31)
 #define GMAC_CONFIG_SARC		GENMASK(30, 28)
 #define GMAC_CONFIG_SARC_SHIFT		28
 #define GMAC_CONFIG_IPC			BIT(27)
@@ -188,6 +190,7 @@ enum power_event {
 #define GMAC_HW_FEAT_TXCOSEL		BIT(14)
 #define GMAC_HW_FEAT_EEESEL		BIT(13)
 #define GMAC_HW_FEAT_TSSEL		BIT(12)
+#define GMAC_HW_FEAT_ARPOFFSEL		BIT(9)
 #define GMAC_HW_FEAT_MMCSEL		BIT(8)
 #define GMAC_HW_FEAT_MGKSEL		BIT(7)
 #define GMAC_HW_FEAT_RWKSEL		BIT(6)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index a99effe61325..9b4b5f69fc02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -782,6 +782,22 @@ static void dwmac4_enable_vlan(struct mac_device_info *hw, u32 type)
 	writel(value, ioaddr + GMAC_VLAN_INCL);
 }
 
+static void dwmac4_set_arp_offload(struct mac_device_info *hw, bool en,
+				   u32 addr)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	writel(addr, ioaddr + GMAC_ARP_ADDR);
+
+	value = readl(ioaddr + GMAC_CONFIG);
+	if (en)
+		value |= GMAC_CONFIG_ARPEN;
+	else
+		value &= ~GMAC_CONFIG_ARPEN;
+	writel(value, ioaddr + GMAC_CONFIG);
+}
+
 const struct stmmac_ops dwmac4_ops = {
 	.core_init = dwmac4_core_init,
 	.set_mac = stmmac_set_mac,
@@ -815,6 +831,7 @@ const struct stmmac_ops dwmac4_ops = {
 	.update_vlan_hash = dwmac4_update_vlan_hash,
 	.sarc_configure = dwmac4_sarc_configure,
 	.enable_vlan = dwmac4_enable_vlan,
+	.set_arp_offload = dwmac4_set_arp_offload,
 };
 
 const struct stmmac_ops dwmac410_ops = {
@@ -850,6 +867,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.update_vlan_hash = dwmac4_update_vlan_hash,
 	.sarc_configure = dwmac4_sarc_configure,
 	.enable_vlan = dwmac4_enable_vlan,
+	.set_arp_offload = dwmac4_set_arp_offload,
 };
 
 const struct stmmac_ops dwmac510_ops = {
@@ -890,6 +908,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.update_vlan_hash = dwmac4_update_vlan_hash,
 	.sarc_configure = dwmac4_sarc_configure,
 	.enable_vlan = dwmac4_enable_vlan,
+	.set_arp_offload = dwmac4_set_arp_offload,
 };
 
 int dwmac4_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index f3ca0236450d..68c157979b94 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -349,6 +349,7 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->tx_coe = (hw_cap & GMAC_HW_FEAT_TXCOSEL) >> 14;
 	dma_cap->rx_coe =  (hw_cap & GMAC_HW_FEAT_RXCOESEL) >> 16;
 	dma_cap->vlins = (hw_cap & GMAC_HW_FEAT_SAVLANINS) >> 27;
+	dma_cap->arpoffsel = (hw_cap & GMAC_HW_FEAT_ARPOFFSEL) >> 9;
 
 	/* MAC HW feature1 */
 	hw_cap = readl(ioaddr + GMAC_HW_FEATURE1);
-- 
2.7.4

