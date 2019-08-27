Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCFE9D53C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387535AbfHZRxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:53:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:65275 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbfHZRxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:53:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:53:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="209450824"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by fmsmga002.fm.intel.com with ESMTP; 26 Aug 2019 10:53:39 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also cover PHY that only talks C45
Date:   Tue, 27 Aug 2019 09:52:49 +0800
Message-Id: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

Make mdiobus_scan() to try harder to look for any PHY that only talks C45.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index bd04fe762056..30dbc48b4c7e 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -525,8 +525,12 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 	int err;
 
 	phydev = get_phy_device(bus, addr, false);
-	if (IS_ERR(phydev))
-		return phydev;
+	if (IS_ERR(phydev)) {
+		/* Try C45 to ensure we don't miss PHY that only talks C45 */
+		phydev = get_phy_device(bus, addr, true);
+		if (IS_ERR(phydev))
+			return phydev;
+	}
 
 	/*
 	 * For DT, see if the auto-probed phy has a correspoding child
-- 
1.9.1

