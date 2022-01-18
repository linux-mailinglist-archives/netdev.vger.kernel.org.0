Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB04919B7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345139AbiARCzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:55:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343548AbiARCmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:42:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6238AB81239;
        Tue, 18 Jan 2022 02:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AF8C36AF3;
        Tue, 18 Jan 2022 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473758;
        bh=RyW+SmIx7B5XRnPeWB2gA4lLDKVVpIflvrlvyxK0gro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHbp1wbLLWEexSBSEdBdW0NMGQprnGWRUEeGGKAkB8XqhLVJNdYI+SrQhn4luPXMk
         UpAzGgCJwGko0koNYO/YOtJAPuoPOsjHtbawxnUt33bba892VCY+4cPnIBCjlc+Pwq
         w4jYqEHqhYLgBNzhVfj+ryv4Bu/Y2i1ITc1CtgW9cC/Brq3BYelp6/KGpPDZZMfYRY
         eQAJ5J5d1DJXob8/GtjHLSylf5CjiNVMFe+7ODTqDg81F1C2yxUAIr2Wf2cgRApO9u
         W/bHh146iGNMO00BqS0/ltbKJGHsjd540700Gwh/wjdp5hKXtdEBbtjSE1ZXVYk4z5
         gT00gGQyv6M8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 056/116] net: phy: prefer 1000baseT over 1000baseKX
Date:   Mon, 17 Jan 2022 21:39:07 -0500
Message-Id: <20220118024007.1950576-56-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 8d333d3084ed3..cccb83dae673b 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -161,11 +161,11 @@ static const struct phy_setting settings[] = {
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

