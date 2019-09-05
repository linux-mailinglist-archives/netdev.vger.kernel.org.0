Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED1AA3B5
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbfIENA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:00:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:32225 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbfIENA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 09:00:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 06:00:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="184228422"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 05 Sep 2019 06:00:55 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 93059195; Thu,  5 Sep 2019 16:00:54 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S . Miller " <davem@davemloft.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] stmmac: platform: adjust messages and move to dev level
Date:   Thu,  5 Sep 2019 16:00:53 +0300
Message-Id: <20190905130053.84703-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch amends the error and warning messages across the platform driver.
It includes the following changes:
 - append \n to the end of messages
 - change pr_* macros to dev_*

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 22 +++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 154daf4d1072..1da461907114 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -23,6 +23,7 @@
 
 /**
  * dwmac1000_validate_mcast_bins - validates the number of Multicast filter bins
+ * @dev: struct device of the platform device
  * @mcast_bins: Multicast filtering bins
  * Description:
  * this function validates the number of Multicast filtering bins specified
@@ -33,7 +34,7 @@
  * invalid and will cause the filtering algorithm to use Multicast
  * promiscuous mode.
  */
-static int dwmac1000_validate_mcast_bins(int mcast_bins)
+static int dwmac1000_validate_mcast_bins(struct device *dev, int mcast_bins)
 {
 	int x = mcast_bins;
 
@@ -44,8 +45,8 @@ static int dwmac1000_validate_mcast_bins(int mcast_bins)
 		break;
 	default:
 		x = 0;
-		pr_info("Hash table entries set to unexpected value %d",
-			mcast_bins);
+		dev_info(dev, "Hash table entries set to unexpected value %d\n",
+			 mcast_bins);
 		break;
 	}
 	return x;
@@ -53,6 +54,7 @@ static int dwmac1000_validate_mcast_bins(int mcast_bins)
 
 /**
  * dwmac1000_validate_ucast_entries - validate the Unicast address entries
+ * @dev: struct device of the platform device
  * @ucast_entries: number of Unicast address entries
  * Description:
  * This function validates the number of Unicast address entries supported
@@ -62,7 +64,8 @@ static int dwmac1000_validate_mcast_bins(int mcast_bins)
  * selected, and defaults to 1 Unicast address if an unsupported
  * configuration is selected.
  */
-static int dwmac1000_validate_ucast_entries(int ucast_entries)
+static int dwmac1000_validate_ucast_entries(struct device *dev,
+					    int ucast_entries)
 {
 	int x = ucast_entries;
 
@@ -73,8 +76,8 @@ static int dwmac1000_validate_ucast_entries(int ucast_entries)
 		break;
 	default:
 		x = 1;
-		pr_info("Unicast table entries set to unexpected value %d\n",
-			ucast_entries);
+		dev_info(dev, "Unicast table entries set to unexpected value %d\n",
+			 ucast_entries);
 		break;
 	}
 	return x;
@@ -457,9 +460,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		of_property_read_u32(np, "snps,perfect-filter-entries",
 				     &plat->unicast_filter_entries);
 		plat->unicast_filter_entries = dwmac1000_validate_ucast_entries(
-					       plat->unicast_filter_entries);
+				&pdev->dev, plat->unicast_filter_entries);
 		plat->multicast_filter_bins = dwmac1000_validate_mcast_bins(
-					      plat->multicast_filter_bins);
+				&pdev->dev, plat->multicast_filter_bins);
 		plat->has_gmac = 1;
 		plat->pmt = 1;
 	}
@@ -508,7 +511,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
 	if (plat->force_thresh_dma_mode) {
 		plat->force_sf_dma_mode = 0;
-		pr_warn("force_sf_dma_mode is ignored if force_thresh_dma_mode is set.");
+		dev_warn(&pdev->dev,
+			 "force_sf_dma_mode is ignored if force_thresh_dma_mode is set.\n");
 	}
 
 	of_property_read_u32(np, "snps,ps-speed", &plat->mac_port_sel_speed);
-- 
2.23.0.rc1

