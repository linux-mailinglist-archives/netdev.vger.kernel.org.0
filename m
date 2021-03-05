Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE632E1ED
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 07:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhCEGAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 01:00:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:52969 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCEGAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 01:00:13 -0500
IronPort-SDR: tFjsg5ywm2PWUC2g0BmxXPrd5KVRbNk0XKV/+pIvNRFcVmiZqnvJBATtBat44H94C75XYUBxtD
 XB9Ovkd/uqFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166839613"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="166839613"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 21:59:58 -0800
IronPort-SDR: ANx896jTZnol9NShHHlG8T26dd6BJwkia3SoveHuqZ5XeuE2WkjoA9bR77wkVGT0e3FeydaAVN
 9PN7Q75pceuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="507877765"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga001.fm.intel.com with ESMTP; 04 Mar 2021 21:59:55 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net 1/1] stmmac: intel: Fixes clock registration error seen for multiple interfaces
Date:   Fri,  5 Mar 2021 14:03:42 +0800
Message-Id: <20210305060342.23503-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>

Issue seen when enumerating multiple Intel mGbE interfaces in EHL.

[    6.898141] intel-eth-pci 0000:00:1d.2: enabling device (0000 -> 0002)
[    6.900971] intel-eth-pci 0000:00:1d.2: Fail to register stmmac-clk
[    6.906434] intel-eth-pci 0000:00:1d.2: User ID: 0x51, Synopsys ID: 0x52

We fix it by making the clock name to be unique following the format
of stmmac-pci_name(pci_dev) so that we can differentiate the clock for
these Intel mGbE interfaces in EHL platform as follow:

  /sys/kernel/debug/clk/stmmac-0000:00:1d.1
  /sys/kernel/debug/clk/stmmac-0000:00:1d.2
  /sys/kernel/debug/clk/stmmac-0000:00:1e.4

Fixes: 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index f2896872a86c..0b64f7710d17 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -233,6 +233,7 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 static int intel_mgbe_common_data(struct pci_dev *pdev,
 				  struct plat_stmmacenet_data *plat)
 {
+	char clk_name[20];
 	int ret;
 	int i;
 
@@ -301,8 +302,10 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->eee_usecs_rate = plat->clk_ptp_rate;
 
 	/* Set system clock */
+	sprintf(clk_name, "%s-%s", "stmmac", pci_name(pdev));
+
 	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
-						   "stmmac-clk", NULL, 0,
+						   clk_name, NULL, 0,
 						   plat->clk_ptp_rate);
 
 	if (IS_ERR(plat->stmmac_clk)) {
-- 
2.17.0

