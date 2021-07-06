Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497E03BC838
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 11:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhGFJFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 05:05:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:47823 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhGFJFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 05:05:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="270202644"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="270202644"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 02:02:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="559882172"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by orsmga004.jf.intel.com with ESMTP; 06 Jul 2021 02:02:30 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net] net: phy: skip disabling interrupt when WOL is enabled in shutdown
Date:   Tue,  6 Jul 2021 17:02:09 +0800
Message-Id: <20210706090209.1897027-1-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

PHY WOL requires WOL interrupt event to trigger the WOL signal
in order to wake up the system. Hence, the PHY driver should not
disable the interrupt during shutdown if PHY WOL is enabled.

Fixes: e2f016cf7751 ("net: phy: add a shutdown procedure")
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: Ling PeiLee <pei.lee.ling@intel.com>
---
 drivers/net/phy/phy_device.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea021ac0..f4b88f613dc1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2994,9 +2994,13 @@ static int phy_remove(struct device *dev)
 
 static void phy_shutdown(struct device *dev)
 {
+	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct phy_device *phydev = to_phy_device(dev);
 
-	phy_disable_interrupts(phydev);
+	/* If the device has WOL enabled, don't disable interrupts. */
+	phy_ethtool_get_wol(phydev, &wol);
+	if (!wol.wolopts)
+		phy_disable_interrupts(phydev);
 }
 
 /**
-- 
2.25.1

