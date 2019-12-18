Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0716F1244A4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfLRKdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:33:22 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:46422 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbfLRKdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:33:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E7474405C2;
        Wed, 18 Dec 2019 10:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576665201; bh=Fw/wxllDxuOcPqlon9LuMR4ARnCLZnT8SI3l2BMKDYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ZtbEWVVeMXkCkkyp9rBWVFP/98649syGf8d00FYFKv69EXDuZIyBgWNVCtPrhsZw1
         lQ9WvWq6OSGc3ienSS6ZWMmYKIKB7wwk1bp0AiMkj2Mc99H9v51PO4mS/jb/zKrh8M
         0F7SPp6IUaHT/GnXpWaM1sePlHT6O+0R5WywJaaXBWhZFgyTOY14nhhClD8v8kozWZ
         4KB5CXJFhd/gU8MHhWHMrquxGtLvMUGra0qFar93n/P4jt29pwzzcCHvxCnXYhfE2G
         DUtOdWLmaLLWBuh5fPo6r+IwAxKMNnMlZ65/9LabdF8Eu7zmK6lzlBYTW69QzQxU+E
         dQEfM6hq4g+gQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B31B1A00AC;
        Wed, 18 Dec 2019 10:33:19 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Richard.Ong@synopsys.com, Boon Leong <boon.leong.ong@intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: stmmac: xgmac3+: Add support for Frame Preemption
Date:   Wed, 18 Dec 2019 11:33:10 +0100
Message-Id: <25588fca643d1f837b35eda49653b974ef9e5ae4.1576664870.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the HW specific support for Frame Preemption on XGMAC3+ cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  6 ++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 24 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 77a48dece556..d8f2c5b24278 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -73,6 +73,9 @@
 #define XGMAC_RXQ_CTRL0			0x000000a0
 #define XGMAC_RXQEN(x)			GENMASK((x) * 2 + 1, (x) * 2)
 #define XGMAC_RXQEN_SHIFT(x)		((x) * 2)
+#define XGMAC_RXQ_CTRL1			0x000000a4
+#define XGMAC_RQ			GENMASK(7, 4)
+#define XGMAC_RQ_SHIFT			4
 #define XGMAC_RXQ_CTRL2			0x000000a8
 #define XGMAC_RXQ_CTRL3			0x000000ac
 #define XGMAC_PSRQ(x)			GENMASK((x) * 8 + 7, (x) * 8)
@@ -136,6 +139,7 @@
 #define XGMAC_HWFEAT_TXQCNT		GENMASK(9, 6)
 #define XGMAC_HWFEAT_RXQCNT		GENMASK(3, 0)
 #define XGMAC_HW_FEATURE3		0x00000128
+#define XGMAC_HWFEAT_FPESEL		BIT(26)
 #define XGMAC_HWFEAT_ESTWID		GENMASK(24, 23)
 #define XGMAC_HWFEAT_ESTDEP		GENMASK(22, 20)
 #define XGMAC_HWFEAT_ESTSEL		BIT(19)
@@ -151,6 +155,8 @@
 #define XGMAC_MDIO_ADDR			0x00000200
 #define XGMAC_MDIO_DATA			0x00000204
 #define XGMAC_MDIO_C22P			0x00000220
+#define XGMAC_FPE_CTRL_STS		0x00000280
+#define XGMAC_EFPE			BIT(0)
 #define XGMAC_ADDRx_HIGH(x)		(0x00000300 + (x) * 0x8)
 #define XGMAC_ADDR_MAX			32
 #define XGMAC_AE			BIT(31)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 2f6e960947d9..307105e8dea0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1410,6 +1410,29 @@ static int dwxgmac3_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 	return 0;
 }
 
+static void dwxgmac3_fpe_configure(void __iomem *ioaddr, u32 num_txq,
+				   u32 num_rxq, bool enable)
+{
+	u32 value;
+
+	if (!enable) {
+		value = readl(ioaddr + XGMAC_FPE_CTRL_STS);
+
+		value &= ~XGMAC_EFPE;
+
+		writel(value, ioaddr + XGMAC_FPE_CTRL_STS);
+	}
+
+	value = readl(ioaddr + XGMAC_RXQ_CTRL1);
+	value &= ~XGMAC_RQ;
+	value |= (num_rxq - 1) << XGMAC_RQ_SHIFT;
+	writel(value, ioaddr + XGMAC_RXQ_CTRL1);
+
+	value = readl(ioaddr + XGMAC_FPE_CTRL_STS);
+	value |= XGMAC_EFPE;
+	writel(value, ioaddr + XGMAC_FPE_CTRL_STS);
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1454,6 +1477,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.config_l4_filter = dwxgmac2_config_l4_filter,
 	.set_arp_offload = dwxgmac2_set_arp_offload,
 	.est_configure = dwxgmac3_est_configure,
+	.fpe_configure = dwxgmac3_fpe_configure,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 3b8887243803..5b62417ad9a4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -413,6 +413,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 
 	/* MAC HW feature 3 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE3);
+	dma_cap->fpesel = (hw_cap & XGMAC_HWFEAT_FPESEL) >> 26;
 	dma_cap->estwid = (hw_cap & XGMAC_HWFEAT_ESTWID) >> 23;
 	dma_cap->estdep = (hw_cap & XGMAC_HWFEAT_ESTDEP) >> 20;
 	dma_cap->estsel = (hw_cap & XGMAC_HWFEAT_ESTSEL) >> 19;
-- 
2.7.4

