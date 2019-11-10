Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C657FF693F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfKJOGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:06:20 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45598 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:06:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EwFFcJhfKxgGqtYhlP9FaZ+r4zh1NaCUSKvSvkP2Qmk=; b=lvoNM7G+8J1OWzPsy9PuMlQMNE
        wRQH7WalHMRDn7aMBo3yTGZT6WY1xiUuzmDiN5aIpvf9GshP+MDdJCJ4MrJzb/BGPTBFk021WC39o
        KnIHUEClbcHQprHXIjGLAfNawjW7ni9AEKD8kNCkTofG+ip1dcEkxLlBlYZNWOPWzy6ukXgjLFH1d
        NnLEgDyhyj8oyPzIxaKpeRCC8ttjDckSqBKUXAcQ3oCNDIwhpXGZCJ2YPiUpL6AE6XoWstpc9TEyv
        BuqL6GCTrtk+q80a55RCdLIBkF/TiJ8zqK9lSgYGrh0vCWBTVXEyPDtutRdFz1ImgLnd30mY0NFqn
        K7vYEM+Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:47374 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnr3-0007d8-U2; Sun, 10 Nov 2019 14:06:14 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnr3-00059H-CF; Sun, 10 Nov 2019 14:06:13 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 01/17] net: sfp: move sfp sub-state machines into
 separate functions
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnr3-00059H-CF@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:13 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the SFP sub-state machines out of the main state machine function,
in preparation for it doing a bit more with the device state.  By doing
so, we ensure that our debug after the main state machine is always
printed.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 74 +++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 31 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e36c04c26866..f0e325324b23 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1481,19 +1481,34 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 	dev_info(sfp->dev, "module removed\n");
 }
 
-static void sfp_sm_event(struct sfp *sfp, unsigned int event)
+/* This state machine tracks the netdev up/down state */
+static void sfp_sm_device(struct sfp *sfp, unsigned int event)
 {
-	mutex_lock(&sfp->sm_mutex);
+	switch (sfp->sm_dev_state) {
+	default:
+		if (event == SFP_E_DEV_UP)
+			sfp->sm_dev_state = SFP_DEV_UP;
+		break;
 
-	dev_dbg(sfp->dev, "SM: enter %s:%s:%s event %s\n",
-		mod_state_to_str(sfp->sm_mod_state),
-		dev_state_to_str(sfp->sm_dev_state),
-		sm_state_to_str(sfp->sm_state),
-		event_to_str(event));
+	case SFP_DEV_UP:
+		if (event == SFP_E_DEV_DOWN) {
+			/* If the module has a PHY, avoid raising TX disable
+			 * as this resets the PHY. Otherwise, raise it to
+			 * turn the laser off.
+			 */
+			if (!sfp->mod_phy)
+				sfp_module_tx_disable(sfp);
+			sfp->sm_dev_state = SFP_DEV_DOWN;
+		}
+		break;
+	}
+}
 
-	/* This state machine tracks the insert/remove state of
-	 * the module, and handles probing the on-board EEPROM.
-	 */
+/* This state machine tracks the insert/remove state of
+ * the module, and handles probing the on-board EEPROM.
+ */
+static void sfp_sm_module(struct sfp *sfp, unsigned int event)
+{
 	switch (sfp->sm_mod_state) {
 	default:
 		if (event == SFP_E_INSERT && sfp->attached) {
@@ -1533,27 +1548,10 @@ static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 		}
 		break;
 	}
+}
 
-	/* This state machine tracks the netdev up/down state */
-	switch (sfp->sm_dev_state) {
-	default:
-		if (event == SFP_E_DEV_UP)
-			sfp->sm_dev_state = SFP_DEV_UP;
-		break;
-
-	case SFP_DEV_UP:
-		if (event == SFP_E_DEV_DOWN) {
-			/* If the module has a PHY, avoid raising TX disable
-			 * as this resets the PHY. Otherwise, raise it to
-			 * turn the laser off.
-			 */
-			if (!sfp->mod_phy)
-				sfp_module_tx_disable(sfp);
-			sfp->sm_dev_state = SFP_DEV_DOWN;
-		}
-		break;
-	}
-
+static void sfp_sm_main(struct sfp *sfp, unsigned int event)
+{
 	/* Some events are global */
 	if (sfp->sm_state != SFP_S_DOWN &&
 	    (sfp->sm_mod_state != SFP_MOD_PRESENT ||
@@ -1564,7 +1562,6 @@ static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 		if (sfp->mod_phy)
 			sfp_sm_phy_detach(sfp);
 		sfp_sm_next(sfp, SFP_S_DOWN, 0);
-		mutex_unlock(&sfp->sm_mutex);
 		return;
 	}
 
@@ -1619,6 +1616,21 @@ static void sfp_sm_event(struct sfp *sfp, unsigned int event)
 	case SFP_S_TX_DISABLE:
 		break;
 	}
+}
+
+static void sfp_sm_event(struct sfp *sfp, unsigned int event)
+{
+	mutex_lock(&sfp->sm_mutex);
+
+	dev_dbg(sfp->dev, "SM: enter %s:%s:%s event %s\n",
+		mod_state_to_str(sfp->sm_mod_state),
+		dev_state_to_str(sfp->sm_dev_state),
+		sm_state_to_str(sfp->sm_state),
+		event_to_str(event));
+
+	sfp_sm_module(sfp, event);
+	sfp_sm_device(sfp, event);
+	sfp_sm_main(sfp, event);
 
 	dev_dbg(sfp->dev, "SM: exit %s:%s:%s\n",
 		mod_state_to_str(sfp->sm_mod_state),
-- 
2.20.1

