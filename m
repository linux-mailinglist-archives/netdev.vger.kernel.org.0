Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454583492E2
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCYNNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230348AbhCYNNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E4D619FE;
        Thu, 25 Mar 2021 13:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678011;
        bh=TLzjIiMW8gsFW9CarK+CjX5T4n1cnXSM8MHtXQS/g7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0r0KGH5DXHduUL6PGdWGkU8F9mUNRUJ86na4z1krZ4UdlIQ8U458605bW5jVWz5b
         r00bG1Ine1ky05r4vxiXBzpDhjFNYkRGSLJNqPCwUhU+aoGSCL7up0GhbkfHesCc6l
         cT00U5+tCTZwqZUqtvzxUCF+56FEdf12mhcxli9+CdPYzymH0+g3/TFMeU1CJTo25q
         hgejyMMmZlLOFMQ7C7X0y/4jZgu8obJip/kR/85708c7JvfcqGh+Wfg8ScwZsmbS4s
         eDw3DHc4pjgN1DcjHIzOvqpbOR+p2vX2iFHYLUHQizMlLIZIPom7rnSVKaHrU8l8pH
         RGrcTwdlOSgGw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 04/12] net: phy: marvell10g: indicate 88X33X0 only port control registers
Date:   Thu, 25 Mar 2021 14:12:42 +0100
Message-Id: <20210325131250.15901-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indicate via register names registers that are only valid for 88X33X0,
not for 88E21X0.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 881a0717846e..7552a658a513 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -78,10 +78,10 @@ enum {
 
 	/* Vendor2 MMD registers */
 	MV_V2_PORT_CTRL		= 0xf001,
-	MV_V2_PORT_CTRL_SWRST	= BIT(15),
-	MV_V2_PORT_CTRL_PWRDOWN	= BIT(11),
-	MV_V2_PORT_CTRL_MACTYPE_MASK = 0x7,
-	MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH = 0x6,
+	MV_V2_PORT_CTRL_PWRDOWN			= BIT(11),
+	MV_V2_33X0_PORT_CTRL_SWRST		= BIT(15),
+	MV_V2_33X0_PORT_CTRL_MACTYPE_MASK	= 0x7,
+	MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH	= 0x6,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -268,7 +268,7 @@ static int mv3310_power_up(struct phy_device *phydev)
 		return ret;
 
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
-				MV_V2_PORT_CTRL_SWRST);
+				MV_V2_33X0_PORT_CTRL_SWRST);
 }
 
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
@@ -479,8 +479,8 @@ static int mv3310_config_init(struct phy_device *phydev)
 	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
 	if (val < 0)
 		return val;
-	priv->rate_match = ((val & MV_V2_PORT_CTRL_MACTYPE_MASK) ==
-			MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH);
+	priv->rate_match = ((val & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) ==
+			MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH);
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
-- 
2.26.2

