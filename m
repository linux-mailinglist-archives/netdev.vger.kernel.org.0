Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA766116ED1
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfLIOQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:16:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34526 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLIOQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=whsx8ahNuXdTnoQDzTj8HCV7v7Z8Z+k0e2iD1MjTHnA=; b=oFZrZ2qahi83AtF8Mm4bJXx01B
        VSLERBqBKc2trbs99+d8WMEjrqKrPZquDA4UWKcgUIW6V/q972Dd24Iw1/HeMEl9Ohtgwfm17e4ys
        8PjEf86atsRC6e7Q9tDfbz6se6Z9+ugKPycZk5BrEFwrfI64fltoE8sTm15KVkhnotLWbv+WLxZaF
        x+YRiTLl4+Se6nDww0jZfK1eAg8rVdnHzgNntC9RzSBpObgITLgovOYMqLASd0nSidUTD5tfw0VT9
        oeBO2YDiWIE6anGXFygxlTCeJ8sCGZWc8DanWN5+8c+mWvpHxb80HOxTy1ZBhFvtftOb0IDCLQdSE
        LbeSFo+Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:50210 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpX-0003VC-Q6; Mon, 09 Dec 2019 14:16:07 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJpV-0004Uh-Rh; Mon, 09 Dec 2019 14:16:06 +0000
In-Reply-To: <20191209141525.GK25745@shell.armlinux.org.uk>
References: <20191209141525.GK25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] net: sfp: error handling for phy probe
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJpV-0004Uh-Rh@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:16:05 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index a67f089f2106..76fa95e54542 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1410,7 +1410,7 @@ static void sfp_sm_phy_detach(struct sfp *sfp)
 	sfp->mod_phy = NULL;
 }
 
-static void sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
+static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 {
 	struct phy_device *phy;
 	int err;
@@ -1418,18 +1418,18 @@ static void sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
 	if (phy == ERR_PTR(-ENODEV)) {
 		dev_info(sfp->dev, "no PHY detected\n");
-		return;
+		return 0;
 	}
 	if (IS_ERR(phy)) {
 		dev_err(sfp->dev, "mdiobus scan returned %ld\n", PTR_ERR(phy));
-		return;
+		return PTR_ERR(phy);
 	}
 
 	err = phy_device_register(phy);
 	if (err) {
 		phy_device_free(phy);
 		dev_err(sfp->dev, "phy_device_register failed: %d\n", err);
-		return;
+		return err;
 	}
 
 	err = sfp_add_phy(sfp->sfp_bus, phy);
@@ -1437,10 +1437,12 @@ static void sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 		phy_device_remove(phy);
 		phy_device_free(phy);
 		dev_err(sfp->dev, "sfp_add_phy failed: %d\n", err);
-		return;
+		return err;
 	}
 
 	sfp->mod_phy = phy;
+
+	return 0;
 }
 
 static void sfp_sm_link_up(struct sfp *sfp)
@@ -1513,21 +1515,24 @@ static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
  * Clause 45 copper SFP+ modules (10G) appear to switch their interface
  * mode according to the negotiated line speed.
  */
-static void sfp_sm_probe_for_phy(struct sfp *sfp)
+static int sfp_sm_probe_for_phy(struct sfp *sfp)
 {
+	int err = 0;
+
 	switch (sfp->id.base.extended_cc) {
 	case SFF8024_ECC_10GBASE_T_SFI:
 	case SFF8024_ECC_10GBASE_T_SR:
 	case SFF8024_ECC_5GBASE_T:
 	case SFF8024_ECC_2_5GBASE_T:
-		sfp_sm_probe_phy(sfp, true);
+		err = sfp_sm_probe_phy(sfp, true);
 		break;
 
 	default:
 		if (sfp->id.base.e1000_base_t)
-			sfp_sm_probe_phy(sfp, false);
+			err = sfp_sm_probe_phy(sfp, false);
 		break;
 	}
+	return err;
 }
 
 static int sfp_module_parse_power(struct sfp *sfp)
@@ -1938,7 +1943,10 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 	init_done:	/* TX_FAULT deasserted or we timed out with TX_FAULT
 			 * clear.  Probe for the PHY and check the LOS state.
 			 */
-			sfp_sm_probe_for_phy(sfp);
+			if (sfp_sm_probe_for_phy(sfp)) {
+				sfp_sm_next(sfp, SFP_S_FAIL, 0);
+				break;
+			}
 			if (sfp_module_start(sfp->sfp_bus)) {
 				sfp_sm_next(sfp, SFP_S_FAIL, 0);
 				break;
-- 
2.20.1

