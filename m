Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD3C4919D8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347448AbiARC4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54490 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348619AbiARCpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:45:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D07B81229;
        Tue, 18 Jan 2022 02:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DEEC36AEB;
        Tue, 18 Jan 2022 02:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473940;
        bh=mxveFy3Bh+mlcsGsrjMwm9G9Ov+4seEvatEqcW+Uc3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP9v8tB5Tby1U9STzyPJXjVf/VCyxGHPjqnhzxoVin7VnUR+4U2wD9yhzoWk2+Inu
         IGog/3RBz14WP62qBhpl0lDQQGVFscTvytYSzeuDC6E14NGetvYR4RHUpZ0yhLRIaE
         b6qzaA1IJQNx6kJC+mZHJaDJ3N2LuDAYTXSKUPvAOrOP5oJmx/3Lk1Wj6hc86Vg/q8
         //qCn8XqMV4xqLTgqoIr6aoNHPSLc6RAoG7TNYU1Y88xf2LEUR3QXbovU6tIvkbW24
         LdCNyoBlQpxSiecCVHYxPHBVhv2ExQ1yLnZl2+3cICR/6FF7jBxIoaG+2JFILuGy+C
         SCSvclM+pZp1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 31/73] net: phy: prefer 1000baseT over 1000baseKX
Date:   Mon, 17 Jan 2022 21:43:50 -0500
Message-Id: <20220118024432.1952028-31-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit f20f94f7f52c4685c81754f489ffcc72186e8bdb ]

The PHY settings table is supposed to be sorted by descending match
priority - in other words, earlier entries are preferred over later
entries.

The order of 1000baseKX/Full and 1000baseT/Full is such that we
prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
a lot rarer than 1000baseT/Full, and thus is much less likely to
be preferred.

This causes phylink problems - it means a fixed link specifying a
speed of 1G and full duplex gets an ethtool linkmode of 1000baseKX/Full
rather than 1000baseT/Full as would be expected - and since we offer
userspace a software emulation of a conventional copper PHY, we want
to offer copper modes in preference to anything else. However, we do
still want to allow the rarer modes as well.

Hence, let's reorder these two modes to prefer copper.

Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 9412669b579c7..84064120918f0 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -128,11 +128,11 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING(   2500, FULL,   2500baseT_Full		),
 	PHY_SETTING(   2500, FULL,   2500baseX_Full		),
 	/* 1G */
-	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
 	PHY_SETTING(   1000, FULL,   1000baseT_Full		),
 	PHY_SETTING(   1000, HALF,   1000baseT_Half		),
 	PHY_SETTING(   1000, FULL,   1000baseT1_Full		),
 	PHY_SETTING(   1000, FULL,   1000baseX_Full		),
+	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
 	/* 100M */
 	PHY_SETTING(    100, FULL,    100baseT_Full		),
 	PHY_SETTING(    100, FULL,    100baseT1_Full		),
-- 
2.34.1

