Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF29F694F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfKJOHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:34 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45726 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YxhOWVuXK2cHl1ZVRXoZ0zGJB4GtZe7GSUTkaaZanpw=; b=SolSMfj7P6R9p1MYTrh2yvas88
        enqN9ADtCbibusgjYMSrffIjJcrGKDHMquHF5Z+HmeplN6Bf9aQWJbK/ns1Jz7mondWFg5OQLIsZs
        3H0Fho4EeUcB3cLeDpiotCxT+nZ+eAvjWJNLXU/PmK6ZPoiVc442Mr3N+JAlt4vuPURJ0j6tVPAwC
        G1Mde1HMxfOPoTNNxPBHvJg8EWODlLRoxtk07kQlRgpwkshi6kt9ZSULTTw4kdNJ5fVvJMpJwC4R/
        VgrxefBaCf7arumUEZ6bAk6QuYfSiGR8oLniz7iB/zbAKsWgjNtyGaq+aI8YJaBYr2yKMZXezJzN3
        mLB6xJeg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53652 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTns0-0007ed-Ni; Sun, 10 Nov 2019 14:07:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrx-0005BM-PM; Sun, 10 Nov 2019 14:07:09 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 12/17] net: sfp: ensure TX_FAULT has deasserted
 before probing the PHY
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrx-0005BM-PM@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:07:09 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX_FAULT should be deasserted to indicate that the module has completed
its initialisation.  This may include the on-board PHY, so wait until
the module has deasserted TX_FAULT before probing the PHY.

This means that we need an extra state to handle a TX_FAULT that
remains set for longer than t_init, since using the existing handling
state would bypass the PHY probe.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index bdc633cc7c30..91fd218ba6b6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -56,6 +56,7 @@ enum {
 	SFP_S_DOWN = 0,
 	SFP_S_WAIT,
 	SFP_S_INIT,
+	SFP_S_INIT_TX_FAULT,
 	SFP_S_WAIT_LOS,
 	SFP_S_LINK_UP,
 	SFP_S_TX_FAULT,
@@ -113,6 +114,7 @@ static const char * const sm_state_strings[] = {
 	[SFP_S_DOWN] = "down",
 	[SFP_S_WAIT] = "wait",
 	[SFP_S_INIT] = "init",
+	[SFP_S_INIT_TX_FAULT] = "init_tx_fault",
 	[SFP_S_WAIT_LOS] = "wait_los",
 	[SFP_S_LINK_UP] = "link_up",
 	[SFP_S_TX_FAULT] = "tx_fault",
@@ -1597,8 +1599,6 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		if (event != SFP_E_TIMEOUT)
 			break;
 
-		sfp_sm_probe_for_phy(sfp);
-
 		if (sfp->state & SFP_F_TX_FAULT) {
 			/* Wait t_init before indicating that the link is up,
 			 * provided the current state indicates no TX_FAULT. If
@@ -1620,10 +1620,29 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 		break;
 
 	case SFP_S_INIT:
-		if (event == SFP_E_TIMEOUT && sfp->state & SFP_F_TX_FAULT)
-			sfp_sm_fault(sfp, SFP_S_TX_FAULT, true);
-		else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR)
-	init_done:	sfp_sm_link_check_los(sfp);
+		if (event == SFP_E_TIMEOUT && sfp->state & SFP_F_TX_FAULT) {
+			/* TX_FAULT is still asserted after t_init, so assume
+			 * there is a fault.
+			 */
+			sfp_sm_fault(sfp, SFP_S_INIT_TX_FAULT,
+				     sfp->sm_retries == 5);
+		} else if (event == SFP_E_TIMEOUT || event == SFP_E_TX_CLEAR) {
+	init_done:	/* TX_FAULT deasserted or we timed out with TX_FAULT
+			 * clear.  Probe for the PHY and check the LOS state.
+			 */
+			sfp_sm_probe_for_phy(sfp);
+			sfp_sm_link_check_los(sfp);
+
+			/* Reset the fault retry count */
+			sfp->sm_retries = 5;
+		}
+		break;
+
+	case SFP_S_INIT_TX_FAULT:
+		if (event == SFP_E_TIMEOUT) {
+			sfp_module_tx_fault_reset(sfp);
+			sfp_sm_next(sfp, SFP_S_INIT, T_INIT_JIFFIES);
+		}
 		break;
 
 	case SFP_S_WAIT_LOS:
-- 
2.20.1

