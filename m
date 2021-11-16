Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56312452E91
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhKPKCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbhKPKCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:02:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116AAC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/GMfSosoZrFbR/m+1edvRFu2zh+i9JyaTmk+bplSc7I=; b=FQngpC8nkSxd9LbJj+pfuceSUe
        VBaSSINlPnB+mi2hbgpgZgd6I1ppVTCab8kf0KqSJtzaShU5+LZ0dIECqLgb3Tc+HQu4gTRx7o6w+
        VlklSlgUWgEvIIrwyB5IH3TyVFaoAlUbp0Ri+XabyILaZp77LCfo6pfiFSEN8RQFefB8ukTIb1PK7
        QUg1qHxGfaCUJpyprLhvj6FcbXRAfumK7nDfxY7iz/6GjQpaVvq+yohdE3Nr6avk3aWQhnhmoyCDc
        nUTEEFh6RTCscL4kZ3CtplZZIIgYUaVvwpY3T/naG4o+si7EkeRR7+lbmuJFEiU4bod2dBWiZRI4+
        QSRXDoAw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39824 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvF1-0000JT-Sg; Tue, 16 Nov 2021 09:59:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvF1-0078SB-FD; Tue, 16 Nov 2021 09:59:03 +0000
In-Reply-To: <YZOAxY8PjO38j+j6@shell.armlinux.org.uk>
References: <YZOAxY8PjO38j+j6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: enetc: remove interface checks in
 enetc_pl_mac_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvF1-0078SB-FD@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 09:59:03 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode in the
validation function. Remove this to simplify it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 536454205590..61f05a021779 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -936,16 +936,6 @@ static void enetc_pl_mac_validate(struct phylink_config *config,
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
-	    state->interface != PHY_INTERFACE_MODE_SGMII &&
-	    state->interface != PHY_INTERFACE_MODE_2500BASEX &&
-	    state->interface != PHY_INTERFACE_MODE_USXGMII &&
-	    !phy_interface_mode_is_rgmii(state->interface)) {
-		linkmode_zero(supported);
-		return;
-	}
-
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Pause);
-- 
2.30.2

