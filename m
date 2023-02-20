Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A5269CE31
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 14:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjBTN5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 08:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjBTN46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 08:56:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14001E2A1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 05:56:30 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pU6eG-0006kz-QY; Mon, 20 Feb 2023 14:56:08 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pU6eE-006HMS-Jz; Mon, 20 Feb 2023 14:56:07 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pU6eE-004lZt-4r; Mon, 20 Feb 2023 14:56:06 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v1 1/4] net: phy: c45: use "supported_eee" instead of supported for access validation
Date:   Mon, 20 Feb 2023 14:56:02 +0100
Message-Id: <20230220135605.1136137-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230220135605.1136137-1-o.rempel@pengutronix.de>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use we use proper variable to validate access to potentially not
supported registers. Otherwise we will get false read/write errors.

Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index f9b128cecc3f..f23cce2c5199 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -674,7 +674,7 @@ int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)
 {
 	int val, changed;
 
-	if (linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)) {
+	if (linkmode_intersects(phydev->supported_eee, PHY_EEE_CAP1_FEATURES)) {
 		val = linkmode_to_mii_eee_cap1_t(adv);
 
 		/* In eee_broken_modes are stored MDIO_AN_EEE_ADV specific raw
@@ -726,7 +726,7 @@ static int genphy_c45_read_eee_adv(struct phy_device *phydev,
 {
 	int val;
 
-	if (linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)) {
+	if (linkmode_intersects(phydev->supported_eee, PHY_EEE_CAP1_FEATURES)) {
 		/* IEEE 802.3-2018 45.2.7.13 EEE advertisement 1
 		 * (Register 7.60)
 		 */
@@ -762,7 +762,7 @@ static int genphy_c45_read_eee_lpa(struct phy_device *phydev,
 {
 	int val;
 
-	if (linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)) {
+	if (linkmode_intersects(phydev->supported_eee, PHY_EEE_CAP1_FEATURES)) {
 		/* IEEE 802.3-2018 45.2.7.14 EEE link partner ability 1
 		 * (Register 7.61)
 		 */
-- 
2.30.2

