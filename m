Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B01122C4F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfLQMxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:53:14 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56176 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbfLQMxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 07:53:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bIkKGkHFeCYPYnsvx+1+EU4iFYImAov+HqBbvJzJx3s=; b=DNz8i9QNngKAsfgZ0kUDhx8eQM
        LA++y26GZ0XBuokqx9yBBx59Js2LHhF1YHFbmQz5UABQf1n+wMHIJRPGrWlY+RyxX5XktNX0iBH6q
        A8Lyck1CFsVGEB7R9FNdF2ihRZJlElxQ9ajioBb2sVnezFrdunB3AIeGDblclQwIFRxP1QHiGlWQ/
        Ygm5aexUx6d6tysQ/lfqgEnEH/3+neQqSoCtu4P7yPVu855U1r3YsPotc8ePcy5UdHIhnrfmAQ0MV
        jT6EtA1k7BBj6DZVbMHaWeXCnnyNOdYNL1OaUfchoMHrO8ZNUlFsdq3OBjPxWwrNI+IHBGwpOl64g
        yOU++U3w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:51508 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihCLa-00061q-CW; Tue, 17 Dec 2019 12:53:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihCLZ-0001Vo-Nw; Tue, 17 Dec 2019 12:53:05 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phy: make phy_error() report which PHY has failed
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 12:53:05 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_error() is called from phy_interrupt() or phy_state_machine(), and
uses WARN_ON() to print a backtrace. The backtrace is not useful when
reporting a PHY error.

However, a system may contain multiple ethernet PHYs, and phy_error()
gives no clue which one caused the problem.

Replace WARN_ON() with a call to phydev_err() so that we can see which
PHY had an error, and also inform the user that we are halting the PHY.

Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
There is another related problem in this area. If an error is detected
while the PHY is running, phy_error() moves to PHY_HALTED state. If we
try to take the network device down, then:

void phy_stop(struct phy_device *phydev)
{
        if (!phy_is_started(phydev)) {
                WARN(1, "called from state %s\n",
                     phy_state_to_str(phydev->state));
                return;
        }

triggers, and we never do any of the phy_stop() cleanup. I'm not sure
what the best way to solve this is - introducing a PHY_ERROR state may
be a solution, but I think we want some phy_is_started() sites to
return true for it and others to return false.

Heiner - you introduced the above warning, could you look at improving
this case so we don't print a warning and taint the kernel when taking
a network device down after phy_error() please?

Thanks.

 drivers/net/phy/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 49300fb59757..06fbca959383 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -663,7 +663,7 @@ void phy_stop_machine(struct phy_device *phydev)
  */
 static void phy_error(struct phy_device *phydev)
 {
-	WARN_ON(1);
+	phydev_err(phydev, "Error detected, halting PHY\n");
 
 	mutex_lock(&phydev->lock);
 	phydev->state = PHY_HALTED;
-- 
2.20.1

