Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3416AF6951
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfKJOHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:44 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45748 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dU1V6RasLiNMKuldMwSNTnG3A4mzaK/rcWOaxD7kS1Y=; b=D89P/NX9DkZLlZAEOoWL60987m
        z8/pGJAuDVXBqJMR9InCJB2FSKKPcH8cRwQnIthJeFmnbBlcsS+R0ZoQkDD7j3mJ8/JiyfFByghTS
        DZ3noGMOGqJuilL2vP/PmM1MRWzxSgNXM1FhC8/btbdUF1mut8ZfM08mcvbDdTAAO4XryJUjSZBiO
        jcDs38wTTSw8ecLduvwNiEelE78Uri5qphfY1mnGYrd97gFQXair49uAlAnUwsCodNd47zw3PYyGO
        4SFLzt9dUS6tXdqF5xNULk702TLQzs158LadITj1T6/jLKQ3lwb9+peoElnuH9SPv+RmtnKIhBNE3
        1o2InClw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:47414 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnsB-0007eu-3O; Sun, 10 Nov 2019 14:07:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTns8-0005Bj-0F; Sun, 10 Nov 2019 14:07:20 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 14/17] net: sfp: split power mode switching from
 probe
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTns8-0005Bj-0F@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:07:20 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch the power mode switching from the probe, so that we don't
repeatedly re-probe the SFP device if there is a problem accessing
the registers at I2C address 0x51.

In splitting this out, we can also fix a bug where we leave the module
in high-power mode when the upstream device is detached but the module
is still inserted.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 101 ++++++++++++++++++++++++++----------------
 1 file changed, 64 insertions(+), 37 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 95e0dd4a52df..1d58e0d0478b 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -49,6 +49,7 @@ enum {
 	SFP_MOD_EMPTY = 0,
 	SFP_MOD_PROBE,
 	SFP_MOD_HPOWER,
+	SFP_MOD_WAITPWR,
 	SFP_MOD_PRESENT,
 	SFP_MOD_ERROR,
 
@@ -71,6 +72,7 @@ static const char  * const mod_state_strings[] = {
 	[SFP_MOD_EMPTY] = "empty",
 	[SFP_MOD_PROBE] = "probe",
 	[SFP_MOD_HPOWER] = "hpower",
+	[SFP_MOD_WAITPWR] = "waitpwr",
 	[SFP_MOD_PRESENT] = "present",
 	[SFP_MOD_ERROR] = "error",
 };
@@ -1360,37 +1362,34 @@ static int sfp_module_parse_power(struct sfp *sfp)
 	return 0;
 }
 
-static int sfp_sm_mod_hpower(struct sfp *sfp)
+static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 {
 	u8 val;
 	int err;
 
-	if (sfp->module_power_mW <= 1000)
-		return 0;
-
 	err = sfp_read(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
 	if (err != sizeof(val)) {
 		dev_err(sfp->dev, "Failed to read EEPROM: %d\n", err);
-		err = -EAGAIN;
-		goto err;
+		return -EAGAIN;
 	}
 
-	val |= BIT(0);
+	if (enable)
+		val |= BIT(0);
+	else
+		val &= ~BIT(0);
 
 	err = sfp_write(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
 	if (err != sizeof(val)) {
 		dev_err(sfp->dev, "Failed to write EEPROM: %d\n", err);
-		err = -EAGAIN;
-		goto err;
+		return -EAGAIN;
 	}
 
-	dev_info(sfp->dev, "Module switched to %u.%uW power level\n",
-		 sfp->module_power_mW / 1000,
-		 (sfp->module_power_mW / 100) % 10);
-	return T_HPOWER_LEVEL;
+	if (enable)
+		dev_info(sfp->dev, "Module switched to %u.%uW power level\n",
+			 sfp->module_power_mW / 1000,
+			 (sfp->module_power_mW / 100) % 10);
 
-err:
-	return err;
+	return 0;
 }
 
 static int sfp_sm_mod_probe(struct sfp *sfp)
@@ -1486,7 +1485,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp)
 	if (ret < 0)
 		return ret;
 
-	return sfp_sm_mod_hpower(sfp);
+	return 0;
 }
 
 static void sfp_sm_mod_remove(struct sfp *sfp)
@@ -1531,13 +1530,22 @@ static void sfp_sm_device(struct sfp *sfp, unsigned int event)
  */
 static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 {
-	/* Handle remove event globally, it resets this state machine.
-	 * Also deal with upstream detachment.
-	 */
-	if (event == SFP_E_REMOVE || sfp->sm_dev_state < SFP_DEV_DOWN) {
+	int err;
+
+	/* Handle remove event globally, it resets this state machine */
+	if (event == SFP_E_REMOVE) {
 		if (sfp->sm_mod_state > SFP_MOD_PROBE)
 			sfp_sm_mod_remove(sfp);
-		if (sfp->sm_mod_state != SFP_MOD_EMPTY)
+		sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
+		return;
+	}
+
+	/* Handle device detach globally */
+	if (sfp->sm_dev_state < SFP_DEV_DOWN) {
+		if (sfp->module_power_mW > 1000 &&
+		    sfp->sm_mod_state > SFP_MOD_HPOWER)
+			sfp_sm_mod_hpower(sfp, false);
+		if (sfp->sm_mod_state > SFP_MOD_EMPTY)
 			sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
 		return;
 	}
@@ -1549,26 +1557,45 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 		break;
 
 	case SFP_MOD_PROBE:
-		if (event == SFP_E_TIMEOUT) {
-			int val = sfp_sm_mod_probe(sfp);
-
-			if (val == 0)
-				sfp_sm_mod_next(sfp, SFP_MOD_PRESENT, 0);
-			else if (val > 0)
-				sfp_sm_mod_next(sfp, SFP_MOD_HPOWER, val);
-			else if (val != -EAGAIN)
-				sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
-			else
-				sfp_sm_set_timer(sfp, T_PROBE_RETRY);
+		if (event != SFP_E_TIMEOUT)
+			break;
+
+		err = sfp_sm_mod_probe(sfp);
+		if (err == -EAGAIN) {
+			sfp_sm_set_timer(sfp, T_PROBE_RETRY);
+			break;
+		}
+		if (err < 0) {
+			sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
+			break;
 		}
-		break;
 
+		/* If this is a power level 1 module, we are done */
+		if (sfp->module_power_mW <= 1000)
+			goto insert;
+
+		sfp_sm_mod_next(sfp, SFP_MOD_HPOWER, 0);
+		/* fall through */
 	case SFP_MOD_HPOWER:
-		if (event == SFP_E_TIMEOUT) {
-			sfp_sm_mod_next(sfp, SFP_MOD_PRESENT, 0);
+		/* Enable high power mode */
+		err = sfp_sm_mod_hpower(sfp, true);
+		if (err == 0)
+			sfp_sm_mod_next(sfp, SFP_MOD_WAITPWR, T_HPOWER_LEVEL);
+		else if (err != -EAGAIN)
+			sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
+		else
+			sfp_sm_set_timer(sfp, T_PROBE_RETRY);
+		break;
+
+	case SFP_MOD_WAITPWR:
+		/* Wait for T_HPOWER_LEVEL to time out */
+		if (event != SFP_E_TIMEOUT)
 			break;
-		}
-		/* fallthrough */
+
+	insert:
+		sfp_sm_mod_next(sfp, SFP_MOD_PRESENT, 0);
+		break;
+
 	case SFP_MOD_PRESENT:
 	case SFP_MOD_ERROR:
 		break;
-- 
2.20.1

