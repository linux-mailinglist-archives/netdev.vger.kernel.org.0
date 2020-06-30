Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A37920F215
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732157AbgF3KEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732078AbgF3KEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:04:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BE0C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dGTQvy1C0T81dzKFc27C0pL0iWAgQqD1GXKXbF0WepI=; b=aqRp/R6t9Zpo4Chnjg3lD/BG+Z
        sixMAiIaGB2iWj4Jq5i5ixpp9uRhQJk1FWViH5j5YMiAKz09EYsxUpvpSrY2d+1X9c/qGH/q88Ls5
        R/REFDDkhE4iezgZNK6H0HH7no0sS3pX5QYNmMXKcbZt0e/Af8uKra6wdU8PLLqCHw4afAes1FYtA
        1UDAdYj04yXkLl8rgO92JJMKxXUMfHEgBmiz6lxLSMTD04o7c+dBULFfx6mPYye5EC4gHMjk/GUS0
        5mQi4A4U9huBNnG5kGtgTYDRuO2vDcT5BcLtbReP+8x3SCV0UzZwm4wSJgMdk0hRCu5k55tHBB/5Q
        QjWTKnzw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45850 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqD84-0000Mu-G5; Tue, 30 Jun 2020 11:04:40 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqD84-0004hC-54; Tue, 30 Jun 2020 11:04:40 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net] net: mvneta: fix use of state->speed
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqD84-0004hC-54@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 11:04:40 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When support for short preambles was added, it incorrectly keyed its
decision off state->speed instead of state->interface.  state->speed
is not guaranteed to be correct for in-band modes, which can lead to
short preambles being unexpectedly disabled.

Fix this by keying off the interface mode, which is the only way that
mvneta can operate at 2.5Gbps.

Fixes: da58a931f248 ("net: mvneta: Add support for 2500Mbps SGMII")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c639e3a29302..7d5d9d34f4e4 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3959,7 +3959,7 @@ static void mvneta_mac_config(struct phylink_config *config, unsigned int mode,
 	/* When at 2.5G, the link partner can send frames with shortened
 	 * preambles.
 	 */
-	if (state->speed == SPEED_2500)
+	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
 		new_ctrl4 |= MVNETA_GMAC4_SHORT_PREAMBLE_ENABLE;
 
 	if (pp->phy_interface != state->interface) {
-- 
2.20.1

