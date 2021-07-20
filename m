Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706D03CF747
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhGTJRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbhGTJRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:17:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6421C061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 02:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oRhEblAZJN3vAaNO4BJ1PWrYHSKzhpG/cBLljR1pJWM=; b=OXVE8TYlTiMEQKVviewxSTQfRF
        2x/PsMn2C24lzZoZTxQzU2sHHgmHqWs1dWCJzfi9/6WKoftQpq8bd4J+YBqmjvo+QncA92rOvbhDi
        8mPVE34iYFvmq73NYA7s1iymURHcKvrrEvmK8aY/BsPwt9Yg2e41fiac5GEZwLb6DIt4pZS1ZVaj8
        +wIdx8q+lkv5on9rIeaxN8WlNKVhNIDLxWrwfV/WWdyDs2BChHGv7sK8YCPXOfmoEwpkxrmIjpv5F
        ppD5avtIgwTRQ9V3efsISi/EVU9Oxj1LE/VOcgd2i9TgAaFXP/UvwBHJZXKIU9Y0lrQONLu/dCBWt
        FYV7cmZg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53330 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5mVe-00069U-42; Tue, 20 Jul 2021 10:57:54 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5mVd-00033I-Sx; Tue, 20 Jul 2021 10:57:53 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: mvpp2: deny disabling autoneg for 802.3z modes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m5mVd-00033I-Sx@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 20 Jul 2021 10:57:53 +0100
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
mvpp2 hardware when in 1000BASE-X and 2500BASE-X.

This means the only way to switch between 2500BASE-X and 1000BASE-X
on SFPs that support this will be:

 # ethtool -s ethX advertise 0x20000006000 # 1000BASE-X Pause AsymPause
 # ethtool -s ethX advertise 0xe000        # 2500BASE-X Pause AsymPause

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Marek Behún <kabel@kernel.org>
Acked-by: Marcin Wojtas <mw@semihalf.com>
---
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

