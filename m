Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495CB48460D
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiADQiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiADQiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:38:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B444C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g0E+NGFB7v4b1gjLeI4O9VCmvlV0IxGRKu97xwdEl1Y=; b=FyRsHYD0pK8kFNayH9nVDqQbOv
        Op7GSPlUAbqb5+kSGai46YC5EkoOAaqLd/QxLP1Cn7xAhLDi+ttxOqUBR6Mb8o0kmpqY1rt/Vvtoo
        bs8dzkzJmJZ/fnmKRRX64yIzuzrwSQG9AWKuVSILHpkwRUFY8OAerbHum2XjYTvi2F8yShjA6AmjA
        d4tIQ5K+vfmDYJsE42BEBGUEJB4Lt3Nsq3AQVbi1iJkjhakNXkx0zA7SKNJgcOwr+bRUqxI50vlEa
        N3WMU3OxlAZ95JmGWFXEF8rTHplQyxjdKGbTmXORUWBOfQNmKSVM0SJEUlSK6kwDKCulh/4K+Y7k6
        toyyI9EQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49482 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1n4mpH-0007Gt-J6; Tue, 04 Jan 2022 16:38:19 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1n4mpH-002PKK-37; Tue, 04 Jan 2022 16:38:19 +0000
In-Reply-To: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
References: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phy: marvell: configure RGMII delays for
 88E1118
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1n4mpH-002PKK-37@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 04 Jan 2022 16:38:19 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corentin Labbe reports that the SSI 1328 does not work when allowing
the PHY to operate at gigabit speeds, but does work with the generic
PHY driver.

This appears to be because m88e1118_config_init() writes a fixed value
to the MSCR register, claiming that this is to enable 1G speeds.
However, this always sets bits 4 and 5, enabling RGMII transmit and
receive delays. The suspicion is that the original board this was
added for required the delays to make 1G speeds work.

Add the necessary configuration for RGMII delays for the 88E1118 to
bring this into line with the requirements for RGMII support, and thus
make the SSI 1328 work.

Corentin Labbe has tested this on gemini-ssi1328 and gemini-ns2502.

Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 64e7874c95f4..739859c0dfb1 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1234,6 +1234,12 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	if (phy_interface_is_rgmii(phydev)) {
+		err = m88e1121_config_aneg_rgmii_delays(phydev);
+		if (err < 0)
+			return err;
+	}
+
 	/* Adjust LED Control */
 	if (phydev->dev_flags & MARVELL_PHY_M1118_DNS323_LEDS)
 		leds = 0x1100;
-- 
2.30.2

