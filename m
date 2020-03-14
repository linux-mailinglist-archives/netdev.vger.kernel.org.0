Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3FE1856AF
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgCOB3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:01 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgCOB3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dCr9mcYJpknL0FgQQYLtOIx0B69mZAu/EfF5LqWKEoA=; b=12eWBYTcFN6CGyrwJuQ1b9wXuK
        eTqulN+WIQptARCikqT9rCsBbYZKo5RTvg2/my6f0rDQPCVeqUubrajW8nNFv0FNrCq7+GkdqtE5Z
        vnMK1TUwrrpSdME1m+ak+49NNkHL3kqmZ4Cp89MMw9hyju5dqdCn4ErPr0wn73Xuge4tyYTbvuxGr
        b7tpJbx5cXw8n/1EJaFlNGPdmlZAKm2N+SNaJxULgudIFjVLqHHWvsvtzW4ak3yHKC5N7Y5L3NXF3
        syIOgYsMN8xZVZuU61xvfvohR9axc26YedTTzN9XQcyCu7R69twDSJZpdqf9BZ9cTmYrqOyUOAa9y
        4DyGrwAw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57536 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD44t-0006MM-4M; Sat, 14 Mar 2020 10:31:35 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD44s-0006Mx-Fv; Sat, 14 Mar 2020 10:31:34 +0000
In-Reply-To: <20200314103102.GJ25745@shell.armlinux.org.uk>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: phylink: pcs: add 802.3 clause 45 helpers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD44s-0006Mx-Fv@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:31:34 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement helpers for PCS accessed via the MII bus using 802.3 clause
45 cycles for 10GBASE-R. Only link up/down is supported, 10G full
duplex is assumed.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 30 ++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7ca427c46d9f..bff570f59d5c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2247,4 +2247,34 @@ void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs)
 }
 EXPORT_SYMBOL_GPL(phylink_mii_c22_pcs_an_restart);
 
+#define C45_ADDR(d,a)	(MII_ADDR_C45 | (d) << 16 | (a))
+void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
+				   struct phylink_link_state *state)
+{
+	struct mii_bus *bus = pcs->bus;
+	int addr = pcs->addr;
+	int stat;
+
+	stat = mdiobus_read(bus, addr, C45_ADDR(MDIO_MMD_PCS, MDIO_STAT1));
+	if (stat < 0) {
+		state->link = false;
+		return;
+	}
+
+	state->link = !!(stat & MDIO_STAT1_LSTATUS);
+	if (!state->link)
+		return;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		state->speed = SPEED_10000;
+		state->duplex = DUPLEX_FULL;
+		break;
+
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_mii_c45_pcs_get_state);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index de591c2fb37e..8fa6df3b881b 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -323,4 +323,6 @@ int phylink_mii_c22_pcs_set_advertisement(struct mdio_device *pcs,
 					const struct phylink_link_state *state);
 void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
+void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
+				   struct phylink_link_state *state);
 #endif
-- 
2.20.1

