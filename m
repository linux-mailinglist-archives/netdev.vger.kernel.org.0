Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A76A1BF295
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgD3IVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgD3IVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:21:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940A3C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 01:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E+Jlswami5rvP5mZf7SXiuaDzrQGVKqYY+iqD9vuNzQ=; b=1YHofCuf2Jq8Az0/2vMPDkraBs
        YXSevfCOhn7vHZuySCUKwVcjSBP7chIsw6odmzI6spccmJYn78l6GHu1GtCgjDdLq7cdTMN4/E27T
        u/zOaKNkhevdcL+iZULRJnk5Zf68Ml0etT2RMFE00bbGbzDHJtff/uQdYKN1gsV4Jk5MfVeubkB23
        FcZ/fkwFlVAfzjFX8rXzAuE8Zl34avWqb/uNFHb+GwbC5rOmCjok9gLX+EvZVGv5qw5tSlBVTI86P
        RpmZybqOJ32sKewLZ0VqyWTEFgKdXgz4ncFi/no8o/c1F+hxKY2mODnuFiefgegcrsm1tzlD5mY0a
        r9xg/YaQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57048 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jU4Rw-0004iX-BN; Thu, 30 Apr 2020 09:21:40 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jU4Rv-0001Jf-8G; Thu, 30 Apr 2020 09:21:39 +0100
In-Reply-To: <20200430082104.GO1551@shell.armlinux.org.uk>
References: <20200430082104.GO1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: 88e6390 10G serdes support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jU4Rv-0001Jf-8G@rmk-PC.armlinux.org.uk>
Date:   Thu, 30 Apr 2020 09:21:39 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for reading and reporting the 10G link status on the
88e6390 in addition to the 1000BASE-X/2500BASE-X/SGMII status.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 43 ++++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |  1 +
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 33d9923cf7c5..9c07b4f3d345 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -748,8 +748,8 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				      MV88E6390_SGMII_BMCR, bmcr);
 }
 
-int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state)
+static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
+	int port, u8 lane, struct phylink_link_state *state)
 {
 	u16 lpa, status;
 	int err;
@@ -771,6 +771,45 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
 }
 
+static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
+	int port, u8 lane, struct phylink_link_state *state)
+{
+	u16 status;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_10G_STAT1, &status);
+	if (err)
+		return err;
+
+	state->link = !!(status & MDIO_STAT1_LSTATUS);
+	if (state->link) {
+		state->speed = SPEED_10000;
+		state->duplex = DUPLEX_FULL;
+	}
+
+	return 0;
+}
+
+int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				   u8 lane, struct phylink_link_state *state)
+{
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return mv88e6390_serdes_pcs_get_state_sgmii(chip, port, lane,
+							    state);
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
+		return mv88e6390_serdes_pcs_get_state_10g(chip, port, lane,
+							  state);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 				    u8 lane)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 71e3c3d0a24e..14315f26228a 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -41,6 +41,7 @@
 
 /* 10GBASE-R and 10GBASE-X4/X2 */
 #define MV88E6390_10G_CTRL1		(0x1000 + MDIO_CTRL1)
+#define MV88E6390_10G_STAT1		(0x1000 + MDIO_STAT1)
 
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
-- 
2.20.1

