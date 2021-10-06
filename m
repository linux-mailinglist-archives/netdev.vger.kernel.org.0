Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21E3423DA6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhJFMXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 08:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhJFMVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 08:21:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E693BC061753
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 05:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XmL4s8Z1goyda8BCeRaIZGc7wmLHWCVbbKv3jmaXKTg=; b=fIhhRLn0iNY0yAqBtcIINCtKzc
        ZqV0lY0bsHbBoJjfE/6O3VzOwJFO8EeZqO5XBNyJIQUQ/Um9XAjevW4wM6/ZOU76jBSpDetqGl/hR
        tEFo2cTQCS3AcNtFt4opTcXbEnLDaFeCQi/mwTwl3dLLtNoLmyDNMgYul1ncDcxP3Pj7waAfAgaHD
        PP22MNh64263ov7b2LoiXQAwyfD/z0byZn+9o1oIs7hKrG7o29MsLhOloUkxIcH8KpYwbLv+tYXtd
        6TMBvqxGRk5wXcFUFnck9A6KyVDZPZc/kRbO/1CEZH9xae4htnhLmhYO/2q3vxs8iEg+uEV6a3n/Q
        xR1TsM/A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53140 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mY5tN-0001LQ-Qp; Wed, 06 Oct 2021 13:19:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mY5tN-001SlT-DB; Wed, 06 Oct 2021 13:19:25 +0100
In-Reply-To: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
References: <YV2UIa2eU+UjmWaE@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: phylink: use mdiobus_modify_changed()
 helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mY5tN-001SlT-DB@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Oct 2021 13:19:25 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the mdiobus_modify_changed() helper in the C22 PCS advertisement
helper.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
v2: fix build warnings

 drivers/net/phy/phylink.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b32774fd65f8..16240f2dd161 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2596,7 +2596,6 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 {
 	struct mii_bus *bus = pcs->bus;
 	int addr = pcs->addr;
-	int val, ret;
 	u16 adv;
 
 	switch (interface) {
@@ -2610,32 +2609,12 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
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

