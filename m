Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2552585A1
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 04:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgIACdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 22:33:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgIACdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 22:33:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kCw6b-00CiJR-2S; Tue, 01 Sep 2020 04:33:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Fix W=1 warning with !CONFIG_OF
Date:   Tue,  1 Sep 2020 04:32:57 +0200
Message-Id: <20200901023257.3030231-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building on platforms without device tree, e.g. amd64, W=1 gives
a warning about mv88e6xxx_mdio_external_match being unused. Replace
of_match_node() with of_device_is_compatible() to prevent this
warning.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ee3b1a6b1ea8..fc3f02168462 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3100,12 +3100,6 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
-static const struct of_device_id mv88e6xxx_mdio_external_match[] = {
-	{ .compatible = "marvell,mv88e6xxx-mdio-external",
-	  .data = (void *)true },
-	{ },
-};
-
 static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 
 {
@@ -3125,7 +3119,6 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 				    struct device_node *np)
 {
-	const struct of_device_id *match;
 	struct device_node *child;
 	int err;
 
@@ -3143,8 +3136,8 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 * bus.
 	 */
 	for_each_available_child_of_node(np, child) {
-		match = of_match_node(mv88e6xxx_mdio_external_match, child);
-		if (match) {
+		if (of_device_is_compatible(
+			    child, "marvell,mv88e6xxx-mdio-external")) {
 			err = mv88e6xxx_mdio_register(chip, child, true);
 			if (err) {
 				mv88e6xxx_mdios_unregister(chip);
-- 
2.28.0

