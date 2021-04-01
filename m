Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2535350E9F
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhDAF7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 01:59:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:3661 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhDAF6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 01:58:32 -0400
IronPort-SDR: 16Y5WlAo0HdYyPlTcqxuHNnMLHRYPgbwY4+bcgbNH+h18NUD1ZI2Gzp6Axpqd0zHwj2fOa4vXW
 16NMwUQ1Up8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191640980"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="191640980"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 22:58:32 -0700
IronPort-SDR: gGck3JOSqyN3h8KmFVKd+VeDv/XjVplRu1cjb6DmIr3euSou4z/Xxpd0v3/TZLaE0xDmLc73eB
 2Rw4P3Atcgvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="412516712"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 31 Mar 2021 22:58:31 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 62D0F580932;
        Wed, 31 Mar 2021 22:58:29 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] stmmac: intel: use managed PCI function on probe and resume
Date:   Thu,  1 Apr 2021 14:02:50 +0800
Message-Id: <20210401060250.24109-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update dwmac-intel to use managed function, i.e. pcim_enable_device().

This will allow devres framework to call resource free function for us.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 3d9a57043af2..add95e20548d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -924,7 +924,7 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	/* Enable pci device */
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n",
 			__func__);
@@ -1006,13 +1006,9 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	pci_free_irq_vectors(pdev);
-
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));
-
-	pci_disable_device(pdev);
 }
 
 static int __maybe_unused intel_eth_pci_suspend(struct device *dev)
@@ -1028,7 +1024,6 @@ static int __maybe_unused intel_eth_pci_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
-	pci_disable_device(pdev);
 	pci_wake_from_d3(pdev, true);
 	return 0;
 }
@@ -1041,7 +1036,7 @@ static int __maybe_unused intel_eth_pci_resume(struct device *dev)
 	pci_restore_state(pdev);
 	pci_set_power_state(pdev, PCI_D0);
 
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret)
 		return ret;
 
-- 
2.25.1

