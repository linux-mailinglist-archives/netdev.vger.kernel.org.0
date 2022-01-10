Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0FC489021
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbiAJGWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:22:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:56164 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238983AbiAJGWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 01:22:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641795727; x=1673331727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=u3alDZoHvRJPnlEHKpAsBdFJ0z0vLEy9N4porvRWpoQ=;
  b=niOr/dCeyFYGSlfMaH2yqZfy6VUmE8INr8ebWGawl95xFggozKnM4VAv
   Ui4eQpuICgA4EA0iRzpE0PFLKDoxjwgCt/waxci9U0zrikdpvvUUCRKmG
   LHEDC6rGSRxIXGlF7ssBBbDgVwc7VwxGCeB6GvLrEaSlVTrzN5VlZ18K0
   llzzC2t/wGApNit/FbEjWb6kJPBb9yXtK/g84ooTITOv8qwFE8Fy7bRgD
   YaeWPo1eUi8sJtV5Z2o9+CHU9rLufH0IW4kuO8zt9AFJmKRMKPzCdvc64
   7BM/Tm4UUaaV/9pEfOlZ76ySDVeYIutU37fbPe+Dm660D0LzZrt0FHgS/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="242958090"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="242958090"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 22:22:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="764424454"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2022 22:22:05 -0800
From:   Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com, stable@vger.kernel.org
Subject: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY loopback
Date:   Mon, 10 Jan 2022 14:21:17 +0800
Message-Id: <20220110062117.17540-2-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
References: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing genphy_loopback() is not applicable for Marvell PHY. So,
adding Marvell specific PHY loopback operation by only setting(enable) or
clearing(disable) BMCR_LOOPBACK bit.

Tested working on Marvell 88E1510.

Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/phy/marvell.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 4fcfca4e1702..2a73a959b48b 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1932,6 +1932,12 @@ static void marvell_get_stats(struct phy_device *phydev,
 		data[i] = marvell_get_stat(phydev, i);
 }
 
+static int marvell_loopback(struct phy_device *phydev, bool enable)
+{
+	return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+			  enable ? BMCR_LOOPBACK : 0);
+}
+
 static int marvell_vct5_wait_complete(struct phy_device *phydev)
 {
 	int i;
@@ -3078,7 +3084,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
-		.set_loopback = genphy_loopback,
+		.set_loopback = marvell_loopback,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
 		.cable_test_start = marvell_vct7_cable_test_start,
-- 
2.17.1

