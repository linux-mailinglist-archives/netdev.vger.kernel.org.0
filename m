Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6029D518
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbfHZRjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:39:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:54772 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733219AbfHZRjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:39:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:39:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="355499141"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga005.jf.intel.com with ESMTP; 26 Aug 2019 10:39:13 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v1 net-next 4/4] net: stmmac: setup higher frequency clk support for EHL & TGL
Date:   Tue, 27 Aug 2019 09:38:11 +0800
Message-Id: <1566869891-29239-5-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
References: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EHL DW EQOS is running on a 200MHz clock. Setting up stmmac-clk,
ptp clock and ptp_max_adj to 200MHz.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 21 +++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |  3 +++
 include/linux/stmmac.h                           |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index e969dc9bb9f0..20906287b6d4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -9,6 +9,7 @@
   Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 *******************************************************************************/
 
+#include <linux/clk-provider.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
 
@@ -174,6 +175,19 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->axi->axi_blen[1] = 8;
 	plat->axi->axi_blen[2] = 16;
 
+	plat->ptp_max_adj = plat->clk_ptp_rate;
+
+	/* Set system clock */
+	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
+						   "stmmac-clk", NULL, 0,
+						   plat->clk_ptp_rate);
+
+	if (IS_ERR(plat->stmmac_clk)) {
+		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
+		plat->stmmac_clk = NULL;
+	}
+	clk_prepare_enable(plat->stmmac_clk);
+
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
 
@@ -193,6 +207,7 @@ static int ehl_common_data(struct pci_dev *pdev,
 
 	plat->rx_queues_to_use = 8;
 	plat->tx_queues_to_use = 8;
+	plat->clk_ptp_rate = 200000000;
 	ret = intel_mgbe_common_data(pdev, plat);
 	if (ret)
 		return ret;
@@ -233,6 +248,7 @@ static int tgl_common_data(struct pci_dev *pdev,
 
 	plat->rx_queues_to_use = 6;
 	plat->tx_queues_to_use = 4;
+	plat->clk_ptp_rate = 200000000;
 	ret = intel_mgbe_common_data(pdev, plat);
 	if (ret)
 		return ret;
@@ -438,10 +454,15 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
  */
 static void stmmac_pci_remove(struct pci_dev *pdev)
 {
+	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
 	int i;
 
 	stmmac_dvr_remove(&pdev->dev);
 
+	if (priv->plat->stmmac_clk)
+		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
+
 	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index c48224973a37..173493db038c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -194,6 +194,9 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 		priv->pps[i].available = true;
 	}
 
+	if (priv->plat->ptp_max_adj)
+		stmmac_ptp_clock_ops.max_adj = priv->plat->ptp_max_adj;
+
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
 
 	spin_lock_init(&priv->ptp_lock);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 5cc6b6faf359..7ad7ae35cf88 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -168,6 +168,7 @@ struct plat_stmmacenet_data {
 	struct clk *clk_ptp_ref;
 	unsigned int clk_ptp_rate;
 	unsigned int clk_ref_rate;
+	s32 ptp_max_adj;
 	struct reset_control *stmmac_rst;
 	struct stmmac_axi *axi;
 	int has_gmac4;
-- 
1.9.1

