Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6314BF6971
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKJOXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:23:17 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46012 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfKJOXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7iVNr8dfoiGZ/Qt3oRMQxgKF3UAjeMk8uMONbT3sj2U=; b=znbjNMOQCyzJadvI8OyRFsgVqB
        ifw14kxXGutIktmaSCD6qBpV5fyN833feidNXfLU+Ogt2hGAmtW8iaokD1VTKoTetaYaE2qEbnBUn
        vF/wgoFj1P4z2VwHtU1MCIG99XrbSHEwnr01xcR74oMbFDL+pI+CZ1FYN+7rXmxMoHE//RSdI597Q
        prOZSnHIXm/ba39SlXhPmqkpvECd7Wuq3NPQfISyNVnDoiqN1tChhATJUoFzKv1avpXVuBBgRSuyV
        QF7N9D/hROjrEdynRi7STG7pFTaCPbEI34wseAdtE0rxJTHG2Q1oFTi4WIP07XtI8Rta3I95D99US
        Z8VLRbpw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54142 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTo7T-0007kT-Ci; Sun, 10 Nov 2019 14:23:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTo7S-0005Sx-RH; Sun, 10 Nov 2019 14:23:10 +0000
In-Reply-To: <20191110142226.GB25745@shell.armlinux.org.uk>
References: <20191110142226.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: phy: marvell10g: add SFP+ support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTo7S-0005Sx-RH@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:23:10 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SFP+ cages to the Marvell 10G PHY driver. This is
slightly complicated by the way phylib works in that we need to use
a multi-step process to attach the SFP bus, and we also need to track
the phylink state machine to know when the module's transmit disable
signal should change state.

With appropriate DT changes, this allows the SFP+ canges on the
Macchiatobin platform to be functional.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 3b99882692e3..1bf13017d288 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -26,6 +26,7 @@
 #include <linux/hwmon.h>
 #include <linux/marvell_phy.h>
 #include <linux/phy.h>
+#include <linux/sfp.h>
 
 #define MV_PHY_ALASKA_NBT_QUIRK_MASK	0xfffffffe
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
@@ -206,6 +207,28 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
 }
 #endif
 
+static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
+{
+	struct phy_device *phydev = upstream;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(support) = { 0, };
+	phy_interface_t iface;
+
+	sfp_parse_support(phydev->sfp_bus, id, support);
+	iface = sfp_select_interface(phydev->sfp_bus, id, support);
+
+	if (iface != PHY_INTERFACE_MODE_10GKR) {
+		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct sfp_upstream_ops mv3310_sfp_ops = {
+	.attach = phy_sfp_attach,
+	.detach = phy_sfp_detach,
+	.module_insert = mv3310_sfp_insert,
+};
+
 static int mv3310_probe(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv;
@@ -236,7 +259,7 @@ static int mv3310_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	return 0;
+	return phy_sfp_probe(phydev, &mv3310_sfp_ops);
 }
 
 static int mv3310_suspend(struct phy_device *phydev)
-- 
2.20.1

