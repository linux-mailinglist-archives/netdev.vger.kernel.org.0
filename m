Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D863D11D6
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbhGUOXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239497AbhGUOVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63F616120E;
        Wed, 21 Jul 2021 15:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626879706;
        bh=GM/YKf0TTowOMKZHs3ZnhJSjFzIIGc4teYwggsZx9lc=;
        h=From:To:Cc:Subject:Date:From;
        b=Lq0mnd0IoQnmGV2JZnegOxfb8QAUNrwT0agSZfZow+n1t+PE/Hu0lr80u/KA1ftnx
         Co+Sq7CgU1s2sbjVIpwDBsRS9fxERAWkJYeIR1U/AwCQ307+94z2yG88a4YQvKFA6G
         gaYrqnCqy9upHb+BrJQH6n8dMeEWj/b6hkN7k3yB4lzj2GnqvgsgjcWTl/j9xcOx1z
         48dxLyHJGhREwTBM9fxRkr9j22c3fHZsN98dDRYIM2Rm+LuDjoJYH6mFByngdn+xFh
         Q8GkJTKS3I9Oh/E7xBKiI9K4xMn3r9LtS/jVhPlakj1j258oCei9v4vkQS+PnwAC1b
         Y3OhnDnaRQ86w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Bauer <mail@david-bauer.net>,
        Michael Walle <michael@walle.cc>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: at803x: fix at803x_match_phy_id mismatch
Date:   Wed, 21 Jul 2021 17:01:28 +0200
Message-Id: <20210721150141.1737124-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are two conflicting patches in net-next, one removed
the at803x_get_features() function and the other added another
user:

drivers/net/phy/at803x.c: In function 'at803x_get_features':
drivers/net/phy/at803x.c:706:14: error: implicit declaration of function 'at803x_match_phy_id' [-Werror=implicit-function-declaration]

Change the new caller over to an open-coded comparison as well.

Fixes: 8887ca5474bd ("net: phy: at803x: simplify custom phy id matching")
Fixes: b856150c8098 ("net: phy: at803x: mask 1000 Base-X link mode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/phy/at803x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 0790ffcd3db6..bdac087058b2 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -703,7 +703,7 @@ static int at803x_get_features(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!at803x_match_phy_id(phydev, ATH8031_PHY_ID))
+	if (phydev->drv->phy_id != ATH8031_PHY_ID)
 		return 0;
 
 	/* AR8031/AR8033 have different status registers
-- 
2.29.2

