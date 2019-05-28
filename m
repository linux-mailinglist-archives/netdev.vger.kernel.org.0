Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE92C796
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 15:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfE1NPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 09:15:31 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38470 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfE1NPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 09:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v1tUxQtZcT8X2kC/VixPttJSHUKmpg2pgWJ5/28a8mA=; b=zmO5T48LgPvKTWOov5E+VzFCw
        3u9JR5qo635x6Saq8Tg4UCRtOICxNms0dNi8hb0GI6vewgb5Q6HPgBmWshrjNTkXHUhol7cmZmTcb
        jWBvLW8VyO2POc8uWasWNOsLfX3X/Cc9Po7eHq2aCDu6rHjrNnr4LrUu5uRiwuSFUZ9vVflcpXt7d
        kSZEA8wLxO4glUNRBR9KB1F8r+YxLaOOcx+buZyZiGQS2fUflT9SsESeIYArHj4Pkp4AvTss7FWKG
        sBiqeMF4nib/6PiO6OdfdRHnjfvChYhF9UdiU4N5ZXHjGvtV+YcPyGRrUZkC9giDg0fI3B2wN+NYA
        QofkDm3Qw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56036)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVbws-0005yH-87; Tue, 28 May 2019 14:15:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVbwq-0003eQ-FX; Tue, 28 May 2019 14:15:24 +0100
Date:   Tue, 28 May 2019 14:15:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: phy: move handling latched link-down
 to phylib state machine
Message-ID: <20190528131524.unl7uvgzurcppu7s@shell.armlinux.org.uk>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <b79f49f8-a42b-11c1-f83e-c198fee49dab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b79f49f8-a42b-11c1-f83e-c198fee49dab@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 08:29:45PM +0200, Heiner Kallweit wrote:
> Especially with fibre links there may be very short link drops. And if
> interrupt handling is slow we may miss such a link drop. To deal with
> this we remove the double link status read from the generic link status
> read functions, and call the state machine twice instead.
> The flag for double-reading link status can be set by phy_mac_interrupt
> from hard irq context, therefore we have to use an atomic operation.

I came up with a different solution to this - I haven't extensively
tested it yet though:

 drivers/net/phy/phy-c45.c    | 12 ------------
 drivers/net/phy/phy.c        | 29 +++++++++++++++++++----------
 drivers/net/phy/phy_device.c | 14 --------------
 3 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 9e24d9569424..756d7711cbc5 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -222,18 +222,6 @@ int genphy_c45_read_link(struct phy_device *phydev)
 		devad = __ffs(mmd_mask);
 		mmd_mask &= ~BIT(devad);
 
-		/* The link state is latched low so that momentary link
-		 * drops can be detected. Do not double-read the status
-		 * in polling mode to detect such short link drops.
-		 */
-		if (!phy_polling_mode(phydev)) {
-			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
-			if (val < 0)
-				return val;
-			else if (val & MDIO_STAT1_LSTATUS)
-				continue;
-		}
-
 		val = phy_read_mmd(phydev, devad, MDIO_STAT1);
 		if (val < 0)
 			return val;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 7b3c5eec0129..2e7f0428e8fa 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -507,20 +507,29 @@ static int phy_config_aneg(struct phy_device *phydev)
  */
 static int phy_check_link_status(struct phy_device *phydev)
 {
-	int err;
+	int err, i;
 
 	WARN_ON(!mutex_is_locked(&phydev->lock));
 
-	err = phy_read_status(phydev);
-	if (err)
-		return err;
+	/* The link state is latched low so that momentary link drops can
+	 * be detected. If the link has failed, re-read the link status
+	 * to ensure that we are up to date with the current link state,
+	 * while notifying that the link status has changed.
+	 */
+	for (i = 0; i < 2; i++) {
+		err = phy_read_status(phydev);
+		if (err)
+			return err;
 
-	if (phydev->link && phydev->state != PHY_RUNNING) {
-		phydev->state = PHY_RUNNING;
-		phy_link_up(phydev);
-	} else if (!phydev->link && phydev->state != PHY_NOLINK) {
-		phydev->state = PHY_NOLINK;
-		phy_link_down(phydev, true);
+		if (phydev->link && phydev->state != PHY_RUNNING) {
+			phydev->state = PHY_RUNNING;
+			phy_link_up(phydev);
+		} else if (!phydev->link && phydev->state != PHY_NOLINK) {
+			phydev->state = PHY_NOLINK;
+			phy_link_down(phydev, true);
+		}
+		if (phydev->link)
+			break;
 	}
 
 	return 0;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 77068c545de0..ccc292c0f585 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1704,20 +1704,6 @@ int genphy_update_link(struct phy_device *phydev)
 {
 	int status;
 
-	/* The link state is latched low so that momentary link
-	 * drops can be detected. Do not double-read the status
-	 * in polling mode to detect such short link drops.
-	 */
-	if (!phy_polling_mode(phydev)) {
-		status = phy_read(phydev, MII_BMSR);
-		if (status < 0) {
-			return status;
-		} else if (status & BMSR_LSTATUS) {
-			phydev->link = 1;
-			return 0;
-		}
-	}
-
 	/* Read link and autonegotiation status */
 	status = phy_read(phydev, MII_BMSR);
 	if (status < 0)
-- 
2.7.4


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
