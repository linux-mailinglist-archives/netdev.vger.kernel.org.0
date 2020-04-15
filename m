Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298301AA11D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897527AbgDOLng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406012AbgDOLnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70F1D21556;
        Wed, 15 Apr 2020 11:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951012;
        bh=AGjX8jH2jQ+NeiGiHoUkxLgcU6FjIhrUWfrpcpKJaY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmPkCklgPMyX2wvWuDd/s2yUfZjkIkZTYxqg8cP3l5A1mwVK3+LxjUI9AqvJautL3
         DIhGl/Xt1/UyUfSB4rG20D8CAcKr+D28ZXU6bBJUpLGuO9lPCF1zxqSObUt6O8OHp8
         Yi6tGaOljtyPxPdIam9vFqdBfcSHDWu6TTfQjVNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 055/106] net: phy: at803x: fix clock sink configuration on ATH8030 and ATH8035
Date:   Wed, 15 Apr 2020 07:41:35 -0400
Message-Id: <20200415114226.13103-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit b1f4c209d84057b6d40b939b6e4404854271d797 ]

The masks in priv->clk_25m_reg and priv->clk_25m_mask are one-bits-set
for the values that comprise the fields, not zero-bits-set.

This patch fixes the clock frequency configuration for ATH8030 and
ATH8035 Atheros PHYs by removing the erroneous "~".

To reproduce this bug, configure the PHY  with the device tree binding
"qca,clk-out-frequency" and remove the machine specific PHY fixups.

Fixes: 2f664823a47021 ("net: phy: at803x: add device tree binding")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Tested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 481cf48c9b9e4..31f731e6df720 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -425,8 +425,8 @@ static int at803x_parse_dt(struct phy_device *phydev)
 		 */
 		if (at803x_match_phy_id(phydev, ATH8030_PHY_ID) ||
 		    at803x_match_phy_id(phydev, ATH8035_PHY_ID)) {
-			priv->clk_25m_reg &= ~AT8035_CLK_OUT_MASK;
-			priv->clk_25m_mask &= ~AT8035_CLK_OUT_MASK;
+			priv->clk_25m_reg &= AT8035_CLK_OUT_MASK;
+			priv->clk_25m_mask &= AT8035_CLK_OUT_MASK;
 		}
 	}
 
-- 
2.20.1

