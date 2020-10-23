Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F642296D31
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462655AbgJWK5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462555AbgJWK4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:56:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2FEC0613D4
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:56:38 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukG-00087q-Kr; Fri, 23 Oct 2020 12:56:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukF-0001kc-G7; Fri, 23 Oct 2020 12:56:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: [RFC PATCH v1 4/6] net: add CAN specific link modes
Date:   Fri, 23 Oct 2020 12:56:24 +0200
Message-Id: <20201023105626.6534-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201023105626.6534-1-o.rempel@pengutronix.de>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the CAN specific link modes to the ethtool user space
API.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-core.c   | 2 +-
 include/uapi/linux/ethtool.h | 9 +++++++++
 net/ethtool/common.c         | 7 +++++++
 net/ethtool/linkmodes.c      | 7 +++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 635be83962b6..0f0c136890e0 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -13,7 +13,7 @@
  */
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 92,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 98,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9ca87bc73c44..eb3cb846c0a6 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1619,6 +1619,15 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
 	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
 	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
+
+	/* CAN specific capabilities */
+	ETHTOOL_LINK_MODE_CAN_SW_BIT			 = 92,
+	ETHTOOL_LINK_MODE_CAN_LS_BIT			 = 93,
+	ETHTOOL_LINK_MODE_CAN_HS_BIT			 = 94,
+	ETHTOOL_LINK_MODE_CAN_FD_BIT			 = 95,
+	ETHTOOL_LINK_MODE_CAN_SIC_BIT			 = 96,
+	ETHTOOL_LINK_MODE_CAN_SIC_XL_BIT		 = 97,
+
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..3d2fa29291a1 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -194,6 +194,13 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(400000, CR4, Full),
 	__DEFINE_LINK_MODE_NAME(100, FX, Half),
 	__DEFINE_LINK_MODE_NAME(100, FX, Full),
+
+	__DEFINE_SPECIAL_MODE_NAME(CAN_SW, "Single-wire CAN"),	/* SAE J2411 */
+	__DEFINE_SPECIAL_MODE_NAME(CAN_LS, "CAN low-speed"),	/* ISO 11898-3 (aka. Fault tolerant) */
+	__DEFINE_SPECIAL_MODE_NAME(CAN_HS, "CAN high-speed"),	/* ISO 11898-2:2016 limited to bit-rates of 1 Mbit/s */
+	__DEFINE_SPECIAL_MODE_NAME(CAN_FD, "CAN FD"),		/* ISO 11898-2:2016 supporting improved optional parameters */
+	__DEFINE_SPECIAL_MODE_NAME(CAN_SIC, "CAN SIC"),		/* CiA 601-4 */
+	__DEFINE_SPECIAL_MODE_NAME(CAN_SIC_XL, "CAN SIC XL"),	/* CiA 610-3 */
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index c5bcb9abc8b9..eae0f75681fe 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -264,6 +264,13 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
 	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
+
+	__DEFINE_SPECIAL_MODE_PARAMS(CAN_SW),
+	__DEFINE_SPECIAL_MODE_PARAMS(CAN_LS),
+	__DEFINE_SPECIAL_MODE_PARAMS(CAN_HS),
+	__DEFINE_SPECIAL_MODE_PARAMS(CAN_FD),
+	__DEFINE_SPECIAL_MODE_PARAMS(CAN_SIC),
+	__DEFINE_SPECIAL_MODE_PARAMS(CAN_SIC_XL),
 };
 
 const struct nla_policy ethnl_linkmodes_set_policy[] = {
-- 
2.28.0

