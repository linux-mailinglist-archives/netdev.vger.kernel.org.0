Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8DD35FDE5
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhDNWf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:35:59 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:40370 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhDNWf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:35:57 -0400
Received: (qmail 19680 invoked from network); 14 Apr 2021 22:28:53 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 14 Apr 2021 22:28:53 -0000
From:   David Bauer <mail@david-bauer.net>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch
Subject: [PATCH net-next 2/2] net: phy: at803x: select correct page on config init
Date:   Thu, 15 Apr 2021 00:28:41 +0200
Message-Id: <20210414222841.82548-2-mail@david-bauer.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210414222841.82548-1-mail@david-bauer.net>
References: <20210414222841.82548-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Atheros AR8031 and AR8033 expose different registers for SGMII/Fiber
as well as the copper side of the PHY depending on the BT_BX_REG_SEL bit
in the chip configure register.

The driver assumes the copper side is selected on probe, but this might
not be the case depending which page was last selected by the
bootloader. Notably, Ubiquiti UniFi bootloaders show this behavior.

Select the copper page when probing to circumvent this.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/phy/at803x.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index b3243ad570c7..b63d2c1575bb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -567,6 +567,7 @@ static int at803x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct at803x_priv *priv;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -574,7 +575,20 @@ static int at803x_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
-	return at803x_parse_dt(phydev);
+	ret = at803x_parse_dt(phydev);
+	if (ret)
+		return ret;
+
+	/* Some bootloaders leave the fiber page selected.
+	 * Switch to the copper page, as otherwise we read
+	 * the PHY capabilities from the fiber side.
+	 */
+	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+		ret = phy_select_page(phydev, AT803X_PAGE_COPPER);
+		ret = phy_restore_page(phydev, AT803X_PAGE_COPPER, ret);
+	}
+
+	return ret;
 }
 
 static void at803x_remove(struct phy_device *phydev)
-- 
2.31.1

