Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0698214FA9
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgGEU4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:56:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbgGEU4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 16:56:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsBgG-003kL1-Oc; Sun, 05 Jul 2020 22:56:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>
Subject: [PATCH] net: dsa: lan9303: fix  variable 'res' set but not used
Date:   Sun,  5 Jul 2020 22:55:55 +0200
Message-Id: <20200705205555.893062-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since lan9303_adjust_link() is a void function, there is no option to
return an error. So just remove the variable and lets any errors be
discarded.

Cc: Egil Hjelmeland <privat@egil-hjelmeland.no>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/lan9303-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index cc17a44dd3a8..aa1142d6a9f5 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1042,7 +1042,7 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 				struct phy_device *phydev)
 {
 	struct lan9303 *chip = ds->priv;
-	int ctl, res;
+	int ctl;
 
 	if (!phy_is_pseudo_fixed_link(phydev))
 		return;
@@ -1063,15 +1063,14 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 	else
 		ctl &= ~BMCR_FULLDPLX;
 
-	res =  lan9303_phy_write(ds, port, MII_BMCR, ctl);
+	lan9303_phy_write(ds, port, MII_BMCR, ctl);
 
 	if (port == chip->phy_addr_base) {
 		/* Virtual Phy: Remove Turbo 200Mbit mode */
 		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
 
 		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
-		res =  regmap_write(chip->regmap,
-				    LAN9303_VIRT_SPECIAL_CTRL, ctl);
+		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
 	}
 }
 
-- 
2.27.0.rc2

