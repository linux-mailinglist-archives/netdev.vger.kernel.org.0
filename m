Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA3A2C3A6
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfE1J5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:57:25 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35884 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfE1J5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:57:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BZhpw7q7U0Bq7eyTv/V4MNMJjqNU3zmweUN/671O6nA=; b=kS93fHh8Rcr18tePpIQ1e+gyvX
        7HHhSk9qJANp09FcQp4x9GRHNjYDGiBvQihqMwphQV7+zl2IQv7otqZj0y77VJRjHWoVjEWjCi2N6
        a86cfzS1j/EloIMoHJv9JihJCR0mMELBI0eCG6rKBGl5MvGax6K71fdRkN5cojhhsNCsi85+FZotM
        2y9UnNdGKDekMUAa9Tiv3G0geuKIgrFKphzBhw72V0jxtXrSHB5tycFfttHN4vdbECSCh/b4YwIw3
        k/gtOb8XM6AjjkSLe3kEIg8YMoO48UG06j3a9WZKn3eHnpCnlvSDZRS6rdeUWer4MYpPeE3PDCU5e
        BV4/5dzQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58712 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYr9-0004yP-3q; Tue, 28 May 2019 10:57:19 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hVYr8-0005Yu-GI; Tue, 28 May 2019 10:57:18 +0100
In-Reply-To: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/5] net: phylink: remove netdev from phylink mii
 ioctl emulation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hVYr8-0005Yu-GI@rmk-PC.armlinux.org.uk>
Date:   Tue, 28 May 2019 10:57:18 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netdev used in the phylink ioctl emulation is never used, so let's
remove it.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9044b95d2afe..219a061572d2 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1340,8 +1340,8 @@ EXPORT_SYMBOL_GPL(phylink_ethtool_set_eee);
  *
  * FIXME: should deal with negotiation state too.
  */
-static int phylink_mii_emul_read(struct net_device *ndev, unsigned int reg,
-				 struct phylink_link_state *state, bool aneg)
+static int phylink_mii_emul_read(unsigned int reg,
+				 struct phylink_link_state *state)
 {
 	struct fixed_phy_status fs;
 	int val;
@@ -1356,8 +1356,6 @@ static int phylink_mii_emul_read(struct net_device *ndev, unsigned int reg,
 	if (reg == MII_BMSR) {
 		if (!state->an_complete)
 			val &= ~BMSR_ANEGCOMPLETE;
-		if (!aneg)
-			val &= ~BMSR_ANEGCAPABLE;
 	}
 	return val;
 }
@@ -1453,8 +1451,7 @@ static int phylink_mii_read(struct phylink *pl, unsigned int phy_id,
 	case MLO_AN_FIXED:
 		if (phy_id == 0) {
 			phylink_get_fixed_state(pl, &state);
-			val = phylink_mii_emul_read(pl->netdev, reg, &state,
-						    true);
+			val = phylink_mii_emul_read(reg, &state);
 		}
 		break;
 
@@ -1467,8 +1464,7 @@ static int phylink_mii_read(struct phylink *pl, unsigned int phy_id,
 			if (val < 0)
 				return val;
 
-			val = phylink_mii_emul_read(pl->netdev, reg, &state,
-						    true);
+			val = phylink_mii_emul_read(reg, &state);
 		}
 		break;
 	}
-- 
2.7.4

