Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D58340172
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 10:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhCRJFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 05:05:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:10982 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCRJFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 05:05:30 -0400
IronPort-SDR: I4QSBcDttPm3Dqga/8UFFnI+e/0J5I80LDy88Lxz19hIP7Rk9Q9pVq1xq/42W18uMJhA2eYmsu
 gObtBFt26vWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="189680237"
X-IronPort-AV: E=Sophos;i="5.81,258,1610438400"; 
   d="scan'208";a="189680237"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 02:05:30 -0700
IronPort-SDR: hk1yorJL8O8FykbM/JjTKrcSQC9oqv23EYpanBd3nw0Fr62+mSv+J4CUl6v+bPqFCf1dHfpnmp
 j97KseJ5l6Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,258,1610438400"; 
   d="scan'208";a="372645266"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga003.jf.intel.com with ESMTP; 18 Mar 2021 02:05:27 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using C22
Date:   Thu, 18 Mar 2021 17:09:37 +0800
Message-Id: <20210318090937.26465-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using Clause-22 to probe for PHY devices such as the Marvell
88E2110, PHY ID with value 0 is read from the MII PHYID registers
which caused the PHY framework failed to attach the Marvell PHY
driver.

Fixed this by adding a check of PHY ID equals to all zeroes.

Fixes: ee951005e95e ("net: phy: clean up get_phy_c22_id() invalid ID handling")
Cc: stable@vger.kernel.org
Reviewed-by: Voon Weifeng <voon.weifeng@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
v2 changelog:
 - added fixes tag
 - marked for net instead of net-next
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cc38e326405a..c12c30254c11 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -809,8 +809,8 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 
 	*phy_id |= phy_reg;
 
-	/* If the phy_id is mostly Fs, there is no device there */
-	if ((*phy_id & 0x1fffffff) == 0x1fffffff)
+	/* If the phy_id is mostly Fs or all zeroes, there is no device there */
+	if (((*phy_id & 0x1fffffff) == 0x1fffffff) || (*phy_id == 0))
 		return -ENODEV;
 
 	return 0;
-- 
2.25.1

