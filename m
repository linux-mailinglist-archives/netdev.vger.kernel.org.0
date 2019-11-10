Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C183F6948
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKJOHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:05 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45674 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2DzdZLJNroVgDKs8nh9lEW/hjx8ltfHN0trEkcAQrDM=; b=DcRfke7SCyDcq2zRnatrz41Y9t
        xvZdIYFuplehxlpG+kKVlmuyyI1rFvNw9awxsbX2U4SLH7hbxtX8gQN+xYjk3kCwouN0H0pyQwpS0
        1dN+E+uULGT46hg6+IXztprrn49nwL2HgX1vWCpv5IEN4xLAC2KOJ7MmiNaJ5Oh+JgY5jzAgaXKKD
        7Tce49x7wQOStwoW/xFxBOjBW4WOGTYBR/T0y2U/iYizRbA0b+qmQu8p67PPdPvZmYEh4rOZadIFM
        mczhErcKryRnrlcb5C3/CGGRtANu8gUQE6GturEkZvbC1t8sBNZzXbUVR4Wv3DNvlUQD6TRqlv3VR
        kYuwsOEg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54036 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrf-0007e1-Ck; Sun, 10 Nov 2019 14:06:51 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrd-0005Ad-9B; Sun, 10 Nov 2019 14:06:49 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 08/17] net: sfp: control TX_DISABLE and phy only from
 main state machine
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrd-0005Ad-9B@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:49 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We initialise TX_DISABLE when the sfp cage is probed, and then
maintain its state in the main state machine.  However, the module
state machine:
- negates it when detecting a newly inserted module when it's already
  guaranteed to be negated.
- negates it when the module is removed, but the main state machine
  will do this anyway.

Make TX_DISABLE entirely controlled by the main state machine.

The main state machine also probes the module for a PHY, and removes
the PHY when the the module is removed.  Hence, removing the PHY in
sfp_sm_module_remove() is also redundant, and is a left-over from
when we tried to probe for the PHY from the module state machine.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 7accd24a6875..bd55584e193d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1494,11 +1494,6 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 
 	sfp_hwmon_remove(sfp);
 
-	if (sfp->mod_phy)
-		sfp_sm_phy_detach(sfp);
-
-	sfp_module_tx_disable(sfp);
-
 	memset(&sfp->id, 0, sizeof(sfp->id));
 	sfp->module_power_mW = 0;
 
@@ -1536,10 +1531,8 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 
 	switch (sfp->sm_mod_state) {
 	default:
-		if (event == SFP_E_INSERT && sfp->attached) {
-			sfp_module_tx_disable(sfp);
+		if (event == SFP_E_INSERT && sfp->attached)
 			sfp_sm_mod_next(sfp, SFP_MOD_PROBE, T_SERIAL);
-		}
 		break;
 
 	case SFP_MOD_PROBE:
-- 
2.20.1

