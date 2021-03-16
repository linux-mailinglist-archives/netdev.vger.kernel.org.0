Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9263233D027
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhCPIyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:54:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:39224 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235553AbhCPIxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 04:53:43 -0400
IronPort-SDR: brrGyZ0wcQU5MpNfuw0wXLNhD1TkzXUw9W7B/ww3B5mZnnKLnecMym8FkSf65GHuOJIRBeliQ+
 ejmtWbJPTesw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189274541"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189274541"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:53:42 -0700
IronPort-SDR: bFPhdZuFuRIsfoX6ZTnXty9YDw1RjNQZmXexsuTu0fZHwM1wQLp4jEQnebGHn8I3Q4gcrPEShb
 +e8hD8vwsN6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="373724184"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2021 01:53:40 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Weifeng <voon.weifeng@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next 1/1] net: phy: fix invalid phy id when probe using C22
Date:   Tue, 16 Mar 2021 16:57:48 +0800
Message-Id: <20210316085748.3017-1-vee.khee.wong@intel.com>
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

Cc: stable@vger.kernel.org
Reviewed-by: Voon Weifeng <voon.weifeng@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a009d1769b08..f1afc00fcba2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -820,8 +820,8 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 
 	*phy_id |= phy_reg;
 
-	/* If the phy_id is mostly Fs, there is no device there */
-	if ((*phy_id & 0x1fffffff) == 0x1fffffff)
+	/* If the phy_id is mostly Fs or all zeroes, there is no device there */
+	if (((*phy_id & 0x1fffffff) == 0x1fffffff) || (*phy_id == 0))
 		return -ENODEV;
 
 	return 0;
-- 
2.25.1

