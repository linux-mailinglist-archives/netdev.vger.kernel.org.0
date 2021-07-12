Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD183C5FB2
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhGLPuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbhGLPuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 11:50:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FBDC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V0XUyC5zQPPoAIYQRA+YHIPiRWTwPZYjx9p4YYxOtiY=; b=MX4V5226p/mumLgjugH9DiqFGT
        LbJfIx5GnQzrReE0B/YUzsEJa+yFEvZBEXkR7Mssjve9k0/oi5ZwOnwuTaXJP8Y3KTrEHKFMYc/Yd
        qoBKY4rB9w1oxiZU4GWzbe/te++M6OdYx0dwKhXFJUE3jwpGCjqK7myvlLxEMz5cCrxUYi109eU/o
        zy0qHrjIvQcW7wgSjSvLwrUSOBbO1M+MlYhCfgoRxPZ1O/t/uhTafG0/6mi/ccpP8gp3gXK1zAthO
        BsnhudFDSS7L+ysAI7CAmW3+Fp9Bji8M4NkOc5jIoLGPKHpb3+O9OQqyFBZdb1+dYxReD3rdpM+VL
        h9tvabnw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40100 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m2y9R-0004zS-F0; Mon, 12 Jul 2021 16:47:21 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m2y9R-0005wP-7n; Mon, 12 Jul 2021 16:47:21 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH net-next] net: mvpp2: deny disabling autoneg for 802.3z modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m2y9R-0005wP-7n@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 12 Jul 2021 16:47:21 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation for Armada 8040 says:

  Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
  When <PortType> = 1 (1000BASE-X) this field must be set to 1.

We presently ignore whether userspace requests autonegotiation or not
through the ethtool ksettings interface. However, we have some network
interfaces that wish to do this. To offer a consistent API across
network interfaces, deny the ability to disable autonegotiation on
mvneta hardware when in 1000BASE-X and 2500BASE-X.

This means the only way to switch between 2500BASE-X and 1000BASE-X
on SFPs that support this will be:

 # ethtool -s ethX advertise 0x20000006000 # 1000BASE-X Pause AsymPause
 # ethtool -s ethX advertise 0xe000        # 2500BASE-X Pause AsymPause

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
net-next is currently closed, but I'd like to collect acks for this
patch. Thanks.

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3229bafa2a2c..878fb17dea41 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6269,6 +6269,15 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 		if (!mvpp2_port_supports_rgmii(port))
 			goto empty_set;
 		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		/* When in 802.3z mode, we must have AN enabled:
+		 * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
+		 * When <PortType> = 1 (1000BASE-X) this field must be set to 1.
+		 */
+		if (!phylink_test(state->advertising, Autoneg))
+			goto empty_set;
+		break;
 	default:
 		break;
 	}
-- 
2.20.1

