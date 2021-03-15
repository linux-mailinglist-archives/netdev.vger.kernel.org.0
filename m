Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F37833AAD6
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhCOFYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:24:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:59451 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhCOFXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 01:23:55 -0400
IronPort-SDR: puCYXcaUXaqBYeAHRK9wXfeifnBq30BUQoplc7SUEQxZhmYxfXG1lSV2eo+vPkKR/3O15qoNgS
 ehgCJdgb5kNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="253054441"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="253054441"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 22:23:55 -0700
IronPort-SDR: EJ2Hb6tBs/TOFqWuA6JxewQ0J5nys5qlmMx7gtudo7oaMnhBKpKsDwwUt3qdQ0hp3v9CY7BTH8
 Meg1rFcL7E4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="373313804"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2021 22:23:51 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King i <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH net-next 6/6] stmmac: intel: add pcs-xpcs for Intel mGbE controller
Date:   Mon, 15 Mar 2021 13:27:11 +0800
Message-Id: <20210315052711.16728-7-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315052711.16728-1-boon.leong.ong@intel.com>
References: <20210315052711.16728-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel mGbE controller such as those in EHL & TGL uses pcs-xpcs driver for
SGMII interface. To ensure mdio bus scanning does not assign phy_device
to MDIO-addressable entities like intel serdes and pcs-xpcs, we set up
to phy_mask to skip them.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 0b64f7710d17..c49646773871 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -9,6 +9,9 @@
 #include "dwmac4.h"
 #include "stmmac.h"
 
+#define INTEL_MGBE_ADHOC_ADDR	0x15
+#define INTEL_MGBE_XPCS_ADDR	0x16
+
 struct intel_priv_data {
 	int mdio_adhoc_addr;	/* mdio address for serdes & etc */
 };
@@ -333,6 +336,16 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	/* Use the last Rx queue */
 	plat->vlan_fail_q = plat->rx_queues_to_use - 1;
 
+	/* Intel mgbe SGMII interface uses pcs-xcps */
+	if (plat->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		plat->mdio_bus_data->has_xpcs = true;
+		plat->mdio_bus_data->xpcs_an_inband = true;
+	}
+
+	/* Ensure mdio bus scan skips intel serdes and pcs-xpcs */
+	plat->mdio_bus_data->phy_mask = 1 << INTEL_MGBE_ADHOC_ADDR;
+	plat->mdio_bus_data->phy_mask |= 1 << INTEL_MGBE_XPCS_ADDR;
+
 	return 0;
 }
 
@@ -664,7 +677,7 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	plat->bsp_priv = intel_priv;
-	intel_priv->mdio_adhoc_addr = 0x15;
+	intel_priv->mdio_adhoc_addr = INTEL_MGBE_ADHOC_ADDR;
 
 	ret = info->setup(pdev, plat);
 	if (ret)
-- 
2.25.1

