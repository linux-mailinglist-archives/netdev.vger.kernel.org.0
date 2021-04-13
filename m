Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FF035D96B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbhDMH4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhDMH4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B7ED613B7;
        Tue, 13 Apr 2021 07:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618300582;
        bh=2CJ/668Lu2L6HYwVEeW3UgcYKoWLzyXwrZMiA2q0Qt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWJqTEMyr3GRbUiLfeVaf7JIXGQ117IWbNnixkP7ExcI2mjxrXhU08va5p27Pn0XP
         7P5NHCPKCay8qq4zyWNgAi9g9+2kwLue/hZDD1Ak/1C+kM8aGENVvkL9aHvGGaL+st
         7z//JjOv7XLPhC5RA6M6XCjdcWQFgQnvSHGfIjeSCdjzasrqI23GVMQd9qjr10fk6N
         nWln80Lj9CwjOrvJWdNFP7iCCCCV0JUyxJWVe86ArLU3Jw9FmQbdCAYJjdBifVgRfJ
         fDRp2OvNbYv7r/xoIDshGhY+17Idmc6EywMADaXwxG5MLXTMS2e7x5OSHsfUW7vab5
         GYI/4Hjt84V4Q==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/5] net: phy: marvell: fix HWMON enable register for 6390
Date:   Tue, 13 Apr 2021 09:55:35 +0200
Message-Id: <20210413075538.30175-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210413075538.30175-1-kabel@kernel.org>
References: <20210413075538.30175-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register 27_6.15:14 has the following description in 88E6393X
documentation:
  Temperature Sensor Enable
    0x0 - Sample every 1s
    0x1 - Sense rate decided by bits 10:8 of this register
    0x2 - Use 26_6.5 (One shot Temperature Sample) to enable
    0x3 - Disable

This is compatible with how the 6390 code uses this register currently,
but the 6390 code handles it as two 1-bit registers (somewhat), instead
of one register with 4 possible values.

Rename this register and define all 4 values according to 6393X
documentation.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 63788d5c13eb..bae2a225b550 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -113,11 +113,11 @@
 #define MII_88E1540_COPPER_CTRL3_FAST_LINK_DOWN		BIT(9)
 
 #define MII_88E6390_MISC_TEST		0x1b
-#define MII_88E6390_MISC_TEST_SAMPLE_1S		0
-#define MII_88E6390_MISC_TEST_SAMPLE_10MS	BIT(14)
-#define MII_88E6390_MISC_TEST_SAMPLE_DISABLE	BIT(15)
-#define MII_88E6390_MISC_TEST_SAMPLE_ENABLE	0
-#define MII_88E6390_MISC_TEST_SAMPLE_MASK	(0x3 << 14)
+#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_SAMPLE_1S	(0x0 << 14)
+#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE		(0x1 << 14)
+#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_ONESHOT	(0x2 << 14)
+#define MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE		(0x3 << 14)
+#define MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK			(0x3 << 14)
 
 #define MII_88E6390_TEMP_SENSOR		0x1c
 #define MII_88E6390_TEMP_SENSOR_MASK	0xff
@@ -2352,9 +2352,8 @@ static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
 	if (ret < 0)
 		goto error;
 
-	ret = ret & ~MII_88E6390_MISC_TEST_SAMPLE_MASK;
-	ret |= MII_88E6390_MISC_TEST_SAMPLE_ENABLE |
-		MII_88E6390_MISC_TEST_SAMPLE_1S;
+	ret = ret & ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
+	ret |= MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_SAMPLE_1S;
 
 	ret = __phy_write(phydev, MII_88E6390_MISC_TEST, ret);
 	if (ret < 0)
@@ -2381,8 +2380,8 @@ static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
 	if (ret < 0)
 		goto error;
 
-	ret = ret & ~MII_88E6390_MISC_TEST_SAMPLE_MASK;
-	ret |= MII_88E6390_MISC_TEST_SAMPLE_DISABLE;
+	ret = ret & ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
+	ret |= MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE;
 
 	ret = __phy_write(phydev, MII_88E6390_MISC_TEST, ret);
 
-- 
2.26.3

