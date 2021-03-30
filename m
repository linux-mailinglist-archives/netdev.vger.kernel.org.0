Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C034DE8D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhC3Cmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:42:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:49176 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230452AbhC3Cmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 22:42:37 -0400
IronPort-SDR: 9uKjxtndS8OlFtPIuIeprh32fF+2mJAzGypdm91XKuOFZzJ+79mpq3r+y9OP9IjJLBcHtSU15g
 YH/3NyxXmI7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="253014600"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="253014600"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 19:42:36 -0700
IronPort-SDR: eGZ6m/VnjlLq0taG0cRQupmf/7F8XQbJMoC2rb86YhmvgTjd1mKyPC0Ri+hgvVE5o7D3hpVTmN
 gbQRjViZJu4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="595296946"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 29 Mar 2021 19:42:36 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 18C905805F0;
        Mon, 29 Mar 2021 19:42:33 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vee.khee.wong@intel.com
Subject: [PATCH net-next 1/1] stmmac: intel: add cross time-stamping freq difference adjustment
Date:   Tue, 30 Mar 2021 10:46:53 +0800
Message-Id: <20210330024653.11062-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cross time-stamping mechanism used in certain instance of Intel mGbE
may run at different clock frequency in comparison to the clock
frequency used by processor, so we introduce cross T/S frequency
adjustment to ensure TSC calculation is correct when processor got the
cross time-stamps.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 08b4852eed4c..3d9a57043af2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -22,8 +22,13 @@
 #define PCH_PTP_CLK_FREQ_19_2MHZ	(GMAC_GPO0)
 #define PCH_PTP_CLK_FREQ_200MHZ		(0)
 
+/* Cross-timestamping defines */
+#define ART_CPUID_LEAF		0x15
+#define EHL_PSE_ART_MHZ		19200000
+
 struct intel_priv_data {
 	int mdio_adhoc_addr;	/* mdio address for serdes & etc */
+	unsigned long crossts_adj;
 	bool is_pse;
 };
 
@@ -340,9 +345,26 @@ static int intel_crosststamp(ktime_t *device,
 		*system = convert_art_to_tsc(art_time);
 	}
 
+	system->cycles *= intel_priv->crossts_adj;
+
 	return 0;
 }
 
+static void intel_mgbe_pse_crossts_adj(struct intel_priv_data *intel_priv,
+				       int base)
+{
+	if (boot_cpu_has(X86_FEATURE_ART)) {
+		unsigned int art_freq;
+
+		/* On systems that support ART, ART frequency can be obtained
+		 * from ECX register of CPUID leaf (0x15).
+		 */
+		art_freq = cpuid_ecx(ART_CPUID_LEAF);
+		do_div(art_freq, base);
+		intel_priv->crossts_adj = art_freq;
+	}
+}
+
 static void common_default_data(struct plat_stmmacenet_data *plat)
 {
 	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
@@ -551,6 +573,8 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
 	plat->bus_id = 2;
 	plat->addr64 = 32;
 
+	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -587,6 +611,8 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
 	plat->bus_id = 3;
 	plat->addr64 = 32;
 
+	intel_mgbe_pse_crossts_adj(intel_priv, EHL_PSE_ART_MHZ);
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -913,6 +939,7 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 
 	plat->bsp_priv = intel_priv;
 	intel_priv->mdio_adhoc_addr = INTEL_MGBE_ADHOC_ADDR;
+	intel_priv->crossts_adj = 1;
 
 	/* Initialize all MSI vectors to invalid so that it can be set
 	 * according to platform data settings below.
-- 
2.25.1

