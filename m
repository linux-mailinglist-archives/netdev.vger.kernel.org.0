Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14FAF6942
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfKJOG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:06:26 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45610 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:06:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0VCemcsbFRyKAIpZ7WhKiTJfMXwAJEhQEteumRkzXG4=; b=CmxYirKRBf0dyGr1gCP7uZBZwj
        X5uZSHLpLLM9M9m6eN9ZWjtrn4s0ss1COfdb/UcktYkO4Ddw4Aj3gsoGV+4UlFman4wzA3+W/8N29
        nUfeyIkqCB192rpy6a1kcjizjdOj9XguWmzyZqccFsvnDxK0iMLnBfwZR6rjsIAN9lDzN35lkfsUn
        x3Wq13GCz/qPOOKm6A6TUY+8BQbcX3L5qM5FVbV644eSIos9eX5IIVdZYjxGrITuUY5+EFTkmRKdU
        ZjMnonaEBHEnIQy4cfxqwXarc2U4h90XbMjGcpDxCP/X4M+nWvd6Hf+LTvZn30HGLVitEM0n/evzn
        LP+OqTBA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53622 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnr9-0007dH-A1; Sun, 10 Nov 2019 14:06:19 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnr8-00059T-Fs; Sun, 10 Nov 2019 14:06:18 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 02/17] net: sfp: move tx disable on device down to
 main state machine
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnr8-00059T-Fs@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:18 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the tx disable assertion on device down to the main state
machine.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index f0e325324b23..47f204b227e8 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1491,15 +1491,8 @@ static void sfp_sm_device(struct sfp *sfp, unsigned int event)
 		break;
 
 	case SFP_DEV_UP:
-		if (event == SFP_E_DEV_DOWN) {
-			/* If the module has a PHY, avoid raising TX disable
-			 * as this resets the PHY. Otherwise, raise it to
-			 * turn the laser off.
-			 */
-			if (!sfp->mod_phy)
-				sfp_module_tx_disable(sfp);
+		if (event == SFP_E_DEV_DOWN)
 			sfp->sm_dev_state = SFP_DEV_DOWN;
-		}
 		break;
 	}
 }
@@ -1561,6 +1554,7 @@ static void sfp_sm_main(struct sfp *sfp, unsigned int event)
 			sfp_sm_link_down(sfp);
 		if (sfp->mod_phy)
 			sfp_sm_phy_detach(sfp);
+		sfp_module_tx_disable(sfp);
 		sfp_sm_next(sfp, SFP_S_DOWN, 0);
 		return;
 	}
-- 
2.20.1

