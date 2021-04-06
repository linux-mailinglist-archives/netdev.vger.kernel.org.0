Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0AB355E93
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243611AbhDFWMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242471AbhDFWMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66AC0613D5;
        Tue,  6 Apr 2021 22:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747111;
        bh=nX4eoEhxrg3W0ZsogIGxXVicdpbr0rV/OQUgZvgLmAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rcca1MOhDfY3XrP7WOcpEDEm1ZQxL8Qs50sG2H4y3MpuyIDz7qeEkrdSn7hEEJogq
         bKKsfo9PAsMjojcY1Q8KE/eurmXdRSCFxyJiODUz2Wpf4HjFG7XtNYGNy50aFr58q4
         CuekGt5v4+0GwcPKy3fE2epvYMtuu2BcHTqqyPiyMNhvs5VH3TfCHsJQYeBoeDtIPh
         Lu9aJ7+ehIGZYjKi2NHtowoNwsz+We80x79TlbGJXd3ZbFnvVtEryCdYU4v5cBJ4I1
         rJTgsFCq0sUlVfeujFvoc7NqAhTqtRECAhTxoOg/++r8123b4kL8v3emexdak1dLrs
         z7cPGxqwNX7Qw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 04/18] net: phy: marvell10g: indicate 88X33x0 only port control registers
Date:   Wed,  7 Apr 2021 00:10:53 +0200
Message-Id: <20210406221107.1004-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename port control registers to indicate that they are valid only for
88X33x0, not for 88E21x0.

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

