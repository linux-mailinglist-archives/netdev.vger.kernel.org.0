Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEDDF6949
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfKJOHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:14 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45686 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g+1QKpsty/T87TA1EdqIrrVlrIJChegTB68BfW5J7mM=; b=MoI4+sb/SCJpR/TgOniJU4GCK2
        veFMybxfnMcK6TeLr47d+Tp0FyY4bUz0JNSL2bT5Crv4aYekHb0C5igtItg8Vnr0YzamuymRQNJ4c
        UnIo0jxyhI6FcwAVr/Egxkj2tEmQHD+RSGxWX4dUGhIDgTDzQC39GLPntrCzg60ZoMN0EJtVeNii9
        TQapSDgjeXea6Yb1kQjTbYKAT6GwDQFPnF8MNhOKrDVDxBBEL7WFhVFkgm7EzI3/xDO1GUxefLGLq
        cd+JWH9rT/7coAgntxirkB5bRLaR48bP13ivqZDbqE4rUcKjzoKEC+uDjfxudSb0f7f29mZitgWie
        NIpZRNCg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54040 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrk-0007eA-Fy; Sun, 10 Nov 2019 14:06:56 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnri-0005Aq-CV; Sun, 10 Nov 2019 14:06:54 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 09/17] net: sfp: split the PHY probe from
 sfp_sm_mod_init()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnri-0005Aq-CV@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:54 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the PHY probe into a separate function, splitting it from
sfp_sm_mod_init().  This will allow us to eliminate the 50ms mdelay()
inside the state machine.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index bd55584e193d..6fa32246ba41 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1290,14 +1290,10 @@ static void sfp_sm_fault(struct sfp *sfp, bool warn)
 static void sfp_sm_mod_init(struct sfp *sfp)
 {
 	sfp_module_tx_enable(sfp);
+}
 
-	/* Wait t_init before indicating that the link is up, provided the
-	 * current state indicates no TX_FAULT.  If TX_FAULT clears before
-	 * this time, that's fine too.
-	 */
-	sfp_sm_next(sfp, SFP_S_INIT, T_INIT_JIFFIES);
-	sfp->sm_retries = 5;
-
+static void sfp_sm_probe_for_phy(struct sfp *sfp)
+{
 	/* Setting the serdes link mode is guesswork: there's no
 	 * field in the EEPROM which indicates what mode should
 	 * be used.
@@ -1582,8 +1578,17 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 	switch (sfp->sm_state) {
 	case SFP_S_DOWN:
 		if (sfp->sm_mod_state == SFP_MOD_PRESENT &&
-		    sfp->sm_dev_state == SFP_DEV_UP)
+		    sfp->sm_dev_state == SFP_DEV_UP) {
 			sfp_sm_mod_init(sfp);
+			sfp_sm_probe_for_phy(sfp);
+
+			/* Wait t_init before indicating that the link is up,
+			 * provided the current state indicates no TX_FAULT. If
+			 * TX_FAULT clears before this time, that's fine too.
+			 */
+			sfp_sm_next(sfp, SFP_S_INIT, T_INIT_JIFFIES);
+			sfp->sm_retries = 5;
+		}
 		break;
 
 	case SFP_S_INIT:
-- 
2.20.1

