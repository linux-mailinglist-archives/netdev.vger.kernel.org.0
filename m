Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2160157460B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiGNHr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 03:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiGNHrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 03:47:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F1A3A480;
        Thu, 14 Jul 2022 00:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657784827; x=1689320827;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IgQIW9OcSiZMlvIj+aZi0OP3kMeCavrUReS+btvbQv4=;
  b=O383c6BWR7ftm5asE6M0eRgr+PEUlrAfSnYPHrzhNGHGJwNPfwzi+/rc
   81toUOCRH5sDpxEPGfK2p69ngdDLeS+MhroakXneOlxleWK7Xv7imjl1B
   gy7OgliSu/Rwcb93AjU9vO7odbe3si3tPzy91T15cvvzWD1p7cDzEPFFA
   lZf3lvq1pGT7BFNZYrw2CSzIlZ3aVilza4jBe8jC9yPa/rqeFKVSaK0YK
   ujYpzqSc4cgxtizh4Dcm7FxZI3jlVHvkzPYf6/LQ6Hjt1tDO1txCm9FKw
   8uV/zda8Hx7U81ZO2/hi2yj4RcskFBZxA1eZLMyGGU58F4DGAnH7e2I+E
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="286584196"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="286584196"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 00:47:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="546174593"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 14 Jul 2022 00:47:06 -0700
Received: from P12HL01TMIN.png.intel.com (P12HL01TMIN.png.intel.com [10.158.65.216])
        by linux.intel.com (Postfix) with ESMTP id E1DCC580BE0;
        Thu, 14 Jul 2022 00:47:03 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 1/1] net: stmmac: switch to use interrupt for hw crosstimestamping
Date:   Thu, 14 Jul 2022 15:54:27 +0800
Message-Id: <20220714075428.1060984-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using current implementation of polling mode, there is high chances we
will hit into timeout error when running phc2sys. Hence, update the
implementation of hardware crosstimestamping to use the MAC interrupt
service routine instead of polling for TSIS bit in the MAC Timestamp
Interrupt Status register to be set.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 25 ++++++++++++-------
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  3 ++-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  4 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c |  5 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 12 +--------
 include/linux/stmmac.h                        |  1 +
 7 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 38fe77d1035e..3fe720c5dc9f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -298,6 +298,11 @@ static void get_arttime(struct mii_bus *mii, int intel_adhoc_addr,
 	*art_time = ns;
 }
 
+static int stmmac_cross_ts_isr(struct stmmac_priv *priv)
+{
+	return (readl(priv->ioaddr + GMAC_INT_STATUS) & GMAC_INT_TSIE);
+}
+
 static int intel_crosststamp(ktime_t *device,
 			     struct system_counterval_t *system,
 			     void *ctx)
