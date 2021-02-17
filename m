Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3AB31D722
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 10:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhBQJyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 04:54:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:22527 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhBQJyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 04:54:00 -0500
IronPort-SDR: bgy/IG8OCJ8P0Tjjo/qySct4nGrx/IOk6vHf04c8ZE+JGVIODDEp2eujcr3RvtpOS96/6d6Z6e
 B5xHIgpdr44A==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="179643960"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="179643960"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 01:53:17 -0800
IronPort-SDR: dX9qS/mBPVuRlhyR92/GwDld8pE4SCeO/Q2gieLHME5cB1d7vIm6tSK+qkyus4IgLVk5ZsZ7A/
 0cQlIXue7ivA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="589549452"
Received: from glass.png.intel.com ([10.158.65.51])
  by fmsmga006.fm.intel.com with ESMTP; 17 Feb 2021 01:53:13 -0800
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] net: stmmac: Add PCI bus info to ethtool driver query output
Date:   Wed, 17 Feb 2021 17:57:05 +0800
Message-Id: <20210217095705.13806-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch populates the PCI bus info in the ethtool driver query data.

Users will be able to view PCI bus info using 'ethtool -i <interface>'.

Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c    | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 4 ++++
 include/linux/stmmac.h                               | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 1c9c67b641a2..751dfdeec41c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -236,6 +236,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	int ret;
 	int i;
 
+	plat->pdev = pdev;
 	plat->phy_addr = -1;
 	plat->clk_csr = 5;
 	plat->has_gmac = 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 9e54f953634b..c5642985ef95 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -268,6 +268,10 @@ static void stmmac_ethtool_getdrvinfo(struct net_device *dev,
 		strlcpy(info->driver, MAC100_ETHTOOL_NAME,
 			sizeof(info->driver));
 
+	if (priv->plat->pdev) {
+		strlcpy(info->bus_info, pci_name(priv->plat->pdev),
+			sizeof(info->bus_info));
+	}
 	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 15ca6b4167cc..a302982de2d7 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -202,5 +202,6 @@ struct plat_stmmacenet_data {
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
 	unsigned int eee_usecs_rate;
+	struct pci_dev *pdev;
 };
 #endif
-- 
2.17.0

