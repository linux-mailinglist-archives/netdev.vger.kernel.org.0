Return-Path: <netdev+bounces-5456-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86466711502
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44CA51C20F86
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4759523D78;
	Thu, 25 May 2023 18:42:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2061E23D44
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4A6C433A1;
	Thu, 25 May 2023 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685040155;
	bh=GWWCsIKjGbJCqa6PV3qLYfiKPWV1AECmUz6kv+1Yd8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRO5/UXA+V7BdBi8PuwXSD1zxXMzylxNYnmPmpkNUntNvRJclIlOujvh9T/8wM9zU
	 x79CiWFD7MW0e9NtuS9rJgD9OTSG0Fs7rMf0a2/G35aB4/Y53RL1s/Jp6CqSDBtjPN
	 zyyQ9j+f70drusD37NzD6mMgP2mINNYedS8XDpgS47EWaE+lHYwOfEVpKvfMO7Bvh+
	 Q1LfmbI9zasCN0JiIkIdTSclOHTUXCVkbVPNwCso6QGwfLbeP50Iex8IwgdZV4aFxI
	 bDufPv82X6R/VHy6vkn2UuvNk9kUtadfcpycOcY7a6f0SdPnpwfXxT2OV9wTdyW99u
	 tjJi2JYPAdvKQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 31/31] mdio_bus: unhide mdio_bus_init prototype
Date: Thu, 25 May 2023 14:41:02 -0400
Message-Id: <20230525184105.1909399-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184105.1909399-1-sashal@kernel.org>
References: <20230525184105.1909399-1-sashal@kernel.org>
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
index 08725a262f320..273a9409c77d6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1604,10 +1604,8 @@ void phy_package_leave(struct phy_device *phydev);
 int devm_phy_package_join(struct device *dev, struct phy_device *phydev,
 			  int addr, size_t priv_size);
 
-#if IS_ENABLED(CONFIG_PHYLIB)
 int __init mdio_bus_init(void);
 void mdio_bus_exit(void);
-#endif
 
 int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
 int phy_ethtool_get_sset_count(struct phy_device *phydev);
-- 
2.39.2


