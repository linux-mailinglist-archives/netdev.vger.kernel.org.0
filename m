Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E23B32E47C
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCEJPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhCEJOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 04:14:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999CAC061756
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 01:14:52 -0800 (PST)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lI6Xr-0004RC-70; Fri, 05 Mar 2021 10:14:51 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] net: dsa: bcm_sf2: simplify optional reset handling
Date:   Fri,  5 Mar 2021 10:14:48 +0100
Message-Id: <20210305091448.19748-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of commit bb475230b8e5 ("reset: make optional functions really
optional"), the reset framework API calls use NULL pointers to describe
optional, non-present reset controls.

This allows to unconditionally return errors from
devm_reset_control_get_optional_exclusive.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/net/dsa/bcm_sf2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 5ee8103b8e9c..f277df922fcd 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -406,7 +406,7 @@ static int bcm_sf2_sw_rst(struct bcm_sf2_priv *priv)
 	/* The watchdog reset does not work on 7278, we need to hit the
 	 * "external" reset line through the reset controller.
 	 */
-	if (priv->type == BCM7278_DEVICE_ID && !IS_ERR(priv->rcdev)) {
+	if (priv->type == BCM7278_DEVICE_ID) {
 		ret = reset_control_assert(priv->rcdev);
 		if (ret)
 			return ret;
@@ -1265,7 +1265,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 
 	priv->rcdev = devm_reset_control_get_optional_exclusive(&pdev->dev,
 								"switch");
-	if (PTR_ERR(priv->rcdev) == -EPROBE_DEFER)
+	if (IS_ERR(priv->rcdev))
 		return PTR_ERR(priv->rcdev);
 
 	/* Auto-detection using standard registers will not work, so
@@ -1426,7 +1426,7 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
 	bcm_sf2_mdio_unregister(priv);
 	clk_disable_unprepare(priv->clk_mdiv);
 	clk_disable_unprepare(priv->clk);
-	if (priv->type == BCM7278_DEVICE_ID && !IS_ERR(priv->rcdev))
+	if (priv->type == BCM7278_DEVICE_ID)
 		reset_control_assert(priv->rcdev);
 
 	return 0;
-- 
2.29.2

