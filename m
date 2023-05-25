Return-Path: <netdev+bounces-5464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C8A711515
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33CF81C20F61
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEC42412A;
	Thu, 25 May 2023 18:45:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD9A24122
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A6CC4339C;
	Thu, 25 May 2023 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685040315;
	bh=CKkzf9WnSHSuDY0Ls9IPQG/AS+xqgVyUO5PWSL2wPI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQ4tkrkIcFXktI6J6PerG0qwEU1H+BuE/N6IozSn6BkbkfoDwpbe7eUhL9MKJGV87
	 JsCebhD4nErotcQBQ2XjvAxEvuyisZRNn9SFPKsT80CXXS5mBN7z10tK7kHKFJb7UH
	 ZZY7PniWQghHq67aB/UajZtqRr9DWghH9N3kzNUe2c0YJpUKX2z7sHbl7Cu1H9C4s1
	 9v0EMAk40oHd9E0DV0JsQWXlRq//qKbYtGKS3lM99BynVTUyrlugxtlEDEGl275aZQ
	 mTqEg80DjcG+NlJlkp3R2C9S7/OU8WhpOHGIzU2109rLrRrcjIfnCLYkUKUy19qloB
	 k2DV/i2aBM1PA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/27] mdio_bus: unhide mdio_bus_init prototype
Date: Thu, 25 May 2023 14:43:53 -0400
Message-Id: <20230525184356.1974216-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184356.1974216-1-sashal@kernel.org>
References: <20230525184356.1974216-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2e9f8ab68f42b059e80db71266c1675c07c664bd ]

mdio_bus_init() is either used as a local module_init() entry,
or it gets called in phy_device.c. In the former case, there
is no declaration, which causes a warning:

drivers/net/phy/mdio_bus.c:1371:12: error: no previous prototype for 'mdio_bus_init' [-Werror=missing-prototypes]

Remove the #ifdef around the declaration to avoid the warning..

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230516194625.549249-4-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 86a3792c568c2..dbaca6a6a32b8 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1080,10 +1080,8 @@ int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 				   const struct ethtool_link_ksettings *cmd);
 int phy_ethtool_nway_reset(struct net_device *ndev);
 
-#if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
 void mdio_bus_exit(void);
-#endif
 
 /* Inline function for use within net/core/ethtool.c (built-in) */
 static inline int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data)
-- 
2.39.2


