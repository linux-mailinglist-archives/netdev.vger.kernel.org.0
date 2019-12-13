Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27AE11EA1C
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfLMSW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:22:27 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50818 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLMSW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2A0ppn3ktaVIJ4QFe/GpX44mbWPINv7pTFO0C0pGkT0=; b=AU7Xl5tHTgRbrpXI5GE9qafK3e
        Pb18MYlUfj4XpS2a9vlkTQrA0s0z13Qqd2/3dUD8kAvQ4MSpKdtI6tWmAfU658Dru83Hdm0DupZnq
        ArFWJJ3dKyCCI/GnKC3vZVBm0X1nhpOwM6sX2/6/T+1axerp3+CvHZhknDkB+QdUx8e9QRqZwHyLL
        pwbvbb0PQ8LfNM1pXf/jS47vV2fk2TYwllyskNNzcwIP9bmC1R/cWfMEFkWzLmqt3Y25UEHYMB9ra
        oABAFvhjup6xc9uNpeYkCxfnJizZK0mEQTCouGWJBL1OT1rnTZWvsImrmfG2Mc8MSKlGDQYFKnSya
        qt9ORPQA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:59520 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifpZu-0006Su-Hw; Fri, 13 Dec 2019 18:22:14 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifpZs-0005kJ-Ll; Fri, 13 Dec 2019 18:22:12 +0000
In-Reply-To: <20191213175415.GW25745@shell.armlinux.org.uk>
References: <20191213175415.GW25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/3] net: mvpp2: update mvpp2 validate()
 implementation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ifpZs-0005kJ-Ll@rmk-PC.armlinux.org.uk>
Date:   Fri, 13 Dec 2019 18:22:12 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up the mvpp2 validate implementation to adopt the same behaviour as
mvneta:
- only allow the link modes that the specified PHY interface mode
  supports with the exception of 1000base-X and 2500base-X.
- use the basex helper to deal with SFP modules that can be switched
  between 1000base-X vs 2500base-X.

This gives consistent behaviour between mvneta and mvpp2.

This commit depends on "net: phylink: extend clause 45 PHY validation
workaround" so is not marked for backporting to stable kernels.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 111b3b8239e1..f09fcbe6ea88 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4786,6 +4786,8 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 			phylink_set(mask, 10000baseER_Full);
 			phylink_set(mask, 10000baseKR_Full);
 		}
+		if (state->interface != PHY_INTERFACE_MODE_NA)
+			break;
 		/* Fall-through */
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
@@ -4796,13 +4798,23 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 		phylink_set(mask, 10baseT_Full);
 		phylink_set(mask, 100baseT_Half);
 		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+		if (state->interface != PHY_INTERFACE_MODE_NA)
+			break;
 		/* Fall-through */
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
-		phylink_set(mask, 1000baseT_Full);
-		phylink_set(mask, 1000baseX_Full);
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
+		if (port->comphy ||
+		    state->interface != PHY_INTERFACE_MODE_2500BASEX) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+		}
+		if (port->comphy ||
+		    state->interface == PHY_INTERFACE_MODE_2500BASEX) {
+			phylink_set(mask, 2500baseT_Full);
+			phylink_set(mask, 2500baseX_Full);
+		}
 		break;
 	default:
 		goto empty_set;
@@ -4811,6 +4823,8 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	phylink_helper_basex_speed(state);
 	return;
 
 empty_set:
-- 
2.20.1

