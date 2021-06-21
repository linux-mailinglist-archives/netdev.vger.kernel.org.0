Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7943AF291
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhFURzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhFURys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B3D61026;
        Mon, 21 Jun 2021 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297952;
        bh=v/nOJmQQ08mnD/U/0+K6FWc6VBo1nCPFpakS1BX+18o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aM3/A5EkRd+Px39/EIxXBKt1B1s4XFL273frVlxRmhulqmfovytoeUbqhDMLvTysA
         vLUeLNY1zkO1bjtErTrTb+vKsNOhO4U7pQ6jGbUHS0PEG+xN1ujiFaKIY8llkNK3sZ
         GDw5XAGWHRCyPfVg+JeoEAECH8ZlmVcs8y3sAzo2GyHpUqDWm9HSZvd50b69/2D/WC
         zXff+ApW2vO6045aCYNfjr/miCnkG0BeEZYicLndZgLBYXZF7/qyXOWkgbJta4jKZ5
         BV4+XFw1rOhnX3JEogyeZOMe5GI/eC3udaz5shtFNAKMm7YPEtUcfZW2xy625RZ/X8
         SKqW/qZJhzwbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 21/39] net: phy: dp83867: perform soft reset and retain established link
Date:   Mon, 21 Jun 2021 13:51:37 -0400
Message-Id: <20210621175156.735062-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Praneeth Bajjuri <praneeth@ti.com>

[ Upstream commit da9ef50f545f86ffe6ff786174d26500c4db737a ]

Current logic is performing hard reset and causing the programmed
registers to be wiped out.

as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
8.6.26 Control Register (CTRL)

do SW_RESTART to perform a reset not including the registers,
If performed when link is already present,
it will drop the link and trigger re-auto negotiation.

Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
Signed-off-by: Geet Modi <geet.modi@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 9bd9a5c0b1db..6bbc81ad295f 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -826,16 +826,12 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 {
 	int err;
 
-	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESET);
+	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
 	if (err < 0)
 		return err;
 
 	usleep_range(10, 20);
 
-	/* After reset FORCE_LINK_GOOD bit is set. Although the
-	 * default value should be unset. Disable FORCE_LINK_GOOD
-	 * for the phy to work properly.
-	 */
 	return phy_modify(phydev, MII_DP83867_PHYCTRL,
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
-- 
2.30.2

