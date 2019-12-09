Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E734116E13
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfLINkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:40:31 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33892 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfLINkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cL2fTM8+s5hOakNyeMroa4xOTbi2DywVIOlbMn5vKWU=; b=jzyIkjLOLqOaGsdvwsx+x3xqzy
        /YWsK2zrd3nfklhhHP16dOd+7227J/pCQHvzzVVEiCadvfsBDUuZnz0njQxBYOO052hKy9IuB6XgM
        p6PR/QYTXUwZNLQHIzNWURhHBtkvRiTPvF7j/oG7Qj1a7ZEDMpKKCKHWEK5SY/khuIgDWMzjnJxbU
        FzLAXtXkDnhJ67HZHwg28aVTIh+1MzzlMWqUx7MMgXc9KfHIq9E3hFZ5eQWWxtoJ48rJx4d6tnT7L
        IyCHKFgHvFCz2Q94kqKYPtoOVrxHDGd5evJe8x5nlxQ+sMNCtt9OfqRt6uvwuq7aUP3UZmYYd75fv
        Rz4x2FlA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37938 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJGx-0003HB-Sl; Mon, 09 Dec 2019 13:40:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJGx-0003kX-4p; Mon, 09 Dec 2019 13:40:23 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        FlorianFainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: sfp: avoid tx-fault with Nokia GPON module
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJGx-0003kX-4p@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 13:40:23 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Nokia GPON module can hold tx-fault active while it is initialising
which can take up to 60s. Avoid this causing the module to be declared
faulty after the SFP MSA defined non-cooled module timeout.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Unfortunately, this adds a second quirk in the SFP code; the SFP code
has no access to the bus-layer quirk system, which is currently a good
thing as doing so would unnecessarily complicate the code.  The bus
layer quirk system is about determining the ethtool properties for
modules - these quirks are about getting the module's basic
functionality up and running.

 drivers/net/phy/sfp.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c0b9a8e4e65a..27360d1840b2 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -155,10 +155,20 @@ static const enum gpiod_flags gpio_flags[] = {
 	GPIOD_ASIS,
 };
 
-#define T_WAIT		msecs_to_jiffies(50)
-#define T_INIT_JIFFIES	msecs_to_jiffies(300)
-#define T_RESET_US	10
-#define T_FAULT_RECOVER	msecs_to_jiffies(1000)
+/* t_start_up (SFF-8431) or t_init (SFF-8472) is the time required for a
+ * non-cooled module to initialise its laser safety circuitry. We wait
+ * an initial T_WAIT period before we check the tx fault to give any PHY
+ * on board (for a copper SFP) time to initialise.
+ */
+#define T_WAIT			msecs_to_jiffies(50)
+#define T_START_UP		msecs_to_jiffies(300)
+#define T_START_UP_BAD_GPON	msecs_to_jiffies(60000)
+
+/* t_reset is the time required to assert the TX_DISABLE signal to reset
+ * an indicated TX_FAULT.
+ */
+#define T_RESET_US		10
+#define T_FAULT_RECOVER		msecs_to_jiffies(1000)
 
 /* SFP module presence detection is poor: the three MOD DEF signals are
  * the same length on the PCB, which means it's possible for MOD DEF 0 to
@@ -218,6 +228,7 @@ struct sfp {
 
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
+	unsigned int module_t_start_up;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1655,6 +1666,12 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (ret < 0)
 		return ret;
 
+	if (!memcmp(id.base.vendor_name, "ALCATELLUCENT   ", 16) &&
+	    !memcmp(id.base.vendor_pn, "3FE46541AA      ", 16))
+		sfp->module_t_start_up = T_START_UP_BAD_GPON;
+	else
+		sfp->module_t_start_up = T_START_UP;
+
 	return 0;
 }
 
@@ -1855,11 +1872,12 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			break;
 
 		if (sfp->state & SFP_F_TX_FAULT) {
-			/* Wait t_init before indicating that the link is up,
-			 * provided the current state indicates no TX_FAULT. If
-			 * TX_FAULT clears before this time, that's fine too.
+			/* Wait up to t_init (SFF-8472) or t_start_up (SFF-8431)
+			 * from the TX_DISABLE deassertion for the module to
+			 * initialise, which is indicated by TX_FAULT
+			 * deasserting.
 			 */
-			timeout = T_INIT_JIFFIES;
+			timeout = sfp->module_t_start_up;
 			if (timeout > T_WAIT)
 				timeout -= T_WAIT;
 			else
@@ -1876,8 +1894,8 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 
 	case SFP_S_INIT:
 		if (event == SFP_E_TIMEOUT && sfp->state & SFP_F_TX_FAULT) {
-			/* TX_FAULT is still asserted after t_init, so assume
-			 * there is a fault.
+			/* TX_FAULT is still asserted after t_init or
+			 * or t_start_up, so assume there is a fault.
 			 */
 			sfp_sm_fault(sfp, SFP_S_INIT_TX_FAULT,
 				     sfp->sm_retries == 5);
@@ -1896,7 +1914,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 	case SFP_S_INIT_TX_FAULT:
 		if (event == SFP_E_TIMEOUT) {
 			sfp_module_tx_fault_reset(sfp);
-			sfp_sm_next(sfp, SFP_S_INIT, T_INIT_JIFFIES);
+			sfp_sm_next(sfp, SFP_S_INIT, sfp->module_t_start_up);
 		}
 		break;
 
@@ -1920,7 +1938,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 	case SFP_S_TX_FAULT:
 		if (event == SFP_E_TIMEOUT) {
 			sfp_module_tx_fault_reset(sfp);
-			sfp_sm_next(sfp, SFP_S_REINIT, T_INIT_JIFFIES);
+			sfp_sm_next(sfp, SFP_S_REINIT, sfp->module_t_start_up);
 		}
 		break;
 
-- 
2.20.1

