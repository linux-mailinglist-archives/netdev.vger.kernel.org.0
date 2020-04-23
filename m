Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DBB1B56C8
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDWH54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgDWH54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:57:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A770AC03C1AB
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 00:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ru/AYmU0ci79nnDEriAUHodbZXg/EUEgF1a9teKgbVQ=; b=gaKoTy3n+OOK2b4OFH0bx4jCj2
        +63ifc9DlcgmGLAbE2xn60eqauzD6suMg2NO5AOeZCOMrwTZVQkGxUvNuDXQjo66G/zTD3ix2pd0c
        Pn88rHs8LJFm6wVglo/l8eiaWOyh5tQiYPbvJobN7JDp8OFrD08BYCICmugNaMNXktqEVg/JzGQyu
        iVHkYJG+qAtJD2vL+4ujMcurG6g7prttkoZvc0rrF/Kqii/QD9SRO0D4W7f5u+5CMxjyq/vkbASD0
        oqx3sMkU+/4PQK6F9Cf8yDGRJquuN03pAxFxxxw1rDPt5O4egfGjYtjE6RQnLT6ufAt7yAm9HeAm0
        6nIfDu3A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37000 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jRWju-0004vC-Vd; Thu, 23 Apr 2020 08:57:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jRWju-0007AB-BO; Thu, 23 Apr 2020 08:57:42 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phy: bcm84881: clear settings on link down
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jRWju-0007AB-BO@rmk-PC.armlinux.org.uk>
Date:   Thu, 23 Apr 2020 08:57:42 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear the link partner advertisement, speed, duplex and pause when
the link goes down, as other phylib drivers do.  This avoids the
stale link partner, speed and duplex settings being reported via
ethtool.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/bcm84881.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 3840d2adbbb9..9717a1626f3f 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -155,9 +155,6 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
 		phydev->link = false;
 
-	if (!phydev->link)
-		return 0;
-
 	linkmode_zero(phydev->lp_advertising);
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
@@ -165,6 +162,9 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	phydev->asym_pause = 0;
 	phydev->mdix = 0;
 
+	if (!phydev->link)
+		return 0;
+
 	if (phydev->autoneg_complete) {
 		val = genphy_c45_read_lpa(phydev);
 		if (val < 0)
-- 
2.20.1

