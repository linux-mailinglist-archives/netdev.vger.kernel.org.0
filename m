Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4C9122D20
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfLQNkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:40:09 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56836 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLQNkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:40:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7W3eQvl76FFnxEN2OH8OdGYAj0sJR1w3S3NSVjgZ2N0=; b=EYxnjjTKDccX7TLuuaMTQ/taPC
        o5z5QgoSRQVvceQd9WqYcfiiCmcNzIYDOkL6WUyyeTJnPb/fwk9ktSIA2oWCCwvN3znS2IOBE72Tc
        XcrcpNiWH0FCuBm+8GmqEpxcWKXlHy7VPBT+CsvO6ZREB4+uAs5/0JGMwh4MGFP13/MwpQLUByfA6
        RuJoGJJRpX6F0/O7HbzAV97kT8fJXKAZ4ETWLUAQXkgB/nt1tTxGSNQsmSIhCpDXYTbgSATkGsGSR
        VNsB9AEGFo9VxljO50yMjI8O08q5tavMMjtqBvVTepyfZoHeIsBq+1ljm2KQpC7uMIN44w5tZI7Sk
        nfWtf8fQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39840 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4s-0006G0-UC; Tue, 17 Dec 2019 13:39:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4q-0001zY-8c; Tue, 17 Dec 2019 13:39:52 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 11/11] net: phy: marvell: use
 genphy_check_and_restart_aneg()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4q-0001zY-8c@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:52 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the helper to check and restart autonegotiation for the marvell
fiber page negotiation setting.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index c40d49523719..a173c05fdb4c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -545,26 +545,7 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 	if (err > 0)
 		changed = 1;
 
-	if (changed == 0) {
-		/* Advertisement hasn't changed, but maybe aneg was never on to
-		 * begin with?	Or maybe phy was isolated?
-		 */
-		int ctl = phy_read(phydev, MII_BMCR);
-
-		if (ctl < 0)
-			return ctl;
-
-		if (!(ctl & BMCR_ANENABLE) || (ctl & BMCR_ISOLATE))
-			changed = 1; /* do restart aneg */
-	}
-
-	/* Only restart aneg if we are advertising something different
-	 * than we were before.
-	 */
-	if (changed > 0)
-		changed = genphy_restart_aneg(phydev);
-
-	return changed;
+	return genphy_check_and_restart_aneg(phydev, changed);
 }
 
 static int m88e1510_config_aneg(struct phy_device *phydev)
-- 
2.20.1

