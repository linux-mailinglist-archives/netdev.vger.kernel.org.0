Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43764545AAF
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346111AbiFJDlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346033AbiFJDlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:41:12 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5745021D3EC;
        Thu,  9 Jun 2022 20:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832469; x=1686368469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5EE9Irt/xFP6OZxqCU9pzSV6Tdyhia7NhlBMrgRnlk4=;
  b=VW2I/qdfCoGHuGjWXhobGIPs6Psh4sX/tInqqvixOc/SUHsAEB5GyCPx
   1PgfGAO0b7n+n4Kcr2L7ipLd3dVCe5QYqkd1YFUMi9YOO1eUKSliVPpmO
   /b/WAJYY5N3OglhIkathW/30eyXnjZtdchGKJXZY5nZGiSd2YkLzrA4FL
   qLyPwomP2BPaPTPQUUz7/6eFy/U3yMizKIiFop0w4AKW97+oycIVjqbcU
   9sG5OuYPG7ClxQjyqp7/x1IRavbjrUezZptDC0CYOuS+OXdp7+2m35adV
   pXUPHTryZVG28wExX8aI2PmfCLxPqSZk5/AUrnEAxxdFw66eQoazAU9qR
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278305262"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="278305262"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:41:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="827994009"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2022 20:41:04 -0700
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
Subject: [PATCH net-next v3 6/7] stmmac: intel: add phy-mode ACPI _DSD setting support
Date:   Fri, 10 Jun 2022 11:36:09 +0800
Message-Id: <20220610033610.114084-7-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610033610.114084-1-boon.leong.ong@intel.com>
References: <20220610033610.114084-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

Thanks to Andrew Lunn's guidance in
https://patchwork.kernel.org/comment/24827101/

Tested-by: Emilio Riva <emilio.riva@ericsson.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 675dfb89b76..e5f3d7deec3 100644
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
-- 
2.25.1

