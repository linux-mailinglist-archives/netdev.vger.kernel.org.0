Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F97F6944
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKJOGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:06:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45632 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJOGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Mliy7WNtKiio0DbLrGfDmc78ojQXU2OJ9mi+N+lcxo4=; b=gf5Yknc7LDVok6pY06BBJPgYre
        pmYyrlBS/tfbv7n30kO+NQTUecTqHEJUABXCBMO/xHDywCu9ETrex7s8iXDvlC5XBHHOJ2EbvzCFT
        SEa6TZQeBntqQ6U+ZK5oPdO2WMCK5NxHvW/szIvS32zfrEZWS9ND91XaOV1zPnifJTbpErICMy5OX
        Ear5vT37TH+dfFB7JOtSQbsZ1lP+dvNQwAc45cjR8xAEEc0V2Jb3HSRbuVGrAymwfGz70JzcTifFp
        NzuFlwK0snW3Sl0y2ci99dCFy6GZPOgG3BakxzMN6ZlGiiWu7fYoul7D9Omc5duMzlw3Smmf6/G3N
        HXVyzLdw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53632 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrK-0007dX-Fg; Sun, 10 Nov 2019 14:06:30 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnrI-00059s-QP; Sun, 10 Nov 2019 14:06:28 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 04/17] net: sfp: handle module remove outside state
 machine
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnrI-00059s-QP@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:06:28 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing a module resets the module state machine back to its initial
state.  Rather than explicitly handling this in every state, handle it
early on outside of the state machine.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index f56a19b26924..e34370c4a6c5 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1502,6 +1502,14 @@ static void sfp_sm_device(struct sfp *sfp, unsigned int event)
  */
 static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 {
+	/* Handle remove event globally, it resets this state machine */
+	if (event == SFP_E_REMOVE) {
+		if (sfp->sm_mod_state > SFP_MOD_PROBE)
+			sfp_sm_mod_remove(sfp);
+		sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
+		return;
+	}
+
 	switch (sfp->sm_mod_state) {
 	default:
 		if (event == SFP_E_INSERT && sfp->attached) {
@@ -1511,9 +1519,7 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 		break;
 
 	case SFP_MOD_PROBE:
-		if (event == SFP_E_REMOVE) {
-			sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
-		} else if (event == SFP_E_TIMEOUT) {
+		if (event == SFP_E_TIMEOUT) {
 			int val = sfp_sm_mod_probe(sfp);
 
 			if (val == 0)
@@ -1535,10 +1541,6 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 		/* fallthrough */
 	case SFP_MOD_PRESENT:
 	case SFP_MOD_ERROR:
-		if (event == SFP_E_REMOVE) {
-			sfp_sm_mod_remove(sfp);
-			sfp_sm_mod_next(sfp, SFP_MOD_EMPTY, 0);
-		}
 		break;
 	}
 }
-- 
2.20.1

