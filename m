Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345C27846D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgIYJwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:52:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:23483 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbgIYJwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 05:52:12 -0400
IronPort-SDR: AdVpkIc18TDQ0M8k1F1q9824CYU2UfG+aSdKw3TVkHEU7AHkGiy2ruqEz8ESHRQnJEfni0dobA
 0mdJtX7WsjLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="225634026"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="225634026"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 02:52:11 -0700
IronPort-SDR: TrybvGWJmcvbbP21dLsqR2BSOs49k6JaoNa9vpYaiLY29F8SLJYjDkqXQDDJdcByDDf7zA40Ti
 xge0rwy/6tRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="487402522"
Received: from glass.png.intel.com ([172.30.181.92])
  by orsmga005.jf.intel.com with ESMTP; 25 Sep 2020 02:52:07 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Subject: [PATCH net 1/1] net: stmmac: Fix clock handling on remove path
Date:   Fri, 25 Sep 2020 17:54:06 +0800
Message-Id: <20200925095406.27834-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While unloading the dwmac-intel driver, clk_disable_unprepare() is
being called twice in stmmac_dvr_remove() and
intel_eth_pci_remove(). This causes kernel panic on the second call.

Removing the second call of clk_disable_unprepare() in
intel_eth_pci_remove().

Fixes: 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove paths")
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2ac9dfb3462c..9e6d60e75f85 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -653,7 +653,6 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdev);
 
-	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));
-- 
2.17.0

