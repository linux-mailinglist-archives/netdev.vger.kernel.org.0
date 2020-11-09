Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBFC2AB870
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgKIMkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:40:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:43619 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729038AbgKIMkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 07:40:49 -0500
IronPort-SDR: XE4LLSM2e1Heqyc+pP/LZsevXieFRGf1owyzxLp6rkjNf/vQc5GQ+UtXbWstgg1bTz/+BhWEBg
 vFS36W/QYVlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187741198"
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="187741198"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 04:40:49 -0800
IronPort-SDR: WkFNnJabM/KZwt/ZkJYDIVyDWOyYm/WDjCNUTd97x/wsp6GrlUHIUSWfaxgmX8rJiGFwF4jLQd
 NqSNQ63XtIcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,463,1596524400"; 
   d="scan'208";a="307638358"
Received: from glass.png.intel.com ([172.30.181.98])
  by fmsmga008.fm.intel.com with ESMTP; 09 Nov 2020 04:40:46 -0800
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 1/1] net: phy: Allow mdio buses to probe C45 before falling back to C22
Date:   Mon,  9 Nov 2020 20:43:47 +0800
Message-Id: <20201109124347.13087-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes mdiobus_scan() to try on C45 first as C45 can access
all devices. This allows the function available for the PHY that
supports for both C45 and C22.

Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/phy/mdio_bus.c | 5 +++++
 include/linux/phy.h        | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 56094dd6bf26..372d0d088f7e 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -691,6 +691,11 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 		if (IS_ERR(phydev))
 			phydev = get_phy_device(bus, addr, true);
 		break;
+	case MDIOBUS_C45_C22:
+		phydev = get_phy_device(bus, addr, true);
+		if (IS_ERR(phydev))
+			phydev = get_phy_device(bus, addr, false);
+		break;
 	}
 
 	if (IS_ERR(phydev))
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 189bc9881ea6..73d9be2c00f4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -360,6 +360,7 @@ struct mii_bus {
 		MDIOBUS_C22,
 		MDIOBUS_C45,
 		MDIOBUS_C22_C45,
+		MDIOBUS_C45_C22,
 	} probe_capabilities;
 
 	/** @shared_lock: protect access to the shared element */
-- 
2.17.0

