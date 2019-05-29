Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7FC2DB54
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfE2LDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:03:25 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53802 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfE2LDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 07:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5IdmKPZQD7bbi1GmqNaL5KPnemw6kM/fEpmK9PgYE8E=; b=NO2W9s0FKRLmviIvrzK4bPhxY
        aqZEdPQckqol0SosB+LpZXZAzhoE3cEaIniAlefkpwWeDB6LVP3JTv1qFE+9q95TvLfNxdF8UwmzE
        9jD5nu4D8DXcLWl4HbH20B5m0OIe+BI4ZmwQgFLtNsmwzVu4E0VDgps6Li0udTMatRUx8IDo4m2Cq
        8afL3AIR2QMeQ/onZIdVG74tri4SK1W9tpcAOqxVFc9AXo4RtosGMl6YaT3pgPobuJZa4Ej1uNL7A
        ZiAl7ChQnUxuEIGNT9mSfHK8+d+jYhNpZOxuMnWbncZE7NnlwX/jNhUg/ab7QnGu6clIDVuIshZhP
        2/KnTuSFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52700)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVwMY-0003u7-Pe; Wed, 29 May 2019 12:03:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVwMV-0004UI-Ps; Wed, 29 May 2019 12:03:15 +0100
Date:   Wed, 29 May 2019 12:03:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190529110315.uw4a24avp4czhcru@shell.armlinux.org.uk>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
 <20190528154238.ifudfslyofk22xoe@shell.armlinux.org.uk>
 <20190528161139.GQ18059@lunn.ch>
 <20190528162356.xjq53h4z7edvr3gl@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528162356.xjq53h4z7edvr3gl@shell.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 05:23:56PM +0100, Russell King - ARM Linux admin wrote:
> On Tue, May 28, 2019 at 06:11:39PM +0200, Andrew Lunn wrote:
> > > One question: are we happy with failing the probe like this, or would it
> > > be better to allow the probe to suceed?
> > > 
> > > As has been pointed out in the C45 MII access patch, we need the PHY
> > > to bind to the network driver for the MII bus to be accessible to
> > > userspace, so if we're going to have userspace tools to upload the
> > > firmware, rather than using u-boot, we need the PHY to be present and
> > > bound to the network interface.
> > 
> > Hi Russell
> > 
> > It is an interesting question. Failing the probe is the simple
> > solution. If we don't fail the probe, we then need to allow the
> > attach, but fail all normal operations, with a noisy kernel log.  That
> > probably means adding a new state to the state machine, PHY_BROKEN.
> > Enter that state if phy_start_aneg() returns an error?
> 
> Hi Andrew,
> 
> I don't think we need a new state - I think we can trap it in
> the link_change_notify() method, and force phydev->state to
> PHY_HALTED if it's in phy_is_started() mode.
> 
> Maybe something like:
> 
> 	if (phy_is_started(phydev) && priv->firmware_failed) {
> 		dev_warn(&phydev->mdio.dev,
> 			 "PHY firmware failure: link forced down");
> 		phydev->state = PHY_HALTED;
> 	}
> 
> Or maybe we just need to do that if phydev->state == PHY_UP or
> PHY_RESUMING (the two states entered from phy_start())?

Here's the fuller patch for what I'm suggesting:

 drivers/net/phy/marvell10g.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 754cde873dde..86333d98b384 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -60,6 +60,8 @@ enum {
 };
 
 struct mv3310_priv {
+	bool firmware_failed;
+
 	struct device *hwmon_dev;
 	char *hwmon_name;
 };
@@ -214,6 +216,10 @@ static int mv3310_probe(struct phy_device *phydev)
 	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
 		return -ENODEV;
 
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
 	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT);
 	if (ret < 0)
 		return ret;
@@ -221,13 +227,9 @@ static int mv3310_probe(struct phy_device *phydev)
 	if (ret & MV_PMA_BOOT_FATAL) {
 		dev_warn(&phydev->mdio.dev,
 			 "PHY failed to boot firmware, status=%04x\n", ret);
-		return -ENODEV;
+		priv->firmware_failed = true;
 	}
 
-	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
 	dev_set_drvdata(&phydev->mdio.dev, priv);
 
 	ret = mv3310_hwmon_probe(phydev);
@@ -247,6 +249,19 @@ static int mv3310_resume(struct phy_device *phydev)
 	return mv3310_hwmon_config(phydev, true);
 }
 
+static void mv3310_link_change_notify(struct phy_device *phydev)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	enum phy_state state = phydev->state;
+
+	if (priv->firmware_failed &&
+	    (state == PHY_UP || state == PHY_RESUMING)) {
+		dev_warn(&phydev->mdio.dev,
+			 "PHY firmware failure: link forced down");
+		phydev->state = state = PHY_HALTED;
+	}
+}
+
 /* Some PHYs in the Alaska family such as the 88X3310 and the 88E2010
  * don't set bit 14 in PMA Extended Abilities (1.11), although they do
  * support 2.5GBASET and 5GBASET. For these models, we can still read their
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
