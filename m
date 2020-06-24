Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF58A207212
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388933AbgFXLaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388470AbgFXLaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 07:30:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA03C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 04:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NDZumQiqnLKjZ712qSyDrwvHV78Y7KUegrBWIGUb7hE=; b=evv0PB41u0G1i9SUUi5GAy8wRH
        DvbffJuUHvth64T9x6wVBu/SoTIKfpcXfUNz4clkVzhV/in1EbLpSWznRyW4pJRZrtdYGJJdqLkLA
        WybEOxjNYtqKyjWgDs8HJNewBMJV+oewdtAoEe+k32kv3rgwHvVQgn3gfa+Me5zJ0PqqOgqkiWhjk
        BuLfI3SBmYQpcQgbNzk60yurNbnom9zPuP0HsTJFIIS5FeWHdtRTXeDbRut8NHVBfSna8NHt66rG2
        Ajrxo54Ee1rnaF/wd6Ed4bvLOhXnw+MRI4hlgcJBWHVUXVZklPOudYC9hW+Xzf+BZvWrqIjQ4Q2NJ
        AspIDcSg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58170 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jo3bQ-0002wT-V1; Wed, 24 Jun 2020 12:30:04 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jo3bQ-0006QS-Nx; Wed, 24 Jun 2020 12:30:04 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: only restart AN if the link mode is
 using in-band AN
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jo3bQ-0006QS-Nx@rmk-PC.armlinux.org.uk>
Date:   Wed, 24 Jun 2020 12:30:04 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we are not using in-band autonegotiation, there is no point passing
the request to restart autonegotiation on to the driver.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7cda1646bbf7..494af91535ba 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -429,7 +429,8 @@ static void phylink_mac_config_up(struct phylink *pl,
 static void phylink_mac_pcs_an_restart(struct phylink *pl)
 {
 	if (pl->link_config.an_enabled &&
-	    phy_interface_mode_is_8023z(pl->link_config.interface)) {
+	    phy_interface_mode_is_8023z(pl->link_config.interface) &&
+	    phylink_autoneg_inband(pl->cur_link_an_mode)) {
 		if (pl->pcs_ops)
 			pl->pcs_ops->pcs_an_restart(pl->config);
 		else
-- 
2.20.1

