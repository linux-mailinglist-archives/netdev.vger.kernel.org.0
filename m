Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5305D43C604
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbhJ0JGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhJ0JGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:06:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA0BC061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jk8dNVv5WQ4mUZVM6fRjbGGYew/ymvkSSRuyeBO5izw=; b=R7+0ld36cbLBc3cIhwXo/Wn8Oz
        grDJE+m94XFN+avKTxE+d7YV3EKf+iooEJOhOpC/koPkxgP7jQY+0sM24nKWXUL0Jk4o8JquTdhX+
        zww9yZvzQGHuqmFhk9kpDVKGShCKWIzp81pN2Iw7wfvom+DjaS4azxlhESK6zXEblGMK4PcnHNZ1U
        hmw7PA9LcOJ+a+q8H/xGVuhnWLyAow+gsAAxG2OTLIMbQwoTeKWCtD4mgTPj5hOaMtfd4eE4Yj/q9
        OZwKd3JZzQUx88zHSC1+5u5DJFu1tFVf532emankOh5QyoGKfNdXBkHEdDKJQUq9g4Owphswce++/
        Fh8LNMdw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34114 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfeqa-0006D2-PB; Wed, 27 Oct 2021 10:03:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfeqa-001Trx-9W; Wed, 27 Oct 2021 10:03:48 +0100
In-Reply-To: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
References: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: mvneta: remove interface checks in
 mvneta_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mfeqa-001Trx-9W@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 27 Oct 2021 10:03:48 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode in the
validation function. Remove this to simplify it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7df923648bc4..446cdd496f1b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3832,15 +3832,8 @@ static void mvneta_validate(struct phylink_config *config,
 	 * "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
 	 * When <PortType> = 1 (1000BASE-X) this field must be set to 1."
 	 */
-	if (phy_interface_mode_is_8023z(state->interface)) {
-		if (!phylink_test(state->advertising, Autoneg)) {
-			linkmode_zero(supported);
-			return;
-		}
-	} else if (state->interface != PHY_INTERFACE_MODE_NA &&
-		   state->interface != PHY_INTERFACE_MODE_QSGMII &&
-		   state->interface != PHY_INTERFACE_MODE_SGMII &&
-		   !phy_interface_mode_is_rgmii(state->interface)) {
+	if (phy_interface_mode_is_8023z(state->interface) &&
+	    !phylink_test(state->advertising, Autoneg)) {
 		linkmode_zero(supported);
 		return;
 	}
-- 
2.30.2

