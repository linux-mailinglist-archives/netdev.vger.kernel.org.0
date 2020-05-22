Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4211DF142
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgEVVcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:32:09 -0400
Received: from foss.arm.com ([217.140.110.172]:42338 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731130AbgEVVbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:31:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C43D011FB;
        Fri, 22 May 2020 14:31:10 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B398E3F68F;
        Fri, 22 May 2020 14:31:10 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 03/11] net: phy: refactor c45 phy identification sequence
Date:   Fri, 22 May 2020 16:30:51 -0500
Message-Id: <20200522213059.1535892-4-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522213059.1535892-1-jeremy.linton@arm.com>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lets factor out the phy id logic, and make it generic
so that it can be used for c22 and c45.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/phy/phy_device.c | 65 +++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7746c07b97fe..f0761fa5e40b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -695,6 +695,29 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
 	return 0;
 }
 
+static int _get_phy_id(struct mii_bus *bus, int addr, int dev_addr,
+		       u32 *phy_id, bool c45)
+{
+	int phy_reg, reg_addr;
+
+	int reg_base = c45 ? (MII_ADDR_C45 | dev_addr << 16) : 0;
+
+	reg_addr =  reg_base | MII_PHYSID1;
+	phy_reg = mdiobus_read(bus, addr, reg_addr);
+	if (phy_reg < 0)
+		return -EIO;
+
+	*phy_id = phy_reg << 16;
+
+	reg_addr = reg_base | MII_PHYSID2;
+	phy_reg = mdiobus_read(bus, addr, reg_addr);
+	if (phy_reg < 0)
+		return -EIO;
+	*phy_id |= phy_reg;
+
+	return 0;
+}
+
 static bool valid_phy_id(int val)
 {
 	return (val > 0 && ((val & 0x1fffffff) != 0x1fffffff));
@@ -715,17 +738,17 @@ static bool valid_phy_id(int val)
  */
 static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 			   struct phy_c45_device_ids *c45_ids) {
-	int phy_reg;
-	int i, reg_addr;
+	int ret;
+	int i;
 	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
 	u32 *devs = &c45_ids->devices_in_package;
 
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, so don't probe it at first.
 	 */
-	for (i = 1; i < num_ids && *devs == 0; i++) {
-		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
-		if (phy_reg < 0)
+	for (i = 0; i < num_ids && *devs == 0; i++) {
+		ret = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
+		if (ret < 0)
 			return -EIO;
 
 		if ((*devs & 0x1fffffff) == 0x1fffffff) {
@@ -752,17 +775,9 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 		if (!(c45_ids->devices_in_package & (1 << i)))
 			continue;
 
-		reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID1;
-		phy_reg = mdiobus_read(bus, addr, reg_addr);
-		if (phy_reg < 0)
-			return -EIO;
-		c45_ids->device_ids[i] = phy_reg << 16;
-
-		reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID2;
-		phy_reg = mdiobus_read(bus, addr, reg_addr);
-		if (phy_reg < 0)
-			return -EIO;
-		c45_ids->device_ids[i] |= phy_reg;
+		ret = _get_phy_id(bus, addr, i, &c45_ids->device_ids[i], true);
+		if (ret < 0)
+			return ret;
 	}
 	*phy_id = 0;
 	return 0;
@@ -787,27 +802,17 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
 		      bool is_c45, struct phy_c45_device_ids *c45_ids)
 {
-	int phy_reg;
+	int ret;
 
 	if (is_c45)
 		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
 
-	/* Grab the bits from PHYIR1, and put them in the upper half */
-	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
-	if (phy_reg < 0) {
+	ret = _get_phy_id(bus, addr, 0, phy_id, false);
+	if (ret < 0) {
 		/* returning -ENODEV doesn't stop bus scanning */
-		return (phy_reg == -EIO || phy_reg == -ENODEV) ? -ENODEV : -EIO;
+		return (ret == -EIO || ret == -ENODEV) ? -ENODEV : -EIO;
 	}
 
-	*phy_id = phy_reg << 16;
-
-	/* Grab the bits from PHYIR2, and put them in the lower half */
-	phy_reg = mdiobus_read(bus, addr, MII_PHYSID2);
-	if (phy_reg < 0)
-		return -EIO;
-
-	*phy_id |= phy_reg;
-
 	return 0;
 }
 
-- 
2.26.2

