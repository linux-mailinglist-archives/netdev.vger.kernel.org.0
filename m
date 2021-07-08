Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63993BF2F0
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 02:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhGHAqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 20:46:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:9478 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230154AbhGHAqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 20:46:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="207596051"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="207596051"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:43:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="457694129"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga008.jf.intel.com with ESMTP; 07 Jul 2021 17:43:45 -0700
From:   mohammad.athari.ismail@intel.com
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option still enabled
Date:   Thu,  8 Jul 2021 08:42:53 +0800
Message-Id: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

When the PHY wakes up from suspend through WOL event, there is a need to
reconfigure the WOL if the WOL option still enabled. The main operation
is to clear the WOL event status. So that, subsequent WOL event can be
triggered properly.

This fix is needed especially for the PHY that operates in PHY_POLL mode
where there is no handler (such as interrupt handler) available to clear
the WOL event status.

Fixes: 611d779af7ca ("net: phy: fix MDIO bus PM PHY resuming")
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/phy/phy_device.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5d5f9a9ee768..d68703ce03b1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -295,6 +295,7 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 
 static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 {
+	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
@@ -314,6 +315,13 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 no_resume:
+	/* If the PHY has WOL option still enabled, reconfigure the WOL mainly
+	 * to clear the WOL event status.
+	 */
+	phy_ethtool_get_wol(phydev, &wol);
+	if (wol.wolopts)
+		phy_ethtool_set_wol(phydev, &wol);
+
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
 
-- 
2.17.1

