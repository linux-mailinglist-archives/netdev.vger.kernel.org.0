Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A92545A90
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbiFJDes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiFJDer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:34:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50DC16FEE5;
        Thu,  9 Jun 2022 20:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832086; x=1686368086;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YKMttFBPE2wCzfsgWycExPpf2Tu2U5inMYPLhQKTMdY=;
  b=gFfvUiE/rhRtkqXEI14KXS6BF8qrGXw9tSQYNYKuDPWKKFATSH71uWS2
   o5erlIxtKdd+6FXjvNfqi1EJwFc/HLRjH25+ErHUgUhGQCI8Hk1FiPr5Z
   pX2LBp4jDSYstmoT5bi0Yq/RzzH8/Ia93QVrvbMoJ7g7PcZzMhVVsqCGq
   kKd041aCm/8WgHei2w4cwYy8wPV/9/5tT6bbwhJ5cuVDqAtTkLJMYw3Lu
   5dYT6Fl9uboL0WJ1/z+NDomI5xv+ySLIPfSYp3evQ+j9dFQSBvJydRBd7
   ikLRnHggSnQN85+g5v7WCK+1wBcU3YjzToIqhH3aW/I4gP8HVBL8BovJj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="302872609"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="302872609"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:34:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="585971614"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2022 20:34:35 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 2/6] stmmac: intel: prepare to support 1000BASE-X phy interface setting
Date:   Fri, 10 Jun 2022 11:29:37 +0800
Message-Id: <20220610032941.113690-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610032941.113690-1-boon.leong.ong@intel.com>
References: <20220610032941.113690-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 38fe77d1035..675dfb89b76 100644
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
@@ -562,7 +561,8 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
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

