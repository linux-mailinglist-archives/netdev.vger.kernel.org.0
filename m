Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56277422C94
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbhJEPf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbhJEPf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 11:35:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31113C06174E
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 08:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YTto7jJWhp/RSwbT4zoyVnD8XEGlFYhOeR04W6jaLyM=; b=jEPAxGGPfWbCea26ADw4aLLb3r
        BhVlSO/VQ/zpDrce7NCHnheNSVyZsYfs80zwkadirCpUjpMfgFVNoNgTZgs2QX/VbXTh5W9M5uVWv
        LtUgZHYs8UJigqmocxr6ZL4oMEesH2IQEtGp+r6QZbs1LaupwSzBiM2RBg3JACDbAPqmX96Fv9Vpv
        R+pXThPHcA/HZOw8ANa5ecMBErdnClIMyWTRC2IHSBP1V8SqkbZJYWgoVh4T1ifyIr/gH0OlSBZf3
        bO4ZgN+cnrBmEyUdl1WPeMV+noC4fsyeXnUujqTlpEj3j3z0NsqdhEWW7Jtnj+5/CcMVaBZNKHeY5
        84dpyczA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47082 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXmSB-0000Uz-6w; Tue, 05 Oct 2021 16:34:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mXmSA-0015rK-Pj; Tue, 05 Oct 2021 16:34:02 +0100
In-Reply-To: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
References: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phylink: use mdiobus_modify_changed()
 helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mXmSA-0015rK-Pj@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 05 Oct 2021 16:34:02 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the mdiobus_modify_changed() helper in the C22 PCS advertisement
helper.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b32774fd65f8..d76362028752 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2610,32 +2610,12 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 				      advertising))
 			adv |= ADVERTISE_1000XPSE_ASYM;
 
-		val = mdiobus_read(bus, addr, MII_ADVERTISE);
-		if (val < 0)
-			return val;
-
-		if (val == adv)
-			return 0;
-
-		ret = mdiobus_write(bus, addr, MII_ADVERTISE, adv);
-		if (ret < 0)
-			return ret;
-
-		return 1;
+		return mdiobus_modify_changed(bus, addr, MII_ADVERTISE,
+					      0xffff, adv);
 
 	case PHY_INTERFACE_MODE_SGMII:
-		val = mdiobus_read(bus, addr, MII_ADVERTISE);
-		if (val < 0)
-			return val;
-
-		if (val == 0x0001)
-			return 0;
-
-		ret = mdiobus_write(bus, addr, MII_ADVERTISE, 0x0001);
-		if (ret < 0)
-			return ret;
-
-		return 1;
+		return mdiobus_modify_changed(bus, addr, MII_ADVERTISE,
+					      0xffff, 0x0001);
 
 	default:
 		/* Nothing to do for other modes */
-- 
2.30.2

