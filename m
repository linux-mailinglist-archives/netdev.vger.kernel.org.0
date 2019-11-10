Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3F0F694A
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKJOHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:21 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45696 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1MmyKxGiLe3cH0ANyY1Vg+r3+fPf8dflBOXbUuC/9Ws=; b=r8u9/1tLrfxf8OZvrxHZg9Yw+P
        ysdqQ+VCitC0t3nSPDvyBmYZHFnOunlivpvOQSSVQa5ch6dRSGNX8DoU1Nb/8L0jeHNpgga83ZDIq
        WkpvUIMfRXRI+dOGp6wJcYUPklV1hEFo/cNvUPiCITFrnsvwS8EXoLAaRV75cBcfx9byptUX3rmUO
        dZHsFCekMf7AEI3z9pdBxXjArMPsiCkTFUbvOJJ6tOXgpvIX1xKCCsAXQtTWjvs8As1z997zHdvhr
        +nzgeavrItspqk9dynG8v0afijhHE3RXzkqwN3vjH8o+QAshZLQAvfLv+2zcxOEUOVHiQXoK8nE4D
        9+UiUtSw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53646 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrq-0007eI-2D; Sun, 10 Nov 2019 14:07:02 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrn-0005B1-HR; Sun, 10 Nov 2019 14:06:59 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 10/17] net: sfp: eliminate mdelay() from PHY probe
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrn-0005B1-HR@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:59 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than using mdelay() to wait before probing the PHY (which holds
several locks, including the rtnl lock), add an extra wait state to
the state machine to introduce the 50ms delay without holding any
locks.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 52 +++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 6fa32246ba41..db015e2cb616 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -54,6 +54,7 @@ enum {
 	SFP_DEV_UP,
 
 	SFP_S_DOWN = 0,
+	SFP_S_WAIT,
 	SFP_S_INIT,
 	SFP_S_WAIT_LOS,
 	SFP_S_LINK_UP,
@@ -110,6 +111,7 @@ static const char *event_to_str(unsigned short event)
 
 static const char * const sm_state_strings[] = {
 	[SFP_S_DOWN] = "down",
+	[SFP_S_WAIT] = "wait",
 	[SFP_S_INIT] = "init",
 	[SFP_S_WAIT_LOS] = "wait_los",
 	[SFP_S_LINK_UP] = "link_up",
@@ -141,6 +143,7 @@ static const enum gpiod_flags gpio_flags[] = {
 	GPIOD_ASIS,
 };
 
+#define T_WAIT		msecs_to_jiffies(50)
 #define T_INIT_JIFFIES	msecs_to_jiffies(300)
 #define T_RESET_US	10
 #define T_FAULT_RECOVER	msecs_to_jiffies(1000)
@@ -161,9 +164,6 @@ static const enum gpiod_flags gpio_flags[] = {
  */
 #define SFP_PHY_ADDR	22
 
-/* Give this long for the PHY to reset. */
-#define T_PHY_RESET_MS	50
-
 struct sff_data {
 	unsigned int gpios;
 	bool (*module_supported)(const struct sfp_eeprom_id *id);
@@ -1204,8 +1204,6 @@ static void sfp_sm_probe_phy(struct sfp *sfp)
 	struct phy_device *phy;
 	int err;
 
-	msleep(T_PHY_RESET_MS);
-
 	phy = mdiobus_scan(sfp->i2c_mii, SFP_PHY_ADDR);
 	if (phy == ERR_PTR(-ENODEV)) {
 		dev_info(sfp->dev, "no PHY detected\n");
@@ -1560,6 +1558,8 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
 static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 {
+	unsigned long timeout;
+
 	/* Some events are global */
 	if (sfp->sm_state != SFP_S_DOWN &&
 	    (sfp->sm_mod_state != SFP_MOD_PRESENT ||
@@ -1577,17 +1577,45 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 	/* The main state machine */
 	switch (sfp->sm_state) {
 	case SFP_S_DOWN:
-		if (sfp->sm_mod_state == SFP_MOD_PRESENT &&
-		    sfp->sm_dev_state == SFP_DEV_UP) {
-			sfp_sm_mod_init(sfp);
-			sfp_sm_probe_for_phy(sfp);
+		if (sfp->sm_mod_state != SFP_MOD_PRESENT ||
+		    sfp->sm_dev_state != SFP_DEV_UP)
+			break;
+
+		sfp_sm_mod_init(sfp);
+
+		/* Initialise the fault clearance retries */
+		sfp->sm_retries = 5;
+
+		/* We need to check the TX_FAULT state, which is not defined
+		 * while TX_DISABLE is asserted. The earliest we want to do
+		 * anything (such as probe for a PHY) is 50ms.
+		 */
+		sfp_sm_next(sfp, SFP_S_WAIT, T_WAIT);
+		break;
 
+	case SFP_S_WAIT:
+		if (event != SFP_E_TIMEOUT)
+			break;
+
+		sfp_sm_probe_for_phy(sfp);
+
+		if (sfp->state & SFP_F_TX_FAULT) {
 			/* Wait t_init before indicating that the link is up,
 			 * provided the current state indicates no TX_FAULT. If
 			 * TX_FAULT clears before this time, that's fine too.
 			 */
-			sfp_sm_next(sfp, SFP_S_INIT, T_INIT_JIFFIES);
-			sfp->sm_retries = 5;
+			timeout = T_INIT_JIFFIES;
+			if (timeout > T_WAIT)
+				timeout -= T_WAIT;
+			else
+				timeout = 1;
+
+			sfp_sm_next(sfp, SFP_S_INIT, timeout);
+		} else {
+			/* TX_FAULT is not asserted, assume the module has
+			 * finished initialising.
+			 */
+			goto init_done;
 		}
 		break;
 
@@ -1595,7 +1623,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		if (event == SFP_E_TIMEOUT && sfp->state & SFP_F_TX_FAULT)
 			sfp_sm_fault(sfp, true);
 		else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR)
-			sfp_sm_link_check_los(sfp);
+	init_done:	sfp_sm_link_check_los(sfp);
 		break;
 
 	case SFP_S_WAIT_LOS:
-- 
2.20.1

