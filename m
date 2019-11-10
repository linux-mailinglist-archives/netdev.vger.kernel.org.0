Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1152BF6953
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfKJOHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:53 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45770 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H+kT9jYEduanuWAT/zZOesiMCLBgnL+jklgvsfLEkNI=; b=dbZnkApyOb0DPYHoC+iC6FHvAV
        pZCd7rT389kX3VDARiD84hhM/ntFieBeN5tTof8t7KY0wEX1feQqfMA58u7Jpmeeqzkc9bWM9c+hy
        HaWb/Eposng4ZEFhf95H7P64h/R5LmoAKyHeGt1rAajNZn8fBMVsHSKQoqeyTMMNkkrgrVAVedqxP
        j3l/pCmgUdY37damvEGC2dtKb6Kf+xBV6e7oRhCdlbwxx4qiECn2tTkO8Brt+durmV4+8rVqoLWfy
        MVnjcYzZgZ+Q1X0GTJBZkIZXMZv6WeJp/H7Ro2XQ3gckBAVOb4rF/UPENzjjDmfRwsd6xJuWCXrfe
        S2I07H8A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53664 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnsM-0007fF-53; Sun, 10 Nov 2019 14:07:34 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnsI-0005C3-7G; Sun, 10 Nov 2019 14:07:30 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 16/17] net: sfp: allow sfp to probe slow to
 initialise GPON modules
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnsI-0005C3-7G@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:07:30 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some GPON modules (e.g. Huawei MA5671A) take a significant amount of
time to start responding on the I2C bus, contary to the SFF
specifications.

Work around this by implementing a two-level timeout strategy, where
we initially quickly retry for the module, and then use a slower retry
after we exceed a maximum number of quick attempts.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 5aaeee461d06..68d91fae2077 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -167,9 +167,12 @@ static const enum gpiod_flags gpio_flags[] = {
  * The SFF-8472 specifies t_serial ("Time from power on until module is
  * ready for data transmission over the two wire serial bus.") as 300ms.
  */
-#define T_SERIAL	msecs_to_jiffies(300)
-#define T_HPOWER_LEVEL	msecs_to_jiffies(300)
-#define T_PROBE_RETRY	msecs_to_jiffies(100)
+#define T_SERIAL		msecs_to_jiffies(300)
+#define T_HPOWER_LEVEL		msecs_to_jiffies(300)
+#define T_PROBE_RETRY_INIT	msecs_to_jiffies(100)
+#define R_PROBE_RETRY_INIT	10
+#define T_PROBE_RETRY_SLOW	msecs_to_jiffies(5000)
+#define R_PROBE_RETRY_SLOW	12
 
 /* SFP modules appear to always have their PHY configured for bus address
  * 0x56 (which with mdio-i2c, translates to a PHY address of 22).
@@ -204,6 +207,8 @@ struct sfp {
 	struct delayed_work timeout;
 	struct mutex sm_mutex;			/* Protects state machine */
 	unsigned char sm_mod_state;
+	unsigned char sm_mod_tries_init;
+	unsigned char sm_mod_tries;
 	unsigned char sm_dev_state;
 	unsigned short sm_state;
 	unsigned int sm_retries;
@@ -1394,7 +1399,7 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 	return 0;
 }
 
-static int sfp_sm_mod_probe(struct sfp *sfp)
+static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 {
 	/* SFP module inserted - read I2C data */
 	struct sfp_eeprom_id id;
@@ -1404,7 +1409,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp)
 
 	ret = sfp_read(sfp, false, 0, &id, sizeof(id));
 	if (ret < 0) {
-		dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
+		if (report)
+			dev_err(sfp->dev, "failed to read EEPROM: %d\n", ret);
 		return -EAGAIN;
 	}
 
@@ -1551,8 +1557,11 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
 	switch (sfp->sm_mod_state) {
 	default:
-		if (event == SFP_E_INSERT)
+		if (event == SFP_E_INSERT) {
 			sfp_sm_mod_next(sfp, SFP_MOD_PROBE, T_SERIAL);
+			sfp->sm_mod_tries_init = R_PROBE_RETRY_INIT;
+			sfp->sm_mod_tries = R_PROBE_RETRY_SLOW;
+		}
 		break;
 
 	case SFP_MOD_PROBE:
@@ -1560,10 +1569,19 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 		if (event != SFP_E_TIMEOUT)
 			break;
 
-		err = sfp_sm_mod_probe(sfp);
+		err = sfp_sm_mod_probe(sfp, sfp->sm_mod_tries == 1);
 		if (err == -EAGAIN) {
-			sfp_sm_set_timer(sfp, T_PROBE_RETRY);
-			break;
+			if (sfp->sm_mod_tries_init &&
+			   --sfp->sm_mod_tries_init) {
+				sfp_sm_set_timer(sfp, T_PROBE_RETRY_INIT);
+				break;
+			} else if (sfp->sm_mod_tries && --sfp->sm_mod_tries) {
+				if (sfp->sm_mod_tries == R_PROBE_RETRY_SLOW - 1)
+					dev_warn(sfp->dev,
+						 "please wait, module slow to respond\n");
+				sfp_sm_set_timer(sfp, T_PROBE_RETRY_SLOW);
+				break;
+			}
 		}
 		if (err < 0) {
 			sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
@@ -1598,7 +1616,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 				sfp_module_remove(sfp->sfp_bus);
 				sfp_sm_mod_next(sfp, SFP_MOD_ERROR, 0);
 			} else {
-				sfp_sm_set_timer(sfp, T_PROBE_RETRY);
+				sfp_sm_set_timer(sfp, T_PROBE_RETRY_INIT);
 			}
 			break;
 		}
-- 
2.20.1

