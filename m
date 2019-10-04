Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D76CC028
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390360AbfJDQGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:06:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33762 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389835AbfJDQGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KxCvbYmfHj72Fmw3ybcEyWCtfiwGqSSMUc6d32YUwU0=; b=KMXW7lu1Xz4nibD8rAxLUsKwUX
        6NDqsv8ymVBtqTsWhfSK0QeuownSYgg5v4v68r+3qMx2sltgIyITP1MzE7LGtGEBkfDa73NgplHEu
        q7OwtGb891o0bSScgqZoiq7HGK53HuixR0qY29c3fbEy3kXXSst9yiZnbhty0Ds65kCjcfx8QiXTc
        TC5nOw42YkFcGOXCmRGBULIFuGbwpwT2SdPj0eBE7ptSUnA3e8esDUyNSNGpZ2QxB85JnMBKjQQwJ
        FtdCn6bwV7IauNQ+DKQBYPyy8/1MRdapZU7prjBV4kFxi45swhpPkdP0kHNDIera0Wtt5e1oACJbd
        IbOMNwkQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39866 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iGQ5y-0005LR-LA; Fri, 04 Oct 2019 17:06:18 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iGQ5u-0001Qv-EF; Fri, 04 Oct 2019 17:06:14 +0100
In-Reply-To: <20191004160525.GZ25745@shell.armlinux.org.uk>
References: <20191004160525.GZ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2 4/4] net: phy: at803x: use operating parameters from
 PHY-specific status
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iGQ5u-0001Qv-EF@rmk-PC.armlinux.org.uk>
Date:   Fri, 04 Oct 2019 17:06:14 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the PHY-specific status register for the current operating mode
(speed and duplex) of the PHY.  This register reflects the actual
mode that the PHY has resolved depending on either the advertisements
of autoneg is enabled, or the forced mode if autoneg is disabled.

This ensures that phylib's software state always tracks the hardware
state.

It seems both AR8033 (which uses the AR8031 ID) and AR8035 support
this status register.  AR8030 is not known at the present time.

This patch depends on "net: phy: extract pause mode" and "net: phy:
extract link partner advertisement reading".

Reported-by: tinywrkb <tinywrkb@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: tinywrkb <tinywrkb@gmail.com>
Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/at803x.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 2aa7b2e60046..1eb5d4fb8925 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -15,6 +15,15 @@
 #include <linux/of_gpio.h>
 #include <linux/gpio/consumer.h>
 
+#define AT803X_SPECIFIC_STATUS			0x11
+#define AT803X_SS_SPEED_MASK			(3 << 14)
+#define AT803X_SS_SPEED_1000			(2 << 14)
+#define AT803X_SS_SPEED_100			(1 << 14)
+#define AT803X_SS_SPEED_10			(0 << 14)
+#define AT803X_SS_DUPLEX			BIT(13)
+#define AT803X_SS_SPEED_DUPLEX_RESOLVED		BIT(11)
+#define AT803X_SS_MDIX				BIT(6)
+
 #define AT803X_INTR_ENABLE			0x12
 #define AT803X_INTR_ENABLE_AUTONEG_ERR		BIT(15)
 #define AT803X_INTR_ENABLE_SPEED_CHANGED	BIT(14)
@@ -357,6 +366,64 @@ static int at803x_aneg_done(struct phy_device *phydev)
 	return aneg_done;
 }
 
+static int at803x_read_status(struct phy_device *phydev)
+{
+	int ss, err, old_link = phydev->link;
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	err = genphy_read_lpa(phydev);
+	if (err < 0)
+		return err;
+
+	/* Read the AT8035 PHY-Specific Status register, which indicates the
+	 * speed and duplex that the PHY is actually using, irrespective of
+	 * whether we are in autoneg mode or not.
+	 */
+	ss = phy_read(phydev, AT803X_SPECIFIC_STATUS);
+	if (ss < 0)
+		return ss;
+
+	if (ss & AT803X_SS_SPEED_DUPLEX_RESOLVED) {
+		switch (ss & AT803X_SS_SPEED_MASK) {
+		case AT803X_SS_SPEED_10:
+			phydev->speed = SPEED_10;
+			break;
+		case AT803X_SS_SPEED_100:
+			phydev->speed = SPEED_100;
+			break;
+		case AT803X_SS_SPEED_1000:
+			phydev->speed = SPEED_1000;
+			break;
+		}
+		if (ss & AT803X_SS_DUPLEX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+		if (ss & AT803X_SS_MDIX)
+			phydev->mdix = ETH_TP_MDI_X;
+		else
+			phydev->mdix = ETH_TP_MDI;
+	}
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
+		phy_resolve_aneg_pause(phydev);
+
+	return 0;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* ATHEROS 8035 */
@@ -370,6 +437,7 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
+	.read_status		= at803x_read_status,
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 }, {
@@ -399,6 +467,7 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
+	.read_status		= at803x_read_status,
 	.aneg_done		= at803x_aneg_done,
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
-- 
2.7.4

