Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173E4452E80
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbhKPJ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 04:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhKPJ60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 04:58:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA75C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yvBiqk/Ny3n/opb3PdqU59HvWkQCbz1JXgY7q+2l7O8=; b=0E39uPGqGwuVwKw7TFG6RboMSN
        fgtDP8QmR0nCzeGXILOqqAOAdmbuZxCO+3ZjCRO8qZ7fxu+ETXtlizeOihyYo+sosWRUrx0haun7R
        EKCj/ec1d5THcxEO2aLfobFPBCLfGQn7dPn4OzQiGGjq078Ir15vYdMFDy9HLuGF1+9jBLwEnGgt8
        ENFT7aVa9iVRkDqB3JDcYLhLeQZPRT78QpQ+O9tZ/9cCEsS68eip5FduW3vLFKKolYaY6Ch1inS3a
        r8aRbBRdp47Iz37BD9mmvxiDseem1TU/MP04wDDyff3/Um9E1YEQU5H0WeCxZh3DaOtv/G1iHI69m
        9qxy1fcw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39818 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvBX-0000IC-Ow; Tue, 16 Nov 2021 09:55:27 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mmvBX-0078Nx-B2; Tue, 16 Nov 2021 09:55:27 +0000
In-Reply-To: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
References: <YZN/86huhkUGzZuV@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/3] net: axienet: remove interface checks in
 axienet_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mmvBX-0078Nx-B2@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 16 Nov 2021 09:55:27 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink checks the interface mode against the supported_interfaces
bitmap, we no longer need to validate the interface mode in the
validation function. Remove this to simplify it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 22 -------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8a0a43d71b51..a058019ad9a1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1507,29 +1507,8 @@ static void axienet_validate(struct phylink_config *config,
 			     unsigned long *supported,
 			     struct phylink_link_state *state)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct axienet_local *lp = netdev_priv(ndev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	/* Only support the mode we are configured for */
-	switch (state->interface) {
-	case PHY_INTERFACE_MODE_NA:
-		break;
-	case PHY_INTERFACE_MODE_1000BASEX:
-	case PHY_INTERFACE_MODE_SGMII:
-		if (lp->switch_x_sgmii)
-			break;
-		fallthrough;
-	default:
-		if (state->interface != lp->phy_mode) {
-			netdev_warn(ndev, "Cannot use PHY mode %s, supported: %s\n",
-				    phy_modes(state->interface),
-				    phy_modes(lp->phy_mode));
-			linkmode_zero(supported);
-			return;
-		}
-	}
-
 	phylink_set(mask, Autoneg);
 	phylink_set_port_modes(mask);
 
@@ -1537,7 +1516,6 @@ static void axienet_validate(struct phylink_config *config,
 	phylink_set(mask, Pause);
 
 	switch (state->interface) {
-	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
-- 
2.30.2

