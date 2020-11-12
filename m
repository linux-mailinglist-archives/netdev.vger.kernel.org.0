Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAD12B0804
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgKLPBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:01:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:19209 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbgKLPBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:01:11 -0500
IronPort-SDR: SA17ywlREMJjSv2z9w7fU9auOeCece+66fM6ClBe60gbbZ0sassSCl0027shyuvZ/6XCtaAgQW
 xCHs61WRVwhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="170484642"
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="170484642"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 07:00:50 -0800
IronPort-SDR: u3tDXpGUjDw9O51RhauCnc1oON5mujg12Q6rjz+3Z5fBHGLyHsUfNskMcIRi4/7LZzICP/PyYB
 cL++A5tq6i4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="530693031"
Received: from glass.png.intel.com ([172.30.181.98])
  by fmsmga006.fm.intel.com with ESMTP; 12 Nov 2020 07:00:48 -0800
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
Subject: [PATCH net-next 1/1] net: phy: Add additional logics on probing C45 PHY devices
Date:   Thu, 12 Nov 2020 23:03:51 +0800
Message-Id: <20201112150351.12662-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For clause 45 PHY, introduce additional logics in get_phy_c45_ids() to
check if there is at least one valid device ID, return 0 on true, and
-ENODEV otherwise.

Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/phy/phy_device.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e13a46c25437..c9ddcd7a63d4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -730,6 +730,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
 	u32 devs_in_pkg = 0;
 	int i, ret, phy_reg;
+	u32 valid_did = 0;
 
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, so don't probe it at first.
@@ -796,12 +797,21 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 		if (phy_reg < 0)
 			return -EIO;
 		c45_ids->device_ids[i] |= phy_reg;
+
+		/* Check if there is at least one valid device ID */
+		if (c45_ids->device_ids[i] &&
+		    (c45_ids->device_ids[i] & 0x1fffffff) != 0x1fffffff)
+			valid_did |= (1 << i);
 	}
 
 	c45_ids->devices_in_package = devs_in_pkg;
 	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
 	c45_ids->mmds_present = devs_in_pkg & ~BIT(0);
 
+	/* There is no valid device ID */
+	if (!valid_did)
+		return -ENODEV;
+
 	return 0;
 }
 
-- 
2.17.0

