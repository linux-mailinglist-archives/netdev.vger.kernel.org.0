Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DC21BFF86
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgD3PDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:03:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:2231 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgD3PDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:03:07 -0400
IronPort-SDR: hbuIzHl0kWc7JZcYc0d/wPlFmQlzbSsjBfhLauMtgu8GGcWt9JxavGMTpVztyKREcS9mhMUczD
 BhtvAHUwLaMA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 08:03:00 -0700
IronPort-SDR: zSrDZcbfmQWN3MSIEGtd8GZH/6BJBvhn6L17FP96YH9hGrAkZT/pHv9IH0oLHq/rxdJWbIlbpI
 g6qV+TOoZxmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,336,1583222400"; 
   d="scan'208";a="459967121"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 30 Apr 2020 08:02:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 85F4E402; Thu, 30 Apr 2020 18:02:55 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 5/7] stmmac: intel: Eliminate useless conditions and variables
Date:   Thu, 30 Apr 2020 18:02:52 +0300
Message-Id: <20200430150254.34565-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
References: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are useless conditions like

	func()
	{
		...
		int ret;
		...
		ret = foo();
		if (ret)
			return ret;

		return 0;
	}

which may be replaced with direct return statement, what we have done here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index bb8bf31c1259ef..b0d735e4c13ce2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -347,16 +347,11 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 static int ehl_common_data(struct pci_dev *pdev,
 			   struct plat_stmmacenet_data *plat)
 {
-	int ret;
-
 	plat->rx_queues_to_use = 8;
 	plat->tx_queues_to_use = 8;
 	plat->clk_ptp_rate = 200000000;
-	ret = intel_mgbe_common_data(pdev, plat);
-	if (ret)
-		return ret;
 
-	return 0;
+	return intel_mgbe_common_data(pdev, plat);
 }
 
 static int ehl_sgmii_data(struct pci_dev *pdev,
@@ -457,16 +452,11 @@ static struct stmmac_pci_info ehl_pse1_sgmii1g_pci_info = {
 static int tgl_common_data(struct pci_dev *pdev,
 			   struct plat_stmmacenet_data *plat)
 {
-	int ret;
-
 	plat->rx_queues_to_use = 6;
 	plat->tx_queues_to_use = 4;
 	plat->clk_ptp_rate = 200000000;
-	ret = intel_mgbe_common_data(pdev, plat);
-	if (ret)
-		return ret;
 
-	return 0;
+	return intel_mgbe_common_data(pdev, plat);
 }
 
 static int tgl_sgmii_data(struct pci_dev *pdev,
-- 
2.26.2

