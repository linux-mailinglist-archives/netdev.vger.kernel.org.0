Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824611CC2D
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfENPqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 11:46:48 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:35776 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbfENPpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 11:45:41 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 06574C0A5F;
        Tue, 14 May 2019 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557848732; bh=TR7YyPM2EDtX+J8pihIwG0EQP8FAA7ze5/BCUlDz3pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DvE2NCvo+zt/N1OIFTsRqV4Yci9fdJlZyXFK02X4tYlT47VOUPsiTqo5Js5xhf96f
         RkYgYWErt60LzbC/rG2+tRDEF7LpOXt1bz0EHAC/WFje9/nZY56AeeYPDBFemgNVo5
         Fe23bawm7zeS+MjqEC7q97FMdeti5a2JJ9M9OXyZQdZ6sPs0z9ftfMwC3kIcaPbM/l
         lukGsu7fkEcyPPFp83qocqEjSE81Gu5XLj7xiEiB5KcC0UJ5hnxMGdjBpTeEk8Zpap
         qDgyedOZbQgqPmCzbpGjZOj/wrBBhv28D2rhd+WYBanp+9Wut7sQQmpteSCls/sBwC
         VviiXgMRHkF7A==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 320A2A024F;
        Tue, 14 May 2019 15:45:41 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 8BC443EA27;
        Tue, 14 May 2019 17:45:39 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [RFC net-next v2 07/14] net: stmmac: Switch MMC functions to HWIF callbacks
