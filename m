Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A85347E36
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhCXQva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236778AbhCXQvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDD2D61A11;
        Wed, 24 Mar 2021 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604666;
        bh=Bqrd7a8qdQzviEJ9iRpTvmEogpJ7AAzj+1nv4IO8P1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXCE2CxP5Ytm4ecAXvRPu6tuN9H5gDfGu9ewrkU70g+AlMBnZ19rMpDgBZf1383pw
         RIVvBMqGJ5is6oFAwqpHlxDLf9LNxAS+yra4lm7HYZ77hM3mkyRFl/0+/xUAu0kYsL
         Km3z8mCWSJwBmugg6TH333q4SsIZMVq60SAwBFVG+HhLBmlUn62gYBs/Dg6cbP8/ol
         BbgUHx/HL/0VQqFGDYXLzeGFqyYvgh1ZslW5NCOU0CvlEIBz3m9IzFpoYbTIKhYWV1
         5pMFqinzlIQ2o2VRn3dpv3EGxOKdAd4nZ9yakezt3Mf+MIh6y3K3uW//nCiHguCSWn
         7CV7kIxNS+wNw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 5/7] net: phy: marvell10g: save MACTYPE instead of rate_matching boolean
Date:   Wed, 24 Mar 2021 17:50:21 +0100
Message-Id: <20210324165023.32352-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324165023.32352-1-kabel@kernel.org>
References: <20210324165023.32352-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Save MACTYPE instead of rate_matching boolean. We will need this for
other configurations.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 46e853f2d41b..b4f9831b4db6 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -100,7 +100,7 @@ enum {
 
 struct mv3310_priv {
 	u32 firmware_ver;
-	bool rate_match;
+	u8 mactype;
 
 	struct device *hwmon_dev;
 	char *hwmon_name;
@@ -486,8 +486,7 @@ static int mv3310_config_init(struct phy_device *phydev)
 	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
 	if (val < 0)
 		return val;
-	priv->rate_match = ((val & MV_V2_PORT_CTRL_MACTYPE_MASK) ==
-			MV_V2_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH);
+	priv->mactype = val & MV_V2_PORT_CTRL_MACTYPE_MASK;
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
@@ -601,7 +600,7 @@ static void mv3310_update_interface(struct phy_device *phydev)
 	 * 10Gb. The PHY adapts the rate to actual wire speed with help of
 	 * internal 16KB buffer.
 	 */
-	if (priv->rate_match) {
+	if (priv->mactype == MV_V2_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH) {
 		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
 		return;
 	}
-- 
2.26.2

