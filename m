Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3CB36539B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhDTHzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229981AbhDTHzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:55:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415C7613B0;
        Tue, 20 Apr 2021 07:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618905292;
        bh=cXU0g0x3ekBH8UJ+BDOXoikyudNDa3HjELtPMjsgwbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3TFlwCQVZBLfibL1bWTvIfESmpYgEBpRLUJTvueMujOkTIKxBLEoq0RzuFpC0NkM
         iPDPRT8aOxQuyUmgrAzCdfFuBmQ4nK9JuM1Dcnf719sPvHcP8SKyzNvAlvynd8WEV1
         gOx3k1ZmXYxU74pKFy14B3TwM2eQbo0s98Vew8IzWDS2/0jKZxpWaVMOWuAZCW1d7f
         bMt9u9uJU5tDpOjFZ9hbXD7J+dCygaVjmu1fZ5XLH8Vd2a2l2PZFm4j6SkbQMCnmvT
         i7FHvV8uHMEAnJjYehfZj5q4Ef3MBuHarhdeZ7fZGfwrAADCUAqBMkWRSJTVkiDjQC
         YlsyvOwbMJg0Q==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 2/5] net: phy: marvell: fix HWMON enable register for 6390
Date:   Tue, 20 Apr 2021 09:54:00 +0200
Message-Id: <20210420075403.5845-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210420075403.5845-1-kabel@kernel.org>
References: <20210420075403.5845-1-kabel@kernel.org>
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

(A newer version of the 6390 documentation removed temperature sensor
 section completely. In an older version, the above mentioned register
 is reserved, although it is R/W. Since the code works, I think we can
 assume that it is correct.)

Rename this register and define all 4 values according to 6393X
documentation.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 70cfcfcdd8f2..9529aaa3bed3 100644
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

