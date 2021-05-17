Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FCB3828C4
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbhEQJuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:50:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:33296 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236234AbhEQJt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 05:49:58 -0400
IronPort-SDR: WksWsRLUxeIr2cbE1HJjbuXQefwikYv+TL9ozfAb4OHGxck5frpQr61EyVUqrdqR0JnukNgPot
 sqcM+5rPGk+g==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="285958510"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="285958510"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 02:48:42 -0700
IronPort-SDR: rME9TzGhPgHXvRp3v/U89+7RJbt2dOakBUJ5/8pgJkfdJdOLkRJmwiN3xWcaRrh0Ifn+fHXCN7
 PpfVMGmoerZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="540356013"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga001.fm.intel.com with ESMTP; 17 May 2021 02:48:38 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: stmmac: Add callbacks for DWC xpcs Energy Efficient Ethernet
Date:   Mon, 17 May 2021 17:43:32 +0800
Message-Id: <20210517094332.24976-3-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
References: <20210517094332.24976-1-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link xpcs callback functions for MAC to configure the xpcs EEE feature.

The clk_eee frequency is used to calculate the MULT_FACT_100NS. This is
to adjust the clock tic closer to 100ns.

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c    | 11 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h           |  2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  6 ++++++
 include/linux/stmmac.h                               |  1 +
 4 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 80728a4c0e3f..e36a8cc59ad0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -429,6 +429,17 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->force_sf_dma_mode = 0;
 	plat->tso_en = 1;
 
+	/* Multiplying factor to the clk_eee_i clock time
+	 * period to make it closer to 100 ns. This value
+	 * should be programmed such that the clk_eee_time_period *
+	 * (MULT_FACT_100NS + 1) should be within 80 ns to 120 ns
+	 * clk_eee frequency is 19.2Mhz
+	 * clk_eee_time_period is 52ns
+	 * 52ns * (1 + 1) = 104ns
+	 * MULT_FACT_100NS = 1
+	 */
+	plat->mult_fact_100ns = 1;
+
 	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
 	for (i = 0; i < plat->rx_queues_to_use; i++) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 2cc91759b91f..c678d7b826a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -624,6 +624,8 @@ struct stmmac_mmc_ops {
 	stmmac_do_callback(__priv, xpcs, link_up, __args)
 #define stmmac_xpcs_probe(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, probe, __args)
+#define stmmac_xpcs_config_eee(__priv, __args...) \
+	stmmac_do_callback(__priv, xpcs, config_eee, __args)
 
 struct stmmac_regs_off {
 	u32 ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 61b11639ee0c..1f6d749fd9a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -720,6 +720,12 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
+	ret = stmmac_xpcs_config_eee(priv, &priv->hw->xpcs_args,
+				     priv->plat->mult_fact_100ns,
+				     edata->eee_enabled);
+	if (ret)
+		return ret;
+
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 0db36360ef21..e14a12df381b 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -223,6 +223,7 @@ struct plat_stmmacenet_data {
 	struct clk *clk_ptp_ref;
 	unsigned int clk_ptp_rate;
 	unsigned int clk_ref_rate;
+	unsigned int mult_fact_100ns;
 	s32 ptp_max_adj;
 	struct reset_control *stmmac_rst;
 	struct stmmac_axi *axi;
-- 
2.17.1