@@ -313,8 +318,6 @@ static int intel_crosststamp(ktime_t *device,
 	u32 num_snapshot;
 	u32 gpio_value;
 	u32 acr_value;
-	int ret;
-	u32 v;
 	int i;
 
 	if (!boot_cpu_has(X86_FEATURE_ART))
@@ -328,6 +331,8 @@ static int intel_crosststamp(ktime_t *device,
 	if (priv->plat->ext_snapshot_en)
 		return -EBUSY;
 
+	priv->plat->int_snapshot_en = 1;
+
 	mutex_lock(&priv->aux_ts_lock);
 	/* Enable Internal snapshot trigger */
 	acr_value = readl(ptpaddr + PTP_ACR);
@@ -347,6 +352,7 @@ static int intel_crosststamp(ktime_t *device,
 		break;
 	default:
 		mutex_unlock(&priv->aux_ts_lock);
+		priv->plat->int_snapshot_en = 0;
 		return -EINVAL;
 	}
 	writel(acr_value, ptpaddr + PTP_ACR);
@@ -368,13 +374,12 @@ static int intel_crosststamp(ktime_t *device,
 	gpio_value |= GMAC_GPO1;
 	writel(gpio_value, ioaddr + GMAC_GPIO_STATUS);
 
-	/* Poll for time sync operation done */
-	ret = readl_poll_timeout(priv->ioaddr + GMAC_INT_STATUS, v,
-				 (v & GMAC_INT_TSIE), 100, 10000);
-
-	if (ret == -ETIMEDOUT) {
-		pr_err("%s: Wait for time sync operation timeout\n", __func__);
-		return ret;
+	/* Time sync done Indication - Interrupt method */
+	if (!wait_event_interruptible_timeout(priv->tstamp_busy_wait,
+					      stmmac_cross_ts_isr(priv),
+					      HZ / 100)) {
+		priv->plat->int_snapshot_en = 0;
+		return -ETIMEDOUT;
 	}
 
 	num_snapshot = (readl(ioaddr + GMAC_TIMESTAMP_STATUS) &
@@ -392,6 +397,7 @@ static int intel_crosststamp(ktime_t *device,
 	}
 
 	system->cycles *= intel_priv->crossts_adj;
+	priv->plat->int_snapshot_en = 0;
 
 	return 0;
 }
@@ -576,6 +582,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 
 	plat->has_crossts = true;
 	plat->crosststamp = intel_crosststamp;
+	plat->int_snapshot_en = 0;
 
 	/* Setup MSI vector offset specific to Intel mGbE controller */
 	plat->msi_mac_vec = 29;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 462ca7ed095a..71dad409f78b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -150,7 +150,8 @@
 #define	GMAC_PCS_IRQ_DEFAULT	(GMAC_INT_RGSMIIS | GMAC_INT_PCS_LINK |	\
 				 GMAC_INT_PCS_ANE)
 
-#define	GMAC_INT_DEFAULT_ENABLE	(GMAC_INT_PMT_EN | GMAC_INT_LPI_EN)
+#define	GMAC_INT_DEFAULT_ENABLE	(GMAC_INT_PMT_EN | GMAC_INT_LPI_EN | \
+				 GMAC_INT_TSIE)
 
 enum dwmac4_irq_status {
 	time_stamp_irq = 0x00001000,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index fd41db65fe1d..d5299dd13e85 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -23,6 +23,7 @@
 static void dwmac4_core_init(struct mac_device_info *hw,
 			     struct net_device *dev)
 {
+	struct stmmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value = readl(ioaddr + GMAC_CONFIG);
 
@@ -58,6 +59,9 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 		value |= GMAC_INT_FPE_EN;
 
 	writel(value, ioaddr + GMAC_INT_EN);
+
+	if (GMAC_INT_DEFAULT_ENABLE & GMAC_INT_TSIE)
+		init_waitqueue_head(&priv->tstamp_busy_wait);
 }
 
 static void dwmac4_rx_queue_enable(struct mac_device_info *hw,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 57970ae2178d..f9e83964aa7e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -266,6 +266,7 @@ struct stmmac_priv {
 	rwlock_t ptp_lock;
 	/* Protects auxiliary snapshot registers from concurrent access. */
 	struct mutex aux_ts_lock;
+	wait_queue_head_t tstamp_busy_wait;
 
 	void __iomem *mmcaddr;
 	void __iomem *ptpaddr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 92d32940aff0..764832f4dae1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -179,6 +179,11 @@ static void timestamp_interrupt(struct stmmac_priv *priv)
 	u64 ptp_time;
 	int i;
 
+	if (priv->plat->int_snapshot_en) {
+		wake_up(&priv->tstamp_busy_wait);
+		return;
+	}
+
 	tsync_int = readl(priv->ioaddr + GMAC_INT_STATUS) & GMAC_INT_TSIE;
 
 	if (!tsync_int)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index e45fb191d8e6..4d11980dcd64 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -175,11 +175,10 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 	struct stmmac_priv *priv =
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	void __iomem *ptpaddr = priv->ptpaddr;
-	void __iomem *ioaddr = priv->hw->pcsr;
 	struct stmmac_pps_cfg *cfg;
-	u32 intr_value, acr_value;
 	int ret = -EOPNOTSUPP;
 	unsigned long flags;
+	u32 acr_value;
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
@@ -213,19 +212,10 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 			netdev_dbg(priv->dev, "Auxiliary Snapshot %d enabled.\n",
 				   priv->plat->ext_snapshot_num >>
 				   PTP_ACR_ATSEN_SHIFT);
-			/* Enable Timestamp Interrupt */
-			intr_value = readl(ioaddr + GMAC_INT_EN);
-			intr_value |= GMAC_INT_TSIE;
-			writel(intr_value, ioaddr + GMAC_INT_EN);
-
 		} else {
 			netdev_dbg(priv->dev, "Auxiliary Snapshot %d disabled.\n",
 				   priv->plat->ext_snapshot_num >>
 				   PTP_ACR_ATSEN_SHIFT);
-			/* Disable Timestamp Interrupt */
-			intr_value = readl(ioaddr + GMAC_INT_EN);
-			intr_value &= ~GMAC_INT_TSIE;
-			writel(intr_value, ioaddr + GMAC_INT_EN);
 		}
 		writel(acr_value, ptpaddr + PTP_ACR);
 		mutex_unlock(&priv->aux_ts_lock);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 29917850f079..8df475db88c0 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -260,6 +260,7 @@ struct plat_stmmacenet_data {
 	bool has_crossts;
 	int int_snapshot_num;
 	int ext_snapshot_num;
+	bool int_snapshot_en;
 	bool ext_snapshot_en;
 	bool multi_msi_en;
 	int msi_mac_vec;
-- 
2.25.1

