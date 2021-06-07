Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641A139D2F8
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhFGCd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:33:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:42307 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230133AbhFGCd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Jun 2021 22:33:56 -0400
IronPort-SDR: gPo2bU+kI09WyJ4/eGCnbFlSKnjfouGN6fjaLPQmO7wBqlOiD7eETF4wYsbO1wi+TfAoZG0Rgi
 RDYLq2FC9AzQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="201529669"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="201529669"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 19:32:06 -0700
IronPort-SDR: xacJE92Mzk0/Sc3cfFlgel8bTGGFYfbFldpaixql4Taf+123qagviLyUed53V2f66y8JqFjcJU
 UV3xXuk+bYhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="551745168"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2021 19:32:06 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 81228580973;
        Sun,  6 Jun 2021 19:32:04 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/1] net: phy: probe for C45 PHYs that return PHY ID of zero in C22 space
Date:   Mon,  7 Jun 2021 10:36:45 +0800
Message-Id: <20210607023645.2958840-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY devices such as the Marvell Alaska 88E2110 does not return a valid
PHY ID when probed using Clause-22. The current implementation treats
PHY ID of zero as a non-error and valid PHY ID, and causing the PHY
device failed to bind to the Marvell driver.

For such devices, we do an additional probe in the Clause-45 space,
if a valid PHY ID is returned, we then proceed to attach the PHY
device to the matching PHY ID driver.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/phy/phy_device.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea021ac0..495d86b4af7c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -870,6 +870,18 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	if (r)
 		return ERR_PTR(r);
 
+	/* PHY device such as the Marvell Alaska 88E2110 will return a PHY ID
+	 * of 0 when probed using get_phy_c22_id() with no error. Proceed to
+	 * probe with C45 to see if we're able to get a valid PHY ID in the C45
+	 * space, if successful, create the C45 PHY device.
+	 */
+	if (!is_c45 && phy_id == 0 && bus->probe_capabilities >= MDIOBUS_C45) {
+		r = get_phy_c45_ids(bus, addr, &c45_ids);
+		if (!r)
+			return phy_device_create(bus, addr, phy_id,
+						 true, &c45_ids);
+	}
+
 	return phy_device_create(bus, addr, phy_id, is_c45, &c45_ids);
 }
 EXPORT_SYMBOL(get_phy_device);
-- 
2.25.1

