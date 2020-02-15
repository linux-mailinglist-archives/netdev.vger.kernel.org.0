Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFEA115FF14
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgBOPtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:49:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34102 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:49:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LQpH6bCHLrq5IN832fmlawJZKP7CnEDBIeNgBHzZ7JE=; b=UlEmSKWV8hANLm2IpkxY03mu7s
        qW7vjctdN3GmftRENEzmaGTNwybSGa5PVU5xTxLOWkILQxlmyswqxEnweGyfSWMe8uhyezPvDN+XR
        jW6S0FQTnsu8Lt1T6ffMJPaOmPVezRHc9UZsku2XCVdtRxq82T2aLKDixj86kOHnQpljkQvFGIUjr
        dvUzGfMHw/aus6lNjIKYhfkEAQjluIrj0tp24cBeMHiPwMCgAlnwdbJIWVDQUgbCvpIKKDr9rwHmQ
        Gm2aV76jj0OINEBLXwi6SNAANdeofI/VqV11SwWgNSnUkdfW6oua+YAbHah19su2BHYrjKUKfo3xl
        bBlE4+9w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:57250 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhQ-0005jh-Qd; Sat, 15 Feb 2020 15:49:44 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhP-0003Xf-2o; Sat, 15 Feb 2020 15:49:43 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 05/10] net: phylink: ensure manual flow control is
 selected appropriately
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhP-0003Xf-2o@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:49:43 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the application of manually controlled flow control modes from
phylink_resolve_flow(), so that we can use alternative providers of
flow control resolution.

We also want to clear the MLO_PAUSE_AN flag when autoneg is disabled,
since flow control can't be negotiated in this circumstance.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 42 +++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index de7b7499ae38..846aee591684 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -339,6 +339,18 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 	return 0;
 }
 
+static void phylink_apply_manual_flow(struct phylink *pl,
+				      struct phylink_link_state *state)
+{
+	/* If autoneg is disabled, pause AN is also disabled */
+	if (!state->an_enabled)
+		state->pause &= ~MLO_PAUSE_AN;
+
+	/* Manual configuration of pause modes */
+	if (!(pl->link_config.pause & MLO_PAUSE_AN))
+		state->pause = pl->link_config.pause;
+}
+
 static void phylink_mac_config(struct phylink *pl,
 			       const struct phylink_link_state *state)
 {
@@ -408,25 +420,20 @@ static void phylink_resolve_flow(struct phylink *pl,
 				 struct phylink_link_state *state)
 {
 	int new_pause = 0;
+	int pause = 0;
 
-	if (pl->link_config.pause & MLO_PAUSE_AN) {
-		int pause = 0;
-
-		if (phylink_test(pl->link_config.advertising, Pause))
-			pause |= MLO_PAUSE_SYM;
-		if (phylink_test(pl->link_config.advertising, Asym_Pause))
-			pause |= MLO_PAUSE_ASYM;
+	if (phylink_test(pl->link_config.advertising, Pause))
+		pause |= MLO_PAUSE_SYM;
+	if (phylink_test(pl->link_config.advertising, Asym_Pause))
+		pause |= MLO_PAUSE_ASYM;
 
-		pause &= state->pause;
+	pause &= state->pause;
 
-		if (pause & MLO_PAUSE_SYM)
-			new_pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
-		else if (pause & MLO_PAUSE_ASYM)
-			new_pause = state->pause & MLO_PAUSE_SYM ?
-				 MLO_PAUSE_TX : MLO_PAUSE_RX;
-	} else {
-		new_pause = pl->link_config.pause & MLO_PAUSE_TXRX_MASK;
-	}
+	if (pause & MLO_PAUSE_SYM)
+		new_pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
+	else if (pause & MLO_PAUSE_ASYM)
+		new_pause = state->pause & MLO_PAUSE_SYM ?
+			 MLO_PAUSE_TX : MLO_PAUSE_RX;
 
 	state->pause &= ~MLO_PAUSE_TXRX_MASK;
 	state->pause |= new_pause;
@@ -494,6 +501,7 @@ static void phylink_resolve(struct work_struct *w)
 		case MLO_AN_PHY:
 			link_state = pl->phy_state;
 			phylink_resolve_flow(pl, &link_state);
+			phylink_apply_manual_flow(pl, &link_state);
 			phylink_mac_config_up(pl, &link_state);
 			break;
 
@@ -518,6 +526,7 @@ static void phylink_resolve(struct work_struct *w)
 				 * the pause mode bits. */
 				link_state.pause |= pl->phy_state.pause;
 				phylink_resolve_flow(pl, &link_state);
+				phylink_apply_manual_flow(pl, &link_state);
 				phylink_mac_config(pl, &link_state);
 			}
 			break;
@@ -1006,7 +1015,6 @@ void phylink_start(struct phylink *pl)
 	 * a fixed-link to start with the correct parameters, and also
 	 * ensures that we set the appropriate advertisement for Serdes links.
 	 */
-	phylink_resolve_flow(pl, &pl->link_config);
 	phylink_mac_config(pl, &pl->link_config);
 
 	/* Restart autonegotiation if using 802.3z to ensure that the link
-- 
2.20.1

