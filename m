Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED81D54A75B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 05:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353305AbiFNDGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 23:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353420AbiFNDFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 23:05:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC23E2B1A0;
        Mon, 13 Jun 2022 20:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655175929; x=1686711929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tk/dObL96dn44VuoBZwZZKZdR9ldP5FCMS13exwOSO0=;
  b=f08eWHJOYqHoY8jLzvovIAfMSfnDUvUVNo4O6DfC8iLNmAN2hvju53u2
   VzslNgMm+s7BSJI77kKhu+Gc7nN5Aiz4+iPFKbEG9TVOdyN/hOV2aBaOe
   UfUFBNCJRD7nlf/thbt9/eYDOCqLjwCa/lgZjU+rvkKm6Rd7194dYhr3Y
   QESm6TjMiy7brDEO79NDL9SH8R2+dG29CQqfGUNX214Zq5B0J+9rvXk+H
   tewUoUjRHxHjscSsQwfTmfOxAYxx5sbtgnzGB1pAXl1FDl7thxqd3F9rB
   2a5chBfdFPwxAXu6yObZoEgTx6Cisn/aKW0FV97dkVwSKDefaNbhaba5p
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="278518785"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="278518785"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 20:05:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="761787736"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2022 20:05:21 -0700
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
Subject: [PATCH net-next v4 4/5] stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support
Date:   Tue, 14 Jun 2022 11:00:29 +0800
Message-Id: <20220614030030.1249850-5-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614030030.1249850-1-boon.leong.ong@intel.com>
References: <20220614030030.1249850-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, phy_interface for TSN controller instance is set based on its
PCI Device ID. For SGMII PHY interface, phy_interface default to
PHY_INTERFACE_MODE_SGMII. As C37 AN supports both SGMII and 1000BASE-X
mode, we add support for 'phy-mode' ACPI _DSD for port-specific
and customer platform specific customization.

v2:
For platform that sets 'fixed-link' using ACPI _DSD, we will unset
xpcs_an_inband within stmmac. Thanks to Russell King for his comment in
https://patchwork.kernel.org/comment/24890222/

v1:
Thanks to Andrew Lunn's guidance in
https://patchwork.kernel.org/comment/24827101/

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 675dfb89b76..97b357dd468 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -442,6 +442,7 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 static int intel_mgbe_common_data(struct pci_dev *pdev,
 				  struct plat_stmmacenet_data *plat)
 {
+	struct fwnode_handle *fwnode;
 	char clk_name[20];
 	int ret;
 	int i;
@@ -560,6 +561,20 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	/* Use the last Rx queue */
 	plat->vlan_fail_q = plat->rx_queues_to_use - 1;
 
+	/* For fixed-link setup, we allow phy-mode setting */
+	fwnode = dev_fwnode(&pdev->dev);
+	if (fwnode) {
+		const char *phy_mode;
+
+		if (!fwnode_property_read_string(fwnode, "phy-mode",
+						 &phy_mode)) {
+			if (!strcmp(phy_mode, "sgmii"))
+				plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+			if (!strcmp(phy_mode, "1000base-x"))
+				plat->phy_interface = PHY_INTERFACE_MODE_1000BASEX;
+		}
+	}
+
 	/* Intel mgbe SGMII interface uses pcs-xcps */
 	if (plat->phy_interface == PHY_INTERFACE_MODE_SGMII ||
 	    plat->phy_interface == PHY_INTERFACE_MODE_1000BASEX) {
@@ -567,6 +582,17 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 		plat->mdio_bus_data->xpcs_an_inband = true;
 	}
 
+	/* For fixed-link setup, we clear xpcs_an_inband */
+	if (fwnode) {
+		struct fwnode_handle *fixed_node;
+
+		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
+		if (fixed_node)
+			plat->mdio_bus_data->xpcs_an_inband = false;
+
+		fwnode_handle_put(fixed_node);
+	}
+
 	/* Ensure mdio bus scan skips intel serdes and pcs-xpcs */
 	plat->mdio_bus_data->phy_mask = 1 << INTEL_MGBE_ADHOC_ADDR;
 	plat->mdio_bus_data->phy_mask |= 1 << INTEL_MGBE_XPCS_ADDR;
-- 
2.25.1