Date:   Tue, 14 May 2019 17:45:29 +0200
Message-Id: <bc9fd252973ca2f17cf34c847e3e5b79e393ede0.1557848472.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557848472.git.joabreu@synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XGMAC has a different MMC module. Lets use HWIF callbacks for MMC module
so that correct callbacks are automatically selected.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h         |  1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.c           |  9 +++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h           | 17 +++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/mmc.h            |  4 ----
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c       | 13 ++++++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  4 ++--
 7 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 272b9ca66314..1961fe9144ca 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -424,6 +424,7 @@ struct mac_device_info {
 	const struct stmmac_mode_ops *mode;
 	const struct stmmac_hwtimestamp *ptp;
 	const struct stmmac_tc_ops *tc;
+	const struct stmmac_mmc_ops *mmc;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index 81b966a8261b..6c61b753b55e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -81,6 +81,7 @@ static const struct stmmac_hwif_entry {
 	const void *hwtimestamp;
 	const void *mode;
 	const void *tc;
+	const void *mmc;
 	int (*setup)(struct stmmac_priv *priv);
 	int (*quirks)(struct stmmac_priv *priv);
 } stmmac_hw[] = {
@@ -100,6 +101,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = NULL,
+		.mmc = &dwmac_mmc_ops,
 		.setup = dwmac100_setup,
 		.quirks = stmmac_dwmac1_quirks,
 	}, {
@@ -117,6 +119,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = NULL,
+		.mmc = &dwmac_mmc_ops,
 		.setup = dwmac1000_setup,
 		.quirks = stmmac_dwmac1_quirks,
 	}, {
@@ -134,6 +137,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = &dwmac510_tc_ops,
+		.mmc = &dwmac_mmc_ops,
 		.setup = dwmac4_setup,
 		.quirks = stmmac_dwmac4_quirks,
 	}, {
@@ -151,6 +155,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
+		.mmc = &dwmac_mmc_ops,
 		.setup = dwmac4_setup,
 		.quirks = NULL,
 	}, {
@@ -168,6 +173,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
+		.mmc = &dwmac_mmc_ops,
 		.setup = dwmac4_setup,
 		.quirks = NULL,
 	}, {
@@ -185,6 +191,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
+		.mmc = &dwmac_mmc_ops,
 		.setup = dwmac4_setup,
 		.quirks = NULL,
 	}, {
@@ -202,6 +209,7 @@ static const struct stmmac_hwif_entry {
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = &dwmac510_tc_ops,
+		.mmc = NULL,
 		.setup = dwxgmac2_setup,
 		.quirks = NULL,
 	},
@@ -267,6 +275,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 		mac->ptp = mac->ptp ? : entry->hwtimestamp;
 		mac->mode = mac->mode ? : entry->mode;
 		mac->tc = mac->tc ? : entry->tc;
+		mac->mmc = mac->mmc ? : entry->mmc;
 
 		priv->hw = mac;
 		priv->ptpaddr = priv->ioaddr + entry->regs.ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 9a000dc31d9e..2acfbc70e3c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -6,6 +6,7 @@
 #define __STMMAC_HWIF_H__
 
 #include <linux/netdevice.h>
+#include <linux/stmmac.h>
 
 #define stmmac_do_void_callback(__priv, __module, __cname,  __arg0, __args...) \
 ({ \
@@ -468,6 +469,21 @@ struct stmmac_tc_ops {
 #define stmmac_tc_setup_cbs(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_cbs, __args)
 
+struct stmmac_counters;
+
+struct stmmac_mmc_ops {
+	void (*ctrl)(void __iomem *ioaddr, unsigned int mode);
+	void (*intr_all_mask)(void __iomem *ioaddr);
+	void (*read)(void __iomem *ioaddr, struct stmmac_counters *mmc);
+};
+
+#define stmmac_mmc_ctrl(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mmc, ctrl, __args)
+#define stmmac_mmc_intr_all_mask(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mmc, intr_all_mask, __args)
+#define stmmac_mmc_read(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mmc, read, __args)
+
 struct stmmac_regs_off {
 	u32 ptp_off;
 	u32 mmc_off;
@@ -486,6 +502,7 @@ extern const struct stmmac_tc_ops dwmac510_tc_ops;
 extern const struct stmmac_ops dwxgmac210_ops;
 extern const struct stmmac_dma_ops dwxgmac210_dma_ops;
 extern const struct stmmac_desc_ops dwxgmac210_desc_ops;
+extern const struct stmmac_mmc_ops dwmac_mmc_ops;
 
 #define GMAC_VERSION		0x00000020	/* GMAC CORE Version */
 #define GMAC4_VERSION		0x00000110	/* GMAC4+ CORE Version */
diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc.h b/drivers/net/ethernet/stmicro/stmmac/mmc.h
index c037326331f5..e2bd90a4d34f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc.h
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc.h
@@ -128,8 +128,4 @@ struct stmmac_counters {
 	unsigned int mmc_rx_icmp_err_octets;
 };
 
-void dwmac_mmc_ctrl(void __iomem *ioaddr, unsigned int mode);
-void dwmac_mmc_intr_all_mask(void __iomem *ioaddr);
-void dwmac_mmc_read(void __iomem *ioaddr, struct stmmac_counters *mmc);
-
 #endif /* __MMC_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
index e9b04c28980f..b8c598125cfe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc_core.c
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include "hwif.h"
 #include "mmc.h"
 
 /* MAC Management Counters register offset */
@@ -128,7 +129,7 @@
 #define MMC_RX_ICMP_GD_OCTETS		0x180
 #define MMC_RX_ICMP_ERR_OCTETS		0x184
 
-void dwmac_mmc_ctrl(void __iomem *mmcaddr, unsigned int mode)
+static void dwmac_mmc_ctrl(void __iomem *mmcaddr, unsigned int mode)
 {
 	u32 value = readl(mmcaddr + MMC_CNTRL);
 
@@ -141,7 +142,7 @@ void dwmac_mmc_ctrl(void __iomem *mmcaddr, unsigned int mode)
 }
 
 /* To mask all all interrupts.*/
-void dwmac_mmc_intr_all_mask(void __iomem *mmcaddr)
+static void dwmac_mmc_intr_all_mask(void __iomem *mmcaddr)
 {
 	writel(MMC_DEFAULT_MASK, mmcaddr + MMC_RX_INTR_MASK);
 	writel(MMC_DEFAULT_MASK, mmcaddr + MMC_TX_INTR_MASK);
@@ -153,7 +154,7 @@ void dwmac_mmc_intr_all_mask(void __iomem *mmcaddr)
  * counter after a read. So all the field of the mmc struct
  * have to be incremented.
  */
-void dwmac_mmc_read(void __iomem *mmcaddr, struct stmmac_counters *mmc)
+static void dwmac_mmc_read(void __iomem *mmcaddr, struct stmmac_counters *mmc)
 {
 	mmc->mmc_tx_octetcount_gb += readl(mmcaddr + MMC_TX_OCTETCOUNT_GB);
 	mmc->mmc_tx_framecount_gb += readl(mmcaddr + MMC_TX_FRAMECOUNT_GB);
@@ -266,3 +267,9 @@ void dwmac_mmc_read(void __iomem *mmcaddr, struct stmmac_counters *mmc)
 	mmc->mmc_rx_icmp_gd_octets += readl(mmcaddr + MMC_RX_ICMP_GD_OCTETS);
 	mmc->mmc_rx_icmp_err_octets += readl(mmcaddr + MMC_RX_ICMP_ERR_OCTETS);
 }
+
+const struct stmmac_mmc_ops dwmac_mmc_ops = {
+	.ctrl = dwmac_mmc_ctrl,
+	.intr_all_mask = dwmac_mmc_intr_all_mask,
+	.read = dwmac_mmc_read,
+};
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 3c749c327cbd..b9f29df7e98a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -537,7 +537,7 @@ static void stmmac_get_ethtool_stats(struct net_device *dev,
 	if (ret) {
 		/* If supported, for new GMAC chips expose the MMC counters */
 		if (priv->dma_cap.rmon) {
-			dwmac_mmc_read(priv->mmcaddr, &priv->mmc);
+			stmmac_mmc_read(priv, priv->mmcaddr, &priv->mmc);
 
 			for (i = 0; i < STMMAC_MMC_STATS_LEN; i++) {
 				char *p;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5ab2733e15e2..571b4a619ed6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2128,10 +2128,10 @@ static void stmmac_mmc_setup(struct stmmac_priv *priv)
 	unsigned int mode = MMC_CNTRL_RESET_ON_READ | MMC_CNTRL_COUNTER_RESET |
 			    MMC_CNTRL_PRESET | MMC_CNTRL_FULL_HALF_PRESET;
 
-	dwmac_mmc_intr_all_mask(priv->mmcaddr);
+	stmmac_mmc_intr_all_mask(priv, priv->mmcaddr);
 
 	if (priv->dma_cap.rmon) {
-		dwmac_mmc_ctrl(priv->mmcaddr, mode);
+		stmmac_mmc_ctrl(priv, priv->mmcaddr, mode);
 		memset(&priv->mmc, 0, sizeof(struct stmmac_counters));
 	} else
 		netdev_info(priv->dev, "No MAC Management Counters available\n");
-- 
2.7.4

