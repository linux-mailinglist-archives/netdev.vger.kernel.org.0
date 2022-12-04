Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8E2641E44
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiLDRlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiLDRlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:41:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555011409B
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 09:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=dH2cbaHGRegnJw/Hn7QKEfDwAdIbI7N2e1kPBoMzAMw=; b=QDX5oQgjC1lcJr/35sxOXa/Ml3
        ahipyGxJR7JFBHca6fbv9FW3wyCjwQ2C+K31m+U3saSx519GakUR9+SzELFoxYGvD6DW1qEUSXxKI
        pqm3Z56a2F5UNom+LAyOZeBRpZT2rQG97fShHLCn3JtLemvZB2m7lirq0b6sm4D2FRTg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1szJ-004KjY-Jj; Sun, 04 Dec 2022 18:41:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next] net: phy: swphy: Support all normal speeds when link down
Date:   Sun,  4 Dec 2022 18:41:03 +0100
Message-Id: <20221204174103.1033005-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The software PHY emulator validation function is happy to accept any
link speed if the link is down. swphy_read_reg() however triggers a
WARN_ON(). Change this to report all the standard 1G link speeds are
supported. Once the speed is known the supported link modes will
change, which is a bit odd, but for emulation is probably O.K.

Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---

Hi Sean

Does this fix your problem?

drivers/net/phy/swphy.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
index 59f1ba4d49bc..63bd98217092 100644
--- a/drivers/net/phy/swphy.c
+++ b/drivers/net/phy/swphy.c
@@ -29,8 +29,10 @@ enum {
 	SWMII_SPEED_10 = 0,
 	SWMII_SPEED_100,
 	SWMII_SPEED_1000,
+	SWMII_SPEED_UNKNOWN,
 	SWMII_DUPLEX_HALF = 0,
 	SWMII_DUPLEX_FULL,
+	SWMII_DUPLEX_UNKNOWN,
 };
 
 /*
@@ -51,6 +53,11 @@ static const struct swmii_regs speed[] = {
 		.lpagb = LPA_1000FULL | LPA_1000HALF,
 		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
 	},
+	[SWMII_SPEED_UNKNOWN] = {
+		.bmsr  = BMSR_ESTATEN | BMSR_100FULL | BMSR_100HALF |
+			 BMSR_10FULL | BMSR_10HALF,
+		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
+	},
 };
 
 static const struct swmii_regs duplex[] = {
@@ -66,6 +73,11 @@ static const struct swmii_regs duplex[] = {
 		.lpagb = LPA_1000FULL,
 		.estat = ESTATUS_1000_TFULL,
 	},
+	[SWMII_DUPLEX_UNKNOWN] = {
+		.bmsr  = BMSR_ESTATEN | BMSR_100FULL | BMSR_100HALF |
+			 BMSR_10FULL | BMSR_10HALF,
+		.estat = ESTATUS_1000_TFULL | ESTATUS_1000_THALF,
+	},
 };
 
 static int swphy_decode_speed(int speed)
@@ -87,8 +99,9 @@ static int swphy_decode_speed(int speed)
  * @state: software phy status
  *
  * This checks that we can represent the state stored in @state can be
- * represented in the emulated MII registers.  Returns 0 if it can,
- * otherwise returns -EINVAL.
+ * represented in the emulated MII registers. Invalid speed is allowed
+ * when the link is down, but the speed must be valid when the link is
+ * up. Returns 0 if it can, otherwise returns -EINVAL.
  */
 int swphy_validate_state(const struct fixed_phy_status *state)
 {
@@ -123,11 +136,14 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 	if (reg > MII_REGS_NUM)
 		return -1;
 
-	speed_index = swphy_decode_speed(state->speed);
-	if (WARN_ON(speed_index < 0))
-		return 0;
-
-	duplex_index = state->duplex ? SWMII_DUPLEX_FULL : SWMII_DUPLEX_HALF;
+	if (state->link) {
+		speed_index = swphy_decode_speed(state->speed);
+		duplex_index = state->duplex ? SWMII_DUPLEX_FULL :
+			SWMII_DUPLEX_HALF;
+	} else {
+		speed_index = SWMII_SPEED_UNKNOWN;
+		duplex_index = SWMII_DUPLEX_UNKNOWN;
+	}
 
 	bmsr |= speed[speed_index].bmsr & duplex[duplex_index].bmsr;
 	estat |= speed[speed_index].estat & duplex[duplex_index].estat;
-- 
2.38.1

