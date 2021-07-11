Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148AA3C3E04
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhGKQlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhGKQlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 12:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6498860FDA;
        Sun, 11 Jul 2021 16:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626021499;
        bh=zjLf4GGHNhZ0wqyExb9qXipL3uUSrHzmwwCgoLa+UCI=;
        h=From:To:Cc:Subject:Date:From;
        b=XC3ZyjmhsglqxbZ2LP+kTfFJOKL9SKeK123VQIerwB1Sb+9gJeZTapCjP+LsFxTTq
         lbbYGxVHKhxSc0czPVeITnw3ZXr+fZXf08ASs4FWOT2vLIyav/Js76Z12PUoiuyTcX
         VtGkwoI/hK5i3W71PQfe2Jiw9t39JglosWGXEtI+3iuFRTfM2aKkNayqCZrAP1K/ZM
         XWIwJDfpGv3Yp8YApK4aCCuzGPB3QBnnvRhYAx762jI5PhgC6P92DBjROK9CfUKIBl
         Vfn3F7OabqZWQu3ZzAST0XS5TZOd9r+cIfdsZqT3GeY2MOwlj1sMebIntX/E681w9f
         7urRC0GKCI+zg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Matteo Croce <mcroce@linux.microsoft.com>
Subject: [PATCH net] net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340
Date:   Sun, 11 Jul 2021 18:38:15 +0200
Message-Id: <20210711163815.19844-1-kabel@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that we cannot differentiate 88X3310 from 88X3340 by simply
looking at bit 3 of revision ID. This only works on revisions A0 and A1.
On revision B0, this bit is always 1.

Instead use the 3.d00d register for differentiation, since this register
contains information about number of ports on the device.

Fixes: 9885d016ffa9 ("net: phy: marvell10g: add separate structure for 88X3340")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reported-by: Matteo Croce <mcroce@linux.microsoft.com>
---
 drivers/net/phy/marvell10g.c | 40 +++++++++++++++++++++++++++++++-----
 include/linux/marvell_phy.h  |  6 +-----
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index bbbc6ac8fa82..53a433442803 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -78,6 +78,11 @@ enum {
 	/* Temperature read register (88E2110 only) */
 	MV_PCS_TEMP		= 0x8042,
 
+	/* Number of ports on the device */
+	MV_PCS_PORT_INFO	= 0xd00d,
+	MV_PCS_PORT_INFO_NPORTS_MASK	= 0x0380,
+	MV_PCS_PORT_INFO_NPORTS_SHIFT	= 7,
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -966,6 +971,30 @@ static const struct mv3310_chip mv2111_type = {
 #endif
 };
 
+static int mv3310_get_number_of_ports(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_PORT_INFO);
+	if (ret < 0)
+		return ret;
+
+	ret &= MV_PCS_PORT_INFO_NPORTS_MASK;
+	ret >>= MV_PCS_PORT_INFO_NPORTS_SHIFT;
+
+	return ret + 1;
+}
+
+static int mv3310_match_phy_device(struct phy_device *phydev)
+{
+	return mv3310_get_number_of_ports(phydev) == 1;
+}
+
+static int mv3340_match_phy_device(struct phy_device *phydev)
+{
+	return mv3310_get_number_of_ports(phydev) == 4;
+}
+
 static int mv211x_match_phy_device(struct phy_device *phydev, bool has_5g)
 {
 	int val;
@@ -994,7 +1023,8 @@ static int mv2111_match_phy_device(struct phy_device *phydev)
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
-		.phy_id_mask	= MARVELL_PHY_ID_88X33X0_MASK,
+		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.match_phy_device = mv3310_match_phy_device,
 		.name		= "mv88x3310",
 		.driver_data	= &mv3310_type,
 		.get_features	= mv3310_get_features,
@@ -1011,8 +1041,9 @@ static struct phy_driver mv3310_drivers[] = {
 		.set_loopback	= genphy_c45_loopback,
 	},
 	{
-		.phy_id		= MARVELL_PHY_ID_88X3340,
-		.phy_id_mask	= MARVELL_PHY_ID_88X33X0_MASK,
+		.phy_id		= MARVELL_PHY_ID_88X3310,
+		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.match_phy_device = mv3340_match_phy_device,
 		.name		= "mv88x3340",
 		.driver_data	= &mv3340_type,
 		.get_features	= mv3310_get_features,
@@ -1069,8 +1100,7 @@ static struct phy_driver mv3310_drivers[] = {
 module_phy_driver(mv3310_drivers);
 
 static struct mdio_device_id __maybe_unused mv3310_tbl[] = {
-	{ MARVELL_PHY_ID_88X3310, MARVELL_PHY_ID_88X33X0_MASK },
-	{ MARVELL_PHY_ID_88X3340, MARVELL_PHY_ID_88X33X0_MASK },
+	{ MARVELL_PHY_ID_88X3310, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E2110, MARVELL_PHY_ID_MASK },
 	{ },
 };
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index acee44b9db26..0f06c2287b52 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -22,14 +22,10 @@
 #define MARVELL_PHY_ID_88E1545		0x01410ea0
 #define MARVELL_PHY_ID_88E1548P		0x01410ec0
 #define MARVELL_PHY_ID_88E3016		0x01410e60
+#define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
 #define MARVELL_PHY_ID_88X2222		0x01410f10
 
-/* PHY IDs and mask for Alaska 10G PHYs */
-#define MARVELL_PHY_ID_88X33X0_MASK	0xfffffff8
-#define MARVELL_PHY_ID_88X3310		0x002b09a0
-#define MARVELL_PHY_ID_88X3340		0x002b09a8
-
 /* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
 #define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
 
-- 
2.31.1

