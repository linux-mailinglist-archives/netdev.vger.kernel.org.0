Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34BF1DE38A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgEVJxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:53:52 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:53511 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbgEVJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:53:52 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BCB6522FE5;
        Fri, 22 May 2020 11:53:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590141229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m87Rv6lV763iWpmgq4WlAH6WIleuTi3tV5wQyyZVlX0=;
        b=bYMBvhyNuwrb1EbTQTwF6XrnpDNSDJj57YmIJNeDJxRKOY5f6pZZD39qVcuWUolETOj2wc
        isYddN8Kl5rNA3Leb4J7VISouHnVl3FI0w1xQBrSs4T8t36jIBioVbUmn/Oh45BqIZPPjP
        2FPwcf0OCAjfS8Tu38IiBTgFrDaWLdM=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Matus Ujhelyi <ujhelyi.m@gmail.com>
Subject: [PATCH net-next] net: phy: at803x: fix PHY ID masks
Date:   Fri, 22 May 2020 11:53:31 +0200
Message-Id: <20200522095331.21448-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ever since its first commit 0ca7111a38f05 ("phy: add AT803x driver") the
PHY ID mask was set to 0xffffffef. It is unclear to me why this mask was
chosen in the first place. Both the AR8031/AR8033 and the AR8035
datasheets mention it is always the given value:
 - for AR8031/AR8033 its 0x004d/0xd074
 - for AR8035 its 0x004d/0xd072

Unfortunately, I don't have a datasheet for the AR8030. Therefore, we
leave its PHY ID mask untouched. For the PHYs mentioned before use the
handy PHY_ID_MATCH_EXACT() macro.

I've tried to contact the author of the initial commit, but received no
answer so far.

Cc: Matus Ujhelyi <ujhelyi.m@gmail.com>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index acd51b29a476..822b3acf6be7 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -126,7 +126,7 @@
 #define ATH8031_PHY_ID 0x004dd074
 #define ATH8032_PHY_ID 0x004dd023
 #define ATH8035_PHY_ID 0x004dd072
-#define AT803X_PHY_ID_MASK			0xffffffef
+#define AT8030_PHY_ID_MASK			0xffffffef
 
 MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
@@ -967,9 +967,8 @@ static int at803x_cable_test_start(struct phy_device *phydev)
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
-	.phy_id			= ATH8035_PHY_ID,
+	PHY_ID_MATCH_EXACT(ATH8035_PHY_ID),
 	.name			= "Qualcomm Atheros AR8035",
-	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
@@ -991,7 +990,7 @@ static struct phy_driver at803x_driver[] = {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
 	.name			= "Qualcomm Atheros AR8030",
-	.phy_id_mask		= AT803X_PHY_ID_MASK,
+	.phy_id_mask		= AT8030_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
 	.config_init		= at803x_config_init,
@@ -1005,9 +1004,8 @@ static struct phy_driver at803x_driver[] = {
 	.config_intr		= at803x_config_intr,
 }, {
 	/* Qualcomm Atheros AR8031/AR8033 */
-	.phy_id			= ATH8031_PHY_ID,
+	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
 	.name			= "Qualcomm Atheros AR8031/AR8033",
-	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.flags			= PHY_POLL_CABLE_TEST,
 	.probe			= at803x_probe,
 	.remove			= at803x_remove,
@@ -1055,10 +1053,10 @@ static struct phy_driver at803x_driver[] = {
 module_phy_driver(at803x_driver);
 
 static struct mdio_device_id __maybe_unused atheros_tbl[] = {
-	{ ATH8030_PHY_ID, AT803X_PHY_ID_MASK },
-	{ ATH8031_PHY_ID, AT803X_PHY_ID_MASK },
+	{ ATH8030_PHY_ID, AT8030_PHY_ID_MASK },
+	{ PHY_ID_MATCH_EXACT(ATH8031_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH8032_PHY_ID) },
-	{ ATH8035_PHY_ID, AT803X_PHY_ID_MASK },
+	{ PHY_ID_MATCH_EXACT(ATH8035_PHY_ID) },
 	{ PHY_ID_MATCH_EXACT(ATH9331_PHY_ID) },
 	{ }
 };
-- 
2.20.1

