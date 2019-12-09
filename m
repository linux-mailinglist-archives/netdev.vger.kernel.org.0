Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCB8116E9E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfLIOIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:08:20 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34392 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLIOIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:08:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZExqbcLQm37N62W50D9jnodCLZh3tujGOFvVc6/9xRw=; b=iQm0r3tgheF9etDlKQrh7/DqRS
        iYJMp259o4YCxHSrtpODl9CM+NeFx67uGyp9SvWTqueQE6P719JxZQ2aAf6so+pOIxq7rcHZBBoOy
        WMiqXyYOGb8FJZ86Q6kSeDW/k+xpWJlm6QOnruPOnnYhb2UVgqxgIqS2xCgEOuxzUdrzkGT73QHoH
        G2i1ProjSlUS0SLmF09pmv7DqnRZA4Lm1WN8QQyttePZ2NeKPhGhic6xVrbPa2Y/7GgD1xcjYAMgA
        0ZNuB0lXCN6Q9LyJHDknaO0NEInybvaB3g/U8oDslvLvc1BRJ8bxeoPmyYQKFdUzniTUfVwfffnPB
        JAp8U2Lg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54432 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJhc-0003RK-UU; Mon, 09 Dec 2019 14:07:57 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJhZ-0004Pq-H8; Mon, 09 Dec 2019 14:07:53 +0000
In-Reply-To: <20191209140258.GI25745@shell.armlinux.org.uk>
References: <20191209140258.GI25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 14/14] net: sfp: add support for Clause 45 PHYs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJhZ-0004Pq-H8@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:07:53 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some SFP+ modules have a Clause 45 PHY onboard, which is accessible via
the normal I2C address.  Detect 10G BASE-T PHYs which may have an
accessible PHY and probe for it.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 44 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index d7d2c797c89c..bfe268028154 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1402,12 +1402,12 @@ static void sfp_sm_phy_detach(struct sfp *sfp)
 	sfp->mod_phy = NULL;
 }
 
-static void sfp_sm_probe_phy(struct sfp *sfp)
+static void sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 {
 	struct phy_device *phy;
 	int err;
 
-	phy = mdiobus_scan(sfp->i2c_mii, SFP_PHY_ADDR);
+	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
 	if (phy == ERR_PTR(-ENODEV)) {
 		dev_info(sfp->dev, "no PHY detected\n");
 		return;
@@ -1417,6 +1417,13 @@ static void sfp_sm_probe_phy(struct sfp *sfp)
 		return;
 	}
 
+	err = phy_device_register(phy);
+	if (err) {
+		phy_device_free(phy);
+		dev_err(sfp->dev, "phy_device_register failed: %d\n", err);
+		return;
+	}
+
 	err = sfp_add_phy(sfp->sfp_bus, phy);
 	if (err) {
 		phy_device_remove(phy);
@@ -1487,10 +1494,32 @@ static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
 	}
 }
 
+/* Probe a SFP for a PHY device if the module supports copper - the PHY
+ * normally sits at I2C bus address 0x56, and may either be a clause 22
+ * or clause 45 PHY.
+ *
+ * Clause 22 copper SFP modules normally operate in Cisco SGMII mode with
+ * negotiation enabled, but some may be in 1000base-X - which is for the
+ * PHY driver to determine.
+ *
+ * Clause 45 copper SFP+ modules (10G) appear to switch their interface
+ * mode according to the negotiated line speed.
+ */
 static void sfp_sm_probe_for_phy(struct sfp *sfp)
 {
-	if (sfp->id.base.e1000_base_t)
-		sfp_sm_probe_phy(sfp);
+	switch (sfp->id.base.extended_cc) {
+	case SFF8024_ECC_10GBASE_T_SFI:
+	case SFF8024_ECC_10GBASE_T_SR:
+	case SFF8024_ECC_5GBASE_T:
+	case SFF8024_ECC_2_5GBASE_T:
+		sfp_sm_probe_phy(sfp, true);
+		break;
+
+	default:
+		if (sfp->id.base.e1000_base_t)
+			sfp_sm_probe_phy(sfp, false);
+		break;
+	}
 }
 
 static int sfp_module_parse_power(struct sfp *sfp)
@@ -1550,6 +1579,13 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 		return -EAGAIN;
 	}
 
+	/* DM7052 reports as a high power module, responds to reads (with
+	 * all bytes 0xff) at 0x51 but does not accept writes.  In any case,
+	 * if the bit is already set, we're already in high power mode.
+	 */
+	if (!!(val & BIT(0)) == enable)
+		return 0;
+
 	if (enable)
 		val |= BIT(0);
 	else
-- 
2.20.1

