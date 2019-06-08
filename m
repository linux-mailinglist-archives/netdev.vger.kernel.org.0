Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F3A39E0B
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfFHLmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbfFHLmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D17214AF;
        Sat,  8 Jun 2019 11:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994133;
        bh=P2ZZyDquJKKG+iVcM149i0KLgbNumf6U1VSjEENDeEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JItZFb9Ct30G8mhcQ/eJWpsBjm+Ivt9zKZpi7hFVw1a4kr9JR6YuXo3h9xsuB5NNv
         XP2UtAIFPKAUcbHHtMfpgQlnWXbnLfqQeFV+tH2LvltvRaq2TnjPRMhcbAwOGTwxJv
         0X8FkfsRgECtPmK02X3lJt2bC1I+POrLqw+jl1uI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Uvarov <muvarov@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 63/70] net: phy: dp83867: increase SGMII autoneg timer duration
Date:   Sat,  8 Jun 2019 07:39:42 -0400
Message-Id: <20190608113950.8033-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Uvarov <muvarov@gmail.com>

[ Upstream commit 1a97a477e666cbdededab93bd3754e508f0c09d7 ]

After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
That is not enough to finalize autonegatiation on some devices.
Increase this timer duration to maximum supported 16ms.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 29cae4de9a4f..ffaf67bdb140 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,12 @@
 
 /* Extended Registers */
 #define DP83867_CFG4            0x0031
+#define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
+#define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
+
 #define DP83867_RGMIICTL	0x0032
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
@@ -292,6 +298,18 @@ static int dp83867_config_init(struct phy_device *phydev)
 				     0);
 		if (ret)
 			return ret;
+
+		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
+		 * are 01). That is not enough to finalize autoneg on some
+		 * devices. Increase this timer duration to maximum 16ms.
+		 */
+		ret = phy_modify_mmd(phydev, DP83867_DEVADDR,
+				     DP83867_CFG4,
+				     DP83867_CFG4_SGMII_ANEG_MASK,
+				     DP83867_CFG4_SGMII_ANEG_TIMER_16MS);
+
+		if (ret)
+			return ret;
 	}
 
 	/* Enable Interrupt output INT_OE in CFG3 register */
-- 
2.20.1

