Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A901E3F1C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgE0KeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgE0KeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:34:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E42C061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P+HO+Qb19suunYEMp6znLtvOD+JT4UQM8o7ndCq0jpA=; b=Nrrbpbj7d9CdWsgep/RtI/sdym
        3yYMiwJDwtq9dTESs5lBhaC56lXR0SdVk2oZICM1LyrdvbLM0nEURxPYuCqDLUMJzZ1CCCougWz9e
        TJ9jziQT61vcj3SfF3TnyZfWBHHsNzqAcnVYzko4jMwgI/u4ayFDBgK/dxvIC52IS0FMjy4bdUKFf
        kdUjlgcf87ukdIAysB1iMRMBshmQ2WkbuDHwhUhs1lf4Aw7e62Rb/tKzFRGwwJRi1Xd+6w+upxBQq
        COgi42uTwiOT66xTNv2mcLwtN6mNrk2WbCuCshW1DSKVF3Os7374IYtOBovsj/tkMytXsReOE+X8L
        hvxk1Dkg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:38112 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNh-0001wU-5H; Wed, 27 May 2020 11:33:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdtNf-00083L-EJ; Wed, 27 May 2020 11:33:51 +0100
In-Reply-To: <20200527103318.GK1551@shell.armlinux.org.uk>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 2/9] net: phy: clean up PHY ID reading
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdtNf-00083L-EJ@rmk-PC.armlinux.org.uk>
Date:   Wed, 27 May 2020 11:33:51 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange the code to read the PHY IDs, so we don't call get_phy_id()
only to immediately call get_phy_c45_ids().  Move that logic into
get_phy_device(), which results in better readability.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e04284c4ebf8..0d6b6ca66216 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -756,29 +756,18 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 }
 
 /**
- * get_phy_id - reads the specified addr for its ID.
+ * get_phy_c22_id - reads the specified addr for its clause 22 ID.
  * @bus: the target MII bus
  * @addr: PHY address on the MII bus
  * @phy_id: where to store the ID retrieved.
- * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
- * @c45_ids: where to store the c45 ID information.
- *
- * Description: In the case of a 802.3-c22 PHY, reads the ID registers
- *   of the PHY at @addr on the @bus, stores it in @phy_id and returns
- *   zero on success.
- *
- *   In the case of a 802.3-c45 PHY, get_phy_c45_ids() is invoked, and
- *   its return value is in turn returned.
  *
+ * Read the 802.3 clause 22 PHY ID from the PHY at @addr on the @bus.
+ * Return the PHY ID read from the PHY in @phy_id on successful access.
  */
-static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
-		      bool is_c45, struct phy_c45_device_ids *c45_ids)
+static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 {
 	int phy_reg;
 
-	if (is_c45)
-		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
-
 	/* Grab the bits from PHYIR1, and put them in the upper half */
 	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
 	if (phy_reg < 0) {
@@ -817,7 +806,11 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	c45_ids.devices_in_package = 0;
 	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
 
-	r = get_phy_id(bus, addr, &phy_id, is_c45, &c45_ids);
+	if (is_c45)
+		r = get_phy_c45_ids(bus, addr, &phy_id, &c45_ids);
+	else
+		r = get_phy_c22_id(bus, addr, &phy_id);
+
 	if (r)
 		return ERR_PTR(r);
 
-- 
2.20.1

