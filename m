Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218E650B1D8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444974AbiDVHnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444953AbiDVHmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:42:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43546517CD;
        Fri, 22 Apr 2022 00:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650613180; x=1682149180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZAM//25jc969fXPpRmMZdTy2q65l1lpKHITyK900QMQ=;
  b=nTCvGj8tAp3hDxnty5LtFbrs7dgv+tFG7VLnJsjhvEgypm3ZUWR/qhpi
   mbOH0GWG3b3dEy/ziLWdfqmTuK4sJGjd7tGP9/7LZWoFf2v1g8gw234RB
   TFdtUxeZZwq4CcSovSfNrXMRx+7MhH5sIPm1TrPVLhmJaHagg3feJzm0P
   qbbj81vyp6adbBTmOio7leQfqdNMNpIZxsisSGDKjTJovsp7BoTgJJFcF
   Xt/jhbHBinKCfRfQyebQbgS3Ujd9zyiaU1S4PWLYNMbwIe5uKEykyNMwu
   lCVt9We4/K7hEG0j+1IcSuAQrsLrfX5pP/yscnWWctUrDuZJHnl1wQKkI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245180239"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="245180239"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:39:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="648516342"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Apr 2022 00:39:36 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 3/4] stmmac: intel: prepare to support 1000BASE-X phy interface setting
Date:   Fri, 22 Apr 2022 15:35:04 +0800
Message-Id: <20220422073505.810084-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422073505.810084-1-boon.leong.ong@intel.com>
References: <20220422073505.810084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, intel_speed_mode_2500() redundantly fix-up phy_interface to
PHY_INTERFACE_MODE_SGMII if the underlying controller is in 1000Mbps
SGMII mode. The value of phy_interface has been initialized earlier.

This patch removes such redundancy to prepare for setting 1000BASE-X
mode for certain hardware platform configuration.

Also update the intel_mgbe_common_data() to include 1000BASE-X setup.

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 63754a9c4ba..265d39acdd0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -251,7 +251,6 @@ static void intel_speed_mode_2500(struct net_device *ndev, void *intel_data)
 		priv->plat->mdio_bus_data->xpcs_an_inband = false;
 	} else {
 		priv->plat->max_speed = 1000;
-		priv->plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 		priv->plat->mdio_bus_data->xpcs_an_inband = true;
 	}
 }
@@ -561,7 +560,8 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->vlan_fail_q = plat->rx_queues_to_use - 1;
 
 	/* Intel mgbe SGMII interface uses pcs-xcps */
-	if (plat->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+	if (plat->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    plat->phy_interface == PHY_INTERFACE_MODE_1000BASEX) {
 		plat->mdio_bus_data->has_xpcs = true;
 		plat->mdio_bus_data->xpcs_an_inband = true;
 	}
-- 
2.25.1

