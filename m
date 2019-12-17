Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564A0122D11
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfLQNjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:39:24 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56750 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2FlLngNOKohUwLC+qXOUbq4yYFVpl6E49OOj6+XHQlU=; b=GUuNZVGlYniSKRl1wUg3QJ9V4v
        HwC5ai1LrNjHzJocn3ga3zjMKFDy+3gc5M9WuucOto1WRedxqzaXZpAezfEQNZVmkLoiV/B8xQygI
        o7dUw70HIQHRw7M4nGY0g/DwIWq3zFR4Bu5aTQzDL7Zvh0UdDXE+eI+HiX4yDCvVAoTWp/8AJwNpC
        OdME5/LPtG1elX/oKsxLGw0vOe7B6rano7yQ5UUI5TcZYPKUY7dgv8WI28Bf0CBYzSu/9qx4N9u6x
        kEJPBRWbFV5GG7q+m8KpJ2Jp+7NltDtCLnMH4RV+WLk/lMk75beYXnRpQ+rVGh3Ke/x/3GGHp1zQo
        pZuPLX6g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:35582 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4C-0006Eu-8t; Tue, 17 Dec 2019 13:39:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihD4B-0001yY-7I; Tue, 17 Dec 2019 13:39:11 +0000
In-Reply-To: <20191217133827.GQ25745@shell.armlinux.org.uk>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 03/11] net: phy: add genphy_check_and_restart_aneg()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihD4B-0001yY-7I@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:39:11 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for restarting autonegotiation(), similar to the clause 45
variant.  Use it in __genphy_config_aneg()

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 48 +++++++++++++++++++++++-------------
 include/linux/phy.h          |  1 +
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e9520e065691..e5854508627b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1736,6 +1736,36 @@ int genphy_restart_aneg(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_restart_aneg);
 
+/**
+ * genphy_check_and_restart_aneg - Enable and restart auto-negotiation
+ * @phydev: target phy_device struct
+ * @restart: whether aneg restart is requested
+ *
+ * Check, and restart auto-negotiation if needed.
+ */
+int genphy_check_and_restart_aneg(struct phy_device *phydev, bool restart)
+{
+	int ret = 0;
+
+	if (!restart) {
+		/* Advertisement hasn't changed, but maybe aneg was never on to
+		 * begin with?  Or maybe phy was isolated?
+		 */
+		ret = phy_read(phydev, MII_BMCR);
+		if (ret < 0)
+			return ret;
+
+		if (!(ret & BMCR_ANENABLE) || (ret & BMCR_ISOLATE))
+			restart = true;
+	}
+
+	if (restart)
+		ret = genphy_restart_aneg(phydev);
+
+	return ret;
+}
+EXPORT_SYMBOL(genphy_check_and_restart_aneg);
+
 /**
  * __genphy_config_aneg - restart auto-negotiation or write BMCR
  * @phydev: target phy_device struct
@@ -1761,23 +1791,7 @@ int __genphy_config_aneg(struct phy_device *phydev, bool changed)
 	else if (err)
 		changed = true;
 
-	if (!changed) {
-		/* Advertisement hasn't changed, but maybe aneg was never on to
-		 * begin with?  Or maybe phy was isolated?
-		 */
-		int ctl = phy_read(phydev, MII_BMCR);
-
-		if (ctl < 0)
-			return ctl;
-
-		if (!(ctl & BMCR_ANENABLE) || (ctl & BMCR_ISOLATE))
-			changed = true; /* do restart aneg */
-	}
-
-	/* Only restart aneg if we are advertising something different
-	 * than we were before.
-	 */
-	return changed ? genphy_restart_aneg(phydev) : 0;
+	return genphy_check_and_restart_aneg(phydev, changed);
 }
 EXPORT_SYMBOL(__genphy_config_aneg);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f69c0e9a0c7d..dbcd887f9015 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1095,6 +1095,7 @@ void phy_attached_info(struct phy_device *phydev);
 int genphy_read_abilities(struct phy_device *phydev);
 int genphy_setup_forced(struct phy_device *phydev);
 int genphy_restart_aneg(struct phy_device *phydev);
+int genphy_check_and_restart_aneg(struct phy_device *phydev, bool restart);
 int genphy_config_eee_advert(struct phy_device *phydev);
 int __genphy_config_aneg(struct phy_device *phydev, bool changed);
 int genphy_aneg_done(struct phy_device *phydev);
-- 
2.20.1

