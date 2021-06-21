Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C184E3AF38D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhFUSCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhFUSAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C2B460698;
        Mon, 21 Jun 2021 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298065;
        bh=eFC8b5XC/EPZQcbaZi9DnD2eoiADfWr+e4VZWow7xhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrQwQGjsGJZ4hEqRblIZbTkjPh2iO6vtJyGTpsWaPuHt1u+2E2QCtxsrS8mRQtq/r
         WZ/RmA4PIWjHp+NF2a+N6msAleS72slLPewv7PrvpVI87Ypil8nyBYp2UCnsKCoi8E
         rjpPnjZ71IJGK3R7EJx0GEbbo16b0wgASeQAvbflTaO3LGmqmknszcIJWfzzE4UZ2e
         cCxxWbtcgf9pA8FJJr1qkF1BFuXpdy/US8USrOYLUYaeLoZKCYXsHuO7dxMHX/0KRz
         T39sd7bicKqpjS/VOT2q4YGPE4WUMA1cLQDiSR8xe357gEBFfepGHSYn+NDS8t5It7
         TgFK0VvseZ7cQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/26] net: phy: dp83867: perform soft reset and retain established link
Date:   Mon, 21 Jun 2021 13:53:47 -0400
Message-Id: <20210621175400.735800-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
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
index 31a559513362..87c0cdbf262a 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -468,16 +468,12 @@ static int dp83867_phy_reset(struct phy_device *phydev)
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

