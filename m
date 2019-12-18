Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8888C1244A7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLRKdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:33:23 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:46382 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfLRKdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:33:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DB48C405BF;
        Wed, 18 Dec 2019 10:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576665201; bh=Rl8X5VQHKz1HG6QQrBXkDv4iSU6x7MqhJR+ess8GXRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=QGdwmFUOadrea/TEcJqzasyLJE+8IuEaqgYhXXZGQXgRV9x/fjvaARrDRSEwVNWnC
         DRmeAI17I57o0bnk90BDctRZ2FweqxgBFLcSVGuqaLh6uq7yxcaoKLrQQm/oMVZHlT
         k5PJCTzK7XLaPuCyyYVLYdwNdiA3T5PfDnxKAdVZkIHQY1yobYiBnoByEWNN2yOOLp
         Tvyv3FCypX7qoEdOunxPZKzMXJDSaJ1e7c7ca4qwqKMhp/Y3TrJRo4mW1HqSdJBTbt
         7d2sT08q3vzmGqeypjbSWrbo6+3ccdOS7jQlYTLYNnkr8DgN8+dUOx0BuyZ+XG3t9G
         dOfqh7s0dmJGA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9D168A00A7;
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
Subject: [PATCH net-next 5/7] net: stmmac: gmac5+: Add support for Frame Preemption
Date:   Wed, 18 Dec 2019 11:33:09 +0100
Message-Id: <3ad6e3561cd5d08279419037a50b5a6b55a29aeb.1576664870.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576664870.git.Jose.Abreu@synopsys.com>
References: <cover.1576664870.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the HW specific support for Frame Preemption on GMAC5+ cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  3 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  2 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c      | 23 +++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h      |  5 +++++
 5 files changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index f7f5a2751147..2e6b60a476c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -64,6 +64,8 @@
 #define GMAC_RXQCTRL_MCBCQEN_SHIFT	20
 #define GMAC_RXQCTRL_TACPQE		BIT(21)
 #define GMAC_RXQCTRL_TACPQE_SHIFT	21
+#define GMAC_RXQCTRL_FPRQ		GENMASK(26, 24)
+#define GMAC_RXQCTRL_FPRQ_SHIFT		24
 
 /* MAC Packet Filtering */
 #define GMAC_PACKET_FILTER_PR		BIT(0)
@@ -237,6 +239,7 @@ enum power_event {
 
 /* MAC HW features3 bitmap */
 #define GMAC_HW_FEAT_ASP		GENMASK(29, 28)
+#define GMAC_HW_FEAT_FPESEL		BIT(26)
 #define GMAC_HW_FEAT_ESTWID		GENMASK(21, 20)
 #define GMAC_HW_FEAT_ESTDEP		GENMASK(19, 17)
 #define GMAC_HW_FEAT_ESTSEL		BIT(16)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 8df7496411a0..f0c0ea616032 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -985,6 +985,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
+	.fpe_configure = dwmac5_fpe_configure,
 };
 
 const struct stmmac_ops dwmac510_ops = {
@@ -1029,6 +1030,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
+	.fpe_configure = dwmac5_fpe_configure,
 };
 
 int dwmac4_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 3552ce1201ff..213d44482ffa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -404,6 +404,7 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 
 	/* 5.10 Features */
 	dma_cap->asp = (hw_cap & GMAC_HW_FEAT_ASP) >> 28;
+	dma_cap->fpesel = (hw_cap & GMAC_HW_FEAT_FPESEL) >> 26;
 	dma_cap->estwid = (hw_cap & GMAC_HW_FEAT_ESTWID) >> 20;
 	dma_cap->estdep = (hw_cap & GMAC_HW_FEAT_ESTDEP) >> 17;
 	dma_cap->estsel = (hw_cap & GMAC_HW_FEAT_ESTSEL) >> 16;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 8047f402fb3f..5d4a3c2458ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -645,3 +645,26 @@ int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 	writel(ctrl, ioaddr + MTL_EST_CONTROL);
 	return 0;
 }
+
+void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
+			  bool enable)
+{
+	u32 value;
+
+	if (!enable) {
+		value = readl(ioaddr + MAC_FPE_CTRL_STS);
+
+		value &= ~EFPE;
+
+		writel(value, ioaddr + MAC_FPE_CTRL_STS);
+	}
+
+	value = readl(ioaddr + GMAC_RXQ_CTRL1);
+	value &= ~GMAC_RXQCTRL_FPRQ;
+	value |= (num_rxq - 1) << GMAC_RXQCTRL_FPRQ_SHIFT;
+	writel(value, ioaddr + GMAC_RXQ_CTRL1);
+
+	value = readl(ioaddr + MAC_FPE_CTRL_STS);
+	value |= EFPE;
+	writel(value, ioaddr + MAC_FPE_CTRL_STS);
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 70e6d8837dd9..3e8faa96b4d4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -11,6 +11,9 @@
 #define PRTYEN				BIT(1)
 #define TMOUTEN				BIT(0)
 
+#define MAC_FPE_CTRL_STS		0x00000234
+#define EFPE				BIT(0)
+
 #define MAC_PPS_CONTROL			0x00000b70
 #define PPS_MAXIDX(x)			((((x) + 1) * 8) - 1)
 #define PPS_MINIDX(x)			((x) * 8)
@@ -102,5 +105,7 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 			   u32 sub_second_inc, u32 systime_flags);
 int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 			 unsigned int ptp_rate);
+void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
+			  bool enable);
 
 #endif /* __DWMAC5_H__ */
-- 
2.7.4

