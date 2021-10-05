Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07FB422C93
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbhJEPfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhJEPfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 11:35:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA8FC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 08:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kZCpUL7mannz34YLP9nSzlT6N3C2Go4oYM86/cH99vw=; b=ptmKoJOxgz3P6NhPLLutgEWVPr
        VyTnkJBJ7gY+G65/mLKYdsjrlefkqHaESR1RWtfxm2T2dl20Qnp1+zaLMwzPYPunLYVQ38NlwXsaX
        9//zOal/ate3f3PexbQ73expIPECMRypmOZdO1i2rzyPTsvBYn0wiIJG0z3ncvJ8pzrUV3xGJhLWQ
        tGvDTsVrFYB7bXzVyPXU6pAKc4Pu3A/r9mPZYcM3joO6sscl7m62r1DI84e35iEpD+NLi8dnj4a1G
        fA5JOJlBxE9M7q13Gn77WLqXTHdt1ToAXZ4K3hSWJNMvqhTo56p6hjd2p4FNxHYGs+fwX/gEcsEDJ
        B9ydJAAA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47080 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXmS6-0000Uo-4g; Tue, 05 Oct 2021 16:33:58 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXmS5-0015rD-Jd; Tue, 05 Oct 2021 16:33:57 +0100
In-Reply-To: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
References: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: mdio: add mdiobus_modify_changed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mXmS5-0015rD-Jd@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 05 Oct 2021 16:33:57 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mdiobus_modify_changed() helper to reflect the phylib and similar
equivalents. This will avoid this functionality being open-coded, as
has already happened in phylink, and it looks like other users will be
appearing soon.

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

