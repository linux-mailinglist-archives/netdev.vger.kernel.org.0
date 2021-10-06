Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131CD423DA3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbhJFMXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 08:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238528AbhJFMVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 08:21:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E713DC061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 05:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WMsZeqh6NkQxkTaSn18Onkg9hq544HRPd48Hiu9NIDs=; b=LFPWPC+Bpn4lcQjmbUB5AqdJ6h
        16L7v5U3euzfIqWpiEqb+rWbwXz2/7I1iQCm/EH1KDkEZZVAcGn0/L9tdY2gCq/BU5jsNm7+nYIQK
        PlHKmpJiaLnB/7S5tzNcf2kTjIr5RRW7j7PUB/u0S7hnX0DEnfTRyN4YR2XYb7pzskdyrnRRcYWYH
        sOBdwZkkxZ1wFPImgUbQ804k7g+mQDl79sLX/o3TX6VmuthBSM85UecyO8GMg8zlJsw5/w/aciNGb
        8UM+9ep8ueZIZq0RbDMYFtdot+1D1nQCU4zmzTAuYGNe/S+z3hOgu5F6vts57qGojCUT+eUb8is7Z
        TO+DOxiA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53138 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mY5tI-0001LF-N7; Wed, 06 Oct 2021 13:19:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mY5tI-001SlN-9S; Wed, 06 Oct 2021 13:19:20 +0100
In-Reply-To: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
References: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/2] net: mdio: add mdiobus_modify_changed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mY5tI-001SlN-9S@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Oct 2021 13:19:20 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mdiobus_modify_changed() helper to reflect the phylib and similar
equivalents. This will avoid this functionality being open-coded, as
has already happened in phylink, and it looks like other users will be
appearing soon.

iReviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio_bus.c | 22 ++++++++++++++++++++++
 include/linux/mdio.h       |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index d25411ae1796..8c59eb6a2b68 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -926,6 +926,28 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask, u16 set)
 }
 EXPORT_SYMBOL_GPL(mdiobus_modify);
 
+/**
+ * mdiobus_modify_changed - Convenience function for modifying a given mdio
+ *	device register and returning if it changed
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ */
+int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
+			   u16 mask, u16 set)
+{
+	int err;
+
+	mutex_lock(&bus->mdio_lock);
+	err = __mdiobus_modify_changed(bus, addr, regnum, mask, set);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mdiobus_modify_changed);
+
 /**
  * mdio_bus_match - determine if given MDIO driver supports the given
  *		    MDIO device
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 5e6dc38f418e..f622888a4ba8 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -349,6 +349,8 @@ int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 		   u16 set);
+int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
+			   u16 mask, u16 set);
 
 static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 {
-- 
2.30.2

