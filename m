Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9834A48D8
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379218AbiAaN4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348874AbiAaN4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:56:52 -0500
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A0DC061714;
        Mon, 31 Jan 2022 05:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
        s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rh3zzrjG4eJ4zkltSxTz4v948/fJYDk5vDVefUcxqXg=; b=ABwLh8yiWuo+TYuERG9ne33ID5
        ksC/jxl5wpEwaODztO3KksEZC3vQl86EWJsshXS8ALGQ5K5eTCZGAu5XABSJsmcgVNHGLDOi2XRYZ
        mUDpO/GCDAScx33uZACIK3OItyizI+1NwvlyxrE8cpaJKp9hZdbvsRTs+77kQCgI2q4oRz7ibk/zg
        9enGMBBytBUgoSmso6Pudw750dktfu8IZg0SNm+SsfQJLvGBCggI+e6YBqVjJ66dXUflF3pUiLc2d
        8+JirNc+0vkuSCP4GVen3AQWkKWCtUOnet1ZiIB9oA/MmK0LofxmilfOXGEqC9ANRhJlqkOEicZkq
        +1Mr3nDg==;
Received: from noodles by the.earth.li with local (Exim 4.94.2)
        (envelope-from <noodles@earth.li>)
        id 1nEXAf-00B0KI-AV; Mon, 31 Jan 2022 13:56:41 +0000
Date:   Mon, 31 Jan 2022 13:56:41 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Luo Jie <luoj@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>
Subject: [PATCH net v2] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
Message-ID: <YffqmcR4iC3xKaRm@earth.li>
References: <YfZnmMteVry/A1XR@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfZnmMteVry/A1XR@earth.li>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A typo in qca808x_read_status means we try to set SMII mode on the port
rather than SGMII when the link speed is not 2.5Gb/s. This results in no
traffic due to the mismatch in configuration between the phy and the
mac.

v2:
 Only change interface mode when the link is up

Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan McDowell <noodles@earth.li>
---
 drivers/net/phy/at803x.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5b6c0d120e09..29aa811af430 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1688,19 +1688,19 @@ static int qca808x_read_status(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->link && phydev->speed == SPEED_2500)
-		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
-	else
-		phydev->interface = PHY_INTERFACE_MODE_SMII;
-
-	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
-	 * except for master/slave configuration fault detected.
-	 * the reason for not putting this code into the function link_change_notify is
-	 * the corner case where the link partner is also the qca8081 PHY and the seed
-	 * value is configured as the same value, the link can't be up and no link change
-	 * occurs.
-	 */
-	if (!phydev->link) {
+	if (phydev->link) {
+		if (phydev->speed == SPEED_2500)
+			phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
+		else
+			phydev->interface = PHY_INTERFACE_MODE_SGMII;
+	} else {
+		/* generate seed as a lower random value to make PHY linked as SLAVE easily,
+		 * except for master/slave configuration fault detected.
+		 * the reason for not putting this code into the function link_change_notify is
+		 * the corner case where the link partner is also the qca8081 PHY and the seed
+		 * value is configured as the same value, the link can't be up and no link change
+		 * occurs.
+		 */
 		if (phydev->master_slave_state == MASTER_SLAVE_STATE_ERR) {
 			qca808x_phy_ms_seed_enable(phydev, false);
 		} else {
-- 
2.30.2

