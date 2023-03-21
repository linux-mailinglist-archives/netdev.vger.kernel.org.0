Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6A76C3664
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjCUP7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjCUP66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:58:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866CA521C4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qHwoipjztaXM51vKYoUbUcFgYImz3aYNMMiw+Utf4NA=; b=1f1RpSePGbhPTFZMxnDMqDHuAR
        VwhpC04DbR2HPTr5J0B7AFJ7MiOjCbqrrS2Xc8Q5KHQV5PonYjuMuIxljytqKjWZIQc69FcxCwbRL
        tc34HBjEMJT+TzD2WSvn6uq7ci2o3SGZvZ9TAHsk29k6eiWS2P6SenbuDXO7Hghj5iJ7jge/IfaTc
        OT7L1MoI9T2dCzwBI4io6tHOM7qapM2kSIFFDN9wmOvRMN2AQ4FZBb5etk48wnf2G6v71yHC9MSWq
        Lduo2JFhvLvZwo7/hGo3MXT6mDZMFfGUkBvpaXvpJ/9+uLQc7Ew973wvJs9XHuIRDCXPNle+GGB44
        Kfr4d/Yg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58118 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1peeNt-0001U9-Ul; Tue, 21 Mar 2023 15:58:49 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1peeNt-00DmhP-8i; Tue, 21 Mar 2023 15:58:49 +0000
In-Reply-To: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
References: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/3] net: pcs: xpcs: use Autoneg bit rather than
 an_enabled
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1peeNt-00DmhP-8i@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Mar 2023 15:58:49 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Autoneg bit in the advertising bitmap and state->an_enabled are
always identical. Thus, we will be removing state->an_enabled.

Use the Autoneg bit in the advertising bitmap to indicate whether
autonegotiation should be used, rather than using the an_enabled
member which will be going away.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 04a685353041..539cd43eae8d 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -923,6 +923,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 			      struct phylink_link_state *state,
 			      const struct xpcs_compat *compat)
 {
+	bool an_enabled;
 	int ret;
 
 	/* Link needs to be read first ... */
@@ -940,11 +941,13 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND, NULL);
 	}
 
-	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
+	an_enabled = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				       state->advertising);
+	if (an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
 		state->an_complete = true;
 		xpcs_read_lpa_c73(xpcs, state);
 		xpcs_resolve_lpa_c73(xpcs, state);
-	} else if (state->an_enabled) {
+	} else if (an_enabled) {
 		state->link = 0;
 	} else if (state->link) {
 		xpcs_resolve_pma(xpcs, state);
@@ -999,7 +1002,8 @@ static int xpcs_get_state_c37_1000basex(struct dw_xpcs *xpcs,
 {
 	int lpa, bmsr;
 
-	if (state->an_enabled) {
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			      state->advertising)) {
 		/* Reset link state */
 		state->link = false;
 
-- 
2.30.2

