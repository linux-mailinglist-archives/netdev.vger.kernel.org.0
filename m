Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E5C44BACB
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 05:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhKJENF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 23:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhKJENE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 23:13:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A6DE61205;
        Wed, 10 Nov 2021 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636517417;
        bh=JbPK3ZzTwJbosw9+kprP7aEFh6+mLFQltJbH+Ts3Tm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrHxYxvnP6rtr98EbJ7CoqO0AcpEPBDJsz5qdCSf2r+siI9anUaoCUMXXib1NvGtf
         5UaQvPXeXBCryhJ1eKIDMMX9y/tZQ1M9QX8qGHpYoE+a2To2owCShZ0KwPvAdEMQ2Q
         d05UYske7Owy9dLXFIfCVn6YnreyWlY73CJEjpVfwLQQ2/l5XQ5yV/mP8i3ubKOTE7
         FqXN5yTc7DAvLpE9N8O4bqGYtRJPL06tWfzbLAugYtDEyDj2KG6QAYIGzT3vswdLfd
         tc5cVQwfXCoKTVc8zVPwveADfIXnfqhNBgba3xHpGzDsM2L6Q3fUiXwO7642qGYwmK
         HrriNpxoESS8w==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 3/3] net: dsa: mv88e6xxx: Link in pcs_get_state() even if LP has AN disabled
Date:   Wed, 10 Nov 2021 05:10:10 +0100
Message-Id: <20211110041010.2402-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110041010.2402-1-kabel@kernel.org>
References: <20211110041010.2402-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function mv88e6xxx_serdes_pcs_get_state() currently does not report
link up if AN is not complete. This is in contrast to for example the
mvneta's mvneta_mac_pcs_get_state() implementation, where link is simply
taken from link bit.

For 1000base-x and 2500base-x modes, it is possible that the link
partner has autonegotiation disabled. In this case we get zero in the
SPD_DPL_VALID and we won't link, even if we can.

An example of such link partner is Marvell 88X3310 PHY, when put into
the mode where host interface changes between 10gbase-r, 5gbase-r,
2500base-x and sgmii according to copper speed. The 88X3310 does not
enable AN in 2500base-x, and so SerDes on mv88e6xxx currently does not
link with it.

Fix this.

Fixes: a5a6858b793f ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index bc198ef06745..dd3fba7aab99 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -53,8 +53,11 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 					  u16 status, u16 lpa,
 					  struct phylink_link_state *state)
 {
-	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
-		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+	state->an_complete = !!(status &
+				MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID);
+
+	if (state->an_complete) {
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
 			                         DUPLEX_FULL : DUPLEX_HALF;
@@ -81,8 +84,13 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 			dev_err(chip->dev, "invalid PHY speed\n");
 			return -EINVAL;
 		}
-	} else {
-		state->link = false;
+	} else if (state->link &&
+		   state->interface != PHY_INTERFACE_MODE_SGMII) {
+		state->duplex = DUPLEX_FULL;
+		if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+			state->speed = SPEED_2500;
+		else
+			state->speed = SPEED_1000;
 	}
 
 	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
-- 
2.32.0

