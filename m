Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB86C2F07A5
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 15:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbhAJOzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 09:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbhAJOzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 09:55:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB4AC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 06:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=whj2ro5CbFaRmtjcxfl9Ho0u42ZMTvq3iXR6V7tt1SQ=; b=zlySZSZpJPF32P50uwkXtHm/1B
        j8vthgVK4FIGwYC3YJXYUAY1t7IRJ6zvdI86dE3in7FypiQ+DR4LZN5jfm1wi1es1NWlp+WjMvpZV
        rb6x8klcT8YJpYe2XfnO+OIjnWIUZ7PU3HTwFAzS9g01huuO0wcRxNwO68qTHf6oDX9uU/Z7J/bKj
        NkKoqCUcfxL0bnMN9ozrzRBfZQXNHAmqYSj2R2OL5r2Xf3xgUZPvl0wTd4TJHMae1zXWEOorcs4GS
        6b/aj/+0vaAe2CttAEbuzYTvUgahD1hQt8A1JBaaFUCCNAFz5R1W5khorzYGz0lU+7qVJd2MjHMAK
        YU84PklQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54362 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyc72-0005tU-7e; Sun, 10 Jan 2021 14:54:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyc72-0008Pq-1x; Sun, 10 Jan 2021 14:54:36 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phy: at803x: use phy_modify_mmd()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kyc72-0008Pq-1x@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 10 Jan 2021 14:54:36 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert at803x_clk_out_config() to use phy_modify_mmd().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/at803x.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index d0b36fd6c265..9636edb8d618 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -529,19 +529,12 @@ static void at803x_remove(struct phy_device *phydev)
 static int at803x_clk_out_config(struct phy_device *phydev)
 {
 	struct at803x_priv *priv = phydev->priv;
-	int val;
 
 	if (!priv->clk_25m_mask)
 		return 0;
 
-	val = phy_read_mmd(phydev, MDIO_MMD_AN, AT803X_MMD7_CLK25M);
-	if (val < 0)
-		return val;
-
-	val &= ~priv->clk_25m_mask;
-	val |= priv->clk_25m_reg;
-
-	return phy_write_mmd(phydev, MDIO_MMD_AN, AT803X_MMD7_CLK25M, val);
+	return phy_modify_mmd(phydev, MDIO_MMD_AN, AT803X_MMD7_CLK25M,
+			      priv->clk_25m_mask, priv->clk_25m_reg);
 }
 
 static int at8031_pll_config(struct phy_device *phydev)
-- 
2.20.1

