Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FD345DC91
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354431AbhKYOtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350357AbhKYOrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 09:47:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85544604DC;
        Thu, 25 Nov 2021 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637851452;
        bh=0sbZDoy5/zPP7tUGVqdyDE3+TJ6yIApFAlecR5ZDQek=;
        h=From:To:Cc:Subject:Date:From;
        b=FXfTU7arzrqn5HnYnEjFTtG1/qzI2ed0qGKITvhBucCoNK6eOrLiocBNSN81z3iZW
         YjiJER0T2Nl3HNjGFVagWCXpwR/ReC/eDbds3orTW5QUyDimNA+Ujwem6o4VCPL/+m
         A51bHJFcHWxqjozkFeW2NwoZJSthDyLQYDDg2b58dyBkzC2Lu5rKQzNAKiLLV3tQO5
         NnN0Uor4ZeiD7MUn4Um3oJ7Affp1Zl40yLhqJ1Q6iUe3hebOCgmZ2d93bbGX25DLJp
         /kRPfNKaClhUJayO+qBOikUtU32r7O7X3m0veido5kbs95fX1pnqAzXdpp1+pId66j
         0QPxeHhgSnbNA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net] net: dsa: mv88e6xxx: Disable AN on 2500base-x for Amethyst
Date:   Thu, 25 Nov 2021 15:43:59 +0100
Message-Id: <20211125144359.18478-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amethyst does not support autonegotiation in 2500base-x mode.
It does not link with AN enabled with other devices.
Disable autonegotiation for Amethyst in 2500base-x mode.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  2 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 12 ++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f00cbf5753b9..7ed420128cea 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4945,7 +4945,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.serdes_power = mv88e6393x_serdes_power,
 	.serdes_get_lane = mv88e6393x_serdes_get_lane,
 	.serdes_pcs_get_state = mv88e6393x_serdes_pcs_get_state,
-	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_config = mv88e6393x_serdes_pcs_config,
 	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
 	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 6ea003678798..b70979bd07df 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -880,6 +880,18 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				      MV88E6390_SGMII_BMCR, bmcr);
 }
 
+int mv88e6393x_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
+				 int lane, unsigned int mode,
+				 phy_interface_t interface,
+				 const unsigned long *advertise)
+{
+	if (interface == PHY_INTERFACE_MODE_2500BASEX)
+		return 0;
+
+	return mv88e6390_serdes_pcs_config(chip, port, lane, mode, interface,
+					   advertise);
+}
+
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 	int port, int lane, struct phylink_link_state *state)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index cbb3ba30caea..fdf56377013b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -111,6 +111,10 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise);
+int mv88e6393x_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
+				 int lane, unsigned int mode,
+				 phy_interface_t interface,
+				 const unsigned long *advertise);
 int mv88e6185_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state);
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-- 
2.32.0

