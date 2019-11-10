Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD12F6952
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKJOHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:48 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45752 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yGoGAP8gXrF4W0wR5ChbrC0VhgAQTxQbgD7DdGtYHmw=; b=aH77GymyakUid6YqJgLElJVMYM
        VM7nPNfzIV9xXIg8r62yC4f0OF5s03XYCgKZ3NXG0Q3SVCBTP7KncRZ1bzDtC9FT8qX94kzgG8EEa
        iILARx1u0p/N8WqQjeo0m1TCamFiT7sJvo3S0NU+JwbWuzfYm5xifmx+PLjMry0fbxq0VpVGGtYem
        TvZXce329elRkULhWKuMfVrcT/B6mJ9c3iukAuqPxeFaHkqgS7Kq9gtPWLWUmLede8JaVdK8AHDu4
        Hm9kX8ucFEDeWnj1nPgYaskP/ON4wwO68FclMIiG1438kmqnWvGe6WBOm5Wx9b+GxsrtwDi8lpOXE
        vs1i45BQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:47416 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnsG-0007f5-66; Sun, 10 Nov 2019 14:07:28 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnsD-0005Bv-3z; Sun, 10 Nov 2019 14:07:25 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 15/17] net: sfp: move module insert reporting out of
 probe
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnsD-0005Bv-3z@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:07:25 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the module insertion reporting out of the probe handling, but
after we have detected that the upstream has attached (since that is
whom we are reporting insertion to.)

Only report module removal if we had previously reported a module
insertion.

This gives cleaner semantics, and means we can probe the module before
we have an upstream attached.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 58 +++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 1d58e0d0478b..5aaeee461d06 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -47,11 +47,12 @@ enum {
 	SFP_E_TIMEOUT,
 
 	SFP_MOD_EMPTY = 0,
+	SFP_MOD_ERROR,
 	SFP_MOD_PROBE,
+	SFP_MOD_WAITDEV,
 	SFP_MOD_HPOWER,
 	SFP_MOD_WAITPWR,
 	SFP_MOD_PRESENT,
-	SFP_MOD_ERROR,
 
 	SFP_DEV_DETACHED = 0,
 	SFP_DEV_DOWN,
@@ -70,11 +71,12 @@ enum {
 
 static const char  * const mod_state_strings[] = {
 	[SFP_MOD_EMPTY] = "empty",
+	[SFP_MOD_ERROR] = "error",
 	[SFP_MOD_PROBE] = "probe",
+	[SFP_MOD_WAITDEV] = "waitdev",
 	[SFP_MOD_HPOWER] = "hpower",
 	[SFP_MOD_WAITPWR] = "waitpwr",
 	[SFP_MOD_PRESENT] = "present",
-	[SFP_MOD_ERROR] = "error",
 };
 
 static const char *mod_state_to_str(unsigned short mod_state)
@@ -1481,16 +1483,13 @@ static int sfp_sm_mod_probe(struct sfp *sfp)
 	if (ret < 0)
 		return ret;
 
-	ret = sfp_module_insert(sfp->sfp_bus, &sfp->id);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
 static void sfp_sm_mod_remove(struct sfp *sfp)
 {
-	sfp_module_remove(sfp->sfp_bus);
+	if (sfp->sm_mod_state > SFP_MOD_WAITDEV)
+		sfp_module_remove(sfp->sfp_bus);
 
 	sfp_hwmon_remove(sfp);
 
@@ -1541,12 +1540,12 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 	}
 
 	/* Handle device detach globally */
-	if (sfp->sm_dev_state < SFP_DEV_DOWN) {
+	if (sfp->sm_dev_state < SFP_DEV_DOWN &&
+	    sfp->sm_mod_state > SFP_MOD_WAITDEV) {
 		if (sfp->module_power_mW > 1000 &&
 		    sfp->sm_mod_state > SFP_MOD_HPOWER)
 			sfp_sm_mod_hpower(sfp, false);
-		if (sfp->sm_mod_state > SFP_MOD_EMPTY)
-			sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
+		sfp_sm_mod_next(sfp, SFP_MOD_WAITDEV, 0);
 		return;
 	}
 
@@ -1557,6 +1556,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 		break;
 
 	case SFP_MOD_PROBE:
+		/* Wait for T_PROBE_INIT to time out */
 		if (event != SFP_E_TIMEOUT)
 			break;
 
@@ -1570,6 +1570,20 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 			break;
 		}
 
+		sfp_sm_mod_next(sfp, SFP_MOD_WAITDEV, 0);
+		/* fall through */
+	case SFP_MOD_WAITDEV:
+		/* Ensure that the device is attached before proceeding */
+		if (sfp->sm_dev_state < SFP_DEV_DOWN)
+			break;
+
+		/* Report the module insertion to the upstream device */
+		err = sfp_module_insert(sfp->sfp_bus, &sfp->id);
+		if (err < 0) {
+			sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
+			break;
+		}
+
 		/* If this is a power level 1 module, we are done */
 		if (sfp->module_power_mW <= 1000)
 			goto insert;
@@ -1579,12 +1593,17 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 	case SFP_MOD_HPOWER:
 		/* Enable high power mode */
 		err = sfp_sm_mod_hpower(sfp, true);
-		if (err == 0)
-			sfp_sm_mod_next(sfp, SFP_MOD_WAITPWR, T_HPOWER_LEVEL);
-		else if (err != -EAGAIN)
-			sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
-		else
-			sfp_sm_set_timer(sfp, T_PROBE_RETRY);
+		if (err < 0) {
+			if (err != -EAGAIN) {
+				sfp_module_remove(sfp->sfp_bus);
+				sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
+			} else {
+				sfp_sm_set_timer(sfp, T_PROBE_RETRY);
+			}
+			break;
+		}
+
+		sfp_sm_mod_next(sfp, SFP_MOD_WAITPWR, T_HPOWER_LEVEL);
 		break;
 
 	case SFP_MOD_WAITPWR:
@@ -1752,8 +1771,6 @@ static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 static void sfp_attach(struct sfp *sfp)
 {
 	sfp_sm_event(sfp, SFP_E_DEV_ATTACH);
-	if (sfp->state & SFP_F_PRESENT)
-		sfp_sm_event(sfp, SFP_E_INSERT);
 }
 
 static void sfp_detach(struct sfp *sfp)
@@ -2021,6 +2038,11 @@ static int sfp_probe(struct platform_device *pdev)
 		sfp->state |= SFP_F_RATE_SELECT;
 	sfp_set_state(sfp, sfp->state);
 	sfp_module_tx_disable(sfp);
+	if (sfp->state & SFP_F_PRESENT) {
+		rtnl_lock();
+		sfp_sm_event(sfp, SFP_E_INSERT);
+		rtnl_unlock();
+	}
 
 	for (i = 0; i < GPIO_MAX; i++) {
 		if (gpio_flags[i] != GPIOD_IN || !sfp->gpio[i])
-- 
2.20.1

