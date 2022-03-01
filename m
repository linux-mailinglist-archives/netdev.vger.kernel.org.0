Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4EA4C871E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiCAIwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCAIwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:52:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBFA89CCF
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 00:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DFkXxdKDfwdDXk3Dh36o2bOdV+1I3ozhcfAahRRlMkY=; b=VxyPqti5/hyGf6IwS8pIk8ght6
        MWoy5mkrA+9UQK3ufj9DKCA1Wh9UG2AMUwKuH5ApVFSpfe0i3FcomeFidNXvLwY4XtLFM6RCNmUQi
        jERY18zWgJUd1lkkenVc3ksOjf+KX6xixU7kD4MvQe8Nk4qe8Mufv+/WImtpO/YyDjblPQs0OYle7
        mcZMw2WmndflhYwMBbkV+o3JmfTKmQuiY2ZFElXJe2XFMBgtNfXF8GuQlfp9TXkriGBLqx6klfi0+
        S4Zl+LQd8/mE8q8azxu9k+EvXUtt8hy0fW4jC7zn1ChgrwhKMjnHZbZRvEisZxp2qlloPWU+Gdv3c
        ZhvaAX3g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40828 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nOyEO-00010v-B0; Tue, 01 Mar 2022 08:51:40 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nOyEN-00BuuE-OB; Tue, 01 Mar 2022 08:51:39 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: sfp: use %pe for printing errors
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nOyEN-00BuuE-OB@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 01 Mar 2022 08:51:39 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert sfp to use %pe for printing error codes, which can print them
as errno symbols rather than numbers.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 48 +++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4720b24ca51b..4dfb79807823 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -471,8 +471,8 @@ static unsigned int sfp_soft_get_state(struct sfp *sfp)
 			state |= SFP_F_TX_FAULT;
 	} else {
 		dev_err_ratelimited(sfp->dev,
-				    "failed to read SFP soft status: %d\n",
-				    ret);
+				    "failed to read SFP soft status: %pe\n",
+				    ERR_PTR(ret));
 		/* Preserve the current state */
 		state = sfp->state;
 	}
@@ -1311,7 +1311,8 @@ static void sfp_hwmon_probe(struct work_struct *work)
 			mod_delayed_work(system_wq, &sfp->hwmon_probe,
 					 T_PROBE_RETRY_SLOW);
 		} else {
-			dev_warn(sfp->dev, "hwmon probe failed: %d\n", err);
+			dev_warn(sfp->dev, "hwmon probe failed: %pe\n",
+				 ERR_PTR(err));
 		}
 		return;
 	}
@@ -1516,14 +1517,15 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
-		dev_err(sfp->dev, "mdiobus scan returned %ld\n", PTR_ERR(phy));
+		dev_err(sfp->dev, "mdiobus scan returned %pe\n", phy);
 		return PTR_ERR(phy);
 	}
 
 	err = phy_device_register(phy);
 	if (err) {
 		phy_device_free(phy);
-		dev_err(sfp->dev, "phy_device_register failed: %d\n", err);
+		dev_err(sfp->dev, "phy_device_register failed: %pe\n",
+			ERR_PTR(err));
 		return err;
 	}
 
@@ -1531,7 +1533,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	if (err) {
 		phy_device_remove(phy);
 		phy_device_free(phy);
-		dev_err(sfp->dev, "sfp_add_phy failed: %d\n", err);
+		dev_err(sfp->dev, "sfp_add_phy failed: %pe\n", ERR_PTR(err));
 		return err;
 	}
 
@@ -1708,7 +1710,7 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 
 	err = sfp_read(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
 	if (err != sizeof(val)) {
-		dev_err(sfp->dev, "Failed to read EEPROM: %d\n", err);
+		dev_err(sfp->dev, "Failed to read EEPROM: %pe\n", ERR_PTR(err));
 		return -EAGAIN;
 	}
 
@@ -1726,7 +1728,8 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 
 	err = sfp_write(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
 	if (err != sizeof(val)) {
-		dev_err(sfp->dev, "Failed to write EEPROM: %d\n", err);
+		dev_err(sfp->dev, "Failed to write EEPROM: %pe\n",
+			ERR_PTR(err));
 		return -EAGAIN;
 	}
 
@@ -1778,7 +1781,9 @@ static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
 		id->base.connector = SFF8024_CONNECTOR_LC;
 		err = sfp_write(sfp, false, SFP_PHYS_ID, &id->base, 3);
 		if (err != 3) {
-			dev_err(sfp->dev, "Failed to rewrite module EEPROM: %d\n", err);
+			dev_err(sfp->dev,
+				"Failed to rewrite module EEPROM: %pe\n",
+				ERR_PTR(err));
 			return err;
 		}
 
@@ -1789,7 +1794,9 @@ static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
 		check = sfp_check(&id->base, sizeof(id->base) - 1);
 		err = sfp_write(sfp, false, SFP_CC_BASE, &check, 1);
 		if (err != 1) {
-			dev_err(sfp->dev, "Failed to update base structure checksum in fiber module EEPROM: %d\n", err);
+			dev_err(sfp->dev,
+				"Failed to update base structure checksum in fiber module EEPROM: %pe\n",
+				ERR_PTR(err));
 			return err;
 		}
 	}
@@ -1814,12 +1821,13 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
 		if (report)
-			dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
+			dev_err(sfp->dev, "failed to read EEPROM: %pe\n",
+				ERR_PTR(ret));
 		return -EAGAIN;
 	}
 
 	if (ret != sizeof(id.base)) {
-		dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
+		dev_err(sfp->dev, "EEPROM short read: %pe\n", ERR_PTR(ret));
 		return -EAGAIN;
 	}
 
@@ -1839,13 +1847,15 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 		if (ret < 0) {
 			if (report)
-				dev_err(sfp->dev, "failed to read EEPROM: %d\n",
-					ret);
+				dev_err(sfp->dev,
+					"failed to read EEPROM: %pe\n",
+					ERR_PTR(ret));
 			return -EAGAIN;
 		}
 
 		if (ret != sizeof(id.base)) {
-			dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
+			dev_err(sfp->dev, "EEPROM short read: %pe\n",
+				ERR_PTR(ret));
 			return -EAGAIN;
 		}
 	}
@@ -1887,12 +1897,13 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	ret = sfp_read(sfp, false, SFP_CC_BASE + 1, &id.ext, sizeof(id.ext));
 	if (ret < 0) {
 		if (report)
-			dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
+			dev_err(sfp->dev, "failed to read EEPROM: %pe\n",
+				ERR_PTR(ret));
 		return -EAGAIN;
 	}
 
 	if (ret != sizeof(id.ext)) {
-		dev_err(sfp->dev, "EEPROM short read: %d\n", ret);
+		dev_err(sfp->dev, "EEPROM short read: %pe\n", ERR_PTR(ret));
 		return -EAGAIN;
 	}
 
@@ -2046,7 +2057,8 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
 		err = sfp_hwmon_insert(sfp);
 		if (err)
-			dev_warn(sfp->dev, "hwmon probe failed: %d\n", err);
+			dev_warn(sfp->dev, "hwmon probe failed: %pe\n",
+				 ERR_PTR(err));
 
 		sfp_sm_mod_next(sfp, SFP_MOD_WAITDEV, 0);
 		fallthrough;
-- 
2.30.2

