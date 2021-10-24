Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DCA438766
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhJXIai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:30:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:64554 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhJXIaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:30:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635064095; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=CB2/lZJfLxHs/HKb5q+3NGZte/6WR/vKOBIrmhwsbaU=; b=jZn8+3kong0EG4vFACSgCdrrOI829he7KABTFzdV4dMbc0iOCupqTXxZCXH5PPQ+MbBC4noI
 hvyvH47wLoQ5UKQfU3O7SbBsZIjl1i4ZXqGjE9alJRVqMQCGEYyCzRes13e4ucsllL8w/02v
 XCuIh/C51i4ZAljlmJQNf7D3yo8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 61751913fd91319f0f3f92dc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 24 Oct 2021 08:28:03
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4DD6EC43460; Sun, 24 Oct 2021 08:28:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EBACBC4360D;
        Sun, 24 Oct 2021 08:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org EBACBC4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v7 06/14] net: phy: add qca8081 read_status
Date:   Sun, 24 Oct 2021 16:27:30 +0800
Message-Id: <20211024082738.849-7-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211024082738.849-1-luoj@codeaurora.org>
References: <20211024082738.849-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Separate the function at803x_read_specific_status from
the at803x_read_status, since it can be reused by the
read_status of qca8081 phy driver excepting adding the
2500M speed.

2. Add the qca8081 read_status function qca808x_read_status.

Signed-off-by: Luo Jie <luoj@codeaurora.org>
---
 drivers/net/phy/at803x.c | 95 ++++++++++++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index aae27fe3e1e1..cecf78e6c643 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -41,6 +41,9 @@
 #define AT803X_SS_SPEED_DUPLEX_RESOLVED		BIT(11)
 #define AT803X_SS_MDIX				BIT(6)
 
+#define QCA808X_SS_SPEED_MASK			GENMASK(9, 7)
+#define QCA808X_SS_SPEED_2500			4
+
 #define AT803X_INTR_ENABLE			0x12
 #define AT803X_INTR_ENABLE_AUTONEG_ERR		BIT(15)
 #define AT803X_INTR_ENABLE_SPEED_CHANGED	BIT(14)
@@ -959,27 +962,9 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 	}
 }
 
-static int at803x_read_status(struct phy_device *phydev)
+static int at803x_read_specific_status(struct phy_device *phydev)
 {
-	int ss, err, old_link = phydev->link;
-
-	/* Update the link, but return if there was an error */
-	err = genphy_update_link(phydev);
-	if (err)
-		return err;
-
-	/* why bother the PHY if nothing can have changed */
-	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
-		return 0;
-
-	phydev->speed = SPEED_UNKNOWN;
-	phydev->duplex = DUPLEX_UNKNOWN;
-	phydev->pause = 0;
-	phydev->asym_pause = 0;
-
-	err = genphy_read_lpa(phydev);
-	if (err < 0)
-		return err;
+	int ss;
 
 	/* Read the AT8035 PHY-Specific Status register, which indicates the
 	 * speed and duplex that the PHY is actually using, irrespective of
@@ -990,13 +975,19 @@ static int at803x_read_status(struct phy_device *phydev)
 		return ss;
 
 	if (ss & AT803X_SS_SPEED_DUPLEX_RESOLVED) {
-		int sfc;
+		int sfc, speed;
 
 		sfc = phy_read(phydev, AT803X_SPECIFIC_FUNCTION_CONTROL);
 		if (sfc < 0)
 			return sfc;
 
-		switch (FIELD_GET(AT803X_SS_SPEED_MASK, ss)) {
+		/* qca8081 takes the different bits for speed value from at803x */
+		if (phydev->drv->phy_id == QCA8081_PHY_ID)
+			speed = FIELD_GET(QCA808X_SS_SPEED_MASK, ss);
+		else
+			speed = FIELD_GET(AT803X_SS_SPEED_MASK, ss);
+
+		switch (speed) {
 		case AT803X_SS_SPEED_10:
 			phydev->speed = SPEED_10;
 			break;
@@ -1006,6 +997,9 @@ static int at803x_read_status(struct phy_device *phydev)
 		case AT803X_SS_SPEED_1000:
 			phydev->speed = SPEED_1000;
 			break;
+		case QCA808X_SS_SPEED_2500:
+			phydev->speed = SPEED_2500;
+			break;
 		}
 		if (ss & AT803X_SS_DUPLEX)
 			phydev->duplex = DUPLEX_FULL;
@@ -1030,6 +1024,35 @@ static int at803x_read_status(struct phy_device *phydev)
 		}
 	}
 
+	return 0;
+}
+
+static int at803x_read_status(struct phy_device *phydev)
+{
+	int err, old_link = phydev->link;
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	err = genphy_read_lpa(phydev);
+	if (err < 0)
+		return err;
+
+	err = at803x_read_specific_status(phydev);
+	if (err < 0)
+		return err;
+
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
 		phy_resolve_aneg_pause(phydev);
 
@@ -1434,6 +1457,33 @@ static int qca83xx_suspend(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca808x_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_STAT);
+	if (ret < 0)
+		return ret;
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->lp_advertising,
+			ret & MDIO_AN_10GBT_STAT_LP2_5G);
+
+	ret = genphy_read_status(phydev);
+	if (ret)
+		return ret;
+
+	ret = at803x_read_specific_status(phydev);
+	if (ret < 0)
+		return ret;
+
+	if (phydev->link && phydev->speed == SPEED_2500)
+		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+	else
+		phydev->interface = PHY_INTERFACE_MODE_SMII;
+
+	return 0;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1605,6 +1655,7 @@ static struct phy_driver at803x_driver[] = {
 	.get_wol		= at803x_get_wol,
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
+	.read_status		= qca808x_read_status,
 }, };
 
 module_phy_driver(at803x_driver);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

