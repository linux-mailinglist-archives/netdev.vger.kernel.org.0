Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BF11E241D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgEZObd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgEZObc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:31:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F32C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 07:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P+HO+Qb19suunYEMp6znLtvOD+JT4UQM8o7ndCq0jpA=; b=kO/2txEIoiyQy/QFgMIjDG9keF
        NNP3ZPkgy7E0mNMyH1qmE7e7ype4E/HIhHh2JugOVxQ6IKCnquuOaqTNw4j9A3bYBXbQkDS/PIZeE
        Vw+Gph1K/rTk1CfquX9kN5y3fBWJ2vOZUOzdEUdefVVTW8hEDC6wGOgJTFNpS4tK7lSB4Uz7BXS4b
        Bo+ClFOqTlygFRtR8/fw9/qdy2tw+TDaOagZQ9SxUCtqW+noRP+u1t7l2gmlgCWVCU+At1JSTG0ln
        kGHGB5+DCbq17C8CQyl7VBRdemBPSNE7NRtxA34CmlEQEmg08E53kdlIYGbG7YB8ffiAidCrGQ8A4
        sSeJiGTw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37034 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdabo-00080Y-UB; Tue, 26 May 2020 15:31:13 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jdabn-0005sO-LN; Tue, 26 May 2020 15:31:11 +0100
In-Reply-To: <20200526142948.GY1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH RFC 3/7] net: phy: clean up PHY ID reading
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jdabn-0005sO-LN@rmk-PC.armlinux.org.uk>
Date:   Tue, 26 May 2020 15:31:11 +0100
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

